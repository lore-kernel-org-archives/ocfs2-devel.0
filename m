Received: from forward103d.mail.yandex.net (forward103d.mail.yandex.net [178.154.239.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90965360751
	for <ocfs2-devel@lists.linux.dev>; Fri, 29 May 2026 09:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.214
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780047854; cv=none; b=PoCwjZ6yGRAD+gz+k6wWOwDdgV4+e/Oqh7T1+ilErWaLQgMIwI+n3C5SjzIaLJDoqvySMeYSDoORYm3oZChKpYZ8lfB/l5AGxHHQlm3FxZD7QwH3GFV3RUIATUoPoUt7+DhFOnWe3nVYPFQofcTaxSxwsVg3+qsSd/fC5y5kAQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780047854; c=relaxed/simple;
	bh=Gxyd3tvIfETeB2bBOroBq/t+j3pGkf2Em6zza1TMmgM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A5ewKh33MlrzMO98sqhMhKJuddrRrZXRSb8KKMPxszpUZ4Fq48D689Vxf8QrCGrFfID+gUtFLklM83166SKaaKEPQQDyqRsHBafgHcEbuW5ybRjZktbU+02CxQGU8y0FEHZJiKjDsK51S11eKqcLQJVXPLvMlL5mLYYa2BLBGRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=KVMD4AHe; arc=none smtp.client-ip=178.154.239.214
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="KVMD4AHe"
Received: from mail-nwsmtp-smtp-production-main-77.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-77.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:7ba3:0:640:5ad4:0])
	by forward103d.mail.yandex.net (Yandex) with ESMTPS id 8E6C0C0058;
	Fri, 29 May 2026 12:44:01 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-77.klg.yp-c.yandex.net (smtp) with ESMTPSA id whX9YAChH8c0-ewJe6OyR;
	Fri, 29 May 2026 12:44:00 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1780047840; bh=krACrAE8r+bphz7LiUcnGYn/6lOLEIt11tUu1vJmBIc=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=KVMD4AHeZs8BgQZ3Tve2uoN+WyfGkbIMxkLlOPx+s4/hnKTUonJaqOCfQ8ZmGTcT3
	 rsYZMYs+rpp1FzDgofGLZAaQ/bNJKsdXZxUvD4kYgKb413l2wy02q8ljXFPTcFSgLo
	 f0yr7ltq5exO8O0UGitmaGy1DA9NLCj67bZ4gq0k=
Authentication-Results: mail-nwsmtp-smtp-production-main-77.klg.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Joel Becker <jlbec@evilplan.org>,
	Mark Fasheh <mark@fasheh.com>,
	Changwei Ge <ge.changwei@h3c.com>,
	ocfs2-devel@lists.linux.dev,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+caacd220635a9cc3bac9@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: fix buffer head management in ocfs2_read_blocks()
Date: Fri, 29 May 2026 12:41:28 +0300
Message-ID: <20260529094128.494293-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In 'ocfs2_read_blocks()', caller should't assume that buffer head
returned by 'sb_getblk()' is exclusively owned and so 'put_bh()'
always drops b_count from 1 to 0. If it is not so, buffer head
remains on hold and likely to be returned by the next call to
'sb_getblk()' unchanged - that is, with BH_Uptodate bit set even
if it has failed validation previously, thus allowing to insert
that buffer head into OCFS2 metadata cache and submit it to upper
layers. To avoid such a scenario, BH_Uptodate should be cleared
immediately after 'validate()' callback has detected some data
inconsistency.

Reported-by: syzbot+caacd220635a9cc3bac9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=caacd220635a9cc3bac9
Fixes: cf76c78595ca ("ocfs2: don't put and assigning null to bh allocated outside")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
After introducing the series started with 775c17386a6fd ("ocfs2:
validate dx_root extent list fields during block read"), reproducer
from https://syzkaller.appspot.com/bug?extid=30b53487d00b4f7f0922
has started to trigger KASAN use-after-free again, and this patch
should fix this as well.
---
 fs/ocfs2/buffer_head_io.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index 701d27d908d4..6114299b121e 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -350,8 +350,6 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 						wait_on_buffer(bh);
 					put_bh(bh);
 					bhs[i] = NULL;
-				} else if (bh && buffer_uptodate(bh)) {
-					clear_buffer_uptodate(bh);
 				}
 				continue;
 			}
@@ -380,8 +378,11 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 				BUG_ON(buffer_jbd(bh));
 				clear_buffer_needs_validate(bh);
 				status = validate(sb, bh);
-				if (status)
+				if (status) {
+					if (buffer_uptodate(bh))
+						clear_buffer_uptodate(bh);
 					goto read_failure;
+				}
 			}
 		}
 
-- 
2.54.0

