From: Xue jiufei <xuejiufei@huawei.com>
Date: Thu, 22 May 2014 09:48:20 +0800
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: fix umount hang while shutting down
	truncate log
Message-ID: <537D5764.5080904@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Revert the following patch because it may cause umount hang while
shutting down truncate log.
75f82eaa502c (ocfs2: fix NULL pointer dereference when dismount and
ocfs2rec simultaneously)

The situation is as followes:
ocfs2_dismout_volume
-> ocfs2_recovery_exit
  -> free osb->recovery_map
-> ocfs2_truncate_shutdown
  -> lock global bitmap inode
    -> ocfs2_wait_for_recovery
	  -> check whether osb->recovery_map->rm_used is zero
Because osb->recovery_map is already freed, rm_used can be any other
values, so it may yield umount hang.

To prevent NULL pointer dereference while getting sys_root_inode, we
use a osb_tl_disable flag to disable schedule osb_truncate_log_wq after
truncate log shutdown.

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
---
 fs/ocfs2/alloc.c | 6 +++++-
 fs/ocfs2/ocfs2.h | 1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index b4deb5f..9d8fcf2 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6046,7 +6046,8 @@ static void ocfs2_truncate_log_worker(struct work_struct *work)
 void ocfs2_schedule_truncate_log_flush(struct ocfs2_super *osb,
 				       int cancel)
 {
-	if (osb->osb_tl_inode) {
+	if (osb->osb_tl_inode &&
+			atomic_read(&osb->osb_tl_disable) == 0) {
 		/* We want to push off log flushes while truncates are
 		 * still running. */
 		if (cancel)
@@ -6223,6 +6224,8 @@ void ocfs2_truncate_log_shutdown(struct ocfs2_super *osb)
 	int status;
 	struct inode *tl_inode = osb->osb_tl_inode;
 
+	atomic_set(&osb->osb_tl_disable, 1);
+
 	if (tl_inode) {
 		cancel_delayed_work(&osb->osb_truncate_log_wq);
 		flush_workqueue(ocfs2_wq);
@@ -6254,6 +6257,7 @@ int ocfs2_truncate_log_init(struct ocfs2_super *osb)
 	 * until we're sure all is well. */
 	INIT_DELAYED_WORK(&osb->osb_truncate_log_wq,
 			  ocfs2_truncate_log_worker);
+	atomic_set(&osb->osb_tl_disable, 0);
 	osb->osb_tl_bh    = tl_bh;
 	osb->osb_tl_inode = tl_inode;
 
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 8d64a97..bbec539 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -422,6 +422,7 @@ struct ocfs2_super
 	struct inode			*osb_tl_inode;
 	struct buffer_head		*osb_tl_bh;
 	struct delayed_work		osb_truncate_log_wq;
+	atomic_t			osb_tl_disable;
 	/*
 	 * How many clusters in our truncate log.
 	 * It must be protected by osb_tl_inode->i_mutex.
-- 
1.8.3.4
