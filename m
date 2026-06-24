Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9EF3955EC
	for <ocfs2-devel@lists.linux.dev>; Wed, 24 Jun 2026 09:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782294808; cv=none; b=j4czlfCh1A2/h5U8htH3naao1GPqs3fnJ2ihACjMv3VNUdO0y66v+5QaaTeUgBvIHB2MY6z86GxeYRW6HEDKrpIZRYSKjxX2uTP6hnObeFBrQBcA+KULzzoRMyLWRjMhv35eERX4m4CqJ5BJJWfuyvQVuyrhj00kXwKg1q7D1mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782294808; c=relaxed/simple;
	bh=xRTWpsLiQB3LgI66XnPUBf2lf2xivCiWWjFTSkkhwmU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JPaC7w/OMqf+pZ92j5IcireXvO6KbIYXwyfgkX9S748TmtNq20zJ1O2g9XeXarunKrXDxJ8VJLFyTW3CkowWaxB6Uba1vvwkVuNm46N9Nrp7wpuKK93cWiN3ciduHA0PKtj84MK2EFq12CwHahPww9rK36Z+YCP8vbTkBnQSyYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ki0vCgoN; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ki0vCgoN"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-37c867bd3e0so515467a91.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 24 Jun 2026 02:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782294805; x=1782899605; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CfOLhVeVHCA5RaEt/UKx9fgMCP4RV1MJQMyFAnYKlKs=;
        b=Ki0vCgoNHvfu3uLw39GL/JLAX0dEZXZOMfeGMMJVzF/5L/9593paSQxJIL5N3QGfte
         /PETMtB0sd0xt58vN387cMzHGm8qkmZmUT3/KjoPoV+ooQ6fNPvU+X8IJff4F2ouk1AW
         b77I1AjpSxXSynbXCjBlsq0e9htJDhX2ksJEMhhOLDeSMG5v4d1OH7uNs7LN8SFCx0Ic
         6QGVnzQ+h90BvOfNxEhStiYi/tKcYruHAgSN6vDhZo4tyW7fIBglsDDJ/ysKsnqfnSRU
         F2MxYRGBu2qxYrGfb5wARSfbBpSazmIPkEVUAfwsVQ8KXK21znH1TqGRMBmOaLDUaAuf
         GIaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782294805; x=1782899605;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CfOLhVeVHCA5RaEt/UKx9fgMCP4RV1MJQMyFAnYKlKs=;
        b=KThW4EoKmIbgg0SU5mhQbIM+akt/zx9y3uOx4I9XYwDXAB8yiJsJCvmG9l3mTjXQxA
         Ju+4+vIC3RyinPXdV8eqAcANXVpYUjpxDbV7H3Npe/rQb3UMLfWGxo4FQqfeGuz1StEb
         tkaZvIlRFED48m7YWf6r38xRuP/Qe6hsODgbDtscgS4La2RuXJJoLne9NiokqxHBHBHX
         aN7hVTdFZY1OP+eesBCLfjP19D82Y/qK3hRp9Sb2v3mCMrEncMW7bokzlu/qwfiRJjM4
         w5ZxVHDnDeWbOvnyra0yfMaKjSBjTdtjURCguVMz7qfS6qICL/HmyBF5CKvRZ/gg2C78
         iJbg==
X-Forwarded-Encrypted: i=1; AHgh+RrTVaP0HfBwm4a3HqG64k9aQio4TFsUS1JubWE3bnzT9wu6cXSH6sabTvqHPC2UpzDTr7TtnSDBYROmMA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyn9yXTOn/Jd0mRJS/U3r3eqZVk57QQcdzvW0WaHHAImn19hVsJ
	QDUHSLYxYeNAGUeG7lAWPq9ymoSTWQCN1EFS+2wiit22V4ZQ5duzOzDU
