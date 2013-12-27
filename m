From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 27 Dec 2013 10:27:06 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix NULL pointer dereference when
 dismount and ocfs2rec simultaneously
Message-ID: <52BCE57A.7050406@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Yiwen Jiang <jiangyiwen@huawei.com>

2 nodes cluster, say Node A and Node B, mount the same ocfs2 volume,
and create a file 1.

Node A			Node B
open 1, get open lock
                        rm 1, and then add 1 to orphan_dir
storage link down,
o2hb_write_timeout
->o2quo_disk_timeout
->emergency_restart
                        at the moment, Node B dismount and do
			ocfs2rec simultaneously
                        1) ocfs2_dismount_volume
			->ocfs2_recovery_exit
			->wait_event(osb->recovery_event)
			->flush_workqueue(ocfs2_wq)
			2) ocfs2rec
			->queue_work(&journal->j_recovery_work)
                        ->ocfs2_recover_orphans
			->ocfs2_commit_truncate
                        ->queue_delayed_work(&osb->osb_truncate_log_wq)

In ocfs2_recovery_exit, it flushes workqueue and then releases system
inodes. When doing ocfs2rec, it will call ocfs2_flush_truncate_log
which will try to get sys_root_inode, and NULL pointer dereference
occurs.

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Signed-off-by: joyce <xuejiufei@huawei.com>
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/super.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index c414929..665e91e 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1947,11 +1947,15 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 
 	ocfs2_shutdown_local_alloc(osb);
 
-	ocfs2_truncate_log_shutdown(osb);
-
 	/* This will disable recovery and flush any recovery work. */
 	ocfs2_recovery_exit(osb);
 
+	/*
+	 * During dismount, when it recovers another node it will call
+	 * ocfs2_recover_orphans and queue delayed work osb_truncate_log_wq.
+	 */
+	ocfs2_truncate_log_shutdown(osb);
+
 	ocfs2_journal_shutdown(osb);
 
 	ocfs2_sync_blockdev(sb);
-- 
1.8.4.3
