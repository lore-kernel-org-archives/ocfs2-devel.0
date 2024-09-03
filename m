Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4AA1D79BF
	for <ocfs2-devel@lists.linux.dev>; Tue,  3 Sep 2024 20:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725396205; cv=none; b=GfaemoUWpzbPcH5QL1YXs4zLRGh1ZgvfxO8kRvKUTddlr6YOLQejtzlVRY8/DJpT8EwOikMM7FXUKm9On5uN/Mt1SAw4FGiVKWIpPZP+6p2uhBsSsJ/27oKLc9Lvm6ifeBUMiiW8QvM1fXKQEcu9WVPqqWYpkYg9MRZsi3eu1qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725396205; c=relaxed/simple;
	bh=ICPaKamSOmGmVVhHJ6kgld+RE3iX/zQONspYntYjdLo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=WuVAsGBnpx8Gp74EDwx5t8g3QoypBNLpdC2r//BaGXYG1ZIHcH6JUV2PmQkmlyBzaX7TEUlnEifQOPyNdyZwsbPkLZe76Cm/Ew9WMWT0ER84Ta5omGCCk592TW8lj0PnQSNHiQZHrSpE2YfjHDxQc5UYD05xlGbMOI+ip8vXqMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-39f5605c674so39979235ab.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 03 Sep 2024 13:43:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725396203; x=1726001003;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HHhZGzUkVK4JwTPspm9AtDp6CUzqqv0WJp3dEPChI1k=;
        b=O+9kBCDQddqGSrPgXVnmx4K2+516GMY2K7Pmm3ZK47Ot4jQTxsTmW8RyEuaKDlwVEx
         J7UDfO/t7nVOjF8v+PuSVLv6AtExrYnuxR8XRTFfZpXtlUHYGVDnovHhXraP4vvGDuZH
         WhzHwEBqKz6OWed9jidOulTcaaynCGVOjb54s1b81VM+mkr8wx384fJF2V8UKr0pUGS4
         MwvNGwUbeKr1qnLB1s0m9ZRPDGg7xPlBspoLi7d6a5sTe230qsT1yg2Qhm1dKEhFnuWd
         UiuJwtaVprxVo+WzClRKjKO2DmYOHnOSRcTNCV+TSvOwFI1CDJ6ZfStLK7j6Kr0eb3Rj
         2XkQ==
X-Forwarded-Encrypted: i=1; AJvYcCUTj2VQrEQjEBv9x3LrAQ7bUXxXZmJhrcIBA+yMKgZ9MTA0QUeKExZqlPcZRcb7Fgy7z+XYpiuIyqSvXg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzh9Jw7JPzE0055uXwngwhfdy8BA7bnfWiob91BTrQtYTUBOFij
	2s26mpVrQcBMgq/8zjqGNhZGIJ7LDOK1d18stWOOsRYzyHK2+39KMtAEgBd8WvsoM/fnOUJROJn
	dBATJh2OR7WjutzlwOYMBG+Jrc0TE9SRt5sd+tuN1QJg9whm6qaAfC7g=
X-Google-Smtp-Source: AGHT+IE0zB3OncRdcb9/kKUQp8pRN4II6ciEuvM1S5T1Xt5+wwtB1f7i3h36hW3pfhV+TGlyqjwA1HRb+obEZXA5P+fx0vqKjuSV
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:8611:b0:4bd:4861:d7f8 with SMTP id
 8926c6da1cb9f-4d017e91f4bmr810462173.4.1725396203294; Tue, 03 Sep 2024
 13:43:23 -0700 (PDT)
Date: Tue, 03 Sep 2024 13:43:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cb688206213d1bda@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_fiemap
From: syzbot <syzbot+ca440b457d21568f8021@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    6cd90e5ea72f Merge branch 'fixes' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12c6b543980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=714e8373ca1f0bb3
dashboard link: https://syzkaller.appspot.com/bug?extid=ca440b457d21568f8021
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-6cd90e5e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5118b413b1ad/vmlinux-6cd90e5e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6a2ee4a9243a/bzImage-6cd90e5e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ca440b457d21568f8021@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
=======================================================
WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
6.11.0-rc5-syzkaller-00316-g6cd90e5ea72f #0 Not tainted
------------------------------------------------------
syz.0.0/5152 is trying to acquire lock:
ffff888035ca6a18 (&mm->mmap_lock){++++}-{3:3}, at: __might_fault+0xaa/0x120 mm/memory.c:6387

