Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474321A4B9F
	for <ocfs2-devel@lists.linux.dev>; Mon, 30 Sep 2024 20:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727727289; cv=none; b=AdDlNo1/Gr6s01WLC5BEAANdRF6D2SlOHT6AFi3ti4MHCzeSMxkdKO7DJ1eVzAKqjCTXthL+HmyNgCmldCMWvy3a1s53DWyyh6LubFolOIq0cD5nR+6jk79P0oXLYeXK28AY5g/qMY70gA7LZo/d8zAn4FUzDKodZL1yzK+gA0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727727289; c=relaxed/simple;
	bh=1jE5oUaDG/OvdlEeec63v9ZoHhssdsyCdyKnNzoQbds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uOKGAzmyDSiBIJ9RpeXgDy2KdpR7ZXUVTMHT33PwN7Q6Za+n2RgvK98eMQwAgEIwnaGnEZR/kHyOQ97gcIVV53ilPge1NQAO15sywBk8Q+1fwCetNvUwTFRbuvVdk5p11Tk9YDpGo3Rvabj7XAVaW4E6YHcTwKoAjZhKxXzICHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V1pf8nAO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V1pf8nAO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727727281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NRSRahG3IG9A9JgT9uy7YQ6vZUBhoEN9i1/SLgSLL6I=;
	b=V1pf8nAOB0WxTcdrZA+cYgupuJRT8Cl/Kkpp+gMebmNCpKp2OveN6/++PIPxEGWfICR59c
	Gj2YzeURkUV2uDoN2m8eR88t7HfE0EvLJZOwvKWamYCJ4DSOa0rRD9JbRtcBccy2pJSel3
	r5Q4rDgV91vgMv0oA+8bkA4B8EvQJUk=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-460-kdRcXKM4PrKkE7Ao9VcUaA-1; Mon,
 30 Sep 2024 16:14:37 -0400
X-MC-Unique: kdRcXKM4PrKkE7Ao9VcUaA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 63406196A401;
	Mon, 30 Sep 2024 20:14:35 +0000 (UTC)
Received: from fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com (unknown [10.6.24.150])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F25AD1955DC7;
	Mon, 30 Sep 2024 20:14:32 +0000 (UTC)
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
	donald.hunter@gmail.com,
	aahringo@redhat.com
Subject: [PATCHv2 dlm/next 11/12] dlm: add nldlm net-namespace aware UAPI
Date: Mon, 30 Sep 2024 16:13:57 -0400
Message-ID: <20240930201358.2638665-12-aahringo@redhat.com>
In-Reply-To: <20240930201358.2638665-1-aahringo@redhat.com>
References: <20240930201358.2638665-1-aahringo@redhat.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Recent patches introduced support to separate DLM lockspaces on a per
net-namespace basis. Currently the file based configfs mechanism is used
to configure parts of DLM. Due the lack of namespace awareness (and it's
probably complicated to add support for this) in configfs we introduce a
socket based UAPI using "netlink". As the DLM subsystem offers now a
config layer it can simultaneously being used with configfs, just that
nldlm is net-namespace aware.

Most of the current configfs functionality that is necessary to
configure DLM is being adapted for now. The nldlm netlink interface
offers also a multicast group for lockspace events NLDLM_MCGRP_EVENT.
This event group can be used as alternative to the already existing udev
event behaviour just it only contains DLM related subsystem events.

Attributes e.g. nodeid, port, IP addresses are expected from the user
space to fill those numbers as they appear on the wire. In case of DLM
fields it is using little endian byte order.

The dumps are being designed to scale in future with high numbers of
members in a lockspace. E.g. dump members require an unique lockspace
identifier (currently only the name) and nldlm is using a netlink dump
behaviour to be prepared if all entries may not fit into one netlink
message.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 Documentation/netlink/specs/nldlm.yaml |  438 ++++++++
 fs/dlm/Makefile                        |    2 +
 fs/dlm/config.c                        |   20 +-
 fs/dlm/dlm_internal.h                  |    4 +
 fs/dlm/lockspace.c                     |   13 +-
 fs/dlm/netlink2.c                      | 1330 ++++++++++++++++++++++++
 fs/dlm/nldlm-kernel.c                  |  290 ++++++
 fs/dlm/nldlm-kernel.h                  |   50 +
 fs/dlm/nldlm.c                         |  847 +++++++++++++++
 include/uapi/linux/nldlm.h             |  153 +++
 10 files changed, 3141 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/netlink/specs/nldlm.yaml
 create mode 100644 fs/dlm/netlink2.c
 create mode 100644 fs/dlm/nldlm-kernel.c
 create mode 100644 fs/dlm/nldlm-kernel.h
 create mode 100644 fs/dlm/nldlm.c
 create mode 100644 include/uapi/linux/nldlm.h

diff --git a/Documentation/netlink/specs/nldlm.yaml b/Documentation/netlink/specs/nldlm.yaml
new file mode 100644
index 000000000000..8c32815c0391
--- /dev/null
+++ b/Documentation/netlink/specs/nldlm.yaml
@@ -0,0 +1,438 @@
+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+
+name: nldlm
+protocol: genetlink
+doc: DLM subsystem.
+
+definitions:
+  -
+    type: enum
+    name: protocol
+    doc: |
+      The transport layer protocol that DLM will use.
+    entries:
+      -
+        name: TCP
+      -
+        name: SCTP
+  -
+    type: enum
+    name: log-level
+    doc: |
+      The internal DLM logger log-level.
+    entries:
+      -
+        name: NONE
+        doc: disable all DLM logging
+      -
+        name: INFO
+        doc: enable INFO log-level only
+      -
+        name: DEBUG
+        doc: enable INFO and DEBUG log-level
+  -
+    type: enum
+    name: ls-ctrl-action
+    doc: |
+      The lockspace control actions. Use in combination with
+      ls-add-member and ls-del-member. First stop lockspace
+      then update the members, then start the lockspace to
+      trigger recovery with new membership updates.
+    entries:
+      -
+        name: STOP
+        doc: stopping the lockspace
+      -
+        name: START
+        doc: starting the lockspace
+  -
+    type: enum
+    name: ls-event-result
+    doc: |
+      The result op of the lockspace event ntf-new-ls and
+      ntf-release-ls. The kernel is waiting for this reply
+      when those events occur.
+    entries:
+      -
+        name: SUCCESS
+        doc: the DLM kernel lockspace event action was successful
+      -
+        name: FAILURE
+        doc: the DLM kernel lockspace event action failed
+
+attribute-sets:
+  -
+    name: cfg
+    attributes:
+      -
+        name: our-nodeid
+        type: u32
+        byte-order: little-endian
+      -
+        name: cluster-name
+        type: string
+      -
+        name: protocol
+        type: u32
+      -
+        name: port
+        type: u16
+        byte-order: big-endian
+      -
+        name: recover-timeout
+        type: u32
+      -
+        name: inactive-timeout
+        type: u32
+      -
+        name: log-level
+        type: u32
+      -
+        name: default-mark
+        type: u32
+      -
+        name: recover-callbacks
+        type: flag
+  -
+    name: ls
+    attributes:
+      -
+        name: name
+        type: string
+  -
+    name: ls-member
+    attributes:
+      -
+        name: ls-name
+        type: string
+      -
+        name: nodeid
+        type: u32
+        byte-order: little-endian
+      -
+        name: weight
+        type: u32
+  -
+    name: ls-ctrl
+    attributes:
+      -
+        name: ls-name
+        type: string
+      -
+        name: action
+        type: u32
+  -
+    name: ls-event-result
+    attributes:
+      -
+        name: ls-name
+        type: string
+      -
+        name: ls-global-id
+        type: u32
+        byte-order: little-endian
+      -
+        name: result
+        type: u32
+  -
+    name: node
+    attributes:
+      -
+        name: id
+        type: u32
+        byte-order: little-endian
+      -
+        name: mark
+        type: u32
+      -
+        name: addrs
+        type: nest
+        nested-attributes: addr
+        multi-attr: true
+  -
+    name: addr
+    attributes:
+      -
+        name: family
+        type: u16
+      -
+        name: addr4
+        type: u32
+        byte-order: big-endian
+        display-hint: ipv4
+      -
+        name: addr6
+        type: binary
+        display-hint: ipv6
+        checks:
+          exact-len: 16
+
+operations:
+  list:
+    -
+      name: get-node
+      doc: |
+        get DLM node information from the kernel configuration.
+      attribute-set: node
+      do:
+        request:
+          attributes:
+            - id
+        reply:
+          attributes:
+            - id
+            - mark
+            - addrs
+      dump:
+        reply:
+          attributes:
+            - id
+            - mark
+            - addrs
+    -
+      name: add-node
+      doc: |
+        add a new DLM node to the kernel configuration.
+      attribute-set: node
+      flags: [ admin-perm ]
+      do:
+        request:
+          attributes:
+            - id
+            - mark
+            - addrs
+    -
+      name: del-node
+      doc: |
+        delete a DLM node from the kernel configuration.
+      attribute-set: node
+      flags: [ admin-perm ]
+      do:
+        request:
+          attributes:
+            - id
+    -
+      name: get-ls
+      doc: |
+        get registered DLM lockspace information.
+      attribute-set: ls
+      do:
+        request:
+          attributes:
+            - name
+        reply:
+          attributes:
+            - name
+      dump:
+        reply:
+          attributes:
+            - name
+    -
+      name: get-ls-member
+      doc: |
+        get members information from a registered DLM lockspace.
+      attribute-set: ls-member
+      flags: [ admin-perm ]
+      do:
+        request:
+          attributes:
+            - ls-name
+            - nodeid
+        reply:
+          attributes:
+            - ls-name
+            - nodeid
+            - weight
+      dump:
+        request:
+          attributes:
+            - ls-name
+        reply:
+          attributes:
+            - ls-name
+            - nodeid
+            - weight
+    -
+      name: ls-add-member
+      doc: |
+        add a member to a specific registered lockspace. Should be used
+        when the lockspaces is stopped.
+      attribute-set: ls-member
+      flags: [ admin-perm ]
+      do:
+        request:
+          attributes:
+            - ls-name
+            - nodeid
+            - weight
+    -
+      name: ls-del-member
+      doc: |
+        delete a member to a specific registered lockspace. Should be used
+        when the lockspaces is stopped.
+      attribute-set: ls-member
+      flags: [ admin-perm ]
+      do:
+        request:
+          attributes:
+            - ls-name
+            - nodeid
+    -
+      name: ls-ctrl
+      doc: |
+        do lockspace control actions like stop and start lockspace for
+        membership updates.
+      attribute-set: ls-ctrl
+      flags: [ admin-perm ]
+      do:
+        request:
+          attributes:
+            - ls-name
+            - action
+    -
+      name: ntf-new-ls
+      doc: |
+        notify that the kernel is creating a new lockspace and the user
+        space need to ackknowledge and set a cluster-wide global-id with
+        ls-event-done.
+      notify: get-ls
+      mcgrp: ls-event
+    -
+      name: ntf-release-ls
+      doc: |
+        notify that the kernel is releasing registered lockspace.
+      notify: get-ls
+      mcgrp: ls-event
+    -
+      name: ls-event-done
+      doc: |
+        send back the result from the user space of the ntf-new-ls or
+        ntf-release-ls ls-event. The user space can decide to accept
+        or reject the lockspace creation. Sending the result back requires
+        to tell the DLM lockspace the cluster-wide unique global-id.
+      attribute-set: ls-event-result
+      flags: [ admin-perm ]
+      do:
+        request:
+          attributes:
+            - ls-name
+            - ls-global-id
+            - result
+    -
+      name: get-cfg
+      doc: |
+        get the current DLM kernel configuration attributes.
+      attribute-set: cfg
+      do:
+        reply:
+          attributes:
+            - our-nodeid
+            - cluster-name
+            - protocol
+            - port
+            - recover-timeout
+            - inactive-timeout
+            - log-level
+            - default-mark
+            - recover-callbacks
+    -
+      name: set-our-nodeid
+      doc: |
+        set our nodeid. The node need to be part of the DLM registered
+        nodes.
+      attribute-set: cfg
+      flags: [ admin-perm ]
+      do:
+        request:
+          attributes:
+            - our-nodeid
+    -
+      name: set-cluster-name
+      doc: |
+        set the DLM cluster name.
+      attribute-set: cfg
+      flags: [ admin-perm ]
+      do:
+        request:
+          attributes:
+            - cluster-name
+    -
+      name: set-protocol
+      doc: |
+        set the DLM used transportation protocol.
+      attribute-set: cfg
+      flags: [ admin-perm ]
+      do:
+        request:
+          attributes:
+            - protocol
+    -
+      name: set-port
+      doc: |
+        set the DLM port to listen for the used transportation protocol.
+      attribute-set: cfg
+      flags: [ admin-perm ]
+      do:
+        request:
+          attributes:
+            - port
+    -
+      name: set-recover-timeout
+      doc: |
+        The DLM recovery has some wait events that requires other nodes
+        to answer in a time. This is the timeout value how long DLM
+        should wait until giving up in the DLM recovery routines.
+      attribute-set: cfg
+      flags: [ admin-perm ]
+      do:
+        request:
+          attributes:
+            - recover-timeout
+    -
+      name: set-inactive-timeout
+      doc: |
+        DLM lock resources are keeping in memory if not being used inside
+        the lockspace anymore to fast reactivate them if they get used after
+        a certain timeout that can be specified here.
+      attribute-set: cfg
+      flags: [ admin-perm ]
+      do:
+        request:
+          attributes:
+            - inactive-timeout
+    -
+      name: set-log-level
+      doc: |
+        set the DLM kernel logging level.
+      attribute-set: cfg
+      flags: [ admin-perm ]
+      do:
+        request:
+          attributes:
+            - log-level
+    -
+      name: set-default-mark
+      doc: |
+        set the default skb mark value for DLM sockets.
+      attribute-set: cfg
+      flags: [ admin-perm ]
+      do:
+        request:
+          attributes:
+            - default-mark
+    -
+      name: set-recover-callbacks
+      doc: |
+        set feature for recover callbacks that is required for some kernel
+        DLM users.
+      attribute-set: cfg
+      flags: [ admin-perm ]
+      do:
+        request:
+          attributes:
+            - recover-callbacks
+
+mcast-groups:
+  list:
+    -
+      name: ls-event
diff --git a/fs/dlm/Makefile b/fs/dlm/Makefile
index c37f9fc361c6..05cd2fca2b1e 100644
--- a/fs/dlm/Makefile
+++ b/fs/dlm/Makefile
@@ -11,6 +11,8 @@ dlm-y :=			ast.o \
 				memory.o \
 				midcomms.o \
 				lowcomms.o \
