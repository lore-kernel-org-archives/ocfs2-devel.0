Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFA914A0BC
	for <ocfs2-devel@lists.linux.dev>; Tue, 14 Jan 2025 14:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736866769; cv=none; b=g9Wp7rvbaM7aWKIVCnUx08ZQfbSddehdSRq3ZqJYWB+k3tSLIrNKGVGzfd07+sNYlLvC9AANc0fxxmCzz2XbOOk0Jfq3cdZ3OtaHKYmFKU1Y75gKydNXEYikjV/4LF3CooUmfHG+FHkc6XPw4ZNOUCcPPA5HvO0FR4HlEzcjELs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736866769; c=relaxed/simple;
	bh=c43cgl4EL874FGbW6/V7EjI28w1qhsDQYzstusKVcC0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=tiR8GyTwj+LsiV9R1iyxHOFFLCVRrRELLCGq2KdpoCjdBzudf2xPSX3fKVIW2OmEAt+kn/45E+W+KmSulGCjGNE5EaVDwGwucDh+Z0iP8Oy1YkeB9C8MRKMzMCyNDcIK+wiP4d3/b3f8GP2GYsdHLP00b+pPrbcD5vtiB03HB3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3ac005db65eso45068625ab.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 14 Jan 2025 06:59:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736866765; x=1737471565;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3BZwYryzusa6Mb1HhF5OewSV/cP+Q4Qnctsibdyrqak=;
        b=H2V8yVhKZU8LGmdWIl/JjnlAJnwtRgVzZe3LLjcuGwPVOp7qexivJk5zZalLXR0K9K
         RbNJO5IvrK5JEQfPVLl/KUgrNnVjNh5n0+gdi39zB85mxDMo72M0eUr3c72+SsPZTncF
         nBQ5XEn0K6q+eWPE2Lr2miskkcWjpmO9rYRfecf1/M/Flj9JImt8a7kvahB33CB8cQqA
         ZqSP7vauFuBDkSSE73l3bxlDFlIXsRwP+o4gT0Fb5QV6ZYbiEWw2RStIPv7I8X8ZqWpA
         gnynicOxnVub4HjHTQlsF94ZaMrk2Aih44iJiykCLP1jjZeQ0XYD9bnPJ5IFPUVH2EBu
         McwA==
X-Forwarded-Encrypted: i=1; AJvYcCWTu3INVBAlDO9Uk4/RDZUIAetRtH3nNgRDd9ELJ0Ejn+DDJsFQ6+/DQmeq65T/JLuNr9LHPiv8k6FU6g==@lists.linux.dev
X-Gm-Message-State: AOJu0YzE7IL3ZtYRQjZKwERsr/RhQ7jciZLvHxM6RHBuM4Iywddqh92u
	c6Pv/T7G0ac5IrkSSBfd0T/srvRLE1sncFaTqKSn0jP5z8aSCbbRYh/UyulHN8e9PvooVyB1rI+
	ztAsMiqeWWhSf3ZdJBbeKZAaWVQ7iZSq1Jis6HvMiAkZLl1c62MOkcT8=
X-Google-Smtp-Source: AGHT+IGzbn99gEPoYc7RlKboDLH9gF0BNgFnMAMN663A3KDIkCJUELTNHHfpMdY1Mpv4Onh9HXN76kJbStRckGyUZ5ez87EcNfuY
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:308b:b0:3a7:172f:1299 with SMTP id
 e9e14a558f8ab-3ce3a96d959mr210130685ab.12.1736866765477; Tue, 14 Jan 2025
 06:59:25 -0800 (PST)
Date: Tue, 14 Jan 2025 06:59:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67867bcd.050a0220.216c54.007e.GAE@google.com>
Subject: [syzbot] [ocfs2?] WARNING in ocfs2_unlink
From: syzbot <syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2144da25584e Merge tag '6.13-rc6-ksmbd-server-fixes' of gi..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=16d91ef8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7ac4cd61d548c1ef
dashboard link: https://syzkaller.appspot.com/bug?extid=55c40ae8a0e5f3659f2b
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13374cb0580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11933218580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/20804efabd09/disk-2144da25.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/40fb8a3e4d97/vmlinux-2144da25.xz
kernel image: https://storage.googleapis.com/syzbot-assets/415035e6e16a/bzImage-2144da25.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/78980b7ee636/mount_0.gz

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=136ad1df980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10ead1df980000
console output: https://syzkaller.appspot.com/x/log.txt?x=176ad1df980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com

(syz-executor370,5817,0):ocfs2_delete_inode:1068 ERROR: status = -17
(syz-executor370,5817,1):ocfs2_query_inode_wipe:937 ERROR: Inode 17057 (on-disk 17057) not orphaned! Disk flags  0x1, inode flags 0x0
(syz-executor370,5817,1):ocfs2_delete_inode:1068 ERROR: status = -17
------------[ cut here ]------------
WARNING: CPU: 1 PID: 5817 at fs/inode.c:407 drop_nlink+0xc4/0x110 fs/inode.c:407
Modules linked in:
CPU: 1 UID: 0 PID: 5817 Comm: syz-executor370 Not tainted 6.13.0-rc6-syzkaller-00130-g2144da25584e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:drop_nlink+0xc4/0x110 fs/inode.c:407
Code: bb 70 07 00 00 be 08 00 00 00 e8 97 37 e7 ff f0 48 ff 83 70 07 00 00 5b 41 5c 41 5e 41 5f 5d c3 cc cc cc cc e8 3d 5c 83 ff 90 <0f> 0b 90 eb 83 44 89 e1 80 e1 07 80 c1 03 38 c1 0f 8c 5c ff ff ff
RSP: 0018:ffffc90003e278f0 EFLAGS: 00010293
RAX: ffffffff821c1793 RBX: 1ffff1100e6a4118 RCX: ffff88802e633c00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff821c1713 R09: 1ffff1100e68bfa2
R10: dffffc0000000000 R11: ffffed100e68bfa3 R12: ffff8880735208c0
R13: 1ffff920007c4f34 R14: ffff888073520878 R15: dffffc0000000000
FS:  000055557662e380(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffc5bb41ed8 CR3: 0000000079324000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ocfs2_unlink+0xf62/0x1c80 fs/ocfs2/namei.c:997
 vfs_unlink+0x365/0x650 fs/namei.c:4523
 do_unlinkat+0x4ae/0x830 fs/namei.c:4587
 __do_sys_unlink fs/namei.c:4635 [inline]
 __se_sys_unlink fs/namei.c:4633 [inline]
 __x64_sys_unlink+0x47/0x50 fs/namei.c:4633
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff0c24f9cd7
Code: 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 57 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc5bb42688 EFLAGS: 00000287 ORIG_RAX: 0000000000000057
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff0c24f9cd7
RDX: 00007ffc5bb426b0 RSI: 00007ffc5bb42740 RDI: 00007ffc5bb42740
RBP: 00007ffc5bb42740 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000100 R11: 0000000000000287 R12: 00007ffc5bb43830
R13: 0000555576637700 R14: 431bde82d7b634db R15: 00007ffc5bb448c0
 </TASK>


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
