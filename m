From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 22 Apr 2010 14:40:22 +0800
Subject: [Ocfs2-devel] [PATCH 08/17] ocfs2: Return allocated metadata blknos
	on the ocfs2_suballoc_result.
In-Reply-To: <4BCFEF22.7080607@oracle.com>
References: <4BCFEF22.7080607@oracle.com>
Message-ID: <1271918431-8135-8-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Joel Becker <joel.becker@oracle.com>

Rather than calculating the resulting block number, return it on the
ocfs2_suballoc_result structure.  This way we can calculate block
numbers for discontiguous block groups.

Cluster groups keep doing it the old way.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/suballoc.c |   43 ++++++++++++++++++++++++-------------------
 1 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 34f3fbb..424c62f 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -55,6 +55,7 @@
 
 struct ocfs2_suballoc_result {
 	u64		sr_bg_blkno;	/* The bg we allocated from */
+	u64		sr_blkno;	/* The first allocated block */
 	unsigned int	sr_bit_offset;	/* The bit in the bg */
 	unsigned int	sr_bits;	/* How many bits we claimed */
 };
@@ -1583,9 +1584,9 @@ out:
 	return ret;
 }
 
-static int ocfs2_bg_discontig_trim_by_rec(struct ocfs2_suballoc_result *res,
-					  struct ocfs2_extent_rec *rec,
-					  struct ocfs2_chain_list *cl)
+static int ocfs2_bg_discontig_fix_by_rec(struct ocfs2_suballoc_result *res,
+					 struct ocfs2_extent_rec *rec,
+					 struct ocfs2_chain_list *cl)
 {
 	unsigned int bpc = le16_to_cpu(cl->cl_bpc);
 	unsigned int bitoff = le32_to_cpu(rec->e_cpos) * bpc;
@@ -1595,32 +1596,35 @@ static int ocfs2_bg_discontig_trim_by_rec(struct ocfs2_suballoc_result *res,
 		return 0;
 	if (res->sr_bit_offset >= (bitoff + bitcount))
 		return 0;
+	res->sr_blkno = le64_to_cpu(rec->e_blkno) +
+		(res->sr_bit_offset - bitoff);
 	if ((res->sr_bit_offset + res->sr_bits) > (bitoff + bitcount))
 		res->sr_bits = (bitoff + bitcount) - res->sr_bit_offset;
 	return 1;
 }
 
-static void ocfs2_bg_discontig_trim_result(struct ocfs2_alloc_context *ac,
-					   struct ocfs2_group_desc *bg,
-					   struct ocfs2_suballoc_result *res)
+static void ocfs2_bg_discontig_fix_result(struct ocfs2_alloc_context *ac,
+					  struct ocfs2_group_desc *bg,
+					  struct ocfs2_suballoc_result *res)
 {
 	int i;
 	struct ocfs2_extent_rec *rec;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)ac->ac_bh->b_data;
 	struct ocfs2_chain_list *cl = &di->id2.i_chain;
 
-	if (!ocfs2_supports_discontig_bh(OCFS2_SB(ac->ac_inode->i_sb)))
-		return;
-
-	if (ocfs2_is_cluster_bitmap(ac->ac_inode))
+	if (ocfs2_is_cluster_bitmap(ac->ac_inode)) {
+		res->sr_blkno = 0;
 		return;
+	}
 
-	if (!bg->bg_list.l_next_free_rec)
+	res->sr_blkno = res->sr_bg_blkno + res->sr_bit_offset;
+	if (!ocfs2_supports_discontig_bh(OCFS2_SB(ac->ac_inode->i_sb)) ||
+	    !bg->bg_list.l_next_free_rec)
 		return;
 
 	for (i = 0; i < le16_to_cpu(bg->bg_list.l_next_free_rec); i++) {
 		rec = &bg->bg_list.l_recs[i];
-		if (ocfs2_bg_discontig_trim_by_rec(res, rec, cl))
+		if (ocfs2_bg_discontig_fix_by_rec(res, rec, cl))
 			break;
 	}
 }
@@ -1655,7 +1659,7 @@ static int ocfs2_search_one_group(struct ocfs2_alloc_context *ac,
 	}
 
 	if (!ret)
-		ocfs2_bg_discontig_trim_result(ac, gd, res);
+		ocfs2_bg_discontig_fix_result(ac, gd, res);
 
 	ret = ocfs2_alloc_dinode_update_counts(alloc_inode, handle, ac->ac_bh,
 					       res->sr_bits,
@@ -1747,7 +1751,7 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 
 	BUG_ON(res->sr_bits == 0);
 	if (!status)
-		ocfs2_bg_discontig_trim_result(ac, bg, res);
+		ocfs2_bg_discontig_fix_result(ac, bg, res);
 
 
 	/*
@@ -1931,7 +1935,7 @@ int ocfs2_claim_metadata(handle_t *handle,
 			 u64 *blkno_start)
 {
 	int status;
-	struct ocfs2_suballoc_result res;
+	struct ocfs2_suballoc_result res = { .sr_blkno = 0, };
 
 	BUG_ON(!ac);
 	BUG_ON(ac->ac_bits_wanted < (ac->ac_bits_given + bits_wanted));
@@ -1949,7 +1953,7 @@ int ocfs2_claim_metadata(handle_t *handle,
 	atomic_inc(&OCFS2_SB(ac->ac_inode->i_sb)->alloc_stats.bg_allocs);
 
 	*suballoc_bit_start = res.sr_bit_offset;
-	*blkno_start = res.sr_bg_blkno + (u64)(res.sr_bit_offset);
+	*blkno_start = res.sr_blkno;
 	ac->ac_bits_given += res.sr_bits;
 	*num_bits = res.sr_bits;
 	status = 0;
@@ -1997,7 +2001,7 @@ int ocfs2_claim_new_inode(handle_t *handle,
 			  u64 *fe_blkno)
 {
 	int status;
-	struct ocfs2_suballoc_result res;
+	struct ocfs2_suballoc_result res = { .sr_blkno = 0, };
 
 	mlog_entry_void();
 
@@ -2022,7 +2026,7 @@ int ocfs2_claim_new_inode(handle_t *handle,
 	BUG_ON(res.sr_bits != 1);
 
 	*suballoc_bit = res.sr_bit_offset;
-	*fe_blkno = res.sr_bg_blkno + (u64)(res.sr_bit_offset);
+	*fe_blkno = res.sr_blkno;
 	ac->ac_bits_given++;
 	ocfs2_save_inode_ac_group(dir, ac);
 	status = 0;
@@ -2101,7 +2105,7 @@ int __ocfs2_claim_clusters(handle_t *handle,
 {
 	int status;
 	unsigned int bits_wanted = max_clusters;
-	struct ocfs2_suballoc_result res;
+	struct ocfs2_suballoc_result res = { .sr_blkno = 0, };
 	struct ocfs2_super *osb = OCFS2_SB(ac->ac_inode->i_sb);
 
 	mlog_entry_void();
@@ -2142,6 +2146,7 @@ int __ocfs2_claim_clusters(handle_t *handle,
 						   min_clusters,
 						   &res);
 		if (!status) {
+			BUG_ON(res.sr_blkno); /* cluster alloc can't set */
 			*cluster_start =
 				ocfs2_desc_bitmap_to_cluster_off(ac->ac_inode,
 								 res.sr_bg_blkno,
-- 
1.5.5
