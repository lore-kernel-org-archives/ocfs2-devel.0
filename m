From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Wed, 23 Mar 2016 13:11:52 -0700
Subject: [Ocfs2-devel] [patch 03/25] ocfs2: test target page before change it
Message-ID: <56f2f888.lXWG9cu6+NN+Loup%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Ryan Ding <ryan.ding@oracle.com>
Subject: ocfs2: test target page before change it

To support direct io in ocfs2_write_begin_nolock & ocfs2_write_end_nolock.

Direct io data will not appear in buffer.  The w_target_page member will
not be filled by direct io.  So avoid to use it when it's NULL.  Unlinke
buffer io and mmap, direct io will call write_begin with more than 1 page
a time.  So the target_index is not sufficient to describe the actual
data.  change it to a range start at target_index, end in end_index.

Signed-off-by: Ryan Ding <ryan.ding@oracle.com>
Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-test-target-page-before-change-it fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-test-target-page-before-change-it
+++ a/fs/ocfs2/aops.c
@@ -1406,12 +1406,13 @@ static void ocfs2_write_failure(struct i
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
 
@@ -1541,11 +1542,13 @@ static int ocfs2_grab_pages_for_write(st
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
@@ -1564,6 +1567,11 @@ static int ocfs2_grab_pages_for_write(st
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
@@ -1665,6 +1673,12 @@ static int ocfs2_write_cluster(struct ad
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
@@ -2266,7 +2280,8 @@ try_again:
 		ocfs2_free_alloc_context(meta_ac);
 
 success:
-	*pagep = wc->w_target_page;
+	if (pagep)
+		*pagep = wc->w_target_page;
 	*fsdata = wc;
 	return 0;
 out_quota:
@@ -2400,18 +2415,23 @@ int ocfs2_write_end_nolock(struct addres
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
_
