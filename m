Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C07F15E97
	for <ocfs2-devel@lists.linux.dev>; Tue, 30 Dec 2025 14:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.134.164.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767104721; cv=none; b=ZLPLHWEEXCbM1PuWtlYb/jomNKVP1NUd/PzxMDTsFhoRjP62olzGJrkKxnrDOP/wuM+TFWMYHcN6tWj78XcjqV54ngZW5AZXW28r53AIQKQy4QEF4thUYltIvbRy+JOaDfxLQ1X8cuYLBVyNDsSz4s6HySxTlZ5PieTkCw0xjlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767104721; c=relaxed/simple;
	bh=4EBknACPJHip5AR3ldEAWTuK+afJeGpldeYsMkUOUow=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=g3OQPR4DGPaDYgtpX27R71kOaDSdTcPplRqHmXnsewaO0ZMovLV0azRRzzKFqdgF5eTnr1TZVbZLbhjNF3DU/G0pVZo8hv9vs3tPf21FwepPKOVpnu4ZTahOMM4c1P560VfYm0wNJMzF7ly2uq4AGfMqOXZKtHXRjel5gDmeJJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr; spf=pass smtp.mailfrom=inria.fr; dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b=AVMLWMyZ; arc=none smtp.client-ip=192.134.164.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inria.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b="AVMLWMyZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oja1dzkACixaZBVh05dXtgwzZZJ1qV8mLv2Y+sZSZZY=;
  b=AVMLWMyZ6ehwHqxJ63LmbF/4SKF2LEzm0E1rwcXxFhFuf9DcqrfGDylA
   ZjLLEtPtJCBTNH5FHT5GwoQrMMXQNm/EFkEbPhzzZFkuzdWDntnr3jUdI
   /SnAE1orDuSb35OxceuW7N2YrWx6I9w5AXbf0FGJgJDaeQYmWCEKejmsx
   g=;
X-CSE-ConnectionGUID: JGqfgGCeR26J3ty9ZF4/EQ==
X-CSE-MsgGUID: 5S2+qZaLTgCYnURTZ8wJ8A==
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="6.21,189,1763420400"; 
   d="scan'208";a="134750600"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.102.196])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Dec 2025 15:25:18 +0100
From: Julia Lawall <Julia.Lawall@inria.fr>
To: Mark Fasheh <mark@fasheh.com>
Cc: yunbolyu@smu.edu.sg,
	kexinsun@smail.nju.edu.cn,
	ratnadiraw@smu.edu.sg,
	xutong.ma@inria.fr,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ocfs2: adjust function name reference
Date: Tue, 30 Dec 2025 15:25:13 +0100
Message-Id: <20251230142513.95467-1-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no function dlm_mast_regions().  However,
dlm_match_regions() is passed the buffer "local",
which it uses internally, so it seems like
dlm_match_regions() was intended.

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 fs/ocfs2/dlm/dlmdomain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 2347a50f079b..cf3ca2f597c2 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1105,7 +1105,7 @@ static int dlm_query_region_handler(struct o2net_msg *msg, u32 len,
 	mlog(0, "Node %u queries hb regions on domain %s\n", qr->qr_node,
 	     qr->qr_domain);
 
-	/* buffer used in dlm_mast_regions() */
+	/* buffer used in dlm_match_regions() */
 	local = kmalloc(sizeof(qr->qr_regions), GFP_KERNEL);
 	if (!local)
 		return -ENOMEM;

