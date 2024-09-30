Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6B91A256B
	for <ocfs2-devel@lists.linux.dev>; Mon, 30 Sep 2024 20:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727727260; cv=none; b=U8SUawPLm+Llb7keOdk01kZrrl9A9T5iIt23i96Pu2Q38R3q2JgKRW4n5a4b+0U8pzaKeFekXW4lPTlllxtNqDPFEUsMtwvVCT86P73TDtJUgb4Rq+2E0jzRgjsL8gfi1zqjb7l1BJ+nUV5FFKusSLn0nlrpdTFoPDFHrZMYikk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727727260; c=relaxed/simple;
	bh=hOxzM1vvni+VRw8MGBOe/I2/OQyuu1ImCQy9QbCD/G0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E27Q2FVP/QJx87RhIPdkBPwFz4dElB5nhe5Un3SjTkqJWAZPFEK3tzpSR5p/N6A/r6fqikCpKki0bi6o2nKnXsQcODxMUZ4yp6LruDRW5EIm2bbvZV+IFzrx4SjW4Rf5hZ6tmrgr/1O/4u6zrfLUdf34hjFyNw2TLjcvRp9gl9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P+ms/Hg5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P+ms/Hg5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727727257;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fJGj4fvColy9wu2xMOGt6pdmjm2QlwLQUgqtQvJQT44=;
	b=P+ms/Hg525SjbEOuAuKIWpB56wvsP+ooy/vJkcKKdvoWy08YdWHlHitdlwGAc+UoGgqz21
	rnCOU+B8wr1Os3xj3sTuekKP3r/mm4l8LSeCUOWepVaCcu5GbdC2SvcwVlvOyoUydx3VQy
	ytRjGTcW7eIaNaiFBudkWg76n/qZWy4=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-96-h0P90KnmPRCzGgdrNotA0A-1; Mon,
 30 Sep 2024 16:14:14 -0400
X-MC-Unique: h0P90KnmPRCzGgdrNotA0A-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2F93219626DA;
	Mon, 30 Sep 2024 20:14:11 +0000 (UTC)
Received: from fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com (unknown [10.6.24.150])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C437C1955DC7;
	Mon, 30 Sep 2024 20:14:08 +0000 (UTC)
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
Subject: [PATCHv2 dlm/next 02/12] dlm: disallow different configs nodeid storages
Date: Mon, 30 Sep 2024 16:13:48 -0400
Message-ID: <20240930201358.2638665-3-aahringo@redhat.com>
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

The DLM configfs path has usually a nodeid in it's directory path and
again a file to store the nodeid again in a separate storage. It is
forced that the user space will set both (the directory name and nodeid
file) storage to the same value if it doesn't do that we run in some
kind of broken state.

This patch will simply represent the file storage to it's upper
directory nodeid name. It will force the user now to use a valid
unsigned int as nodeid directory name and will ignore all nodeid writes
in the nodeid file storage as this will now always represent the upper
nodeid directory name.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/config.c | 53 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 18 deletions(-)

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index eac96f1c1d74..1b213b5beb19 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -24,9 +24,9 @@
 #include "lowcomms.h"
 
 /*
- * /config/dlm/<cluster>/spaces/<space>/nodes/<node>/nodeid
+ * /config/dlm/<cluster>/spaces/<space>/nodes/<node>/nodeid (refers to <node>)
  * /config/dlm/<cluster>/spaces/<space>/nodes/<node>/weight
- * /config/dlm/<cluster>/comms/<comm>/nodeid
+ * /config/dlm/<cluster>/comms/<comm>/nodeid (refers to <comm>)
  * /config/dlm/<cluster>/comms/<comm>/local
  * /config/dlm/<cluster>/comms/<comm>/addr      (write only)
  * /config/dlm/<cluster>/comms/<comm>/addr_list (read only)
@@ -517,6 +517,12 @@ static void release_space(struct config_item *i)
 static struct config_item *make_comm(struct config_group *g, const char *name)
 {
 	struct dlm_comm *cm;
+	unsigned int nodeid;
+	int rv;
+
+	rv = kstrtouint(name, 0, &nodeid);
+	if (rv)
+		return ERR_PTR(rv);
 
 	cm = kzalloc(sizeof(struct dlm_comm), GFP_NOFS);
 	if (!cm)
@@ -528,7 +534,7 @@ static struct config_item *make_comm(struct config_group *g, const char *name)
 	if (!cm->seq)
 		cm->seq = dlm_comm_count++;
 
-	cm->nodeid = -1;
+	cm->nodeid = nodeid;
 	cm->local = 0;
 	cm->addr_count = 0;
 	cm->mark = 0;
@@ -555,16 +561,25 @@ static void release_comm(struct config_item *i)
 static struct config_item *make_node(struct config_group *g, const char *name)
 {
 	struct dlm_space *sp = config_item_to_space(g->cg_item.ci_parent);
+	unsigned int nodeid;
 	struct dlm_node *nd;
+	uint32_t seq = 0;
+	int rv;
+
+	rv = kstrtouint(name, 0, &nodeid);
+	if (rv)
+		return ERR_PTR(rv);
 
 	nd = kzalloc(sizeof(struct dlm_node), GFP_NOFS);
 	if (!nd)
 		return ERR_PTR(-ENOMEM);
 
 	config_item_init_type_name(&nd->item, name, &node_type);
-	nd->nodeid = -1;
+	nd->nodeid = nodeid;
 	nd->weight = 1;  /* default weight of 1 if none is set */
 	nd->new = 1;     /* set to 0 once it's been read by dlm_nodeid_list() */
+	dlm_comm_seq(nodeid, &seq);
+	nd->comm_seq = seq;
 
 	mutex_lock(&sp->members_lock);
 	list_add(&nd->list, &sp->members);
@@ -622,16 +637,19 @@ void dlm_config_exit(void)
 
 static ssize_t comm_nodeid_show(struct config_item *item, char *buf)
 {
-	return sprintf(buf, "%d\n", config_item_to_comm(item)->nodeid);
+	unsigned int nodeid;
+	int rv;
+
+	rv = kstrtouint(config_item_name(item), 0, &nodeid);
+	if (WARN_ON(rv))
+		return rv;
+
+	return sprintf(buf, "%u\n", nodeid);
 }
 
 static ssize_t comm_nodeid_store(struct config_item *item, const char *buf,
 				 size_t len)
 {
-	int rc = kstrtoint(buf, 0, &config_item_to_comm(item)->nodeid);
-
-	if (rc)
-		return rc;
 	return len;
 }
 
@@ -772,20 +790,19 @@ static struct configfs_attribute *comm_attrs[] = {
 
 static ssize_t node_nodeid_show(struct config_item *item, char *buf)
 {
-	return sprintf(buf, "%d\n", config_item_to_node(item)->nodeid);
+	unsigned int nodeid;
+	int rv;
+
+	rv = kstrtouint(config_item_name(item), 0, &nodeid);
+	if (WARN_ON(rv))
+		return rv;
+
+	return sprintf(buf, "%u\n", nodeid);
 }
 
 static ssize_t node_nodeid_store(struct config_item *item, const char *buf,
 				 size_t len)
 {
-	struct dlm_node *nd = config_item_to_node(item);
-	uint32_t seq = 0;
-	int rc = kstrtoint(buf, 0, &nd->nodeid);
-
-	if (rc)
-		return rc;
-	dlm_comm_seq(nd->nodeid, &seq);
-	nd->comm_seq = seq;
 	return len;
 }
 
-- 
2.43.0

