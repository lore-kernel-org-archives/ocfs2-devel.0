From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 27 Aug 2008 06:44:53 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Combine normal and xattr get
	extent clusters process together.
In-Reply-To: <48B4F128.2060303@oracle.com>
References: <48B4F128.2060303@oracle.com>
Message-ID: <1219790693-9918-2-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_xattr_get_clusters was originally copied and modified from
ocfs2_get_clusters and some codes are almost common, so combine
them together with the help of new wrapper, ocfs2_extent_tree.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c      |    7 ++
 fs/ocfs2/extent_map.c |  146 +++++++++++++++++++------------------------------
 fs/ocfs2/extent_map.h |    2 +-
 fs/ocfs2/xattr.c      |    8 +--
 4 files changed, 68 insertions(+), 95 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 80dbf2f..da51f52 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -307,6 +307,13 @@ static void __ocfs2_init_extent_tree(struct ocfs2_extent_tree *et,
 				     void *obj,
 				     struct ocfs2_extent_tree_operations *ops)
 {
+	BUG_ON(!obj && !bh);
+	/*
+	 * We at least need one to get our et_root_el initialized.
+	 * And if no bh, No modification of the extent tree is allowed such
+	 * as inserting or removing extents.
+	 */
+
 	et->et_ops = ops;
 	et->et_root_bh = bh;
 	if (!obj)
diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index 619b20a..623b189 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -373,12 +373,15 @@ out:
 	return ret;
 }
 
