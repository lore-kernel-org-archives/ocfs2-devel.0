From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 12 Jul 2010 15:45:31 -0700
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2: Tail zeroing fixes.
In-Reply-To: <1278501367-7710-1-git-send-email-joel.becker@oracle.com>
References: <20100703213219.GB21262@mail.oracle.com>
	<1278501367-7710-1-git-send-email-joel.becker@oracle.com>
Message-ID: <20100712224531.GJ12179@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Tao Ma <tao.ma@oracle.com>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>

On Wed, Jul 07, 2010 at 04:16:04AM -0700, Joel Becker wrote:
> 	This is version 3 of the ocfs2 tail zeroing fixes.  This version
> has some major changes.  Tao correctly pointed out that we can have
> multiple extents past i_size due to unwritten extents.  I've reworked
> the zeroing code to walk them all.  Since I had to do that, and I had to
> handle refcounted extents, I end up fixing a refcount bug with
> non-sparse extentds.
> 	There are now three patches.  The first changes our zeroing
> code to go page-by-page at the high level.  The second actually changes
> the zeroing code.  The final patch, limiting zeroing to the end of a
> write, is unchanged from v2.

	Version 4 of these fixes are now in the fixes and linux-next
branches of ocfs2.git.  I'm just appending the diff to this file rather
than resending all the patches.  They've passed the first round of heavy
testing from our testers, and we're going to keep pounding on them as we
get towards 2.6.35.
	Linus, I'm going to let all of the ocfs2 fixes stew in
linux-next for a few days before I send the pull request.  Figure it by
the end of the week.

Joel

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 9b3381a..356e976 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1107,6 +1107,7 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
 	int ret = 0, i;
 	unsigned long start, target_index, end_index, index;
 	struct inode *inode = mapping->host;
+	loff_t last_byte;
 
 	target_index = user_pos >> PAGE_CACHE_SHIFT;
 
@@ -1120,8 +1121,14 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
 	if (new) {
 		wc->w_num_pages = ocfs2_pages_per_cluster(inode->i_sb);
 		start = ocfs2_align_clusters_to_page_index(inode->i_sb, cpos);
-		/* This is the index *past* the write */
-		end_index = ((user_pos + user_len - 1) >> PAGE_CACHE_SHIFT) + 1;
+		/*
+		 * We need the index *past* the last page we could possibly
+		 * touch.  This is the page past the end of the write or
+		 * i_size, whichever is greater.
+		 */
+		last_byte = max(user_pos + user_len, i_size_read(inode));
+		BUG_ON(last_byte < 1);
+		end_index = ((last_byte - 1) >> PAGE_CACHE_SHIFT) + 1;
 		if ((start + wc->w_num_pages) > end_index)
 			wc->w_num_pages = end_index - start;
 	} else {
@@ -1619,6 +1626,18 @@ static int ocfs2_expand_nonsparse_inode(struct inode *inode,
 	return ret;
 }
 
+static int ocfs2_zero_tail(struct inode *inode, struct buffer_head *di_bh,
+			   loff_t pos)
+{
+	int ret = 0;
+
+	BUG_ON(!ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)));
+	if (pos > i_size_read(inode))
+		ret = ocfs2_zero_extend(inode, di_bh, pos);
+
+	return ret;
+}
+
 int ocfs2_write_begin_nolock(struct address_space *mapping,
 			     loff_t pos, unsigned len, unsigned flags,
 			     struct page **pagep, void **fsdata,
@@ -1655,7 +1674,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 	}
 
 	if (ocfs2_sparse_alloc(osb))
-		ret = ocfs2_zero_extend(inode, di_bh, pos);
+		ret = ocfs2_zero_tail(inode, di_bh, pos);
 	else
 		ret = ocfs2_expand_nonsparse_inode(inode, di_bh, pos, len,
 						   wc);
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 1fdc45a..ac15911 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -734,7 +734,7 @@ static handle_t *ocfs2_zero_start_ordered_transaction(struct inode *inode)
 	handle_t *handle = NULL;
 	int ret = 0;
 
-	if (ocfs2_should_order_data(inode))
+	if (!ocfs2_should_order_data(inode))
 		goto out;
 
 	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
@@ -771,7 +771,7 @@ static int ocfs2_write_zero_page(struct inode *inode, u64 abs_from,
 	unsigned zero_from, zero_to, block_start, block_end;
 
 	BUG_ON(abs_from >= abs_to);
-	BUG_ON(abs_to > ((index + 1) << PAGE_CACHE_SHIFT));
+	BUG_ON(abs_to > (((u64)index + 1) << PAGE_CACHE_SHIFT));
 	BUG_ON(abs_from & (inode->i_blkbits - 1));
 
 	page = grab_cache_page(mapping, index);
@@ -793,8 +793,7 @@ static int ocfs2_write_zero_page(struct inode *inode, u64 abs_from,
 	     index, zero_from, zero_to);
 
 	/* We know that zero_from is block aligned */
-	for (block_start = zero_from;
-	     (block_start < PAGE_CACHE_SIZE) && (block_start < zero_to);
+	for (block_start = zero_from; block_start < zero_to;
 	     block_start = block_end) {
 		block_end = block_start + (1 << inode->i_blkbits);
 
@@ -966,6 +965,9 @@ int ocfs2_zero_extend(struct inode *inode, struct buffer_head *di_bh,
 	struct super_block *sb = inode->i_sb;
 
 	zero_start = ocfs2_align_bytes_to_blocks(sb, i_size_read(inode));
+	mlog(0, "zero_start %llu for i_size %llu\n",
+	     (unsigned long long)zero_start,
+	     (unsigned long long)i_size_read(inode));
 	while (zero_start < zero_to_size) {
 		ret = ocfs2_zero_extend_get_range(inode, di_bh, zero_start,
 						  zero_to_size,
-- 

"The only way to get rid of a temptation is to yield to it."
         - Oscar Wilde 

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
