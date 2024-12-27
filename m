Received: from forward202a.mail.yandex.net (forward202a.mail.yandex.net [178.154.239.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EB61F2388
	for <ocfs2-devel@lists.linux.dev>; Fri, 27 Dec 2024 13:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735305251; cv=none; b=IIQlzG0aZBPh8HAAcKcx8Bq1lIEu6kGBjSjm9+wuyupvH4/ZPJ/mlijUQ+45cWepn5Vq8/SkeTAbahgohweakZ30ydREoYotHcWbNvhZLYmqzyoTuKUULVAHWTDUDQfi3B1Bg/0bIu2E/e3lE/7lyhnVaAdDwGHPV9RhlrmPFqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735305251; c=relaxed/simple;
	bh=PLivuT/0OpqumKIKYYRJ1FrzpyVRANwEpIA8H1kAZSM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MiVDD61R9ZZMxVEtxFc3PL3J9LF7uBtwzDyQuhTaUoet3HQ2BnF7LPoni7QcYaRnu72UwfH7s81zH7eSAQ4Bf0gCZbr2vTgQzkPMOmFpw8DmT5oYzQWyo555sXg1IlGhBYGeU5cYNmEBbV2TI6mwDoTDBMm33+Df8VINkalSr/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=B7tvQrSy; arc=none smtp.client-ip=178.154.239.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="B7tvQrSy"
Received: from forward100a.mail.yandex.net (forward100a.mail.yandex.net [IPv6:2a02:6b8:c0e:500:1:45:d181:d100])
	by forward202a.mail.yandex.net (Yandex) with ESMTPS id DAC8E6C126
	for <ocfs2-devel@lists.linux.dev>; Fri, 27 Dec 2024 16:07:30 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-51.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-51.vla.yp-c.yandex.net [IPv6:2a02:6b8:c0f:2f03:0:640:5d54:0])
	by forward100a.mail.yandex.net (Yandex) with ESMTPS id B860A47378;
	Fri, 27 Dec 2024 16:07:22 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-51.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id K7a5Jn1Oh4Y0-JpeGc0CY;
	Fri, 27 Dec 2024 16:07:22 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1735304842; bh=epSVHIpHY4DN48qIkvaz0tT+/V2jAg06XsJF2p2aoC4=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=B7tvQrSyp2etzUcTkMmLoXOpCDRo2z33XfXqTlRQ+v5faap/gjFm9m3c4PRKjZvUv
	 QtjQaNH89/vKA2TaoW63bSTzdngL1GAxUp3Elba36oNNi57n5EUamF0E+mLz2opOFg
	 eoX9PVgVG1eeqNRba/M2wFiJY6+KnquQy7Nyd43U=
Authentication-Results: mail-nwsmtp-smtp-production-main-51.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+7aef76bdb53b83d62a9e@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: uncache inode after ocfs2_search_dirblock() search failure
Date: Fri, 27 Dec 2024 16:07:17 +0300
Message-ID: <20241227130717.144988-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.47.1
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
 ? __die_body+0x61/0xb0
 ? die+0x9f/0xc0
 ? do_trap+0x14a/0x3d0
 ? ocfs2_set_new_buffer_uptodate+0x149/0x170
 ? do_error_trap+0x1c2/0x280
 ? ocfs2_set_new_buffer_uptodate+0x149/0x170
 ? __pfx_do_error_trap+0x10/0x10
 ? handle_invalid_op+0x34/0x40
 ? ocfs2_set_new_buffer_uptodate+0x149/0x170
 ? exc_invalid_op+0x39/0x50
 ? asm_exc_invalid_op+0x1a/0x20
 ? ocfs2_set_new_buffer_uptodate+0x148/0x170
 ? ocfs2_set_new_buffer_uptodate+0x149/0x170
 ? ocfs2_set_new_buffer_uptodate+0x148/0x170
 ocfs2_group_add+0x318/0x1240
 ? mnt_get_write_access+0x68/0x2a0
 ? __pfx_ocfs2_group_add+0x10/0x10
 ? mnt_get_write_access+0x68/0x2a0
 ? __pfx_lock_release+0x10/0x10
 ? rcu_read_lock_any_held+0xb4/0x130
 ? __pfx_rcu_read_lock_any_held+0x10/0x10
 ? __pfx_lock_release+0x10/0x10
 ? mnt_get_write_access+0x223/0x2a0
 ? mnt_want_write_file+0x172/0x200
 ocfs2_ioctl+0x60b/0x750
 ? __pfx_ocfs2_ioctl+0x10/0x10
 ? lockdep_hardirqs_on_prepare+0x401/0x750
 ? bpf_lsm_file_ioctl+0x9/0x20
 ? __pfx_ocfs2_ioctl+0x10/0x10
 __se_sys_ioctl+0xfc/0x170
 do_syscall_64+0xf6/0x210
 ? exc_page_fault+0x92/0x110
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 ...
 </TASK>

In 'ocfs2_find_entry_id()', the buffer head remains cached (by
'ocfs2_read_blocks()') regardless of the search result returned
by 'ocfs2_search_dirblock()'. In case of search failure, that
buffer head is no longer used and should be uncached before
calling 'brelse()'. This is very similar to commit 737f34137844
("ocfs2: uncache inode which has failed entering the group").

Reported-by: syzbot+7aef76bdb53b83d62a9e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7aef76bdb53b83d62a9e
Fixes: 23193e513d1c ("ocfs2: Read support for directories with inline data")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/ocfs2/dir.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 213206ebdd58..3bfbc166d1fe 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -416,6 +416,9 @@ static struct buffer_head *ocfs2_find_entry_id(const char *name,
 	if (found == 1)
 		return di_bh;
 
+	/* Cached by ocfs2_read_blocks() so remove it. */
+	ocfs2_remove_from_cache(INODE_CACHE(dir), di_bh);
+
 	brelse(di_bh);
 out:
 	return NULL;
-- 
2.47.1

