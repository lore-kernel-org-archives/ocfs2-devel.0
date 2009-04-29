From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 30 Apr 2009 06:58:28 +0800
Subject: [Ocfs2-devel] [PATCH 16/39] ocfs2: Add __ocfs2_reflink.
In-Reply-To: <49F95A79.6040806@oracle.com>
References: <49F95A79.6040806@oracle.com>
Message-ID: <1241045931-24607-16-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ioctl will call __ocfs2_reflink. And it will:
1. Create a new refcount tree to the old file if it doesn't have one
   and insert all the extent records to the tree if they are not
   refcounted.
2. Insert all the extent records to the new inode's extent list.
3. Increase the r_count for all the items in the refcount tree.

Note:
This patch use ocfs2_mknod to create a new file under the destination
directory, it isn't safe. Some following patches will try to create
the file first in orphan dir, reflink the extent list and then move
the created file to the destination directory.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/namei.c        |    6 +-
 fs/ocfs2/namei.h        |    2 +
 fs/ocfs2/refcounttree.c |  379 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 383 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 31fc13e..e38b9dc 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -217,10 +217,8 @@ static struct inode *ocfs2_get_init_inode(struct inode *dir, int mode)
 	return inode;
 }
 
-static int ocfs2_mknod(struct inode *dir,
-		       struct dentry *dentry,
-		       int mode,
-		       dev_t dev)
+int ocfs2_mknod(struct inode *dir, struct dentry *dentry,
+		int mode, dev_t dev)
 {
 	int status = 0;
 	struct buffer_head *parent_fe_bh = NULL;
diff --git a/fs/ocfs2/namei.h b/fs/ocfs2/namei.h
index 688aef6..7f9cc46 100644
--- a/fs/ocfs2/namei.h
+++ b/fs/ocfs2/namei.h
@@ -35,5 +35,7 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,
 		     struct inode *orphan_dir_inode,
 		     struct inode *inode,
 		     struct buffer_head *orphan_dir_bh);
+int ocfs2_mknod(struct inode *dir, struct dentry *dentry,
+		int mode, dev_t dev);
 
 #endif /* OCFS2_NAMEI_H */
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 85f09bf..2edb5d1 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -32,6 +32,7 @@
 #include "dlmglue.h"
 #include "extent_map.h"
 #include "aops.h"
+#include "namei.h"
 
 struct ocfs2_cow_context {
 	struct inode *inode;
@@ -2476,3 +2477,381 @@ out:
 	brelse(ref_root_bh);
 	return ret;
 }
