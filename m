Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792501978;
	b=Ut4jrHtWMiexCniDH2nJkQWbaeE0Qf0XbOo0HWM++wAF6KNan1FGNgUbpRLoCkBhXKnZ
	 dtBmizDphzqgasYyUENtGEvdWkFR+UL6+8FEqzk/wSBWPCJAJS67bLlJZ0DYU3VCx+qEQ
	 6WnNv+ThXbnsepGHRQxMYWkPEDc1BzFqE1pjYmR2RYJ4MXS6TRR9dzwKygD0+22NXMoTh
	 SrXpghrX0wsLWb+Nh9+4RyCscDv7xn8CgAiMRCrOYpkIBmltmCoAFmUZjxa5MbSGr8ugc
	 olagytFZ2ot4PUcjGj3vjrrRqBBieUXqCzwAWfGDEal9zm5s2TmVbM4pLugrGZ8WQGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792501978;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=GXRYtUbRh38fe0NTnBbIezCa9WUPMrbWF4pq21pcnKs=;
	b=RLkrVue9RylKV0Vvn9kSDQdnau6Bz7De3R/YeLh8I+DObed2ezmWZf0N7VP7N3NFw5Nt
	 TQ3c837ktWw0/XRy/lcWn65lS4K+PqzLEjctvlekuAG7PPPOSrz3LGOV5Zs7koJZdhUHX
	 2r6kogL/vTvoXTA5jJ6g5GFN6Ku5x2yx79GCtQkth32yC4jFh0ZY2sN6agnwuHsUWnfsJ
	 Z+48SDC5ZwMRu0uYEMJ3zWzEhKtWz6n2LvNntKndbG4eLU3rKfpHENratTYZClj6zrsgS
	 IFHyv+a4rpYsHEPljlUO7grc9sOR2PZAmsaGzzkRNtiN9dBuTzvVCN9vxUWF/eEhyyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="H6/O3Nha";
	arc=none smtp.remote-ip=209.85.214.172
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D53E606A31F
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Oct 2026 13:12:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D53E606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=H6/O3Nha
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ea1e7fad99so4169315ad.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 20 Oct 2026 06:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792501978; x=1793106778; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GXRYtUbRh38fe0NTnBbIezCa9WUPMrbWF4pq21pcnKs=;
        b=H6/O3NhazIEpAaaCaExau2YOdBUVLfVFDe/CjeCe44POwJclK3Avsljdwr06xgdz8N
         kOdKmbystYcAjF8GG7+xCztq5ZOE0DoEFIJBfjg6emK6UE+h8Bk4clKvNmJMqIPTDTFx
         ayGI8+L361bRNXyMd5CHXtu6qKSBWmGUxW0fSREfDB4G43VG0VdpItJ/V31ZgEAv6AV3
         o1VEdCDFYcKsEJY3C9zb5q9G8Ldz7AQvhQVbjy4oGe/yr5TyQlm+4vkG0HpiDtcx3KjN
         xTlf88r+gOtwCe9zCP9VOCeOJ2umIRsilzQoG+NRK+FTvkPQhr9mo63FnmwiVI8tmOMn
         ORpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792501978; x=1793106778;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GXRYtUbRh38fe0NTnBbIezCa9WUPMrbWF4pq21pcnKs=;
        b=TwVctpg4NyWp0DHt0qIFgp3wrFfSA+kyH8d3VT8rDe2DoXZSELRWd9sJ1pDiEP+NPQ
         ERioaH5nCn+7N2bZK5+ajw3hFtF0+F4YTJI8xpafCwBUDsoUSYIySOLksASp3C0h10cK
         bG4WESLD3zPKwlurznEsR/vJY8yyr5wrl/IXbLJ0NKx9LFWTp7CV3hDHApBb70YwsD0a
         She5HNXx00bYL+a2FAc9y8VrLDxQOLKdNm2LxB1ZRezc09q0YMpKJDFAERBbqWukJk2m
         Dg0fUE47luYhz0R1vYgu34MzBx+P7Gt81LjAwEOmARkYWQMrljOJNbF1SsD9xabd5TfB
         IiZg==
