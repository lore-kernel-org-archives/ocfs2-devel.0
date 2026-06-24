Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C80D3A0EA2
	for <ocfs2-devel@lists.linux.dev>; Wed, 24 Jun 2026 09:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782294806; cv=none; b=XNo6Go3hk8qQVotrnPqjO8e8zzrtZ6tzcAuIvS04xegfc3N8k6s329m3DU5eeCOvuU8uTG8ifrvK+h+0MV7baoHx2Jjg3csvhrPNqDjJgBymTa+ksQya/jq8pUNezYePRpE+totcVv0c84NQkDjRacKa+ibAynV6DSWwA399y+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782294806; c=relaxed/simple;
	bh=Z5efhBZU+3iOqeTIpeB6ugeIAsjAHDfYythXW4YcnNo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YuktjtyI1GpjtdcpQyOEWGHxRz/k7xiz+7+ajt4gLk+jVJ9wDyU/ELwLM4jvQu3/sVA2OFPlUtlO82y0HGc3if5850p04DFxKGqcw09Ranm8hCj3nqIGXsUw70dSNcQEFhdxMC0smjo4mLkZZEQ+kV4a5zpM8IkSlMzKYWBJusA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NX3WV1uX; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NX3WV1uX"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-37da8b5540bso572118a91.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 24 Jun 2026 02:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782294801; x=1782899601; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J5WP/l8UGQCYrWSnPh6hR24kvVy7qJLQ9iU0qLQ9980=;
        b=NX3WV1uXlDGcewj3N8C4bG7QtOFtQ8MqDNJpGESx/eDFD1XLVWcecJQBt0mVh57LVM
         tDUxLppg6TIdkRAGsQ5kmncU8dQzONJnsqVess9EWum9S0xE6zkxK+aILjEPZZ4pG65v
         7RL17uthftdXWpPNpkZEvR0j/gSUm8bxBrI7WBvqaFUVHyTb1kKzTVU7UNnWsWVUCz5m
         S51jCuOkaLclrRG2Krj66nC4no7dCsXhrWwygNhb8ofvfeBVPd6c2Z1kkPcH8T/yXVMA
         ToBzmT/IkmAeCWeAjFErAkdKydVmMvaSN3ZQ5Sz3+Seq5cH/jLRwBDWX1N5EOGbaiW1g
         SZHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782294801; x=1782899601;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=J5WP/l8UGQCYrWSnPh6hR24kvVy7qJLQ9iU0qLQ9980=;
        b=aczXcPgztDgBEyhx4qwnHOlb03qmqm9iGFsjaC5zBObeBAxuAO/C5bnR9W0ECHC3Wk
         4UKTU+0P+VTiCtDKMSwKYbiCGTt3qesP0/XOiSiqJij1dSqlI3v3xHf0oxXQwSrOhwQB
         FK+/a+w19xpnRgW+lghJMNaJ/hFFB38icl7bJks3Dxpw58RyfCcCeu92Ue721lwexdcJ
         5skPkVMTfbsRWtVrCy66Y4YVq5++NcBnu4Yo/XOx/pE9qyJAMh3NA55N1Eoh5GVwzukP
         c6bdPtssz1Qz3rM2jK+gqYKV9qem9VNYENU3tA+JPx7q9KeHB+838uyIcbGEVSxqFqzT
         ElZw==
X-Forwarded-Encrypted: i=1; AHgh+Rqdl8rL7HDcGzP9b9gxF7h8NxD2FafkNfgCcoPs4oPwGcCsHjyDxGU+y5WMkauS4Piyj5Wp76RfT0+6gA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzYEtbigDkWGrOeyQ+6s0cPXj3J+UehRdDSLkUDhVeCO4Z4DuAb
	ZTVQ01Kk2QiIJik1v6QX/Ls1b6G9uNbEeWjfh/X/nd953Zg3fVpDLGEB
