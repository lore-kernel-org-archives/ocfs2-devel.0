Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1121A3026
	for <ocfs2-devel@lists.linux.dev>; Mon, 30 Sep 2024 20:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727727267; cv=none; b=gVBCJ/IBYiRL4c45qHFl9+psowMViGtyHWQprMV9tcXJ4vW6IfBuQ1HOxw687E1na7hx31CrhP3ytOKVI6T97nQxzBZxj/ExVeAeEAdtvjthIEGRpeCkcDjtE7g3mTZ55RBEHRr5G8CF/5cg/qL0cEZGets7MDDdePtIYuD0lUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727727267; c=relaxed/simple;
	bh=CDghhemlnnZe9puChcu2OexM6x8XJKY/jXW1OWqPggg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8cc50erW453rDuRxv3Aov4WMTevnGN3nTHK4CIkmxEUw+BuiVMFfVYVh6kK9RETud/JKoOj18BxAUFITbTKxUkKHDgZagaPuQeP0+jODlKMKOJddCYGFVf6LZyYheASGBilOZEyEdzyrij99pDVbegSj0eQFawOTLh8SAeA3+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X2Wj/nH6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X2Wj/nH6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727727264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T8ECzptBQ1lW5D8O8jXzi9piamrkZVJk+YJzrikZLng=;
	b=X2Wj/nH6M8jAFKDjRLoPwZhCkz3WOgjVA52n/wZ8mzV6UWXw4uze0BdaexKFya7OTM3USj
	PPJK2J2avoXgllV39BEI0aekynO5OZw/V3YQLvs+LerI005BGyQTLwgEmJJyTaQCz/sH1i
	zzMOQolpRA5zNR69Tx+p8PGeQgnJrk0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-630-GenGo7WMMAWgM8R1IE95ow-1; Mon,
 30 Sep 2024 16:14:21 -0400
X-MC-Unique: GenGo7WMMAWgM8R1IE95ow-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0A8A91978F59;
	Mon, 30 Sep 2024 20:14:19 +0000 (UTC)
Received: from fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com (unknown [10.6.24.150])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9BA981955DC7;
	Mon, 30 Sep 2024 20:14:16 +0000 (UTC)
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
Subject: [PATCHv2 dlm/next 05/12] dlm: use dlm_config as only cluster configuration
Date: Mon, 30 Sep 2024 16:13:51 -0400
Message-ID: <20240930201358.2638665-6-aahringo@redhat.com>
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

