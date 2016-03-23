From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Wed, 23 Mar 2016 13:12:12 -0700
Subject: [Ocfs2-devel] [patch 10/25] ocfs2: take ip_alloc_sem in
 ocfs2_dio_get_block & ocfs2_dio_end_io_write
Message-ID: <56f2f89c.ZsLzLQVlrfzj4rNW%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Ryan Ding <ryan.ding@oracle.com>
Subject: ocfs2: take ip_alloc_sem in ocfs2_dio_get_block & ocfs2_dio_end_io_write

Take ip_alloc_sem to prevent concurrent access to extent tree, which may
cause the extent tree in an unstable state.

Signed-off-by: Ryan Ding <ryan.ding@oracle.com>
Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-take-ip_alloc_sem-in-ocfs2_dio_get_block-ocfs2_dio_end_io_write fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-take-ip_alloc_sem-in-ocfs2_dio_get_block-ocfs2_dio_end_io_write
+++ a/fs/ocfs2/aops.c
@@ -2151,6 +2151,7 @@ static int ocfs2_dio_get_block(struct in
 			       struct buffer_head *bh_result, int create)
 {
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_write_ctxt *wc;
 	struct ocfs2_write_cluster_desc *desc = NULL;
 	struct ocfs2_dio_write_ctxt *dwc = NULL;
@@ -2166,9 +2167,12 @@ static int ocfs2_dio_get_block(struct in
 	mlog(0, "get block of %lu at %llu:%u req %u\n",
 			inode->i_ino, pos, len, total_len);
 
+	down_read(&oi->ip_alloc_sem);
 	/* This is the fast path for re-write. */
 	ret = ocfs2_get_block(inode, iblock, bh_result, create);
 
+	up_read(&oi->ip_alloc_sem);
+
 	if (buffer_mapped(bh_result) &&
 	    !buffer_new(bh_result) &&
 	    ret == 0)
@@ -2206,6 +2210,8 @@ static int ocfs2_dio_get_block(struct in
 		goto out;
 	}
 
+	down_write(&oi->ip_alloc_sem);
+
 	if (first_get_block) {
 		if (ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
 			ret = ocfs2_zero_tail(inode, di_bh, pos);
@@ -2259,6 +2265,7 @@ static int ocfs2_dio_get_block(struct in
 	BUG_ON(ret != len);
 	ret = 0;
 unlock:
+	up_write(&oi->ip_alloc_sem);
 	ocfs2_inode_unlock(inode, 1);
 	brelse(di_bh);
 out:
@@ -2275,6 +2282,7 @@ static void ocfs2_dio_end_io_write(struc
 	struct ocfs2_cached_dealloc_ctxt dealloc;
 	struct ocfs2_extent_tree et;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_unwritten_extent *ue = NULL;
 	struct buffer_head *di_bh = NULL;
 	struct ocfs2_dinode *di;
@@ -2293,12 +2301,6 @@ static void ocfs2_dio_end_io_write(struc
 	    !dwc->dw_orphaned)
 		goto out;
 
-	ret = ocfs2_inode_lock(inode, &di_bh, 1);
-	if (ret < 0) {
-		mlog_errno(ret);
-		goto out;
-	}
-
 	/* ocfs2_file_write_iter will get i_mutex, so we need not lock if we
 	 * are in that context. */
 	if (dwc->dw_writer_pid != task_pid_nr(current)) {
@@ -2306,6 +2308,14 @@ static void ocfs2_dio_end_io_write(struc
 		locked = 1;
 	}
 
+	ret = ocfs2_inode_lock(inode, &di_bh, 1);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	down_write(&oi->ip_alloc_sem);
+
 	/* Delete orphan before acquire i_mutex. */
 	if (dwc->dw_orphaned) {
 		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
@@ -2359,6 +2369,7 @@ static void ocfs2_dio_end_io_write(struc
 commit:
 	ocfs2_commit_trans(osb, handle);
 unlock:
+	up_write(&oi->ip_alloc_sem);
 	ocfs2_inode_unlock(inode, 1);
 	brelse(di_bh);
 out:
_
