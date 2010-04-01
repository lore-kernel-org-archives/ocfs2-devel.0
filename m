From: Tao Ma <tao.ma@oracle.com>
Date: Thu,  1 Apr 2010 10:59:03 +0800
Subject: [Ocfs2-devel] [PATCH 06/15] ocfs2: Trim suballocations if they
	cross discontiguous regions
In-Reply-To: <4BB40AB4.8040205@oracle.com>
References: <4BB40AB4.8040205@oracle.com>
Message-ID: <1270090752-18935-6-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Joel Becker <joel.becker@oracle.com>

A discontiguous block group can find a range of free bits that straddle
more than one region of its space.  Callers can't handle that, so we
trim the returned bits until they fit within one region.

Only cluster allocations ask for min_bits>1.  Discontiguous block groups
are only for block allocations.  So min_bits doesn't matter here.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/suballoc.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 298fb54..1910f09 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1619,6 +1619,48 @@ out:
 	return ret;
 }
 
+static int ocfs2_bg_discontig_trim_by_rec(struct ocfs2_suballoc_result *res,
+					  struct ocfs2_extent_rec *rec,
+					  struct ocfs2_chain_list *cl)
+{
+	unsigned int bpc = le16_to_cpu(cl->cl_bpc);
+	unsigned int bitoff = le32_to_cpu(rec->e_cpos) * bpc;
+	unsigned int bitcount = le32_to_cpu(rec->e_leaf_clusters) * bpc;
+
+	if (res->sr_bit_offset < bitoff)
+		return 0;
+	if (res->sr_bit_offset >= (bitoff + bitcount))
+		return 0;
+	if ((res->sr_bit_offset + res->sr_bits) > (bitoff + bitcount))
+		res->sr_bits = (bitoff + bitcount) - res->sr_bit_offset;
+	return 1;
+}
+
+static void ocfs2_bg_discontig_trim_result(struct ocfs2_alloc_context *ac,
+					   struct ocfs2_group_desc *bg,
+					   struct ocfs2_suballoc_result *res)
+{
+	int i;
+	struct ocfs2_extent_rec *rec;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)ac->ac_bh->b_data;
+	struct ocfs2_chain_list *cl = &di->id2.i_chain;
+
+	if (!ocfs2_supports_discontig_bh(OCFS2_SB(ac->ac_inode->i_sb)))
+		return;
+
+	if (ocfs2_is_cluster_bitmap(ac->ac_inode))
+		return;
+
+	if (!bg->bg_list.l_next_free_rec)
+		return;
+
+	for (i = 0; i < le16_to_cpu(bg->bg_list.l_next_free_rec); i++) {
+		rec = &bg->bg_list.l_recs[i];
+		if (ocfs2_bg_discontig_trim_by_rec(res, rec, cl))
+			break;
+	}
+}
+
 static int ocfs2_search_one_group(struct ocfs2_alloc_context *ac,
 				  handle_t *handle,
 				  u32 bits_wanted,
@@ -1648,6 +1690,9 @@ static int ocfs2_search_one_group(struct ocfs2_alloc_context *ac,
 		goto out;
 	}
 
+	if (!ret)
+		ocfs2_bg_discontig_trim_result(ac, gd, res);
+
 	ret = ocfs2_alloc_dinode_update_counts(alloc_inode, handle, ac->ac_bh,
 					       res->sr_bits,
 					       le16_to_cpu(gd->bg_chain));
@@ -1737,6 +1782,9 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 	res->sr_bg_blkno = le64_to_cpu(bg->bg_blkno);
 
 	BUG_ON(res->sr_bits == 0);
+	if (!status)
+		ocfs2_bg_discontig_trim_result(ac, bg, res);
+
 
 	/*
 	 * Keep track of previous block descriptor read. When
-- 
1.5.5
