From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 26 Aug 2010 13:06:50 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: properly set and use inode group alloc
	hint
Message-ID: <20100826200650.GP14548@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We were setting ac->ac_last_group in ocfs2_claim_suballoc_bits from
res->sr_bg_blkno.  Unfortunately, res->sr_bg_blkno is going to be zero under
normal (non-fragmented) circumstances. The discontig block group patches
effectively turned off that feature. Fix this by correctly calculating what
the next group hint should be.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
Tested-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
---
 fs/ocfs2/suballoc.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index a8e6a95..da7c31b 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -62,6 +62,17 @@ struct ocfs2_suballoc_result {
 	unsigned int	sr_bits;	/* How many bits we claimed */
 };
 
+static u64 ocfs2_group_from_res(struct ocfs2_suballoc_result *res)
+{
+	if (res->sr_blkno == 0)
+		return 0;
+
+	if (res->sr_bg_blkno)
+		return res->sr_bg_blkno;
+
+	return ocfs2_which_suballoc_group(res->sr_blkno, res->sr_bit_offset);
+}
+
 static inline void ocfs2_debug_bg(struct ocfs2_group_desc *bg);
 static inline void ocfs2_debug_suballoc_inode(struct ocfs2_dinode *fe);
 static inline u16 ocfs2_find_victim_chain(struct ocfs2_chain_list *cl);
@@ -1845,6 +1856,7 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 	int status;
 	u16 victim, i;
 	u16 bits_left = 0;
+	u64 hint = ac->ac_last_group;
 	struct ocfs2_chain_list *cl;
 	struct ocfs2_dinode *fe;
 
@@ -1872,7 +1884,7 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 		goto bail;
 	}
 
-	res->sr_bg_blkno = ac->ac_last_group;
+	res->sr_bg_blkno = hint;
 	if (res->sr_bg_blkno) {
 		/* Attempt to short-circuit the usual search mechanism
 		 * by jumping straight to the most recently used
@@ -1896,8 +1908,10 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 
 	status = ocfs2_search_chain(ac, handle, bits_wanted, min_bits,
 				    res, &bits_left);
-	if (!status)
+	if (!status) {
+		hint = ocfs2_group_from_res(res);
 		goto set_hint;
+	}
 	if (status < 0 && status != -ENOSPC) {
 		mlog_errno(status);
 		goto bail;
@@ -1920,8 +1934,10 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 		ac->ac_chain = i;
 		status = ocfs2_search_chain(ac, handle, bits_wanted, min_bits,
 					    res, &bits_left);
-		if (!status)
+		if (!status) {
+			hint = ocfs2_group_from_res(res);
 			break;
+		}
 		if (status < 0 && status != -ENOSPC) {
 			mlog_errno(status);
 			goto bail;
@@ -1936,7 +1952,7 @@ set_hint:
 		if (bits_left < min_bits)
 			ac->ac_last_group = 0;
 		else
-			ac->ac_last_group = res->sr_bg_blkno;
+			ac->ac_last_group = hint;
 	}
 
 bail:
-- 
1.6.4.2
