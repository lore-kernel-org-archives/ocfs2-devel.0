Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946D040849
	for <ocfs2-devel@lists.linux.dev>; Wed,  9 Oct 2024 06:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728454707; cv=none; b=fv6YhxbZb5vXLVl5XfIhHIkLKpPZD5rKeKsr5J5pIrFIJe78V9W22aII6ojkTWpAz/E7xE4hV/V9u4lqzeKng5Dxd7DRuyOZO0NY8t2KFJQKBa3UTD/Vhw6CYA9qhnuOdYGyUjpEon8YEuzW6s6Rwbqhjb24R5yeG6Ei6+DgeIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728454707; c=relaxed/simple;
	bh=jeDl2eECNFgxn+gUZTVvWl/vmgDs+A4ZWpxCrYxTNR4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=GRvqs9Br8jiI2PymX3NUV7RBBw2pbDaLgyqvBrUFy/ZRv6LI5fOkVpYuP6u4ijYgmQIL5fkPlJhsFANiTmw4i8STBIqqXnyfTJO47MXjM0KkgsDth9qpcTBrBNwzsKXO8gaL1HaHgpn8HfrUuwbkr4Q1hd5HD+26VIBtDMtCTzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a342e872a7so67616245ab.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 08 Oct 2024 23:18:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728454705; x=1729059505;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VF9K6dR9/HzjqVYyr6eWKyBb0jNYgJqmpi7rOEdO2vs=;
        b=ZNawKE3vte8+OkAZW2FqX1isKtShajuzN7IDSNC/wMVH4YfFNPA3ohPFClicV9ub8I
         267tbaXglrdzPYEhuFugFbvhl/RJsBy4GRaz4Z9aRwD8gYFp0wo2h6I/qO6/0SgfPd2s
         74a07ESaE0e5Hz3onWqktTpBd/MSLX1ZhzaAiIyPMcKaxQhbysUiUhJGM6EFIMJN+1CY
         Q2GCo3e5bhEUTvXKqvHb1gcWrPtx8x8GtXWNRlxSaemK6nHtFcFsW7RCoH9jfjRONKIz
         W+yh7Q6Odg5T5ZOXX5oahve6IOUPK6mrItbACAWwUsCrYUuWHqkb5+DMGYKarF/g8hwV
         I4Yw==
X-Forwarded-Encrypted: i=1; AJvYcCWJF4N9RnhI6RZ9OmkcRfA3MYLO+lNEc/ZBDiEtn59i3k2PiGyGTe9117Xky170Y764d4G5gAwZyfaWSA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwH1SBhMz7wuxO261pWBAclqb++vlXSTu7EMzS8zHrT90VhnL7p
	AUVcy4SfPmG1+Kh7rIhmfJSHTDDv9vVp2igF7D7xFa1zXMrcFVlUnN87v5gqO0kO33HaPCgqf4s
	4675Jl87UL5RLLqbn6VDfj/hM5TaOQR+UDTYm8hW3GWuT3rVx9qDoNrk=
X-Google-Smtp-Source: AGHT+IEmM6ola206n/8IgSkGKN72AhhtxxN5z2YQfi/3qDBvDcIFW71cA+Sj5/cBOESAKNzNbe5eiJXo2C0ah1HqRv1ZK10BqVxI
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c05:b0:3a0:c85c:f18b with SMTP id
 e9e14a558f8ab-3a397ced693mr13784695ab.13.1728454704756; Tue, 08 Oct 2024
 23:18:24 -0700 (PDT)
