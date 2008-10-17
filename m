From: Tiger Yang <tiger.yang@oracle.com>
Date: Fri, 17 Oct 2008 17:33:01 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2/xattr: Add POSIX ACLs support in
	ocfs2
In-Reply-To: <48F85A7D.2040407@oracle.com>
References: <48F85A7D.2040407@oracle.com>
Message-ID: <1224235981-24966-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch add POSIX access control list in ocfs2.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 Documentation/filesystems/ocfs2.txt |    4 +-
 fs/Kconfig                          |    9 +
 fs/ocfs2/Makefile                   |    1 +
 fs/ocfs2/acl.c                      |  530 +++++++++++++++++++++++++++++++++++
 fs/ocfs2/acl.h                      |   61 ++++
 fs/ocfs2/file.c                     |   11 +-
 fs/ocfs2/namei.c                    |    8 +
 fs/ocfs2/ocfs2.h                    |    1 +
 fs/ocfs2/super.c                    |   33 +++
 fs/ocfs2/xattr.c                    |   50 +++-
 fs/ocfs2/xattr.h                    |    6 +
 11 files changed, 699 insertions(+), 15 deletions(-)
 create mode 100644 fs/ocfs2/acl.c
 create mode 100644 fs/ocfs2/acl.h

diff --git a/Documentation/filesystems/ocfs2.txt b/Documentation/filesystems/ocfs2.txt
index 4340cc8..578209c 100644
--- a/Documentation/filesystems/ocfs2.txt
+++ b/Documentation/filesystems/ocfs2.txt
@@ -28,13 +28,11 @@ Manish Singh  <manish.singh@oracle.com>
 Caveats
 =======
 Features which OCFS2 does not support yet:
-	- extended attributes
 	- quotas
 	- cluster aware flock
 	- cluster aware lockf
 	- Directory change notification (F_NOTIFY)
 	- Distributed Caching (F_SETLEASE/F_GETLEASE/break_lease)
-	- POSIX ACLs
 
 Mount options
 =============
@@ -82,3 +80,5 @@ inode64			Indicates that Ocfs2 is allowed to create inodes at
 			bits of significance.
 user_xattr	(*)	Enables Extended User Attributes.
 nouser_xattr		Disables Extended User Attributes.
+acl			Enables POSIX Access Control Lists support.
+noacl		(*)	Disables POSIX Access Control Lists support.
diff --git a/fs/Kconfig b/fs/Kconfig
index e651a36..c7be505 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -507,6 +507,15 @@ config OCFS2_COMPAT_JBD
 	  is backwards compatible with JBD.  It is safe to say N here.
 	  However, if you really want to use the original JBD, say Y here.
 
+config OCFS2_FS_POSIX_ACL
+	bool "OCFS2 POSIX Access Control Lists"
+	depends on OCFS2_FS
+	select FS_POSIX_ACL
+	default n
+	help
+	  Posix Access Control Lists (ACLs) support permissions for users and
+	  groups beyond the owner/group/world scheme.
+
 endif # BLOCK
 
 config DNOTIFY
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 589dcdf..ea7c8d4 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_OCFS2_FS) += 	\
 
 obj-$(CONFIG_OCFS2_FS_O2CB) += ocfs2_stack_o2cb.o
 obj-$(CONFIG_OCFS2_FS_USERSPACE_CLUSTER) += ocfs2_stack_user.o
+obj-$(CONFIG_OCFS2_FS_POSIX_ACL) += acl.o
 
 ocfs2-objs := \
 	alloc.o 		\
diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
new file mode 100644
index 0000000..b161b9f
--- /dev/null
+++ b/fs/ocfs2/acl.c
@@ -0,0 +1,530 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * acl.c
+ *
+ * Copyright (C) 2004, 2008 Oracle.  All rights reserved.
+ *
+ * CREDITS:
+ * Lots of code in this file is copy from linux/fs/ext3/acl.c.
+ * Copyright (C) 2001-2003 Andreas Gruenbacher, <agruen@suse.de>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
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
+		return ERR_PTR(-EINVAL);
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
+static struct posix_acl *ocfs2_get_acl_nolock(struct inode *inode,
+					      int type,
+					      struct buffer_head *di_bh)
+{
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	int name_index;
+	char *value = NULL;
+	struct posix_acl *acl;
+	int retval;
+
+	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
+		return NULL;
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
+	retval = ocfs2_xattr_get_nolock(inode, di_bh, name_index, "", NULL, 0);
+	if (retval > 0) {
+		value = kmalloc(retval, GFP_NOFS);
+		if (!value)
+			return ERR_PTR(-ENOMEM);
+		retval = ocfs2_xattr_get_nolock(inode, di_bh, name_index,
+						"", value, retval);
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
+
+/*
+ * Get posix acl.
+ */
+static struct posix_acl *ocfs2_get_acl(struct inode *inode, int type)
+{
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct buffer_head *di_bh = NULL;
+	struct posix_acl *acl;
+	int ret;
+
+	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
+		return NULL;
+
+	ret = ocfs2_inode_lock(inode, &di_bh, 0);
+	if (ret < 0) {
+		mlog_errno(ret);
+		acl = ERR_PTR(ret);
+		return acl;
+	}
+
+	acl = ocfs2_get_acl_nolock(inode, type, di_bh);
+
+	ocfs2_inode_unlock(inode, 0);
+
+	brelse(di_bh);
+
+	return acl;
+}
+
+static int ocfs2_set_acl_handle(handle_t *handle,
+				struct inode *inode,
+				struct buffer_head *di_bh,
+				int type,
+				struct posix_acl *acl,
+				struct ocfs2_alloc_context *meta_ac,
+				struct ocfs2_alloc_context *data_ac)
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
+	ret = ocfs2_xattr_set_handle(handle, inode, di_bh, name_index,
+				     "", value, size, 0, meta_ac, data_ac);
+
+	kfree(value);
+
+	return ret;
+}
+
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
+int ocfs2_init_acl(handle_t *handle,
+		   struct inode *inode,
+		   struct inode *dir,
+		   struct buffer_head *di_bh,
+		   struct buffer_head *dir_bh,
+		   struct ocfs2_alloc_context *meta_ac,
+		   struct ocfs2_alloc_context *data_ac)
+{
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct posix_acl *acl = NULL;
+	int ret = 0;
+
+	if (!S_ISLNK(inode->i_mode)) {
+		if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
+			acl = ocfs2_get_acl_nolock(dir, ACL_TYPE_DEFAULT,
+						   dir_bh);
+			if (IS_ERR(acl))
+				return PTR_ERR(acl);
+		}
+		if (!acl)
+			inode->i_mode &= ~current->fs->umask;
+	}
+	if ((osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) && acl) {
+		struct posix_acl *clone;
+		mode_t mode;
+
+		if (S_ISDIR(inode->i_mode)) {
+			ret = ocfs2_set_acl_handle(handle, inode, di_bh,
+						   ACL_TYPE_DEFAULT, acl,
+						   meta_ac, data_ac);
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
+				ret = ocfs2_set_acl_handle(handle, inode,
+							   di_bh,
+							   ACL_TYPE_ACCESS,
+							   clone,
+							   meta_ac, data_ac);
+			}
+		}
+		posix_acl_release(clone);
+	}
+cleanup:
+	posix_acl_release(acl);
+	return ret;
+}
+
+int ocfs2_acl_chmod(handle_t *handle,
+		    struct inode *inode,
+		    struct buffer_head *di_bh)
+{
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct posix_acl *acl, *clone;
+	int ret;
+
+	if (S_ISLNK(inode->i_mode))
+		return -EOPNOTSUPP;
+
+	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
+		return 0;
+
+	acl = ocfs2_get_acl_nolock(inode, ACL_TYPE_ACCESS, di_bh);
+	if (IS_ERR(acl) || !acl)
+		return PTR_ERR(acl);
+	clone = posix_acl_clone(acl, GFP_KERNEL);
+	posix_acl_release(acl);
+	if (!clone)
+		return -ENOMEM;
+	ret = posix_acl_chmod_masq(clone, inode->i_mode);
+	if (!ret) {
+		ret = ocfs2_set_acl_handle(handle, inode, di_bh,
+					   ACL_TYPE_ACCESS, clone,
+					   NULL, NULL);
+	}
+
+	posix_acl_release(clone);
+	return ret;
+}
+
+static size_t ocfs2_xattr_list_acl_access(struct inode *inode,
+					  char *list,
+					  size_t list_len,
+					  const char *name,
+					  size_t name_len)
+{
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	const size_t size = sizeof(POSIX_ACL_XATTR_ACCESS);
+
+	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
+		return 0;
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
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	const size_t size = sizeof(POSIX_ACL_XATTR_DEFAULT);
+
+	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
+		return 0;
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
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct posix_acl *acl;
+	int ret;
+
+	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
+		return -EOPNOTSUPP;
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
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct posix_acl *acl;
+	int ret = 0;
+
+	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
+		return -EOPNOTSUPP;
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
index 0000000..8facaaf
--- /dev/null
+++ b/fs/ocfs2/acl.h
@@ -0,0 +1,61 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * acl.h
+ *
+ * Copyright (C) 2004, 2008 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
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
+#ifdef CONFIG_OCFS2_FS_POSIX_ACL
+
+extern int ocfs2_check_acl(struct inode *, int);
+extern int ocfs2_init_acl(handle_t *, struct inode *, struct inode *,
+			  struct buffer_head *, struct buffer_head *,
+			  struct ocfs2_alloc_context *,
+			  struct ocfs2_alloc_context *);
+extern int ocfs2_acl_chmod(handle_t *, struct inode *, struct buffer_head *);
+
+#else /* CONFIG_OCFS2_FS_POSIX_ACL*/
+
+#define ocfs2_check_acl NULL
+
+static inline int ocfs2_init_acl(handle_t *handle,
+				 struct inode *inode,
+				 struct inode *dir,
+				 struct buffer_head *di_bh,
+				 struct buffer_head *dir_bh,
+				 struct ocfs2_alloc_context *meta_ac,
+				 struct ocfs2_alloc_context *data_ac)
+{
+	return 0;
+}
+static inline int ocfs2_acl_chmod(handle_t *handle,
+				  struct inode *inode,
+				  struct buffer_head *di_bh)
+{
+	return 0;
+}
+
+#endif /* CONFIG_OCFS2_FS_POSIX_ACL*/
+
+#endif /* OCFS2_ACL_H */
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index c69c12c..298278b 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -56,6 +56,7 @@
 #include "suballoc.h"
 #include "super.h"
 #include "xattr.h"
+#include "acl.h"
 
 #include "buffer_head_io.h"
 
@@ -976,6 +977,14 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 		goto bail_commit;
 	}
 
