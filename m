Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BA118B49C
	for <ocfs2-devel@lists.linux.dev>; Thu, 12 Sep 2024 09:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726133728; cv=none; b=SgL0Rw8hHj2fBh1RorqCYkSOmb25Loq1O3iSi2YFJZns+B6kZqhawrOdQOKRr2JqEmxQm45FTKpz8SS4vIIoK7IFDZxiPw7YwFAS8RnxVJRnMl+njd2fWSrWrLUArD3SKMnuhVBSODe/AvRBXQeOeiuQtNBU8VH6Xpn8kGNn7m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726133728; c=relaxed/simple;
	bh=ehpA70HSEZqRTxvErOSz9/BzASFw9HrdY9tUr0JEKRA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=VA/6nX/7OxjWHG8WoPriXsQZi2O4YQiPF8VJx10D9P6or00zaXkrZg540bWG5txP7mMyeAdzRr62CXd4Av7viA0W+vM4uig7B3D94hszL8nPATBi32X3BzRE620bFeVGR097lOTuvggOTC8Kr5VxcfFpOm274o93FrXuXuWguQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-82cedb7a183so124480239f.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 12 Sep 2024 02:35:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726133726; x=1726738526;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2qwD8LnIsOP3W2sx9rgr6wCqCLnQ7bgsKr0t6sHDDlE=;
        b=iSjJaaoKDXmOt7bibODMrrJWbIzcbETnyiGeV0SdD4nUFWsfxPDrn6iGc2qc9Y7PR/
         OAPkfzJ0FbmqujwBHT8/kh7d0JgOtu6nEskklm65KBjN0uNJIbNaS/Y+mJtNjS30mMzz
         eYA9eO0xQc6saEiOUi1Z5gqxIMpw/smkKTrzEvA7ltOaL8F7N1GWhWqEcw19VupoACx/
         UULUKbsGz21LPKHEeF1n0RtaCDHPDbptUgCxbeOMwx6MdkWhltHUQ6D3Uo8k/rUQq8kF
         eMDgpR97lsCyk9vz4d8KFmwoefo3Von9CWiJjz0eSXHhGf+EkMkU4qDK14f5+wWVYxUU
         JKLA==
X-Forwarded-Encrypted: i=1; AJvYcCUYYYncf1kF/iAuR5mq/z+3tCBWdrCKlLCnXwZKxkN8wcZGmpE32/5y091SXZ9o1DaHdLwCL/leuVG9EA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyg5GIR2ybQbMiGyYHlLIwuSQ9EXR/rqviXagvgJx1UyDhiXo19
	z0BxL1pBF2aw1WDbuWp+rX5ynJzUaR5lm5z/N3U/kK5lTAb/pY7PLUneuagaMqmgBF0OyXY7rXQ
	dS+yK3XFuS7sngxK+8ytratE6xblOVOhZ6pC/vYsHj7sl0NeqMBTPyo4=
X-Google-Smtp-Source: AGHT+IEXdrRKxrVhwO+ACttb2I+d/6P89mocz2lytkCP2q37sDiR/aeyUjAvgagC5f1LH+YL7Ji6EQlXbP3qkK6FJQgYWjtr/xEK
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fce:b0:39d:323d:89b2 with SMTP id
 e9e14a558f8ab-3a08495e116mr20121375ab.26.1726133726057; Thu, 12 Sep 2024
 02:35:26 -0700 (PDT)
Date: Thu, 12 Sep 2024 02:35:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000093a1ca0621e8d336@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_page_mkwrite
From: syzbot <syzbot+2e6495950edcf7fbfccf@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8d8d276ba2fb Merge tag 'trace-v6.11-rc6' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=119fa477980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=61d235cb8d15001c
dashboard link: https://syzkaller.appspot.com/bug?extid=2e6495950edcf7fbfccf
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-8d8d276b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d23708af23a4/vmlinux-8d8d276b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1aed2837c105/bzImage-8d8d276b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2e6495950edcf7fbfccf@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
=======================================================
WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
6.11.0-rc7-syzkaller-00020-g8d8d276ba2fb #0 Not tainted
------------------------------------------------------
syz.0.0/5113 is trying to acquire lock:
ffff88804bc43f60 (&oi->ip_alloc_sem){++++}-{3:3}, at: ocfs2_page_mkwrite+0x347/0xed0 fs/ocfs2/mmap.c:142

