Received: from forward204a.mail.yandex.net (forward204a.mail.yandex.net [178.154.239.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694DA29BDB3
	for <ocfs2-devel@lists.linux.dev>; Thu, 11 Dec 2025 16:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765469169; cv=none; b=qI+kGb+TGpojkYZUFQLdRMWcH6zCpIUdIff23Nzc8I+nYDiSsTuwbOU14yTjjbgeJLilqoXUSZgS8tpNykfVKdq3bTsrgO6lgNpYvUkpOvEVb7Ur+fo5v5qY90D5eMCUBVD1i00tu2ZJYAXbsQKcgZhhSR2ZV+mdMfTr4E5cbBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765469169; c=relaxed/simple;
	bh=5Ntqsmrij1YT/jxqajOwvpg+GBv9jX9iHqgR8ZefHfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mmwdRQwMpkWpSU91ELE1x1mbOGT1EUcwULGgFysPdYDHidzbey7QBZy3fNv+n1uzGw0SJWE2HT51HMTYl4dTZN52ifqgqLz0q7yoj64SqJrIgg99bYX0hww1q9dXQmzb9PFxdqx/ZplrmmLeaq6Mukw1a7bH4cq14uiIfb7vb+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=KE9utm5x; arc=none smtp.client-ip=178.154.239.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="KE9utm5x"
Received: from forward101a.mail.yandex.net (forward101a.mail.yandex.net [IPv6:2a02:6b8:c0e:500:1:45:d181:d101])
	by forward204a.mail.yandex.net (Yandex) with ESMTPS id 99A9F81098
	for <ocfs2-devel@lists.linux.dev>; Thu, 11 Dec 2025 19:00:03 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-55.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-55.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:582e:0:640:200:0])
	by forward101a.mail.yandex.net (Yandex) with ESMTPS id 4AB6980C2B;
	Thu, 11 Dec 2025 18:59:53 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-55.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id pxRn58cMquQ0-RWzPvMiA;
	Thu, 11 Dec 2025 18:59:52 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1765468792; bh=ODGNk5B/1d9fP8n3xsxJ3scKm8TMJ1N3OP1RUlloI6M=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=KE9utm5xlrGGxQI/0ZINFJYZmIwfk34csOkmI9TQm7a+wIemAHZ1dqHqfV8p6n4Op
	 xr0dZHXqIaEkcaMIRfP3bSbsobhj4kAZ+IgAMbASNDI7tAOZv99U6l4+A7el1UOOjb
	 s8M1uSUsRAWQAfjaBsnu3DaviNSCViOe5JnhwC6E=
Authentication-Results: mail-nwsmtp-smtp-production-main-55.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	ocfs2-devel@lists.linux.dev,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+cf96bc82a588a27346a8@syzkaller.appspotmail.com
Subject: [PATCH v2] ocfs2: adjust ocfs2_xa_remove_entry() to match UBSAN boundary checks
Date: Thu, 11 Dec 2025 18:59:49 +0300
Message-ID: <20251211155949.774485-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <lhnx6meceuvndkxjpxaapwkiqvlp6recho77b4yjirznjn62jr@fu5gq2gsg2yu>
References: <lhnx6meceuvndkxjpxaapwkiqvlp6recho77b4yjirznjn62jr@fu5gq2gsg2yu>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After introducing 2f26f58df041 ("ocfs2: annotate flexible array members
with __counted_by_le()"), syzbot has reported the following issue:

UBSAN: array-index-out-of-bounds in fs/ocfs2/xattr.c:1955:3
index 2 is out of range for type 'struct ocfs2_xattr_entry[]
__counted_by(xh_count)' (aka 'struct ocfs2_xattr_entry[]')
...
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 ubsan_epilogue+0xa/0x40 lib/ubsan.c:233
 __ubsan_handle_out_of_bounds+0xe9/0xf0 lib/ubsan.c:455
 ocfs2_xa_remove_entry+0x36d/0x3e0 fs/ocfs2/xattr.c:1955
 ...

To address this issue, 'xh_entries[]' member removal should be performed
before actually changing 'xh_count', thus making sure that all array
accesses matches the boundary checks performed by UBSAN.

Reported-by: syzbot+cf96bc82a588a27346a8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cf96bc82a588a27346a8
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
v2: adjust commit metadata per Heming's notices
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

