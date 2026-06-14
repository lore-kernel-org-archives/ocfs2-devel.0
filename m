Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12FB271A71
	for <ocfs2-devel@lists.linux.dev>; Sun, 14 Jun 2026 05:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781415234; cv=none; b=nESEP8jliq2p95xKrg9sEJs2y2MYr9Rz9Hv8rF/mc+MhsMjcAORyjJTvwP7f5HX7+pzTDW1FtPj2HjPUbShouSDF72arACvATYjgLRY+uckSA3wIRy3llk8cK8XoUIseDrCFOj5jfU5LaKt5sd9B5p+yD4AGy0Br2/XSo/sx78Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781415234; c=relaxed/simple;
	bh=WDmz1jd/6f0EWFGd1kdwQdzBm93CDU8f7n6cm7pz13E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QI08cNiycguboCHiDfPgBxKPJCAUyjXoGAFQe+aO94dqEAM8WNylXkMnuEsDePXvDoMY2EZzZXudFsXRqBwRe86AUoErZgjG53PJDgY3XjaoDQZWtJ8rb7PcLEUX+THuscf8/DRDLIElj8VGOCo65v06ndJb70MGV9X12/xBH1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WQNQPe5V; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WQNQPe5V"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2c0c35980fdso23204175ad.2
        for <ocfs2-devel@lists.linux.dev>; Sat, 13 Jun 2026 22:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781415232; x=1782020032; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jR2/7XwJ/gGeva15G52MbY/z6y9ELj2+4dIObyRa35k=;
        b=WQNQPe5Vi5DNyC03xxDEZV4gP+9IBEfWqGMEj4bGV5i6EGoyTVoynmFHWut4+CHMDi
         PMaKnDmbh93c7ihzyMSRRDElingfge3AhlvMkAK0bzWWC/1Tjsb+zyaOI+o9s5wpEfvf
         fLjaKPXiMUmX2n+30N1ISdSSRJpHufYmTspIyBZMN/R5Gr8q0Bn9C0EUi+k35XbdiIqp
         j7AlNOvPw+zCTO6lHWMN/l5Ml2qf+ljomTbjpIY0zTrOHJkVCvTaX2Yu3vXYbEZikewM
         L30o/YHvEaEPzw9gs6cqLbgxVexyp5bU4XiqiHJ+Mc/cR/Ypw5FXSvdfNNgkiekudCIQ
         hO9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781415232; x=1782020032;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jR2/7XwJ/gGeva15G52MbY/z6y9ELj2+4dIObyRa35k=;
        b=LytXL6LL+PY7suRdnoP5aHATUNvM4G3a5RbDKB3UC+a5gx7ZmN+Fg6pxc/vd01IWao
         X8YJDOILdg4a7RRcHcY/FcUcOHHlTW97LJgHUPgEeXkT6LI1XRz1NC2zJU4mqEX2ul6R
         rwPJ/1EMKgpDpIJ7N/13eVoliDJfDp9Xn9y37Ikiakw8YSWgE0+QmqEQaMyvTsRxunV0
         k/IbxaSc+/oMoCJJ5OQma2xmKXzWJtioKlY9v7nuZVW4HDgI8RtQZz1m7NW5z5uclv9J
         jTio8JFQdlNoJoFiGReQZ1hzUTOejK+Ob4AKIsrqKNFMywpP5MlXZM2B/Y6q2N3AV2Ce
         eFAg==
X-Gm-Message-State: AOJu0YyL4OObNEaQUxX6aLyN8caAKn2iQR8j0xLO4UHg6ds8u05CLvZT
	Hsjm8DxN4jiKRQuSSCeUYsP6x3MOcyvbhMh543OlWNz276I+u2f2Aw0V
X-Gm-Gg: Acq92OEgDwhq2LPyM1zxyV2ruAecaMdw7DLYGR4EeMHkXOghReKxlBgCnGKnvFig9kd
	C1chImMqf/5Wv0/W6Zt72N2JEr4R4cgp4GkAtes2x+cX4DF5Z1TKYaGOm44/I6Pz+52v9lZxNhO
	Wm1S5pGm/Eqlt8hniwSB00mjINCW3B9qyhm7bmx94YHSmn3T/rwhmmtUjl3YkoJUdRl0YyjOrTx
	/lLxnIXgsXRwBsWkcc/xQZ6O8BVF22WtxOe09OttJG/THmjiWXj/f0HpckFRt7llGcGg63b0IJz
	2jDVf7xM6H+fH4G93WKATHLaV6zYnBg2XSElIAbB8vcVM03AkKOgkdrOe6fONBaQVOiaSRb1Sk0
	u4DL4CGWisSd6/0LcAR1Y4DZuMSi65ENXjRn65Xp0isn3tQTaJ+iIPZoFNom1JyltYAs21jqNLQ
	vo5HR6DVhax48B5Txa1w==
