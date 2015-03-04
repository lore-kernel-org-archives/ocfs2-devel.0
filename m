From: Masanari Iida <standby24x7@gmail.com>
Date: Wed,  4 Mar 2015 12:51:35 +0900
Subject: [Ocfs2-devel] [PATCH] fs:ocfs2: Fix typo in MODULE_DESCRIPTION in
	stackglue.c
Message-ID: <1425441095-12823-1-git-send-email-standby24x7@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, jlbec@evilplan.org, mfasheh@suse.com, ocfs2-devel@oss.oracle.com
Cc: Masanari Iida <standby24x7@gmail.com>

This patch fix spelling typo in MODULE_DESCRIPTION within stackglue.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 fs/ocfs2/stackglue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 5d965e8..8e59bb3 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -742,7 +742,7 @@ static void __exit ocfs2_stack_glue_exit(void)
 }
 
 MODULE_AUTHOR("Oracle");
-MODULE_DESCRIPTION("ocfs2 cluter stack glue layer");
+MODULE_DESCRIPTION("ocfs2 cluster stack glue layer");
 MODULE_LICENSE("GPL");
 module_init(ocfs2_stack_glue_init);
 module_exit(ocfs2_stack_glue_exit);
-- 
2.3.1.167.g7f4ba4b
