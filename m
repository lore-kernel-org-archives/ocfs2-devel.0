From: Tao Ma <tao.ma@oracle.com>
Date: Fri,  3 Apr 2009 07:45:58 +0800
Subject: [Ocfs2-devel] [PATCH 19/42] ocfs2: Add __ocfs2_reflink.
In-Reply-To: <49D5CAC2.4010201@oracle.com>
References: <49D5CAC2.4010201@oracle.com>
Message-ID: <1238715981-21488-19-git-send-email-tao.ma@oracle.com>
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
directory, it isn't safe. The next a few patches will try to create
the first first in orphan dir, reflink and then move it to the
destination directory.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/namei.c        |    6 +-
 fs/ocfs2/namei.h        |    2 +
 fs/ocfs2/refcounttree.c |  382 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 386 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 2615cb9..7a309bd 100644
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
index 1ae016c..7b8ffca 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -31,6 +31,7 @@
 #include "dlmglue.h"
 #include "extent_map.h"
 #include "aops.h"
+#include "namei.h"
 
 struct ocfs2_cow_context {
 	struct inode *inode;
@@ -1492,3 +1493,384 @@ out:
 	brelse(ref_bh);
 	return ret;
 }
+
+/*
+ * Insert a new extent into refcount tree and mark a extent rec
+ * as refcounted in the dinode tree.
+ */
+static int ocfs2_add_refcount_flag(struct inode *inode,
+				   struct ocfs2_extent_tree *di_et,
+				   struct ocfs2_extent_tree *ref_et,
+				   u32 cpos, u32 p_cluster, u32 num_clusters,
+				   struct ocfs2_cached_dealloc_ctxt *dealloc)
+{
+	int ret;
+	handle_t *handle;
+	int credits = 1;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_alloc_context *meta_ac = NULL;
+
+	ret = ocfs2_lock_allocators(inode, ref_et, 0, 1, NULL, &meta_ac);
+	if (ret) {
+		mlog_errno(ret);
+		return ret;
+	}
+
+	credits += ocfs2_calc_extend_credits(inode->i_sb,
+					     ref_et->et_root_el, 0);
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
+	ret = __ocfs2_increase_refcount(handle, ref_et,
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
+	struct buffer_head *ref_bh = NULL;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)fe_bh->b_data;
+	unsigned int ext_flags;
+	loff_t size;
+	u32 cpos, num_clusters, clusters, p_cluster;
+	struct ocfs2_cached_dealloc_ctxt dealloc;
+	struct ocfs2_extent_tree di_et;
+	struct ocfs2_extent_tree ref_et;
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
+					&ref_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ocfs2_init_dinode_extent_tree(&di_et, INODE_CACHE(inode), fe_bh);
+	ocfs2_init_refcount_extent_tree(&ref_et, INODE_CACHE(inode), ref_bh);
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
+		ret = ocfs2_add_refcount_flag(inode, &di_et, &ref_et,
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
+	brelse(ref_bh);
+out:
+
+	if (!ret && ocfs2_dealloc_has_cluster(&dealloc)) {
+		ocfs2_schedule_truncate_log_flush(OCFS2_SB(inode->i_sb), 1);
+		ocfs2_run_deallocs(OCFS2_SB(inode->i_sb), &dealloc);
+	}
+	return ret;
+}
+
+static int ocfs2_duplicate_extent_list(struct inode *s_inode,
+				struct inode *t_inode,
+				handle_t *handle,
+				struct buffer_head *s_bh,
+				struct buffer_head *t_bh,
+				struct ocfs2_alloc_context *meta_ac,
+				struct ocfs2_cached_dealloc_ctxt *dealloc,
+				struct ocfs2_extent_tree *ref_et)
+{
+	int ret = 0;
+	u32 p_cluster, num_clusters, clusters, cpos;
+	loff_t size;
+	unsigned int ext_flags;
+	struct ocfs2_extent_tree et;
+	struct ocfs2_extent_rec rec;
+	struct ocfs2_dinode *fe = (struct ocfs2_dinode *)t_bh->b_data;
+
+	memset(&rec, 0, sizeof(rec));
+	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(t_inode), t_bh);
+
+	size = i_size_read(s_inode);
+	clusters = ocfs2_clusters_for_bytes(s_inode->i_sb, size);
+
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(t_inode), t_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	cpos = 0;
+	while (cpos < clusters) {
+		ret = ocfs2_get_clusters(s_inode, cpos, &p_cluster,
+					 &num_clusters, &ext_flags);
+
+		if (p_cluster) {
+			memset(&rec, 0, sizeof(rec));
+			rec.e_cpos = cpu_to_le32(cpos);
+			rec.e_int_clusters = cpu_to_le32(num_clusters);
+			rec.e_blkno = cpu_to_le64(
+					ocfs2_clusters_to_blocks(s_inode->i_sb,
+								 p_cluster));
+			rec.e_flags = ext_flags;
+
+			ret = ocfs2_insert_extent(handle, &et, &rec, meta_ac);
+			if (ret) {
+				mlog_errno(ret);
+				break;
+			}
+
+			ret = __ocfs2_increase_refcount(handle, ref_et,
+							p_cluster, num_clusters,
+							meta_ac, dealloc);
+			if (ret) {
+				mlog_errno(ret);
+				break;
+			}
+		}
+
+		cpos += num_clusters;
+	}
+
+	spin_lock(&OCFS2_I(t_inode)->ip_lock);
+	OCFS2_I(t_inode)->ip_clusters = OCFS2_I(s_inode)->ip_clusters;
+	spin_unlock(&OCFS2_I(t_inode)->ip_lock);
+	i_size_write(t_inode, size);
+	fe->i_size = cpu_to_le64(size);
+	fe->i_clusters = cpu_to_le32(OCFS2_I(s_inode)->ip_clusters);
+
+	ocfs2_journal_dirty(handle, t_bh);
+out:
+	return ret;
+}
+
+/*
+ * Calculate how much meta and credits we need for relink s_inode.
+ *
+ * We will iterate the s_inode's extent tree and calculate the extent
+ * record number. We will at most need num_recs * 2 for refcount tree
+ * in case each one will cause a split.
+ * the iteration will be very fast since all the extent records have
+ * already been inserted into extent map by ocfs2_attach_refcount_tree.
+ */
+static int ocfs2_calc_refcount_credits(struct inode *s_inode,
+				       struct buffer_head *s_bh,
+				       struct ocfs2_extent_tree *ref_et,
+				       int *meta_add, int *credits)
+{
+	int ret = 0, num_recs = 0;
+	u32 p_cluster, num_clusters, clusters, cpos;
+	loff_t size;
+
+	size = i_size_read(s_inode);
+	clusters = ocfs2_clusters_for_bytes(s_inode->i_sb, size);
+
+	cpos = 0;
+	while (cpos < clusters) {
+		ret = ocfs2_get_clusters(s_inode, cpos, &p_cluster,
+					 &num_clusters, NULL);
+
+		if (p_cluster)
+			num_recs++;
+
+		cpos += num_clusters;
+	}
+
+	num_recs *= 2;
+
+	/* Calculate how many meta we need according to num_recs. */
+	ret = ocfs2_calc_tree_change_need(s_inode->i_sb, ref_et, num_recs,
+					  meta_add, credits);
+	if (ret)
+		mlog_errno(ret);
+
+	return ret;
+}
+
+static int ocfs2_create_reflink_node(struct inode *s_inode,
+				     struct buffer_head *s_bh,
+				     struct inode *t_inode,
+				     struct buffer_head *t_bh)
+{
+	int ret, credits, meta_add;
+	handle_t *handle;
+	struct buffer_head *ref_bh = NULL;
+	struct ocfs2_alloc_context *meta_ac = NULL;
+	struct ocfs2_cached_dealloc_ctxt dealloc;
+	struct ocfs2_super *osb = OCFS2_SB(s_inode->i_sb);
+	struct ocfs2_refcount_block *rb;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)s_bh->b_data;
+	struct ocfs2_extent_list *el;
+	struct ocfs2_extent_tree ref_et;
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
+					&ref_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+	ocfs2_init_refcount_extent_tree(&ref_et, INODE_CACHE(t_inode), ref_bh);
+	rb = (struct ocfs2_refcount_block *)ref_bh->b_data;
+
+	el = &di->id2.i_list;
+
+	meta_add = le16_to_cpu(el->l_next_free_rec) *
+		   le16_to_cpu(el->l_tree_depth);
+
+	credits = ocfs2_calc_create_meta_credits(s_inode->i_sb, meta_add);
+
+	ret = ocfs2_calc_refcount_credits(s_inode, s_bh, &ref_et,
+					  &meta_add, &credits);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	mlog(0, "meta_add = %d, credits = %d\n", meta_add, credits);
+
+	if (meta_add) {
+		ret = ocfs2_reserve_new_metadata_blocks(osb,
+							meta_add, &meta_ac);
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
+		goto out_free_resource;
+	}
+
+	ret = ocfs2_duplicate_extent_list(s_inode, t_inode, handle,
+					  s_bh, t_bh, meta_ac,
+					  &dealloc, &ref_et);
+	if (ret)
+		mlog_errno(ret);
+
+	ocfs2_commit_trans(osb, handle);
+out_free_resource:
+	if (meta_ac)
+		ocfs2_free_alloc_context(meta_ac);
+out:
+	if (ocfs2_dealloc_has_cluster(&dealloc)) {
+		ocfs2_schedule_truncate_log_flush(osb, 1);
+		ocfs2_run_deallocs(osb, &dealloc);
+	}
+
+	brelse(ref_bh);
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
