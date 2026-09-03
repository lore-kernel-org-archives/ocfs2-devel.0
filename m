Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7A83AA4E0
	for <ocfs2-devel@lists.linux.dev>; Thu,  3 Sep 2026 10:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788432472; cv=none; b=RPFRWxCv67GT984BgfCGAF4LhGVwpjX4H2bGizvEej0ZlOG0LM2t3zNVeentBsENDeq8f07M6UfI3EhjQeBAfCNg3VfFQlvDWEuEU3YQiOLBuE7kz669MFHAZeLf00efapu8D5K/GpHl8UV130Sbkbu2K0xTQ27OyJ1UeD1k/24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788432472; c=relaxed/simple;
	bh=znHWs4Pe6toTgnXHCFSOkAd+DrzwECs05VAGzXRlxOg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=X/91jCaHQdDwvrtbZr6nwbh+cftJ8mChegWf67ltAth2JDejk/N8SrYcdmtkUeM5KggQQjpM/RbvBUtzw1be6eVAhKC8792HgtJleHYFNx9f53Kw9wOSi04ATFK9AcSR/6nhCMAveFqpb6EWNBsVmjb8d31+0Ssji8Y0slVBEfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=FIU5f8L1; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="FIU5f8L1"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788432465; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=uNmLAbN5X//e+9PjwXsem+2dldl0gpZ80D23EnR2chI=;
	b=FIU5f8L1DD/FgrG5y3eENhT3Svq08z1kyVEyQ3adz3ywhNr3rymyj8vTiZZw9kAbc81gUgftTgpkWXYvsXYCnKrIPx/rHI+6YLTMYogAwtiaOjlxWAv3nhkIiqxLRCreulukjFCWGabjgIF5yv7h13v0Qkt0ZfMGmJ6fZUSJGk4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R241e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XAFkQSC_1788432464;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XAFkQSC_1788432464 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 03 Sep 2026 18:47:45 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>,
	ZW Tang <tangzw515@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ocfs2: skip uninitialized lockres in ocfs2_mark_lockres_freeing()
Date: Thu,  3 Sep 2026 18:47:44 +0800
Message-Id: <20260903104744.2164235-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A hard readonly mount skips ocfs2_dlm_init(), so the per-osb lock
resources are never initialized and osb->cconn stays NULL.  Before
commit 550842cc60987 ("ocfs2: fix freeing uninitialized resource on
ocfs2_dlm_shutdown") ocfs2_dismount_volume() only called
ocfs2_dlm_shutdown() when osb->cconn was set.  It now calls it
unconditionally, so unmounting a hard readonly mount drops the osb
locks and takes the never initialized l_lock in
ocfs2_mark_lockres_freeing().  With lockdep enabled this triggers:

INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.

ocfs2_drop_lock() and ocfs2_lock_res_free() already skip lock
resources without OCFS2_LOCK_INITIALIZED.  Add the same check to
ocfs2_mark_lockres_freeing(), which is reachable before them through
ocfs2_simple_drop_lockres(), so an uninitialized lockres is never
touched.

Fixes: 550842cc60987 ("ocfs2: fix freeing uninitialized resource on ocfs2_dlm_shutdown")
Reported-by: ZW Tang <tangzw515@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/dlmglue.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index a23dd8f86c89..cf3318b0d3a8 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3525,6 +3525,10 @@ void ocfs2_mark_lockres_freeing(struct ocfs2_super *osb,
 	struct ocfs2_mask_waiter mw;
 	unsigned long flags, flags2;
 
+	/* We didn't get anywhere near actually using this lockres. */
+	if (!(lockres->l_flags & OCFS2_LOCK_INITIALIZED))
+		return;
+
 	ocfs2_init_mask_waiter(&mw);
 
 	spin_lock_irqsave(&lockres->l_lock, flags);
-- 
2.39.3

