From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon,  7 Jul 2008 13:26:19 -0700
Subject: [Ocfs2-devel] [PATCH 3/4] ocfs2: Fixes tiny race between mount and
	recovery
In-Reply-To: <1215462380-12975-1-git-send-email-sunil.mushran@oracle.com>
References: <1215462380-12975-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1215462380-12975-4-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch fixes a tiny race between recovery and mount that could otherwise
lead to a hang.

During mount, the node takes an EX on the superblock and the journal/slot locks,
and, if needed, recovers the slot it is assigned. However, it only marks the
other dirty slots and leaves their recovery to the recovery thread that does so
after the mount process has completed.

The last step of the mount process calls for it to drop the EX on the superblock
lock. The node holds onto the same lock level on its journal/slot lock.

The recovery thread then picks up the EX on the superblock lock and then takes
the same lock for the journal/slot it is recovering.

This exposes a tiny race as another node mounting the volume could race the
recovery thread for the EX on the superblock lock.

If that happens, that node could be assigned a dirty slot which it would recover.
It too will then drop the EX on the superblock lock but hold onto the same
lock level on its journal/slot lock.

Now when the recovery thread on the first node gets back the EX on the superblock
lock, it will promptly attempt to get the EX on the journal/slot lock of the node
it thinks is dirty but since has not only been recovered but also locked by
another node.

Hang.

The fix here is to make the journal/slot EX lock request during recovery a trylock
operation. If the trylock fails, it would indicate that that slot is in use and
thus recovered.

This bug appears to have been inadvertently introduced during the mount/umount
vote removal by mainline commit 34d024f84345807bf44163fac84e921513dde323. In the
older voting scheme, the voting thread would remove the node being mounted from
the recovery map.

Mark Fasheh <mfasheh@suse.com> wrote the initial draft of this patch fix.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/journal.c |   80 +++++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 64 insertions(+), 16 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index c39eb12..3b14d1f 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -28,6 +28,7 @@
 #include <linux/slab.h>
 #include <linux/highmem.h>
 #include <linux/kthread.h>
+#include <linux/delay.h>
 
 #define MLOG_MASK_PREFIX ML_JOURNAL
 #include <cluster/masklog.h>
@@ -70,9 +71,14 @@ static int ocfs2_commit_thread(void *arg);
  * It is protected by the recovery_lock.
  */
 
+struct ocfs2_recovery_item {
+	unsigned int ri_node_num;
+	unsigned int ri_count;
+};
+
 struct ocfs2_recovery_map {
 	int rm_used;
-	unsigned int *rm_entries;
+	struct ocfs2_recovery_item *rm_entries;
 };
 
 int ocfs2_recovery_init(struct ocfs2_super *osb)
@@ -85,15 +91,15 @@ int ocfs2_recovery_init(struct ocfs2_super *osb)
 	init_waitqueue_head(&osb->recovery_event);
 
 	rm = kzalloc(sizeof(struct ocfs2_recovery_map) +
-		     osb->max_slots * sizeof(unsigned int),
+		     osb->max_slots * sizeof(struct ocfs2_recovery_item),
 		     GFP_KERNEL);
 	if (!rm) {
 		mlog_errno(-ENOMEM);
 		return -ENOMEM;
 	}
 
-	rm->rm_entries = (unsigned int *)((char *)rm +
-					  sizeof(struct ocfs2_recovery_map));
+	rm->rm_entries = (struct ocfs2_recovery_item *)
+			((char *)rm + sizeof(struct ocfs2_recovery_map));
 	osb->recovery_map = rm;
 
 	return 0;
