From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Thu, 10 Nov 2016 09:52:17 -0800
Subject: [Ocfs2-devel] [PATCH v2 1/6] ocfs2: convert inode refcount test to
	a helper
In-Reply-To: <147873187285.2820.9992440620792982440.stgit@birch.djwong.org>
References: <147873186646.2820.17513529102740292215.stgit@birch.djwong.org>
	<147873187285.2820.9992440620792982440.stgit@birch.djwong.org>
Message-ID: <20161110175217.GC16807@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@versity.com, jlbec@evilplan.org
Cc: linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Replace the open-coded inode refcount flag test with a helper function
to reduce the potential for bugs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ocfs2/alloc.c        |    3 +--
 fs/ocfs2/file.c         |    7 +++----
 fs/ocfs2/inode.h        |    6 ++++++
 fs/ocfs2/move_extents.c |   10 ++--------
 fs/ocfs2/refcounttree.c |   22 +++++++++-------------
 fs/ocfs2/xattr.c        |    4 ++--
 6 files changed, 23 insertions(+), 29 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index f72712f..a0ca49f 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -5713,8 +5713,7 @@ int ocfs2_remove_btree_range(struct inode *inode,
 	struct ocfs2_refcount_tree *ref_tree = NULL;
 
 	if ((flags & OCFS2_EXT_REFCOUNTED) && len) {
-		BUG_ON(!(OCFS2_I(inode)->ip_dyn_features &
-			 OCFS2_HAS_REFCOUNT_FL));
+		BUG_ON(!ocfs2_is_refcount_inode(inode));
 
 		if (!refcount_tree_locked) {
 			ret = ocfs2_lock_refcount_tree(osb, refcount_loc, 1,
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 000c234..d261f3a 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1030,7 +1030,7 @@ int ocfs2_extend_no_holes(struct inode *inode, struct buffer_head *di_bh,
 	 * Only quota files call this without a bh, and they can't be
 	 * refcounted.
 	 */
-	BUG_ON(!di_bh && (oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL));
+	BUG_ON(!di_bh && ocfs2_is_refcount_inode(inode));
 	BUG_ON(!di_bh && !(oi->ip_flags & OCFS2_INODE_SYSTEM_FILE));
 
 	clusters_to_add = ocfs2_clusters_for_bytes(inode->i_sb, new_i_size);
@@ -1719,8 +1719,7 @@ static int ocfs2_remove_inode_range(struct inode *inode,
 	 * within one cluster(means is not exactly aligned to clustersize).
 	 */
 
-	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL) {
-
+	if (ocfs2_is_refcount_inode(inode)) {
 		ret = ocfs2_cow_file_pos(inode, di_bh, byte_start);
 		if (ret) {
 			mlog_errno(ret);
@@ -2036,7 +2035,7 @@ int ocfs2_check_range_for_refcount(struct inode *inode, loff_t pos,
 	struct super_block *sb = inode->i_sb;
 
 	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb)) ||
-	    !(OCFS2_I(inode)->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL) ||
+	    !ocfs2_is_refcount_inode(inode) ||
 	    OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
 		return 0;
 
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index 5af68fc..9b955f7 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -181,4 +181,10 @@ static inline struct ocfs2_inode_info *cache_info_to_inode(struct ocfs2_caching_
 	return container_of(ci, struct ocfs2_inode_info, ip_metadata_cache);
 }
 
+/* Does this inode have the reflink flag set? */
+static inline bool ocfs2_is_refcount_inode(struct inode *inode)
+{
+	return (OCFS2_I(inode)->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL);
+}
+
 #endif /* OCFS2_INODE_H */
diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 4e8f32eb..e52a285 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -235,10 +235,7 @@ static int ocfs2_defrag_extent(struct ocfs2_move_extents_context *context,
 	u64 phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, phys_cpos);
 
 	if ((ext_flags & OCFS2_EXT_REFCOUNTED) && *len) {
-
-		BUG_ON(!(OCFS2_I(inode)->ip_dyn_features &
-			 OCFS2_HAS_REFCOUNT_FL));
-
+		BUG_ON(!ocfs2_is_refcount_inode(inode));
 		BUG_ON(!context->refcount_loc);
 
 		ret = ocfs2_lock_refcount_tree(osb, context->refcount_loc, 1,
@@ -581,10 +578,7 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
 	phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, phys_cpos);
 
 	if ((ext_flags & OCFS2_EXT_REFCOUNTED) && len) {
-
-		BUG_ON(!(OCFS2_I(inode)->ip_dyn_features &
-			 OCFS2_HAS_REFCOUNT_FL));
-
+		BUG_ON(!ocfs2_is_refcount_inode(inode));
 		BUG_ON(!context->refcount_loc);
 
 		ret = ocfs2_lock_refcount_tree(osb, context->refcount_loc, 1,
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 1923851..3410eb1 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -410,7 +410,7 @@ static int ocfs2_get_refcount_block(struct inode *inode, u64 *ref_blkno)
 		goto out;
 	}
 
-	BUG_ON(!(OCFS2_I(inode)->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL));
+	BUG_ON(!ocfs2_is_refcount_inode(inode));
 
 	di = (struct ocfs2_dinode *)di_bh->b_data;
 	*ref_blkno = le64_to_cpu(di->i_refcount_loc);
@@ -570,7 +570,7 @@ static int ocfs2_create_refcount_tree(struct inode *inode,
 	u32 num_got;
 	u64 suballoc_loc, first_blkno;
 
-	BUG_ON(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL);
+	BUG_ON(ocfs2_is_refcount_inode(inode));
 
 	trace_ocfs2_create_refcount_tree(
 		(unsigned long long)OCFS2_I(inode)->ip_blkno);
@@ -708,7 +708,7 @@ static int ocfs2_set_refcount_tree(struct inode *inode,
 	struct ocfs2_refcount_block *rb;
 	struct ocfs2_refcount_tree *ref_tree;
 
-	BUG_ON(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL);
+	BUG_ON(ocfs2_is_refcount_inode(inode));
 
 	ret = ocfs2_lock_refcount_tree(osb, refcount_loc, 1,
 				       &ref_tree, &ref_root_bh);
@@ -775,7 +775,7 @@ int ocfs2_remove_refcount_tree(struct inode *inode, struct buffer_head *di_bh)
 	u64 blk = 0, bg_blkno = 0, ref_blkno = le64_to_cpu(di->i_refcount_loc);
 	u16 bit = 0;
 
-	if (!(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL))
+	if (!ocfs2_is_refcount_inode(inode))
 		return 0;
 
 	BUG_ON(!ref_blkno);
@@ -2299,11 +2299,10 @@ int ocfs2_decrease_refcount(struct inode *inode,
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
@@ -2533,7 +2532,6 @@ int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
 					  int *ref_blocks)
 {
 	int ret;
-	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct buffer_head *ref_root_bh = NULL;
 	struct ocfs2_refcount_tree *tree;
 	u64 start_cpos = ocfs2_blocks_to_clusters(inode->i_sb, phys_blkno);
@@ -2544,7 +2542,7 @@ int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
 		goto out;
 	}
 
-	BUG_ON(!(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL));
+	BUG_ON(!ocfs2_is_refcount_inode(inode));
 
 	ret = ocfs2_get_refcount_tree(OCFS2_SB(inode->i_sb),
 				      refcount_loc, &tree);
@@ -3412,14 +3410,13 @@ static int ocfs2_refcount_cow_hunk(struct inode *inode,
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
@@ -3629,11 +3626,10 @@ int ocfs2_refcount_cow_xattr(struct inode *inode,
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
@@ -3807,7 +3803,7 @@ static int ocfs2_attach_refcount_tree(struct inode *inode,
 
 	ocfs2_init_dealloc_ctxt(&dealloc);
 
-	if (!(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL)) {
+	if (!ocfs2_is_refcount_inode(inode)) {
 		ret = ocfs2_create_refcount_tree(inode, di_bh);
 		if (ret) {
 			mlog_errno(ret);
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index cb157a3..3c5384d 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2577,7 +2577,7 @@ int ocfs2_xattr_remove(struct inode *inode, struct buffer_head *di_bh)
 	if (!(oi->ip_dyn_features & OCFS2_HAS_XATTR_FL))
 		return 0;
 
-	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL) {
+	if (ocfs2_is_refcount_inode(inode)) {
 		ret = ocfs2_lock_refcount_tree(OCFS2_SB(inode->i_sb),
 					       le64_to_cpu(di->i_refcount_loc),
 					       1, &ref_tree, &ref_root_bh);
@@ -3608,7 +3608,7 @@ int ocfs2_xattr_set(struct inode *inode,
 	}
 
 	/* Check whether the value is refcounted and do some preparation. */
-	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL &&
+	if (ocfs2_is_refcount_inode(inode) &&
 	    (!xis.not_found || !xbs.not_found)) {
 		ret = ocfs2_prepare_refcount_xattr(inode, di, &xi,
 						   &xis, &xbs, &ref_tree,
