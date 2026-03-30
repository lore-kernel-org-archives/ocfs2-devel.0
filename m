Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334552E7BD3
	for <ocfs2-devel@lists.linux.dev>; Mon, 30 Mar 2026 15:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774884901; cv=none; b=O6Bzi2tWOGZ9d45GqoQieAb105H/KdgFINWObxOkeV1yc1uHVyYpnSuwo1q5rllvU/ysGzVqUfzSa0K58kFG3JETcI+pYUV23BiyB8B1iXUuPA28O96ygIhqhQwT5icjR1vYnMzx8Y2T0BlUtPsqUvp33HeQZRGNqZg9kMY/Mso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774884901; c=relaxed/simple;
	bh=vjn6Ceu6ZwFiS0rhgLdDMOfk8nkhN44uMDy1G++48hk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ShwEvwp/hUgAcNvjyQravBXQL+IL27nVqXpCDyHszo8dNa/IQ8JcWqARvznoqlQNyhkKJ9441S4RoS0KWj+7w7cdCAH/c+p/9Ym3XJNE6gN9rWW0IN9KoGaP+aoiqUjCUjOtwG0jgRCRU/LJ7RUXk5u4ouapoDMEt9FKRb0GJug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mbnMZZuS; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mbnMZZuS"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774884897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4pR3qvaYypeH/YSaK48K9lnyMZEmt/gVAMGvxZinvuk=;
	b=mbnMZZuSfDK29nFN5bInuBIhaEW8iwman90DXXtHMvZEtjroSKEO7ZwjjSR33slMdHOex8
	k4Oe6puTp4Bkcb9e9lawVbah6sCSlmJKFqiwBYJea212n5QNyBp+2Lz6CxxUhjNKquvOFK
	iEJHYmEe4ORBCrlVNSoRxs/AgBvCh6w=
From: Yufan Chen <yufan.chen@linux.dev>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] ocfs2/heartbeat: fix slot mapping rollback leaks on error paths
Date: Mon, 30 Mar 2026 23:34:28 +0800
Message-ID: <20260330153428.19586-1-yufan.chen@linux.dev>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6290; i=ericterminal@gmail.com; h=from:subject; bh=jivq/B/R2IDUbI2Fb1T9JVy7CA1asvM4rw4doDwtyio=; b=owGbwMvMwCXWM/dCzeS3H+sZT6slMWSemhYX5bjuSl2e965E34TcwDqp6OkneT508vRmLWwRc lycLnW+YyILgxgXg6WYIsvd//vm5nrdmnOd+3AuzBxWJpAh0iINDEDAwsCXm5hXaqRjpGeqbahn aKRjoGPMwMUpAFP9Q5yRoU29o4E7UHFrYmz4P72fLD+7f+4QjPFkOv1E4pfq1WdMtxn+p9ze1vu SbQv3Ez738sA1Tw9m5Nw/u7Pil9iee4s40iqV2QA=
X-Developer-Key: i=ericterminal@gmail.com; a=openpgp; fpr=DDFFBE9D6D4ADA9CD70BC36D8C9DD07C93EDF17F
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Yufan Chen <ericterminal@gmail.com>

o2hb_map_slot_data() allocates hr_tmp_block, hr_slots,
hr_slot_data, and pages in stages. If a later allocation fails, the
current code returns without unwinding the earlier allocations.

o2hb_region_dev_store() also leaves slot mapping resources behind when
setup aborts, and it keeps hr_aborted_start/hr_node_deleted set across
retries. That leaves stale state behind after a failed start.

Factor the slot cleanup into o2hb_unmap_slot_data(), use it from both
o2hb_map_slot_data() and o2hb_region_release(), and call it from the
dev_store() rollback after stopping a started heartbeat thread. While
freeing pages, clear each hr_slot_data entry as it is released, and
reset the start state before each new setup attempt.

This closes the slot mapping leak on allocation/setup failure paths
and keeps failed setup attempts retryable.

Signed-off-by: Yufan Chen <ericterminal@gmail.com>
---
 fs/ocfs2/cluster/heartbeat.c | 83 ++++++++++++++++++++++++------------
 1 file changed, 56 insertions(+), 27 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index fe1949578..d12784aaa 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1488,33 +1488,45 @@ static struct o2hb_region *to_o2hb_region(struct config_item *item)
 	return item ? container_of(item, struct o2hb_region, hr_item) : NULL;
 }
 
