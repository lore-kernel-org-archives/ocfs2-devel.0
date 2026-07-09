Received: from forward203b.mail.yandex.net (forward203b.mail.yandex.net [178.154.239.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CD41FC8
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Jul 2026 06:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783577370; cv=none; b=ChKfLPJ6TLE7TP+uRT2s0qzgdTOuseeJWv8r1KwA02woPLgDyUWSpeGf3O0Xy3SZVx5PriM14zHH51d7DRelYwy2D1SH/f9TqvomPpEJ0pRBtT5uTw1QiR+UIvNu7AOFLd+qzyYAa8JT3PK08LvI1XeCclC7kL0TbViKIywfysg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783577370; c=relaxed/simple;
	bh=rwHF1ccDi2KEOv/HW5TMtEEnQCGxblRbgcHaVQKExiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TgOxodkveReXFTRnEKm7Ds4JMjJ8wmcgScuLpm0Zhj27N1yurOa79BUIr2+4ePzh5dTet66ifd7dKzr/kb/rA5fizklsdFiDpzT5BHmRvIH2HbnqoQ8X92T3sIOTDgAJqejFJw2aiSEyNoV4remWQroIzDGYQsJ0xbkrrS9MDgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=Bll97FK4; arc=none smtp.client-ip=178.154.239.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="Bll97FK4"
Received: from forward103b.mail.yandex.net (forward103b.mail.yandex.net [IPv6:2a02:6b8:c02:900:1:45:d181:d103])
	by forward203b.mail.yandex.net (postfix) with ESMTPS id 1101183D36
	for <ocfs2-devel@lists.linux.dev>; Thu, 09 Jul 2026 09:03:14 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-69.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-69.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:1e19:0:640:66e9:0])
	by forward103b.mail.yandex.net (postfix) with ESMTPS id 19B95C0066;
	Thu, 09 Jul 2026 09:03:06 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-69.iva.yp-c.yandex.net (smtp) with ESMTPSA id 33DGQe4dFa60-QIP5t23V;
	Thu, 09 Jul 2026 09:03:05 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1783576985; bh=LGiiyNIqmKUtNPB9vjYwzBsLlP15w+7WCQ4Q5T+xbGo=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=Bll97FK4/bM1tOvzEvPfVcEOIoKTIuCqCricVixdWGcpbDyYDxE+FdCMAsFWn2k2f
	 u/9OUR6PkCn5b8cR+imuZ1nLpibIjdceMrzZx4P4LTqaEp0AUcp+0b01dc70IXv3uM
	 wNNZFMS0ps4pDYbbZu1PxFWZZWwg+qRmvt3UGV7I=
Authentication-Results: mail-nwsmtp-smtp-production-main-69.iva.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
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
Subject: [PATCH v2] ocfs2: do not use make_bad_inode() in ocfs2_read_inode_block_full()
Date: Thu,  9 Jul 2026 09:01:01 +0300
Message-ID: <20260709060101.207262-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <af3d9607-0704-4121-b969-23e1c4b397e4@linux.alibaba.com>
References: <af3d9607-0704-4121-b969-23e1c4b397e4@linux.alibaba.com>
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
for directory inode during active VFS lookup is likely to confuse
the latter, including VFS_BUG_ON_INODE() triggered in this case.

Reported-by: syzbot+d222f4b7129379c3d5bc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d222f4b7129379c3d5bc
Fixes: 58b6fcd2ab34 ("ocfs2: mark inode bad upon validation failure during read")
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
v2: fix typo and add Fixes: tag

Suggested by Al at https://syzkaller.appspot.com/text?tag=Patch&x=10c51a1a580000.

I've also verified https://syzkaller.appspot.com/bug?extid=b93b65ee321c97861072
and this issue is no longer triggered when 'make_bad_inode()' is dropped. And note
https://lore.kernel.org/all/57qlrwjb2kxgolx4yim3jsdflunh2gvqhsqq5ttsfenbjfl4vu@3nliqvyxsnhb
as well.
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

