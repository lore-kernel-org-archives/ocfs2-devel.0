From: Guozhonghua <guozhonghua@h3c.com>
Date: Mon, 12 Aug 2019 11:06:25 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: The function ocfs2_orphan_scan_exit is
 declared, but not implemented and called, so as to be removed.
Message-ID: <71604351584F6A4EBAE558C676F37CA4014FC208AC@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2: The function ocfs2_orphan_scan_exit is declared, but not implemented and called, so as to be removed.
Add two space before and after the character *. 

Signed-off-by: guozhonghua <guozhonghua@h3c.com>

---
 fs/ocfs2/journal.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index c0fe6ed08ab1..f1479d22e998 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -144,7 +144,6 @@ static inline void ocfs2_ci_set_new(struct ocfs2_super *osb,
 void ocfs2_orphan_scan_init(struct ocfs2_super *osb);
 void ocfs2_orphan_scan_start(struct ocfs2_super *osb);
 void ocfs2_orphan_scan_stop(struct ocfs2_super *osb);
-void ocfs2_orphan_scan_exit(struct ocfs2_super *osb);
 
 void ocfs2_complete_recovery(struct work_struct *work);
 void ocfs2_wait_for_recovery(struct ocfs2_super *osb);
@@ -441,7 +440,7 @@ static inline int ocfs2_mknod_credits(struct super_block *sb, int is_dir,
  * previous dirblock update in the free list */
 static inline int ocfs2_link_credits(struct super_block *sb)
 {
-	return 2*OCFS2_INODE_UPDATE_CREDITS + 4 +
+	return 2 * OCFS2_INODE_UPDATE_CREDITS + 4 +
 	       ocfs2_quota_trans_credits(sb);
 }
 
-- 
2.12.1.windows.1
