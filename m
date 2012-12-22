From: Xue jiufei <xuejiufei@huawei.com>
Date: Sat, 22 Dec 2012 15:04:44 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: detect chain loop in ocfs2_search_chain
Message-ID: <50D55B8C.6030008@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  Detects a chain loop by keeping a count of the descriptores read. 
If a loop is found, flag an error and set filesystem readonly.

Signed-off-by: xuejiufei <xuejiufei@huawei.com>
---
 fs/ocfs2/suballoc.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index f169da4..de1f947 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1742,7 +1742,7 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 			      u16 *bits_left)
 {
 	int status;
-	u16 chain;
+	u16 chain, num_gds, max_chain_len, chain_len = 0;
 	u64 next_group;
 	struct inode *alloc_inode = ac->ac_inode;
 	struct buffer_head *group_bh = NULL;
@@ -1751,6 +1751,10 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 	struct ocfs2_chain_list *cl = (struct ocfs2_chain_list *) &fe->id2.i_chain;
 	struct ocfs2_group_desc *bg;
 
+	/* Calculate the max chain length */
+	num_gds = (fe->i_clusters + cl->cl_cpg) / cl->cl_cpg;
+	max_chain_len = (num_gds + cl->cl_count) / cl->cl_count;
+
 	chain = ac->ac_chain;
 	trace_ocfs2_search_chain_begin(
 		(unsigned long long)OCFS2_I(alloc_inode)->ip_blkno,
@@ -1775,6 +1779,15 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 		if (!bg->bg_next_group)
 			break;
 
+		if (++chain_len > max_chain_len) {
+			ocfs2_error(alloc_inode->i_sb, "chain %d "
+					"exceeds the max chain length %d, group block (%llu)",
+					chain, max_chain_len,
+					(unsigned long long)group_bh->b_blocknr);
+			status = -EIO;
+			goto bail;
+		}
+
 		brelse(prev_group_bh);
 		prev_group_bh = NULL;
 
-- 
1.7.8.6
