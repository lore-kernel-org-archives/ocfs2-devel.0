From: Tao Ma <tao.ma@oracle.com>
Date: Thu,  1 Apr 2010 10:59:09 +0800
Subject: [Ocfs2-devel] [PATCH 12/15] ocfs2: Some tiny bug fixes for
	discontiguous block allocation.
In-Reply-To: <4BB40AB4.8040205@oracle.com>
References: <4BB40AB4.8040205@oracle.com>
Message-ID: <1270090752-18935-12-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The fixes include:
1. some endian problems.
2. we should use bit/bpc in ocfs2_block_group_grow_discontig to
   allocate clusters.
3. set num_clusters properly in __ocfs2_claim_clusters.
4. change name from ocfs2_supports_discontig_bh to
   ocfs2_supports_discontig_bg.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/ocfs2.h    |    2 +-
 fs/ocfs2/suballoc.c |   41 ++++++++++++++++++++++-------------------
 2 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index b5fd76f..85a0899 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -482,7 +482,7 @@ static inline int ocfs2_supports_indexed_dirs(struct ocfs2_super *osb)
 	return 0;
 }
 
-static inline int ocfs2_supports_discontig_bh(struct ocfs2_super *osb)
+static inline int ocfs2_supports_discontig_bg(struct ocfs2_super *osb)
 {
 	if (osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_DISCONTIG_BG)
 		return 1;
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 0d2cd75..0878b5d 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -344,15 +344,17 @@ static void ocfs2_bg_discontig_add_extent(struct ocfs2_super *osb,
 	struct ocfs2_extent_list *el = &bg->bg_list;
 	struct ocfs2_extent_rec *rec;
 
-	BUG_ON(!ocfs2_supports_discontig_bh(osb));
+	BUG_ON(!ocfs2_supports_discontig_bg(osb));
 	if (!el->l_next_free_rec)
 		el->l_count = cpu_to_le16(ocfs2_extent_recs_per_gd(osb->sb));
 	rec = &el->l_recs[le16_to_cpu(el->l_next_free_rec)];
-	rec->e_blkno = p_blkno;
+	rec->e_blkno = cpu_to_le64(p_blkno);
 	rec->e_cpos = cpu_to_le32(le16_to_cpu(bg->bg_bits) /
 				  le16_to_cpu(cl->cl_bpc));
 	rec->e_leaf_clusters = cpu_to_le32(clusters);
 	le16_add_cpu(&bg->bg_bits, clusters * le16_to_cpu(cl->cl_bpc));
+	le16_add_cpu(&bg->bg_free_bits_count,
+		     clusters * le16_to_cpu(cl->cl_bpc));
 	le16_add_cpu(&el->l_next_free_rec, 1);
 }
 
@@ -400,7 +402,7 @@ static int ocfs2_block_group_fill(handle_t *handle,
 	if (group_clusters == le16_to_cpu(cl->cl_cpg))
 		bg->bg_bits = cpu_to_le16(ocfs2_bits_per_group(cl));
 	else
-		ocfs2_bg_discontig_add_extent(osb, bg, cl, bg->bg_blkno,
+		ocfs2_bg_discontig_add_extent(osb, bg, cl, group_blkno,
 					      group_clusters);
 
 	/* set the 1st bit in the bitmap to account for the descriptor block */
@@ -511,8 +513,8 @@ static int ocfs2_block_group_grow_discontig(handle_t *handle,
 	struct ocfs2_super *osb = OCFS2_SB(alloc_inode->i_sb);
 	struct ocfs2_group_desc *bg =
 		(struct ocfs2_group_desc *)bg_bh->b_data;
-	unsigned int needed =
-		ocfs2_bits_per_group(cl) - le16_to_cpu(bg->bg_bits);
+	unsigned int needed = le16_to_cpu(cl->cl_cpg) -
+			 le16_to_cpu(bg->bg_bits) / le16_to_cpu(cl->cl_bpc);
 	u32 p_cpos, clusters;
 	u64 p_blkno;
 	struct ocfs2_extent_list *el = &bg->bg_list;
@@ -543,10 +545,8 @@ static int ocfs2_block_group_grow_discontig(handle_t *handle,
 					      clusters);
 
 		min_bits = clusters;
-		needed = ocfs2_bits_per_group(cl) - le16_to_cpu(bg->bg_bits);
-	}
-
-	if (needed > 0) {
+		needed = le16_to_cpu(cl->cl_cpg) -
+			 le16_to_cpu(bg->bg_bits) / le16_to_cpu(cl->cl_bpc);
 	}
 
 	status = ocfs2_journal_dirty(handle, bg_bh);
@@ -601,13 +601,14 @@ ocfs2_block_group_alloc_discontig(handle_t *handle,
 	unsigned int alloc_rec = ocfs2_find_smallest_chain(cl);
 	struct ocfs2_super *osb = OCFS2_SB(alloc_inode->i_sb);
 
-	if (!ocfs2_supports_discontig_bh(osb)) {
+	if (!ocfs2_supports_discontig_bg(osb)) {
 		status = -ENOSPC;
 		goto bail;
 	}
 
 	status = ocfs2_extend_trans(handle,
-				    ocfs2_calc_bg_discontig_credits(osb->sb));
+				    ocfs2_calc_bg_discontig_credits(osb->sb) +
+				    handle->h_buffer_credits);
 	if (status) {
 		mlog_errno(status);
 		goto bail;
@@ -677,7 +678,7 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 	struct ocfs2_chain_list *cl;
 	struct ocfs2_alloc_context *ac = NULL;
 	handle_t *handle = NULL;
-	u64 bg_blkno;
+	u16 alloc_rec;
 	struct buffer_head *bg_bh = NULL;
 	struct ocfs2_group_desc *bg;
 
@@ -733,18 +734,20 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 		goto bail;
 	}
 
-	le32_add_cpu(&cl->cl_recs[bg->bg_chain].c_free,
+	alloc_rec = le16_to_cpu(bg->bg_chain);
+	le32_add_cpu(&cl->cl_recs[alloc_rec].c_free,
 		     le16_to_cpu(bg->bg_free_bits_count));
-	le32_add_cpu(&cl->cl_recs[bg->bg_chain].c_total,
+	le32_add_cpu(&cl->cl_recs[alloc_rec].c_total,
 		     le16_to_cpu(bg->bg_bits));
-	cl->cl_recs[bg->bg_chain].c_blkno  = cpu_to_le64(bg_blkno);
+	cl->cl_recs[alloc_rec].c_blkno  = cpu_to_le64(bg->bg_blkno);
 	if (le16_to_cpu(cl->cl_next_free_rec) < le16_to_cpu(cl->cl_count))
 		le16_add_cpu(&cl->cl_next_free_rec, 1);
 
 	le32_add_cpu(&fe->id1.bitmap1.i_used, le16_to_cpu(bg->bg_bits) -
 					le16_to_cpu(bg->bg_free_bits_count));
 	le32_add_cpu(&fe->id1.bitmap1.i_total, le16_to_cpu(bg->bg_bits));
-	le32_add_cpu(&fe->i_clusters, le16_to_cpu(cl->cl_cpg));
+	le32_add_cpu(&fe->i_clusters,
+		     le16_to_cpu(bg->bg_bits) / le16_to_cpu(cl->cl_bpc));
 
 	status = ocfs2_journal_dirty(handle, bh);
 	if (status < 0) {
@@ -1662,7 +1665,7 @@ static void ocfs2_bg_discontig_fix_result(struct ocfs2_alloc_context *ac,
 
 	res->sr_blkno = res->sr_bg_blkno + res->sr_bit_offset;
 	res->sr_bg_blkno = 0;  /* Clear it for contig block groups */
-	if (!ocfs2_supports_discontig_bh(OCFS2_SB(ac->ac_inode->i_sb)) ||
+	if (!ocfs2_supports_discontig_bg(OCFS2_SB(ac->ac_inode->i_sb)) ||
 	    !bg->bg_list.l_next_free_rec)
 		return;
 
@@ -2206,6 +2209,7 @@ int __ocfs2_claim_clusters(handle_t *handle,
 								 res.sr_bg_blkno,
 								 res.sr_bit_offset);
 			atomic_inc(&osb->alloc_stats.bitmap_data);
+			*num_clusters = res.sr_bits;
 		}
 	}
 	if (status < 0) {
@@ -2214,8 +2218,7 @@ int __ocfs2_claim_clusters(handle_t *handle,
 		goto bail;
 	}
 
-	ac->ac_bits_given += res.sr_bits;
-	*num_clusters = res.sr_bits;
+	ac->ac_bits_given += *num_clusters;
 
 bail:
 	mlog_exit(status);
-- 
1.5.5
