From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:16:02 -0800
Subject: [Ocfs2-devel] [PATCH 15/40] ocfs2: Drop struct inode from
	ocfs2_extent_tree_operations.
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-16-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We can get to the inode from the caching information.  Other parent
types don't need it.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |   86 ++++++++++++++++++++++-------------------------------
 fs/ocfs2/inode.c |    4 --
 fs/ocfs2/inode.h |    6 ++++
 3 files changed, 42 insertions(+), 54 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index d2cc623..06aae9f 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -79,18 +79,16 @@ struct ocfs2_extent_tree_operations {
 	 * that value.  new_clusters is the delta, and must be
 	 * added to the total.  Required.
 	 */
-	void (*eo_update_clusters)(struct inode *inode,
-				   struct ocfs2_extent_tree *et,
+	void (*eo_update_clusters)(struct ocfs2_extent_tree *et,
 				   u32 new_clusters);
 
 	/*
 	 * If ->eo_insert_check() exists, it is called before rec is
 	 * inserted into the extent tree.  It is optional.
 	 */
-	int (*eo_insert_check)(struct inode *inode,
-			       struct ocfs2_extent_tree *et,
+	int (*eo_insert_check)(struct ocfs2_extent_tree *et,
 			       struct ocfs2_extent_rec *rec);
-	int (*eo_sanity_check)(struct inode *inode, struct ocfs2_extent_tree *et);
+	int (*eo_sanity_check)(struct ocfs2_extent_tree *et);
 
 	/*
 	 * --------------------------------------------------------------
@@ -109,8 +107,7 @@ struct ocfs2_extent_tree_operations {
 	 * it exists.  If it does not, et->et_max_leaf_clusters is set
 	 * to 0 (unlimited).  Optional.
 	 */
-	void (*eo_fill_max_leaf_clusters)(struct inode *inode,
-					  struct ocfs2_extent_tree *et);
+	void (*eo_fill_max_leaf_clusters)(struct ocfs2_extent_tree *et);
 };
 
 
@@ -121,14 +118,11 @@ struct ocfs2_extent_tree_operations {
 static u64 ocfs2_dinode_get_last_eb_blk(struct ocfs2_extent_tree *et);
 static void ocfs2_dinode_set_last_eb_blk(struct ocfs2_extent_tree *et,
 					 u64 blkno);
-static void ocfs2_dinode_update_clusters(struct inode *inode,
-					 struct ocfs2_extent_tree *et,
+static void ocfs2_dinode_update_clusters(struct ocfs2_extent_tree *et,
 					 u32 clusters);
-static int ocfs2_dinode_insert_check(struct inode *inode,
-				     struct ocfs2_extent_tree *et,
+static int ocfs2_dinode_insert_check(struct ocfs2_extent_tree *et,
 				     struct ocfs2_extent_rec *rec);
-static int ocfs2_dinode_sanity_check(struct inode *inode,
-				     struct ocfs2_extent_tree *et);
+static int ocfs2_dinode_sanity_check(struct ocfs2_extent_tree *et);
 static void ocfs2_dinode_fill_root_el(struct ocfs2_extent_tree *et);
 static struct ocfs2_extent_tree_operations ocfs2_dinode_et_ops = {
 	.eo_set_last_eb_blk	= ocfs2_dinode_set_last_eb_blk,
@@ -156,39 +150,37 @@ static u64 ocfs2_dinode_get_last_eb_blk(struct ocfs2_extent_tree *et)
 	return le64_to_cpu(di->i_last_eb_blk);
 }
 
-static void ocfs2_dinode_update_clusters(struct inode *inode,
-					 struct ocfs2_extent_tree *et,
+static void ocfs2_dinode_update_clusters(struct ocfs2_extent_tree *et,
 					 u32 clusters)
 {
+	struct ocfs2_inode_info *oi = cache_info_to_inode(et->et_ci);
 	struct ocfs2_dinode *di = et->et_object;
 
 	le32_add_cpu(&di->i_clusters, clusters);
-	spin_lock(&OCFS2_I(inode)->ip_lock);
-	OCFS2_I(inode)->ip_clusters = le32_to_cpu(di->i_clusters);
-	spin_unlock(&OCFS2_I(inode)->ip_lock);
+	spin_lock(&oi->ip_lock);
+	oi->ip_clusters = le32_to_cpu(di->i_clusters);
+	spin_unlock(&oi->ip_lock);
 }
 
-static int ocfs2_dinode_insert_check(struct inode *inode,
-				     struct ocfs2_extent_tree *et,
+static int ocfs2_dinode_insert_check(struct ocfs2_extent_tree *et,
 				     struct ocfs2_extent_rec *rec)
 {
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_inode_info *oi = cache_info_to_inode(et->et_ci);
+	struct ocfs2_super *osb = OCFS2_SB(oi->vfs_inode.i_sb);
 
-	BUG_ON(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL);
+	BUG_ON(oi->ip_dyn_features & OCFS2_INLINE_DATA_FL);
 	mlog_bug_on_msg(!ocfs2_sparse_alloc(osb) &&
-			(OCFS2_I(inode)->ip_clusters != rec->e_cpos),
+			(oi->ip_clusters != rec->e_cpos),
 			"Device %s, asking for sparse allocation: inode %llu, "
 			"cpos %u, clusters %u\n",
 			osb->dev_str,
-			(unsigned long long)OCFS2_I(inode)->ip_blkno,
-			rec->e_cpos,
-			OCFS2_I(inode)->ip_clusters);
+			(unsigned long long)oi->ip_blkno,
+			rec->e_cpos, oi->ip_clusters);
 
 	return 0;
 }
 
-static int ocfs2_dinode_sanity_check(struct inode *inode,
-				     struct ocfs2_extent_tree *et)
+static int ocfs2_dinode_sanity_check(struct ocfs2_extent_tree *et)
 {
 	struct ocfs2_dinode *di = et->et_object;
 
@@ -228,8 +220,7 @@ static u64 ocfs2_xattr_value_get_last_eb_blk(struct ocfs2_extent_tree *et)
 	return le64_to_cpu(vb->vb_xv->xr_last_eb_blk);
 }
 
-static void ocfs2_xattr_value_update_clusters(struct inode *inode,
-					      struct ocfs2_extent_tree *et,
+static void ocfs2_xattr_value_update_clusters(struct ocfs2_extent_tree *et,
 					      u32 clusters)
 {
 	struct ocfs2_xattr_value_buf *vb = et->et_object;
@@ -251,12 +242,11 @@ static void ocfs2_xattr_tree_fill_root_el(struct ocfs2_extent_tree *et)
 	et->et_root_el = &xb->xb_attrs.xb_root.xt_list;
 }
 
-static void ocfs2_xattr_tree_fill_max_leaf_clusters(struct inode *inode,
-						    struct ocfs2_extent_tree *et)
+static void ocfs2_xattr_tree_fill_max_leaf_clusters(struct ocfs2_extent_tree *et)
 {
+	struct super_block *sb = ocfs2_metadata_cache_get_super(et->et_ci);
 	et->et_max_leaf_clusters =
-		ocfs2_clusters_for_bytes(inode->i_sb,
-					 OCFS2_MAX_XATTR_TREE_LEAF_SIZE);
+		ocfs2_clusters_for_bytes(sb, OCFS2_MAX_XATTR_TREE_LEAF_SIZE);
 }
 
 static void ocfs2_xattr_tree_set_last_eb_blk(struct ocfs2_extent_tree *et,
@@ -276,8 +266,7 @@ static u64 ocfs2_xattr_tree_get_last_eb_blk(struct ocfs2_extent_tree *et)
 	return le64_to_cpu(xt->xt_last_eb_blk);
 }
 
-static void ocfs2_xattr_tree_update_clusters(struct inode *inode,
-					     struct ocfs2_extent_tree *et,
+static void ocfs2_xattr_tree_update_clusters(struct ocfs2_extent_tree *et,
 					     u32 clusters)
 {
 	struct ocfs2_xattr_block *xb = et->et_object;
@@ -312,7 +301,7 @@ static void __ocfs2_init_extent_tree(struct ocfs2_extent_tree *et,
 	if (!et->et_ops->eo_fill_max_leaf_clusters)
 		et->et_max_leaf_clusters = 0;
 	else
-		et->et_ops->eo_fill_max_leaf_clusters(inode, et);
+		et->et_ops->eo_fill_max_leaf_clusters(et);
 }
 
 void ocfs2_init_dinode_extent_tree(struct ocfs2_extent_tree *et,
@@ -350,11 +339,10 @@ static inline u64 ocfs2_et_get_last_eb_blk(struct ocfs2_extent_tree *et)
 	return et->et_ops->eo_get_last_eb_blk(et);
 }
 
-static inline void ocfs2_et_update_clusters(struct inode *inode,
-					    struct ocfs2_extent_tree *et,
+static inline void ocfs2_et_update_clusters(struct ocfs2_extent_tree *et,
 					    u32 clusters)
 {
-	et->et_ops->eo_update_clusters(inode, et, clusters);
+	et->et_ops->eo_update_clusters(et, clusters);
 }
 
 static inline int ocfs2_et_root_journal_access(handle_t *handle,
@@ -365,24 +353,22 @@ static inline int ocfs2_et_root_journal_access(handle_t *handle,
 					  type);
 }
 
-static inline int ocfs2_et_insert_check(struct inode *inode,
-					struct ocfs2_extent_tree *et,
+static inline int ocfs2_et_insert_check(struct ocfs2_extent_tree *et,
 					struct ocfs2_extent_rec *rec)
 {
 	int ret = 0;
 
 	if (et->et_ops->eo_insert_check)
-		ret = et->et_ops->eo_insert_check(inode, et, rec);
+		ret = et->et_ops->eo_insert_check(et, rec);
 	return ret;
 }
 
-static inline int ocfs2_et_sanity_check(struct inode *inode,
-					struct ocfs2_extent_tree *et)
+static inline int ocfs2_et_sanity_check(struct ocfs2_extent_tree *et)
 {
 	int ret = 0;
 
 	if (et->et_ops->eo_sanity_check)
-		ret = et->et_ops->eo_sanity_check(inode, et);
+		ret = et->et_ops->eo_sanity_check(et);
 	return ret;
 }
 
@@ -2856,7 +2842,7 @@ static int ocfs2_remove_rightmost_path(struct inode *inode, handle_t *handle,
 	struct ocfs2_extent_list *el;
 
 
-	ret = ocfs2_et_sanity_check(inode, et);
+	ret = ocfs2_et_sanity_check(et);
 	if (ret)
 		goto out;
 	/*
@@ -4143,7 +4129,7 @@ static int ocfs2_do_insert_extent(struct inode *inode,
 
 out_update_clusters:
 	if (type->ins_split == SPLIT_NONE)
-		ocfs2_et_update_clusters(inode, et,
+		ocfs2_et_update_clusters(et,
 					 le16_to_cpu(insert_rec->e_leaf_clusters));
 
 	ret = ocfs2_journal_dirty(handle, et->et_root_bh);
@@ -4532,7 +4518,7 @@ int ocfs2_insert_extent(struct ocfs2_super *osb,
 	rec.e_blkno = cpu_to_le64(start_blk);
 	rec.e_leaf_clusters = cpu_to_le16(new_clusters);
 	rec.e_flags = flags;
-	status = ocfs2_et_insert_check(inode, et, &rec);
+	status = ocfs2_et_insert_check(et, &rec);
 	if (status) {
 		mlog_errno(status);
 		goto bail;
@@ -5413,7 +5399,7 @@ int ocfs2_remove_btree_range(struct inode *inode,
 		goto out_commit;
 	}
 
-	ocfs2_et_update_clusters(inode, et, -len);
+	ocfs2_et_update_clusters(et, -len);
 
 	ret = ocfs2_journal_dirty(handle, et->et_root_bh);
 	if (ret) {
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index b9cf212..453724d 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1347,10 +1347,6 @@ int ocfs2_read_inode_block(struct inode *inode, struct buffer_head **bh)
 	return ocfs2_read_inode_block_full(inode, bh, 0);
 }
 
-static struct ocfs2_inode_info *cache_info_to_inode(struct ocfs2_caching_info *ci)
-{
-	return container_of(ci, struct ocfs2_inode_info, ip_metadata_cache);
-}
 
 static u64 ocfs2_inode_cache_owner(struct ocfs2_caching_info *ci)
 {
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index 4660962..28b15c0 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -165,4 +165,10 @@ int ocfs2_read_inode_block(struct inode *inode, struct buffer_head **bh);
 /* The same, but can be passed OCFS2_BH_* flags */
 int ocfs2_read_inode_block_full(struct inode *inode, struct buffer_head **bh,
 				int flags);
+
+static inline struct ocfs2_inode_info *cache_info_to_inode(struct ocfs2_caching_info *ci)
+{
+	return container_of(ci, struct ocfs2_inode_info, ip_metadata_cache);
+}
+
 #endif /* OCFS2_INODE_H */
-- 
1.5.6.5
