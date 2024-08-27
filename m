Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C447E1D47A5
	for <ocfs2-devel@lists.linux.dev>; Tue, 27 Aug 2024 18:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724781824; cv=none; b=j9uexVYKwQnyFIhw2OVMZTUpFm2DLgAJd5xFv9wVRUDvI3/dVlMlrFvfVFwxbncKuoCOIDtLqRJu2ainX/Wb5qqoySqkxgjXII5RtgrsTp0XOSGAXe2bbestmoaya5ywNdDN5RYrmoFGw57fSFIt6Sl5ixSWqtCzmNkmmQ357k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724781824; c=relaxed/simple;
	bh=2EYGC1vMs0Hpw0whCd3bNyo1/02HGjJXSqnQRxHrocY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hs3W7rCL/pW0wASjYq0g23Xt8Q7nlJRnJfe4BeH5DSX8ocm2vKAREPGKt7yKM7B0r3elwcDpte7PhLcxHn29KUm3KAlXFdyRfaFeATHuAh+1IZSuQgPHCppmYz/pSOnMeX/NBpJRIa2W2f9mDs/VmPMBX+KXQSLJei7PKIG5Pq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EQrQN1mr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EQrQN1mr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724781816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OpnAX1fOM2MzxfYtvNDSARUGYAHYe8Rt2hfnrOKJSbk=;
	b=EQrQN1mrWHVAs1KRRpUAxoKyk4TSY9M3yZHoPR32hODt7hA4lNcUH8wRcK4Kn2j1ttdccH
	NlvbjK10ATDxeGUu8mUP1LEOJjriwurB40XEndAkW9u/3Ednb9yrIszIkoT6wUjN43t0mR
	UPRhr71jeHDx3CwHuOwD6rDE+9+W47M=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-361-h3AoxaQyPYG3P68gVUJ3tw-1; Tue,
 27 Aug 2024 14:03:28 -0400
X-MC-Unique: h3AoxaQyPYG3P68gVUJ3tw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 56C0419560A3;
	Tue, 27 Aug 2024 18:03:25 +0000 (UTC)
Received: from fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com (fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com [10.6.24.150])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DE0FD1955F1B;
	Tue, 27 Aug 2024 18:03:21 +0000 (UTC)
From: Alexander Aring <aahringo@redhat.com>
To: teigland@redhat.com
Cc: gfs2@lists.linux.dev,
	song@kernel.org,
	yukuai3@huawei.com,
	agruenba@redhat.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	netdev@vger.kernel.org,
	vvidic@valentin-vidic.from.hr,
	heming.zhao@suse.com,
	lucien.xin@gmail.com,
	paulmck@kernel.org,
	rcu@vger.kernel.org,
	juri.lelli@redhat.com,
	williams@redhat.com,
	aahringo@redhat.com
Subject: [RFC 7/7] rv: add dlm compatible lock state kernel verifier
Date: Tue, 27 Aug 2024 14:02:36 -0400
Message-ID: <20240827180236.316946-8-aahringo@redhat.com>
In-Reply-To: <20240827180236.316946-1-aahringo@redhat.com>
References: <20240827180236.316946-1-aahringo@redhat.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

This patch adds the DLM kernel lock state verifier. It can be simply
activated by:

echo "dlm" > /sys/kernel/tracing/rv/enabled_monitors
echo "printk" > /sys/kernel/tracing/rv/monitors/dlm/reactors

then run any kind of workload on DLM to check on DLM correctness in
sense of compatible lock states and their current holders. For example
there cannot be two lock holders or more for a specific lock holding the
exclusive lock.

IMPORTANT: This kernel verifier for DLM only makes sense to use it with
combination of DLM's net-namespace feature to run a DLM cluster on one
Linux kernel instance. This offers us a whole cluster view in the Linux
tracing subsystem that this verifier takes advantage of!

The above note is the reason why this verifier works kinda different
than other verifiers. We build a layer to have a cluster view and check
if a lock state is still compatible with all current lock holder states.
That's why we have a rhashtable in the verifier to keep track of all
current cluster wide locks. However we use da events to check if our
model is violating or not.

As example gfs2 can be used to produce some kind of filesystem benchmark
that produces DLM lock handling. This verifier will then check if DLM is
working as expected.

