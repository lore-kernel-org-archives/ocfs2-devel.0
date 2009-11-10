From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon,  9 Nov 2009 16:08:57 -0800
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2: Fix version files
In-Reply-To: <1257811737-10835-1-git-send-email-sunil.mushran@oracle.com>
References: <1257811737-10835-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1257811737-10835-5-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/ver.c  |    8 +++++---
 fs/ocfs2/dlm/dlmfsver.c |    7 ++++---
 fs/ocfs2/dlm/dlmver.c   |    7 ++++---
 fs/ocfs2/ver.c          |   12 +++++++++---
 4 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/cluster/ver.c b/fs/ocfs2/cluster/ver.c
index a56eee6..6ab31de 100644
--- a/fs/ocfs2/cluster/ver.c
+++ b/fs/ocfs2/cluster/ver.c
@@ -28,9 +28,9 @@
 
 #include "ver.h"
 
-#define CLUSTER_BUILD_VERSION "1.5.0"
-
-#define VERSION_STR "OCFS2 Node Manager " CLUSTER_BUILD_VERSION
+#define VERSION_STR "OCFS2 Node Manager " \
+	CLUSTER_BUILD_VERSION " " CLUSTER_BUILD_DATE \
+	" (build " CLUSTER_BUILD_MD5 ")"
 
 void cluster_print_version(void)
 {
@@ -39,4 +39,6 @@ void cluster_print_version(void)
 
 MODULE_DESCRIPTION(VERSION_STR);
 
+#ifdef MODULE_VERSION
 MODULE_VERSION(CLUSTER_BUILD_VERSION);
+#endif
diff --git a/fs/ocfs2/dlm/dlmfsver.c b/fs/ocfs2/dlm/dlmfsver.c
index a733b33..38872d0 100644
--- a/fs/ocfs2/dlm/dlmfsver.c
+++ b/fs/ocfs2/dlm/dlmfsver.c
@@ -28,9 +28,8 @@
 
 #include "dlmfsver.h"
 
-#define DLM_BUILD_VERSION "1.5.0"
-
-#define VERSION_STR "OCFS2 DLMFS " DLM_BUILD_VERSION
+#define VERSION_STR "OCFS2 DLMFS " \
+	DLM_BUILD_VERSION " " DLM_BUILD_DATE " (build " DLM_BUILD_MD5 ")"
 
 void dlmfs_print_version(void)
 {
@@ -39,4 +38,6 @@ void dlmfs_print_version(void)
 
 MODULE_DESCRIPTION(VERSION_STR);
 
+#ifdef MODULE_VERSION
 MODULE_VERSION(DLM_BUILD_VERSION);
+#endif
diff --git a/fs/ocfs2/dlm/dlmver.c b/fs/ocfs2/dlm/dlmver.c
index dfc0da4..71061b9 100644
--- a/fs/ocfs2/dlm/dlmver.c
+++ b/fs/ocfs2/dlm/dlmver.c
@@ -28,9 +28,8 @@
 
 #include "dlmver.h"
 
-#define DLM_BUILD_VERSION "1.5.0"
-
-#define VERSION_STR "OCFS2 DLM " DLM_BUILD_VERSION
+#define VERSION_STR "OCFS2 DLM " \
+	DLM_BUILD_VERSION " " DLM_BUILD_DATE " (build " DLM_BUILD_MD5 ")"
 
 void dlm_print_version(void)
 {
@@ -39,4 +38,6 @@ void dlm_print_version(void)
 
 MODULE_DESCRIPTION(VERSION_STR);
 
+#ifdef MODULE_VERSION
 MODULE_VERSION(DLM_BUILD_VERSION);
+#endif
diff --git a/fs/ocfs2/ver.c b/fs/ocfs2/ver.c
index e2488f4..f715770 100644
--- a/fs/ocfs2/ver.c
+++ b/fs/ocfs2/ver.c
@@ -29,15 +29,21 @@
 
 #include "ver.h"
 
-#define OCFS2_BUILD_VERSION "1.5.0"
-
-#define VERSION_STR "OCFS2 " OCFS2_BUILD_VERSION
+#define VERSION_STR "OCFS2 " \
+	OCFS2_BUILD_VERSION " " OCFS2_BUILD_DATE " (build " OCFS2_BUILD_MD5 ")"
 
 void ocfs2_print_version(void)
 {
 	printk(KERN_INFO "%s\n", VERSION_STR);
 }
 
+int ocfs2_str_version(char *buf)
+{
+	return sprintf(buf, "%s\n", VERSION_STR);
+}
+
 MODULE_DESCRIPTION(VERSION_STR);
 
+#ifdef MODULE_VERSION
 MODULE_VERSION(OCFS2_BUILD_VERSION);
+#endif
-- 
1.5.6.5
