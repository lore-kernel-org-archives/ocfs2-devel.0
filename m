Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E57A3BE651
	for <ocfs2-devel@lists.linux.dev>; Tue, 16 Jun 2026 07:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781596183; cv=none; b=TkqWaW3T6S2RYr9PZw8UT1iXTqG0ijESaElzwMf+FYt9C+kFcamAuZjL6JR1oClApTqNI4oPOhx+8KaYQLDe18iSNbxxGea3v45X4+74pMT8nLa3PpQoksm94OInNHA23xnCVnFJMHOyiV7/gU6u+cS9mWUCbZqAMKLgkfBc63w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781596183; c=relaxed/simple;
	bh=1CcBlSobrdKSY/0g3fjYgSIOnFz2AcI8sG9OtSLAt6A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jyjFMyz7sidzuKsR1lk+3yYmcDGdvkhp4GDVaZbRjLeAdGFjkqVhILC8j15jpHe6qdD44jhGnfYhzn97zmzdeCEzbxbLZjgD1e27Jat7uipqAcL4snssJSyzcymgONrxT8+v9hzqHuRIuAsXhggvqJ9SjocpeCMc8U2jjJeKp4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hxU48Uvy; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hxU48Uvy"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-37c5b9d42efso80808a91.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 16 Jun 2026 00:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781596180; x=1782200980; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RZSCRAEq6mLWIILwn7aPw9PV7cJkqVVF3rIiGatxsiA=;
        b=hxU48UvykuEbz4D6NC2Jj6f5fJV0OlT10yytUX3GnCNdmBquXMyj0b+Am75YDsY6Y3
         VzTq3YjTj1+di47rRnXgs4T21MGY+2XHxg6ytppHZRTXMQao0pj7hmKAL8XaeAnH22pq
         xRj3KVnDKXbjwY4VSR4o323ZyM6QYOair18iZ7KP5ZpUkRget2441TQaPt8xzq7p1a2q
         Xgw5viPUj5h9eB2cc0Pj1vqeqNa3HEM+ZsjkxHu6XsPXjWKRLy7IO/K6ere9leihY3gK
         u41oY8ddNMnRi5RGZZZY+bHJa1Y8UDTLfpFiLIeqYElZ2w/jEG8JfrHfyKpB1fpLlQh9
         w3jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781596180; x=1782200980;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RZSCRAEq6mLWIILwn7aPw9PV7cJkqVVF3rIiGatxsiA=;
        b=mAAYzsqZYdEbEPVcuc8kzh0YtOonTGZl/vawsbt8J9tW/S+qPCF4Y7g0x/zdyQX3wz
         g5pZhKCxmuGimEHli8pWRVOV9yxfHa6xYR1J8EJ683ula873Rn8kSWPy2dlezdlCUn9o
         8bZUAs1wxuZKCioEGvi6/MLIJgTRr70rVZB5XLjIBVVtBwMG1MFcKc1FFbEh27pJ/Srk
         8wZOV3hAvv8fi30HA198LUkAM10WzE0nFwNiEOGQo86dRivzZ2Oh6Uv7noJpoxoDtBVs
         1zcMWl9r6nnsA4n95HcpRegN7u1kJaemZKBgG4/lzsebPqr9D5pkbJOWBSYAXsMKjZgS
         vvRQ==
X-Gm-Message-State: AOJu0YyU1l5b5osXw7GGXKtlIubcMmrNFLMVSsH+dfZjPhONlAtephx9
	juuPl5qsG0MsjG+fBPh0earCPmK7pM6PvhZCrjtEEoswMZLN3se8BRj7
X-Gm-Gg: Acq92OF5wrE1zOWr+/GdHEvanT8E2dCSLIYvRkafI8xlrrfW7jwNyaTUouUhX8cLyjk
	phC+utewu+QFb6k/JyYtVAue9EWBP2fGrKYrWqb2Ivur2bmlaQ7b28Wz5Mr0F4AZJrrxibRRceW
	q5Ha1rtPethYE0N58oMo29etz9pHBvNhjy750ccDTuY7XxPlMF/sIGO/eZSCk1Hol7kw6mclXoR
	6fYaPkg7IhtP9D8vanOyO5wdkzwxzHmNsrC9HfdoQaQUrkkQh7P58oozVQvSWwEwdtdqB+HIcwa
	R729RnBYDFDajvRAriq0e7EkOOzdIuo/vR//PvouIVM9g9Tzve0PBYb2lPMJSVVDiUxobfbQk3d
	/mhHAgSXrTwluB/vNfmLDBu0Qhc4Pe6Aa0vUahTp//BgILcPgw+IF4xNo+I/F1OhR8wREKK8Ibk
	ooSJ7YKOzjZF1Dotfaug==