-/* drop_item only drops its ref after killing the thread, nothing should
- * be using the region anymore.  this has to clean up any state that
- * attributes might have built up. */
-static void o2hb_region_release(struct config_item *item)
+static void o2hb_unmap_slot_data(struct o2hb_region *reg)
 {
 	int i;
 	struct page *page;
-	struct o2hb_region *reg = to_o2hb_region(item);
-
-	mlog(ML_HEARTBEAT, "hb region release (%pg)\n", reg_bdev(reg));
-
-	kfree(reg->hr_tmp_block);
 
 	if (reg->hr_slot_data) {
 		for (i = 0; i < reg->hr_num_pages; i++) {
 			page = reg->hr_slot_data[i];
-			if (page)
+			if (page) {
 				__free_page(page);
+				reg->hr_slot_data[i] = NULL;
+			}
 		}
 		kfree(reg->hr_slot_data);
+		reg->hr_slot_data = NULL;
 	}
 
+	kfree(reg->hr_slots);
+	reg->hr_slots = NULL;
+
+	kfree(reg->hr_tmp_block);
+	reg->hr_tmp_block = NULL;
+}
+
+/* drop_item only drops its ref after killing the thread, nothing should
+ * be using the region anymore.  this has to clean up any state that
+ * attributes might have built up.
+ */
+static void o2hb_region_release(struct config_item *item)
+{
+	struct o2hb_region *reg = to_o2hb_region(item);
+
+	mlog(ML_HEARTBEAT, "hb region release (%pg)\n", reg_bdev(reg));
+
+	o2hb_unmap_slot_data(reg);
+
 	if (reg->hr_bdev_file)
 		fput(reg->hr_bdev_file);
 
-	kfree(reg->hr_slots);
-
 	debugfs_remove_recursive(reg->hr_debug_dir);
 	kfree(reg->hr_db_livenodes);
 	kfree(reg->hr_db_regnum);
@@ -1667,6 +1679,7 @@ static void o2hb_init_region_params(struct o2hb_region *reg)
 static int o2hb_map_slot_data(struct o2hb_region *reg)
 {
 	int i, j;
+	int ret = -ENOMEM;
 	unsigned int last_slot;
 	unsigned int spp = reg->hr_slots_per_page;
 	struct page *page;
@@ -1674,14 +1687,14 @@ static int o2hb_map_slot_data(struct o2hb_region *reg)
 	struct o2hb_disk_slot *slot;
 
 	reg->hr_tmp_block = kmalloc(reg->hr_block_bytes, GFP_KERNEL);
-	if (reg->hr_tmp_block == NULL)
-		return -ENOMEM;
+	if (!reg->hr_tmp_block)
+		goto out;
 
 	reg->hr_slots = kzalloc_objs(struct o2hb_disk_slot, reg->hr_blocks);
-	if (reg->hr_slots == NULL)
-		return -ENOMEM;
+	if (!reg->hr_slots)
+		goto out;
 
-	for(i = 0; i < reg->hr_blocks; i++) {
+	for (i = 0; i < reg->hr_blocks; i++) {
 		slot = &reg->hr_slots[i];
 		slot->ds_node_num = i;
 		INIT_LIST_HEAD(&slot->ds_live_item);
@@ -1695,12 +1708,12 @@ static int o2hb_map_slot_data(struct o2hb_region *reg)
 
 	reg->hr_slot_data = kzalloc_objs(struct page *, reg->hr_num_pages);
 	if (!reg->hr_slot_data)
-		return -ENOMEM;
+		goto out;
 
-	for(i = 0; i < reg->hr_num_pages; i++) {
+	for (i = 0; i < reg->hr_num_pages; i++) {
 		page = alloc_page(GFP_KERNEL);
 		if (!page)
-			return -ENOMEM;
+			goto out;
 
 		reg->hr_slot_data[i] = page;
 
@@ -1720,6 +1733,10 @@ static int o2hb_map_slot_data(struct o2hb_region *reg)
 	}
 
 	return 0;
+
+out:
+	o2hb_unmap_slot_data(reg);
+	return ret;
 }
 
 /* Read in all the slots available and populate the tracking
@@ -1809,9 +1826,11 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 		     "blocksize %u incorrect for device, expected %d",
 		     reg->hr_block_bytes, sectsize);
 		ret = -EINVAL;
-		goto out3;
+		goto out;
 	}
 
+	reg->hr_aborted_start = 0;
+	reg->hr_node_deleted = 0;
 	o2hb_init_region_params(reg);
 
 	/* Generation of zero is invalid */
@@ -1823,13 +1842,13 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 	ret = o2hb_map_slot_data(reg);
 	if (ret) {
 		mlog_errno(ret);
-		goto out3;
+		goto out;
 	}
 
 	ret = o2hb_populate_slot_data(reg);
 	if (ret) {
 		mlog_errno(ret);
-		goto out3;
+		goto out;
 	}
 
 	INIT_DELAYED_WORK(&reg->hr_write_timeout_work, o2hb_write_timeout);
@@ -1860,7 +1879,7 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 	if (IS_ERR(hb_task)) {
 		ret = PTR_ERR(hb_task);
 		mlog_errno(ret);
-		goto out3;
+		goto out;
 	}
 
 	spin_lock(&o2hb_live_lock);
@@ -1877,12 +1896,12 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 
 	if (reg->hr_aborted_start) {
 		ret = -EIO;
-		goto out3;
+		goto out;
 	}
 
 	if (reg->hr_node_deleted) {
 		ret = -EINVAL;
-		goto out3;
+		goto out;
 	}
 
 	/* Ok, we were woken.  Make sure it wasn't by drop_item() */
@@ -1901,8 +1920,18 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 		printk(KERN_NOTICE "o2hb: Heartbeat started on region %s (%pg)\n",
 		       config_item_name(&reg->hr_item), reg_bdev(reg));
 
-out3:
+out:
 	if (ret < 0) {
+		spin_lock(&o2hb_live_lock);
+		hb_task = reg->hr_task;
+		reg->hr_task = NULL;
+		spin_unlock(&o2hb_live_lock);
+
+		if (hb_task)
+			kthread_stop(hb_task);
+
+		o2hb_unmap_slot_data(reg);
+
 		fput(reg->hr_bdev_file);
 		reg->hr_bdev_file = NULL;
 	}
-- 
2.47.3