+	if (attr->ia_valid & ATTR_MODE) {
+		status = ocfs2_acl_chmod(handle, inode, bh);
+		if (status < 0) {
+			mlog_errno(status);
+			goto bail_commit;
+		}
+	}
+
 	status = ocfs2_mark_inode_dirty(handle, inode, bh);
 	if (status < 0)
 		mlog_errno(status);
@@ -1036,7 +1045,7 @@ int ocfs2_permission(struct inode *inode, int mask)
 		goto out;
 	}
 
-	ret = generic_permission(inode, mask, NULL);
+	ret = generic_permission(inode, mask, ocfs2_check_acl);
 
 	ocfs2_inode_unlock(inode, 0);
 out:
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 052b20c..5aafec5 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -61,6 +61,7 @@
 #include "sysfile.h"
 #include "uptodate.h"
 #include "xattr.h"
+#include "acl.h"
 
 #include "buffer_head_io.h"
 
@@ -309,6 +310,13 @@ static int ocfs2_mknod(struct inode *dir,
 		inc_nlink(dir);
 	}
 
+	status = ocfs2_init_acl(handle, inode, dir, new_fe_bh, parent_fe_bh,
+				meta_ac, data_ac);
+	if (status < 0) {
+		mlog_errno(status);
+		goto leave;
+	}
+
 	status = ocfs2_init_security(handle, inode, dir, new_fe_bh,
 				     meta_ac, data_ac);
 	if (status < 0) {
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index a21a465..0dbccf2 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -195,6 +195,7 @@ enum ocfs2_mount_options
 	OCFS2_MOUNT_LOCALFLOCKS = 1 << 5, /* No cluster aware user file locks */
 	OCFS2_MOUNT_NOUSERXATTR = 1 << 6, /* No user xattr */
 	OCFS2_MOUNT_INODE64 = 1 << 7,	/* Allow inode numbers > 2^32 */
+	OCFS2_MOUNT_POSIX_ACL = 1 << 8,	/* POSIX access control lists */
 };
 
 #define OCFS2_OSB_SOFT_RO	0x0001
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index ad97080..b8771fa 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -158,6 +158,8 @@ enum {
 	Opt_user_xattr,
 	Opt_nouser_xattr,
 	Opt_inode64,
+	Opt_acl,
+	Opt_noacl,
 	Opt_err,
 };
 
