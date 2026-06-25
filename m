Received: from forward203a.mail.yandex.net (forward203a.mail.yandex.net [178.154.239.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1735384242
	for <ocfs2-devel@lists.linux.dev>; Thu, 25 Jun 2026 08:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782377232; cv=none; b=r32zMxru5yM30T4GU32+KPaavO1g7Ileykt3gJ47v2loVavAwJa79cTvoC4XeMq/pvwBEaJqdRVj1UdQR/inuVVdUX1t9Gd58/yrBR9f1Z1nHasFNk+1XUCJGiPZ50/oobuk8cpGfROdbQXzuR53mN94MpMbwaifjTF8bH4KE/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782377232; c=relaxed/simple;
	bh=MHKWFlRUbkhvN0GSDQHdq5wvLvBeXS+UHOoUhUSQNAw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oH9TwZYHwB1jmITUxqtW1CkB2VC0Z8Jvurn3hDtkOteRQanvKp4xUUHVjRPDkq9E/xTbeq3KC4bPw0J06Nete9I2J6DBlK61hIoUNrxJByOaIr2WXKW1t46GmxMqLbMzOx7OIgyrYr1Qhu4DsWqzgTgitNegEffIFPNCj63TxJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=JceyW9fI; arc=none smtp.client-ip=178.154.239.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="JceyW9fI"
Received: from forward101a.mail.yandex.net (forward101a.mail.yandex.net [IPv6:2a02:6b8:c0e:500:1:45:d181:d101])
	by forward203a.mail.yandex.net (Yandex) with ESMTPS id D714986869
	for <ocfs2-devel@lists.linux.dev>; Thu, 25 Jun 2026 11:47:00 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-94.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-94.vla.yp-c.yandex.net [IPv6:2a02:6b8:c15:290e:0:640:f317:0])
	by forward101a.mail.yandex.net (Yandex) with ESMTPS id 0CE0680769;
	Thu, 25 Jun 2026 11:46:53 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-94.vla.yp-c.yandex.net (smtp) with ESMTPSA id pkUPa6Ye18c0-5QOceyMJ;
	Thu, 25 Jun 2026 11:46:52 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1782377212; bh=4GMr0MaeEC9+Hk2qBbBq2oDrLCZWYAnvJsG9Y0pt1sc=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=JceyW9fIXP2RRi4VQVstGU6fd489ZN7ZEUKk/uWnMrWj5QB1h5nVrDnEuZq9T7RMS
	 jUWOzwYPRumySjl5CPCKmaQEo0QlcaHvwq+41qz1Fe5XsDyxUtHb8jvvsT0yU8EMy4
	 jHj3nnq/BTQevWP7nY+cn6eMaTDsauagfrl6XJl0=
Authentication-Results: mail-nwsmtp-smtp-production-main-94.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Sam Sun <samsun1006219@gmail.com>,
	ocfs2-devel@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] ocfs2: validate quota file block count in ocfs2_local_read_info()
Date: Thu, 25 Jun 2026 11:44:48 +0300
Message-ID: <20260625084448.1634511-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In 'ocfs2_local_read_info()', assume that number of blocks allocated
for local quota file should not exceed the limit based on claimed
number of chunks, and refuse an attempt to enable quota otherwise.

Reported-by: Sam Sun <samsun1006219@gmail.com>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/ocfs2/quota_local.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index f55810c59b1b..33a9b5b449c8 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -733,6 +733,13 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
 	oinfo->dqi_blocks = le32_to_cpu(ldinfo->dqi_blocks);
 	oinfo->dqi_libh = bh;
 
+	if (oinfo->dqi_blocks > oinfo->dqi_chunks * ol_chunk_blocks(sb)) {
+		mlog(ML_ERROR, "unexpectedly large local quota "
+		     "file block count %u\n", oinfo->dqi_blocks);
+		status = -EFSCORRUPTED;
+		goto out_err;
+	}
+
 	/* We crashed when using local quota file? */
 	if (!(oinfo->dqi_flags & OLQF_CLEAN)) {
 		rec = OCFS2_SB(sb)->quota_rec;
-- 
2.54.0

