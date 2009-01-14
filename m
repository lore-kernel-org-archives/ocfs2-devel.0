From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 13 Jan 2009 17:47:12 -0800
Subject: [Ocfs2-devel] [PATCH 07/15] ocfs2: comments typo fix
In-Reply-To: <1231897640-31410-1-git-send-email-sunil.mushran@oracle.com>
References: <1231897640-31410-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1231897640-31410-8-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Coly Li <coyli@suse.de>

Mainline commit 3b5da0189c93160e44b878d2c72e9552d642497c

This patch fixes two typos in comments of ocfs2.

Signed-off-by: Coly Li <coyli@suse.de>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
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
index 7b2a9a8..83a30a0 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -83,7 +83,7 @@ enum ocfs2_unlock_action {
 };
 
 /* ocfs2_lock_res->l_flags flags. */
-#define OCFS2_LOCK_ATTACHED      (0x00000001) /* have we initialized
+#define OCFS2_LOCK_ATTACHED      (0x00000001) /* we have initialized
 					       * the lvb */
 #define OCFS2_LOCK_BUSY          (0x00000002) /* we are currently in
 					       * dlm_lock */
-- 
1.5.6.3