Most useful feature is checking DLM recovery handling if nodes
leave the lockspace and DLM is still correct.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 Documentation/trace/rv/monitor_dlm.rst |  77 +++++
 include/trace/events/rv.h              |   9 +
 kernel/trace/rv/Kconfig                |  18 +
 kernel/trace/rv/Makefile               |   1 +
 kernel/trace/rv/monitors/dlm/dlm.c     | 445 +++++++++++++++++++++++++
 kernel/trace/rv/monitors/dlm/dlm.h     |  38 +++
 kernel/trace/rv/monitors/dlm/dlm_da.h  | 143 ++++++++
 tools/verification/models/dlm.dot      |  14 +
 8 files changed, 745 insertions(+)
 create mode 100644 Documentation/trace/rv/monitor_dlm.rst
 create mode 100644 kernel/trace/rv/monitors/dlm/dlm.c
 create mode 100644 kernel/trace/rv/monitors/dlm/dlm.h
 create mode 100644 kernel/trace/rv/monitors/dlm/dlm_da.h
 create mode 100644 tools/verification/models/dlm.dot

diff --git a/Documentation/trace/rv/monitor_dlm.rst b/Documentation/trace/rv/monitor_dlm.rst
new file mode 100644
index 000000000000..95cdf3d1a904
--- /dev/null
+++ b/Documentation/trace/rv/monitor_dlm.rst
@@ -0,0 +1,77 @@
+Monitor dlm
+============
+
+- Name: dlm - dlm runtime lock compatibility verifier.
+  Only makes sense with DLM net-names paces because we
+  need the whole traced cluster view.
+- Type: per-dlm_lock deterministic automaton
+- Author: Alexander Aring <aahringo@redhat.com>
+
+Description
+-----------
+
+This is a per-dlm lock compatibility monitor, with the following
+definition::
+
+               |
+    with       |
+   others      v
+ compatible  +-------------+
+  +--------- |             |
+  |          |    valid    |
+  +--------> |             |
+             +-------------+
+               |
+               | all_unlock
+               v
+             #=============#
+             H     free    H
+             #=============#
+
+This model is on a per cluster wide DLM lock basis. Each cluster
+node can hold a specific lock resource in a certain lock mode.
+This lock mode is either compatible or not compatible with all
+other nodes holding the particular lock resource in a different
+lock mode. A simple lock state is the Exclusive Lock state. Two
+nodes can never held the exclusive lock for a specific lock
+resource at the same time. This is what "with others compatible"
+edge means when a node changes the lock state and checks if the
+lock state is still compatible with other holders of the lock, we
+are still in the valid state.
+
+If all holders for a specific lock resource that we track switch
+to unlock state, we free the monitoring resource as we don't track
+the lock correctness anymore. The lock can be monitored again if
+the same lock resource switches to a valid lock state.
+
+This monitor introduce also another lock state to signal that a
+lock state is in transition. The user signals a lock state change
+and we waiting for a lock state completion (ast) callback. At this
+time the user cannot assume to hold the state in a certain state
+until completion and we need to ignore lock holders they are in
+transition.
+
+IMPORTANT NOTE:
+
+This monitor makes only sense when having a cluster wide view in
+the local Linux tracing subsystem. For now this means a DLM user
+should construct a cluster with several nodes by using
+net-namespaces. This will allow the DLM monitor to track cluster
+wide lock changes. The monitor also works on a real cluster with
+several machines as nodes, but it will not make any sense as we
+don't check on any cluster-wide DLM correctness. Only for per-node
+local DLM correctness, which is unlikely to break.
+
+There might be ideas to use time synchronized tracing to get a
+cluster wide Linux tracing view and run the kernel verifier on
+a real cluster, however this isn't supported yet and only an idea
+to how to might handle it.
+
+This monitor is different than other current monitors. It builds
+an nonexitent layer that represents the current cluster state that
+we don't track in such a way in DLM. That's why it only works
+with DLM and net-namespaces together.
+
+Specification
+-------------
+Grapviz Dot file in tools/verification/models/dlm.dot
diff --git a/include/trace/events/rv.h b/include/trace/events/rv.h
index 56592da9301c..cd031a4d994d 100644
--- a/include/trace/events/rv.h
+++ b/include/trace/events/rv.h
@@ -66,6 +66,15 @@ DEFINE_EVENT(error_da_monitor, error_wip,
 	     TP_PROTO(char *state, char *event),
 	     TP_ARGS(state, event));
 #endif /* CONFIG_RV_MON_WIP */
