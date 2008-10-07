From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 7 Oct 2008 15:08:11 -0700
Subject: [Ocfs2-devel] [PATCH 13/39] ocfs2: Add extended attribute
	support
In-Reply-To: <20081002081644.GB24717@lst.de>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
	<1222293680-15451-14-git-send-email-mfasheh@suse.com>
	<20081002081644.GB24717@lst.de>
Message-ID: <20081007220811.GG26373@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Tao Ma <tao.ma@oracle.com>

On Thu, Oct 02, 2008 at 10:16:44AM +0200, Christoph Hellwig wrote:
> On Wed, Sep 24, 2008 at 03:00:54PM -0700, Mark Fasheh wrote:
> >  	xattr.o			\
> > +	xattr_user.o		\
> > +	xattr_trusted.o
> 
> Please don't split this up, it's always been a really stupid idea in
> extN.  The only difference between secure, trusted and user attrs is
> that they go into a different namespace bit (and have different
> permission checking, but that's handled in the VFS).  I have some
> upcoming patches to store a fs private flag in struct xattr_handler
> so that even those flags wrappers can go away, and each of the
> namespaces will just be five lines of code for the xattr_handler
> declaration.

Ok. The following patch (in ocfs2.git now) removes those two files, and puts
the code for user and trusted xattrs at the bottom of xattr.c. Is that
mainly what you were getting at here?


> > +static inline struct xattr_handler *ocfs2_xattr_handler(int name_index)
> > +{
> > +	struct xattr_handler *handler = NULL;
> > +
> > +	if (name_index > 0 && name_index < OCFS2_XATTR_MAX)
> > +		handler = ocfs2_xattr_handler_map[name_index];
> > +
> > +	return handler;
> > +}
> 
> You seem to need the handler mostly for getting back to the prefix
> from the handler.  This is a pretty clear indicator that you don't
> want to use the xattr_handler splitting but deal with the whole
> attr name.  Take a look at the btrfs code after my recent xattr changes
> on how to handle this more nicely.

Tao, Can you look into this?


> > +
> > +static inline u32 ocfs2_xattr_name_hash(struct inode *inode,
> > +					char *prefix,
> > +					int prefix_len,
> > +					char *name,
> > +					int name_len)
> 
> And I think there's far too much inlining going on in here..

Yep, I went ahead and un-inlined that function.

Thanks for the review,
	--Mark

--
Mark Fasheh

From: Mark Fasheh <mfasheh@suse.com>

ocfs2: Move trusted and user attribute support into xattr.c

Per Christoph Hellwig's suggestion - don't split these up. It's not like we
gained much by having the two tiny files around.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/Makefile        |    4 +-
 fs/ocfs2/xattr.c         |  110 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/xattr_trusted.c |   82 ----------------------------------
 fs/ocfs2/xattr_user.c    |   94 ---------------------------------------
 4 files changed, 111 insertions(+), 179 deletions(-)
 delete mode 100644 fs/ocfs2/xattr_trusted.c
 delete mode 100644 fs/ocfs2/xattr_user.c

diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 21323da..589dcdf 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -35,9 +35,7 @@ ocfs2-objs := \
 	sysfile.o 		\
 	uptodate.o		\
 	ver.o			\
-	xattr.o			\
-	xattr_user.o		\
-	xattr_trusted.o
+	xattr.o
 
 ocfs2_stackglue-objs := stackglue.o
 ocfs2_stack_o2cb-objs := stack_o2cb.o
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index e21a1a8..0f556b0 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -37,6 +37,9 @@
 #include <linux/writeback.h>
 #include <linux/falloc.h>
 #include <linux/sort.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/string.h>
 
 #define MLOG_MASK_PREFIX ML_XATTR
 #include <cluster/masklog.h>
@@ -4740,3 +4743,110 @@ static int ocfs2_delete_xattr_index_block(struct inode *inode,
 out:
 	return ret;
 }
+
+/*
+ * 'trusted' attributes support
+ */
+
+#define XATTR_TRUSTED_PREFIX "trusted."
+
+static size_t ocfs2_xattr_trusted_list(struct inode *inode, char *list,
+				       size_t list_size, const char *name,
+				       size_t name_len)
+{
+	const size_t prefix_len = sizeof(XATTR_TRUSTED_PREFIX) - 1;
+	const size_t total_len = prefix_len + name_len + 1;
+
+	if (list && total_len <= list_size) {
+		memcpy(list, XATTR_TRUSTED_PREFIX, prefix_len);
+		memcpy(list + prefix_len, name, name_len);
+		list[prefix_len + name_len] = '\0';
+	}
+	return total_len;
+}
+
+static int ocfs2_xattr_trusted_get(struct inode *inode, const char *name,
+				   void *buffer, size_t size)
+{
+	if (strcmp(name, "") == 0)
+		return -EINVAL;
+	return ocfs2_xattr_get(inode, OCFS2_XATTR_INDEX_TRUSTED, name,
+			       buffer, size);
+}
+
+static int ocfs2_xattr_trusted_set(struct inode *inode, const char *name,
+				   const void *value, size_t size, int flags)
+{
+	if (strcmp(name, "") == 0)
+		return -EINVAL;
+
+	return ocfs2_xattr_set(inode, OCFS2_XATTR_INDEX_TRUSTED, name, value,
+			       size, flags);
+}
+
+struct xattr_handler ocfs2_xattr_trusted_handler = {
+	.prefix	= XATTR_TRUSTED_PREFIX,
+	.list	= ocfs2_xattr_trusted_list,
+	.get	= ocfs2_xattr_trusted_get,
+	.set	= ocfs2_xattr_trusted_set,
+};
+
+
+/*
+ * 'user' attributes support
+ */
+
+#define XATTR_USER_PREFIX "user."
+
+static size_t ocfs2_xattr_user_list(struct inode *inode, char *list,
+				    size_t list_size, const char *name,
+				    size_t name_len)
+{
+	const size_t prefix_len = sizeof(XATTR_USER_PREFIX) - 1;
+	const size_t total_len = prefix_len + name_len + 1;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	if (osb->s_mount_opt & OCFS2_MOUNT_NOUSERXATTR)
+		return 0;
+
+	if (list && total_len <= list_size) {
+		memcpy(list, XATTR_USER_PREFIX, prefix_len);
+		memcpy(list + prefix_len, name, name_len);
+		list[prefix_len + name_len] = '\0';
+	}
+	return total_len;
+}
+
+static int ocfs2_xattr_user_get(struct inode *inode, const char *name,
+				void *buffer, size_t size)
+{
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	if (strcmp(name, "") == 0)
+		return -EINVAL;
+	if (osb->s_mount_opt & OCFS2_MOUNT_NOUSERXATTR)
+		return -EOPNOTSUPP;
+	return ocfs2_xattr_get(inode, OCFS2_XATTR_INDEX_USER, name,
+			       buffer, size);
+}
+
+static int ocfs2_xattr_user_set(struct inode *inode, const char *name,
+				const void *value, size_t size, int flags)
+{
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	if (strcmp(name, "") == 0)
+		return -EINVAL;
+	if (osb->s_mount_opt & OCFS2_MOUNT_NOUSERXATTR)
+		return -EOPNOTSUPP;
+
+	return ocfs2_xattr_set(inode, OCFS2_XATTR_INDEX_USER, name, value,
+			       size, flags);
+}
+
+struct xattr_handler ocfs2_xattr_user_handler = {
+	.prefix	= XATTR_USER_PREFIX,
+	.list	= ocfs2_xattr_user_list,
+	.get	= ocfs2_xattr_user_get,
+	.set	= ocfs2_xattr_user_set,
+};
diff --git a/fs/ocfs2/xattr_trusted.c b/fs/ocfs2/xattr_trusted.c
deleted file mode 100644
index 4c589c4..0000000
--- a/fs/ocfs2/xattr_trusted.c
+++ /dev/null
@@ -1,82 +0,0 @@
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
- * xattr_trusted.c
- *
- * Copyright (C) 2008 Oracle.  All rights reserved.
- *
- * CREDITS:
- * Lots of code in this file is taken from ext3.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License as published by the Free Software Foundation; either
- * version 2 of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
- */
-
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/string.h>
-
-#define MLOG_MASK_PREFIX ML_INODE
-#include <cluster/masklog.h>
-
-#include "ocfs2.h"
-#include "alloc.h"
-#include "dlmglue.h"
-#include "file.h"
-#include "ocfs2_fs.h"
-#include "xattr.h"
-
-#define XATTR_TRUSTED_PREFIX "trusted."
-
-static size_t ocfs2_xattr_trusted_list(struct inode *inode, char *list,
-				       size_t list_size, const char *name,
-				       size_t name_len)
-{
-	const size_t prefix_len = sizeof(XATTR_TRUSTED_PREFIX) - 1;
-	const size_t total_len = prefix_len + name_len + 1;
-
-	if (list && total_len <= list_size) {
-		memcpy(list, XATTR_TRUSTED_PREFIX, prefix_len);
-		memcpy(list + prefix_len, name, name_len);
-		list[prefix_len + name_len] = '\0';
-	}
-	return total_len;
-}
-
-static int ocfs2_xattr_trusted_get(struct inode *inode, const char *name,
-				   void *buffer, size_t size)
-{
-	if (strcmp(name, "") == 0)
-		return -EINVAL;
-	return ocfs2_xattr_get(inode, OCFS2_XATTR_INDEX_TRUSTED, name,
-			       buffer, size);
-}
-
-static int ocfs2_xattr_trusted_set(struct inode *inode, const char *name,
-				   const void *value, size_t size, int flags)
-{
-	if (strcmp(name, "") == 0)
-		return -EINVAL;
-
-	return ocfs2_xattr_set(inode, OCFS2_XATTR_INDEX_TRUSTED, name, value,
-			       size, flags);
-}
-
-struct xattr_handler ocfs2_xattr_trusted_handler = {
-	.prefix	= XATTR_TRUSTED_PREFIX,
-	.list	= ocfs2_xattr_trusted_list,
-	.get	= ocfs2_xattr_trusted_get,
-	.set	= ocfs2_xattr_trusted_set,
-};
diff --git a/fs/ocfs2/xattr_user.c b/fs/ocfs2/xattr_user.c
deleted file mode 100644
index 93ba716..0000000
--- a/fs/ocfs2/xattr_user.c
+++ /dev/null
@@ -1,94 +0,0 @@
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
- * xattr_user.c
- *
- * Copyright (C) 2008 Oracle.  All rights reserved.
- *
- * CREDITS:
- * Lots of code in this file is taken from ext3.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License as published by the Free Software Foundation; either
- * version 2 of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
- */
-
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/string.h>
-
-#define MLOG_MASK_PREFIX ML_INODE
-#include <cluster/masklog.h>
-
-#include "ocfs2.h"
-#include "alloc.h"
-#include "dlmglue.h"
-#include "file.h"
-#include "ocfs2_fs.h"
-#include "xattr.h"
-
-#define XATTR_USER_PREFIX "user."
-
-static size_t ocfs2_xattr_user_list(struct inode *inode, char *list,
-				    size_t list_size, const char *name,
-				    size_t name_len)
-{
-	const size_t prefix_len = sizeof(XATTR_USER_PREFIX) - 1;
-	const size_t total_len = prefix_len + name_len + 1;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-
-	if (osb->s_mount_opt & OCFS2_MOUNT_NOUSERXATTR)
-		return 0;
-
-	if (list && total_len <= list_size) {
-		memcpy(list, XATTR_USER_PREFIX, prefix_len);
-		memcpy(list + prefix_len, name, name_len);
-		list[prefix_len + name_len] = '\0';
-	}
-	return total_len;
-}
-
-static int ocfs2_xattr_user_get(struct inode *inode, const char *name,
-				void *buffer, size_t size)
-{
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-
-	if (strcmp(name, "") == 0)
-		return -EINVAL;
-	if (osb->s_mount_opt & OCFS2_MOUNT_NOUSERXATTR)
-		return -EOPNOTSUPP;
-	return ocfs2_xattr_get(inode, OCFS2_XATTR_INDEX_USER, name,
-			       buffer, size);
-}
-
-static int ocfs2_xattr_user_set(struct inode *inode, const char *name,
-				const void *value, size_t size, int flags)
-{
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-
-	if (strcmp(name, "") == 0)
-		return -EINVAL;
-	if (osb->s_mount_opt & OCFS2_MOUNT_NOUSERXATTR)
-		return -EOPNOTSUPP;
-
-	return ocfs2_xattr_set(inode, OCFS2_XATTR_INDEX_USER, name, value,
-			       size, flags);
-}
-
-struct xattr_handler ocfs2_xattr_user_handler = {
-	.prefix	= XATTR_USER_PREFIX,
-	.list	= ocfs2_xattr_user_list,
-	.get	= ocfs2_xattr_user_get,
-	.set	= ocfs2_xattr_user_set,
-};
-- 
1.5.4.1
