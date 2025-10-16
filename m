Received: from forward101a.mail.yandex.net (forward101a.mail.yandex.net [178.154.239.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BA4212FAA
	for <ocfs2-devel@lists.linux.dev>; Thu, 16 Oct 2025 08:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760604447; cv=none; b=F6EopgokXL0LjPXJ+9yPW37OmeJhZutE6DfevvZhzFPtnqcUmJIidB/Rz7VMBR8eZGYsy/rPCSK3SZHwkBpr4oFia4Tn6p7PI9pGcQVhvjNbsKNBGJyzn7Zp0pxfOTbHidTcxjw1yYslWA7qwQdOGJ3LXMIVSZLZwL0nA7F+E1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760604447; c=relaxed/simple;
	bh=CNq6udMA6te9XgcojchyEhdhrtwTKf7MAuNZoHLuvE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7eCo6nFj1Ln9eFwqLP8NUa5vuFXti2wbiZ13kuIGYMjezYP5/WqLxW1cwxRHn4q0j1RVVHLqdLMR/5V5X7n5BXvVqCyN+gtMFIc+fgednLTWvzQ4yjd/3R5OrZuWZ4B0UrduXCUwV+et57/YpUPfI3lT9EvgXNSpgvo4lw9XbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=DiCpaW8Q; arc=none smtp.client-ip=178.154.239.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="DiCpaW8Q"
Received: from mail-nwsmtp-smtp-production-main-52.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-52.vla.yp-c.yandex.net [IPv6:2a02:6b8:c2d:6c0a:0:640:c879:0])
	by forward101a.mail.yandex.net (Yandex) with ESMTPS id E4CCD80D4A;
	Thu, 16 Oct 2025 11:47:14 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-52.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id DlM4bn1LnSw0-EmSYLeUQ;
	Thu, 16 Oct 2025 11:47:14 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1760604434; bh=vsOKK2q4jMaXB5OCUzyJjxxCx40IGUpkzrssxkYXo5M=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=DiCpaW8QmIZDA1WfPUciy+o0o3POD/Vfte3CyRP65+oxv68CngPoY17MBz5TKMl4N
	 AhAZo+2nTrm9e41Aifb1xkN7eO6VdHoX5Vl2sY9aw/IdyytRliYwqOkLY4QnqNNct+
	 BHDyO8xp6gbOw7RB+WS7/Pz+Jv/FnDNcKD/Kjo/c=
Authentication-Results: mail-nwsmtp-smtp-production-main-52.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+77026564530dbc29b854@syzkaller.appspotmail.com
Subject: [PATCH v2] ocfs2: add chain list sanity check to ocfs2_block_group_alloc()
Date: Thu, 16 Oct 2025 11:46:53 +0300
Message-ID: <20251016084653.59686-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <2d6351d4-c753-4a95-8036-95c991524de6@suse.com>
References: <2d6351d4-c753-4a95-8036-95c991524de6@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In 'ocfs2_block_group_alloc()', add an extra check whether the maximum
amount of chain records in 'struct ocfs2_chain_list' matches the value
calculated based on the filesystem block size.

Reported-by: syzbot+77026564530dbc29b854@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=77026564530dbc29b854
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
v2: remove redundant call to mlog_errno() and comment (Heming Zhao)
---
 fs/ocfs2/suballoc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 6ac4dcd54588..e6d4f5015f84 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -671,6 +671,11 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 	BUG_ON(ocfs2_is_cluster_bitmap(alloc_inode));
 
 	cl = &fe->id2.i_chain;
+	if (le16_to_cpu(cl->cl_count) != ocfs2_chain_recs_per_inode(osb->sb)) {
+		status = -EINVAL;
+		goto bail;
+	}
+
 	status = ocfs2_reserve_clusters_with_limit(osb,
 						   le16_to_cpu(cl->cl_cpg),
 						   max_block, flags, &ac);
-- 
2.51.0

