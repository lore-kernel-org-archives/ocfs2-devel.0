From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 14 Jul 2008 13:12:38 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Fix race between mount and recovery
In-Reply-To: <1216066358-12090-1-git-send-email-sunil.mushran@oracle.com>
References: <1216066358-12090-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1216066358-12090-3-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

As the fs recovery is asynchronous, there is a small chance that another
node can mount (and thus recover) the slot before the recovery thread
gets to it.

If this happens, the recovery thread will block indefinitely on the
journal/slot lock as that lock will be held for the duration of the mount
(by design) by the node assigned to that slot.

The solution implemented is to keep track of the journal replays using
a recovery generation in the journal inode, which will be incremented by the
thread replaying that journal. The recovery thread, before attempting the
blocking lock on the journal/slot lock, will compare the generation on disk
with what it has cached and skip recovery if it does not match.

This bug appears to have been inadvertently introduced during the mount/umount
vote removal by mainline commit 34d024f84345807bf44163fac84e921513dde323. In the
mount voting scheme, the messaging would indirectly indicate that the slot
was being recovered.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/journal.c |  173 ++++++++++++++++++++++++++++++++++++++++------------
 fs/ocfs2/journal.h |    3 +-
 fs/ocfs2/ocfs2.h   |    2 +
 fs/ocfs2/super.c   |   12 +++-
 4 files changed, 148 insertions(+), 42 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 741a4e2..1e078d8 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -57,7 +57,7 @@ static int __ocfs2_recovery_thread(void *arg);
 static int ocfs2_commit_cache(struct ocfs2_super *osb);
 static int ocfs2_wait_on_mount(struct ocfs2_super *osb);
 static int ocfs2_journal_toggle_dirty(struct ocfs2_super *osb,
-				      int dirty);
+				      int dirty, int replayed);
 static int ocfs2_trylock_journal(struct ocfs2_super *osb,
 				 int slot_num);
 static int ocfs2_recover_orphans(struct ocfs2_super *osb,
@@ -436,8 +436,18 @@ done:
 	return status;
 }
 
+static void ocfs2_bump_recovery_generation(struct ocfs2_dinode *di)
+{
+	le32_add_cpu(&(di->id1.journal1.ij_recovery_generation), 1);
+}
+
+static u32 ocfs2_get_recovery_generation(struct ocfs2_dinode *di)
+{
+	return le32_to_cpu(di->id1.journal1.ij_recovery_generation);
+}
+
 static int ocfs2_journal_toggle_dirty(struct ocfs2_super *osb,
-				      int dirty)
+				      int dirty, int replayed)
 {
 	int status;
 	unsigned int flags;
@@ -467,6 +477,9 @@ static int ocfs2_journal_toggle_dirty(struct ocfs2_super *osb,
 		flags &= ~OCFS2_JOURNAL_DIRTY_FL;
 	fe->id1.journal1.ij_flags = cpu_to_le32(flags);
 
+	if (replayed)
+		ocfs2_bump_recovery_generation(fe);
+
 	status = ocfs2_write_block(osb, bh, journal->j_inode);
 	if (status < 0)
 		mlog_errno(status);
@@ -541,7 +554,7 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
 		 * Do not toggle if flush was unsuccessful otherwise
 		 * will leave dirty metadata in a "clean" journal
 		 */
-		status = ocfs2_journal_toggle_dirty(osb, 0);
+		status = ocfs2_journal_toggle_dirty(osb, 0, 0);
 		if (status < 0)
 			mlog_errno(status);
 	}
@@ -584,7 +597,7 @@ static void ocfs2_clear_journal_error(struct super_block *sb,
 	}
 }
 
