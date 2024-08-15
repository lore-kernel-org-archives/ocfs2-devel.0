Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F8A1BBBF4
	for <ocfs2-devel@lists.linux.dev>; Thu, 15 Aug 2024 10:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723718845; cv=none; b=KNU72dyZz+8I8XCjHBNW4uMWnIE85U/hVDa+bH5zyjOiuu5cpcVjhN93JDa1BUSqbDu6ZmemKK78nFnrtHplMximo1ePkF8vWPN++YLhFw2q2YnsGbz/CNKfyhC78v3fCSYRkHxfWLuVqKQUB72J7IQylPKU13aridlgWY1b+wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723718845; c=relaxed/simple;
	bh=yCWwAnK1UqcoNSOSGByQVCXlCiRvpJmbiW9YwqRy6b4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=EIndHwdA8rAQs2SYwINrca+dka2Vi5UHFRuw+IH6bZioXqCauWUyVN+e3yp4cn4KnGkejHtc7vMa2e210KjmHLC5pxe027DQDO527QB1D9mXa/R8P4HwpqR3w6yPlovPL0iATCXaM+gOAnNq5o5D97/4u2dz6HN0rAN/llc0rKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-39b3b5858e6so7480185ab.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 15 Aug 2024 03:47:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723718842; x=1724323642;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4R0x6jvQPqj95doxzZCr2akon71oPdcz8oMNY4kUKyo=;
        b=B7bSNNO08ZJaPbNRnmdtYQebSd8dxNyoKkhlM2cGuosR6zeCW5kNSZbQ1vWvsx+886
         +cYzq/KlF8IZe3nuF7Q8Yuz2pPZ7sbRFm8Bj/454ctr8M3L3cOQBLFSzdkFRkZdaFirn
         Vp6gT55trkjyHz0pPjm8Zo4jhKqVkq2MRF4+ieEQAJB0aP8fliG48vJylqsXHRqDQ1M/
         kNk7lqkYin2mlDe5ZiXP6gppBZpQccnmUnrz8rLFLCIT4ACvHqukIfhPBBCKzAt0NIRF
         mSOQdPQa4RyYdDq1Gx1O/ZIpGvgjCMQIqF/WeJDDRo+fXO0rml6LKXArpvzfh9Mb1lmI
         2N0Q==
X-Forwarded-Encrypted: i=1; AJvYcCVRlo17ZXNM5yY9czxZ2D/A0s+gTZ4R+Z4vWtfFEqq9PbBvUF400L1Xslbytc6Iuq7Ts6wP2/Lmfm2/wntxIFUwHvEcpA4a+qTrpEE=
X-Gm-Message-State: AOJu0Yy61dv6ZOz6sDQSva2bBWD5OtL/HIVrPvb1nfQZN0gV5FtsZcRK
	WePocJPU8bV4zl/hBiqyYBdy+8tHymm2ahftrPM1TtYNYOXMl4m8vhd/mUOZPPdX1H9etdqru3s
	V+1mev7gdUdePfJXaSFZndhTiF2vkriYmeqpPYel5tsFfGt9u+b90nBY=
X-Google-Smtp-Source: AGHT+IH3bp65kYvIp1GRTdKaKPFpi1klt5T/THnz6EIpKoXROQGK0LrQq5xCklCDbGMhsEkEXWGLplplRQSfe6nt2iLszq7WNMnI
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b46:b0:397:fa4e:3df0 with SMTP id
 e9e14a558f8ab-39d124c23bbmr3802795ab.3.1723718842599; Thu, 15 Aug 2024
 03:47:22 -0700 (PDT)
Date: Thu, 15 Aug 2024 03:47:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004e582f061fb691ff@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_iget
From: syzbot <syzbot+5bdd4953bc58c8fbd6eb@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d07b43284ab3 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1309d7d9980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7229118d88b4a71b
dashboard link: https://syzkaller.appspot.com/bug?extid=5bdd4953bc58c8fbd6eb
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=119c396b980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=148ab6d5980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-d07b4328.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/91ceec6e19d3/vmlinux-d07b4328.xz
kernel image: https://storage.googleapis.com/syzbot-assets/be11646b0c05/bzImage-d07b4328.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/958835a2c737/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5bdd4953bc58c8fbd6eb@syzkaller.appspotmail.com