but task is already holding lock:
ffff88804ac2e518 (sb_pagefaults){.+.+}-{0:0}, at: do_page_mkwrite+0x19b/0x480 mm/memory.c:3142

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (sb_pagefaults){.+.+}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1676 [inline]
       sb_start_pagefault include/linux/fs.h:1841 [inline]
       ocfs2_page_mkwrite+0x223/0xed0 fs/ocfs2/mmap.c:122
       do_page_mkwrite+0x19b/0x480 mm/memory.c:3142
       wp_page_shared mm/memory.c:3545 [inline]
       do_wp_page+0x23d9/0x52f0 mm/memory.c:3695
       handle_pte_fault+0x115a/0x6fc0 mm/memory.c:5537
       __handle_mm_fault mm/memory.c:5664 [inline]
       handle_mm_fault+0x1109/0x1bc0 mm/memory.c:5832
       do_user_addr_fault arch/x86/mm/fault.c:1389 [inline]
       handle_page_fault arch/x86/mm/fault.c:1481 [inline]
       exc_page_fault+0x2b9/0x8c0 arch/x86/mm/fault.c:1539
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
       rep_movs_alternative+0x4a/0x70 arch/x86/lib/copy_user_64.S:65
       copy_user_generic arch/x86/include/asm/uaccess_64.h:110 [inline]
       raw_copy_to_user arch/x86/include/asm/uaccess_64.h:131 [inline]
       copy_to_user_iter lib/iov_iter.c:25 [inline]
       iterate_ubuf include/linux/iov_iter.h:29 [inline]
       iterate_and_advance2 include/linux/iov_iter.h:245 [inline]
       iterate_and_advance include/linux/iov_iter.h:271 [inline]
       _copy_to_iter+0x26b/0x1960 lib/iov_iter.c:185
       copy_to_iter include/linux/uio.h:196 [inline]
       get_random_bytes_user+0x1e5/0x420 drivers/char/random.c:464
       __do_sys_getrandom drivers/char/random.c:1406 [inline]
       __se_sys_getrandom drivers/char/random.c:1380 [inline]
       __x64_sys_getrandom+0x152/0x250 drivers/char/random.c:1380
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&mm->mmap_lock){++++}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       __might_fault+0xc6/0x120 mm/memory.c:6387
       _inline_copy_to_user include/linux/uaccess.h:176 [inline]
       _copy_to_user+0x2a/0xb0 lib/usercopy.c:26
       copy_to_user include/linux/uaccess.h:209 [inline]
       fiemap_fill_next_extent+0x235/0x410 fs/ioctl.c:145
       ocfs2_fiemap+0x9f1/0xf80 fs/ocfs2/extent_map.c:796
       ioctl_fiemap fs/ioctl.c:220 [inline]
       do_vfs_ioctl+0x1c07/0x2e50 fs/ioctl.c:841
       __do_sys_ioctl fs/ioctl.c:905 [inline]
       __se_sys_ioctl+0x81/0x170 fs/ioctl.c:893
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&oi->ip_alloc_sem){++++}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3133 [inline]
       check_prevs_add kernel/locking/lockdep.c:3252 [inline]
       validate_chain+0x18e0/0x5900 kernel/locking/lockdep.c:3868
       __lock_acquire+0x137a/0x2040 kernel/locking/lockdep.c:5142
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       down_write+0x99/0x220 kernel/locking/rwsem.c:1579
       ocfs2_page_mkwrite+0x347/0xed0 fs/ocfs2/mmap.c:142
       do_page_mkwrite+0x19b/0x480 mm/memory.c:3142
       wp_page_shared mm/memory.c:3545 [inline]
       do_wp_page+0x23d9/0x52f0 mm/memory.c:3695
       handle_pte_fault+0x115a/0x6fc0 mm/memory.c:5537
       __handle_mm_fault mm/memory.c:5664 [inline]
       handle_mm_fault+0x1109/0x1bc0 mm/memory.c:5832
       do_user_addr_fault arch/x86/mm/fault.c:1389 [inline]
       handle_page_fault arch/x86/mm/fault.c:1481 [inline]
       exc_page_fault+0x2b9/0x8c0 arch/x86/mm/fault.c:1539
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
       rep_movs_alternative+0x4a/0x70 arch/x86/lib/copy_user_64.S:65
       copy_user_generic arch/x86/include/asm/uaccess_64.h:110 [inline]
       raw_copy_to_user arch/x86/include/asm/uaccess_64.h:131 [inline]
       copy_to_user_iter lib/iov_iter.c:25 [inline]
       iterate_ubuf include/linux/iov_iter.h:29 [inline]
       iterate_and_advance2 include/linux/iov_iter.h:245 [inline]
       iterate_and_advance include/linux/iov_iter.h:271 [inline]
       _copy_to_iter+0x26b/0x1960 lib/iov_iter.c:185
       copy_to_iter include/linux/uio.h:196 [inline]
       get_random_bytes_user+0x1e5/0x420 drivers/char/random.c:464
       __do_sys_getrandom drivers/char/random.c:1406 [inline]
       __se_sys_getrandom drivers/char/random.c:1380 [inline]
       __x64_sys_getrandom+0x152/0x250 drivers/char/random.c:1380
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &oi->ip_alloc_sem --> &mm->mmap_lock --> sb_pagefaults

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(sb_pagefaults);
                               lock(&mm->mmap_lock);
                               lock(sb_pagefaults);
  lock(&oi->ip_alloc_sem);

 *** DEADLOCK ***

