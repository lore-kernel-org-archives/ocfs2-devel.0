Received: from forward103d.mail.yandex.net (forward103d.mail.yandex.net [178.154.239.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB74F32779B
	for <ocfs2-devel@lists.linux.dev>; Thu, 23 Oct 2025 14:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.214
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761229031; cv=none; b=cnsRJ63Tg62cpxpVwZ4rnSfximpMxn8sAf0+v9DlEPVoO+XqpasWnYivBcahLv40pQShsl0eFe30eKqBcynjZneD+Lw1/Oka4UAJkACH9LeuQBRHhKeb4vHRjXBnGs5nDT3cA/hUuiaeFnx5QNr0tsRhevK2C6M+r0adBNpush0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761229031; c=relaxed/simple;
	bh=64fwtTDJa/bxy5EJ9MXE4o8s8hTmQtZlXZVj0AYG3Js=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CeAzjy88l5r0UoIggutTD+jIVQbYY45NlSXR9p5hqe2xe/QDHl5HlOLdP3y4yssV/X1DVuJ8Z716zKlI5myn04ZNvOdi4CuiHtx0fIdsUdRI2orGPPcVO+CgVX/MKFjoW8K/KGAAyh5nIlHoorhoUiq2CaUn6FDLtm//vKewmWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=XgmGMVCn; arc=none smtp.client-ip=178.154.239.214
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="XgmGMVCn"
Received: from mail-nwsmtp-smtp-production-main-88.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-88.klg.yp-c.yandex.net [IPv6:2a02:6b8:c43:84a0:0:640:dfd2:0])
	by forward103d.mail.yandex.net (Yandex) with ESMTPS id 71D99C010D;
	Thu, 23 Oct 2025 17:16:59 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-88.klg.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id vGZDgwDLlqM0-NcPNXHgf;
	Thu, 23 Oct 2025 17:16:58 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1761229018; bh=NU+ycM+gPP9TFiYVRQjYhB6mGo/K9SLdNurO4M9QqJU=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=XgmGMVCnWgfdjMN2B7oItMYOf0rqWg9LvRy4dUjJFOVKsGqCe/LTNf9P6S9w4OOOC
	 vOGtknCBDr5QqOccU8scQHyKCruvbHKfxrgP+Yh3ib47Bcn88JLkz1qrQoJGvtPqAj
	 b6pMaiKUgO+w6X/uQe2NqAr0aI307l3aVm9bRJYo=
Authentication-Results: mail-nwsmtp-smtp-production-main-88.klg.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+c16daba279a1161acfb0@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: add inline inode consistency check to ocfs2_validate_inode_block()
Date: Thu, 23 Oct 2025 17:16:50 +0300
Message-ID: <20251023141650.417129-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In 'ocfs2_validate_inode_block()', add an extra check whether an inode
with inline data (i.e. self-contained) has no clusters, thus preventing
an invalid inode from being passed to 'ocfs2_evict_inode()' and below.

Reported-by: syzbot+c16daba279a1161acfb0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c16daba279a1161acfb0
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/ocfs2/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index fcc89856ab95..5fad0a56cc98 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1503,6 +1503,14 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if ((le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) &&
+	    le32_to_cpu(di->i_clusters)) {
+		rc = ocfs2_error(sb, "Invalid dinode %llu: %u clusters\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le32_to_cpu(di->i_clusters));
+		goto bail;
+	}
+
 	rc = 0;
 
 bail:
-- 
2.51.0