but task is already holding lock:
ffff888012decda0 (&oi->ip_alloc_sem){++++}-{3:3}, at: ocfs2_fiemap+0x377/0xf80 fs/ocfs2/extent_map.c:755

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&oi->ip_alloc_sem){++++}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       down_write+0x99/0x220 kernel/locking/rwsem.c:1579
       ocfs2_page_mkwrite+0x347/0xed0 fs/ocfs2/mmap.c:142
       do_page_mkwrite+0x19b/0x480 mm/memory.c:3142
       do_shared_fault mm/memory.c:5133 [inline]
       do_fault mm/memory.c:5195 [inline]
       do_pte_missing mm/memory.c:3947 [inline]
       handle_pte_fault+0x126b/0x6fc0 mm/memory.c:5521
       __handle_mm_fault mm/memory.c:5664 [inline]
       handle_mm_fault+0x1109/0x1bc0 mm/memory.c:5832
       do_user_addr_fault arch/x86/mm/fault.c:1389 [inline]
       handle_page_fault arch/x86/mm/fault.c:1481 [inline]
       exc_page_fault+0x2b9/0x8c0 arch/x86/mm/fault.c:1539
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623

-> #1 (sb_pagefaults){.+.+}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1676 [inline]
       sb_start_pagefault include/linux/fs.h:1841 [inline]
       ocfs2_page_mkwrite+0x223/0xed0 fs/ocfs2/mmap.c:122
       do_page_mkwrite+0x19b/0x480 mm/memory.c:3142
       do_shared_fault mm/memory.c:5133 [inline]
       do_fault mm/memory.c:5195 [inline]
       do_pte_missing mm/memory.c:3947 [inline]
       handle_pte_fault+0x126b/0x6fc0 mm/memory.c:5521
       __handle_mm_fault mm/memory.c:5664 [inline]
       handle_mm_fault+0x1109/0x1bc0 mm/memory.c:5832
       do_user_addr_fault arch/x86/mm/fault.c:1389 [inline]
       handle_page_fault arch/x86/mm/fault.c:1481 [inline]
       exc_page_fault+0x2b9/0x8c0 arch/x86/mm/fault.c:1539
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623

-> #0 (&mm->mmap_lock){++++}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3133 [inline]
       check_prevs_add kernel/locking/lockdep.c:3252 [inline]
       validate_chain+0x18e0/0x5900 kernel/locking/lockdep.c:3868
       __lock_acquire+0x137a/0x2040 kernel/locking/lockdep.c:5142
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

other info that might help us debug this:

Chain exists of:
  &mm->mmap_lock --> sb_pagefaults --> &oi->ip_alloc_sem

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(&oi->ip_alloc_sem);
                               lock(sb_pagefaults);
                               lock(&oi->ip_alloc_sem);
  rlock(&mm->mmap_lock);

 *** DEADLOCK ***

1 lock held by syz.0.0/5152:
 #0: ffff888012decda0 (&oi->ip_alloc_sem){++++}-{3:3}, at: ocfs2_fiemap+0x377/0xf80 fs/ocfs2/extent_map.c:755

stack backtrace:
CPU: 0 UID: 0 PID: 5152 Comm: syz.0.0 Not tainted 6.11.0-rc5-syzkaller-00316-g6cd90e5ea72f #0
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
RIP: 0033:0x7fa8b7f79eb9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa8b8cc7038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fa8b8115f80 RCX: 00007fa8b7f79eb9
RDX: 00000000200001c0 RSI: 00000000c020660b RDI: 0000000000000005
RBP: 00007fa8b7fe793e R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007fa8b8115f80 R15: 00007ffc6d1b5088
 </TASK>


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
