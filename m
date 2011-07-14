From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 14 Jul 2011 15:50:27 -0700
Subject: [Ocfs2-devel] [PATCH 16/16] ocfs2: Fix ocfs2_page_mkwrite()
In-Reply-To: <1310683827-19157-1-git-send-email-sunil.mushran@oracle.com>
References: <1310683827-19157-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1310683827-19157-17-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Wengang Wang <wen.gang.wang@oracle.com>

This patch address two shortcomings in ocfs2_page_mkwrite():
1. Makes the function return better VM_FAULT_* errors.
2. It handles a error that is triggered when a page is dropped from the mapping
due to memory pressure. This patch locks the page to prevent that.

[Patch was cleaned up by Sunil Mushran.]

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/aops.c |   51 +++++++++++++++++++++++++++++++++++++++++++--------
 fs/ocfs2/mmap.c |   53 ++++++++++++++++++++++++-----------------------------
 2 files changed, 67 insertions(+), 37 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index ac97bca..92e363b 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -865,6 +865,12 @@ struct ocfs2_write_ctxt {
 	struct page			*w_target_page;
 
 	/*
+	 * w_target_locked is used for page_mkwrite path indicating no unlocking
+	 * against w_target_page in ocfs2_write_end_nolock.
+	 */
+	unsigned int			w_target_locked:1;
+
+	/*
 	 * ocfs2_write_end() uses this to know what the real range to
 	 * write in the target should be.
 	 */
@@ -897,6 +903,24 @@ void ocfs2_unlock_and_free_pages(struct page **pages, int num_pages)
 
 static void ocfs2_free_write_ctxt(struct ocfs2_write_ctxt *wc)
 {
+	int i;
+
+	/*
+	 * w_target_locked is only set to true in the page_mkwrite() case.
+	 * The intent is to allow us to lock the target page from write_begin()
+	 * to write_end(). The caller must hold a ref on w_target_page.
+	 */
+	if (wc->w_target_locked) {
+		BUG_ON(!wc->w_target_page);
+		for (i = 0; i < wc->w_num_pages; i++) {
+			if (wc->w_target_page == wc->w_pages[i]) {
+				wc->w_pages[i] = NULL;
+				break;
+			}
+		}
+		mark_page_accessed(wc->w_target_page);
+		page_cache_release(wc->w_target_page);
+	}
 	ocfs2_unlock_and_free_pages(wc->w_pages, wc->w_num_pages);
 
 	brelse(wc->w_di_bh);
@@ -1134,20 +1158,17 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
 			 */
 			lock_page(mmap_page);
 
+			/* Exit and let the caller retry */
 			if (mmap_page->mapping != mapping) {
+				WARN_ON(mmap_page->mapping);
 				unlock_page(mmap_page);
-				/*
-				 * Sanity check - the locking in
-				 * ocfs2_pagemkwrite() should ensure
-				 * that this code doesn't trigger.
-				 */
-				ret = -EINVAL;
-				mlog_errno(ret);
+				ret = -EAGAIN;
 				goto out;
 			}
 
 			page_cache_get(mmap_page);
 			wc->w_pages[i] = mmap_page;
+			wc->w_target_locked = true;
 		} else {
 			wc->w_pages[i] = find_or_create_page(mapping, index,
 							     GFP_NOFS);
@@ -1162,6 +1183,8 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
 			wc->w_target_page = wc->w_pages[i];
 	}
 out:
+	if (ret)
+		wc->w_target_locked = false;
 	return ret;
 }
 
@@ -1819,11 +1842,23 @@ try_again:
 	 */
 	ret = ocfs2_grab_pages_for_write(mapping, wc, wc->w_cpos, pos, len,
 					 cluster_of_pages, mmap_page);
