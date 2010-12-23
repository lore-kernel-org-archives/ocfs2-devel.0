From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Dec 2010 15:31:13 +0800
Subject: [Ocfs2-devel] [PATCH 30/34] ocfs2: Remove masklog ML_JOURNAL.
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <1293089477-5019-30-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <boyu.mt@taobao.com>

Remove mlog(0) from fs/ocfs2/journal.c and the masklog JOURNAL.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ocfs2/cluster/masklog.c |    1 -
 fs/ocfs2/cluster/masklog.h |    1 -
 fs/ocfs2/journal.c         |  130 ++++++++++--------------
 fs/ocfs2/ocfs2_trace.h     |  241 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 295 insertions(+), 78 deletions(-)

diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index a229ede..3f1e995 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -92,7 +92,6 @@ static struct mlog_attribute mlog_attrs[MLOG_MAX_BITS] = {
 	define_mask(DLM_MASTER),
 	define_mask(DLM_RECOVERY),
 	define_mask(AIO),
-	define_mask(JOURNAL),
 	define_mask(DLM_GLUE),
 	define_mask(BH_IO),
 	define_mask(UPTODATE),
diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index 5d358c1..61e8f6c 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -94,7 +94,6 @@
 #define ML_DLM_MASTER	0x0000000000000800ULL /* dlm master functions */
 #define ML_DLM_RECOVERY	0x0000000000001000ULL /* dlm master functions */
 #define ML_AIO		0x0000000000002000ULL /* ocfs2 aio read and write */
-#define ML_JOURNAL	0x0000000000004000ULL /* ocfs2 journalling functions */
 #define ML_DLM_GLUE	0x0000000000080000ULL /* ocfs2 dlm glue layer */
 #define ML_BH_IO	0x0000000000100000ULL /* ocfs2 buffer I/O */
 #define ML_UPTODATE	0x0000000000200000ULL /* ocfs2 caching sequence #'s */
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 9565091..5d3c077 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -31,7 +31,6 @@
 #include <linux/time.h>
 #include <linux/random.h>
 
-#define MLOG_MASK_PREFIX ML_JOURNAL
 #include <cluster/masklog.h>
 
 #include "ocfs2.h"
@@ -52,6 +51,7 @@
 #include "quota.h"
 
 #include "buffer_head_io.h"
+#include "ocfs2_trace.h"
 
 DEFINE_SPINLOCK(trans_inc_lock);
 
@@ -308,9 +308,10 @@ static int ocfs2_commit_cache(struct ocfs2_super *osb)
 	/* Flush all pending commits and checkpoint the journal. */
 	down_write(&journal->j_trans_barrier);
 
-	if (atomic_read(&journal->j_num_trans) == 0) {
+	flushed = atomic_read(&journal->j_num_trans);
+	trace_ocfs2_commit_cache_begin(flushed);
+	if (flushed == 0) {
 		up_write(&journal->j_trans_barrier);
-		mlog(0, "No transactions for me to flush!\n");
 		goto finally;
 	}
 
@@ -329,8 +330,7 @@ static int ocfs2_commit_cache(struct ocfs2_super *osb)
 	atomic_set(&journal->j_num_trans, 0);
 	up_write(&journal->j_trans_barrier);
 
-	mlog(0, "commit_thread: flushed transaction %lu (%u handles)\n",
-	     journal->j_trans_id, flushed);
+	trace_ocfs2_commit_cache_end(journal->j_trans_id, flushed);
 
 	ocfs2_wake_downconvert_thread(osb);
 	wake_up(&journal->j_checkpointed);
@@ -423,7 +423,7 @@ int ocfs2_extend_trans(handle_t *handle, int nblocks)
 
 	old_nblocks = handle->h_buffer_credits;
 
-	mlog(0, "Trying to extend transaction by %d blocks\n", nblocks);
+	trace_ocfs2_extend_trans(old_nblocks, nblocks);
 
 #ifdef CONFIG_OCFS2_DEBUG_FS
 	status = 1;
@@ -436,9 +436,7 @@ int ocfs2_extend_trans(handle_t *handle, int nblocks)
 #endif
 
 	if (status > 0) {
-		mlog(0,
-		     "jbd2_journal_extend failed, trying "
-		     "jbd2_journal_restart\n");
+		trace_ocfs2_extend_trans_restart(old_nblocks + nblocks);
 		status = jbd2_journal_restart(handle,
 					      old_nblocks + nblocks);
 		if (status < 0) {
@@ -616,12 +614,9 @@ static int __ocfs2_journal_access(handle_t *handle,
 	BUG_ON(!handle);
 	BUG_ON(!bh);
 
-	mlog(0, "bh->b_blocknr=%llu, type=%d (\"%s\"), bh->b_size = %zu\n",
-	     (unsigned long long)bh->b_blocknr, type,
-	     (type == OCFS2_JOURNAL_ACCESS_CREATE) ?
-	     "OCFS2_JOURNAL_ACCESS_CREATE" :
-	     "OCFS2_JOURNAL_ACCESS_WRITE",
-	     bh->b_size);
+	trace_ocfs2_journal_access(
+		(unsigned long long)ocfs2_metadata_cache_owner(ci),
+		(unsigned long long)bh->b_blocknr, type, bh->b_size);
 
 	/* we can safely remove this assertion after testing. */
 	if (!buffer_uptodate(bh)) {
@@ -730,8 +725,7 @@ void ocfs2_journal_dirty(handle_t *handle, struct buffer_head *bh)
 {
 	int status;
 
-	mlog(0, "(bh->b_blocknr=%llu)\n",
-	     (unsigned long long)bh->b_blocknr);
+	trace_ocfs2_journal_dirty((unsigned long long)bh->b_blocknr);
 
 	status = jbd2_journal_dirty_metadata(handle, bh);
 	BUG_ON(status);
@@ -809,10 +803,9 @@ int ocfs2_journal_init(struct ocfs2_journal *journal, int *dirty)
 		goto done;
 	}
 
-	mlog(0, "inode->i_size = %lld\n", inode->i_size);
-	mlog(0, "inode->i_blocks = %llu\n",
-			(unsigned long long)inode->i_blocks);
-	mlog(0, "inode->ip_clusters = %u\n", OCFS2_I(inode)->ip_clusters);
+	trace_ocfs2_journal_init(inode->i_size, 
+				 (unsigned long long)inode->i_blocks,
+				 OCFS2_I(inode)->ip_clusters);
 
 	/* call the kernels journal init function now */
 	j_journal = jbd2_journal_init_inode(inode);
@@ -822,8 +815,7 @@ int ocfs2_journal_init(struct ocfs2_journal *journal, int *dirty)
 		goto done;
 	}
 
-	mlog(0, "Returned from jbd2_journal_init_inode\n");
-	mlog(0, "j_journal->j_maxlen = %u\n", j_journal->j_maxlen);
+	trace_ocfs2_journal_init_maxlen(j_journal->j_maxlen);
 
 	*dirty = (le32_to_cpu(di->id1.journal1.ij_flags) &
 		  OCFS2_JOURNAL_DIRTY_FL);
@@ -922,10 +914,7 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
 		BUG();
 
 	num_running_trans = atomic_read(&(osb->journal->j_num_trans));
-	if (num_running_trans > 0)
-		mlog(0, "Shutting down journal: must wait on %d "
-		     "running transactions!\n",
-		     num_running_trans);
+	trace_ocfs2_journal_shutdown(num_running_trans);
 
 	/* Do a commit_cache here. It will flush our journal, *and*
 	 * release any locks that are still held.
@@ -938,7 +927,7 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
 	 * completely destroy the journal. */
 	if (osb->commit_task) {
 		/* Wait for the commit thread */
-		mlog(0, "Waiting for ocfs2commit to exit....\n");
+		trace_ocfs2_journal_shutdown_wait(osb->commit_task);
 		kthread_stop(osb->commit_task);
 		osb->commit_task = NULL;
 	}
@@ -1158,7 +1147,7 @@ struct ocfs2_la_recovery_item {
  */
 void ocfs2_complete_recovery(struct work_struct *work)
 {
-	int ret;
+	int ret = 0;
 	struct ocfs2_journal *journal =
 		container_of(work, struct ocfs2_journal, j_recovery_work);
 	struct ocfs2_super *osb = journal->j_osb;
@@ -1167,7 +1156,8 @@ void ocfs2_complete_recovery(struct work_struct *work)
 	struct ocfs2_quota_recovery *qrec;
 	LIST_HEAD(tmp_la_list);
 
-	mlog(0, "completing recovery from keventd\n");
+	trace_ocfs2_complete_recovery(
+		(unsigned long long)OCFS2_I(journal->j_inode)->ip_blkno);
 
 	spin_lock(&journal->j_lock);
 	list_splice_init(&journal->j_la_cleanups, &tmp_la_list);
@@ -1176,15 +1166,18 @@ void ocfs2_complete_recovery(struct work_struct *work)
 	list_for_each_entry_safe(item, n, &tmp_la_list, lri_list) {
 		list_del_init(&item->lri_list);
 
-		mlog(0, "Complete recovery for slot %d\n", item->lri_slot);
-
 		ocfs2_wait_on_quotas(osb);
 
 		la_dinode = item->lri_la_dinode;
-		if (la_dinode) {
-			mlog(0, "Clean up local alloc %llu\n",
-			     (unsigned long long)le64_to_cpu(la_dinode->i_blkno));
+		tl_dinode = item->lri_tl_dinode;
+		qrec = item->lri_qrec;
 
+		trace_ocfs2_complete_recovery_slot(item->lri_slot,
+			la_dinode ? le64_to_cpu(la_dinode->i_blkno) : 0,
+			tl_dinode ? le64_to_cpu(tl_dinode->i_blkno) : 0,
+			qrec);
+
+		if (la_dinode) {
 			ret = ocfs2_complete_local_alloc_recovery(osb,
 								  la_dinode);
 			if (ret < 0)
@@ -1193,11 +1186,7 @@ void ocfs2_complete_recovery(struct work_struct *work)
 			kfree(la_dinode);
 		}
 
-		tl_dinode = item->lri_tl_dinode;
 		if (tl_dinode) {
-			mlog(0, "Clean up truncate log %llu\n",
-			     (unsigned long long)le64_to_cpu(tl_dinode->i_blkno));
-
 			ret = ocfs2_complete_truncate_log_recovery(osb,
 								   tl_dinode);
 			if (ret < 0)
@@ -1210,9 +1199,7 @@ void ocfs2_complete_recovery(struct work_struct *work)
 		if (ret < 0)
 			mlog_errno(ret);
 
-		qrec = item->lri_qrec;
 		if (qrec) {
-			mlog(0, "Recovering quota files");
 			ret = ocfs2_finish_quota_recovery(osb, qrec,
 							  item->lri_slot);
 			if (ret < 0)
@@ -1223,7 +1210,7 @@ void ocfs2_complete_recovery(struct work_struct *work)
 		kfree(item);
 	}
 
-	mlog(0, "Recovery completion\n");
+	trace_ocfs2_complete_recovery_end(ret);
 }
 
 /* NOTE: This function always eats your references to la_dinode and
@@ -1340,15 +1327,12 @@ restart:
 		 * clear it until ocfs2_recover_node() has succeeded. */
 		node_num = rm->rm_entries[0];
 		spin_unlock(&osb->osb_lock);
-		mlog(0, "checking node %d\n", node_num);
 		slot_num = ocfs2_node_num_to_slot(osb, node_num);
+		trace_ocfs2_recovery_thread_node(node_num, slot_num);
 		if (slot_num == -ENOENT) {
 			status = 0;
-			mlog(0, "no slot for this node, so no recovery"
-			     "required.\n");
 			goto skip_recovery;
 		}
-		mlog(0, "node %d was using slot %d\n", node_num, slot_num);
 
 		/* It is a bit subtle with quota recovery. We cannot do it
 		 * immediately because we have to obtain cluster locks from
@@ -1375,7 +1359,7 @@ skip_recovery:
 		spin_lock(&osb->osb_lock);
 	}
 	spin_unlock(&osb->osb_lock);
-	mlog(0, "All nodes recovered\n");
+	trace_ocfs2_recovery_thread_end(status);
 
 	/* Refresh all journal recovery generations from disk */
 	status = ocfs2_check_journals_nolocks(osb);
@@ -1428,19 +1412,15 @@ bail:
 
 void ocfs2_recovery_thread(struct ocfs2_super *osb, int node_num)
 {
-	mlog(0, "(node_num=%d, osb->node_num = %d)\n",
-	     node_num, osb->node_num);
-
 	mutex_lock(&osb->recovery_lock);
-	if (osb->disable_recovery)
-		goto out;
 
-	/* People waiting on recovery will wait on
-	 * the recovery map to empty. */
-	if (ocfs2_recovery_map_set(osb, node_num))
-		mlog(0, "node %d already in recovery map.\n", node_num);
+	trace_ocfs2_recovery_thread(node_num, osb->node_num,
+		osb->disable_recovery, osb->recovery_thread_task,
+		osb->disable_recovery ?
+		-1 : ocfs2_recovery_map_set(osb, node_num));
 
-	mlog(0, "starting recovery thread...\n");
+	if (osb->disable_recovery)
+		goto out;
 
 	if (osb->recovery_thread_task)
 		goto out;
@@ -1528,7 +1508,7 @@ static int ocfs2_replay_journal(struct ocfs2_super *osb,
 	 * If not, it needs recovery.
 	 */
 	if (osb->slot_recovery_generations[slot_num] != slot_reco_gen) {
-		mlog(0, "Slot %u already recovered (old/new=%u/%u)\n", slot_num,
+		trace_ocfs2_replay_journal_recovered(slot_num,
 		     osb->slot_recovery_generations[slot_num], slot_reco_gen);
 		osb->slot_recovery_generations[slot_num] = slot_reco_gen;
 		status = -EBUSY;
@@ -1539,7 +1519,7 @@ static int ocfs2_replay_journal(struct ocfs2_super *osb,
 
 	status = ocfs2_inode_lock_full(inode, &bh, 1, OCFS2_META_LOCK_RECOVERY);
 	if (status < 0) {
-		mlog(0, "status returned from ocfs2_inode_lock=%d\n", status);
+		trace_ocfs2_replay_journal_lock_err(status);
 		if (status != -ERESTARTSYS)
 			mlog(ML_ERROR, "Could not lock journal!\n");
 		goto done;
@@ -1552,7 +1532,7 @@ static int ocfs2_replay_journal(struct ocfs2_super *osb,
 	slot_reco_gen = ocfs2_get_recovery_generation(fe);
 
 	if (!(flags & OCFS2_JOURNAL_DIRTY_FL)) {
-		mlog(0, "No recovery required for node %d\n", node_num);
+		trace_ocfs2_replay_journal_skip(node_num);
 		/* Refresh recovery generation for the slot */
 		osb->slot_recovery_generations[slot_num] = slot_reco_gen;
 		goto done;
@@ -1573,7 +1553,6 @@ static int ocfs2_replay_journal(struct ocfs2_super *osb,
 		goto done;
 	}
 
-	mlog(0, "calling journal_init_inode\n");
 	journal = jbd2_journal_init_inode(inode);
 	if (journal == NULL) {
 		mlog(ML_ERROR, "Linux journal layer error\n");
@@ -1593,7 +1572,6 @@ static int ocfs2_replay_journal(struct ocfs2_super *osb,
 	ocfs2_clear_journal_error(osb->sb, journal, slot_num);
 
 	/* wipe the journal */
-	mlog(0, "flushing the journal.\n");
 	jbd2_journal_lock_updates(journal);
 	status = jbd2_journal_flush(journal);
 	jbd2_journal_unlock_updates(journal);
@@ -1652,8 +1630,7 @@ static int ocfs2_recover_node(struct ocfs2_super *osb,
 	struct ocfs2_dinode *la_copy = NULL;
 	struct ocfs2_dinode *tl_copy = NULL;
 
-	mlog(0, "(node_num=%d, slot_num=%d, osb->node_num = %d)\n",
-	     node_num, slot_num, osb->node_num);
+	trace_ocfs2_recover_node(node_num, slot_num, osb->node_num);
 
 	/* Should not ever be called to recover ourselves -- in that
 	 * case we should've called ocfs2_journal_load instead. */
@@ -1662,9 +1639,7 @@ static int ocfs2_recover_node(struct ocfs2_super *osb,
 	status = ocfs2_replay_journal(osb, node_num, slot_num);
 	if (status < 0) {
 		if (status == -EBUSY) {
-			mlog(0, "Skipping recovery for slot %u (node %u) "
-			     "as another node has recovered it\n", slot_num,
-			     node_num);
+			trace_ocfs2_recover_node_skip(slot_num, node_num);
 			status = 0;
 			goto done;
 		}
@@ -1771,8 +1746,8 @@ int ocfs2_mark_dead_nodes(struct ocfs2_super *osb)
 		spin_lock(&osb->osb_lock);
 		osb->slot_recovery_generations[i] = gen;
 
-		mlog(0, "Slot %u recovery generation is %u\n", i,
-		     osb->slot_recovery_generations[i]);
+		trace_ocfs2_mark_dead_nodes(i,
+					    osb->slot_recovery_generations[i]);
 
 		if (i == osb->slot_num) {
 			spin_unlock(&osb->osb_lock);
@@ -1846,11 +1821,12 @@ void ocfs2_queue_orphan_scan(struct ocfs2_super *osb)
 
 	os = &osb->osb_orphan_scan;
 
-	mlog(0, "Begin orphan scan\n");
-
 	if (atomic_read(&os->os_state) == ORPHAN_SCAN_INACTIVE)
 		goto out;
 
+	trace_ocfs2_queue_orphan_scan_begin(os->os_count, os->os_seqno,
+					    atomic_read(&os->os_state));
+
 	status = ocfs2_orphan_scan_lock(osb, &seqno);
 	if (status < 0) {
 		if (status != -EAGAIN)
@@ -1880,7 +1856,8 @@ void ocfs2_queue_orphan_scan(struct ocfs2_super *osb)
 unlock:
 	ocfs2_orphan_scan_unlock(osb, seqno);
 out:
-	mlog(0, "Orphan scan completed\n");
+	trace_ocfs2_queue_orphan_scan_end(os->os_count, os->os_seqno,
+					  atomic_read(&os->os_state));
 	return;
 }
 
@@ -1964,8 +1941,7 @@ static int ocfs2_orphan_filldir(void *priv, const char *name, int name_len,
 	if (IS_ERR(iter))
 		return 0;
 
-	mlog(0, "queue orphan %llu\n",
-	     (unsigned long long)OCFS2_I(iter)->ip_blkno);
+	trace_ocfs2_orphan_filldir((unsigned long long)OCFS2_I(iter)->ip_blkno);
 	/* No locking is required for the next_orphan queue as there
 	 * is only ever a single process doing orphan recovery. */
 	OCFS2_I(iter)->ip_next_orphan = p->head;
@@ -2081,7 +2057,7 @@ static int ocfs2_recover_orphans(struct ocfs2_super *osb,
 	struct inode *iter;
 	struct ocfs2_inode_info *oi;
 
-	mlog(0, "Recover inodes from orphan dir in slot %d\n", slot);
+	trace_ocfs2_recover_orphans(slot);
 
 	ocfs2_mark_recovering_orphan_dir(osb, slot);
 	ret = ocfs2_queue_orphans(osb, slot, &inode);
@@ -2094,7 +2070,8 @@ static int ocfs2_recover_orphans(struct ocfs2_super *osb,
 
 	while (inode) {
 		oi = OCFS2_I(inode);
-		mlog(0, "iput orphan %llu\n", (unsigned long long)oi->ip_blkno);
+		trace_ocfs2_recover_orphans_iput(
+					(unsigned long long)oi->ip_blkno);
 
 		iter = oi->ip_next_orphan;
 
@@ -2132,6 +2109,7 @@ static int __ocfs2_wait_on_mount(struct ocfs2_super *osb, int quota)
 	 * MOUNTED flag, but this is set right before
 	 * dismount_volume() so we can trust it. */
 	if (atomic_read(&osb->vol_state) == VOLUME_DISABLED) {
+		trace_ocfs2_wait_on_mount(VOLUME_DISABLED);
 		mlog(0, "mount error, exiting!\n");
 		return -EBUSY;
 	}
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index a58008f..736cb40 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -3936,6 +3936,247 @@ DEFINE_EVENT(ocfs2__int, ocfs2_encode_fh_type,
 );
 
 /* End of trace events for fs/ocfs2/dcache.c. */
+
+/* Trace events for fs/ocfs2/journal.c. */
+DEFINE_EVENT(ocfs2__uint, ocfs2_commit_cache_begin,
+
+	TP_PROTO(unsigned int flush),
+
+	TP_ARGS(flush)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint, ocfs2_commit_cache_end,
+
+	TP_PROTO(unsigned long long trans_id, unsigned int flushed),
+
+	TP_ARGS(trans_id, flushed)
+);
+
+DEFINE_EVENT(ocfs2__int_int, ocfs2_extend_trans,
+
+	TP_PROTO(int old, int nblocks),
+
+	TP_ARGS(old, nblocks)
+);
+
+DEFINE_EVENT(ocfs2__int, ocfs2_extend_trans_restart,
+
+	TP_PROTO(int nblocks),
+
+	TP_ARGS(nblocks)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull_uint_uint, ocfs2_journal_access,
+
+	TP_PROTO(unsigned long long owner, unsigned long long blkno,
+		 unsigned int type, unsigned int b_size),
+
+	TP_ARGS(owner, blkno, type, b_size)
+);
+
+DEFINE_EVENT(ocfs2__ull, ocfs2_journal_dirty,
+
+	TP_PROTO(unsigned long long blkno),
+
+	TP_ARGS(blkno)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull_uint, ocfs2_journal_init,
+
+	TP_PROTO(unsigned long long size, unsigned long long blocks,
+		 unsigned int clusters),
+
+	TP_ARGS(size, blocks, clusters)
+);
+
+DEFINE_EVENT(ocfs2__uint, ocfs2_journal_init_maxlen,
+
+	TP_PROTO(unsigned int maxlen),
+
+	TP_ARGS(maxlen)
+);
+
+DEFINE_EVENT(ocfs2__int, ocfs2_journal_shutdown,
+
+	TP_PROTO(int num_running_trans),
+
+	TP_ARGS(num_running_trans)
+);
+
+DEFINE_EVENT(ocfs2__pointer, ocfs2_journal_shutdown_wait,
+
+	TP_PROTO(void *commit_task),
+
+	TP_ARGS(commit_task)
+);
+
+DEFINE_EVENT(ocfs2__ull, ocfs2_complete_recovery,
+
+	TP_PROTO(unsigned long long ino),
+
+	TP_ARGS(ino)
+);
+
+DEFINE_EVENT(ocfs2__int, ocfs2_complete_recovery_end,
+
+	TP_PROTO(int ret),
+
+	TP_ARGS(ret)
+);
+
+TRACE_EVENT(ocfs2_complete_recovery_slot,
+
+	TP_PROTO(int slot, unsigned long long la_ino,
+		 unsigned long long tl_ino, void *qrec),
+
+	TP_ARGS(slot, la_ino, tl_ino, qrec),
+
+	TP_STRUCT__entry(
+		__field(	int,			slot		)
+		__field(	unsigned long long,	la_ino		)
+		__field(	unsigned long long,	tl_ino		)
+		__field(	void *,			qrec		)
+	),
+
+	TP_fast_assign(
+		__entry->slot		= 	slot;
+		__entry->la_ino		= 	la_ino;
+		__entry->tl_ino		= 	tl_ino;
+		__entry->qrec		= 	qrec;
+	),
+
+	TP_printk("%d %llu %llu %p", __entry->slot, __entry->la_ino,
+		  __entry->tl_ino, __entry->qrec)
+);
+
+DEFINE_EVENT(ocfs2__int_int, ocfs2_recovery_thread_node,
+
+	TP_PROTO(int node, int slot),
+
+	TP_ARGS(node, slot)
+);
+
+DEFINE_EVENT(ocfs2__int, ocfs2_recovery_thread_end,
+
+	TP_PROTO(int status),
+
+	TP_ARGS(status)
+);
+
+TRACE_EVENT(ocfs2_recovery_thread,
+
+	TP_PROTO(int node_num, int osb_node_num, int disable,
+		 void *recovery_thread, int map_set),
+
+	TP_ARGS(node_num, osb_node_num, disable, recovery_thread, map_set),
+
+	TP_STRUCT__entry(
+		__field(	int,	node_num		)
+		__field(	int,	osb_node_num		)
+		__field(	int,	disable			)
+		__field(	void *,	recovery_thread		)
+		__field(	int,	map_set			)
+	),
+
+	TP_fast_assign(
+		__entry->node_num		= 	node_num;
+		__entry->osb_node_num		= 	osb_node_num;
+		__entry->disable		= 	disable;
+		__entry->recovery_thread	= 	recovery_thread;
+		__entry->map_set		= 	map_set;
+	),
+
+	TP_printk("%d %d %d %p %d", __entry->node_num,
+		   __entry->osb_node_num, __entry->disable,
+		   __entry->recovery_thread, __entry->map_set)
+);
+
+DEFINE_EVENT(ocfs2__uint_uint_uint, ocfs2_replay_journal_recovered,
+
+	TP_PROTO(unsigned int slot_num, unsigned int old_gen,
+		 unsigned int new_gen),
+
+	TP_ARGS(slot_num, old_gen, new_gen)
+);
+
+DEFINE_EVENT(ocfs2__int, ocfs2_replay_journal_lock_err,
+
+	TP_PROTO(int status),
+
+	TP_ARGS(status)
+);
+
+DEFINE_EVENT(ocfs2__int, ocfs2_replay_journal_skip,
+
+	TP_PROTO(int slot),
+
+	TP_ARGS(slot)
+);
+
+DEFINE_EVENT(ocfs2__uint_uint_uint, ocfs2_recover_node,
+
+	TP_PROTO(unsigned int slot_num, unsigned int node_num,
+		 unsigned int osb_slot_num),
+
+	TP_ARGS(slot_num, node_num, osb_slot_num)
+);
+
+DEFINE_EVENT(ocfs2__uint_uint, ocfs2_recover_node_skip,
+
+	TP_PROTO(unsigned int slot_num, unsigned int node_num),
+
+	TP_ARGS(slot_num, node_num)
+);
+
+DEFINE_EVENT(ocfs2__uint_uint, ocfs2_mark_dead_nodes,
+
+	TP_PROTO(unsigned int slot_num, unsigned int gen),
+
+	TP_ARGS(slot_num, gen)
+);
+
+DEFINE_EVENT(ocfs2__uint_uint_uint, ocfs2_queue_orphan_scan_begin,
+
+	TP_PROTO(unsigned int count, unsigned int seqno, unsigned int state),
+
+	TP_ARGS(count, seqno, state)
+);
+
+DEFINE_EVENT(ocfs2__uint_uint_uint, ocfs2_queue_orphan_scan_end,
+
+	TP_PROTO(unsigned int count, unsigned int seqno, unsigned int state),
+
+	TP_ARGS(count, seqno, state)
+);
+
+DEFINE_EVENT(ocfs2__ull, ocfs2_orphan_filldir,
+
+	TP_PROTO(unsigned long long blkno),
+
+	TP_ARGS(blkno)
+);
+
+DEFINE_EVENT(ocfs2__int, ocfs2_recover_orphans,
+
+	TP_PROTO(int slot),
+
+	TP_ARGS(slot)
+);
+
+DEFINE_EVENT(ocfs2__ull, ocfs2_recover_orphans_iput,
+
+	TP_PROTO(unsigned long long blkno),
+
+	TP_ARGS(blkno)
+);
+
+DEFINE_EVENT(ocfs2__int, ocfs2_wait_on_mount,
+
+	TP_PROTO(int state),
+
+	TP_ARGS(state)
+);
+/* End of trace events for fs/ocfs2/journal.c. */
 #endif /* _TRACE_OCFS2_H */
 
 /* This part must be outside protection */
-- 
1.7.0.4
