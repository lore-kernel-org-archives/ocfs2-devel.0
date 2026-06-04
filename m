Received: from forward206b.mail.yandex.net (forward206b.mail.yandex.net [178.154.239.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8115142EEA1
	for <ocfs2-devel@lists.linux.dev>; Thu,  4 Jun 2026 12:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780574534; cv=none; b=LSNuRQhOEYms8Po0Owm89P51yYiLVKOLNNsv5JGJ6rqnEcQfPq9SUbqdJPQvumNr0Utrp48IPwsMSuHDTHmXnVxkWGV4ikp6i5IOhNPJYHv9TVqQuiYlTlIQfNlcDQBfwHCV+EdY/MsXar8B+fOsZI6W30/EG5pjbx70z8PsoF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780574534; c=relaxed/simple;
	bh=jHUt6clrzq3U7Z5EuBPVQgP1+Gw2SAV9zXunaz5B3A8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iiRgkCC1ux0b5GoADbizrPrR8DpMAKA5l5tP3GfTLIMwEuxS35NmFhr0GHYQ+fj0J9tz4K4nYOv0sQaS6QQMNJbXbTj6lvxxu0jssVegPwZiyMc73tmlNYUXPk/Az6lx1VYIp8S+P85+ONIvJXlKts+cnD8Kaa0Cb+C90kZH97w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=hDzPMDBf; arc=none smtp.client-ip=178.154.239.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="hDzPMDBf"
Received: from forward101b.mail.yandex.net (forward101b.mail.yandex.net [IPv6:2a02:6b8:c02:900:1:45:d181:d101])
	by forward206b.mail.yandex.net (Yandex) with ESMTPS id 8845D82ED6
	for <ocfs2-devel@lists.linux.dev>; Thu, 04 Jun 2026 15:01:59 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-canary-88.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-canary-88.sas.yp-c.yandex.net [IPv6:2a02:6b8:c1c:2e1d:0:640:64e7:0])
	by forward101b.mail.yandex.net (Yandex) with ESMTPS id 08D2DC0019;
	Thu, 04 Jun 2026 15:01:50 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-canary-88.sas.yp-c.yandex.net (smtp) with ESMTPSA id l1gOs6Ac8Cg0-g4YLMsTR;
	Thu, 04 Jun 2026 15:01:49 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1780574509; bh=G5IW7VPtJElyPruarUmp54VYttxOOnaux8WpI1nX2l4=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=hDzPMDBfxSx6FrJfice+f3/1f0Blr3KEM0IHU/9gw+NH4I5sposuQ7f0Qbwq3N1kE
	 kpt8ivqCotPxw0G8bAyoIbV/Jj/tGPwY5T5/JByRposoKuRlX79kiOfDkjxqsfuahu
	 ajW8Dlm4PUquGOKce2cvV3ha9ovFNFcIFy1O7eR8=
Authentication-Results: mail-nwsmtp-smtp-production-canary-88.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Joel Becker <jlbec@evilplan.org>,
	Mark Fasheh <mark@fasheh.com>,
	ocfs2-devel@lists.linux.dev,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+5bdd4953bc58c8fbd6eb@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: reject orphaned dinodes with non-zero link count
Date: Thu,  4 Jun 2026 14:59:19 +0300
Message-ID: <20260604115919.536337-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since non-zero link count for an orphaned inode most likely
means that on-disk inode data is corrupted, reject such an
inodes in 'ocfs2_validate_inode_block()'.

Reported-by: syzbot+5bdd4953bc58c8fbd6eb@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5bdd4953bc58c8fbd6eb
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
I'm quite sure about Closes: but was unable to test this using syzbot due to
"FATAL: kernel too old" issues (most likely caused by the kernel vs. glibc
mismatch) like https://syzkaller.appspot.com/x/log.txt?x=13f51bec580000.
---
 fs/ocfs2/inode.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index a510a0eb1adc..d483e0c61d12 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1477,6 +1477,15 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if ((le32_to_cpu(di->i_flags) & OCFS2_ORPHANED_FL) &&
+	    ocfs2_read_links_count(di)) {
+		rc = ocfs2_error(sb,
+				 "Invalid dinode #%llu: orphaned with %u links\n",
+				 (unsigned long long)bh->b_blocknr,
+				 ocfs2_read_links_count(di));
+		goto bail;
+	}
+
 	if (le32_to_cpu(di->i_fs_generation) !=
 	    OCFS2_SB(sb)->fs_generation) {
 		rc = ocfs2_error(sb,
-- 
2.54.0

