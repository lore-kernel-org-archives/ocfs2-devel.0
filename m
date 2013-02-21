From: xiaowei.hu at oracle.com <xiaowei.hu@oracle.com>
Date: Thu, 21 Feb 2013 15:54:19 +0800
Subject: [Ocfs2-devel] [PATCH] the ac->ac_allow_chain_relink=0 won't disable
	group relink
Message-ID: <1361433259-15336-1-git-send-email-xiaowei.hu@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: "Xiaowei.Hu" <xiaowei.hu@oracle.com>

ocfs2_block_group_alloc_discontig() disables chain relink by setting
ac->ac_allow_chain_relink = 0 because it grabs clusters from multiple
cluster groups. It doesn't keep the credits for all chain relink,but
ocfs2_claim_suballoc_bits overrides this in this call trace:
ocfs2_block_group_claim_bits()->ocfs2_claim_clusters()->
__ocfs2_claim_clusters()->ocfs2_claim_suballoc_bits()
ocfs2_claim_suballoc_bits set ac->ac_allow_chain_relink = 1; then call
ocfs2_search_chain() one time and disable it again, and then we run
out of credits.

Fix is to allow relink by default and disable it in
ocfs2_block_group_alloc_discontig.

Signed-off-by: Xiaowei.Hu <xiaowei.hu@oracle.com>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
---
 fs/ocfs2/suballoc.c | 7 +++----
 fs/ocfs2/suballoc.h | 2 +-
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 4b5e568..033bfc6 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -642,7 +642,7 @@ ocfs2_block_group_alloc_discontig(handle_t *handle,
 	 * cluster groups will be staying in cache for the duration of
 	 * this operation.
 	 */
-	ac->ac_allow_chain_relink = 0;
+	ac->ac_disable_chain_relink = 1;
 
 	/* Claim the first region */
 	status = ocfs2_block_group_claim_bits(osb, handle, ac, min_bits,
@@ -1823,7 +1823,7 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 	 * Do this *after* figuring out how many bits we're taking out
 	 * of our target group.
 	 */
-	if (ac->ac_allow_chain_relink &&
+	if (!ac->ac_disable_chain_relink &&
 	    (prev_group_bh) &&
 	    (ocfs2_block_group_reasonably_empty(bg, res->sr_bits))) {
 		status = ocfs2_relink_block_group(handle, alloc_inode,
@@ -1928,7 +1928,6 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 
 	victim = ocfs2_find_victim_chain(cl);
 	ac->ac_chain = victim;
-	ac->ac_allow_chain_relink = 1;
 
 	status = ocfs2_search_chain(ac, handle, bits_wanted, min_bits,
 				    res, &bits_left);
@@ -1947,7 +1946,7 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 	 * searching each chain in order. Don't allow chain relinking
 	 * because we only calculate enough journal credits for one
 	 * relink per alloc. */
-	ac->ac_allow_chain_relink = 0;
+	ac->ac_disable_chain_relink = 1;
 	for (i = 0; i < le16_to_cpu(cl->cl_next_free_rec); i ++) {
 		if (i == victim)
 			continue;
diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
index b8afabf..a36d0aa 100644
--- a/fs/ocfs2/suballoc.h
+++ b/fs/ocfs2/suballoc.h
@@ -49,7 +49,7 @@ struct ocfs2_alloc_context {
 
 	/* these are used by the chain search */
 	u16    ac_chain;
-	int    ac_allow_chain_relink;
+	int    ac_disable_chain_relink;
 	group_search_t *ac_group_search;
 
 	u64    ac_last_group;
-- 
1.7.11.7
