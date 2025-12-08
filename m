Received: from mail-ot1-f78.google.com (mail-ot1-f78.google.com [209.85.210.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A5A25A640
	for <ocfs2-devel@lists.linux.dev>; Mon,  8 Dec 2025 07:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765179692; cv=none; b=tTH9intMCv+6pkIjGucEar37SxXyAVrrjq96/29t4SoAjrSfKP0uLXnZ8r4fA09b0xxyo3sU9MQ2OutFvbepsqObaojwWhwAQ6wUn+EoAhvyIXQzuo1Of6JmJc85o5vTJ+X3qlUO/Qfx8z19O6u7DCAGn5CclH9d77sYBssf6yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765179692; c=relaxed/simple;
	bh=tvfZMSrDkC6ta5yr9Alwrmm9vBEkWPqK6e9b3jtcV7o=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=FQK+0l5YOCSYXfYQhpShtJ3oHP0/bs44AKoBwoPNPJpCh+dQmPVWITWsm2pjkzvkBccLAMQFsIXKlEu5spOjmUzAjkK92m+G+4H1CeAiM2wgTYP+SxBzYplmISsJp4xd2e/PWvabPXBQoJznL1R65ywaGdSJb7QcX9ZYDnegSK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f78.google.com with SMTP id 46e09a7af769-7c754daf77fso8486913a34.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 07 Dec 2025 23:41:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765179689; x=1765784489;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GE07irCDDq/q2tmA9wlEkvrmYCuBmh6FCVvXbPHRbBM=;
        b=CwCHckKO4CW9VZE9maLMHMjT/XaQCkSEnrqyeFJg1nf+vx+3dupmxjVGB7NXSz214V
         NBbqP+XiJxf0/UPH+PnaBJeOUhSgRrPHD5lo7EbcUtGOBzZfm1k9aA1ioblN8q0BwX9S
         vhVSIl4oTxcd/atX+/+xCNBontm+nkWrZREYSf0M+ut+bPxkoWqOpflOpx3hcsIEF35G
         UTjQrDZwPIzQvf+kaQ+6/vNzKgzgtU9IifQgB0oc4kAODBB4bIO860qVsUGDfVbi8H5Y
         D/Yi6WTBQy6x7cW2+ctil36G+KK1UQrSN/rKyTofdr9b1u5QzB1XMzzgcb6j/99bocxe
         TT/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXd0PVpFU2zUE+pocGSaCO/B/86b2klDioPoS/smp+VhyZNdVAXSDT3uGpQhBd3sidqyOW6A+UdgYP44g==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+PC0SKBSbrS7VQui5M6wzKXWFtkUOEF2/N+D8vx67d7JGEXop
	qoEXzEtpWWIRlTpVEAyKiyEOZzw4FRV8sMhGnZWotWBB07TiIhR/d+qTr6j+fbD6BAe4FZbr6uu
	enZ/C4ldEg21tS7Qv8QK36LMUVI25Dz0CpZVUWLSvncjYjq4Xrf3BDAJlNkg=
X-Google-Smtp-Source: AGHT+IFuE0PTxDTIr8e0pkfDGlzSczbA8WUs2HGi9aboSBZU0RD1oRu1HhmMfJHtA/BE5VsbNAhbMVapOIbsHPJKRBo1TjtW0mjy
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:ef81:0:b0:659:9a49:8e33 with SMTP id
 006d021491bc7-6599a499e62mr2276040eaf.37.1765179689733; Sun, 07 Dec 2025
 23:41:29 -0800 (PST)
Date: Sun, 07 Dec 2025 23:41:29 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69368129.a70a0220.38f243.008e.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_remove_refcount_tree
From: syzbot <syzbot+6d832e79d3efe1c46743@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    cc3ee4ba57b7 Merge tag 'x86-urgent-2025-12-06' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1084a992580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c076ba11dc381bf9
dashboard link: https://syzkaller.appspot.com/bug?extid=6d832e79d3efe1c46743
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16affc1a580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=168f221a580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/add7b22e16d3/disk-cc3ee4ba.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/df4dfdacc713/vmlinux-cc3ee4ba.xz
kernel image: https://storage.googleapis.com/syzbot-assets/13e72276bff4/bzImage-cc3ee4ba.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/31e89a92b694/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=121da6c2580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6d832e79d3efe1c46743@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/ocfs2/refcounttree.c:774!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 5921 Comm: syz-executor Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:ocfs2_remove_refcount_tree+0xd51/0xd60 fs/ocfs2/refcounttree.c:774
Code: fe e9 be fd ff ff 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c d8 fd ff ff 4c 89 ff e8 2a 9d 80 fe e9 cb fd ff ff e8 30 3e 1e fe 90 <0f> 0b 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90
RSP: 0018:ffffc90003eb72c0 EFLAGS: 00010293
RAX: ffffffff83a1f400 RBX: 0000000000000010 RCX: ffff888025443c80
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90003eb74b0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000100 R11: 00000000fffffffc R12: 1ffff1100aff633b
R13: 1ffff920007d6e68 R14: 1ffff110092a8c52 R15: 0000000000000000
FS:  000055557d56b500(0000) GS:ffff888126e4f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055557d596648 CR3: 00000000343a8000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 ocfs2_wipe_inode fs/ocfs2/inode.c:888 [inline]
 ocfs2_delete_inode fs/ocfs2/inode.c:1155 [inline]
 ocfs2_evict_inode+0x142a/0x4020 fs/ocfs2/inode.c:1297
 evict+0x5f4/0xae0 fs/inode.c:837
 d_delete_notify include/linux/fsnotify.h:377 [inline]
 vfs_rmdir+0x3f4/0x670 fs/namei.c:5249
 do_rmdir+0x27f/0x4a0 fs/namei.c:5291
 __do_sys_unlinkat fs/namei.c:5468 [inline]
 __se_sys_unlinkat fs/namei.c:5462 [inline]
 __x64_sys_unlinkat+0xc2/0xf0 fs/namei.c:5462
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9853deed27
Code: 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 07 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff08488218 EFLAGS: 00000207 ORIG_RAX: 0000000000000107
RAX: ffffffffffffffda RBX: 0000000000000065 RCX: 00007f9853deed27
RDX: 0000000000000200 RSI: 00007fff084893c0 RDI: 00000000ffffff9c
RBP: 00007f9853e73d7d R08: 000055557d58e66b R09: 0000000000000000
R10: 0000000000001000 R11: 0000000000000207 R12: 00007fff084893c0
R13: 00007f9853e73d7d R14: 000000000001da3d R15: 00007fff0848b580
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_remove_refcount_tree+0xd51/0xd60 fs/ocfs2/refcounttree.c:774
Code: fe e9 be fd ff ff 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c d8 fd ff ff 4c 89 ff e8 2a 9d 80 fe e9 cb fd ff ff e8 30 3e 1e fe 90 <0f> 0b 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90
RSP: 0018:ffffc90003eb72c0 EFLAGS: 00010293
RAX: ffffffff83a1f400 RBX: 0000000000000010 RCX: ffff888025443c80
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90003eb74b0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000100 R11: 00000000fffffffc R12: 1ffff1100aff633b
R13: 1ffff920007d6e68 R14: 1ffff110092a8c52 R15: 0000000000000000
FS:  000055557d56b500(0000) GS:ffff888126e4f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055557d596648 CR3: 00000000343a8000 CR4: 00000000003526f0


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
