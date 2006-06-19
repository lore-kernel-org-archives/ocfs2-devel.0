From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon, 19 Jun 2006 16:46:43 -0700
Subject: [Ocfs2-devel] [-mm PATCH] ocfs2: Shared writeable mmap
Message-ID: <20060619234643.GK3082@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dhowells@redhat.com, akpm@osdl.org
Cc: linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

I finally got some time to sit down and implement an OCFS2 patch to make use
of the ->page_mkwrite() callback added by David Howells' patch (named
'add-page_mkwrite-vm_operations-method.patch' in -mm). The patches, and an
MPI program to test this can be found at:

http://kernel.org/pub/linux/kernel/people/mfasheh/ocfs2/mmap/

There's one bug however, which will cause the test program on one of the
reading nodes to see stale data if it is run several times in a row against
the same file. I have verified that the same thing works fine on a local
file system (ext3). I'm not sure where the issue is, but I have a feeling
I'm doing something bad in ocfs2_data_convert_worker(). Another possibility
is that we missed a place to put the ->page_mkwrite callback.

Unfortunately, I have to step away from this patch for a bit as I have some
higher priority issues to deal with :/ Luckily, it seems to be in a state
which I think warrants it being pushed out to the public for general review,
testing, etc. If anyone is interested, I'd also appreciate any advice or
help regarding the bug -- my VM-foo is very weak :)
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh at oracle.com

From: Mark Fasheh <mark.fasheh@oracle.com>

ocfs2: Shared writeable mmap

Implement cluster consistent shared writeable mappings using the
->page_mkwrite() callback.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

---

 fs/ocfs2/dlmglue.c |   10 +++++
 fs/ocfs2/mmap.c    |  100 ++++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 90 insertions(+), 20 deletions(-)

