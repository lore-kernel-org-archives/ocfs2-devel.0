From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon,  9 Nov 2009 18:00:06 -0800
Subject: [Ocfs2-devel] [PATCH 03/10] ocfs2: Add helper task_pid_nr()
In-Reply-To: <1257818413-32014-1-git-send-email-sunil.mushran@oracle.com>
References: <1257818413-32014-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1257818413-32014-4-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 7af5729474b5b8ad385adadab78d6e723e7655a3 added a helper
to obtain the pid number.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Makefile                          |    3 ++-
 configure.in                      |    5 +++++
 kapi-compat/include/task_pid_nr.h |   12 ++++++++++++
 3 files changed, 19 insertions(+), 1 deletions(-)
 create mode 100644 kapi-compat/include/task_pid_nr.h

diff --git a/Makefile b/Makefile
index d038ae9..98726c9 100644
--- a/Makefile
+++ b/Makefile
@@ -10,7 +10,8 @@ LINUX_INCLUDE_FILES =
 
 KAPI_COMPAT_FILES = \
 	kapi-compat/include/workqueue.h			\
-	kapi-compat/include/dlmconstants.h
+	kapi-compat/include/dlmconstants.h		\
+	kapi-compat/include/task_pid_nr.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index f67de02..e94412b 100644
--- a/configure.in
+++ b/configure.in
@@ -170,6 +170,11 @@ OCFS2_CHECK_KERNEL([dlmconstants.h], dlmconstants.h,
 AC_SUBST(NO_DLMCONSTANTS_HEADER)
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS dlmconstants.h"
 
+task_pid_nr_compat_header=
+OCFS2_CHECK_KERNEL([task_pid_nr() in sched.h], sched.h,
+  , task_pid_nr_compat_header="task_pid_nr.h", [^static inline pid_t task_pid_nr(struct])
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $task_pid_nr_compat_header"
+
 
 # End kapi_compat checks
 
diff --git a/kapi-compat/include/task_pid_nr.h b/kapi-compat/include/task_pid_nr.h
new file mode 100644
index 0000000..bd69a75
--- /dev/null
+++ b/kapi-compat/include/task_pid_nr.h
@@ -0,0 +1,12 @@
+#ifndef KAPI_TASK_PID_NR_H
+#define KAPI_TASK_PID_NR_H
+
+#include <linux/types.h>
+#include <linux/sched.h>
+
+static inline pid_t task_pid_nr(struct task_struct *tsk)
+{
+        return tsk->pid;
+}
+
+#endif
-- 
1.5.6.5
