From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu Jan  3 11:21:58 2008
Subject: [Ocfs2-devel] [PATCH 07/30] ocfs2: Handle missing vmops->fault()
In-Reply-To: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
References: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1199388006-32658-6-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit 54cb8821de07f2ffcd28c380ce9b93d5784b40d7 in mainline introduces
vmops->fault() which is used to replace vmops->populate() and vmops->nopage().
This patch allows one to build ocfs2 with kernels having/not having this
change.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 Config.make.in    |    1 +
 configure.in      |    5 ++++
 fs/ocfs2/Makefile |    4 +++
 fs/ocfs2/mmap.c   |   55 +++++++++++++++++++++++++++++++++++++++++++++++++---
 4 files changed, 61 insertions(+), 4 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index 67ee363..4208ece 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -60,6 +60,7 @@ EXTRA_CFLAGS += @KAPI_COMPAT_CFLAGS@
 NO_DELAYED_WORK = @NO_DELAYED_WORK@
 
 NO_SYNC_MAPPING_RANGE  = @NO_SYNC_MAPPING_RANGE@
+NO_FAULT_IN_VMOPS = @NO_FAULT_IN_VMOPS@
 
 OCFS_DEBUG = @OCFS_DEBUG@
 
diff --git a/configure.in b/configure.in
index 72698ae..1aced84 100644
--- a/configure.in
+++ b/configure.in
@@ -178,6 +178,11 @@ OCFS2_CHECK_KERNEL([do_sync_mapping_range() in fs.h], fs.h,
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS sync_mapping_range.h"
 AC_SUBST(NO_SYNC_MAPPING_RANGE)
 
+NO_FAULT_IN_VMOPS=
+OCFS2_CHECK_KERNEL([fault() in struct vm_operations_struct in mm.h], mm.h,
+  , NO_FAULT_IN_VMOPS=yes, [^.*int (\*fault)])
+AC_SUBST(NO_FAULT_IN_VMOPS)
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 737c12a..cbf3118 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -33,6 +33,10 @@ ifdef NO_SYNC_MAPPING_RANGE
 CFLAGS_alloc.o += -DNO_SYNC_MAPPING_RANGE
 endif
 
+ifdef NO_FAULT_IN_VMOPS
+EXTRA_CFLAGS += -DNO_FAULT_IN_VMOPS
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index 9875615..a827b0b 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -60,6 +60,7 @@ static inline int ocfs2_vm_op_unblock_sigs(sigset_t *oldset)
 	return sigprocmask(SIG_SETMASK, oldset, NULL);
 }
 
+#ifndef NO_FAULT_IN_VMOPS
 static int ocfs2_fault(struct vm_area_struct *area, struct vm_fault *vmf)
 {
 	sigset_t blocked, oldset;
@@ -83,6 +84,35 @@ out:
 	mlog_exit_ptr(vmf->page);
 	return ret;
 }
+#else
+static struct page *ocfs2_nopage(struct vm_area_struct * area,
+				 unsigned long address,
+				 int *type)
+{
+	struct page *page = NOPAGE_SIGBUS;
+	sigset_t blocked, oldset;
+	int error, ret;
+
+	mlog_entry("(area=%p, address=%lu, type=%p)\n", area, address,
+		   type);
+
+	error = ocfs2_vm_op_block_sigs(&blocked, &oldset);
+	if (error < 0) {
+		mlog_errno(error);
+		ret = VM_FAULT_SIGBUS;
+		goto out;
+	}
+
+	page = filemap_nopage(area, address, type);
+
+	error = ocfs2_vm_op_unblock_sigs(&oldset);
+	if (error < 0)
+		mlog_errno(error);
+out:
+	mlog_exit_ptr(page);
+	return page;
+}
+#endif
 
 static int __ocfs2_page_mkwrite(struct inode *inode, struct buffer_head *di_bh,
 				struct page *page)
@@ -96,6 +126,9 @@ static int __ocfs2_page_mkwrite(struct inode *inode, struct buffer_head *di_bh,
 	void *fsdata;
 	loff_t size = i_size_read(inode);
 
+	mlog_entry("(inode=0x%p, i_ino=%lu, page=0x%p)\n", inode, inode->i_ino,
+		   page);
+
 	/*
 	 * Another node might have truncated while we were waiting on
 	 * cluster locks.
@@ -147,6 +180,7 @@ static int __ocfs2_page_mkwrite(struct inode *inode, struct buffer_head *di_bh,
 	BUG_ON(ret != len);
 	ret = 0;
 out:
+	mlog_exit(ret);
 	return ret;
 }
 
@@ -157,6 +191,8 @@ static int ocfs2_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 	sigset_t blocked, oldset;
 	int ret, ret2;
 
+	mlog_entry("(vma=0x%p, page=0x%p)\n", vma, page);
+
 	ret = ocfs2_vm_op_block_sigs(&blocked, &oldset);
 	if (ret < 0) {
 		mlog_errno(ret);
@@ -202,11 +238,16 @@ out:
 	if (ret2 < 0)
 		mlog_errno(ret2);
 
+	mlog_exit(ret);
 	return ret;
 }
 
 static struct vm_operations_struct ocfs2_file_vm_ops = {
+#ifndef NO_FAULT_IN_VMOPS
 	.fault		= ocfs2_fault,
+#else
+	.nopage		= ocfs2_nopage,
+#endif
 	.page_mkwrite	= ocfs2_page_mkwrite,
 };
 
@@ -214,16 +255,22 @@ int ocfs2_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	int ret = 0, lock_level = 0;
 
-	ret = ocfs2_meta_lock_atime(file->f_dentry->d_inode,
+	mlog_entry("(file=0x%p, vma=%p, '%.*s')\n", file, vma,
+		   file->f_path.dentry->d_name.len,
+		   file->f_path.dentry->d_name.name);
+
+	ret = ocfs2_meta_lock_atime(file->f_path.dentry->d_inode,
 				    file->f_vfsmnt, &lock_level);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
 	}
-	ocfs2_meta_unlock(file->f_dentry->d_inode, lock_level);
+	ocfs2_meta_unlock(file->f_path.dentry->d_inode, lock_level);
 out:
 	vma->vm_ops = &ocfs2_file_vm_ops;
+#ifndef NO_FAULT_IN_VMOPS
 	vma->vm_flags |= VM_CAN_NONLINEAR;
-	return 0;
+#endif
+	mlog_exit(ret);
+	return ret;
 }
-
-- 
1.5.2.5
