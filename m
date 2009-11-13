From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 12 Nov 2009 17:47:31 -0800
Subject: [Ocfs2-devel] [PATCH 10/18] ocfs2: Handle missing
	bdi_init()/bdi_destroy()
In-Reply-To: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
References: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1258076859-13538-11-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit e0bf68ddec4f4f90e5871404be4f1854c17f3120 added bdi_init()
and bdi_destroy(). Patch adds empty inlines to allow building with EL5.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Makefile                       |    3 ++-
 configure.in                   |    5 +++++
 kapi-compat/include/bdi_init.h |   14 ++++++++++++++
 3 files changed, 21 insertions(+), 1 deletions(-)
 create mode 100644 kapi-compat/include/bdi_init.h

diff --git a/Makefile b/Makefile
index 0dd7443..68f746e 100644
--- a/Makefile
+++ b/Makefile
@@ -29,7 +29,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/blkdev_get.h		\
 	kapi-compat/include/configfs.h			\
 	kapi-compat/include/su_mutex.h			\
-	kapi-compat/include/sock_shutdown.h
+	kapi-compat/include/sock_shutdown.h		\
+	kapi-compat/include/bdi_init.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index e045fa8..53deffd 100644
--- a/configure.in
+++ b/configure.in
@@ -364,6 +364,11 @@ OCFS2_CHECK_KERNEL([kernel_sock_shutdown() in net.t], net.h,
   , sock_shutdown_header=sock_shutdown.h, [^extern int kernel_sock_shutdown(struct socket \*sock])
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $sock_shutdown_header"
 
+bdi_init_compat_header=
+OCFS2_CHECK_KERNEL([bdi_init() in backing-dev.h], backing-dev.h,
+  , bdi_init_compat_header=bdi_init.h, [^int bdi_init(struct backing_dev_info \*bdi);])
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $bdi_init_compat_header"
+
 # End kapi_compat checks
 
 # using -include has two advantages:
diff --git a/kapi-compat/include/bdi_init.h b/kapi-compat/include/bdi_init.h
new file mode 100644
index 0000000..2966533
--- /dev/null
+++ b/kapi-compat/include/bdi_init.h
@@ -0,0 +1,14 @@
+#ifndef KAPI_BDI_INIT_H
+#define KAPI_BDI_INIT_H
+
+static inline int bdi_init(struct backing_dev_info *bdi)
+{
+	return 0;
+}
+
+static inline void bdi_destroy(struct backing_dev_info *bdi)
+{
+	return ;
+}
+
+#endif
-- 
1.5.6.5