X-Gm-Gg: AfdE7cn007L+i/McpvNRTbq9zgcr8AxA6ljyKR5ZeAFl3Af3UkM9yW3Ek14BXzzq0fG
	BJ+Q2Huyc0zFA1c/+EOrkiJT7sw2PJyy3B0g4nncbNG3jt0NkttmKcNU67uYMb3GEXMtf7dArA9
	Cdh5MMgJqnT8u/M4YAdLnQ8c65g/6t9LboegkfleA7B5+Med2yU3h+2kz+zTTNYkAhs3CRckTgA
	1j/XgYVE5UBKWeinsSPbQAlcDz53DzvApa2ILDAyXqkBRCXscnTu/h2PLmbn1C0vy4kFzuXlUY2
	EemxG+f4mJf/+jE4MOO3BqJe7dC6q1IHBpBhHLZN+j87/mer5+9Q2l3o62CqcHhUt8lMjhRFIkO
	cdMGug8nzgculCPrjOR7R2wYbGoGtx+CS9pq8xhPZdPaYQySkBHRIkXxDD8kfjl3rR8i/3XLUPz
	zPQMoyp+/xg3kK4DFk+w==
X-Received: by 2002:a17:90b:4d06:b0:36b:b1f4:e0ac with SMTP id 98e67ed59e1d1-37de423a22fmr2499634a91.14.1782294801105;
        Wed, 24 Jun 2026 02:53:21 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37de3ce544dsm2247634a91.9.2026.06.24.02.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 02:53:20 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	zzzccc427@gmail.com
Subject: [PATCH 1/2] ocfs2: synchronize heartbeat callbacks with o2net teardown
Date: Wed, 24 Jun 2026 17:53:09 +0800
Message-Id: <20260624095310.763763-2-zzzccc427@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260624095310.763763-1-zzzccc427@gmail.com>
References: <20260624095310.763763-1-zzzccc427@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Heartbeat callbacks stay registered while configfs local-node teardown
enters o2net_stop_listening(). A node-down event can still run through
o2net_disconnect_node() and o2net_set_nn_state() while teardown is
destroying o2net_wq, so the later queue/flush operations can hit a dead
workqueue. KASAN has caught this as a slab-use-after-free in
__queue_work() with the call chain:

KASAN slab-use-after-free in __queue_work+0x56/0xa90
Read of size 4
Call trace:
  dump_stack_lvl+0x66/0xa0
  print_report+0xce/0x630
  __queue_work+0x56/0xa90
  srso_alias_return_thunk+0x5/0xfbef5
  __virt_addr_valid+0x19f/0x330
  kasan_report+0xe0/0x110
  __queue_delayed_work+0x58/0x1e0
  queue_delayed_work_on+0xb4/0xc0
  o2net_set_nn_state+0x467/0x840
  o2net_disconnect_node+0x7b/0xe0
  o2net_hb_node_down_cb+0x54/0x60
  o2hb_run_event_list+0x236/0x2d0
  o2hb_check_slot+0xad4/0xbc0
  lock_release+0xc8/0x290
  o2hb_check_slot+0x9ea/0xbc0
  trace_hardirqs_on+0x18/0x130
  o2hb_do_disk_heartbeat+0x646/0xb30 (fs/ocfs2/cluster/heartbeat.c:1079)
  __lock_acquire+0x466/0x2260
  lockdep_hardirqs_on_prepare+0xea/0x1a0
  ktime_get_with_offset+0xe9/0x230
  o2hb_thread+0x14e/0x770
  kthread+0x1ad/0x1f0
  ret_from_fork+0x3c9/0x540
  __switch_to+0x2e9/0x730
  ret_from_fork_asm+0x1a/0x30
Allocated by task stack:
  kasan_save_stack+0x33/0x60
  kasan_save_track+0x14/0x30
  __kasan_kmalloc+0xaa/0xb0
  __kmalloc_noprof+0x292/0x760
  __alloc_workqueue+0x736/0xc60
  alloc_workqueue_noprof+0xb1/0x110
  o2net_start_listening+0xe5/0x430
  o2nm_node_local_store+0x184/0x310
  configfs_write_iter+0x18a/0x210
  vfs_write+0x469/0x810
  ksys_write+0xd2/0x170
  do_syscall_64+0x115/0x6a0 (arch/x86/entry/syscall_64.c:87)
  entry_SYSCALL_64_after_hwframe+0x77/0x7f
Freed by task stack:
  kasan_save_stack+0x33/0x60
  kasan_save_track+0x14/0x30
  kasan_save_free_info+0x3b/0x60
  __kasan_slab_free+0x5f/0x80
  kfree+0x313/0x590
  rcu_core+0x4f4/0x1320
  handle_softirqs+0x156/0x660

queue_delayed_work_on
o2net_set_nn_state
o2net_disconnect_node
o2net_hb_node_down_cb
o2hb_run_event_list

