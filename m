Received: from forward102a.mail.yandex.net (forward102a.mail.yandex.net [178.154.239.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA7A330D23
	for <ocfs2-devel@lists.linux.dev>; Wed, 22 Oct 2025 11:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.85
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761133096; cv=none; b=gv/RJQKGi8CMWvDNRHcpGzsxU9V8lR7Y71Tu2zV+E1joocUEQJPskyGgu5mWEUcb6hUraxSXVcvuWbopHf/TXUYd/V4AsGOzIuNSmzWTKfIMawFG/BiyBHg2Lnz4wUs4j76T1/ZSkHeItfnRQloePKRktm84/3QFB3gYwjsXiWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761133096; c=relaxed/simple;
	bh=3TH2vVoDrj+eVC9yVcdbS4YZE95+NgI66TrtTh5H094=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qNwkN6cl9Zg4r92tSwhqZwkLS7WzTNLhEiYf440Nw5QxQjkmQlrrz2e5nhIUV3fcsWnuW86Fv/MPRzMsBXn0xX2mz3M807dfJKuZm07HIz2pdm3pv0/3A2oUBwGrbDrkudFflDMyQRneWMD8G65GPeZ3bLUNc9PMd/0HnajLUys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=AAKsQIm1; arc=none smtp.client-ip=178.154.239.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="AAKsQIm1"
Received: from mail-nwsmtp-smtp-production-main-91.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-91.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:3d8a:0:640:4a68:0])
	by forward102a.mail.yandex.net (Yandex) with ESMTPS id 1F6E5C0072;
	Wed, 22 Oct 2025 14:38:03 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-91.iva.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id 0cVN4J1LteA0-X6Fmz1Cr;
	Wed, 22 Oct 2025 14:38:02 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1761133082; bh=bABJGCrpBQa418K8e1HXDzy0csFfKn8hRQ/DOi9s8cY=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=AAKsQIm12gciNU2kFtQNdrVP36BZbtdpSTWOphK7bzjWSbmnrpD9be4ADTkjWmA6J
	 fOyoc9RAqXJ/3aGWGL/YJ2fmEcumD6JUrgQ9I+fJspzbMKqnq/n3g2tCk1sWcvIKlV
	 G6ApnrgxvnJvyg3mWwyUuacoLhflg/dolJh/NG1Q=
Authentication-Results: mail-nwsmtp-smtp-production-main-91.iva.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+c24237f0eee59c0c2abb@syzkaller.appspotmail.com,
	syzbot+4d55dad3a9e8e9f7d2b5@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: improve truncate log consistency check in ocfs2_get_truncate_log_info()
Date: Wed, 22 Oct 2025 14:37:42 +0300
Message-ID: <20251022113742.198134-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In 'ocfs2_get_truncate_log_info()', add an extra check whether number of
used records doesn't exceed the limit defined when making a filesystem,
this preventing at least two BUG()s caused by an attempts to handle
corrupted data structures.

Reported-by: syzbot+c24237f0eee59c0c2abb@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c24237f0eee59c0c2abb
Reported-by: syzbot+4d55dad3a9e8e9f7d2b5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4d55dad3a9e8e9f7d2b5
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
note: this patch supersedes "ocfs2: add extra consistency check to
ocfs2_replay_truncate_records()" because it fixes two syzbot reports at once
---
 fs/ocfs2/alloc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 162711cc5b20..ce38505a823c 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6164,7 +6164,7 @@ static int ocfs2_get_truncate_log_info(struct ocfs2_super *osb,
 	struct buffer_head *bh = NULL;
 	struct ocfs2_dinode *di;
 	struct ocfs2_truncate_log *tl;
-	unsigned int tl_count;
+	unsigned int tl_count, tl_used;
 
 	inode = ocfs2_get_system_file_inode(osb,
 					   TRUNCATE_LOG_SYSTEM_INODE,
@@ -6184,9 +6184,10 @@ static int ocfs2_get_truncate_log_info(struct ocfs2_super *osb,
 
 	di = (struct ocfs2_dinode *)bh->b_data;
 	tl = &di->id2.i_dealloc;
+	tl_used = le16_to_cpu(tl->tl_used);
 	tl_count = le16_to_cpu(tl->tl_count);
 	if (unlikely(tl_count > ocfs2_truncate_recs_per_inode(osb->sb) ||
-		     tl_count == 0)) {
+		     tl_count == 0 || tl_used > tl_count)) {
 		status = -EFSCORRUPTED;
 		iput(inode);
 		brelse(bh);
-- 
2.51.0

