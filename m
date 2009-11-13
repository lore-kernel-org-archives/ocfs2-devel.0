From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 12 Nov 2009 17:47:22 -0800
Subject: [Ocfs2-devel] [PATCH 01/18] ocfs2: Add kapi-default.h in cluster
	and dlm
In-Reply-To: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
References: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1258076859-13538-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit 19582597eec08f61b6f5794c15f6f2c9821a67d9 added kapi-default.h in
fs/ocfs2. This patch adds a similar named file in fs/ocfs2/cluster and
fs/ocfs2/dlm to allow building against the mainline without kapi-compat
headers.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/Makefile       |    2 +-
 fs/ocfs2/cluster/kapi-default.h |   26 ++++++++++++++++++++++++++
 fs/ocfs2/dlm/Makefile           |    2 +-
 fs/ocfs2/dlm/kapi-default.h     |   26 ++++++++++++++++++++++++++
 4 files changed, 54 insertions(+), 2 deletions(-)
 create mode 100644 fs/ocfs2/cluster/kapi-default.h
 create mode 100644 fs/ocfs2/dlm/kapi-default.h

diff --git a/fs/ocfs2/cluster/Makefile b/fs/ocfs2/cluster/Makefile
index d89112d..1f040c6 100644
--- a/fs/ocfs2/cluster/Makefile
+++ b/fs/ocfs2/cluster/Makefile
@@ -12,7 +12,7 @@ include $(OUR_TOPDIR)/Config.make
 endif
 
 COMPAT_SOURCES =
-COMPAT_HEADERS =
+COMPAT_HEADERS = kapi-default.h
 SOURCES =
 HEADERS =
 
diff --git a/fs/ocfs2/cluster/kapi-default.h b/fs/ocfs2/cluster/kapi-default.h
new file mode 100644
index 0000000..fcf3ac9
--- /dev/null
+++ b/fs/ocfs2/cluster/kapi-default.h
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
diff --git a/fs/ocfs2/dlm/Makefile b/fs/ocfs2/dlm/Makefile
index 122b370..0c4d1f4 100644
--- a/fs/ocfs2/dlm/Makefile
+++ b/fs/ocfs2/dlm/Makefile
@@ -13,7 +13,7 @@ include $(OUR_TOPDIR)/Config.make
 endif
 
 COMPAT_SOURCES =
-COMPAT_HEADERS =
+COMPAT_HEADERS = kapi-default.h
 DLM_SOURCES =
 DLMFS_SOURCES =
 HEADERS =
diff --git a/fs/ocfs2/dlm/kapi-default.h b/fs/ocfs2/dlm/kapi-default.h
new file mode 100644
index 0000000..fcf3ac9
--- /dev/null
+++ b/fs/ocfs2/dlm/kapi-default.h
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
-- 
1.5.6.5