Keep heartbeat callbacks registered so quorum state still tracks node
state, but stop them from driving o2net reconnect/disconnect work once
local teardown starts. Mark the transport offline before destroying
o2net_wq, wait for any in-flight heartbeat callback to finish, and delay
bring-up replay until the new local node is published through
o2nm_this_node().

The replay also has to stay serialized with heartbeat callback delivery.
Otherwise a live-node snapshot can be copied, a real hb_down callback
can install -ENOTCONN for a peer, and the stale replay can call
o2net_hb_node_up() for that same peer and queue reconnect work even
though heartbeat is already down.

The buggy scenario involves two paths, with each column showing the order
within that path:

local-node teardown:                 heartbeat node-down callback:
1. configfs local-off enters         1. o2hb_run_event_list() invokes
   o2net_stop_listening().              o2net_hb_node_down_cb().
2. teardown heads for                2. the callback reaches
   destroy_workqueue(o2net_wq).         o2net_disconnect_node() and
                                        o2net_set_nn_state().
3. teardown destroys and NULLs       3. the callback flushes or queues
   o2net_wq.                            work through o2net_wq.

Fixes: 98211489d414 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
 fs/ocfs2/cluster/heartbeat.c   | 43 ++++++++++++++----
 fs/ocfs2/cluster/heartbeat.h   |  5 ++
 fs/ocfs2/cluster/nodemanager.c |  4 ++
 fs/ocfs2/cluster/tcp.c         | 83 +++++++++++++++++++++++++++-------
 fs/ocfs2/cluster/tcp.h         |  1 +
 5 files changed, 109 insertions(+), 27 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 6da96a374fcd..76e0c687bcbd 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1469,13 +1469,38 @@ void o2hb_init(void)
 	o2hb_debug_init();
 }
 
-/* if we're already in a callback then we're already serialized by the sem */
-static void o2hb_fill_node_map_from_callback(unsigned long *map,
-					     unsigned int bits)
+static void __o2hb_fill_node_map(unsigned long *map, unsigned int bits)
 {
 	bitmap_copy(map, o2hb_live_node_bitmap, bits);
 }
 
+void o2hb_callback_read_lock(void)
+{
+	down_read(&o2hb_callback_sem);
+}
+
+void o2hb_callback_read_unlock(void)
+{
+	up_read(&o2hb_callback_sem);
+}
+
+void o2hb_synchronize_callbacks(void)
+{
+	down_write(&o2hb_callback_sem);
+	up_write(&o2hb_callback_sem);
+}
+
+/*
+ * Callers must already hold o2hb_callback_sem for read or write so the copy
+ * stays serialized with callback delivery.
+ */
+void o2hb_fill_node_map_locked(unsigned long *map, unsigned int bits)
+{
+	spin_lock(&o2hb_live_lock);
+	__o2hb_fill_node_map(map, bits);
+	spin_unlock(&o2hb_live_lock);
+}
+
 /*
  * get a map of all nodes that are heartbeating in any regions
  */
@@ -1483,11 +1508,9 @@ void o2hb_fill_node_map(unsigned long *map, unsigned int bits)
 {
 	/* callers want to serialize this map and callbacks so that they
 	 * can trust that they don't miss nodes coming to the party */
-	down_read(&o2hb_callback_sem);
-	spin_lock(&o2hb_live_lock);
-	o2hb_fill_node_map_from_callback(map, bits);
-	spin_unlock(&o2hb_live_lock);
-	up_read(&o2hb_callback_sem);
+	o2hb_callback_read_lock();
+	o2hb_fill_node_map_locked(map, bits);
+	o2hb_callback_read_unlock();
 }
 EXPORT_SYMBOL_GPL(o2hb_fill_node_map);
 
@@ -2510,7 +2533,7 @@ int o2hb_check_node_heartbeating_no_sem(u8 node_num)
 	unsigned long testing_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
 
 	spin_lock(&o2hb_live_lock);
