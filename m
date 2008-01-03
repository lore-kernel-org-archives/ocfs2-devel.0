From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu Jan  3 11:21:59 2008
Subject: [Ocfs2-devel] [PATCH 08/30] ocfs2: Handle struct f_path in struct
	file
In-Reply-To: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
References: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1199388006-32658-7-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit 0f7fc9e4d03987fe29f6dd4aa67e4c56eb7ecb05 in mainline added
struct path in struct file. This patch allows one to build ocfs2 with
kernels having/not having that change.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 Config.make.in              |    1 +
 Makefile                    |    3 ++-
 configure.in                |    6 ++++++
 fs/ocfs2/Makefile           |    4 ++++
 fs/ocfs2/aops.c             |    4 ++--
 fs/ocfs2/dir.c              |    2 +-
 fs/ocfs2/dlm/Makefile       |    4 ++++
 fs/ocfs2/dlm/dlmfs.c        |    4 ++--
 fs/ocfs2/file.c             |   38 +++++++++++++++++++-------------------
 fs/ocfs2/ioctl.c            |    2 +-
 fs/ocfs2/mmap.c             |   10 +++++-----
 kapi-compat/include/fpath.h |   10 ++++++++++
 12 files changed, 57 insertions(+), 31 deletions(-)
 create mode 100644 kapi-compat/include/fpath.h

diff --git a/Config.make.in b/Config.make.in
index 4208ece..34db742 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -61,6 +61,7 @@ NO_DELAYED_WORK = @NO_DELAYED_WORK@
 
 NO_SYNC_MAPPING_RANGE  = @NO_SYNC_MAPPING_RANGE@
 NO_FAULT_IN_VMOPS = @NO_FAULT_IN_VMOPS@
+NO_F_PATH_IN_STRUCT_FILE = @NO_F_PATH_IN_STRUCT_FILE@
 
 OCFS_DEBUG = @OCFS_DEBUG@
 
diff --git a/Makefile b/Makefile
index 3ddb1aa..c1ebc15 100644
--- a/Makefile
+++ b/Makefile
@@ -12,7 +12,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/workqueue.h \
 	kapi-compat/include/compiler.h \
 	kapi-compat/include/highmem.h \
-	kapi-compat/include/sync_mapping_range.h
+	kapi-compat/include/sync_mapping_range.h \
+	kapi-compat/include/fpath.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index 1aced84..62588ac 100644
--- a/configure.in
+++ b/configure.in
@@ -183,6 +183,12 @@ OCFS2_CHECK_KERNEL([fault() in struct vm_operations_struct in mm.h], mm.h,
   , NO_FAULT_IN_VMOPS=yes, [^.*int (\*fault)])
 AC_SUBST(NO_FAULT_IN_VMOPS)
 
+NO_F_PATH_IN_STRUCT_FILE=
+OCFS2_CHECK_KERNEL([f_path in fs.h], fs.h,
+  , NO_F_PATH_IN_STRUCT_FILE=yes, [f_path])
+AC_SUBST(NO_F_PATH_IN_STRUCT_FILE)
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS fpath.h"
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index cbf3118..34dfbc2 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -37,6 +37,10 @@ ifdef NO_FAULT_IN_VMOPS
 EXTRA_CFLAGS += -DNO_FAULT_IN_VMOPS
 endif
 
