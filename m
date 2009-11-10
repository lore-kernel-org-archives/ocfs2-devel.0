From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon,  9 Nov 2009 18:00:11 -0800
Subject: [Ocfs2-devel] [PATCH 08/10] ocfs2: Handle struct
	address_space_operations_ext
In-Reply-To: <1257818413-32014-1-git-send-email-sunil.mushran@oracle.com>
References: <1257818413-32014-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1257818413-32014-9-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Around in 2.6.24 or so, two new aops, write_begin() and write_end(), were added.
In that release, OCFS2 was updated to make use of these aops instead of the older
prepare_write() and commit_write().

EL5 U4 backports the new aops in a new struct address_space_operations_ext.

This patch looks for the new struct failing which looks for the new aops in
the older struct. If both lookups fail, the build errors out.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in    |    1 +
 configure.in      |   13 +++++++++++++
 fs/ocfs2/Makefile |    4 ++++
 fs/ocfs2/aops.c   |   16 ++++++++++++++++
 fs/ocfs2/inode.c  |    5 +++++
 fs/ocfs2/inode.h  |    4 ++++
 fs/ocfs2/super.c  |    4 ++++
 7 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index eb8e2a9..aead755 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -60,6 +60,7 @@ EXTRA_CFLAGS += @KAPI_COMPAT_CFLAGS@
 NO_DELAYED_WORK_STRUCT = @NO_DELAYED_WORK_STRUCT@
 NO_DLMCONSTANTS_HEADER = @NO_DLMCONSTANTS_HEADER@
 NO_F_PATH_IN_STRUCT_FILE = @NO_F_PATH_IN_STRUCT_FILE@
+ADDRESS_SPACE_OPS_EXT = @ADDRESS_SPACE_OPS_EXT@
 
 
 OCFS_DEBUG = @OCFS_DEBUG@
diff --git a/configure.in b/configure.in
index e29e6df..8179f59 100644
--- a/configure.in
+++ b/configure.in
@@ -199,6 +199,19 @@ OCFS2_CHECK_KERNEL([f_path in fs.h], fs.h,
 AC_SUBST(NO_F_PATH_IN_STRUCT_FILE)
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS fpath.h"
 
+ADDRESS_SPACE_OPS_EXT=
+OCFS2_CHECK_KERNEL([	struct address_space_operations_ext in fs.h], fs.h,
+ ADDRESS_SPACE_OPS_EXT=yes, , [^struct address_space_operations_ext {])
+AC_SUBST(ADDRESS_SPACE_OPS_EXT)
+if test "x$ADDRESS_SPACE_OPS_EXT" = "x" ; then
+  has_write_begin=
+  OCFS2_CHECK_KERNEL([	write_begin() in fs.h], fs.h,
+  has_write_begin=yes, , [int (\*write_begin)(struct file \*])
+  if test "x$has_write_begin" = "x" ; then
+    AC_MSG_ERROR(Cannot build with kernel that does not have aops->write_begin())
+  fi
+fi
+
 
 # End kapi_compat checks
 
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 86dabb1..817f9d2 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -48,6 +48,10 @@ ifdef NO_F_PATH_IN_STRUCT_FILE
 EXTRA_CFLAGS += -DNO_F_PATH_IN_STRUCT_FILE
 endif
 
+ifdef ADDRESS_SPACE_OPS_EXT
+EXTRA_CFLAGS += -DADDRESS_SPACE_OPS_EXT
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 67a3731..99ae9f0 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2009,6 +2009,7 @@ static int ocfs2_write_end(struct file *file, struct address_space *mapping,
 	return ret;
 }
 
+#ifndef ADDRESS_SPACE_OPS_EXT
 const struct address_space_operations ocfs2_aops = {
 	.readpage		= ocfs2_readpage,
 	.readpages		= ocfs2_readpages,
@@ -2024,3 +2025,18 @@ const struct address_space_operations ocfs2_aops = {
 	.is_partially_uptodate	= block_is_partially_uptodate,
 	.error_remove_page	= generic_error_remove_page,
 };
+#else
+const struct address_space_operations_ext ocfs2_aops_ext = {
+	.orig_aops.readpage		= ocfs2_readpage,
+	.orig_aops.readpages		= ocfs2_readpages,
+	.orig_aops.writepage		= ocfs2_writepage,
+	.write_begin			= ocfs2_write_begin,
+	.write_end			= ocfs2_write_end,
+	.orig_aops.bmap			= ocfs2_bmap,
+	.orig_aops.sync_page		= block_sync_page,
+	.orig_aops.direct_IO		= ocfs2_direct_IO,
+	.orig_aops.invalidatepage	= ocfs2_invalidatepage,
+	.orig_aops.releasepage		= ocfs2_releasepage,
+	.orig_aops.migratepage		= buffer_migrate_page,
+};
+#endif
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 0297fb8..d38dcdd 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -285,7 +285,12 @@ void ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
 		inode->i_blocks = 0;
 	else
 		inode->i_blocks = ocfs2_inode_sector_count(inode);
+#ifndef ADDRESS_SPACE_OPS_EXT
 	inode->i_mapping->a_ops = &ocfs2_aops;
+#else
+	inode->i_mapping->a_ops =
+		(struct address_space_operations *)&ocfs2_aops_ext;
+#endif
 	inode->i_atime.tv_sec = le64_to_cpu(fe->i_atime);
 	inode->i_atime.tv_nsec = le32_to_cpu(fe->i_atime_nsec);
 	inode->i_mtime.tv_sec = le64_to_cpu(fe->i_mtime);
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index ba4fe07..c7db724 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -111,7 +111,11 @@ static inline struct ocfs2_inode_info *OCFS2_I(struct inode *inode)
 
 extern struct kmem_cache *ocfs2_inode_cache;
 
+#ifndef ADDRESS_SPACE_OPS_EXT
 extern const struct address_space_operations ocfs2_aops;
+#else
+extern const struct address_space_operations_ext ocfs2_aops_ext;
+#endif
 extern const struct ocfs2_caching_operations ocfs2_inode_caching_ops;
 
 static inline struct ocfs2_caching_info *INODE_CACHE(struct inode *inode)
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 5f19ff5..8c8b206 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1044,6 +1044,10 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
 		((osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) ? MS_POSIXACL : 0);
 
+#ifdef ADDRESS_SPACE_OPS_EXT
+	sb->s_flags |= MS_HAS_NEW_AOPS;
+#endif
+
 	/* Hard readonly mode only if: bdev_read_only, MS_RDONLY,
 	 * heartbeat=none */
 	if (bdev_read_only(sb->s_bdev)) {
-- 
1.5.6.5
