From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 12 Nov 2009 17:47:32 -0800
Subject: [Ocfs2-devel] [PATCH 11/18] ocfs2: Handle missing
	BDI_CAP_NO_ACCT_AND_WRITEBACK
In-Reply-To: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
References: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1258076859-13538-12-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit e4ad08fe64afca4ef79ecc4c624e6e871688da0d added macro
BDI_CAP_NO_ACCT_AND_WRITEBACK.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Makefile                         |    3 ++-
 configure.in                     |    5 +++++
 kapi-compat/include/bdi_define.h |    6 ++++++
 3 files changed, 13 insertions(+), 1 deletions(-)
 create mode 100644 kapi-compat/include/bdi_define.h

diff --git a/Makefile b/Makefile
index 68f746e..1cd2584 100644
--- a/Makefile
+++ b/Makefile
@@ -30,7 +30,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/configfs.h			\
 	kapi-compat/include/su_mutex.h			\
 	kapi-compat/include/sock_shutdown.h		\
-	kapi-compat/include/bdi_init.h
+	kapi-compat/include/bdi_init.h			\
+	kapi-compat/include/bdi_define.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index 53deffd..5fe4934 100644
--- a/configure.in
+++ b/configure.in
@@ -369,6 +369,11 @@ OCFS2_CHECK_KERNEL([bdi_init() in backing-dev.h], backing-dev.h,
   , bdi_init_compat_header=bdi_init.h, [^int bdi_init(struct backing_dev_info \*bdi);])
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $bdi_init_compat_header"
 
+bdi_define_compat_header=
+OCFS2_CHECK_KERNEL([BDI_CAP_NO_ACCT_AND_WRITEBACK in backing-dev.h], backing-dev.h,
+  , bdi_define_compat_header=bdi_define.h, [^#define BDI_CAP_NO_ACCT_AND_WRITEBACK])
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $bdi_define_compat_header"
+
 # End kapi_compat checks
 
 # using -include has two advantages:
diff --git a/kapi-compat/include/bdi_define.h b/kapi-compat/include/bdi_define.h
new file mode 100644
index 0000000..28de9da
--- /dev/null
+++ b/kapi-compat/include/bdi_define.h
@@ -0,0 +1,6 @@
+#ifndef KAPI_BDI_DEFINE_H
+#define KAPI_BDI_DEFINE_H
+
+#define BDI_CAP_NO_ACCT_AND_WRITEBACK	(BDI_CAP_NO_ACCT_DIRTY | BDI_CAP_NO_WRITEBACK)
+
+#endif
-- 
1.5.6.5
