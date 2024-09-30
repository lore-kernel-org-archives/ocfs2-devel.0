Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5D81A2C2B
	for <ocfs2-devel@lists.linux.dev>; Mon, 30 Sep 2024 20:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727727265; cv=none; b=NFSx06tT3dUiS+DDzILLDByzR+iIubV3PsLHtWbWpfKn2paBbWw1v+sw3hAfjYqfk4L4hCiwbqHoX+ptY9rrFq9StWrRljBwrOxi99x9yGD+2wI53h4M4u469hlfVADZ/y8H9zZSEKTMl6LU5PtItDTLIj4vaA00uEQYnyoGNIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727727265; c=relaxed/simple;
	bh=yyYkU1ftial3IHB+h4Bmg6vRVbYC0AGupABRCZ1Be54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=srEa48M8/JCKK5CPCZn95ObK+H3xD0AiwPxcrUbV+z56rYMNGHc+9R/7wKmDK7oaTwq41ZImMoOOLvdPsG6EI9cItrAkJ2mhnlNIjoubOAH3G17+tlzQBOfsGZ1ntctE+Yr0c3L4N8OprbEKDzryHdDKr3qNh8W2aBQIFDpZjbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YAhp+R7D; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YAhp+R7D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727727262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y7rP0orM8QjhHGTk8aHIfF2wBCeC8AcAEDsdCZCHuMQ=;
	b=YAhp+R7Dien7K84IE0N1ZxPlptfKjNQkG4iADgD3fpqabPN5LK9UKKEhdgaE1ZJcuIwSOO
	EI/6zEls6qmBHh62au+fGtkut5xkQP+Xm6v7NLjdCz578Ro9VgeC/LF+CyQAP9mwaWsFo4
	YnNZscEw9Xl+9j5wJLS86kWqaHDaNAo=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-44-RBsRsetrNXOiR1nu9iuhdQ-1; Mon,
 30 Sep 2024 16:14:18 -0400
X-MC-Unique: RBsRsetrNXOiR1nu9iuhdQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 685E1196A408;
	Mon, 30 Sep 2024 20:14:16 +0000 (UTC)
Received: from fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com (unknown [10.6.24.150])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 04C4A1955DC7;
	Mon, 30 Sep 2024 20:14:13 +0000 (UTC)
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
Subject: [PATCHv2 dlm/next 04/12] dlm: handle port as __be16 network byte order
Date: Mon, 30 Sep 2024 16:13:50 -0400
Message-ID: <20240930201358.2638665-5-aahringo@redhat.com>
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

