Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3721A38DC
	for <ocfs2-devel@lists.linux.dev>; Mon, 30 Sep 2024 20:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727727270; cv=none; b=IqVaWElUJr6qutwPgYAlvemPe/6KnwN8cP17ee6+7olxd4ZfBj8gFbh4OY5Ni+Iqe/p4wIt2VD14qLXGw5NFad/Zbe15mVmdu7TfB++IWcr3m+ERv9NpFj8Acu4yBR8hZNEA8BctPgfc6jBapCvqNfRm0djpYBpBrBrLvrAVYBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727727270; c=relaxed/simple;
	bh=U0nOA7Z1A1/Dy25L8IFvcBZsOwg8CiDXCZ/aPn74aWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2QaaCuACcP09Zobbmt/ik4SdPhMjMmmiUjQ1ueWAZRUpc+w85J6FbHoAAYiWyKSEVSovCAnD4C7EUKS32VKeGeDQMDXNwqrOWlJI/rz7FOpGx3WjrNWyizKC4SUVyyyK4SsZpWrnkw7bBKBzjd7ytmYyBm2hgOi2sH3e11GpIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OT+LLe5z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OT+LLe5z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727727268;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gRLptKCiXpp4gNIkR9o/h84xalWa/aBGlKLc9592qnI=;
	b=OT+LLe5zCSPSuTluma0ZwYVp4/OiVZVosjFpNQKGPcQ7DorCIMzDGy8YrIJcHtvpaI4ZEZ
	fBrs5rvKLDnJb7mHfeS6xUFdJCNfmQdCZdRvlIcvLL3oZJvbm2kVmuBVe4bClbyCnlwq4c
	grgmxgpptYbd7T/fMHGBzfCVqb01s1Q=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-246--HXvZQgMOESWWm2rmfJuBA-1; Mon,
 30 Sep 2024 16:14:24 -0400
X-MC-Unique: -HXvZQgMOESWWm2rmfJuBA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D0F7019772EC;
	Mon, 30 Sep 2024 20:14:21 +0000 (UTC)
Received: from fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com (unknown [10.6.24.150])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3DADA1955DC7;
	Mon, 30 Sep 2024 20:14:19 +0000 (UTC)
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
Subject: [PATCHv2 dlm/next 06/12] dlm: dlm_config_info config fields to unsigned int
Date: Mon, 30 Sep 2024 16:13:52 -0400
Message-ID: <20240930201358.2638665-7-aahringo@redhat.com>
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

We are using kstrtouint() to parse common integer fields. This patch
will switch to use unsigned int instead of int as we are parsing
unsigned integer values.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/config.c |  3 ++-
 fs/dlm/config.h | 22 +++++++++++-----------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index d9cde614ddd4..a98f0e746e9e 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -153,7 +153,8 @@ static ssize_t cluster_tcp_port_store(struct config_item *item,
 
 CONFIGFS_ATTR(cluster_, tcp_port);
 
-static ssize_t cluster_set(int *info_field, int (*check_cb)(unsigned int x),
+static ssize_t cluster_set(unsigned int *info_field,
+			   int (*check_cb)(unsigned int x),
 			   const char *buf, size_t len)
 {
 	unsigned int x;
diff --git a/fs/dlm/config.h b/fs/dlm/config.h
index 9cb4300cce7c..9abe71453c5e 100644
--- a/fs/dlm/config.h
+++ b/fs/dlm/config.h
@@ -30,17 +30,17 @@ extern const struct rhashtable_params dlm_rhash_rsb_params;
 
 struct dlm_config_info {
 	__be16 ci_tcp_port;
-	int ci_buffer_size;
-	int ci_rsbtbl_size;
-	int ci_recover_timer;
-	int ci_toss_secs;
-	int ci_scan_secs;
-	int ci_log_debug;
-	int ci_log_info;
-	int ci_protocol;
-	int ci_mark;
-	int ci_new_rsb_count;
-	int ci_recover_callbacks;
+	unsigned int ci_buffer_size;
+	unsigned int ci_rsbtbl_size;
+	unsigned int ci_recover_timer;
+	unsigned int ci_toss_secs;
+	unsigned int ci_scan_secs;
+	unsigned int ci_log_debug;
+	unsigned int ci_log_info;
+	unsigned int ci_protocol;
+	unsigned int ci_mark;
+	unsigned int ci_new_rsb_count;
+	unsigned int ci_recover_callbacks;
 	char ci_cluster_name[DLM_LOCKSPACE_LEN];
 };
 
-- 
2.43.0