-	o2hb_fill_node_map_from_callback(testing_map, O2NM_MAX_NODES);
+	__o2hb_fill_node_map(testing_map, O2NM_MAX_NODES);
 	spin_unlock(&o2hb_live_lock);
 	if (!test_bit(node_num, testing_map)) {
 		mlog(ML_HEARTBEAT,
@@ -2527,7 +2550,7 @@ int o2hb_check_node_heartbeating_from_callback(u8 node_num)
 {
 	unsigned long testing_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
 
-	o2hb_fill_node_map_from_callback(testing_map, O2NM_MAX_NODES);
+	o2hb_fill_node_map_locked(testing_map, O2NM_MAX_NODES);
 	if (!test_bit(node_num, testing_map)) {
 		mlog(ML_HEARTBEAT,
 		     "node (%u) does not have heartbeating enabled.\n",
diff --git a/fs/ocfs2/cluster/heartbeat.h b/fs/ocfs2/cluster/heartbeat.h
index 8ef8c1b9eeb7..2ca2b657583c 100644
--- a/fs/ocfs2/cluster/heartbeat.h
+++ b/fs/ocfs2/cluster/heartbeat.h
@@ -58,6 +58,11 @@ int o2hb_register_callback(const char *region_uuid,
 			   struct o2hb_callback_func *hc);
 void o2hb_unregister_callback(const char *region_uuid,
 			      struct o2hb_callback_func *hc);
+void o2hb_callback_read_lock(void);
+void o2hb_callback_read_unlock(void);
+void o2hb_synchronize_callbacks(void);
+void o2hb_fill_node_map_locked(unsigned long *map,
+			       unsigned int bits);
 void o2hb_fill_node_map(unsigned long *map,
 			unsigned int bits);
 void o2hb_exit(void);
diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index e1f8f577ce5d..fc1e804d1fd1 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -326,6 +326,7 @@ static ssize_t o2nm_node_local_store(struct config_item *item, const char *page,
 	struct o2nm_node *node = to_o2nm_node(item);
 	struct o2nm_cluster *cluster;
 	unsigned long tmp;
+	bool starting = false;
 	char *p = (char *)page;
 	ssize_t ret;
 
@@ -362,6 +363,7 @@ static ssize_t o2nm_node_local_store(struct config_item *item, const char *page,
 		ret = o2net_start_listening(node);
 		if (ret)
 			goto out;
+		starting = true;
 	}
 
 	if (!tmp && cluster->cl_has_local &&
@@ -375,6 +377,8 @@ static ssize_t o2nm_node_local_store(struct config_item *item, const char *page,
 	if (node->nd_local) {
 		cluster->cl_has_local = tmp;
 		cluster->cl_local_node = node->nd_num;
+		if (starting)
+			o2net_complete_start_listening(node);
 	}
 
 	ret = count;
diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 09a1f3b77bb8..e62c1ef8223b 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -105,6 +105,8 @@ static struct socket *o2net_listen_sock;
  * destroying the work queue.
  */
 static struct workqueue_struct *o2net_wq;
+/* Heartbeat callbacks stay registered across local-node off/on. */
+static bool o2net_listening;
 static struct work_struct o2net_listen_work;
 
 static struct o2hb_callback_func o2net_hb_up, o2net_hb_down;
@@ -1692,6 +1694,19 @@ static void o2net_still_up(struct work_struct *work)
 
 /* ------------------------------------------------------------ */
 
+static void o2net_hb_node_up(struct o2net_node *nn)
+{
+	/* ensure an immediate connect attempt */
+	nn->nn_last_connect_attempt = jiffies -
+		(msecs_to_jiffies(o2net_reconnect_delay()) + 1);
+
+	spin_lock(&nn->nn_lock);
+	atomic_set(&nn->nn_timeout, 0);
+	if (nn->nn_persistent_error)
+		o2net_set_nn_state(nn, NULL, 0, 0);
+	spin_unlock(&nn->nn_lock);
+}
+
 void o2net_disconnect_node(struct o2nm_node *node)
 {
 	struct o2net_node *nn = o2net_nn_from_num(node->nd_num);
@@ -1713,41 +1728,39 @@ void o2net_disconnect_node(struct o2nm_node *node)
 static void o2net_hb_node_down_cb(struct o2nm_node *node, int node_num,
 				  void *data)
 {
+	u8 this_node;
+
 	o2quo_hb_down(node_num);
 
 	if (!node)
-		return;
+		goto out;
 
-	if (node_num != o2nm_this_node())
+	this_node = o2nm_this_node();
+	if (!READ_ONCE(o2net_listening) || this_node == O2NM_MAX_NODES)
+		goto out;
+
+	if (node_num != this_node)
 		o2net_disconnect_node(node);
 
+out:
 	BUG_ON(atomic_read(&o2net_connected_peers) < 0);
 }
 
 static void o2net_hb_node_up_cb(struct o2nm_node *node, int node_num,
 				void *data)
 {
-	struct o2net_node *nn = o2net_nn_from_num(node_num);
+	u8 this_node;
 
 	o2quo_hb_up(node_num);
 
 	BUG_ON(!node);
 
-	/* ensure an immediate connect attempt */
-	nn->nn_last_connect_attempt = jiffies -
-		(msecs_to_jiffies(o2net_reconnect_delay()) + 1);
+	this_node = o2nm_this_node();
+	if (!READ_ONCE(o2net_listening) || this_node == O2NM_MAX_NODES)
+		return;
 
-	if (node_num != o2nm_this_node()) {
-		/* believe it or not, accept and node heartbeating testing
-		 * can succeed for this node before we got here.. so
-		 * only use set_nn_state to clear the persistent error
-		 * if that hasn't already happened */
-		spin_lock(&nn->nn_lock);
-		atomic_set(&nn->nn_timeout, 0);
-		if (nn->nn_persistent_error)
-			o2net_set_nn_state(nn, NULL, 0, 0);
-		spin_unlock(&nn->nn_lock);
-	}
+	if (node_num != this_node)
+		o2net_hb_node_up(o2net_nn_from_num(node_num));
 }
 
 void o2net_unregister_hb_callbacks(void)
@@ -1756,6 +1769,37 @@ void o2net_unregister_hb_callbacks(void)
 	o2hb_unregister_callback(NULL, &o2net_hb_down);
 }
 
+/*
+ * Delay heartbeat-driven network work until the local node is fully published
+ * through o2nm_this_node(), then replay the nodes that are already live while
+ * callback delivery stays blocked.
+ */
+void o2net_complete_start_listening(struct o2nm_node *node)
+{
+	unsigned long live_nodes[BITS_TO_LONGS(O2NM_MAX_NODES)];
+	unsigned long node_num;
+	u8 local_node;
+
+	local_node = o2nm_this_node();
+	if (WARN_ON_ONCE(local_node == O2NM_MAX_NODES))
+		return;
+	if (WARN_ON_ONCE(local_node != node->nd_num))
+		return;
+	if (WARN_ON_ONCE(!o2net_wq))
+		return;
+
+	o2hb_callback_read_lock();
+	WRITE_ONCE(o2net_listening, true);
+	o2hb_fill_node_map_locked(live_nodes, O2NM_MAX_NODES);
+	for_each_set_bit(node_num, live_nodes, O2NM_MAX_NODES) {
+		if (node_num == local_node)
+			continue;
+
+		o2net_hb_node_up(o2net_nn_from_num(node_num));
+	}
+	o2hb_callback_read_unlock();
+}
+
 int o2net_register_hb_callbacks(void)
 {
 	int ret;
@@ -2034,6 +2078,8 @@ int o2net_start_listening(struct o2nm_node *node)
 {
 	int ret = 0;
 
+	if (WARN_ON_ONCE(READ_ONCE(o2net_listening)))
+		return -EBUSY;
 	BUG_ON(o2net_wq != NULL);
 	BUG_ON(o2net_listen_sock != NULL);
 
@@ -2065,6 +2111,9 @@ void o2net_stop_listening(struct o2nm_node *node)
 	BUG_ON(o2net_wq == NULL);
 	BUG_ON(o2net_listen_sock == NULL);
 
+	WRITE_ONCE(o2net_listening, false);
+	o2hb_synchronize_callbacks();
+
 	/* stop the listening socket from generating work */
 	write_lock_bh(&sock->sk->sk_callback_lock);
 	sock->sk->sk_data_ready = sock->sk->sk_user_data;
diff --git a/fs/ocfs2/cluster/tcp.h b/fs/ocfs2/cluster/tcp.h
index a75b551d31c7..2e86d42b5faf 100644
--- a/fs/ocfs2/cluster/tcp.h
+++ b/fs/ocfs2/cluster/tcp.h
@@ -96,6 +96,7 @@ struct o2nm_node;
 int o2net_register_hb_callbacks(void);
 void o2net_unregister_hb_callbacks(void);
 int o2net_start_listening(struct o2nm_node *node);
+void o2net_complete_start_listening(struct o2nm_node *node);
 void o2net_stop_listening(struct o2nm_node *node);
 void o2net_disconnect_node(struct o2nm_node *node);
 int o2net_num_connected_peers(void);
-- 
2.43.0

