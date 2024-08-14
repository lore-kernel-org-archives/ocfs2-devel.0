Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B8F1BA86C
	for <ocfs2-devel@lists.linux.dev>; Wed, 14 Aug 2024 14:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723646102; cv=none; b=Hn+r1n4wVMqZbWt/Ym5KLiTdOdipaxdWYLPHjGpMbsD/cxiQXkWifQYknVzE//cztICYw3clI8OdAxQmfVPuZuYvKopOusZ76hHvAvKhGNLkIR5ChsHCFl3bqHXSoaBg+YCdhY2BihqpIVXkwPwlTP9wQ/1ZqjOe+38bqtprtUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723646102; c=relaxed/simple;
	bh=zehiyL84+Yy7mrEewhGl7U+dyidathI9ZYfp5G8ZHJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pEF1FWdQXWD5pmly5bdVN0yqLmM+8NRTqJM2tAL0I0N3asXRXNcZ1wJCq7aVM8TT1Dcb0LnkE8uPSKq9XcXedwG+VUKFN6EhKM+W8/ZQKilHrfLIM/Hwnr4IoorJHc1b7gPOvdY07/7lnWhKUdryARd2dRniIFTGO1LrqcrIkvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VHgy4PmB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VHgy4PmB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723646094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d/fY3yXccWWtE+/SQnrMD3l5NmhlIdYNoPV261byjGA=;
	b=VHgy4PmBflIqjsBkfOEptbw9cYFjnjRf8PCgWzcyToVKa5sIpIKVFC7i42nJAyvwWLDUAj
	swnUffkLpSrQy/QhbtDELbbgg5bTMI7b05zhaMKhskyj5Muz1ixgyjFh5Fs2bLUzdlvRrO
	qeKKRgk+RcbvKz3wPJFKVEe2paSwsO8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-637-g_HyB81jMCyA91YB832SxA-1; Wed,
 14 Aug 2024 10:34:50 -0400
X-MC-Unique: g_HyB81jMCyA91YB832SxA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3BCF91944EB6;
	Wed, 14 Aug 2024 14:34:48 +0000 (UTC)
Received: from fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com (fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com [10.6.24.150])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B80A7300019A;
	Wed, 14 Aug 2024 14:34:45 +0000 (UTC)
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
	lucien.xin@gmail.com,
	aahringo@redhat.com
Subject: [RFC dlm/next 10/12] dlm: separate dlm lockspaces per net-namespace
Date: Wed, 14 Aug 2024 10:34:12 -0400
Message-ID: <20240814143414.1877505-11-aahringo@redhat.com>
In-Reply-To: <20240814143414.1877505-1-aahringo@redhat.com>
References: <20240814143414.1877505-1-aahringo@redhat.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

This patch separates the internal DLM lockspace handling on a per
net-namespace basis. The current handling of DLM offers that all
lockspaces are created on a local machine without separation and the
machine is part of a cluster with several nodes as other machines. This
patch allows us to create a cluster without running several machines on
one Linux kernel. We do that by separating all current global variables
on a per net-namespace basis, in this patch it is "struct dlm_net". This
patch "simply" convert mostly all global variables on a per net-namespace
basis and offer a new config layer to operate on this. The configfs UAPI
mechanism is using this config layer, as configfs isn't net-namespace
aware it only operates on "init_net" namespace. Further new UAPIs that
are namespace aware can operate on the config layer on a net-namespace
basis. The DLM config layer is implemented in "config.c" the current
configfs UAPI mechanism to access the config layer is implemented in
"configfs.c". The config layer uses a per net-namespace mutex lock to
avoid mutual access of configuration variables as this layer can be
accessed in future from multiple UAPI sources.

Character device access that is used for dlm locking calls from user
space are only accessible from init_net namespace, any open() on those
character devices will currently end in an -EOPNOTSUPP. To support such
a functionality may a different mechanism will be introduced.

This patch will separate the DLM sysfs handling by net-namespace by
using kset_type_create_and_add() and implementing the necessary
callbacks to reference to the right "struct net" that is part of the
per lockspace kobject.

Note as this patch series should have no effect as all users still apply
&init_net to dlm_new_lockspace() except that users of the DLM character
device don't open() those devices under &init_net will be rejected now.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/Makefile       |   1 +
 fs/dlm/config.c       | 699 ++++++++++++++++++++++++++++++++++++++++++
 fs/dlm/config.h       | 197 ++++++++++--
 fs/dlm/configfs.c     | 614 ++++++++++++++++---------------------
 fs/dlm/configfs.h     |  19 ++
 fs/dlm/debug_fs.c     |  24 +-
 fs/dlm/dir.c          |   4 +-
 fs/dlm/dlm_internal.h |  20 +-
 fs/dlm/lock.c         |  64 ++--
 fs/dlm/lock.h         |   3 +-
 fs/dlm/lockspace.c    | 192 +++++++-----
 fs/dlm/lockspace.h    |  13 +-
 fs/dlm/lowcomms.c     | 521 ++++++++++++++++---------------
 fs/dlm/lowcomms.h     |  29 +-
 fs/dlm/main.c         |   5 -
 fs/dlm/member.c       |  36 +--
 fs/dlm/midcomms.c     | 287 ++++++++---------
 fs/dlm/midcomms.h     |  31 +-
 fs/dlm/plock.c        |   2 +-
 fs/dlm/rcom.c         |  16 +-
 fs/dlm/rcom.h         |   3 +-
 fs/dlm/recover.c      |  17 +-
 fs/dlm/user.c         |  63 ++--
 fs/dlm/user.h         |   2 +-
 24 files changed, 1855 insertions(+), 1007 deletions(-)
 create mode 100644 fs/dlm/config.c
 create mode 100644 fs/dlm/configfs.h

diff --git a/fs/dlm/Makefile b/fs/dlm/Makefile
index 48959179fc78..c37f9fc361c6 100644
--- a/fs/dlm/Makefile
+++ b/fs/dlm/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_DLM) +=		dlm.o
 dlm-y :=			ast.o \
+				config.o \
 				configfs.o \
 				dir.o \
 				lock.o \
