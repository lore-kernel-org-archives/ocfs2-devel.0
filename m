From: Tristan Ye <tristan.ye@oracle.com>
Date: Mon, 29 Nov 2010 17:21:46 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Teach 'coherency=full' O_DIRECT
	writes to correctly up_read i_alloc_sem.
Message-ID: <1291022506-14981-1-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Due to newly-introduced 'coherency=full' O_DIRECT writes also takes the EX
rw_lock like buffered writes did(rw_level == 1), it turns out messing the
usage of 'level' in ocfs2_dio_end_io() up, which caused i_alloc_sem being
failed to get up_read'd correctly.

This patch tries to teach ocfs2_dio_end_io to understand well on all locking
stuffs by explicitly introducing a new bit for i_alloc_sem in iocb's private
data, just like what we did for rw_lock.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/aops.c |    6 ++++--
 fs/ocfs2/aops.h |    6 ++++++
 fs/ocfs2/file.c |    9 +++++++--
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index f1e962c..857e013 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -568,7 +568,7 @@ static void ocfs2_dio_end_io(struct kiocb *iocb,
 			     bool is_async)
 {
 	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
-	int level;
+	int level, sem_locked;
 
 	/* this io's submitter should not have unlocked this before we could */
 	BUG_ON(!ocfs2_iocb_is_rw_locked(iocb));
@@ -576,7 +576,9 @@ static void ocfs2_dio_end_io(struct kiocb *iocb,
 	ocfs2_iocb_clear_rw_locked(iocb);
 
 	level = ocfs2_iocb_rw_locked_level(iocb);
-	if (!level)
+	sem_locked = ocfs2_iocb_is_sem_locked(iocb);
+	ocfs2_iocb_clear_sem_locked(iocb);
+	if (sem_locked)
 		up_read(&inode->i_alloc_sem);
 	ocfs2_rw_unlock(inode, level);
 
diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
index 76bfdfd..c7a3e5f 100644
--- a/fs/ocfs2/aops.h
+++ b/fs/ocfs2/aops.h
@@ -72,4 +72,10 @@ static inline void ocfs2_iocb_set_rw_locked(struct kiocb *iocb, int level)
 	clear_bit(0, (unsigned long *)&iocb->private)
 #define ocfs2_iocb_rw_locked_level(iocb) \
 	test_bit(1, (unsigned long *)&iocb->private)
+#define ocfs2_iocb_set_sem_locked(iocb) \
+	set_bit(2, (unsigned long *)&iocb->private)
+#define ocfs2_iocb_clear_sem_locked(iocb) \
+	clear_bit(2, (unsigned long *)&iocb->private)
+#define ocfs2_iocb_is_sem_locked(iocb) \
+	test_bit(2, (unsigned long *)&iocb->private)
 #endif /* OCFS2_FILE_H */
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 77b4c04..0e9d729 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2246,7 +2246,10 @@ relock:
 	if (direct_io) {
 		down_read(&inode->i_alloc_sem);
 		have_alloc_sem = 1;
-	}
+		/* communicate with ocfs2_dio_end_io */
+		ocfs2_iocb_set_sem_locked(iocb);
+	} else
+		ocfs2_iocb_clear_sem_locked(iocb);
 
 	/*
 	 * Concurrent O_DIRECT writes are allowed with
@@ -2534,6 +2537,7 @@ static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
 	if (filp->f_flags & O_DIRECT) {
 		down_read(&inode->i_alloc_sem);
 		have_alloc_sem = 1;
+		ocfs2_iocb_set_sem_locked(iocb);
 
 		ret = ocfs2_rw_lock(inode, 0);
 		if (ret < 0) {
@@ -2543,7 +2547,8 @@ static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
 		rw_level = 0;
 		/* communicate with ocfs2_dio_end_io */
 		ocfs2_iocb_set_rw_locked(iocb, rw_level);
-	}
+	} else
+		ocfs2_iocb_clear_sem_locked(iocb);
 
 	/*
 	 * We're fine letting folks race truncates and extending
-- 
1.5.5
