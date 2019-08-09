From: Guozhonghua <guozhonghua@h3c.com>
Date: Fri, 9 Aug 2019 08:26:59 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: The function
 ocfs2_calc_tree_trunc_credits is not used anymore, so as to be removed.
Message-ID: <71604351584F6A4EBAE558C676F37CA4014FC2050F@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


ocfs2: The function ocfs2_calc_tree_trunc_credits is not called anywhere, it is not used anymore, so as to be removed.

Signed-off-by: guozhonghua <guozhonghua@h3c.com>

---
 fs/ocfs2/journal.h | 28 ----------------------------
 1 file changed, 28 deletions(-)

diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index c0fe6ed08ab1..ad766a7761ad 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -575,34 +575,6 @@ static inline int ocfs2_calc_bg_discontig_credits(struct super_block *sb)
 	return ocfs2_extent_recs_per_gd(sb);
 }
 
-static inline int ocfs2_calc_tree_trunc_credits(struct super_block *sb,
-						unsigned int clusters_to_del,
-						struct ocfs2_dinode *fe,
-						struct ocfs2_extent_list *last_el)
-{
- 	/* for dinode + all headers in this pass + update to next leaf */
-	u16 next_free = le16_to_cpu(last_el->l_next_free_rec);
-	u16 tree_depth = le16_to_cpu(fe->id2.i_list.l_tree_depth);
-	int credits = 1 + tree_depth + 1;
-	int i;
-
-	i = next_free - 1;
-	BUG_ON(i < 0);
-
-	/* We may be deleting metadata blocks, so metadata alloc dinode +
-	   one desc. block for each possible delete. */
-	if (tree_depth && next_free == 1 &&
-	    ocfs2_rec_clusters(last_el, &last_el->l_recs[i]) == clusters_to_del)
-		credits += 1 + tree_depth;
-
-	/* update to the truncate log. */
-	credits += OCFS2_TRUNCATE_LOG_UPDATE;
-
-	credits += ocfs2_quota_trans_credits(sb);
-
-	return credits;
-}
-
 static inline int ocfs2_jbd2_file_inode(handle_t *handle, struct inode *inode)
 {
 	return jbd2_journal_inode_add_write(handle, &OCFS2_I(inode)->ip_jinode);
-- 
2.12.1.windows.1
