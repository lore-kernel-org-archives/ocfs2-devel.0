Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC14319CC0A
	for <ocfs2-devel@lists.linux.dev>; Mon, 14 Apr 2025 04:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744604946; cv=none; b=U/rAQrUTlrCyA6cwNQ3c2Attamfiyb6FF4HdMSi6Ex4Bd8EKchSTqcZSPIKZsC5AsPOnB3+gVo+0n0E3hOsnFM9ttuv94VSHQI4YwSbKN0Up1I+ZMuW2LrM9L4fbHMS1cp1coaX1Xtcl1/w9+lq+9XcLNlz89pioboLskj2jyMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744604946; c=relaxed/simple;
	bh=dFjpoHLwYiryRQGd0iDHH8wwDO4qSKHsYv4Y+8fobRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kxJ8S1KBerE/OpK8Ew/+jZQyaBxY2GBsFzZMm5FqvlagLAhCShO7Q0TsbtxT/BxKIqLU7aLUBqKfrnJV2E2mVAjv/RVOepKpTsMiu9mmqMG0BgSVaoRP/oSbK2aY81fkptYLwDOVf03AGd80PBtoY45FtEu3j32Xnzk8r96kILI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=IvvA24aZ; arc=none smtp.client-ip=54.254.200.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="IvvA24aZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1744604854;
	bh=ZzX8Z/mzhOSbpQ+4ov+n9ydOOvnwhcefBMjmLVxlxxQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=IvvA24aZ8DwzauZLL+3crgEvRg8zBZf4h0CFReeajIh0XtEVQK5qWNfqVLaCC2RIv
	 l0lj+m5jcpseWJ993EXIJosAu1+fQiax8jpP7j3U4lu7bJTHI4lhWChqlZTpu9ihrE
	 CA2YNITZyNlOe93ipe/uqOsf+PFtjYmiSBiVV6pg=
X-QQ-mid: bizesmtpip4t1744604807t2f7bca
X-QQ-Originating-IP: IlhwnyCWyIUNtgBVZwfyEMeZ6zSVm/eWDs20XGO8Rsw=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 14 Apr 2025 12:26:42 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 8640425311280884179
EX-QQ-RecipientCnt: 15
From: WangYuli <wangyuli@uniontech.com>
To: wangyuli@uniontech.com
Cc: akpm@linux-foundation.org,
	guanwentao@uniontech.com,
	linux-kernel@vger.kernel.org,
	mingo@kernel.org,
	niecheng1@uniontech.com,
	tglx@linutronix.de,
	zhanjun@uniontech.com,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	ocfs2-devel@lists.linux.dev
Subject: [PATCH v2 2/5] ocfs2: o2net_idle_timer: Rename del_timer_sync in comment
Date: Mon, 14 Apr 2025 12:26:26 +0800
Message-ID: <83353E80121F81DD+20250414042629.63019-2-wangyuli@uniontech.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <37A1CE32D2AEA134+20250414042251.61846-1-wangyuli@uniontech.com>
References: <37A1CE32D2AEA134+20250414042251.61846-1-wangyuli@uniontech.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: NDzbcI2eQBLkmTFSIFOYz/4/TWAIYIlyD1Mc1Vs+f96itrSHEMWkl+fI
	pDCWmKs7OpGeVawB9fii/rrtBgktCfynY3NLGs1ZUx7V2Lkq7CCWzLSzMUIESJQIjSH1x7B
	QAT5pfiuVokqbYjV2iLWrFJ+AChqJrjxFYI2SE+4MMQe8CxivWvhnsyga9k3uKhYUerkMhi
	grBGWyZkVa6hRrJ92FMAsSQQKm7yxfyfNTcmuY+ktLy2P/IQczt2D5ysJvmI1HLVFzxkzrl
	AVVL9ARPK+XAYvSE4Ak2EjN2W111IdV5DQ7gFJYwkUZ+AHUfXBRFSK2/X1yyy+Swmb8l4YY
	2uF3W3iZqoWp9XAO+Lt4na1eGg3J4mRGv9thyCpquf5mFsuLR7JZqISyEe0g/hqn2binWI3
	G/0kUsofZlFllFDk9cU/JBIwYJ97ICUyiYCAVNcj0ZGKEMZZqx+brKiK/B56cOjO/RYQQYR
	SpNVcE01dV6FVdIDWnxy4JcUiACk5CawkfOqxTGHxZPzFwXOITrOLv/r+IL+U10AbepCyqt
	6mmncHB49oy85bj4quHwFHfBRnjtKuiTixv2TvTcZkFIR1TSOipvjPP9ZdLyIUYtUiMZYCE
	dvxzFlEv+6ap3DaDfSbs77WNcYXAxWkOrUDnG5Ql5now4xGmuW1UuRuLOEzJT/Z3O6wDxoY
	Mkg/rIEDcmvMMNjzk/siMszixpSmm/4sWgsq2vCmW0Ftz80zJuyDWldZwm3TFgGrkZYD/s1
	91jTRTZPzWTdi/P7kZzJfWgj1Xfy2ivdDJoC54AFU5CMSeu/ho34/7OrOC9s07UIxEzYNqM
	wG4Tjp2Qca9KTpIdU5VCYXQ1wWWYrv4DyKMH2IUlYXFvJb9wcZrSbvNXxgy9IHhFih7xSH4
	zc3Uyj7BNYcqeX41Zrha+ShkAwXt81eWbaarVy1VULVAaIAg5aT+U0IZ52F+zdwihZ3YQsI
	0hMhUp6qCRE346oVuZWzvAPInIOCxStGm9exFqHy1cXFVaI9OxXMAh9sTFiEEx97+NeWZIy
	QAXortwLGxho3iB6jypQrCvK9nRDbofe2a7qyhOCf8SmLIb9ol
X-QQ-XMRINFO: OD9hHCdaPRBwq3WW+NvGbIU=
X-QQ-RECHKSPAM: 0

Commit 8fa7292fee5c ("treewide: Switch/rename to timer_delete[_sync]()")
switched del_timer_sync to timer_delete_sync, but did not modify the
comment for o2net_idle_timer(). Now fix it.

Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: WangYuli <wangyuli@uniontech.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Dmitry Antipov <dmantipov@yandex.ru>
Cc: ocfs2-devel@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
---
Changelog:
 *v1->v2: Add Joseph Qi's "Acked-by" tag.
---
 fs/ocfs2/cluster/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index fce9beb214f0..43e652a2adaf 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -1483,7 +1483,7 @@ static void o2net_sc_send_keep_req(struct work_struct *work)
 	sc_put(sc);
 }
 
-/* socket shutdown does a del_timer_sync against this as it tears down.
+/* socket shutdown does a timer_delete_sync against this as it tears down.
  * we can't start this timer until we've got to the point in sc buildup
  * where shutdown is going to be involved */
 static void o2net_idle_timer(struct timer_list *t)
-- 
2.49.0