X-Received: by 2002:a17:902:c94f:b0:2c0:b319:fb43 with SMTP id d9443c01a7336-2c41235e4camr100310655ad.21.1781415232076;
        Sat, 13 Jun 2026 22:33:52 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c432e81a05sm63512405ad.64.2026.06.13.22.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 22:33:51 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	Cen Zhang <zzzccc427@gmail.com>
Subject: [PATCH] ocfs2/cluster: reject local node clears while heartbeat runs
Date: Sun, 14 Jun 2026 13:33:45 +0800
Message-Id: <20260614053345.64053-1-zzzccc427@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

o2nm_node_local_store() can clear the current local node while a
heartbeat region is still active. That path stops listening and stores
O2NM_INVALID_NODE_NUM, but heartbeat threads keep calling
o2nm_this_node() from o2hb_do_disk_heartbeat() and shutdown.

Once that happens, o2hb_check_own_slot() and o2hb_prepare_block() can
use node 255 as a slot index, and o2nm_undepend_this_node() can BUG_ON()
when the thread exits. The same local=0 path also leaves cl_has_local
set, so later attempts to restore a real local node fail with -EBUSY.

Track the heartbeat start/run/stop window with a per-region active flag
protected by o2hb_live_lock. Set it before kthread_run() can let the
heartbeat thread re-read o2nm_this_node(), and clear it only after
startup cleanup or region teardown has stopped any created thread. Then
reject local=0 while any region remains active, and when the clear is
allowed drop cl_has_local together with cl_local_node so the
nodemanager state matches o2nm_node_group_drop_item().

The buggy scenario involves two paths, with each column showing the
order within that path:

configfs local attribute store		heartbeat thread
1. Userspace writes 0 to the		1. o2hb_thread() keeps calling
   current node's local attribute.	   o2hb_do_disk_heartbeat().
2. o2nm_node_local_store()		2. o2hb_check_own_slot() and
   stops listening and stores		   o2hb_prepare_block() re-read
   O2NM_INVALID_NODE_NUM.		   o2nm_this_node().
3. cl_has_local still stays set,	3. The thread uses node 255 as
   so later o2nm_this_node()		   the local slot index or
   reports node 255.			   shutdown node number.
4. A later local=1 write hits		4. Heartbeat can touch
   -EBUSY.				   reg->hr_slots[255] or BUG_ON()
					   in o2nm_undepend_this_node().

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