X-Gm-Gg: AfdE7cnGNP3s+EB2G61tB6AXUQBan12R9V2nZGCkrLJbOuWXChKoUeCqiLY8cYCQMVR
	0c+rCwNzb/AJb/7UEboCfyzkAox9d/iUn9Mn89QcWbReUyuWvU0eloyBL/dIXvsFDhHZ/3Dyn3n
	ogIuKirKjGPgLh3Cmle2lfUh8qtuOqlGVukM5NEL7pKZHOa9Sn90bXqldvmTR3LKmVslU/HgLZZ
	T1Ip3xy3FSGVKISa7GnD2revXF9ELDM9PbcayXDZBa6lXHa5Pb+88OQOLFBJ91wZlAr7VBmXMi7
	3w1FT6cBNJ6PIozPQaB1ZcmzHv98xkRhJuGNdwT/tgKEU+UogayO+mHIe26yUli25RQTMcb6ZmT
	xy+QpZCyE5He+pJ4xTRlsP/Sh63Fr/deGte1NB1GdUcKEUvKqtUjYK/TlPCIO7gxJcZOOxO6DnH
	FePjeEAYqeeWiCEcx3EQ==
X-Received: by 2002:a17:90b:4d01:b0:36a:8240:2477 with SMTP id 98e67ed59e1d1-37de429d93cmr3022448a91.19.1782294804900;
        Wed, 24 Jun 2026 02:53:24 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37de3ce544dsm2247634a91.9.2026.06.24.02.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 02:53:24 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	zzzccc427@gmail.com
Subject: [PATCH 2/2] ocfs2: o2hb: quiesce negotiate handlers and timeout work
Date: Wed, 24 Jun 2026 17:53:10 +0800
Message-Id: <20260624095310.763763-3-zzzccc427@gmail.com>
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

Heartbeat regions publish struct o2hb_region as the private data for the
NEGO_TIMEOUT and NEGO_APPROVE o2net handlers as soon as make_item()
creates the configfs region. The approve handler can call
o2hb_arm_timeout(), so a peer can touch the region timeout work before
dev_store() has finished building the heartbeat runtime, or after
teardown has started to shut that runtime back down.

The final configfs put also has to keep reg alive until the last
in-flight o2net callback drops its handler reference.
o2net_unregister_handler_list() blocks future handler lookups, but it
does not wait for sc_rx_work that already passed o2net_handler_get().
That drain needs to cover local listener teardown as well, where the
o2net ordered workqueue may already be inside destroy_workqueue().

Fix the lifetime rule in both directions. Initialize the region delayed
works before publishing reg through the o2net handler table, keep new or
stopping regions non-armable with hr_stopping, and quiesce both delayed
works on failed-start and teardown paths even when no heartbeat thread is
left to call o2hb_disarm_timeout(). Then unregister handlers before
tearing down handler-visible region state and make the drain wait for the
active or destroying o2net ordered workqueue before release frees reg.

The buggy scenario involves two paths, with each column showing the order
within that path:

region lifecycle:                late negotiate callback:
1. make_item() registers the     1. o2net_process_message() gets a
   region handlers before           heartbeat handler for reg.
   dev_store() has built a       2. The callback runs after the lookup
   runnable heartbeat context.      lock is dropped and dereferences reg.
2. A failed start or rmdir       3. An approve or timeout path tries to
   stops the heartbeat thread,      queue reg's delayed work, or release
   quiesces existing work, and      races the callback body after handler
   drops the final configfs ref.    unregister.
3. region_release() must drain   4. The callback or delayed work can
   handler-visible o2net rx work    outlive reg unless lifecycle code
   before freeing reg.              keeps the region non-armable and
                                    drains the active-or-destroying
                                    o2net workqueue.

