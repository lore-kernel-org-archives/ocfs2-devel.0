From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon,  9 Nov 2009 18:00:08 -0800
Subject: [Ocfs2-devel] [PATCH 05/10] ocfs2: Add helper current_umask()
In-Reply-To: <1257818413-32014-1-git-send-email-sunil.mushran@oracle.com>
References: <1257818413-32014-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1257818413-32014-6-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit ce3b0f8d5c2203301fc87f3aaaed73e5819e2a48 adde helper
current_umask().

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Makefile                            |    3 ++-
 configure.in                        |    5 +++++
 kapi-compat/include/current_umask.h |    9 +++++++++
 3 files changed, 16 insertions(+), 1 deletions(-)
 create mode 100644 kapi-compat/include/current_umask.h

diff --git a/Makefile b/Makefile
index 98726c9..950d6fc 100644
--- a/Makefile
+++ b/Makefile
@@ -11,7 +11,8 @@ LINUX_INCLUDE_FILES =
 KAPI_COMPAT_FILES = \
 	kapi-compat/include/workqueue.h			\
 	kapi-compat/include/dlmconstants.h		\
-	kapi-compat/include/task_pid_nr.h
+	kapi-compat/include/task_pid_nr.h		\
+	kapi-compat/include/current_umask.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index e94412b..93f9632 100644
--- a/configure.in
+++ b/configure.in
@@ -175,6 +175,11 @@ OCFS2_CHECK_KERNEL([task_pid_nr() in sched.h], sched.h,
   , task_pid_nr_compat_header="task_pid_nr.h", [^static inline pid_t task_pid_nr(struct])
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $task_pid_nr_compat_header"
 
+current_umask_compat_header=
+OCFS2_CHECK_KERNEL([current_umask() in fs.h], fs.h,
+ , current_umask_compat_header="current_umask.h", [^extern int current_umask(void)])
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $current_umask_compat_header"
+
 
 # End kapi_compat checks
 
diff --git a/kapi-compat/include/current_umask.h b/kapi-compat/include/current_umask.h
new file mode 100644
index 0000000..eee781f
--- /dev/null
+++ b/kapi-compat/include/current_umask.h
@@ -0,0 +1,9 @@
+#ifndef KAPI_CURRENT_UMASK_H
+#define KAPI_CURRENT_UMASK_H
+
+static inline int current_umask(void)
+{
+	return current->fs->umask;
+}
+
+#endif
-- 
1.5.6.5
