From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon Feb 11 10:53:28 2008
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: Add fops->sendfile()
In-Reply-To: <1202755969-7115-1-git-send-email-sunil.mushran@oracle.com>
References: <1202755969-7115-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1202755969-7115-4-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

fops->sendfile() was removed in 2.6.23. Re-adding as this version
of the fs is meant to also work with older kernels.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in    |    1 +
 configure.in      |    5 +++++
 fs/ocfs2/Makefile |    4 ++++
 fs/ocfs2/file.c   |   42 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index a9740e8..b7d553d 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -94,6 +94,7 @@ DIO_OLD_GET_BLOCKS = @DIO_OLD_GET_BLOCKS@
 NO_LINUX_UACCESS_H = @NO_LINUX_UACCESS_H@
 NO_SYSTEM_UTSNAME = @NO_SYSTEM_UTSNAME@
 HAS_MS_LOOP_NO_AOPS  = @HAS_MS_LOOP_NO_AOPS@
+HAS_FOPS_SENDFILE = @HAS_FOPS_SENDFILE@
 
 OCFS_DEBUG = @OCFS_DEBUG@
 
diff --git a/configure.in b/configure.in
index a1c5d19..f3544b0 100644
--- a/configure.in
+++ b/configure.in
@@ -415,6 +415,11 @@ OCFS2_CHECK_KERNEL([MS_LOOP_NO_AOPS flag defined], fs.h,
   HAS_MS_LOOP_NO_AOPS==yes, , [MS_LOOP_NO_AOPS])
 AC_SUBST(HAS_MS_LOOP_NO_AOPS)
 
+HAS_FOPS_SENDFILE=
+OCFS2_CHECK_KERNEL([fops->sendfile() in fs.h], fs.h,
+  HAS_FOPS_SENDFILE=yes, , [^.*ssize_t (\*sendfile)])
+AC_SUBST(HAS_FOPS_SENDFILE)
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 05a94c7..0b90da3 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -164,6 +164,10 @@ ifdef HAS_MS_LOOP_NO_AOPS
 EXTRA_CFLAGS += -DHAS_MS_LOOP_NO_AOPS
 endif
 
+ifdef HAS_FOPS_SENDFILE
+EXTRA_CFLAGS += -DHAS_FOPS_SENDFILE
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index e068a76..11856c2 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2465,6 +2465,45 @@ bail:
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
@@ -2511,6 +2550,9 @@ const struct file_operations ocfs2_fops = {
 	.splice_read	= ocfs2_file_splice_read,
 	.splice_write	= ocfs2_file_splice_write,
 #endif
+#ifdef HAS_FOPS_SENDFILE
+	.sendfile	= ocfs2_file_sendfile,
+#endif
 };
 
 #ifdef FOP_IS_NOT_CONST
-- 
1.5.3.4