Validation reproduced this kernel report:
KASAN slab-use-after-free in __run_timers+0x22c/0x5b0
Write of size 8
Call trace:
  dump_stack_lvl+0x66/0xa0
  print_report+0xce/0x630
  __run_timers+0x22c/0x5b0
  kasan_report+0xe0/0x110
  _raw_spin_unlock_irqrestore+0x27/0x60
  try_to_wake_up+0x191/0xf70
  timer_expire_remote+0xae/0xf0
  run_timer_softirq+0x19b/0x1a0
  handle_softirqs+0x156/0x660
  __irq_exit_rcu+0xc4/0x160
  irq_exit_rcu+0xe/0x20
  sysvec_apic_timer_interrupt+0x6c/0x80
  asm_sysvec_apic_timer_interrupt+0x1a/0x20

Allocated by task stack:
  kasan_save_stack+0x33/0x60
  kasan_save_track+0x14/0x30
  __kasan_kmalloc+0xaa/0xb0
  o2hb_heartbeat_group_make_item+0x3c/0x600

Fixes: 34069b886f95 ("ocfs2: o2hb: add NEGO_TIMEOUT message")
Fixes: e76f8237a2f7 ("ocfs2: o2hb: add NEGOTIATE_APPROVE message")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
 fs/ocfs2/cluster/heartbeat.c |  56 ++++++++++++++++---
 fs/ocfs2/cluster/tcp.c       | 103 ++++++++++++++++++++++++++++++-----
 fs/ocfs2/cluster/tcp.h       |   1 +
 3 files changed, 138 insertions(+), 22 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 76e0c687bcbd..428b8e52f7ff 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -15,6 +15,7 @@
 #include <linux/file.h>
 #include <linux/kthread.h>
 #include <linux/configfs.h>
+#include <linux/mutex.h>
 #include <linux/random.h>
 #include <linux/crc32.h>
 #include <linux/time.h>
@@ -258,6 +259,9 @@ struct o2hb_region {
 	/* Message key for negotiate timeout message. */
 	unsigned int		hr_key;
 	struct list_head	hr_handler_list;
+	/* Serializes timeout arming against failed-start and teardown. */
+	struct mutex		hr_arming_mutex;
+	bool			hr_stopping;
 
 	/* last hb status, 0 for success, other value for error. */
 	int			hr_last_hb_status;
@@ -322,9 +326,14 @@ static void o2hb_write_timeout(struct work_struct *work)
 
 static void o2hb_arm_timeout(struct o2hb_region *reg)
 {
+	mutex_lock(&reg->hr_arming_mutex);
+
+	if (reg->hr_stopping)
+		goto out_unlock;
+
 	/* Arm writeout only after thread reaches steady state */
 	if (atomic_read(&reg->hr_steady_iterations) != 0)
-		return;
+		goto out_unlock;
 
 	mlog(ML_HEARTBEAT, "Queue write timeout for %u ms\n",
 	     O2HB_MAX_WRITE_TIMEOUT_MS);
@@ -343,6 +352,18 @@ static void o2hb_arm_timeout(struct o2hb_region *reg)
 	schedule_delayed_work(&reg->hr_nego_timeout_work,
 			      msecs_to_jiffies(O2HB_NEGO_TIMEOUT_MS));
 	bitmap_zero(reg->hr_nego_node_bitmap, O2NM_MAX_NODES);
+
+out_unlock:
+	mutex_unlock(&reg->hr_arming_mutex);
+}
+
+static void o2hb_queue_nego_timeout(struct o2hb_region *reg,
+				    unsigned long delay)
+{
+	mutex_lock(&reg->hr_arming_mutex);
+	if (!reg->hr_stopping)
+		schedule_delayed_work(&reg->hr_nego_timeout_work, delay);
+	mutex_unlock(&reg->hr_arming_mutex);
 }
 
 static void o2hb_disarm_timeout(struct o2hb_region *reg)
@@ -351,6 +372,19 @@ static void o2hb_disarm_timeout(struct o2hb_region *reg)
 	cancel_delayed_work_sync(&reg->hr_nego_timeout_work);
 }
 
