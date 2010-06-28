From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 28 Jun 2010 13:44:21 +0800
Subject: [Ocfs2-devel] [RFC] Add writepages in ocfs2_aops.
Message-ID: <1277703861-3534-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,
	This is a RFC for adding writepages in ocfs2_aops.

On Jun 9, Dave Chinner added d87815cb2090e07b0b0b2d73dc9740706e92c80c to 
mainline kernel which limits writeback to write the pages until we reach 
inode->i_size during sync. But for ocfs2, it cause several problems 
because we have dirty pages after i_size within the same cluster. So 
this commit at least has these effect on ocfs2:
1. all the place we use filemap_fdatawrite in ocfs2 doesn't flush pages 
after i_size now.
2. sync, fsync, fdatasync and umount don't flush pages after i_size(they 
are called from writeback_single_inode).
3. reflink have a BUG_ON triggered because we have some dirty pages 
while during CoW. http://oss.oracle.com/bugzilla/show_bug.cgi?id=1265

I think the possible solution includes:
1) maybe add a new function in address_space_operations named 
get_write_size to get it. I think it is needed for all file systems that 
has "block size" > "page size".(But by now, it seems that only ocfs2 has 
this? So it may not be persuasive enough?)
2) revert the patch(I guess it is not easy since it fix some problem 
that generic file system has).
3) Use our own writepages and change wbc->range_end to the end of the 
cluster if LLONG_MAX is used. It should be simple enough but a little 
bit tricky.
4) maybe we can clear the page after extend_file? That means we only 
clear the pages containing i_size and delay the writeback of pages 
within the same cluster to i_size increase. I haven't dived into it 
since it needs more change than method 3.

The attached patch is my implementation of 3. Any comment is welcomed.

Regards,
Tao

From b6d5267d682e933894aebe669c10e85405949e62 Mon Sep 17 00:00:00 2001
From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 28 Jun 2010 11:38:30 +0800
Subject: [PATCH] ocfs2: Add writepages to ocfs2_aops.

In commit d87815cb2090e07b0b0b2d73dc9740706e92c80c, Dave
limit writeback pages to within i_size when the writback
is started. But ocfs2 always has some pages passed i_size
within the same cluster. So it will break many ocfs2
hypothesis that all the pages within the same cluster
will be cleared.

So this patch adds writepages to ocfs2_aops. It is a
corresponding hack to that commit. In case we know that
the following generic_writepages will limit write end to
i_size, we limit it first to the end of the last cluster so
that we can flush those pages as we want.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/aops.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 3623ca2..4dfaa6e 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -28,6 +28,7 @@
 #include <linux/pipe_fs_i.h>
 #include <linux/mpage.h>
 #include <linux/quotaops.h>
+#include <linux/writeback.h>
 
 #define MLOG_MASK_PREFIX ML_FILE_IO
 #include <cluster/masklog.h>
@@ -1988,10 +1989,36 @@ static int ocfs2_write_end(struct file *file, struct address_space *mapping,
 	return ret;
 }
 
+static int ocfs2_writepages(struct address_space *mapping,
+			    struct writeback_control *wbc)
+{
+	int ret;
+	struct inode *inode = mapping->host;
+	loff_t sync_end = ocfs2_clusters_for_bytes(inode->i_sb,
+						i_size_read(inode)) <<
+			OCFS2_SB(inode->i_sb)->s_clustersize_bits;
+	loff_t range_end = wbc->range_end;
+
+	/*
+	 * In commit d87815cb2090e07b0b0b2d73dc9740706e92c80c, Dave
+	 * has changed write_cache_pages to only write pages within
+	 * i_size. While in ocfs2, we have to flush the pages that
+	 * within the last cluster. So change it accordingly.
+	 */
+	if (wbc->sync_mode == WB_SYNC_ALL &&
+	    wbc->range_end == LLONG_MAX)
+		wbc->range_end = sync_end;
+
+	ret = generic_writepages(mapping, wbc);
+	wbc->range_end = range_end;
+	return ret;
+}
+
 const struct address_space_operations ocfs2_aops = {
 	.readpage		= ocfs2_readpage,
 	.readpages		= ocfs2_readpages,
 	.writepage		= ocfs2_writepage,
+	.writepages		= ocfs2_writepages,
 	.write_begin		= ocfs2_write_begin,
 	.write_end		= ocfs2_write_end,
 	.bmap			= ocfs2_bmap,
-- 
1.5.5
