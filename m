From: Jan Kara <jack@suse.cz>
Date: Wed, 28 Feb 2018 12:17:59 +0100
Subject: [Ocfs2-devel] [PATCH 3/6] ocfs2: Fix deadlock during umount
In-Reply-To: <20180228111802.23967-1-jack@suse.cz>
References: <20180228111802.23967-1-jack@suse.cz>
Message-ID: <20180228111802.23967-4-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When ocfs2 quota recovery races with umount, it can happen that umount
waits for recovery to finish while quota recovery waits to grab s_umount
semaphore held by umount. This results in a deadlock. Fix the problem by
not grabbing s_umount semaphore during quota recovery. We are protected
from disabling of quotas by the fact that quotas gets disabled only on
umount and that happens after recovery is disabled.

Reported-by: Shichangkuo <shi.changkuo@h3c.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/quota_local.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 16c42ed0dca8..d60d744bbcb2 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -454,8 +454,10 @@ struct ocfs2_quota_recovery *ocfs2_begin_quota_recovery(
 
 /* Sync changes in local quota file into global quota file and
  * reinitialize local quota file.
- * The function expects local quota file to be already locked and
- * s_umount locked in shared mode. */
+ * The function expects local quota file to be already locked. Quota is
+ * disabled only during umount after disabling recovery so we are protected
+ * against that.
+ */
 static int ocfs2_recover_local_quota_file(struct inode *lqinode,
 					  int type,
 					  struct ocfs2_quota_recovery *rec)
@@ -586,7 +588,6 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
 {
 	unsigned int ino[OCFS2_MAXQUOTAS] = { LOCAL_USER_QUOTA_SYSTEM_INODE,
 					      LOCAL_GROUP_QUOTA_SYSTEM_INODE };
-	struct super_block *sb = osb->sb;
 	struct ocfs2_local_disk_dqinfo *ldinfo;
 	struct buffer_head *bh;
 	handle_t *handle;
@@ -598,7 +599,6 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
 	printk(KERN_NOTICE "ocfs2: Finishing quota recovery on device (%s) for "
 	       "slot %u\n", osb->dev_str, slot_num);
 
-	down_read(&sb->s_umount);
 	for (type = 0; type < OCFS2_MAXQUOTAS; type++) {
 		if (list_empty(&(rec->r_list[type])))
 			continue;
@@ -675,7 +675,6 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
 			break;
 	}
 out:
-	up_read(&sb->s_umount);
 	kfree(rec);
 	return status;
 }
@@ -837,9 +836,10 @@ static int ocfs2_local_free_info(struct super_block *sb, int type)
 	ocfs2_release_local_quota_bitmaps(&oinfo->dqi_chunk);
 
 	/*
-	 * s_umount held in exclusive mode protects us against racing with
-	 * recovery thread...
+	 * Recovery should be already disabled at this point so that we cannot
+	 * race with quota recovery.
 	 */
+	WARN_ON(!OCFS2_SB(sb)->disable_recovery);
 	if (oinfo->dqi_rec) {
 		ocfs2_free_quota_recovery(oinfo->dqi_rec);
 		mark_clean = 0;
-- 
2.13.6
