Received: from red-soft.ru (red-soft.ru [188.246.186.2])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A99338593
	for <ocfs2-devel@lists.linux.dev>; Thu, 30 Jul 2026 13:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.246.186.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785417899; cv=none; b=JdUbhvesjZc01CAzKEAmXMRv817jjEUpk+JXvTa9BZfD/s2Qk2OaL02L6zzbV3EfxEuzLKxGmWnkJ/6Wc4HT4rwdgbFvpiSWu++tnXw+JiupVQn/yrw+swVvYTq5LxCi+DLxmwdV1xRMZMNM+2XTwBIsJskfcEYANh58OXCEPDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785417899; c=relaxed/simple;
	bh=E0Rsx1nOdshR4u3de5a+jTq+XWnLiMI+VHJTzm9oU4s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gBnFvG8SL1ahPidOLJVNVCQZ8BYGH7F4VzbkVF2CBXA0PxjZN6fZV6WqiffMcMDAOirOk05VPefNApu9Lob3KdP7jYXzW9pY259fFWo+WStjILsk9nQ/qqlXXUr5gbRObyEbmIc167Z9d/osSFUpeiIlwI1ULDR8ZEBENyX3Yw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=red-soft.ru; spf=pass smtp.mailfrom=red-soft.ru; arc=none smtp.client-ip=188.246.186.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=red-soft.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=red-soft.ru
Received: from localhost.localdomain (unknown [10.81.7.147])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by red-soft.ru (Postfix) with ESMTPSA id 124C3263426;
	Thu, 30 Jul 2026 16:15:51 +0300 (MSK)
From: Roman Demidov <roman.demidov@red-soft.ru>
To: Mark Fasheh <mark@fasheh.com>
Cc: Roman Demidov <roman.demidov@red-soft.ru>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH] ocfs2: Remove redundant NULL check for rec variable
Date: Thu, 30 Jul 2026 16:15:04 +0300
Message-ID: <20260730131507.26636-1-roman.demidov@red-soft.ru>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-KSMG-AntiPhishing: NotDetected
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Envelope-From: roman.demidov@red-soft.ru
X-KSMG-AntiSpam-Info: LuaCore: 113 0.3.113 b83a27b0bdff87150e3aba5d24ea90b4a220db99, {Tracking_ml_letters}, {Tracking_from_domain_doesnt_match_to}, FromAlignment: s
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 204896 [Jul 30 2026]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.22
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.0.7854, bases: 2026/07/30 04:17:00 #28591546
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 1

The rec variable will contain the address of the structure array element,
i.e., the address of the ocfs2_chain_rec structure.
This address cannot be NULL.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Roman Demidov <roman.demidov@red-soft.ru>
---
 fs/ocfs2/move_extents.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index ad1678ee7cc4..b546c7371e28 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -415,9 +415,6 @@ static int ocfs2_find_victim_alloc_group(struct inode *inode,
 	for (i = 0; i < le16_to_cpu(cl->cl_next_free_rec); i++) {
 
 		rec = &(cl->cl_recs[i]);
-		if (!rec)
-			continue;
-
 		bg = NULL;
 
 		do {
-- 
2.53.0

