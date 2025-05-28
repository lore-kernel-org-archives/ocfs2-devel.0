Received: from mail-qk1-f205.google.com (mail-qk1-f205.google.com [209.85.222.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDFE2853E5
	for <ocfs2-devel@lists.linux.dev>; Wed, 28 May 2025 14:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748443724; cv=none; b=uAqOGLBsDy0Y2mn11JQ5wPSVi00Umr8obVen9nAI20U7ScKZA7yqjcOTnR1gnwXUaQl57rvsugFzZYFGnYgAtBid3cpl0VzQsTu/MUFhRqRJ7LUUbstXsGHnhsDQuAvfOJKqydbI72lUVfHZL/biDq4C94FCKIFadeLrSzBThZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748443724; c=relaxed/simple;
	bh=aSQkgtbaIw4kmPNazY/4wGXVxEjN0zpCY0z42x76mdQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=JrWhHcX3EY2c06GxrR5XdjAgDtwrY7mVd1Zr5FMtAllAMl+1JsxcczcjXhmFjV0bO/mGeTy4OM6BK2OOc6KYhgO/OrrYfHrQWmGFYNndfmT5bVeqvjy0b8w7HQA1Avs3BhmSS0EEamce22YMtHIMrv910V92zPGbTPpcTvHv1yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.222.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-qk1-f205.google.com with SMTP id af79cd13be357-7c579d37eeeso595781285a.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 28 May 2025 07:48:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748443721; x=1749048521;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4cx32Sj3K02lxj9Rd2CNjxbRCZi+yI5OJOD2QwS+p60=;
        b=OoHBcWFuWUaeUtDxKvjkW+C91t8A2I0P05MyH1GM1gDFlk9qIGicDS9IgLEdujonK4
         ApbXN1Pia3Dk9ATKVe9XEptvJPdT0n1qSMkHhPDD1/FaeLoYZOueV222UNWPrMv9bV/L
         Usmkb8K49CGfUG6f6Q7BgrLspNygjzg4dwymqw3tSbNzmPoAezvzqAMAezUWzFGvdOF7
         3qmGrmUkaZGfqTAPP4faZsaoaINfylbyCMolVyUNz7yXWZwozVi+kBb+l+TCCXutl15c
         JBGiXKxFn6oocECisuIK+04uURV50lJlBrPVHlWfL+Eg9WdbYfn58VvqAMVdfr5pzGDW
         tWyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKLTc+wYGqOntYYlIodqEolsuR5MaBft9rBvNLb13iV5uSnP/4TUjK+PJkXoRbqaTHVFOwlUCMTc/PqA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzVIspTANPC4IxgPpAdba/8136EuOvIgL2jlIN6kxA/iWPskQZd
	Xkfl3Zy0rkQfJxdaxWwas69idoz6ZghY4+1DrrmsJcf+0M7ZrcnlazD1uemQQE785oI7CMZtQdK
	Uah4txID7fGUiDilHLJKbYZDINgE7e/JlQNkblmJUqcN8D/fyGo8/CIXvGSY=
X-Google-Smtp-Source: AGHT+IHyNdUnFlDInVGodrS7ppM23zNXxx5vyd1O1xHzhAZF56lKu3J3ZIGJXBCUr2NKQDLaFOTt0pjj+esfFRASa9ROXT3BAyXl
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:b94:b0:86a:93c:5548 with SMTP id
 ca18e2360f4ac-86cbb7be930mr2044389139f.3.1748443711224; Wed, 28 May 2025
 07:48:31 -0700 (PDT)
Date: Wed, 28 May 2025 07:48:31 -0700
In-Reply-To: <67ae02b1.050a0220.110943.005e.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6837223f.a70a0220.253bc2.00d1.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] possible deadlock in ocfs2_read_folio
From: syzbot <syzbot+bd316bb736c7dc2f318e@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    c89756bcf406 Merge tag 'pm-6.16-rc1' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1201f170580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ded97a85afe9a6c8
dashboard link: https://syzkaller.appspot.com/bug?extid=bd316bb736c7dc2f318e
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=113ae6d4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12b01df4580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-c89756bc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b21d74e73303/vmlinux-c89756bc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b778ededeb75/bzImage-c89756bc.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/6ca75df782b2/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=14b01df4580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bd316bb736c7dc2f318e@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.15.0-syzkaller-03478-gc89756bcf406 #0 Not tainted
------------------------------------------------------
syz-executor341/5408 is trying to acquire lock:
ffff888046e7a2e0 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_read_folio+0x353/0x970 fs/ocfs2/aops.c:287

but task is already holding lock:
ffff888046e7a7e0 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:932 [inline]
ffff888046e7a7e0 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: filemap_fault+0x546/0x1200 mm/filemap.c:3391

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (mapping.invalidate_lock#3){.+.+}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5871
       down_read+0x46/0x2e0 kernel/locking/rwsem.c:1524
       filemap_invalidate_lock_shared include/linux/fs.h:932 [inline]
       filemap_fault+0x546/0x1200 mm/filemap.c:3391
       ocfs2_fault+0xa4/0x3f0 fs/ocfs2/mmap.c:38
       __do_fault+0x138/0x390 mm/memory.c:5098
       do_read_fault mm/memory.c:5518 [inline]
       do_fault mm/memory.c:5652 [inline]
       do_pte_missing mm/memory.c:4160 [inline]
       handle_pte_fault mm/memory.c:5997 [inline]
       __handle_mm_fault+0x37c5/0x55e0 mm/memory.c:6140
       handle_mm_fault+0x3f6/0x8c0 mm/memory.c:6309
       faultin_page mm/gup.c:1193 [inline]
       __get_user_pages+0x1a78/0x30c0 mm/gup.c:1491
       populate_vma_page_range+0x26b/0x340 mm/gup.c:1929
       __mm_populate+0x24c/0x380 mm/gup.c:2032
       mm_populate include/linux/mm.h:3487 [inline]
       vm_mmap_pgoff+0x3f0/0x4c0 mm/util.c:584
       ksys_mmap_pgoff+0x51f/0x760 mm/mmap.c:607
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&mm->mmap_lock){++++}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5871
       __might_fault+0xcc/0x130 mm/memory.c:7151
       _inline_copy_to_user include/linux/uaccess.h:192 [inline]
       _copy_to_user+0x2c/0xb0 lib/usercopy.c:26
       copy_to_user include/linux/uaccess.h:225 [inline]
       fiemap_fill_next_extent+0x1c0/0x390 fs/ioctl.c:145
       ocfs2_fiemap+0x888/0xc90 fs/ocfs2/extent_map.c:806
       ioctl_fiemap fs/ioctl.c:220 [inline]
       do_vfs_ioctl+0x16d3/0x1990 fs/ioctl.c:841
       __do_sys_ioctl fs/ioctl.c:905 [inline]
       __se_sys_ioctl+0x82/0x170 fs/ioctl.c:893
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3168 [inline]
       check_prevs_add kernel/locking/lockdep.c:3287 [inline]
       validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3911
       __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5240
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5871
       down_read+0x46/0x2e0 kernel/locking/rwsem.c:1524
       ocfs2_read_folio+0x353/0x970 fs/ocfs2/aops.c:287
       filemap_read_folio+0x117/0x380 mm/filemap.c:2401
       filemap_fault+0xb16/0x1200 mm/filemap.c:3495
       ocfs2_fault+0xa4/0x3f0 fs/ocfs2/mmap.c:38
       __do_fault+0x138/0x390 mm/memory.c:5098
       do_read_fault mm/memory.c:5518 [inline]
       do_fault mm/memory.c:5652 [inline]
       do_pte_missing mm/memory.c:4160 [inline]
       handle_pte_fault mm/memory.c:5997 [inline]
       __handle_mm_fault+0x37c5/0x55e0 mm/memory.c:6140
       handle_mm_fault+0x3f6/0x8c0 mm/memory.c:6309
       faultin_page mm/gup.c:1193 [inline]
       __get_user_pages+0x1a78/0x30c0 mm/gup.c:1491
       populate_vma_page_range+0x26b/0x340 mm/gup.c:1929
       __mm_populate+0x24c/0x380 mm/gup.c:2032
       mm_populate include/linux/mm.h:3487 [inline]
       vm_mmap_pgoff+0x3f0/0x4c0 mm/util.c:584
       ksys_mmap_pgoff+0x51f/0x760 mm/mmap.c:607
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &ocfs2_file_ip_alloc_sem_key --> &mm->mmap_lock --> mapping.invalidate_lock#3

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(mapping.invalidate_lock#3);
                               lock(&mm->mmap_lock);
                               lock(mapping.invalidate_lock#3);
  rlock(&ocfs2_file_ip_alloc_sem_key);

 *** DEADLOCK ***

1 lock held by syz-executor341/5408:
 #0: ffff888046e7a7e0 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:932 [inline]
 #0: ffff888046e7a7e0 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: filemap_fault+0x546/0x1200 mm/filemap.c:3391

stack backtrace:
CPU: 0 UID: 0 PID: 5408 Comm: syz-executor341 Not tainted 6.15.0-syzkaller-03478-gc89756bcf406 #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_circular_bug+0x2ee/0x310 kernel/locking/lockdep.c:2046
 check_noncircular+0x134/0x160 kernel/locking/lockdep.c:2178
 check_prev_add kernel/locking/lockdep.c:3168 [inline]
 check_prevs_add kernel/locking/lockdep.c:3287 [inline]
 validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3911
 __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5240
 lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5871
 down_read+0x46/0x2e0 kernel/locking/rwsem.c:1524
 ocfs2_read_folio+0x353/0x970 fs/ocfs2/aops.c:287
 filemap_read_folio+0x117/0x380 mm/filemap.c:2401
 filemap_fault+0xb16/0x1200 mm/filemap.c:3495
 ocfs2_fault+0xa4/0x3f0 fs/ocfs2/mmap.c:38
 __do_fault+0x138/0x390 mm/memory.c:5098
 do_read_fault mm/memory.c:5518 [inline]
 do_fault mm/memory.c:5652 [inline]
 do_pte_missing mm/memory.c:4160 [inline]
 handle_pte_fault mm/memory.c:5997 [inline]
 __handle_mm_fault+0x37c5/0x55e0 mm/memory.c:6140
 handle_mm_fault+0x3f6/0x8c0 mm/memory.c:6309
 faultin_page mm/gup.c:1193 [inline]
 __get_user_pages+0x1a78/0x30c0 mm/gup.c:1491
 populate_vma_page_range+0x26b/0x340 mm/gup.c:1929
 __mm_populate+0x24c/0x380 mm/gup.c:2032
 mm_populate include/linux/mm.h:3487 [inline]
 vm_mmap_pgoff+0x3f0/0x4c0 mm/util.c:584
 ksys_mmap_pgoff+0x51f/0x760 mm/mmap.c:607
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1267d03dd9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 18 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1267c97208 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 00007f1267d90718 RCX: 00007f1267d03dd9
RDX: 0000000001000003 RSI: 0000000000b36000 RDI: 0000200000000000
RBP: 00007f1267d90710 R08: 0000000000000006 R09: 0000000000000000
R10: 0000000000028011 R11: 0000000000000246 R12: 00007f1267d5d624
R13: 5bf000f24f5ebbca R14: 0000200000000280 R15: 0000200000000000
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