+				nldlm.o \
+				nldlm-kernel.o \
 				plock.o \
 				rcom.o \
 				recover.o \
diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index 93d10b9e7483..bb7e2f9b6db8 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -91,11 +91,21 @@ int __init dlm_config_init(void)
 	if (rv)
 		return rv;
 
+	rv = dlm_nldlm_init();
+	if (rv)
+		goto err;
+
 	rv = dlm_configfs_init();
-	if (rv) {
-		unregister_pernet_subsys(&dlm_net_ops);
-		dlm_net_id = 0;
-	}
+	if (rv)
+		goto err_nldlm;
+
+	return rv;
+
+err_nldlm:
+	dlm_nldlm_exit();
+err:
+	unregister_pernet_subsys(&dlm_net_ops);
+	dlm_net_id = 0;
 
 	return rv;
 }
@@ -103,6 +113,8 @@ int __init dlm_config_init(void)
 void dlm_config_exit(void)
 {
 	dlm_configfs_exit();
+	dlm_nldlm_exit();
+
 	unregister_pernet_subsys(&dlm_net_ops);
 	dlm_net_id = 0;
 }
diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index 10fe3b59bd70..c1f85c9a6e77 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -813,6 +813,10 @@ extern struct workqueue_struct *dlm_wq;
 int dlm_plock_init(void);
 void dlm_plock_exit(void);
 
+int nldlm_ls_event(const struct dlm_ls *ls, uint32_t cmd);
+int __init dlm_nldlm_init(void);
+void dlm_nldlm_exit(void);
+
 #ifdef CONFIG_DLM_DEBUG
 void dlm_register_debugfs(void);
 void dlm_unregister_debugfs(void);
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index e5eeb3957b89..862d32774100 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -9,6 +9,7 @@
 *******************************************************************************
 ******************************************************************************/
 
+#include <uapi/linux/nldlm.h>
 #include <linux/netdevice.h>
 #include <linux/module.h>
 
