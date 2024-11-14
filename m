Received: from forward100d.mail.yandex.net (forward100d.mail.yandex.net [178.154.239.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7397346BF
	for <ocfs2-devel@lists.linux.dev>; Thu, 14 Nov 2024 04:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731559156; cv=none; b=Pm4xT3KC70Wv7m79eBT9lc0zbzYK6ABnzOAY+0QHdNgXFqn9bmGFP5PjG0GoJlPykopMjYf30kD7qEByFr2V6iK4L3qZDBT/g6nYMps9K27Uuvb+Gk5W5DYxYZpLwiLJci7oLYikgF9hVewN0NYZg0ulyUZPPnakaQixUmSfxqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731559156; c=relaxed/simple;
	bh=yF5klxCfMAWZbW/ekeWy+BENsCiSnblO6fJEbf1XnjY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=byst80H1DhAHZwFLJA7rws2V9HFHGUkcc4zy1qZXbGy04TBGt8aGKeP9b/EFe/c67/5coEpUi04nzGXLNE9G8Aqw+vumeko0IKi8ekz1iqKcwbFfM/ruf5rpe5YPgJsevICEtn7t/0ujaC432A+HMdVzBRIEgqrNj7rcIjsX/S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=gxRQ2rWX; arc=none smtp.client-ip=178.154.239.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="gxRQ2rWX"
Received: from mail-nwsmtp-smtp-production-main-42.myt.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-42.myt.yp-c.yandex.net [IPv6:2a02:6b8:c12:1320:0:640:729a:0])
	by forward100d.mail.yandex.net (Yandex) with ESMTPS id 71D7C609C2;
	Thu, 14 Nov 2024 07:39:03 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-42.myt.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id 1dDif1QOr0U0-HhEJDhnw;
	Thu, 14 Nov 2024 07:39:02 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1731559142; bh=B2Pefr84L3Rnlg3nmBNUusAhFtcFDYnLwV7zE1fjd54=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=gxRQ2rWXRNr5DyQV9TCtlst5ThbhGUSY7EsI6usrOaNSXFlYcGMdgaSj0jsrKTS4G
	 bLg/9IRCUh+Ht0NWsXpf3vA1M7kQESrrXlcJZmAtgM/jbDMVL6NTp5rjiJm1rO3t6G
	 nA63nZmqqG6M8vF7IIiyU8b+96bIKbLPk0SMGGbY=
Authentication-Results: mail-nwsmtp-smtp-production-main-42.myt.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+453873f1588c2d75b447@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: uncache inode which has failed entering the group
Date: Thu, 14 Nov 2024 07:38:44 +0300
Message-ID: <20241114043844.111847-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzbot has reported the following BUG:

kernel BUG at fs/ocfs2/uptodate.c:509!
...
Call Trace:
 <TASK>
 ? __die_body+0x5f/0xb0
 ? die+0x9e/0xc0
 ? do_trap+0x15a/0x3a0
 ? ocfs2_set_new_buffer_uptodate+0x145/0x160
 ? do_error_trap+0x1dc/0x2c0
 ? ocfs2_set_new_buffer_uptodate+0x145/0x160
 ? __pfx_do_error_trap+0x10/0x10
 ? handle_invalid_op+0x34/0x40
 ? ocfs2_set_new_buffer_uptodate+0x145/0x160
 ? exc_invalid_op+0x38/0x50
 ? asm_exc_invalid_op+0x1a/0x20
 ? ocfs2_set_new_buffer_uptodate+0x2e/0x160
 ? ocfs2_set_new_buffer_uptodate+0x144/0x160
 ? ocfs2_set_new_buffer_uptodate+0x145/0x160
 ocfs2_group_add+0x39f/0x15a0
 ? __pfx_ocfs2_group_add+0x10/0x10
 ? __pfx_lock_acquire+0x10/0x10
 ? mnt_get_write_access+0x68/0x2b0
 ? __pfx_lock_release+0x10/0x10
 ? rcu_read_lock_any_held+0xb7/0x160
 ? __pfx_rcu_read_lock_any_held+0x10/0x10
 ? smack_log+0x123/0x540
 ? mnt_get_write_access+0x68/0x2b0
 ? mnt_get_write_access+0x68/0x2b0
 ? mnt_get_write_access+0x226/0x2b0
 ocfs2_ioctl+0x65e/0x7d0
 ? __pfx_ocfs2_ioctl+0x10/0x10
 ? smack_file_ioctl+0x29e/0x3a0
 ? __pfx_smack_file_ioctl+0x10/0x10
 ? lockdep_hardirqs_on_prepare+0x43d/0x780
 ? __pfx_lockdep_hardirqs_on_prepare+0x10/0x10
 ? __pfx_ocfs2_ioctl+0x10/0x10
 __se_sys_ioctl+0xfb/0x170
 do_syscall_64+0xf3/0x230
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
...
 </TASK>

When 'ioctl(OCFS2_IOC_GROUP_ADD, ...)' has failed for the particular
inode in 'ocfs2_verify_group_and_input()', corresponding buffer head
remains cached and subsequent call to the same 'ioctl()' for the same
inode issues the BUG() in 'ocfs2_set_new_buffer_uptodate()' (trying
to cache the same buffer head of that inode). Fix this by uncaching
the buffer head with 'ocfs2_remove_from_cache()' on error path in
'ocfs2_group_add()'.

Reported-by: syzbot+453873f1588c2d75b447@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=453873f1588c2d75b447
Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/ocfs2/resize.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index c4a4016d3866..b0733c08ed13 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -574,6 +574,8 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 	ocfs2_commit_trans(osb, handle);
 
 out_free_group_bh:
+	if (ret < 0)
+		ocfs2_remove_from_cache(INODE_CACHE(inode), group_bh);
 	brelse(group_bh);
 
 out_unlock:
-- 
2.47.0