4c6c09a7927affae4616607c9f0da0a95b232baa
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 64cd528..d57860d 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2685,6 +2685,15 @@ static void ocfs2_data_convert_worker(st
        	inode = ocfs2_lock_res_inode(lockres);
 	mapping = inode->i_mapping;
 
+	/*
+	 * We need this before the filemap_fdatawrite() so that it can
+	 * transfer the dirty bit from the PTE to the
+	 * page. Unfortunately this means that even for EX->PR
+	 * downconverts, we'll lose our mappings and have to build
+	 * them up again.
+	 */
+	unmap_mapping_range(mapping, 0, 0, 0);
+
 	if (filemap_fdatawrite(mapping)) {
 		mlog(ML_ERROR, "Could not sync inode %llu for downconvert!",
 		     (unsigned long long)OCFS2_I(inode)->ip_blkno);
@@ -2692,7 +2701,6 @@ static void ocfs2_data_convert_worker(st
 	sync_mapping_buffers(mapping);
 	if (blocking == LKM_EXMODE) {
 		truncate_inode_pages(mapping, 0);
-		unmap_mapping_range(mapping, 0, 0, 0);
 	} else {
 		/* We only need to wait on the I/O if we're not also
 		 * truncating pages because truncate_inode_pages waits
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index 843cf9d..b53063c 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -42,6 +42,23 @@ #include "file.h"
 #include "inode.h"
 #include "mmap.h"
 
+static inline int ocfs2_vm_op_block_sigs(sigset_t *blocked, sigset_t *oldset)
+{
+	/* The best way to deal with signals in the vm path is
+	 * to block them upfront, rather than allowing the
+	 * locking paths to return -ERESTARTSYS. */
+	sigfillset(blocked);
+
+	/* We should technically never get a bad return value
+	 * from sigprocmask */
+	return sigprocmask(SIG_BLOCK, blocked, oldset);
+}
+
+static inline int ocfs2_vm_op_unblock_sigs(sigset_t *oldset)
+{
+	return sigprocmask(SIG_SETMASK, oldset, NULL);
+}
+
 static struct page *ocfs2_nopage(struct vm_area_struct * area,
 				 unsigned long address,
 				 int *type)
@@ -53,14 +70,7 @@ static struct page *ocfs2_nopage(struct 
 
 	mlog_entry("(inode %lu, address %lu)\n", inode->i_ino, address);
 
-	/* The best way to deal with signals in this path is
-	 * to block them upfront, rather than allowing the
-	 * locking paths to return -ERESTARTSYS. */
-	sigfillset(&blocked);
-
-	/* We should technically never get a bad ret return
-	 * from sigprocmask */
-	ret = sigprocmask(SIG_BLOCK, &blocked, &oldset);
+	ret = ocfs2_vm_op_block_sigs(&blocked, &oldset);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
@@ -68,7 +78,7 @@ static struct page *ocfs2_nopage(struct 
 
 	page = filemap_nopage(area, address, type);
 
-	ret = sigprocmask(SIG_SETMASK, &oldset, NULL);
+	ret = ocfs2_vm_op_unblock_sigs(&oldset);
 	if (ret < 0)
 		mlog_errno(ret);
 out:
@@ -76,21 +86,73 @@ out:
 	return page;
 }
 
+static int ocfs2_page_mkwrite(struct vm_area_struct *vma, struct page *page)
+{
+	struct inode *inode = vma->vm_file->f_dentry->d_inode;
+	sigset_t blocked, oldset;
+	int ret, ret2;
+	pgoff_t last_index;
+
+	mlog_entry("(inode %llu, page index %lu)\n",
+		   (unsigned long long)OCFS2_I(inode)->ip_blkno, page->index);
+
+	ret = ocfs2_vm_op_block_sigs(&blocked, &oldset);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	/* Take a meta data lock so that we can test the page location
+	 * against the proper end of file. This particular check may
+	 * be a little paranoid. */
+	ret = ocfs2_meta_lock(inode, NULL, NULL, 0);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out_restore_signals;
+	}
+
+	/*
+	 * When we support holes, allocation should be handled here,
+	 * as writepage() is too late to handle ENOSPC issues.
+	 */
+	last_index = i_size_read(inode) << PAGE_CACHE_SHIFT;
+	if (page->index > last_index) {
+		ret = -EFBIG;
+		goto out_meta_unlock;
+	}
+
+	/*
+	 * Take and drop an exclusive data lock here. This will ensure
+	 * that other nodes write out and invalidate their pages for
+	 * this inode. Dlmglue handles caching of the exclusive lock,
+	 * so the page can be safely marked writeable until another
+	 * node notifies us of competing access.
+	 */
+	ret = ocfs2_data_lock(inode, 1);
+	if (ret < 0)
+		mlog_errno(ret);
+	else
+		ocfs2_data_unlock(inode, 1);
+
+out_meta_unlock:
+	ocfs2_meta_unlock(inode, 0);
+
+out_restore_signals:
+	ret2 = ocfs2_vm_op_unblock_sigs(&oldset);
+	if (ret2 < 0)
+		mlog_errno(ret2);
+
+out:
+	return ret;
+}
+
 static struct vm_operations_struct ocfs2_file_vm_ops = {
-	.nopage = ocfs2_nopage,
+	.nopage		= ocfs2_nopage,
+	.page_mkwrite	= ocfs2_page_mkwrite,
 };
 
 int ocfs2_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	/* We don't want to support shared writable mappings yet. */
-	if (((vma->vm_flags & VM_SHARED) || (vma->vm_flags & VM_MAYSHARE))
-	    && ((vma->vm_flags & VM_WRITE) || (vma->vm_flags & VM_MAYWRITE))) {
-		mlog(0, "disallow shared writable mmaps %lx\n", vma->vm_flags);
-		/* This is -EINVAL because generic_file_readonly_mmap
-		 * returns it in a similar situation. */
-		return -EINVAL;
-	}
-
 	file_accessed(file);
 	vma->vm_ops = &ocfs2_file_vm_ops;
 	return 0;
-- 
1.3.3
