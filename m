From: Tao Ma <tao.ma@oracle.com>
Date: Thu,  3 Dec 2009 21:55:05 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Handle O_DIRECT when writing to a
	refcounted cluster.
Message-ID: <1259848505-8049-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In case of writing to a refcounted cluster with O_DIRECT,
we need to fall back to buffer write. And when it is finished,
we need to flush the page and the journal as we did for other
O_DIRECT writes.

This patch fix oss bug 1191.
http://oss.oracle.com/bugzilla/show_bug.cgi?id=1191

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Tested-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/file.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 89fc8ee..2eb0a66 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1771,7 +1771,8 @@ static int ocfs2_prepare_inode_for_write(struct dentry *dentry,
 					 loff_t *ppos,
 					 size_t count,
 					 int appending,
-					 int *direct_io)
+					 int *direct_io,
+					 int *has_refcount)
 {
 	int ret = 0, meta_level = 0;
 	struct inode *inode = dentry->d_inode;
@@ -1832,6 +1833,8 @@ static int ocfs2_prepare_inode_for_write(struct dentry *dentry,
 							       saved_pos,
 							       count,
 							       &meta_level);
+			if (has_refcount)
+				*has_refcount = 1;
 		}
 
 		if (ret < 0) {
@@ -1855,6 +1858,10 @@ static int ocfs2_prepare_inode_for_write(struct dentry *dentry,
 			break;
 		}
 
+		if (has_refcount && *has_refcount == 1) {
+			*direct_io = 0;
+			break;
+		}
 		/*
 		 * Allowing concurrent direct writes means
 		 * i_size changes wouldn't be synchronized, so
@@ -1898,7 +1905,7 @@ static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
 				    loff_t pos)
 {
 	int ret, direct_io, appending, rw_level, have_alloc_sem  = 0;
-	int can_do_direct;
+	int can_do_direct, has_refcount = 0;
 	ssize_t written = 0;
 	size_t ocount;		/* original count */
 	size_t count;		/* after file limit checks */
@@ -1941,7 +1948,7 @@ relock:
 	can_do_direct = direct_io;
 	ret = ocfs2_prepare_inode_for_write(file->f_path.dentry, ppos,
 					    iocb->ki_left, appending,
-					    &can_do_direct);
+					    &can_do_direct, &has_refcount);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
@@ -2005,14 +2012,16 @@ out_dio:
 	/* buffered aio wouldn't have proper lock coverage today */
 	BUG_ON(ret == -EIOCBQUEUED && !(file->f_flags & O_DIRECT));
 
-	if ((file->f_flags & O_SYNC && !direct_io) || IS_SYNC(inode)) {
+	if ((file->f_flags & O_SYNC && !direct_io) || IS_SYNC(inode) ||
+	    (file->f_flags & O_DIRECT && has_refcount)) {
 		ret = filemap_fdatawrite_range(file->f_mapping, pos,
 					       pos + count - 1);
 		if (ret < 0)
 			written = ret;
 
 		if (!ret && (old_size != i_size_read(inode) ||
-		    old_clusters != OCFS2_I(inode)->ip_clusters)) {
+		    old_clusters != OCFS2_I(inode)->ip_clusters ||
+		    has_refcount)) {
 			ret = jbd2_journal_force_commit(osb->journal->j_journal);
 			if (ret < 0)
 				written = ret;
@@ -2061,7 +2070,7 @@ static int ocfs2_splice_to_file(struct pipe_inode_info *pipe,
 	int ret;
 
 	ret = ocfs2_prepare_inode_for_write(out->f_path.dentry,	&sd->pos,
-					    sd->total_len, 0, NULL);
+					    sd->total_len, 0, NULL, NULL);
 	if (ret < 0) {
 		mlog_errno(ret);
 		return ret;
-- 
1.5.5
