From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue Mar 11 16:32:15 2008
Subject: [Ocfs2-devel] [PATCH 01/18] ocfs2: Add helper task_pid_nr
In-Reply-To: <1205278329-11111-1-git-send-email-sunil.mushran@oracle.com>
References: <1205278329-11111-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1205278329-11111-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit 7af5729474b5b8ad385adadab78d6e723e7655a3 in mainline introduced
helper task_pid_nr(). This patch allows one to build ocfs2 with kernels
having/not having that change.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Makefile                          |    3 ++-
 configure.in                      |    5 +++++
 kapi-compat/include/task_pid_nr.h |   12 ++++++++++++
 3 files changed, 19 insertions(+), 1 deletions(-)
 create mode 100644 kapi-compat/include/task_pid_nr.h

diff --git a/Makefile b/Makefile
index 8e17890..0768cd0 100644
--- a/Makefile
+++ b/Makefile
@@ -32,7 +32,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/blkcnt_t.h \
 	kapi-compat/include/read_mapping_page.h \
 	kapi-compat/include/aiovec.h \
-	kapi-compat/include/mandatory_lock.h
+	kapi-compat/include/mandatory_lock.h \
+	kapi-compat/include/task_pid_nr.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index f3544b0..df2dcc6 100644
--- a/configure.in
+++ b/configure.in
@@ -420,6 +420,11 @@ OCFS2_CHECK_KERNEL([fops->sendfile() in fs.h], fs.h,
   HAS_FOPS_SENDFILE=yes, , [^.*ssize_t (\*sendfile)])
 AC_SUBST(HAS_FOPS_SENDFILE)
 
+task_pid_nr_compat_header=""
+OCFS2_CHECK_KERNEL([task_pid_nr in sched.h], sched.h,
+  , task_pid_nr_compat_header="task_pid_nr.h", [^static inline pid_t task_pid_nr(struct])
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $task_pid_nr_compat_header"
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
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
1.5.3.4
