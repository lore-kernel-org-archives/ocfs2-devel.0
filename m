From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 11 Nov 2009 12:44:57 -0800
Subject: [Ocfs2-devel] [PATCH 08/11] ocfs2: Handle struct f_path in struct
	file
In-Reply-To: <1257972298-15590-1-git-send-email-sunil.mushran@oracle.com>
References: <1257972298-15590-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1257972298-15590-5-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 0f7fc9e4d03987fe29f6dd4aa67e4c56eb7ecb05 added
struct path into struct file.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in              |    1 +
 Makefile                    |    3 ++-
 configure.in                |    6 ++++++
 fs/ocfs2/Makefile           |    4 ++++
 fs/ocfs2/aops.c             |    4 ++--
 fs/ocfs2/dir.c              |    2 +-
 fs/ocfs2/dlm/Makefile       |    4 ++++
 fs/ocfs2/dlm/dlmfs.c        |    4 ++--
 fs/ocfs2/file.c             |   36 ++++++++++++++++++------------------
 fs/ocfs2/ioctl.c            |    6 +++---
 fs/ocfs2/kapi-default.h     |    5 +++++
 fs/ocfs2/mmap.c             |    8 ++++----
 kapi-compat/include/fpath.h |    9 +++++++++
 13 files changed, 61 insertions(+), 31 deletions(-)
 create mode 100644 kapi-compat/include/fpath.h

diff --git a/Config.make.in b/Config.make.in
index 33b7a89..eb8e2a9 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -59,6 +59,7 @@ EXTRA_CFLAGS += @KAPI_COMPAT_CFLAGS@
 
 NO_DELAYED_WORK_STRUCT = @NO_DELAYED_WORK_STRUCT@
 NO_DLMCONSTANTS_HEADER = @NO_DLMCONSTANTS_HEADER@
+NO_F_PATH_IN_STRUCT_FILE = @NO_F_PATH_IN_STRUCT_FILE@
 
 
 OCFS_DEBUG = @OCFS_DEBUG@
diff --git a/Makefile b/Makefile
index 8e58c5d..6a28531 100644
--- a/Makefile
+++ b/Makefile
@@ -13,7 +13,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/dlmconstants.h		\
 	kapi-compat/include/task_pid_nr.h		\
 	kapi-compat/include/current_umask.h		\
-	kapi-compat/include/sync_mapping.h
+	kapi-compat/include/sync_mapping.h		\
+	kapi-compat/include/fpath.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index b543a9d..46f1f96 100644
--- a/configure.in
+++ b/configure.in
@@ -193,6 +193,12 @@ if test "x$do_sync_mapping_range" = "x" ; then
   KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS sync_mapping.h"
 fi
 
+NO_F_PATH_IN_STRUCT_FILE=
+OCFS2_CHECK_KERNEL([f_path in fs.h], fs.h,
+  , NO_F_PATH_IN_STRUCT_FILE=fpath.h, [struct path.*f_path])
+AC_SUBST(NO_F_PATH_IN_STRUCT_FILE)
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $NO_F_PATH_IN_STRUCT_FILE"
+
 
 # End kapi_compat checks
 
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index b2a0a7a..07d2064 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -44,6 +44,10 @@ ifdef NO_DLMCONSTANTS_HEADER
 EXTRA_CFLAGS += -DNO_DLMCONSTANTS_HEADER
 endif
 
