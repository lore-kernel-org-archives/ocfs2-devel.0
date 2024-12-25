Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892BD2B9A6
	for <ocfs2-devel@lists.linux.dev>; Wed, 25 Dec 2024 16:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735145243; cv=none; b=KvDM1OU5nWQfyh9IHMm4MCj1q7h2hOXVczcR007HrpsrbG7R2ErN11CJTOEjO1OFWY8XzvdYNIXDIpm531taEVKpTztBvqknq1qzSdzNnhOmbpAFLT/qKnyhrVn9GOQmTm9kq0Cx1gvD7nl0BbO6G12MgYphliJaTBZIQxwlrcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735145243; c=relaxed/simple;
	bh=8bSQm0xu+t+Ov8KXN5K+bFLkrl/q1aqItHT+7lkLk0I=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=coLAYTsY/MMcKNYNU/6AAgcoeVsASpVdCic/R5LcjlO69lpzIrbrKJTAPN9JHlxIU7UGjaMmDj0q/i4KLt+9Yrlzj9kPFQZUB9tWHaDfbWN8cz5cpB37ztBYDX6z5Ce8KvVCy35LcTWj7V3qMwyjkk8lSBxC3wtKuJmCl01AMl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-844d02766ebso510281539f.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 25 Dec 2024 08:47:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735145240; x=1735750040;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S4SP9JXk0dQksw7X6Hq/OUmQSsPgd0GQ22mOGrKU8oc=;
        b=wz12pDn5aaYHLFnkQWig3jMziUSwf52QxGp0oevvheeRa3ah+xOJSLlMeeKtSUZ0Zo
         ldU3w18+TfSz3nOidc7basABBhVh26rscayOqCELNbG+9c5kVJ4TwFCkCi/g3rMdTdWd
         xKkcv3+nu0BNHZ2yvWcf0ZyX4VvKh6wB2GdER8VA3nkgAvR2gU0me0Vk3FGB5w0YfUrR
         SbTYint//G4dg2KEXuugq5QsIqxEtXUC7hkDYN23G1oUfsCu8MKtvD+jJ4GnNQM7+Igt
         IUlxzJgsJyMi7BcLOHN0uzsUC8ngPsRkTimtVEibo4o2Bt6fdd4ptdmbDu4nECPrQtqu
         W1nA==
X-Forwarded-Encrypted: i=1; AJvYcCWaQrFrK1YKz+veoRzTarIRJTc3C7n6sSYej2RGJuYbb4G3k1y+XjuVZd0jvKAv4nbui540ky9WbAmGyQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyKlJe6mAZHrWeWdS/qlE+7PM+ZVmQ4nD14SKq6DM0BJrCS4IWA
	yPx25ZFzjnBR6W3u/Dd9cr4gKAUyQ13cyk8MbdiiHeOJjEvFZHz6lWNJg0k6nW4byBvFYsGLN0p
	bsnjdtdhMal9dEVRB7WmyjbJYVpmEzDW1Z/pxOj30wJGV2yQIdxW/+to=
X-Google-Smtp-Source: AGHT+IGdUUV8ZD5ajzvmLJ/iwPBLSihI8uhnVGilyp0311eSQ3YbY9Xtqx45ge3hOndOsSkHGyGsOke2h5Jly+pjiGqnyLWxbWK+
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3a10:b0:3a7:e0c0:5f0d with SMTP id
 e9e14a558f8ab-3c2d1b9b8c6mr207153255ab.3.1735145240709; Wed, 25 Dec 2024
 08:47:20 -0800 (PST)
Date: Wed, 25 Dec 2024 08:47:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <676c3718.050a0220.2f3838.037f.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_set_new_buffer_uptodate (2)
From: syzbot <syzbot+7aef76bdb53b83d62a9e@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    499551201b5f Merge tag 'arm64-fixes' of git://git.kernel.o..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=13a76f30580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6a2b862bf4a5409f
dashboard link: https://syzkaller.appspot.com/bug?extid=7aef76bdb53b83d62a9e
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17483cf8580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17a76f30580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/12df04796e30/disk-49955120.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/48be851df472/vmlinux-49955120.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ca727608fc80/bzImage-49955120.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/afa847f269d7/mount_0.gz

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14de1fe8580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16de1fe8580000
console output: https://syzkaller.appspot.com/x/log.txt?x=12de1fe8580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7aef76bdb53b83d62a9e@syzkaller.appspotmail.com

ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
------------[ cut here ]------------
kernel BUG at fs/ocfs2/uptodate.c:509!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5831 Comm: syz-executor214 Not tainted 6.13.0-rc3-syzkaller-00209-g499551201b5f #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:ocfs2_set_new_buffer_uptodate+0x145/0x160 fs/ocfs2/uptodate.c:509
Code: 03 42 80 3c 20 00 74 08 48 89 df e8 75 af 63 fe 4c 8b 1b 4c 89 ff 5b 41 5c 41 5d 41 5e 41 5f e9 31 6c 29 08 e8 7c 4e fd fd 90 <0f> 0b e8 74 4e fd fd 90 0f 0b e8 6c 4e fd fd 90 0f 0b e8 64 4e fd
RSP: 0018:ffffc900033cfa30 EFLAGS: 00010293
RAX: ffffffff83a22574 RBX: 0000000000000001 RCX: ffff888034a03c00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffc900033cfcf0 R08: ffffffff83a2245e R09: 1ffffffff2032fae
R10: dffffc0000000000 R11: fffffbfff2032faf R12: ffff8880754fcfb8
R13: dffffc0000000000 R14: ffff88807b765570 R15: ffff8880754f8830
FS:  0000555565eff380(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000066c7e0 CR3: 0000000033ee0000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 ocfs2_group_add+0x3a3/0x15a0 fs/ocfs2/resize.c:507
 ocfs2_ioctl+0x65e/0x7d0 fs/ocfs2/ioctl.c:891
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:906 [inline]
 __se_sys_ioctl+0xf7/0x170 fs/ioctl.c:892
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0b996cd6f9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 61 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffcd6119cf8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0031656c69662f2e RCX: 00007f0b996cd6f9
RDX: 00000000200000c0 RSI: 0000000040186f02 RDI: 0000000000000004
RBP: 00007f0b99744610 R08: 0000000000000000 R09: 00007ffcd6119ec8
R10: 00007f0b99708ab3 R11: 0000000000000246 R12: 0000000000000001
R13: 00007ffcd6119eb8 R14: 0000000000000001 R15: 0000000000000001
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_set_new_buffer_uptodate+0x145/0x160 fs/ocfs2/uptodate.c:509
Code: 03 42 80 3c 20 00 74 08 48 89 df e8 75 af 63 fe 4c 8b 1b 4c 89 ff 5b 41 5c 41 5d 41 5e 41 5f e9 31 6c 29 08 e8 7c 4e fd fd 90 <0f> 0b e8 74 4e fd fd 90 0f 0b e8 6c 4e fd fd 90 0f 0b e8 64 4e fd
RSP: 0018:ffffc900033cfa30 EFLAGS: 00010293
RAX: ffffffff83a22574 RBX: 0000000000000001 RCX: ffff888034a03c00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffc900033cfcf0 R08: ffffffff83a2245e R09: 1ffffffff2032fae
R10: dffffc0000000000 R11: fffffbfff2032faf R12: ffff8880754fcfb8
R13: dffffc0000000000 R14: ffff88807b765570 R15: ffff8880754f8830
FS:  0000555565eff380(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000066c7e0 CR3: 0000000033ee0000 CR4: 0000000000350ef0


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
