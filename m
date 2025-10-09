Received: from forward100b.mail.yandex.net (forward100b.mail.yandex.net [178.154.239.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2E82D9EE6
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Oct 2025 10:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760005574; cv=none; b=O0GhGDYt+fcQAPH6IP9udjWUVz1G6I7aZaDwAViC8rBgCS/Ef7C/q7oDfZNif+h+vPMwr3srr6JlKVoLRm42coTa40YtEKFjNGvJadKqCuXNmmsRjG9SQvvwgDsoL9TWKeJ0oYNcSKHBNq/xzcadVfTjtPG0czlKkkdiMHRQzGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760005574; c=relaxed/simple;
	bh=S7yf/b8fQZg1I0vgMK+mGhkBVZjsGg08qD5VBlHNfSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EiTQnPBu4D8fvV6mDhsbFheclCcBcPT3VYDbtFfl281WHT8WxmoBwreozaaA2nlPlwtIVropydgQ/3WIUjTP0PWgi451mcMX39smko7zWUBwHXudN0OoDTV35GPTuxBOf8nlZl9vmwKKurubNL9TxPdiV/uoCUfKwSZBp/LraxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=SgsGt2ly; arc=none smtp.client-ip=178.154.239.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="SgsGt2ly"
Received: from mail-nwsmtp-smtp-production-main-91.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-91.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:9408:0:640:11a4:0])
	by forward100b.mail.yandex.net (Yandex) with ESMTPS id BF4D480B00;
	Thu, 09 Oct 2025 13:26:06 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-91.iva.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id 5QHHeeRLEOs0-RetGsDy0;
	Thu, 09 Oct 2025 13:26:06 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1760005566; bh=5PIsMmNUTXTGCVVi+t0KZSj6uu0RmcMFYHhBBFs0g0E=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=SgsGt2ly/NNGxo6kxhb1B/Garl+MurXM3kmUuCm44Rf6qxt9jhU/JUiaANY5/4AV7
	 RmUl6ElyKmtb97di4JYzMiJ9XZUZltdaXfwMh62pKfavXh5vw2cxl1kQfrLWbbfD2W
	 LZwuj1dfAxOQuZ1VAXSKgmHeb7/vS/QyTcntoIzQ=
Authentication-Results: mail-nwsmtp-smtp-production-main-91.iva.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH 1/2] ocfs2: add extra flags check in ocfs2_ioctl_move_extents()
Date: Thu,  9 Oct 2025 13:23:48 +0300
Message-ID: <20251009102349.181126-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <6be1e189-b974-4666-add0-5b0fe7330fb3@linux.alibaba.com>
References: <6be1e189-b974-4666-add0-5b0fe7330fb3@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In 'ocfs2_ioctl_move_extents()', add extra check whether only actually
supported flags are passed via 'ioctl(..., OCFS2_IOC_MOVE_EXT, ...)',
and reject anything beyond OCFS2_MOVE_EXT_FL_AUTO_DEFRAG and
OCFS2_MOVE_EXT_FL_PART_DEFRAG with -EINVAL. In particular,
OCFS2_MOVE_EXT_FL_COMPLETE may be set by the kernel only and
should never be passed from userspace.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/ocfs2/move_extents.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 86f2631e6360..e038c009cdef 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -1031,6 +1031,12 @@ int ocfs2_ioctl_move_extents(struct file *filp, void __user *argp)
 	if (range.me_threshold > i_size_read(inode))
 		range.me_threshold = i_size_read(inode);
 
+	if (range.me_flags & ~(OCFS2_MOVE_EXT_FL_AUTO_DEFRAG |
+			       OCFS2_MOVE_EXT_FL_PART_DEFRAG)) {
+		status = -EINVAL;
+		goto out_free;
+	}
+
 	if (range.me_flags & OCFS2_MOVE_EXT_FL_AUTO_DEFRAG) {
 		context->auto_defrag = 1;
 
-- 
2.51.0

