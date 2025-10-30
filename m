Received: from forward204d.mail.yandex.net (forward204d.mail.yandex.net [178.154.239.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086A7157480
	for <ocfs2-devel@lists.linux.dev>; Thu, 30 Oct 2025 15:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761838592; cv=none; b=QILmnotO8Iqul/ydU6WtvIeuO2fIYo/cKQCQrLV2goLLRLcXSbwIoTiE71imvVo6QsV8tGLP5fP5oJ/d6+a7/3uCEP6YS7sd7nzfnfeSlZ+WE1VwKPCEchaZZw09qXutym7DPqB1fBGW90Bn+IsrXGSIGPkrqcPIGam6MSxlC4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761838592; c=relaxed/simple;
	bh=RVkZm31EWmzHCAyHMhuD92HDfDMmpla4ZzR/+CqkdTs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=i/nTZ/qM11RexDif0leWvE1QWc0K/pBVvNXKBQcL0E0ndggaocdyXoZc1LPbqsc1IqwMHxpurMVgMbW4HCkNoEo4GgfKlFmFEPRnxK+PczlswNjTXQepTn+kjetS6BtU+DnwR6sohl/pHO5udSXZHJfVhdYxf4p4fUs8cBWz33I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=ZtNG4ExN; arc=none smtp.client-ip=178.154.239.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="ZtNG4ExN"
Received: from forward100d.mail.yandex.net (forward100d.mail.yandex.net [IPv6:2a02:6b8:c41:1300:1:45:d181:d100])
	by forward204d.mail.yandex.net (Yandex) with ESMTPS id 2BFDF84A21
	for <ocfs2-devel@lists.linux.dev>; Thu, 30 Oct 2025 18:30:54 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-88.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-88.klg.yp-c.yandex.net [IPv6:2a02:6b8:c43:84a0:0:640:dfd2:0])
	by forward100d.mail.yandex.net (Yandex) with ESMTPS id 2163DC0081;
	Thu, 30 Oct 2025 18:30:46 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-88.klg.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id iUho7MELQiE0-uC3fdxiU;
	Thu, 30 Oct 2025 18:30:45 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1761838245; bh=k2vGnw35aAr+Y3o6tKRDBjOFK4MGtg06zJNFxYGwwww=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=ZtNG4ExNG9m0B29FogAsRQPtbE4BiF7jYTaIZRz7A7lQFUdrRtnvhvQhAbFjOoo1O
	 euCDmqch3Hbjm9n0I1/e5cLX+ZiYzj5w9X7RvSKsmAS6DEo+d4vH5vY3AR7oltgJ1Q
	 I2d4ziT3yXx7yk2plJwc5x4OYMajN07Ait87jbjo=
Authentication-Results: mail-nwsmtp-smtp-production-main-88.klg.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Heming Zhao <heming.zhao@suse.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+77026564530dbc29b854@syzkaller.appspotmail.com,
	syzbot+5054473a31f78f735416@syzkaller.appspotmail.com
Subject: [PATCH v2 1/2] ocfs2: add extra consistency checks for chain allocator dinodes
Date: Thu, 30 Oct 2025 18:30:02 +0300
Message-ID: <20251030153003.1934585-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When validating chain allocator dinode in 'ocfs2_validate_inode_block()',
add an extra checks whether a) the maximum amount of chain records in
'struct ocfs2_chain_list' matches the value calculated based on the
filesystem block size, and b) the next free slot index is within the
valid range.

Reported-by: syzbot+77026564530dbc29b854@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=77026564530dbc29b854
Reported-by: syzbot+5054473a31f78f735416@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5054473a31f78f735416
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
v2: unchanged since v1
---
 fs/ocfs2/inode.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index fcc89856ab95..1b6bdd9d7755 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1503,6 +1503,23 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if (le32_to_cpu(di->i_flags) & OCFS2_CHAIN_FL) {
+		struct ocfs2_chain_list *cl = &di->id2.i_chain;
+
+		if (le16_to_cpu(cl->cl_count) != ocfs2_chain_recs_per_inode(sb)) {
+			rc = ocfs2_error(sb, "Invalid dinode %llu: chain list count %u\n",
+					 (unsigned long long)bh->b_blocknr,
+					 le16_to_cpu(cl->cl_count));
+			goto bail;
+		}
+		if (le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count)) {
+			rc = ocfs2_error(sb, "Invalid dinode %llu: chain list index %u\n",
+					 (unsigned long long)bh->b_blocknr,
+					 le16_to_cpu(cl->cl_next_free_rec));
+			goto bail;
+		}
+	}
+
 	rc = 0;
 
 bail:
-- 
2.51.0

