Received: from forward101a.mail.yandex.net (forward101a.mail.yandex.net [178.154.239.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B4B2ECD36
	for <ocfs2-devel@lists.linux.dev>; Mon, 20 Oct 2025 10:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760955917; cv=none; b=ueMVFInV+UU8iYAReLrf8wNeUxTJvuDAWU/nvPUnM55t8k/dDnFjHEKTYdwiJ8sgbhy0nmeNsjtJoLbPNoky89/WBy/MY4LtA+X012ozjWC0AxmNDr+BwciMy3qaxGIU+epI9pYFHeMGUhxaTXNjp2netfdO4/0EtIPOyTBQTyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760955917; c=relaxed/simple;
	bh=YcjGUas+rTJZZWYX0clPiN69myWk9xM3aRkcNKPtETk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fAtds//V5B1uOYzS1epVdc5kl34ZkDdtO20FGuocvh2Cco1v+nQ15sLMzMfENHT9GPgpwZl4a2wSq7Sv6ofhLzVjwAhG4jGYh8Tln3da4H4XLeUeCJQu3cY82TzuhIZpjMKFFpRWYWNay524JxmVUb8L4JbSy4SU9hTjoWuJ/1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=mnbxBBXx; arc=none smtp.client-ip=178.154.239.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="mnbxBBXx"
Received: from mail-nwsmtp-smtp-production-main-81.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-81.vla.yp-c.yandex.net [IPv6:2a02:6b8:c0f:571a:0:640:23e3:0])
	by forward101a.mail.yandex.net (Yandex) with ESMTPS id 88FE280CBB;
	Mon, 20 Oct 2025 13:25:05 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-81.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id 4PSwknVLsuQ0-y4e1rhPE;
	Mon, 20 Oct 2025 13:25:04 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1760955904; bh=GmAkEtcBAfqGPYjZGzBUuq58cfwM84ExHxR8sPdl8tM=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=mnbxBBXx/9aAw3YtIyF/mCx/B3kv2liFnlouN9zD4dHHYAz5ODk83lMkotwG33aon
	 QeXdo9mPmCsVdzAEZVeHLK6QDYXLRRS6AHfLmY+gO1dCP+y2c2m3jMuiibbZf6ire6
	 2r4xmpqBpcWE/xkRWIAOuUWm1kpuTEEn1TUerTdI=
Authentication-Results: mail-nwsmtp-smtp-production-main-81.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+4d55dad3a9e8e9f7d2b5@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: add extra consistency check to ocfs2_replay_truncate_records()
Date: Mon, 20 Oct 2025 13:24:55 +0300
Message-ID: <20251020102455.96229-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In 'ocfs2_replay_truncate_records()', check whether truncate long
length matches the one configured via the superblock parameters
established at mount and current record index is within the valid
range, thus preventing an out-of-bounds accesses while iterating
over the log records below.

Reported-by: syzbot+4d55dad3a9e8e9f7d2b5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4d55dad3a9e8e9f7d2b5
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/ocfs2/alloc.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 162711cc5b20..143ce8ba6071 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -5941,6 +5941,16 @@ static int ocfs2_replay_truncate_records(struct ocfs2_super *osb,
 
 	di = (struct ocfs2_dinode *) tl_bh->b_data;
 	tl = &di->id2.i_dealloc;
+	if (le16_to_cpu(tl->tl_count) != ocfs2_truncate_recs_per_inode(osb->sb)) {
+		status = -EINVAL;
+		mlog_errno(status);
+		goto bail;
+	}
+	if (le16_to_cpu(tl->tl_used) >= le16_to_cpu(tl->tl_count)) {
+		status = -EINVAL;
+		mlog_errno(status);
+		goto bail;
+	}
 	i = le16_to_cpu(tl->tl_used) - 1;
 	while (i >= 0) {
 		handle = ocfs2_start_trans(osb, OCFS2_TRUNCATE_LOG_FLUSH_ONE_REC);
-- 
2.51.0