Date: Tue, 08 Oct 2024 23:18:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67062030.050a0220.3f80e.0024.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_truncate_inline
From: syzbot <syzbot+81092778aac03460d6b7@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    360c1f1f24c6 Merge tag 'block-6.12-20241004' of git://git...
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1208479f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f8af0b3195caed62
dashboard link: https://syzkaller.appspot.com/bug?extid=81092778aac03460d6b7
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17f6d380580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1608479f980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/518c06e21f9f/disk-360c1f1f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2a385fca5995/vmlinux-360c1f1f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/510ff8226499/bzImage-360c1f1f.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/fc8df043f98c/mount_0.gz

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=135dcd27980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10ddcd27980000
console output: https://syzkaller.appspot.com/x/log.txt?x=175dcd27980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+81092778aac03460d6b7@syzkaller.appspotmail.com

ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
------------[ cut here ]------------
kernel BUG at fs/ocfs2/alloc.c:7402!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 1 UID: 0 PID: 5222 Comm: syz-executor553 Not tainted 6.12.0-rc1-syzkaller-00165-g360c1f1f24c6 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:ocfs2_truncate_inline+0x93d/0x940 fs/ocfs2/alloc.c:7402
Code: 38 c1 0f 8c bf fe ff ff 48 89 d7 48 89 54 24 08 e8 d8 d6 7a fe 48 8b 54 24 08 e9 a8 fe ff ff e8 f9 37 3c 08 e8 24 48 14 fe 90 <0f> 0b 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e
RSP: 0018:ffffc900038ef200 EFLAGS: 00010293
RAX: ffffffff83808e6c RBX: 00000000fffffffd RCX: ffff88802ae61e00
RDX: 0000000000000000 RSI: 0000000000000007 RDI: 0000000000000004
RBP: ffffc900038ef310 R08: ffffffff83808708 R09: 1ffffffff20377cd
R10: dffffc0000000000 R11: fffffbfff20377ce R12: 0000000000000007
R13: ffff888074ba5e48 R14: dffffc0000000000 R15: 0000000000000007
FS:  0000555583ee2380(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7782abb100 CR3: 0000000029b44000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ocfs2_remove_inode_range+0x603/0x2690 fs/ocfs2/file.c:1787
 __ocfs2_change_file_space+0x8e4/0xfd0 fs/ocfs2/file.c:2017
 ocfs2_fallocate+0x2e4/0x350 fs/ocfs2/file.c:2127
 vfs_fallocate+0x569/0x6e0 fs/open.c:333
 do_vfs_ioctl+0x2583/0x2e40 fs/ioctl.c:886
 __do_sys_ioctl fs/ioctl.c:905 [inline]
 __se_sys_ioctl+0x81/0x170 fs/ioctl.c:893
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7782a3edd9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffcbc179258 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0031656c69662f2e RCX: 00007f7782a3edd9
RDX: 00000000200000c0 RSI: 0000000040305829 RDI: 0000000000000005
RBP: 00007f7782ab75f0 R08: 0000555583ee34c0 R09: 0000555583ee34c0
R10: 0000555583ee34c0 R11: 0000000000000246 R12: 00007ffcbc179280
R13: 00007ffcbc1794a8 R14: 431bde82d7b634db R15: 00007f7782a8803b
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_truncate_inline+0x93d/0x940 fs/ocfs2/alloc.c:7402
Code: 38 c1 0f 8c bf fe ff ff 48 89 d7 48 89 54 24 08 e8 d8 d6 7a fe 48 8b 54 24 08 e9 a8 fe ff ff e8 f9 37 3c 08 e8 24 48 14 fe 90 <0f> 0b 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e
RSP: 0018:ffffc900038ef200 EFLAGS: 00010293
RAX: ffffffff83808e6c RBX: 00000000fffffffd RCX: ffff88802ae61e00
RDX: 0000000000000000 RSI: 0000000000000007 RDI: 0000000000000004
RBP: ffffc900038ef310 R08: ffffffff83808708 R09: 1ffffffff20377cd
R10: dffffc0000000000 R11: fffffbfff20377ce R12: 0000000000000007
R13: ffff888074ba5e48 R14: dffffc0000000000 R15: 0000000000000007
FS:  0000555583ee2380(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7782abb100 CR3: 0000000029b44000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


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
