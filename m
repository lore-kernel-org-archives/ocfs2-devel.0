From: Joel Becker <Joel.Becker@oracle.com>
Date: Sat, 3 Jul 2010 14:33:43 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: No need to zero pages past i_size.
	i_size v2
In-Reply-To: <20100703213219.GB21262@mail.oracle.com>
References: <20100702224912.GC5800@mail.oracle.com>
	<20100703213219.GB21262@mail.oracle.com>
Message-ID: <20100703213343.GC21262@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Tao Ma <tao.ma@oracle.com>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>

	Here's the second patch, the one that keeps us from zeroing
pages past i_size.  This should keep ocfs2 and Dave's writeback patch
happy.

Joel

-------------------------------------------------------

When ocfs2 fills a hole, it does so by allocating clusters.  When a
cluster is larger than the write, ocfs2 must zero the portions of the
cluster outside of the write.  If the clustersize is smaller than a
pagecache page, this is handled by the normal pagecache mechanisms, but
when the clustersize is larger than a page, ocfs2's write code will zero
the pages adjacent to the write.  This makes sure the entire cluster is
zeroed correctly.

Currently ocfs2 behaves exactly the same when writing past i_size.
However, this means ocfs2 is writing zeroed pages for portions of a new
cluster that are beyond i_size.  The page writeback code isn't expecting
this.  It treats all pages past the one containing i_size as left behind
due to a previous truncate operation.

Thankfully, ocfs2 calculates the number of pages it will be working on
up front.  The rest of the write code merely honors the original
calculation.  We can simply trim the number of pages to only cover the
actual file data.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/aops.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 96e6aeb..e90ad74 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1130,11 +1130,12 @@ out:
  */
 static int ocfs2_grab_pages_for_write(struct address_space *mapping,
 				      struct ocfs2_write_ctxt *wc,
-				      u32 cpos, loff_t user_pos, int new,
+				      u32 cpos, loff_t user_pos,
+				      unsigned user_len, int new,
 				      struct page *mmap_page)
 {
 	int ret = 0, i;
-	unsigned long start, target_index, index;
+	unsigned long start, target_index, end_index, index;
 	struct inode *inode = mapping->host;
 
 	target_index = user_pos >> PAGE_CACHE_SHIFT;
@@ -1142,11 +1143,17 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
 	/*
 	 * Figure out how many pages we'll be manipulating here. For
 	 * non allocating write, we just change the one
-	 * page. Otherwise, we'll need a whole clusters worth.
+	 * page. Otherwise, we'll need a whole clusters worth.  If we're
+	 * writing past i_size, we only need enough pages to cover the
+	 * last page of the write.
 	 */
 	if (new) {
 		wc->w_num_pages = ocfs2_pages_per_cluster(inode->i_sb);
 		start = ocfs2_align_clusters_to_page_index(inode->i_sb, cpos);
+		/* This is the index *past* the write */
+		end_index = ((user_pos + user_len) >> PAGE_CACHE_SHIFT) + 1;
+		if ((start + wc->w_num_pages) > end_index)
+			wc->w_num_pages = end_index - start;
 	} else {
 		wc->w_num_pages = 1;
 		start = target_index;
@@ -1789,7 +1796,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 	 * that we can zero and flush if we error after adding the
 	 * extent.
 	 */
-	ret = ocfs2_grab_pages_for_write(mapping, wc, wc->w_cpos, pos,
+	ret = ocfs2_grab_pages_for_write(mapping, wc, wc->w_cpos, pos, len,
 					 cluster_of_pages, mmap_page);
 	if (ret) {
 		mlog_errno(ret);
-- 
1.7.1

-- 

"Vote early and vote often." 
        - Al Capone

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
