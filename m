Received: from mail-ot1-f80.google.com (mail-ot1-f80.google.com [209.85.210.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41283101AB
	for <ocfs2-devel@lists.linux.dev>; Tue, 16 Dec 2025 16:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765902024; cv=none; b=B0Vymh8xW40GIixnjRLEG2t6Cmn24WqOuidGNnL4s5FslMxNL6NCKkKW+7XZ3rHLFGjR0cHhonQk5pwaOX9gXIvh5cLN+krKEQfKbqjnW87WkbKw7kCwqs7wcp6+b/vHZNp8NCiSZcOsGb+I6KTBAEFt4z03FNOd4HRzVea4+Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765902024; c=relaxed/simple;
	bh=a4GDEL/K2WlClftg92wFz5qG0ClbjQQpU2qkEVZ9aso=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=QIfqDJR0hQJO6eCilNCkhgr0sWxLzihJachdVhLIXsfPIuElyo7DVIt1f7xEVJLqQDPtYjxCe/GkkyEvtF60MHJGpK9XV3qiCF5og6b/1nN6WScGRfhtytaxQ+zAFlq4Tg4rAsmA1SJHlmviQLvmeNgg3N7OqPNCHZoyP323zdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f80.google.com with SMTP id 46e09a7af769-7c79200d1a4so8270967a34.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 16 Dec 2025 08:20:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765902022; x=1766506822;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DhF/x1wjsRopi+Kln0l4jVjDSBpwOU/mYdMdR5H0B04=;
        b=cAh6aGZCgbaeiZwvY0hb43V8WYxKy0AhRvnqkiNyhfXqYOZT1Kg7VpXhPr2hHx0Q1i
         w9ejl43k8Q/4U6uIDi5B6Kf3Yg/6q3tOw+dgM4u70RMcYTGYm6Esb1j2OmX0HeGcmRNa
         DgIICfF2oNMmZfXLw7QlBUiJunUMQVj9o/5aL9dQOu4/97bB+dKLMv3cUTAzO5iIWERd
         mszM/jdjsSnXVyEFnPhHsmJ3uc2SVM+az2kki+7Jy+mL4ZKZp71wW/7PmSyZOhxwPInk
         G305Ijot8l8dCdhaf5jWnAT0ifrwiTgn6oo3r8t9a1EaPdjbsD9HLGR/fQ708WMmfVIw
         oK5g==
X-Forwarded-Encrypted: i=1; AJvYcCXVHaz9DFjzy/HuJwoFh9w4WrDFW8XojvCO457SjZfrv/kXHFOF7erTGtytHFkF+JU90Ilg5hIPfA766A==@lists.linux.dev
X-Gm-Message-State: AOJu0YwP/ZbeV/Y1K7FZxGuRY6cgNOITeyJwunjgTgjqCZwT3uemuuue
	eLgdTCtJR2oiNyEJzqRQSOnk0gvw3AeQTYlkNTAv68zXOPKRUVteXGEgwJQPhRewaUzkyLsYpiY
	7zrcAnjjkdu20oA6cvCJ7cuPucXd1cJj+fA0YH7EwQ82mhhbN3kmuhivNlMk=
X-Google-Smtp-Source: AGHT+IEHR1zG4RmhvS0OQ2V3ndmIA43tErvFDoBZlqU3ieXBHsqVl8DLewBJVQmqkPS1q5HYbhL4HJI9YnMshe/akyZbIo3woaZi
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:bc90:0:b0:659:7cb2:78b1 with SMTP id
 006d021491bc7-65b37e889c7mr7084915eaf.4.1765902021899; Tue, 16 Dec 2025
 08:20:21 -0800 (PST)
Date: Tue, 16 Dec 2025 08:20:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <694186c5.050a0220.dc18b.0000.GAE@google.com>
Subject: [syzbot] [ocfs2?] WARNING in ocfs2_xa_remove_entry
From: syzbot <syzbot+8021f90e085c9ef5797d@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    187d0801404f Merge tag 'libcrypto-fixes-for-linus' of git:..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11803e1a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=de48dccdf203ea90
dashboard link: https://syzkaller.appspot.com/bug?extid=8021f90e085c9ef5797d
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15803e1a580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13c671c2580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-187d0801.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/48c184ec5db6/vmlinux-187d0801.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3eafabbccdb7/bzImage-187d0801.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/d5c016f0013c/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=15c671c2580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8021f90e085c9ef5797d@syzkaller.appspotmail.com

JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
------------[ cut here ]------------
memmove: detected buffer overflow: 16 byte read of buffer size 0
WARNING: lib/string_helpers.c:1036 at 0x0, CPU#0: syz.0.17/5492
Modules linked in:
CPU: 0 UID: 0 PID: 5492 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__fortify_report+0x89/0xa0 lib/string_helpers.c:1035
Code: e8 bc db 98 fd 48 8d 3d 85 b5 1b 0b 45 84 e4 49 8b 37 48 c7 c0 00 e5 df 8b 48 c7 c1 20 e5 df 8b 48 0f 44 c8 4c 89 f2 49 89 d8 <67> 48 0f b9 3a 5b 41 5c 41 5e 41 5f 5d e9 15 6a cf 06 cc cc cc cc
RSP: 0018:ffffc90002a2edb8 EFLAGS: 00010246
RAX: ffffffff8bdfe500 RBX: 0000000000000000 RCX: ffffffff8bdfe500
RDX: 0000000000000010 RSI: ffffffff8bdfe400 RDI: ffffffff8fac76a0
RBP: 0000000000000012 R08: 0000000000000000 R09: 0000000000000004
R10: ffff888056e9738c R11: ffffed100add2e7a R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000010 R15: ffffffff8bdfe208
FS:  00005555818de500(0000) GS:ffff88808d22f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000000111ed000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 __fortify_panic+0x9/0x10 lib/string_helpers.c:1042
 fortify_memcpy_chk include/linux/fortify-string.h:599 [inline]
 ocfs2_xa_remove_entry+0x304/0x3e0 fs/ocfs2/xattr.c:1955
 ocfs2_xa_remove fs/ocfs2/xattr.c:2043 [inline]
 ocfs2_xa_set+0xaf4/0x2a70 fs/ocfs2/xattr.c:2247
 ocfs2_xattr_block_set+0x3ca/0x31b0 fs/ocfs2/xattr.c:2985
 __ocfs2_xattr_set_handle+0x27e/0xf20 fs/ocfs2/xattr.c:-1
 ocfs2_xattr_set+0xde8/0x11f0 fs/ocfs2/xattr.c:3650
 __vfs_removexattr+0x431/0x470 fs/xattr.c:518
 __vfs_removexattr_locked+0x1e8/0x230 fs/xattr.c:553
 vfs_removexattr+0x80/0x1b0 fs/xattr.c:575
 removexattr fs/xattr.c:1023 [inline]
 filename_removexattr fs/xattr.c:1052 [inline]
 path_removexattrat+0x35d/0x690 fs/xattr.c:1088
 __do_sys_lremovexattr fs/xattr.c:1106 [inline]
 __se_sys_lremovexattr fs/xattr.c:1103 [inline]
 __x64_sys_lremovexattr+0x65/0x80 fs/xattr.c:1103
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7efe82f8f7c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc19a71458 EFLAGS: 00000246 ORIG_RAX: 00000000000000c6
RAX: ffffffffffffffda RBX: 00007efe831e5fa0 RCX: 00007efe82f8f7c9
RDX: 0000000000000000 RSI: 0000200000000180 RDI: 00002000000000c0
RBP: 00007efe83013f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007efe831e5fa0 R14: 00007efe831e5fa0 R15: 0000000000000002
 </TASK>
----------------
Code disassembly (best guess):
   0:	e8 bc db 98 fd       	call   0xfd98dbc1
   5:	48 8d 3d 85 b5 1b 0b 	lea    0xb1bb585(%rip),%rdi        # 0xb1bb591
   c:	45 84 e4             	test   %r12b,%r12b
   f:	49 8b 37             	mov    (%r15),%rsi
  12:	48 c7 c0 00 e5 df 8b 	mov    $0xffffffff8bdfe500,%rax
  19:	48 c7 c1 20 e5 df 8b 	mov    $0xffffffff8bdfe520,%rcx
  20:	48 0f 44 c8          	cmove  %rax,%rcx
  24:	4c 89 f2             	mov    %r14,%rdx
  27:	49 89 d8             	mov    %rbx,%r8
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	5b                   	pop    %rbx
  30:	41 5c                	pop    %r12
  32:	41 5e                	pop    %r14
  34:	41 5f                	pop    %r15
  36:	5d                   	pop    %rbp
  37:	e9 15 6a cf 06       	jmp    0x6cf6a51
  3c:	cc                   	int3
  3d:	cc                   	int3
  3e:	cc                   	int3
  3f:	cc                   	int3


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
