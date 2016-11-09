From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Wed, 09 Nov 2016 14:51:12 -0800
Subject: [Ocfs2-devel] [PATCH 1/6] ocfs2: convert inode refcount test to a
	helper
In-Reply-To: <147873186646.2820.17513529102740292215.stgit@birch.djwong.org>
References: <147873186646.2820.17513529102740292215.stgit@birch.djwong.org>
Message-ID: <147873187285.2820.9992440620792982440.stgit@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@versity.com, jlbec@evilplan.org, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Replace the open-coded inode refcount flag test with a helper function
to reduce the potential for bugs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ocfs2/refcounttree.c |   28 +++++++++++++++-------------
 fs/ocfs2/refcounttree.h |    2 ++
 2 files changed, 17 insertions(+), 13 deletions(-)


diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 1923851..59be8f4 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -48,6 +48,12 @@
 #include <linux/mount.h>
 #include <linux/posix_acl.h>
 
+/* Does this inode have the reflink flag set? */
+bool ocfs2_is_refcount_inode(struct inode *inode)
+{
+	return (OCFS2_I(inode)->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL);
+}
+
 struct ocfs2_cow_context {
 	struct inode *inode;
 	u32 cow_start;
@@ -410,7 +416,7 @@ static int ocfs2_get_refcount_block(struct inode *inode, u64 *ref_blkno)
 		goto out;
 	}
 
-	BUG_ON(!(OCFS2_I(inode)->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL));
+	BUG_ON(!ocfs2_is_refcount_inode(inode));
 
 	di = (struct ocfs2_dinode *)di_bh->b_data;
 	*ref_blkno = le64_to_cpu(di->i_refcount_loc);
@@ -570,7 +576,7 @@ static int ocfs2_create_refcount_tree(struct inode *inode,
 	u32 num_got;
 	u64 suballoc_loc, first_blkno;
 
-	BUG_ON(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL);
+	BUG_ON(ocfs2_is_refcount_inode(inode));
 
 	trace_ocfs2_create_refcount_tree(
 		(unsigned long long)OCFS2_I(inode)->ip_blkno);
@@ -708,7 +714,7 @@ static int ocfs2_set_refcount_tree(struct inode *inode,
 	struct ocfs2_refcount_block *rb;
 	struct ocfs2_refcount_tree *ref_tree;
 
-	BUG_ON(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL);
+	BUG_ON(ocfs2_is_refcount_inode(inode));
 
 	ret = ocfs2_lock_refcount_tree(osb, refcount_loc, 1,
 				       &ref_tree, &ref_root_bh);
@@ -775,7 +781,7 @@ int ocfs2_remove_refcount_tree(struct inode *inode, struct buffer_head *di_bh)
 	u64 blk = 0, bg_blkno = 0, ref_blkno = le64_to_cpu(di->i_refcount_loc);
 	u16 bit = 0;
 
-	if (!(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL))
+	if (!ocfs2_is_refcount_inode(inode))
 		return 0;
 
 	BUG_ON(!ref_blkno);
@@ -2299,11 +2305,10 @@ int ocfs2_decrease_refcount(struct inode *inode,
 {
 	int ret;
 	u64 ref_blkno;
-	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct buffer_head *ref_root_bh = NULL;
 	struct ocfs2_refcount_tree *tree;
 
-	BUG_ON(!(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL));
+	BUG_ON(!ocfs2_is_refcount_inode(inode));
 
 	ret = ocfs2_get_refcount_block(inode, &ref_blkno);
 	if (ret) {
@@ -2533,7 +2538,6 @@ int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
 					  int *ref_blocks)
 {
 	int ret;
-	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct buffer_head *ref_root_bh = NULL;
 	struct ocfs2_refcount_tree *tree;
 	u64 start_cpos = ocfs2_blocks_to_clusters(inode->i_sb, phys_blkno);
@@ -2544,7 +2548,7 @@ int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
 		goto out;
 	}
 
-	BUG_ON(!(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL));
+	BUG_ON(!ocfs2_is_refcount_inode(inode));
 
 	ret = ocfs2_get_refcount_tree(OCFS2_SB(inode->i_sb),
 				      refcount_loc, &tree);
@@ -3412,14 +3416,13 @@ static int ocfs2_refcount_cow_hunk(struct inode *inode,
 {
 	int ret;
 	u32 cow_start = 0, cow_len = 0;
-	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 	struct buffer_head *ref_root_bh = NULL;
 	struct ocfs2_refcount_tree *ref_tree;
 	struct ocfs2_cow_context *context = NULL;
 
-	BUG_ON(!(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL));
+	BUG_ON(!ocfs2_is_refcount_inode(inode));
 
 	ret = ocfs2_refcount_cal_cow_clusters(inode, &di->id2.i_list,
 					      cpos, write_len, max_cpos,
@@ -3629,11 +3632,10 @@ int ocfs2_refcount_cow_xattr(struct inode *inode,
 {
 	int ret;
 	struct ocfs2_xattr_value_root *xv = vb->vb_xv;
-	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_cow_context *context = NULL;
 	u32 cow_start, cow_len;
 
-	BUG_ON(!(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL));
+	BUG_ON(!ocfs2_is_refcount_inode(inode));
 
 	ret = ocfs2_refcount_cal_cow_clusters(inode, &xv->xr_list,
 					      cpos, write_len, UINT_MAX,
@@ -3807,7 +3809,7 @@ static int ocfs2_attach_refcount_tree(struct inode *inode,
 
 	ocfs2_init_dealloc_ctxt(&dealloc);
 
-	if (!(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL)) {
+	if (!ocfs2_is_refcount_inode(inode)) {
 		ret = ocfs2_create_refcount_tree(inode, di_bh);
 		if (ret) {
 			mlog_errno(ret);
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index 6422bbc..553edfb 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -17,6 +17,8 @@
 #ifndef OCFS2_REFCOUNTTREE_H
 #define OCFS2_REFCOUNTTREE_H
 
+bool ocfs2_is_refcount_inode(struct inode *inode);
+
 struct ocfs2_refcount_tree {
 	struct rb_node rf_node;
 	u64 rf_blkno;
