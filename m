From: Tao Ma <tao.ma@oracle.com>
Date: Thu,  1 Apr 2010 10:59:07 +0800
Subject: [Ocfs2-devel] [PATCH 10/15] ocfs2: Grow discontig block groups in
	one transaction.
In-Reply-To: <4BB40AB4.8040205@oracle.com>
References: <4BB40AB4.8040205@oracle.com>
Message-ID: <1270090752-18935-10-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Joel Becker <joel.becker@oracle.com>

Rather than extending the transaction every time we add an extent to a
discontiguous block group, we grab enough credits to fill the extent
list up front.  This means we can free the bits in the same transaction
if we end up not getting enough space.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/journal.h  |   12 ++++++++++++
 fs/ocfs2/suballoc.c |   48 ++++++++++++++++++++++--------------------------
 2 files changed, 34 insertions(+), 26 deletions(-)

diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 3f74e09..45035f5 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -562,6 +562,18 @@ static inline int ocfs2_calc_group_alloc_credits(struct super_block *sb,
 	return blocks;
 }
 
+/*
+ * Allocating a discontiguous block group requires the credits from
+ * ocfs2_calc_group_alloc_credits() as well as enough credits to fill
+ * the group descriptor's extent list.  The caller already has started
+ * the transaction with ocfs2_calc_group_alloc_credits().  They extend
+ * it with these credits.
+ */
+static inline int ocfs2_calc_bg_discontig_credits(struct super_block *sb)
+{
+	return ocfs2_extent_recs_per_gd(sb);
+}
+
 static inline int ocfs2_calc_tree_trunc_credits(struct super_block *sb,
 						unsigned int clusters_to_del,
 						struct ocfs2_dinode *fe,
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 0ee6548..679ac4d 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -528,12 +528,6 @@ static int ocfs2_block_group_grow_discontig(handle_t *handle,
 
 	while ((needed > 0) && (le16_to_cpu(el->l_next_free_rec) <
 				le16_to_cpu(el->l_count))) {
-		status = ocfs2_extend_trans(handle, OCFS2_SUBALLOC_ALLOC);
-		if (status) {
-			mlog_errno(status);
-			goto bail;
-		}
-
 		if (min_bits > needed)
 			min_bits = needed;
 		status = ocfs2_block_group_claim_bits(osb, handle, ac,
@@ -563,11 +557,12 @@ bail:
 	return status;
 }
 
-static void ocfs2_bg_alloc_cleanup(struct inode *alloc_inode,
-				   struct buffer_head *bg_bh,
-				   struct ocfs2_cached_dealloc_ctxt *dealloc)
+static void ocfs2_bg_alloc_cleanup(handle_t *handle,
+				   struct ocfs2_alloc_context *cluster_ac,
+				   struct inode *alloc_inode,
+				   struct buffer_head *bg_bh)
 {
-	int i;
+	int i, ret;
 	struct ocfs2_group_desc *bg;
 	struct ocfs2_extent_list *el;
 	struct ocfs2_extent_rec *rec;
@@ -579,9 +574,13 @@ static void ocfs2_bg_alloc_cleanup(struct inode *alloc_inode,
 	el = &bg->bg_list;
 	for (i = 0; i < le16_to_cpu(el->l_next_free_rec); i++) {
 		rec = &el->l_recs[i];
-		ocfs2_cache_cluster_dealloc(dealloc,
-					    le64_to_cpu(rec->e_blkno),
-					    le32_to_cpu(rec->e_leaf_clusters));
+		ret = ocfs2_free_clusters(handle, cluster_ac->ac_inode,
+					  cluster_ac->ac_bh,
+					  le64_to_cpu(rec->e_blkno),
+					  le32_to_cpu(rec->e_leaf_clusters));
+		if (ret)
+			mlog_errno(ret);
+		/* Try all the clusters to free */
 	}
 
 	ocfs2_remove_from_cache(INODE_CACHE(alloc_inode), bg_bh);
@@ -592,8 +591,7 @@ static struct buffer_head *
 ocfs2_block_group_alloc_discontig(handle_t *handle,
 				  struct inode *alloc_inode,
 				  struct ocfs2_alloc_context *ac,
-				  struct ocfs2_chain_list *cl,
-				  struct ocfs2_cached_dealloc_ctxt *dealloc)
+				  struct ocfs2_chain_list *cl)
 {
 	int status;
 	u32 bit_off, num_bits;
@@ -608,6 +606,13 @@ ocfs2_block_group_alloc_discontig(handle_t *handle,
 		goto bail;
 	}
 
+	status = ocfs2_extend_trans(handle,
+				    ocfs2_calc_bg_discontig_credits(osb->sb));
+	if (status) {
+		mlog_errno(status);
+		goto bail;
+	}
+
 	/* Claim the first region */
 	status = ocfs2_block_group_claim_bits(osb, handle, ac, min_bits,
 					      &bit_off, &num_bits);
@@ -645,7 +650,7 @@ ocfs2_block_group_alloc_discontig(handle_t *handle,
 
 bail:
 	if (status)
-		ocfs2_bg_alloc_cleanup(alloc_inode, bg_bh, dealloc);
+		ocfs2_bg_alloc_cleanup(handle, ac, alloc_inode, bg_bh);
 	return status ? ERR_PTR(status) : bg_bh;
 }
 
@@ -667,14 +672,11 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 	u64 bg_blkno;
 	struct buffer_head *bg_bh = NULL;
 	struct ocfs2_group_desc *bg;
-	struct ocfs2_cached_dealloc_ctxt dealloc;
 
 	BUG_ON(ocfs2_is_cluster_bitmap(alloc_inode));
 
 	mlog_entry_void();
 
-	ocfs2_init_dealloc_ctxt(&dealloc);
-
 	cl = &fe->id2.i_chain;
 	status = ocfs2_reserve_clusters_with_limit(osb,
 						   le16_to_cpu(cl->cl_cpg),
@@ -706,8 +708,7 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 	if (IS_ERR(bg_bh) && (PTR_ERR(bg_bh) == -ENOSPC))
 		bg_bh = ocfs2_block_group_alloc_discontig(handle,
 							  alloc_inode,
-							  ac, cl,
-							  &dealloc);
+							  ac, cl);
 	if (IS_ERR(bg_bh)) {
 		status = PTR_ERR(bg_bh);
 		bg_bh = NULL;
@@ -761,11 +762,6 @@ bail:
 	if (handle)
 		ocfs2_commit_trans(osb, handle);
 
-	if (ocfs2_dealloc_has_cluster(&dealloc)) {
-		ocfs2_schedule_truncate_log_flush(osb, 1);
-		ocfs2_run_deallocs(osb, &dealloc);
-	}
-
 	if (ac)
 		ocfs2_free_alloc_context(ac);
 
-- 
1.5.5
