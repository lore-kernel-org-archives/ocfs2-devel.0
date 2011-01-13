From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 13 Jan 2011 19:01:36 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix ocfs2_page_mkwrite path
Message-ID: <201101131103.p0D7C5Cx002897@acsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch fixes two problems in ocfs2_page_mkwrite path:
1) it makes ocfs2_page_mkwrite returns VM_FAULT_*
2) it fixes a bug of returning -EINVAL.
The -EINVAL is returned when the page is no longger belong to the inode mapping
(pagecache gets truncated).  Make it return VM_FAULT_NOPAGE in that case.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/aops.c |   47 +++++++++++++++++++++++++++++++++++++++--------
 fs/ocfs2/mmap.c |   53 ++++++++++++++++++++++++-----------------------------
 2 files changed, 63 insertions(+), 37 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 0d7c554..619a38f 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -876,6 +876,12 @@ struct ocfs2_write_ctxt {
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
@@ -908,8 +914,29 @@ void ocfs2_unlock_and_free_pages(struct page **pages, int num_pages)
 
 static void ocfs2_free_write_ctxt(struct ocfs2_write_ctxt *wc)
 {
+	/*
+	 * don't unlock on the target_page for page_mkwrite pach.
+	 * page_mkwrite() wants a return with the page locked.
+	 * re-acquiring after ocfs2_unlock_and_free_pages is not acceptable.
+	 * During the time when it unlocked, the page can changed to
+	 * not belong to the inode mapping any longer.
+	 *
+	 * caller must hold a ref on w_target_page.
+	 */
+	if (wc->w_target_locked) {
+		int i;
+
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
-
 	brelse(wc->w_di_bh);
 	kfree(wc);
 }
@@ -1139,20 +1166,19 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
 			 */
 			lock_page(mmap_page);
 
+			/*
+			 * pagecache gets truncated. Let VM retry it.
+			 */
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
+				ret = 0;
 				goto out;
 			}
 
 			page_cache_get(mmap_page);
 			wc->w_pages[i] = mmap_page;
+			wc->w_target_locked = true;
 		} else {
 			wc->w_pages[i] = find_or_create_page(mapping, index,
 							     GFP_NOFS);
@@ -1167,6 +1193,8 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
 			wc->w_target_page = wc->w_pages[i];
 	}
 out:
+	if (ret)
+		wc->w_target_locked = false;
 	return ret;
 }
 
@@ -1786,6 +1814,9 @@ int ocfs2_write_begin_nolock(struct file *filp,
 		mlog_errno(ret);
 		goto out_quota;
 	}
+	/* Did the pagecache lose the page?  Retry. */
+	if (!wc->w_target_page)
+		goto out_quota;
 
 	ret = ocfs2_write_cluster_by_desc(mapping, data_ac, meta_ac, wc, pos,
 					  len);
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index 7e32db9..9f88443 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -62,7 +62,7 @@ static int ocfs2_fault(struct vm_area_struct *area, struct vm_fault *vmf)
 static int __ocfs2_page_mkwrite(struct file *file, struct buffer_head *di_bh,
 				struct page *page)
 {
-	int ret;
+	int ret = VM_FAULT_NOPAGE;
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct address_space *mapping = inode->i_mapping;
 	loff_t pos = page_offset(page);
@@ -72,32 +72,25 @@ static int __ocfs2_page_mkwrite(struct file *file, struct buffer_head *di_bh,
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
@@ -117,17 +110,21 @@ static int __ocfs2_page_mkwrite(struct file *file, struct buffer_head *di_bh,
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
@@ -169,8 +166,6 @@ static int ocfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 
 out:
 	ocfs2_unblock_signals(&oldset);
-	if (ret)
-		ret = VM_FAULT_SIGBUS;
 	return ret;
 }
 
-- 
1.7.2.3