Fixes: a7f6a5fb4bde ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
 fs/ocfs2/cluster/heartbeat.c   | 55 +++++++++++++++++++++++++++++++---
 fs/ocfs2/cluster/heartbeat.h   |  1 +
 fs/ocfs2/cluster/nodemanager.c | 13 ++++----
 fs/ocfs2/cluster/nodemanager.h |  3 ++
 4 files changed, 63 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index d12784aaaa4b..4c83f680017f 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -201,8 +201,9 @@ struct o2hb_region {
 				hr_item_dropped:1,
 				hr_node_deleted:1;
 
-	/* protected by the hr_callback_sem */
+	/* Protected by o2hb_live_lock. */
 	struct task_struct 	*hr_task;
+	bool			hr_heartbeat_active;
 
 	unsigned int		hr_blocks;
 	unsigned long long	hr_start_block;
@@ -1771,8 +1772,9 @@ static int o2hb_populate_slot_data(struct o2hb_region *reg)
 }
 
 /*
- * this is acting as commit; we set up all of hr_bdev_file and hr_task or
- * nothing
+ * This acts as commit.  The active flag covers the start/run/stop window and
+ * startup publishes it before rechecking the local node, so local=0 either
+ * sees heartbeat in progress or forces this path to fail before a thread runs.
  */
 static ssize_t o2hb_region_dev_store(struct config_item *item,
 				     const char *page,
@@ -1874,6 +1876,17 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 	/* unsteady_iterations is triple the steady_iterations */
 	atomic_set(&reg->hr_unsteady_iterations, (live_threshold * 3));
 
+	o2nm_lock_subsystem();
+	spin_lock(&o2hb_live_lock);
+	reg->hr_heartbeat_active = true;
+	spin_unlock(&o2hb_live_lock);
+	if (o2nm_this_node() == O2NM_MAX_NODES) {
+		o2nm_unlock_subsystem();
+		ret = -EINVAL;
+		goto out;
+	}
+	o2nm_unlock_subsystem();
+
 	hb_task = kthread_run(o2hb_thread, reg, "o2hb-%s",
 			      reg->hr_item.ci_name);
 	if (IS_ERR(hb_task)) {
@@ -1925,10 +1938,16 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 		spin_lock(&o2hb_live_lock);
 		hb_task = reg->hr_task;
 		reg->hr_task = NULL;
+		if (!hb_task)
+			reg->hr_heartbeat_active = false;
 		spin_unlock(&o2hb_live_lock);
 
-		if (hb_task)
+		if (hb_task) {
 			kthread_stop(hb_task);
+			spin_lock(&o2hb_live_lock);
+			reg->hr_heartbeat_active = false;
+			spin_unlock(&o2hb_live_lock);
+		}
 
 		o2hb_unmap_slot_data(reg);
 
@@ -2109,6 +2128,11 @@ static void o2hb_heartbeat_group_drop_item(struct config_group *group,
 	if (hb_task)
 		kthread_stop(hb_task);
 
+	spin_lock(&o2hb_live_lock);
+	if (hb_task)
+		reg->hr_heartbeat_active = false;
+	spin_unlock(&o2hb_live_lock);
+
 	if (o2hb_global_heartbeat_active()) {
 		spin_lock(&o2hb_live_lock);
 		clear_bit(reg->hr_region_num, o2hb_region_bitmap);
@@ -2571,6 +2595,29 @@ int o2hb_get_all_regions(char *region_uuids, u8 max_regions)
 }
 EXPORT_SYMBOL_GPL(o2hb_get_all_regions);
 
+/*
+ * The active flag covers the entire start/run/stop window in which a region
+ * may still have a heartbeat thread that can re-read o2nm_this_node().
+ */
+int o2hb_heartbeat_active(void)
+{
+	struct o2hb_region *reg;
+	int active = 0;
+
+	spin_lock(&o2hb_live_lock);
+
+	list_for_each_entry(reg, &o2hb_all_regions, hr_all_item) {
+		if (reg->hr_heartbeat_active) {
+			active = 1;
+			break;
+		}
+	}
+
+	spin_unlock(&o2hb_live_lock);
+
+	return active;
+}
+
 int o2hb_global_heartbeat_active(void)
 {
 	return (o2hb_heartbeat_mode == O2HB_HEARTBEAT_GLOBAL);
diff --git a/fs/ocfs2/cluster/heartbeat.h b/fs/ocfs2/cluster/heartbeat.h
index 8ef8c1b9eeb7..7040dc4b529d 100644
--- a/fs/ocfs2/cluster/heartbeat.h
+++ b/fs/ocfs2/cluster/heartbeat.h
@@ -66,6 +66,7 @@ int o2hb_check_node_heartbeating_no_sem(u8 node_num);
 int o2hb_check_node_heartbeating_from_callback(u8 node_num);
 void o2hb_stop_all_regions(void);
 int o2hb_get_all_regions(char *region_uuids, u8 numregions);
+int o2hb_heartbeat_active(void);
 int o2hb_global_heartbeat_active(void);
 
 #endif /* O2CLUSTER_HEARTBEAT_H */
diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index 402563154550..ffe9cb37d9e5 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -25,9 +25,6 @@ static const char *o2nm_fence_method_desc[O2NM_FENCE_METHODS] = {
 	"panic",	/* O2NM_FENCE_PANIC */
 };
 
-static inline void o2nm_lock_subsystem(void);
-static inline void o2nm_unlock_subsystem(void);
-
 struct o2nm_node *o2nm_get_node_by_num(u8 node_num)
 {
 	struct o2nm_node *node = NULL;
@@ -366,7 +363,13 @@ static ssize_t o2nm_node_local_store(struct config_item *item, const char *page,
 
 	if (!tmp && cluster->cl_has_local &&
 	    cluster->cl_local_node == node->nd_num) {
+		if (o2hb_heartbeat_active()) {
+			ret = -EBUSY;
+			goto out;
+		}
+
 		o2net_stop_listening(node);
+		cluster->cl_has_local = 0;
 		cluster->cl_local_node = O2NM_INVALID_NODE_NUM;
 	}
 
@@ -762,12 +765,12 @@ static struct o2nm_cluster_group o2nm_cluster_group = {
 	},
 };
 
-static inline void o2nm_lock_subsystem(void)
+void o2nm_lock_subsystem(void)
 {
 	mutex_lock(&o2nm_cluster_group.cs_subsys.su_mutex);
 }
 
-static inline void o2nm_unlock_subsystem(void)
+void o2nm_unlock_subsystem(void)
 {
 	mutex_unlock(&o2nm_cluster_group.cs_subsys.su_mutex);
 }
diff --git a/fs/ocfs2/cluster/nodemanager.h b/fs/ocfs2/cluster/nodemanager.h
index 3490e77a952d..96c0abb1f127 100644
--- a/fs/ocfs2/cluster/nodemanager.h
+++ b/fs/ocfs2/cluster/nodemanager.h
@@ -63,6 +63,9 @@ struct o2nm_node *o2nm_get_node_by_ip(__be32 addr);
 void o2nm_node_get(struct o2nm_node *node);
 void o2nm_node_put(struct o2nm_node *node);
 
+void o2nm_lock_subsystem(void);
+void o2nm_unlock_subsystem(void);
+
 int o2nm_depend_item(struct config_item *item);
 void o2nm_undepend_item(struct config_item *item);
 int o2nm_depend_this_node(void);
-- 
2.43.0

