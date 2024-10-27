Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E0E1384B3
	for <ocfs2-devel@lists.linux.dev>; Sun, 27 Oct 2024 10:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730024366; cv=none; b=NN/C4rfIE0NWywbz8X/z3W5Ty82ThEm0cp75tQQxHh14MY66382YeDS78a3zx6rTmsF/DJC2dQVX3WUwkDP1ATvqJsQnwB2WFJRWHp+GS/52CMSSFbVCGLNj5a0aPSIY7OYxeRv7lVnFy07EB4C2eOZ+FNXp87H4O171WC82150=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730024366; c=relaxed/simple;
	bh=qRTd0c5r2UBxAkqC5ig+z+WyhXzuqJKegjPdOLhaaVs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=sj0Ivx6gwWFL2pbsAc+cIQhoZicWw/WHgD2tmjEHGFWirHFStZJ/ymsWOZGMU6f/0N2rMtiJCWvz+YSDyMlBgxpfky737moRcSd/yCaQhRf3r14FK6Gtbv+lYEsi61nVYfMMtCLuVnCuDD450G6EJdHcVqhjOy4FXOmBHoogOSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a3ba4fcf24so35616815ab.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 27 Oct 2024 03:19:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730024364; x=1730629164;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X7yBQ7adT+27PYHQzx3rievw5FftioafdeMYYsgAE/E=;
        b=fmlg5/BJr470XfioyHjqGIrmmuH2/wTLcTtMQZxgj8wcyRpIUn1rzX2HiIxMi0XAdV
         R3D2Y8tLlK/T9gAVp9GCRpKYXRIcxgLn+2WdAAyL4+LhpwYl9yhN/KkNYwLNbWeT7xJg
         OGJpwbf2ue9vqSKVlZgfxZi+jnXWz/3NqqKuRSamlgX4hZgANYXwoGGPscV1LWCnMlzo
         CHUmC7ihkqxvOgJl2/YQC4SNlUUFhgH8gWA4mH85jWzPcbtj3Bgw5oik3UkCtUNCwbzV
         T6h9FWoMo98IbXY4GHd41HVY49DiKnZUXhfxvuFZ9BvJ+Ldu5yBV6TOWturoxhaEB7pe
         dMog==
X-Forwarded-Encrypted: i=1; AJvYcCUDQ/BRr9Rrj1hI0dPyA+hZA69RztH8FJjX0KK0pWu0d/7/ELHmWYeSFw2KqrjEcuphHRMjPoKv6Nkvfg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyhnQ1RiIAsxMv3pYbgAqRuprKRF6W0XtlxnTrQXwZk2ad2KRzh
	FwxtcdqMKGF+BUZEVNIHuKFUXGKYjrjXa1xp7IDIS6oXk4FZh/TrOVjFo5SiKodClYPiIXnyccz
	FbP1ov7ShmtlTnV+IrkhnINaeYFH/JBCeN3nUb8GKsmDOuD684Ci9rgQ=
X-Google-Smtp-Source: AGHT+IHXka4mtV1N/LMxD8SbGh4vMl/E5YMdqP/2rftJopwTR+SSIfmXZWSp23Wc/Tu3os3vaS/kax1YiPJSSJWx6JE8k1/9HHfi
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:17cf:b0:3a0:9238:d38 with SMTP id
 e9e14a558f8ab-3a4ed293143mr33026905ab.10.1730024363769; Sun, 27 Oct 2024
 03:19:23 -0700 (PDT)
Date: Sun, 27 Oct 2024 03:19:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <671e13ab.050a0220.2b8c0f.01d0.GAE@google.com>
Subject: [syzbot] [ocfs2?] general protection fault in ocfs2_xa_block_wipe_namevalue
From: syzbot <syzbot+386ce9e60fa1b18aac5b@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c2ee9f594da8 KVM: selftests: Fix build on on non-x86 archi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12d688a7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fc6f8ce8c5369043
dashboard link: https://syzkaller.appspot.com/bug?extid=386ce9e60fa1b18aac5b
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11ff2a5f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=131c4c30580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-c2ee9f59.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8a3541902b13/vmlinux-c2ee9f59.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a00efacc2604/bzImage-c2ee9f59.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/24458d1e01ba/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+386ce9e60fa1b18aac5b@syzkaller.appspotmail.com