-int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
+int ocfs2_get_clusters_btree(struct inode *inode, u32 v_cluster,
 			     u32 *p_cluster, u32 *num_clusters,
-			     struct ocfs2_extent_list *el)
+			     struct ocfs2_extent_tree *et,
+			     unsigned int *extent_flags)
 {
 	int ret = 0, i;
+	unsigned int flags = 0;
 	struct buffer_head *eb_bh = NULL;
+	struct ocfs2_extent_list *el = et->et_root_el;
 	struct ocfs2_extent_block *eb;
 	struct ocfs2_extent_rec *rec;
 	u32 coff;
@@ -396,7 +399,7 @@ int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
 		if (el->l_tree_depth) {
 			ocfs2_error(inode->i_sb,
 				    "Inode %lu has non zero tree depth in "
-				    "xattr leaf block %llu\n", inode->i_ino,
+				    "leaf block %llu\n", inode->i_ino,
 				    (unsigned long long)eb_bh->b_blocknr);
 			ret = -EROFS;
 			goto out;
@@ -405,16 +408,36 @@ int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
 
 	i = ocfs2_search_extent_list(el, v_cluster);
 	if (i == -1) {
-		ret = -EROFS;
-		mlog_errno(ret);
-		goto out;
+		if (ocfs2_is_dinode_extent_tree(et)) {
+			/*
+			 * A hole was found. Return some canned values that
+			 * callers can key on. If asked for, num_clusters will
+			 * be populated with the size of the hole.
+			 */
+			*p_cluster = 0;
+			if (num_clusters) {
+				ret = ocfs2_figure_hole_clusters(inode, el,
+								 eb_bh,
+								 v_cluster,
+								 num_clusters);
+				if (ret) {
+					mlog_errno(ret);
+					goto out;
+				}
+			}
+		} else if (ocfs2_is_xattr_value_extent_tree(et)) {
+			ret = -EROFS;
+			mlog_errno(ret);
+			goto out;
+		} else
+			BUG();
 	} else {
 		rec = &el->l_recs[i];
 		BUG_ON(v_cluster < le32_to_cpu(rec->e_cpos));
 
 		if (!rec->e_blkno) {
 			ocfs2_error(inode->i_sb, "Inode %lu has bad extent "
-				    "record (%u, %u, 0) in xattr", inode->i_ino,
+				    "record (%u, %u, 0)", inode->i_ino,
 				    le32_to_cpu(rec->e_cpos),
 				    ocfs2_rec_clusters(el, rec));
 			ret = -EROFS;
@@ -426,26 +449,39 @@ int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
 		*p_cluster = *p_cluster + coff;
 		if (num_clusters)
 			*num_clusters = ocfs2_rec_clusters(el, rec) - coff;
+
+		flags = rec->e_flags;
+
+		if (ocfs2_is_dinode_extent_tree(et))
+			ocfs2_extent_map_insert_rec(inode, rec);
 	}
+
+	if (extent_flags)
+		*extent_flags = flags;
 out:
-	if (eb_bh)
-		brelse(eb_bh);
+	brelse(eb_bh);
 	return ret;
 }
 
+int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
+			     u32 *p_cluster, u32 *num_clusters,
+			     struct ocfs2_xattr_value_root *xv)
+{
+	struct ocfs2_extent_tree et;
+
+	ocfs2_init_xattr_value_extent_tree(&et, inode, NULL, xv);
+	return ocfs2_get_clusters_btree(inode, v_cluster,
+					p_cluster, num_clusters,
+					&et, NULL);
+}
+
 int ocfs2_get_clusters(struct inode *inode, u32 v_cluster,
 		       u32 *p_cluster, u32 *num_clusters,
 		       unsigned int *extent_flags)
 {
-	int ret, i;
-	unsigned int flags = 0;
+	int ret;
 	struct buffer_head *di_bh = NULL;
-	struct buffer_head *eb_bh = NULL;
-	struct ocfs2_dinode *di;
-	struct ocfs2_extent_block *eb;
-	struct ocfs2_extent_list *el;
-	struct ocfs2_extent_rec *rec;
-	u32 coff;
+	struct ocfs2_extent_tree et;
 
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
 		ret = -ERANGE;
@@ -465,80 +501,12 @@ int ocfs2_get_clusters(struct inode *inode, u32 v_cluster,
 		goto out;
 	}
 
-	di = (struct ocfs2_dinode *) di_bh->b_data;
-	el = &di->id2.i_list;
-
-	if (el->l_tree_depth) {
-		ret = ocfs2_find_leaf(inode, el, v_cluster, &eb_bh);
-		if (ret) {
-			mlog_errno(ret);
-			goto out;
-		}
-
-		eb = (struct ocfs2_extent_block *) eb_bh->b_data;
-		el = &eb->h_list;
-
-		if (el->l_tree_depth) {
-			ocfs2_error(inode->i_sb,
-				    "Inode %lu has non zero tree depth in "
-				    "leaf block %llu\n", inode->i_ino,
-				    (unsigned long long)eb_bh->b_blocknr);
-			ret = -EROFS;
-			goto out;
-		}
-	}
-
-	i = ocfs2_search_extent_list(el, v_cluster);
-	if (i == -1) {
-		/*
-		 * A hole was found. Return some canned values that
-		 * callers can key on. If asked for, num_clusters will
-		 * be populated with the size of the hole.
-		 */
-		*p_cluster = 0;
-		if (num_clusters) {
-			ret = ocfs2_figure_hole_clusters(inode, el, eb_bh,
-							 v_cluster,
-							 num_clusters);
-			if (ret) {
-				mlog_errno(ret);
-				goto out;
-			}
-		}
-	} else {
-		rec = &el->l_recs[i];
-
-		BUG_ON(v_cluster < le32_to_cpu(rec->e_cpos));
-
-		if (!rec->e_blkno) {
-			ocfs2_error(inode->i_sb, "Inode %lu has bad extent "
-				    "record (%u, %u, 0)", inode->i_ino,
-				    le32_to_cpu(rec->e_cpos),
-				    ocfs2_rec_clusters(el, rec));
-			ret = -EROFS;
-			goto out;
-		}
-
-		coff = v_cluster - le32_to_cpu(rec->e_cpos);
-
-		*p_cluster = ocfs2_blocks_to_clusters(inode->i_sb,
-						    le64_to_cpu(rec->e_blkno));
-		*p_cluster = *p_cluster + coff;
-
-		if (num_clusters)
-			*num_clusters = ocfs2_rec_clusters(el, rec) - coff;
-
-		flags = rec->e_flags;
-
-		ocfs2_extent_map_insert_rec(inode, rec);
-	}
-
-	if (extent_flags)
-		*extent_flags = flags;
-
+	ocfs2_init_dinode_extent_tree(&et, inode, di_bh);
+	ret = ocfs2_get_clusters_btree(inode, v_cluster,
+				       p_cluster, num_clusters,
+				       &et, extent_flags);
 out:
 	brelse(di_bh);
-	brelse(eb_bh);
 	return ret;
 }
 
diff --git a/fs/ocfs2/extent_map.h b/fs/ocfs2/extent_map.h
index d98444e..ac2d9d7 100644
--- a/fs/ocfs2/extent_map.h
+++ b/fs/ocfs2/extent_map.h
@@ -52,5 +52,5 @@ int ocfs2_extent_map_get_blocks(struct inode *inode, u64 v_blkno, u64 *p_blkno,
 
 int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
 			     u32 *p_cluster, u32 *num_clusters,
-			     struct ocfs2_extent_list *el);
+			     struct ocfs2_xattr_value_root *xv);
 #endif  /* _EXTENT_MAP_H */
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 2ccffb1..2bc53b1 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -423,7 +423,7 @@ static int ocfs2_xattr_shrink_size(struct inode *inode,
 	trunc_len = old_clusters - new_clusters;
 	while (trunc_len) {
 		ret = ocfs2_xattr_get_clusters(inode, cpos, &phys_cpos,
-					       &alloc_size, &xv->xr_list);
+					       &alloc_size, xv);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -656,9 +656,7 @@ static int ocfs2_xattr_get_value_outside(struct inode *inode,
 	int i, ret = 0;
 	size_t cplen, blocksize;
 	struct buffer_head *bh = NULL;
-	struct ocfs2_extent_list *el;
 
-	el = &xv->xr_list;
 	clusters = le32_to_cpu(xv->xr_clusters);
 	bpc = ocfs2_clusters_to_blocks(inode->i_sb, 1);
 	blocksize = inode->i_sb->s_blocksize;
@@ -666,7 +664,7 @@ static int ocfs2_xattr_get_value_outside(struct inode *inode,
 	cpos = 0;
 	while (cpos < clusters) {
 		ret = ocfs2_xattr_get_clusters(inode, cpos, &p_cluster,
-					       &num_clusters, el);
+					       &num_clusters, xv);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -916,7 +914,7 @@ static int __ocfs2_xattr_set_value_outside(struct inode *inode,
 
 	while (cpos < clusters) {
 		ret = ocfs2_xattr_get_clusters(inode, cpos, &p_cluster,
-					       &num_clusters, &xv->xr_list);
+					       &num_clusters, xv);
 		if (ret) {
 			mlog_errno(ret);
 			goto out_commit;
-- 
1.5.4.GIT
