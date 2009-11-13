From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 12 Nov 2009 17:47:28 -0800
Subject: [Ocfs2-devel] [PATCH 07/18] ocfs2: Handles missing
	configfs_depend_item() and configfs_undepend_item()
In-Reply-To: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
References: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1258076859-13538-8-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 631d1febab8e546e3bb800bdfe2c212b8adf87de added configfs_depend_item()
and configfs_undepend_item(). Patch adds empty macros when building against EL5 that
does not have the functionality.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Makefile                       |    3 ++-
 configure.in                   |    5 +++++
 kapi-compat/include/configfs.h |    7 +++++++
 3 files changed, 14 insertions(+), 1 deletions(-)
 create mode 100644 kapi-compat/include/configfs.h

diff --git a/Makefile b/Makefile
index 5e1bb62..00535ff 100644
--- a/Makefile
+++ b/Makefile
@@ -26,7 +26,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/sysctl.h			\
 	kapi-compat/include/slab.h			\
 	kapi-compat/include/blkdev_put.h		\
-	kapi-compat/include/blkdev_get.h
+	kapi-compat/include/blkdev_get.h		\
+	kapi-compat/include/configfs.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index 8ce5e67..aad0ea1 100644
--- a/configure.in
+++ b/configure.in
@@ -349,6 +349,11 @@ OCFS2_CHECK_KERNEL([	older prototype of blkdev_get() in fs.h], fs.h,
   blkdev_get_header=blkdev_get.h, , [^extern int blkdev_get(struct block_device \*, mode_t, unsigned);])
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $blkdev_get_header"
 
+configfs_compat_header=
+OCFS2_CHECK_KERNEL([configfs_depend_item() in configfs.h], configfs.h,
+  , configfs_compat_header=configfs.h, [^int configfs_depend_item(])
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $configfs_compat_header"
+
 # End kapi_compat checks
 
 # using -include has two advantages:
diff --git a/kapi-compat/include/configfs.h b/kapi-compat/include/configfs.h
new file mode 100644
index 0000000..cbc11e6
--- /dev/null
+++ b/kapi-compat/include/configfs.h
@@ -0,0 +1,7 @@
+#ifndef KAPI_CONFIGFS_H
+#define KAPI_CONFIGFS_H
+
+#define configfs_depend_item(a, b)	(0)
+#define configfs_undepend_item(a, b)
+
+#endif
-- 
1.5.6.5
