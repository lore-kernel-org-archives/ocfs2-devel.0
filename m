Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA451247291
	for <ocfs2-devel@lists.linux.dev>; Wed, 23 Sep 2026 00:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790123967; cv=none; b=IUA8KRFY9txnGgTYZaPyfok0raCsBOHHCz9vKxv/SffQPyvP8Blr6ElGJpjiw2d2VQ3W2SndhABaNovHH+T+sdQU0eCv17MadPAhKFT+M523CkdbSgr1nsSGzHfSAuUUucqjGFAmsQ7bMBM/uYqCj96JckxfhlXU90EFJd8gV0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790123967; c=relaxed/simple;
	bh=J8IGJOTPNLo5funj/k5m2l+HeG+UE8ItYZ+QlSXAmoQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ic6NqOXvN+qdmO24Xgj7kX42Ronp/1lnqpQP2OLa+P2/VICpOQtTbJ952bhVzy0IsmktuHlYd2I7e0o4aArFy0QSqFsEUKGbUNrCm+Jp9zRBJONuOksdRBvKVpHcPthyI8nkNYsoZbwhxySAJ3r8XJo6j56shPbXSM5ASeK6hiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=hpZvOf3X; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="hpZvOf3X"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790123962; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=wb1T1pRgBdjSKoXGUtRKQo+JqN2Jv3JC84D1tTDRpuo=;
	b=hpZvOf3XzxNcY0Pz0rY6B9PRcZ8I27QL2Bk6UmX3MyhBpVDfxdzk+slF1n91nUTlIodnFZxpTyIsc0ku0gb0tL3Qb5mBMF7CpggsvV30HeVhNrXL5LTgps8sr9HPXZmh5ZxCeXhHhtYm2WuonbUzhsJ1FB/5Wr4ScxZ3ShXfAMY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XBVF1hm_1790123960;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XBVF1hm_1790123960 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 23 Sep 2026 08:39:21 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: add Heming Zhao as ocfs2 reviewer
Date: Wed, 23 Sep 2026 08:39:20 +0800
Message-Id: <20260923003920.2382398-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Heming Zhao has contributed ocfs2 a lot recent years, both as a author
and reviewer. So add him as ocfs2 reviewer.

Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 05215fcc18a5..56c9523559df 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20774,6 +20774,7 @@ ORACLE CLUSTER FILESYSTEM 2 (OCFS2)
 M:	Mark Fasheh <mark@fasheh.com>
 M:	Joel Becker <jlbec@evilplan.org>
 M:	Joseph Qi <joseph.qi@linux.alibaba.com>
+R:	Heming Zhao <heming.zhao@suse.com>
 L:	ocfs2-devel@lists.linux.dev
 S:	Supported
 W:	http://ocfs2.wiki.kernel.org
-- 
2.39.3

