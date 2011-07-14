From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 14 Jul 2011 15:50:25 -0700
Subject: [Ocfs2-devel] [PATCH 14/16] ocfs2: Clean up messages in the fs
In-Reply-To: <1310683827-19157-1-git-send-email-sunil.mushran@oracle.com>
References: <1310683827-19157-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1310683827-19157-15-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Convert useful messages from ML_NOTICE to KERN_NOTICE to improve readability.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/journal.c     |    9 ++++++---
 fs/ocfs2/quota_local.c |   13 +++++++++----
 fs/ocfs2/slot_map.c    |    4 ++--
 fs/ocfs2/super.c       |   10 +++++-----
 4 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 295d564..8eaaa78 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1544,9 +1544,9 @@ static int ocfs2_replay_journal(struct ocfs2_super *osb,
 	/* we need to run complete recovery for offline orphan slots */
 	ocfs2_replay_map_set_state(osb, REPLAY_NEEDED);
 
-	mlog(ML_NOTICE, "Recovering node %d from slot %d on device (%u,%u)\n",
-	     node_num, slot_num,
-	     MAJOR(osb->sb->s_dev), MINOR(osb->sb->s_dev));
+	printk(KERN_NOTICE "ocfs2: Begin replay journal (node %d, slot %d) on "\
+	       "device (%u,%u)\n", node_num, slot_num, MAJOR(osb->sb->s_dev),
+	       MINOR(osb->sb->s_dev));
 
 	OCFS2_I(inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
 
@@ -1601,6 +1601,9 @@ static int ocfs2_replay_journal(struct ocfs2_super *osb,
 
 	jbd2_journal_destroy(journal);
 
+	printk(KERN_NOTICE "ocfs2: End replay journal (node %d, slot %d) on "\
+	       "device (%u,%u)\n", node_num, slot_num, MAJOR(osb->sb->s_dev),
+	       MINOR(osb->sb->s_dev));
 done:
 	/* drop the lock on this nodes journal */
 	if (got_lock)
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index dc8007f..942fd65 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -404,7 +404,9 @@ struct ocfs2_quota_recovery *ocfs2_begin_quota_recovery(
 	int status = 0;
 	struct ocfs2_quota_recovery *rec;
 
-	mlog(ML_NOTICE, "Beginning quota recovery in slot %u\n", slot_num);
+	printk(KERN_NOTICE "ocfs2: Beginning quota recovery on device (%s) for "
+	       "slot %u\n", osb->dev_str, slot_num);
+
 	rec = ocfs2_alloc_quota_recovery();
 	if (!rec)
 		return ERR_PTR(-ENOMEM);
@@ -596,7 +598,9 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
 	struct inode *lqinode;
 	unsigned int flags;
 
-	mlog(ML_NOTICE, "Finishing quota recovery in slot %u\n", slot_num);
+	printk(KERN_NOTICE "ocfs2: Finishing quota recovery on device (%s) for "
+	       "slot %u\n", osb->dev_str, slot_num);
+
 	mutex_lock(&sb_dqopt(sb)->dqonoff_mutex);
 	for (type = 0; type < MAXQUOTAS; type++) {
 		if (list_empty(&(rec->r_list[type])))
@@ -612,8 +616,9 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
 		/* Someone else is holding the lock? Then he must be
 		 * doing the recovery. Just skip the file... */
 		if (status == -EAGAIN) {
-			mlog(ML_NOTICE, "skipping quota recovery for slot %d "
-			     "because quota file is locked.\n", slot_num);
+			printk(KERN_NOTICE "ocfs2: Skipping quota recovery on "
+			       "device (%s) for slot %d because quota file is "
+			       "locked.\n", osb->dev_str, slot_num);
 			status = 0;
 			goto out_put;
 		} else if (status < 0) {
diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index 26fc001..1424c15 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -493,8 +493,8 @@ int ocfs2_find_slot(struct ocfs2_super *osb)
 			goto bail;
 		}
 	} else
-		mlog(ML_NOTICE, "slot %d is already allocated to this node!\n",
-		     slot);
+		printk(KERN_INFO "ocfs2: Slot %d on device (%s) was already "
+		       "allocated to this node!\n", slot, osb->dev_str);
 
 	ocfs2_set_slot(si, slot, osb->node_num);
 	osb->slot_num = slot;
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index cdbaf5e..41b4b23 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1107,9 +1107,9 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 		ocfs2_set_ro_flag(osb, 1);
 
-		printk(KERN_NOTICE "Readonly device detected. No cluster "
-		       "services will be utilized for this mount. Recovery "
-		       "will be skipped.\n");
+		printk(KERN_NOTICE "ocfs2: Readonly device (%s) detected. "
+		       "Cluster services will not be used for this mount. "
+		       "Recovery will be skipped.\n", osb->dev_str);
 	}
 
 	if (!ocfs2_is_hard_readonly(osb)) {
@@ -2462,8 +2462,8 @@ static int ocfs2_check_volume(struct ocfs2_super *osb)
 			goto finally;
 		}
 	} else {
-		mlog(ML_NOTICE, "File system was not unmounted cleanly, "
-		     "recovering volume.\n");
+		printk(KERN_NOTICE "ocfs2: File system on device (%s) was not "
+		       "unmounted cleanly, recovering it.\n", osb->dev_str);
 	}
 
 	local = ocfs2_mount_local(osb);
-- 
1.7.4.1