-	if (ret) {
+	if (ret && ret != -EAGAIN) {
 		mlog_errno(ret);
 		goto out_quota;
 	}
 
+	/*
+	 * ocfs2_grab_pages_for_write() returns -EAGAIN if it could not lock
+	 * the target page. In this case, we exit with no error and no target
+	 * page. This will trigger the caller, page_mkwrite(), to re-try
+	 * the operation.
+	 */
+	if (ret == -EAGAIN) {
+		BUG_ON(wc->w_target_page);
+		ret = 0;
+		goto out_quota;
+	}
+
 	ret = ocfs2_write_cluster_by_desc(mapping, data_ac, meta_ac, wc, pos,
 					  len);
 	if (ret) {
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index 3e9393c..9cd4108 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -61,7 +61,7 @@ static int ocfs2_fault(struct vm_area_struct *area, struct vm_fault *vmf)
 static int __ocfs2_page_mkwrite(struct file *file, struct buffer_head *di_bh,
 				struct page *page)
 {
-	int ret;
+	int ret = VM_FAULT_NOPAGE;
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct address_space *mapping = inode->i_mapping;
 	loff_t pos = page_offset(page);
@@ -71,32 +71,25 @@ static int __ocfs2_page_mkwrite(struct file *file, struct buffer_head *di_bh,
 	void *fsdata;
 	loff_t size = i_size_read(inode);
 
-	/*
-	 * Another node might have truncated while we were waiting on
-	 * cluster locks.
-	 * We don't check size == 0 before the shift. This is borrowed
-	 * from do_generic_file_read.
-	 */
 	last_index = (size - 1) >> PAGE_CACHE_SHIFT;
-	if (unlikely(!size || page->index > last_index)) {
-		ret = -EINVAL;
-		goto out;
-	}
 
 	/*
-	 * The i_size check above doesn't catch the case where nodes
-	 * truncated and then re-extended the file. We'll re-check the
-	 * page mapping after taking the page lock inside of
-	 * ocfs2_write_begin_nolock().
+	 * There are cases that lead to the page no longer bebongs to the
+	 * mapping.
+	 * 1) pagecache truncates locally due to memory pressure.
+	 * 2) pagecache truncates when another is taking EX lock against 
+	 * inode lock. see ocfs2_data_convert_worker.
+	 * 
+	 * The i_size check doesn't catch the case where nodes truncated and
+	 * then re-extended the file. We'll re-check the page mapping after
+	 * taking the page lock inside of ocfs2_write_begin_nolock().
+	 *
+	 * Let VM retry with these cases.
 	 */
-	if (!PageUptodate(page) || page->mapping != inode->i_mapping) {
-		/*
-		 * the page has been umapped in ocfs2_data_downconvert_worker.
-		 * So return 0 here and let VFS retry.
-		 */
-		ret = 0;
+	if ((page->mapping != inode->i_mapping) ||
+	    (!PageUptodate(page)) ||
+	    (page_offset(page) >= size))
 		goto out;
-	}
 
 	/*
 	 * Call ocfs2_write_begin() and ocfs2_write_end() to take
@@ -116,17 +109,21 @@ static int __ocfs2_page_mkwrite(struct file *file, struct buffer_head *di_bh,
 	if (ret) {
 		if (ret != -ENOSPC)
 			mlog_errno(ret);
+		if (ret == -ENOMEM)
+			ret = VM_FAULT_OOM;
+		else
+			ret = VM_FAULT_SIGBUS;
 		goto out;
 	}
 
-	ret = ocfs2_write_end_nolock(mapping, pos, len, len, locked_page,
-				     fsdata);
-	if (ret < 0) {
-		mlog_errno(ret);
+	if (!locked_page) {
+		ret = VM_FAULT_NOPAGE;
 		goto out;
 	}
+	ret = ocfs2_write_end_nolock(mapping, pos, len, len, locked_page,
+				     fsdata);
 	BUG_ON(ret != len);
-	ret = 0;
+	ret = VM_FAULT_LOCKED;
 out:
 	return ret;
 }
@@ -168,8 +165,6 @@ static int ocfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 
 out:
 	ocfs2_unblock_signals(&oldset);
-	if (ret)
-		ret = VM_FAULT_SIGBUS;
 	return ret;
 }
 
-- 
1.7.4.1
