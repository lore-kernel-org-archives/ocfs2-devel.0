Received: from forward206a.mail.yandex.net (forward206a.mail.yandex.net [178.154.239.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280DC28D8F1
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Oct 2025 10:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760006033; cv=none; b=SlR7IzYbWAJg+rv2Rgx9oCIaTZWr/DPvoTrTrS/TGlzdZ+ht5RTNcDg3DAPsLt5/+TD+V6G3FOB3x+3pth5vJUT2b11q+RLqBoH+kr5BC7IeB49xSakfvPrqvgSb/8I0baAVHXgs8JPaVoL8tFBNrjYrxWA+kf5Icc2HZ1RYIZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760006033; c=relaxed/simple;
	bh=L5adSYpC+9e8s91/jq8s3Q+Wiuiu0FRnAHU4njAblYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gF2dZEfaXzgsHcoCxn7rSmOZqp/1Z25zrjJ2UsNJV2ihhxEVSjChZPheDcU1Kbmi60q7FABLbpACKYpSGCKZlp+RoHenu6EZslr0sd+7TYH5EE7yNAGHn8CsvtfconoogMQMSWxj2y9h8JN/9WTWudtFw1ihDcuGmSXSkezqxOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=fD/LYb17; arc=none smtp.client-ip=178.154.239.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="fD/LYb17"
Received: from forward103a.mail.yandex.net (forward103a.mail.yandex.net [IPv6:2a02:6b8:c0e:500:1:45:d181:d103])
	by forward206a.mail.yandex.net (Yandex) with ESMTPS id E9B7B8494D
	for <ocfs2-devel@lists.linux.dev>; Thu, 09 Oct 2025 13:26:15 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-91.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-91.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:9408:0:640:11a4:0])
	by forward103a.mail.yandex.net (Yandex) with ESMTPS id 93F9C807CD;
	Thu, 09 Oct 2025 13:26:07 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-91.iva.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id 5QHHeeRLEOs0-D9Aq4nw2;
	Thu, 09 Oct 2025 13:26:07 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1760005567; bh=CiwXLAzKN7luXJpl0Dmo6JBku3SCG8KmPHSqv5/vEj4=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=fD/LYb172EME0Sv3flIEBrqgohwMx8XX2vec4l1VWva3jgFd0zBHcsDI9KvD+y/E1
	 X1SR2+wqKRBg1Dmo7ZDmRImjcCq5HqJikEDdBOV74SHVOdpaxHmetLXoz7J+82g0DC
	 14jsYPKqw1VOzfLX6fc969Igk2kbkTA6W7ytxA40=
Authentication-Results: mail-nwsmtp-smtp-production-main-91.iva.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+727d161855d11d81e411@syzkaller.appspotmail.com
Subject: [PATCH 2/2] ocfs2: relax BUG() to ocfs2_error() in __ocfs2_move_extent()
Date: Thu,  9 Oct 2025 13:23:49 +0300
Message-ID: <20251009102349.181126-2-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009102349.181126-1-dmantipov@yandex.ru>
References: <6be1e189-b974-4666-add0-5b0fe7330fb3@linux.alibaba.com>
 <20251009102349.181126-1-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In '__ocfs2_move_extent()', relax 'BUG()' to 'ocfs2_error()' just
to avoid crashing the whole kernel due to a filesystem corruption.

Reported-by: syzbot+727d161855d11d81e411@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=727d161855d11d81e411
Fixes: 8f603e567aa7 ("Ocfs2/move_extents: move a range of extent.")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/ocfs2/move_extents.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index e038c009cdef..ba4952b41602 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -98,7 +98,13 @@ static int __ocfs2_move_extent(handle_t *handle,
 
 	rec = &el->l_recs[index];
 
-	BUG_ON(ext_flags != rec->e_flags);
+	if (ext_flags != rec->e_flags) {
+		ret = ocfs2_error(inode->i_sb,
+				  "Inode %llu has corrupted extent %d with flags 0x%x at cpos %u\n",
+				  (unsigned long long)ino, index, rec->e_flags, cpos);
+		goto out;
+	}
+
 	/*
 	 * after moving/defraging to new location, the extent is not going
 	 * to be refcounted anymore.
-- 
2.51.0