X-Received: by 2002:a17:90a:c2c8:b0:35f:bb17:39f with SMTP id 98e67ed59e1d1-37c52337840mr2086162a91.1.1781596180293;
        Tue, 16 Jun 2026 00:49:40 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c6a1878426sm7340665ad.64.2026.06.16.00.49.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 00:49:39 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	zzzccc427@gmail.com
Subject: [PATCH v2] ocfs2/cluster: keep heartbeat local node stable
Date: Tue, 16 Jun 2026 15:49:31 +0800
Message-Id: <20260616074931.3774929-1-zzzccc427@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

o2nm_node_local_store() handles local=0 by stopping o2net and setting
cl_local_node to O2NM_INVALID_NODE_NUM, but it leaves cl_has_local set.
That stale state makes o2nm_this_node() return 255, blocks a later
local=1 attempt with -EBUSY, and can feed 255 to heartbeat users that
call o2nm_this_node() dynamically.

Clearing cl_has_local is required when the local node is reset. But
heartbeat threads can still be running at that point. They pin the local
node config item at startup, yet o2hb_do_disk_heartbeat() and thread
teardown re-read o2nm_this_node() for the local slot and for
o2nm_undepend_this_node(). Once local=0 has cleared the live local-node
state, those dynamic reads return O2NM_MAX_NODES, which is also the
invalid node number 255.

Store the local node number in the heartbeat region when the region
starts. Use that stable node for heartbeat slot writes/checks,
negotiation messages, and the final configfs undepend. Stop the
heartbeat loop when the current local node no longer matches the stored
node, and clear cl_has_local together with cl_local_node in the local=0
path so nodemanager state matches node removal.

Validation reproduced this kernel report:
KASAN slab-out-of-bounds in o2hb_do_disk_heartbeat+0x372/0xb30
RIP: 0010:memset+0xf/0x20
Read of size 8
Call trace:
  dump_stack_lvl+0x66/0xa0
  print_report+0xd0/0x630
  o2hb_do_disk_heartbeat+0x372/0xb30 (fs/ocfs2/cluster/heartbeat.c:1079)
  srso_alias_return_thunk+0x5/0xfbef5
  __virt_addr_valid+0x188/0x2f0
  kasan_report+0xe4/0x120
  o2hb_do_disk_heartbeat+0x5/0xb30 (fs/ocfs2/cluster/heartbeat.c:1079)
  o2hb_thread+0x14e/0x770
  kthread_affine_node+0x139/0x180
  lockdep_hardirqs_on_prepare+0xda/0x190
  trace_hardirqs_on+0x18/0x130
  kthread+0x19d/0x1e0
  ret_from_fork+0x37a/0x4d0
  __switch_to+0x2d5/0x6f0
  ret_from_fork_asm+0x1a/0x30

Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Fixes: a7f6a5fb4bde ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
Changes since v1:
- Clear cluster->cl_has_local in the local=0 path as suggested by Joseph.
- Replace the broader heartbeat active-state approach with a stable local
  node number stored in each heartbeat region while the heartbeat thread is
  running.

 fs/ocfs2/cluster/heartbeat.c   | 43 +++++++++++++++++++++++-----------
 fs/ocfs2/cluster/nodemanager.c | 19 +++++++++++----
 fs/ocfs2/cluster/nodemanager.h |  2 ++
 3 files changed, 46 insertions(+), 18 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index d12784aaaa4b..6da96a374fcd 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -202,8 +202,9 @@ struct o2hb_region {
 				hr_node_deleted:1;
 
 	/* protected by the hr_callback_sem */
 	struct task_struct 	*hr_task;
+	u8			hr_node_num;
 
 	unsigned int		hr_blocks;
 	unsigned long long	hr_start_block;
 
@@ -349,14 +350,14 @@ static void o2hb_disarm_timeout(struct o2hb_region *reg)
 	cancel_delayed_work_sync(&reg->hr_write_timeout_work);
 	cancel_delayed_work_sync(&reg->hr_nego_timeout_work);
 }
 