X-Forwarded-Encrypted: i=1; AKwUvBxmBksICg7PRSlxLguh6DJ7uB7HsPGdAfE8WresjL/ymBL8HyO/ISTwCxnuaAK1bBqQ8cw8rYmWAewRGA==@lists.linux.dev
X-Gm-Message-State: AFq9FYImNVyywL0R1Rwmhq7zCFRhKZ6xzep+FZCXbGkuBmKdh39GJuum
	YHk7Byt2LQAg9gjViD0DpTmUmDdgJEJZ6jURu4eXyvJpAYwiKKioHhlK
X-Gm-Gg: AYBFou3wTlE7LUYSot3/bgtyPBkHxWcAOSZnxcFpi2zByjJdOLl8T9JRjJvksYLIHOM
	Aweb2Fuskt40/tfmvi19pwBxVsXQdv+xqLBLKcWj/wkW9A8+kmS+P8+IhI3slkxrOvSUlhvli/J
	2Hsy/uO5pWhytrAKghkrwzTR1a334IQ1gFtfjZsRxjUgVgGnKCDI8cU9W3DNVmmW4H9Cbon+SJO
	ObD+lGAWlhzue4mB9bCr9XqqFApdQJAqgWEUiwexh4mep19D+veUXXOiQ3nLCiwc5jUt0/SXvQN
	mUe+KeP4m09+tOa3jA/5Bi+yor/pNGJoTxMjNq6gv0n6HrzeVTSVMbrqrOncf29Qga01ifNuWxn
	1Vmk5x6iyy4Jqlq598WRfgdyofxyw9W1DPLlCJjTk+HeUcnnp/y3mFc0mbxN4WLzpdZ17tH8jDA
	WAveAXhalst3uDJ3qFDOZ2cdw3xneFCobuCy0itGeV12JmhgUEVXYN/UMm3KugX7ft71Cqm4T38
	omt/g==
X-Received: by 2002:a17:903:1a2b:b0:2e6:13b1:e196 with SMTP id d9443c01a7336-2e9a73571b7mr84573785ad.74.1792501977648;
        Tue, 20 Oct 2026 06:12:57 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea1502d425sm11910725ad.49.2026.10.20.06.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 06:12:57 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: heming.zhao@suse.com,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	baijiaju1990@gmail.com,
	jjzuming@gmail.com,
	zzzccc427@gmail.com
Subject: [PATCH] ocfs2/cluster: remove zero-address nodes from IP tree on teardown
Date: Tue, 20 Oct 2026 21:12:50 +0800
Message-Id: <pm-ocfs2-node-ip-rbtree-zero-address-uaf-v5-e7f64be16b7c3b0988d1@gmail.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

o2nm_node_ipv4_address_store() accepts 0.0.0.0. It sets
O2NM_NODE_ATTR_ADDRESS and links nd_ip_node into cl_node_ip_tree under
cl_nodes_lock, but o2nm_node_group_drop_item() uses nd_ipv4_address as a
membership test. A zero address therefore leaves the rbtree node linked
when config_item_put() releases and frees struct o2nm_node. A later
address store or IP lookup can then walk the stale node and dereference
freed memory.

During teardown, drop_item takes cl_nodes_lock, skips rb_erase()
for the zero key, and then calls config_item_put(). A later
o2nm_node_ipv4_address_store() duplicate check or o2nm_get_node_by_ip()
lookup takes the same lock and walks the stale cl_node_ip_tree entry. Use
O2NM_NODE_ATTR_ADDRESS for teardown so every published nd_ip_node is
erased before configfs can release the node, without rejecting 0.0.0.0
or changing lookup semantics.

Fixes: 0c83ed8eeb28 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
 fs/ocfs2/cluster/nodemanager.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index e08850a5d736..be184c5ad54d 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -626,8 +626,11 @@ static void o2nm_node_group_drop_item(struct config_group *group,
 
 	write_lock(&cluster->cl_nodes_lock);
 
-	/* XXX sloppy */
-	if (node->nd_ipv4_address)
+	/*
+	 * 0.0.0.0 is a valid configured address, so nd_ipv4_address does
+	 * not tell us whether nd_ip_node was published in the IP tree.
+	 */
+	if (test_bit(O2NM_NODE_ATTR_ADDRESS, &node->nd_set_attributes))
 		rb_erase(&node->nd_ip_node, &cluster->cl_node_ip_tree);
 
 	/* nd_num might be 0 if the node number hasn't been set.. */