+
+/*
+ * Insert a new extent into refcount tree and mark a extent rec
+ * as refcounted in the dinode tree.
+ */
+static int ocfs2_add_refcount_flag(struct inode *inode,
+				   struct ocfs2_extent_tree *di_et,
+				   struct ocfs2_caching_info *ref_ci,
+				   struct buffer_head *ref_root_bh,
+				   u32 cpos, u32 p_cluster, u32 num_clusters,
+				   struct ocfs2_cached_dealloc_ctxt *dealloc)
+{
+	int ret;
+	handle_t *handle;
+	int credits = 1, ref_blocks = 0;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_alloc_context *meta_ac = NULL;
+
+	ret = ocfs2_calc_refcount_meta_credits(inode->i_sb,
+					       ref_ci, ref_root_bh,
+					       p_cluster, num_clusters,
+					       &ref_blocks, &credits);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	mlog(0, "reserve new metadata %d, credits = %d\n",
+	     ref_blocks, credits);
+
+	if (ref_blocks) {
+		ret = ocfs2_reserve_new_metadata_blocks(OCFS2_SB(inode->i_sb),
+							ref_blocks, &meta_ac);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
+
+	handle = ocfs2_start_trans(osb, credits);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_mark_extent_refcounted(inode, di_et, handle,
+					   cpos, num_clusters, p_cluster,
+					   meta_ac, dealloc);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	ret = __ocfs2_increase_refcount(handle, ref_ci, ref_root_bh,
+					p_cluster, num_clusters,
+					meta_ac, dealloc);
+	if (ret)
+		mlog_errno(ret);
+
+out_commit:
+	ocfs2_commit_trans(osb, handle);
+out:
+	if (meta_ac)
+		ocfs2_free_alloc_context(meta_ac);
+	return ret;
+}
+
+static int ocfs2_attach_refcount_tree(struct inode *inode,
+				      struct buffer_head *fe_bh)
+{
+	int ret;
+	struct buffer_head *ref_root_bh = NULL;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)fe_bh->b_data;
+	unsigned int ext_flags;
+	loff_t size;
+	u32 cpos, num_clusters, clusters, p_cluster;
+	struct ocfs2_cached_dealloc_ctxt dealloc;
+	struct ocfs2_extent_tree di_et;
+
+	ocfs2_init_dealloc_ctxt(&dealloc);
+
+	if (!(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL)) {
+		ret = ocfs2_create_refcount_tree(inode, fe_bh);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
+
+	BUG_ON(!di->i_refcount_loc);
+	ret = ocfs2_read_refcount_block(INODE_CACHE(inode),
+					le64_to_cpu(di->i_refcount_loc),
+					&ref_root_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ocfs2_init_dinode_extent_tree(&di_et, INODE_CACHE(inode), fe_bh);
+
+	size = i_size_read(inode);
+	clusters = ocfs2_clusters_for_bytes(inode->i_sb, size);
+
+	cpos = 0;
+	while (cpos < clusters) {
+		ret = ocfs2_get_clusters(inode, cpos, &p_cluster,
+					 &num_clusters, &ext_flags);
+
+		cpos += num_clusters;
+		if ((ext_flags & OCFS2_EXT_REFCOUNTED) || !p_cluster)
+			continue;
+
+		ret = ocfs2_add_refcount_flag(inode, &di_et,
+					      INODE_CACHE(inode), ref_root_bh,
+					      cpos - num_clusters,
+					      p_cluster, num_clusters,
+					      &dealloc);
+		if (ret) {
+			mlog_errno(ret);
+			break;
+		}
+	}
+
+	/*
+	 * Empty the extent map so that we may get the right extent
+	 * record from the disk.
+	 */
+	ocfs2_extent_map_trunc(inode, 0);
+	brelse(ref_root_bh);
+out:
+
+	if (!ret && ocfs2_dealloc_has_cluster(&dealloc)) {
+		ocfs2_schedule_truncate_log_flush(OCFS2_SB(inode->i_sb), 1);
+		ocfs2_run_deallocs(OCFS2_SB(inode->i_sb), &dealloc);
+	}
+	return ret;
+}
+
+static int ocfs2_add_refcounted_extent(struct inode *inode,
+				   struct ocfs2_extent_tree *et,
+				   struct ocfs2_caching_info *ref_ci,
+				   struct buffer_head *ref_root_bh,
+				   u32 cpos, u32 p_cluster, u32 num_clusters,
+				   unsigned int ext_flags,
+				   struct ocfs2_cached_dealloc_ctxt *dealloc)
+{
+	int ret;
+	handle_t *handle;
+	int credits = 0;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_alloc_context *meta_ac = NULL;
+
+	ret = ocfs2_lock_refcount_allocators(inode->i_sb,
+					     p_cluster, num_clusters,
+					     et, ref_ci,
+					     ref_root_bh, &meta_ac,
+					     NULL, &credits);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	handle = ocfs2_start_trans(osb, credits);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_insert_extent(handle, et, cpos,
+			cpu_to_le64(ocfs2_clusters_to_blocks(inode->i_sb,
+							     p_cluster)),
+			num_clusters, ext_flags, meta_ac);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	ret = __ocfs2_increase_refcount(handle, ref_ci, ref_root_bh,
+					p_cluster, num_clusters,
+					meta_ac, dealloc);
+	if (ret)
+		mlog_errno(ret);
+
+out_commit:
+	ocfs2_commit_trans(osb, handle);
+out:
+	if (meta_ac)
+		ocfs2_free_alloc_context(meta_ac);
+	return ret;
+}
+
+static int ocfs2_duplicate_extent_list(struct inode *s_inode,
+				struct inode *t_inode,
+				struct buffer_head *t_bh,
+				struct buffer_head *ref_root_bh,
+				struct ocfs2_cached_dealloc_ctxt *dealloc)
+{
+	int ret = 0;
+	u32 p_cluster, num_clusters, clusters, cpos;
+	loff_t size;
+	unsigned int ext_flags;
+	struct ocfs2_extent_tree et;
+
+	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(t_inode), t_bh);
+
+	size = i_size_read(s_inode);
+	clusters = ocfs2_clusters_for_bytes(s_inode->i_sb, size);
+
+	cpos = 0;
+	while (cpos < clusters) {
+		ret = ocfs2_get_clusters(s_inode, cpos, &p_cluster,
+					 &num_clusters, &ext_flags);
+
+		if (p_cluster) {
+			ret = ocfs2_add_refcounted_extent(t_inode, &et,
+							  INODE_CACHE(t_inode),
+							  ref_root_bh,
+							  cpos, p_cluster,
+							  num_clusters,
+							  ext_flags,
+							  dealloc);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
+		}
+
+		cpos += num_clusters;
+	}
+
+out:
+	return ret;
+}
+
+static int ocfs2_complete_reflink(struct inode *s_inode,
+				  struct inode *t_inode,
+				  struct buffer_head *t_bh)
+{
+	int ret;
+	handle_t *handle;
+	struct ocfs2_dinode *fe = (struct ocfs2_dinode *)t_bh->b_data;
+	loff_t size = i_size_read(s_inode);
+
+	handle = ocfs2_start_trans(OCFS2_SB(t_inode->i_sb),
+				   OCFS2_INODE_UPDATE_CREDITS);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		return ret;
+	}
+
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(t_inode), t_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	spin_lock(&OCFS2_I(t_inode)->ip_lock);
+	OCFS2_I(t_inode)->ip_clusters = OCFS2_I(s_inode)->ip_clusters;
+	fe->i_clusters = cpu_to_le32(OCFS2_I(s_inode)->ip_clusters);
+	spin_unlock(&OCFS2_I(t_inode)->ip_lock);
+	i_size_write(t_inode, size);
+	fe->i_size = cpu_to_le64(size);
+
+	ocfs2_journal_dirty(handle, t_bh);
+
+out_commit:
+	ocfs2_commit_trans(OCFS2_SB(t_inode->i_sb), handle);
+	return ret;
+}
+
+static int ocfs2_create_reflink_node(struct inode *s_inode,
+				     struct buffer_head *s_bh,
+				     struct inode *t_inode,
+				     struct buffer_head *t_bh)
+{
+	int ret;
+	struct buffer_head *ref_root_bh = NULL;
+	struct ocfs2_cached_dealloc_ctxt dealloc;
+	struct ocfs2_super *osb = OCFS2_SB(s_inode->i_sb);
+	struct ocfs2_refcount_block *rb;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)s_bh->b_data;
+	struct ocfs2_extent_list *el;
+
+	ocfs2_init_dealloc_ctxt(&dealloc);
+
+	ret = ocfs2_set_refcount_tree(t_inode, t_bh,
+				      le64_to_cpu(di->i_refcount_loc));
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_read_refcount_block(INODE_CACHE(t_inode),
+					le64_to_cpu(di->i_refcount_loc),
+					&ref_root_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+	rb = (struct ocfs2_refcount_block *)ref_root_bh->b_data;
+
+	el = &di->id2.i_list;
+
+	ret = ocfs2_duplicate_extent_list(s_inode, t_inode, t_bh,
+					  ref_root_bh, &dealloc);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_complete_reflink(s_inode, t_inode, t_bh);
+	if (ret)
+		mlog_errno(ret);
+
+out:
+	if (ocfs2_dealloc_has_cluster(&dealloc)) {
+		ocfs2_schedule_truncate_log_flush(osb, 1);
+		ocfs2_run_deallocs(osb, &dealloc);
+	}
+
+	brelse(ref_root_bh);
+
+	return ret;
+}
+
+static int __ocfs2_reflink(struct dentry *old_dentry,
+			   struct buffer_head *old_bh,
+			   struct inode *dir,
+			   struct dentry *dentry)
+{
+	int ret;
+	struct inode *inode = old_dentry->d_inode;
+	struct inode *new_inode;
+	struct buffer_head *new_bh = NULL;
+
+	mlog_entry("(inode=%lu, old='%.*s' new='%.*s')\n", inode->i_ino,
+		   old_dentry->d_name.len, old_dentry->d_name.name,
+		   dentry->d_name.len, dentry->d_name.name);
+
+	ret = ocfs2_mknod(dir, dentry, inode->i_mode, 0);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_attach_refcount_tree(inode, old_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	new_inode = dentry->d_inode;
+
+	mutex_lock(&new_inode->i_mutex);
+	ret = ocfs2_inode_lock(new_inode, &new_bh, 1);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_unlock;
+	}
+
+	ret = ocfs2_create_reflink_node(inode, old_bh, new_inode, new_bh);
+	if (ret)
+		mlog_errno(ret);
+
+	ocfs2_inode_unlock(new_inode, 1);
+	brelse(new_bh);
+out_unlock:
+	mutex_unlock(&new_inode->i_mutex);
+out:
+	mlog_exit(ret);
+
+	return ret;
+}
-- 
1.6.2.rc2.16.gf474c
