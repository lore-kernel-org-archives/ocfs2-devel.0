From: Ryan Ding <ryan.ding@oracle.com>
Date: Fri, 11 Sep 2015 16:19:14 +0800
Subject: [Ocfs2-devel] [PATCH 3/8] ocfs2: test target page before change it
In-Reply-To: <1441959559-29947-1-git-send-email-ryan.ding@oracle.com>
References: <1441959559-29947-1-git-send-email-ryan.ding@oracle.com>
Message-ID: <1441959559-29947-4-git-send-email-ryan.ding@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

To support direct io in ocfs2_write_begin_nolock & ocfs2_write_end_nolock.

Direct io data will not appear in buffer. The w_target_page member will not be
filled by direct io. So avoid to use it when it's NULL.
Unlinke buffer io and mmap, direct io will call write_begin with more than 1
page a time. So the target_index is not sufficient to describe the actual data.
change it to a range start at target_index, end in end_index.

Signed-off-by: Ryan Ding <ryan.ding@oracle.com>
Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
cc: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/aops.c |   32 ++++++++++++++++++++++++++------
 1 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 0f022dc..eff5b59 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1398,12 +1398,13 @@ static void ocfs2_write_failure(struct inode *inode,
 		to = user_pos + user_len;
 	struct page *tmppage;
 
-	ocfs2_zero_new_buffers(wc->w_target_page, from, to);
+	if (wc->w_target_page)
+		ocfs2_zero_new_buffers(wc->w_target_page, from, to);
 
 	for(i = 0; i < wc->w_num_pages; i++) {
 		tmppage = wc->w_pages[i];
 
-		if (page_has_buffers(tmppage)) {
+		if (tmppage && page_has_buffers(tmppage)) {
 			if (ocfs2_should_order_data(inode))
 				ocfs2_jbd2_file_inode(wc->w_handle, inode);
 
@@ -1533,11 +1534,13 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
 		wc->w_num_pages = 1;
 		start = target_index;
 	}
+	end_index = (user_pos + user_len - 1) >> PAGE_CACHE_SHIFT;
 
 	for(i = 0; i < wc->w_num_pages; i++) {
 		index = start + i;
 
-		if (index == target_index && mmap_page) {
+		if (index >= target_index && index <= end_index &&
+		    wc->w_type == OCFS2_WRITE_MMAP) {
 			/*
 			 * ocfs2_pagemkwrite() is a little different
 			 * and wants us to directly use the page
@@ -1556,6 +1559,11 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
 			page_cache_get(mmap_page);
 			wc->w_pages[i] = mmap_page;
 			wc->w_target_locked = true;
+		} else if (index >= target_index && index <= end_index &&
+			   wc->w_type == OCFS2_WRITE_DIRECT) {
+			/* Direct write has no mapping page. */
+			wc->w_pages[i] = NULL;
+			continue;
 		} else {
 			wc->w_pages[i] = find_or_create_page(mapping, index,
 							     GFP_NOFS);
@@ -1657,6 +1665,12 @@ static int ocfs2_write_cluster(struct address_space *mapping,
 	for(i = 0; i < wc->w_num_pages; i++) {
 		int tmpret;
 
+		/* This is the direct io target page. */
+		if (wc->w_pages[i] == NULL) {
+			p_blkno++;
+			continue;
+		}
+
 		tmpret = ocfs2_prepare_page_for_write(inode, &p_blkno, wc,
 						      wc->w_pages[i], cpos,
 						      user_pos, user_len,
@@ -2258,7 +2272,8 @@ try_again:
 		ocfs2_free_alloc_context(meta_ac);
 
 success:
-	*pagep = wc->w_target_page;
+	if (pagep)
+		*pagep = wc->w_target_page;
 	*fsdata = wc;
 	return 0;
 out_quota:
@@ -2392,18 +2407,23 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
 		goto out_write_size;
 	}
 
-	if (unlikely(copied < len)) {
+	if (unlikely(copied < len) && wc->w_target_page) {
 		if (!PageUptodate(wc->w_target_page))
 			copied = 0;
 
 		ocfs2_zero_new_buffers(wc->w_target_page, start+copied,
 				       start+len);
 	}
-	flush_dcache_page(wc->w_target_page);
+	if (wc->w_target_page)
+		flush_dcache_page(wc->w_target_page);
 
 	for(i = 0; i < wc->w_num_pages; i++) {
 		tmppage = wc->w_pages[i];
 
+		/* This is the direct io target page. */
+		if (tmppage == NULL)
+			continue;
+
 		if (tmppage == wc->w_target_page) {
 			from = wc->w_target_from;
 			to = wc->w_target_to;
-- 
1.7.1