+static void o2hb_set_region_stopping(struct o2hb_region *reg, bool stopping)
+{
+	mutex_lock(&reg->hr_arming_mutex);
+	reg->hr_stopping = stopping;
+	mutex_unlock(&reg->hr_arming_mutex);
+}
+
+static void o2hb_quiesce_timeout(struct o2hb_region *reg)
+{
+	o2hb_set_region_stopping(reg, true);
+	o2hb_disarm_timeout(reg);
+}
+
 static int o2hb_send_nego_msg(int key, int type, u8 target, u8 node_num)
 {
 	struct o2hb_nego_msg msg;
@@ -400,8 +434,7 @@ static void o2hb_nego_timeout(struct work_struct *work)
 			/* check negotiate bitmap every second to do timeout
 			 * approve decision.
 			 */
-			schedule_delayed_work(&reg->hr_nego_timeout_work,
-				msecs_to_jiffies(1000));
+			o2hb_queue_nego_timeout(reg, msecs_to_jiffies(1000));
 
 			return;
 		}
@@ -1558,6 +1591,8 @@ static void o2hb_region_release(struct config_item *item)
 
 	mlog(ML_HEARTBEAT, "hb region release (%pg)\n", reg_bdev(reg));
 
+	o2hb_quiesce_timeout(reg);
+	o2net_unregister_and_flush_handler_list(&reg->hr_handler_list);
 	o2hb_unmap_slot_data(reg);
 
 	if (reg->hr_bdev_file)
@@ -1573,7 +1608,6 @@ static void o2hb_region_release(struct config_item *item)
 	list_del(&reg->hr_all_item);
 	spin_unlock(&o2hb_live_lock);
 
-	o2net_unregister_handler_list(&reg->hr_handler_list);
 	kfree(reg);
 }
 
@@ -1888,9 +1922,6 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 		goto out;
 	}
 
-	INIT_DELAYED_WORK(&reg->hr_write_timeout_work, o2hb_write_timeout);
-	INIT_DELAYED_WORK(&reg->hr_nego_timeout_work, o2hb_nego_timeout);
-
 	/*
 	 * A node is considered live after it has beat LIVE_THRESHOLD
 	 * times.  We're not steady until we've given them a chance
@@ -1910,6 +1941,7 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 	atomic_set(&reg->hr_steady_iterations, live_threshold);
 	/* unsteady_iterations is triple the steady_iterations */
 	atomic_set(&reg->hr_unsteady_iterations, (live_threshold * 3));
+	o2hb_set_region_stopping(reg, false);
 
 	hb_task = kthread_run(o2hb_thread, reg, "o2hb-%s",
 			      reg->hr_item.ci_name);
