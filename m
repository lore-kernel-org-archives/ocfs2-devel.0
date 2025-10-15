Received: from forward102b.mail.yandex.net (forward102b.mail.yandex.net [178.154.239.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F9821A447
	for <ocfs2-devel@lists.linux.dev>; Wed, 15 Oct 2025 06:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760510940; cv=none; b=i7aDH0gzOYiPFAyaJY0/AsjqHu7CyelX1LWxQ2YWcIgCvfrP1+cYf4DFgB13u91O4YSSaBjXIL/jAe2DI5MD3LCy/AXoW1SGuPAMe36XBACP2nIt9rLXocEh2NpWesICzqldlGndRbcvuz0OHGkvE0bUoRNUnFWN8aCS1K5e9Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760510940; c=relaxed/simple;
	bh=YRrRS6Gm8i50e6lrcKoutjiS4PRbkLrpWaoGTxkDTS8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hequ4ZJuqbo9gH6CqNDX8cdtu1pZUxcmAZdL3d6vuE8ZjRchPuRz2TVY52VdQW2TocNQhv6xuOir2uEttTRcvAhR3ARd7YhTakqorVbrnKJQoH1VdCc8Q0+UqlSmqOdplH9lfna0PUmNI3eksmQCISuNpAqAaTjcRPrlBB6QAkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=Nh3g5+5S; arc=none smtp.client-ip=178.154.239.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="Nh3g5+5S"
Received: from mail-nwsmtp-smtp-production-main-87.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-87.sas.yp-c.yandex.net [IPv6:2a02:6b8:c23:2f3c:0:640:7ca0:0])
	by forward102b.mail.yandex.net (Yandex) with ESMTPS id 0E994C0157;
	Wed, 15 Oct 2025 09:48:49 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-87.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id lmJOUGsLReA0-r4fMzt6d;
	Wed, 15 Oct 2025 09:48:48 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1760510928; bh=VIk63EUprtPs/BtRXZTVoDQhE3BVTOrBVwAvInKBsF8=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=Nh3g5+5SwLjCkYzFtbaUF4gax3tQ7kup1C+v22ihy8xyIGbUiEyDoukmVa7E5Uo8V
	 XJx7PUIS6sOhmRzt5kNrF8mOS2033bEVwMm8s746ThWdP3dIYXREHNhcScUCfDH6ax
	 yVtDCga7WC33QApDWXZztL2nOetmd91RMaSUEx9w=
Authentication-Results: mail-nwsmtp-smtp-production-main-87.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+77026564530dbc29b854@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: add chain list sanity check to ocfs2_block_group_alloc()
Date: Wed, 15 Oct 2025 09:48:37 +0300
Message-ID: <20251015064837.281929-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.51.0
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
 fs/ocfs2/suballoc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 6ac4dcd54588..99eb651d5593 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -671,6 +671,13 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 	BUG_ON(ocfs2_is_cluster_bitmap(alloc_inode));
 
 	cl = &fe->id2.i_chain;
+	/* If these two doesn't match, the filesystem is most likely corrupted. */
+	if (le16_to_cpu(cl->cl_count) != ocfs2_chain_recs_per_inode(osb->sb)) {
+		status = -EINVAL;
+		mlog_errno(status);
+		goto bail;
+	}
+
 	status = ocfs2_reserve_clusters_with_limit(osb,
 						   le16_to_cpu(cl->cl_cpg),
 						   max_block, flags, &ac);
-- 
2.51.0

