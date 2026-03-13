Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AE44086A
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Mar 2026 22:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773439335; cv=none; b=LYx/P4gUd2/MsP84Iv2o0w/jEeJmrsO/eU9zCXh8Uoi3j4HDmOOVl2ddOjN4BwwheL3lETcs7D7hdgbiiWcyNME/KhXP0OjtIaEe9Koay8pi0+6h1uXIQ4+twRetXHt93MifBzXN1xaFVScBhUGY2Iu7sN1JFfXJNpdIeNSkvBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773439335; c=relaxed/simple;
	bh=dMG7HhbWmFCRAg0bz6Q6kUd7FAZ/581te2YWJ188pXM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=t3i+4ZqyGcn4p+2lE3X0oODbniWo3mLD5WUjVT+eta9Tg1BleTSHm44JjK+1KyEgyKKhdzB8fsw30C75OZrkE12Xd5zBlp3liIouldiSbfBUS8xUBA1PD47jO8NDwFT+hKuyOQDMhqnZHHcBaupmh4XPcPm4MBH7fJVCeTIAguU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WkKTPktt; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WkKTPktt"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8cd8c6e365eso273899985a.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 13 Mar 2026 15:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773439333; x=1774044133; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2+gHeRBeWFeZC5PFsQ43Y+A/0chzwDyT4HCPX1fo8qU=;
        b=WkKTPkttWcIxzK6RkKOl2yuS49l63sA4+cxu2eyP1G5dXRu8MFDlvyOfrv2kzKaqXm
         8M1eHMNL1wrKmtNhLCdiTJiQTASzHmMerNWflCisKiZ6+o5EQhrBrg6FbcnqvdmHB0FQ
         cTosjtb64No8n5qUgO8G/6wvWs2uyHqfnjos2k7ysSOTJp5Hd0rS3a6UcHl7m4ptffaH
         wzIcbeLTPzvsWGVhv+C76Gr4De3XGe6Oluh5GsRUfYwSGxElCM6yz3MBTp3E3wgCodk3
         ZsMfixOvfCOgNeWUkANzaK7eGShQKIwy2IUaNvfVU7hVls+1RNQGMmlIaxuYBj0PoxO5
         0Z5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773439333; x=1774044133;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2+gHeRBeWFeZC5PFsQ43Y+A/0chzwDyT4HCPX1fo8qU=;
        b=lZjlO+K1Y63vpG2OnK9NJNa4Nm8B8g6ixZappmCsfqCUrSoHNY+YkgVKwxGv0Y2MRn
         EysPW7EiiRi5jfx4UI2y89wST94hxl7gmJsCepADFBp6qp/7sIfUvlrOJ8Q1KbySGJyH
         9L22hVdWxLgbo9ANXl1dbAmSksxOeVdvy1aASX7hVZjDesxk3xeeuHbdM6myf/fS09k6
         pY2LUgY6adEIM/VdKRVVjPjlFZQRTDr+NQfWN18iTRnkxE1WnGmglmvZ9emanXwKuXpC
         VpSidTF64Ph4p6Vz2aab0xJxabNUYPKioEhWO6spqvaIBLc14XM+4MiOEf1mUlLVM1BJ
         BQDw==
X-Gm-Message-State: AOJu0YwK4VZyy6e2NxF5OD0/pVKnKjdo/MIRi3iQ4JgSHLNZ+3H2LYa1
	u/HO/cOAfjgjRl1PFjFDmUoXxnlzsXYdClolozzBCOEbZZMjqzEybuaY
