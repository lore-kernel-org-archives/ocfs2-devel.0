From: Guozhonghua <guozhonghua@h3c.com>
Date: Thu, 28 Sep 2017 11:14:35 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: remove unused function
	ocfs2_publish_get_mount_state.
Message-ID: <71604351584F6A4EBAE558C676F37CA4D0743232@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Remove unused function ocfs2_publish_get_mount_state.

Signed-off-by: guozhonghua <guozhonghua@h3c.com>
---
 fs/ocfs2/super.h |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ocfs2/super.h b/fs/ocfs2/super.h
index b023e4f..d4550c8 100644
--- a/fs/ocfs2/super.h
+++ b/fs/ocfs2/super.h
@@ -26,9 +26,6 @@
 #ifndef OCFS2_SUPER_H
 #define OCFS2_SUPER_H
 
-int ocfs2_publish_get_mount_state(struct ocfs2_super *osb,
-				  int node_num);
-
 __printf(3, 4)
 int __ocfs2_error(struct super_block *sb, const char *function,
 		   const char *fmt, ...);
-- 
1.7.9.5
