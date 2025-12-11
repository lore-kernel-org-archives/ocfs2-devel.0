Received: from forward102d.mail.yandex.net (forward102d.mail.yandex.net [178.154.239.213])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CA930C629
	for <ocfs2-devel@lists.linux.dev>; Thu, 11 Dec 2025 12:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765454646; cv=none; b=A5kogKSA+4Q6R6LBV7Tlg6pSkGEg8Vmkz5FyKiKuE7kpmxKAPcgQ+s1kwhdTrhWnuCmK1VZmwgQJSxetbr7y3w90Ia9/HWLTiqgg4tfaWBid/iuz4EJZdcSJnPoS9P0Ad/F4+A5x2dnxd8IJVph3vTckLHR/U2oDahiZwOOepoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765454646; c=relaxed/simple;
	bh=d5DdcH7e3V91SffZDhX2mFMvkm7hwOJOgeud7+VdBGA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X0fEH8grtnPpd7sRcee6HufhVnNnxUb01IsJz2DdjVLS2RhrssJbczAkZGGkTZeoPIfuZ5MW0ABKmBgqrqRZGPtVow/mVM3EnOyumkkRHv2S27zsBDTF+v81kZbTzHkpU7ud0rrTBnjpzvOn9qyW8DI82q0k3nORqbBCMSTM1ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=dXWznaDB; arc=none smtp.client-ip=178.154.239.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="dXWznaDB"
Received: from mail-nwsmtp-smtp-production-main-81.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-81.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:3d48:0:640:52d7:0])
	by forward102d.mail.yandex.net (Yandex) with ESMTPS id C3738C01D9;
	Thu, 11 Dec 2025 15:03:53 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-81.klg.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id q3OB2xXL2Sw0-Dp1PO9wp;
	Thu, 11 Dec 2025 15:03:53 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1765454633; bh=CMuwD5Pd/PVm3pAnV5IVDzILSZy9j1JnXUfnKKMhRZM=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=dXWznaDBCfXC4MRzpAbhx0SytpIflsu83yWMcmoPv2uIn8NMSoryk7anguKg3xlwL
	 50mcusmxfZRO8b9Y4DMuQuLR6s/dDvz9snYefESFM3ufffMfoB475F/h1Ml9FQI4/r
	 mKyuJ/qlBD0IU0ehQ5ZkwEpUSk2cYVn9oNF//IzE=
Authentication-Results: mail-nwsmtp-smtp-production-main-81.klg.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	ocfs2-devel@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+cf96bc82a588a27346a8@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: adjust ocfs2_xa_remove_entry() to match UBSAN boundary checks
Date: Thu, 11 Dec 2025 15:03:50 +0300
Message-ID: <20251211120350.693428-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In 'ocfs2_xa_remove_entry()', perform 'xh_entries[]' member removal
before actually changing 'xh_count', thus making sure that all array
accesses matches the boundary checks performed by UBSAN.

Reported-by: syzbot+cf96bc82a588a27346a8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cf96bc82a588a27346a8
Fixes: 2f26f58df041 ("ocfs2: annotate flexible array members with __counted_by_le()")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/ocfs2/xattr.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index dc1761e84814..de99276d12f0 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1941,8 +1941,7 @@ static void ocfs2_xa_remove_entry(struct ocfs2_xa_loc *loc)
 	ocfs2_xa_wipe_namevalue(loc);
 	loc->xl_entry = NULL;
 
-	le16_add_cpu(&xh->xh_count, -1);
-	count = le16_to_cpu(xh->xh_count);
+	count = le16_to_cpu(xh->xh_count) - 1;
 
 	/*
 	 * Only zero out the entry if there are more remaining.  This is
@@ -1957,6 +1956,8 @@ static void ocfs2_xa_remove_entry(struct ocfs2_xa_loc *loc)
 		memset(&xh->xh_entries[count], 0,
 		       sizeof(struct ocfs2_xattr_entry));
 	}
+
+	xh->xh_count = cpu_to_le16(count);
 }
 
 /*
-- 
2.52.0