+ifdef NO_F_PATH_IN_STRUCT_FILE
+EXTRA_CFLAGS += -DNO_F_PATH_IN_STRUCT_FILE
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index deb2b13..67a3731 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -636,7 +636,7 @@ static void ocfs2_dio_end_io(struct kiocb *iocb,
 			     ssize_t bytes,
 			     void *private)
 {
-	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
+	struct inode *inode = filp_dentry(iocb->ki_filp)->d_inode;
 	int level;
 
 	/* this io's submitter should not have unlocked this before we could */
@@ -678,7 +678,7 @@ static ssize_t ocfs2_direct_IO(int rw,
 			       unsigned long nr_segs)
 {
 	struct file *file = iocb->ki_filp;
-	struct inode *inode = file->f_path.dentry->d_inode->i_mapping->host;
+	struct inode *inode = filp_dentry(file)->d_inode->i_mapping->host;
 	int ret;
 
 	mlog_entry_void();
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 28c3ec2..69b3402 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -2025,7 +2025,7 @@ int ocfs2_dir_foreach(struct inode *inode, loff_t *f_pos, void *priv,
 int ocfs2_readdir(struct file * filp, void * dirent, filldir_t filldir)
 {
 	int error = 0;
-	struct inode *inode = filp->f_path.dentry->d_inode;
+	struct inode *inode = filp_dentry(filp)->d_inode;
 	int lock_level = 0;
 
 	mlog_entry("dirino=%llu\n",
diff --git a/fs/ocfs2/dlm/Makefile b/fs/ocfs2/dlm/Makefile
index 44b6cc6..a42d35d 100644
--- a/fs/ocfs2/dlm/Makefile
+++ b/fs/ocfs2/dlm/Makefile
@@ -26,6 +26,10 @@ ifdef NO_DELAYED_WORK_STRUCT
 EXTRA_CFLAGS += -DNO_DELAYED_WORK_STRUCT
 endif
 
+ifdef NO_F_PATH_IN_STRUCT_FILE
+EXTRA_CFLAGS += -DNO_F_PATH_IN_STRUCT_FILE
+endif
+
 DLM_SOURCES +=			\
 	dlmast.c		\
 	dlmconvert.c		\
diff --git a/fs/ocfs2/dlm/dlmfs.c b/fs/ocfs2/dlm/dlmfs.c
index 02bf178..8e293fa 100644
--- a/fs/ocfs2/dlm/dlmfs.c
+++ b/fs/ocfs2/dlm/dlmfs.c
@@ -187,7 +187,7 @@ static ssize_t dlmfs_file_read(struct file *filp,
 	int bytes_left;
 	ssize_t readlen;
 	char *lvb_buf;
-	struct inode *inode = filp->f_path.dentry->d_inode;
+	struct inode *inode = filp_dentry(filp)->d_inode;
 
 	mlog(0, "inode %lu, count = %zu, *ppos = %llu\n",
 		inode->i_ino, count, *ppos);
@@ -231,7 +231,7 @@ static ssize_t dlmfs_file_write(struct file *filp,
 	int bytes_left;
 	ssize_t writelen;
 	char *lvb_buf;
-	struct inode *inode = filp->f_path.dentry->d_inode;
+	struct inode *inode = filp_dentry(filp)->d_inode;
 
 	mlog(0, "inode %lu, count = %zu, *ppos = %llu\n",
 		inode->i_ino, count, *ppos);
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 89fc8ee..68bf44f 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -105,7 +105,7 @@ static int ocfs2_file_open(struct inode *inode, struct file *file)
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 
 	mlog_entry("(0x%p, 0x%p, '%.*s')\n", inode, file,
-		   file->f_path.dentry->d_name.len, file->f_path.dentry->d_name.name);
+		   filp_dentry(file)->d_name.len, filp_dentry(file)->d_name.name);
 
 	spin_lock(&oi->ip_lock);
 
@@ -146,8 +146,8 @@ static int ocfs2_file_release(struct inode *inode, struct file *file)
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 
 	mlog_entry("(0x%p, 0x%p, '%.*s')\n", inode, file,
-		       file->f_path.dentry->d_name.len,
-		       file->f_path.dentry->d_name.name);
+		       filp_dentry(file)->d_name.len,
+		       filp_dentry(file)->d_name.name);
 
 	spin_lock(&oi->ip_lock);
 	if (!--oi->ip_open_count)
@@ -1593,7 +1593,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 		}
 	}
 
-	if (file && should_remove_suid(file->f_path.dentry)) {
+	if (file && should_remove_suid(filp_dentry(file))) {
 		ret = __ocfs2_write_remove_suid(inode, di_bh);
 		if (ret) {
 			mlog_errno(ret);
@@ -1660,7 +1660,7 @@ out:
 int ocfs2_change_file_space(struct file *file, unsigned int cmd,
 			    struct ocfs2_space_resv *sr)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
+	struct inode *inode = filp_dentry(file)->d_inode;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	if ((cmd == OCFS2_IOC_RESVSP || cmd == OCFS2_IOC_RESVSP64) &&
@@ -1905,13 +1905,13 @@ static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
 	loff_t old_size, *ppos = &iocb->ki_pos;
 	u32 old_clusters;
 	struct file *file = iocb->ki_filp;
-	struct inode *inode = file->f_path.dentry->d_inode;
+	struct inode *inode = filp_dentry(file)->d_inode;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	mlog_entry("(0x%p, %u, '%.*s')\n", file,
 		   (unsigned int)nr_segs,
-		   file->f_path.dentry->d_name.len,
-		   file->f_path.dentry->d_name.name);
+		   filp_dentry(file)->d_name.len,
+		   filp_dentry(file)->d_name.name);
 
 	if (iocb->ki_left == 0)
 		return 0;
@@ -1939,7 +1939,7 @@ relock:
 	}
 
 	can_do_direct = direct_io;
-	ret = ocfs2_prepare_inode_for_write(file->f_path.dentry, ppos,
+	ret = ocfs2_prepare_inode_for_write(filp_dentry(file), ppos,
 					    iocb->ki_left, appending,
 					    &can_do_direct);
 	if (ret < 0) {
@@ -2060,7 +2060,7 @@ static int ocfs2_splice_to_file(struct pipe_inode_info *pipe,
 {
 	int ret;
 
-	ret = ocfs2_prepare_inode_for_write(out->f_path.dentry,	&sd->pos,
+	ret = ocfs2_prepare_inode_for_write(filp_dentry(out), &sd->pos,
 					    sd->total_len, 0, NULL);
 	if (ret < 0) {
 		mlog_errno(ret);
@@ -2088,8 +2088,8 @@ static ssize_t ocfs2_file_splice_write(struct pipe_inode_info *pipe,
 
 	mlog_entry("(0x%p, 0x%p, %u, '%.*s')\n", out, pipe,
 		   (unsigned int)len,
-		   out->f_path.dentry->d_name.len,
-		   out->f_path.dentry->d_name.name);
+		   filp_dentry(out)->d_name.len,
+		   filp_dentry(out)->d_name.name);
 
 	if (pipe->inode)
 		mutex_lock_nested(&pipe->inode->i_mutex, I_MUTEX_PARENT);
@@ -2144,12 +2144,12 @@ static ssize_t ocfs2_file_splice_read(struct file *in,
 				      unsigned int flags)
 {
 	int ret = 0, lock_level = 0;
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
@@ -2175,12 +2175,12 @@ static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
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
index 31fbb06..857b409 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -110,7 +110,7 @@ bail:
 
 long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
-	struct inode *inode = filp->f_path.dentry->d_inode;
+	struct inode *inode = filp_dentry(filp)->d_inode;
 	unsigned int flags;
 	int new_clusters;
 	int status;
@@ -132,12 +132,12 @@ long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		if (get_user(flags, (int __user *) arg))
 			return -EFAULT;
 
-		status = mnt_want_write(filp->f_path.mnt);
+		status = mnt_want_write(filp_mnt(filp));
 		if (status)
 			return status;
 		status = ocfs2_set_inode_attr(inode, flags,
 			OCFS2_FL_MODIFIABLE);
-		mnt_drop_write(filp->f_path.mnt);
+		mnt_drop_write(filp_mnt(filp));
 		return status;
 	case OCFS2_IOC_RESVSP:
 	case OCFS2_IOC_RESVSP64:
diff --git a/fs/ocfs2/kapi-default.h b/fs/ocfs2/kapi-default.h
index 21e5e3a..bb642ae 100644
--- a/fs/ocfs2/kapi-default.h
+++ b/fs/ocfs2/kapi-default.h
@@ -29,4 +29,9 @@ typedef struct work_struct kapi_work_struct_t;
 # define KAPI_INIT_DELAYED_WORK(a, b, c)	INIT_DELAYED_WORK(a, b)
 #endif
 
+#ifndef filp_dentry
+# define filp_dentry(i) (i)->f_path.dentry
+# define filp_mnt(i)    (i)->f_path.mnt
+#endif
+
 #endif
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index 3973761..55afd11 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -157,7 +157,7 @@ out:
 static int ocfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct page *page = vmf->page;
-	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
+	struct inode *inode = filp_dentry(vma->vm_file)->d_inode;
 	struct buffer_head *di_bh = NULL;
 	sigset_t blocked, oldset;
 	int ret, ret2;
@@ -211,13 +211,13 @@ int ocfs2_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	int ret = 0, lock_level = 0;
 
-	ret = ocfs2_inode_lock_atime(file->f_dentry->d_inode,
-				    file->f_vfsmnt, &lock_level);
+	ret = ocfs2_inode_lock_atime(filp_dentry(file)->d_inode,
+				     filp_mnt(file), &lock_level);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
 	}
-	ocfs2_inode_unlock(file->f_dentry->d_inode, lock_level);
+	ocfs2_inode_unlock(filp_dentry(file)->d_inode, lock_level);
 out:
 	vma->vm_ops = &ocfs2_file_vm_ops;
 	vma->vm_flags |= VM_CAN_NONLINEAR;
diff --git a/kapi-compat/include/fpath.h b/kapi-compat/include/fpath.h
new file mode 100644
index 0000000..52a1655
--- /dev/null
+++ b/kapi-compat/include/fpath.h
@@ -0,0 +1,9 @@
+#ifndef KAPI_FPATH_H
+#define KAPI_FPATH_H
+
+#ifdef NO_F_PATH_IN_STRUCT_FILE
+# define filp_dentry(i) (i)->f_dentry
+# define filp_mnt(i)    (i)->f_vfsmnt
+#endif
+
+#endif
-- 
1.5.6.5