-static int o2hb_send_nego_msg(int key, int type, u8 target)
+static int o2hb_send_nego_msg(int key, int type, u8 target, u8 node_num)
 {
 	struct o2hb_nego_msg msg;
 	int status, ret;
 
-	msg.node_num = o2nm_this_node();
+	msg.node_num = node_num;
 again:
 	ret = o2net_send_message(type, key, &msg, sizeof(msg),
 			target, &status);
 
@@ -372,10 +373,12 @@ static void o2hb_nego_timeout(struct work_struct *work)
 {
 	unsigned long live_node_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
 	int master_node, i, ret;
 	struct o2hb_region *reg;
+	u8 node_num;
 
 	reg = container_of(work, struct o2hb_region, hr_nego_timeout_work.work);
+	node_num = reg->hr_node_num;
 	/* don't negotiate timeout if last hb failed since it is very
 	 * possible io failed. Should let write timeout fence self.
 	 */
 	if (reg->hr_last_hb_status)
@@ -384,12 +387,12 @@ static void o2hb_nego_timeout(struct work_struct *work)
 	o2hb_fill_node_map(live_node_bitmap, O2NM_MAX_NODES);
 	/* lowest node as master node to make negotiate decision. */
 	master_node = find_first_bit(live_node_bitmap, O2NM_MAX_NODES);
 
-	if (master_node == o2nm_this_node()) {
+	if (master_node == node_num) {
 		if (!test_bit(master_node, reg->hr_nego_node_bitmap)) {
 			printk(KERN_NOTICE "o2hb: node %d hb write hung for %ds on region %s (%pg).\n",
-				o2nm_this_node(), O2HB_NEGO_TIMEOUT_MS/1000,
+				node_num, O2HB_NEGO_TIMEOUT_MS / 1000,
 				config_item_name(&reg->hr_item), reg_bdev(reg));
 			set_bit(master_node, reg->hr_nego_node_bitmap);
 		}
 		if (!bitmap_equal(reg->hr_nego_node_bitmap, live_node_bitmap,
@@ -416,20 +419,20 @@ static void o2hb_nego_timeout(struct work_struct *work)
 				continue;
 
 			mlog(ML_HEARTBEAT, "send NEGO_APPROVE msg to node %d\n", i);
 			ret = o2hb_send_nego_msg(reg->hr_key,
-					O2HB_NEGO_APPROVE_MSG, i);
+					O2HB_NEGO_APPROVE_MSG, i, node_num);
 			if (ret)
 				mlog(ML_ERROR, "send NEGO_APPROVE msg to node %d fail %d\n",
 					i, ret);
 		}
 	} else {
 		/* negotiate timeout with master node. */
 		printk(KERN_NOTICE "o2hb: node %d hb write hung for %ds on region %s (%pg), negotiate timeout with node %d.\n",
-			o2nm_this_node(), O2HB_NEGO_TIMEOUT_MS/1000, config_item_name(&reg->hr_item),
+			node_num, O2HB_NEGO_TIMEOUT_MS / 1000, config_item_name(&reg->hr_item),
 			reg_bdev(reg), master_node);
 		ret = o2hb_send_nego_msg(reg->hr_key, O2HB_NEGO_TIMEOUT_MSG,
-				master_node);
+				master_node, node_num);
 		if (ret)
 			mlog(ML_ERROR, "send NEGO_TIMEOUT msg to node %d fail %d\n",
 				master_node, ret);
 	}
@@ -600,9 +603,11 @@ static int o2hb_issue_node_write(struct o2hb_region *reg,
 	struct bio *bio;
 
 	o2hb_bio_wait_init(write_wc);
 
-	slot = o2nm_this_node();
+	slot = reg->hr_node_num;
+	if (slot >= O2NM_MAX_NODES)
+		return -EINVAL;
 
 	bio = o2hb_setup_one_bio(reg, write_wc, &slot, slot+1,
 				 REQ_OP_WRITE | REQ_SYNC);
 	if (IS_ERR(bio)) {
@@ -669,10 +674,14 @@ static int o2hb_check_own_slot(struct o2hb_region *reg)
 {
 	struct o2hb_disk_slot *slot;
 	struct o2hb_disk_heartbeat_block *hb_block;
 	char *errstr;
+	u8 node_num = reg->hr_node_num;
+
+	if (node_num >= O2NM_MAX_NODES)
+		return 0;
 
-	slot = &reg->hr_slots[o2nm_this_node()];
+	slot = &reg->hr_slots[node_num];
 	/* Don't check on our 1st timestamp */
 	if (!slot->ds_last_time)
 		return 0;
 
@@ -711,9 +720,12 @@ static inline void o2hb_prepare_block(struct o2hb_region *reg,
 	u64 cputime;
 	struct o2hb_disk_slot *slot;
 	struct o2hb_disk_heartbeat_block *hb_block;
 
-	node_num = o2nm_this_node();
+	node_num = reg->hr_node_num;
+	if (node_num >= O2NM_MAX_NODES)
+		return;
+
 	slot = &reg->hr_slots[node_num];
 
 	hb_block = (struct o2hb_disk_heartbeat_block *)slot->ds_raw_block;
 	memset(hb_block, 0, reg->hr_block_bytes);
@@ -1205,18 +1217,19 @@ static int o2hb_thread(void *data)
 
 	set_user_nice(current, MIN_NICE);
 
 	/* Pin node */
-	ret = o2nm_depend_this_node();
+	ret = o2nm_depend_node(reg->hr_node_num);
 	if (ret) {
 		mlog(ML_ERROR, "Node has been deleted, ret = %d\n", ret);
 		reg->hr_node_deleted = 1;
 		wake_up(&o2hb_steady_queue);
 		return 0;
 	}
 
 	while (!kthread_should_stop() &&
-	       !reg->hr_unclean_stop && !reg->hr_aborted_start) {
+	       !reg->hr_unclean_stop && !reg->hr_aborted_start &&
+	       o2nm_this_node() == reg->hr_node_num) {
 		/* We track the time spent inside
 		 * o2hb_do_disk_heartbeat so that we avoid more than
 		 * hr_timeout_ms between disk writes. On busy systems
 		 * this should result in a heartbeat which is less
@@ -1263,9 +1276,9 @@ static int o2hb_thread(void *data)
 			mlog_errno(ret);
 	}
 
 	/* Unpin node */
-	o2nm_undepend_this_node();
+	o2nm_undepend_node(reg->hr_node_num);
 
 	mlog(ML_HEARTBEAT|ML_KTHREAD, "o2hb thread exiting\n");
 
 	return 0;
@@ -1790,9 +1803,10 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 		return -EINVAL;
 
 	/* We can't heartbeat without having had our node number
 	 * configured yet. */
-	if (o2nm_this_node() == O2NM_MAX_NODES)
+	reg->hr_node_num = o2nm_this_node();
+	if (reg->hr_node_num == O2NM_MAX_NODES)
 		return -EINVAL;
 
 	ret = kstrtol(p, 0, &fd);
 	if (ret < 0)
@@ -2035,8 +2049,9 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
 	if (strlen(name) > O2HB_MAX_REGION_NAME_LEN) {
 		ret = -ENAMETOOLONG;
 		goto free;
 	}
+	reg->hr_node_num = O2NM_MAX_NODES;
 
 	spin_lock(&o2hb_live_lock);
 	reg->hr_region_num = 0;
 	if (o2hb_global_heartbeat_active()) {
diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index 402563154550..e1f8f577ce5d 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -366,8 +366,9 @@ static ssize_t o2nm_node_local_store(struct config_item *item, const char *page,
 
 	if (!tmp && cluster->cl_has_local &&
 	    cluster->cl_local_node == node->nd_num) {
 		o2net_stop_listening(node);
+		cluster->cl_has_local = 0;
 		cluster->cl_local_node = O2NM_INVALID_NODE_NUM;
 	}
 
 	node->nd_local = tmp;
@@ -781,14 +782,14 @@ void o2nm_undepend_item(struct config_item *item)
 {
 	configfs_undepend_item(item);
 }
 
-int o2nm_depend_this_node(void)
+int o2nm_depend_node(u8 node_num)
 {
 	int ret = 0;
 	struct o2nm_node *local_node;
 
-	local_node = o2nm_get_node_by_num(o2nm_this_node());
+	local_node = o2nm_get_node_by_num(node_num);
 	if (!local_node) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -799,19 +800,29 @@ int o2nm_depend_this_node(void)
 out:
 	return ret;
 }
 
-void o2nm_undepend_this_node(void)
+void o2nm_undepend_node(u8 node_num)
 {
 	struct o2nm_node *local_node;
 
-	local_node = o2nm_get_node_by_num(o2nm_this_node());
+	local_node = o2nm_get_node_by_num(node_num);
 	BUG_ON(!local_node);
 
 	o2nm_undepend_item(&local_node->nd_item);
 	o2nm_node_put(local_node);
 }
 
+int o2nm_depend_this_node(void)
+{
+	return o2nm_depend_node(o2nm_this_node());
+}
+
+void o2nm_undepend_this_node(void)
+{
+	o2nm_undepend_node(o2nm_this_node());
+}
+
 
 static void __exit exit_o2nm(void)
 {
 	/* XXX sync with hb callbacks and shut down hb? */
diff --git a/fs/ocfs2/cluster/nodemanager.h b/fs/ocfs2/cluster/nodemanager.h
index 3490e77a952d..39006005427b 100644
--- a/fs/ocfs2/cluster/nodemanager.h
+++ b/fs/ocfs2/cluster/nodemanager.h
@@ -64,8 +64,10 @@ void o2nm_node_get(struct o2nm_node *node);
 void o2nm_node_put(struct o2nm_node *node);
 
 int o2nm_depend_item(struct config_item *item);
 void o2nm_undepend_item(struct config_item *item);
+int o2nm_depend_node(u8 node_num);
+void o2nm_undepend_node(u8 node_num);
 int o2nm_depend_this_node(void);
 void o2nm_undepend_this_node(void);
 
 #endif /* O2CLUSTER_NODEMANAGER_H */
-- 
2.43.0