@@ -205,10 +206,18 @@ static const struct kobj_type dlm_kset_ktype = {
 
 static int do_uevent(struct dlm_ls *ls, int in)
 {
-	if (in)
+	int rv;
+
+	if (in) {
 		kobject_uevent(&ls->ls_kobj, KOBJ_ONLINE);
-	else
+		rv = nldlm_ls_event(ls, NLDLM_CMD_NTF_NEW_LS);
+	} else {
 		kobject_uevent(&ls->ls_kobj, KOBJ_OFFLINE);
+		rv = nldlm_ls_event(ls, NLDLM_CMD_NTF_RELEASE_LS);
+	}
+
+	/* ignore if nldlm_ls_event() has no subscribers */
+	WARN_ON(rv && rv != -ESRCH);
 
 	log_rinfo(ls, "%s the lockspace group...", in ? "joining" : "leaving");
 
diff --git a/fs/dlm/netlink2.c b/fs/dlm/netlink2.c
new file mode 100644
index 000000000000..556a7b87db89
--- /dev/null
+++ b/fs/dlm/netlink2.c
@@ -0,0 +1,1330 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <net/genetlink.h>
+#include <net/sock.h>
+
+#include "dlm_internal.h"
+#include "lockspace.h"
+#include "midcomms.h"
+#include "config.h"
+#include "member.h"
+#include "lock.h"
+
+#include "nldlm.h"
+
+/* nldlm netlink family */
+static struct genl_family nldlm_genl_family;
+
+enum nldlm_multicast_groups {
+	NLDLM_MCGRP_CONFIG,
+	NLDLM_MCGRP_EVENT,
+};
+
+static const struct genl_multicast_group nldlm_mcgrps[] = {
+	[NLDLM_MCGRP_CONFIG] = { .name = "config", },
+	[NLDLM_MCGRP_EVENT] = { .name = "event", },
+};
+
+static int nldlm_put_ls(struct sk_buff *skb, const char *lsname,
+			int attrtype)
+{
+	struct nlattr *nl_ls;
+	int rv;
+
+	nl_ls = nla_nest_start(skb, attrtype);
+	if (!nl_ls)
+		return -ENOBUFS;
+
+	rv = nla_put_string(skb, NLDLM_LS_ATTR_NAME, lsname);
+	if (rv < 0) {
+		nla_nest_cancel(skb, nl_ls);
+		return rv;
+	}
+
+	nla_nest_end(skb, nl_ls);
+	return 0;
+}
+
+static int nldlm_put_ls_event(struct sk_buff *skb, const struct dlm_ls *ls,
+			      u32 portid, u32 seq, int flags, uint32_t cmd,
+			      uint32_t type)
+{
+	struct nlattr *nl_event;
+	void *hdr;
+	int rv;
+
+	hdr = genlmsg_put(skb, 0, 0, &nldlm_genl_family, 0, cmd);
+	if (!hdr)
+		return -ENOBUFS;
+
+	nl_event = nla_nest_start(skb, NLDLM_ATTR_LS_EVENT);
+	if (!nl_event)
+		return -ENOBUFS;
+
+	rv = nldlm_put_ls(skb, ls->ls_name, NLDLM_LS_EVENT_ATTR_LS);
+	if (rv < 0) {
+		nla_nest_cancel(skb, nl_event);
+		goto err;
+	}
+
+	rv = nla_put_u32(skb, NLDLM_LS_EVENT_ATTR_TYPE, type);
+	if (rv) {
+		nla_nest_cancel(skb, nl_event);
+		goto err;
+	}
+
+	nla_nest_end(skb, nl_event);
+	genlmsg_end(skb, hdr);
+	return 0;
+
+err:
+	genlmsg_cancel(skb, hdr);
+	return -ENOBUFS;
+}
+
+int nldlm_ls_event(const struct dlm_ls *ls, uint32_t type)
+{
+	struct sk_buff *skb;
+	int rv;
+
+	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	if (!skb)
+		return -ENOMEM;
+
+	rv = nldlm_put_ls_event(skb, ls, 0, 0, 0, NLDLM_CMD_LS_EVENT, type);
+	if (rv < 0) {
+		nlmsg_free(skb);
+		return rv;
+	}
+
+	return genlmsg_multicast_netns(&nldlm_genl_family, read_pnet(&ls->ls_dn->net), skb, 0,
+				       NLDLM_MCGRP_EVENT, GFP_ATOMIC);
+}
+
+static const struct nla_policy nldlm_ls_policy[NLDLM_LS_ATTR_MAX + 1] = {
+	[NLDLM_LS_ATTR_NAME] = { .type = NLA_NUL_STRING },
+};
+
+static int nldlm_parse_ls(const struct nlattr *nla, char *lsname)
+{
+	struct nlattr *ls_attrs[NLDLM_LS_ATTR_MAX + 1];
+
+	if (!nla)
+		return -EINVAL;
+
+	if (nla_parse_nested(ls_attrs, NLDLM_LS_ATTR_MAX, nla,
+			     nldlm_ls_policy, NULL))
+		return -EINVAL;
+
+	if (lsname) {
+		if (!ls_attrs[NLDLM_LS_ATTR_NAME])
+			return -EINVAL;
+
+		nla_strscpy(lsname, ls_attrs[NLDLM_LS_ATTR_NAME],
+			    DLM_LOCKSPACE_LEN);
+	}
+
+	return 0;
+}
+
+static int __nldlm_get_ls(struct sk_buff *skb, struct dlm_cfg_ls *ls,
+			  u32 portid, u32 seq, struct netlink_callback *cb,
+			  int flags)
+{
+	void *hdr;
+	int rv;
+
+	hdr = genlmsg_put(skb, portid, seq, &nldlm_genl_family, flags,
+			  NLDLM_CMD_GET_LS);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (cb)
+		genl_dump_check_consistent(cb, hdr);
+
+	rv = nldlm_put_ls(skb, ls->name, NLDLM_ATTR_LS);
+	if (rv < 0)
+		goto err;
+
+	genlmsg_end(skb, hdr);
+	return 0;
+
+err:
+	genlmsg_cancel(skb, hdr);
+	return rv;
+}
+
+static int nldlm_dump_ls(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(skb->sk));
+	unsigned int idx = cb->args[0];
+	struct dlm_cfg_ls *ls;
+	int rv;
+
+	mutex_lock(&dn->cfg_lock);
+	list_for_each_entry(ls, &dn->lockspaces, list) {
+		if (ls->idx < idx)
+			continue;
+
+		rv = __nldlm_get_ls(skb, ls, NETLINK_CB(cb->skb).portid,
+				    cb->nlh->nlmsg_seq, cb, NLM_F_MULTI);
+		if (rv < 0)
+			break;
+
+		idx = ls->idx + 1;
+	}
+	mutex_unlock(&dn->cfg_lock);
+
+	cb->args[0] = idx;
+	return skb->len;
+}
+
+static int nldlm_get_ls(struct sk_buff *msg, struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(msg->sk));
+	struct dlm_cfg_ls *ls = NULL, *ls_iter;
+	char lsname[DLM_LOCKSPACE_LEN];
+	struct sk_buff *skb;
+	int rv;
+
+	rv = nldlm_parse_ls(info->attrs[NLDLM_ATTR_LS], lsname);
+	if (rv < 0)
+		return rv;
+
+	mutex_lock(&dn->cfg_lock);
+	list_for_each_entry(ls_iter, &dn->lockspaces, list) {
+		if (!strncmp(ls_iter->name, lsname, DLM_LOCKSPACE_LEN)) {
+			ls = ls_iter;
+			break;
+		}
+	}
+
+	if (!ls) {
+		rv = -ENOENT;
+		goto err;
+	}
+
+	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	if (!skb) {
+		rv = -ENOMEM;
+		goto err;
+	}
+
+	rv = __nldlm_get_ls(skb, ls, info->snd_portid,
+			    info->snd_seq, NULL, 0);
+	if (rv < 0) {
+		nlmsg_free(skb);
+		goto err;
+	}
+
+	rv = genlmsg_reply(skb, info);
+
+err:
+	mutex_unlock(&dn->cfg_lock);
+	return rv;
+}
+
+static int nldlm_put_addr(struct sk_buff *skb, const struct sockaddr_storage *addr,
+			  int attrtype)
+{
+	struct nlattr *nl_addr;
+	int rv;
+
+	nl_addr = nla_nest_start(skb, attrtype);
+	if (!nl_addr)
+		return -ENOBUFS;
+
+	rv = nla_put_u16(skb, NLDLM_ADDR_ATTR_FAMILY, addr->ss_family);
+	if (rv) {
+		nla_nest_cancel(skb, nl_addr);
+		return -ENOBUFS;
+	}
+
+	switch (addr->ss_family) {
+	case AF_INET:
+		rv = nla_put_in_addr(skb, NLDLM_ADDR_ATTR_ADDR4,
+				     ((struct sockaddr_in *)addr)->sin_addr.s_addr);
+		if (rv) {
+			nla_nest_cancel(skb, nl_addr);
+			return -ENOBUFS;
+		}
+		break;
+	case AF_INET6:
+		rv = nla_put_in6_addr(skb, NLDLM_ADDR_ATTR_ADDR6,
+				      &((struct sockaddr_in6 *)addr)->sin6_addr);
+		if (rv) {
+			nla_nest_cancel(skb, nl_addr);
+			return -ENOBUFS;
+		}
+		break;
+	default:
+		nla_nest_cancel(skb, nl_addr);
+		return -EINVAL;
+	}
+
+	nla_nest_end(skb, nl_addr);
+	return 0;
+}
+
+static int nldlm_put_node(struct sk_buff *skb, struct dlm_cfg_node *nd,
+			  int attrtype)
+{
+	struct nlattr *nl_nd, *nl_addrs;
+	int rv, i;
+
+	nl_nd = nla_nest_start(skb, attrtype);
+	if (!nl_nd)
+		return -ENOBUFS;
+
+	rv = nla_put_le32(skb, NLDLM_NODE_ATTR_ID, cpu_to_le32(nd->id));
+	if (rv < 0) {
+		nla_nest_cancel(skb, nl_nd);
+		return rv;
+	}
+
+	nl_addrs = nla_nest_start(skb, NLDLM_NODE_ATTR_ADDRS);
+	if (!nl_addrs) {
+		nla_nest_cancel(skb, nl_nd);
+		return -ENOBUFS;
+	}
+
+	for (i = 0; i < nd->addrs_count; i++) {
+		rv = nldlm_put_addr(skb, &nd->addrs[i], i + 1);
+		if (rv) {
+			nla_nest_cancel(skb, nl_addrs);
+			nla_nest_cancel(skb, nl_nd);
+			return rv;
+		}
+	}
+
+	nla_nest_end(skb, nl_addrs);
+	nla_nest_end(skb, nl_nd);
+	return 0;
+}
+
+static int __nldlm_get_node(struct sk_buff *skb, struct dlm_cfg_node *nd,
+			    u32 portid, u32 seq,
+			    struct netlink_callback *cb, int flags)
+{
+	void *hdr;
+	int rv;
+
+	hdr = genlmsg_put(skb, portid, seq, &nldlm_genl_family, flags,
+			  NLDLM_CMD_GET_NODE);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (cb)
+		genl_dump_check_consistent(cb, hdr);
+
+	rv = nldlm_put_node(skb, nd, NLDLM_ATTR_NODE);
+	if (rv < 0)
+		goto err;
+
+	genlmsg_end(skb, hdr);
+	return 0;
+
+err:
+	genlmsg_cancel(skb, hdr);
+	return rv;
+}
+
+static const struct nla_policy
+nldlm_addr_policy[NLDLM_ADDR_ATTR_MAX + 1] = {
+	[NLDLM_ADDR_ATTR_FAMILY] = { .type = NLA_U16 },
+	[NLDLM_ADDR_ATTR_ADDR4] = { .type = NLA_BE32 },
+	[NLDLM_ADDR_ATTR_ADDR6] = { .type = NLA_BINARY,
+				    .len = sizeof(struct in6_addr)},
+};
+
+static int nldlm_parse_addr(const struct nlattr *nla, struct sockaddr_storage *addr)
+{
+	struct nlattr *addr_attrs[NLDLM_ADDR_ATTR_MAX + 1];
+
+	if (nla_parse_nested(addr_attrs, NLDLM_ADDR_ATTR_MAX, nla,
+			     nldlm_addr_policy, NULL))
+		return -EINVAL;
+
+	if (!addr_attrs[NLDLM_ADDR_ATTR_FAMILY])
+		return -EINVAL;
+
+	addr->ss_family = nla_get_u16(addr_attrs[NLDLM_ADDR_ATTR_FAMILY]);
+	switch (addr->ss_family) {
+	case AF_INET:
+		if (!addr_attrs[NLDLM_ADDR_ATTR_ADDR4])
+			return -EINVAL;
+
+		((struct sockaddr_in *)addr)->sin_addr.s_addr =
+			nla_get_in_addr(addr_attrs[NLDLM_ADDR_ATTR_ADDR4]);
+		break;
+	case AF_INET6:
+		if (!addr_attrs[NLDLM_ADDR_ATTR_ADDR6])
+			return -EINVAL;
+
+		((struct sockaddr_in6 *)addr)->sin6_addr =
+			nla_get_in6_addr(addr_attrs[NLDLM_ADDR_ATTR_ADDR6]);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static const struct nla_policy
+nldlm_node_policy[NLDLM_NODE_ATTR_MAX + 1] = {
+	[NLDLM_NODE_ATTR_ID] = { .type = NLA_U32 },
+	[NLDLM_NODE_ATTR_MARK] = { .type = NLA_U32 },
+	[NLDLM_NODE_ATTR_ADDRS] = { .type = NLA_NESTED },
+};
+
+static int nldlm_parse_node(const struct nlattr *nla, __le32 *nodeid,
+			    struct sockaddr_storage *addrs, size_t *addrs_count,
+			    uint32_t *mark)
+{
+	struct nlattr *nd_attrs[NLDLM_NODE_ATTR_MAX + 1];
+	int rem, rv;
+
+	if (!nla)
+		return -EINVAL;
+
+	if (nla_parse_nested(nd_attrs, NLDLM_NODE_ATTR_MAX, nla,
+			     nldlm_node_policy, NULL))
+		return -EINVAL;
+
+	if (nodeid) {
+		if (!nd_attrs[NLDLM_NODE_ATTR_ID])
+			return -EINVAL;
+
+		*nodeid = nla_get_le32(nd_attrs[NLDLM_NODE_ATTR_ID]);
+	}
+
+	if (addrs && addrs_count) {
+		if (!nd_attrs[NLDLM_NODE_ATTR_ADDRS])
+			return -EINVAL;
+
+		*addrs_count = 0;
+		nla_for_each_nested(nla, nd_attrs[NLDLM_NODE_ATTR_ADDRS], rem) {
+			if (*addrs_count == DLM_MAX_ADDR_COUNT)
+				return -ENOSPC;
+
+			rv = nldlm_parse_addr(nla, &addrs[*addrs_count]);
+			if (rv)
+				return rv;
+
+			(*addrs_count)++;
+		}
+	}
+
+	if (mark) {
+		if (nd_attrs[NLDLM_NODE_ATTR_MARK])
+			*mark = nla_get_u32(nd_attrs[NLDLM_NODE_ATTR_MARK]);
+		else
+			*mark = DLM_DEFAULT_MARK;
+	}
+
+	return 0;
+}
+
+static int nldlm_get_node(struct sk_buff *msg, struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(msg->sk));
+	struct dlm_cfg_node *nd;
+	struct sk_buff *skb;
+	__le32 nodeid;
+	int rv;
+
+	rv = nldlm_parse_node(info->attrs[NLDLM_ATTR_NODE], &nodeid, NULL, NULL,
+			      NULL);
+	if (rv)
+		return rv;
+
+	mutex_lock(&dn->cfg_lock);
+	nd = dlm_cfg_get_node(dn, le32_to_cpu(nodeid));
+	if (!nd) {
+		rv = -ENOENT;
+		goto out;
+	}
+
+	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	if (!skb) {
+		rv = -ENOMEM;
+		goto out;
+	}
+
+	rv = __nldlm_get_node(skb, nd, info->snd_portid,
+			      info->snd_seq, NULL, 0);
+	if (rv < 0) {
+		nlmsg_free(skb);
+		goto out;
+	}
+
+	rv = genlmsg_reply(skb, info);
+
+out:
+	mutex_unlock(&dn->cfg_lock);
+	return rv;
+}
+
+static int nldlm_dump_nodes(struct sk_buff *skb,
+			    struct netlink_callback *cb)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(skb->sk));
+	unsigned int idx = cb->args[0];
+	struct dlm_cfg_node *nd;
+	int rv;
+
+	mutex_lock(&dn->cfg_lock);
+	list_for_each_entry(nd, &dn->nodes, list) {
+		if (nd->idx < idx)
+			continue;
+
+		rv = __nldlm_get_node(skb, nd, NETLINK_CB(cb->skb).portid,
+				      cb->nlh->nlmsg_seq, cb, NLM_F_MULTI);
+		if (rv < 0)
+			break;
+
+		idx = nd->idx + 1;
+	}
+	mutex_unlock(&dn->cfg_lock);
+
+	cb->args[0] = idx;
+	return skb->len;
+}
+
+static int nldlm_new_node(struct sk_buff *msg, struct genl_info *info)
+{
+	struct sockaddr_storage addrs[DLM_MAX_ADDR_COUNT] = {};
+	struct dlm_net *dn = dlm_pernet(sock_net(msg->sk));
+	size_t addrs_count;
+	uint32_t mark;
+	__le32 nodeid;
+	int rv;
+
+	rv = nldlm_parse_node(info->attrs[NLDLM_ATTR_NODE], &nodeid,
+			      addrs, &addrs_count, &mark);
+	if (rv < 0)
+		return rv;
+
+	return dlm_cfg_new_node(dn, le32_to_cpu(nodeid), mark, addrs,
+				addrs_count);
+}
+
+static int nldlm_del_node(struct sk_buff *msg, struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(msg->sk));
+	__le32 nodeid;
+	int rv;
+
+	rv = nldlm_parse_node(info->attrs[NLDLM_ATTR_NODE], &nodeid, NULL,
+			      NULL, NULL);
+	if (rv < 0)
+		return rv;
+
+	return dlm_cfg_del_node(dn, le32_to_cpu(nodeid));
+}
+
+static int nldlm_put_member(struct sk_buff *skb,
+			    const struct dlm_cfg_member *mb, int attrtype)
+{
+	struct nlattr *nl_mb;
+	int rv;
+
+	nl_mb = nla_nest_start(skb, NLDLM_ATTR_LS_MEMBER);
+	if (!nl_mb)
+		return -ENOBUFS;
+
+	rv = nldlm_put_ls(skb, mb->ls->name, NLDLM_LS_MEMBER_ATTR_LS);
+	if (rv < 0) {
+		nla_nest_cancel(skb, nl_mb);
+		return rv;
+	}
+
+	rv = nldlm_put_node(skb, mb->nd, NLDLM_LS_MEMBER_ATTR_NODE);
+	if (rv < 0) {
+		nla_nest_cancel(skb, nl_mb);
+		return rv;
+	}
+
+	rv = nla_put_u32(skb, NLDLM_LS_MEMBER_ATTR_WEIGHT, mb->weight);
+	if (rv < 0) {
+		nla_nest_cancel(skb, nl_mb);
+		return rv;
+	}
+
+	nla_nest_end(skb, nl_mb);
+	return 0;
+}
+
+static int __nldlm_get_member(struct sk_buff *skb,
+			      const struct dlm_cfg_member *mb,
+			      u32 portid, u32 seq,
+			      struct netlink_callback *cb, int flags)
+{
+	void *hdr;
+	int rv;
+
+	hdr = genlmsg_put(skb, portid, seq, &nldlm_genl_family, flags,
+			  NLDLM_CMD_GET_LS_MEMBER);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (cb)
+		genl_dump_check_consistent(cb, hdr);
+
+	rv = nldlm_put_member(skb, mb, NLDLM_ATTR_LS_MEMBER);
+	if (rv < 0)
+		goto err;
+
+	genlmsg_end(skb, hdr);
+	return 0;
+
+err:
+	genlmsg_cancel(skb, hdr);
+	return rv;
+}
+
+static const struct nla_policy nldlm_member_policy[NLDLM_LS_MEMBER_ATTR_MAX + 1] = {
+	[NLDLM_LS_MEMBER_ATTR_LS] = { .type = NLA_NESTED },
+	[NLDLM_LS_MEMBER_ATTR_NODE] = { .type = NLA_NESTED },
+	[NLDLM_LS_MEMBER_ATTR_WEIGHT] = { .type = NLA_U32 },
+};
+
+static int nldlm_parse_member(const struct nlattr *nla, char *lsname,
+			      __le32 *nodeid, uint32_t *weight)
+{
+	struct nlattr *member_attrs[NLDLM_LS_MEMBER_ATTR_MAX + 1];
+	int rv;
+
+	if (!nla)
+		return -EINVAL;
+
+	if (nla_parse_nested(member_attrs, NLDLM_LS_MEMBER_ATTR_MAX, nla,
+			     nldlm_member_policy, NULL))
+		return -EINVAL;
+
+	if (lsname) {
+		rv = nldlm_parse_ls(member_attrs[NLDLM_LS_MEMBER_ATTR_LS],
+				    lsname);
+		if (rv)
+			return rv;
+	}
+
+	if (nodeid) {
+		rv = nldlm_parse_node(member_attrs[NLDLM_LS_MEMBER_ATTR_NODE],
+				      nodeid, NULL, NULL, NULL);
+		if (rv)
+			return rv;
+	}
+
+	if (weight) {
+		if (member_attrs[NLDLM_LS_MEMBER_ATTR_WEIGHT])
+			*weight = nla_get_u32(member_attrs[NLDLM_LS_MEMBER_ATTR_WEIGHT]);
+		else
+			*weight = DLM_DEFAULT_WEIGHT;
+	}
+
+	return 0;
+}
+
+static int nldlm_get_member(struct sk_buff *msg, struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(msg->sk));
+	char lsname[DLM_LOCKSPACE_LEN];
+	struct dlm_cfg_member *mb;
+	struct sk_buff *skb;
+	__le32 nodeid;
+	int rv;
+
+	rv = nldlm_parse_member(info->attrs[NLDLM_ATTR_LS_MEMBER], lsname,
+				&nodeid, NULL);
+	if (rv < 0)
+		return rv;
+
+	mutex_lock(&dn->cfg_lock);
+	mb = dlm_cfg_get_ls_member(dn, lsname, le32_to_cpu(nodeid));
+	if (!mb) {
+		rv = -ENOENT;
+		goto out;
+	}
+
+	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	if (!skb) {
+		rv = -ENOMEM;
+		goto out;
+	}
+
+	rv = __nldlm_get_member(skb, mb, info->snd_portid,
+				info->snd_seq, NULL, 0);
+	if (rv < 0) {
+		nlmsg_free(skb);
+		goto out;
+	}
+
+	rv = genlmsg_reply(skb, info);
+
+out:
+	mutex_unlock(&dn->cfg_lock);
+	return rv;
+}
+
+static int nldlm_dump_members(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	const struct genl_info *info = genl_info_dump(cb);
+	struct dlm_net *dn = dlm_pernet(sock_net(skb->sk));
+	unsigned int idx = cb->args[0];
+	char lsname[DLM_LOCKSPACE_LEN];
+	struct dlm_cfg_member *mb;
+	struct dlm_cfg_ls *ls;
+	int rv;
+
+	rv = nldlm_parse_ls(info->attrs[NLDLM_ATTR_LS], lsname);
+	if (rv < 0)
+		return rv;
+
+	mutex_lock(&dn->cfg_lock);
+	ls = dlm_cfg_get_ls(dn, lsname);
+	if (!ls) {
+		mutex_unlock(&dn->cfg_lock);
+		return -ENOENT;
+	}
+
+	list_for_each_entry(mb, &ls->members, list) {
+		if (mb->idx < idx)
+			continue;
+
+		rv = __nldlm_get_member(skb, mb, NETLINK_CB(cb->skb).portid,
+					cb->nlh->nlmsg_seq, cb, NLM_F_MULTI);
+		if (rv < 0)
+			break;
+
+		idx = mb->idx + 1;
+	}
+	mutex_unlock(&dn->cfg_lock);
+
+	cb->args[0] = idx;
+	return skb->len;
+}
+
+static int nldlm_ls_member_add(struct sk_buff *msg, struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(msg->sk));
+	char lsname[DLM_LOCKSPACE_LEN];
+	uint32_t weight;
+	__le32 nodeid;
+	int rv;
+
+	rv = nldlm_parse_member(info->attrs[NLDLM_ATTR_LS_MEMBER], lsname,
+				&nodeid, &weight);
+	if (rv < 0)
+		return rv;
+
+	return dlm_cfg_add_member(dn, lsname, le32_to_cpu(nodeid), weight);
+}
+
+static int nldlm_ls_member_del(struct sk_buff *msg, struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(msg->sk));
+	char lsname[DLM_LOCKSPACE_LEN];
+	__le32 nodeid;
+	int rv;
+
+	rv = nldlm_parse_member(info->attrs[NLDLM_ATTR_LS_MEMBER], lsname,
+				&nodeid, NULL);
+	if (rv < 0)
+		return rv;
+
+	return dlm_cfg_del_member(dn, lsname, le32_to_cpu(nodeid));
+}
+
+static const struct nla_policy
+nldlm_ls_event_policy[NLDLM_LS_EVENT_ATTR_MAX + 1] = {
+	[NLDLM_LS_EVENT_ATTR_LS] = { .type = NLA_NESTED },
+	[NLDLM_LS_EVENT_ATTR_TYPE] = { .type = NLA_U32 },
+	[NLDLM_LS_EVENT_ATTR_CTRL] = { .type = NLA_U32 },
+	[NLDLM_LS_EVENT_ATTR_RESULT] = { .type = NLA_U32 },
+};
+
+static int nldlm_parse_ls_event(const struct nlattr *nla, char *lsname,
+				uint32_t *type, uint32_t *ctrl,
+				uint32_t *result)
+{
+	struct nlattr *ls_event_attrs[NLDLM_LS_EVENT_ATTR_MAX + 1];
+	int rv;
+
+	if (!nla)
+		return -EINVAL;
+
+	if (nla_parse_nested(ls_event_attrs, NLDLM_LS_EVENT_ATTR_MAX, nla,
+			     nldlm_ls_event_policy, NULL))
+		return -EINVAL;
+
+	if (lsname) {
+		rv = nldlm_parse_ls(ls_event_attrs[NLDLM_LS_EVENT_ATTR_LS],
+				    lsname);
+		if (rv < 0)
+			return -EINVAL;
+	}
+
+	if (type) {
+		if (!ls_event_attrs[NLDLM_LS_EVENT_ATTR_TYPE])
+			return -EINVAL;
+
+		*type = nla_get_u32(ls_event_attrs[NLDLM_LS_EVENT_ATTR_TYPE]);
+	}
+
+	if (ctrl) {
+		if (!ls_event_attrs[NLDLM_LS_EVENT_ATTR_CTRL])
+			return -EINVAL;
+
+		*ctrl = nla_get_u32(ls_event_attrs[NLDLM_LS_EVENT_ATTR_CTRL]);
+	}
+
+	if (result) {
+		if (!ls_event_attrs[NLDLM_LS_EVENT_ATTR_RESULT])
+			return -EINVAL;
+
+		*result = nla_get_u32(ls_event_attrs[NLDLM_LS_EVENT_ATTR_RESULT]);
+	}
+
+	return 0;
+}
+
+static int nldlm_ls_event_done(struct sk_buff *msg, struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(msg->sk));
+	char lsname[DLM_LOCKSPACE_LEN];
+	struct dlm_ls *ls;
+	uint32_t result;
+	int rv;
+
+	rv = nldlm_parse_ls_event(info->attrs[NLDLM_ATTR_LS_EVENT],
+				  lsname, NULL, NULL, &result);
+	if (rv < 0)
+		return rv;
+
+	ls = dlm_find_lockspace_name(dn, lsname);
+	if (!ls)
+		return -ENOENT;
+
+	switch (result) {
+	case NLDLM_EVENT_MEMBER_SUCCESS:
+		rv = 0;
+		break;
+	case NLDLM_EVENT_MEMBER_FAILURE:
+		rv = -1;
+		break;
+	default:
+		dlm_put_lockspace(ls);
+		return -EINVAL;
+	}
+
+	ls->ls_uevent_result = rv;
+	set_bit(LSFL_UEVENT_WAIT, &ls->ls_flags);
+	wake_up(&ls->ls_uevent_wait);
+
+	dlm_put_lockspace(ls);
+	return 0;
+}
+
+static int nldlm_ls_control(struct sk_buff *msg, struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(msg->sk));
+	char lsname[DLM_LOCKSPACE_LEN];
+	struct dlm_ls *ls;
+	uint32_t ctrl;
+	int rv;
+
+	rv = nldlm_parse_ls_event(info->attrs[NLDLM_ATTR_LS_EVENT],
+				  lsname, NULL, &ctrl, NULL);
+	if (rv < 0)
+		return rv;
+
+	ls = dlm_find_lockspace_name(dn, lsname);
+	if (!ls)
+		return -ENOENT;
+
+	switch (ctrl) {
+	case NLDLM_LS_CTRL_STOP:
+		dlm_ls_stop(ls);
+		break;
+	case NLDLM_LS_CTRL_START:
+		dlm_ls_start(ls);
+		break;
+	default:
+		rv = -EINVAL;
+		break;
+	}
+
+	dlm_put_lockspace(ls);
+	return rv;
+}
+
+static int nldlm_get_config(struct sk_buff *msg, struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(msg->sk));
+	struct nlattr *nl_cfg;
+	struct sk_buff *skb;
+	uint32_t log_level;
+	void *hdr;
+	int rv;
+
+	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	if (!skb) {
+		mutex_unlock(&dn->cfg_lock);
+		return -ENOMEM;
+	}
+
+	hdr = genlmsg_put(skb, info->snd_portid, info->snd_seq,
+			  &nldlm_genl_family, 0, NLDLM_CMD_GET_CONFIG);
+	if (!hdr) {
+		nlmsg_free(skb);
+		return -EMSGSIZE;
+	}
+
+	nl_cfg = nla_nest_start(skb, NLDLM_ATTR_CFG);
+	if (!nl_cfg) {
+		nlmsg_free(skb);
+		return -ENOBUFS;
+	}
+
+	mutex_lock(&dn->cfg_lock);
+	if (dn->our_node) {
+		rv = nldlm_put_node(skb, dn->our_node,
+				    NLDLM_CFG_ATTR_OUR_NODE);
+		if (rv < 0)
+			goto err;
+	}
+
+	rv = nla_put_string(skb, NLDLM_CFG_ATTR_CLUSTER_NAME,
+			    dn->config.ci_cluster_name);
+	if (rv < 0)
+		goto err;
+
+	rv = nla_put_u32(skb, NLDLM_CFG_ATTR_PROTOCOL,
+			 dn->config.ci_protocol);
+	if (rv < 0)
+		goto err;
+
+	rv = nla_put_be16(skb, NLDLM_CFG_ATTR_PORT,
+			  dn->config.ci_tcp_port);
+	if (rv < 0)
+		goto err;
+
+	if (!dn->config.ci_log_info)
+		log_level = NLDLM_LOG_LEVEL_NONE;
+	else if (dn->config.ci_log_info)
+		log_level = NLDLM_LOG_LEVEL_INFO;
+	else if (dn->config.ci_log_debug)
+		log_level = NLDLM_LOG_LEVEL_DEBUG;
+
+	rv = nla_put_u32(skb, NLDLM_CFG_ATTR_LOG_LEVEL, log_level);
+	if (rv < 0)
+		goto err;
+
+	rv = nla_put_u32(skb, NLDLM_CFG_ATTR_RECOVER_TIMEOUT,
+			 dn->config.ci_recover_timer);
+	if (rv < 0)
+		goto err;
+
+	rv = nla_put_u32(skb, NLDLM_CFG_ATTR_INACTIVE_TIMEOUT,
+			 dn->config.ci_toss_secs);
+	if (rv < 0)
+		goto err;
+
+	rv = nla_put_u32(skb, NLDLM_CFG_ATTR_DEFAULT_MARK,
+			 dn->config.ci_mark);
+	if (rv < 0)
+		goto err;
+
+	if (dn->config.ci_recover_callbacks) {
+		rv = nla_put_flag(skb, NLDLM_CFG_ATTR_RECOVER_CALLBACKS);
+		if (rv < 0)
+			goto err;
+	}
+
+	mutex_unlock(&dn->cfg_lock);
+	nla_nest_end(skb, nl_cfg);
+	genlmsg_end(skb, hdr);
+	return genlmsg_reply(skb, info);
+
+err:
+	mutex_unlock(&dn->cfg_lock);
+	nla_nest_cancel(skb, nl_cfg);
+	genlmsg_cancel(skb, hdr);
+	nlmsg_free(skb);
+	return rv;
+}
+
+static const struct nla_policy nldlm_cfg_policy[NLDLM_CFG_ATTR_MAX + 1] = {
+	[NLDLM_CFG_ATTR_OUR_NODE] = { .type = NLA_NESTED },
+	[NLDLM_CFG_ATTR_CLUSTER_NAME] = { .type = NLA_NUL_STRING },
+	[NLDLM_CFG_ATTR_PROTOCOL] = { .type = NLA_U32 },
+	[NLDLM_CFG_ATTR_PORT] = { .type = NLA_BE16 },
+	[NLDLM_CFG_ATTR_RECOVER_TIMEOUT] = { .type = NLA_U32 },
+	[NLDLM_CFG_ATTR_INACTIVE_TIMEOUT] = { .type = NLA_U32 },
+	[NLDLM_CFG_ATTR_LOG_LEVEL] = { .type = NLA_U32 },
+	[NLDLM_CFG_ATTR_DEFAULT_MARK] = { .type = NLA_U32 },
+	[NLDLM_CFG_ATTR_RECOVER_CALLBACKS] = { .type = NLA_FLAG },
+};
+
+static int nldlm_set_cluster_name(struct sk_buff *msg, struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(msg->sk));
+	struct nlattr *cfg_attrs[NLDLM_CFG_ATTR_MAX + 1];
+
+	if (!info->attrs[NLDLM_ATTR_CFG])
+		return -EINVAL;
+
+	if (nla_parse_nested(cfg_attrs, NLDLM_CFG_ATTR_MAX,
+			     info->attrs[NLDLM_ATTR_CFG],
+			     nldlm_cfg_policy, NULL))
+		return -EINVAL;
+
+	if (!cfg_attrs[NLDLM_CFG_ATTR_CLUSTER_NAME])
+		return -EINVAL;
+
+	mutex_lock(&dn->cfg_lock);
+	nla_strscpy(dn->config.ci_cluster_name,
+		    cfg_attrs[NLDLM_CFG_ATTR_CLUSTER_NAME],
+		    DLM_LOCKSPACE_LEN);
+	mutex_unlock(&dn->cfg_lock);
+	return 0;
+}
+
+static int nldlm_set_our_node_id(struct sk_buff *msg, struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(msg->sk));
+	struct nlattr *node_attrs[NLDLM_NODE_ATTR_MAX + 1];
+	struct nlattr *cfg_attrs[NLDLM_CFG_ATTR_MAX + 1];
+	__le32 nodeid;
+
+	if (!info->attrs[NLDLM_ATTR_CFG])
+		return -EINVAL;
+
+	if (nla_parse_nested(cfg_attrs, NLDLM_CFG_ATTR_MAX,
+			     info->attrs[NLDLM_ATTR_CFG],
+			     nldlm_cfg_policy, NULL))
+		return -EINVAL;
+
+	if (!cfg_attrs[NLDLM_CFG_ATTR_OUR_NODE])
+		return -EINVAL;
+
+	if (nla_parse_nested(node_attrs, NLDLM_NODE_ATTR_MAX,
+			     cfg_attrs[NLDLM_CFG_ATTR_OUR_NODE],
+			     nldlm_node_policy, NULL))
+		return -EINVAL;
+
+	nodeid = nla_get_le32(node_attrs[NLDLM_NODE_ATTR_ID]);
+	return dlm_cfg_set_our_node(dn, le32_to_cpu(nodeid));
+}
+
+static int nldlm_set_protocol(struct sk_buff *msg, struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(msg->sk));
+	struct nlattr *cfg_attrs[NLDLM_CFG_ATTR_MAX + 1];
+	uint32_t protocol;
+
+	if (!info->attrs[NLDLM_ATTR_CFG])
+		return -EINVAL;
+
+	if (nla_parse_nested(cfg_attrs, NLDLM_CFG_ATTR_MAX,
+			     info->attrs[NLDLM_ATTR_CFG],
+			     nldlm_cfg_policy, NULL))
+		return -EINVAL;
+
+	if (!cfg_attrs[NLDLM_CFG_ATTR_PROTOCOL])
+		return -EINVAL;
+
+	protocol = nla_get_u32(cfg_attrs[NLDLM_CFG_ATTR_PROTOCOL]);
+	return dlm_cfg_set_protocol(dn, protocol);
+}
+
+static int nldlm_set_port(struct sk_buff *msg, struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(msg->sk));
+	struct nlattr *cfg_attrs[NLDLM_CFG_ATTR_MAX + 1];
+	__be16 port;
+
+	if (!info->attrs[NLDLM_ATTR_CFG])
+		return -EINVAL;
+
+	if (nla_parse_nested(cfg_attrs, NLDLM_CFG_ATTR_MAX,
+			     info->attrs[NLDLM_ATTR_CFG],
+			     nldlm_cfg_policy, NULL))
+		return -EINVAL;
+
+	if (!cfg_attrs[NLDLM_CFG_ATTR_PORT])
+		return -EINVAL;
+
+	port = nla_get_be16(cfg_attrs[NLDLM_CFG_ATTR_PORT]);
+	return dlm_cfg_set_port(dn, port);
+}
+
+static int nldlm_set_log_level(struct sk_buff *msg, struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(msg->sk));
+	struct nlattr *cfg_attrs[NLDLM_CFG_ATTR_MAX + 1];
+	uint32_t level;
+
+	if (!info->attrs[NLDLM_ATTR_CFG])
+		return -EINVAL;
+
+	if (nla_parse_nested(cfg_attrs, NLDLM_CFG_ATTR_MAX,
+			     info->attrs[NLDLM_ATTR_CFG],
+			     nldlm_cfg_policy, NULL))
+		return -EINVAL;
+
+	if (!cfg_attrs[NLDLM_CFG_ATTR_LOG_LEVEL])
+		return -EINVAL;
+
+	level = nla_get_u32(cfg_attrs[NLDLM_CFG_ATTR_LOG_LEVEL]);
+	switch (level) {
+	case NLDLM_LOG_LEVEL_NONE:
+		dlm_cfg_set_log_info(dn, 0);
+		dlm_cfg_set_log_debug(dn, 0);
+		break;
+	case NLDLM_LOG_LEVEL_INFO:
+		dlm_cfg_set_log_info(dn, 1);
+		dlm_cfg_set_log_debug(dn, 0);
+		break;
+	case NLDLM_LOG_LEVEL_DEBUG:
+		dlm_cfg_set_log_info(dn, 1);
+		dlm_cfg_set_log_debug(dn, 1);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int nldlm_set_inactive_timeout(struct sk_buff *msg,
+				      struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(msg->sk));
+	struct nlattr *cfg_attrs[NLDLM_CFG_ATTR_MAX + 1];
+	uint32_t secs;
+
+	if (!info->attrs[NLDLM_ATTR_CFG])
+		return -EINVAL;
+
+	if (nla_parse_nested(cfg_attrs, NLDLM_CFG_ATTR_MAX,
+			     info->attrs[NLDLM_ATTR_CFG],
+			     nldlm_cfg_policy, NULL))
+		return -EINVAL;
+
+	if (!cfg_attrs[NLDLM_CFG_ATTR_INACTIVE_TIMEOUT])
+		return -EINVAL;
+
+	secs = nla_get_u32(cfg_attrs[NLDLM_CFG_ATTR_INACTIVE_TIMEOUT]);
+	return dlm_cfg_set_toss_secs(dn, secs);
+}
+
+static int nldlm_set_recover_timeout(struct sk_buff *msg, struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(msg->sk));
+	struct nlattr *cfg_attrs[NLDLM_CFG_ATTR_MAX + 1];
+	uint32_t secs;
+
+	if (!info->attrs[NLDLM_ATTR_CFG])
+		return -EINVAL;
+
+	if (nla_parse_nested(cfg_attrs, NLDLM_CFG_ATTR_MAX,
+			     info->attrs[NLDLM_ATTR_CFG],
+			     nldlm_cfg_policy, NULL))
+		return -EINVAL;
+
+	if (!cfg_attrs[NLDLM_CFG_ATTR_RECOVER_TIMEOUT])
+		return -EINVAL;
+
+	secs = nla_get_u32(cfg_attrs[NLDLM_CFG_ATTR_RECOVER_TIMEOUT]);
+	return dlm_cfg_set_recover_timer(dn, secs);
+}
+
+static int nldlm_set_default_mark(struct sk_buff *msg, struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(msg->sk));
+	struct nlattr *cfg_attrs[NLDLM_CFG_ATTR_MAX + 1];
+	uint32_t mark;
+
+	if (!info->attrs[NLDLM_ATTR_CFG])
+		return -EINVAL;
+
+	if (nla_parse_nested(cfg_attrs, NLDLM_CFG_ATTR_MAX,
+			     info->attrs[NLDLM_ATTR_CFG],
+			     nldlm_cfg_policy, NULL))
+		return -EINVAL;
+
+	if (!cfg_attrs[NLDLM_CFG_ATTR_DEFAULT_MARK])
+		return -EINVAL;
+
+	mark = nla_get_u32(cfg_attrs[NLDLM_CFG_ATTR_DEFAULT_MARK]);
+	return dlm_cfg_set_mark(dn, mark);
+}
+
+static int nldlm_set_cap_recover_callbacks(struct sk_buff *msg, struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(msg->sk));
+	struct nlattr *cfg_attrs[NLDLM_CFG_ATTR_MAX + 1];
+	int on;
+
+	if (!info->attrs[NLDLM_ATTR_CFG])
+		return -EINVAL;
+
+	if (nla_parse_nested(cfg_attrs, NLDLM_CFG_ATTR_MAX,
+			     info->attrs[NLDLM_ATTR_CFG],
+			     nldlm_cfg_policy, NULL))
+		return -EINVAL;
+
+	on = nla_get_flag(cfg_attrs[NLDLM_CFG_ATTR_RECOVER_CALLBACKS]);
+	return dlm_cfg_set_recover_callbacks(dn, on);
+}
+
+static const struct nla_policy nldlm_policy[NLDLM_ATTR_MAX + 1] = {
+	[NLDLM_ATTR_LS] = { .type = NLA_NESTED },
+	[NLDLM_ATTR_LS_MEMBER] = { .type = NLA_NESTED },
+	[NLDLM_ATTR_LS_EVENT] = { .type = NLA_NESTED },
+	[NLDLM_ATTR_NODE] = { .type = NLA_NESTED },
+};
+
+static const struct genl_ops nldlm_ops[] = {
+	{
+		.cmd = NLDLM_CMD_GET_LS,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP_STRICT,
+		.doit = nldlm_get_ls,
+		.dumpit = nldlm_dump_ls,
+	},
+	{
+		.cmd = NLDLM_CMD_GET_NODE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP_STRICT,
+		.doit = nldlm_get_node,
+		.dumpit = nldlm_dump_nodes,
+	},
+	{
+		.cmd = NLDLM_CMD_NEW_NODE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit = nldlm_new_node,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NLDLM_CMD_DEL_NODE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit = nldlm_del_node,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NLDLM_CMD_GET_LS_MEMBER,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP_STRICT,
+		.doit = nldlm_get_member,
+		.dumpit = nldlm_dump_members,
+	},
+	{
+		.cmd = NLDLM_CMD_LS_EVENT_ADD_MEMBER,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit = nldlm_ls_member_add,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NLDLM_CMD_LS_EVENT_DEL_MEMBER,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit = nldlm_ls_member_del,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NLDLM_CMD_LS_EVENT_DONE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit = nldlm_ls_event_done,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NLDLM_CMD_LS_EVENT_CTRL,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit = nldlm_ls_control,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NLDLM_CMD_GET_CONFIG,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit = nldlm_get_config,
+	},
+	{
+		.cmd = NLDLM_CMD_SET_CLUSTER_NAME,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit = nldlm_set_cluster_name,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NLDLM_CMD_SET_OUR_NODE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit = nldlm_set_our_node_id,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NLDLM_CMD_SET_PROTOCOL,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit = nldlm_set_protocol,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NLDLM_CMD_SET_PORT,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit = nldlm_set_port,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NLDLM_CMD_SET_LOG_LEVEL,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit = nldlm_set_log_level,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NLDLM_CMD_SET_INACTIVE_TIMEOUT,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit = nldlm_set_inactive_timeout,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NLDLM_CMD_SET_RECOVER_TIMEOUT,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit = nldlm_set_recover_timeout,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NLDLM_CMD_SET_DEFAULT_MARK,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit = nldlm_set_default_mark,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NLDLM_CMD_SET_RECOVER_CALLBACKS,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit = nldlm_set_cap_recover_callbacks,
+		.flags = GENL_ADMIN_PERM,
+	},
+};
+
+static struct genl_family nldlm_genl_family __ro_after_init = {
+	.name = NLDLM_GENL_NAME,
+	.version = 1,
+	.maxattr = NLDLM_ATTR_MAX,
+	.policy = nldlm_policy,
+	.netnsok = true,
+	.parallel_ops = true,
+	.module = THIS_MODULE,
+	.ops = nldlm_ops,
+	.n_ops = ARRAY_SIZE(nldlm_ops),
+	.resv_start_op = NLDLM_CMD_MAX + 1,
+	.mcgrps = nldlm_mcgrps,
+	.n_mcgrps = ARRAY_SIZE(nldlm_mcgrps),
+};
+
+int __init dlm_nldlm_init(void)
+{
+	return genl_register_family(&nldlm_genl_family);
+}
+
+void dlm_nldlm_exit(void)
+{
+	genl_unregister_family(&nldlm_genl_family);
+}
diff --git a/fs/dlm/nldlm-kernel.c b/fs/dlm/nldlm-kernel.c
new file mode 100644
index 000000000000..9bf418b3420f
--- /dev/null
+++ b/fs/dlm/nldlm-kernel.c
@@ -0,0 +1,290 @@
+// SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+/* Do not edit directly, auto-generated from: */
+/*	Documentation/netlink/specs/nldlm.yaml */
+/* YNL-GEN kernel source */
+
+#include <net/netlink.h>
+#include <net/genetlink.h>
+
+#include "nldlm-kernel.h"
+
+#include <uapi/linux/nldlm.h>
+
+/* Common nested types */
+const struct nla_policy nldlm_addr_nl_policy[NLDLM_A_ADDR_ADDR6 + 1] = {
+	[NLDLM_A_ADDR_FAMILY] = { .type = NLA_U16, },
+	[NLDLM_A_ADDR_ADDR4] = { .type = NLA_U32, },
+	[NLDLM_A_ADDR_ADDR6] = NLA_POLICY_EXACT_LEN(16),
+};
+
+/* NLDLM_CMD_GET_NODE - do */
+static const struct nla_policy nldlm_get_node_nl_policy[NLDLM_A_NODE_ID + 1] = {
+	[NLDLM_A_NODE_ID] = { .type = NLA_U32, },
+};
+
+/* NLDLM_CMD_ADD_NODE - do */
+static const struct nla_policy nldlm_add_node_nl_policy[NLDLM_A_NODE_ADDRS + 1] = {
+	[NLDLM_A_NODE_ID] = { .type = NLA_U32, },
+	[NLDLM_A_NODE_MARK] = { .type = NLA_U32, },
+	[NLDLM_A_NODE_ADDRS] = NLA_POLICY_NESTED(nldlm_addr_nl_policy),
+};
+
+/* NLDLM_CMD_DEL_NODE - do */
+static const struct nla_policy nldlm_del_node_nl_policy[NLDLM_A_NODE_ID + 1] = {
+	[NLDLM_A_NODE_ID] = { .type = NLA_U32, },
+};
+
+/* NLDLM_CMD_GET_LS - do */
+static const struct nla_policy nldlm_get_ls_nl_policy[NLDLM_A_LS_NAME + 1] = {
+	[NLDLM_A_LS_NAME] = { .type = NLA_NUL_STRING, },
+};
+
+/* NLDLM_CMD_GET_LS_MEMBER - do */
+static const struct nla_policy nldlm_get_ls_member_do_nl_policy[NLDLM_A_LS_MEMBER_NODEID + 1] = {
+	[NLDLM_A_LS_MEMBER_LS_NAME] = { .type = NLA_NUL_STRING, },
+	[NLDLM_A_LS_MEMBER_NODEID] = { .type = NLA_U32, },
+};
+
+/* NLDLM_CMD_GET_LS_MEMBER - dump */
+static const struct nla_policy nldlm_get_ls_member_dump_nl_policy[NLDLM_A_LS_MEMBER_LS_NAME + 1] = {
+	[NLDLM_A_LS_MEMBER_LS_NAME] = { .type = NLA_NUL_STRING, },
+};
+
+/* NLDLM_CMD_LS_ADD_MEMBER - do */
+static const struct nla_policy nldlm_ls_add_member_nl_policy[NLDLM_A_LS_MEMBER_WEIGHT + 1] = {
+	[NLDLM_A_LS_MEMBER_LS_NAME] = { .type = NLA_NUL_STRING, },
+	[NLDLM_A_LS_MEMBER_NODEID] = { .type = NLA_U32, },
+	[NLDLM_A_LS_MEMBER_WEIGHT] = { .type = NLA_U32, },
+};
+
+/* NLDLM_CMD_LS_DEL_MEMBER - do */
+static const struct nla_policy nldlm_ls_del_member_nl_policy[NLDLM_A_LS_MEMBER_NODEID + 1] = {
+	[NLDLM_A_LS_MEMBER_LS_NAME] = { .type = NLA_NUL_STRING, },
+	[NLDLM_A_LS_MEMBER_NODEID] = { .type = NLA_U32, },
+};
+
+/* NLDLM_CMD_LS_CTRL - do */
+static const struct nla_policy nldlm_ls_ctrl_nl_policy[NLDLM_A_LS_CTRL_ACTION + 1] = {
+	[NLDLM_A_LS_CTRL_LS_NAME] = { .type = NLA_NUL_STRING, },
+	[NLDLM_A_LS_CTRL_ACTION] = { .type = NLA_U32, },
+};
+
+/* NLDLM_CMD_LS_EVENT_DONE - do */
+static const struct nla_policy nldlm_ls_event_done_nl_policy[NLDLM_A_LS_EVENT_RESULT_RESULT + 1] = {
+	[NLDLM_A_LS_EVENT_RESULT_LS_NAME] = { .type = NLA_NUL_STRING, },
+	[NLDLM_A_LS_EVENT_RESULT_LS_GLOBAL_ID] = { .type = NLA_U32, },
+	[NLDLM_A_LS_EVENT_RESULT_RESULT] = { .type = NLA_U32, },
+};
+
+/* NLDLM_CMD_SET_OUR_NODEID - do */
+static const struct nla_policy nldlm_set_our_nodeid_nl_policy[NLDLM_A_CFG_OUR_NODEID + 1] = {
+	[NLDLM_A_CFG_OUR_NODEID] = { .type = NLA_U32, },
+};
+
+/* NLDLM_CMD_SET_CLUSTER_NAME - do */
+static const struct nla_policy nldlm_set_cluster_name_nl_policy[NLDLM_A_CFG_CLUSTER_NAME + 1] = {
+	[NLDLM_A_CFG_CLUSTER_NAME] = { .type = NLA_NUL_STRING, },
+};
+
+/* NLDLM_CMD_SET_PROTOCOL - do */
+static const struct nla_policy nldlm_set_protocol_nl_policy[NLDLM_A_CFG_PROTOCOL + 1] = {
+	[NLDLM_A_CFG_PROTOCOL] = { .type = NLA_U32, },
+};
+
+/* NLDLM_CMD_SET_PORT - do */
+static const struct nla_policy nldlm_set_port_nl_policy[NLDLM_A_CFG_PORT + 1] = {
+	[NLDLM_A_CFG_PORT] = { .type = NLA_U16, },
+};
+
+/* NLDLM_CMD_SET_RECOVER_TIMEOUT - do */
+static const struct nla_policy nldlm_set_recover_timeout_nl_policy[NLDLM_A_CFG_RECOVER_TIMEOUT + 1] = {
+	[NLDLM_A_CFG_RECOVER_TIMEOUT] = { .type = NLA_U32, },
+};
+
+/* NLDLM_CMD_SET_INACTIVE_TIMEOUT - do */
+static const struct nla_policy nldlm_set_inactive_timeout_nl_policy[NLDLM_A_CFG_INACTIVE_TIMEOUT + 1] = {
+	[NLDLM_A_CFG_INACTIVE_TIMEOUT] = { .type = NLA_U32, },
+};
+
+/* NLDLM_CMD_SET_LOG_LEVEL - do */
+static const struct nla_policy nldlm_set_log_level_nl_policy[NLDLM_A_CFG_LOG_LEVEL + 1] = {
+	[NLDLM_A_CFG_LOG_LEVEL] = { .type = NLA_U32, },
+};
+
+/* NLDLM_CMD_SET_DEFAULT_MARK - do */
+static const struct nla_policy nldlm_set_default_mark_nl_policy[NLDLM_A_CFG_DEFAULT_MARK + 1] = {
+	[NLDLM_A_CFG_DEFAULT_MARK] = { .type = NLA_U32, },
+};
+
+/* NLDLM_CMD_SET_RECOVER_CALLBACKS - do */
+static const struct nla_policy nldlm_set_recover_callbacks_nl_policy[NLDLM_A_CFG_RECOVER_CALLBACKS + 1] = {
+	[NLDLM_A_CFG_RECOVER_CALLBACKS] = { .type = NLA_FLAG, },
+};
+
+/* Ops table for nldlm */
+static const struct genl_split_ops nldlm_nl_ops[] = {
+	{
+		.cmd		= NLDLM_CMD_GET_NODE,
+		.doit		= nldlm_nl_get_node_doit,
+		.policy		= nldlm_get_node_nl_policy,
+		.maxattr	= NLDLM_A_NODE_ID,
+		.flags		= GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd	= NLDLM_CMD_GET_NODE,
+		.dumpit	= nldlm_nl_get_node_dumpit,
+		.flags	= GENL_CMD_CAP_DUMP,
+	},
+	{
+		.cmd		= NLDLM_CMD_ADD_NODE,
+		.doit		= nldlm_nl_add_node_doit,
+		.policy		= nldlm_add_node_nl_policy,
+		.maxattr	= NLDLM_A_NODE_ADDRS,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd		= NLDLM_CMD_DEL_NODE,
+		.doit		= nldlm_nl_del_node_doit,
+		.policy		= nldlm_del_node_nl_policy,
+		.maxattr	= NLDLM_A_NODE_ID,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd		= NLDLM_CMD_GET_LS,
+		.doit		= nldlm_nl_get_ls_doit,
+		.policy		= nldlm_get_ls_nl_policy,
+		.maxattr	= NLDLM_A_LS_NAME,
+		.flags		= GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd	= NLDLM_CMD_GET_LS,
+		.dumpit	= nldlm_nl_get_ls_dumpit,
+		.flags	= GENL_CMD_CAP_DUMP,
+	},
+	{
+		.cmd		= NLDLM_CMD_GET_LS_MEMBER,
+		.doit		= nldlm_nl_get_ls_member_doit,
+		.policy		= nldlm_get_ls_member_do_nl_policy,
+		.maxattr	= NLDLM_A_LS_MEMBER_NODEID,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd		= NLDLM_CMD_GET_LS_MEMBER,
+		.dumpit		= nldlm_nl_get_ls_member_dumpit,
+		.policy		= nldlm_get_ls_member_dump_nl_policy,
+		.maxattr	= NLDLM_A_LS_MEMBER_LS_NAME,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DUMP,
+	},
+	{
+		.cmd		= NLDLM_CMD_LS_ADD_MEMBER,
+		.doit		= nldlm_nl_ls_add_member_doit,
+		.policy		= nldlm_ls_add_member_nl_policy,
+		.maxattr	= NLDLM_A_LS_MEMBER_WEIGHT,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd		= NLDLM_CMD_LS_DEL_MEMBER,
+		.doit		= nldlm_nl_ls_del_member_doit,
+		.policy		= nldlm_ls_del_member_nl_policy,
+		.maxattr	= NLDLM_A_LS_MEMBER_NODEID,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd		= NLDLM_CMD_LS_CTRL,
+		.doit		= nldlm_nl_ls_ctrl_doit,
+		.policy		= nldlm_ls_ctrl_nl_policy,
+		.maxattr	= NLDLM_A_LS_CTRL_ACTION,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd		= NLDLM_CMD_LS_EVENT_DONE,
+		.doit		= nldlm_nl_ls_event_done_doit,
+		.policy		= nldlm_ls_event_done_nl_policy,
+		.maxattr	= NLDLM_A_LS_EVENT_RESULT_RESULT,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd	= NLDLM_CMD_GET_CFG,
+		.doit	= nldlm_nl_get_cfg_doit,
+		.flags	= GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd		= NLDLM_CMD_SET_OUR_NODEID,
+		.doit		= nldlm_nl_set_our_nodeid_doit,
+		.policy		= nldlm_set_our_nodeid_nl_policy,
+		.maxattr	= NLDLM_A_CFG_OUR_NODEID,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd		= NLDLM_CMD_SET_CLUSTER_NAME,
+		.doit		= nldlm_nl_set_cluster_name_doit,
+		.policy		= nldlm_set_cluster_name_nl_policy,
+		.maxattr	= NLDLM_A_CFG_CLUSTER_NAME,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd		= NLDLM_CMD_SET_PROTOCOL,
+		.doit		= nldlm_nl_set_protocol_doit,
+		.policy		= nldlm_set_protocol_nl_policy,
+		.maxattr	= NLDLM_A_CFG_PROTOCOL,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd		= NLDLM_CMD_SET_PORT,
+		.doit		= nldlm_nl_set_port_doit,
+		.policy		= nldlm_set_port_nl_policy,
+		.maxattr	= NLDLM_A_CFG_PORT,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd		= NLDLM_CMD_SET_RECOVER_TIMEOUT,
+		.doit		= nldlm_nl_set_recover_timeout_doit,
+		.policy		= nldlm_set_recover_timeout_nl_policy,
+		.maxattr	= NLDLM_A_CFG_RECOVER_TIMEOUT,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd		= NLDLM_CMD_SET_INACTIVE_TIMEOUT,
+		.doit		= nldlm_nl_set_inactive_timeout_doit,
+		.policy		= nldlm_set_inactive_timeout_nl_policy,
+		.maxattr	= NLDLM_A_CFG_INACTIVE_TIMEOUT,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd		= NLDLM_CMD_SET_LOG_LEVEL,
+		.doit		= nldlm_nl_set_log_level_doit,
+		.policy		= nldlm_set_log_level_nl_policy,
+		.maxattr	= NLDLM_A_CFG_LOG_LEVEL,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd		= NLDLM_CMD_SET_DEFAULT_MARK,
+		.doit		= nldlm_nl_set_default_mark_doit,
+		.policy		= nldlm_set_default_mark_nl_policy,
+		.maxattr	= NLDLM_A_CFG_DEFAULT_MARK,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd		= NLDLM_CMD_SET_RECOVER_CALLBACKS,
+		.doit		= nldlm_nl_set_recover_callbacks_doit,
+		.policy		= nldlm_set_recover_callbacks_nl_policy,
+		.maxattr	= NLDLM_A_CFG_RECOVER_CALLBACKS,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
+	},
+};
+
+static const struct genl_multicast_group nldlm_nl_mcgrps[] = {
+	[NLDLM_NLGRP_LS_EVENT] = { "ls-event", },
+};
+
+struct genl_family nldlm_nl_family __ro_after_init = {
+	.name		= NLDLM_FAMILY_NAME,
+	.version	= NLDLM_FAMILY_VERSION,
+	.netnsok	= true,
+	.parallel_ops	= true,
+	.module		= THIS_MODULE,
+	.split_ops	= nldlm_nl_ops,
+	.n_split_ops	= ARRAY_SIZE(nldlm_nl_ops),
+	.mcgrps		= nldlm_nl_mcgrps,
+	.n_mcgrps	= ARRAY_SIZE(nldlm_nl_mcgrps),
+};
diff --git a/fs/dlm/nldlm-kernel.h b/fs/dlm/nldlm-kernel.h
new file mode 100644
index 000000000000..b278d7160e27
--- /dev/null
+++ b/fs/dlm/nldlm-kernel.h
@@ -0,0 +1,50 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
+/* Do not edit directly, auto-generated from: */
+/*	Documentation/netlink/specs/nldlm.yaml */
+/* YNL-GEN kernel header */
+
+#ifndef _LINUX_NLDLM_GEN_H
+#define _LINUX_NLDLM_GEN_H
+
+#include <net/netlink.h>
+#include <net/genetlink.h>
+
+#include <uapi/linux/nldlm.h>
+
+/* Common nested types */
+extern const struct nla_policy nldlm_addr_nl_policy[NLDLM_A_ADDR_ADDR6 + 1];
+
+int nldlm_nl_get_node_doit(struct sk_buff *skb, struct genl_info *info);
+int nldlm_nl_get_node_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
+int nldlm_nl_add_node_doit(struct sk_buff *skb, struct genl_info *info);
+int nldlm_nl_del_node_doit(struct sk_buff *skb, struct genl_info *info);
+int nldlm_nl_get_ls_doit(struct sk_buff *skb, struct genl_info *info);
+int nldlm_nl_get_ls_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
+int nldlm_nl_get_ls_member_doit(struct sk_buff *skb, struct genl_info *info);
+int nldlm_nl_get_ls_member_dumpit(struct sk_buff *skb,
+				  struct netlink_callback *cb);
+int nldlm_nl_ls_add_member_doit(struct sk_buff *skb, struct genl_info *info);
+int nldlm_nl_ls_del_member_doit(struct sk_buff *skb, struct genl_info *info);
+int nldlm_nl_ls_ctrl_doit(struct sk_buff *skb, struct genl_info *info);
+int nldlm_nl_ls_event_done_doit(struct sk_buff *skb, struct genl_info *info);
+int nldlm_nl_get_cfg_doit(struct sk_buff *skb, struct genl_info *info);
+int nldlm_nl_set_our_nodeid_doit(struct sk_buff *skb, struct genl_info *info);
+int nldlm_nl_set_cluster_name_doit(struct sk_buff *skb, struct genl_info *info);
+int nldlm_nl_set_protocol_doit(struct sk_buff *skb, struct genl_info *info);
+int nldlm_nl_set_port_doit(struct sk_buff *skb, struct genl_info *info);
+int nldlm_nl_set_recover_timeout_doit(struct sk_buff *skb,
+				      struct genl_info *info);
+int nldlm_nl_set_inactive_timeout_doit(struct sk_buff *skb,
+				       struct genl_info *info);
+int nldlm_nl_set_log_level_doit(struct sk_buff *skb, struct genl_info *info);
+int nldlm_nl_set_default_mark_doit(struct sk_buff *skb, struct genl_info *info);
+int nldlm_nl_set_recover_callbacks_doit(struct sk_buff *skb,
+					struct genl_info *info);
+
+enum {
+	NLDLM_NLGRP_LS_EVENT,
+};
+
+extern struct genl_family nldlm_nl_family;
+
+#endif /* _LINUX_NLDLM_GEN_H */
diff --git a/fs/dlm/nldlm.c b/fs/dlm/nldlm.c
new file mode 100644
index 000000000000..8767602c82ca
--- /dev/null
+++ b/fs/dlm/nldlm.c
@@ -0,0 +1,847 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <net/genetlink.h>
+#include <net/sock.h>
+
+#include "dlm_internal.h"
+#include "nldlm-kernel.h"
+#include "lockspace.h"
+#include "member.h"
+#include "config.h"
+#include "lock.h"
+
+static int nldlm_put_ls_event(struct sk_buff *msg, const struct dlm_ls *ls,
+			      u32 portid, u32 seq, int flags, uint32_t cmd)
+{
+	void *hdr;
+	int rv;
+
+	hdr = genlmsg_put(msg, 0, 0, &nldlm_nl_family, 0, cmd);
+	if (!hdr)
+		return -ENOBUFS;
+
+	rv = nla_put_string(msg, NLDLM_A_LS_NAME, ls->ls_name);
+	if (rv < 0)
+		goto err;
+
+	genlmsg_end(msg, hdr);
+	return 0;
+
+err:
+	genlmsg_cancel(msg, hdr);
+	return -ENOBUFS;
+}
+
+int nldlm_ls_event(const struct dlm_ls *ls, uint32_t cmd)
+{
+	struct sk_buff *msg;
+	int rv;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	if (!msg)
+		return -ENOMEM;
+
+	rv = nldlm_put_ls_event(msg, ls, 0, 0, 0, cmd);
+	if (rv < 0) {
+		nlmsg_free(msg);
+		return rv;
+	}
+
+	return genlmsg_multicast_netns(&nldlm_nl_family,
+				       read_pnet(&ls->ls_dn->net), msg, 0,
+				       NLDLM_NLGRP_LS_EVENT, GFP_ATOMIC);
+}
+
+static int __nldlm_get_ls(struct sk_buff *msg, struct dlm_cfg_ls *ls,
+			  u32 portid, u32 seq, struct netlink_callback *cb,
+			  int flags)
+{
+	void *hdr;
+	int rv;
+
+	hdr = genlmsg_put(msg, portid, seq, &nldlm_nl_family, flags,
+			  NLDLM_CMD_GET_LS);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (cb)
+		genl_dump_check_consistent(cb, hdr);
+
+	rv = nla_put_string(msg, NLDLM_A_LS_NAME, ls->name);
+	if (rv < 0)
+		goto err;
+
+	genlmsg_end(msg, hdr);
+	return 0;
+
+err:
+	genlmsg_cancel(msg, hdr);
+	return rv;
+}
+
+int nldlm_nl_get_ls_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(skb->sk));
+	struct dlm_cfg_ls *ls = NULL, *ls_iter;
+	char lsname[DLM_LOCKSPACE_LEN];
+	struct sk_buff *msg;
+	int rv;
+
+	if (!info->attrs[NLDLM_A_LS_NAME])
+		return -EINVAL;
+
+	nla_strscpy(lsname, info->attrs[NLDLM_A_LS_NAME],
+		    DLM_LOCKSPACE_LEN);
+
+	mutex_lock(&dn->cfg_lock);
+	list_for_each_entry(ls_iter, &dn->lockspaces, list) {
+		if (!strncmp(ls_iter->name, lsname, DLM_LOCKSPACE_LEN)) {
+			ls = ls_iter;
+			break;
+		}
+	}
+
+	if (!ls) {
+		rv = -ENOENT;
+		goto err;
+	}
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	if (!msg) {
+		rv = -ENOMEM;
+		goto err;
+	}
+
+	rv = __nldlm_get_ls(msg, ls, info->snd_portid,
+			    info->snd_seq, NULL, 0);
+	if (rv < 0) {
+		nlmsg_free(msg);
+		goto err;
+	}
+
+	rv = genlmsg_reply(msg, info);
+
+err:
+	mutex_unlock(&dn->cfg_lock);
+	return rv;
+}
+
+int nldlm_nl_get_ls_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(skb->sk));
+	unsigned int idx = cb->args[0];
+	struct dlm_cfg_ls *ls;
+	int rv;
+
+	mutex_lock(&dn->cfg_lock);
+	list_for_each_entry(ls, &dn->lockspaces, list) {
+		if (ls->idx < idx)
+			continue;
+
+		rv = __nldlm_get_ls(skb, ls, NETLINK_CB(cb->skb).portid,
+				    cb->nlh->nlmsg_seq, cb, NLM_F_MULTI);
+		if (rv < 0)
+			break;
+
+		idx = ls->idx + 1;
+	}
+	mutex_unlock(&dn->cfg_lock);
+
+	cb->args[0] = idx;
+	return skb->len;
+}
+
+static int __nldlm_get_node(struct sk_buff *msg, struct dlm_cfg_node *nd,
+			    u32 portid, u32 seq,
+			    struct netlink_callback *cb, int flags)
+{
+	struct nlattr *nl_addr;
+	void *hdr;
+	size_t i;
+	int rv;
+
+	hdr = genlmsg_put(msg, portid, seq, &nldlm_nl_family, flags,
+			  NLDLM_CMD_GET_NODE);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (cb)
+		genl_dump_check_consistent(cb, hdr);
+
+	rv = nla_put_le32(msg, NLDLM_A_NODE_ID, cpu_to_le32(nd->id));
+	if (rv < 0)
+		goto err;
+
+	rv = nla_put_u32(msg, NLDLM_A_NODE_MARK, nd->mark);
+	if (rv < 0)
+		goto err;
+
+	for (i = 0; i < nd->addrs_count; i++) {
+		nl_addr = nla_nest_start(msg, NLDLM_A_NODE_ADDRS);
+		if (!nl_addr)
+			goto err;
+
+		rv = nla_put_u16(msg, NLDLM_A_ADDR_FAMILY, nd->addrs[i].ss_family);
+		if (rv) {
+			nla_nest_cancel(msg, nl_addr);
+			goto err;
+		}
+
+		switch (nd->addrs[i].ss_family) {
+		case AF_INET:
+			rv = nla_put_in_addr(msg, NLDLM_A_ADDR_ADDR4,
+					     ((struct sockaddr_in *)&nd->addrs[i])->sin_addr.s_addr);
+			if (rv) {
+				nla_nest_cancel(msg, nl_addr);
+				goto err;
+			}
+
+			break;
+		case AF_INET6:
+			rv = nla_put_in6_addr(msg, NLDLM_A_ADDR_ADDR6,
+					      &((struct sockaddr_in6 *)&nd->addrs[i])->sin6_addr);
+			if (rv) {
+				nla_nest_cancel(msg, nl_addr);
+				goto err;
+			}
+
+			break;
+		default:
+			nla_nest_cancel(msg, nl_addr);
+			goto err;
+		}
+
+		nla_nest_end(msg, nl_addr);
+	}
+
+	genlmsg_end(msg, hdr);
+	return 0;
+
+err:
+	genlmsg_cancel(msg, hdr);
+	return rv;
+}
+
+int nldlm_nl_get_node_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(skb->sk));
+	struct dlm_cfg_node *nd;
+	struct sk_buff *msg;
+	__le32 nodeid;
+	int rv;
+
+	if (!info->attrs[NLDLM_A_NODE_ID])
+		return -EINVAL;
+
+	nodeid = nla_get_le32(info->attrs[NLDLM_A_NODE_ID]);
+
+	mutex_lock(&dn->cfg_lock);
+	nd = dlm_cfg_get_node(dn, le32_to_cpu(nodeid));
+	if (!nd) {
+		rv = -ENOENT;
+		goto out;
+	}
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	if (!msg) {
+		rv = -ENOMEM;
+		goto out;
+	}
+
+	rv = __nldlm_get_node(msg, nd, info->snd_portid,
+			      info->snd_seq, NULL, 0);
+	if (rv < 0) {
+		nlmsg_free(msg);
+		goto out;
+	}
+
+	rv = genlmsg_reply(msg, info);
+
+out:
+	mutex_unlock(&dn->cfg_lock);
+	return rv;
+}
+
+int nldlm_nl_get_node_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(skb->sk));
+	unsigned int idx = cb->args[0];
+	struct dlm_cfg_node *nd;
+	int rv;
+
+	mutex_lock(&dn->cfg_lock);
+	list_for_each_entry(nd, &dn->nodes, list) {
+		if (nd->idx < idx)
+			continue;
+
+		rv = __nldlm_get_node(skb, nd, NETLINK_CB(cb->skb).portid,
+				      cb->nlh->nlmsg_seq, cb, NLM_F_MULTI);
+		if (rv < 0)
+			break;
+
+		idx = nd->idx + 1;
+	}
+	mutex_unlock(&dn->cfg_lock);
+
+	cb->args[0] = idx;
+	return skb->len;
+}
+
+int nldlm_nl_add_node_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *head = nlmsg_attrdata(info->nlhdr, GENL_HDRLEN);
+	struct sockaddr_storage addrs[DLM_MAX_ADDR_COUNT] = {};
+	int rem, len = nlmsg_attrlen(info->nlhdr, GENL_HDRLEN);
+	struct dlm_net *dn = dlm_pernet(sock_net(skb->sk));
+	struct nlattr *addr_attrs[NLDLM_A_ADDR_MAX + 1];
+	struct nlattr *nla;
+	size_t addrs_count;
+	__le32 nodeid;
+	u32 mark;
+	int rv;
+
+	if (!info->attrs[NLDLM_A_NODE_ID] ||
+	    !info->attrs[NLDLM_A_NODE_ADDRS])
+		return -EINVAL;
+
+	nodeid = nla_get_le32(info->attrs[NLDLM_A_NODE_ID]);
+
+	addrs_count = 0;
+	nla_for_each_attr(nla, head, len, rem) {
+		if (nla_type(nla) != NLDLM_A_NODE_ADDRS)
+			continue;
+
+		if (addrs_count == DLM_MAX_ADDR_COUNT)
+			return -ENOSPC;
+
+		rv = nla_parse_nested(addr_attrs, NLDLM_A_ADDR_MAX, nla,
+				     nldlm_addr_nl_policy, NULL);
+		if (rv)
+			return rv;
+
+		if (!addr_attrs[NLDLM_A_ADDR_FAMILY])
+			return -EINVAL;
+
+		addrs[addrs_count].ss_family = nla_get_u16(addr_attrs[NLDLM_A_ADDR_FAMILY]);
+		switch (addrs[addrs_count].ss_family) {
+		case AF_INET:
+			if (!addr_attrs[NLDLM_A_ADDR_ADDR4])
+				return -EINVAL;
+
+			((struct sockaddr_in *)&addrs[addrs_count])->sin_addr.s_addr =
+				nla_get_in_addr(addr_attrs[NLDLM_A_ADDR_ADDR4]);
+			break;
+		case AF_INET6:
+			if (!addr_attrs[NLDLM_A_ADDR_ADDR6])
+				return -EINVAL;
+
+			((struct sockaddr_in6 *)&addrs[addrs_count])->sin6_addr =
+				nla_get_in6_addr(addr_attrs[NLDLM_A_ADDR_ADDR6]);
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		addrs_count++;
+	}
+
+	if (info->attrs[NLDLM_A_NODE_MARK])
+		mark = nla_get_u32(info->attrs[NLDLM_A_NODE_MARK]);
+	else
+		mark = DLM_DEFAULT_MARK;
+
+	return dlm_cfg_new_node(dn, le32_to_cpu(nodeid), mark, addrs,
+				addrs_count);
+}
+
+int nldlm_nl_del_node_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(skb->sk));
+	__le32 nodeid;
+
+	if (!info->attrs[NLDLM_A_NODE_ID])
+		return -EINVAL;
+
+	nodeid = nla_get_le32(info->attrs[NLDLM_A_NODE_ID]);
+	return dlm_cfg_del_node(dn, le32_to_cpu(nodeid));
+}
+
+static int __nldlm_get_ls_member(struct sk_buff *msg,
+				 const struct dlm_cfg_member *mb,
+				 u32 portid, u32 seq,
+				 struct netlink_callback *cb, int flags)
+{
+	void *hdr;
+	int rv;
+
+	hdr = genlmsg_put(msg, portid, seq, &nldlm_nl_family, flags,
+			  NLDLM_CMD_GET_LS_MEMBER);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (cb)
+		genl_dump_check_consistent(cb, hdr);
+
+	rv = nla_put_string(msg, NLDLM_A_LS_MEMBER_LS_NAME, mb->ls->name);
+	if (rv < 0)
+		goto err;
+
+	rv = nla_put_le32(msg, NLDLM_A_LS_MEMBER_NODEID, cpu_to_le32(mb->nd->id));
+	if (rv < 0)
+		goto err;
+
+	rv = nla_put_u32(msg, NLDLM_A_LS_MEMBER_WEIGHT, mb->weight);
+	if (rv < 0)
+		goto err;
+
+	genlmsg_end(msg, hdr);
+	return 0;
+
+err:
+	genlmsg_cancel(msg, hdr);
+	return rv;
+}
+
+int nldlm_nl_get_ls_member_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(skb->sk));
+	char lsname[DLM_LOCKSPACE_LEN];
+	struct dlm_cfg_member *mb;
+	struct sk_buff *msg;
+	__le32 nodeid;
+	int rv;
+
+	if (!info->attrs[NLDLM_A_LS_MEMBER_LS_NAME] ||
+	    !info->attrs[NLDLM_A_LS_MEMBER_NODEID])
+		return -EINVAL;
+
+	nla_strscpy(lsname, info->attrs[NLDLM_A_LS_MEMBER_LS_NAME],
+		    DLM_LOCKSPACE_LEN);
+	nodeid = nla_get_le32(info->attrs[NLDLM_A_LS_MEMBER_NODEID]);
+
+	mutex_lock(&dn->cfg_lock);
+	mb = dlm_cfg_get_ls_member(dn, lsname, le32_to_cpu(nodeid));
+	if (!mb) {
+		rv = -ENOENT;
+		goto out;
+	}
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	if (!msg) {
+		rv = -ENOMEM;
+		goto out;
+	}
+
+	rv = __nldlm_get_ls_member(msg, mb, info->snd_portid,
+				   info->snd_seq, NULL, 0);
+	if (rv < 0) {
+		nlmsg_free(msg);
+		goto out;
+	}
+
+	rv = genlmsg_reply(msg, info);
+
+out:
+	mutex_unlock(&dn->cfg_lock);
+	return rv;
+}
+
+int nldlm_nl_get_ls_member_dumpit(struct sk_buff *skb,
+				  struct netlink_callback *cb)
+{
+	const struct genl_info *info = genl_info_dump(cb);
+	struct dlm_net *dn = dlm_pernet(sock_net(skb->sk));
+	unsigned int idx = cb->args[0];
+	char lsname[DLM_LOCKSPACE_LEN];
+	struct dlm_cfg_member *mb;
+	struct dlm_cfg_ls *ls;
+	int rv;
+
+	if (!info->attrs[NLDLM_A_LS_MEMBER_LS_NAME])
+		return -EINVAL;
+
+	nla_strscpy(lsname, info->attrs[NLDLM_A_LS_MEMBER_LS_NAME],
+		    DLM_LOCKSPACE_LEN);
+
+	mutex_lock(&dn->cfg_lock);
+	ls = dlm_cfg_get_ls(dn, lsname);
+	if (!ls) {
+		mutex_unlock(&dn->cfg_lock);
+		return -ENOENT;
+	}
+
+	list_for_each_entry(mb, &ls->members, list) {
+		if (mb->idx < idx)
+			continue;
+
+		rv = __nldlm_get_ls_member(skb, mb, NETLINK_CB(cb->skb).portid,
+					   cb->nlh->nlmsg_seq, cb,
+					   NLM_F_MULTI);
+		if (rv < 0)
+			break;
+
+		idx = mb->idx + 1;
+	}
+	mutex_unlock(&dn->cfg_lock);
+
+	cb->args[0] = idx;
+	return skb->len;
+}
+
+int nldlm_nl_ls_ctrl_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(skb->sk));
+	char lsname[DLM_LOCKSPACE_LEN];
+	enum nldlm_ls_ctrl_action ctrl;
+	struct dlm_ls *ls;
+
+	if (!info->attrs[NLDLM_A_LS_CTRL_LS_NAME] ||
+	    !info->attrs[NLDLM_A_LS_CTRL_ACTION])
+		return -EINVAL;
+
+	nla_strscpy(lsname, info->attrs[NLDLM_A_LS_CTRL_LS_NAME],
+		    DLM_LOCKSPACE_LEN);
+	ctrl = nla_get_u32(info->attrs[NLDLM_A_LS_CTRL_ACTION]);
+
+	ls = dlm_find_lockspace_name(dn, lsname);
+	if (!ls)
+		return -ENOENT;
+
+	switch (ctrl) {
+	case NLDLM_LS_CTRL_ACTION_STOP:
+		dlm_ls_stop(ls);
+		break;
+	case NLDLM_LS_CTRL_ACTION_START:
+		dlm_ls_start(ls);
+		break;
+	default:
+		dlm_put_lockspace(ls);
+		return -EINVAL;
+	}
+
+	dlm_put_lockspace(ls);
+	return 0;
+}
+
+int nldlm_nl_ls_event_done_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(skb->sk));
+	enum nldlm_ls_event_result result;
+	char lsname[DLM_LOCKSPACE_LEN];
+	struct dlm_ls *ls;
+	__le32 global_id;
+	int rv;
+
+	if (!info->attrs[NLDLM_A_LS_EVENT_RESULT_LS_NAME] ||
+	    !info->attrs[NLDLM_A_LS_EVENT_RESULT_LS_GLOBAL_ID] ||
+	    !info->attrs[NLDLM_A_LS_EVENT_RESULT_RESULT])
+		return -EINVAL;
+
+	nla_strscpy(lsname, info->attrs[NLDLM_A_LS_EVENT_RESULT_LS_NAME],
+		    DLM_LOCKSPACE_LEN);
+	global_id = nla_get_le32(info->attrs[NLDLM_A_LS_EVENT_RESULT_LS_GLOBAL_ID]);
+	result = nla_get_u32(info->attrs[NLDLM_A_LS_EVENT_RESULT_RESULT]);
+
+	/* sanity checking only if the global_id is already given in another
+	 * lockspace. This check is racy and it requires more changes to
+	 * not make it racy, however is it better than just apply the id.
+	 */
+	ls = dlm_find_lockspace_global(dn, le32_to_cpu(global_id));
+	if (ls) {
+		dlm_put_lockspace(ls);
+		return -EEXIST;
+	}
+
+	ls = dlm_find_lockspace_name(dn, lsname);
+	if (!ls)
+		return -ENOENT;
+
+	switch (result) {
+	case NLDLM_LS_EVENT_RESULT_SUCCESS:
+		ls->ls_global_id = le32_to_cpu(global_id);
+		rv = 0;
+		break;
+	case NLDLM_LS_EVENT_RESULT_FAILURE:
+		rv = -1;
+		break;
+	default:
+		dlm_put_lockspace(ls);
+		return -EINVAL;
+	}
+
+	ls->ls_uevent_result = rv;
+	set_bit(LSFL_UEVENT_WAIT, &ls->ls_flags);
+	wake_up(&ls->ls_uevent_wait);
+
+	dlm_put_lockspace(ls);
+	return 0;
+}
+
+int nldlm_nl_ls_add_member_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(skb->sk));
+	char lsname[DLM_LOCKSPACE_LEN];
+	__le32 nodeid;
+	u32 weight = DLM_DEFAULT_WEIGHT;
+
+	if (!info->attrs[NLDLM_A_LS_MEMBER_LS_NAME] ||
+	    !info->attrs[NLDLM_A_LS_MEMBER_NODEID])
+		return -EINVAL;
+
+	nla_strscpy(lsname, info->attrs[NLDLM_A_LS_MEMBER_LS_NAME],
+		    DLM_LOCKSPACE_LEN);
+	nodeid = nla_get_le32(info->attrs[NLDLM_A_LS_MEMBER_NODEID]);
+	if (info->attrs[NLDLM_A_LS_MEMBER_WEIGHT])
+		weight = nla_get_u32(info->attrs[NLDLM_A_LS_MEMBER_WEIGHT]);
+
+	return dlm_cfg_add_member(dn, lsname, le32_to_cpu(nodeid), weight);
+}
+
+int nldlm_nl_ls_del_member_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(skb->sk));
+	char lsname[DLM_LOCKSPACE_LEN];
+	__le32 nodeid;
+
+	if (!info->attrs[NLDLM_A_LS_MEMBER_LS_NAME] ||
+	    !info->attrs[NLDLM_A_LS_MEMBER_NODEID])
+		return -EINVAL;
+
+	nla_strscpy(lsname, info->attrs[NLDLM_A_LS_MEMBER_LS_NAME],
+		    DLM_LOCKSPACE_LEN);
+	nodeid = nla_get_le32(info->attrs[NLDLM_A_LS_MEMBER_NODEID]);
+
+	return dlm_cfg_del_member(dn, lsname, le32_to_cpu(nodeid));
+}
+
+int nldlm_nl_get_cfg_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	enum nldlm_log_level log_level = NLDLM_LOG_LEVEL_NONE;
+	struct dlm_net *dn = dlm_pernet(sock_net(skb->sk));
+	struct sk_buff *msg;
+	void *hdr;
+	int rv;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = genlmsg_put(msg, info->snd_portid, info->snd_seq,
+			  &nldlm_nl_family, 0, NLDLM_CMD_GET_CFG);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return -EMSGSIZE;
+	}
+
+	mutex_lock(&dn->cfg_lock);
+	if (dn->our_node) {
+		rv = nla_put_le32(msg, NLDLM_A_CFG_OUR_NODEID,
+				  cpu_to_le32(dn->our_node->id));
+		if (rv < 0)
+			goto err;
+	}
+
+	rv = nla_put_string(msg, NLDLM_A_CFG_CLUSTER_NAME,
+			    dn->config.ci_cluster_name);
+	if (rv < 0)
+		goto err;
+
+	rv = nla_put_u32(msg, NLDLM_A_CFG_PROTOCOL,
+			 dn->config.ci_protocol);
+	if (rv < 0)
+		goto err;
+
+	rv = nla_put_be16(msg, NLDLM_A_CFG_PORT,
+			  dn->config.ci_tcp_port);
+	if (rv < 0)
+		goto err;
+
+	if (!dn->config.ci_log_info)
+		log_level = NLDLM_LOG_LEVEL_NONE;
+	else if (dn->config.ci_log_info)
+		log_level = NLDLM_LOG_LEVEL_INFO;
+	else if (dn->config.ci_log_debug)
+		log_level = NLDLM_LOG_LEVEL_DEBUG;
+
+	rv = nla_put_u32(msg, NLDLM_A_CFG_LOG_LEVEL, log_level);
+	if (rv < 0)
+		goto err;
+
+	rv = nla_put_u32(msg, NLDLM_A_CFG_RECOVER_TIMEOUT,
+			 dn->config.ci_recover_timer);
+	if (rv < 0)
+		goto err;
+
+	rv = nla_put_u32(msg, NLDLM_A_CFG_INACTIVE_TIMEOUT,
+			 dn->config.ci_toss_secs);
+	if (rv < 0)
+		goto err;
+
+	rv = nla_put_u32(msg, NLDLM_A_CFG_DEFAULT_MARK,
+			 dn->config.ci_mark);
+	if (rv < 0)
+		goto err;
+
+	if (dn->config.ci_recover_callbacks) {
+		rv = nla_put_flag(msg, NLDLM_A_CFG_RECOVER_CALLBACKS);
+		if (rv < 0)
+			goto err;
+	}
+
+	mutex_unlock(&dn->cfg_lock);
+	genlmsg_end(msg, hdr);
+	return genlmsg_reply(msg, info);
+
+err:
+	mutex_unlock(&dn->cfg_lock);
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+	return rv;
+}
+
+int nldlm_nl_set_our_nodeid_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(skb->sk));
+	__le32 nodeid;
+
+	if (!info->attrs[NLDLM_A_CFG_OUR_NODEID])
+		return -EINVAL;
+
+	nodeid = nla_get_le32(info->attrs[NLDLM_A_CFG_OUR_NODEID]);
+
+	return dlm_cfg_set_our_nodeid(dn, le32_to_cpu(nodeid));
+}
+
+int nldlm_nl_set_cluster_name_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(skb->sk));
+
+	if (!info->attrs[NLDLM_A_CFG_CLUSTER_NAME])
+		return -EINVAL;
+
+	mutex_lock(&dn->cfg_lock);
+	nla_strscpy(dn->config.ci_cluster_name,
+		    info->attrs[NLDLM_A_CFG_CLUSTER_NAME],
+		    DLM_LOCKSPACE_LEN);
+	mutex_unlock(&dn->cfg_lock);
+
+	return 0;
+}
+
+int nldlm_nl_set_protocol_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(skb->sk));
+	uint32_t protocol;
+
+	if (!info->attrs[NLDLM_A_CFG_PROTOCOL])
+		return -EINVAL;
+
+	protocol = nla_get_u32(info->attrs[NLDLM_A_CFG_PROTOCOL]);
+
+	return dlm_cfg_set_protocol(dn, protocol);
+}
+
+int nldlm_nl_set_port_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(skb->sk));
+	__be16 port;
+
+	if (!info->attrs[NLDLM_A_CFG_PORT])
+		return -EINVAL;
+
+	port = nla_get_be16(info->attrs[NLDLM_A_CFG_PORT]);
+
+	return dlm_cfg_set_port(dn, port);
+}
+
+int nldlm_nl_set_recover_timeout_doit(struct sk_buff *skb,
+				      struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(skb->sk));
+	uint32_t secs;
+
+	if (!info->attrs[NLDLM_A_CFG_RECOVER_TIMEOUT])
+		return -EINVAL;
+
+	secs = nla_get_u32(info->attrs[NLDLM_A_CFG_RECOVER_TIMEOUT]);
+
+	return dlm_cfg_set_recover_timer(dn, secs);
+}
+
+int nldlm_nl_set_inactive_timeout_doit(struct sk_buff *skb,
+				       struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(skb->sk));
+	uint32_t secs;
+
+	if (!info->attrs[NLDLM_A_CFG_INACTIVE_TIMEOUT])
+		return -EINVAL;
+
+	secs = nla_get_u32(info->attrs[NLDLM_A_CFG_INACTIVE_TIMEOUT]);
+
+	return dlm_cfg_set_toss_secs(dn, secs);
+}
+
+int nldlm_nl_set_log_level_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(skb->sk));
+	uint32_t level;
+
+	if (!info->attrs[NLDLM_A_CFG_LOG_LEVEL])
+		return -EINVAL;
+
+	level = nla_get_u32(info->attrs[NLDLM_A_CFG_LOG_LEVEL]);
+
+	switch (level) {
+	case NLDLM_LOG_LEVEL_NONE:
+		dlm_cfg_set_log_info(dn, 0);
+		dlm_cfg_set_log_debug(dn, 0);
+		break;
+	case NLDLM_LOG_LEVEL_INFO:
+		dlm_cfg_set_log_info(dn, 1);
+		dlm_cfg_set_log_debug(dn, 0);
+		break;
+	case NLDLM_LOG_LEVEL_DEBUG:
+		dlm_cfg_set_log_info(dn, 1);
+		dlm_cfg_set_log_debug(dn, 1);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int nldlm_nl_set_default_mark_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(skb->sk));
+	uint32_t mark;
+
+	if (!info->attrs[NLDLM_A_CFG_DEFAULT_MARK])
+		return -EINVAL;
+
+	mark = nla_get_u32(info->attrs[NLDLM_A_CFG_DEFAULT_MARK]);
+
+	return dlm_cfg_set_mark(dn, mark);
+}
+
+int nldlm_nl_set_recover_callbacks_doit(struct sk_buff *skb,
+					struct genl_info *info)
+{
+	struct dlm_net *dn = dlm_pernet(sock_net(skb->sk));
+	int flag;
+
+	flag = nla_get_flag(info->attrs[NLDLM_A_CFG_RECOVER_CALLBACKS]);
+
+	return dlm_cfg_set_recover_callbacks(dn, flag);
+}
+
+int __init dlm_nldlm_init(void)
+{
+	return genl_register_family(&nldlm_nl_family);
+}
+
+void dlm_nldlm_exit(void)
+{
+	genl_unregister_family(&nldlm_nl_family);
+}
diff --git a/include/uapi/linux/nldlm.h b/include/uapi/linux/nldlm.h
new file mode 100644
index 000000000000..d169bfaa1ffa
--- /dev/null
+++ b/include/uapi/linux/nldlm.h
@@ -0,0 +1,153 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
+/* Do not edit directly, auto-generated from: */
+/*	Documentation/netlink/specs/nldlm.yaml */
+/* YNL-GEN uapi header */
+
+#ifndef _UAPI_LINUX_NLDLM_H
+#define _UAPI_LINUX_NLDLM_H
+
+#define NLDLM_FAMILY_NAME	"nldlm"
+#define NLDLM_FAMILY_VERSION	1
+
+/**
+ * enum nldlm_protocol - The transport layer protocol that DLM will use.
+ */
+enum nldlm_protocol {
+	NLDLM_PROTOCOL_TCP,
+	NLDLM_PROTOCOL_SCTP,
+};
+
+/**
+ * enum nldlm_log_level - The internal DLM logger log-level.
+ * @NLDLM_LOG_LEVEL_NONE: disable all DLM logging
+ * @NLDLM_LOG_LEVEL_INFO: enable INFO log-level only
+ * @NLDLM_LOG_LEVEL_DEBUG: enable INFO and DEBUG log-level
+ */
+enum nldlm_log_level {
+	NLDLM_LOG_LEVEL_NONE,
+	NLDLM_LOG_LEVEL_INFO,
+	NLDLM_LOG_LEVEL_DEBUG,
+};
+
+/**
+ * enum nldlm_ls_ctrl_action - The lockspace control actions. Use in
+ *   combination with ls-add-member and ls-del-member. First stop lockspace
+ *   then update the members, then start the lockspace to trigger recovery with
+ *   new membership updates.
+ * @NLDLM_LS_CTRL_ACTION_STOP: stopping the lockspace
+ * @NLDLM_LS_CTRL_ACTION_START: starting the lockspace
+ */
+enum nldlm_ls_ctrl_action {
+	NLDLM_LS_CTRL_ACTION_STOP,
+	NLDLM_LS_CTRL_ACTION_START,
+};
+
+/**
+ * enum nldlm_ls_event_result - The result op of the lockspace event ntf-new-ls
+ *   and ntf-release-ls. The kernel is waiting for this reply when those events
+ *   occur.
+ * @NLDLM_LS_EVENT_RESULT_SUCCESS: the DLM kernel lockspace event action was
+ *   successful
+ * @NLDLM_LS_EVENT_RESULT_FAILURE: the DLM kernel lockspace event action failed
+ */
+enum nldlm_ls_event_result {
+	NLDLM_LS_EVENT_RESULT_SUCCESS,
+	NLDLM_LS_EVENT_RESULT_FAILURE,
+};
+
+enum {
+	NLDLM_A_CFG_OUR_NODEID = 1,
+	NLDLM_A_CFG_CLUSTER_NAME,
+	NLDLM_A_CFG_PROTOCOL,
+	NLDLM_A_CFG_PORT,
+	NLDLM_A_CFG_RECOVER_TIMEOUT,
+	NLDLM_A_CFG_INACTIVE_TIMEOUT,
+	NLDLM_A_CFG_LOG_LEVEL,
+	NLDLM_A_CFG_DEFAULT_MARK,
+	NLDLM_A_CFG_RECOVER_CALLBACKS,
+
+	__NLDLM_A_CFG_MAX,
+	NLDLM_A_CFG_MAX = (__NLDLM_A_CFG_MAX - 1)
+};
+
+enum {
+	NLDLM_A_LS_NAME = 1,
+
+	__NLDLM_A_LS_MAX,
+	NLDLM_A_LS_MAX = (__NLDLM_A_LS_MAX - 1)
+};
+
+enum {
+	NLDLM_A_LS_MEMBER_LS_NAME = 1,
+	NLDLM_A_LS_MEMBER_NODEID,
+	NLDLM_A_LS_MEMBER_WEIGHT,
+
+	__NLDLM_A_LS_MEMBER_MAX,
+	NLDLM_A_LS_MEMBER_MAX = (__NLDLM_A_LS_MEMBER_MAX - 1)
+};
+
+enum {
+	NLDLM_A_LS_CTRL_LS_NAME = 1,
+	NLDLM_A_LS_CTRL_ACTION,
+
+	__NLDLM_A_LS_CTRL_MAX,
+	NLDLM_A_LS_CTRL_MAX = (__NLDLM_A_LS_CTRL_MAX - 1)
+};
+
+enum {
+	NLDLM_A_LS_EVENT_RESULT_LS_NAME = 1,
+	NLDLM_A_LS_EVENT_RESULT_LS_GLOBAL_ID,
+	NLDLM_A_LS_EVENT_RESULT_RESULT,
+
+	__NLDLM_A_LS_EVENT_RESULT_MAX,
+	NLDLM_A_LS_EVENT_RESULT_MAX = (__NLDLM_A_LS_EVENT_RESULT_MAX - 1)
+};
+
+enum {
+	NLDLM_A_NODE_ID = 1,
+	NLDLM_A_NODE_MARK,
+	NLDLM_A_NODE_ADDRS,
+
+	__NLDLM_A_NODE_MAX,
+	NLDLM_A_NODE_MAX = (__NLDLM_A_NODE_MAX - 1)
+};
+
+enum {
+	NLDLM_A_ADDR_FAMILY = 1,
+	NLDLM_A_ADDR_ADDR4,
+	NLDLM_A_ADDR_ADDR6,
+
+	__NLDLM_A_ADDR_MAX,
+	NLDLM_A_ADDR_MAX = (__NLDLM_A_ADDR_MAX - 1)
+};
+
+enum {
+	NLDLM_CMD_GET_NODE = 1,
+	NLDLM_CMD_ADD_NODE,
+	NLDLM_CMD_DEL_NODE,
+	NLDLM_CMD_GET_LS,
+	NLDLM_CMD_GET_LS_MEMBER,
+	NLDLM_CMD_LS_ADD_MEMBER,
+	NLDLM_CMD_LS_DEL_MEMBER,
+	NLDLM_CMD_LS_CTRL,
+	NLDLM_CMD_NTF_NEW_LS,
+	NLDLM_CMD_NTF_RELEASE_LS,
+	NLDLM_CMD_LS_EVENT_DONE,
+	NLDLM_CMD_GET_CFG,
+	NLDLM_CMD_SET_OUR_NODEID,
+	NLDLM_CMD_SET_CLUSTER_NAME,
+	NLDLM_CMD_SET_PROTOCOL,
+	NLDLM_CMD_SET_PORT,
+	NLDLM_CMD_SET_RECOVER_TIMEOUT,
+	NLDLM_CMD_SET_INACTIVE_TIMEOUT,
+	NLDLM_CMD_SET_LOG_LEVEL,
+	NLDLM_CMD_SET_DEFAULT_MARK,
+	NLDLM_CMD_SET_RECOVER_CALLBACKS,
+
+	__NLDLM_CMD_MAX,
+	NLDLM_CMD_MAX = (__NLDLM_CMD_MAX - 1)
+};
+
+#define NLDLM_MCGRP_LS_EVENT	"ls-event"
+
+#endif /* _UAPI_LINUX_NLDLM_H */
-- 
2.43.0