(syz-executor200,5094,0):ocfs2_read_locked_inode:536 ERROR: bug expression: !!(fe->i_flags & cpu_to_le32(OCFS2_SYSTEM_FL)) != !!(args->fi_flags & OCFS2_FI_FLAG_SYSFILE)
(syz-executor200,5094,0):ocfs2_read_locked_inode:536 ERROR: Inode 17: system file state is ambiguous
------------[ cut here ]------------
kernel BUG at fs/ocfs2/inode.c:536!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5094 Comm: syz-executor200 Not tainted 6.11.0-rc3-syzkaller-00060-gd07b43284ab3 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_read_locked_inode fs/ocfs2/inode.c:533 [inline]
RIP: 0010:ocfs2_iget+0x202b/0x2120 fs/ocfs2/inode.c:159
Code: 00 e8 59 8b 75 fe 4c 8b 84 24 c0 01 00 00 4c 89 f7 48 c7 c6 e8 bd 0b 8e ba 18 02 00 00 48 c7 c1 00 00 49 8c e8 06 c9 16 00 90 <0f> 0b e8 de 45 0e fe 90 0f 0b e8 d6 45 0e fe 31 db 65 ff 0d a5 93
RSP: 0018:ffffc9000b0aefe0 EFLAGS: 00010246
RAX: 64c5852747dade00 RBX: ffffc9000b0af140 RCX: 64c5852747dade00
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffc9000b0af270 R08: ffffffff8174024c R09: 1ffff1100410519a
R10: dffffc0000000000 R11: ffffed100410519b R12: ffff8880154ea200
R13: dffffc0000000000 R14: ffffc9000b0af160 R15: 1000000000000000
FS:  00005555677bf380(0000) GS:ffff888020800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055a9ee203e78 CR3: 000000003680c000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ocfs2_init_global_system_inodes+0xc6/0x730 fs/ocfs2/super.c:437
 ocfs2_initialize_super fs/ocfs2/super.c:2250 [inline]
 ocfs2_fill_super+0x3068/0x5880 fs/ocfs2/super.c:994
 mount_bdev+0x20a/0x2d0 fs/super.c:1679
 legacy_get_tree+0xee/0x190 fs/fs_context.c:662
 vfs_get_tree+0x90/0x2a0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3472
 do_mount fs/namespace.c:3812 [inline]
 __do_sys_mount fs/namespace.c:4020 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:3997
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2d27572dea
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff1e6e9398 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fff1e6e93b0 RCX: 00007f2d27572dea
RDX: 0000000020004480 RSI: 00000000200044c0 RDI: 00007fff1e6e93b0
RBP: 0000000000000004 R08: 00007fff1e6e93f0 R09: 000000000000447b
R10: 0000000002800400 R11: 0000000000000282 R12: 0000000002800400
R13: 00007fff1e6e93f0 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_read_locked_inode fs/ocfs2/inode.c:533 [inline]
RIP: 0010:ocfs2_iget+0x202b/0x2120 fs/ocfs2/inode.c:159
Code: 00 e8 59 8b 75 fe 4c 8b 84 24 c0 01 00 00 4c 89 f7 48 c7 c6 e8 bd 0b 8e ba 18 02 00 00 48 c7 c1 00 00 49 8c e8 06 c9 16 00 90 <0f> 0b e8 de 45 0e fe 90 0f 0b e8 d6 45 0e fe 31 db 65 ff 0d a5 93
RSP: 0018:ffffc9000b0aefe0 EFLAGS: 00010246
RAX: 64c5852747dade00 RBX: ffffc9000b0af140 RCX: 64c5852747dade00
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffc9000b0af270 R08: ffffffff8174024c R09: 1ffff1100410519a
R10: dffffc0000000000 R11: ffffed100410519b R12: ffff8880154ea200
R13: dffffc0000000000 R14: ffffc9000b0af160 R15: 1000000000000000
FS:  00005555677bf380(0000) GS:ffff888020800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055a9ee203e78 CR3: 000000003680c000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


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
