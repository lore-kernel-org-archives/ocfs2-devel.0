From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Mon, 09 Jun 2014 13:04:02 -0700
Subject: [Ocfs2-devel] [patch 3/8] ocfs2: revert "ocfs2: fix NULL pointer
	dereference when dismount and ocfs2rec simultaneously"
Message-ID: <20140609200402.66B1331C76B@corp2gmr1-1.hot.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2: revert "ocfs2: fix NULL pointer dereference when dismount and ocfs2rec simultaneously"

75f82eaa502c ("ocfs2: fix NULL pointer dereference when dismount and
ocfs2rec simultaneously") may cause umount hang while shutting down
truncate log.

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
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/super.c~ocfs2-revert-the-patch-fix-null-pointer-dereference-when-dismount-and-ocfs2rec-simultaneously fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-revert-the-patch-fix-null-pointer-dereference-when-dismount-and-ocfs2rec-simultaneously
+++ a/fs/ocfs2/super.c
@@ -1925,15 +1925,11 @@ static void ocfs2_dismount_volume(struct
 
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
_
