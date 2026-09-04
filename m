Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7453839B7
	for <ocfs2-devel@lists.linux.dev>; Fri,  4 Sep 2026 07:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788505234; cv=none; b=MupY67spvFTSbxPdh1RHdzB1IsJpgUKEakriLQGmXsTQJje9pajq2bK/PasQptQNUCL7cwX01h/CBvZ7chVtli3h5RxI6bfX1OpOvhGyMfqBunMzCSrHoLRdQxCbPcymoIKmIGuQ1RwVQOTDJSry5ZS05PPo7YyJ0725gf5sDCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788505234; c=relaxed/simple;
	bh=SOJ8QCflRbkW8jpMaQoN3egliz/RPrUaGCkqQ+5BElk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GbpnwqH3MX1p/S0BqbYSV1O0gn8egvhanxBwe7aH8QMYFamXeNDrkFnuwt972vc5MT3II/gSLkH1a51bPjevqVWE3Y0ePgwcaGsh+lZ3qOqEXLsPWikP9lC2UYGBTWAtz4eOn8vGMQ03zLkWecQgtN4kif3qsq0h5qP2s91YZMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=WbO+boOa; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="WbO+boOa"
Received: from PC-202605011814.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4c86dea68;
	Fri, 4 Sep 2026 15:00:19 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Kurt Hackel <kurt.hackel@oracle.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: [PATCH] ocfs2: shut down idle timer during socket teardown
Date: Fri,  4 Sep 2026 15:00:14 +0800
Message-Id: <20260904070014.4049073-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa06b37e1e603a1kunma597ccf12d247
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCTUlDVkJNHkkfGhlDSEhJGlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSE
	pPSExVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=WbO+boOa7XZEEcM7AncrzXxwxm03MYOM8GNKZ3BOz0v0bCCZc08oORGuR3nlfebO1ClBhLYS2drkm7bqG0fXz9ZoBFtFlnCog6Ei06g+LOgDRPX/eZlEdko6ibLaESfhnAXbi3uElgh8cme37PT99JeHutm3l9m0IEHP5ckz69g=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=ZjSgnYmrCgIxaVCe4AaedaNBdz6nUCnBC2pw0ArPvbk=;
	h=date:mime-version:subject:message-id:from;

o2net_idle_timer() rearms sc_idle_timeout from its callback. The socket
shutdown path uses timer_delete_sync(), which waits for a running callback
but does not prevent the callback from rearming the timer after deletion.

The socket container is released after this path, and sc_kref_release()
expects the timer to be inactive. Use timer_shutdown_sync() so the timer
cannot be queued again during teardown.

Fixes: 98211489d414 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
---
 fs/ocfs2/cluster/tcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 474fe1414..cef8cfa2a 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -733,7 +733,7 @@ static void o2net_shutdown_sc(struct work_struct *work)
 	if (o2net_unregister_callbacks(sc->sc_sock->sk, sc)) {
 		/* we shouldn't flush as we're in the thread, the
 		 * races with pending sc work structs are harmless */
-		timer_delete_sync(&sc->sc_idle_timeout);
+		timer_shutdown_sync(&sc->sc_idle_timeout);
 		o2net_sc_cancel_delayed_work(sc, &sc->sc_keepalive_work);
 		sc_put(sc);
 		kernel_sock_shutdown(sc->sc_sock, SHUT_RDWR);
@@ -1513,7 +1513,7 @@ static void o2net_sc_send_keep_req(struct work_struct *work)
 	sc_put(sc);
 }
 
-/* socket shutdown does a timer_delete_sync against this as it tears down.
+/* socket shutdown shuts down this timer as it tears down.
  * we can't start this timer until we've got to the point in sc buildup
  * where shutdown is going to be involved */
 static void o2net_idle_timer(struct timer_list *t)
-- 
2.34.1

