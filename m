Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1BD29BDB6
	for <ocfs2-devel@lists.linux.dev>; Sun, 19 Oct 2025 09:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760865217; cv=none; b=ljLdbq8mI1yUxwTjF4oBdhr2XJ3mUhr/5HV9NDs7CK0P7XE5L1vQDwVsCLYVSc9THbgDIXQYCl/5Zvd37mo85I2ljKLIy1MG/MwJFjGdTisRnoc8Sdy3ep1oNBUJlccIZePnR8Md4OWdVK4nca31JJCKp07bCNYhE1Pig0ZFZvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760865217; c=relaxed/simple;
	bh=suqT4dDmdOOVurOBiFqZVxsm2O3zT6CRdaYbbgTnbUI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=rmIVnB+gfdFkAjexgvR7swFfjVGZ/ZxutXe3vr0vo79TAg7rs1VhLHDuFR4NHRPtAh123fLk+OVF5BQuKWa+1sKD149wcXEqDTgiKb0TJSCS/qYT5aFQIh2c7vF0KoJF6+YUo2dKPHX11mbbBwWl6XmUpbsCltMxV7XXEs8+mOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-430c8321bc1so26125185ab.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 19 Oct 2025 02:13:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760865215; x=1761470015;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PNybqyDOAzWhDRx2d5SkmVYwuuYPyIcWTu7XfaT2bNk=;
        b=IXV/4SRMGTbdh5eSuoHMrA0W2Es6qg0O3Uz3UVPfLyCTYQpm/FkgUYyuW97FXg/ZFb
         j869qDUMa9G1dS/m9eF8d1lhb+PLTPC1KWhmQoTIBSTMqCTW0Bm6uk5LyP3Svj4bPlEN
         e/nMNO9pCJJd/jYKgh2P1UNpjnNjfIgqUCRLHmXCV6zRB746QYl513Eo28cYa34KRUw0
         f5FrONTXDbDLyIluuauXiNnTOuSzTo4lZo99DHW5BSzHnI1Xnzp+DKHUZgnSm2AHhkBB
         /Q1SxaThZv74husXjYCB5RvHGFYe9hpdazERld1JNGQ78Pl9ShuMNnheN3U6lIJRmE/b
         I5eg==
X-Forwarded-Encrypted: i=1; AJvYcCVr/sFf8Hoie8RHiBAsvw1PGMZZmWJ5vPmjaDGficcK5QrVPvN6c6LmlXxRyseT99HdLfWRStRwXZcCZA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz02825yK/iSMLsl6VBRmx8cstITpAkWYGm0XeeVyix2K+FEI27
	hg/ZPpHPrgYdiyIwJhWfa14Y3ooxtR87doB3HJWJxFlHWXuByFb1Vsp74zLsTihXUxV4HIy54ZA
	6Gt5AmkFIQJ73WiKc2Rhsj/bE8WOBqGIkKxy1rJOFUkPj/BxtkZFTx3sbLg8=
X-Google-Smtp-Source: AGHT+IEyblhAPbkA7AgZV8rggV0n7/0jXjcig/5pAVScLXiI5DyyfP9YqVi/9rd1YtVRGlzU7c9R9ql596DXPR4RHWNK5igF4NW1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:17c8:b0:430:ae26:7c28 with SMTP id
 e9e14a558f8ab-430c524cea2mr158942935ab.1.1760865214996; Sun, 19 Oct 2025
 02:13:34 -0700 (PDT)
