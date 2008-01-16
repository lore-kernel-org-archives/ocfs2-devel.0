From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed Jan 16 11:33:16 2008
Subject: [Ocfs2-devel] [PATCH 04/20] ocfs2: Commit journal on sync writes
In-Reply-To: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
References: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1200511977-19513-5-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Maineline commit 9ea2d32f40434589ea0e136373f7d1545afb411f
Author: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu, 18 Oct 2007 14:14:45 -0700

We're missing a meta data commit for extending sync writes. In thoery, write
could return with the meta data required to read the data uncommitted to
disk. Fix that by detecting an allocating write and forcing a journal commit
in the sync case.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/file.c |   26 +++++++++++++++++++++++++-
 1 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index ad73b3c..a6a93b1 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2027,9 +2027,11 @@ static ssize_t __ocfs2_file_aio_write(struct kiocb *iocb,
 	ssize_t written = 0;
 	size_t ocount;		/* original count */
 	size_t count;		/* after file limit checks */
-	loff_t *ppos = &iocb->ki_pos;
+	loff_t old_size, *ppos = &iocb->ki_pos;
+	u32 old_clusters;
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = filp_dentry(file)->d_inode;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	mlog_entry("(0x%p, %u, '%.*s')\n", file,
 		   (unsigned int)nr_segs,
@@ -2111,6 +2113,13 @@ relock:
 	 */
 	pos = *ppos;
 
+	/*
+	 * To later detect whether a journal commit for sync writes is
+	 * necessary, we sample i_size, and cluster count here.
+	 */
+	old_size = i_size_read(inode);
+	old_clusters = OCFS2_I(inode)->ip_clusters;
+
 	/* communicate with ocfs2_dio_end_io */
 	ocfs2_iocb_set_rw_locked(iocb, rw_level);
 
@@ -2136,6 +2145,21 @@ out_dio:
 	/* buffered aio wouldn't have proper lock coverage today */
 	BUG_ON(ret == -EIOCBQUEUED && !(file->f_flags & O_DIRECT));
 
+	if ((file->f_flags & O_SYNC && !direct_io) || IS_SYNC(inode)) {
+		/*
+		 * The generic write paths have handled getting data
+		 * to disk, but since we don't make use of the dirty
+		 * inode list, a manual journal commit is necessary
+		 * here.
+		 */
+		if (old_size != i_size_read(inode) ||
+		    old_clusters != OCFS2_I(inode)->ip_clusters) {
+			ret = journal_force_commit(osb->journal->j_journal);
+			if (ret < 0)
+				written = ret;
+		}
+	}
+
 	/* 
 	 * deep in g_f_a_w_n()->ocfs2_direct_IO we pass in a ocfs2_dio_end_io
 	 * function pointer which is called when o_direct io completes so that
-- 
1.5.3.4
