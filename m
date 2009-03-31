From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Tue, 31 Mar 2009 08:19:41 -0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: remove some pointless conditionals
	before kfree()
Message-ID: <49D1D1CF.1080804@cn.fujitsu.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Remove some pointless conditionals before kfree().

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 fs/ocfs2/alloc.c             |    3 +--
 fs/ocfs2/cluster/heartbeat.c |    6 ++----
 fs/ocfs2/cluster/tcp.c       |    6 ++----
 fs/ocfs2/dlm/dlmdomain.c     |    3 +--
 fs/ocfs2/dlm/dlmrecovery.c   |    6 ++----
 fs/ocfs2/extent_map.c        |    3 +--
 fs/ocfs2/journal.c           |    9 +++------
 fs/ocfs2/localalloc.c        |    9 +++------
 fs/ocfs2/super.c             |    6 ++----
 9 files changed, 17 insertions(+), 34 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 19e3a96..08f46cd 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6882,8 +6882,7 @@ int ocfs2_zero_range_for_truncate(struct inode *inode, handle_t *handle,
 		mlog_errno(ret);
 
 out:
-	if (pages)
-		kfree(pages);
+	kfree(pages);
 
 	return ret;
 }
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 04697ba..a1934ed 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -963,8 +963,7 @@ static void o2hb_region_release(struct config_item *item)
 	struct page *page;
 	struct o2hb_region *reg = to_o2hb_region(item);
 
-	if (reg->hr_tmp_block)
-		kfree(reg->hr_tmp_block);
+	kfree(reg->hr_tmp_block);
 
 	if (reg->hr_slot_data) {
 		for (i = 0; i < reg->hr_num_pages; i++) {
@@ -978,8 +977,7 @@ static void o2hb_region_release(struct config_item *item)
 	if (reg->hr_bdev)
 		blkdev_put(reg->hr_bdev, FMODE_READ|FMODE_WRITE);
 
-	if (reg->hr_slots)
-		kfree(reg->hr_slots);
+	kfree(reg->hr_slots);
 
 	spin_lock(&o2hb_live_lock);
 	list_del(&reg->hr_all_item);
diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 9fbe849..7530d10 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -1083,10 +1083,8 @@ out:
 	o2net_debug_del_nst(&nst); /* must be before dropping sc and node */
 	if (sc)
 		sc_put(sc);
-	if (vec)
-		kfree(vec);
-	if (msg)
-		kfree(msg);
+	kfree(vec);
+	kfree(msg);
 	o2net_complete_nsw(nn, &nsw, 0, 0, 0);
 	return ret;
 }
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index d8d578f..30e38ab 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -304,8 +304,7 @@ static void dlm_free_ctxt_mem(struct dlm_ctxt *dlm)
 	if (dlm->lockres_hash)
 		dlm_free_pagevec((void **)dlm->lockres_hash, DLM_HASH_PAGES);
 
-	if (dlm->name)
-		kfree(dlm->name);
+	kfree(dlm->name);
 
 	kfree(dlm);
 }
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index bcb9260..ffd48e8 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1469,10 +1469,8 @@ leave:
 
 	dlm_put(dlm);
 	if (ret < 0) {
-		if (buf)
-			kfree(buf);
-		if (item)
-			kfree(item);
+		kfree(buf);
+		kfree(item);
 	}
 
 	mlog_exit(ret);
diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index f2bb1a0..7640858 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -280,8 +280,7 @@ search:
 	spin_unlock(&oi->ip_lock);
 
 out:
-	if (new_emi)
-		kfree(new_emi);
+	kfree(new_emi);
 }
 
 static int ocfs2_last_eb_is_empty(struct inode *inode,
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 57d7d25..195af61 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1150,11 +1150,9 @@ static void ocfs2_queue_recovery_completion(struct ocfs2_journal *journal,
 		/* Though we wish to avoid it, we are in fact safe in
 		 * skipping local alloc cleanup as fsck.ocfs2 is more
 		 * than capable of reclaiming unused space. */
-		if (la_dinode)
-			kfree(la_dinode);
+		kfree(la_dinode);
 
-		if (tl_dinode)
-			kfree(tl_dinode);
+		kfree(tl_dinode);
 
 		if (qrec)
 			ocfs2_free_quota_recovery(qrec);
@@ -1320,8 +1318,7 @@ bail:
 
 	mutex_unlock(&osb->recovery_lock);
 
-	if (rm_quota)
-		kfree(rm_quota);
+	kfree(rm_quota);
 
 	mlog_exit(status);
 	/* no one is callint kthread_stop() for us so the kthread() api
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index ec70cdb..471597b 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -136,8 +136,7 @@ static void ocfs2_shutdown_la_debug(struct ocfs2_super *osb)
 	if (osb->local_alloc_debug)
 		debugfs_remove(osb->local_alloc_debug);
 
-	if (osb->local_alloc_debug_buf)
-		kfree(osb->local_alloc_debug_buf);
+	kfree(osb->local_alloc_debug_buf);
 
 	osb->local_alloc_debug_buf = NULL;
 	osb->local_alloc_debug = NULL;
@@ -423,8 +422,7 @@ out:
 	if (local_alloc_inode)
 		iput(local_alloc_inode);
 
-	if (alloc_copy)
-		kfree(alloc_copy);
+	kfree(alloc_copy);
 
 	mlog_exit_void();
 }
@@ -1284,8 +1282,7 @@ bail:
 	if (main_bm_inode)
 		iput(main_bm_inode);
 
-	if (alloc_copy)
-		kfree(alloc_copy);
+	kfree(alloc_copy);
 
 	if (ac)
 		ocfs2_free_alloc_context(ac);
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 7ac83a8..6ee9457 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2134,8 +2134,7 @@ static int ocfs2_check_volume(struct ocfs2_super *osb)
 		mlog_errno(status);
 
 finally:
-	if (local_alloc)
-		kfree(local_alloc);
+	kfree(local_alloc);
 
 	mlog_exit(status);
 	return status;
@@ -2163,8 +2162,7 @@ static void ocfs2_delete_osb(struct ocfs2_super *osb)
 	 * we free it here.
 	 */
 	kfree(osb->journal);
-	if (osb->local_alloc_copy)
-		kfree(osb->local_alloc_copy);
+	kfree(osb->local_alloc_copy);
 	kfree(osb->uuid_str);
 	ocfs2_put_dlm_debug(osb->osb_dlm_debug);
 	memset(osb, 0, sizeof(struct ocfs2_super));
-- 
1.5.3.8
