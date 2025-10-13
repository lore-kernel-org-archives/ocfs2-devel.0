Received: from forward103a.mail.yandex.net (forward103a.mail.yandex.net [178.154.239.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC95F309EE4
	for <ocfs2-devel@lists.linux.dev>; Mon, 13 Oct 2025 15:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369417; cv=none; b=GpWQjUBZpuD9gVnkSW1wHU+oxlJ58N+co3Q61KnGJWGv6XsL20kvToTl5KpwPv9b2vAKFVkYbUPXM/uMhMWDENwt+p3NoZSTzC+ccCyFXSNORSsB0yUIoKt9jjHFwP89FupME0c28O0QBbcQR99hJzsNUYmspHNL15wSe+vadJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369417; c=relaxed/simple;
	bh=2bEMm1jpK4+i4Iwzb0gc5dZF8tZXIN4AMo6XOwmrq+8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uLrvOpsa2GGrzf7BR0BCQ3vNdEj2O708yE/XsJi0Dsv36DQWQoEbRgocV5O3RWIL6RQxWSLfGyJ94Z+pv8LZfvsLWXVWLlWvWdwQ4Vx/s4uJtY2PdhY44uXbl33y87IOYI34LWfGd9mfMpr7aDnQYglHBnCknw2zRu4HUJPKiYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=HUdk68VS; arc=none smtp.client-ip=178.154.239.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="HUdk68VS"
Received: from mail-nwsmtp-smtp-production-main-92.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-92.vla.yp-c.yandex.net [IPv6:2a02:6b8:c0f:4880:0:640:22e4:0])
	by forward103a.mail.yandex.net (Yandex) with ESMTPS id 1843380784;
	Mon, 13 Oct 2025 18:30:05 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-92.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id 3UQnZrQLG8c0-QbOHlyiU;
	Mon, 13 Oct 2025 18:30:04 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1760369404; bh=lNX9S3uPE98ES89f3N+5mxTP/sr/4fgKSbkrCjMbkHY=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=HUdk68VS1GVRfokgQUNCikGE62Fhud563LaSmA/zPoclztIfTgw0mb42fyJ3QndMn
	 WWB+cl6MKU1Zt+ShviYF4slnHR0GzRrPFLGgA4cY+I1HkjK1sFw/6h5Tfr5Yq3eEwt
	 3b/GkKG2u2u6RotF2gIR7SPrq7AALp+C+o1Mki3Q=
Authentication-Results: mail-nwsmtp-smtp-production-main-92.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] ocfs2: fix __counted_by_le() usage in ocfs2_expand_inline_dx_root()
Date: Mon, 13 Oct 2025 18:30:02 +0300
Message-ID: <20251013153002.167377-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After annotating 'l_recs[]' VLA member of 'struct ocfs2_extent_list'
with '__counted_by_le(l_count)', 'l_count' should be initialized
before touching 'l_recs[]' with 'memset()' to avoid false positives
from buffer overflow guards when CONFIG_UBSAN_BOUNDS is enabled.

Fixes: aa545adbe491 ("ocfs2: annotate flexible array members with __counted_by_le()")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
note: since the commit in subject is not merged to upstream yet, Fixes: reference is taken from
https://web.git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?h=mm-nonmm-unstable&id=aa545adbe491
---
 fs/ocfs2/dir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 3c2dacba9b0a..d9a2fcb63bbb 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -4133,10 +4133,10 @@ static int ocfs2_expand_inline_dx_root(struct inode *dir,
 	}
 
 	dx_root->dr_flags &= ~OCFS2_DX_FLAG_INLINE;
-	memset(&dx_root->dr_list, 0, osb->sb->s_blocksize -
-	       offsetof(struct ocfs2_dx_root_block, dr_list));
 	dx_root->dr_list.l_count =
 		cpu_to_le16(ocfs2_extent_recs_per_dx_root(osb->sb));
+	memset(&dx_root->dr_list, 0, osb->sb->s_blocksize -
+	       offsetof(struct ocfs2_dx_root_block, dr_list));
 
 	/* This should never fail considering we start with an empty
 	 * dx_root. */
-- 
2.51.0