@@ -143,7 +149,7 @@ static int __ocfs2_recovery_map_test(struct ocfs2_super *osb,
 	assert_spin_locked(&osb->osb_lock);
 
 	for (i = 0; i < rm->rm_used; i++) {
-		if (rm->rm_entries[i] == node_num)
+		if (rm->rm_entries[i].ri_node_num == node_num)
 			return 1;
 	}
 
@@ -155,6 +161,7 @@ static int ocfs2_recovery_map_set(struct ocfs2_super *osb,
 				  unsigned int node_num)
 {
 	struct ocfs2_recovery_map *rm = osb->recovery_map;
+	int i;
 
 	spin_lock(&osb->osb_lock);
 	if (__ocfs2_recovery_map_test(osb, node_num)) {
@@ -165,8 +172,17 @@ static int ocfs2_recovery_map_set(struct ocfs2_super *osb,
 	/* XXX: Can this be exploited? Not from o2dlm... */
 	BUG_ON(rm->rm_used >= osb->max_slots);
 
-	rm->rm_entries[rm->rm_used] = node_num;
+	for (i = 0; i < rm->rm_used; i++) {
+		if (rm->rm_entries[i].ri_node_num == node_num) {
+			rm->rm_entries[i].ri_count++;
+			goto out;
+		}
+	}
+
+	rm->rm_entries[rm->rm_used].ri_node_num = node_num;
+	rm->rm_entries[rm->rm_used].ri_count = 1;
 	rm->rm_used++;
+out:
 	spin_unlock(&osb->osb_lock);
 
 	return 0;
@@ -181,17 +197,21 @@ static void ocfs2_recovery_map_clear(struct ocfs2_super *osb,
 	spin_lock(&osb->osb_lock);
 
 	for (i = 0; i < rm->rm_used; i++) {
-		if (rm->rm_entries[i] == node_num)
+		if (rm->rm_entries[i].ri_node_num == node_num) {
+			rm->rm_entries[i].ri_count--;
+			if (rm->rm_entries[i].ri_count)
+				goto out;
 			break;
+		}
 	}
 
 	if (i < rm->rm_used) {
 		/* XXX: be careful with the pointer math */
 		memmove(&(rm->rm_entries[i]), &(rm->rm_entries[i + 1]),
-			(rm->rm_used - i - 1) * sizeof(unsigned int));
+			(rm->rm_used - i - 1) * sizeof(struct ocfs2_recovery_item));
 		rm->rm_used--;
 	}
-
+out:
 	spin_unlock(&osb->osb_lock);
 }
 
@@ -1020,7 +1040,7 @@ restart:
 	while (rm->rm_used) {
 		/* It's always safe to remove entry zero, as we won't
 		 * clear it until ocfs2_recover_node() has succeeded. */
-		node_num = rm->rm_entries[0];
+		node_num = rm->rm_entries[0].ri_node_num;
 		spin_unlock(&osb->osb_lock);
 
 		status = ocfs2_recover_node(osb, node_num);
@@ -1105,7 +1125,8 @@ out:
  * clean. Will only replay if the journal inode is marked dirty. */
 static int ocfs2_replay_journal(struct ocfs2_super *osb,
 				int node_num,
-				int slot_num)
+				int slot_num,
+				int *busy)
 {
 	int status;
 	int got_lock = 0;
@@ -1115,6 +1136,8 @@ static int ocfs2_replay_journal(struct ocfs2_super *osb,
 	journal_t *journal = NULL;
 	struct buffer_head *bh = NULL;
 
+	*busy = 0;
+
 	inode = ocfs2_get_system_file_inode(osb, JOURNAL_SYSTEM_INODE,
 					    slot_num);
 	if (inode == NULL) {
@@ -1131,8 +1154,23 @@ static int ocfs2_replay_journal(struct ocfs2_super *osb,
 	}
 	SET_INODE_JOURNAL(inode);
 
-	status = ocfs2_inode_lock_full(inode, &bh, 1, OCFS2_META_LOCK_RECOVERY);
+	status = ocfs2_inode_lock_full(inode, &bh, 1,
+		       OCFS2_META_LOCK_RECOVERY|OCFS2_META_LOCK_NOQUEUE);
 	if (status < 0) {
+		/*
+		 * As fs recovery is asynchronous, there is a small possibility
+		 * that the slot being recovered has been assigned to another
+		 * node that happened to be mounting the volume@that same
+		 * time. If so, the journal replay will be handled by that node.
+		 * A failed trylock on the journal indicates that the slot has
+		 * been assigned to another node.
+		 */
+		if (status == -EAGAIN) {
+			*busy = 1;
+			status = 0;
+			goto done;
+		}
+
 		mlog(0, "status returned from ocfs2_inode_lock=%d\n", status);
 		if (status != -ERESTARTSYS)
 			mlog(ML_ERROR, "Could not lock journal!\n");
@@ -1232,7 +1270,7 @@ done:
 static int ocfs2_recover_node(struct ocfs2_super *osb,
 			      int node_num)
 {
-	int status = 0;
+	int status = 0, busy = 0;
 	int slot_num;
 	struct ocfs2_slot_info *si = osb->slot_info;
 	struct ocfs2_dinode *la_copy = NULL;
@@ -1256,11 +1294,16 @@ static int ocfs2_recover_node(struct ocfs2_super *osb,
 
 	mlog(0, "node %d was using slot %d\n", node_num, slot_num);
 
-	status = ocfs2_replay_journal(osb, node_num, slot_num);
+	status = ocfs2_replay_journal(osb, node_num, slot_num, &busy);
 	if (status < 0) {
 		mlog_errno(status);
 		goto done;
 	}
+	if (busy) {
+		mlog(0, "Skipping recovery for slot %u (node %u) "
+		     "as another node has recovered it\n", slot_num, node_num);
+		goto done;
+	}
 
 	/* Stamp a clean local alloc file AFTER recovering the journal... */
 	status = ocfs2_begin_local_alloc_recovery(osb, slot_num, &la_copy);
@@ -1339,7 +1382,7 @@ bail:
  * slot info struct has been updated from disk. */
 int ocfs2_mark_dead_nodes(struct ocfs2_super *osb)
 {
-	int status, i, node_num;
+	int status, i, node_num, inreco;
 	struct ocfs2_slot_info *si = osb->slot_info;
 
 	/* This is called with the super block cluster lock, so we
@@ -1353,8 +1396,13 @@ int ocfs2_mark_dead_nodes(struct ocfs2_super *osb)
 			continue;
 
 		node_num = si->si_global_node_nums[i];
-		if (__ocfs2_recovery_map_test(osb, node_num))
+
+		spin_lock(&osb->osb_lock);
+		inreco = __ocfs2_recovery_map_test(osb, node_num);
+		spin_unlock(&osb->osb_lock);
+		if (inreco)
 			continue;
+
 		spin_unlock(&si->si_lock);
 
 		/* Ok, we have a slot occupied by another node which
-- 
1.5.4.3