@@ -180,6 +182,8 @@ static match_table_t tokens = {
 	{Opt_user_xattr, "user_xattr"},
 	{Opt_nouser_xattr, "nouser_xattr"},
 	{Opt_inode64, "inode64"},
+	{Opt_acl, "acl"},
+	{Opt_noacl, "noacl"},
 	{Opt_err, NULL}
 };
 
@@ -466,6 +470,8 @@ unlock_osb:
 	if (!ret) {
 		/* Only save off the new mount options in case of a successful
 		 * remount. */
+		if (!(osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_XATTR))
+			parsed_options.mount_opt &= ~OCFS2_MOUNT_POSIX_ACL;
 		osb->s_mount_opt = parsed_options.mount_opt;
 		osb->s_atime_quantum = parsed_options.atime_quantum;
 		osb->preferred_slot = parsed_options.slot;
@@ -651,6 +657,10 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	}
 	brelse(bh);
 	bh = NULL;
+
+	if (!(osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_XATTR))
+		parsed_options.mount_opt &= ~OCFS2_MOUNT_POSIX_ACL;
+
 	osb->s_mount_opt = parsed_options.mount_opt;
 	osb->s_atime_quantum = parsed_options.atime_quantum;
 	osb->preferred_slot = parsed_options.slot;
@@ -664,6 +674,9 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	sb->s_magic = OCFS2_SUPER_MAGIC;
 
