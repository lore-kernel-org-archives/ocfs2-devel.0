From: Jan Kara <jack@suse.cz>
Date: Thu, 24 Nov 2016 09:12:41 +0100
Subject: [Ocfs2-devel] [PATCH 6/7] ocfs2: Use s_umount for quota recovery
	protection
In-Reply-To: <1479975162-24060-1-git-send-email-jack@suse.cz>
References: <1479975162-24060-1-git-send-email-jack@suse.cz>
Message-ID: <1479975162-24060-7-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>, mfasheh@versity.com, jlbec@evilplan.org, ocfs2-devel@oss.oracle.com, Jan Kara <jack@suse.cz>

Currently we use dqonoff_mutex to serialize quota recovery protection
and turning of quotas on / off. Use s_umount semaphore instead.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/quota_local.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 8a54fd8a4fa5..32c5a40c1257 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -454,7 +454,7 @@ struct ocfs2_quota_recovery *ocfs2_begin_quota_recovery(
 /* Sync changes in local quota file into global quota file and
  * reinitialize local quota file.
  * The function expects local quota file to be already locked and
- * dqonoff_mutex locked. */
+ * s_umount locked in shared mode. */
 static int ocfs2_recover_local_quota_file(struct inode *lqinode,
 					  int type,
 					  struct ocfs2_quota_recovery *rec)
@@ -597,7 +597,7 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
 	printk(KERN_NOTICE "ocfs2: Finishing quota recovery on device (%s) for "
 	       "slot %u\n", osb->dev_str, slot_num);
 
-	mutex_lock(&sb_dqopt(sb)->dqonoff_mutex);
+	down_read(&sb->s_umount);
 	for (type = 0; type < OCFS2_MAXQUOTAS; type++) {
 		if (list_empty(&(rec->r_list[type])))
 			continue;
@@ -674,7 +674,7 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
 			break;
 	}
 out:
-	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
+	up_read(&sb->s_umount);
 	kfree(rec);
 	return status;
 }
@@ -840,7 +840,10 @@ static int ocfs2_local_free_info(struct super_block *sb, int type)
 	}
 	ocfs2_release_local_quota_bitmaps(&oinfo->dqi_chunk);
 
-	/* dqonoff_mutex protects us against racing with recovery thread... */
+	/*
+	 * s_umount held in exclusive mode protects us against racing with
+	 * recovery thread...
+	 */
 	if (oinfo->dqi_rec) {
 		ocfs2_free_quota_recovery(oinfo->dqi_rec);
 		mark_clean = 0;
-- 
2.6.6
