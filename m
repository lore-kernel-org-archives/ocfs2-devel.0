Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D8E278E7C
	for <ocfs2-devel@lists.linux.dev>; Fri, 11 Apr 2025 10:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.243.244.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744367318; cv=none; b=V2g3/zqcMzWxRLkFFrR+5RPowtd2JTAnW4j88S9QWXiy/vg88XhaDSFamrJTcQFpDys9lo7v4Jm9wltmJZqpY0+cHz8BD5ngqB5cdDjGtlVS9efP7E2TzCxGacsTdmS2eWOVaun164dSf+c6jMYCQpnE2Li2H6fOR0aJoJEjZtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744367318; c=relaxed/simple;
	bh=ZDCwX/VIIX2cwjTORa/viaElRwz8HH8NWVCcOJobQOI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a8fb02Ajr1t4f46MLKMZUzmp2PU77T9lobPgCEsB0Ldst2jUxvYqhOgi3tFuoFL2G2JgJR1hATcE6F/zWIp23nsR+1V9fFGzDY92fCjDJQ5Fj4wyTNdAm0vJmGzrbz2L1rzI18Ffe2oW+ZefPz4J+i0AXjeg49fhiUdgV6iF5Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=AMB1+Gay; arc=none smtp.client-ip=54.243.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="AMB1+Gay"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1744367220;
	bh=Qvl4cj8ljBGCVeGDelcgbiIaxF0858Xn7bz1tzcyE/c=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=AMB1+GayCZ2msOfMu4sw9l2YodfAa4F7Smo6rdQngCRhumO5VY4iI3ApjIDVBlUGV
	 /Lyc9fzWfm2Ys46pO14Ffa31pwepkx1O+l7gleLtpKl9XY7A4VChWo6C7HS02fV/mK
	 F6b7tnYbcIxcmBxOC8wlVvk67vZCTDTGjOYoK5l4=
X-QQ-mid: zesmtpip3t1744367176t06a84176
X-QQ-Originating-IP: T6GmBeruXCFtkICI5bUi36KWkx/42EidU75gg0SRHd8=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 11 Apr 2025 18:26:13 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 11810010522310925225
EX-QQ-RecipientCnt: 15
From: WangYuli <wangyuli@uniontech.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: akpm@linux-foundation.org,
	kuba@kernel.org,
	dmantipov@yandex.ru,
	mingo@kernel.org,
	axboe@kernel.dk,
	wangyuli@uniontech.com,
	tglx@linutronix.de,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	zhanjun@uniontech.com,
	niecheng1@uniontech.com,
	guanwentao@uniontech.com
Subject: [PATCH] ocfs2: o2net_idle_timer: Rename del_timer_sync in comment
Date: Fri, 11 Apr 2025 18:26:10 +0800
Message-ID: <BDDB1E4E2876C36C+20250411102610.165946-1-wangyuli@uniontech.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: NWaY/LEHNR/FznKEMis7KFA3cuZI6LvpOtEWDSfif2oJYzutp3G2Bhmw
	p50Mlqe9LYhzY6J03qqnB0RwZP38Qyfav7dFWw4RnO8C4Pw1Nl+//Oq0OD5FKohz5Rv30Ms
	YN479BzXUwe8mphEPA1tzN5RubvWdXgle+O44UWWQcFn6NSX0AqZTuKUc+5pQOQzZwlC7yl
	94tJPy7WWXkCzhc393TVwGbgklsppbxrcAnz8yBGk4CYJ73CxkCPw1VZufrWopNoskFhWVo
	2XrVG5UL1hbYoyVgcesumwYL/xs+aqIzmGrdo7JOBBm98/B/GApoRReZsI23g0r392c0Smg
	+K2DjfJ2+s6yDXobuH0qleO2lQomQ1uxOjUNSUCNPZVZy/nPpsqHoI3UZ3HDbXHimptCc+Q
	Z9OrdeixAn9pGHXaxGH1iGVrboiONDGBfegArvtryts04ctv4r9hbuLrbKyXTQz9Os3wDCP
	FgXr35nwV/FL73mbJLobJz6gVlb+OerHRl89P2DsSOlO/vLXXvAIRLVtExmlFeh1z78Q+8p
	4dgQrYVe/4E8Md6GfXAtw4yK6zdSSVBLcTmPsct+1XV+2myqpW3ufuiEnPkYYmSvRvA1Zgt
	Jm13116uM7xSCogc0/Q4NqtJyczZCW2Yxkb0MfUatX/3tdjE423OoljgJYgcRI2ggpKttOX
	Y5kEqQyBugbyvXl21o9/DVNKFWdjDOPp+Y0fv2Rg4Y2X3SPiXxNU9u9AqQeOmJxA/ymZ7/F
	n1fPmQIqKk6uHsRruIZsbJbb+BftKL3x8KT3yKaXYijXuUkdCp4U35Wwjr9dpsc3UYH1dY0
	bBqYgMz4atLJOkm5wFGKc8cUyz0SW5yp0n9n97TNiHDSIuLCuhkluEMXraZxHyFgOPnQOzc
	gXRUGs78XbPd/G5KLmYklDLToFYp1hNG/mFhwJBwZuc9bwym9Ff2otbNG7SRn/WQAo1ErHc
	WYRkR1HTxlTsXf0TX1EgdZ7AMb9iESDAMoC3YqEfYW/dUBX88A+fqoleBXlwk0zuoxiMZ+1
	lekEBAHw==
X-QQ-XMRINFO: OWPUhxQsoeAVDbp3OJHYyFg=
X-QQ-RECHKSPAM: 0

Commit 8fa7292fee5c ("treewide: Switch/rename to timer_delete[_sync]()")
switched del_timer_sync to timer_delete_sync, but did not modify the
comment for o2net_idle_timer(). Now fix it.

Signed-off-by: WangYuli <wangyuli@uniontech.com>
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

