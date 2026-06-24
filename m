Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFB13B71C8
	for <ocfs2-devel@lists.linux.dev>; Wed, 24 Jun 2026 09:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782294801; cv=none; b=LtLMe8FgBvFndzX4xiCJviv37DoDoYqVxpgFpFIRuaziANVUaMyuUMe4J9ImTHSV8hM9ToxYghgSQIQaGRJlJaxKipZlv9Hf0qW295i0EqEAnpnYFNEYNdNFAaHe/1Ts/WE62jziI2uZUvyv4AiHXo2HTTSRktBuxi8f+zEC5oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782294801; c=relaxed/simple;
	bh=URoxyQKjPhKxt92W5MRdg5N2t3Xv1dSnRH4jSjuIM7s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=d0KQZpCD1WQEaCflYZSawm/nIT3cmYE8FjelfoNKrlGHfv30Js4cwuGOjvbc+bCQYs1LBXc3kFPLvjHqc++GD1ZgfSIxUGRr2oEbA/4NKhQPKnUlNRol8mvP6xejUPzEzT44fZnCGMyGvddPJz5pFwv6izB1k32C+6MixygIgrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a+vsxmCp; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a+vsxmCp"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-36dac5d5d05so365469a91.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 24 Jun 2026 02:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782294797; x=1782899597; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LU9X7+Tdz5zrP1eqy0eH4+PnbG8UzjQnw7f/Je2fQW4=;
        b=a+vsxmCpseO2pIDY/pxcSoY1qcuyH+bVjWsijpEHMqzOfNphzHxyAasLyPwizguHD1
         a2uerGUyojRjaQtiQ8yv6T0VYhQfe0FMGwlnYmccorQEwQwk+jjefWG8k8+6cuYVSz6W
         zFtm5bTmJioYleUbDPspqP9IWG9DS2HEV4wzmwBFW+tfVDLdEfdlWNdk1PeqK7lSPh5J
         kOQ0cirgl1o3liNTOzKZ4qkNI9+D9wPCFO7sKCHNFrfCioG7Fj0pth9R1zT1xYty9g7z
         ZuK7mfu0Pyki1+qrqGf2k/PGG2n7dzptH8wwQDpEleay3QmTquHZzIpdC7wvyXg/IDW0
         EL6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782294797; x=1782899597;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LU9X7+Tdz5zrP1eqy0eH4+PnbG8UzjQnw7f/Je2fQW4=;
        b=mFxhBLsTVtbn7T2iO+pf4vwycU9qR3SKtpt6aeOiEVvqlrCNN84+/tswL8bqsqztNg
         cXLn2tlozaDgW8abJHDb88XTaIHzXPZBG1W/b7Uj0HqlXRb1/ZMesBefNcQXMSPc5ckl
         6HDsNYF4CKQb3I9y1a9e29C6Z/dOSlHPPPE/USdYzNUuHLTNIsOt4z+Tk/xJOu639gPJ
         YKNWsP8TlFrVGOX/VRxeNJ8j/YSnZUs0R6DO4wT1Iq7EX1lZkCfnn+aIxlOO8CQv8G9F
         MJr4z5da3poJDnfctVgG2mV9umwkmtmLLx1mjlXJNup4Rsowc4iPtDPRuWhGZMp+GMho
         stvw==
X-Forwarded-Encrypted: i=1; AHgh+RoeKenYsitdN+fSabY/1l4jJuTZ2uSZ5GJYrieCtk4vdMVsxZRgi8bOsHEZhhUQa7PQO4sNQXkz/McLdw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwDnNPrKoC3eor9Lrmgv6mr4+PaR+k/INFu3ytVzTLoqG8F2ACg
	++B7yF4VOV335NpPLNwFS8yM8nhKyR9drrCGyTovNDbNv7dol8Cq+2XO
X-Gm-Gg: AfdE7ckqC5d8k/qjpZvbzaJFUcsw7myiwTlpT20+HzIIR+AdOWFgaNzhxMCP5VLqESa
	DH6BSikwYmgbAtoAdWCJXQ4O74uTT7NId/p/ROBKZhIZO3Nk3f13qN0e9Vk4GqA6OGXx8IN9OQv
	lkEkgJFGJ9d5xGrmyVm+cQOzJdRc7LnQbrIt8kBkYnphAb5LhBaGy4V+FvAtHlSSiLnHDmd5/5L
	NWuN7bWQgb7OFdJi0t0gLQg8IUiA8ZIOCY3WOxps9cdn5VmAhhAXx/9O7dqGsZtrS/pceoiud1T
	91ohkU5c/6T5TttwO8fmXY3v74tE4mCs1JBlnWx3X8J3QsWjIcZLDn9OxB8mjFKx0vtrdWMOJjl
	KqQn/lgG77+K04tr90E0CYUt1AR/gzMiKubP/GOYmBjdNVe2G8Y0Ng2AOVZfdcaPMsog4qouDBY
	CVkVX9PDY=
X-Received: by 2002:a17:90b:4a8d:b0:368:147f:bd27 with SMTP id 98e67ed59e1d1-37de44e2282mr2724975a91.23.1782294796722;
        Wed, 24 Jun 2026 02:53:16 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37de3ce544dsm2247634a91.9.2026.06.24.02.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 02:53:16 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	zzzccc427@gmail.com
Subject: [PATCH 0/2] ocfs2: harden heartbeat teardown races
Date: Wed, 24 Jun 2026 17:53:08 +0800
Message-Id: <20260624095310.763763-1-zzzccc427@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series fixes two OCFS2 heartbeat/o2net teardown races found by
KASAN.

This series is based on my earlier patch:

  [PATCH v2] ocfs2/cluster: keep heartbeat local node stable

That patch has been queued in Andrew's -mm tree as:

  ocfs2-cluster-keep-heartbeat-local-node-stable.patch

It is needed as the base because this series uses the stable per-region
heartbeat node number from that patch instead of re-reading
o2nm_this_node() during teardown.

Patch 1 stops heartbeat callbacks from queuing o2net reconnect and
disconnect work after local o2net teardown has started, while still
keeping the callbacks registered for quorum state.

Patch 2 keeps a heartbeat region non-armable while it is starting or
stopping, unregisters negotiate handlers before tearing down state they
can reach, and waits for the active or destroying o2net ordered
workqueue before freeing the region.

Thanks,
Cen

Cen Zhang (2):
  ocfs2: synchronize heartbeat callbacks with o2net teardown
  ocfs2: o2hb: quiesce negotiate handlers and timeout work

 fs/ocfs2/cluster/heartbeat.c   |  99 ++++++++++++++----
 fs/ocfs2/cluster/heartbeat.h   |   5 +
 fs/ocfs2/cluster/nodemanager.c |   4 +
 fs/ocfs2/cluster/tcp.c         | 186 +++++++++++++++++++++++++++------
 fs/ocfs2/cluster/tcp.h         |   2 +
 5 files changed, 247 insertions(+), 49 deletions(-)

-- 
2.43.0
