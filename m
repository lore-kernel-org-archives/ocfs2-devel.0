Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C7513DDDD
	for <ocfs2-devel@lists.linux.dev>; Fri, 12 Jul 2024 07:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720770780; cv=none; b=Fe740lWjOZsuHII6fO5ph4sFqoUjbYwn7mIhiLbKIr/4c2JDKTZOHrlZSenwH342+WwtHjvark3/OiubMNwWRAqoeTveS+/qV2a5Sz+5tEeRAvg+PhydeWn/vnwEz2eutf/8fPCeGywFnsD5RgyeE/x8FSTsPxGw3JdHRuS3hLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720770780; c=relaxed/simple;
	bh=LJzFcaO6EhsCzg/RRLtr12hGEwHpHzuasg4wu0U5ahU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PDDMT8OwGiiUf8k2OmbM/fDqOWuKirdBGTOks9NCVr2LNF9UPx4Y3PYdfBXBK0TiU1N0oHvVBwrbUAWw9QdSpGDPzq0l+2GkmCSRnGRPwmRjie6wNIDGtTtulrdixgyqlCZuZiDp+8TNONhtYjSfHRaPvfHpbvRkbfY2LsLQz/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xd4KAZcy; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xd4KAZcy"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-389ccd2f0abso5761115ab.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 12 Jul 2024 00:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720770778; x=1721375578; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UVQecFZQw5pq7o5g7m6MGek0nnZHT+/jF3xC6kNu4h8=;
        b=Xd4KAZcyUy8UcV7aBQsuPYvB4ovNUV3hVZEHBmHPVTxzUNdfRyxyU1TpCQjm2WKCM3
         LbbnFEJQEFP0YO96TJW5yR+D2BIxzyuS5bbhvBQ0gvl8SfCb1g9uVli3LXXHqZ6SJCdg
         AO3269dxYDMqF+23ZU87DFpi+bh9wItWmCTLtB5TMmHzS9GauIJHQ9lP/rZ9Pz7g/gyG
         ClbdcysJOPWFWxbqdX1JKXdrOXfoI31iS9K3Jj9KsoAuH5ZZueSE2IN53X5CYKZbI7UO
         K3shf7B7sc68pn3AfulgNu//iVXUX+Zd4AIDYN5sZb58Zcp2Djhgumj51A3jlBvR2pIF
         oonQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720770778; x=1721375578;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UVQecFZQw5pq7o5g7m6MGek0nnZHT+/jF3xC6kNu4h8=;
        b=JbzmZRD05DQLWQH/6mykdDcHE63FSzgresvlruFnjurkNYsXtDHiKQjbrmW9MWHPiK
         KuUP4UPYZbjEleNcevvJlLWSsXClT9+u2EtkZ9nD5c5qrEYJ+ekAV0aIO3WKFN9gxkOQ
         LHuD0w2xsSmc53iYfeFrSL1RuDfnHbgV+E5oBignMIWb5PJ8KX1TAwZ6caPpa2ZPhota
         kUc8tVzApq4CPFWI8TWpbe437iJUpY8VZi248zK+p9fpoFnAnsEiNDDCcamCsXE+dXci
         7ANKpxm4ckPRuwY/+09zo3aMw+0ozsbsu7ZONFT9HIihIEkcagAJ/LQMJFoHUnXkrG76
         GkcQ==
X-Gm-Message-State: AOJu0YzSmKW1U5Etgi9DauYSpoC9z4oeAMbASUNRYmCziEMklwRgA0ar
	shSpRg3kDdhWrrfE0cXgTwfXEHxnqKqPSb9hb6FuEHcJ+wuulnbP
X-Google-Smtp-Source: AGHT+IHKqaI5s8Q13iNv/Hzttv1Yvysgysr7P9Zfb7s3qTANT0kXsnwnsmaGTzPpHTq6TYOEDkx/Iw==
X-Received: by 2002:a05:6e02:1388:b0:374:aa87:bcaa with SMTP id e9e14a558f8ab-38a583980b0mr135180065ab.14.1720770773331;
        Fri, 12 Jul 2024 00:52:53 -0700 (PDT)
Received: from FLYINGPENG-MB1.tencent.com ([103.7.29.30])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b438c6f83sm6834411b3a.82.2024.07.12.00.52.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 12 Jul 2024 00:52:52 -0700 (PDT)
From: flyingpenghao@gmail.com
X-Google-Original-From: flyingpeng@tencent.com
To: mark@fasheh.com,
	jlbec@evilplan.org
Cc: ocfs2-devel@lists.linux.dev,
	Peng Hao <flyingpeng@tencent.com>
Subject: [PATCH]  fs/ocfs2: fix a format error
Date: Fri, 12 Jul 2024 15:52:46 +0800
Message-Id: <20240712075246.48975-1-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Peng Hao <flyingpeng@tencent.com>

Replace spaces with tab.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 fs/ocfs2/cluster/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 2b8fa3e782fb..f7a8158e3ee4 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -846,7 +846,7 @@ int o2net_register_handler(u32 msg_type, u32 key, u32 max_len,
 	if (o2net_handler_tree_lookup(msg_type, key, &p, &parent))
 		ret = -EEXIST;
 	else {
-	        rb_link_node(&nmh->nh_node, parent, p);
+		rb_link_node(&nmh->nh_node, parent, p);
 		rb_insert_color(&nmh->nh_node, &o2net_handler_tree);
 		list_add_tail(&nmh->nh_unregister_item, unreg_list);
 
-- 
2.27.0

