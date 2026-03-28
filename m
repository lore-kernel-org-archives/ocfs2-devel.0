Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8D725EF87
	for <ocfs2-devel@lists.linux.dev>; Sat, 28 Mar 2026 09:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774689832; cv=none; b=VnEVEE3FiJiuQXbldrsLh2J26XDM+Cb0K4MKWsGwxVd5+2n+a1/QnrpIIiQ38y2/5Grcyzqj/95r/Uq82+Z/jymFXeuROhYoZXPgkd1KkABHTRYPIoILiawwXBqNU9+fG0dL+wGNh4hOdiVO3/Nsj8GWrb6wdO+Kp8IoamwfyNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774689832; c=relaxed/simple;
	bh=n+/ko9WnqhGa6irCZS9OhHG1C9YFxFiPMFkjKIznaDU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EzesjHLVpJZCYT2PBy4rbyQULiud5O8q0Z/elFRP4s8/t8kbNCq2U84iTT1TUvuG1LySxP/VTVscHTq0b4hOBv1uDHhc3BOQdzP+En41hK65/vDpzocRNie8S8JzY5B06jl5J/klQkVEgsTOmnuC2TABzaXWNtyEWijMX7EjJzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cZ4YKimE; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cZ4YKimE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774689828;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oMwRq5HnS+78DwQUlqC1Tm5QUKwvNs03NfwdMzwehuI=;
	b=cZ4YKimESZuso/j1XQXM9keaH81rMt2E/YlFqxKHFwGEtW+MsGyavc4XdZ09RLkGmDCoA+
	3obf224Tgq2L9dCc06f590XBNloYG783owDw7KZY6Nq3s2F3KrSmTnPczcwzbIK1X+W67x
	EDoxHsX/Jb76icij++/zsaU+z80m660=
From: Yufan Chen <yufan.chen@linux.dev>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: yufan.chen@linux.dev,
	Yufan Chen <ericterminal@gmail.com>
Subject: [PATCH] ocfs2/heartbeat: fix slot mapping rollback leaks on error paths
Date: Sat, 28 Mar 2026 17:23:39 +0800
Message-ID: <20260328092339.75306-1-yufan.chen@linux.dev>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4754; i=ericterminal@gmail.com; h=from:subject; bh=qcdY096lMznJ2ikeq8Den44mbzGNepyRr/kPQoTEyh4=; b=owGbwMvMwCXWM/dCzeS3H+sZT6slMWQen8PS1MWTN5W/5tw8vzcRV0PsdDLXyLXue3JFsuq7U PzaChfLjoksDGJcDJZiiix3/++bm+t1a8517sO5MHNYmUCGSIs0MAABCwNfbmJeqZGOkZ6ptqGe oZGOgY4xAxenAEz1ZCmGf1b+gj5bpiYJzwrtnKUZGl+0/2JtZnl2TiOfQmrXE4UT2Qx/xb6tN24 VtNScfFbmtPnR89EnTPkiUyc9yjxUOfHYk1m2XAA=
X-Developer-Key: i=ericterminal@gmail.com; a=openpgp; fpr=DDFFBE9D6D4ADA9CD70BC36D8C9DD07C93EDF17F
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Yufan Chen <ericterminal@gmail.com>

o2hb_map_slot_data() allocated hr_tmp_block, hr_slots, hr_slot_data, and pages in stages but returned directly on allocation failures without unwinding previously allocated resources. Under repeated allocation failures this could leak memory and increase pressure toward OOM.

o2hb_region_dev_store() also failed to roll back slot mapping resources when setup aborted, leaving stale allocations around retry attempts.

Introduce o2hb_unmap_slot_data() as a single reverse-order cleanup helper, switch o2hb_map_slot_data() to a centralized goto-based error exit, and call the same rollback path from o2hb_region_dev_store() after stopping a possibly started heartbeat thread. This ensures failed setup fully releases resources and remains safely retryable.

Signed-off-by: Yufan Chen <ericterminal@gmail.com>
---
 fs/ocfs2/cluster/heartbeat.c | 64 +++++++++++++++++++++++++-----------
 1 file changed, 45 insertions(+), 19 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index fe1949578..2f82040f4 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1488,18 +1488,10 @@ static struct o2hb_region *to_o2hb_region(struct config_item *item)
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
@@ -1508,13 +1500,32 @@ static void o2hb_region_release(struct config_item *item)
 				__free_page(page);
 		}
 		kfree(reg->hr_slot_data);
+		reg->hr_slot_data = NULL;
 	}
 
+	kfree(reg->hr_slots);
+	reg->hr_slots = NULL;
+
+	kfree(reg->hr_tmp_block);
+	reg->hr_tmp_block = NULL;
+	reg->hr_num_pages = 0;
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
@@ -1667,6 +1678,7 @@ static void o2hb_init_region_params(struct o2hb_region *reg)
 static int o2hb_map_slot_data(struct o2hb_region *reg)
 {
 	int i, j;
+	int ret = -ENOMEM;
 	unsigned int last_slot;
 	unsigned int spp = reg->hr_slots_per_page;
 	struct page *page;
@@ -1674,14 +1686,14 @@ static int o2hb_map_slot_data(struct o2hb_region *reg)
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
@@ -1695,12 +1707,12 @@ static int o2hb_map_slot_data(struct o2hb_region *reg)
 
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
 
@@ -1720,6 +1732,10 @@ static int o2hb_map_slot_data(struct o2hb_region *reg)
 	}
 
 	return 0;
+
+out:
+	o2hb_unmap_slot_data(reg);
+	return ret;
 }
 
 /* Read in all the slots available and populate the tracking
@@ -1903,6 +1919,16 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 
 out3:
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

