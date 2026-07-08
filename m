Received: from forward205b.mail.yandex.net (forward205b.mail.yandex.net [178.154.239.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3AA3EA95C
	for <ocfs2-devel@lists.linux.dev>; Wed,  8 Jul 2026 07:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783494407; cv=none; b=ghcR8XCwlvw1N5c7ucHMNCrGqa/cQUf8GaiJjM3CWKWvV3N1j5PYrluxJOmBuEptn5RtNoZStLvaknb4LpEsZ9Z/MiV7P+Fe8uK4f6gKj2inU5EXcOLIw9I8DfQ7Ti8d+hMi14uzjWeVFU0sE6KtMSFRXvamCAOQGaoWz0RXWXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783494407; c=relaxed/simple;
	bh=Y10FxRtxvPyTE98QrQ0uhl3uaSSR+IXDpPDJ2i7qnZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hAC54/RxTIKH8uxcZJkWpXHEKzo9wxHPz6WXt9ks1pizMcx/pRIZlUE3KzPiqG0atIR+oNkAy/q9UYkNdkVMNwiFtovSjHGj8uvIhPjzQLelspK469ekFCmeWTAWCN/j65apBT9gYu5EsVAfgVAWumkDO7lXyuHXJTWxDbuMuCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=GvcJs6Se; arc=none smtp.client-ip=178.154.239.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="GvcJs6Se"
Received: from forward100b.mail.yandex.net (forward100b.mail.yandex.net [IPv6:2a02:6b8:c02:900:1:45:d181:d100])
	by forward205b.mail.yandex.net (postfix) with ESMTPS id 1B23A8574A
	for <ocfs2-devel@lists.linux.dev>; Wed, 08 Jul 2026 10:06:21 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net [IPv6:2a02:6b8:c24:1698:0:640:befc:0])
	by forward100b.mail.yandex.net (postfix) with ESMTPS id 6F76C811FC;
	Wed, 08 Jul 2026 10:06:13 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net (smtp) with ESMTPSA id 96DIFQGgDa60-zMHGkanp;
	Wed, 08 Jul 2026 10:06:12 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1783494372; bh=KWmvEayVfMIbsbbRNy8vvK5OzBoBC4nnPrXdQG8aHFY=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=GvcJs6SerM4QMbKGdx2CgqlCcytfohdxDwGcna61Tjmjk32OfgiicnC8kEUeBEGfw
	 i6pIk/afxvTq6+sRYgsfYZ3v/J1icAQg2iXxH8mhyFjU73WEB8Y6w/1bBlhS6qP8XT
	 QFP652L4OO20KTq1uvWgKKbK9lgT1gvtuOI19ffI=
Authentication-Results: mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	Heming Zhao <heming.zhao@suse.com>,
	Ahmet Eray Karadag <eraykrdg1@gmail.com>,
	Albin Babu Varghese <albinbabuvarghese20@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+d222f4b7129379c3d5bc@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: do not use make_bad_inode() in ocfs2_read_inode_block_full()
Date: Wed,  8 Jul 2026 10:02:54 +0300
Message-ID: <20260708070254.149940-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit 58b6fcd2ab34 ("ocfs2: mark inode bad upon
validation failure during read").

Since 'make_bad_inode()' resets inode type to S_IFREG, doing this
for directory inode during active VFS lookup ls likely to confuse
the latter, including VFS_BUG_ON_INODE() triggered in this case.

Reported-by: syzbot+d222f4b7129379c3d5bc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d222f4b7129379c3d5bc
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
Suggested by Al at https://syzkaller.appspot.com/text?tag=Patch&x=10c51a1a580000.

I've also verified https://syzkaller.appspot.com/bug?extid=b93b65ee321c97861072
and this issue is no longer triggered when 'make_bad_inode()' is dropped.
---
 fs/ocfs2/inode.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 662dbc845b8b..b5d109cc9edc 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1948,8 +1948,6 @@ int ocfs2_read_inode_block_full(struct inode *inode, struct buffer_head **bh,
 	rc = ocfs2_read_blocks(INODE_CACHE(inode), OCFS2_I(inode)->ip_blkno,
 			       1, &tmp, flags, ocfs2_validate_inode_block);
 
-	if (rc < 0)
-		make_bad_inode(inode);
 	/* If ocfs2_read_blocks() got us a new bh, pass it up. */
 	if (!rc && !*bh)
 		*bh = tmp;
-- 
2.55.0