@@ -1959,6 +1991,8 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 
 out:
 	if (ret < 0) {
+		o2hb_quiesce_timeout(reg);
+
 		spin_lock(&o2hb_live_lock);
 		hb_task = reg->hr_task;
 		reg->hr_task = NULL;
@@ -2098,6 +2132,10 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
 	 */
 	reg->hr_key = crc32_le(reg->hr_region_num + O2NM_MAX_REGIONS,
 		name, strlen(name));
+	mutex_init(&reg->hr_arming_mutex);
+	reg->hr_stopping = true;
+	INIT_DELAYED_WORK(&reg->hr_write_timeout_work, o2hb_write_timeout);
+	INIT_DELAYED_WORK(&reg->hr_nego_timeout_work, o2hb_nego_timeout);
 	INIT_LIST_HEAD(&reg->hr_handler_list);
 	ret = o2net_register_handler(O2HB_NEGO_TIMEOUT_MSG, reg->hr_key,
 			sizeof(struct o2hb_nego_msg),
@@ -2118,7 +2156,7 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
 	return &reg->hr_item;
 
 unregister_handler:
-	o2net_unregister_handler_list(&reg->hr_handler_list);
+	o2net_unregister_and_flush_handler_list(&reg->hr_handler_list);
 remove_item:
 	spin_lock(&o2hb_live_lock);
 	list_del(&reg->hr_all_item);
@@ -2137,6 +2175,8 @@ static void o2hb_heartbeat_group_drop_item(struct config_group *group,
 	struct o2hb_region *reg = to_o2hb_region(item);
 	int quorum_region = 0;
 
+	o2hb_quiesce_timeout(reg);
+
 	/* stop the thread when the user removes the region dir */
 	spin_lock(&o2hb_live_lock);
 	hb_task = reg->hr_task;
diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index e62c1ef8223b..474fe1414cee 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -38,6 +38,8 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/completion.h>
+#include <linux/mutex.h>
 #include <linux/sched/mm.h>
 #include <linux/jiffies.h>
 #include <linux/slab.h>
@@ -102,9 +104,14 @@ static struct socket *o2net_listen_sock;
  * quorum work is queued as sock containers are shutdown.. stop_listening
  * tears down all the node's sock containers, preventing future shutdowns
  * and queued quorum work, before canceling delayed quorum work and
- * destroying the work queue.
+ * destroying the work queue.  Handler teardown can also race local listener
+ * shutdown, so keep a waitable destroying pointer until the old ordered
+ * queue has finished draining.
  */
 static struct workqueue_struct *o2net_wq;
+static struct workqueue_struct *o2net_wq_destroying;
+static DEFINE_MUTEX(o2net_wq_mutex);
+static DECLARE_COMPLETION(o2net_wq_destroyed);
 /* Heartbeat callbacks stay registered across local-node off/on. */
 static bool o2net_listening;
 static struct work_struct o2net_listen_work;
@@ -886,6 +893,27 @@ void o2net_unregister_handler_list(struct list_head *list)
 }
 EXPORT_SYMBOL_GPL(o2net_unregister_handler_list);
 
+static void o2net_flush_wq(void)
+{
+	mutex_lock(&o2net_wq_mutex);
+	if (o2net_wq_destroying) {
+		mutex_unlock(&o2net_wq_mutex);
+		wait_for_completion(&o2net_wq_destroyed);
+		return;
+	}
+
+	if (o2net_wq)
+		flush_workqueue(o2net_wq);
+	mutex_unlock(&o2net_wq_mutex);
+}
+
+void o2net_unregister_and_flush_handler_list(struct list_head *list)
+{
+	o2net_unregister_handler_list(list);
+	o2net_flush_wq();
+}
+EXPORT_SYMBOL_GPL(o2net_unregister_and_flush_handler_list);
+
 static struct o2net_msg_handler *o2net_handler_get(u32 msg_type, u32 key)
 {
 	struct o2net_msg_handler *nmh;
@@ -1717,12 +1745,10 @@ void o2net_disconnect_node(struct o2nm_node *node)
 	o2net_set_nn_state(nn, NULL, 0, -ENOTCONN);
 	spin_unlock(&nn->nn_lock);
 
-	if (o2net_wq) {
-		cancel_delayed_work(&nn->nn_connect_expired);
-		cancel_delayed_work(&nn->nn_connect_work);
-		cancel_delayed_work(&nn->nn_still_up);
-		flush_workqueue(o2net_wq);
-	}
+	cancel_delayed_work(&nn->nn_connect_expired);
+	cancel_delayed_work(&nn->nn_connect_work);
+	cancel_delayed_work(&nn->nn_still_up);
+	o2net_flush_wq();
 }
 
 static void o2net_hb_node_down_cb(struct o2nm_node *node, int node_num,
@@ -2067,6 +2093,36 @@ static int o2net_open_listening_sock(__be32 addr, __be16 port)
 	return ret;
 }
 
+static void o2net_destroy_wq(void)
+{
+	struct workqueue_struct *wq;
+
+	mutex_lock(&o2net_wq_mutex);
+	if (o2net_wq_destroying) {
+		mutex_unlock(&o2net_wq_mutex);
+		wait_for_completion(&o2net_wq_destroyed);
+		return;
+	}
+
+	wq = o2net_wq;
+	if (!wq) {
+		mutex_unlock(&o2net_wq_mutex);
+		return;
+	}
+
+	reinit_completion(&o2net_wq_destroyed);
+	o2net_wq_destroying = wq;
+	mutex_unlock(&o2net_wq_mutex);
+
+	destroy_workqueue(wq);
+
+	mutex_lock(&o2net_wq_mutex);
+	o2net_wq = NULL;
+	o2net_wq_destroying = NULL;
+	complete_all(&o2net_wq_destroyed);
+	mutex_unlock(&o2net_wq_mutex);
+}
+
 /*
  * called from node manager when we should bring up our network listening
  * socket.  node manager handles all the serialization to only call this
@@ -2077,24 +2133,44 @@ static int o2net_open_listening_sock(__be32 addr, __be16 port)
 int o2net_start_listening(struct o2nm_node *node)
 {
 	int ret = 0;
+	struct workqueue_struct *wq;
 
 	if (WARN_ON_ONCE(READ_ONCE(o2net_listening)))
 		return -EBUSY;
-	BUG_ON(o2net_wq != NULL);
+
+	mutex_lock(&o2net_wq_mutex);
+	if (o2net_wq_destroying) {
+		mutex_unlock(&o2net_wq_mutex);
+		return -EBUSY;
+	}
+	if (WARN_ON_ONCE(o2net_wq)) {
+		mutex_unlock(&o2net_wq_mutex);
+		return -EBUSY;
+	}
+	mutex_unlock(&o2net_wq_mutex);
+
 	BUG_ON(o2net_listen_sock != NULL);
 
 	mlog(ML_KTHREAD, "starting o2net thread...\n");
-	o2net_wq = alloc_ordered_workqueue("o2net", WQ_MEM_RECLAIM);
-	if (o2net_wq == NULL) {
+	wq = alloc_ordered_workqueue("o2net", WQ_MEM_RECLAIM);
+	if (!wq) {
 		mlog(ML_ERROR, "unable to launch o2net thread\n");
 		return -ENOMEM; /* ? */
 	}
 
+	mutex_lock(&o2net_wq_mutex);
+	if (unlikely(o2net_wq_destroying || o2net_wq)) {
+		mutex_unlock(&o2net_wq_mutex);
+		destroy_workqueue(wq);
+		return -EBUSY;
+	}
+	o2net_wq = wq;
+	mutex_unlock(&o2net_wq_mutex);
+
 	ret = o2net_open_listening_sock(node->nd_ipv4_address,
 					node->nd_ipv4_port);
 	if (ret) {
-		destroy_workqueue(o2net_wq);
-		o2net_wq = NULL;
+		o2net_destroy_wq();
 	} else
 		o2quo_conn_up(node->nd_num);
 
@@ -2130,8 +2206,7 @@ void o2net_stop_listening(struct o2nm_node *node)
 
 	/* finish all work and tear down the work queue */
 	mlog(ML_KTHREAD, "waiting for o2net thread to exit....\n");
-	destroy_workqueue(o2net_wq);
-	o2net_wq = NULL;
+	o2net_destroy_wq();
 
 	sock_release(o2net_listen_sock);
 	o2net_listen_sock = NULL;
diff --git a/fs/ocfs2/cluster/tcp.h b/fs/ocfs2/cluster/tcp.h
index 2e86d42b5faf..a11bcee28947 100644
--- a/fs/ocfs2/cluster/tcp.h
+++ b/fs/ocfs2/cluster/tcp.h
@@ -89,6 +89,7 @@ int o2net_register_handler(u32 msg_type, u32 key, u32 max_len,
 			   o2net_post_msg_handler_func *post_func,
 			   struct list_head *unreg_list);
 void o2net_unregister_handler_list(struct list_head *list);
+void o2net_unregister_and_flush_handler_list(struct list_head *list);
 
 void o2net_fill_node_map(unsigned long *map, unsigned bytes);
 
-- 
2.43.0