(syz-executor887,5095,0):ocfs2_xa_remove:2028 ERROR: status = -12
(syz-executor887,5095,0):ocfs2_xa_cleanup_value_truncate:1999 ERROR: Partial truncate while removing xattr overlay.upper.  Leaking 1 clusters and removing the entry
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 UID: 0 PID: 5095 Comm: syz-executor887 Not tainted 6.12.0-rc4-syzkaller-00047-gc2ee9f594da8 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_xa_block_wipe_namevalue+0x91/0x550 fs/ocfs2/xattr.c:1637
Code: f8 48 c1 e8 03 48 bb 00 00 00 00 00 fc ff df 0f b6 04 18 84 c0 0f 85 f7 03 00 00 45 0f b7 27 49 8d 7d 04 48 89 f8 48 c1 e8 03 <0f> b6 04 18 84 c0 0f 85 f9 03 00 00 41 0f b7 45 04 89 44 24 04 49
RSP: 0018:ffffc9000aecebf0 EFLAGS: 00010247
RAX: 0000000000000000 RBX: dffffc0000000000 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 00000000fffffff4 RDI: 0000000000000004
RBP: ffffc9000aecf418 R08: ffffffff83a08052 R09: 0000000000000000
R10: ffff8880473f73c0 R11: ffffffff83a0a5e0 R12: 0000000000000000
R13: 0000000000000000 R14: ffffc9000aecf410 R15: ffff8880473f7230
FS:  000055557176f380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020001400 CR3: 000000003fa50000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ocfs2_xa_wipe_namevalue fs/ocfs2/xattr.c:1470 [inline]
 ocfs2_xa_remove_entry fs/ocfs2/xattr.c:1941 [inline]
 ocfs2_xa_remove fs/ocfs2/xattr.c:2044 [inline]
 ocfs2_xa_set+0x1120/0x2b40 fs/ocfs2/xattr.c:2248
 ocfs2_xattr_block_set+0x46e/0x3390 fs/ocfs2/xattr.c:2986
 __ocfs2_xattr_set_handle+0x28c/0x10a0
 ocfs2_xattr_set+0x128c/0x1930 fs/ocfs2/xattr.c:3651
 __vfs_removexattr+0x42a/0x460 fs/xattr.c:518
 __vfs_removexattr_locked+0x206/0x450 fs/xattr.c:553
 vfs_removexattr+0x103/0x2b0 fs/xattr.c:575
 removexattr fs/xattr.c:907 [inline]
 path_removexattr+0x284/0x3a0 fs/xattr.c:928
 __do_sys_lremovexattr fs/xattr.c:948 [inline]
 __se_sys_lremovexattr fs/xattr.c:945 [inline]
 __x64_sys_lremovexattr+0x5d/0x70 fs/xattr.c:945
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fdd4bc7a7c9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 d1 1a 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffe80c9a48 EFLAGS: 00000246 ORIG_RAX: 00000000000000c6
RAX: ffffffffffffffda RBX: 00007fffe80c9a60 RCX: 00007fdd4bc7a7c9
RDX: 00007fdd4bc79950 RSI: 0000000020000280 RDI: 0000000020000240
RBP: 0000000000000001 R08: 00007fffe80c97e7 R09: 0000555571770378
R10: 0000000000000001 R11: 0000000000000246 R12: 00007fffe80c9a80
R13: 00007fffe80c9ca8 R14: 431bde82d7b634db R15: 00007fdd4bcbc01d
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_xa_block_wipe_namevalue+0x91/0x550 fs/ocfs2/xattr.c:1637
Code: f8 48 c1 e8 03 48 bb 00 00 00 00 00 fc ff df 0f b6 04 18 84 c0 0f 85 f7 03 00 00 45 0f b7 27 49 8d 7d 04 48 89 f8 48 c1 e8 03 <0f> b6 04 18 84 c0 0f 85 f9 03 00 00 41 0f b7 45 04 89 44 24 04 49
RSP: 0018:ffffc9000aecebf0 EFLAGS: 00010247
RAX: 0000000000000000 RBX: dffffc0000000000 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 00000000fffffff4 RDI: 0000000000000004
RBP: ffffc9000aecf418 R08: ffffffff83a08052 R09: 0000000000000000
R10: ffff8880473f73c0 R11: ffffffff83a0a5e0 R12: 0000000000000000
R13: 0000000000000000 R14: ffffc9000aecf410 R15: ffff8880473f7230
FS:  000055557176f380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020001400 CR3: 000000003fa50000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	f8                   	clc
   1:	48 c1 e8 03          	shr    $0x3,%rax
   5:	48 bb 00 00 00 00 00 	movabs $0xdffffc0000000000,%rbx
   c:	fc ff df
   f:	0f b6 04 18          	movzbl (%rax,%rbx,1),%eax
  13:	84 c0                	test   %al,%al
  15:	0f 85 f7 03 00 00    	jne    0x412
  1b:	45 0f b7 27          	movzwl (%r15),%r12d
  1f:	49 8d 7d 04          	lea    0x4(%r13),%rdi
  23:	48 89 f8             	mov    %rdi,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	0f b6 04 18          	movzbl (%rax,%rbx,1),%eax <-- trapping instruction
  2e:	84 c0                	test   %al,%al
  30:	0f 85 f9 03 00 00    	jne    0x42f
  36:	41 0f b7 45 04       	movzwl 0x4(%r13),%eax
  3b:	89 44 24 04          	mov    %eax,0x4(%rsp)
  3f:	49                   	rex.WB


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
