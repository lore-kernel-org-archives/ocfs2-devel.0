From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 12 May 2008 18:31:36 -0700
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2/dlm: Silence build warnings
In-Reply-To: <1210642297-23180-1-git-send-email-sunil.mushran@oracle.com>
References: <1210642297-23180-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1210642297-23180-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch silences the build warnings concerning dlm_debug_init()
and friends when building without CONFIG_DEBUG_FS enabled.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmdebug.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdebug.h b/fs/ocfs2/dlm/dlmdebug.h
index d34a62a..8c686d2 100644
--- a/fs/ocfs2/dlm/dlmdebug.h
+++ b/fs/ocfs2/dlm/dlmdebug.h
@@ -60,25 +60,25 @@ void dlm_destroy_debugfs_root(void);
 
 #else
 
-static int dlm_debug_init(struct dlm_ctxt *dlm)
+static inline int dlm_debug_init(struct dlm_ctxt *dlm)
 {
 	return 0;
 }
-static void dlm_debug_shutdown(struct dlm_ctxt *dlm)
+static inline void dlm_debug_shutdown(struct dlm_ctxt *dlm)
 {
 }
-static int dlm_create_debugfs_subroot(struct dlm_ctxt *dlm)
+static inline int dlm_create_debugfs_subroot(struct dlm_ctxt *dlm)
 {
 	return 0;
 }
-static void dlm_destroy_debugfs_subroot(struct dlm_ctxt *dlm)
+static inline void dlm_destroy_debugfs_subroot(struct dlm_ctxt *dlm)
 {
 }
-static int dlm_create_debugfs_root(void)
+static inline int dlm_create_debugfs_root(void)
 {
 	return 0;
 }
-static void dlm_destroy_debugfs_root(void)
+static inline void dlm_destroy_debugfs_root(void)
 {
 }
 
-- 
1.5.3.6
