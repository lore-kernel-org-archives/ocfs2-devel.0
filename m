From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 12 Nov 2009 17:47:39 -0800
Subject: [Ocfs2-devel] [PATCH 18/18] ocfs2: Add fops->sendfile()
In-Reply-To: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
References: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1258076859-13538-19-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

fops->sendfile() was removed in 2.6.23. Patch re-adds it and uses it
if built with EL5.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in    |    1 +
 configure.in      |    5 +++++
 fs/ocfs2/Makefile |    4 ++++
 fs/ocfs2/file.c   |   45 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index 4b5f4c3..02b8c9c 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -77,6 +77,7 @@ OLD_BIO_END_IO_T = @OLD_BIO_END_IO_T@
 NO_FAULT_IN_VMOPS = @NO_FAULT_IN_VMOPS@
 GET_RETURNS_U64_IN_SIMPLE_ATTR_OPEN = @GET_RETURNS_U64_IN_SIMPLE_ATTR_OPEN@
 NO_SHOULD_REMOVE_SUID = @NO_SHOULD_REMOVE_SUID@
+HAS_FOPS_SENDFILE = @HAS_FOPS_SENDFILE@
 
 
 OCFS_DEBUG = @OCFS_DEBUG@
diff --git a/configure.in b/configure.in
index a992f4b..5bc9d42 100644
--- a/configure.in
+++ b/configure.in
@@ -409,6 +409,11 @@ OCFS2_CHECK_KERNEL([filemap_fdatawait_range() in fs.h], fs.h,
  , fdatawait_header=filemap_fdatawait_range.h, [extern int filemap_fdatawait_range(struct address_space \*,])
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $fdatawait_header"
 
+HAS_FOPS_SENDFILE=
+OCFS2_CHECK_KERNEL([	fops->sendfile() in fs.h], fs.h,
+  HAS_FOPS_SENDFILE=yes, , [^.*ssize_t (\*sendfile)])
+AC_SUBST(HAS_FOPS_SENDFILE)
+
 # End kapi_compat checks
 
 # using -include has two advantages:
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 4a4c250..2e85623 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -110,6 +110,10 @@ FS_SOURCES += compat_should_remove_suid.c
 EXTRA_CFLAGS += -DNO_SHOULD_REMOVE_SUID
 endif
 
+ifdef HAS_FOPS_SENDFILE
+EXTRA_CFLAGS += -DHAS_FOPS_SENDFILE
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 1367586..de75f5a 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2249,6 +2249,45 @@ bail:
 	return ret;
 }
 
+#ifdef HAS_FOPS_SENDFILE
+static ssize_t ocfs2_file_sendfile(struct file *in_file,
+				   loff_t *ppos,
+				   size_t count,
+				   read_actor_t actor,
+				   void *target)
+{
+	int ret;
+	struct inode *inode = in_file->f_mapping->host;
+
+	mlog_entry("inode %llu, ppos %lld, count = %u\n",
+		   (unsigned long long)OCFS2_I(inode)->ip_blkno,
+		   (long long) *ppos,
+		   (unsigned int) count);
+
+	/* Obviously, there is no user buffer to worry about here --
+	 * this simplifies locking, so no need to walk vmas a la
+	 * read/write. We take the cluster lock against the inode
+	 * and call generic_file_sendfile. */
+	ret = ocfs2_inode_lock(inode, NULL, 0);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto bail;
+	}
+
+	down_read(&OCFS2_I(inode)->ip_alloc_sem);
+
+	ret = generic_file_sendfile(in_file, ppos, count, actor, target);
+
+	up_read(&OCFS2_I(inode)->ip_alloc_sem);
+
+	ocfs2_inode_unlock(inode, 0);
+
+bail:
+	mlog_exit(ret);
+	return ret;
+}
+#endif
+
 #ifdef IOP_IS_NOT_CONST
 struct inode_operations ocfs2_file_iops = {
 #else
@@ -2297,6 +2336,9 @@ const struct file_operations ocfs2_fops = {
 	.flock		= ocfs2_flock,
 	.splice_read	= ocfs2_file_splice_read,
 	.splice_write	= ocfs2_file_splice_write,
+#ifdef HAS_FOPS_SENDFILE
+	.sendfile	= ocfs2_file_sendfile,
+#endif
 };
 
 const struct file_operations ocfs2_dops = {
@@ -2343,6 +2385,9 @@ const struct file_operations ocfs2_fops_no_plocks = {
 	.flock		= ocfs2_flock,
 	.splice_read	= ocfs2_file_splice_read,
 	.splice_write	= ocfs2_file_splice_write,
+#ifdef HAS_FOPS_SENDFILE
+	.sendfile	= ocfs2_file_sendfile,
+#endif
 };
 
 const struct file_operations ocfs2_dops_no_plocks = {
-- 
1.5.6.5
