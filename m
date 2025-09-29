Received: from forward204a.mail.yandex.net (forward204a.mail.yandex.net [178.154.239.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC6D15CD7E
	for <ocfs2-devel@lists.linux.dev>; Mon, 29 Sep 2025 17:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759165838; cv=none; b=MYngQIIVehgQoic6w2W92cWmd4svp8Kch5N4GR2JUHiinwJHoTmMKn1Ub3297LQSGZHsX3azrPgXZuiJLHuaq2TWfsSR/0sPnwK92rGM/1qloDHEGJ5fEVXYYEmjSTvxjr/ylpELidGnDcDNVQDjSwzv3/EWfeWvOlWrhnXqEGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759165838; c=relaxed/simple;
	bh=AqG+VN+XTRXvPYAl/RdKhtK+sNI+hoitJjH8Ovk8iJM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VDDo3UzC5q1oSS7NgLO1GUYL2xC6u76bbeNYSXMqm0t7QXIyHcS0cPoGq+at+PkE0uiMCkgNj1aGtqzJHnCjnbubWxwymCFdijuoPNkDTLgbEY4VpfMgEaKPBod5NyXq5FkQB56HA+zdUBWM9E+2dbVVGYK7rOdYqOlW3I/82nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=ILTbD2lD; arc=none smtp.client-ip=178.154.239.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="ILTbD2lD"
Received: from forward103a.mail.yandex.net (forward103a.mail.yandex.net [IPv6:2a02:6b8:c0e:500:1:45:d181:d103])
	by forward204a.mail.yandex.net (Yandex) with ESMTPS id B08E582D73
	for <ocfs2-devel@lists.linux.dev>; Mon, 29 Sep 2025 20:04:44 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-72.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-72.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:788b:0:640:a95d:0])
	by forward103a.mail.yandex.net (Yandex) with ESMTPS id 1CC8A8066B;
	Mon, 29 Sep 2025 20:04:37 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-72.iva.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id Z4hrTC2MaSw0-VLR1f7ok;
	Mon, 29 Sep 2025 20:04:36 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1759165476; bh=TOyF+5uC5dmCc4kSCZUH2RkpR/E8s0X2vFxA3P6u7KM=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=ILTbD2lDMycMOyDZPAeqGagFAETsgWhgdfrIb5iXL/11OJgLTy7DVWnXZ/dPqvTuF
	 ZRBt0NUy7xlYkil52ovld7nB6kQvjXCCZ/pJPwAWmX+ntKI/rtyKc0vqeY2JikdAvp
	 8spGUWC3vHeiZ8dH0YhoPcjHVFtyDXLH0B4F/m/M=
Authentication-Results: mail-nwsmtp-smtp-production-main-72.iva.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+30b53487d00b4f7f0922@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: add extra consistency check to ocfs2_dx_dir_lookup()
Date: Mon, 29 Sep 2025 20:04:34 +0300
Message-ID: <20250929170434.1757820-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In 'ocfs2_dx_dir_lookup()', check whether an extent list length
of the directory indexing block matches the one configured via
the superblock parameters established at mount, thus preventing
an out-of-bounds accesses in 'ocfs2_dx_dir_lookup_rec()'.

Reported-by: syzbot+30b53487d00b4f7f0922@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=30b53487d00b4f7f0922
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/ocfs2/dir.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 8c9c4825f984..ff632f1337b7 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -865,6 +865,13 @@ static int ocfs2_dx_dir_lookup(struct inode *inode,
 	u64 blkno;
 	u32 name_hash = hinfo->major_hash;
 
+	if (le16_to_cpu(el->l_count) !=
+	    ocfs2_extent_recs_per_dx_root(inode->i_sb)) {
+		ret = -EFSCORRUPTED;
+		mlog_errno(ret);
+		goto out;
+	}
+
 	ret = ocfs2_dx_dir_lookup_rec(inode, el, name_hash, &cpos, &blkno,
 				      &clen);
 	if (ret) {
-- 
2.51.0