+#ifdef CONFIG_RV_MON_DLM
+DEFINE_EVENT(event_da_monitor, event_dlm,
+	    TP_PROTO(char *state, char *event, char *next_state, bool final_state),
+	    TP_ARGS(state, event, next_state, final_state));
+
+DEFINE_EVENT(error_da_monitor, error_dlm,
+	     TP_PROTO(char *state, char *event),
+	     TP_ARGS(state, event));
+#endif /* CONFIG_RV_MON_DLM */
 #endif /* CONFIG_DA_MON_EVENTS_IMPLICIT */
 
 #ifdef CONFIG_DA_MON_EVENTS_ID
diff --git a/kernel/trace/rv/Kconfig b/kernel/trace/rv/Kconfig
index 831779607e84..bc12b72088c4 100644
--- a/kernel/trace/rv/Kconfig
+++ b/kernel/trace/rv/Kconfig
@@ -50,6 +50,24 @@ config RV_MON_WWNR
 	  For further information, see:
 	    Documentation/trace/rv/monitor_wwnr.rst
 
+config RV_MON_DLM
+	depends on RV
+	depends on DLM
+	depends on NET_NS
+	bool "dlm monitor"
+	help
+	  Enable dlm (runtime lock compatibility verifier) sample monitor,
+	  this monitor will check on DLM lock correctness in sense of
+	  checking on compatible lock modes during DLM runtime. E.g. two
+	  cluster wide lock holders that holding the exclusive lock state
+	  for a specific lock.
+
+	  IMPORTANT: the verifier only works on DLMs net-namespace feature
+	  that is e.g. supported by gfs2.
+
+	  For further information, see:
+	    Documentation/trace/rv/monitor_dlm.rst
+
 config RV_REACTORS
 	bool "Runtime verification reactors"
 	default y
diff --git a/kernel/trace/rv/Makefile b/kernel/trace/rv/Makefile
index 963d14875b45..b1ac0d69ebef 100644
--- a/kernel/trace/rv/Makefile
+++ b/kernel/trace/rv/Makefile
@@ -3,6 +3,7 @@
 obj-$(CONFIG_RV) += rv.o
 obj-$(CONFIG_RV_MON_WIP) += monitors/wip/wip.o
 obj-$(CONFIG_RV_MON_WWNR) += monitors/wwnr/wwnr.o
+obj-$(CONFIG_RV_MON_DLM) += monitors/dlm/dlm.o
 obj-$(CONFIG_RV_REACTORS) += rv_reactors.o
 obj-$(CONFIG_RV_REACT_PRINTK) += reactor_printk.o
 obj-$(CONFIG_RV_REACT_PANIC) += reactor_panic.o