This patch removes the configfs storage fields from the dlm_cluster
structure to store per cluster values. Those fields also exists for the
dlm_config global variable and get stored in both when setting configfs
values. To read values it will always be read out from the dlm_cluster
configfs structure but this patch changes it to only use the global
dlm_config variable. Storing them in two places makes no sense as both
are able to be changed under certain conditions during DLM runtime.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/config.c | 47 +++++------------------------------------------
 1 file changed, 5 insertions(+), 42 deletions(-)

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index 77a86c180d0e..d9cde614ddd4 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -73,20 +73,6 @@ const struct rhashtable_params dlm_rhash_rsb_params = {
 
 struct dlm_cluster {
 	struct config_group group;
-	__be16 cl_tcp_port;
-	unsigned int cl_buffer_size;
-	unsigned int cl_rsbtbl_size;
-	unsigned int cl_recover_timer;
-	unsigned int cl_toss_secs;
-	unsigned int cl_scan_secs;
-	unsigned int cl_log_debug;
-	unsigned int cl_log_info;
-	unsigned int cl_protocol;
-	unsigned int cl_mark;
-	unsigned int cl_new_rsb_count;
-	unsigned int cl_recover_callbacks;
-	char cl_cluster_name[DLM_LOCKSPACE_LEN];
-
 	struct dlm_spaces *sps;
 	struct dlm_comms *cms;
 };
@@ -115,18 +101,14 @@ enum {
 
 static ssize_t cluster_cluster_name_show(struct config_item *item, char *buf)
 {
-	struct dlm_cluster *cl = config_item_to_cluster(item);
-	return sprintf(buf, "%s\n", cl->cl_cluster_name);
+	return sprintf(buf, "%s\n", dlm_config.ci_cluster_name);
 }
 
 static ssize_t cluster_cluster_name_store(struct config_item *item,
 					  const char *buf, size_t len)
 {
-	struct dlm_cluster *cl = config_item_to_cluster(item);
-
 	strscpy(dlm_config.ci_cluster_name, buf,
-				sizeof(dlm_config.ci_cluster_name));
-	strscpy(cl->cl_cluster_name, buf, sizeof(cl->cl_cluster_name));
+		sizeof(dlm_config.ci_cluster_name));
 	return len;
 }
 
@@ -171,8 +153,7 @@ static ssize_t cluster_tcp_port_store(struct config_item *item,
 
 CONFIGFS_ATTR(cluster_, tcp_port);
 
-static ssize_t cluster_set(struct dlm_cluster *cl, unsigned int *cl_field,
-			   int *info_field, int (*check_cb)(unsigned int x),
+static ssize_t cluster_set(int *info_field, int (*check_cb)(unsigned int x),
 			   const char *buf, size_t len)
 {
 	unsigned int x;
@@ -190,7 +171,6 @@ static ssize_t cluster_set(struct dlm_cluster *cl, unsigned int *cl_field,
 			return rc;
 	}
 
-	*cl_field = x;
 	*info_field = x;
 
 	return len;
@@ -200,14 +180,11 @@ static ssize_t cluster_set(struct dlm_cluster *cl, unsigned int *cl_field,
 static ssize_t cluster_##name##_store(struct config_item *item, \
 		const char *buf, size_t len) \
 {                                                                             \
-	struct dlm_cluster *cl = config_item_to_cluster(item);		      \
-	return cluster_set(cl, &cl->cl_##name, &dlm_config.ci_##name,         \
-			   check_cb, buf, len);                               \
+	return cluster_set(&dlm_config.ci_##name, check_cb, buf, len);        \
 }                                                                             \
 static ssize_t cluster_##name##_show(struct config_item *item, char *buf)     \
 {                                                                             \
-	struct dlm_cluster *cl = config_item_to_cluster(item);		      \
-	return snprintf(buf, PAGE_SIZE, "%u\n", cl->cl_##name);               \
+	return snprintf(buf, PAGE_SIZE, "%u\n", dlm_config.ci_##name);        \
 }                                                                             \
 CONFIGFS_ATTR(cluster_, name);
 
@@ -450,20 +427,6 @@ static struct config_group *make_cluster(struct config_group *g,
 	configfs_add_default_group(&sps->ss_group, &cl->group);
 	configfs_add_default_group(&cms->cs_group, &cl->group);
 
-	cl->cl_tcp_port = dlm_config.ci_tcp_port;
-	cl->cl_buffer_size = dlm_config.ci_buffer_size;
-	cl->cl_rsbtbl_size = dlm_config.ci_rsbtbl_size;
-	cl->cl_recover_timer = dlm_config.ci_recover_timer;
-	cl->cl_toss_secs = dlm_config.ci_toss_secs;
-	cl->cl_scan_secs = dlm_config.ci_scan_secs;
-	cl->cl_log_debug = dlm_config.ci_log_debug;
-	cl->cl_log_info = dlm_config.ci_log_info;
-	cl->cl_protocol = dlm_config.ci_protocol;
-	cl->cl_new_rsb_count = dlm_config.ci_new_rsb_count;
-	cl->cl_recover_callbacks = dlm_config.ci_recover_callbacks;
-	memcpy(cl->cl_cluster_name, dlm_config.ci_cluster_name,
-	       DLM_LOCKSPACE_LEN);
-
 	space_list = &sps->ss_group;
 	comm_list = &cms->cs_group;
 	return &cl->group;
-- 
2.43.0

