From: Tiger Yang <tiger.yang@oracle.com>
Date: Fri, 19 Sep 2008 17:42:33 +0800
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: Add security xattr support in ocfs2
In-Reply-To: <48D3725A.1030701@oracle.com>
References: <48D3725A.1030701@oracle.com>
Message-ID: <1221817353-11111-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch add security extended attribute support in ocfs2.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/Makefile         |    3 +-
 fs/ocfs2/xattr.c          |    4 --
 fs/ocfs2/xattr.h          |    2 -
 fs/ocfs2/xattr_security.c |   81 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 83 insertions(+), 7 deletions(-)
 create mode 100644 fs/ocfs2/xattr_security.c

diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 21323da..73c1c82 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -37,7 +37,8 @@ ocfs2-objs := \
 	ver.o			\
 	xattr.o			\
 	xattr_user.o		\
-	xattr_trusted.o
+	xattr_trusted.o		\
+	xattr_security.o
 
 ocfs2_stackglue-objs := stackglue.o
 ocfs2_stack_o2cb-objs := stack_o2cb.o
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 505fb40..d57cfae 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -81,9 +81,7 @@ struct xattr_handler *ocfs2_xattr_handlers[] = {
 	&ocfs2_xattr_acl_default_handler,
 #endif
 	&ocfs2_xattr_trusted_handler,
-#ifdef CONFIG_OCFS2_FS_SECURITY
 	&ocfs2_xattr_security_handler,
-#endif
 	NULL
 };
 
@@ -96,9 +94,7 @@ static struct xattr_handler *ocfs2_xattr_handler_map[] = {
 					= &ocfs2_xattr_acl_default_handler,
 #endif
 	[OCFS2_XATTR_INDEX_TRUSTED]	= &ocfs2_xattr_trusted_handler,
-#ifdef CONFIG_OCFS2_FS_SECURITY
 	[OCFS2_XATTR_INDEX_SECURITY]	= &ocfs2_xattr_security_handler,
-#endif
 };
 
 struct ocfs2_xattr_info {
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index af2ba32..f3ec79a 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -44,9 +44,7 @@ extern struct xattr_handler ocfs2_xattr_trusted_handler;
 extern struct xattr_handler ocfs2_xattr_acl_access_handler;
 extern struct xattr_handler ocfs2_xattr_acl_default_handler;
 #endif
-#ifdef CONFIG_OCFS2_FS_SECURITY
 extern struct xattr_handler ocfs2_xattr_security_handler;
-#endif
 extern struct xattr_handler *ocfs2_xattr_handlers[];
 
 ssize_t ocfs2_listxattr(struct dentry *, char *, size_t);
diff --git a/fs/ocfs2/xattr_security.c b/fs/ocfs2/xattr_security.c
new file mode 100644
index 0000000..428c102
--- /dev/null
+++ b/fs/ocfs2/xattr_security.c
@@ -0,0 +1,81 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * xattr_security.c
+ *
+ * Copyright (C) 2008 Oracle.  All rights reserved.
+ *
+ * CREDITS:
+ * Lots of code in this file is taken from ext3.
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
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/security.h>
+
+#define MLOG_MASK_PREFIX ML_INODE
+#include <cluster/masklog.h>
+
+#include "ocfs2.h"
+#include "alloc.h"
+#include "dlmglue.h"
+#include "file.h"
+#include "ocfs2_fs.h"
+#include "xattr.h"
+
+static size_t ocfs2_xattr_security_list(struct inode *inode, char *list,
+					size_t list_size, const char *name,
+					size_t name_len)
+{
+	const size_t prefix_len = XATTR_SECURITY_PREFIX_LEN;
+	const size_t total_len = prefix_len + name_len + 1;
+
+	if (list && total_len <= list_size) {
+		memcpy(list, XATTR_SECURITY_PREFIX, prefix_len);
+		memcpy(list + prefix_len, name, name_len);
+		list[prefix_len + name_len] = '\0';
+	}
+	return total_len;
+}
+
+static int ocfs2_xattr_security_get(struct inode *inode, const char *name,
+				    void *buffer, size_t size)
+{
+	if (strcmp(name, "") == 0)
+		return -EINVAL;
+	return ocfs2_xattr_get(inode, OCFS2_XATTR_INDEX_SECURITY, name,
+			       buffer, size);
+}
+
+static int ocfs2_xattr_security_set(struct inode *inode, const char *name,
+				    const void *value, size_t size, int flags)
+{
+	if (strcmp(name, "") == 0)
+		return -EINVAL;
+
+	return ocfs2_xattr_set(inode, OCFS2_XATTR_INDEX_SECURITY, name, value,
+			       size, flags);
+}
+
+struct xattr_handler ocfs2_xattr_security_handler = {
+	.prefix	= XATTR_SECURITY_PREFIX,
+	.list	= ocfs2_xattr_security_list,
+	.get	= ocfs2_xattr_security_get,
+	.set	= ocfs2_xattr_security_set,
+};
-- 
1.5.4.1