Date: Sun, 19 Oct 2025 02:13:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68f4abbe.050a0220.1186a4.052a.GAE@google.com>
Subject: [syzbot] [ocfs2?] divide error in ocfs2_block_group_fill (3)
From: syzbot <syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    9b332cece987 Merge tag 'nfsd-6.18-1' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=107b85e2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c2d7b4143707d3a0
dashboard link: https://syzkaller.appspot.com/bug?extid=fd8af97c7227fe605d95
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-9b332cec.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/512c0375bad7/vmlinux-9b332cec.xz
kernel image: https://storage.googleapis.com/syzbot-assets/458c8c31cc7b/bzImage-9b332cec.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
=======================================================
WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
Oops: divide error: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5318 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_bg_discontig_add_extent fs/ocfs2/suballoc.c:335 [inline]
RIP: 0010:ocfs2_block_group_fill+0x5bd/0xa70 fs/ocfs2/suballoc.c:386
Code: 34 1a 49 81 c6 50 01 00 00 45 0f b7 3f 49 83 c5 02 4c 89 e8 48 c1 e8 03 42 0f b6 04 20 84 c0 0f 85 eb 03 00 00 44 89 f8 31 d2 <66> 41 f7 75 00 0f b7 d8 4c 89 f0 48 c1 e8 03 42 0f b6 04 20 84 c0
RSP: 0018:ffffc9000fd362a0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000100000
RDX: 0000000000000000 RSI: 00000000000010fe RDI: 00000000000010ff
RBP: ffffc9000fd363a8 R08: 00313050554f5247 R09: 00313050554f5247
R10: dffffc0000000000 R11: ffffed100a449001 R12: dffffc0000000000
R13: ffff8880334dc2c2 R14: ffff888052248150 R15: 0000000000000000
FS:  00007f73479876c0(0000) GS:ffff88808d301000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000000 CR3: 000000004280a000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 ocfs2_block_group_alloc_discontig fs/ocfs2/suballoc.c:634 [inline]
 ocfs2_block_group_alloc fs/ocfs2/suballoc.c:703 [inline]
 ocfs2_reserve_suballoc_bits+0x20a6/0x4640 fs/ocfs2/suballoc.c:834
 ocfs2_reserve_new_metadata_blocks+0x403/0x940 fs/ocfs2/suballoc.c:984
 ocfs2_expand_inline_dir fs/ocfs2/dir.c:2845 [inline]
 ocfs2_extend_dir+0xc76/0x4870 fs/ocfs2/dir.c:3207
 ocfs2_prepare_dir_for_insert+0x2fe8/0x5450 fs/ocfs2/dir.c:4312
 ocfs2_mknod+0x819/0x2050 fs/ocfs2/namei.c:297
 ocfs2_create+0x1a5/0x440 fs/ocfs2/namei.c:676
 vfs_create+0x24e/0x400 fs/namei.c:3493
 do_mknodat+0x3c6/0x4d0 fs/namei.c:4372
 __do_sys_mknod fs/namei.c:4405 [inline]
 __se_sys_mknod fs/namei.c:4403 [inline]
 __x64_sys_mknod+0x8c/0xa0 fs/namei.c:4403
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7346b8eec9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7347987038 EFLAGS: 00000246 ORIG_RAX: 0000000000000085
RAX: ffffffffffffffda RBX: 00007f7346de5fa0 RCX: 00007f7346b8eec9
RDX: 0000000000000700 RSI: 0000000000000000 RDI: 0000200000000000
RBP: 00007f7346c11f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f7346de6038 R14: 00007f7346de5fa0 R15: 00007fff09db6038
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_bg_discontig_add_extent fs/ocfs2/suballoc.c:335 [inline]
RIP: 0010:ocfs2_block_group_fill+0x5bd/0xa70 fs/ocfs2/suballoc.c:386
Code: 34 1a 49 81 c6 50 01 00 00 45 0f b7 3f 49 83 c5 02 4c 89 e8 48 c1 e8 03 42 0f b6 04 20 84 c0 0f 85 eb 03 00 00 44 89 f8 31 d2 <66> 41 f7 75 00 0f b7 d8 4c 89 f0 48 c1 e8 03 42 0f b6 04 20 84 c0
RSP: 0018:ffffc9000fd362a0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000100000
RDX: 0000000000000000 RSI: 00000000000010fe RDI: 00000000000010ff
RBP: ffffc9000fd363a8 R08: 00313050554f5247 R09: 00313050554f5247
R10: dffffc0000000000 R11: ffffed100a449001 R12: dffffc0000000000
R13: ffff8880334dc2c2 R14: ffff888052248150 R15: 0000000000000000
FS:  00007f73479876c0(0000) GS:ffff88808d301000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000000 CR3: 000000004280a000 CR4: 0000000000352ef0
----------------
Code disassembly (best guess):
   0:	34 1a                	xor    $0x1a,%al
   2:	49 81 c6 50 01 00 00 	add    $0x150,%r14
   9:	45 0f b7 3f          	movzwl (%r15),%r15d
   d:	49 83 c5 02          	add    $0x2,%r13
  11:	4c 89 e8             	mov    %r13,%rax
  14:	48 c1 e8 03          	shr    $0x3,%rax
  18:	42 0f b6 04 20       	movzbl (%rax,%r12,1),%eax
  1d:	84 c0                	test   %al,%al
  1f:	0f 85 eb 03 00 00    	jne    0x410
  25:	44 89 f8             	mov    %r15d,%eax
  28:	31 d2                	xor    %edx,%edx
* 2a:	66 41 f7 75 00       	divw   0x0(%r13) <-- trapping instruction
  2f:	0f b7 d8             	movzwl %ax,%ebx
  32:	4c 89 f0             	mov    %r14,%rax
  35:	48 c1 e8 03          	shr    $0x3,%rax
  39:	42 0f b6 04 20       	movzbl (%rax,%r12,1),%eax
  3e:	84 c0                	test   %al,%al


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
