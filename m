Received: from forward102b.mail.yandex.net (forward102b.mail.yandex.net [178.154.239.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAAA218AB9
	for <ocfs2-devel@lists.linux.dev>; Mon, 20 Oct 2025 15:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760972579; cv=none; b=MuKy3cAFII7m7xLl+/ApPhM1vFww9MOHj0JNdeGXDvpx7XyP44eR8mhqDVrK/XANMpc1mPW3evEjx+60sT8xK67GfytZybAmxEnHvxemdDT3dof7ntL5RITm+L8GrzbsJJ8QD7l3y3hHPth/9P9n0KmvSn/Hk014o25tHbkqJoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760972579; c=relaxed/simple;
	bh=lYMywPuRkYuzanjpcTYK4vWq+W4tBiuK+Cjm+laTXEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MhUQ88x/GpLFbS1iGFgNOp2RJZO4baUNasKfU2FfG+8TvOP434BRTZC7U8bUToSBKWrx3dm6swIV2jwCxm3XPtO658mCXokS2Zxw1cBZPEfxZQHKZGLTlcOWHUqARx+6vSnFvTx9ms/dPM8Te2KlzamK1RgHO9cYmBDvFVSpS0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=sjgw8Z4M; arc=none smtp.client-ip=178.154.239.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="sjgw8Z4M"
Received: from mail-nwsmtp-smtp-production-main-98.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-98.sas.yp-c.yandex.net [IPv6:2a02:6b8:c23:1ba8:0:640:1638:0])
	by forward102b.mail.yandex.net (Yandex) with ESMTPS id 621CCC010F;
	Mon, 20 Oct 2025 18:02:46 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-98.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id i2XQQM3L1Ko0-SISufuvz;
	Mon, 20 Oct 2025 18:02:45 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1760972565; bh=3QrvctDafh8rTWJf5v2+nOJuCynCiv3WFBzleqjx/CM=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=sjgw8Z4McZ5YSQvQVk47UKH1bKf73h3p+shnB4TWd9/CdCfFqre1EBt5OL0dICDaE
	 V2BJrqUAQPOVKnrPVyjhlYgE9IIml6Q7LIdHLSg7BTSd5D+t4f6NzpCOb1v5I98hBd
	 R29k5kboo3OwG2k47qZNqof5lAdAphjf1d7PS+2E=
Authentication-Results: mail-nwsmtp-smtp-production-main-98.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+4d55dad3a9e8e9f7d2b5@syzkaller.appspotmail.com
Subject: [PATCH v2] ocfs2: add extra consistency check to ocfs2_replay_truncate_records()
Date: Mon, 20 Oct 2025 18:02:27 +0300
Message-ID: <20251020150227.210267-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <18c4bf1b-5860-46ff-9e55-71e715fafdf2@suse.com>
References: <18c4bf1b-5860-46ff-9e55-71e715fafdf2@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In 'ocfs2_replay_truncate_records()', check whether truncate log
length matches the one comes from the superblock parameters defined
when making a filesystem and current record index is within the valid
range, thus preventing an out-of-bounds accesses while iterating over
the log records below.

Reported-by: syzbot+4d55dad3a9e8e9f7d2b5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4d55dad3a9e8e9f7d2b5
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
v2: adjust commit message (Heming Zhao)
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

