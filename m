Received: from forward101a.mail.yandex.net (forward101a.mail.yandex.net [178.154.239.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155092EDD52
	for <ocfs2-devel@lists.linux.dev>; Wed, 29 Oct 2025 05:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761717241; cv=none; b=Wl+pfKvYzBNW+eHzZCcoj0bEb0/TTeUAnRNgLc/ZC/GfkwxSt9Wq6DRAH6yiERdqtDsZrDRTRH5fIlq6vkgnFgpkBui+2UK3CtMUwOs4/0S+pnWKx9FAlyahGi1x676WVigHtczmlvP3AOao41hGqel2MeDWgoPi70MvWFNjDOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761717241; c=relaxed/simple;
	bh=bAIwf701GL2sy3oqN3P1wf/OoPeHqmUaj9FoyJErBqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=syvCeiVhNnoxzL6/EZFrQDzXQq+P+FdA3IaoRAaZDq9+4syvN8d+aixvUcMQWOrs3661H9F70GNytys8xTW1nceREb0oDuAbL3LCtmdKU4TvKJMh5VnG3UkKccomkuu3ktXGZI8KlLjNC0KZBfakTLs2MJqfhl2cX6ym8Wp0YYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=nX6kZBP8; arc=none smtp.client-ip=178.154.239.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="nX6kZBP8"
Received: from mail-nwsmtp-smtp-production-main-81.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-81.vla.yp-c.yandex.net [IPv6:2a02:6b8:c0f:571a:0:640:23e3:0])
	by forward101a.mail.yandex.net (Yandex) with ESMTPS id 8ADAC80C8F;
	Wed, 29 Oct 2025 08:53:48 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-81.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id krWxHjNLw4Y0-18tIBZfY;
	Wed, 29 Oct 2025 08:53:47 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1761717227; bh=A2jtHe4zZnguCLY9Ysaz4kLhmcprUm4Y2tdIRSyTwm8=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=nX6kZBP8lObM42elAewg+i52MCWT0TaRk12kq5DMMeWqktZVs7dSckpA5oWtmIdNm
	 U10s5IgpQN89QVHFvzXfEuJo08FB53RqZRUA8R8ATHkia7g4ESYBwmcAbmclKqfgXC
	 KjyOrjO0u3VXUsR1DqKjF6iGimIDlbC5LPNUrYec=
Authentication-Results: mail-nwsmtp-smtp-production-main-81.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
	Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	lvc-project@linuxtesting.org,
	syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH 2/2] ocfs2: validate cl_bpc in allocator inodes to prevent divide-by-zero
Date: Wed, 29 Oct 2025 08:53:38 +0300
Message-ID: <20251029055338.1192000-2-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251029055338.1192000-1-dmantipov@yandex.ru>
References: <9461385f-235d-40fc-8da6-b1f2dfb47d6c@linux.alibaba.com>
 <20251029055338.1192000-1-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Deepanshu Kartikey <kartikey406@gmail.com>

The chain allocator field cl_bpc (blocks per cluster) is read from disk
and used in division operations without validation. A corrupted filesystem
image with cl_bpc=0 causes a divide-by-zero crash in the kernel:

  divide error: 0000 [#1] PREEMPT SMP KASAN
  RIP: 0010:ocfs2_bg_discontig_add_extent fs/ocfs2/suballoc.c:335 [inline]
  RIP: 0010:ocfs2_block_group_fill+0x5bd/0xa70 fs/ocfs2/suballoc.c:386
  Call Trace:
   ocfs2_block_group_alloc+0x7e9/0x1330 fs/ocfs2/suballoc.c:703
   ocfs2_reserve_suballoc_bits+0x20a6/0x4640 fs/ocfs2/suballoc.c:834
   ocfs2_reserve_new_inode+0x4f4/0xcc0 fs/ocfs2/suballoc.c:1074
   ocfs2_mknod+0x83c/0x2050 fs/ocfs2/namei.c:306

This patch adds validation in ocfs2_validate_inode_block() to ensure cl_bpc
matches the expected value calculated from the superblock's cluster size
and block size for chain allocator inodes (identified by OCFS2_CHAIN_FL).

Moving the validation to inode validation time (rather than allocation time)
has several benefits:
- Validates once when the inode is read, rather than on every allocation
- Protects all code paths that use cl_bpc (allocation, resize, etc.)
- Follows the existing pattern of inode validation in OCFS2
- Centralizes validation logic

The validation catches both:
- Zero values that cause divide-by-zero crashes
- Non-zero but incorrect values indicating filesystem corruption or
  mismatched filesystem geometry

With this fix, mounting a corrupted filesystem produces:

  OCFS2: ERROR (device loop0): ocfs2_validate_inode_block: Inode 74
         has corrupted cl_bpc: ondisk=0 expected=16

instead of a kernel crash.

Link: https://lore.kernel.org/ocfs2-devel/20251026132625.12348-1-kartikey406@gmail.com/T/#u [v1]
Link: https://lore.kernel.org/all/20251027124131.10002-1-kartikey406@gmail.com/T/ [v2]
Reported-by: syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=fd8af97c7227fe605d95
Tested-by: syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
[dmantipov: combine into the series and tweak
 the message to fit the commonly used style]
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/ocfs2/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 1b6bdd9d7755..efb930da0920 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1505,6 +1505,8 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 
 	if (le32_to_cpu(di->i_flags) & OCFS2_CHAIN_FL) {
 		struct ocfs2_chain_list *cl = &di->id2.i_chain;
+		u16 bpc = 1 << (OCFS2_SB(sb)->s_clustersize_bits -
+				sb->s_blocksize_bits);
 
 		if (le16_to_cpu(cl->cl_count) != ocfs2_chain_recs_per_inode(sb)) {
 			rc = ocfs2_error(sb, "Invalid dinode %llu: chain list count %u\n",
@@ -1518,6 +1520,12 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 					 le16_to_cpu(cl->cl_next_free_rec));
 			goto bail;
 		}
+		if (le16_to_cpu(cl->cl_bpc) != bpc) {
+			rc = ocfs2_error(sb, "Invalid dinode %llu: bits per cluster %u\n",
+					 (unsigned long long)bh->b_blocknr,
+					 le16_to_cpu(cl->cl_bpc));
+			goto bail;
+		}
 	}
 
 	rc = 0;
-- 
2.51.0

