From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 31 Oct 2014 19:32:55 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix leftover orphan entry caused by
 append O_DIRECT write crash
Message-ID: <54537367.3060405@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This is try to fix an issue introduced by:
[PATCH 0/7 v5] ocfs2: support append O_DIRECT write

If one node has crashed with orphan entry leftover, another node which
do append O_DIRECT write to the same file will override the
i_dio_orphaned_slot. Then the old entry won't be cleaned forever.
If this case happens, we let it wait for orphan recovery first.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/inode.h   |  2 ++
 fs/ocfs2/journal.c |  2 ++
 fs/ocfs2/namei.c   | 37 +++++++++++++++++++++++++++++++++++--
 fs/ocfs2/super.c   |  2 ++
 4 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index a9b76de..1fdf470 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -80,6 +80,8 @@ struct ocfs2_inode_info
 	 */
 	tid_t i_sync_tid;
 	tid_t i_datasync_tid;
+
+	wait_queue_head_t append_dio_wq;
 };

 /*
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 1ddb34d..d44c031 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -2208,6 +2208,8 @@ static int ocfs2_recover_orphans(struct ocfs2_super *osb,
 			ret = ocfs2_del_inode_from_orphan(osb, inode, 0, 0);
 			if (ret)
 				mlog_errno(ret);
+
+			wake_up(&OCFS2_I(inode)->append_dio_wq);
 		} /* else if ORPHAN_NO_NEED_TRUNCATE, do nothing */

 next:
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index e6587ec..ceceb20 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -2654,6 +2654,26 @@ leave:
 	return status;
 }

+static int ocfs2_dio_orphan_recovered(struct inode *inode)
+{
+	int ret;
+	struct buffer_head *di_bh = NULL;
+	struct ocfs2_dinode *di = NULL;
+
+	ret = ocfs2_inode_lock(inode, &di_bh, 1);
+	if (ret < 0) {
+		mlog_errno(ret);
+		return 0;
+	}
+
+	di = (struct ocfs2_dinode *) di_bh->b_data;
+	ret = !(di->i_flags & cpu_to_le32(OCFS2_DIO_ORPHANED_FL));
+	ocfs2_inode_unlock(inode, 1);
+	brelse(di_bh);
+
+	return ret;
+}
+
 int ocfs2_add_inode_to_orphan(struct ocfs2_super *osb,
 	struct inode *inode)
 {
@@ -2666,12 +2686,26 @@ int ocfs2_add_inode_to_orphan(struct ocfs2_super *osb,
 	struct ocfs2_dinode *di = NULL;
 	bool orphaned = false;

+restart:
 	status = ocfs2_inode_lock(inode, &di_bh, 1);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
 	}

+	di = (struct ocfs2_dinode *) di_bh->b_data;
+	/*
+	 * Another append dio crashed?
+	 * If so, wait for recovery first.
+	 */
+	if (unlikely(di->i_flags & cpu_to_le32(OCFS2_DIO_ORPHANED_FL))) {
+		ocfs2_inode_unlock(inode, 1);
+		brelse(di_bh);
+		wait_event_interruptible(OCFS2_I(inode)->append_dio_wq,
+				ocfs2_dio_orphan_recovered(inode));
+		goto restart;
+	}
+
 	status = ocfs2_dio_prepare_orphan_dir(osb, &orphan_dir_inode,
 			OCFS2_I(inode)->ip_blkno,
 			orphan_name,
@@ -2684,8 +2718,7 @@ int ocfs2_add_inode_to_orphan(struct ocfs2_super *osb,
 				"orphan dir %llu.\n",
 				OCFS2_I(inode)->ip_blkno,
 				OCFS2_I(orphan_dir_inode)->ip_blkno);
-		di = (struct ocfs2_dinode *) di_bh->b_data;
-		if (!(di->i_flags & le32_to_cpu(OCFS2_ORPHANED_FL))) {
+		if (!(di->i_flags & cpu_to_le32(OCFS2_ORPHANED_FL))) {
 			mlog_errno(status);
 			goto bail_unlock_orphan;
 		}
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 93c85bc..da33a14 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1760,6 +1760,8 @@ static void ocfs2_inode_init_once(void *data)
 	ocfs2_lock_res_init_once(&oi->ip_inode_lockres);
 	ocfs2_lock_res_init_once(&oi->ip_open_lockres);

+	init_waitqueue_head(&oi->append_dio_wq);
+
 	ocfs2_metadata_cache_init(INODE_CACHE(&oi->vfs_inode),
 				  &ocfs2_inode_caching_ops);

-- 
1.8.4.3
