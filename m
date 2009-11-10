From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon,  9 Nov 2009 18:00:05 -0800
Subject: [Ocfs2-devel] [PATCH 02/10] ocfs2: Handle missing dlmconstants.h
In-Reply-To: <1257818413-32014-1-git-send-email-sunil.mushran@oracle.com>
References: <1257818413-32014-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1257818413-32014-3-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit d69a3ad6a0e47b2aa9b2b2ddfd385752132a4d34 split
lock mode and flag constants from dlm.h into a sharable header,
dlmconstants.h.

This patch adds a header with the same name that merely includes
dlm.h.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in                     |    1 +
 Makefile                           |    3 ++-
 configure.in                       |    6 ++++++
 fs/ocfs2/Makefile                  |    4 ++++
 fs/ocfs2/stackglue.h               |    2 ++
 kapi-compat/include/dlmconstants.h |    9 +++++++++
 6 files changed, 24 insertions(+), 1 deletions(-)
 create mode 100644 kapi-compat/include/dlmconstants.h

diff --git a/Config.make.in b/Config.make.in
index cf292b6..33b7a89 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -58,6 +58,7 @@ MAKEBO_VERSION = @VERSION@
 EXTRA_CFLAGS += @KAPI_COMPAT_CFLAGS@
 
 NO_DELAYED_WORK_STRUCT = @NO_DELAYED_WORK_STRUCT@
+NO_DLMCONSTANTS_HEADER = @NO_DLMCONSTANTS_HEADER@
 
 
 OCFS_DEBUG = @OCFS_DEBUG@
diff --git a/Makefile b/Makefile
index 262bc49..d038ae9 100644
--- a/Makefile
+++ b/Makefile
@@ -9,7 +9,8 @@ SUBDIRS = fs vendor
 LINUX_INCLUDE_FILES =
 
 KAPI_COMPAT_FILES = \
-	kapi-compat/include/workqueue.h
+	kapi-compat/include/workqueue.h			\
+	kapi-compat/include/dlmconstants.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index acbe098..f67de02 100644
--- a/configure.in
+++ b/configure.in
@@ -164,6 +164,12 @@ OCFS2_CHECK_KERNEL([struct delayed_work in workqueue.h], workqueue.h,
 AC_SUBST(NO_DELAYED_WORK_STRUCT)
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS workqueue.h"
 
+NO_DLMCONSTANTS_HEADER=
+OCFS2_CHECK_KERNEL([dlmconstants.h], dlmconstants.h,
+ , NO_DLMCONSTANTS_HEADER=yes, [__DLMCONSTANTS_DOT_H__])
+AC_SUBST(NO_DLMCONSTANTS_HEADER)
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS dlmconstants.h"
+
 
 # End kapi_compat checks
 
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 4415ce6..e997fe4 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -38,6 +38,10 @@ ifdef NO_DELAYED_WORK_STRUCT
 EXTRA_CFLAGS += -DNO_DELAYED_WORK_STRUCT
 endif
 
+ifdef NO_DLMCONSTANTS_HEADER
+EXTRA_CFLAGS += -DNO_DLMCONSTANTS_HEADER
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
index 03a44d6..52d1a1d 100644
--- a/fs/ocfs2/stackglue.h
+++ b/fs/ocfs2/stackglue.h
@@ -23,7 +23,9 @@
 
 #include <linux/types.h>
 #include <linux/list.h>
+#ifndef NO_DLMCONSTANTS_HEADER
 #include <linux/dlmconstants.h>
+#endif
 
 #include "dlm/dlmapi.h"
 #include <linux/dlm.h>
diff --git a/kapi-compat/include/dlmconstants.h b/kapi-compat/include/dlmconstants.h
new file mode 100644
index 0000000..19e92c9
--- /dev/null
+++ b/kapi-compat/include/dlmconstants.h
@@ -0,0 +1,9 @@
+#ifndef KAPI_DLMCONSTANTS_H
+#define KAPI_DLMCONSTANTS_H
+
+#ifdef NO_DLMCONSTANTS_HEADER
+#include <linux/types.h>
+#include <linux/dlm.h>
+#endif
+
+#endif
-- 
1.5.6.5
