From: Coly Li <coyli@suse.de>
Date: Wed, 05 Nov 2008 15:16:24 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: comments typo fix
Message-ID: <49114848.1090902@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch fixes two typos in comments of ocfs2.

Signed-off-by: Coly Li <coyli@suse.de>
Cc: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlm/userdlm.h |    2 +-
 fs/ocfs2/ocfs2.h       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlm/userdlm.h b/fs/ocfs2/dlm/userdlm.h
index 39ec277..0c3cc03 100644
--- a/fs/ocfs2/dlm/userdlm.h
+++ b/fs/ocfs2/dlm/userdlm.h
@@ -33,7 +33,7 @@
 #include <linux/workqueue.h>

 /* user_lock_res->l_flags flags. */
-#define USER_LOCK_ATTACHED      (0x00000001) /* have we initialized
+#define USER_LOCK_ATTACHED      (0x00000001) /* we have initialized
 					       * the lvb */
 #define USER_LOCK_BUSY          (0x00000002) /* we are currently in
 					       * dlm_lock */
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index a21a465..e91c201 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -85,7 +85,7 @@ enum ocfs2_unlock_action {
 };

 /* ocfs2_lock_res->l_flags flags. */
-#define OCFS2_LOCK_ATTACHED      (0x00000001) /* have we initialized
+#define OCFS2_LOCK_ATTACHED      (0x00000001) /* we have initialized
 					       * the lvb */
 #define OCFS2_LOCK_BUSY          (0x00000002) /* we are currently in
 					       * dlm_lock */


-- 
Coly Li
SuSE PRC Labs
