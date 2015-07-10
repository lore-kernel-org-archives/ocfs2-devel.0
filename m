From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 10 Jul 2015 19:18:38 +0800
Subject: [Ocfs2-devel] [PATCH 1/2 v2] ocfs2: fix race between dio and
	recover orphan
Message-ID: <559FAA0E.8090005@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

During direct io the inode will be added to orphan first and then
deleted from orphan. There is a race window that the orphan entry will
be deleted twice and thus trigger the BUG when validating
OCFS2_DIO_ORPHANED_FL in ocfs2_del_inode_from_orphan.

ocfs2_direct_IO_write
    ...
    ocfs2_add_inode_to_orphan
    >>>>>>>> race window.
             1) another node may rm the file and then down, this node
             take care of orphan recovery and clear flag
             OCFS2_DIO_ORPHANED_FL.
             2) since rw lock is unlocked, it may race with another
             orphan recovery and append dio.
    ocfs2_del_inode_from_orphan

So take Take inode mutex lock when recover orphans and make rw unlock
at the end of aio write in case of append dio.

Reported-by: Yiwen Jiang <jiangyiwen@huawei.com>
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/aops.c    |  9 ++++++---
 fs/ocfs2/file.c    |  2 +-
 fs/ocfs2/inode.h   |  2 --
 fs/ocfs2/journal.c |  8 ++++----
 fs/ocfs2/namei.c   | 42 +++++++++++++-----------------------------
 fs/ocfs2/super.c   |  2 --
 6 files changed, 24 insertions(+), 41 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 1a35c61..eb8b05d 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -627,10 +627,13 @@ static void ocfs2_dio_end_io(struct kiocb *iocb,
 		mutex_unlock(&OCFS2_I(inode)->ip_unaligned_aio);
 	}

-	ocfs2_iocb_clear_rw_locked(iocb);
+	/* Let rw unlock to be done later to protect append direct io write */
+	if (offset + bytes <= i_size_read(inode)) {
+		ocfs2_iocb_clear_rw_locked(iocb);

-	level = ocfs2_iocb_rw_locked_level(iocb);
-	ocfs2_rw_unlock(inode, level);
+		level = ocfs2_iocb_rw_locked_level(iocb);
+		ocfs2_rw_unlock(inode, level);
+	}
 }

 static int ocfs2_releasepage(struct page *page, gfp_t wait)
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 719f7f4..3403a54 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2410,7 +2410,7 @@ no_sync:
 		unaligned_dio = 0;
 	}

-	if (unaligned_dio) {
+	if (unaligned_dio && ocfs2_iocb_is_unaligned_aio(iocb)) {
 		ocfs2_iocb_clear_unaligned_aio(iocb);
 		mutex_unlock(&OCFS2_I(inode)->ip_unaligned_aio);
 	}
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index 5e86b24..ca3431e 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -81,8 +81,6 @@ struct ocfs2_inode_info
 	tid_t i_sync_tid;
 	tid_t i_datasync_tid;

-	wait_queue_head_t append_dio_wq;
-
 	struct dquot *i_dquot[MAXQUOTAS];
 };

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 7c099f7..5e56268 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -2170,6 +2170,7 @@ static int ocfs2_recover_orphans(struct ocfs2_super *osb,
 		iter = oi->ip_next_orphan;
 		oi->ip_next_orphan = NULL;

+		mutex_lock(&inode->i_mutex);
 		ret = ocfs2_rw_lock(inode, 1);
 		if (ret < 0) {
 			mlog_errno(ret);
@@ -2206,17 +2207,16 @@ static int ocfs2_recover_orphans(struct ocfs2_super *osb,
 			ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh, 0, 0);
 			if (ret)
 				mlog_errno(ret);
-
-			wake_up(&OCFS2_I(inode)->append_dio_wq);
 		} /* else if ORPHAN_NO_NEED_TRUNCATE, do nothing */
 unlock_inode:
 		ocfs2_inode_unlock(inode, 1);
+		brelse(di_bh);
+		di_bh = NULL;
 unlock_rw:
 		ocfs2_rw_unlock(inode, 1);
 next:
+		mutex_unlock(&inode->i_mutex);
 		iput(inode);
-		brelse(di_bh);
-		di_bh = NULL;
 		inode = iter;
 	}

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 6e6abb9..38b3336 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -2570,27 +2570,6 @@ leave:
 	return status;
 }

-static int ocfs2_dio_orphan_recovered(struct inode *inode)
-{
-	int ret;
-	struct buffer_head *di_bh = NULL;
-	struct ocfs2_dinode *di = NULL;
-
-	ret = ocfs2_inode_lock(inode, &di_bh, 1);
-	if (ret < 0) {
-		mlog_errno(ret);
-		return 0;
-	}
-
-	di = (struct ocfs2_dinode *) di_bh->b_data;
-	ret = !(di->i_flags & cpu_to_le32(OCFS2_DIO_ORPHANED_FL));
-	ocfs2_inode_unlock(inode, 1);
-	brelse(di_bh);
-
-	return ret;
-}
-
-#define OCFS2_DIO_ORPHANED_FL_CHECK_INTERVAL 10000
 int ocfs2_add_inode_to_orphan(struct ocfs2_super *osb,
 	struct inode *inode)
 {
@@ -2602,7 +2581,6 @@ int ocfs2_add_inode_to_orphan(struct ocfs2_super *osb,
 	handle_t *handle = NULL;
 	struct ocfs2_dinode *di = NULL;

-restart:
 	status = ocfs2_inode_lock(inode, &di_bh, 1);
 	if (status < 0) {
 		mlog_errno(status);
@@ -2612,15 +2590,21 @@ restart:
 	di = (struct ocfs2_dinode *) di_bh->b_data;
 	/*
 	 * Another append dio crashed?
-	 * If so, wait for recovery first.
+	 * If so, manually recover it first.
 	 */
 	if (unlikely(di->i_flags & cpu_to_le32(OCFS2_DIO_ORPHANED_FL))) {
-		ocfs2_inode_unlock(inode, 1);
-		brelse(di_bh);
-		wait_event_interruptible_timeout(OCFS2_I(inode)->append_dio_wq,
-				ocfs2_dio_orphan_recovered(inode),
-				msecs_to_jiffies(OCFS2_DIO_ORPHANED_FL_CHECK_INTERVAL));
-		goto restart;
+		status = ocfs2_truncate_file(inode, di_bh, i_size_read(inode));
+		if (status < 0) {
+			if (status != -ENOSPC)
+				mlog_errno(status);
+			goto bail_unlock_inode;
+		}
+
+		status = ocfs2_del_inode_from_orphan(osb, inode, di_bh, 0, 0);
+		if (status < 0) {
+			mlog_errno(status);
+			goto bail_unlock_inode;
+		}
 	}

 	status = ocfs2_prepare_orphan_dir(osb, &orphan_dir_inode,
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 403c566..4474ef2 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1746,8 +1746,6 @@ static void ocfs2_inode_init_once(void *data)
 	ocfs2_lock_res_init_once(&oi->ip_inode_lockres);
 	ocfs2_lock_res_init_once(&oi->ip_open_lockres);

-	init_waitqueue_head(&oi->append_dio_wq);
-
 	ocfs2_metadata_cache_init(INODE_CACHE(&oi->vfs_inode),
 				  &ocfs2_inode_caching_ops);

-- 
1.8.4.3
