From: Tiger Yang <tiger.yang@oracle.com>
Date: Fri, 19 Sep 2008 17:43:01 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: Add posix ACL support in ocfs2 v1
In-Reply-To: <48D3725A.1030701@oracle.com>
References: <48D3725A.1030701@oracle.com>
Message-ID: <1221817381-11133-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch add posix ACL support in ocfs2.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/Makefile |    1 +
 fs/ocfs2/acl.c    |  383 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/acl.h    |   40 ++++++
 fs/ocfs2/file.c   |    3 +-
 fs/ocfs2/namei.c  |    3 +
 fs/ocfs2/xattr.c  |    4 -
 fs/ocfs2/xattr.h  |    2 -
 7 files changed, 429 insertions(+), 7 deletions(-)
 create mode 100644 fs/ocfs2/acl.c
 create mode 100644 fs/ocfs2/acl.h

diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 73c1c82..27f0954 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_OCFS2_FS_O2CB) += ocfs2_stack_o2cb.o
 obj-$(CONFIG_OCFS2_FS_USERSPACE_CLUSTER) += ocfs2_stack_user.o
 
 ocfs2-objs := \
+	acl.o			\
 	alloc.o 		\
 	aops.o 			\
 	buffer_head_io.o	\
diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
new file mode 100644
index 0000000..eff4155
--- /dev/null
+++ b/fs/ocfs2/acl.c
@@ -0,0 +1,383 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * acl.c
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
+
+#define MLOG_MASK_PREFIX ML_INODE
+#include <cluster/masklog.h>
+
+#include "ocfs2.h"
+#include "alloc.h"
+#include "dlmglue.h"
+#include "file.h"
+#include "ocfs2_fs.h"
+
+#include "xattr.h"
+#include "acl.h"
+
+/*
+ * Convert from xattr value to acl struct.
+ */
+static struct posix_acl *ocfs2_acl_from_xattr(const void *value, size_t size)
+{
+	int n, count;
+	struct posix_acl *acl;
+
+	if (!value)
+		return NULL;
+	if (size < sizeof(struct posix_acl_entry))
+		 return ERR_PTR(-EINVAL);
+
+	count = size / sizeof(struct posix_acl_entry);
+	if (count < 0)
+		return ERR_PTR(-EINVAL);
+	if (count == 0)
+		return NULL;
+
+	acl = posix_acl_alloc(count, GFP_NOFS);
+	if (!acl)
+		return ERR_PTR(-ENOMEM);
+	for (n = 0; n < count; n++) {
+		struct ocfs2_acl_entry *entry =
+			(struct ocfs2_acl_entry *)value;
+
+		acl->a_entries[n].e_tag  = le16_to_cpu(entry->e_tag);
+		acl->a_entries[n].e_perm = le16_to_cpu(entry->e_perm);
+		acl->a_entries[n].e_id   = le32_to_cpu(entry->e_id);
+		value += sizeof(struct posix_acl_entry);
+
+	}
+	return acl;
+}
+
+/*
+ * Convert acl struct to xattr value.
+ */
+static void *ocfs2_acl_to_xattr(const struct posix_acl *acl, size_t *size)
+{
+	struct ocfs2_acl_entry *entry = NULL;
+	char *ocfs2_acl;
+	size_t n;
+
+	*size = acl->a_count * sizeof(struct posix_acl_entry);
+
+	ocfs2_acl = kmalloc(*size, GFP_NOFS);
+	if (!ocfs2_acl)
+		return ERR_PTR(-ENOMEM);
+
+	entry = (struct ocfs2_acl_entry *)ocfs2_acl;
+	for (n = 0; n < acl->a_count; n++, entry++) {
+		entry->e_tag  = cpu_to_le16(acl->a_entries[n].e_tag);
+		entry->e_perm = cpu_to_le16(acl->a_entries[n].e_perm);
+		entry->e_id   = cpu_to_le32(acl->a_entries[n].e_id);
+	}
+	return ocfs2_acl;
+}
+
+/*
+ * Get posix acl.
+ */
+static struct posix_acl *ocfs2_get_acl(struct inode *inode, int type)
+{
+	int name_index;
+	char *value = NULL;
+	struct posix_acl *acl;
+	int retval;
+
+	switch (type) {
+	case ACL_TYPE_ACCESS:
+		name_index = OCFS2_XATTR_INDEX_POSIX_ACL_ACCESS;
+		break;
+	case ACL_TYPE_DEFAULT:
+		name_index = OCFS2_XATTR_INDEX_POSIX_ACL_DEFAULT;
+		break;
+	default:
+		return ERR_PTR(-EINVAL);
+	}
+
+	retval = ocfs2_xattr_get(inode, name_index, "", NULL, 0);
+	if (retval > 0) {
+		value = kmalloc(retval, GFP_NOFS);
+		if (!value)
+			return ERR_PTR(-ENOMEM);
+		retval = ocfs2_xattr_get(inode, name_index, "", value, retval);
+	}
+
+	if (retval > 0)
+		acl = ocfs2_acl_from_xattr(value, retval);
+	else if (retval == -ENODATA || retval == -ENOSYS)
+		acl = NULL;
+	else
+		acl = ERR_PTR(retval);
+
+	kfree(value);
+
+	return acl;
+}
+
+/*
+ * Set the access or default ACL of an inode.
+ */
+static int ocfs2_set_acl(struct inode *inode, int type, struct posix_acl *acl)
+{
+	int name_index;
+	void *value = NULL;
+	size_t size = 0;
+	int ret;
+
+	if (S_ISLNK(inode->i_mode))
+		return -EOPNOTSUPP;
+
+	switch (type) {
+	case ACL_TYPE_ACCESS:
+		name_index = OCFS2_XATTR_INDEX_POSIX_ACL_ACCESS;
+		if (acl) {
+			mode_t mode = inode->i_mode;
+			ret = posix_acl_equiv_mode(acl, &mode);
+			if (ret < 0)
+				return ret;
+			else {
+				inode->i_mode = mode;
+				if (ret == 0)
+					acl = NULL;
+			}
+		}
+		break;
+	case ACL_TYPE_DEFAULT:
+		name_index = OCFS2_XATTR_INDEX_POSIX_ACL_DEFAULT;
+		if (!S_ISDIR(inode->i_mode))
+			return acl ? -EACCES : 0;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (acl) {
+		value = ocfs2_acl_to_xattr(acl, &size);
+		if (IS_ERR(value))
+			return (int)PTR_ERR(value);
+	}
+
+	ret = ocfs2_xattr_set(inode, name_index, "", value, size, 0);
+
+	kfree(value);
+
+	return ret;
+}
+
+int ocfs2_check_acl(struct inode *inode, int mask)
+{
+	struct posix_acl *acl = ocfs2_get_acl(inode, ACL_TYPE_ACCESS);
+
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+	if (acl) {
+		int ret = posix_acl_permission(inode, acl, mask);
+		posix_acl_release(acl);
+		return ret;
+	}
+
+	return -EAGAIN;
+}
+
+/*
+ * Initialize the ACLs of a new inode. If parent directory has default ACL,
+ * then clone to new inode. Called from ocfs2_mknod.
+ */
+int ocfs2_init_acl(struct inode *inode, struct inode *dir)
+{
+	struct posix_acl *acl = NULL;
+	int ret = 0;
+
+	if (!S_ISLNK(inode->i_mode)) {
+		acl = ocfs2_get_acl(dir, ACL_TYPE_DEFAULT);
+		if (IS_ERR(acl))
+			return PTR_ERR(acl);
+		if (!acl)
+			inode->i_mode &= ~current->fs->umask;
+	}
+	if (acl) {
+		struct posix_acl *clone;
+		mode_t mode;
+
+		if (S_ISDIR(inode->i_mode)) {
+			ret = ocfs2_set_acl(inode, ACL_TYPE_DEFAULT, acl);
+			if (ret)
+				goto cleanup;
+		}
+		clone = posix_acl_clone(acl, GFP_NOFS);
+		ret = -ENOMEM;
+		if (!clone)
+			goto cleanup;
+
+		mode = inode->i_mode;
+		ret = posix_acl_create_masq(clone, &mode);
+		if (ret >= 0) {
+			inode->i_mode = mode;
+			if (ret > 0) {
+				ret = ocfs2_set_acl(inode,
+						    ACL_TYPE_ACCESS, clone);
+			}
+		}
+		posix_acl_release(clone);
+	}
+cleanup:
+	posix_acl_release(acl);
+	return ret;
+}
+
+static size_t ocfs2_xattr_list_acl_access(struct inode *inode,
+					  char *list,
+					  size_t list_len,
+					  const char *name,
+					  size_t name_len)
+{
+	const size_t size = sizeof(POSIX_ACL_XATTR_ACCESS);
+
+	if (list && size <= list_len)
+		memcpy(list, POSIX_ACL_XATTR_ACCESS, size);
+	return size;
+}
+
+static size_t ocfs2_xattr_list_acl_default(struct inode *inode,
+					   char *list,
+					   size_t list_len,
+					   const char *name,
+					   size_t name_len)
+{
+	const size_t size = sizeof(POSIX_ACL_XATTR_DEFAULT);
+
+	if (list && size <= list_len)
+		memcpy(list, POSIX_ACL_XATTR_DEFAULT, size);
+	return size;
+}
+
+static int ocfs2_xattr_get_acl(struct inode *inode,
+			       int type,
+			       void *buffer,
+			       size_t size)
+{
+	struct posix_acl *acl;
+	int ret;
+
+	acl = ocfs2_get_acl(inode, type);
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+	if (acl == NULL)
+		return -ENODATA;
+	ret = posix_acl_to_xattr(acl, buffer, size);
+	posix_acl_release(acl);
+
+	return ret;
+}
+
+static int ocfs2_xattr_get_acl_access(struct inode *inode,
+				      const char *name,
+				      void *buffer,
+				      size_t size)
+{
+	if (strcmp(name, "") != 0)
+		return -EINVAL;
+	return ocfs2_xattr_get_acl(inode, ACL_TYPE_ACCESS, buffer, size);
+}
+
+static int ocfs2_xattr_get_acl_default(struct inode *inode,
+				       const char *name,
+				       void *buffer,
+				       size_t size)
+{
+	if (strcmp(name, "") != 0)
+		return -EINVAL;
+	return ocfs2_xattr_get_acl(inode, ACL_TYPE_DEFAULT, buffer, size);
+}
+
+static int ocfs2_xattr_set_acl(struct inode *inode,
+			       int type,
+			       const void *value,
+			       size_t size)
+{
+	struct posix_acl *acl;
+	int ret = 0;
+
+	if (!is_owner_or_cap(inode))
+		return -EPERM;
+
+	if (value) {
+		acl = posix_acl_from_xattr(value, size);
+		if (IS_ERR(acl))
+			return PTR_ERR(acl);
+		else if (acl) {
+			ret = posix_acl_valid(acl);
+			if (ret)
+				goto cleanup;
+		}
+	} else
+		acl = NULL;
+
+	ret = ocfs2_set_acl(inode, type, acl);
+
+cleanup:
+	posix_acl_release(acl);
+	return ret;
+}
+
+static int ocfs2_xattr_set_acl_access(struct inode *inode,
+				      const char *name,
+				      const void *value,
+				      size_t size,
+				      int flags)
+{
+	if (strcmp(name, "") != 0)
+		return -EINVAL;
+	return ocfs2_xattr_set_acl(inode, ACL_TYPE_ACCESS, value, size);
+}
+
+static int ocfs2_xattr_set_acl_default(struct inode *inode,
+				       const char *name,
+				       const void *value,
+				       size_t size,
+				       int flags)
+{
+	if (strcmp(name, "") != 0)
+		return -EINVAL;
+	return ocfs2_xattr_set_acl(inode, ACL_TYPE_DEFAULT, value, size);
+}
+
+struct xattr_handler ocfs2_xattr_acl_access_handler = {
+	.prefix	= POSIX_ACL_XATTR_ACCESS,
+	.list	= ocfs2_xattr_list_acl_access,
+	.get	= ocfs2_xattr_get_acl_access,
+	.set	= ocfs2_xattr_set_acl_access,
+};
+
+struct xattr_handler ocfs2_xattr_acl_default_handler = {
+	.prefix	= POSIX_ACL_XATTR_DEFAULT,
+	.list	= ocfs2_xattr_list_acl_default,
+	.get	= ocfs2_xattr_get_acl_default,
+	.set	= ocfs2_xattr_set_acl_default,
+};
diff --git a/fs/ocfs2/acl.h b/fs/ocfs2/acl.h
new file mode 100644
index 0000000..ba1cb92
--- /dev/null
+++ b/fs/ocfs2/acl.h
@@ -0,0 +1,40 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * acl.h
+ *
+ * Function prototypes
+ *
+ * Copyright (C) 2008 Oracle.  All rights reserved.
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
+#ifndef OCFS2_ACL_H
+#define OCFS2_ACL_H
+
+#include <linux/posix_acl_xattr.h>
+
+struct ocfs2_acl_entry {
+	__le16 e_tag;
+	__le16 e_perm;
+	__le32 e_id;
+};
+
+int ocfs2_check_acl(struct inode *inode, int mask);
+int ocfs2_init_acl(struct inode *inode, struct inode *dir);
+
+#endif /* OCFS2_ACL_H */
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index edcdd39..96a53eb 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -56,6 +56,7 @@
 #include "suballoc.h"
 #include "super.h"
 #include "xattr.h"
+#include "acl.h"
 
 #include "buffer_head_io.h"
 
@@ -1031,7 +1032,7 @@ int ocfs2_permission(struct inode *inode, int mask, struct nameidata *nd)
 		goto out;
 	}
 