+ifdef NO_F_PATH_IN_STRUCT_FILE
+EXTRA_CFLAGS += -DNO_F_PATH_IN_STRUCT_FILE
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 34d1045..93c01b7 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -584,7 +584,7 @@ static void ocfs2_dio_end_io(struct kiocb *iocb,
 			     ssize_t bytes,
 			     void *private)
 {
-	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
+	struct inode *inode = filp_dentry(iocb->ki_filp)->d_inode;
 	int level;
 
 	/* this io's submitter should not have unlocked this before we could */
@@ -626,7 +626,7 @@ static ssize_t ocfs2_direct_IO(int rw,
 			       unsigned long nr_segs)
 {
 	struct file *file = iocb->ki_filp;
-	struct inode *inode = file->f_path.dentry->d_inode->i_mapping->host;
+	struct inode *inode = filp_dentry(file)->d_inode->i_mapping->host;
 	int ret;
 
 	mlog_entry_void();
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 7453b70..892001d 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -840,7 +840,7 @@ int ocfs2_dir_foreach(struct inode *inode, loff_t *f_pos, void *priv,
 int ocfs2_readdir(struct file * filp, void * dirent, filldir_t filldir)
 {
 	int error = 0;
-	struct inode *inode = filp->f_path.dentry->d_inode;
+	struct inode *inode = filp_dentry(filp)->d_inode;
 	int lock_level = 0;
 
 	mlog_entry("dirino=%llu\n",
diff --git a/fs/ocfs2/dlm/Makefile b/fs/ocfs2/dlm/Makefile
index aeae5fd..7e7abda 100644
--- a/fs/ocfs2/dlm/Makefile
+++ b/fs/ocfs2/dlm/Makefile
@@ -20,6 +20,10 @@ ifdef NO_DELAYED_WORK
 EXTRA_CFLAGS += -DNO_DELAYED_WORK
 endif
 
+ifdef NO_F_PATH_IN_STRUCT_FILE
+EXTRA_CFLAGS += -DNO_F_PATH_IN_STRUCT_FILE
+endif
+
 DLM_SOURCES =			\
 	dlmast.c		\
 	dlmconvert.c		\
diff --git a/fs/ocfs2/dlm/dlmfs.c b/fs/ocfs2/dlm/dlmfs.c
index 7418dc8..0284cdb 100644
--- a/fs/ocfs2/dlm/dlmfs.c
+++ b/fs/ocfs2/dlm/dlmfs.c
@@ -175,7 +175,7 @@ static ssize_t dlmfs_file_read(struct file *filp,
 	int bytes_left;
 	ssize_t readlen;
 	char *lvb_buf;
-	struct inode *inode = filp->f_path.dentry->d_inode;
+	struct inode *inode = filp_dentry(filp)->d_inode;
 
 	mlog(0, "inode %lu, count = %zu, *ppos = %llu\n",
 		inode->i_ino, count, *ppos);
@@ -219,7 +219,7 @@ static ssize_t dlmfs_file_write(struct file *filp,
 	int bytes_left;
 	ssize_t writelen;
 	char *lvb_buf;
-	struct inode *inode = filp->f_path.dentry->d_inode;
+	struct inode *inode = filp_dentry(filp)->d_inode;
 
 	mlog(0, "inode %lu, count = %zu, *ppos = %llu\n",
 		inode->i_ino, count, *ppos);
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index a62b14e..1ccf8ea 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -70,7 +70,7 @@ static int ocfs2_file_open(struct inode *inode, struct file *file)
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 
 	mlog_entry("(0x%p, 0x%p, '%.*s')\n", inode, file,
-		   file->f_path.dentry->d_name.len, file->f_path.dentry->d_name.name);
+		   filp_dentry(file)->d_name.len, filp_dentry(file)->d_name.name);
 
 	spin_lock(&oi->ip_lock);
 
@@ -100,8 +100,8 @@ static int ocfs2_file_release(struct inode *inode, struct file *file)
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 
 	mlog_entry("(0x%p, 0x%p, '%.*s')\n", inode, file,
-		       file->f_path.dentry->d_name.len,
-		       file->f_path.dentry->d_name.name);
+		   filp_dentry(file)->d_name.len,
+		   filp_dentry(file)->d_name.name);
 
 	spin_lock(&oi->ip_lock);
 	if (!--oi->ip_open_count)
@@ -1663,7 +1663,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 		}
 	}
 
-	if (file && should_remove_suid(file->f_path.dentry)) {
+	if (file && should_remove_suid(filp_dentry(file))) {
 		ret = __ocfs2_write_remove_suid(inode, di_bh);
 		if (ret) {
 			mlog_errno(ret);
@@ -1730,7 +1730,7 @@ out:
 int ocfs2_change_file_space(struct file *file, unsigned int cmd,
 			    struct ocfs2_space_resv *sr)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
+	struct inode *inode = filp_dentry(file)->d_inode;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);;
 
 	if ((cmd == OCFS2_IOC_RESVSP || cmd == OCFS2_IOC_RESVSP64) &&
@@ -2023,12 +2023,12 @@ static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
 	size_t count;		/* after file limit checks */
 	loff_t *ppos = &iocb->ki_pos;
 	struct file *file = iocb->ki_filp;
-	struct inode *inode = file->f_path.dentry->d_inode;
+	struct inode *inode = filp_dentry(file)->d_inode;
 
 	mlog_entry("(0x%p, %u, '%.*s')\n", file,
 		   (unsigned int)nr_segs,
-		   file->f_path.dentry->d_name.len,
-		   file->f_path.dentry->d_name.name);
+		   filp_dentry(file)->d_name.len,
+		   filp_dentry(file)->d_name.name);
 
 	if (iocb->ki_left == 0)
 		return 0;
@@ -2062,7 +2062,7 @@ relock:
 	}
 
 	can_do_direct = direct_io;
-	ret = ocfs2_prepare_inode_for_write(file->f_path.dentry, ppos,
+	ret = ocfs2_prepare_inode_for_write(filp_dentry(file), ppos,
 					    iocb->ki_left, appending,
 					    &can_do_direct);
 	if (ret < 0) {
@@ -2251,12 +2251,12 @@ static ssize_t ocfs2_file_splice_write(struct pipe_inode_info *pipe,
 				       unsigned int flags)
 {
 	int ret;
-	struct inode *inode = out->f_path.dentry->d_inode;
+	struct inode *inode = filp_dentry(out)->d_inode;
 
 	mlog_entry("(0x%p, 0x%p, %u, '%.*s')\n", out, pipe,
 		   (unsigned int)len,
-		   out->f_path.dentry->d_name.len,
-		   out->f_path.dentry->d_name.name);
+		   filp_dentry(out)->d_name.len,
+		   filp_dentry(out)->d_name.name);
 
 	inode_double_lock(inode, pipe->inode);
 
@@ -2266,7 +2266,7 @@ static ssize_t ocfs2_file_splice_write(struct pipe_inode_info *pipe,
 		goto out;
 	}
 
-	ret = ocfs2_prepare_inode_for_write(out->f_path.dentry, ppos, len, 0,
+	ret = ocfs2_prepare_inode_for_write(filp_dentry(out), ppos, len, 0,
 					    NULL);
 	if (ret < 0) {
 		mlog_errno(ret);
@@ -2292,12 +2292,12 @@ static ssize_t ocfs2_file_splice_read(struct file *in,
 				      unsigned int flags)
 {
 	int ret = 0;
-	struct inode *inode = in->f_path.dentry->d_inode;
+	struct inode *inode = filp_dentry(in)->d_inode;
 
 	mlog_entry("(0x%p, 0x%p, %u, '%.*s')\n", in, pipe,
 		   (unsigned int)len,
-		   in->f_path.dentry->d_name.len,
-		   in->f_path.dentry->d_name.name);
+		   filp_dentry(in)->d_name.len,
+		   filp_dentry(in)->d_name.name);
 
 	/*
 	 * See the comment in ocfs2_file_aio_read()
@@ -2323,12 +2323,12 @@ static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
 {
 	int ret = 0, rw_level = -1, have_alloc_sem = 0, lock_level = 0;
 	struct file *filp = iocb->ki_filp;
-	struct inode *inode = filp->f_path.dentry->d_inode;
+	struct inode *inode = filp_dentry(filp)->d_inode;
 
 	mlog_entry("(0x%p, %u, '%.*s')\n", filp,
 		   (unsigned int)nr_segs,
-		   filp->f_path.dentry->d_name.len,
-		   filp->f_path.dentry->d_name.name);
+		   filp_dentry(filp)->d_name.len,
+		   filp_dentry(filp)->d_name.name);
 
 	if (!inode) {
 		ret = -EINVAL;
diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 87dcece..135dd2f 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -148,7 +148,7 @@ int ocfs2_ioctl(struct inode * inode, struct file * filp,
 #ifdef CONFIG_COMPAT
 long ocfs2_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
+	struct inode *inode = filp_dentry(file)->d_inode;
 	int ret;
 
 	switch (cmd) {
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index a827b0b..3a09454 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -186,7 +186,7 @@ out:
 
 static int ocfs2_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 {
-	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
+	struct inode *inode = filp_dentry(vma->vm_file)->d_inode;
 	struct buffer_head *di_bh = NULL;
 	sigset_t blocked, oldset;
 	int ret, ret2;
@@ -256,16 +256,16 @@ int ocfs2_mmap(struct file *file, struct vm_area_struct *vma)
 	int ret = 0, lock_level = 0;
 
 	mlog_entry("(file=0x%p, vma=%p, '%.*s')\n", file, vma,
-		   file->f_path.dentry->d_name.len,
-		   file->f_path.dentry->d_name.name);
+		   filp_dentry(file)->d_name.len,
+		   filp_dentry(file)->d_name.name);
 
-	ret = ocfs2_meta_lock_atime(file->f_path.dentry->d_inode,
+	ret = ocfs2_meta_lock_atime(filp_dentry(file)->d_inode,
 				    file->f_vfsmnt, &lock_level);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
 	}
-	ocfs2_meta_unlock(file->f_path.dentry->d_inode, lock_level);
+	ocfs2_meta_unlock(filp_dentry(file)->d_inode, lock_level);
 out:
 	vma->vm_ops = &ocfs2_file_vm_ops;
 #ifndef NO_FAULT_IN_VMOPS
diff --git a/kapi-compat/include/fpath.h b/kapi-compat/include/fpath.h
new file mode 100644
index 0000000..a2f89e2
--- /dev/null
+++ b/kapi-compat/include/fpath.h
@@ -0,0 +1,10 @@
+#ifndef KAPI_FPATH_H
+#define KAPI_FPATH_H
+
+#ifdef NO_F_PATH_IN_STRUCT_FILE
+# define filp_dentry(i) (i)->f_dentry
+#else
+# define filp_dentry(i) (i)->f_path.dentry
+#endif
+
+#endif
-- 
1.5.2.5
