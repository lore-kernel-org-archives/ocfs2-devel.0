Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D18A2C190
	for <ocfs2-devel@lists.linux.dev>; Sat,  6 Dec 2025 12:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765025524; cv=none; b=Z/SD86WEbCMYNg8wyvRqVft2UhuvXetl/u83j1qVj4urbyuif0LL7qYKhGc6BFiRiWf/pQ3aaebv0XDwQP7Bb4mAQn+tQy8y6Z44zWAsF5sv6F3sbRnhVOet95F3OivRac5yuPd9o7wST/Dd4Cc+YiPWYtI3Z0rQ1TTetJaHxFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765025524; c=relaxed/simple;
	bh=vhU5Q86BjklQWfsyGMKkGHdy9ppWh/5ecLHLE6yZQDc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=PP4ztJ5cf8EAALPb4tHd+Pnw940MhmTLuGl0JP1Bl8RJMaXppt2OSC68k7Y10jk6JKoJ7DM6yA9j3IkNnQrDz4Jql8j3xFNwISaLkpEKJY1soi+gW37OqBoLOSIkRb+qtwehoJIMzIUGjiCSFHfy5svZDE9wXg4HGiN9bSF8HSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-65747d01bb0so4465897eaf.0
        for <ocfs2-devel@lists.linux.dev>; Sat, 06 Dec 2025 04:52:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765025522; x=1765630322;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SLZ/dqQWYMUXCDHcmr0W7APt4Gliz5H3pRLjGITzJMI=;
        b=mEnanYACKbhDrdCQchV7ClzV+jqNMctTfpyMGvYw+GObp5cdIDxY9tI5Z2PRkppUcm
         amI3Ao9cWiYMKF865/PnNvtMTreAlolSe+ZYlgvfKqU7uTahesfvRF0ZidfCPrebuiss
         DRWiSq509Mj0SFXCW/Ah3jK7Y7RpnQFGG2dZIWs+qnlV9wTRGAKckILOPKf4HJoatwjP
         yyz7fACZFofpgURBKTuvpNVRi1zNeIFNOM+cnumJiVtTob7yHbU5PpdA7/7uCjpX2D3B
         JKGQJVWryGWDM+FUKWJW5Kpu3Zm0EDlro5ozUL4Bgg/WF5L9F+TrHnL1Ee+sjwcoeeYw
         I/UA==
X-Forwarded-Encrypted: i=1; AJvYcCXf7HSqDE4zdvK53E6bQOJdX7SxVomjLjf3thD4dazy01NTwbJO94hn8+oy797DvkyLh5S+9AxhCprMxA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwSplleEhUSbietSA/Sy3imH2i47dT1+H4uPO9akQFLIXcd2QOm
	sLgNekgDJvgwiaZPJrzqU2ygb+4s5eoTZG69PG/YciXwEpPtRpV5ntpRmjvQ3P9oNsoaFAdID+C
	elLRJNhTg9IEsK41mDgsRNHMvTJMrMe0MzfrPqMnRfEijC5FyF/2yHvPkg3U=
X-Google-Smtp-Source: AGHT+IH01AQwWZ0p7qcuuq97G+zPz+2OXtMQ9uoDtTYNQiFb+IpJwiaYpdzwjb5j8eymdZJs/ztPKK+iopxt4TXUCeE1eIOrOU+b
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:edcb:0:b0:659:9a49:8e8e with SMTP id
 006d021491bc7-6599a8c0c00mr918519eaf.18.1765025522495; Sat, 06 Dec 2025
 04:52:02 -0800 (PST)
Date: Sat, 06 Dec 2025 04:52:02 -0800
In-Reply-To: <20251206123128.166117-1-activprithvi@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <693426f2.a70a0220.38f243.0029.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] kernel BUG in ocfs2_write_block
From: syzbot <syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com>
To: activprithvi@gmail.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
kernel BUG in ocfs2_write_block

WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
On-disk corruption discovered. Please run fsck.ocfs2 once the filesystem is unmounted.
OCFS2: File system is now read-only.
------------[ cut here ]------------
kernel BUG at fs/ocfs2/buffer_head_io.c:45!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 6601 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:ocfs2_write_block+0x5d2/0x640 fs/ocfs2/buffer_head_io.c:45
Code: 00 00 fc ff df 80 3c 08 00 74 08 4c 89 ff e8 45 37 8b fe 49 8b 3f 4c 89 ee 48 8b 14 24 e8 36 88 0f 00 eb 1f e8 8f 78 29 fe 90 <0f> 0b e8 87 78 29 fe 90 0f 0b e8 7f 78 29 fe e9 ce fa ff ff e8 75
RSP: 0018:ffffc90004e4ee20 EFLAGS: 00010293
RAX: ffffffff839534d1 RBX: 1ffff1100444ea03 RCX: ffff888024ae8000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90004e4eef0 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: fffffbfff1dac76f R12: 0000000000000000
R13: dffffc0000000000 R14: ffff888022275000 R15: 0000000000000001
FS:  00007fbd0a5066c0(0000) GS:ffff888126df7000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fbd0ae829e0 CR3: 0000000020b78000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 ocfs2_update_disk_slot+0x6f8/0x9d0 fs/ocfs2/slot_map.c:207
 ocfs2_find_slot+0x6bb/0xc30 fs/ocfs2/slot_map.c:492
 ocfs2_mount_volume fs/ocfs2/super.c:1749 [inline]
 ocfs2_fill_super+0x3833/0x65f0 fs/ocfs2/super.c:1083
 get_tree_bdev_flags+0x40e/0x4d0 fs/super.c:1691
 vfs_get_tree+0x92/0x2b0 fs/super.c:1751
 fc_mount fs/namespace.c:1208 [inline]
 do_new_mount_fc fs/namespace.c:3651 [inline]
 do_new_mount+0x302/0xa10 fs/namespace.c:3727
 do_mount fs/namespace.c:4050 [inline]
 __do_sys_mount fs/namespace.c:4238 [inline]
 __se_sys_mount+0x313/0x410 fs/namespace.c:4215
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fbd0aea0e6a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fbd0a505e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fbd0a505ef0 RCX: 00007fbd0aea0e6a
RDX: 0000200000004440 RSI: 0000200000000040 RDI: 00007fbd0a505eb0
RBP: 0000200000004440 R08: 00007fbd0a505ef0 R09: 00000000000008c0
R10: 00000000000008c0 R11: 0000000000000246 R12: 0000200000000040
R13: 00007fbd0a505eb0 R14: 0000000000004440 R15: 0000200000000280
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_write_block+0x5d2/0x640 fs/ocfs2/buffer_head_io.c:45
Code: 00 00 fc ff df 80 3c 08 00 74 08 4c 89 ff e8 45 37 8b fe 49 8b 3f 4c 89 ee 48 8b 14 24 e8 36 88 0f 00 eb 1f e8 8f 78 29 fe 90 <0f> 0b e8 87 78 29 fe 90 0f 0b e8 7f 78 29 fe e9 ce fa ff ff e8 75
RSP: 0018:ffffc90004e4ee20 EFLAGS: 00010293
RAX: ffffffff839534d1 RBX: 1ffff1100444ea03 RCX: ffff888024ae8000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90004e4eef0 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: fffffbfff1dac76f R12: 0000000000000000
R13: dffffc0000000000 R14: ffff888022275000 R15: 0000000000000001
FS:  00007fbd0a5066c0(0000) GS:ffff888126df7000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fbd0ae829e0 CR3: 0000000020b78000 CR4: 00000000003526f0


Tested on:

commit:         24172e0d Merge tag 'arm64-fixes' of git://git.kernel.o..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=11510eb4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=41ad820f608cb833
dashboard link: https://syzkaller.appspot.com/bug?extid=c818e5c4559444f88aa0
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=13d2421a580000