-	ret = generic_permission(inode, mask, NULL);
+	ret = generic_permission(inode, mask, ocfs2_check_acl);
 
 	ocfs2_inode_unlock(inode, 0);
 out:
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 76d1d13..9f8f313 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -61,6 +61,7 @@
 #include "sysfile.h"
 #include "uptodate.h"
 #include "xattr.h"
+#include "acl.h"
 
 #include "buffer_head_io.h"
 
@@ -328,6 +329,8 @@ leave:
 	if (status == -ENOSPC)
 		mlog(0, "Disk is full\n");
 
+	status = ocfs2_init_acl(inode, dir);
+
 	if (new_fe_bh)
 		brelse(new_fe_bh);
 
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index d57cfae..1daff4f 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -76,10 +76,8 @@ static struct ocfs2_xattr_def_value_root def_xv = {
 
 struct xattr_handler *ocfs2_xattr_handlers[] = {
 	&ocfs2_xattr_user_handler,
-#ifdef CONFIG_OCFS2_FS_POSIX_ACL
 	&ocfs2_xattr_acl_access_handler,
 	&ocfs2_xattr_acl_default_handler,
-#endif
 	&ocfs2_xattr_trusted_handler,
 	&ocfs2_xattr_security_handler,
 	NULL
@@ -87,12 +85,10 @@ struct xattr_handler *ocfs2_xattr_handlers[] = {
 
 static struct xattr_handler *ocfs2_xattr_handler_map[] = {
 	[OCFS2_XATTR_INDEX_USER]	= &ocfs2_xattr_user_handler,
-#ifdef CONFIG_OCFS2_FS_POSIX_ACL
 	[OCFS2_XATTR_INDEX_POSIX_ACL_ACCESS]
 					= &ocfs2_xattr_acl_access_handler,
 	[OCFS2_XATTR_INDEX_POSIX_ACL_DEFAULT]
 					= &ocfs2_xattr_acl_default_handler,
-#endif
 	[OCFS2_XATTR_INDEX_TRUSTED]	= &ocfs2_xattr_trusted_handler,
 	[OCFS2_XATTR_INDEX_SECURITY]	= &ocfs2_xattr_security_handler,
 };
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index f3ec79a..b8d6522 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -40,10 +40,8 @@ enum ocfs2_xattr_type {
 
 extern struct xattr_handler ocfs2_xattr_user_handler;
 extern struct xattr_handler ocfs2_xattr_trusted_handler;
-#ifdef CONFIG_OCFS2_FS_POSIX_ACL
 extern struct xattr_handler ocfs2_xattr_acl_access_handler;
 extern struct xattr_handler ocfs2_xattr_acl_default_handler;
-#endif
 extern struct xattr_handler ocfs2_xattr_security_handler;
 extern struct xattr_handler *ocfs2_xattr_handlers[];
 
-- 
1.5.4.1
