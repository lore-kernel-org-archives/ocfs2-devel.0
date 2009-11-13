From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 12 Nov 2009 17:47:30 -0800
Subject: [Ocfs2-devel] [PATCH 09/18] ocfs2: Handle missing helper
	kernel_sock_shutdown()
In-Reply-To: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
References: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1258076859-13538-10-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 91cf45f02af5c871251165d000c3f42a2a0b0552 added helper
kernel_sock_shutdown().

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Makefile                            |    3 ++-
 configure.in                        |    5 +++++
 kapi-compat/include/sock_shutdown.h |   17 +++++++++++++++++
 3 files changed, 24 insertions(+), 1 deletions(-)
 create mode 100644 kapi-compat/include/sock_shutdown.h

diff --git a/Makefile b/Makefile
index 623bda4..0dd7443 100644
--- a/Makefile
+++ b/Makefile
@@ -28,7 +28,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/blkdev_put.h		\
 	kapi-compat/include/blkdev_get.h		\
 	kapi-compat/include/configfs.h			\
-	kapi-compat/include/su_mutex.h
+	kapi-compat/include/su_mutex.h			\
+	kapi-compat/include/sock_shutdown.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index af32060..e045fa8 100644
--- a/configure.in
+++ b/configure.in
@@ -359,6 +359,11 @@ OCFS2_CHECK_KERNEL([su_mutex in struct configfs_subsystem in configfs.h], config
   , su_mutex_header=su_mutex.h, [struct mutex            su_mutex;])
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $su_mutex_header"
 
+sock_shutdown_header=
+OCFS2_CHECK_KERNEL([kernel_sock_shutdown() in net.t], net.h,
+  , sock_shutdown_header=sock_shutdown.h, [^extern int kernel_sock_shutdown(struct socket \*sock])
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $sock_shutdown_header"
+
 # End kapi_compat checks
 
 # using -include has two advantages:
diff --git a/kapi-compat/include/sock_shutdown.h b/kapi-compat/include/sock_shutdown.h
new file mode 100644
index 0000000..83efccd
--- /dev/null
+++ b/kapi-compat/include/sock_shutdown.h
@@ -0,0 +1,17 @@
+#ifndef KAPI_SOCK_SHUTDOWN_H
+#define KAPI_SOCK_SHUTDOWN_H
+
+#include <linux/net.h>
+
+enum sock_shutdown_cmd {
+	SHUT_RD         = 0,
+	SHUT_WR         = 1,
+	SHUT_RDWR       = 2,
+};
+
+static inline int kernel_sock_shutdown(struct socket *sock, enum sock_shutdown_cmd how)
+{
+	return sock->ops->shutdown(sock, how);
+}
+
+#endif
-- 
1.5.6.5
