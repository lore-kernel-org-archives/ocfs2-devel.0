From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 12 Nov 2009 17:47:33 -0800
Subject: [Ocfs2-devel] [PATCH 12/18] ocfs2: Handle missing vmops->fault()
In-Reply-To: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
References: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1258076859-13538-13-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 54cb8821de07f2ffcd28c380ce9b93d5784b40d7 introduced vmops->fault()
to replace vmops->populate() and vmops->nopage(). Patch adds nopage() and uses it
when building against EL5.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in    |    1 +
 configure.in      |    5 ++++
 fs/ocfs2/Makefile |    4 +++
 fs/ocfs2/mmap.c   |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 65 insertions(+), 1 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index 618c814..a0330b9 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -74,6 +74,7 @@ NO_VECTORIZED_AIO = @NO_VECTORIZED_AIO@
 OLD_PERMISSION = @OLD_PERMISSION@
 KMEM_CACHE_CREATE_DTOR = @KMEM_CACHE_CREATE_DTOR@
 OLD_BIO_END_IO_T = @OLD_BIO_END_IO_T@
+NO_FAULT_IN_VMOPS = @NO_FAULT_IN_VMOPS@
 
 
 OCFS_DEBUG = @OCFS_DEBUG@
diff --git a/configure.in b/configure.in
index 5fe4934..a65ba15 100644
--- a/configure.in
+++ b/configure.in
@@ -374,6 +374,11 @@ OCFS2_CHECK_KERNEL([BDI_CAP_NO_ACCT_AND_WRITEBACK in backing-dev.h], backing-dev
   , bdi_define_compat_header=bdi_define.h, [^#define BDI_CAP_NO_ACCT_AND_WRITEBACK])
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $bdi_define_compat_header"
 
+NO_FAULT_IN_VMOPS=
+OCFS2_CHECK_KERNEL([fault() in struct vm_operations_struct in mm.h], mm.h,
+  , NO_FAULT_IN_VMOPS=yes, [^.*int (\*fault)])
+AC_SUBST(NO_FAULT_IN_VMOPS)
+
 # End kapi_compat checks
 
 # using -include has two advantages:
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index c769fd8..401a1f5 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -96,6 +96,10 @@ ifdef KMEM_CACHE_CREATE_DTOR
 EXTRA_CFLAGS += -DKMEM_CACHE_CREATE_DTOR
 endif
 
+ifdef NO_FAULT_IN_VMOPS
+EXTRA_CFLAGS += -DNO_FAULT_IN_VMOPS
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index b4a25c8..4d37071 100644
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
@@ -151,17 +184,26 @@ static int __ocfs2_page_mkwrite(struct inode *inode, struct buffer_head *di_bh,
 	BUG_ON(ret != len);
 	ret = 0;
 out:
+	mlog_exit(ret);
 	return ret;
 }
 
+#ifndef NO_FAULT_IN_VMOPS
 static int ocfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
+#else
+static int ocfs2_page_mkwrite(struct vm_area_struct *vma, struct page *page)
+#endif
 {
+#ifndef NO_FAULT_IN_VMOPS
 	struct page *page = vmf->page;
+#endif
 	struct inode *inode = filp_dentry(vma->vm_file)->d_inode;
 	struct buffer_head *di_bh = NULL;
 	sigset_t blocked, oldset;
 	int ret, ret2;
 
+	mlog_entry("(vma=0x%p, page=0x%p)\n", vma, page);
+
 	ret = ocfs2_vm_op_block_sigs(&blocked, &oldset);
 	if (ret < 0) {
 		mlog_errno(ret);
@@ -199,6 +241,7 @@ out:
 		mlog_errno(ret2);
 	if (ret)
 		ret = VM_FAULT_SIGBUS;
+	mlog_exit(ret);
 	return ret;
 }
 
@@ -207,7 +250,11 @@ static struct vm_operations_struct ocfs2_file_vm_ops = {
 #else
 static const struct vm_operations_struct ocfs2_file_vm_ops = {
 #endif
+#ifndef NO_FAULT_IN_VMOPS
 	.fault		= ocfs2_fault,
+#else
+	.nopage		= ocfs2_nopage,
+#endif
 	.page_mkwrite	= ocfs2_page_mkwrite,
 };
 
@@ -215,6 +262,10 @@ int ocfs2_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	int ret = 0, lock_level = 0;
 
+	mlog_entry("(file=0x%p, vma=%p, '%.*s')\n", file, vma,
+		   filp_dentry(file)->d_name.len,
+		   filp_dentry(file)->d_name.name);
+
 	ret = ocfs2_inode_lock_atime(filp_dentry(file)->d_inode,
 				     filp_mnt(file), &lock_level);
 	if (ret < 0) {
@@ -224,7 +275,10 @@ int ocfs2_mmap(struct file *file, struct vm_area_struct *vma)
 	ocfs2_inode_unlock(filp_dentry(file)->d_inode, lock_level);
 out:
 	vma->vm_ops = &ocfs2_file_vm_ops;
+#ifndef NO_FAULT_IN_VMOPS
 	vma->vm_flags |= VM_CAN_NONLINEAR;
-	return 0;
+#endif
+	mlog_exit(ret);
+	return ret;
 }
 
-- 
1.5.6.5
