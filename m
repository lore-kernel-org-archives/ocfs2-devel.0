From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 11 Nov 2009 12:44:54 -0800
Subject: [Ocfs2-devel] [PATCH 01/11] ocfs2: Add kapi-default.h
In-Reply-To: <1257972298-15590-1-git-send-email-sunil.mushran@oracle.com>
References: <1257972298-15590-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1257972298-15590-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add kapi-default.h to allow us to build ocfs2 1.6 against mainline
without the kapi-compat headers.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/Makefile       |    2 +-
 fs/ocfs2/kapi-default.h |   26 ++++++++++++++++++++++++++
 fs/ocfs2/ocfs2.h        |    2 ++
 3 files changed, 29 insertions(+), 1 deletions(-)
 create mode 100644 fs/ocfs2/kapi-default.h

diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 8222d03..9ca23b4 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -13,7 +13,7 @@ include $(OUR_TOPDIR)/Config.make
 endif
 
 COMPAT_SOURCES =
-COMPAT_HEADERS =
+COMPAT_HEADERS = kapi-default.h
 FS_SOURCES =
 FS_HEADERS =
 GLUE_SOURCES =
diff --git a/fs/ocfs2/kapi-default.h b/fs/ocfs2/kapi-default.h
new file mode 100644
index 0000000..fcf3ac9
--- /dev/null
+++ b/fs/ocfs2/kapi-default.h
@@ -0,0 +1,26 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * kapi-default.h
+ *
+ * Defines kapi-compat macros and structures used in OCFS2
+ *
+ * Copyright (C) 2009 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation; either
+ * version 2 of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ */
+
+#ifndef KAPI_DEFAULT_H
+#define KAPI_DEFAULT_H
+
+
+#endif
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index eae4046..89ed209 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -42,6 +42,8 @@
 # include "ocfs2_jbd_compat.h"
 #endif
 
+#include "kapi-default.h"
+
 /* For union ocfs2_dlm_lksb */
 #include "stackglue.h"
 
-- 
1.5.6.5
