From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Wed, 23 Mar 2016 13:12:14 -0700
Subject: [Ocfs2-devel] [patch 11/25] ocfs2: fix disk file size and memory
 file size mismatch
Message-ID: <56f2f89e.wkDkM9XcWRQY+kqI%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Ryan Ding <ryan.ding@oracle.com>
Subject: ocfs2: fix disk file size and memory file size mismatch

When doing append direct write in an already allocated cluster, and fast
path in ocfs2_dio_get_block() is triggered, function
ocfs2_dio_end_io_write() will be skipped as there is no context allocated.
 So disk file size will not be changed as it should be.  The solution is
to skip fast path when we are about to change file size.

Fixes: af1310367f41 ("ocfs2: fix sparse file & data ordering issue in direct io.")
Signed-off-by: Ryan Ding <ryan.ding@oracle.com>
Acked-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-fix-disk-file-size-and-memory-file-size-mismatch fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-fix-disk-file-size-and-memory-file-size-mismatch
+++ a/fs/ocfs2/aops.c
@@ -2167,19 +2167,26 @@ static int ocfs2_dio_get_block(struct in
 	mlog(0, "get block of %lu at %llu:%u req %u\n",
 			inode->i_ino, pos, len, total_len);
 
-	down_read(&oi->ip_alloc_sem);
-	/* This is the fast path for re-write. */
-	ret = ocfs2_get_block(inode, iblock, bh_result, create);
+	/*
+	 * Because we need to change file size in ocfs2_dio_end_io_write(), or
+	 * we may need to add it to orphan dir. So can not fall to fast path
+	 * while file size will be changed.
+	 */
+	if (pos + total_len <= i_size_read(inode)) {
+		down_read(&oi->ip_alloc_sem);
+		/* This is the fast path for re-write. */
+		ret = ocfs2_get_block(inode, iblock, bh_result, create);
 
-	up_read(&oi->ip_alloc_sem);
+		up_read(&oi->ip_alloc_sem);
 
-	if (buffer_mapped(bh_result) &&
-	    !buffer_new(bh_result) &&
-	    ret == 0)
-		goto out;
+		if (buffer_mapped(bh_result) &&
+		    !buffer_new(bh_result) &&
+		    ret == 0)
+			goto out;
 
-	/* Clear state set by ocfs2_get_block. */
-	bh_result->b_state = 0;
+		/* Clear state set by ocfs2_get_block. */
+		bh_result->b_state = 0;
+	}
 
 	dwc = ocfs2_dio_alloc_write_ctx(bh_result, &first_get_block);
 	if (unlikely(dwc == NULL)) {
_
