Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CF020322
	for <ocfs2-devel@lists.linux.dev>; Tue,  7 Oct 2025 03:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759809333; cv=none; b=gda3+ihftV0FlpZ/hU91okOoFWo5aZEaS9jqQBABToHp7qNauWzN4Pwmv8ZnjZ8YwssyaAWPwqZY0mgaWrBVmspR8Xu9w19uokwslNdUhxItUNZ9RNNxzOy3/6JrhQdfON0rgZeZ5Udiia6p6R+zwM4IXDh5rnrPvqPtPoy1peM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759809333; c=relaxed/simple;
	bh=r6KU3UA7XOv6EJeOIp+g0o8Vscx9ypTrEEVxiFrzMrQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=iOtRMSynZAo9cGu/xvYGQMQvZ9YRkaZw2TPGvCXy3nDfkNUjDh8yWg98dfQ6bbywWuusM1upc1FTX0DM3ad4Vq/3tNfWa3ExmcPeQhZN3f4yZROs9IZy2epevk83Zoe7J3Sc2lhUhZ/i74y8kkr4UkZAlwC5fnyWifkvQ278N7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-925332ba890so1557944039f.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 06 Oct 2025 20:55:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759809331; x=1760414131;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cXe/si0AdIFfWRGG0Lyp1Myvzf+B3lva4QTre8L89+Q=;
        b=nNyI0vjSBZO/L1ipbxx8LY3ReOIdDw1P6+X0NCVyISECWB0xZHpeiJcrzq29jnPuhW
         aHoiyP6dJIVuVpmP38wiM0YtK+JYNIf2kn9v5858MoNKWsVYVmUx6Cp/rcNb1uRenFPH
         NT+AtH2itnM+nK5YqhaWsXw6Z2ipxLFLEhWHDIdAvu5PSSZgJWV3WP3McxoZuUrzsizH
         6Sk525UCr2XNptmY+EB3tqaAQuUa2S2OLpFGxp1y9yoN+ydYCmYreT0QPLvR3sURYXZf
         OnmwZ8xjuslyuBuvj975D0BO1K0vX5I2wma3oGrki7OXAMCBlGapvS4A3PmwPrqan7/R
         BS0Q==
X-Forwarded-Encrypted: i=1; AJvYcCV/OxOOmnzgRG6xxqQkc896cR3CdyCnO0AMlKQ+lpOzewDP0vC4Pygz6+ahqlvTlXBuv+Q2zod6pZi6Kw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwAB1uDqB/Bi0IETFkIfouJ+YJHD2BRrNwquBkgeCP9jhaCosDW
	mdEOpg36xOAzV6z8iVxvNwdUZb1vXsuwDr/X0ugF2DJdZ0A9qWCN4jqv5CAMMuG3P4wjO9rxqiu
	WjYxbAYEi2QsRn6e2O1fTb3rJE3m5x+dxeH7xn+wsFVen6o96sGEYAL87rAA=
X-Google-Smtp-Source: AGHT+IGmHerphZMAS+CUcAorXHw9/E9e9vz/nLzhHxAmi8JMEfVfDNcNFEC6cSkUDqQrcyIMe+f2E9i7OriDblkLXxgzsWUMFCfq
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:15ca:b0:936:7fd5:b8be with SMTP id
 ca18e2360f4ac-93b96a9338fmr1920091239f.13.1759809331558; Mon, 06 Oct 2025
 20:55:31 -0700 (PDT)
Date: Mon, 06 Oct 2025 20:55:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68e48f33.a00a0220.298cc0.046e.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in __ocfs2_move_extent
From: syzbot <syzbot+727d161855d11d81e411@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    e406d57be7bd Merge tag 'mm-nonmm-stable-2025-10-02-15-29' ..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17739214580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=84e81c4d0c0e900a
dashboard link: https://syzkaller.appspot.com/bug?extid=727d161855d11d81e411
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15fc5334580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=156a9ee2580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-e406d57b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ed88be2e6138/vmlinux-e406d57b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/bdedb017e44c/bzImage-e406d57b.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/dc258190d4b3/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=17a54458580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+727d161855d11d81e411@syzkaller.appspotmail.com

         option from the mount to silence this warning.
=======================================================
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
------------[ cut here ]------------
kernel BUG at fs/ocfs2/move_extents.c:101!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5497 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__ocfs2_move_extent+0xccf/0xce0 fs/ocfs2/move_extents.c:101
Code: ff 44 89 e1 80 e1 07 80 c1 03 38 c1 0f 8c f0 fd ff ff 4c 89 e7 e8 01 d5 7b fe 48 8b 7c 24 08 e9 de fd ff ff e8 72 a9 14 fe 90 <0f> 0b 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90
RSP: 0018:ffffc9000cb4f320 EFLAGS: 00010293
RAX: ffffffff83a9e4ce RBX: 0000000000000000 RCX: ffff888000332480
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000002
RBP: ffffc9000cb4f488 R08: ffff888000332480 R09: 0000000000000006
R10: 00000000fffffffc R11: 0000000000000000 R12: 0000000000002550
R13: 0000000000000002 R14: dffffc0000000000 R15: 0000000000000000
FS:  000055556197a500(0000) GS:ffff88808d98a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000020000000b000 CR3: 00000000591c9000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 ocfs2_move_extent fs/ocfs2/move_extents.c:672 [inline]
 __ocfs2_move_extents_range+0x2116/0x3380 fs/ocfs2/move_extents.c:859
 ocfs2_move_extents+0x378/0x960 fs/ocfs2/move_extents.c:926
 ocfs2_ioctl_move_extents+0x53e/0x710 fs/ocfs2/move_extents.c:1052
 ocfs2_ioctl+0x191/0x750 fs/ocfs2/ioctl.c:942
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xf9/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f57bad8eec9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd42f1aff8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f57bafe5fa0 RCX: 00007f57bad8eec9
RDX: 00002000000000c0 RSI: 0000000040406f06 RDI: 0000000000000004
RBP: 00007f57bae11f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f57bafe5fa0 R14: 00007f57bafe5fa0 R15: 0000000000000003
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__ocfs2_move_extent+0xccf/0xce0 fs/ocfs2/move_extents.c:101
Code: ff 44 89 e1 80 e1 07 80 c1 03 38 c1 0f 8c f0 fd ff ff 4c 89 e7 e8 01 d5 7b fe 48 8b 7c 24 08 e9 de fd ff ff e8 72 a9 14 fe 90 <0f> 0b 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90
RSP: 0018:ffffc9000cb4f320 EFLAGS: 00010293
RAX: ffffffff83a9e4ce RBX: 0000000000000000 RCX: ffff888000332480
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000002
RBP: ffffc9000cb4f488 R08: ffff888000332480 R09: 0000000000000006
R10: 00000000fffffffc R11: 0000000000000000 R12: 0000000000002550
R13: 0000000000000002 R14: dffffc0000000000 R15: 0000000000000000
FS:  000055556197a500(0000) GS:ffff88808d98a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000020000000b000 CR3: 00000000591c9000 CR4: 0000000000352ef0


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

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
