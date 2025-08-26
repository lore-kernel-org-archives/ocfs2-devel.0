Received: from forward101a.mail.yandex.net (forward101a.mail.yandex.net [178.154.239.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31F0B661
	for <ocfs2-devel@lists.linux.dev>; Tue, 26 Aug 2025 09:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756201933; cv=none; b=By5ucI51I35E5/jSfpgJ0XKj1YF9t4R8bJ+p7JYnIXP+k3fM7Kku77J3eicbfy75AppaKGl1ltNFAw0sBgWic+Qz3C6l5TL0iyq/LcSiTRMM9fIKvTBjN3Syoicy7KyIqwY5X/0i6uZlSOkduYgUpwVocUUE6jcakXQnRtNFMGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756201933; c=relaxed/simple;
	bh=maSpfU7NlTtteFE0T1FICQPk0/7IpP8YAw9IFOTtYqU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kRqtFeP97/l+UKzTfQLPNgdUIWW42ErnRAK+cdF+jtrdwjMM1NDVJ/SjSPP5jRMi/VC4xjvw+SyNFJOo2b7i20D9to66hBTZDZ+0fU/Dnc/H/PeN94oFgMR6/S+nztsRx7V0BoUFN6jftWELX/0l0HMJaOEX+byLcb32ZsIdnxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=ftqtFdbG; arc=none smtp.client-ip=178.154.239.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="ftqtFdbG"
Received: from mail-nwsmtp-smtp-production-main-97.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-97.vla.yp-c.yandex.net [IPv6:2a02:6b8:c15:2804:0:640:a3ea:0])
	by forward101a.mail.yandex.net (Yandex) with ESMTPS id 4D39C805E7;
	Tue, 26 Aug 2025 12:52:01 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-97.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id xpU8VEFMnW20-0Rwo7aEr;
	Tue, 26 Aug 2025 12:52:00 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1756201920; bh=eRB9nDFi+nXvWXpDguh4pcVI8cP4v1MvB100csdLd9o=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=ftqtFdbGMx/2qNV6VXyYXYs/y1amID8CxBs2pfVMBY4KLmT/KIFfwTAQhlcJH0M51
	 0w3OZaXKmqE5ewZveyR8Kyqi05PF5w2YkjISTGgJyQi7VGy0sVqYOmXzQISAZwGMNX
	 LiF//7lXsof0z5Y4YZxFDS/Z3u0/kp5/F0PLNFRk=
Authentication-Results: mail-nwsmtp-smtp-production-main-97.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+900962ac9bf1860033f2@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: add suballoc slot check in ocfs2_validate_inode_block()
Date: Tue, 26 Aug 2025 12:51:06 +0300
Message-ID: <20250826095106.666980-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In 'ocfs2_validate_inode_block()', add suballoc slot check
similar to one in 'ocfs2_get_suballoc_slot_bit()', thus
preventing an out-of-bounds accesses for 'local_system_inodes'
in 'get_local_system_inode()'.

Reported-by: syzbot+900962ac9bf1860033f2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=900962ac9bf1860033f2
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
Most likely this fixes https://syzkaller.appspot.com/bug?extid=a77d690840e60bc2ddd8 as well.
---
 fs/ocfs2/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 14bf440ea4df..07cd3b4aa9cb 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1492,6 +1492,14 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if (le16_to_cpu(di->i_suballoc_slot) != (u16)OCFS2_INVALID_SLOT &&
+	    (u32)le16_to_cpu(di->i_suballoc_slot) > OCFS2_SB(sb)->max_slots - 1) {
+		rc = ocfs2_error(sb, "Invalid dinode %llu: suballoc slot %u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(di->i_suballoc_slot));
+		goto bail;
+	}
+
 	rc = 0;
 
 bail:
-- 
2.51.0

