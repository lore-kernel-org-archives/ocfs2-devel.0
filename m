From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 20 Nov 2009 17:12:57 -0800
Subject: [Ocfs2-devel] [PATCH 10/10] ocfs2: Handle missing cancel_work_sync()
In-Reply-To: <1258765977-4334-1-git-send-email-sunil.mushran@oracle.com>
References: <1258765977-4334-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1258765977-4334-11-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 28e53bddf814485699a4142bc056fd37d4e11dd4 added helper
cancel_work_sync(). The patch adds a helper with the same name that
cancels pending work and flushes the workqueues.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Makefile                               |    3 ++-
 configure.in                           |    5 +++++
 kapi-compat/include/cancel_work_sync.h |   14 ++++++++++++++
 3 files changed, 21 insertions(+), 1 deletions(-)
 create mode 100644 kapi-compat/include/cancel_work_sync.h

diff --git a/Makefile b/Makefile
index 07adc70..f285238 100644
--- a/Makefile
+++ b/Makefile
@@ -40,7 +40,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/hardsect.h			\
 	kapi-compat/include/triggers.h			\
 	kapi-compat/include/compat_kobject.h		\
-	kapi-compat/include/quotas.h
+	kapi-compat/include/quotas.h			\
+	kapi-compat/include/cancel_work_sync.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index 9913820..405e1a5 100644
--- a/configure.in
+++ b/configure.in
@@ -454,6 +454,11 @@ KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $SKIP_QUOTAS"
 
 SKIP_EXPORTS=yes
 
+cancel_work_sync_header=
+OCFS2_CHECK_KERNEL([cancel_work_sync() in workqueue.h], workqueue.h,
+ , cancel_work_sync_header=cancel_work_sync.h, [extern int cancel_work_sync(struct work_struct])
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $cancel_work_sync_header"
+
 # End kapi_compat checks
 
 # using -include has two advantages:
diff --git a/kapi-compat/include/cancel_work_sync.h b/kapi-compat/include/cancel_work_sync.h
new file mode 100644
index 0000000..226362e
--- /dev/null
+++ b/kapi-compat/include/cancel_work_sync.h
@@ -0,0 +1,14 @@
+#ifndef KAPI_CANCEL_WORK_SYNC_H
+#define KAPI_CANCEL_WORK_SYNC_H
+
+static inline int cancel_work_sync(struct work_struct *work)
+{
+	int ret;
+
+	ret = cancel_delayed_work(work);
+	if (!ret)              
+		flush_scheduled_work();
+	return ret;
+}
+
+#endif
-- 
1.5.6.5
