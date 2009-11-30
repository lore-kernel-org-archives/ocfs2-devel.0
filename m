From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 30 Nov 2009 15:08:40 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: refcounttree.c cleanup.
Message-ID: <1259564920-9833-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

sparse check finds some endian problem and some other minor issues.
There is an obsolete function which should be removed.
So this patch resolve all these.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/refcounttree.c |   33 ++++++++-------------------------
 1 files changed, 8 insertions(+), 25 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 3a0df7a..4af793e 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -276,7 +276,7 @@ static void ocfs2_erase_refcount_tree_from_list(struct ocfs2_super *osb,
 	spin_unlock(&osb->osb_lock);
 }
 
-void ocfs2_kref_remove_refcount_tree(struct kref *kref)
+static void ocfs2_kref_remove_refcount_tree(struct kref *kref)
 {
 	struct ocfs2_refcount_tree *tree =
 		container_of(kref, struct ocfs2_refcount_tree, rf_getcnt);
@@ -524,23 +524,6 @@ out:
 	return ret;
 }
 
-int ocfs2_lock_refcount_tree_by_inode(struct inode *inode, int rw,
-				      struct ocfs2_refcount_tree **ret_tree,
-				      struct buffer_head **ref_bh)
-{
-	int ret;
-	u64 ref_blkno;
-
-	ret = ocfs2_get_refcount_block(inode, &ref_blkno);
-	if (ret) {
-		mlog_errno(ret);
-		return ret;
-	}
-
-	return ocfs2_lock_refcount_tree(OCFS2_SB(inode->i_sb), ref_blkno,
-					rw, ret_tree, ref_bh);
-}
-
 void ocfs2_unlock_refcount_tree(struct ocfs2_super *osb,
 				struct ocfs2_refcount_tree *tree, int rw)
 {
@@ -1418,7 +1401,7 @@ static int ocfs2_divide_leaf_refcount_block(struct buffer_head *ref_leaf_bh,
 
 	/* change old and new rl_used accordingly. */
 	le16_add_cpu(&rl->rl_used, -num_moved);
-	new_rl->rl_used = cpu_to_le32(num_moved);
+	new_rl->rl_used = cpu_to_le16(num_moved);
 
 	sort(&rl->rl_recs, le16_to_cpu(rl->rl_used),
 	     sizeof(struct ocfs2_refcount_rec),
@@ -1797,7 +1780,8 @@ static int ocfs2_split_refcount_rec(handle_t *handle,
 		recs_need++;
 
 	/* If the leaf block don't have enough record, expand it. */
-	if (le16_to_cpu(rf_list->rl_used) + recs_need > rf_list->rl_count) {
+	if (le16_to_cpu(rf_list->rl_used) + recs_need >
+					 le16_to_cpu(rf_list->rl_count)) {
 		struct ocfs2_refcount_rec tmp_rec;
 		u64 cpos = le64_to_cpu(orig_rec->r_cpos);
 		len = le32_to_cpu(orig_rec->r_clusters);
@@ -1859,7 +1843,7 @@ static int ocfs2_split_refcount_rec(handle_t *handle,
 		memcpy(tail_rec, orig_rec, sizeof(struct ocfs2_refcount_rec));
 		le64_add_cpu(&tail_rec->r_cpos,
 			     le32_to_cpu(tail_rec->r_clusters) - len);
-		tail_rec->r_clusters = le32_to_cpu(len);
+		tail_rec->r_clusters = cpu_to_le32(len);
 	}
 
 	/*
@@ -3840,8 +3824,7 @@ static int ocfs2_add_refcounted_extent(struct inode *inode,
 	}
 
 	ret = ocfs2_insert_extent(handle, et, cpos,
-			cpu_to_le64(ocfs2_clusters_to_blocks(inode->i_sb,
-							     p_cluster)),
+			ocfs2_clusters_to_blocks(inode->i_sb, p_cluster),
 			num_clusters, ext_flags, meta_ac);
 	if (ret) {
 		mlog_errno(ret);
@@ -4253,8 +4236,8 @@ static int ocfs2_user_path_parent(const char __user *path,
  * @new_dentry:        target dentry
  * @preserve:  if true, preserve all file attributes
  */
-int ocfs2_vfs_reflink(struct dentry *old_dentry, struct inode *dir,
-		      struct dentry *new_dentry, bool preserve)
+static int ocfs2_vfs_reflink(struct dentry *old_dentry, struct inode *dir,
+			     struct dentry *new_dentry, bool preserve)
 {
 	struct inode *inode = old_dentry->d_inode;
 	int error;
-- 
1.5.5
