From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu Dec 20 15:29:59 2007
Subject: [Ocfs2-devel] [PATCH 24/30] ocfs2: Handle missing vmops->fault()
In-Reply-To: <1198193387-16606-1-git-send-email-sunil.mushran@oracle.com>
References: <1198193387-16606-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1198193387-16606-23-git-send-email-sunil.mushran@oracle.com>
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
---
 Config.make.in    |    1 +
 configure.in      |    5 +++++
 fs/ocfs2/Makefile |    4 ++++
 fs/ocfs2/mmap.c   |   51 +++++++++++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index c1ca1d9..96dbb7a 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -68,6 +68,7 @@ STRUCT_SUBSYSTEM_DEFINED = @STRUCT_SUBSYSTEM_DEFINED@
 FALLOCATE_DEFINED = @FALLOCATE_DEFINED@
 SPLICE_HEADER = @SPLICE_HEADER@
 GENERIC_SEGMENT_CHECKS = @GENERIC_SEGMENT_CHECKS@
+FAULT_IN_VMOPS = @FAULT_IN_VMOPS@
 
 OCFS_DEBUG = @OCFS_DEBUG@
 
diff --git a/configure.in b/configure.in
index a311d3f..b8b8001 100644
--- a/configure.in
+++ b/configure.in
@@ -267,6 +267,11 @@ OCFS2_CHECK_KERNEL([generic_segment_checks() in fs.h], fs.h,
   GENERIC_SEGMENT_CHECKS=yes, , [generic_segment_checks()])
 AC_SUBST(GENERIC_SEGMENT_CHECKS)
 
+FAULT_IN_VMOPS=
+OCFS2_CHECK_KERNEL([fault() in struct vm_operations_struct in mm.h], mm.h,
+  FAULT_IN_VMOPS=yes, , [^.*int (\*fault)])
+AC_SUBST(FAULT_IN_VMOPS)
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 7434d6d..521888b 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -61,6 +61,10 @@ ifdef GENERIC_SEGMENT_CHECKS
 EXTRA_CFLAGS += -DGENERIC_SEGMENT_CHECKS
 endif
 
+ifdef FAULT_IN_VMOPS
+EXTRA_CFLAGS += -DFAULT_IN_VMOPS
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index c0483c9..58c67ea 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -60,6 +60,7 @@ static inline int ocfs2_vm_op_unblock_sigs(sigset_t *oldset)
 	return sigprocmask(SIG_SETMASK, oldset, NULL);
 }
 
+#ifdef FAULT_IN_VMOPS
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
+#ifdef FAULT_IN_VMOPS
 	.fault		= ocfs2_fault,
+#else
+	.nopage		= ocfs2_nopage,
+#endif
 	.page_mkwrite	= ocfs2_page_mkwrite,
 };
 
@@ -214,6 +255,10 @@ int ocfs2_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	int ret = 0, lock_level = 0;
 
+	mlog_entry("(file=0x%p, vma=%p, '%.*s')\n", file, vma,
+		   file->f_path_dentry->d_name.len,
+		   file->f_path_dentry->d_name.name);
+
 	ret = ocfs2_meta_lock_atime(file->f_dentry->d_inode,
 				    file->f_vfsmnt, &lock_level);
 	if (ret < 0) {
@@ -223,7 +268,9 @@ int ocfs2_mmap(struct file *file, struct vm_area_struct *vma)
 	ocfs2_meta_unlock(file->f_dentry->d_inode, lock_level);
 out:
 	vma->vm_ops = &ocfs2_file_vm_ops;
+#ifdef FAULT_IN_VMOPS
 	vma->vm_flags |= VM_CAN_NONLINEAR;
-	return 0;
+#endif
+	mlog_exit(ret);
+	return ret;
 }
-
-- 
1.5.2.5