X-Gm-Gg: ATEYQzzPhmkkQJ/cHxlBddrtoPZTL2/mGB6D/6ft1p24eQc/Ux2dBKurgcPFA8pnZbM
	uyyRurhEg+mBrO+shNqYqtE0QD/p3E5CcrJPY4g1EouAQnSSL8VAJ9BfgZJ7d5k4N0kdkHB8K4j
	Wt9stQ9uQem2KR/zjm9GyRT+qa5eoAaXxnJDPQnG62cX/tn4ZQU1QDDACvwvAzWXXjrmzmX7qfi
	Uzua2XcuZt65HHCk1sZGYFgzPQdpaMhmrwFNgAlmlColX5IfIxgXVGoJtXvFQoTR9IAt/oJh5My
	vUd/puBzF6RIYPD5J1fF6tuXw87MkCpWU/35YgvJaRsvsPlRZNLq+b7ESEBcENTdnNL8NaDDCES
	IpgZiPNsKJ25lz3j51PYT0xaQ47dqOBTC/hkHgYGwv0TsANNhyUn5kfr/qrRHwx30QQyrlpYnph
	unP5RU105pM9nRId0vg0rYPjhZ5h6eJ+vSP32GNE4ZhSmb
X-Received: by 2002:a05:622a:4e:b0:509:1c5e:1062 with SMTP id d75a77b69052e-50957b88869mr70338891cf.3.1773439332758;
        Fri, 13 Mar 2026 15:02:12 -0700 (PDT)
Received: from 192-222-50-213.ll.local ([192.222.50.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5095ce7d853sm26033581cf.28.2026.03.13.15.02.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 15:02:12 -0700 (PDT)
From: Jenny Guanni Qu <qguanni@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	klaudia@vidocsecurity.com,
	dawid@vidocsecurity.com,
	Jenny Guanni Qu <qguanni@gmail.com>
Subject: [PATCH] ocfs2: dlm: validate query region message length and fields
Date: Fri, 13 Mar 2026 22:02:12 +0000
Message-Id: <20260313220212.143925-1-qguanni@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

dlm_query_region_handler() casts msg->buf to struct dlm_query_region
and accesses its fields without verifying that the received message
length is at least sizeof(struct dlm_query_region). A short message
from a cluster peer can cause out-of-bounds reads.

Additionally, qr->qr_namelen is not validated before being passed to
__dlm_lookup_domain_full() which uses it as a memcmp length,
qr->qr_numregions is used as a loop bound for iterating qr_regions[]
without checking it is within O2NM_MAX_REGIONS, and qr->qr_domain is
logged with %s which reads until a NUL terminator that may not exist
within the received payload.

Add a message length check, validate qr_namelen against
O2NM_MAX_NAME_LEN, validate qr_numregions against O2NM_MAX_REGIONS,
and use %.*s for bounded logging.

The OOB read pattern was confirmed with KASAN using a test module
that accesses fields past a short kmalloc'd buffer matching the
handler's cast pattern.

Fixes: ea2034416b54 ("ocfs2/dlm: Add message DLM_QUERY_REGION")
Reported-by: Klaudia Kloc <klaudia@vidocsecurity.com>
Reported-by: Dawid Moczadło <dawid@vidocsecurity.com>
Tested-by: Jenny Guanni Qu <qguanni@gmail.com>
Signed-off-by: Jenny Guanni Qu <qguanni@gmail.com>
---
 fs/ocfs2/dlm/dlmdomain.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 2018501b2249..d81e41bd231b 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1100,10 +1100,19 @@ static int dlm_query_region_handler(struct o2net_msg *msg, u32 len,
 	char *local = NULL;
 	int status = 0;
 
+	if (len < sizeof(struct dlm_query_region))
+		return -EINVAL;
+
 	qr = (struct dlm_query_region *) msg->buf;
 
-	mlog(0, "Node %u queries hb regions on domain %s\n", qr->qr_node,
-	     qr->qr_domain);
+	if (qr->qr_namelen >= O2NM_MAX_NAME_LEN)
+		return -EINVAL;
+
+	if (qr->qr_numregions >= O2NM_MAX_REGIONS)
+		return -EINVAL;
+
+	mlog(0, "Node %u queries hb regions on domain %.*s\n", qr->qr_node,
+	     qr->qr_namelen, qr->qr_domain);
 
 	/* buffer used in dlm_mast_regions() */
 	local = kmalloc(sizeof(qr->qr_regions), GFP_KERNEL);
-- 
2.34.1

