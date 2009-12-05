From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri,  4 Dec 2009 17:54:06 -0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: Enable NFS support
In-Reply-To: <1259978046-5692-1-git-send-email-sunil.mushran@oracle.com>
References: <1259978046-5692-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1259978046-5692-4-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commits 6e91ea2bb0b6a3ddf6d4faeb54a9c20d4e20bc42 and
2596110a3994593f6aa3e2bb76345ad4791b1a14 changed the exportfs api.

This patch adds support for the old exportfs api by enabling export_ops.decode_fh()
and export_ops.get_dentry().

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in    |    1 +
 configure.in      |    5 ++++
 fs/ocfs2/Makefile |    4 +++
 fs/ocfs2/export.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/export.h |    2 +
 5 files changed, 72 insertions(+), 0 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index 8675982..304fd76 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -83,6 +83,7 @@ SKIP_BUFFER_TRIGGERS = @SKIP_BUFFER_TRIGGERS@
 NO_NAME_IN_BACKING_DEV_INFO=@NO_NAME_IN_BACKING_DEV_INFO@
 NO_KOBJ_ATTRIBUTE = @NO_KOBJ_ATTRIBUTE@
 SKIP_QUOTAS= @SKIP_QUOTAS@
+NFS_OLD_API=@NFS_OLD_API@
 
 
 OCFS_DEBUG = @OCFS_DEBUG@
diff --git a/configure.in b/configure.in
index 6b83f8c..ebb0a34 100644
--- a/configure.in
+++ b/configure.in
@@ -457,6 +457,11 @@ OCFS2_CHECK_KERNEL([cancel_work_sync() in workqueue.h], workqueue.h,
  , cancel_work_sync_header=cancel_work_sync.h, [extern int cancel_work_sync(struct work_struct])
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $cancel_work_sync_header"
 
+NFS_OLD_API=
+OCFS2_CHECK_KERNEL([existence of exportfs.h], exportfs.h,
+ , NFS_OLD_API=yes, [enum fid_type {])
+AC_SUBST(NFS_OLD_API)
+
 # End kapi_compat checks
 
 # using -include has two advantages:
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 7a03c94..9f8115d 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -132,6 +132,10 @@ ifdef SKIP_QUOTAS
 EXTRA_CFLAGS += -DSKIP_QUOTAS
 endif
 
+ifdef NFS_OLD_API
+EXTRA_CFLAGS += -DNFS_OLD_API
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
index fce7d23..00dcb59 100644
--- a/fs/ocfs2/export.c
+++ b/fs/ocfs2/export.c
@@ -47,10 +47,17 @@ struct ocfs2_inode_handle
 	u32 ih_generation;
 };
 
+#ifdef NFS_OLD_API
+static struct dentry *ocfs2_get_dentry(struct super_block *sb, void *vobjp)
+#else
 static struct dentry *ocfs2_get_dentry(struct super_block *sb,
 		struct ocfs2_inode_handle *handle)
+#endif
 {
 	struct inode *inode;
+#ifdef NFS_OLD_API
+	struct ocfs2_inode_handle *handle = vobjp;
+#endif
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 	u64 blkno = handle->ih_blkno;
 	int status, set;
@@ -247,6 +254,53 @@ bail:
 	return type;
 }
 
+#ifdef NFS_OLD_API
+static struct dentry *ocfs2_decode_fh(struct super_block *sb, u32 *fh_in,
+				      int fh_len, int fileid_type,
+				      int (*acceptable)(void *context,
+						        struct dentry *de),
+				      void *context)
+{
+	struct ocfs2_inode_handle handle, parent;
+	struct dentry *ret = NULL;
+	__le32 *fh = (__force __le32 *) fh_in;
+
+	mlog_entry("(0x%p, 0x%p, %d, %d, 0x%p, 0x%p)\n",
+		   sb, fh, fh_len, fileid_type, acceptable, context);
+
+	if (fh_len < 3 || fileid_type > 2)
+		goto bail;
+
+	if (fileid_type == 2) {
+		if (fh_len < 6)
+			goto bail;
+
+		parent.ih_blkno = (u64)le32_to_cpu(fh[3]) << 32;
+		parent.ih_blkno |= (u64)le32_to_cpu(fh[4]);
+		parent.ih_generation = le32_to_cpu(fh[5]);
+
+		mlog(0, "Decoding parent: blkno: %llu, generation: %u\n",
+		     (unsigned long long)parent.ih_blkno,
+		     parent.ih_generation);
+	}
+
+	handle.ih_blkno = (u64)le32_to_cpu(fh[0]) << 32;
+	handle.ih_blkno |= (u64)le32_to_cpu(fh[1]);
+	handle.ih_generation = le32_to_cpu(fh[2]);
+
+	mlog(0, "Encoding fh: blkno: %llu, generation: %u\n",
+	     (unsigned long long)handle.ih_blkno, handle.ih_generation);
+
+	ret = ocfs2_export_ops.find_exported_dentry(sb, &handle, &parent,
+						    acceptable, context);
+
+bail:
+	mlog_exit_ptr(ret);
+	return ret;
+}
+
+#else	/* ! NFS_OLD_API */
+
 static struct dentry *ocfs2_fh_to_dentry(struct super_block *sb,
 		struct fid *fid, int fh_len, int fh_type)
 {
@@ -274,6 +328,7 @@ static struct dentry *ocfs2_fh_to_parent(struct super_block *sb,
 	parent.ih_generation = le32_to_cpu(fid->raw[5]);
 	return ocfs2_get_dentry(sb, &parent);
 }
+#endif	/* NFS_OLD_API */
 
 #ifdef EXPORTOP_IS_NOT_CONST
 struct export_operations ocfs2_export_ops = {
@@ -281,7 +336,12 @@ struct export_operations ocfs2_export_ops = {
 const struct export_operations ocfs2_export_ops = {
 #endif
 	.encode_fh	= ocfs2_encode_fh,
+#ifdef NFS_OLD_API
+	.get_dentry	= ocfs2_get_dentry,
+	.decode_fh	= ocfs2_decode_fh,
+#else
 	.fh_to_dentry	= ocfs2_fh_to_dentry,
 	.fh_to_parent	= ocfs2_fh_to_parent,
+#endif
 	.get_parent	= ocfs2_get_parent,
 };
diff --git a/fs/ocfs2/export.h b/fs/ocfs2/export.h
index 0707bf3..2cac2a6 100644
--- a/fs/ocfs2/export.h
+++ b/fs/ocfs2/export.h
@@ -26,7 +26,9 @@
 #ifndef OCFS2_EXPORT_H
 #define OCFS2_EXPORT_H
 
+#ifndef NFS_OLD_API
 #include <linux/exportfs.h>
+#endif
 
 #ifdef EXPORTOP_IS_NOT_CONST
 extern struct export_operations ocfs2_export_ops;
-- 
1.6.3.3
