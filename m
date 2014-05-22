From: Xue jiufei <xuejiufei@huawei.com>
Date: Thu, 22 May 2014 10:20:34 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: revert the patch fix NULL pointer
 dereference when dismount and ocfs2rec simultaneously
Message-ID: <537D5EF2.8060506@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following patch may cause umount hang while
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

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
---
 fs/ocfs2/super.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index a7cdd56..6fd5eb3 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1925,15 +1925,11 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 
 	ocfs2_shutdown_local_alloc(osb);
 
+	ocfs2_truncate_log_shutdown(osb);
+
 	/* This will disable recovery and flush any recovery work. */
 	ocfs2_recovery_exit(osb);
 
-	/*
-	 * During dismount, when it recovers another node it will call
-	 * ocfs2_recover_orphans and queue delayed work osb_truncate_log_wq.
-	 */
-	ocfs2_truncate_log_shutdown(osb);
-
 	ocfs2_journal_shutdown(osb);
 
 	ocfs2_sync_blockdev(sb);
-- 
1.8.3.4
