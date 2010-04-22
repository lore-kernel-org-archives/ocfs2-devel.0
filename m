From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 22 Apr 2010 14:40:19 +0800
Subject: [Ocfs2-devel] [PATCH 05/17] ocfs2: ocfs2_claim_suballoc_bits()
	doesn't need an osb argument.
In-Reply-To: <4BCFEF22.7080607@oracle.com>
References: <4BCFEF22.7080607@oracle.com>
Message-ID: <1271918431-8135-5-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Joel Becker <joel.becker@oracle.com>

It's contained on ac->ac_inode->i_sb anyway.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/suballoc.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index bc1d6b7..13b69ef 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -86,8 +86,7 @@ static int ocfs2_block_group_search(struct inode *inode,
 				    u32 bits_wanted, u32 min_bits,
 				    u64 max_block,
 				    struct ocfs2_suballoc_result *res);
-static int ocfs2_claim_suballoc_bits(struct ocfs2_super *osb,
-				     struct ocfs2_alloc_context *ac,
+static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 				     handle_t *handle,
 				     u32 bits_wanted,
 				     u32 min_bits,
@@ -1768,8 +1767,7 @@ bail:
 }
 
 /* will give out up to bits_wanted contiguous bits. */
-static int ocfs2_claim_suballoc_bits(struct ocfs2_super *osb,
-				     struct ocfs2_alloc_context *ac,
+static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 				     handle_t *handle,
 				     u32 bits_wanted,
 				     u32 min_bits,
@@ -1795,7 +1793,8 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_super *osb,
 
 	if (le32_to_cpu(fe->id1.bitmap1.i_used) >=
 	    le32_to_cpu(fe->id1.bitmap1.i_total)) {
-		ocfs2_error(osb->sb, "Chain allocator dinode %llu has %u used "
+		ocfs2_error(ac->ac_inode->i_sb,
+			    "Chain allocator dinode %llu has %u used "
 			    "bits but only %u total.",
 			    (unsigned long long)le64_to_cpu(fe->i_blkno),
 			    le32_to_cpu(fe->id1.bitmap1.i_used),
@@ -1891,8 +1890,7 @@ int ocfs2_claim_metadata(struct ocfs2_super *osb,
 	BUG_ON(ac->ac_bits_wanted < (ac->ac_bits_given + bits_wanted));
 	BUG_ON(ac->ac_which != OCFS2_AC_USE_META);
 
-	status = ocfs2_claim_suballoc_bits(osb,
-					   ac,
+	status = ocfs2_claim_suballoc_bits(ac,
 					   handle,
 					   bits_wanted,
 					   1,
@@ -1964,8 +1962,7 @@ int ocfs2_claim_new_inode(struct ocfs2_super *osb,
 
 	ocfs2_init_inode_ac_group(dir, parent_fe_bh, ac);
 
-	status = ocfs2_claim_suballoc_bits(osb,
-					   ac,
+	status = ocfs2_claim_suballoc_bits(ac,
 					   handle,
 					   1,
 					   1,
@@ -2093,8 +2090,7 @@ int __ocfs2_claim_clusters(struct ocfs2_super *osb,
 		if (bits_wanted > (osb->bitmap_cpg - 1))
 			bits_wanted = osb->bitmap_cpg - 1;
 
-		status = ocfs2_claim_suballoc_bits(osb,
-						   ac,
+		status = ocfs2_claim_suballoc_bits(ac,
 						   handle,
 						   bits_wanted,
 						   min_clusters,
-- 
1.5.5
