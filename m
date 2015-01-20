From: Joseph Qi <joseph.qi@huawei.com>
Date: Tue, 20 Jan 2015 16:11:34 +0800
Subject: [Ocfs2-devel] [PATCH 8/9 v6] ocfs2: wait for orphan recovery first
 once append O_DIRECT write crash
Message-ID: <54BE0DB6.4080207@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

If one node has crashed with orphan entry leftover, another node which do
append O_DIRECT write to the same file will override the
i_dio_orphaned_slot.  Then the old entry won't be cleaned forever. If
this case happens, we let it wait for orphan recovery first.

Cc: Weiwei Wang <wangww631@huawei.com>
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/inode.h   |  2 ++
 fs/ocfs2/journal.c |  2 ++
 fs/ocfs2/namei.c   | 37 +++++++++++++++++++++++++++++++++++++
 fs/ocfs2/super.c   |  2 ++
 4 files changed, 43 insertions(+)

diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index ca3431e..5e86b24 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -81,6 +81,8 @@ struct ocfs2_inode_info
 	tid_t i_sync_tid;
 	tid_t i_datasync_tid;

+	wait_queue_head_t append_dio_wq;
+
 	struct dquot *i_dquot[MAXQUOTAS];
 };

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 1163127..ca11c83 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -2205,6 +2205,8 @@ static int ocfs2_recover_orphans(struct ocfs2_super *osb,
 			ret = ocfs2_del_inode_from_orphan(osb, inode, 0, 0);
 			if (ret)
 				mlog_errno(ret);
+
+			wake_up(&OCFS2_I(inode)->append_dio_wq);
 		} /* else if ORPHAN_NO_NEED_TRUNCATE, do nothing */

 next:
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index b069d6d..873b40a 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -2578,6 +2578,27 @@ leave:
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
+#define OCFS2_DIO_ORPHANED_FL_CHECK_INTERVAL 10000
 int ocfs2_add_inode_to_orphan(struct ocfs2_super *osb,
 	struct inode *inode)
 {
@@ -2587,13 +2608,29 @@ int ocfs2_add_inode_to_orphan(struct ocfs2_super *osb,
 	struct buffer_head *di_bh = NULL;
 	int status = 0;
 	handle_t *handle = NULL;
+	struct ocfs2_dinode *di = NULL;

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
+		wait_event_interruptible_timeout(OCFS2_I(inode)->append_dio_wq,
+				ocfs2_dio_orphan_recovered(inode),
+				msecs_to_jiffies(OCFS2_DIO_ORPHANED_FL_CHECK_INTERVAL));
+		goto restart;
+	}
+
 	status = ocfs2_prepare_orphan_dir(osb, &orphan_dir_inode,
 			OCFS2_I(inode)->ip_blkno,
 			orphan_name,
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 8372317..04ee6d1 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1768,6 +1768,8 @@ static void ocfs2_inode_init_once(void *data)
 	ocfs2_lock_res_init_once(&oi->ip_inode_lockres);
 	ocfs2_lock_res_init_once(&oi->ip_open_lockres);

+	init_waitqueue_head(&oi->append_dio_wq);
+
 	ocfs2_metadata_cache_init(INODE_CACHE(&oi->vfs_inode),
 				  &ocfs2_inode_caching_ops);

-- 
1.8.4.3
