From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 19 Aug 2008 17:22:15 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix sleep-with-spinlock recovery
	regression
Message-ID: <20080820002215.GE8070@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This fixes a bug introduced with 539d8264093560b917ee3afe4c7f74e5da09d6a5:
    [PATCH 2/2] ocfs2: Fix race between mount and recovery

ocfs2_mark_dead_nodes() was reading journal inodes while holding the
spinlock protecting our in-memory recovery state. The fix is very simple -
the disk state is protected by a cluster lock that's already held, so we
just move the spinlock down past the read.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/journal.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 7a37240..20f3675 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1418,13 +1418,13 @@ int ocfs2_mark_dead_nodes(struct ocfs2_super *osb)
 {
 	unsigned int node_num;
 	int status, i;
+	u32 gen;
 	struct buffer_head *bh = NULL;
 	struct ocfs2_dinode *di;
 
 	/* This is called with the super block cluster lock, so we
 	 * know that the slot map can't change underneath us. */
 
-	spin_lock(&osb->osb_lock);
 	for (i = 0; i < osb->max_slots; i++) {
 		/* Read journal inode to get the recovery generation */
 		status = ocfs2_read_journal_inode(osb, i, &bh, NULL);
@@ -1433,23 +1433,31 @@ int ocfs2_mark_dead_nodes(struct ocfs2_super *osb)
 			goto bail;
 		}
 		di = (struct ocfs2_dinode *)bh->b_data;
-		osb->slot_recovery_generations[i] =
-					ocfs2_get_recovery_generation(di);
+		gen = ocfs2_get_recovery_generation(di);
 		brelse(bh);
 		bh = NULL;
 
+		spin_lock(&osb->osb_lock);
+		osb->slot_recovery_generations[i] = gen;
+
 		mlog(0, "Slot %u recovery generation is %u\n", i,
 		     osb->slot_recovery_generations[i]);
 
-		if (i == osb->slot_num)
+		if (i == osb->slot_num) {
+			spin_unlock(&osb->osb_lock);
 			continue;
+		}
 
 		status = ocfs2_slot_to_node_num_locked(osb, i, &node_num);
-		if (status == -ENOENT)
+		if (status == -ENOENT) {
+			spin_unlock(&osb->osb_lock);
 			continue;
+		}
 
-		if (__ocfs2_recovery_map_test(osb, node_num))
+		if (__ocfs2_recovery_map_test(osb, node_num)) {
+			spin_unlock(&osb->osb_lock);
 			continue;
+		}
 		spin_unlock(&osb->osb_lock);
 
 		/* Ok, we have a slot occupied by another node which
-- 
1.5.4.1