+	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
+		((osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) ? MS_POSIXACL : 0);
+
 	/* Hard readonly mode only if: bdev_read_only, MS_RDONLY,
 	 * heartbeat=none */
 	if (bdev_read_only(sb->s_bdev)) {
@@ -945,6 +958,19 @@ static int ocfs2_parse_options(struct super_block *sb,
 		case Opt_inode64:
 			mopt->mount_opt |= OCFS2_MOUNT_INODE64;
 			break;
+#ifdef CONFIG_OCFS2_FS_POSIX_ACL
+		case Opt_acl:
+			mopt->mount_opt |= OCFS2_MOUNT_POSIX_ACL;
+			break;
+		case Opt_noacl:
+			mopt->mount_opt &= ~OCFS2_MOUNT_POSIX_ACL;
+			break;
+#else
+		case Opt_acl:
+		case Opt_noacl:
+			printk(KERN_INFO "ocfs2 (no)acl options not supported\n");
+			break;
+#endif
 		default:
 			mlog(ML_ERROR,
 			     "Unrecognized mount option \"%s\" "
@@ -1017,6 +1043,13 @@ static int ocfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 	if (opts & OCFS2_MOUNT_INODE64)
 		seq_printf(s, ",inode64");
 
+#ifdef CONFIG_OCFS2_FS_POSIX_ACL
+	if (opts & OCFS2_MOUNT_POSIX_ACL)
+		seq_printf(s, ",acl");
+	else
+		seq_printf(s, ",noacl");
+#endif
+
 	return 0;
 }
 
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index e31bf54..01b7e90 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -81,6 +81,10 @@ static struct ocfs2_xattr_def_value_root def_xv = {
 
 struct xattr_handler *ocfs2_xattr_handlers[] = {
 	&ocfs2_xattr_user_handler,
+#ifdef CONFIG_OCFS2_FS_POSIX_ACL
+	&ocfs2_xattr_acl_access_handler,
+	&ocfs2_xattr_acl_default_handler,
+#endif
 	&ocfs2_xattr_trusted_handler,
 	&ocfs2_xattr_security_handler,
 	NULL
@@ -88,6 +92,12 @@ struct xattr_handler *ocfs2_xattr_handlers[] = {
 
 static struct xattr_handler *ocfs2_xattr_handler_map[] = {
 	[OCFS2_XATTR_INDEX_USER]	= &ocfs2_xattr_user_handler,
+#ifdef CONFIG_OCFS2_FS_POSIX_ACL
+	[OCFS2_XATTR_INDEX_POSIX_ACL_ACCESS]
+					= &ocfs2_xattr_acl_access_handler,
+	[OCFS2_XATTR_INDEX_POSIX_ACL_DEFAULT]
+					= &ocfs2_xattr_acl_default_handler,
+#endif
 	[OCFS2_XATTR_INDEX_TRUSTED]	= &ocfs2_xattr_trusted_handler,
 	[OCFS2_XATTR_INDEX_SECURITY]	= &ocfs2_xattr_security_handler,
 };
@@ -811,12 +821,8 @@ cleanup:
 	return ret;
 }
 
-/* ocfs2_xattr_get()
- *
- * Copy an extended attribute into the buffer provided.
- * Buffer is NULL to compute the size of buffer required.
- */
-static int ocfs2_xattr_get(struct inode *inode,
+int ocfs2_xattr_get_nolock(struct inode *inode,
+			   struct buffer_head *di_bh,
 			   int name_index,
 			   const char *name,
 			   void *buffer,
@@ -824,7 +830,6 @@ static int ocfs2_xattr_get(struct inode *inode,
 {
 	int ret;
 	struct ocfs2_dinode *di = NULL;
-	struct buffer_head *di_bh = NULL;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_xattr_search xis = {
 		.not_found = -ENODATA,
@@ -839,11 +844,6 @@ static int ocfs2_xattr_get(struct inode *inode,
 	if (!(oi->ip_dyn_features & OCFS2_HAS_XATTR_FL))
 		ret = -ENODATA;
 
-	ret = ocfs2_inode_lock(inode, &di_bh, 0);
-	if (ret < 0) {
-		mlog_errno(ret);
-		return ret;
-	}
 	xis.inode_bh = xbs.inode_bh = di_bh;
 	di = (struct ocfs2_dinode *)di_bh->b_data;
 
@@ -854,6 +854,32 @@ static int ocfs2_xattr_get(struct inode *inode,
 		ret = ocfs2_xattr_block_get(inode, name_index, name, buffer,
 					    buffer_size, &xbs);
 	up_read(&oi->ip_xattr_sem);
+
+	return ret;
+}
+
+/* ocfs2_xattr_get()
+ *
+ * Copy an extended attribute into the buffer provided.
+ * Buffer is NULL to compute the size of buffer required.
+ */
+static int ocfs2_xattr_get(struct inode *inode,
+			   int name_index,
+			   const char *name,
+			   void *buffer,
+			   size_t buffer_size)
+{
+	int ret;
+	struct buffer_head *di_bh = NULL;
+
+	ret = ocfs2_inode_lock(inode, &di_bh, 0);
+	if (ret < 0) {
+		mlog_errno(ret);
+		return ret;
+	}
+	ret = ocfs2_xattr_get_nolock(inode, di_bh, name_index,
+				     name, buffer, buffer_size);
+
 	ocfs2_inode_unlock(inode, 0);
 
 	brelse(di_bh);
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index 3b15d5b..ac03c34 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -33,9 +33,15 @@ enum ocfs2_xattr_type {
 extern struct xattr_handler ocfs2_xattr_user_handler;
 extern struct xattr_handler ocfs2_xattr_trusted_handler;
 extern struct xattr_handler ocfs2_xattr_security_handler;
+#ifdef CONFIG_OCFS2_FS_POSIX_ACL
+extern struct xattr_handler ocfs2_xattr_acl_access_handler;
+extern struct xattr_handler ocfs2_xattr_acl_default_handler;
+#endif
 extern struct xattr_handler *ocfs2_xattr_handlers[];
 
 ssize_t ocfs2_listxattr(struct dentry *, char *, size_t);
+int ocfs2_xattr_get_nolock(struct inode *, struct buffer_head *, int,
+			   const char *, void *, size_t);
 int ocfs2_xattr_set(struct inode *, int, const char *, const void *,
 		    size_t, int);
 int ocfs2_xattr_set_handle(handle_t *, struct inode *, struct buffer_head *,
-- 
1.5.4.1