diff --git a/kernel/trace/rv/monitors/dlm/dlm.c b/kernel/trace/rv/monitors/dlm/dlm.c
new file mode 100644
index 000000000000..2f384b5b08b6
--- /dev/null
+++ b/kernel/trace/rv/monitors/dlm/dlm.c
@@ -0,0 +1,445 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/ftrace.h>
+#include <linux/tracepoint.h>
+#include <linux/console.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/rv.h>
+#include <rv/instrumentation.h>
+#include <rv/da_monitor.h>
+
+#define MODULE_NAME "dlm_rv"
+#include <trace/events/rv.h>
+#include <trace/events/dlm.h>
+
+#include "dlm.h"
+#include "dlm_da.h"
+#include "../../../fs/dlm/lock.h"
+
+/* out of DLM DLM API mode values */
+#define STATE_MODE_UNLOCK -1
+#define STATE_MODE_IN_TRANSITION -2
+
+struct dlm_rv_lock_key {
+	uint32_t ls_id;
+	char res_name[DLM_RESNAME_MAXLEN];
+};
+
+struct dlm_rv_lock {
+	union rv_dlm_lock_monitor rv;
+
+	struct dlm_rv_lock_key key;
+	struct rhash_head node;
+
+	struct list_head holders;
+
+	/* holder for lock list */
+	struct list_head list;
+};
+
+/* protected by dlm_rv_hash_lock */
+struct dlm_rv_holder {
+	unsigned int nodeid;
+	int mode;
+
+	struct list_head list;
+};
+
+static const struct rhashtable_params dlm_rv_hash_params = {
+	.nelem_hint = 3, /* start small */
+	.key_len = sizeof(struct dlm_rv_lock_key),
+	.key_offset = offsetof(struct dlm_rv_lock, key),
+	.head_offset = offsetof(struct dlm_rv_lock, node),
+	.automatic_shrinking = true,
+};
+
+static LIST_HEAD(dlm_rv_locks);
+static struct rhashtable dlm_rv_hash;
+static DEFINE_SPINLOCK(dlm_rv_hash_lock);
+static struct kmem_cache *lk_cache;
+static struct kmem_cache *hl_cache;
+
+/*
+ * Entry point for the per-dlm_lock monitor.
+ */
+#define DECLARE_DA_MON_PER_DLM_LOCK(name, type)							\
+												\
+DECLARE_AUTOMATA_HELPERS(name, type)								\
+DECLARE_DA_MON_GENERIC_HELPERS(name, type)							\
+DECLARE_DA_MON_MODEL_HANDLER_PER_DLM_LOCK(name, type)						\
+DECLARE_DA_MON_INIT_PER_DLM_LOCK(name, type)							\
+DECLARE_DA_MON_MONITOR_HANDLER_PER_DLM_LOCK(name, type)
+
+static struct rv_monitor rv_dlm;
+DECLARE_DA_MON_PER_DLM_LOCK(dlm, unsigned char);
+
+static struct dlm_rv_lock *
+lookup_lock(uint32_t ls_id, const char *res_name, size_t res_length)
+{
+	struct dlm_rv_lock_key key = {
+		.ls_id = ls_id,
+	};
+
+	WARN_ON(res_length > DLM_RESNAME_MAXLEN);
+
+	/* the key.res_name is DLM_RESNAME_MAXLEN */
+	memcpy(&key.res_name, res_name, res_length);
+	return rhashtable_lookup_fast(&dlm_rv_hash, &key, dlm_rv_hash_params);
+}
+
+static struct dlm_rv_holder *
+lookup_holder(struct dlm_rv_lock *lk, unsigned int nodeid)
+{
+	struct dlm_rv_holder *iter, *hl = NULL;
+
+	list_for_each_entry(iter, &lk->holders, list) {
+		if (iter->nodeid == nodeid) {
+			hl = iter;
+			break;
+		}
+	}
+
+	return hl;
+}
+
+/* set a specific mode to a lock node holder identified by the nodeid */
+static void set_holder_state(struct dlm_rv_lock *lk, unsigned int nodeid,
+			     int mode)
+{
+	struct dlm_rv_holder *hl;
+
+	hl = lookup_holder(lk, nodeid);
+	if (hl) {
+		hl->mode = mode;
+		return;
+	}
+
+	/* we only create holders they are not start with UNLOCK */
+	if (mode == STATE_MODE_UNLOCK)
+		return;
+
+	hl = kmem_cache_zalloc(hl_cache, GFP_ATOMIC);
+	if (WARN_ON_ONCE(!hl))
+		return;
+
+	hl->nodeid = nodeid;
+	hl->mode = mode;
+
+	list_add(&hl->list, &lk->holders);
+}
+
+/* check if all lock holders except the one from nodeid is still
+ * compatible with the mode given by mode. Usually the nodeid which
+ * is skipped has the applied mode as parameter to check if the
+ * state change is valid.
+ */
+static int check_valid_lock_holders(struct dlm_rv_lock *lk, int mode,
+				    unsigned int nodeid)
+{
+	struct dlm_rv_holder *hl;
+
+	list_for_each_entry(hl, &lk->holders, list) {
+		/* ignore ourself
+		 * ignore pending lock states
+		 */
+		if (hl->nodeid == nodeid ||
+		    hl->mode == STATE_MODE_IN_TRANSITION)
+			continue;
+
+		if (!dlm_modes_compat(mode, hl->mode))
+			return 0;
+	}
+
+	return 1;
+}
+
+/* check if all holders for a lock are in unlock state */
+static int check_all_unlock_holders(struct dlm_rv_lock *lk)
+{
+	struct dlm_rv_holder *hl;
+
+	/* should never happen but when we delete the lk */
+	if (WARN_ON(list_empty(&lk->holders)))
+		return 1;
+
+	list_for_each_entry(hl, &lk->holders, list) {
+		if (hl->mode != STATE_MODE_UNLOCK)
+			return 0;
+	}
+
+	return 1;
+}
+
+/* drop all lock holders for a specific lock */
+static void drop_all_lock_holders(struct dlm_rv_lock *lk)
+{
+	struct dlm_rv_holder *hl, *tmp;
+
+	list_for_each_entry_safe(hl, tmp, &lk->holders, list) {
+		list_del(&hl->list);
+		kmem_cache_free(hl_cache, hl);
+	}
+}
+
+/* unlock specific lock holder if available and if all lock holders
+ * are in unlock state, we remove and free the lock.
+ */
+static void unlock_lock_holder(struct dlm_rv_lock *lk, unsigned int nodeid)
+{
+	int rv;
+
+	set_holder_state(lk, nodeid, STATE_MODE_UNLOCK);
+	rv = check_all_unlock_holders(lk);
+	if (rv) {
+		drop_all_lock_holders(lk);
+
+		list_del(&lk->list);
+		rhashtable_remove_fast(&dlm_rv_hash, &lk->node,
+				       dlm_rv_hash_params);
+		/* move into final state */
+		da_handle_event_dlm(lk, all_unlock_dlm);
+		kmem_cache_free(lk_cache, lk);
+	}
+}
+
+static void handle_dlm_ast(void *data, unsigned int our_nodeid, __u32 ls_id,
+			   __u32 lkb_id, __u8 sb_flags, int sb_status,
+			   const char *res_name, size_t res_length, int mode)
+{
+	struct dlm_rv_holder *hl;
+	struct dlm_rv_lock *lk;
+	int rv;
+
+	switch (sb_status) {
+	case -DLM_EUNLOCK:
+		/* handle an unlock of an lock we saw before */
+		spin_lock_bh(&dlm_rv_hash_lock);
+		/* switch to unlock state if there is a lock available
+		 * and check if all locks are in unlock mode, see
+		 * unlock_lock_holder().
+		 */
+		lk = lookup_lock(ls_id, res_name, res_length);
+		if (lk)
+			unlock_lock_holder(lk, our_nodeid);
+		spin_unlock_bh(&dlm_rv_hash_lock);
+		return;
+	case 0:
+		/* successful lock state change */
+		break;
+	default:
+		/* ignored */
+		return;
+	}
+
+	spin_lock_bh(&dlm_rv_hash_lock);
+	lk = lookup_lock(ls_id, res_name, res_length);
+	if (!lk) {
+		/* start to begin tracking DLM cluster lock */
+		lk = kmem_cache_zalloc(lk_cache, GFP_ATOMIC);
+		if (WARN_ON_ONCE(!lk)) {
+			spin_unlock_bh(&dlm_rv_hash_lock);
+			return;
+		}
+
+		lk->key.ls_id = ls_id;
+		memcpy(lk->key.res_name, res_name, res_length);
+		INIT_LIST_HEAD(&lk->holders);
+
+		da_monitor_reset_dlm(da_get_monitor_dlm(lk));
+		da_handle_start_event_dlm(lk, with_others_compatible_dlm);
+		set_holder_state(lk, our_nodeid, mode);
+
+		list_add_tail(&lk->list, &dlm_rv_locks);
+		rv = rhashtable_insert_fast(&dlm_rv_hash, &lk->node,
+					    dlm_rv_hash_params);
+		spin_unlock_bh(&dlm_rv_hash_lock);
+
+		WARN_ON(rv);
+		return;
+	}
+
+	/* lock is known, change it's state and check if it doesn't
+	 * violate the DLM cluster wide compatible lock modes
+	 */
+	set_holder_state(lk, our_nodeid, mode);
+	rv = check_valid_lock_holders(lk, mode, our_nodeid);
+	if (rv) {
+		/* the whole validation process, this event signals
+		 * everything is fine and DLM works correctly there
+		 * are no cluster-wide locks that violates DLM locking.
+		 */
+		da_handle_event_dlm(lk, with_others_compatible_dlm);
+	} else {
+		/* print all holders of the lock when a invalid lock state is entered */
+		console_lock();
+		pr_info("---\n");
+		pr_info("ls_id %u lkb_id: 0x%08x\n", ls_id, lkb_id);
+		pr_info("holders:\n");
+		list_for_each_entry(hl, &lk->holders, list) {
+			pr_info("\tnodeid: %u mode: %d\n", hl->nodeid,
+				hl->mode);
+		}
+		pr_info("---\n");
+		console_unlock();
+
+		/* move into an invalid state change, we don't have a edge for that
+		 * so we just use event_max_dlm.
+		 */
+		da_handle_event_dlm(lk, event_max_dlm);
+	}
+	spin_unlock_bh(&dlm_rv_hash_lock);
+}
+
+/* set the holder to transition state as lock downgrades can issue
+ * grant messages to other nodes we need to ignore if a lock on a
+ * specific node is in state transition. From point of DLM API
+ * the user cannot assume to still hold the lock at this point
+ * anyway.
+ */
+static void set_holder_transition(uint32_t ls_id, const char *res_name,
+				  size_t res_length, uint32_t our_nodeid)
+{
+	struct dlm_rv_holder *hl;
+	struct dlm_rv_lock *lk;
+
+	spin_lock_bh(&dlm_rv_hash_lock);
+	lk = lookup_lock(ls_id, res_name, res_length);
+	if (lk) {
+		hl = lookup_holder(lk, our_nodeid);
+		if (hl)
+			hl->mode = STATE_MODE_IN_TRANSITION;
+	}
+	spin_unlock_bh(&dlm_rv_hash_lock);
+}
+
+/* after a lock request got validated it cannot fail */
+static void handle_dlm_lock_validated(void *data, struct dlm_ls *ls,
+				      struct dlm_lkb *lkb,
+				      struct dlm_args *args,
+				      const char *res_name, size_t res_length)
+{
+	set_holder_transition(ls->ls_global_id, res_name,
+			      res_length, ls->ls_dn->our_node->id);
+}
+
+static void handle_dlm_unlock_validated(void *data, struct dlm_ls *ls,
+					struct dlm_lkb *lkb,
+					struct dlm_args *args)
+{
+	set_holder_transition(ls->ls_global_id,
+			      lkb->lkb_resource->res_name,
+			      lkb->lkb_resource->res_length,
+			      ls->ls_dn->our_node->id);
+}
+
+/* remove all holders, recovery will fast this up and we need to drop them */
+static void handle_dlm_release_lockspace(void *data, unsigned int our_nodeid,
+					 __u32 ls_id)
+{
+	struct dlm_rv_lock *lk, *lk_tmp;
+
+	spin_lock_bh(&dlm_rv_hash_lock);
+	list_for_each_entry_safe(lk, lk_tmp, &dlm_rv_locks, list) {
+		if (lk->key.ls_id != ls_id)
+			continue;
+
+		/* unlock all locks for the node that calls
+		 * dlm_release_lockspace(). It's not necessary
+		 * from the DLM API that a node need to unlock
+		 * all locks before calling dlm_release_lockspace()
+		 * there is even an optimization because each recovery
+		 * will deal with that locally. However we handle a
+		 * dlm_release_lockspace() on a specific node as
+		 * unlock all locks.
+		 */
+		unlock_lock_holder(lk, our_nodeid);
+	}
+	spin_unlock_bh(&dlm_rv_hash_lock);
+}
+
+static void rhash_lock_free(void *ptr, void *arg)
+{
+	struct dlm_rv_lock *lk = ptr;
+
+	list_del(&lk->list);
+	drop_all_lock_holders(lk);
+	kmem_cache_free(lk_cache, lk);
+}
+
+static int enable_dlm(void)
+{
+	int retval;
+
+	retval = rhashtable_init(&dlm_rv_hash, &dlm_rv_hash_params);
+	if (retval)
+		return retval;
+
+	retval = da_monitor_init_dlm();
+	if (retval) {
+		rhashtable_destroy(&dlm_rv_hash);
+		return retval;
+	}
+
+	rv_attach_trace_probe("dlm", dlm_ast, handle_dlm_ast);
+	rv_attach_trace_probe("dlm", dlm_lock_validated, handle_dlm_lock_validated);
+	rv_attach_trace_probe("dlm", dlm_unlock_validated, handle_dlm_unlock_validated);
+	rv_attach_trace_probe("dlm", dlm_release_lockspace, handle_dlm_release_lockspace);
+
+	return 0;
+}
+
+static void disable_dlm(void)
+{
+	rv_dlm.enabled = 0;
+
+	rv_detach_trace_probe("dlm", dlm_ast, handle_dlm_ast);
+	rv_detach_trace_probe("dlm", dlm_lock_validated, handle_dlm_lock_validated);
+	rv_detach_trace_probe("dlm", dlm_unlock_validated, handle_dlm_unlock_validated);
+	rv_detach_trace_probe("dlm", dlm_release_lockspace, handle_dlm_release_lockspace);
+
+	da_monitor_destroy_dlm();
+
+	rhashtable_free_and_destroy(&dlm_rv_hash, rhash_lock_free, NULL);
+}
+
+static struct rv_monitor rv_dlm = {
+	.name = "dlm",
+	.description = "dlm runtime lock compatibility verifier",
+	.enable = enable_dlm,
+	.disable = disable_dlm,
+	.reset = da_monitor_reset_all_dlm,
+	.enabled = 0,
+};
+
+static int __init register_dlm(void)
+{
+	lk_cache = KMEM_CACHE(dlm_rv_lock, 0);
+	if (!lk_cache)
+		return -ENOMEM;
+
+	hl_cache = KMEM_CACHE(dlm_rv_holder, 0);
+	if (!hl_cache) {
+		kmem_cache_destroy(lk_cache);
+		return -ENOMEM;
+	}
+
+	rv_register_monitor(&rv_dlm);
+	return 0;
+}
+
+static void __exit unregister_dlm(void)
+{
+	rv_unregister_monitor(&rv_dlm);
+
+	kmem_cache_destroy(hl_cache);
+	kmem_cache_destroy(lk_cache);
+}
+
+module_init(register_dlm);
+module_exit(unregister_dlm);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Alexander Aring <aahringo@redhat.com>");
+MODULE_DESCRIPTION("dlm: runtime lock compatibility verifier");
diff --git a/kernel/trace/rv/monitors/dlm/dlm.h b/kernel/trace/rv/monitors/dlm/dlm.h
new file mode 100644
index 000000000000..514614be2ca9
--- /dev/null
+++ b/kernel/trace/rv/monitors/dlm/dlm.h
@@ -0,0 +1,38 @@
+enum states_dlm {
+	valid_dlm = 0,
+	free_dlm,
+	state_max_dlm
+};
+
+#define INVALID_STATE state_max_dlm
+
+enum events_dlm {
+	all_unlock_dlm = 0,
+	with_others_compatible_dlm,
+	event_max_dlm
+};
+
+struct automaton_dlm {
+	char *state_names[state_max_dlm];
+	char *event_names[event_max_dlm];
+	unsigned char function[state_max_dlm][event_max_dlm];
+	unsigned char initial_state;
+	bool final_states[state_max_dlm];
+};
+
+static const struct automaton_dlm automaton_dlm = {
+	.state_names = {
+		"valid",
+		"free"
+	},
+	.event_names = {
+		"all_unlock",
+		"with_others_compatible"
+	},
+	.function = {
+		{      free_dlm,     valid_dlm },
+		{ INVALID_STATE, INVALID_STATE },
+	},
+	.initial_state = valid_dlm,
+	.final_states = { 0, 1 },
+};
diff --git a/kernel/trace/rv/monitors/dlm/dlm_da.h b/kernel/trace/rv/monitors/dlm/dlm_da.h
new file mode 100644
index 000000000000..064ed5085b30
--- /dev/null
+++ b/kernel/trace/rv/monitors/dlm/dlm_da.h
@@ -0,0 +1,143 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#ifndef __DLM_DA_RV__
+#define __DLM_DA_RV__
+
+/*
+ * Event handler for per_dlm_lock monitors.
+ */
+#define DECLARE_DA_MON_MODEL_HANDLER_PER_DLM_LOCK(name, type)					\
+												\
+static inline bool da_event_##name(struct da_monitor *da_mon, struct dlm_rv_lock *lk,		\
+				   enum events_##name event)					\
+{												\
+	type curr_state = da_monitor_curr_state_##name(da_mon);					\
+	type next_state = model_get_next_state_##name(curr_state, event);			\
+												\
+	if (next_state != INVALID_STATE) {							\
+		da_monitor_set_state_##name(da_mon, next_state);				\
+												\
+		trace_event_##name(model_get_state_name_##name(curr_state),			\
+				   model_get_event_name_##name(event),				\
+				   model_get_state_name_##name(next_state),			\
+				   model_is_final_state_##name(next_state));			\
+												\
+		return true;									\
+	}											\
+												\
+	if (rv_reacting_on_##name())								\
+		cond_react_##name(format_react_msg_##name(curr_state, event));			\
+												\
+	trace_error_##name(model_get_state_name_##name(curr_state),				\
+			   model_get_event_name_##name(event));					\
+												\
+	return false;										\
+}
+
+/*
+ * Functions to define, init and get a per-dlm-lock monitor.
+ */
+#define DECLARE_DA_MON_INIT_PER_DLM_LOCK(name, type)						\
+												\
+/*												\
+ * da_get_monitor_##name - return the monitor in the allocated slot for tsk			\
+ */												\
+static inline struct da_monitor *da_get_monitor_##name(struct dlm_rv_lock *lk)			\
+{												\
+	return &lk->rv.da_mon;									\
+}												\
+												\
+static void da_monitor_reset_all_##name(void)							\
+{												\
+}												\
+												\
+/*												\
+ * da_monitor_init_##name - initialize the per-task monitor					\
+ *												\
+ * Try to allocate a slot in the task's vector of monitors. If there				\
+ * is an available slot, use it and reset all task's monitor.					\
+ */												\
+static int da_monitor_init_##name(void)								\
+{												\
+	da_monitor_reset_all_##name();								\
+	return 0;										\
+}												\
+												\
+/*												\
+ * da_monitor_destroy_##name - return the allocated slot					\
+ */												\
+static inline void da_monitor_destroy_##name(void)						\
+{												\
+	return;											\
+}
+
+/*
+ * Handle event for per task.
+ */
+#define DECLARE_DA_MON_MONITOR_HANDLER_PER_DLM_LOCK(name, type)					\
+												\
+static inline void										\
+__da_handle_event_##name(struct da_monitor *da_mon, struct dlm_rv_lock *lk,			\
+			 enum events_##name event)						\
+{												\
+	bool retval;										\
+												\
+	retval = da_event_##name(da_mon, lk, event);						\
+	if (!retval)										\
+		da_monitor_reset_##name(da_mon);						\
+}												\
+												\
+/*												\
+ * da_handle_event_##name - handle an event							\
+ */												\
+static inline void										\
+da_handle_event_##name(struct dlm_rv_lock *lk, enum events_##name event)			\
+{												\
+	struct da_monitor *da_mon = da_get_monitor_##name(lk);					\
+	bool retval;										\
+												\
+	retval = da_monitor_handling_event_##name(da_mon);					\
+	if (!retval)										\
+		return;										\
+												\
+	__da_handle_event_##name(da_mon, lk, event);						\
+}												\
+												\
+/*												\
+ * da_handle_start_event_##name - start monitoring or handle event				\
+ *												\
+ * This function is used to notify the monitor that the system is returning			\
+ * to the initial state, so the monitor can start monitoring in the next event.			\
+ * Thus:											\
+ *												\
+ * If the monitor already started, handle the event.						\
+ * If the monitor did not start yet, start the monitor but skip the event.			\
+ */												\
+static inline bool										\
+da_handle_start_event_##name(struct dlm_rv_lock *lk, enum events_##name event)			\
+{												\
+	struct da_monitor *da_mon;								\
+												\
+	if (!da_monitor_enabled_##name())							\
+		return 0;									\
+												\
+	da_mon = da_get_monitor_##name(lk);							\
+												\
+	if (unlikely(!da_monitoring_##name(da_mon))) {						\
+		da_monitor_start_##name(da_mon);						\
+		return 0;									\
+	}											\
+												\
+	__da_handle_event_##name(da_mon, lk, event);						\
+												\
+	return 1;										\
+}
+
+/*
+ * Futher monitor types are expected, so make this a union.
+ */
+union rv_dlm_lock_monitor {
+	struct da_monitor da_mon;
+};
+
+#endif /* __DLM_DA_RV__ */
diff --git a/tools/verification/models/dlm.dot b/tools/verification/models/dlm.dot
new file mode 100644
index 000000000000..43092c865e3b
--- /dev/null
+++ b/tools/verification/models/dlm.dot
@@ -0,0 +1,14 @@
+digraph state_automaton {
+	{node [shape = circle] "valid"};
+	{node [shape = plaintext, style=invis, label=""] "__init_valid"};
+	{node [shape = doublecircle] "free"};
+	"__init_valid" -> "valid";
+	"valid" [label = "valid", color = green3]
+	"valid" -> "valid" [ label = "with_others_compatible" ];
+	"free" [label = "free"]
+	"valid" -> "free" [ label = "all_unlock" ];
+	{ rank = min ;
+		"__init_valid";
+		"valid";
+	}
+}
-- 
2.43.0

