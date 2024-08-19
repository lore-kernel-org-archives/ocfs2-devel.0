Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBB318B490
	for <ocfs2-devel@lists.linux.dev>; Mon, 19 Aug 2024 18:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724092706; cv=none; b=mZtCrTO+4IUMc3wJmt+mdGs/QjYtwLbTO9+DE5B/alqgC3X7miJRbgNWPFEySYG70S8QbR116+mpt4P+9bb8I4E3FqSQwiYOUwZSVS41mMdLGbDNg2OcRY4Nxeki5H5iGlAUlwHoJJCFLhs8dmyLRtssHO7AzVvv3OyH1kZjlSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724092706; c=relaxed/simple;
	bh=U0nOA7Z1A1/Dy25L8IFvcBZsOwg8CiDXCZ/aPn74aWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SPgp5JozbLOzVMSrLwIjaLtD5w6ikFWV/5v1g1Z/0WfZDvh/I9/ae3LR4q+D6H4PsO9zYlRmbumOkBjhc8PVcQko4NAhfYdx0Midr8o6mdK6hnhDh0ZwgyTAUjmSADjdicpZ6SBev8UOvr8kEf9xdqO/TUGOJZX2j2roz0kZuts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Sybr5Mbo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sybr5Mbo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724092703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gRLptKCiXpp4gNIkR9o/h84xalWa/aBGlKLc9592qnI=;
	b=Sybr5Mbo002W7xMJFHw6f7rXuGzqUZn5u8fEw8gSYdGHyjdrG1QGZQ5S+p/rIUeJ/llzFs
	v6jD8ddAEHY7ay2/zvDIDBypmyaR1JMJbVKqceGgZ3v5VrCaC/nIvboX2fndOsn43NO6lz
	+zXxIHzYg9qaBjJq2lfOTx217ZGVcc0=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-336-GaVGPgepPiKUezWf1dZNLw-1; Mon,
 19 Aug 2024 14:38:19 -0400
X-MC-Unique: GaVGPgepPiKUezWf1dZNLw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BC9771955D57;
	Mon, 19 Aug 2024 18:38:16 +0000 (UTC)
Received: from fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com (fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com [10.6.24.150])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B03EA1955F44;
	Mon, 19 Aug 2024 18:38:13 +0000 (UTC)
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
	aahringo@redhat.com
Subject: [PATCH dlm/next 06/12] dlm: dlm_config_info config fields to unsigned int
Date: Mon, 19 Aug 2024 14:37:36 -0400
Message-ID: <20240819183742.2263895-7-aahringo@redhat.com>
In-Reply-To: <20240819183742.2263895-1-aahringo@redhat.com>
References: <20240819183742.2263895-1-aahringo@redhat.com>
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

