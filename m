From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 14 Jul 2011 15:50:12 -0700
Subject: [Ocfs2-devel] [PATCH 01/16] ocfs2/cluster: Abort heartbeat start on
	hard-ro devices
In-Reply-To: <1310683827-19157-1-git-send-email-sunil.mushran@oracle.com>
References: <1310683827-19157-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1310683827-19157-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Currently if the heartbeat device is hard-ro, the o2hb thread keeps chugging
along and dumping errors along the way. The user needs to manually stop the
heartbeat.

The patch addresses this shortcoming by adding a limit to the number of times
the hb thread will iterate in an unsteady state. If the hb thread does not
ready steady state in that many interation, the start is aborted.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |  185 ++++++++++++++++++++++++++----------------
 1 files changed, 116 insertions(+), 69 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 9a3e6bb..4728a74 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -216,6 +216,7 @@ struct o2hb_region {
 
 	struct list_head	hr_all_item;
 	unsigned		hr_unclean_stop:1,
+				hr_aborted_start:1,
 				hr_item_pinned:1,
 				hr_item_dropped:1;
 
@@ -254,6 +255,10 @@ struct o2hb_region {
 	 * a more complete api that doesn't lead to this sort of fragility. */
 	atomic_t		hr_steady_iterations;
 
+	/* terminate o2hb thread if it does not reach steady state
+	 * (hr_steady_iterations == 0) within hr_unsteady_iterations */
+	atomic_t		hr_unsteady_iterations;
+
 	char			hr_dev_name[BDEVNAME_SIZE];
 
 	unsigned int		hr_timeout_ms;
@@ -324,6 +329,10 @@ static void o2hb_write_timeout(struct work_struct *work)
 
 static void o2hb_arm_write_timeout(struct o2hb_region *reg)
 {
+	/* Arm writeout only after thread reaches steady state */
+	if (atomic_read(&reg->hr_steady_iterations) != 0)
+		return;
+
 	mlog(ML_HEARTBEAT, "Queue write timeout for %u ms\n",
 	     O2HB_MAX_WRITE_TIMEOUT_MS);
 
@@ -537,9 +546,14 @@ static int o2hb_verify_crc(struct o2hb_region *reg,
 	return read == computed;
 }
 
-/* We want to make sure that nobody is heartbeating on top of us --
- * this will help detect an invalid configuration. */
-static void o2hb_check_last_timestamp(struct o2hb_region *reg)
+/*
+ * Compare the slot data with what we wrote in the last iteration.
+ * If the match fails, print an appropriate error message. This is to
+ * detect errors like... another node hearting on the same slot,
+ * flaky device that is losing writes, etc.
+ * Returns 1 if check succeeds, 0 otherwise.
+ */
+static int o2hb_check_own_slot(struct o2hb_region *reg)
 {
 	struct o2hb_disk_slot *slot;
 	struct o2hb_disk_heartbeat_block *hb_block;
@@ -548,13 +562,13 @@ static void o2hb_check_last_timestamp(struct o2hb_region *reg)
 	slot = &reg->hr_slots[o2nm_this_node()];
 	/* Don't check on our 1st timestamp */
 	if (!slot->ds_last_time)
-		return;
+		return 0;
 
 	hb_block = slot->ds_raw_block;
 	if (le64_to_cpu(hb_block->hb_seq) == slot->ds_last_time &&
 	    le64_to_cpu(hb_block->hb_generation) == slot->ds_last_generation &&
 	    hb_block->hb_node == slot->ds_node_num)
-		return;
+		return 1;
 
 #define ERRSTR1		"Another node is heartbeating on device"
 #define ERRSTR2		"Heartbeat generation mismatch on device"
@@ -574,6 +588,8 @@ static void o2hb_check_last_timestamp(struct o2hb_region *reg)
 	     (unsigned long long)slot->ds_last_time, hb_block->hb_node,
 	     (unsigned long long)le64_to_cpu(hb_block->hb_generation),
 	     (unsigned long long)le64_to_cpu(hb_block->hb_seq));
+
+	return 0;
 }
 
 static inline void o2hb_prepare_block(struct o2hb_region *reg,
@@ -719,17 +735,24 @@ static void o2hb_shutdown_slot(struct o2hb_disk_slot *slot)
 	o2nm_node_put(node);
 }
 
-static void o2hb_set_quorum_device(struct o2hb_region *reg,
-				   struct o2hb_disk_slot *slot)
+static void o2hb_set_quorum_device(struct o2hb_region *reg)
 {
-	assert_spin_locked(&o2hb_live_lock);
-
 	if (!o2hb_global_heartbeat_active())
 		return;
 
-	if (test_bit(reg->hr_region_num, o2hb_quorum_region_bitmap))
+	/* Prevent race with o2hb_heartbeat_group_drop_item() */
+	if (kthread_should_stop())
+		return;
+
+	/* Tag region as quorum only after thread reaches steady state */
+	if (atomic_read(&reg->hr_steady_iterations) != 0)
 		return;
 
+	spin_lock(&o2hb_live_lock);
+
+	if (test_bit(reg->hr_region_num, o2hb_quorum_region_bitmap))
+		goto unlock;
+
 	/*
 	 * A region can be added to the quorum only when it sees all
 	 * live nodes heartbeat on it. In other words, the region has been
@@ -737,13 +760,10 @@ static void o2hb_set_quorum_device(struct o2hb_region *reg,
 	 */
 	if (memcmp(reg->hr_live_node_bitmap, o2hb_live_node_bitmap,
 		   sizeof(o2hb_live_node_bitmap)))
-		return;
-
-	if (slot->ds_changed_samples < O2HB_LIVE_THRESHOLD)
-		return;
+		goto unlock;
 
-	printk(KERN_NOTICE "o2hb: Region %s is now a quorum device\n",
-	       config_item_name(&reg->hr_item));
+	printk(KERN_NOTICE "o2hb: Region %s (%s) is now a quorum device\n",
+	       config_item_name(&reg->hr_item), reg->hr_dev_name);
 
 	set_bit(reg->hr_region_num, o2hb_quorum_region_bitmap);
 
@@ -754,6 +774,8 @@ static void o2hb_set_quorum_device(struct o2hb_region *reg,
 	if (o2hb_pop_count(&o2hb_quorum_region_bitmap,
 			   O2NM_MAX_REGIONS) > O2HB_PIN_CUT_OFF)
 		o2hb_region_unpin(NULL);
+unlock:
+	spin_unlock(&o2hb_live_lock);
 }
 
 static int o2hb_check_slot(struct o2hb_region *reg,
@@ -925,8 +947,6 @@ fire_callbacks:
 		slot->ds_equal_samples = 0;
 	}
 out:
-	o2hb_set_quorum_device(reg, slot);
-
 	spin_unlock(&o2hb_live_lock);
 
 	o2hb_run_event_list(&event);
@@ -957,7 +977,8 @@ static int o2hb_highest_node(unsigned long *nodes,
 
 static int o2hb_do_disk_heartbeat(struct o2hb_region *reg)
 {
-	int i, ret, highest_node, change = 0;
+	int i, ret, highest_node;
+	int membership_change = 0, own_slot_ok = 0;
 	unsigned long configured_nodes[BITS_TO_LONGS(O2NM_MAX_NODES)];
 	unsigned long live_node_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
 	struct o2hb_bio_wait_ctxt write_wc;
@@ -966,7 +987,7 @@ static int o2hb_do_disk_heartbeat(struct o2hb_region *reg)
 				       sizeof(configured_nodes));
 	if (ret) {
 		mlog_errno(ret);
-		return ret;
+		goto bail;
 	}
 
 	/*
@@ -982,8 +1003,9 @@ static int o2hb_do_disk_heartbeat(struct o2hb_region *reg)
 
 	highest_node = o2hb_highest_node(configured_nodes, O2NM_MAX_NODES);
 	if (highest_node >= O2NM_MAX_NODES) {
-		mlog(ML_NOTICE, "ocfs2_heartbeat: no configured nodes found!\n");
-		return -EINVAL;
+		mlog(ML_NOTICE, "o2hb: No configured nodes found!\n");
+		ret = -EINVAL;
+		goto bail;
 	}
 
 	/* No sense in reading the slots of nodes that don't exist
@@ -993,29 +1015,27 @@ static int o2hb_do_disk_heartbeat(struct o2hb_region *reg)
 	ret = o2hb_read_slots(reg, highest_node + 1);
 	if (ret < 0) {
 		mlog_errno(ret);
-		return ret;
+		goto bail;
 	}
 
 	/* With an up to date view of the slots, we can check that no
 	 * other node has been improperly configured to heartbeat in
 	 * our slot. */
-	o2hb_check_last_timestamp(reg);
+	own_slot_ok = o2hb_check_own_slot(reg);
 
 	/* fill in the proper info for our next heartbeat */
 	o2hb_prepare_block(reg, reg->hr_generation);
 
-	/* And fire off the write. Note that we don't wait on this I/O
-	 * until later. */
 	ret = o2hb_issue_node_write(reg, &write_wc);
 	if (ret < 0) {
 		mlog_errno(ret);
-		return ret;
+		goto bail;
 	}
 
 	i = -1;
 	while((i = find_next_bit(configured_nodes,
 				 O2NM_MAX_NODES, i + 1)) < O2NM_MAX_NODES) {
-		change |= o2hb_check_slot(reg, &reg->hr_slots[i]);
+		membership_change |= o2hb_check_slot(reg, &reg->hr_slots[i]);
 	}
 
 	/*
@@ -1030,18 +1050,39 @@ static int o2hb_do_disk_heartbeat(struct o2hb_region *reg)
 		 * disk */
 		mlog(ML_ERROR, "Write error %d on device \"%s\"\n",
 		     write_wc.wc_error, reg->hr_dev_name);
-		return write_wc.wc_error;
+		ret = write_wc.wc_error;
+		goto bail;
 	}
 
-	o2hb_arm_write_timeout(reg);
+	/* Skip disarming the timeout if own slot has stale/bad data */
+	if (own_slot_ok) {
+		o2hb_set_quorum_device(reg);
+		o2hb_arm_write_timeout(reg);
+	}
 
+bail:
 	/* let the person who launched us know when things are steady */
-	if (!change && (atomic_read(&reg->hr_steady_iterations) != 0)) {
-		if (atomic_dec_and_test(&reg->hr_steady_iterations))
+	if (atomic_read(&reg->hr_steady_iterations) != 0) {
+		if (!ret && own_slot_ok && !membership_change) {
+			if (atomic_dec_and_test(&reg->hr_steady_iterations))
+				wake_up(&o2hb_steady_queue);
+		}
+	}
+
+	if (atomic_read(&reg->hr_steady_iterations) != 0) {
+		if (atomic_dec_and_test(&reg->hr_unsteady_iterations)) {
+			printk(KERN_NOTICE "o2hb: Unable to stabilize "
+			       "heartbeart on region %s (%s)\n",
+			       config_item_name(&reg->hr_item),
+			       reg->hr_dev_name);
+			atomic_set(&reg->hr_steady_iterations, 0);
+			reg->hr_aborted_start = 1;
 			wake_up(&o2hb_steady_queue);
+			ret = -EIO;
+		}
 	}
 
-	return 0;
+	return ret;
 }
 
 /* Subtract b from a, storing the result in a. a *must* have a larger
@@ -1095,7 +1136,8 @@ static int o2hb_thread(void *data)
 	/* Pin node */
 	o2nm_depend_this_node();
 
-	while (!kthread_should_stop() && !reg->hr_unclean_stop) {
+	while (!kthread_should_stop() &&
+	       !reg->hr_unclean_stop && !reg->hr_aborted_start) {
 		/* We track the time spent inside
 		 * o2hb_do_disk_heartbeat so that we avoid more than
 		 * hr_timeout_ms between disk writes. On busy systems
@@ -1103,10 +1145,7 @@ static int o2hb_thread(void *data)
 		 * likely to time itself out. */
 		do_gettimeofday(&before_hb);
 
-		i = 0;
-		do {
-			ret = o2hb_do_disk_heartbeat(reg);
-		} while (ret && ++i < 2);
+		ret = o2hb_do_disk_heartbeat(reg);
 
 		do_gettimeofday(&after_hb);
 		elapsed_msec = o2hb_elapsed_msecs(&before_hb, &after_hb);
@@ -1117,7 +1156,8 @@ static int o2hb_thread(void *data)
 		     after_hb.tv_sec, (unsigned long) after_hb.tv_usec,
 		     elapsed_msec);
 
-		if (elapsed_msec < reg->hr_timeout_ms) {
+		if (!kthread_should_stop() &&
+		    elapsed_msec < reg->hr_timeout_ms) {
 			/* the kthread api has blocked signals for us so no
 			 * need to record the return value. */
 			msleep_interruptible(reg->hr_timeout_ms - elapsed_msec);
@@ -1134,20 +1174,20 @@ static int o2hb_thread(void *data)
 	 * to timeout on this region when we could just as easily
 	 * write a clear generation - thus indicating to them that
 	 * this node has left this region.
-	 *
-	 * XXX: Should we skip this on unclean_stop? */
-	o2hb_prepare_block(reg, 0);
-	ret = o2hb_issue_node_write(reg, &write_wc);
-	if (ret == 0) {
-		o2hb_wait_on_io(reg, &write_wc);
-	} else {
-		mlog_errno(ret);
+	 */
+	if (!reg->hr_unclean_stop && !reg->hr_aborted_start) {
+		o2hb_prepare_block(reg, 0);
+		ret = o2hb_issue_node_write(reg, &write_wc);
+		if (ret == 0)
+			o2hb_wait_on_io(reg, &write_wc);
+		else
+			mlog_errno(ret);
 	}
 
 	/* Unpin node */
 	o2nm_undepend_this_node();
 
-	mlog(ML_HEARTBEAT|ML_KTHREAD, "hb thread exiting\n");
+	mlog(ML_HEARTBEAT|ML_KTHREAD, "o2hb thread exiting\n");
 
 	return 0;
 }
@@ -1426,6 +1466,8 @@ static void o2hb_region_release(struct config_item *item)
 	struct page *page;
 	struct o2hb_region *reg = to_o2hb_region(item);
 
+	mlog(ML_HEARTBEAT, "hb region release (%s)\n", reg->hr_dev_name);
+
 	if (reg->hr_tmp_block)
 		kfree(reg->hr_tmp_block);
 
@@ -1792,7 +1834,10 @@ static ssize_t o2hb_region_dev_write(struct o2hb_region *reg,
 			live_threshold <<= 1;
 		spin_unlock(&o2hb_live_lock);
 	}
-	atomic_set(&reg->hr_steady_iterations, live_threshold + 1);
+	++live_threshold;
+	atomic_set(&reg->hr_steady_iterations, live_threshold);
+	/* unsteady_iterations is double the steady_iterations */
+	atomic_set(&reg->hr_unsteady_iterations, (live_threshold << 1));
 
 	hb_task = kthread_run(o2hb_thread, reg, "o2hb-%s",
 			      reg->hr_item.ci_name);
@@ -1809,14 +1854,12 @@ static ssize_t o2hb_region_dev_write(struct o2hb_region *reg,
 	ret = wait_event_interruptible(o2hb_steady_queue,
 				atomic_read(&reg->hr_steady_iterations) == 0);
 	if (ret) {
-		/* We got interrupted (hello ptrace!).  Clean up */
-		spin_lock(&o2hb_live_lock);
-		hb_task = reg->hr_task;
-		reg->hr_task = NULL;
-		spin_unlock(&o2hb_live_lock);
+		atomic_set(&reg->hr_steady_iterations, 0);
+		reg->hr_aborted_start = 1;
+	}
 
-		if (hb_task)
-			kthread_stop(hb_task);
+	if (reg->hr_aborted_start) {
+		ret = -EIO;
 		goto out;
 	}
 
@@ -1833,8 +1876,8 @@ static ssize_t o2hb_region_dev_write(struct o2hb_region *reg,
 		ret = -EIO;
 
 	if (hb_task && o2hb_global_heartbeat_active())
-		printk(KERN_NOTICE "o2hb: Heartbeat started on region %s\n",
-		       config_item_name(&reg->hr_item));
+		printk(KERN_NOTICE "o2hb: Heartbeat started on region %s (%s)\n",
+		       config_item_name(&reg->hr_item), reg->hr_dev_name);
 
 out:
 	if (filp)
@@ -2092,13 +2135,6 @@ static void o2hb_heartbeat_group_drop_item(struct config_group *group,
 
 	/* stop the thread when the user removes the region dir */
 	spin_lock(&o2hb_live_lock);
-	if (o2hb_global_heartbeat_active()) {
-		clear_bit(reg->hr_region_num, o2hb_region_bitmap);
-		clear_bit(reg->hr_region_num, o2hb_live_region_bitmap);
-		if (test_bit(reg->hr_region_num, o2hb_quorum_region_bitmap))
-			quorum_region = 1;
-		clear_bit(reg->hr_region_num, o2hb_quorum_region_bitmap);
-	}
 	hb_task = reg->hr_task;
 	reg->hr_task = NULL;
 	reg->hr_item_dropped = 1;
@@ -2107,19 +2143,30 @@ static void o2hb_heartbeat_group_drop_item(struct config_group *group,
 	if (hb_task)
 		kthread_stop(hb_task);
 
+	if (o2hb_global_heartbeat_active()) {
+		spin_lock(&o2hb_live_lock);
+		clear_bit(reg->hr_region_num, o2hb_region_bitmap);
+		clear_bit(reg->hr_region_num, o2hb_live_region_bitmap);
+		if (test_bit(reg->hr_region_num, o2hb_quorum_region_bitmap))
+			quorum_region = 1;
+		clear_bit(reg->hr_region_num, o2hb_quorum_region_bitmap);
+		spin_unlock(&o2hb_live_lock);
+		printk(KERN_NOTICE "o2hb: Heartbeat %s on region %s (%s)\n",
+		       ((atomic_read(&reg->hr_steady_iterations) == 0) ?
+			"stopped" : "start aborted"), config_item_name(item),
+		       reg->hr_dev_name);
+	}
+
 	/*
 	 * If we're racing a dev_write(), we need to wake them.  They will
 	 * check reg->hr_task
 	 */
 	if (atomic_read(&reg->hr_steady_iterations) != 0) {
+		reg->hr_aborted_start = 1;
 		atomic_set(&reg->hr_steady_iterations, 0);
 		wake_up(&o2hb_steady_queue);
 	}
 
-	if (o2hb_global_heartbeat_active())
-		printk(KERN_NOTICE "o2hb: Heartbeat stopped on region %s\n",
-		       config_item_name(&reg->hr_item));
-
 	config_item_put(item);
 
 	if (!o2hb_global_heartbeat_active() || !quorum_region)
-- 
1.7.4.1