This patch handles the DLM listen port setting internally as byte order
as it is a value that is used as network byte on the wire. The user
space still sets this value as host byte order for configfs as we don't
break UAPI here.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/config.c   | 55 +++++++++++++++++++++++++++++++++++------------
 fs/dlm/config.h   |  2 +-
 fs/dlm/lowcomms.c |  8 +++----
 3 files changed, 46 insertions(+), 19 deletions(-)

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index 1b213b5beb19..77a86c180d0e 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -73,7 +73,7 @@ const struct rhashtable_params dlm_rhash_rsb_params = {
 
 struct dlm_cluster {
 	struct config_group group;
-	unsigned int cl_tcp_port;
+	__be16 cl_tcp_port;
 	unsigned int cl_buffer_size;
 	unsigned int cl_rsbtbl_size;
 	unsigned int cl_recover_timer;
@@ -132,6 +132,45 @@ static ssize_t cluster_cluster_name_store(struct config_item *item,
 
 CONFIGFS_ATTR(cluster_, cluster_name);
 
+static ssize_t cluster_tcp_port_show(struct config_item *item, char *buf)
+{
+	return sprintf(buf, "%u\n", be16_to_cpu(dlm_config.ci_tcp_port));
+}
+
+static int dlm_check_zero_and_dlm_running(unsigned int x)
+{
+	if (!x)
+		return -EINVAL;
+
+	if (dlm_lowcomms_is_running())
+		return -EBUSY;
+
+	return 0;
+}
+
+static ssize_t cluster_tcp_port_store(struct config_item *item,
+				      const char *buf, size_t len)
+{
+	int rc;
+	u16 x;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	rc = kstrtou16(buf, 0, &x);
+	if (rc)
+		return rc;
+
+	rc = dlm_check_zero_and_dlm_running(x);
+	if (rc)
+		return rc;
+
+	dlm_config.ci_tcp_port = cpu_to_be16(x);
+	return len;
+}
+
+CONFIGFS_ATTR(cluster_, tcp_port);
+
 static ssize_t cluster_set(struct dlm_cluster *cl, unsigned int *cl_field,
 			   int *info_field, int (*check_cb)(unsigned int x),
 			   const char *buf, size_t len)
@@ -191,17 +230,6 @@ static int dlm_check_protocol_and_dlm_running(unsigned int x)
 	return 0;
 }
 
-static int dlm_check_zero_and_dlm_running(unsigned int x)
-{
-	if (!x)
-		return -EINVAL;
-
-	if (dlm_lowcomms_is_running())
-		return -EBUSY;
-
-	return 0;
-}
-
 static int dlm_check_zero(unsigned int x)
 {
 	if (!x)
@@ -218,7 +246,6 @@ static int dlm_check_buffer_size(unsigned int x)
 	return 0;
 }
 
-CLUSTER_ATTR(tcp_port, dlm_check_zero_and_dlm_running);
 CLUSTER_ATTR(buffer_size, dlm_check_buffer_size);
 CLUSTER_ATTR(rsbtbl_size, dlm_check_zero);
 CLUSTER_ATTR(recover_timer, dlm_check_zero);
@@ -974,7 +1001,7 @@ int dlm_our_addr(struct sockaddr_storage *addr, int num)
 #define DEFAULT_CLUSTER_NAME      ""
 
 struct dlm_config_info dlm_config = {
-	.ci_tcp_port = DEFAULT_TCP_PORT,
+	.ci_tcp_port = cpu_to_be16(DEFAULT_TCP_PORT),
 	.ci_buffer_size = DLM_MAX_SOCKET_BUFSIZE,
 	.ci_rsbtbl_size = DEFAULT_RSBTBL_SIZE,
 	.ci_recover_timer = DEFAULT_RECOVER_TIMER,
diff --git a/fs/dlm/config.h b/fs/dlm/config.h
index ed237d910208..9cb4300cce7c 100644
--- a/fs/dlm/config.h
+++ b/fs/dlm/config.h
@@ -29,7 +29,7 @@ extern const struct rhashtable_params dlm_rhash_rsb_params;
 #define DLM_PROTO_SCTP	1
 
 struct dlm_config_info {
-	int ci_tcp_port;
+	__be16 ci_tcp_port;
 	int ci_buffer_size;
 	int ci_rsbtbl_size;
 	int ci_recover_timer;
diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index cb3a10b041c2..df40c3fd1070 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -660,18 +660,18 @@ static void add_sock(struct socket *sock, struct connection *con)
 
 /* Add the port number to an IPv6 or 4 sockaddr and return the address
    length */
-static void make_sockaddr(struct sockaddr_storage *saddr, uint16_t port,
+static void make_sockaddr(struct sockaddr_storage *saddr, __be16 port,
 			  int *addr_len)
 {
 	saddr->ss_family =  dlm_local_addr[0].ss_family;
 	if (saddr->ss_family == AF_INET) {
 		struct sockaddr_in *in4_addr = (struct sockaddr_in *)saddr;
-		in4_addr->sin_port = cpu_to_be16(port);
+		in4_addr->sin_port = port;
 		*addr_len = sizeof(struct sockaddr_in);
 		memset(&in4_addr->sin_zero, 0, sizeof(in4_addr->sin_zero));
 	} else {
 		struct sockaddr_in6 *in6_addr = (struct sockaddr_in6 *)saddr;
-		in6_addr->sin6_port = cpu_to_be16(port);
+		in6_addr->sin6_port = port;
 		*addr_len = sizeof(struct sockaddr_in6);
 	}
 	memset((char *)saddr + *addr_len, 0, sizeof(struct sockaddr_storage) - *addr_len);
@@ -1121,7 +1121,7 @@ static void writequeue_entry_complete(struct writequeue_entry *e, int completed)
 /*
  * sctp_bind_addrs - bind a SCTP socket to all our addresses
  */
-static int sctp_bind_addrs(struct socket *sock, uint16_t port)
+static int sctp_bind_addrs(struct socket *sock, __be16 port)
 {
 	struct sockaddr_storage localaddr;
 	struct sockaddr *addr = (struct sockaddr *)&localaddr;
-- 
2.43.0