2 locks held by syz.0.0/5113:
 #0: ffff888040731e18 (&mm->mmap_lock){++++}-{3:3}, at: mmap_read_trylock include/linux/mmap_lock.h:163 [inline]
 #0: ffff888040731e18 (&mm->mmap_lock){++++}-{3:3}, at: get_mmap_lock_carefully mm/memory.c:5869 [inline]
 #0: ffff888040731e18 (&mm->mmap_lock){++++}-{3:3}, at: lock_mm_and_find_vma+0x32/0x2f0 mm/memory.c:5929
 #1: ffff88804ac2e518 (sb_pagefaults){.+.+}-{0:0}, at: do_page_mkwrite+0x19b/0x480 mm/memory.c:3142

stack backtrace:
CPU: 0 UID: 0 PID: 5113 Comm: syz.0.0 Not tainted 6.11.0-rc7-syzkaller-00020-g8d8d276ba2fb #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:93 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:119
 check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2186
 check_prev_add kernel/locking/lockdep.c:3133 [inline]
 check_prevs_add kernel/locking/lockdep.c:3252 [inline]
 validate_chain+0x18e0/0x5900 kernel/locking/lockdep.c:3868
 __lock_acquire+0x137a/0x2040 kernel/locking/lockdep.c:5142
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
 down_write+0x99/0x220 kernel/locking/rwsem.c:1579
 ocfs2_page_mkwrite+0x347/0xed0 fs/ocfs2/mmap.c:142
 do_page_mkwrite+0x19b/0x480 mm/memory.c:3142
 wp_page_shared mm/memory.c:3545 [inline]
 do_wp_page+0x23d9/0x52f0 mm/memory.c:3695
 handle_pte_fault+0x115a/0x6fc0 mm/memory.c:5537
 __handle_mm_fault mm/memory.c:5664 [inline]
 handle_mm_fault+0x1109/0x1bc0 mm/memory.c:5832
 do_user_addr_fault arch/x86/mm/fault.c:1389 [inline]
 handle_page_fault arch/x86/mm/fault.c:1481 [inline]
 exc_page_fault+0x2b9/0x8c0 arch/x86/mm/fault.c:1539
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
RIP: 0010:rep_movs_alternative+0x4a/0x70 arch/x86/lib/copy_user_64.S:71
Code: 75 f1 c3 cc cc cc cc 66 0f 1f 84 00 00 00 00 00 48 8b 06 48 89 07 48 83 c6 08 48 83 c7 08 83 e9 08 74 df 83 f9 08 73 e8 eb c9 <f3> a4 c3 cc cc cc cc 48 89 c8 48 c1 e9 03 83 e0 07 f3 48 a5 89 c1
RSP: 0018:ffffc9000b62faf8 EFLAGS: 00050246
RAX: ffffffff84b01901 RBX: 0000000000000040 RCX: 0000000000000040
RDX: 0000000000000000 RSI: ffffc9000b62fd40 RDI: 0000000020000240
RBP: ffffc9000b62fc70 R08: ffffc9000b62fd7f R09: 1ffff920016c5faf
R10: dffffc0000000000 R11: fffff520016c5fb0 R12: 1ffff920016c5fc9
R13: 0000000020000240 R14: ffffc9000b62fe48 R15: ffffc9000b62fd40
 copy_user_generic arch/x86/include/asm/uaccess_64.h:110 [inline]
 raw_copy_to_user arch/x86/include/asm/uaccess_64.h:131 [inline]
 copy_to_user_iter lib/iov_iter.c:25 [inline]
 iterate_ubuf include/linux/iov_iter.h:29 [inline]
 iterate_and_advance2 include/linux/iov_iter.h:245 [inline]
 iterate_and_advance include/linux/iov_iter.h:271 [inline]
 _copy_to_iter+0x26b/0x1960 lib/iov_iter.c:185
 copy_to_iter include/linux/uio.h:196 [inline]
 get_random_bytes_user+0x1e5/0x420 drivers/char/random.c:464
 __do_sys_getrandom drivers/char/random.c:1406 [inline]
 __se_sys_getrandom drivers/char/random.c:1380 [inline]
 __x64_sys_getrandom+0x152/0x250 drivers/char/random.c:1380
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f375117def9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f3751e92038 EFLAGS: 00000246 ORIG_RAX: 000000000000013e
RAX: ffffffffffffffda RBX: 00007f3751335f80 RCX: 00007f375117def9
RDX: 0000000000000000 RSI: 00000000ffffff9a RDI: 0000000020000240
RBP: 00007f37511f09f6 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f3751335f80 R15: 00007fff8387faa8
 </TASK>
----------------
Code disassembly (best guess):
   0:	75 f1                	jne    0xfffffff3
   2:	c3                   	ret
   3:	cc                   	int3
   4:	cc                   	int3
   5:	cc                   	int3
   6:	cc                   	int3
   7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
   e:	00 00
  10:	48 8b 06             	mov    (%rsi),%rax
  13:	48 89 07             	mov    %rax,(%rdi)
  16:	48 83 c6 08          	add    $0x8,%rsi
  1a:	48 83 c7 08          	add    $0x8,%rdi
  1e:	83 e9 08             	sub    $0x8,%ecx
  21:	74 df                	je     0x2
  23:	83 f9 08             	cmp    $0x8,%ecx
  26:	73 e8                	jae    0x10
  28:	eb c9                	jmp    0xfffffff3
* 2a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi) <-- trapping instruction
  2c:	c3                   	ret
  2d:	cc                   	int3
  2e:	cc                   	int3
  2f:	cc                   	int3
  30:	cc                   	int3
  31:	48 89 c8             	mov    %rcx,%rax
  34:	48 c1 e9 03          	shr    $0x3,%rcx
  38:	83 e0 07             	and    $0x7,%eax
  3b:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  3e:	89 c1                	mov    %eax,%ecx


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
