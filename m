Received: from forward206d.mail.yandex.net (forward206d.mail.yandex.net [178.154.239.215])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE74C29B8D0
	for <ocfs2-devel@lists.linux.dev>; Wed,  8 Oct 2025 11:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.215
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759922478; cv=none; b=Gx+WxOBwNk78OLCtCPoht8W8Gv8oSR+BtgKhMCAYzG8jAjB0KGxWdd2KSYijOcqusjY06ADokBrXyrXgldfYVgKWaURyb4c3ysVSfwQo76rLT5XypgBNvjTS1ft8iBF/yqVsiDDpUXLfsnFg2tLwUap9SF6QvXtuZ9e4BzgfRFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759922478; c=relaxed/simple;
	bh=8waNksfO0OV1P/exjCp0Ki2p5jqxBTRjHaJT5kJTCN8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AAtECY27TCGsp3BXHAzfWmKNstZVgTA4i7TNqvMXi2cvPNbTvanBx6xnLYLHO89gpTL0Dh3ZlSQMuEdGJFCNaqu142g8u9sYfmAhXYGLT0gRygW+zvFPs8Hl3iGsiBFTxCKf2EcYtpohqr/O/AnEzg2TDTAiTxrKYiuiU0LO8fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=geULqZaW; arc=none smtp.client-ip=178.154.239.215
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="geULqZaW"
Received: from forward103d.mail.yandex.net (forward103d.mail.yandex.net [IPv6:2a02:6b8:c41:1300:1:45:d181:d103])
	by forward206d.mail.yandex.net (Yandex) with ESMTPS id CAFD581CE8
	for <ocfs2-devel@lists.linux.dev>; Wed, 08 Oct 2025 14:21:06 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-92.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-92.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:7501:0:640:380f:0])
	by forward103d.mail.yandex.net (Yandex) with ESMTPS id 2B19AC0091;
	Wed, 08 Oct 2025 14:20:58 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-92.iva.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id uKk3mXHLQeA0-bhsGbKyx;
	Wed, 08 Oct 2025 14:20:57 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1759922457; bh=boqcYUMJzkJ1YhaEdeHYf2AbXaxt/wMfEDV+ld9yso0=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=geULqZaWgnSo9NykgdXaMATxNfM054K/TludK9i7k97HUY/1QNymQiFWGpltdEQ6H
	 Y5llCkPihgYvqkYhANU7uCIKQK8zydZm0GiZBOzg3ywuI610cpwx7e1Ov5xRmHGrCy
	 M3PFwI9Ye6khJkC0dxLOTb6sQQtFU/1/WZaKsyRE=
Authentication-Results: mail-nwsmtp-smtp-production-main-92.iva.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+727d161855d11d81e411@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: add extra flags check in ocfs2_ioctl_move_extents()
Date: Wed,  8 Oct 2025 14:20:31 +0300
Message-ID: <20251008112031.2369598-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.51.0
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

Reported-by: syzbot+727d161855d11d81e411@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=727d161855d11d81e411
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