-int ocfs2_journal_load(struct ocfs2_journal *journal, int local)
+int ocfs2_journal_load(struct ocfs2_journal *journal, int local, int replayed)
 {
 	int status = 0;
 	struct ocfs2_super *osb;
@@ -603,7 +616,7 @@ int ocfs2_journal_load(struct ocfs2_journal *journal, int local)
 
 	ocfs2_clear_journal_error(osb->sb, journal->j_journal, osb->slot_num);
 
-	status = ocfs2_journal_toggle_dirty(osb, 1);
+	status = ocfs2_journal_toggle_dirty(osb, 1, replayed);
 	if (status < 0) {
 		mlog_errno(status);
 		goto done;
@@ -645,7 +658,7 @@ int ocfs2_journal_wipe(struct ocfs2_journal *journal, int full)
 		goto bail;
 	}
 
-	status = ocfs2_journal_toggle_dirty(journal->j_osb, 0);
+	status = ocfs2_journal_toggle_dirty(journal->j_osb, 0, 0);
 	if (status < 0)
 		mlog_errno(status);
 
@@ -887,6 +900,13 @@ restart:
 
 		ocfs2_recovery_map_clear(osb, node_num);
 	}
+
+	/* Refresh all journal recovery generations from disk */
+	status = ocfs2_check_journals_nolocks(osb);
+	status = (status == -EROFS) ? 0 : status;
+	if (status < 0)
+		mlog_errno(status);
+
 	ocfs2_super_unlock(osb, 1);
 
 	/* We always run recovery on our own orphan dir - the dead
@@ -950,6 +970,42 @@ out:
 	mlog_exit_void();
 }
 
+static int ocfs2_read_journal_inode(struct ocfs2_super *osb,
+				    int slot_num,
+				    struct buffer_head **bh,
+				    struct inode **ret_inode)
+{
+	int status = -EACCES;
+	struct inode *inode = NULL;
+
+	BUG_ON(slot_num >= osb->max_slots);
+
+	inode = ocfs2_get_system_file_inode(osb, JOURNAL_SYSTEM_INODE,
+					    slot_num);
+	if (!inode || is_bad_inode(inode)) {
+		mlog_errno(status);
+		goto bail;
+	}
+	SET_INODE_JOURNAL(inode);
+
+	status = ocfs2_read_block(osb, OCFS2_I(inode)->ip_blkno, bh, 0, inode);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail;
+	}
+
+	status = 0;
+
+bail:
+	if (inode) {
+		if (status || !ret_inode)
+			iput(inode);
+		else
+			*ret_inode = inode;
+	}
+	return status;
+}
+
 /* Does the actual journal replay and marks the journal inode as
  * clean. Will only replay if the journal inode is marked dirty. */
 static int ocfs2_replay_journal(struct ocfs2_super *osb,
@@ -963,22 +1019,35 @@ static int ocfs2_replay_journal(struct ocfs2_super *osb,
 	struct ocfs2_dinode *fe;
 	journal_t *journal = NULL;
 	struct buffer_head *bh = NULL;
+	u32 slot_reco_gen;
 
-	inode = ocfs2_get_system_file_inode(osb, JOURNAL_SYSTEM_INODE,
-					    slot_num);
-	if (inode == NULL) {
-		status = -EACCES;
+	status = ocfs2_read_journal_inode(osb, slot_num, &bh, &inode);
+	if (status) {
 		mlog_errno(status);
 		goto done;
 	}
-	if (is_bad_inode(inode)) {
-		status = -EACCES;
-		iput(inode);
-		inode = NULL;
-		mlog_errno(status);
+
+	fe = (struct ocfs2_dinode *)bh->b_data;
+	slot_reco_gen = ocfs2_get_recovery_generation(fe);
+	brelse(bh);
+	bh = NULL;
+
+	/*
+	 * As the fs recovery is asynchronous, there is a small chance that another
+	 * node mounted (and recovered) the slot before the recovery thread could
+	 * get the lock. To handle that, we dirty read the journal inode for that
+	 * slot to get the recovery generation. If it is different than what we
+	 * expected, the slot has been recovered. If not, it needs recovery.
+	 */
+	if (osb->slot_recovery_generation[slot_num] != slot_reco_gen) {
+		mlog(0, "Slot %u already recovered (old/new=%u/%u)\n", slot_num,
+		     osb->slot_recovery_generation[slot_num], slot_reco_gen);
+		osb->slot_recovery_generation[slot_num] = slot_reco_gen;
+		status = -EBUSY;
 		goto done;
 	}
-	SET_INODE_JOURNAL(inode);
+
+	/* Continue with recovery as the journal has not yet been recovered */
 
 	status = ocfs2_inode_lock_full(inode, &bh, 1, OCFS2_META_LOCK_RECOVERY);
 	if (status < 0) {
@@ -992,9 +1061,12 @@ static int ocfs2_replay_journal(struct ocfs2_super *osb,
 	fe = (struct ocfs2_dinode *) bh->b_data;
 
 	flags = le32_to_cpu(fe->id1.journal1.ij_flags);
+	slot_reco_gen = ocfs2_get_recovery_generation(fe);
 
 	if (!(flags & OCFS2_JOURNAL_DIRTY_FL)) {
 		mlog(0, "No recovery required for node %d\n", node_num);
+		/* Refresh recovery generation for the slot */
+		osb->slot_recovery_generation[slot_num] = slot_reco_gen;
 		goto done;
 	}
 
@@ -1042,6 +1114,11 @@ static int ocfs2_replay_journal(struct ocfs2_super *osb,
 	flags &= ~OCFS2_JOURNAL_DIRTY_FL;
 	fe->id1.journal1.ij_flags = cpu_to_le32(flags);
 
+	/* Increment recovery generation to indicate successful recovery */
+	ocfs2_bump_recovery_generation(fe);
+	osb->slot_recovery_generation[slot_num] =
+					ocfs2_get_recovery_generation(fe);
+
 	status = ocfs2_write_block(osb, bh, inode);
 	if (status < 0)
 		mlog_errno(status);
@@ -1107,6 +1184,13 @@ static int ocfs2_recover_node(struct ocfs2_super *osb,
 
 	status = ocfs2_replay_journal(osb, node_num, slot_num);
 	if (status < 0) {
+		if (status == -EBUSY) {
+			mlog(0, "Skipping recovery for slot %u (node %u) "
+			     "as another node has recovered it\n", slot_num,
+			     node_num);
+			status = 0;
+			goto done;
+		}
 		mlog_errno(status);
 		goto done;
 	}
@@ -1190,12 +1274,29 @@ int ocfs2_mark_dead_nodes(struct ocfs2_super *osb)
 {
 	int status, i, node_num;
 	struct ocfs2_slot_info *si = osb->slot_info;
+	struct buffer_head *bh = NULL;
+	struct ocfs2_dinode *di;
 
 	/* This is called with the super block cluster lock, so we
 	 * know that the slot map can't change underneath us. */
 
 	spin_lock(&si->si_lock);
 	for(i = 0; i < si->si_num_slots; i++) {
+		/* Read journal inode to get the recovery generation */
+		status = ocfs2_read_journal_inode(osb, i, &bh, NULL);
+		if (status) {
+			mlog_errno(status);
+			goto bail;
+		}
+		di = (struct ocfs2_dinode *)bh->b_data;
+		osb->slot_recovery_generation[i] =
+					ocfs2_get_recovery_generation(di);
+		brelse(bh);
+		bh = NULL;
+
+		mlog(0, "Slot %u recovery generation is %u\n", i,
+		     osb->slot_recovery_generation[i]);
+
 		if (i == osb->slot_num)
 			continue;
 		if (ocfs2_is_empty_slot(si, i))
@@ -1464,49 +1565,41 @@ static int ocfs2_commit_thread(void *arg)
 	return 0;
 }
 
-/* Look for a dirty journal without taking any cluster locks. Used for
- * hard readonly access to determine whether the file system journals
- * require recovery. */
+/* Reads all the journal inodes without taking any cluster locks. Used
+ * for hard readonly access to determine whether any journal requires
+ * recovery. Also used to refresh the recovery generation numbers after
+ * a journal has been recovered by another node.
+ */
 int ocfs2_check_journals_nolocks(struct ocfs2_super *osb)
 {
 	int ret = 0;
 	unsigned int slot;
-	struct buffer_head *di_bh;
+	struct buffer_head *di_bh = NULL;
 	struct ocfs2_dinode *di;
-	struct inode *journal = NULL;
+	int journal_dirty = 0;
 
 	for(slot = 0; slot < osb->max_slots; slot++) {
-		journal = ocfs2_get_system_file_inode(osb,
-						      JOURNAL_SYSTEM_INODE,
-						      slot);
-		if (!journal || is_bad_inode(journal)) {
-			ret = -EACCES;
-			mlog_errno(ret);
-			goto out;
-		}
-
-		di_bh = NULL;
-		ret = ocfs2_read_block(osb, OCFS2_I(journal)->ip_blkno, &di_bh,
-				       0, journal);
-		if (ret < 0) {
+		ret = ocfs2_read_journal_inode(osb, slot, &di_bh, NULL);
+		if (ret) {
 			mlog_errno(ret);
 			goto out;
 		}
 
 		di = (struct ocfs2_dinode *) di_bh->b_data;
 
+		osb->slot_recovery_generation[slot] =
+					ocfs2_get_recovery_generation(di);
+
 		if (le32_to_cpu(di->id1.journal1.ij_flags) &
 		    OCFS2_JOURNAL_DIRTY_FL)
-			ret = -EROFS;
+			journal_dirty = 1;
 
 		brelse(di_bh);
-		if (ret)
-			break;
+		di_bh = NULL;
 	}
 
 out:
-	if (journal)
-		iput(journal);
-
+	if (journal_dirty)
+		ret = -EROFS;
 	return ret;
 }
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 52f02fe..dc27100 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -157,7 +157,8 @@ int    ocfs2_journal_init(struct ocfs2_journal *journal,
 void   ocfs2_journal_shutdown(struct ocfs2_super *osb);
 int    ocfs2_journal_wipe(struct ocfs2_journal *journal,
 			  int full);
-int    ocfs2_journal_load(struct ocfs2_journal *journal, int local);
+int    ocfs2_journal_load(struct ocfs2_journal *journal, int local,
+			  int replayed);
 int    ocfs2_check_journals_nolocks(struct ocfs2_super *osb);
 void   ocfs2_recovery_thread(struct ocfs2_super *osb,
 			     int node_num);
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 9546470..db52558 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -193,6 +193,8 @@ struct ocfs2_super
 
 	struct ocfs2_slot_info *slot_info;
 
+	u32 *slot_recovery_generation;
+
 	spinlock_t node_map_lock;
 	struct ocfs2_node_map recovery_map;
 
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index ff31722..da92242 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1497,6 +1497,15 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	}
 	mlog(0, "max_slots for this device: %u\n", osb->max_slots);
 
+	osb->slot_recovery_generation = kcalloc(osb->max_slots,
+					sizeof(*osb->slot_recovery_generation),
+					GFP_KERNEL);
+	if (!osb->slot_recovery_generation) {
+		status = -ENOMEM;
+		mlog_errno(status);
+		goto bail;
+	}
+
 	init_waitqueue_head(&osb->osb_wipe_event);
 	osb->osb_orphan_wipes = kcalloc(osb->max_slots,
 					sizeof(*osb->osb_orphan_wipes),
@@ -1739,7 +1748,7 @@ static int ocfs2_check_volume(struct ocfs2_super *osb)
 	local = ocfs2_mount_local(osb);
 
 	/* will play back anything left in the journal. */
-	ocfs2_journal_load(osb->journal, local);
+	ocfs2_journal_load(osb->journal, local, dirty);
 
 	if (dirty) {
 		/* recover my local alloc if we didn't unmount cleanly. */
@@ -1801,6 +1810,7 @@ static void ocfs2_delete_osb(struct ocfs2_super *osb)
 		ocfs2_free_slot_info(osb->slot_info);
 
 	kfree(osb->osb_orphan_wipes);
+	kfree(osb->slot_recovery_generation);
 	/* FIXME
 	 * This belongs in journal shutdown, but because we have to
 	 * allocate osb->journal at the start of ocfs2_initalize_osb(),
-- 
1.5.4.3
