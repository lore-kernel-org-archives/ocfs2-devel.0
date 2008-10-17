From: Tiger Yang <tiger.yang@oracle.com>
Date: Fri, 17 Oct 2008 17:32:08 +0800
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2/xattr: some fix in xattr
In-Reply-To: <48F85A7D.2040407@oracle.com>
References: <48F85A7D.2040407@oracle.com>
Message-ID: <1224235928-24925-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch fix some function declaration problem in xattr.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/xattr.c |   52 +++++++++++++++++++++++++++++-----------------------
 fs/ocfs2/xattr.h |   38 ++++++--------------------------------
 2 files changed, 35 insertions(+), 55 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 57b51fc..fa154d3 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -3,25 +3,20 @@
  *
  * xattr.c
  *
- * Copyright (C) 2008 Oracle.  All rights reserved.
+ * Copyright (C) 2004, 2008 Oracle.  All rights reserved.
  *
  * CREDITS:
- * Lots of code in this file is taken from ext3.
+ * Lots of code in this file is copy from linux/fs/ext3/xattr.c.
+ * Copyright (C) 2001-2003 Andreas Gruenbacher, <agruen@suse.de>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public
- * License as published by the Free Software Foundation; either
- * version 2 of the License, or (at your option) any later version.
+ * License version 2 as published by the Free Software Foundation.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
  */
 
 #include <linux/capability.h>
@@ -147,6 +142,24 @@ static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
 static int ocfs2_delete_xattr_index_block(struct inode *inode,
 					  struct buffer_head *xb_bh);
 
+static inline u16 ocfs2_xattr_buckets_per_cluster(struct ocfs2_super *osb)
+{
+	return (1 << osb->s_clustersize_bits) / OCFS2_XATTR_BUCKET_SIZE;
+}
+
+static inline u16 ocfs2_blocks_per_xattr_bucket(struct super_block *sb)
+{
+	return OCFS2_XATTR_BUCKET_SIZE / (1 << sb->s_blocksize_bits);
+}
+
+static inline u16 ocfs2_xattr_max_xe_in_bucket(struct super_block *sb)
+{
+	u16 len = sb->s_blocksize -
+		 offsetof(struct ocfs2_xattr_header, xh_entries);
+
+	return len / sizeof(struct ocfs2_xattr_entry);
+}
+
 static inline const char *ocfs2_xattr_prefix(int name_index)
 {
 	struct xattr_handler *handler = NULL;
@@ -800,11 +813,11 @@ cleanup:
  * Copy an extended attribute into the buffer provided.
  * Buffer is NULL to compute the size of buffer required.
  */
-int ocfs2_xattr_get(struct inode *inode,
-		    int name_index,
-		    const char *name,
-		    void *buffer,
-		    size_t buffer_size)
+static int ocfs2_xattr_get(struct inode *inode,
+			   int name_index,
+			   const char *name,
+			   void *buffer,
+			   size_t buffer_size)
 {
 	int ret;
 	struct ocfs2_dinode *di = NULL;
@@ -4925,14 +4938,11 @@ out:
 /*
  * 'trusted' attributes support
  */
-
-#define XATTR_TRUSTED_PREFIX "trusted."
-
 static size_t ocfs2_xattr_trusted_list(struct inode *inode, char *list,
 				       size_t list_size, const char *name,
 				       size_t name_len)
 {
-	const size_t prefix_len = sizeof(XATTR_TRUSTED_PREFIX) - 1;
+	const size_t prefix_len = XATTR_TRUSTED_PREFIX_LEN;
 	const size_t total_len = prefix_len + name_len + 1;
 
 	if (list && total_len <= list_size) {
@@ -4969,18 +4979,14 @@ struct xattr_handler ocfs2_xattr_trusted_handler = {
 	.set	= ocfs2_xattr_trusted_set,
 };
 
-
 /*
  * 'user' attributes support
  */
-
-#define XATTR_USER_PREFIX "user."
-
 static size_t ocfs2_xattr_user_list(struct inode *inode, char *list,
 				    size_t list_size, const char *name,
 				    size_t name_len)
 {
-	const size_t prefix_len = sizeof(XATTR_USER_PREFIX) - 1;
+	const size_t prefix_len = XATTR_USER_PREFIX_LEN;
 	const size_t total_len = prefix_len + name_len + 1;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index c25c7c6..1d8314c 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -3,24 +3,16 @@
  *
  * xattr.h
  *
- * Function prototypes
- *
- * Copyright (C) 2008 Oracle.  All rights reserved.
+ * Copyright (C) 2004, 2008 Oracle.  All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public
- * License as published by the Free Software Foundation; either
- * version 2 of the License, or (at your option) any later version.
+ * License version 2 as published by the Free Software Foundation.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
  */
 
 #ifndef OCFS2_XATTR_H
@@ -40,29 +32,11 @@ enum ocfs2_xattr_type {
 
 extern struct xattr_handler ocfs2_xattr_user_handler;
 extern struct xattr_handler ocfs2_xattr_trusted_handler;
-
-extern ssize_t ocfs2_listxattr(struct dentry *, char *, size_t);
-extern int ocfs2_xattr_get(struct inode *, int, const char *, void *, size_t);
-extern int ocfs2_xattr_set(struct inode *, int, const char *, const void *,
-			   size_t, int);
-extern int ocfs2_xattr_remove(struct inode *inode, struct buffer_head *di_bh);
 extern struct xattr_handler *ocfs2_xattr_handlers[];
 
-static inline u16 ocfs2_xattr_buckets_per_cluster(struct ocfs2_super *osb)
-{
-	return (1 << osb->s_clustersize_bits) / OCFS2_XATTR_BUCKET_SIZE;
-}
-
-static inline u16 ocfs2_blocks_per_xattr_bucket(struct super_block *sb)
-{
-	return OCFS2_XATTR_BUCKET_SIZE / (1 << sb->s_blocksize_bits);
-}
-
-static inline u16 ocfs2_xattr_max_xe_in_bucket(struct super_block *sb)
-{
-	u16 len = sb->s_blocksize -
-		 offsetof(struct ocfs2_xattr_header, xh_entries);
+ssize_t ocfs2_listxattr(struct dentry *, char *, size_t);
+int ocfs2_xattr_set(struct inode *, int, const char *, const void *,
+		    size_t, int);
+int ocfs2_xattr_remove(struct inode *, struct buffer_head *);
 
-	return len / sizeof(struct ocfs2_xattr_entry);
-}
 #endif /* OCFS2_XATTR_H */
-- 
1.5.4.1