diff --git a/fs/dlm/config.c b/fs/dlm/config.c
new file mode 100644
index 000000000000..239ce69ef0f1
--- /dev/null
+++ b/fs/dlm/config.c
@@ -0,0 +1,699 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <net/netns/generic.h>
+
+#include "dlm_internal.h"
+#include "lockspace.h"
+#include "midcomms.h"
+#include "lowcomms.h"
+#include "configfs.h"
+#include "config.h"
+
+const struct rhashtable_params dlm_rhash_rsb_params = {
+	.nelem_hint = 3, /* start small */
+	.key_len = DLM_RESNAME_MAXLEN,
+	.key_offset = offsetof(struct dlm_rsb, res_name),
+	.head_offset = offsetof(struct dlm_rsb, res_node),
+	.automatic_shrinking = true,
+};
+
+/* Config file defaults */
+#define DEFAULT_TCP_PORT       21064
+#define DEFAULT_RSBTBL_SIZE     1024
+#define DEFAULT_RECOVER_TIMER      5
+#define DEFAULT_TOSS_SECS         10
+#define DEFAULT_SCAN_SECS          5
+#define DEFAULT_LOG_DEBUG          0
+#define DEFAULT_LOG_INFO           1
+#define DEFAULT_PROTOCOL           DLM_PROTO_TCP
+#define DEFAULT_MARK               0
+#define DEFAULT_NEW_RSB_COUNT    128
+#define DEFAULT_RECOVER_CALLBACKS  0
+#define DEFAULT_CLUSTER_NAME      ""
+
+static int __net_init dlm_net_init(struct net *net)
+{
+	struct dlm_net *dn = dlm_pernet(net);
+
+	write_pnet(&dn->net, net);
+	dn->dlm_monitor_unused = 1;
+
+	dn->config.ci_tcp_port = cpu_to_be16(DEFAULT_TCP_PORT);
+	dn->config.ci_buffer_size = DLM_MAX_SOCKET_BUFSIZE;
+	dn->config.ci_rsbtbl_size = DEFAULT_RSBTBL_SIZE;
+	dn->config.ci_recover_timer = DEFAULT_RECOVER_TIMER;
+	dn->config.ci_toss_secs = DEFAULT_TOSS_SECS;
+	dn->config.ci_scan_secs = DEFAULT_SCAN_SECS;
+	dn->config.ci_log_debug = DEFAULT_LOG_DEBUG;
+	dn->config.ci_log_info = DEFAULT_LOG_INFO;
+	dn->config.ci_protocol = DEFAULT_PROTOCOL;
+	dn->config.ci_mark = DEFAULT_MARK;
+	dn->config.ci_new_rsb_count = DEFAULT_NEW_RSB_COUNT;
+	dn->config.ci_recover_callbacks = DEFAULT_RECOVER_CALLBACKS;
+	strscpy(dn->config.ci_cluster_name, DEFAULT_CLUSTER_NAME);
+
+	dlm_lockspace_net_init(dn);
+	dlm_midcomms_init(dn);
+
+	mutex_init(&dn->cfg_lock);
+	INIT_LIST_HEAD(&dn->nodes);
+	INIT_LIST_HEAD(&dn->lockspaces);
+
+	return 0;
+}
+
+static void __net_exit dlm_net_exit(struct net *net)
+{
+	struct dlm_net *dn = dlm_pernet(net);
+
+	dlm_midcomms_exit(dn);
+}
+
+static unsigned int dlm_net_id __read_mostly;
+
+static struct pernet_operations dlm_net_ops = {
+	.init = dlm_net_init,
+	.exit = dlm_net_exit,
+	.id = &dlm_net_id,
+	.size = sizeof(struct dlm_net),
+};
+
+struct dlm_net *dlm_pernet(struct net *net)
+{
+	return dlm_net_id ? net_generic(net, dlm_net_id) : NULL;
+}
+
+int __init dlm_config_init(void)
+{
+	int rv;
+
+	rv = register_pernet_subsys(&dlm_net_ops);
+	if (rv)
+		return rv;
+
+	rv = dlm_configfs_init();
+	if (rv) {
+		unregister_pernet_subsys(&dlm_net_ops);
+		dlm_net_id = 0;
+	}
+
+	return rv;
+}
+
+void dlm_config_exit(void)
+{
+	dlm_configfs_exit();
+	unregister_pernet_subsys(&dlm_net_ops);
+	dlm_net_id = 0;
+}
+
+unsigned int dlm_our_nodeid(struct dlm_net *dn)
+{
+	return dn->our_node->id;
+}
+
+int dlm_cfg_set_cluster_name(struct dlm_net *dn, const char *name)
+{
+	mutex_lock(&dn->cfg_lock);
+	if (dlm_lowcomms_is_running(dn)) {
+		mutex_unlock(&dn->cfg_lock);
+		return -EBUSY;
+	}
+
+	strscpy(dn->config.ci_cluster_name, name);
+	mutex_unlock(&dn->cfg_lock);
+	return 0;
+}
+
+int dlm_cfg_set_port(struct dlm_net *dn, __be16 port)
+{
+	if (!port)
+		return -EINVAL;
+
+	mutex_lock(&dn->cfg_lock);
+	if (dlm_lowcomms_is_running(dn)) {
+		mutex_unlock(&dn->cfg_lock);
+		return -EBUSY;
+	}
+
+	dn->config.ci_tcp_port = port;
+	mutex_unlock(&dn->cfg_lock);
+
+	return 0;
+}
+
+int dlm_cfg_set_buffer_size(struct dlm_net *dn, unsigned int size)
+{
+	if (size < DLM_MAX_SOCKET_BUFSIZE)
+		return -EINVAL;
+
+	mutex_lock(&dn->cfg_lock);
+	if (dlm_lowcomms_is_running(dn)) {
+		mutex_unlock(&dn->cfg_lock);
+		return -EBUSY;
+	}
+
+	dn->config.ci_buffer_size = size;
+	mutex_unlock(&dn->cfg_lock);
+
+	return 0;
+}
+
+int dlm_cfg_set_protocol(struct dlm_net *dn, unsigned int protocol)
+{
+	switch (protocol) {
+	case 0:
+		/* TCP */
+		break;
+	case 1:
+		/* SCTP */
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	mutex_lock(&dn->cfg_lock);
+	if (dlm_lowcomms_is_running(dn)) {
+		mutex_unlock(&dn->cfg_lock);
+		return -EBUSY;
+	}
+
+	dn->config.ci_protocol = protocol;
+	mutex_unlock(&dn->cfg_lock);
+
+	return 0;
+}
+
+int dlm_cfg_set_toss_secs(struct dlm_net *dn, unsigned int secs)
+{
+	if (!secs)
+		return -EINVAL;
+
+	mutex_lock(&dn->cfg_lock);
+	if (dlm_lowcomms_is_running(dn)) {
+		mutex_unlock(&dn->cfg_lock);
+		return -EBUSY;
+	}
+
+	dn->config.ci_toss_secs = secs;
+	mutex_unlock(&dn->cfg_lock);
+
+	return 0;
+}
+
+int dlm_cfg_set_recover_timer(struct dlm_net *dn, unsigned int secs)
+{
+	if (!secs)
+		return -EINVAL;
+
+	mutex_lock(&dn->cfg_lock);
+	if (dlm_lowcomms_is_running(dn)) {
+		mutex_unlock(&dn->cfg_lock);
+		return -EBUSY;
+	}
+
+	dn->config.ci_recover_timer = secs;
+	mutex_unlock(&dn->cfg_lock);
+
+	return 0;
+}
+
+int dlm_cfg_set_log_debug(struct dlm_net *dn, unsigned int on)
+{
+	mutex_lock(&dn->cfg_lock);
+	dn->config.ci_log_debug = on;
+	mutex_unlock(&dn->cfg_lock);
+
+	return 0;
+}
+
+int dlm_cfg_set_log_info(struct dlm_net *dn, unsigned int on)
+{
+	mutex_lock(&dn->cfg_lock);
+	dn->config.ci_log_info = on;
+	mutex_unlock(&dn->cfg_lock);
+
+	return 0;
+}
+
+int dlm_cfg_set_mark(struct dlm_net *dn, unsigned int mark)
+{
+	mutex_lock(&dn->cfg_lock);
+	if (dlm_lowcomms_is_running(dn)) {
+		mutex_unlock(&dn->cfg_lock);
+		return -EBUSY;
+	}
+
+	dn->config.ci_mark = 1;
+	mutex_unlock(&dn->cfg_lock);
+
+	return 0;
+}
+
+int dlm_cfg_set_recover_callbacks(struct dlm_net *dn, unsigned int on)
+{
+	mutex_lock(&dn->cfg_lock);
+	if (dlm_lowcomms_is_running(dn)) {
+		mutex_unlock(&dn->cfg_lock);
+		return -EBUSY;
+	}
+
+	dn->config.ci_recover_callbacks = on;
+	mutex_unlock(&dn->cfg_lock);
+
+	return 0;
+}
+
+struct dlm_cfg_ls *dlm_cfg_get_ls(struct dlm_net *dn, const char *lsname)
+{
+	struct dlm_cfg_ls *iter, *ls = NULL;
+
+	list_for_each_entry(iter, &dn->lockspaces, list) {
+		if (!strncmp(iter->name, lsname, DLM_LOCKSPACE_LEN)) {
+			ls = iter;
+			break;
+		}
+	}
+
+	return ls;
+}
+
+/* caller must free mem */
+int dlm_config_nodes(struct dlm_net *dn, char *lsname,
+		     struct dlm_config_node **nodes_out,
+		     unsigned int *count_out)
+{
+	struct dlm_config_node *nodes, *node;
+	struct dlm_cfg_member *mb;
+	struct dlm_cfg_ls *ls;
+	int rv = 0, count;
+
+	mutex_lock(&dn->cfg_lock);
+	ls = dlm_cfg_get_ls(dn, lsname);
+	if (!ls) {
+		rv = -EEXIST;
+		goto out;
+	}
+
+	if (!ls->members_count) {
+		rv = -EINVAL;
+		goto out;
+	}
+
+	count = ls->members_count;
+	nodes = kcalloc(count, sizeof(struct dlm_config_node), GFP_NOFS);
+	if (!nodes) {
+		rv = -ENOMEM;
+		goto out;
+	}
+
+	node = nodes;
+	list_for_each_entry(mb, &ls->members, list) {
+		node->nodeid = mb->nd->id;
+		node->weight = mb->weight;
+		node->new = mb->new;
+		node->comm_seq = mb->nd->seq;
+		node++;
+
+		mb->new = 0;
+	}
+
+	*count_out = count;
+	*nodes_out = nodes;
+ out:
+	mutex_unlock(&dn->cfg_lock);
+
+	return rv;
+}
+
+struct dlm_cfg_node *dlm_cfg_get_node(struct dlm_net *dn, unsigned int id)
+{
+	struct dlm_cfg_node *iter, *con = NULL;
+
+	list_for_each_entry(iter, &dn->nodes, list) {
+		if (iter->id == id) {
+			con = iter;
+			break;
+		}
+	}
+
+	return con;
+}
+
+static int dlm_cfg_set_addr(struct dlm_net *dn, struct dlm_cfg_node *nd,
+			    unsigned int id, struct sockaddr_storage *addr)
+{
+	int rv;
+
+	/* TODO -EEXIST */
+	if (nd->addrs_count >= DLM_MAX_ADDR_COUNT)
+		return -ENOSPC;
+
+	rv = dlm_midcomms_addr(dn, nd->id, addr);
+	if (rv)
+		return rv;
+
+	nd->addrs[nd->addrs_count++] = *addr;
+
+	return 0;
+}
+
+int dlm_cfg_new_node(struct dlm_net *dn, unsigned int id,
+		    unsigned int mark, struct sockaddr_storage *addrs,
+		    size_t addrs_count)
+{
+	struct dlm_cfg_node *nd;
+	int i, rv = 0;
+
+	mutex_lock(&dn->cfg_lock);
+	if (dlm_lowcomms_is_running(dn)) {
+		rv = -EBUSY;
+		goto out;
+	}
+
+	nd = dlm_cfg_get_node(dn, id);
+	if (nd) {
+		rv = -EEXIST;
+		goto out;
+	}
+
+	nd = kzalloc(sizeof(*nd), GFP_ATOMIC);
+	if (!nd) {
+		rv = -ENOMEM;
+		goto out;
+	}
+
+	nd->seq = dn->dlm_cfg_node_count++;
+	if (!nd->seq)
+		nd->seq = dn->dlm_cfg_node_count++;
+
+	nd->id = id;
+	nd->mark = mark;
+
+	/* due configfs optional */
+	if (addrs && addrs_count) {
+		if (addrs_count >= DLM_MAX_ADDR_COUNT) {
+			rv = -ENOSPC;
+			kfree(nd);
+			goto out;
+		}
+
+		for (i = 0; i < addrs_count; i++) {
+			rv = dlm_cfg_set_addr(dn, nd, i, &addrs[i]);
+			if (rv < 0) {
+				kfree(nd);
+				goto out;
+			}
+		}
+
+		nd->addrs_count = addrs_count;
+	}
+
+	nd->idx = ++dn->node_idx;
+	list_add_tail(&nd->list, &dn->nodes);
+
+out:
+	mutex_unlock(&dn->cfg_lock);
+
+	return rv;
+}
+
+int dlm_cfg_del_node(struct dlm_net *dn, unsigned int id)
+{
+	struct dlm_cfg_node *nd;
+
+	mutex_lock(&dn->cfg_lock);
+	if (dlm_lowcomms_is_running(dn)) {
+		mutex_unlock(&dn->cfg_lock);
+		return -EBUSY;
+	}
+
+	nd = dlm_cfg_get_node(dn, id);
+	if (!nd) {
+		mutex_unlock(&dn->cfg_lock);
+		return -ENOENT;
+	}
+
+	if (dn->our_node == nd) {
+		if (nd->used != 1) {
+			mutex_unlock(&dn->cfg_lock);
+			return -EBUSY;
+		}
+
+		dn->our_node = NULL;
+	} else {
+		if (nd->used != 0) {
+			mutex_unlock(&dn->cfg_lock);
+			return -EBUSY;
+		}
+	}
+
+	list_del(&nd->list);
+	dlm_midcomms_close(dn, id);
+	mutex_unlock(&dn->cfg_lock);
+
+	kfree(nd);
+
+	return 0;
+}
+
+int dlm_cfg_set_our_node(struct dlm_net *dn, unsigned int id)
+{
+	struct dlm_cfg_node *nd;
+
+	mutex_lock(&dn->cfg_lock);
+	if (dlm_lowcomms_is_running(dn)) {
+		mutex_unlock(&dn->cfg_lock);
+		return -EBUSY;
+	}
+
+	nd = dlm_cfg_get_node(dn, id);
+	if (!nd) {
+		mutex_unlock(&dn->cfg_lock);
+		return -ENOENT;
+	}
+
+	if (dn->our_node)
+		dn->our_node->used--;
+
+	dn->our_node = nd;
+	nd->used++;
+	mutex_unlock(&dn->cfg_lock);
+
+	return 0;
+}
+
+static struct dlm_cfg_member *
+dlm_cfg_get_member(struct dlm_cfg_ls *ls, unsigned int id)
+{
+	struct dlm_cfg_member *iter, *mb = NULL;
+
+	list_for_each_entry(iter, &ls->members, list) {
+		if (iter->nd->id == id) {
+			mb = iter;
+			break;
+		}
+	}
+
+	return mb;
+}
+
+struct dlm_cfg_member *
+dlm_cfg_get_ls_member(struct dlm_net *dn, const char *lsname,
+		      unsigned int nodeid)
+{
+	struct dlm_cfg_ls *ls;
+
+	ls = dlm_cfg_get_ls(dn, lsname);
+	if (!ls)
+		return NULL;
+
+	return dlm_cfg_get_member(ls, nodeid);
+}
+
+int dlm_cfg_add_member(struct dlm_net *dn, const char *lsname,
+		       unsigned int id, unsigned int weight)
+{
+	struct dlm_cfg_member *mb;
+	struct dlm_cfg_node *nd;
+	struct dlm_cfg_ls *ls;
+	bool new_ls = false;
+
+	mutex_lock(&dn->cfg_lock);
+	ls = dlm_cfg_get_ls(dn, lsname);
+	if (!ls) {
+		ls = kzalloc(sizeof(*ls), GFP_ATOMIC);
+		if (!ls) {
+			mutex_unlock(&dn->cfg_lock);
+			return -ENOMEM;
+		}
+
+		strscpy(ls->name, lsname);
+		INIT_LIST_HEAD(&ls->members);
+		ls->idx = ++dn->ls_idx;
+		new_ls = true;
+	} else {
+		mb = dlm_cfg_get_member(ls, id);
+		if (mb) {
+			mutex_unlock(&dn->cfg_lock);
+			return -EEXIST;
+		}
+	}
+
+	nd = dlm_cfg_get_node(dn, id);
+	if (!nd) {
+		mutex_unlock(&dn->cfg_lock);
+		if (new_ls)
+			kfree(ls);
+		return -ENOENT;
+	}
+
+	mb = kzalloc(sizeof(*mb), GFP_ATOMIC);
+	if (!mb) {
+		mutex_unlock(&dn->cfg_lock);
+		if (new_ls)
+			kfree(ls);
+		return -ENOMEM;
+	}
+
+	nd->used++;
+	mb->nd = nd;
+	mb->ls = ls;
+	mb->weight = weight;
+	mb->new = 1;
+
+	list_add_tail(&mb->list, &ls->members);
+	ls->members_count++;
+	mb->idx = ++ls->member_idx;
+
+	if (new_ls)
+		list_add_tail(&ls->list, &dn->lockspaces);
+	mutex_unlock(&dn->cfg_lock);
+
+	return 0;
+}
+
+int dlm_cfg_del_member(struct dlm_net *dn, const char *lsname, unsigned int id)
+{
+	struct dlm_cfg_member *mb;
+
+	mutex_lock(&dn->cfg_lock);
+	mb = dlm_cfg_get_ls_member(dn, lsname, id);
+	if (!mb) {
+		mutex_unlock(&dn->cfg_lock);
+		return -ENOENT;
+	}
+
+	mb->nd->used--;
+	list_del(&mb->list);
+	mb->ls->members_count--;
+	if (!mb->ls->members_count)
+		list_del(&mb->ls->list);
+	mutex_unlock(&dn->cfg_lock);
+
+	kfree(mb);
+
+	return 0;
+}
+
+int dlm_cfg_add_addr(struct dlm_net *dn, unsigned int id,
+		     struct sockaddr_storage *addr)
+{
+	struct dlm_cfg_node *nd;
+	int rv;
+
+	mutex_lock(&dn->cfg_lock);
+	if (dlm_lowcomms_is_running(dn)) {
+		mutex_unlock(&dn->cfg_lock);
+		return -EBUSY;
+	}
+
+	nd = dlm_cfg_get_node(dn, id);
+	if (!nd) {
+		mutex_unlock(&dn->cfg_lock);
+		return -ENOENT;
+	}
+
+	rv = dlm_cfg_set_addr(dn, nd, id, addr);
+	mutex_unlock(&dn->cfg_lock);
+
+	return rv;
+}
+
+int dlm_comm_seq(struct dlm_net *dn, unsigned int id, uint32_t *seq)
+{
+	struct dlm_cfg_node *nd;
+
+	mutex_lock(&dn->cfg_lock);
+	nd = dlm_cfg_get_node(dn, id);
+	if (!nd) {
+		mutex_unlock(&dn->cfg_lock);
+		return -ENOENT;
+	}
+
+	*seq = nd->seq;
+	mutex_unlock(&dn->cfg_lock);
+
+	return 0;
+}
+
+/* num 0 is first addr, num 1 is second addr */
+int dlm_our_addr(struct dlm_net *dn, struct sockaddr_storage *addr, int num)
+{
+	mutex_lock(&dn->cfg_lock);
+	if (!dn->our_node) {
+		mutex_unlock(&dn->cfg_lock);
+		return -1;
+	}
+
+	if (num >= dn->our_node->addrs_count) {
+		mutex_unlock(&dn->cfg_lock);
+		return -1;
+	}
+
+	memcpy(addr, &dn->our_node->addrs[num], sizeof(*addr));
+	mutex_unlock(&dn->cfg_lock);
+
+	return 0;
+}
+
+int dlm_cfg_set_node_mark(struct dlm_net *dn, unsigned int nodeid,
+			  unsigned int mark)
+{
+	struct dlm_cfg_node *nd;
+
+	mutex_lock(&dn->cfg_lock);
+	if (dlm_lowcomms_is_running(dn)) {
+		mutex_unlock(&dn->cfg_lock);
+		return -EBUSY;
+	}
+
+	nd = dlm_cfg_get_node(dn, nodeid);
+	if (!nd) {
+		mutex_unlock(&dn->cfg_lock);
+		return -ENOENT;
+	}
+
+	nd->mark = mark;
+	mutex_unlock(&dn->cfg_lock);
+
+	return 0;
+}
+
+int dlm_cfg_set_weight(struct dlm_net *dn, const char *lsname,
+		       unsigned int nodeid, unsigned int weight)
+{
+	struct dlm_cfg_member *mb;
+
+	mutex_lock(&dn->cfg_lock);
+	mb = dlm_cfg_get_ls_member(dn, lsname, nodeid);
+	if (!mb) {
+		mutex_unlock(&dn->cfg_lock);
+		return -ENOENT;
+	}
+
+	mb->weight = weight;
+	mutex_unlock(&dn->cfg_lock);
+
+	return 0;
+}
diff --git a/fs/dlm/config.h b/fs/dlm/config.h
index 9abe71453c5e..ca48c22cbc73 100644
--- a/fs/dlm/config.h
+++ b/fs/dlm/config.h
@@ -1,19 +1,26 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/******************************************************************************
-*******************************************************************************
-**
-**  Copyright (C) Sistina Software, Inc.  1997-2003  All rights reserved.
-**  Copyright (C) 2004-2011 Red Hat, Inc.  All rights reserved.
-**
-**
-*******************************************************************************
-******************************************************************************/
-
-#ifndef __CONFIG_DOT_H__
-#define __CONFIG_DOT_H__
+#ifndef __DLM_CONFIG_H__
+#define __DLM_CONFIG_H__
+
+#include <uapi/linux/dlmconstants.h>
+#include <linux/socket.h>
+
+#define CONN_HASH_SIZE 32
 
 #define DLM_MAX_SOCKET_BUFSIZE	4096
 
+#define DLM_MAX_ADDR_COUNT 3
+
+#define DLM_PROTO_TCP	0
+#define DLM_PROTO_SCTP	1
+
+#define DLM_DEFAULT_WEIGHT 1
+#define DLM_DEFAULT_MARK 0
+
+extern const struct rhashtable_params dlm_rhash_rsb_params;
+
+struct dlm_net;
+
 struct dlm_config_node {
 	int nodeid;
 	int weight;
@@ -21,38 +28,176 @@ struct dlm_config_node {
 	uint32_t comm_seq;
 };
 
-extern const struct rhashtable_params dlm_rhash_rsb_params;
+struct dlm_proto_ops {
+	bool try_new_addr;
+	const char *name;
+	int proto;
 
-#define DLM_MAX_ADDR_COUNT 3
+	void (*sockopts)(struct socket *sock);
+	int (*bind)(struct dlm_net *dn, struct socket *sock);
+	int (*listen_validate)(const struct dlm_net *dn);
+	void (*listen_sockopts)(struct socket *sock);
+	int (*listen_bind)(struct dlm_net *dn, struct socket *sock);
+};
 
-#define DLM_PROTO_TCP	0
-#define DLM_PROTO_SCTP	1
+struct listen_connection {
+	struct socket *sock;
+	struct work_struct rwork;
+};
 
 struct dlm_config_info {
 	__be16 ci_tcp_port;
 	unsigned int ci_buffer_size;
-	unsigned int ci_rsbtbl_size;
 	unsigned int ci_recover_timer;
 	unsigned int ci_toss_secs;
-	unsigned int ci_scan_secs;
 	unsigned int ci_log_debug;
 	unsigned int ci_log_info;
 	unsigned int ci_protocol;
 	unsigned int ci_mark;
-	unsigned int ci_new_rsb_count;
 	unsigned int ci_recover_callbacks;
 	char ci_cluster_name[DLM_LOCKSPACE_LEN];
+
+	/* unused, still here for backwards compatibility */
+	unsigned int ci_rsbtbl_size;
+	unsigned int ci_new_rsb_count;
+	unsigned int ci_scan_secs;
+};
+
+struct listen_sock_callbacks {
+	void (*sk_error_report)(struct sock *sk);
+	void (*sk_data_ready)(struct sock *sk);
+	void (*sk_state_change)(struct sock *sk);
+	void (*sk_write_space)(struct sock *sk);
+};
+
+struct dlm_cfg_ls {
+	char name[DLM_LOCKSPACE_LEN];
+	struct list_head members;
+	unsigned int members_count;
+	unsigned int member_idx;
+	unsigned int idx;
+
+	struct list_head list;
+};
+
+struct dlm_cfg_node {
+	unsigned int id;
+	uint32_t mark;
+	struct sockaddr_storage addrs[DLM_MAX_ADDR_COUNT];
+	unsigned int addrs_count;
+	unsigned int idx;
+	unsigned int seq;
+	unsigned int used;
+
+	struct list_head list;
 };
 
-extern struct dlm_config_info dlm_config;
+struct dlm_cfg_member {
+	struct dlm_cfg_node *nd;
+	struct dlm_cfg_ls *ls;
+	unsigned int weight;
+	unsigned int idx;
+	bool new;
+
+	struct list_head list;
+};
+
+struct dlm_net {
+	possible_net_t net;
+	struct dlm_config_info config;
+
+	atomic_t dlm_monitor_opened;
+	int dlm_monitor_unused;
+
+	struct listen_sock_callbacks listen_sock;
+	struct listen_connection listen_con;
+	struct sockaddr_storage dlm_local_addr[DLM_MAX_ADDR_COUNT];
+	int dlm_local_count;
+
+	/* Work queues */
+	struct workqueue_struct *io_workqueue;
+	struct workqueue_struct *process_workqueue;
 
+	struct hlist_head connection_hash[CONN_HASH_SIZE];
+	spinlock_t connections_lock;
+	struct srcu_struct connections_srcu;
+
+	const struct dlm_proto_ops *dlm_proto_ops;
+
+	struct work_struct process_work;
+	spinlock_t processqueue_lock;
+	bool process_dlm_messages_pending;
+	wait_queue_head_t processqueue_wq;
+	atomic_t processqueue_count;
+	struct list_head processqueue;
+
+	struct hlist_head node_hash[CONN_HASH_SIZE];
+	spinlock_t nodes_lock;
+	struct srcu_struct nodes_srcu;
+
+	/* This mutex prevents that midcomms_close() is running while
+	 * stop() or remove(). As I experienced invalid memory access
+	 * behaviours when DLM_DEBUG_FENCE_TERMINATION is enabled and
+	 * resetting machines. I will end in some double deletion in nodes
+	 * datastructure.
+	 */
+	struct mutex close_lock;
+
+	int ls_count;
+	struct mutex ls_lock;
+	struct list_head lslist;
+	spinlock_t lslist_lock;
+
+	struct mutex cfg_lock;
+	uint32_t dlm_cfg_node_count;
+	struct dlm_cfg_node *our_node;
+	unsigned int node_idx;
+	struct list_head nodes;
+	unsigned int ls_idx;
+	struct list_head lockspaces;
+};
+
+struct dlm_net *dlm_pernet(struct net *net);
 int dlm_config_init(void);
 void dlm_config_exit(void);
-int dlm_config_nodes(char *lsname, struct dlm_config_node **nodes_out,
-		     int *count_out);
-int dlm_comm_seq(int nodeid, uint32_t *seq);
-int dlm_our_nodeid(void);
-int dlm_our_addr(struct sockaddr_storage *addr, int num);
 
-#endif				/* __CONFIG_DOT_H__ */
+unsigned int dlm_our_nodeid(struct dlm_net *dn);
+
+struct dlm_cfg_node *dlm_cfg_get_node(struct dlm_net *dn, unsigned int id);
+struct dlm_cfg_ls *dlm_cfg_get_ls(struct dlm_net *dn, const char *lsname);
+struct dlm_cfg_member *
+dlm_cfg_get_ls_member(struct dlm_net *dn, const char *lsname,
+		      unsigned int nodeid);
+
+int dlm_cfg_set_cluster_name(struct dlm_net *dn, const char *name);
+int dlm_cfg_set_port(struct dlm_net *dn, __be16 port);
+int dlm_cfg_set_buffer_size(struct dlm_net *dn, unsigned int size);
+int dlm_cfg_set_protocol(struct dlm_net *dn, unsigned int protocol);
+int dlm_cfg_set_toss_secs(struct dlm_net *dn, unsigned int secs);
+int dlm_cfg_set_recover_timer(struct dlm_net *dn, unsigned int secs);
+int dlm_cfg_set_mark(struct dlm_net *dn, unsigned int mark);
+int dlm_cfg_set_features(struct dlm_net *dn, unsigned int features);
+int dlm_cfg_set_log_debug(struct dlm_net *dn, unsigned int on);
+int dlm_cfg_set_log_info(struct dlm_net *dn, unsigned int on);
+int dlm_cfg_set_recover_callbacks(struct dlm_net *dn, unsigned int on);
+
+int dlm_cfg_new_node(struct dlm_net *dn, unsigned int id, unsigned int mark,
+		     struct sockaddr_storage *addrs, size_t addrs_count);
+int dlm_cfg_del_node(struct dlm_net *dn, unsigned int id);
+int dlm_cfg_set_our_node(struct dlm_net *dn, unsigned int id);
+int dlm_cfg_set_node_mark(struct dlm_net *dn, unsigned int nodeid, unsigned int mark);
+int dlm_cfg_add_member(struct dlm_net *dn, const char *lsname,
+		       unsigned int id, unsigned int weight);
+int dlm_cfg_del_member(struct dlm_net *dn, const char *lsname, unsigned int id);
+int dlm_cfg_add_addr(struct dlm_net *dn, unsigned int id,
+		     struct sockaddr_storage *addr);
+int dlm_cfg_set_weight(struct dlm_net *dn, const char *lsname,
+		       unsigned int nodeid, unsigned int weight);
+
+int dlm_config_nodes(struct dlm_net *dn, char *lsname,
+		     struct dlm_config_node **nodes_out,
+		     unsigned int *count_out);
+int dlm_comm_seq(struct dlm_net *dn, unsigned int id, uint32_t *seq);
+int dlm_our_addr(struct dlm_net *dn, struct sockaddr_storage *addr, int num);
 
+#endif /* __DLM_CONFIG_H__ */
diff --git a/fs/dlm/configfs.c b/fs/dlm/configfs.c
index a98f0e746e9e..a4b449fd3022 100644
--- a/fs/dlm/configfs.c
+++ b/fs/dlm/configfs.c
@@ -1,13 +1,13 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /******************************************************************************
-*******************************************************************************
-**
-**  Copyright (C) Sistina Software, Inc.  1997-2003  All rights reserved.
-**  Copyright (C) 2004-2011 Red Hat, Inc.  All rights reserved.
-**
-**
-*******************************************************************************
-******************************************************************************/
+ ******************************************************************************
+ **
+ **  Copyright (C) Sistina Software, Inc.  1997-2003  All rights reserved.
+ **  Copyright (C) 2004-2011 Red Hat, Inc.  All rights reserved.
+ **
+ **
+ ******************************************************************************
+ ******************************************************************************/
 
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -19,9 +19,10 @@
 #include <net/ipv6.h>
 #include <net/sock.h>
 
-#include "config.h"
+#include "configfs.h"
 #include "midcomms.h"
 #include "lowcomms.h"
+#include "config.h"
 
 /*
  * /config/dlm/<cluster>/spaces/<space>/nodes/<node>/nodeid (refers to <node>)
@@ -35,8 +36,6 @@
 
 static struct config_group *space_list;
 static struct config_group *comm_list;
-static struct dlm_comm *local_comm;
-static uint32_t dlm_comm_count;
 
 struct dlm_clusters;
 struct dlm_cluster;
@@ -63,14 +62,6 @@ static void release_node(struct config_item *);
 static struct configfs_attribute *comm_attrs[];
 static struct configfs_attribute *node_attrs[];
 
-const struct rhashtable_params dlm_rhash_rsb_params = {
-	.nelem_hint = 3, /* start small */
-	.key_len = DLM_RESNAME_MAXLEN,
-	.key_offset = offsetof(struct dlm_rsb, res_name),
-	.head_offset = offsetof(struct dlm_rsb, res_node),
-	.automatic_shrinking = true,
-};
-
 struct dlm_cluster {
 	struct config_group group;
 	struct dlm_spaces *sps;
@@ -101,14 +92,26 @@ enum {
 
 static ssize_t cluster_cluster_name_show(struct config_item *item, char *buf)
 {
-	return sprintf(buf, "%s\n", dlm_config.ci_cluster_name);
+	struct dlm_net *dn = dlm_pernet(&init_net);
+	int rv;
+
+	mutex_lock(&dn->cfg_lock);
+	rv = sprintf(buf, "%s\n", dn->config.ci_cluster_name);
+	mutex_unlock(&dn->cfg_lock);
+
+	return rv;
 }
 
 static ssize_t cluster_cluster_name_store(struct config_item *item,
 					  const char *buf, size_t len)
 {
-	strscpy(dlm_config.ci_cluster_name, buf,
-		sizeof(dlm_config.ci_cluster_name));
+	struct dlm_net *dn = dlm_pernet(&init_net);
+
+	mutex_lock(&dn->cfg_lock);
+	strscpy(dn->config.ci_cluster_name, buf,
+		sizeof(dn->config.ci_cluster_name));
+	mutex_unlock(&dn->cfg_lock);
+
 	return len;
 }
 
@@ -116,23 +119,20 @@ CONFIGFS_ATTR(cluster_, cluster_name);
 
 static ssize_t cluster_tcp_port_show(struct config_item *item, char *buf)
 {
-	return sprintf(buf, "%u\n", be16_to_cpu(dlm_config.ci_tcp_port));
-}
-
-static int dlm_check_zero_and_dlm_running(unsigned int x)
-{
-	if (!x)
-		return -EINVAL;
+	struct dlm_net *dn = dlm_pernet(&init_net);
+	int rv;
 
-	if (dlm_lowcomms_is_running())
-		return -EBUSY;
+	mutex_lock(&dn->cfg_lock);
+	rv = sprintf(buf, "%u\n", be16_to_cpu(dn->config.ci_tcp_port));
+	mutex_unlock(&dn->cfg_lock);
 
-	return 0;
+	return rv;
 }
 
 static ssize_t cluster_tcp_port_store(struct config_item *item,
 				      const char *buf, size_t len)
 {
+	struct dlm_net *dn = dlm_pernet(&init_net);
 	int rc;
 	u16 x;
 
@@ -143,20 +143,19 @@ static ssize_t cluster_tcp_port_store(struct config_item *item,
 	if (rc)
 		return rc;
 
-	rc = dlm_check_zero_and_dlm_running(x);
+	rc = dlm_cfg_set_port(dn, cpu_to_be16(x));
 	if (rc)
 		return rc;
 
-	dlm_config.ci_tcp_port = cpu_to_be16(x);
 	return len;
 }
 
 CONFIGFS_ATTR(cluster_, tcp_port);
 
-static ssize_t cluster_set(unsigned int *info_field,
-			   int (*check_cb)(unsigned int x),
+static ssize_t cluster_set(int (*setter)(struct dlm_net *dn, unsigned int x),
 			   const char *buf, size_t len)
 {
+	struct dlm_net *dn = dlm_pernet(&init_net);
 	unsigned int x;
 	int rc;
 
@@ -166,75 +165,66 @@ static ssize_t cluster_set(unsigned int *info_field,
 	if (rc)
 		return rc;
 
-	if (check_cb) {
-		rc = check_cb(x);
-		if (rc)
-			return rc;
-	}
-
-	*info_field = x;
+	rc = setter(dn, x);
+	if (rc)
+		return rc;
 
 	return len;
 }
 
-#define CLUSTER_ATTR(name, check_cb)                                          \
+#define CLUSTER_ATTR(name)                                                    \
 static ssize_t cluster_##name##_store(struct config_item *item, \
 		const char *buf, size_t len) \
 {                                                                             \
-	return cluster_set(&dlm_config.ci_##name, check_cb, buf, len);        \
+	return cluster_set(dlm_cfg_set_##name, buf, len);                     \
 }                                                                             \
 static ssize_t cluster_##name##_show(struct config_item *item, char *buf)     \
 {                                                                             \
-	return snprintf(buf, PAGE_SIZE, "%u\n", dlm_config.ci_##name);        \
+	struct dlm_net *dn = dlm_pernet(&init_net);                           \
+	int rv;                                                               \
+	mutex_lock(&dn->cfg_lock);                                            \
+	rv = snprintf(buf, PAGE_SIZE, "%u\n", dn->config.ci_##name);          \
+	mutex_unlock(&dn->cfg_lock);                                          \
+	return rv;                                                            \
 }                                                                             \
-CONFIGFS_ATTR(cluster_, name);
-
-static int dlm_check_protocol_and_dlm_running(unsigned int x)
-{
-	switch (x) {
-	case 0:
-		/* TCP */
-		break;
-	case 1:
-		/* SCTP */
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	if (dlm_lowcomms_is_running())
-		return -EBUSY;
-
-	return 0;
-}
-
-static int dlm_check_zero(unsigned int x)
-{
-	if (!x)
-		return -EINVAL;
-
-	return 0;
-}
-
-static int dlm_check_buffer_size(unsigned int x)
-{
-	if (x < DLM_MAX_SOCKET_BUFSIZE)
-		return -EINVAL;
-
-	return 0;
-}
-
-CLUSTER_ATTR(buffer_size, dlm_check_buffer_size);
-CLUSTER_ATTR(rsbtbl_size, dlm_check_zero);
-CLUSTER_ATTR(recover_timer, dlm_check_zero);
-CLUSTER_ATTR(toss_secs, dlm_check_zero);
-CLUSTER_ATTR(scan_secs, dlm_check_zero);
-CLUSTER_ATTR(log_debug, NULL);
-CLUSTER_ATTR(log_info, NULL);
-CLUSTER_ATTR(protocol, dlm_check_protocol_and_dlm_running);
-CLUSTER_ATTR(mark, NULL);
-CLUSTER_ATTR(new_rsb_count, NULL);
-CLUSTER_ATTR(recover_callbacks, NULL);
+CONFIGFS_ATTR(cluster_, name)
+
+CLUSTER_ATTR(buffer_size);
+CLUSTER_ATTR(recover_timer);
+CLUSTER_ATTR(toss_secs);
+CLUSTER_ATTR(log_debug);
+CLUSTER_ATTR(log_info);
+CLUSTER_ATTR(protocol);
+CLUSTER_ATTR(mark);
+CLUSTER_ATTR(recover_callbacks);
+
+#define CLUSTER_ATTR_UNUSED(name)						\
+static ssize_t cluster_##name##_store(struct config_item *item,			\
+		const char *buf, size_t len)					\
+{										\
+	struct dlm_net *dn = dlm_pernet(&init_net);				\
+	unsigned int x;								\
+	int rc;									\
+										\
+	if (!capable(CAP_SYS_ADMIN))						\
+		return -EPERM;							\
+	rc = kstrtouint(buf, 0, &x);						\
+	if (rc)									\
+		return rc;							\
+										\
+	dn->config.ci_##name = x;						\
+	return len;								\
+}										\
+static ssize_t cluster_##name##_show(struct config_item *item, char *buf)	\
+{										\
+	struct dlm_net *dn = dlm_pernet(&init_net);				\
+	return snprintf(buf, PAGE_SIZE, "%u\n", dn->config.ci_##name);		\
+}										\
+CONFIGFS_ATTR(cluster_, name)
+
+CLUSTER_ATTR_UNUSED(rsbtbl_size);
+CLUSTER_ATTR_UNUSED(scan_secs);
+CLUSTER_ATTR_UNUSED(new_rsb_count);
 
 static struct configfs_attribute *cluster_attrs[] = {
 	[CLUSTER_ATTR_TCP_PORT] = &cluster_attr_tcp_port,
@@ -276,9 +266,6 @@ struct dlm_spaces {
 
 struct dlm_space {
 	struct config_group group;
-	struct list_head members;
-	struct mutex members_lock;
-	int members_count;
 	struct dlm_nodes *nds;
 };
 
@@ -288,12 +275,6 @@ struct dlm_comms {
 
 struct dlm_comm {
 	struct config_item item;
-	int seq;
-	int nodeid;
-	int local;
-	int addr_count;
-	unsigned int mark;
-	struct sockaddr_storage *addr[DLM_MAX_ADDR_COUNT];
 };
 
 struct dlm_nodes {
@@ -302,11 +283,6 @@ struct dlm_nodes {
 
 struct dlm_node {
 	struct config_item item;
-	struct list_head list; /* space->members */
-	int nodeid;
-	int weight;
-	int new;
-	int comm_seq; /* copy of cm->seq when nd->nodeid is set */
 };
 
 static struct configfs_group_operations clusters_ops = {
@@ -475,11 +451,6 @@ static struct config_group *make_space(struct config_group *g, const char *name)
 
 	config_group_init_type_name(&nds->ns_group, "nodes", &nodes_type);
 	configfs_add_default_group(&nds->ns_group, &sp->group);
-
-	INIT_LIST_HEAD(&sp->members);
-	mutex_init(&sp->members_lock);
-	sp->members_count = 0;
-	sp->nds = nds;
 	return &sp->group;
 
  fail:
@@ -501,14 +472,16 @@ static void drop_space(struct config_group *g, struct config_item *i)
 static void release_space(struct config_item *i)
 {
 	struct dlm_space *sp = config_item_to_space(i);
+
 	kfree(sp->nds);
 	kfree(sp);
 }
 
 static struct config_item *make_comm(struct config_group *g, const char *name)
 {
-	struct dlm_comm *cm;
+	struct dlm_net *dn = dlm_pernet(&init_net);
 	unsigned int nodeid;
+	struct dlm_comm *cm;
 	int rv;
 
 	rv = kstrtouint(name, 0, &nodeid);
@@ -519,42 +492,46 @@ static struct config_item *make_comm(struct config_group *g, const char *name)
 	if (!cm)
 		return ERR_PTR(-ENOMEM);
 
-	config_item_init_type_name(&cm->item, name, &comm_type);
-
-	cm->seq = dlm_comm_count++;
-	if (!cm->seq)
-		cm->seq = dlm_comm_count++;
+	rv = dlm_cfg_new_node(dn, nodeid, 0, NULL, 0);
+	if (rv) {
+		kfree(cm);
+		return ERR_PTR(rv);
+	}
 
-	cm->nodeid = nodeid;
-	cm->local = 0;
-	cm->addr_count = 0;
-	cm->mark = 0;
+	config_item_init_type_name(&cm->item, name, &comm_type);
 	return &cm->item;
 }
 
 static void drop_comm(struct config_group *g, struct config_item *i)
 {
-	struct dlm_comm *cm = config_item_to_comm(i);
-	if (local_comm == cm)
-		local_comm = NULL;
-	dlm_midcomms_close(cm->nodeid);
-	while (cm->addr_count--)
-		kfree(cm->addr[cm->addr_count]);
+	struct dlm_net *dn = dlm_pernet(&init_net);
+	unsigned int nodeid;
+	int rv;
+
+	rv = kstrtouint(config_item_name(i), 0, &nodeid);
+	if (WARN_ON(rv))
+		return;
+
+	rv = dlm_cfg_del_node(dn, nodeid);
+	if (WARN_ON(rv))
+		return;
+
 	config_item_put(i);
 }
 
 static void release_comm(struct config_item *i)
 {
 	struct dlm_comm *cm = config_item_to_comm(i);
+
 	kfree(cm);
 }
 
 static struct config_item *make_node(struct config_group *g, const char *name)
 {
-	struct dlm_space *sp = config_item_to_space(g->cg_item.ci_parent);
+	struct dlm_net *dn = dlm_pernet(&init_net);
 	unsigned int nodeid;
 	struct dlm_node *nd;
-	uint32_t seq = 0;
+	const char *lsname;
 	int rv;
 
 	rv = kstrtouint(name, 0, &nodeid);
@@ -565,30 +542,32 @@ static struct config_item *make_node(struct config_group *g, const char *name)
 	if (!nd)
 		return ERR_PTR(-ENOMEM);
 
-	config_item_init_type_name(&nd->item, name, &node_type);
-	nd->nodeid = nodeid;
-	nd->weight = 1;  /* default weight of 1 if none is set */
-	nd->new = 1;     /* set to 0 once it's been read by dlm_nodeid_list() */
-	dlm_comm_seq(nodeid, &seq);
-	nd->comm_seq = seq;
-
-	mutex_lock(&sp->members_lock);
-	list_add(&nd->list, &sp->members);
-	sp->members_count++;
-	mutex_unlock(&sp->members_lock);
+	lsname = config_item_name(g->cg_item.ci_parent);
+	rv = dlm_cfg_add_member(dn, lsname, nodeid, DLM_DEFAULT_WEIGHT);
+	if (rv) {
+		kfree(nd);
+		return ERR_PTR(rv);
+	}
 
+	config_item_init_type_name(&nd->item, name, &node_type);
 	return &nd->item;
 }
 
 static void drop_node(struct config_group *g, struct config_item *i)
 {
-	struct dlm_space *sp = config_item_to_space(g->cg_item.ci_parent);
-	struct dlm_node *nd = config_item_to_node(i);
+	struct dlm_net *dn = dlm_pernet(&init_net);
+	unsigned int nodeid;
+	const char *lsname;
+	int rv;
+
+	rv = kstrtouint(config_item_name(i), 0, &nodeid);
+	if (WARN_ON(rv))
+		return;
 
-	mutex_lock(&sp->members_lock);
-	list_del(&nd->list);
-	sp->members_count--;
-	mutex_unlock(&sp->members_lock);
+	lsname = config_item_name(g->cg_item.ci_parent);
+	rv = dlm_cfg_del_member(dn, lsname, nodeid);
+	if (WARN_ON(rv))
+		return;
 
 	config_item_put(i);
 }
@@ -596,6 +575,7 @@ static void drop_node(struct config_group *g, struct config_item *i)
 static void release_node(struct config_item *i)
 {
 	struct dlm_node *nd = config_item_to_node(i);
+
 	kfree(nd);
 }
 
@@ -610,14 +590,14 @@ static struct dlm_clusters clusters_root = {
 	},
 };
 
-int __init dlm_config_init(void)
+int __init dlm_configfs_init(void)
 {
 	config_group_init(&clusters_root.subsys.su_group);
 	mutex_init(&clusters_root.subsys.su_mutex);
 	return configfs_register_subsystem(&clusters_root.subsys);
 }
 
-void dlm_config_exit(void)
+void dlm_configfs_exit(void)
 {
 	configfs_unregister_subsystem(&clusters_root.subsys);
 }
@@ -646,73 +626,97 @@ static ssize_t comm_nodeid_store(struct config_item *item, const char *buf,
 
 static ssize_t comm_local_show(struct config_item *item, char *buf)
 {
-	return sprintf(buf, "%d\n", config_item_to_comm(item)->local);
+	struct dlm_net *dn = dlm_pernet(&init_net);
+	unsigned int nodeid;
+	int local = 0, rv;
+
+	rv = kstrtouint(config_item_name(item), 0, &nodeid);
+	if (WARN_ON(rv))
+		return rv;
+
+	mutex_lock(&dn->cfg_lock);
+	if (dn->our_node)
+		local = (dn->our_node->id == nodeid);
+	mutex_unlock(&dn->cfg_lock);
+
+	return sprintf(buf, "%d\n", local);
 }
 
 static ssize_t comm_local_store(struct config_item *item, const char *buf,
 				size_t len)
 {
-	struct dlm_comm *cm = config_item_to_comm(item);
-	int rc = kstrtoint(buf, 0, &cm->local);
+	struct dlm_net *dn = dlm_pernet(&init_net);
+	unsigned int nodeid;
+	int rv;
+
+	rv = kstrtouint(config_item_name(item), 0, &nodeid);
+	if (WARN_ON(rv))
+		return rv;
+
+	rv = dlm_cfg_set_our_node(dn, nodeid);
+	if (rv)
+		return rv;
 
-	if (rc)
-		return rc;
-	if (cm->local && !local_comm)
-		local_comm = cm;
 	return len;
 }
 
 static ssize_t comm_addr_store(struct config_item *item, const char *buf,
 		size_t len)
 {
-	struct dlm_comm *cm = config_item_to_comm(item);
-	struct sockaddr_storage *addr;
+	struct dlm_net *dn = dlm_pernet(&init_net);
+	struct sockaddr_storage addr;
+	unsigned int nodeid;
 	int rv;
 
 	if (len != sizeof(struct sockaddr_storage))
 		return -EINVAL;
 
-	if (cm->addr_count >= DLM_MAX_ADDR_COUNT)
-		return -ENOSPC;
-
-	addr = kzalloc(sizeof(*addr), GFP_NOFS);
-	if (!addr)
-		return -ENOMEM;
-
-	memcpy(addr, buf, len);
+	rv = kstrtouint(config_item_name(item), 0, &nodeid);
+	if (WARN_ON(rv))
+		return rv;
 
-	rv = dlm_midcomms_addr(cm->nodeid, addr);
-	if (rv) {
-		kfree(addr);
+	memcpy(&addr, buf, len);
+	rv = dlm_cfg_add_addr(dn, nodeid, &addr);
+	if (rv)
 		return rv;
-	}
 
-	cm->addr[cm->addr_count++] = addr;
 	return len;
 }
 
 static ssize_t comm_addr_list_show(struct config_item *item, char *buf)
 {
-	struct dlm_comm *cm = config_item_to_comm(item);
+	struct dlm_net *dn = dlm_pernet(&init_net);
 	ssize_t s;
 	ssize_t allowance;
-	int i;
+	int i, rv;
 	struct sockaddr_storage *addr;
 	struct sockaddr_in *addr_in;
 	struct sockaddr_in6 *addr_in6;
-	
+	struct dlm_cfg_node *nd;
+	unsigned int nodeid;
+
 	/* Taken from ip6_addr_string() defined in lib/vsprintf.c */
 	char buf0[sizeof("AF_INET6	xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:255.255.255.255\n")];
-	
+
+	rv = kstrtouint(config_item_name(item), 0, &nodeid);
+	if (WARN_ON(rv))
+		return rv;
 
 	/* Derived from SIMPLE_ATTR_SIZE of fs/configfs/file.c */
 	allowance = 4096;
 	buf[0] = '\0';
 
-	for (i = 0; i < cm->addr_count; i++) {
-		addr = cm->addr[i];
+	mutex_lock(&dn->cfg_lock);
+	nd = dlm_cfg_get_node(dn, nodeid);
+	if (!nd) {
+		mutex_unlock(&dn->cfg_lock);
+		return -ENOENT;
+	}
+
+	for (i = 0; i < nd->addrs_count; i++) {
+		addr = &nd->addrs[i];
 
-		switch(addr->ss_family) {
+		switch (addr->ss_family) {
 		case AF_INET:
 			addr_in = (struct sockaddr_in *)addr;
 			s = sprintf(buf0, "AF_INET	%pI4\n", &addr_in->sin_addr.s_addr);
@@ -733,34 +737,54 @@ static ssize_t comm_addr_list_show(struct config_item *item, char *buf)
 			break;
 		}
 	}
+	mutex_unlock(&dn->cfg_lock);
+
 	return 4096 - allowance;
 }
 
 static ssize_t comm_mark_show(struct config_item *item, char *buf)
 {
-	return sprintf(buf, "%u\n", config_item_to_comm(item)->mark);
+	struct dlm_net *dn = dlm_pernet(&init_net);
+	unsigned int nodeid, mark;
+	struct dlm_cfg_node *nd;
+	int rv;
+
+	rv = kstrtouint(config_item_name(item), 0, &nodeid);
+	if (WARN_ON(rv))
+		return rv;
+
+	mutex_lock(&dn->cfg_lock);
+	nd = dlm_cfg_get_node(dn, nodeid);
+	if (!nd) {
+		mutex_unlock(&dn->cfg_lock);
+		return -ENOENT;
+	}
+
+	mark = nd->mark;
+	mutex_unlock(&dn->cfg_lock);
+
+	return sprintf(buf, "%u\n", mark);
 }
 
 static ssize_t comm_mark_store(struct config_item *item, const char *buf,
 			       size_t len)
 {
-	struct dlm_comm *comm;
-	unsigned int mark;
-	int rc;
+	struct dlm_net *dn = dlm_pernet(&init_net);
+	unsigned int nodeid, mark;
+	int rv;
 
-	rc = kstrtouint(buf, 0, &mark);
-	if (rc)
-		return rc;
+	rv = kstrtouint(buf, 0, &mark);
+	if (rv)
+		return rv;
 
-	if (mark == 0)
-		mark = dlm_config.ci_mark;
+	rv = kstrtouint(config_item_name(item), 0, &nodeid);
+	if (WARN_ON(rv))
+		return rv;
 
-	comm = config_item_to_comm(item);
-	rc = dlm_lowcomms_nodes_set_mark(comm->nodeid, mark);
-	if (rc)
-		return rc;
+	rv = dlm_cfg_set_node_mark(dn, nodeid, mark);
+	if (rv)
+		return rv;
 
-	comm->mark = mark;
 	return len;
 }
 
@@ -799,16 +823,52 @@ static ssize_t node_nodeid_store(struct config_item *item, const char *buf,
 
 static ssize_t node_weight_show(struct config_item *item, char *buf)
 {
-	return sprintf(buf, "%d\n", config_item_to_node(item)->weight);
+	struct dlm_net *dn = dlm_pernet(&init_net);
+	const struct dlm_cfg_member *mb;
+	unsigned int nodeid, weight;
+	const char *lsname;
+	int rv;
+
+	rv = kstrtouint(config_item_name(item), 0, &nodeid);
+	if (WARN_ON(rv))
+		return rv;
+
+	lsname = config_item_name(item->ci_parent->ci_parent);
+
+	mutex_lock(&dn->cfg_lock);
+	mb = dlm_cfg_get_ls_member(dn, lsname, nodeid);
+	if (!mb) {
+		mutex_unlock(&dn->cfg_lock);
+		return -ENOENT;
+	}
+
+	weight = mb->weight;
+	mutex_unlock(&dn->cfg_lock);
+
+	return sprintf(buf, "%u\n", weight);
 }
 
 static ssize_t node_weight_store(struct config_item *item, const char *buf,
 				 size_t len)
 {
-	int rc = kstrtoint(buf, 0, &config_item_to_node(item)->weight);
+	struct dlm_net *dn = dlm_pernet(&init_net);
+	unsigned int nodeid, weight;
+	const char *lsname;
+	int rv;
+
+	rv = kstrtouint(buf, 0, &weight);
+	if (rv)
+		return rv;
+
+	rv = kstrtouint(config_item_name(item), 0, &nodeid);
+	if (WARN_ON(rv))
+		return rv;
+
+	lsname = config_item_name(item->ci_parent->ci_parent);
+	rv = dlm_cfg_set_weight(dn, lsname, nodeid, weight);
+	if (rv)
+		return rv;
 
-	if (rc)
-		return rc;
 	return len;
 }
 
@@ -820,163 +880,3 @@ static struct configfs_attribute *node_attrs[] = {
 	[NODE_ATTR_WEIGHT] = &node_attr_weight,
 	NULL,
 };
-
-/*
- * Functions for the dlm to get the info that's been configured
- */
-
-static struct dlm_space *get_space(char *name)
-{
-	struct config_item *i;
-
-	if (!space_list)
-		return NULL;
-
-	mutex_lock(&space_list->cg_subsys->su_mutex);
-	i = config_group_find_item(space_list, name);
-	mutex_unlock(&space_list->cg_subsys->su_mutex);
-
-	return config_item_to_space(i);
-}
-
-static void put_space(struct dlm_space *sp)
-{
-	config_item_put(&sp->group.cg_item);
-}
-
-static struct dlm_comm *get_comm(int nodeid)
-{
-	struct config_item *i;
-	struct dlm_comm *cm = NULL;
-	int found = 0;
-
-	if (!comm_list)
-		return NULL;
-
-	mutex_lock(&clusters_root.subsys.su_mutex);
-
-	list_for_each_entry(i, &comm_list->cg_children, ci_entry) {
-		cm = config_item_to_comm(i);
-
-		if (cm->nodeid != nodeid)
-			continue;
-		found = 1;
-		config_item_get(i);
-		break;
-	}
-	mutex_unlock(&clusters_root.subsys.su_mutex);
-
-	if (!found)
-		cm = NULL;
-	return cm;
-}
-
-static void put_comm(struct dlm_comm *cm)
-{
-	config_item_put(&cm->item);
-}
-
-/* caller must free mem */
-int dlm_config_nodes(char *lsname, struct dlm_config_node **nodes_out,
-		     int *count_out)
-{
-	struct dlm_space *sp;
-	struct dlm_node *nd;
-	struct dlm_config_node *nodes, *node;
-	int rv, count;
-
-	sp = get_space(lsname);
-	if (!sp)
-		return -EEXIST;
-
-	mutex_lock(&sp->members_lock);
-	if (!sp->members_count) {
-		rv = -EINVAL;
-		printk(KERN_ERR "dlm: zero members_count\n");
-		goto out;
-	}
-
-	count = sp->members_count;
-
-	nodes = kcalloc(count, sizeof(struct dlm_config_node), GFP_NOFS);
-	if (!nodes) {
-		rv = -ENOMEM;
-		goto out;
-	}
-
-	node = nodes;
-	list_for_each_entry(nd, &sp->members, list) {
-		node->nodeid = nd->nodeid;
-		node->weight = nd->weight;
-		node->new = nd->new;
-		node->comm_seq = nd->comm_seq;
-		node++;
-
-		nd->new = 0;
-	}
-
-	*count_out = count;
-	*nodes_out = nodes;
-	rv = 0;
- out:
-	mutex_unlock(&sp->members_lock);
-	put_space(sp);
-	return rv;
-}
-
-int dlm_comm_seq(int nodeid, uint32_t *seq)
-{
-	struct dlm_comm *cm = get_comm(nodeid);
-	if (!cm)
-		return -EEXIST;
-	*seq = cm->seq;
-	put_comm(cm);
-	return 0;
-}
-
-int dlm_our_nodeid(void)
-{
-	return local_comm->nodeid;
-}
-
-/* num 0 is first addr, num 1 is second addr */
-int dlm_our_addr(struct sockaddr_storage *addr, int num)
-{
-	if (!local_comm)
-		return -1;
-	if (num + 1 > local_comm->addr_count)
-		return -1;
-	memcpy(addr, local_comm->addr[num], sizeof(*addr));
-	return 0;
-}
-
-/* Config file defaults */
-#define DEFAULT_TCP_PORT       21064
-#define DEFAULT_RSBTBL_SIZE     1024
-#define DEFAULT_RECOVER_TIMER      5
-#define DEFAULT_TOSS_SECS         10
-#define DEFAULT_SCAN_SECS          5
-#define DEFAULT_LOG_DEBUG          0
-#define DEFAULT_LOG_INFO           1
-#define DEFAULT_PROTOCOL           DLM_PROTO_TCP
-#define DEFAULT_MARK               0
-#define DEFAULT_NEW_RSB_COUNT    128
-#define DEFAULT_RECOVER_CALLBACKS  0
-#define DEFAULT_CLUSTER_NAME      ""
-
-struct dlm_config_info dlm_config = {
-	.ci_tcp_port = cpu_to_be16(DEFAULT_TCP_PORT),
-	.ci_buffer_size = DLM_MAX_SOCKET_BUFSIZE,
-	.ci_rsbtbl_size = DEFAULT_RSBTBL_SIZE,
-	.ci_recover_timer = DEFAULT_RECOVER_TIMER,
-	.ci_toss_secs = DEFAULT_TOSS_SECS,
-	.ci_scan_secs = DEFAULT_SCAN_SECS,
-	.ci_log_debug = DEFAULT_LOG_DEBUG,
-	.ci_log_info = DEFAULT_LOG_INFO,
-	.ci_protocol = DEFAULT_PROTOCOL,
-	.ci_mark = DEFAULT_MARK,
-	.ci_new_rsb_count = DEFAULT_NEW_RSB_COUNT,
-	.ci_recover_callbacks = DEFAULT_RECOVER_CALLBACKS,
-	.ci_cluster_name = DEFAULT_CLUSTER_NAME
-};
-
diff --git a/fs/dlm/configfs.h b/fs/dlm/configfs.h
new file mode 100644
index 000000000000..b8027c0db8b5
--- /dev/null
+++ b/fs/dlm/configfs.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/******************************************************************************
+ ******************************************************************************
+ **
+ **  Copyright (C) Sistina Software, Inc.  1997-2003  All rights reserved.
+ **  Copyright (C) 2004-2011 Red Hat, Inc.  All rights reserved.
+ **
+ **
+ ******************************************************************************
+ ******************************************************************************/
+
+#ifndef __CONFIGFS_DOT_H__
+#define __CONFIGFS_DOT_H__
+
+int dlm_configfs_init(void);
+void dlm_configfs_exit(void);
+
+#endif				/* __CONFIGFS_DOT_H__ */
+
diff --git a/fs/dlm/debug_fs.c b/fs/dlm/debug_fs.c
index 7112958c2e5b..f9e7ca337a62 100644
--- a/fs/dlm/debug_fs.c
+++ b/fs/dlm/debug_fs.c
@@ -331,9 +331,10 @@ static void print_format3(struct dlm_rsb *r, struct seq_file *s)
 	unlock_rsb(r);
 }
 
-static void print_format4(struct dlm_rsb *r, struct seq_file *s)
+static void print_format4(struct dlm_ls *ls, struct dlm_rsb *r,
+			  struct seq_file *s)
 {
-	int our_nodeid = dlm_our_nodeid();
+	int our_nodeid = dlm_our_nodeid(ls->ls_dn);
 	int print_name = 1;
 	int i;
 
@@ -381,6 +382,7 @@ static const struct seq_operations format4_seq_ops;
 static int table_seq_show(struct seq_file *seq, void *iter_ptr)
 {
 	struct dlm_rsb *rsb = list_entry(iter_ptr, struct dlm_rsb, res_slow_list);
+	struct dlm_ls *ls = seq->private;
 
 	if (seq->op == &format1_seq_ops)
 		print_format1(rsb, seq);
@@ -389,7 +391,7 @@ static int table_seq_show(struct seq_file *seq, void *iter_ptr)
 	else if (seq->op == &format3_seq_ops)
 		print_format3(rsb, seq);
 	else if (seq->op == &format4_seq_ops)
-		print_format4(rsb, seq);
+		print_format4(ls, rsb, seq);
 
 	return 0;
 }
@@ -736,11 +738,15 @@ static const struct file_operations dlm_rawmsg_fops = {
 	.llseek	= no_llseek,
 };
 
-void *dlm_create_debug_comms_file(int nodeid, void *data)
+void *dlm_create_debug_comms_file(struct dlm_net *dn, int nodeid, void *data)
 {
 	struct dentry *d_node;
 	char name[256];
 
+	/* debugfs only supported for init_net */
+	if (!net_eq(read_pnet(&dn->net), &init_net))
+		return NULL;
+
 	memset(name, 0, sizeof(name));
 	snprintf(name, 256, "%d", nodeid);
 
@@ -755,8 +761,12 @@ void *dlm_create_debug_comms_file(int nodeid, void *data)
 	return d_node;
 }
 
-void dlm_delete_debug_comms_file(void *ctx)
+void dlm_delete_debug_comms_file(struct dlm_net *dn, void *ctx)
 {
+	/* debugfs only supported for init_net */
+	if (!net_eq(read_pnet(&dn->net), &init_net))
+		return;
+
 	debugfs_remove(ctx);
 }
 
@@ -765,6 +775,10 @@ void dlm_create_debug_file(struct dlm_ls *ls)
 	/* Reserve enough space for the longest file name */
 	char name[DLM_LOCKSPACE_LEN + sizeof("_queued_asts")];
 
+	/* debugfs only supported for init_net */
+	if (!net_eq(read_pnet(&ls->ls_dn->net), &init_net))
+		return;
+
 	/* format 1 */
 
 	ls->ls_debug_rsb_dentry = debugfs_create_file(ls->ls_name,
diff --git a/fs/dlm/dir.c b/fs/dlm/dir.c
index b1ab0adbd9d0..2fa0afd5c57b 100644
--- a/fs/dlm/dir.c
+++ b/fs/dlm/dir.c
@@ -35,7 +35,7 @@ int dlm_hash2nodeid(struct dlm_ls *ls, uint32_t hash)
 	uint32_t node;
 
 	if (ls->ls_num_nodes == 1)
-		return dlm_our_nodeid();
+		return dlm_our_nodeid(ls->ls_dn);
 	else {
 		node = (hash >> 16) % ls->ls_total_weight;
 		return ls->ls_node_array[node];
@@ -74,7 +74,7 @@ int dlm_recover_directory(struct dlm_ls *ls, uint64_t seq)
 		goto out;
 
 	list_for_each_entry(memb, &ls->ls_nodes, list) {
-		if (memb->nodeid == dlm_our_nodeid())
+		if (memb->nodeid == dlm_our_nodeid(ls->ls_dn))
 			continue;
 
 		memset(last_name, 0, DLM_RESNAME_MAXLEN);
diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index d534a4bc162b..10fe3b59bd70 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -64,24 +64,24 @@ struct dlm_msg;
 
 #define log_rinfo(ls, fmt, args...) \
 do { \
-	if (dlm_config.ci_log_info) \
+	if (ls->ls_dn->config.ci_log_info) \
 		printk(KERN_INFO "dlm: %s: " fmt "\n", \
 			(ls)->ls_name, ##args); \
-	else if (dlm_config.ci_log_debug) \
+	else if (ls->ls_dn->config.ci_log_debug) \
 		printk(KERN_DEBUG "dlm: %s: " fmt "\n", \
 		       (ls)->ls_name , ##args); \
 } while (0)
 
 #define log_debug(ls, fmt, args...) \
 do { \
-	if (dlm_config.ci_log_debug) \
+	if (ls->ls_dn->config.ci_log_debug) \
 		printk(KERN_DEBUG "dlm: %s: " fmt "\n", \
 		       (ls)->ls_name , ##args); \
 } while (0)
 
 #define log_limit(ls, fmt, args...) \
 do { \
-	if (dlm_config.ci_log_debug) \
+	if (ls->ls_dn->config.ci_log_debug) \
 		printk_ratelimited(KERN_DEBUG "dlm: %s: " fmt "\n", \
 			(ls)->ls_name , ##args); \
 } while (0)
@@ -561,6 +561,8 @@ struct rcom_lock {
 
 struct dlm_ls {
 	struct list_head	ls_list;	/* list of lockspaces */
+	struct dlm_net		*ls_dn;
+	netns_tracker		ls_tracker;
 	uint32_t		ls_global_id;	/* global unique lockspace ID */
 	uint32_t		ls_generation;
 	uint32_t		ls_exflags;
@@ -816,15 +818,17 @@ void dlm_register_debugfs(void);
 void dlm_unregister_debugfs(void);
 void dlm_create_debug_file(struct dlm_ls *ls);
 void dlm_delete_debug_file(struct dlm_ls *ls);
-void *dlm_create_debug_comms_file(int nodeid, void *data);
-void dlm_delete_debug_comms_file(void *ctx);
+void *dlm_create_debug_comms_file(struct dlm_net *dn, int nodeid, void *data);
+void dlm_delete_debug_comms_file(struct dlm_net *dn, void *ctx);
 #else
 static inline void dlm_register_debugfs(void) { }
 static inline void dlm_unregister_debugfs(void) { }
 static inline void dlm_create_debug_file(struct dlm_ls *ls) { }
 static inline void dlm_delete_debug_file(struct dlm_ls *ls) { }
-static inline void *dlm_create_debug_comms_file(int nodeid, void *data) { return NULL; }
-static inline void dlm_delete_debug_comms_file(void *ctx) { }
+static inline void *dlm_create_debug_comms_file(struct dlm_net *dn, int nodeid,
+						void *data) { return NULL; }
+static inline void dlm_delete_debug_comms_file(struct dlm_net *dn,
+					       void *ctx) { }
 #endif
 
 #endif				/* __DLM_INTERNAL_DOT_H__ */
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 865dc70a9dfc..0e8d2b9bf908 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -320,9 +320,9 @@ static void queue_bast(struct dlm_rsb *r, struct dlm_lkb *lkb, int rqmode)
  * Basic operations on rsb's and lkb's
  */
 
-static inline unsigned long rsb_toss_jiffies(void)
+static inline unsigned long rsb_toss_jiffies(const struct dlm_ls *ls)
 {
-	return jiffies + (READ_ONCE(dlm_config.ci_toss_secs) * HZ);
+	return jiffies + (READ_ONCE(ls->ls_dn->config.ci_toss_secs) * HZ);
 }
 
 /* This is only called to add a reference when the code already holds
@@ -457,7 +457,7 @@ static void del_scan(struct dlm_ls *ls, struct dlm_rsb *r)
 
 static void add_scan(struct dlm_ls *ls, struct dlm_rsb *r)
 {
-	int our_nodeid = dlm_our_nodeid();
+	int our_nodeid = dlm_our_nodeid(ls->ls_dn);
 	struct dlm_rsb *first;
 
 	/* A dir record for a remote master rsb should never be on the scan list. */
@@ -473,7 +473,7 @@ static void add_scan(struct dlm_ls *ls, struct dlm_rsb *r)
 
 	spin_lock_bh(&ls->ls_scan_lock);
 	/* set the new rsb absolute expire time in the rsb */
-	r->res_toss_time = rsb_toss_jiffies();
+	r->res_toss_time = rsb_toss_jiffies(ls);
 	if (list_empty(&ls->ls_scan_list)) {
 		/* if the queue is empty add the element and it's
 		 * our new expire time
@@ -510,7 +510,7 @@ static void add_scan(struct dlm_ls *ls, struct dlm_rsb *r)
 void dlm_rsb_scan(struct timer_list *timer)
 {
 	struct dlm_ls *ls = from_timer(ls, timer, ls_scan_timer);
-	int our_nodeid = dlm_our_nodeid();
+	int our_nodeid = dlm_our_nodeid(ls->ls_dn);
 	struct dlm_rsb *r;
 	int rv;
 
@@ -696,7 +696,7 @@ static int find_rsb_dir(struct dlm_ls *ls, const void *name, int len,
 			unsigned int flags, struct dlm_rsb **r_ret)
 {
 	struct dlm_rsb *r = NULL;
-	int our_nodeid = dlm_our_nodeid();
+	int our_nodeid = dlm_our_nodeid(ls->ls_dn);
 	int from_local = 0;
 	int from_other = 0;
 	int from_dir = 0;
@@ -915,7 +915,7 @@ static int find_rsb_nodir(struct dlm_ls *ls, const void *name, int len,
 			  unsigned int flags, struct dlm_rsb **r_ret)
 {
 	struct dlm_rsb *r = NULL;
-	int our_nodeid = dlm_our_nodeid();
+	int our_nodeid = dlm_our_nodeid(ls->ls_dn);
 	int recover = (flags & R_RECEIVE_RECOVER);
 	int error;
 
@@ -1135,7 +1135,7 @@ static int validate_master_nodeid(struct dlm_ls *ls, struct dlm_rsb *r,
 				  r->res_first_lkid, r->res_name);
 		}
 
-		r->res_master_nodeid = dlm_our_nodeid();
+		r->res_master_nodeid = dlm_our_nodeid(ls->ls_dn);
 		r->res_nodeid = 0;
 		return 0;
 	}
@@ -1257,7 +1257,7 @@ static int _dlm_master_lookup(struct dlm_ls *ls, int from_nodeid, const char *na
 {
 	struct dlm_rsb *r = NULL;
 	uint32_t hash;
-	int our_nodeid = dlm_our_nodeid();
+	int our_nodeid = dlm_our_nodeid(ls->ls_dn);
 	int dir_nodeid, error;
 
 	if (len > DLM_RESNAME_MAXLEN)
@@ -1423,7 +1423,7 @@ static void deactivate_rsb(struct kref *kref)
 {
 	struct dlm_rsb *r = container_of(kref, struct dlm_rsb, res_ref);
 	struct dlm_ls *ls = r->res_ls;
-	int our_nodeid = dlm_our_nodeid();
+	int our_nodeid = dlm_our_nodeid(ls->ls_dn);
 
 	DLM_ASSERT(list_empty(&r->res_root_list), dlm_print_rsb(r););
 	rsb_set_flag(r, RSB_INACTIVE);
@@ -2647,7 +2647,7 @@ static void send_blocking_asts_all(struct dlm_rsb *r, struct dlm_lkb *lkb)
 
 static int set_master(struct dlm_rsb *r, struct dlm_lkb *lkb)
 {
-	int our_nodeid = dlm_our_nodeid();
+	int our_nodeid = dlm_our_nodeid(r->res_ls->ls_dn);
 
 	if (rsb_flag(r, RSB_MASTER_UNCERTAIN)) {
 		rsb_clear_flag(r, RSB_MASTER_UNCERTAIN);
@@ -3502,7 +3502,7 @@ static int _create_message(struct dlm_ls *ls, int mb_len,
 	   pass into midcomms_commit and a message buffer (mb) that we
 	   write our data into */
 
-	mh = dlm_midcomms_get_mhandle(to_nodeid, mb_len, &mb);
+	mh = dlm_midcomms_get_mhandle(ls->ls_dn, to_nodeid, mb_len, &mb);
 	if (!mh)
 		return -ENOBUFS;
 
@@ -3510,7 +3510,7 @@ static int _create_message(struct dlm_ls *ls, int mb_len,
 
 	ms->m_header.h_version = cpu_to_le32(DLM_HEADER_MAJOR | DLM_HEADER_MINOR);
 	ms->m_header.u.h_lockspace = cpu_to_le32(ls->ls_global_id);
-	ms->m_header.h_nodeid = cpu_to_le32(dlm_our_nodeid());
+	ms->m_header.h_nodeid = cpu_to_le32(dlm_our_nodeid(ls->ls_dn));
 	ms->m_header.h_length = cpu_to_le16(mb_len);
 	ms->m_header.h_cmd = DLM_MSG;
 
@@ -4024,7 +4024,7 @@ static int receive_request(struct dlm_ls *ls, const struct dlm_message *ms)
 
 	lock_rsb(r);
 
-	if (r->res_master_nodeid != dlm_our_nodeid()) {
+	if (r->res_master_nodeid != dlm_our_nodeid(ls->ls_dn)) {
 		error = validate_master_nodeid(ls, r, from_nodeid);
 		if (error) {
 			unlock_rsb(r);
@@ -4273,7 +4273,7 @@ static void receive_lookup(struct dlm_ls *ls, const struct dlm_message *ms)
 	int len, error, ret_nodeid, from_nodeid, our_nodeid;
 
 	from_nodeid = le32_to_cpu(ms->m_header.h_nodeid);
-	our_nodeid = dlm_our_nodeid();
+	our_nodeid = dlm_our_nodeid(ls->ls_dn);
 
 	len = receive_extralen(ms);
 
@@ -4305,7 +4305,7 @@ static void receive_remove(struct dlm_ls *ls, const struct dlm_message *ms)
 	}
 
 	dir_nodeid = dlm_hash2nodeid(ls, le32_to_cpu(ms->m_hash));
-	if (dir_nodeid != dlm_our_nodeid()) {
+	if (dir_nodeid != dlm_our_nodeid(ls->ls_dn)) {
 		log_error(ls, "receive_remove from %d bad nodeid %d",
 			  from_nodeid, dir_nodeid);
 		return;
@@ -4461,8 +4461,8 @@ static int receive_request_reply(struct dlm_ls *ls,
 			  from_nodeid, result, r->res_master_nodeid,
 			  r->res_dir_nodeid, r->res_first_lkid, r->res_name);
 
-		if (r->res_dir_nodeid != dlm_our_nodeid() &&
-		    r->res_master_nodeid != dlm_our_nodeid()) {
+		if (r->res_dir_nodeid != dlm_our_nodeid(ls->ls_dn) &&
+		    r->res_master_nodeid != dlm_our_nodeid(ls->ls_dn)) {
 			/* cause _request_lock->set_master->send_lookup */
 			r->res_master_nodeid = 0;
 			r->res_nodeid = -1;
@@ -4477,7 +4477,7 @@ static int receive_request_reply(struct dlm_ls *ls,
 		} else {
 			_request_lock(r, lkb);
 
-			if (r->res_master_nodeid == dlm_our_nodeid())
+			if (r->res_master_nodeid == dlm_our_nodeid(ls->ls_dn))
 				confirm_master(r, 0);
 		}
 		break;
@@ -4735,10 +4735,11 @@ static void receive_lookup_reply(struct dlm_ls *ls,
 			  "master %d dir %d our %d first %x %s",
 			  lkb->lkb_id, le32_to_cpu(ms->m_header.h_nodeid),
 			  ret_nodeid, r->res_master_nodeid, r->res_dir_nodeid,
-			  dlm_our_nodeid(), r->res_first_lkid, r->res_name);
+			  dlm_our_nodeid(ls->ls_dn), r->res_first_lkid,
+			  r->res_name);
 	}
 
-	if (ret_nodeid == dlm_our_nodeid()) {
+	if (ret_nodeid == dlm_our_nodeid(ls->ls_dn)) {
 		r->res_master_nodeid = ret_nodeid;
 		r->res_nodeid = 0;
 		do_lookup_list = 1;
@@ -4957,7 +4958,8 @@ void dlm_receive_message_saved(struct dlm_ls *ls, const struct dlm_message *ms,
    standard locking activity) or an RCOM (recovery message sent as part of
    lockspace recovery). */
 
-void dlm_receive_buffer(const union dlm_packet *p, int nodeid)
+void dlm_receive_buffer(struct dlm_net *dn, const union dlm_packet *p,
+			int nodeid)
 {
 	const struct dlm_header *hd = &p->header;
 	struct dlm_ls *ls;
@@ -4982,17 +4984,14 @@ void dlm_receive_buffer(const union dlm_packet *p, int nodeid)
 		return;
 	}
 
-	ls = dlm_find_lockspace_global(le32_to_cpu(hd->u.h_lockspace));
+	ls = dlm_find_lockspace_global(dn, le32_to_cpu(hd->u.h_lockspace));
 	if (!ls) {
-		if (dlm_config.ci_log_debug) {
-			printk_ratelimited(KERN_DEBUG "dlm: invalid lockspace "
-				"%u from %d cmd %d type %d\n",
-				le32_to_cpu(hd->u.h_lockspace), nodeid,
-				hd->h_cmd, type);
-		}
+		log_limit(ls, "dlm: invalid lockspace %u from %d cmd %d type %d\n",
+			  le32_to_cpu(hd->u.h_lockspace), nodeid,
+			  hd->h_cmd, type);
 
 		if (hd->h_cmd == DLM_RCOM && type == DLM_RCOM_STATUS)
-			dlm_send_ls_not_ready(nodeid, &p->rcom);
+			dlm_send_ls_not_ready(dn, nodeid, &p->rcom);
 		return;
 	}
 
@@ -5624,7 +5623,8 @@ int dlm_recover_master_copy(struct dlm_ls *ls, const struct dlm_rcom *rc,
 
 	lock_rsb(r);
 
-	if (dlm_no_directory(ls) && (dlm_dir_nodeid(r) != dlm_our_nodeid())) {
+	if (dlm_no_directory(ls) &&
+	    (dlm_dir_nodeid(r) != dlm_our_nodeid(ls->ls_dn))) {
 		log_error(ls, "dlm_recover_master_copy remote %d %x not dir",
 			  from_nodeid, remid);
 		error = -EBADR;
@@ -6275,7 +6275,7 @@ int dlm_user_purge(struct dlm_ls *ls, struct dlm_user_proc *proc,
 {
 	int error = 0;
 
-	if (nodeid && (nodeid != dlm_our_nodeid())) {
+	if (nodeid && (nodeid != dlm_our_nodeid(ls->ls_dn))) {
 		error = send_purge(ls, nodeid, pid);
 	} else {
 		dlm_lock_recovery(ls);
diff --git a/fs/dlm/lock.h b/fs/dlm/lock.h
index b23d7b854ed4..dc374fc80c9a 100644
--- a/fs/dlm/lock.h
+++ b/fs/dlm/lock.h
@@ -16,7 +16,8 @@ void dlm_dump_rsb_name(struct dlm_ls *ls, const char *name, int len);
 void dlm_print_lkb(struct dlm_lkb *lkb);
 void dlm_receive_message_saved(struct dlm_ls *ls, const struct dlm_message *ms,
 			       uint32_t saved_seq);
-void dlm_receive_buffer(const union dlm_packet *p, int nodeid);
+void dlm_receive_buffer(struct dlm_net *dn, const union dlm_packet *p,
+			int nodeid);
 int dlm_modes_compat(int mode1, int mode2);
 void free_inactive_rsb(struct dlm_rsb *r);
 void dlm_put_rsb(struct dlm_rsb *r);
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 2dd37a2e718d..e5eeb3957b89 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -9,6 +9,7 @@
 *******************************************************************************
 ******************************************************************************/
 
+#include <linux/netdevice.h>
 #include <linux/module.h>
 
 #include "dlm_internal.h"
@@ -25,11 +26,6 @@
 #include "user.h"
 #include "ast.h"
 
-static int			ls_count;
-static struct mutex		ls_lock;
-static struct list_head		lslist;
-static spinlock_t		lslist_lock;
-
 static ssize_t dlm_control_store(struct dlm_ls *ls, const char *buf, size_t len)
 {
 	ssize_t ret = len;
@@ -179,13 +175,34 @@ static const struct sysfs_ops dlm_attr_ops = {
 	.store = dlm_attr_store,
 };
 
+static const void *lockspace_kobj_namespace(const struct kobject *k)
+{
+	struct dlm_ls *ls = container_of(k, struct dlm_ls, ls_kobj);
+
+	return read_pnet(&ls->ls_dn->net);
+}
+
 static struct kobj_type dlm_ktype = {
 	.default_groups = dlm_groups,
-	.sysfs_ops     = &dlm_attr_ops,
+	.sysfs_ops      = &dlm_attr_ops,
+	.namespace      = lockspace_kobj_namespace,
 };
 
 static struct kset *dlm_kset;
 
+static const struct kobj_ns_type_operations *
+dlm_sysfs_object_child_ns_type(const struct kobject *kobj)
+{
+	return &net_ns_type_operations;
+}
+
+static const struct kobj_type dlm_kset_ktype = {
+	.sysfs_ops = &kobj_sysfs_ops,
+	.release   = kset_release,
+	.get_ownership = kset_get_ownership,
+	.child_ns_type = dlm_sysfs_object_child_ns_type,
+};
+
 static int do_uevent(struct dlm_ls *ls, int in)
 {
 	if (in)
@@ -218,14 +235,18 @@ static const struct kset_uevent_ops dlm_uevent_ops = {
 	.uevent = dlm_uevent,
 };
 
-int __init dlm_lockspace_init(void)
+void __net_init dlm_lockspace_net_init(struct dlm_net *dn)
 {
-	ls_count = 0;
-	mutex_init(&ls_lock);
-	INIT_LIST_HEAD(&lslist);
-	spin_lock_init(&lslist_lock);
+	dn->ls_count = 0;
+	mutex_init(&dn->ls_lock);
+	INIT_LIST_HEAD(&dn->lslist);
+	spin_lock_init(&dn->lslist_lock);
+}
 
-	dlm_kset = kset_create_and_add("dlm", &dlm_uevent_ops, kernel_kobj);
+int __init dlm_lockspace_init(void)
+{
+	dlm_kset = kset_type_create_and_add("dlm", &dlm_uevent_ops,
+					    kernel_kobj, &dlm_kset_ktype);
 	if (!dlm_kset) {
 		printk(KERN_WARNING "%s: can not create kset\n", __func__);
 		return -ENOMEM;
@@ -238,13 +259,13 @@ void dlm_lockspace_exit(void)
 	kset_unregister(dlm_kset);
 }
 
-struct dlm_ls *dlm_find_lockspace_name(const char *lsname)
+struct dlm_ls *dlm_find_lockspace_name(struct dlm_net *dn, const char *lsname)
 {
 	struct dlm_ls *ls;
 
-	spin_lock_bh(&lslist_lock);
+	spin_lock_bh(&dn->lslist_lock);
 
-	list_for_each_entry(ls, &lslist, ls_list) {
+	list_for_each_entry(ls, &dn->lslist, ls_list) {
 		if (!strncmp(ls->ls_name, lsname, DLM_LOCKSPACE_LEN)) {
 			atomic_inc(&ls->ls_count);
 			goto out;
@@ -252,17 +273,17 @@ struct dlm_ls *dlm_find_lockspace_name(const char *lsname)
 	}
 	ls = NULL;
  out:
-	spin_unlock_bh(&lslist_lock);
+	spin_unlock_bh(&dn->lslist_lock);
 	return ls;
 }
 
-struct dlm_ls *dlm_find_lockspace_global(uint32_t id)
+struct dlm_ls *dlm_find_lockspace_global(struct dlm_net *dn, uint32_t id)
 {
 	struct dlm_ls *ls;
 
-	spin_lock_bh(&lslist_lock);
+	spin_lock_bh(&dn->lslist_lock);
 
-	list_for_each_entry(ls, &lslist, ls_list) {
+	list_for_each_entry(ls, &dn->lslist, ls_list) {
 		if (ls->ls_global_id == id) {
 			atomic_inc(&ls->ls_count);
 			goto out;
@@ -270,7 +291,7 @@ struct dlm_ls *dlm_find_lockspace_global(uint32_t id)
 	}
 	ls = NULL;
  out:
-	spin_unlock_bh(&lslist_lock);
+	spin_unlock_bh(&dn->lslist_lock);
 	return ls;
 }
 
@@ -282,12 +303,12 @@ struct dlm_ls *dlm_find_lockspace_local(dlm_lockspace_t *lockspace)
 	return ls;
 }
 
-struct dlm_ls *dlm_find_lockspace_device(int minor)
+struct dlm_ls *dlm_find_lockspace_device(struct dlm_net *dn, int minor)
 {
 	struct dlm_ls *ls;
 
-	spin_lock_bh(&lslist_lock);
-	list_for_each_entry(ls, &lslist, ls_list) {
+	spin_lock_bh(&dn->lslist_lock);
+	list_for_each_entry(ls, &dn->lslist, ls_list) {
 		if (ls->ls_device.minor == minor) {
 			atomic_inc(&ls->ls_count);
 			goto out;
@@ -295,7 +316,7 @@ struct dlm_ls *dlm_find_lockspace_device(int minor)
 	}
 	ls = NULL;
  out:
-	spin_unlock_bh(&lslist_lock);
+	spin_unlock_bh(&dn->lslist_lock);
 	return ls;
 }
 
@@ -307,26 +328,28 @@ void dlm_put_lockspace(struct dlm_ls *ls)
 
 static void remove_lockspace(struct dlm_ls *ls)
 {
+	struct dlm_net *dn = ls->ls_dn;
+
 retry:
 	wait_event(ls->ls_count_wait, atomic_read(&ls->ls_count) == 0);
 
-	spin_lock_bh(&lslist_lock);
+	spin_lock_bh(&dn->lslist_lock);
 	if (atomic_read(&ls->ls_count) != 0) {
-		spin_unlock_bh(&lslist_lock);
+		spin_unlock_bh(&dn->lslist_lock);
 		goto retry;
 	}
 
 	WARN_ON(ls->ls_create_count != 0);
 	list_del(&ls->ls_list);
-	spin_unlock_bh(&lslist_lock);
+	spin_unlock_bh(&dn->lslist_lock);
 }
 
-static int threads_start(void)
+static int threads_start(struct dlm_net *dn)
 {
 	int error;
 
 	/* Thread for sending/receiving messages for all lockspace's */
-	error = dlm_midcomms_start();
+	error = dlm_midcomms_start(dn);
 	if (error)
 		log_print("cannot start dlm midcomms %d", error);
 
@@ -371,8 +394,8 @@ static void free_lockspace(struct work_struct *work)
 	kfree(ls);
 }
 
-static int new_lockspace(const char *name, const char *cluster,
-			 uint32_t flags, int lvblen,
+static int new_lockspace(struct dlm_net *dn, const char *name,
+			 const char *cluster, uint32_t flags, int lvblen,
 			 const struct dlm_lockspace_ops *ops, void *ops_arg,
 			 int *ops_result, dlm_lockspace_t **lockspace)
 {
@@ -389,14 +412,14 @@ static int new_lockspace(const char *name, const char *cluster,
 	if (!try_module_get(THIS_MODULE))
 		return -EINVAL;
 
-	if (!dlm_user_daemon_available()) {
+	if (!dlm_user_daemon_available(dn)) {
 		log_print("dlm user daemon not available");
 		error = -EUNATCH;
 		goto out;
 	}
 
 	if (ops && ops_result) {
-	       	if (!dlm_config.ci_recover_callbacks)
+		if (!dn->config.ci_recover_callbacks)
 			*ops_result = -EOPNOTSUPP;
 		else
 			*ops_result = 0;
@@ -404,21 +427,21 @@ static int new_lockspace(const char *name, const char *cluster,
 
 	if (!cluster)
 		log_print("dlm cluster name '%s' is being used without an application provided cluster name",
-			  dlm_config.ci_cluster_name);
+			  dn->config.ci_cluster_name);
 
-	if (dlm_config.ci_recover_callbacks && cluster &&
-	    strncmp(cluster, dlm_config.ci_cluster_name, DLM_LOCKSPACE_LEN)) {
+	if (dn->config.ci_recover_callbacks && cluster &&
+	    strncmp(cluster, dn->config.ci_cluster_name, DLM_LOCKSPACE_LEN)) {
 		log_print("dlm cluster name '%s' does not match "
 			  "the application cluster name '%s'",
-			  dlm_config.ci_cluster_name, cluster);
+			  dn->config.ci_cluster_name, cluster);
 		error = -EBADR;
 		goto out;
 	}
 
 	error = 0;
 
-	spin_lock_bh(&lslist_lock);
-	list_for_each_entry(ls, &lslist, ls_list) {
+	spin_lock_bh(&dn->lslist_lock);
+	list_for_each_entry(ls, &dn->lslist, ls_list) {
 		WARN_ON(ls->ls_create_count <= 0);
 		if (ls->ls_namelen != namelen)
 			continue;
@@ -433,7 +456,7 @@ static int new_lockspace(const char *name, const char *cluster,
 		error = 1;
 		break;
 	}
-	spin_unlock_bh(&lslist_lock);
+	spin_unlock_bh(&dn->lslist_lock);
 
 	if (error)
 		goto out;
@@ -449,8 +472,10 @@ static int new_lockspace(const char *name, const char *cluster,
 	atomic_set(&ls->ls_count, 0);
 	init_waitqueue_head(&ls->ls_count_wait);
 	ls->ls_flags = 0;
+	get_net_track(read_pnet(&dn->net), &ls->ls_tracker, GFP_NOFS);
+	ls->ls_dn = dn;
 
-	if (ops && dlm_config.ci_recover_callbacks) {
+	if (ops && dn->config.ci_recover_callbacks) {
 		ls->ls_ops = ops;
 		ls->ls_ops_arg = ops_arg;
 	}
@@ -548,10 +573,10 @@ static int new_lockspace(const char *name, const char *cluster,
 	spin_lock_init(&ls->ls_scan_lock);
 	timer_setup(&ls->ls_scan_timer, dlm_rsb_scan, TIMER_DEFERRABLE);
 
-	spin_lock_bh(&lslist_lock);
+	spin_lock_bh(&dn->lslist_lock);
 	ls->ls_create_count = 1;
-	list_add(&ls->ls_list, &lslist);
-	spin_unlock_bh(&lslist_lock);
+	list_add(&ls->ls_list, &dn->lslist);
+	spin_unlock_bh(&dn->lslist_lock);
 
 	if (flags & DLM_LSFL_FS)
 		set_bit(LSFL_FS, &ls->ls_flags);
@@ -618,9 +643,9 @@ static int new_lockspace(const char *name, const char *cluster,
  out_callback:
 	dlm_callback_stop(ls);
  out_delist:
-	spin_lock_bh(&lslist_lock);
+	spin_lock_bh(&dn->lslist_lock);
 	list_del(&ls->ls_list);
-	spin_unlock_bh(&lslist_lock);
+	spin_unlock_bh(&dn->lslist_lock);
 	xa_destroy(&ls->ls_recover_xa);
 	kfree(ls->ls_recover_buf);
  out_lkbxa:
@@ -628,38 +653,39 @@ static int new_lockspace(const char *name, const char *cluster,
 	rhashtable_destroy(&ls->ls_rsbtbl);
  out_lsfree:
 	kobject_put(&ls->ls_kobj);
+	put_net_track(read_pnet(&dn->net), &ls->ls_tracker);
 	kfree(ls);
  out:
 	module_put(THIS_MODULE);
 	return error;
 }
 
-static int __dlm_new_lockspace(const char *name, const char *cluster,
-			       uint32_t flags, int lvblen,
+static int __dlm_new_lockspace(struct dlm_net *dn, const char *name,
+			       const char *cluster, uint32_t flags, int lvblen,
 			       const struct dlm_lockspace_ops *ops,
 			       void *ops_arg, int *ops_result,
 			       dlm_lockspace_t **lockspace)
 {
 	int error = 0;
 
-	mutex_lock(&ls_lock);
-	if (!ls_count)
-		error = threads_start();
+	mutex_lock(&dn->ls_lock);
+	if (!dn->ls_count)
+		error = threads_start(dn);
 	if (error)
 		goto out;
 
-	error = new_lockspace(name, cluster, flags, lvblen, ops, ops_arg,
+	error = new_lockspace(dn, name, cluster, flags, lvblen, ops, ops_arg,
 			      ops_result, lockspace);
 	if (!error)
-		ls_count++;
+		dn->ls_count++;
 	if (error > 0)
 		error = 0;
-	if (!ls_count) {
-		dlm_midcomms_shutdown();
-		dlm_midcomms_stop();
+	if (!dn->ls_count) {
+		dlm_midcomms_shutdown(dn);
+		dlm_midcomms_stop(dn);
 	}
  out:
-	mutex_unlock(&ls_lock);
+	mutex_unlock(&dn->ls_lock);
 	return error;
 }
 
@@ -669,12 +695,14 @@ int dlm_new_lockspace(struct net *net, const char *name, const char *cluster,
 		      void *ops_arg, int *ops_result,
 		      dlm_lockspace_t **lockspace)
 {
-	return __dlm_new_lockspace(name, cluster, flags | DLM_LSFL_FS, lvblen,
+	struct dlm_net *dn = dlm_pernet(net);
+
+	return __dlm_new_lockspace(dn, name, cluster, flags | DLM_LSFL_FS, lvblen,
 				   ops, ops_arg, ops_result, lockspace);
 }
 
-int dlm_new_user_lockspace(const char *name, const char *cluster,
-			   uint32_t flags, int lvblen,
+int dlm_new_user_lockspace(struct dlm_net *dn, const char *name,
+			   const char *cluster, uint32_t flags, int lvblen,
 			   const struct dlm_lockspace_ops *ops,
 			   void *ops_arg, int *ops_result,
 			   dlm_lockspace_t **lockspace)
@@ -682,7 +710,7 @@ int dlm_new_user_lockspace(const char *name, const char *cluster,
 	if (flags & DLM_LSFL_SOFTIRQ)
 		return -EINVAL;
 
-	return __dlm_new_lockspace(name, cluster, flags, lvblen, ops,
+	return __dlm_new_lockspace(dn, name, cluster, flags, lvblen, ops,
 				   ops_arg, ops_result, lockspace);
 }
 
@@ -717,13 +745,13 @@ static int lockspace_busy(struct dlm_ls *ls, int force)
 	return rv;
 }
 
-static int release_lockspace(struct dlm_ls *ls, int force)
+static int release_lockspace(struct dlm_net *dn, struct dlm_ls *ls, int force)
 {
 	int busy, rv;
 
 	busy = lockspace_busy(ls, force);
 
-	spin_lock_bh(&lslist_lock);
+	spin_lock_bh(&dn->lslist_lock);
 	if (ls->ls_create_count == 1) {
 		if (busy) {
 			rv = -EBUSY;
@@ -737,19 +765,19 @@ static int release_lockspace(struct dlm_ls *ls, int force)
 	} else {
 		rv = -EINVAL;
 	}
-	spin_unlock_bh(&lslist_lock);
+	spin_unlock_bh(&dn->lslist_lock);
 
 	if (rv) {
 		log_debug(ls, "release_lockspace no remove %d", rv);
 		return rv;
 	}
 
-	if (ls_count == 1)
-		dlm_midcomms_version_wait();
+	if (dn->ls_count == 1)
+		dlm_midcomms_version_wait(ls->ls_dn);
 
 	dlm_device_deregister(ls);
 
-	if (force < 3 && dlm_user_daemon_available())
+	if (force < 3 && dlm_user_daemon_available(dn))
 		do_uevent(ls, 0);
 
 	dlm_recoverd_stop(ls);
@@ -760,9 +788,9 @@ static int release_lockspace(struct dlm_ls *ls, int force)
 	clear_bit(LSFL_RUNNING, &ls->ls_flags);
 	timer_shutdown_sync(&ls->ls_scan_timer);
 
-	if (ls_count == 1) {
+	if (dn->ls_count == 1) {
 		dlm_clear_members(ls);
-		dlm_midcomms_shutdown();
+		dlm_midcomms_shutdown(ls->ls_dn);
 	}
 
 	dlm_callback_stop(ls);
@@ -788,6 +816,8 @@ static int release_lockspace(struct dlm_ls *ls, int force)
 
 	log_rinfo(ls, "%s final free", __func__);
 
+	put_net_track(read_pnet(&dn->net), &ls->ls_tracker);
+
 	/* delayed free of data structures see free_lockspace() */
 	queue_work(dlm_wq, &ls->ls_free_work);
 	module_put(THIS_MODULE);
@@ -810,6 +840,7 @@ static int release_lockspace(struct dlm_ls *ls, int force)
 
 int dlm_release_lockspace(void *lockspace, int force)
 {
+	struct dlm_net *dn;
 	struct dlm_ls *ls;
 	int error;
 
@@ -818,36 +849,37 @@ int dlm_release_lockspace(void *lockspace, int force)
 		return -EINVAL;
 	dlm_put_lockspace(ls);
 
-	mutex_lock(&ls_lock);
-	error = release_lockspace(ls, force);
+	dn = ls->ls_dn;
+	mutex_lock(&dn->ls_lock);
+	error = release_lockspace(dn, ls, force);
 	if (!error)
-		ls_count--;
-	if (!ls_count)
-		dlm_midcomms_stop();
-	mutex_unlock(&ls_lock);
+		dn->ls_count--;
+	if (!dn->ls_count)
+		dlm_midcomms_stop(dn);
+	mutex_unlock(&dn->ls_lock);
 
 	return error;
 }
 
-void dlm_stop_lockspaces(void)
+void dlm_stop_lockspaces(struct dlm_net *dn)
 {
 	struct dlm_ls *ls;
 	int count;
 
  restart:
 	count = 0;
-	spin_lock_bh(&lslist_lock);
-	list_for_each_entry(ls, &lslist, ls_list) {
+	spin_lock_bh(&dn->lslist_lock);
+	list_for_each_entry(ls, &dn->lslist, ls_list) {
 		if (!test_bit(LSFL_RUNNING, &ls->ls_flags)) {
 			count++;
 			continue;
 		}
-		spin_unlock_bh(&lslist_lock);
+		spin_unlock_bh(&dn->lslist_lock);
 		log_error(ls, "no userland control daemon, stopping lockspace");
 		dlm_ls_stop(ls);
 		goto restart;
 	}
-	spin_unlock_bh(&lslist_lock);
+	spin_unlock_bh(&dn->lslist_lock);
 
 	if (count)
 		log_print("dlm user daemon left %d lockspaces", count);
diff --git a/fs/dlm/lockspace.h b/fs/dlm/lockspace.h
index 7898a906aab9..9d50fc44dc0b 100644
--- a/fs/dlm/lockspace.h
+++ b/fs/dlm/lockspace.h
@@ -22,14 +22,15 @@
 
 int dlm_lockspace_init(void);
 void dlm_lockspace_exit(void);
-struct dlm_ls *dlm_find_lockspace_name(const char *lsname);
-struct dlm_ls *dlm_find_lockspace_global(uint32_t id);
+void dlm_lockspace_net_init(struct dlm_net *dn);
+struct dlm_ls *dlm_find_lockspace_name(struct dlm_net *dn, const char *lsname);
+struct dlm_ls *dlm_find_lockspace_global(struct dlm_net *dn, uint32_t id);
 struct dlm_ls *dlm_find_lockspace_local(void *id);
-struct dlm_ls *dlm_find_lockspace_device(int minor);
+struct dlm_ls *dlm_find_lockspace_device(struct dlm_net *dn, int minor);
 void dlm_put_lockspace(struct dlm_ls *ls);
-void dlm_stop_lockspaces(void);
-int dlm_new_user_lockspace(const char *name, const char *cluster,
-			   uint32_t flags, int lvblen,
+void dlm_stop_lockspaces(struct dlm_net *dn);
+int dlm_new_user_lockspace(struct dlm_net *dn, const char *name,
+			   const char *cluster, uint32_t flags, int lvblen,
 			   const struct dlm_lockspace_ops *ops,
 			   void *ops_arg, int *ops_result,
 			   dlm_lockspace_t **lockspace);
diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index df40c3fd1070..a64905ba3e62 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -68,6 +68,7 @@
 
 struct connection {
 	struct socket *sock;	/* NULL if not connected */
+	struct dlm_net *dn;
 	uint32_t nodeid;	/* So we know who we are in the list */
 	/* this semaphore is used to allow parallel recv/send in read
 	 * lock mode. When we release a sock we need to held the write lock.
@@ -114,11 +115,6 @@ struct connection {
 };
 #define sock2con(x) ((struct connection *)(x)->sk_user_data)
 
-struct listen_connection {
-	struct socket *sock;
-	struct work_struct rwork;
-};
-
 #define DLM_WQ_REMAIN_BYTES(e) (PAGE_SIZE - e->end)
 #define DLM_WQ_LENGTH_BYTES(e) (e->end - e->offset)
 
@@ -156,39 +152,6 @@ struct processqueue_entry {
 	struct list_head list;
 };
 
-struct dlm_proto_ops {
-	bool try_new_addr;
-	const char *name;
-	int proto;
-
-	void (*sockopts)(struct socket *sock);
-	int (*bind)(struct socket *sock);
-	int (*listen_validate)(void);
-	void (*listen_sockopts)(struct socket *sock);
-	int (*listen_bind)(struct socket *sock);
-};
-
-static struct listen_sock_callbacks {
-	void (*sk_error_report)(struct sock *);
-	void (*sk_data_ready)(struct sock *);
-	void (*sk_state_change)(struct sock *);
-	void (*sk_write_space)(struct sock *);
-} listen_sock;
-
-static struct listen_connection listen_con;
-static struct sockaddr_storage dlm_local_addr[DLM_MAX_ADDR_COUNT];
-static int dlm_local_count;
-
-/* Work queues */
-static struct workqueue_struct *io_workqueue;
-static struct workqueue_struct *process_workqueue;
-
-static struct hlist_head connection_hash[CONN_HASH_SIZE];
-static DEFINE_SPINLOCK(connections_lock);
-DEFINE_STATIC_SRCU(connections_srcu);
-
-static const struct dlm_proto_ops *dlm_proto_ops;
-
 #define DLM_IO_SUCCESS 0
 #define DLM_IO_END 1
 #define DLM_IO_EOF 2
@@ -199,16 +162,9 @@ static void process_recv_sockets(struct work_struct *work);
 static void process_send_sockets(struct work_struct *work);
 static void process_dlm_messages(struct work_struct *work);
 
-static DECLARE_WORK(process_work, process_dlm_messages);
-static DEFINE_SPINLOCK(processqueue_lock);
-static bool process_dlm_messages_pending;
-static DECLARE_WAIT_QUEUE_HEAD(processqueue_wq);
-static atomic_t processqueue_count;
-static LIST_HEAD(processqueue);
-
-bool dlm_lowcomms_is_running(void)
+bool dlm_lowcomms_is_running(const struct dlm_net *dn)
 {
-	return !!listen_con.sock;
+	return !!dn->listen_con.sock;
 }
 
 static void lowcomms_queue_swork(struct connection *con)
@@ -218,7 +174,7 @@ static void lowcomms_queue_swork(struct connection *con)
 	if (!test_bit(CF_IO_STOP, &con->flags) &&
 	    !test_bit(CF_APP_LIMITED, &con->flags) &&
 	    !test_and_set_bit(CF_SEND_PENDING, &con->flags))
-		queue_work(io_workqueue, &con->swork);
+		queue_work(con->dn->io_workqueue, &con->swork);
 }
 
 static void lowcomms_queue_rwork(struct connection *con)
@@ -229,7 +185,7 @@ static void lowcomms_queue_rwork(struct connection *con)
 
 	if (!test_bit(CF_IO_STOP, &con->flags) &&
 	    !test_and_set_bit(CF_RECV_PENDING, &con->flags))
-		queue_work(io_workqueue, &con->rwork);
+		queue_work(con->dn->io_workqueue, &con->rwork);
 }
 
 static void writequeue_entry_ctor(void *data)
@@ -266,11 +222,12 @@ static struct writequeue_entry *con_next_wq(struct connection *con)
 	return e;
 }
 
-static struct connection *__find_con(int nodeid, int r)
+static struct connection *__find_con(const struct dlm_net *dn,
+				     int nodeid, int r)
 {
 	struct connection *con;
 
-	hlist_for_each_entry_rcu(con, &connection_hash[r], list) {
+	hlist_for_each_entry_rcu(con, &dn->connection_hash[r], list) {
 		if (con->nodeid == nodeid)
 			return con;
 	}
@@ -278,8 +235,10 @@ static struct connection *__find_con(int nodeid, int r)
 	return NULL;
 }
 
-static void dlm_con_init(struct connection *con, int nodeid)
+static void dlm_con_init(struct dlm_net *dn, struct connection *con,
+			 int nodeid)
 {
+	con->dn = dn;
 	con->nodeid = nodeid;
 	init_rwsem(&con->sock_lock);
 	INIT_LIST_HEAD(&con->writequeue);
@@ -294,13 +253,14 @@ static void dlm_con_init(struct connection *con, int nodeid)
  * If 'allocation' is zero then we don't attempt to create a new
  * connection structure for this node.
  */
-static struct connection *nodeid2con(int nodeid, gfp_t alloc)
+static struct connection *nodeid2con(struct dlm_net *dn, int nodeid,
+				     gfp_t alloc)
 {
 	struct connection *con, *tmp;
 	int r;
 
 	r = nodeid_hash(nodeid);
-	con = __find_con(nodeid, r);
+	con = __find_con(dn, nodeid, r);
 	if (con || !alloc)
 		return con;
 
@@ -308,24 +268,24 @@ static struct connection *nodeid2con(int nodeid, gfp_t alloc)
 	if (!con)
 		return NULL;
 
-	dlm_con_init(con, nodeid);
+	dlm_con_init(dn, con, nodeid);
 
-	spin_lock(&connections_lock);
+	spin_lock(&dn->connections_lock);
 	/* Because multiple workqueues/threads calls this function it can
 	 * race on multiple cpu's. Instead of locking hot path __find_con()
 	 * we just check in rare cases of recently added nodes again
 	 * under protection of connections_lock. If this is the case we
 	 * abort our connection creation and return the existing connection.
 	 */
-	tmp = __find_con(nodeid, r);
+	tmp = __find_con(dn, nodeid, r);
 	if (tmp) {
-		spin_unlock(&connections_lock);
+		spin_unlock(&dn->connections_lock);
 		kfree(con);
 		return tmp;
 	}
 
-	hlist_add_head_rcu(&con->list, &connection_hash[r]);
-	spin_unlock(&connections_lock);
+	hlist_add_head_rcu(&con->list, &dn->connection_hash[r]);
+	spin_unlock(&dn->connections_lock);
 
 	return con;
 }
@@ -358,7 +318,8 @@ static int addr_compare(const struct sockaddr_storage *x,
 	return 1;
 }
 
-static int nodeid_to_addr(int nodeid, struct sockaddr_storage *sas_out,
+static int nodeid_to_addr(struct dlm_net *dn, int nodeid,
+			  struct sockaddr_storage *sas_out,
 			  struct sockaddr *sa_out, bool try_new_addr,
 			  unsigned int *mark)
 {
@@ -366,20 +327,20 @@ static int nodeid_to_addr(int nodeid, struct sockaddr_storage *sas_out,
 	struct connection *con;
 	int idx;
 
-	if (!dlm_local_count)
+	if (!dn->dlm_local_count)
 		return -1;
 
-	idx = srcu_read_lock(&connections_srcu);
-	con = nodeid2con(nodeid, 0);
+	idx = srcu_read_lock(&dn->connections_srcu);
+	con = nodeid2con(dn, nodeid, 0);
 	if (!con) {
-		srcu_read_unlock(&connections_srcu, idx);
+		srcu_read_unlock(&dn->connections_srcu, idx);
 		return -ENOENT;
 	}
 
 	spin_lock(&con->addrs_lock);
 	if (!con->addr_count) {
 		spin_unlock(&con->addrs_lock);
-		srcu_read_unlock(&connections_srcu, idx);
+		srcu_read_unlock(&dn->connections_srcu, idx);
 		return -ENOENT;
 	}
 
@@ -399,11 +360,11 @@ static int nodeid_to_addr(int nodeid, struct sockaddr_storage *sas_out,
 		memcpy(sas_out, &sas, sizeof(struct sockaddr_storage));
 
 	if (!sa_out) {
-		srcu_read_unlock(&connections_srcu, idx);
+		srcu_read_unlock(&dn->connections_srcu, idx);
 		return 0;
 	}
 
-	if (dlm_local_addr[0].ss_family == AF_INET) {
+	if (dn->dlm_local_addr[0].ss_family == AF_INET) {
 		struct sockaddr_in *in4  = (struct sockaddr_in *) &sas;
 		struct sockaddr_in *ret4 = (struct sockaddr_in *) sa_out;
 		ret4->sin_addr.s_addr = in4->sin_addr.s_addr;
@@ -413,19 +374,19 @@ static int nodeid_to_addr(int nodeid, struct sockaddr_storage *sas_out,
 		ret6->sin6_addr = in6->sin6_addr;
 	}
 
-	srcu_read_unlock(&connections_srcu, idx);
+	srcu_read_unlock(&dn->connections_srcu, idx);
 	return 0;
 }
 
-static int addr_to_nodeid(struct sockaddr_storage *addr, int *nodeid,
-			  unsigned int *mark)
+static int addr_to_nodeid(struct dlm_net *dn, struct sockaddr_storage *addr,
+			  int *nodeid, unsigned int *mark)
 {
 	struct connection *con;
 	int i, idx, addr_i;
 
-	idx = srcu_read_lock(&connections_srcu);
+	idx = srcu_read_lock(&dn->connections_srcu);
 	for (i = 0; i < CONN_HASH_SIZE; i++) {
-		hlist_for_each_entry_rcu(con, &connection_hash[i], list) {
+		hlist_for_each_entry_rcu(con, &dn->connection_hash[i], list) {
 			WARN_ON_ONCE(!con->addr_count);
 
 			spin_lock(&con->addrs_lock);
@@ -434,14 +395,14 @@ static int addr_to_nodeid(struct sockaddr_storage *addr, int *nodeid,
 					*nodeid = con->nodeid;
 					*mark = con->mark;
 					spin_unlock(&con->addrs_lock);
-					srcu_read_unlock(&connections_srcu, idx);
+					srcu_read_unlock(&dn->connections_srcu, idx);
 					return 0;
 				}
 			}
 			spin_unlock(&con->addrs_lock);
 		}
 	}
-	srcu_read_unlock(&connections_srcu, idx);
+	srcu_read_unlock(&dn->connections_srcu, idx);
 
 	return -ENOENT;
 }
@@ -459,15 +420,16 @@ static bool dlm_lowcomms_con_has_addr(const struct connection *con,
 	return false;
 }
 
-int dlm_lowcomms_addr(int nodeid, struct sockaddr_storage *addr)
+int dlm_lowcomms_addr(struct dlm_net *dn, int nodeid,
+		      struct sockaddr_storage *addr)
 {
 	struct connection *con;
 	bool ret, idx;
 
-	idx = srcu_read_lock(&connections_srcu);
-	con = nodeid2con(nodeid, GFP_NOFS);
+	idx = srcu_read_lock(&dn->connections_srcu);
+	con = nodeid2con(dn, nodeid, GFP_NOFS);
 	if (!con) {
-		srcu_read_unlock(&connections_srcu, idx);
+		srcu_read_unlock(&dn->connections_srcu, idx);
 		return -ENOMEM;
 	}
 
@@ -475,27 +437,27 @@ int dlm_lowcomms_addr(int nodeid, struct sockaddr_storage *addr)
 	if (!con->addr_count) {
 		memcpy(&con->addr[0], addr, sizeof(*addr));
 		con->addr_count = 1;
-		con->mark = dlm_config.ci_mark;
+		con->mark = dn->config.ci_mark;
 		spin_unlock(&con->addrs_lock);
-		srcu_read_unlock(&connections_srcu, idx);
+		srcu_read_unlock(&dn->connections_srcu, idx);
 		return 0;
 	}
 
 	ret = dlm_lowcomms_con_has_addr(con, addr);
 	if (ret) {
 		spin_unlock(&con->addrs_lock);
-		srcu_read_unlock(&connections_srcu, idx);
+		srcu_read_unlock(&dn->connections_srcu, idx);
 		return -EEXIST;
 	}
 
 	if (con->addr_count >= DLM_MAX_ADDR_COUNT) {
 		spin_unlock(&con->addrs_lock);
-		srcu_read_unlock(&connections_srcu, idx);
+		srcu_read_unlock(&dn->connections_srcu, idx);
 		return -ENOSPC;
 	}
 
 	memcpy(&con->addr[con->addr_count++], addr, sizeof(*addr));
-	srcu_read_unlock(&connections_srcu, idx);
+	srcu_read_unlock(&dn->connections_srcu, idx);
 	spin_unlock(&con->addrs_lock);
 	return 0;
 }
@@ -538,20 +500,22 @@ static void lowcomms_state_change(struct sock *sk)
 
 static void lowcomms_listen_data_ready(struct sock *sk)
 {
+	struct dlm_net *dn = dlm_pernet(sock_net(sk));
+
 	trace_sk_data_ready(sk);
 
-	queue_work(io_workqueue, &listen_con.rwork);
+	queue_work(dn->io_workqueue, &dn->listen_con.rwork);
 }
 
-int dlm_lowcomms_connect_node(int nodeid)
+int dlm_lowcomms_connect_node(struct dlm_net *dn, int nodeid)
 {
 	struct connection *con;
 	int idx;
 
-	idx = srcu_read_lock(&connections_srcu);
-	con = nodeid2con(nodeid, 0);
+	idx = srcu_read_lock(&dn->connections_srcu);
+	con = nodeid2con(dn, nodeid, 0);
 	if (WARN_ON_ONCE(!con)) {
-		srcu_read_unlock(&connections_srcu, idx);
+		srcu_read_unlock(&dn->connections_srcu, idx);
 		return -ENOENT;
 	}
 
@@ -562,28 +526,29 @@ int dlm_lowcomms_connect_node(int nodeid)
 		spin_unlock_bh(&con->writequeue_lock);
 	}
 	up_read(&con->sock_lock);
-	srcu_read_unlock(&connections_srcu, idx);
+	srcu_read_unlock(&dn->connections_srcu, idx);
 
 	cond_resched();
 	return 0;
 }
 
-int dlm_lowcomms_nodes_set_mark(int nodeid, unsigned int mark)
+int dlm_lowcomms_nodes_set_mark(struct dlm_net *dn, int nodeid,
+				unsigned int mark)
 {
 	struct connection *con;
 	int idx;
 
-	idx = srcu_read_lock(&connections_srcu);
-	con = nodeid2con(nodeid, 0);
+	idx = srcu_read_lock(&dn->connections_srcu);
+	con = nodeid2con(dn, nodeid, 0);
 	if (!con) {
-		srcu_read_unlock(&connections_srcu, idx);
+		srcu_read_unlock(&dn->connections_srcu, idx);
 		return -ENOENT;
 	}
 
 	spin_lock(&con->addrs_lock);
 	con->mark = mark;
 	spin_unlock(&con->addrs_lock);
-	srcu_read_unlock(&connections_srcu, idx);
+	srcu_read_unlock(&dn->connections_srcu, idx);
 	return 0;
 }
 
@@ -595,48 +560,47 @@ static void lowcomms_error_report(struct sock *sk)
 	inet = inet_sk(sk);
 	switch (sk->sk_family) {
 	case AF_INET:
-		printk_ratelimited(KERN_ERR "dlm: node %d: socket error "
-				   "sending to node %d at %pI4, dport %d, "
-				   "sk_err=%d/%d\n", dlm_our_nodeid(),
+		pr_err_ratelimited("dlm: node %d: socket error sending to node %d at %pI4, dport %d, sk_err=%d/%d\n",
+				   dlm_our_nodeid(con->dn),
 				   con->nodeid, &inet->inet_daddr,
 				   ntohs(inet->inet_dport), sk->sk_err,
 				   READ_ONCE(sk->sk_err_soft));
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
 	case AF_INET6:
-		printk_ratelimited(KERN_ERR "dlm: node %d: socket error "
-				   "sending to node %d at %pI6c, "
-				   "dport %d, sk_err=%d/%d\n", dlm_our_nodeid(),
+		pr_err_ratelimited("dlm: node %d: socket error sending to node %d at %pI6c, dport %d, sk_err=%d/%d\n",
+				   dlm_our_nodeid(con->dn),
 				   con->nodeid, &sk->sk_v6_daddr,
 				   ntohs(inet->inet_dport), sk->sk_err,
 				   READ_ONCE(sk->sk_err_soft));
 		break;
 #endif
 	default:
-		printk_ratelimited(KERN_ERR "dlm: node %d: socket error "
-				   "invalid socket family %d set, "
-				   "sk_err=%d/%d\n", dlm_our_nodeid(),
+		pr_err_ratelimited("dlm: node %d: socket error invalid socket family %d set, sk_err=%d/%d\n",
+				   dlm_our_nodeid(con->dn),
 				   sk->sk_family, sk->sk_err,
 				   READ_ONCE(sk->sk_err_soft));
 		break;
 	}
 
-	dlm_midcomms_unack_msg_resend(con->nodeid);
+	dlm_midcomms_unack_msg_resend(con->dn, con->nodeid);
 
-	listen_sock.sk_error_report(sk);
+	con->dn->listen_sock.sk_error_report(sk);
 }
 
 static void restore_callbacks(struct sock *sk)
 {
+	struct dlm_net *dn = dlm_pernet(sock_net(sk));
+
 #ifdef CONFIG_LOCKDEP
 	WARN_ON_ONCE(!lockdep_sock_is_held(sk));
 #endif
 
 	sk->sk_user_data = NULL;
-	sk->sk_data_ready = listen_sock.sk_data_ready;
-	sk->sk_state_change = listen_sock.sk_state_change;
-	sk->sk_write_space = listen_sock.sk_write_space;
-	sk->sk_error_report = listen_sock.sk_error_report;
+	sk->sk_data_ready = dn->listen_sock.sk_data_ready;
+	sk->sk_state_change = dn->listen_sock.sk_state_change;
+	sk->sk_write_space = dn->listen_sock.sk_write_space;
+	sk->sk_error_report = dn->listen_sock.sk_error_report;
 }
 
 /* Make a socket active */
@@ -650,7 +614,7 @@ static void add_sock(struct socket *sock, struct connection *con)
 	sk->sk_user_data = con;
 	sk->sk_data_ready = lowcomms_data_ready;
 	sk->sk_write_space = lowcomms_write_space;
-	if (dlm_config.ci_protocol == DLM_PROTO_SCTP)
+	if (con->dn->config.ci_protocol == DLM_PROTO_SCTP)
 		sk->sk_state_change = lowcomms_state_change;
 	sk->sk_allocation = GFP_NOFS;
 	sk->sk_use_task_frag = false;
@@ -660,10 +624,11 @@ static void add_sock(struct socket *sock, struct connection *con)
 
 /* Add the port number to an IPv6 or 4 sockaddr and return the address
    length */
-static void make_sockaddr(struct sockaddr_storage *saddr, __be16 port,
-			  int *addr_len)
+static void make_sockaddr(const struct dlm_net *dn,
+			  struct sockaddr_storage *saddr,
+			  __be16 port, int *addr_len)
 {
-	saddr->ss_family =  dlm_local_addr[0].ss_family;
+	saddr->ss_family =  dn->dlm_local_addr[0].ss_family;
 	if (saddr->ss_family == AF_INET) {
 		struct sockaddr_in *in4_addr = (struct sockaddr_in *)saddr;
 		in4_addr->sin_port = port;
@@ -801,7 +766,7 @@ static void shutdown_connection(struct connection *con, bool and_other)
 	if (con->othercon && and_other)
 		shutdown_connection(con->othercon, false);
 
-	flush_workqueue(io_workqueue);
+	flush_workqueue(con->dn->io_workqueue);
 	down_read(&con->sock_lock);
 	/* nothing to shutdown */
 	if (!con->sock) {
@@ -858,40 +823,42 @@ static void free_processqueue_entry(struct processqueue_entry *pentry)
 
 static void process_dlm_messages(struct work_struct *work)
 {
+	struct dlm_net *dn = container_of(work, struct dlm_net,
+					  process_work);
 	struct processqueue_entry *pentry;
 
-	spin_lock_bh(&processqueue_lock);
-	pentry = list_first_entry_or_null(&processqueue,
+	spin_lock_bh(&dn->processqueue_lock);
+	pentry = list_first_entry_or_null(&dn->processqueue,
 					  struct processqueue_entry, list);
 	if (WARN_ON_ONCE(!pentry)) {
-		process_dlm_messages_pending = false;
-		spin_unlock_bh(&processqueue_lock);
+		dn->process_dlm_messages_pending = false;
+		spin_unlock_bh(&dn->processqueue_lock);
 		return;
 	}
 
 	list_del(&pentry->list);
-	if (atomic_dec_and_test(&processqueue_count))
-		wake_up(&processqueue_wq);
-	spin_unlock_bh(&processqueue_lock);
+	if (atomic_dec_and_test(&dn->processqueue_count))
+		wake_up(&dn->processqueue_wq);
+	spin_unlock_bh(&dn->processqueue_lock);
 
 	for (;;) {
-		dlm_process_incoming_buffer(pentry->nodeid, pentry->buf,
+		dlm_process_incoming_buffer(dn, pentry->nodeid, pentry->buf,
 					    pentry->buflen);
 		free_processqueue_entry(pentry);
 
-		spin_lock_bh(&processqueue_lock);
-		pentry = list_first_entry_or_null(&processqueue,
+		spin_lock_bh(&dn->processqueue_lock);
+		pentry = list_first_entry_or_null(&dn->processqueue,
 						  struct processqueue_entry, list);
 		if (!pentry) {
-			process_dlm_messages_pending = false;
-			spin_unlock_bh(&processqueue_lock);
+			dn->process_dlm_messages_pending = false;
+			spin_unlock_bh(&dn->processqueue_lock);
 			break;
 		}
 
 		list_del(&pentry->list);
-		if (atomic_dec_and_test(&processqueue_count))
-			wake_up(&processqueue_wq);
-		spin_unlock_bh(&processqueue_lock);
+		if (atomic_dec_and_test(&dn->processqueue_count))
+			wake_up(&dn->processqueue_wq);
+		spin_unlock_bh(&dn->processqueue_lock);
 	}
 }
 
@@ -899,6 +866,7 @@ static void process_dlm_messages(struct work_struct *work)
 static int receive_from_sock(struct connection *con, int buflen)
 {
 	struct processqueue_entry *pentry;
+	struct dlm_net *dn = con->dn;
 	int ret, buflen_real;
 	struct msghdr msg;
 	struct kvec iov;
@@ -961,14 +929,14 @@ static int receive_from_sock(struct connection *con, int buflen)
 	memmove(con->rx_leftover_buf, pentry->buf + ret,
 		con->rx_leftover);
 
-	spin_lock_bh(&processqueue_lock);
-	ret = atomic_inc_return(&processqueue_count);
-	list_add_tail(&pentry->list, &processqueue);
-	if (!process_dlm_messages_pending) {
-		process_dlm_messages_pending = true;
-		queue_work(process_workqueue, &process_work);
+	spin_lock_bh(&dn->processqueue_lock);
+	ret = atomic_inc_return(&dn->processqueue_count);
+	list_add_tail(&pentry->list, &dn->processqueue);
+	if (!dn->process_dlm_messages_pending) {
+		dn->process_dlm_messages_pending = true;
+		queue_work(dn->process_workqueue, &dn->process_work);
 	}
-	spin_unlock_bh(&processqueue_lock);
+	spin_unlock_bh(&dn->processqueue_lock);
 
 	if (ret > DLM_MAX_PROCESS_BUFFERS)
 		return DLM_IO_FLUSH;
@@ -977,7 +945,7 @@ static int receive_from_sock(struct connection *con, int buflen)
 }
 
 /* Listening socket is busy, accept a connection */
-static int accept_from_sock(void)
+static int accept_from_sock(struct dlm_net *dn)
 {
 	struct sockaddr_storage peeraddr;
 	int len, idx, result, nodeid;
@@ -985,7 +953,7 @@ static int accept_from_sock(void)
 	struct socket *newsock;
 	unsigned int mark;
 
-	result = kernel_accept(listen_con.sock, &newsock, O_NONBLOCK);
+	result = kernel_accept(dn->listen_con.sock, &newsock, O_NONBLOCK);
 	if (result == -EAGAIN)
 		return DLM_IO_END;
 	else if (result < 0)
@@ -1000,8 +968,8 @@ static int accept_from_sock(void)
 	}
 
 	/* Get the new node's NODEID */
-	make_sockaddr(&peeraddr, 0, &len);
-	if (addr_to_nodeid(&peeraddr, &nodeid, &mark)) {
+	make_sockaddr(dn, &peeraddr, 0, &len);
+	if (addr_to_nodeid(dn, &peeraddr, &nodeid, &mark)) {
 		switch (peeraddr.ss_family) {
 		case AF_INET: {
 			struct sockaddr_in *sin = (struct sockaddr_in *)&peeraddr;
@@ -1035,10 +1003,10 @@ static int accept_from_sock(void)
 	 *  the same time and the connections cross on the wire.
 	 *  In this case we store the incoming one in "othercon"
 	 */
-	idx = srcu_read_lock(&connections_srcu);
-	newcon = nodeid2con(nodeid, 0);
+	idx = srcu_read_lock(&dn->connections_srcu);
+	newcon = nodeid2con(dn, nodeid, 0);
 	if (WARN_ON_ONCE(!newcon)) {
-		srcu_read_unlock(&connections_srcu, idx);
+		srcu_read_unlock(&dn->connections_srcu, idx);
 		result = -ENOENT;
 		goto accept_err;
 	}
@@ -1054,12 +1022,12 @@ static int accept_from_sock(void)
 			if (!othercon) {
 				log_print("failed to allocate incoming socket");
 				up_write(&newcon->sock_lock);
-				srcu_read_unlock(&connections_srcu, idx);
+				srcu_read_unlock(&dn->connections_srcu, idx);
 				result = -ENOMEM;
 				goto accept_err;
 			}
 
-			dlm_con_init(othercon, nodeid);
+			dlm_con_init(dn, othercon, nodeid);
 			lockdep_set_subclass(&othercon->sock_lock, 1);
 			newcon->othercon = othercon;
 			set_bit(CF_IS_OTHERCON, &othercon->flags);
@@ -1089,7 +1057,7 @@ static int accept_from_sock(void)
 		release_sock(newcon->sock->sk);
 	}
 	up_write(&newcon->sock_lock);
-	srcu_read_unlock(&connections_srcu, idx);
+	srcu_read_unlock(&dn->connections_srcu, idx);
 
 	return DLM_IO_SUCCESS;
 
@@ -1121,15 +1089,16 @@ static void writequeue_entry_complete(struct writequeue_entry *e, int completed)
 /*
  * sctp_bind_addrs - bind a SCTP socket to all our addresses
  */
-static int sctp_bind_addrs(struct socket *sock, __be16 port)
+static int sctp_bind_addrs(struct dlm_net *dn, struct socket *sock,
+			   __be16 port)
 {
 	struct sockaddr_storage localaddr;
 	struct sockaddr *addr = (struct sockaddr *)&localaddr;
 	int i, addr_len, result = 0;
 
-	for (i = 0; i < dlm_local_count; i++) {
-		memcpy(&localaddr, &dlm_local_addr[i], sizeof(localaddr));
-		make_sockaddr(&localaddr, port, &addr_len);
+	for (i = 0; i < dn->dlm_local_count; i++) {
+		memcpy(&localaddr, &dn->dlm_local_addr[i], sizeof(localaddr));
+		make_sockaddr(dn, &localaddr, port, &addr_len);
 
 		if (!i)
 			result = kernel_bind(sock, addr, addr_len);
@@ -1146,17 +1115,18 @@ static int sctp_bind_addrs(struct socket *sock, __be16 port)
 }
 
 /* Get local addresses */
-static void init_local(void)
+static void init_local(struct dlm_net *dn)
 {
 	struct sockaddr_storage sas;
 	int i;
 
-	dlm_local_count = 0;
+	dn->dlm_local_count = 0;
 	for (i = 0; i < DLM_MAX_ADDR_COUNT; i++) {
-		if (dlm_our_addr(&sas, i))
+		if (dlm_our_addr(dn, &sas, i))
 			break;
 
-		memcpy(&dlm_local_addr[dlm_local_count++], &sas, sizeof(sas));
+		memcpy(&dn->dlm_local_addr[dn->dlm_local_count++], &sas,
+		       sizeof(sas));
 	}
 }
 
@@ -1255,8 +1225,9 @@ static struct dlm_msg *dlm_lowcomms_new_msg_con(struct connection *con, int len,
  * dlm_lowcomms_commit_msg which is a must call if success
  */
 #ifndef __CHECKER__
-struct dlm_msg *dlm_lowcomms_new_msg(int nodeid, int len, char **ppc,
-				     void (*cb)(void *data), void *data)
+struct dlm_msg *dlm_lowcomms_new_msg(struct dlm_net *dn, int nodeid, int len,
+				     char **ppc, void (*cb)(void *data),
+				     void *data)
 {
 	struct connection *con;
 	struct dlm_msg *msg;
@@ -1270,16 +1241,16 @@ struct dlm_msg *dlm_lowcomms_new_msg(int nodeid, int len, char **ppc,
 		return NULL;
 	}
 
-	idx = srcu_read_lock(&connections_srcu);
-	con = nodeid2con(nodeid, 0);
+	idx = srcu_read_lock(&dn->connections_srcu);
+	con = nodeid2con(dn, nodeid, 0);
 	if (WARN_ON_ONCE(!con)) {
-		srcu_read_unlock(&connections_srcu, idx);
+		srcu_read_unlock(&dn->connections_srcu, idx);
 		return NULL;
 	}
 
 	msg = dlm_lowcomms_new_msg_con(con, len, ppc, cb, data);
 	if (!msg) {
-		srcu_read_unlock(&connections_srcu, idx);
+		srcu_read_unlock(&dn->connections_srcu, idx);
 		return NULL;
 	}
 
@@ -1320,8 +1291,12 @@ static void _dlm_lowcomms_commit_msg(struct dlm_msg *msg)
 #ifndef __CHECKER__
 void dlm_lowcomms_commit_msg(struct dlm_msg *msg)
 {
+	struct writequeue_entry *e = msg->entry;
+	struct connection *con = e->con;
+	struct dlm_net *dn = con->dn;
+
 	_dlm_lowcomms_commit_msg(msg);
-	srcu_read_unlock(&connections_srcu, msg->idx);
+	srcu_read_unlock(&dn->connections_srcu, msg->idx);
 	/* because dlm_lowcomms_new_msg() */
 	kref_put(&msg->ref, dlm_msg_release);
 }
@@ -1439,17 +1414,17 @@ static void connection_release(struct rcu_head *rcu)
 
 /* Called from recovery when it knows that a node has
    left the cluster */
-int dlm_lowcomms_close(int nodeid)
+int dlm_lowcomms_close(struct dlm_net *dn, int nodeid)
 {
 	struct connection *con;
 	int idx;
 
 	log_print("closing connection to node %d", nodeid);
 
-	idx = srcu_read_lock(&connections_srcu);
-	con = nodeid2con(nodeid, 0);
+	idx = srcu_read_lock(&dn->connections_srcu);
+	con = nodeid2con(dn, nodeid, 0);
 	if (WARN_ON_ONCE(!con)) {
-		srcu_read_unlock(&connections_srcu, idx);
+		srcu_read_unlock(&dn->connections_srcu, idx);
 		return -ENOENT;
 	}
 
@@ -1457,17 +1432,18 @@ int dlm_lowcomms_close(int nodeid)
 	log_print("io handling for node: %d stopped", nodeid);
 	close_connection(con, true);
 
-	spin_lock(&connections_lock);
+	spin_lock(&dn->connections_lock);
 	hlist_del_rcu(&con->list);
-	spin_unlock(&connections_lock);
+	spin_unlock(&dn->connections_lock);
 
 	clean_one_writequeue(con);
-	call_srcu(&connections_srcu, &con->rcu, connection_release);
+	call_srcu(&dn->connections_srcu, &con->rcu, connection_release);
 	if (con->othercon) {
 		clean_one_writequeue(con->othercon);
-		call_srcu(&connections_srcu, &con->othercon->rcu, connection_release);
+		call_srcu(&dn->connections_srcu, &con->othercon->rcu,
+			  connection_release);
 	}
-	srcu_read_unlock(&connections_srcu, idx);
+	srcu_read_unlock(&dn->connections_srcu, idx);
 
 	/* for debugging we print when we are done to compare with other
 	 * messages in between. This function need to be correctly synchronized
@@ -1482,6 +1458,7 @@ int dlm_lowcomms_close(int nodeid)
 static void process_recv_sockets(struct work_struct *work)
 {
 	struct connection *con = container_of(work, struct connection, rwork);
+	struct dlm_net *dn = con->dn;
 	int ret, buflen;
 
 	down_read(&con->sock_lock);
@@ -1490,7 +1467,7 @@ static void process_recv_sockets(struct work_struct *work)
 		return;
 	}
 
-	buflen = READ_ONCE(dlm_config.ci_buffer_size);
+	buflen = READ_ONCE(dn->config.ci_buffer_size);
 	do {
 		ret = receive_from_sock(con, buflen);
 	} while (ret == DLM_IO_SUCCESS);
@@ -1519,11 +1496,11 @@ static void process_recv_sockets(struct work_struct *work)
 		 * removed. Especially in a message burst we are too slow to
 		 * process messages and the queue will fill up memory.
 		 */
-		wait_event(processqueue_wq, !atomic_read(&processqueue_count));
+		wait_event(dn->processqueue_wq, !atomic_read(&dn->processqueue_count));
 		fallthrough;
 	case DLM_IO_RESCHED:
 		cond_resched();
-		queue_work(io_workqueue, &con->rwork);
+		queue_work(dn->io_workqueue, &con->rwork);
 		/* CF_RECV_PENDING not cleared */
 		break;
 	default:
@@ -1550,13 +1527,15 @@ static void process_recv_sockets(struct work_struct *work)
 
 static void process_listen_recv_socket(struct work_struct *work)
 {
+	struct dlm_net *dn = container_of(work, struct dlm_net,
+					  listen_con.rwork);
 	int ret;
 
-	if (WARN_ON_ONCE(!listen_con.sock))
+	if (WARN_ON_ONCE(!dn->listen_con.sock))
 		return;
 
 	do {
-		ret = accept_from_sock();
+		ret = accept_from_sock(dn);
 	} while (ret == DLM_IO_SUCCESS);
 
 	if (ret < 0)
@@ -1566,28 +1545,30 @@ static void process_listen_recv_socket(struct work_struct *work)
 static int dlm_connect(struct connection *con)
 {
 	struct sockaddr_storage addr;
+	struct dlm_net *dn = con->dn;
 	int result, addr_len;
 	struct socket *sock;
 	unsigned int mark;
 
 	memset(&addr, 0, sizeof(addr));
-	result = nodeid_to_addr(con->nodeid, &addr, NULL,
-				dlm_proto_ops->try_new_addr, &mark);
+	result = nodeid_to_addr(dn, con->nodeid, &addr, NULL,
+				dn->dlm_proto_ops->try_new_addr, &mark);
 	if (result < 0) {
 		log_print("no address for nodeid %d", con->nodeid);
 		return result;
 	}
 
 	/* Create a socket to communicate with */
-	result = sock_create_kern(&init_net, dlm_local_addr[0].ss_family,
-				  SOCK_STREAM, dlm_proto_ops->proto, &sock);
+	result = sock_create_kern(read_pnet(&dn->net), dn->dlm_local_addr[0].ss_family,
+				  SOCK_STREAM, dn->dlm_proto_ops->proto,
+				  &sock);
 	if (result < 0)
 		return result;
 
 	sock_set_mark(sock->sk, mark);
-	dlm_proto_ops->sockopts(sock);
+	dn->dlm_proto_ops->sockopts(sock);
 
-	result = dlm_proto_ops->bind(sock);
+	result = dn->dlm_proto_ops->bind(dn, sock);
 	if (result < 0) {
 		sock_release(sock);
 		return result;
@@ -1596,7 +1577,7 @@ static int dlm_connect(struct connection *con)
 	add_sock(sock, con);
 
 	log_print_ratelimited("connecting to %d", con->nodeid);
-	make_sockaddr(&addr, dlm_config.ci_tcp_port, &addr_len);
+	make_sockaddr(dn, &addr, dn->config.ci_tcp_port, &addr_len);
 	result = kernel_connect(sock, (struct sockaddr *)&addr, addr_len, 0);
 	switch (result) {
 	case -EINPROGRESS:
@@ -1618,6 +1599,7 @@ static int dlm_connect(struct connection *con)
 static void process_send_sockets(struct work_struct *work)
 {
 	struct connection *con = container_of(work, struct connection, swork);
+	struct dlm_net *dn = con->dn;
 	int ret;
 
 	WARN_ON_ONCE(test_bit(CF_IS_OTHERCON, &con->flags));
@@ -1642,7 +1624,7 @@ static void process_send_sockets(struct work_struct *work)
 				 * manager to fence itself after certain amount
 				 * of retries.
 				 */
-				queue_work(io_workqueue, &con->swork);
+				queue_work(dn->io_workqueue, &con->swork);
 				return;
 			}
 		}
@@ -1661,7 +1643,7 @@ static void process_send_sockets(struct work_struct *work)
 	case DLM_IO_RESCHED:
 		/* CF_SEND_PENDING not cleared */
 		cond_resched();
-		queue_work(io_workqueue, &con->swork);
+		queue_work(dn->io_workqueue, &con->swork);
 		break;
 	default:
 		if (ret < 0) {
@@ -1679,58 +1661,59 @@ static void process_send_sockets(struct work_struct *work)
 	}
 }
 
-static void work_stop(void)
+static void work_stop(struct dlm_net *dn)
 {
-	if (io_workqueue) {
-		destroy_workqueue(io_workqueue);
-		io_workqueue = NULL;
+	if (dn->io_workqueue) {
+		destroy_workqueue(dn->io_workqueue);
+		dn->io_workqueue = NULL;
 	}
 
-	if (process_workqueue) {
-		destroy_workqueue(process_workqueue);
-		process_workqueue = NULL;
+	if (dn->process_workqueue) {
+		destroy_workqueue(dn->process_workqueue);
+		dn->process_workqueue = NULL;
 	}
 }
 
-static int work_start(void)
+static int work_start(struct dlm_net *dn)
 {
-	io_workqueue = alloc_workqueue("dlm_io", WQ_HIGHPRI | WQ_MEM_RECLAIM |
-				       WQ_UNBOUND, 0);
-	if (!io_workqueue) {
+	dn->io_workqueue = alloc_workqueue("dlm_io", WQ_HIGHPRI |
+					   WQ_MEM_RECLAIM | WQ_UNBOUND, 0);
+	if (!dn->io_workqueue) {
 		log_print("can't start dlm_io");
 		return -ENOMEM;
 	}
 
-	process_workqueue = alloc_workqueue("dlm_process", WQ_HIGHPRI | WQ_BH, 0);
-	if (!process_workqueue) {
+	dn->process_workqueue = alloc_workqueue("dlm_process",
+						WQ_HIGHPRI | WQ_BH, 0);
+	if (!dn->process_workqueue) {
 		log_print("can't start dlm_process");
-		destroy_workqueue(io_workqueue);
-		io_workqueue = NULL;
+		destroy_workqueue(dn->io_workqueue);
+		dn->io_workqueue = NULL;
 		return -ENOMEM;
 	}
 
 	return 0;
 }
 
-void dlm_lowcomms_shutdown(void)
+void dlm_lowcomms_shutdown(struct dlm_net *dn)
 {
 	struct connection *con;
 	int i, idx;
 
 	/* stop lowcomms_listen_data_ready calls */
-	lock_sock(listen_con.sock->sk);
-	listen_con.sock->sk->sk_data_ready = listen_sock.sk_data_ready;
-	release_sock(listen_con.sock->sk);
+	lock_sock(dn->listen_con.sock->sk);
+	dn->listen_con.sock->sk->sk_data_ready = dn->listen_sock.sk_data_ready;
+	release_sock(dn->listen_con.sock->sk);
 
-	cancel_work_sync(&listen_con.rwork);
-	dlm_close_sock(&listen_con.sock);
+	cancel_work_sync(&dn->listen_con.rwork);
+	dlm_close_sock(&dn->listen_con.sock);
 
-	idx = srcu_read_lock(&connections_srcu);
+	idx = srcu_read_lock(&dn->connections_srcu);
 	for (i = 0; i < CONN_HASH_SIZE; i++) {
-		hlist_for_each_entry_rcu(con, &connection_hash[i], list) {
+		hlist_for_each_entry_rcu(con, &dn->connection_hash[i], list) {
 			shutdown_connection(con, true);
 			stop_connection_io(con);
-			flush_workqueue(process_workqueue);
+			flush_workqueue(dn->process_workqueue);
 			close_connection(con, true);
 
 			clean_one_writequeue(con);
@@ -1739,48 +1722,51 @@ void dlm_lowcomms_shutdown(void)
 			allow_connection_io(con);
 		}
 	}
-	srcu_read_unlock(&connections_srcu, idx);
+	srcu_read_unlock(&dn->connections_srcu, idx);
 }
 
-void dlm_lowcomms_stop(void)
+void dlm_lowcomms_stop(struct dlm_net *dn)
 {
-	work_stop();
-	dlm_proto_ops = NULL;
+	work_stop(dn);
+	dn->dlm_proto_ops = NULL;
 }
 
-static int dlm_listen_for_all(void)
+static int dlm_listen_for_all(struct dlm_net *dn)
 {
 	struct socket *sock;
 	int result;
 
 	log_print("Using %s for communications",
-		  dlm_proto_ops->name);
+		  dn->dlm_proto_ops->name);
 
-	result = dlm_proto_ops->listen_validate();
+	result = dn->dlm_proto_ops->listen_validate(dn);
 	if (result < 0)
 		return result;
 
-	result = sock_create_kern(&init_net, dlm_local_addr[0].ss_family,
-				  SOCK_STREAM, dlm_proto_ops->proto, &sock);
+	result = sock_create_kern(read_pnet(&dn->net), dn->dlm_local_addr[0].ss_family,
+				  SOCK_STREAM, dn->dlm_proto_ops->proto,
+				  &sock);
 	if (result < 0) {
 		log_print("Can't create comms socket: %d", result);
 		return result;
 	}
 
-	sock_set_mark(sock->sk, dlm_config.ci_mark);
-	dlm_proto_ops->listen_sockopts(sock);
+	sock_set_mark(sock->sk, dn->config.ci_mark);
+	dn->dlm_proto_ops->listen_sockopts(sock);
 
-	result = dlm_proto_ops->listen_bind(sock);
+	result = dn->dlm_proto_ops->listen_bind(dn, sock);
 	if (result < 0)
 		goto out;
 
 	lock_sock(sock->sk);
-	listen_sock.sk_data_ready = sock->sk->sk_data_ready;
-	listen_sock.sk_write_space = sock->sk->sk_write_space;
-	listen_sock.sk_error_report = sock->sk->sk_error_report;
-	listen_sock.sk_state_change = sock->sk->sk_state_change;
+	dn->listen_sock.sk_data_ready = sock->sk->sk_data_ready;
+	dn->listen_sock.sk_write_space = sock->sk->sk_write_space;
+	dn->listen_sock.sk_error_report = sock->sk->sk_error_report;
+	dn->listen_sock.sk_state_change = sock->sk->sk_state_change;
 
-	listen_con.sock = sock;
+	mutex_lock(&dn->cfg_lock);
+	dn->listen_con.sock = sock;
+	mutex_unlock(&dn->cfg_lock);
 
 	sock->sk->sk_allocation = GFP_NOFS;
 	sock->sk->sk_use_task_frag = false;
@@ -1789,7 +1775,7 @@ static int dlm_listen_for_all(void)
 
 	result = sock->ops->listen(sock, 128);
 	if (result < 0) {
-		dlm_close_sock(&listen_con.sock);
+		dlm_close_sock(&dn->listen_con.sock);
 		return result;
 	}
 
@@ -1800,7 +1786,7 @@ static int dlm_listen_for_all(void)
 	return result;
 }
 
-static int dlm_tcp_bind(struct socket *sock)
+static int dlm_tcp_bind(struct dlm_net *dn, struct socket *sock)
 {
 	struct sockaddr_storage src_addr;
 	int result, addr_len;
@@ -1808,8 +1794,8 @@ static int dlm_tcp_bind(struct socket *sock)
 	/* Bind to our cluster-known address connecting to avoid
 	 * routing problems.
 	 */
-	memcpy(&src_addr, &dlm_local_addr[0], sizeof(src_addr));
-	make_sockaddr(&src_addr, 0, &addr_len);
+	memcpy(&src_addr, &dn->dlm_local_addr[0], sizeof(src_addr));
+	make_sockaddr(dn, &src_addr, 0, &addr_len);
 
 	result = kernel_bind(sock, (struct sockaddr *)&src_addr,
 			     addr_len);
@@ -1821,10 +1807,10 @@ static int dlm_tcp_bind(struct socket *sock)
 	return 0;
 }
 
-static int dlm_tcp_listen_validate(void)
+static int dlm_tcp_listen_validate(const struct dlm_net *dn)
 {
 	/* We don't support multi-homed hosts */
-	if (dlm_local_count > 1) {
+	if (dn->dlm_local_count > 1) {
 		log_print("TCP protocol can't handle multi-homed hosts, try SCTP");
 		return -EINVAL;
 	}
@@ -1844,13 +1830,14 @@ static void dlm_tcp_listen_sockopts(struct socket *sock)
 	sock_set_reuseaddr(sock->sk);
 }
 
-static int dlm_tcp_listen_bind(struct socket *sock)
+static int dlm_tcp_listen_bind(struct dlm_net *dn, struct socket *sock)
 {
 	int addr_len;
 
 	/* Bind to our port */
-	make_sockaddr(&dlm_local_addr[0], dlm_config.ci_tcp_port, &addr_len);
-	return kernel_bind(sock, (struct sockaddr *)&dlm_local_addr[0],
+	make_sockaddr(dn, &dn->dlm_local_addr[0], dn->config.ci_tcp_port,
+		      &addr_len);
+	return kernel_bind(sock, (struct sockaddr *)&dn->dlm_local_addr[0],
 			   addr_len);
 }
 
@@ -1864,12 +1851,12 @@ static const struct dlm_proto_ops dlm_tcp_ops = {
 	.listen_bind = dlm_tcp_listen_bind,
 };
 
-static int dlm_sctp_bind(struct socket *sock)
+static int dlm_sctp_bind(struct dlm_net *dn, struct socket *sock)
 {
-	return sctp_bind_addrs(sock, 0);
+	return sctp_bind_addrs(dn, sock, 0);
 }
 
-static int dlm_sctp_listen_validate(void)
+static int dlm_sctp_listen_validate(const struct dlm_net *dn)
 {
 	if (!IS_ENABLED(CONFIG_IP_SCTP)) {
 		log_print("SCTP is not enabled by this kernel");
@@ -1880,9 +1867,9 @@ static int dlm_sctp_listen_validate(void)
 	return 0;
 }
 
-static int dlm_sctp_bind_listen(struct socket *sock)
+static int dlm_sctp_bind_listen(struct dlm_net *dn, struct socket *sock)
 {
-	return sctp_bind_addrs(sock, dlm_config.ci_tcp_port);
+	return sctp_bind_addrs(dn, sock, dn->config.ci_tcp_port);
 }
 
 static void dlm_sctp_sockopts(struct socket *sock)
@@ -1903,77 +1890,87 @@ static const struct dlm_proto_ops dlm_sctp_ops = {
 	.listen_bind = dlm_sctp_bind_listen,
 };
 
-int dlm_lowcomms_start(void)
+int dlm_lowcomms_start(struct dlm_net *dn)
 {
 	int error;
 
-	init_local();
-	if (!dlm_local_count) {
+	init_local(dn);
+	if (!dn->dlm_local_count) {
 		error = -ENOTCONN;
 		log_print("no local IP address has been set");
 		goto fail;
 	}
 
-	error = work_start();
+	error = work_start(dn);
 	if (error)
 		goto fail;
 
 	/* Start listening */
-	switch (dlm_config.ci_protocol) {
+	switch (dn->config.ci_protocol) {
 	case DLM_PROTO_TCP:
-		dlm_proto_ops = &dlm_tcp_ops;
+		dn->dlm_proto_ops = &dlm_tcp_ops;
 		break;
 	case DLM_PROTO_SCTP:
-		dlm_proto_ops = &dlm_sctp_ops;
+		dn->dlm_proto_ops = &dlm_sctp_ops;
 		break;
 	default:
 		log_print("Invalid protocol identifier %d set",
-			  dlm_config.ci_protocol);
+			  dn->config.ci_protocol);
 		error = -EINVAL;
 		goto fail_proto_ops;
 	}
 
-	error = dlm_listen_for_all();
+	error = dlm_listen_for_all(dn);
 	if (error)
 		goto fail_listen;
 
 	return 0;
 
 fail_listen:
-	dlm_proto_ops = NULL;
+	dn->dlm_proto_ops = NULL;
 fail_proto_ops:
-	work_stop();
+	work_stop(dn);
 fail:
 	return error;
 }
 
-void dlm_lowcomms_init(void)
+void __net_init dlm_lowcomms_init(struct dlm_net *dn)
 {
 	int i;
 
+	init_srcu_struct(&dn->connections_srcu);
+	spin_lock_init(&dn->connections_lock);
+
 	for (i = 0; i < CONN_HASH_SIZE; i++)
-		INIT_HLIST_HEAD(&connection_hash[i]);
+		INIT_HLIST_HEAD(&dn->connection_hash[i]);
 
-	INIT_WORK(&listen_con.rwork, process_listen_recv_socket);
+	INIT_WORK(&dn->listen_con.rwork, process_listen_recv_socket);
+	INIT_WORK(&dn->process_work, process_dlm_messages);
+	spin_lock_init(&dn->processqueue_lock);
+	init_waitqueue_head(&dn->processqueue_wq);
+	INIT_LIST_HEAD(&dn->processqueue);
 }
 
-void dlm_lowcomms_exit(void)
+void __net_exit dlm_lowcomms_exit(struct dlm_net *dn)
 {
 	struct connection *con;
 	int i, idx;
 
-	idx = srcu_read_lock(&connections_srcu);
+	idx = srcu_read_lock(&dn->connections_srcu);
 	for (i = 0; i < CONN_HASH_SIZE; i++) {
-		hlist_for_each_entry_rcu(con, &connection_hash[i], list) {
-			spin_lock(&connections_lock);
+		hlist_for_each_entry_rcu(con, &dn->connection_hash[i], list) {
+			spin_lock(&dn->connections_lock);
 			hlist_del_rcu(&con->list);
-			spin_unlock(&connections_lock);
+			spin_unlock(&dn->connections_lock);
 
 			if (con->othercon)
-				call_srcu(&connections_srcu, &con->othercon->rcu,
+				call_srcu(&dn->connections_srcu, &con->othercon->rcu,
 					  connection_release);
-			call_srcu(&connections_srcu, &con->rcu, connection_release);
+			call_srcu(&dn->connections_srcu, &con->rcu, connection_release);
 		}
 	}
-	srcu_read_unlock(&connections_srcu, idx);
+	srcu_read_unlock(&dn->connections_srcu, idx);
+
+	srcu_barrier(&dn->connections_srcu);
+	cleanup_srcu_struct(&dn->connections_srcu);
 }
diff --git a/fs/dlm/lowcomms.h b/fs/dlm/lowcomms.h
index fd0df604eb93..f19c061c9dde 100644
--- a/fs/dlm/lowcomms.h
+++ b/fs/dlm/lowcomms.h
@@ -18,8 +18,6 @@
 #define DLM_MAX_APP_BUFSIZE		(DLM_MAX_SOCKET_BUFSIZE - \
 					 DLM_MIDCOMMS_OPT_LEN)
 
-#define CONN_HASH_SIZE 32
-
 /* This is deliberately very simple because most clusters have simple
  * sequential nodeids, so we should be able to go straight to a connection
  * struct in the array
@@ -30,23 +28,26 @@ static inline int nodeid_hash(int nodeid)
 }
 
 /* check if dlm is running */
-bool dlm_lowcomms_is_running(void);
+bool dlm_lowcomms_is_running(const struct dlm_net *dn);
 
-int dlm_lowcomms_start(void);
-void dlm_lowcomms_shutdown(void);
+int dlm_lowcomms_start(struct dlm_net *dn);
+void dlm_lowcomms_shutdown(struct dlm_net *dn);
 void dlm_lowcomms_shutdown_node(int nodeid, bool force);
-void dlm_lowcomms_stop(void);
-void dlm_lowcomms_init(void);
-void dlm_lowcomms_exit(void);
-int dlm_lowcomms_close(int nodeid);
-struct dlm_msg *dlm_lowcomms_new_msg(int nodeid, int len, char **ppc,
-				     void (*cb)(void *data), void *data);
+void dlm_lowcomms_stop(struct dlm_net *dn);
+void dlm_lowcomms_init(struct dlm_net *dn);
+void dlm_lowcomms_exit(struct dlm_net *dn);
+int dlm_lowcomms_close(struct dlm_net *dn, int nodeid);
+struct dlm_msg *dlm_lowcomms_new_msg(struct dlm_net *dn, int nodeid, int len,
+				     char **ppc, void (*cb)(void *data),
+				     void *data);
 void dlm_lowcomms_commit_msg(struct dlm_msg *msg);
 void dlm_lowcomms_put_msg(struct dlm_msg *msg);
 int dlm_lowcomms_resend_msg(struct dlm_msg *msg);
-int dlm_lowcomms_connect_node(int nodeid);
-int dlm_lowcomms_nodes_set_mark(int nodeid, unsigned int mark);
-int dlm_lowcomms_addr(int nodeid, struct sockaddr_storage *addr);
+int dlm_lowcomms_connect_node(struct dlm_net *dn, int nodeid);
+int dlm_lowcomms_nodes_set_mark(struct dlm_net *dn, int nodeid,
+				unsigned int mark);
+int dlm_lowcomms_addr(struct dlm_net *dn, int nodeid,
+		      struct sockaddr_storage *addr);
 void dlm_midcomms_receive_done(int nodeid);
 struct kmem_cache *dlm_lowcomms_writequeue_cache_create(void);
 struct kmem_cache *dlm_lowcomms_msg_cache_create(void);
diff --git a/fs/dlm/main.c b/fs/dlm/main.c
index 4887c8a05318..01ba63ab3822 100644
--- a/fs/dlm/main.c
+++ b/fs/dlm/main.c
@@ -17,7 +17,6 @@
 #include "user.h"
 #include "memory.h"
 #include "config.h"
-#include "midcomms.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/dlm.h>
@@ -32,8 +31,6 @@ static int __init init_dlm(void)
 	if (error)
 		goto out;
 
-	dlm_midcomms_init();
-
 	error = dlm_lockspace_init();
 	if (error)
 		goto out_mem;
@@ -72,7 +69,6 @@ static int __init init_dlm(void)
  out_lockspace:
 	dlm_lockspace_exit();
  out_mem:
-	dlm_midcomms_exit();
 	dlm_memory_exit();
  out:
 	return error;
@@ -86,7 +82,6 @@ static void __exit exit_dlm(void)
 	dlm_user_exit();
 	dlm_config_exit();
 	dlm_lockspace_exit();
-	dlm_midcomms_exit();
 	dlm_unregister_debugfs();
 	dlm_memory_exit();
 }
diff --git a/fs/dlm/member.c b/fs/dlm/member.c
index c9661906568a..ed5f4139d712 100644
--- a/fs/dlm/member.c
+++ b/fs/dlm/member.c
@@ -100,7 +100,7 @@ int dlm_slots_copy_in(struct dlm_ls *ls)
 	struct dlm_rcom *rc = ls->ls_recover_buf;
 	struct rcom_config *rf = (struct rcom_config *)rc->rc_buf;
 	struct rcom_slot *ro0, *ro;
-	int our_nodeid = dlm_our_nodeid();
+	int our_nodeid = dlm_our_nodeid(ls->ls_dn);
 	int i, num_slots;
 	uint32_t gen;
 
@@ -162,7 +162,7 @@ int dlm_slots_assign(struct dlm_ls *ls, int *num_slots, int *slots_size,
 {
 	struct dlm_member *memb;
 	struct dlm_slot *array;
-	int our_nodeid = dlm_our_nodeid();
+	int our_nodeid = dlm_our_nodeid(ls->ls_dn);
 	int array_size, max_slots, i;
 	int need = 0;
 	int max = 0;
@@ -307,18 +307,18 @@ static void add_ordered_member(struct dlm_ls *ls, struct dlm_member *new)
 	}
 }
 
-static int add_remote_member(int nodeid)
+static int add_remote_member(struct dlm_net *dn, int nodeid)
 {
 	int error;
 
-	if (nodeid == dlm_our_nodeid())
+	if (nodeid == dlm_our_nodeid(dn))
 		return 0;
 
-	error = dlm_lowcomms_connect_node(nodeid);
+	error = dlm_lowcomms_connect_node(dn, nodeid);
 	if (error < 0)
 		return error;
 
-	dlm_midcomms_add_member(nodeid);
+	dlm_midcomms_add_member(dn, nodeid);
 	return 0;
 }
 
@@ -335,7 +335,7 @@ static int dlm_add_member(struct dlm_ls *ls, struct dlm_config_node *node)
 	memb->weight = node->weight;
 	memb->comm_seq = node->comm_seq;
 
-	error = add_remote_member(node->nodeid);
+	error = add_remote_member(ls->ls_dn, node->nodeid);
 	if (error < 0) {
 		kfree(memb);
 		return error;
@@ -373,8 +373,8 @@ int dlm_is_removed(struct dlm_ls *ls, int nodeid)
 	return 0;
 }
 
-static void clear_memb_list(struct list_head *head,
-			    void (*after_del)(int nodeid))
+static void clear_memb_list(struct dlm_net *dn, struct list_head *head,
+			    void (*after_del)(struct dlm_net *dn, int nodeid))
 {
 	struct dlm_member *memb;
 
@@ -382,28 +382,28 @@ static void clear_memb_list(struct list_head *head,
 		memb = list_entry(head->next, struct dlm_member, list);
 		list_del(&memb->list);
 		if (after_del)
-			after_del(memb->nodeid);
+			after_del(dn, memb->nodeid);
 		kfree(memb);
 	}
 }
 
-static void remove_remote_member(int nodeid)
+static void remove_remote_member(struct dlm_net *dn, int nodeid)
 {
-	if (nodeid == dlm_our_nodeid())
+	if (nodeid == dlm_our_nodeid(dn))
 		return;
 
-	dlm_midcomms_remove_member(nodeid);
+	dlm_midcomms_remove_member(dn, nodeid);
 }
 
 void dlm_clear_members(struct dlm_ls *ls)
 {
-	clear_memb_list(&ls->ls_nodes, remove_remote_member);
+	clear_memb_list(ls->ls_dn, &ls->ls_nodes, remove_remote_member);
 	ls->ls_num_nodes = 0;
 }
 
 void dlm_clear_members_gone(struct dlm_ls *ls)
 {
-	clear_memb_list(&ls->ls_nodes_gone, NULL);
+	clear_memb_list(ls->ls_dn, &ls->ls_nodes_gone, NULL);
 }
 
 static void make_member_array(struct dlm_ls *ls)
@@ -493,7 +493,7 @@ static void dlm_lsop_recover_slot(struct dlm_ls *ls, struct dlm_member *memb)
 	   we consider the node to have failed (versus
 	   being removed due to dlm_release_lockspace) */
 
-	error = dlm_comm_seq(memb->nodeid, &seq);
+	error = dlm_comm_seq(ls->ls_dn, memb->nodeid, &seq);
 
 	if (!error && seq == memb->comm_seq)
 		return;
@@ -582,7 +582,7 @@ int dlm_recover_members(struct dlm_ls *ls, struct dlm_recover *rv, int *neg_out)
 
 		neg++;
 		list_move(&memb->list, &ls->ls_nodes_gone);
-		remove_remote_member(memb->nodeid);
+		remove_remote_member(ls->ls_dn, memb->nodeid);
 		ls->ls_num_nodes--;
 		dlm_lsop_recover_slot(ls, memb);
 	}
@@ -719,7 +719,7 @@ int dlm_ls_start(struct dlm_ls *ls)
 	if (!rv)
 		return -ENOMEM;
 
-	error = dlm_config_nodes(ls->ls_name, &nodes, &count);
+	error = dlm_config_nodes(ls->ls_dn, ls->ls_name, &nodes, &count);
 	if (error < 0)
 		goto fail_rv;
 
diff --git a/fs/dlm/midcomms.c b/fs/dlm/midcomms.c
index 2c101bbe261a..6b36909bc0f5 100644
--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -153,6 +153,7 @@
 
 struct midcomms_node {
 	int nodeid;
+	struct dlm_net *dn;
 	uint32_t version;
 	atomic_t seq_send;
 	atomic_t seq_next;
@@ -212,18 +213,6 @@ struct dlm_mhandle {
 	struct rcu_head rcu;
 };
 
-static struct hlist_head node_hash[CONN_HASH_SIZE];
-static DEFINE_SPINLOCK(nodes_lock);
-DEFINE_STATIC_SRCU(nodes_srcu);
-
-/* This mutex prevents that midcomms_close() is running while
- * stop() or remove(). As I experienced invalid memory access
- * behaviours when DLM_DEBUG_FENCE_TERMINATION is enabled and
- * resetting machines. I will end in some double deletion in nodes
- * datastructure.
- */
-static DEFINE_MUTEX(close_lock);
-
 struct kmem_cache *dlm_midcomms_cache_create(void)
 {
 	return KMEM_CACHE(dlm_mhandle, 0);
@@ -271,11 +260,11 @@ uint32_t dlm_midcomms_version(struct midcomms_node *node)
 	return node->version;
 }
 
-static struct midcomms_node *__find_node(int nodeid, int r)
+static struct midcomms_node *__find_node(struct dlm_net *dn, int nodeid, int r)
 {
 	struct midcomms_node *node;
 
-	hlist_for_each_entry_rcu(node, &node_hash[r], hlist) {
+	hlist_for_each_entry_rcu(node, &dn->node_hash[r], hlist) {
 		if (node->nodeid == nodeid)
 			return node;
 	}
@@ -329,32 +318,34 @@ static void midcomms_node_reset(struct midcomms_node *node)
 	wake_up(&node->shutdown_wait);
 }
 
-static struct midcomms_node *nodeid2node(int nodeid)
+static struct midcomms_node *nodeid2node(struct dlm_net *dn, int nodeid)
 {
-	return __find_node(nodeid, nodeid_hash(nodeid));
+	return __find_node(dn, nodeid, nodeid_hash(nodeid));
 }
 
-int dlm_midcomms_addr(int nodeid, struct sockaddr_storage *addr)
+int dlm_midcomms_addr(struct dlm_net *dn, int nodeid,
+		      struct sockaddr_storage *addr)
 {
 	int ret, idx, r = nodeid_hash(nodeid);
 	struct midcomms_node *node;
 
-	ret = dlm_lowcomms_addr(nodeid, addr);
+	ret = dlm_lowcomms_addr(dn, nodeid, addr);
 	if (ret)
 		return ret;
 
-	idx = srcu_read_lock(&nodes_srcu);
-	node = __find_node(nodeid, r);
+	idx = srcu_read_lock(&dn->nodes_srcu);
+	node = __find_node(dn, nodeid, r);
 	if (node) {
-		srcu_read_unlock(&nodes_srcu, idx);
+		srcu_read_unlock(&dn->nodes_srcu, idx);
 		return 0;
 	}
-	srcu_read_unlock(&nodes_srcu, idx);
+	srcu_read_unlock(&dn->nodes_srcu, idx);
 
 	node = kmalloc(sizeof(*node), GFP_NOFS);
 	if (!node)
 		return -ENOMEM;
 
+	node->dn = dn;
 	node->nodeid = nodeid;
 	spin_lock_init(&node->state_lock);
 	spin_lock_init(&node->send_queue_lock);
@@ -364,29 +355,29 @@ int dlm_midcomms_addr(int nodeid, struct sockaddr_storage *addr)
 	node->users = 0;
 	midcomms_node_reset(node);
 
-	spin_lock_bh(&nodes_lock);
-	hlist_add_head_rcu(&node->hlist, &node_hash[r]);
-	spin_unlock_bh(&nodes_lock);
+	spin_lock_bh(&dn->nodes_lock);
+	hlist_add_head_rcu(&node->hlist, &dn->node_hash[r]);
+	spin_unlock_bh(&dn->nodes_lock);
 
-	node->debugfs = dlm_create_debug_comms_file(nodeid, node);
+	node->debugfs = dlm_create_debug_comms_file(dn, nodeid, node);
 	return 0;
 }
 
-static int dlm_send_ack(int nodeid, uint32_t seq)
+static int dlm_send_ack(struct dlm_net *dn, int nodeid, uint32_t seq)
 {
 	int mb_len = sizeof(struct dlm_header);
 	struct dlm_header *m_header;
 	struct dlm_msg *msg;
 	char *ppc;
 
-	msg = dlm_lowcomms_new_msg(nodeid, mb_len, &ppc, NULL, NULL);
+	msg = dlm_lowcomms_new_msg(dn, nodeid, mb_len, &ppc, NULL, NULL);
 	if (!msg)
 		return -ENOMEM;
 
 	m_header = (struct dlm_header *)ppc;
 
 	m_header->h_version = cpu_to_le32(DLM_HEADER_MAJOR | DLM_HEADER_MINOR);
-	m_header->h_nodeid = cpu_to_le32(dlm_our_nodeid());
+	m_header->h_nodeid = cpu_to_le32(dlm_our_nodeid(dn));
 	m_header->h_length = cpu_to_le16(mb_len);
 	m_header->h_cmd = DLM_ACK;
 	m_header->u.h_seq = cpu_to_le32(seq);
@@ -416,7 +407,8 @@ static void dlm_send_ack_threshold(struct midcomms_node *node,
 	} while (atomic_cmpxchg(&node->ulp_delivered, oval, nval) != oval);
 
 	if (send_ack)
-		dlm_send_ack(node->nodeid, atomic_read(&node->seq_next));
+		dlm_send_ack(node->dn, node->nodeid,
+			     atomic_read(&node->seq_next));
 }
 
 static int dlm_send_fin(struct midcomms_node *node,
@@ -427,7 +419,7 @@ static int dlm_send_fin(struct midcomms_node *node,
 	struct dlm_mhandle *mh;
 	char *ppc;
 
-	mh = dlm_midcomms_get_mhandle(node->nodeid, mb_len, &ppc);
+	mh = dlm_midcomms_get_mhandle(node->dn, node->nodeid, mb_len, &ppc);
 	if (!mh)
 		return -ENOMEM;
 
@@ -437,7 +429,7 @@ static int dlm_send_fin(struct midcomms_node *node,
 	m_header = (struct dlm_header *)ppc;
 
 	m_header->h_version = cpu_to_le32(DLM_HEADER_MAJOR | DLM_HEADER_MINOR);
-	m_header->h_nodeid = cpu_to_le32(dlm_our_nodeid());
+	m_header->h_nodeid = cpu_to_le32(dlm_our_nodeid(node->dn));
 	m_header->h_length = cpu_to_le16(mb_len);
 	m_header->h_cmd = DLM_FIN;
 
@@ -500,15 +492,15 @@ static void dlm_pas_fin_ack_rcv(struct midcomms_node *node)
 	spin_unlock_bh(&node->state_lock);
 }
 
-static void dlm_receive_buffer_3_2_trace(uint32_t seq,
+static void dlm_receive_buffer_3_2_trace(struct dlm_net *dn, uint32_t seq,
 					 const union dlm_packet *p)
 {
 	switch (p->header.h_cmd) {
 	case DLM_MSG:
-		trace_dlm_recv_message(dlm_our_nodeid(), seq, &p->message);
+		trace_dlm_recv_message(dlm_our_nodeid(dn), seq, &p->message);
 		break;
 	case DLM_RCOM:
-		trace_dlm_recv_rcom(dlm_our_nodeid(), seq, &p->rcom);
+		trace_dlm_recv_rcom(dlm_our_nodeid(dn), seq, &p->rcom);
 		break;
 	default:
 		break;
@@ -540,7 +532,7 @@ static void dlm_midcomms_receive_buffer(const union dlm_packet *p,
 
 			switch (node->state) {
 			case DLM_ESTABLISHED:
-				dlm_send_ack(node->nodeid, nval);
+				dlm_send_ack(node->dn, node->nodeid, nval);
 
 				/* passive shutdown DLM_LAST_ACK case 1
 				 * additional we check if the node is used by
@@ -559,14 +551,14 @@ static void dlm_midcomms_receive_buffer(const union dlm_packet *p,
 				}
 				break;
 			case DLM_FIN_WAIT1:
-				dlm_send_ack(node->nodeid, nval);
+				dlm_send_ack(node->dn, node->nodeid, nval);
 				node->state = DLM_CLOSING;
 				set_bit(DLM_NODE_FLAG_STOP_RX, &node->flags);
 				pr_debug("switch node %d to state %s\n",
 					 node->nodeid, dlm_state_str(node->state));
 				break;
 			case DLM_FIN_WAIT2:
-				dlm_send_ack(node->nodeid, nval);
+				dlm_send_ack(node->dn, node->nodeid, nval);
 				midcomms_node_reset(node);
 				pr_debug("switch node %d to state %s\n",
 					 node->nodeid, dlm_state_str(node->state));
@@ -585,8 +577,8 @@ static void dlm_midcomms_receive_buffer(const union dlm_packet *p,
 			break;
 		default:
 			WARN_ON_ONCE(test_bit(DLM_NODE_FLAG_STOP_RX, &node->flags));
-			dlm_receive_buffer_3_2_trace(seq, p);
-			dlm_receive_buffer(p, node->nodeid);
+			dlm_receive_buffer_3_2_trace(node->dn, seq, p);
+			dlm_receive_buffer(node->dn, p, node->nodeid);
 			atomic_inc(&node->ulp_delivered);
 			/* unlikely case to send ack back when we don't transmit */
 			dlm_send_ack_threshold(node, DLM_RECV_ACK_BACK_MSG_THRESHOLD);
@@ -597,7 +589,7 @@ static void dlm_midcomms_receive_buffer(const union dlm_packet *p,
 		 * current node->seq_next number as ack.
 		 */
 		if (seq < oval)
-			dlm_send_ack(node->nodeid, oval);
+			dlm_send_ack(node->dn, node->nodeid, oval);
 
 		log_print_ratelimited("ignore dlm msg because seq mismatch, seq: %u, expected: %u, nodeid: %d",
 				      seq, oval, node->nodeid);
@@ -654,15 +646,16 @@ static int dlm_opts_check_msglen(const union dlm_packet *p, uint16_t msglen,
 	return 0;
 }
 
-static void dlm_midcomms_receive_buffer_3_2(const union dlm_packet *p, int nodeid)
+static void dlm_midcomms_receive_buffer_3_2(struct dlm_net *dn,
+					    const union dlm_packet *p, int nodeid)
 {
 	uint16_t msglen = le16_to_cpu(p->header.h_length);
 	struct midcomms_node *node;
 	uint32_t seq;
 	int ret, idx;
 
-	idx = srcu_read_lock(&nodes_srcu);
-	node = nodeid2node(nodeid);
+	idx = srcu_read_lock(&dn->nodes_srcu);
+	node = nodeid2node(dn, nodeid);
 	if (WARN_ON_ONCE(!node))
 		goto out;
 
@@ -718,7 +711,7 @@ static void dlm_midcomms_receive_buffer_3_2(const union dlm_packet *p, int nodei
 		}
 
 		WARN_ON_ONCE(test_bit(DLM_NODE_FLAG_STOP_RX, &node->flags));
-		dlm_receive_buffer(p, nodeid);
+		dlm_receive_buffer(node->dn, p, nodeid);
 		break;
 	case DLM_OPTS:
 		seq = le32_to_cpu(p->header.u.h_seq);
@@ -779,19 +772,20 @@ static void dlm_midcomms_receive_buffer_3_2(const union dlm_packet *p, int nodei
 	}
 
 out:
-	srcu_read_unlock(&nodes_srcu, idx);
+	srcu_read_unlock(&dn->nodes_srcu, idx);
 }
 
-static void dlm_midcomms_receive_buffer_3_1(const union dlm_packet *p, int nodeid)
+static void dlm_midcomms_receive_buffer_3_1(struct dlm_net *dn, const union dlm_packet *p,
+					    int nodeid)
 {
 	uint16_t msglen = le16_to_cpu(p->header.h_length);
 	struct midcomms_node *node;
 	int idx;
 
-	idx = srcu_read_lock(&nodes_srcu);
-	node = nodeid2node(nodeid);
+	idx = srcu_read_lock(&dn->nodes_srcu);
+	node = nodeid2node(dn, nodeid);
 	if (WARN_ON_ONCE(!node)) {
-		srcu_read_unlock(&nodes_srcu, idx);
+		srcu_read_unlock(&dn->nodes_srcu, idx);
 		return;
 	}
 
@@ -807,10 +801,10 @@ static void dlm_midcomms_receive_buffer_3_1(const union dlm_packet *p, int nodei
 	default:
 		log_print_ratelimited("version mismatch detected, assumed 0x%08x but node %d has 0x%08x",
 				      DLM_VERSION_3_1, node->nodeid, node->version);
-		srcu_read_unlock(&nodes_srcu, idx);
+		srcu_read_unlock(&dn->nodes_srcu, idx);
 		return;
 	}
-	srcu_read_unlock(&nodes_srcu, idx);
+	srcu_read_unlock(&dn->nodes_srcu, idx);
 
 	switch (p->header.h_cmd) {
 	case DLM_RCOM:
@@ -830,7 +824,7 @@ static void dlm_midcomms_receive_buffer_3_1(const union dlm_packet *p, int nodei
 		return;
 	}
 
-	dlm_receive_buffer(p, nodeid);
+	dlm_receive_buffer(dn, p, nodeid);
 }
 
 int dlm_validate_incoming_buffer(int nodeid, unsigned char *buf, int len)
@@ -880,7 +874,8 @@ int dlm_validate_incoming_buffer(int nodeid, unsigned char *buf, int len)
  * Called from the low-level comms layer to process a buffer of
  * commands.
  */
-int dlm_process_incoming_buffer(int nodeid, unsigned char *buf, int len)
+int dlm_process_incoming_buffer(struct dlm_net *dn, int nodeid,
+				unsigned char *buf, int len)
 {
 	const unsigned char *ptr = buf;
 	const struct dlm_header *hd;
@@ -896,10 +891,10 @@ int dlm_process_incoming_buffer(int nodeid, unsigned char *buf, int len)
 
 		switch (hd->h_version) {
 		case cpu_to_le32(DLM_VERSION_3_1):
-			dlm_midcomms_receive_buffer_3_1((const union dlm_packet *)ptr, nodeid);
+			dlm_midcomms_receive_buffer_3_1(dn, (const union dlm_packet *)ptr, nodeid);
 			break;
 		case cpu_to_le32(DLM_VERSION_3_2):
-			dlm_midcomms_receive_buffer_3_2((const union dlm_packet *)ptr, nodeid);
+			dlm_midcomms_receive_buffer_3_2(dn, (const union dlm_packet *)ptr, nodeid);
 			break;
 		default:
 			log_print("received invalid version header: %u from node %d, will skip this message",
@@ -915,16 +910,16 @@ int dlm_process_incoming_buffer(int nodeid, unsigned char *buf, int len)
 	return ret;
 }
 
-void dlm_midcomms_unack_msg_resend(int nodeid)
+void dlm_midcomms_unack_msg_resend(struct dlm_net *dn, int nodeid)
 {
 	struct midcomms_node *node;
 	struct dlm_mhandle *mh;
 	int idx, ret;
 
-	idx = srcu_read_lock(&nodes_srcu);
-	node = nodeid2node(nodeid);
+	idx = srcu_read_lock(&dn->nodes_srcu);
+	node = nodeid2node(dn, nodeid);
 	if (WARN_ON_ONCE(!node)) {
-		srcu_read_unlock(&nodes_srcu, idx);
+		srcu_read_unlock(&dn->nodes_srcu, idx);
 		return;
 	}
 
@@ -933,7 +928,7 @@ void dlm_midcomms_unack_msg_resend(int nodeid)
 	case DLM_VERSION_3_2:
 		break;
 	default:
-		srcu_read_unlock(&nodes_srcu, idx);
+		srcu_read_unlock(&dn->nodes_srcu, idx);
 		return;
 	}
 
@@ -948,15 +943,15 @@ void dlm_midcomms_unack_msg_resend(int nodeid)
 					      mh->seq, node->nodeid);
 	}
 	rcu_read_unlock();
-	srcu_read_unlock(&nodes_srcu, idx);
+	srcu_read_unlock(&dn->nodes_srcu, idx);
 }
 
-static void dlm_fill_opts_header(struct dlm_opts *opts, uint16_t inner_len,
-				 uint32_t seq)
+static void dlm_fill_opts_header(struct dlm_net *dn, struct dlm_opts *opts,
+				 uint16_t inner_len, uint32_t seq)
 {
 	opts->o_header.h_cmd = DLM_OPTS;
 	opts->o_header.h_version = cpu_to_le32(DLM_HEADER_MAJOR | DLM_HEADER_MINOR);
-	opts->o_header.h_nodeid = cpu_to_le32(dlm_our_nodeid());
+	opts->o_header.h_nodeid = cpu_to_le32(dlm_our_nodeid(dn));
 	opts->o_header.h_length = cpu_to_le16(DLM_MIDCOMMS_OPT_LEN + inner_len);
 	opts->o_header.u.h_seq = cpu_to_le32(seq);
 }
@@ -980,7 +975,8 @@ static struct dlm_msg *dlm_midcomms_get_msg_3_2(struct dlm_mhandle *mh, int node
 	struct dlm_opts *opts;
 	struct dlm_msg *msg;
 
-	msg = dlm_lowcomms_new_msg(nodeid, len + DLM_MIDCOMMS_OPT_LEN,
+	msg = dlm_lowcomms_new_msg(mh->node->dn, nodeid,
+				   len + DLM_MIDCOMMS_OPT_LEN,
 				   ppc, midcomms_new_msg_cb, mh);
 	if (!msg)
 		return NULL;
@@ -989,7 +985,7 @@ static struct dlm_msg *dlm_midcomms_get_msg_3_2(struct dlm_mhandle *mh, int node
 	mh->opts = opts;
 
 	/* add possible options here */
-	dlm_fill_opts_header(opts, len, mh->seq);
+	dlm_fill_opts_header(mh->node->dn, opts, len, mh->seq);
 
 	*ppc += sizeof(*opts);
 	mh->inner_p = (const union dlm_packet *)*ppc;
@@ -1000,15 +996,16 @@ static struct dlm_msg *dlm_midcomms_get_msg_3_2(struct dlm_mhandle *mh, int node
  * dlm_midcomms_commit_mhandle which is a must call if success
  */
 #ifndef __CHECKER__
-struct dlm_mhandle *dlm_midcomms_get_mhandle(int nodeid, int len, char **ppc)
+struct dlm_mhandle *dlm_midcomms_get_mhandle(struct dlm_net *dn, int nodeid,
+					     int len, char **ppc)
 {
 	struct midcomms_node *node;
 	struct dlm_mhandle *mh;
 	struct dlm_msg *msg;
 	int idx;
 
-	idx = srcu_read_lock(&nodes_srcu);
-	node = nodeid2node(nodeid);
+	idx = srcu_read_lock(&dn->nodes_srcu);
+	node = nodeid2node(dn, nodeid);
 	if (WARN_ON_ONCE(!node))
 		goto err;
 
@@ -1026,7 +1023,7 @@ struct dlm_mhandle *dlm_midcomms_get_mhandle(int nodeid, int len, char **ppc)
 
 	switch (node->version) {
 	case DLM_VERSION_3_1:
-		msg = dlm_lowcomms_new_msg(nodeid, len, ppc, NULL, NULL);
+		msg = dlm_lowcomms_new_msg(dn, nodeid, len, ppc, NULL, NULL);
 		if (!msg) {
 			dlm_free_mhandle(mh);
 			goto err;
@@ -1059,7 +1056,7 @@ struct dlm_mhandle *dlm_midcomms_get_mhandle(int nodeid, int len, char **ppc)
 	return mh;
 
 err:
-	srcu_read_unlock(&nodes_srcu, idx);
+	srcu_read_unlock(&dn->nodes_srcu, idx);
 	return NULL;
 }
 #endif
@@ -1100,10 +1097,11 @@ static void dlm_midcomms_commit_msg_3_2(struct dlm_mhandle *mh,
 void dlm_midcomms_commit_mhandle(struct dlm_mhandle *mh,
 				 const void *name, int namelen)
 {
+	struct dlm_net *dn = mh->node->dn;
 
 	switch (mh->node->version) {
 	case DLM_VERSION_3_1:
-		srcu_read_unlock(&nodes_srcu, mh->idx);
+		srcu_read_unlock(&dn->nodes_srcu, mh->idx);
 
 		dlm_lowcomms_commit_msg(mh->msg);
 		dlm_lowcomms_put_msg(mh->msg);
@@ -1118,35 +1116,25 @@ void dlm_midcomms_commit_mhandle(struct dlm_mhandle *mh,
 		 */
 		rcu_read_lock();
 		dlm_midcomms_commit_msg_3_2(mh, name, namelen);
-		srcu_read_unlock(&nodes_srcu, mh->idx);
+		srcu_read_unlock(&dn->nodes_srcu, mh->idx);
 		rcu_read_unlock();
 		break;
 	default:
-		srcu_read_unlock(&nodes_srcu, mh->idx);
+		srcu_read_unlock(&dn->nodes_srcu, mh->idx);
 		WARN_ON_ONCE(1);
 		break;
 	}
 }
 #endif
 
-int dlm_midcomms_start(void)
-{
-	return dlm_lowcomms_start();
-}
-
-void dlm_midcomms_stop(void)
+int dlm_midcomms_start(struct dlm_net *dn)
 {
-	dlm_lowcomms_stop();
+	return dlm_lowcomms_start(dn);
 }
 
-void dlm_midcomms_init(void)
+void dlm_midcomms_stop(struct dlm_net *dn)
 {
-	int i;
-
-	for (i = 0; i < CONN_HASH_SIZE; i++)
-		INIT_HLIST_HEAD(&node_hash[i]);
-
-	dlm_lowcomms_init();
+	dlm_lowcomms_stop(dn);
 }
 
 static void midcomms_node_release(struct rcu_head *rcu)
@@ -1158,26 +1146,43 @@ static void midcomms_node_release(struct rcu_head *rcu)
 	kfree(node);
 }
 
-void dlm_midcomms_exit(void)
+void __net_init dlm_midcomms_init(struct dlm_net *dn)
+{
+	int i;
+
+	init_srcu_struct(&dn->nodes_srcu);
+	spin_lock_init(&dn->nodes_lock);
+	mutex_init(&dn->close_lock);
+
+	for (i = 0; i < CONN_HASH_SIZE; i++)
+		INIT_HLIST_HEAD(&dn->node_hash[i]);
+
+	dlm_lowcomms_init(dn);
+}
+
+void __net_exit dlm_midcomms_exit(struct dlm_net *dn)
 {
 	struct midcomms_node *node;
 	int i, idx;
 
-	idx = srcu_read_lock(&nodes_srcu);
+	idx = srcu_read_lock(&dn->nodes_srcu);
 	for (i = 0; i < CONN_HASH_SIZE; i++) {
-		hlist_for_each_entry_rcu(node, &node_hash[i], hlist) {
-			dlm_delete_debug_comms_file(node->debugfs);
+		hlist_for_each_entry_rcu(node, &dn->node_hash[i], hlist) {
+			dlm_delete_debug_comms_file(dn, node->debugfs);
 
-			spin_lock(&nodes_lock);
+			spin_lock(&dn->nodes_lock);
 			hlist_del_rcu(&node->hlist);
-			spin_unlock(&nodes_lock);
+			spin_unlock(&dn->nodes_lock);
 
-			call_srcu(&nodes_srcu, &node->rcu, midcomms_node_release);
+			call_srcu(&dn->nodes_srcu, &node->rcu, midcomms_node_release);
 		}
 	}
-	srcu_read_unlock(&nodes_srcu, idx);
+	srcu_read_unlock(&dn->nodes_srcu, idx);
+
+	srcu_barrier(&dn->nodes_srcu);
+	cleanup_srcu_struct(&dn->nodes_srcu);
 
-	dlm_lowcomms_exit();
+	dlm_lowcomms_exit(dn);
 }
 
 static void dlm_act_fin_ack_rcv(struct midcomms_node *node)
@@ -1211,15 +1216,15 @@ static void dlm_act_fin_ack_rcv(struct midcomms_node *node)
 	spin_unlock_bh(&node->state_lock);
 }
 
-void dlm_midcomms_add_member(int nodeid)
+void dlm_midcomms_add_member(struct dlm_net *dn, int nodeid)
 {
 	struct midcomms_node *node;
 	int idx;
 
-	idx = srcu_read_lock(&nodes_srcu);
-	node = nodeid2node(nodeid);
+	idx = srcu_read_lock(&dn->nodes_srcu);
+	node = nodeid2node(dn, nodeid);
 	if (WARN_ON_ONCE(!node)) {
-		srcu_read_unlock(&nodes_srcu, idx);
+		srcu_read_unlock(&dn->nodes_srcu, idx);
 		return;
 	}
 
@@ -1253,19 +1258,19 @@ void dlm_midcomms_add_member(int nodeid)
 	pr_debug("node %d users inc count %d\n", nodeid, node->users);
 	spin_unlock_bh(&node->state_lock);
 
-	srcu_read_unlock(&nodes_srcu, idx);
+	srcu_read_unlock(&dn->nodes_srcu, idx);
 }
 
-void dlm_midcomms_remove_member(int nodeid)
+void dlm_midcomms_remove_member(struct dlm_net *dn, int nodeid)
 {
 	struct midcomms_node *node;
 	int idx;
 
-	idx = srcu_read_lock(&nodes_srcu);
-	node = nodeid2node(nodeid);
+	idx = srcu_read_lock(&dn->nodes_srcu);
+	node = nodeid2node(dn, nodeid);
 	/* in case of dlm_midcomms_close() removes node */
 	if (!node) {
-		srcu_read_unlock(&nodes_srcu, idx);
+		srcu_read_unlock(&dn->nodes_srcu, idx);
 		return;
 	}
 
@@ -1276,7 +1281,7 @@ void dlm_midcomms_remove_member(int nodeid)
 	 */
 	if (!node->users) {
 		spin_unlock_bh(&node->state_lock);
-		srcu_read_unlock(&nodes_srcu, idx);
+		srcu_read_unlock(&dn->nodes_srcu, idx);
 		return;
 	}
 
@@ -1315,17 +1320,17 @@ void dlm_midcomms_remove_member(int nodeid)
 	}
 	spin_unlock_bh(&node->state_lock);
 
-	srcu_read_unlock(&nodes_srcu, idx);
+	srcu_read_unlock(&dn->nodes_srcu, idx);
 }
 
-void dlm_midcomms_version_wait(void)
+void dlm_midcomms_version_wait(struct dlm_net *dn)
 {
 	struct midcomms_node *node;
 	int i, idx, ret;
 
-	idx = srcu_read_lock(&nodes_srcu);
+	idx = srcu_read_lock(&dn->nodes_srcu);
 	for (i = 0; i < CONN_HASH_SIZE; i++) {
-		hlist_for_each_entry_rcu(node, &node_hash[i], hlist) {
+		hlist_for_each_entry_rcu(node, &dn->node_hash[i], hlist) {
 			ret = wait_event_timeout(node->shutdown_wait,
 						 node->version != DLM_VERSION_NOT_SET ||
 						 node->state == DLM_CLOSED ||
@@ -1336,7 +1341,7 @@ void dlm_midcomms_version_wait(void)
 					 node->nodeid, dlm_state_str(node->state));
 		}
 	}
-	srcu_read_unlock(&nodes_srcu, idx);
+	srcu_read_unlock(&dn->nodes_srcu, idx);
 }
 
 static void midcomms_shutdown(struct midcomms_node *node)
@@ -1388,74 +1393,74 @@ static void midcomms_shutdown(struct midcomms_node *node)
 			 node->nodeid, dlm_state_str(node->state));
 }
 
-void dlm_midcomms_shutdown(void)
+void dlm_midcomms_shutdown(struct dlm_net *dn)
 {
 	struct midcomms_node *node;
 	int i, idx;
 
-	mutex_lock(&close_lock);
-	idx = srcu_read_lock(&nodes_srcu);
+	mutex_lock(&dn->close_lock);
+	idx = srcu_read_lock(&dn->nodes_srcu);
 	for (i = 0; i < CONN_HASH_SIZE; i++) {
-		hlist_for_each_entry_rcu(node, &node_hash[i], hlist) {
+		hlist_for_each_entry_rcu(node, &dn->node_hash[i], hlist) {
 			midcomms_shutdown(node);
 		}
 	}
 
-	dlm_lowcomms_shutdown();
+	dlm_lowcomms_shutdown(dn);
 
 	for (i = 0; i < CONN_HASH_SIZE; i++) {
-		hlist_for_each_entry_rcu(node, &node_hash[i], hlist) {
+		hlist_for_each_entry_rcu(node, &dn->node_hash[i], hlist) {
 			midcomms_node_reset(node);
 		}
 	}
-	srcu_read_unlock(&nodes_srcu, idx);
-	mutex_unlock(&close_lock);
+	srcu_read_unlock(&dn->nodes_srcu, idx);
+	mutex_unlock(&dn->close_lock);
 }
 
-int dlm_midcomms_close(int nodeid)
+int dlm_midcomms_close(struct dlm_net *dn, int nodeid)
 {
 	struct midcomms_node *node;
 	int idx, ret;
 
-	idx = srcu_read_lock(&nodes_srcu);
+	idx = srcu_read_lock(&dn->nodes_srcu);
 	/* Abort pending close/remove operation */
-	node = nodeid2node(nodeid);
+	node = nodeid2node(dn, nodeid);
 	if (node) {
 		/* let shutdown waiters leave */
 		set_bit(DLM_NODE_FLAG_CLOSE, &node->flags);
 		wake_up(&node->shutdown_wait);
 	}
-	srcu_read_unlock(&nodes_srcu, idx);
+	srcu_read_unlock(&dn->nodes_srcu, idx);
 
-	synchronize_srcu(&nodes_srcu);
+	synchronize_srcu(&dn->nodes_srcu);
 
-	mutex_lock(&close_lock);
-	idx = srcu_read_lock(&nodes_srcu);
-	node = nodeid2node(nodeid);
+	mutex_lock(&dn->close_lock);
+	idx = srcu_read_lock(&dn->nodes_srcu);
+	node = nodeid2node(dn, nodeid);
 	if (!node) {
-		srcu_read_unlock(&nodes_srcu, idx);
-		mutex_unlock(&close_lock);
-		return dlm_lowcomms_close(nodeid);
+		srcu_read_unlock(&dn->nodes_srcu, idx);
+		mutex_unlock(&dn->close_lock);
+		return dlm_lowcomms_close(dn, nodeid);
 	}
 
-	ret = dlm_lowcomms_close(nodeid);
-	dlm_delete_debug_comms_file(node->debugfs);
+	ret = dlm_lowcomms_close(dn, nodeid);
+	dlm_delete_debug_comms_file(dn, node->debugfs);
 
-	spin_lock_bh(&nodes_lock);
+	spin_lock_bh(&dn->nodes_lock);
 	hlist_del_rcu(&node->hlist);
-	spin_unlock_bh(&nodes_lock);
-	srcu_read_unlock(&nodes_srcu, idx);
+	spin_unlock_bh(&dn->nodes_lock);
+	srcu_read_unlock(&dn->nodes_srcu, idx);
 
 	/* wait that all readers left until flush send queue */
-	synchronize_srcu(&nodes_srcu);
+	synchronize_srcu(&dn->nodes_srcu);
 
 	/* drop all pending dlm messages, this is fine as
 	 * this function get called when the node is fenced
 	 */
 	dlm_send_queue_flush(node);
 
-	call_srcu(&nodes_srcu, &node->rcu, midcomms_node_release);
-	mutex_unlock(&close_lock);
+	call_srcu(&dn->nodes_srcu, &node->rcu, midcomms_node_release);
+	mutex_unlock(&dn->close_lock);
 
 	return ret;
 }
@@ -1497,7 +1502,7 @@ int dlm_midcomms_rawmsg_send(struct midcomms_node *node, void *buf,
 	rd.node = node;
 	rd.buf = buf;
 
-	msg = dlm_lowcomms_new_msg(node->nodeid, buflen, &msgbuf,
+	msg = dlm_lowcomms_new_msg(node->dn, node->nodeid, buflen, &msgbuf,
 				   midcomms_new_rawmsg_cb, &rd);
 	if (!msg)
 		return -ENOMEM;
diff --git a/fs/dlm/midcomms.h b/fs/dlm/midcomms.h
index 7fad1d170bba..4abb8c4bb9fb 100644
--- a/fs/dlm/midcomms.h
+++ b/fs/dlm/midcomms.h
@@ -12,24 +12,29 @@
 #ifndef __MIDCOMMS_DOT_H__
 #define __MIDCOMMS_DOT_H__
 
+#include "config.h"
+
 struct midcomms_node;
 
 int dlm_validate_incoming_buffer(int nodeid, unsigned char *buf, int len);
-int dlm_process_incoming_buffer(int nodeid, unsigned char *buf, int buflen);
-struct dlm_mhandle *dlm_midcomms_get_mhandle(int nodeid, int len, char **ppc);
+int dlm_process_incoming_buffer(struct dlm_net *dn, int nodeid,
+				unsigned char *buf, int len);
+struct dlm_mhandle *dlm_midcomms_get_mhandle(struct dlm_net *dn, int nodeid,
+					     int len, char **ppc);
 void dlm_midcomms_commit_mhandle(struct dlm_mhandle *mh, const void *name,
 				 int namelen);
-int dlm_midcomms_addr(int nodeid, struct sockaddr_storage *addr);
-void dlm_midcomms_version_wait(void);
-int dlm_midcomms_close(int nodeid);
-int dlm_midcomms_start(void);
-void dlm_midcomms_stop(void);
-void dlm_midcomms_init(void);
-void dlm_midcomms_exit(void);
-void dlm_midcomms_shutdown(void);
-void dlm_midcomms_add_member(int nodeid);
-void dlm_midcomms_remove_member(int nodeid);
-void dlm_midcomms_unack_msg_resend(int nodeid);
+int dlm_midcomms_addr(struct dlm_net *dn, int nodeid,
+		      struct sockaddr_storage *addr);
+void dlm_midcomms_version_wait(struct dlm_net *dn);
+int dlm_midcomms_close(struct dlm_net *dn, int nodeid);
+int dlm_midcomms_start(struct dlm_net *dn);
+void dlm_midcomms_init(struct dlm_net *dn);
+void dlm_midcomms_exit(struct dlm_net *dn);
+void dlm_midcomms_stop(struct dlm_net *dn);
+void dlm_midcomms_shutdown(struct dlm_net *dn);
+void dlm_midcomms_add_member(struct dlm_net *dn, int nodeid);
+void dlm_midcomms_remove_member(struct dlm_net *dn, int nodeid);
+void dlm_midcomms_unack_msg_resend(struct dlm_net *dn, int nodeid);
 const char *dlm_midcomms_state(struct midcomms_node *node);
 unsigned long dlm_midcomms_flags(struct midcomms_node *node);
 int dlm_midcomms_send_queue_cnt(struct midcomms_node *node);
diff --git a/fs/dlm/plock.c b/fs/dlm/plock.c
index 9ca83ef70ed1..b16d5277bb1e 100644
--- a/fs/dlm/plock.c
+++ b/fs/dlm/plock.c
@@ -463,7 +463,7 @@ int dlm_posix_get(dlm_lockspace_t *lockspace, u64 number, struct file *file,
 		fl->c.flc_type = (op->info.ex) ? F_WRLCK : F_RDLCK;
 		fl->c.flc_flags = FL_POSIX;
 		fl->c.flc_pid = op->info.pid;
-		if (op->info.nodeid != dlm_our_nodeid())
+		if (op->info.nodeid != dlm_our_nodeid(ls->ls_dn))
 			fl->c.flc_pid = -fl->c.flc_pid;
 		fl->fl_start = op->info.start;
 		fl->fl_end = op->info.end;
diff --git a/fs/dlm/rcom.c b/fs/dlm/rcom.c
index be1a71a6303a..3b7c44375f23 100644
--- a/fs/dlm/rcom.c
+++ b/fs/dlm/rcom.c
@@ -37,7 +37,7 @@ static void _create_rcom(struct dlm_ls *ls, int to_nodeid, int type, int len,
 
 	rc->rc_header.h_version = cpu_to_le32(DLM_HEADER_MAJOR | DLM_HEADER_MINOR);
 	rc->rc_header.u.h_lockspace = cpu_to_le32(ls->ls_global_id);
-	rc->rc_header.h_nodeid = cpu_to_le32(dlm_our_nodeid());
+	rc->rc_header.h_nodeid = cpu_to_le32(dlm_our_nodeid(ls->ls_dn));
 	rc->rc_header.h_length = cpu_to_le16(mb_len);
 	rc->rc_header.h_cmd = DLM_RCOM;
 
@@ -55,7 +55,7 @@ static int create_rcom(struct dlm_ls *ls, int to_nodeid, int type, int len,
 	struct dlm_mhandle *mh;
 	char *mb;
 
-	mh = dlm_midcomms_get_mhandle(to_nodeid, mb_len, &mb);
+	mh = dlm_midcomms_get_mhandle(ls->ls_dn, to_nodeid, mb_len, &mb);
 	if (!mh) {
 		log_print("%s to %d type %d len %d ENOBUFS",
 			  __func__, to_nodeid, type, len);
@@ -75,7 +75,8 @@ static int create_rcom_stateless(struct dlm_ls *ls, int to_nodeid, int type,
 	struct dlm_msg *msg;
 	char *mb;
 
-	msg = dlm_lowcomms_new_msg(to_nodeid, mb_len, &mb, NULL, NULL);
+	msg = dlm_lowcomms_new_msg(ls->ls_dn, to_nodeid, mb_len, &mb, NULL,
+				   NULL);
 	if (!msg) {
 		log_print("create_rcom to %d type %d len %d ENOBUFS",
 			  to_nodeid, type, len);
@@ -177,7 +178,7 @@ int dlm_rcom_status(struct dlm_ls *ls, int nodeid, uint32_t status_flags,
 
 	ls->ls_recover_nodeid = nodeid;
 
-	if (nodeid == dlm_our_nodeid()) {
+	if (nodeid == dlm_our_nodeid(ls->ls_dn)) {
 		rc = ls->ls_recover_buf;
 		rc->rc_result = cpu_to_le32(dlm_recover_status(ls));
 		goto out;
@@ -501,7 +502,8 @@ static void receive_rcom_lock(struct dlm_ls *ls, const struct dlm_rcom *rc_in,
 /* If the lockspace doesn't exist then still send a status message
    back; it's possible that it just doesn't have its global_id yet. */
 
-int dlm_send_ls_not_ready(int nodeid, const struct dlm_rcom *rc_in)
+int dlm_send_ls_not_ready(struct dlm_net *dn, int nodeid,
+			  const struct dlm_rcom *rc_in)
 {
 	struct dlm_rcom *rc;
 	struct rcom_config *rf;
@@ -509,7 +511,7 @@ int dlm_send_ls_not_ready(int nodeid, const struct dlm_rcom *rc_in)
 	char *mb;
 	int mb_len = sizeof(struct dlm_rcom) + sizeof(struct rcom_config);
 
-	mh = dlm_midcomms_get_mhandle(nodeid, mb_len, &mb);
+	mh = dlm_midcomms_get_mhandle(dn, nodeid, mb_len, &mb);
 	if (!mh)
 		return -ENOBUFS;
 
@@ -517,7 +519,7 @@ int dlm_send_ls_not_ready(int nodeid, const struct dlm_rcom *rc_in)
 
 	rc->rc_header.h_version = cpu_to_le32(DLM_HEADER_MAJOR | DLM_HEADER_MINOR);
 	rc->rc_header.u.h_lockspace = rc_in->rc_header.u.h_lockspace;
-	rc->rc_header.h_nodeid = cpu_to_le32(dlm_our_nodeid());
+	rc->rc_header.h_nodeid = cpu_to_le32(dlm_our_nodeid(dn));
 	rc->rc_header.h_length = cpu_to_le16(mb_len);
 	rc->rc_header.h_cmd = DLM_RCOM;
 
diff --git a/fs/dlm/rcom.h b/fs/dlm/rcom.h
index 765926ae0020..8b1d7418b335 100644
--- a/fs/dlm/rcom.h
+++ b/fs/dlm/rcom.h
@@ -20,7 +20,8 @@ int dlm_send_rcom_lookup(struct dlm_rsb *r, int dir_nodeid, uint64_t seq);
 int dlm_send_rcom_lock(struct dlm_rsb *r, struct dlm_lkb *lkb, uint64_t seq);
 void dlm_receive_rcom(struct dlm_ls *ls, const struct dlm_rcom *rc,
 		      int nodeid);
-int dlm_send_ls_not_ready(int nodeid, const struct dlm_rcom *rc_in);
+int dlm_send_ls_not_ready(struct dlm_net *dn, int nodeid,
+			  const struct dlm_rcom *rc_in);
 
 #endif
 
diff --git a/fs/dlm/recover.c b/fs/dlm/recover.c
index 2e1169c81c6e..9c5849556bff 100644
--- a/fs/dlm/recover.c
+++ b/fs/dlm/recover.c
@@ -47,7 +47,7 @@ int dlm_wait_function(struct dlm_ls *ls, int (*testfn) (struct dlm_ls *ls))
 	while (1) {
 		rv = wait_event_timeout(ls->ls_wait_general,
 					testfn(ls) || dlm_recovery_stopped(ls),
-					dlm_config.ci_recover_timer * HZ);
+					ls->ls_dn->config.ci_recover_timer * HZ);
 		if (rv)
 			break;
 		if (test_bit(LSFL_RCOM_WAIT, &ls->ls_flags)) {
@@ -156,7 +156,7 @@ static int wait_status(struct dlm_ls *ls, uint32_t status, uint64_t seq)
 	uint32_t status_all = status << 1;
 	int error;
 
-	if (ls->ls_low_nodeid == dlm_our_nodeid()) {
+	if (ls->ls_low_nodeid == dlm_our_nodeid(ls->ls_dn)) {
 		error = wait_status_all(ls, status, 0, seq);
 		if (!error)
 			dlm_set_recover_status(ls, status_all);
@@ -179,7 +179,7 @@ int dlm_recover_members_wait(struct dlm_ls *ls, uint64_t seq)
 		memb->generation = 0;
 	}
 
-	if (ls->ls_low_nodeid == dlm_our_nodeid()) {
+	if (ls->ls_low_nodeid == dlm_our_nodeid(ls->ls_dn)) {
 		error = wait_status_all(ls, DLM_RS_NODES, 1, seq);
 		if (error)
 			goto out;
@@ -461,7 +461,7 @@ static int recover_master(struct dlm_rsb *r, unsigned int *count, uint64_t seq)
 	if (!is_removed && !rsb_flag(r, RSB_NEW_MASTER))
 		return 0;
 
-	our_nodeid = dlm_our_nodeid();
+	our_nodeid = dlm_our_nodeid(ls->ls_dn);
 	dir_nodeid = dlm_dir_nodeid(r);
 
 	if (dir_nodeid == our_nodeid) {
@@ -499,12 +499,13 @@ static int recover_master(struct dlm_rsb *r, unsigned int *count, uint64_t seq)
  * resent.
  */
 
-static int recover_master_static(struct dlm_rsb *r, unsigned int *count)
+static int recover_master_static(struct dlm_ls *ls, struct dlm_rsb *r,
+				 unsigned int *count)
 {
 	int dir_nodeid = dlm_dir_nodeid(r);
 	int new_master = dir_nodeid;
 
-	if (dir_nodeid == dlm_our_nodeid())
+	if (dir_nodeid == dlm_our_nodeid(ls->ls_dn))
 		new_master = 0;
 
 	dlm_purge_mstcpy_locks(r);
@@ -544,7 +545,7 @@ int dlm_recover_masters(struct dlm_ls *ls, uint64_t seq,
 
 		lock_rsb(r);
 		if (nodir)
-			error = recover_master_static(r, &count);
+			error = recover_master_static(ls, r, &count);
 		else
 			error = recover_master(r, &count, seq);
 		unlock_rsb(r);
@@ -578,7 +579,7 @@ int dlm_recover_master_reply(struct dlm_ls *ls, const struct dlm_rcom *rc)
 
 	ret_nodeid = le32_to_cpu(rc->rc_result);
 
-	if (ret_nodeid == dlm_our_nodeid())
+	if (ret_nodeid == dlm_our_nodeid(ls->ls_dn))
 		new_master = 0;
 	else
 		new_master = ret_nodeid;
diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index 5cb3896be826..1b682f8f95b6 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/miscdevice.h>
+#include <linux/netdevice.h>
 #include <linux/init.h>
 #include <linux/wait.h>
 #include <linux/file.h>
@@ -29,8 +30,6 @@
 
 static const char name_prefix[] = "dlm";
 static const struct file_operations device_fops;
-static atomic_t dlm_monitor_opened;
-static int dlm_monitor_unused = 1;
 
 #ifdef CONFIG_COMPAT
 
@@ -345,6 +344,12 @@ static int dlm_device_register(struct dlm_ls *ls, char *name)
 {
 	int error, len;
 
+	/* user lock device created for init_net where it is supported
+	 * for now.
+	 */
+	if (!net_eq(read_pnet(&ls->ls_dn->net), &init_net))
+		return 0;
+
 	/* The device is already registered.  This happens when the
 	   lockspace is created multiple times from userspace. */
 	if (ls->ls_device.name)
@@ -381,6 +386,12 @@ int dlm_device_deregister(struct dlm_ls *ls)
 	if (!ls->ls_device.name)
 		return 0;
 
+	/* user lock device created for init_net where it is supported
+	 * for now. Lets warn if for some reason lockspace switched its
+	 * ns during lifetime which is currently not supported either.
+	 */
+	WARN_ON(!net_eq(read_pnet(&ls->ls_dn->net), &init_net));
+
 	misc_deregister(&ls->ls_device);
 	kfree(ls->ls_device.name);
 	return 0;
@@ -402,7 +413,8 @@ static int device_user_purge(struct dlm_user_proc *proc,
 	return error;
 }
 
-static int device_create_lockspace(struct dlm_lspace_params *params)
+static int device_create_lockspace(struct dlm_net *dn,
+				   struct dlm_lspace_params *params)
 {
 	dlm_lockspace_t *lockspace;
 	struct dlm_ls *ls;
@@ -411,7 +423,7 @@ static int device_create_lockspace(struct dlm_lspace_params *params)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	error = dlm_new_user_lockspace(params->name, dlm_config.ci_cluster_name,
+	error = dlm_new_user_lockspace(dn, params->name, dn->config.ci_cluster_name,
 				       params->flags, DLM_USER_LVB_LEN, NULL,
 				       NULL, NULL, &lockspace);
 	if (error)
@@ -432,7 +444,8 @@ static int device_create_lockspace(struct dlm_lspace_params *params)
 	return error;
 }
 
-static int device_remove_lockspace(struct dlm_lspace_params *params)
+static int device_remove_lockspace(struct dlm_net *dn,
+				   struct dlm_lspace_params *params)
 {
 	dlm_lockspace_t *lockspace;
 	struct dlm_ls *ls;
@@ -441,7 +454,7 @@ static int device_remove_lockspace(struct dlm_lspace_params *params)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	ls = dlm_find_lockspace_device(params->minor);
+	ls = dlm_find_lockspace_device(dn, params->minor);
 	if (!ls)
 		return -ENOENT;
 
@@ -511,6 +524,7 @@ static ssize_t device_write(struct file *file, const char __user *buf,
 			    size_t count, loff_t *ppos)
 {
 	struct dlm_user_proc *proc = file->private_data;
+	struct dlm_net *dn = dlm_pernet(&init_net);
 	struct dlm_write_request *kbuf;
 	int error;
 
@@ -603,7 +617,7 @@ static ssize_t device_write(struct file *file, const char __user *buf,
 			log_print("create/remove only on control device");
 			goto out_free;
 		}
-		error = device_create_lockspace(&kbuf->i.lspace);
+		error = device_create_lockspace(dn, &kbuf->i.lspace);
 		break;
 
 	case DLM_USER_REMOVE_LOCKSPACE:
@@ -611,7 +625,7 @@ static ssize_t device_write(struct file *file, const char __user *buf,
 			log_print("create/remove only on control device");
 			goto out_free;
 		}
-		error = device_remove_lockspace(&kbuf->i.lspace);
+		error = device_remove_lockspace(dn, &kbuf->i.lspace);
 		break;
 
 	case DLM_USER_PURGE:
@@ -638,10 +652,18 @@ static ssize_t device_write(struct file *file, const char __user *buf,
 
 static int device_open(struct inode *inode, struct file *file)
 {
+	struct net *net = current->nsproxy->net_ns;
+	struct dlm_net *dn = dlm_pernet(&init_net);
 	struct dlm_user_proc *proc;
 	struct dlm_ls *ls;
 
-	ls = dlm_find_lockspace_device(iminor(inode));
+	/* Allow open() only on processes for init namespace for now.
+	 * Everything else is not supported. Do deal with this UAPI.
+	 */
+	if (!net_eq(net, &init_net))
+		return -EOPNOTSUPP;
+
+	ls = dlm_find_lockspace_device(dn, iminor(inode));
 	if (!ls)
 		return -ENOENT;
 
@@ -877,12 +899,12 @@ static __poll_t device_poll(struct file *file, poll_table *wait)
 	return 0;
 }
 
-int dlm_user_daemon_available(void)
+int dlm_user_daemon_available(struct dlm_net *dn)
 {
 	/* dlm_controld hasn't started (or, has started, but not
 	   properly populated configfs) */
 
-	if (!dlm_our_nodeid())
+	if (!dlm_our_nodeid(dn))
 		return 0;
 
 	/* This is to deal with versions of dlm_controld that don't
@@ -891,10 +913,10 @@ int dlm_user_daemon_available(void)
 	   was never opened, that it's an old version.  dlm_controld
 	   should open the monitor device before populating configfs. */
 
-	if (dlm_monitor_unused)
+	if (dn->dlm_monitor_unused)
 		return 1;
 
-	return atomic_read(&dlm_monitor_opened) ? 1 : 0;
+	return atomic_read(&dn->dlm_monitor_opened) ? 1 : 0;
 }
 
 static int ctl_device_open(struct inode *inode, struct file *file)
@@ -910,15 +932,20 @@ static int ctl_device_close(struct inode *inode, struct file *file)
 
 static int monitor_device_open(struct inode *inode, struct file *file)
 {
-	atomic_inc(&dlm_monitor_opened);
-	dlm_monitor_unused = 0;
+	struct dlm_net *dn = dlm_pernet(&init_net);
+
+	atomic_inc(&dn->dlm_monitor_opened);
+	dn->dlm_monitor_unused = 0;
 	return 0;
 }
 
 static int monitor_device_close(struct inode *inode, struct file *file)
 {
-	if (atomic_dec_and_test(&dlm_monitor_opened))
-		dlm_stop_lockspaces();
+	struct dlm_net *dn = dlm_pernet(&init_net);
+
+	if (atomic_dec_and_test(&dn->dlm_monitor_opened))
+		dlm_stop_lockspaces(dn);
+
 	return 0;
 }
 
@@ -964,8 +991,6 @@ int __init dlm_user_init(void)
 {
 	int error;
 
-	atomic_set(&dlm_monitor_opened, 0);
-
 	error = misc_register(&ctl_device);
 	if (error) {
 		log_print("misc_register failed for control device");
diff --git a/fs/dlm/user.h b/fs/dlm/user.h
index 2caf8e6e24d5..eac33bbe99b1 100644
--- a/fs/dlm/user.h
+++ b/fs/dlm/user.h
@@ -12,6 +12,6 @@ void dlm_user_add_ast(struct dlm_lkb *lkb, uint32_t flags, int mode,
 int dlm_user_init(void);
 void dlm_user_exit(void);
 int dlm_device_deregister(struct dlm_ls *ls);
-int dlm_user_daemon_available(void);
+int dlm_user_daemon_available(struct dlm_net *dn);
 
 #endif
-- 
2.43.0

