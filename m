Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542B2192B97
	for <ocfs2-devel@lists.linux.dev>; Thu, 12 Sep 2024 09:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726132893; cv=none; b=Rv8HNKeRshxX4AFczGJoZwtyMonW8SUpeo9kSLr37nzyH5DzGt8Rk/u4CFs3Nuc543omjAy7PRUnOYR633DcCEj/YvC+6WOSTVxLHtyeWuNuyORY3XcN82XGaHUSR8/RJ3YZNJDfBfv0g8/QTtVuKSG3xybhO1W+mAAnnQtsQTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726132893; c=relaxed/simple;
	bh=akTf7ryabJi+EOydiuI+e0lC9qa+g4OTwka/3VUu8/A=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ZX+2UtI7eT2a35qaE2jMQb8fdnZ4Z9yTtF4NReINXp3GzT+StnlHjsY6M4P/U5nHJEwWXu+kVXO/IzoJ6IN34Q5fASVLIKxj/aOEoyy3uEahbnolU3wK65JWwgAurXpaso/evaLXdR8ei1BTn2i8wXSRNLgmPl2CqrU4NYI8jGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-39f5605c674so12160745ab.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 12 Sep 2024 02:21:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726132890; x=1726737690;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O6TnpEc7v/Mea0Akm2u/BbGpFqmBFrKFb2fGYInzlJY=;
        b=lgojXMHA1dbKwtQ9PTVhbjpJhbHSvyKhSiVUCiX5bYr+GDxRfQEuhvZH1WDXgnkmjz
         rn0CKRlFjc8SaHFnV3KJF3LJh2BQVLTqJm8wzBb7hdHMLhnwIq8uTpyFlFqN2lkM2Dfz
         5mee2a69DeQE8bxXwer+yPQZkIh+rMOR3b9FRWr8LcDBEIq8In7OuTl50NRbV9wlWd8Q
         WFM/oH5kGKQYOTKdoOD9vntlHTSq2o0o3CLfnBh9MpPJpDiqReN9FZFn8iR7ZaorIPdr
         sZ+Ozfqek1+JCURY4OKk9UVnNpRbdG0ZGpXi4AVdP68vTis3/AHvpua+Vy5ZXfB/lcjm
         DSCA==
X-Forwarded-Encrypted: i=1; AJvYcCWZ6SmwXf8Bv9Iqgqmo0V40ax3iZZNIFkTBNq23tl1Am7x5QtC+6nNZGP4IIK4j2xBl0zG/Ug+kB5eWTg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxHMIzygTcDKV6snY7snh9ShhlGe+sZp3j8av2s5maZukmEpPn9
	LRZqd5zgS+2zGGD93kLCNCn0a+EY6wFRMaDON0f2SrL9JwPVow0I5ftvpueubbioJcfHwsjMyXF
	kbRZdRDq89fW2/wUynxt8xhih/f6pCuJtE496NddtBRzwyOAwnOshRCA=
X-Google-Smtp-Source: AGHT+IFfPw1Mrcs2bzR2K8vzGTdBd9zz1nwrUlZ9PNEF2WlofTnrrHk8KiiEmzuRRTLIXkJMCCv3gZ7NTqLmMuA3g3hnf6fMzzu4
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c0d:b0:39b:2ceb:1a23 with SMTP id
 e9e14a558f8ab-3a0848cb40fmr19924375ab.3.1726132890619; Thu, 12 Sep 2024
 02:21:30 -0700 (PDT)
Date: Thu, 12 Sep 2024 02:21:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c7e54f0621e8a14f@google.com>
Subject: [syzbot] [ocfs2?] KASAN: slab-use-after-free Read in ocfs2_fault
From: syzbot <syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    88fac17500f4 Merge tag 'fuse-fixes-6.11-rc7' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16f47d09980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=660f6eb11f9c7dc5
dashboard link: https://syzkaller.appspot.com/bug?extid=a49010a0e8fcdeea075f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-88fac175.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/de92cf928379/vmlinux-88fac175.xz
kernel image: https://storage.googleapis.com/syzbot-assets/253b0e12054b/bzImage-88fac175.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in ocfs2_fault+0xe9/0x3d0 fs/ocfs2/mmap.c:41
Read of size 8 at addr ffff888012015080 by task syz.0.0/5116

CPU: 0 UID: 0 PID: 5116 Comm: syz.0.0 Not tainted 6.11.0-rc6-syzkaller-00026-g88fac17500f4 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:93 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:119
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 ocfs2_fault+0xe9/0x3d0 fs/ocfs2/mmap.c:41
 __do_fault+0x135/0x460 mm/memory.c:4655
 do_read_fault mm/memory.c:5061 [inline]
 do_fault mm/memory.c:5191 [inline]
 do_pte_missing mm/memory.c:3947 [inline]
 handle_pte_fault+0x321f/0x6fc0 mm/memory.c:5521
 __handle_mm_fault mm/memory.c:5664 [inline]
 handle_mm_fault+0x1109/0x1bc0 mm/memory.c:5832
 faultin_page mm/gup.c:1194 [inline]
 __get_user_pages+0x6ec/0x16a0 mm/gup.c:1493
 populate_vma_page_range+0x264/0x330 mm/gup.c:1932
 __mm_populate+0x27a/0x460 mm/gup.c:2035
 mm_populate include/linux/mm.h:3430 [inline]
 vm_mmap_pgoff+0x2c3/0x3d0 mm/util.c:593
 ksys_mmap_pgoff+0x4f1/0x720 mm/mmap.c:1514
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3a03b7cef9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f3a0496f038 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 00007f3a03d36058 RCX: 00007f3a03b7cef9
RDX: 0000000000000002 RSI: 0000000000b36000 RDI: 0000000020000000
RBP: 00007f3a03bef01e R08: 000000000000000a R09: 0000000000000000
R10: 0000000000028011 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f3a03d36058 R15: 00007fffb8722f38
 </TASK>

Allocated by task 5116:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 unpoison_slab_object mm/kasan/common.c:312 [inline]
 __kasan_slab_alloc+0x66/0x80 mm/kasan/common.c:338
 kasan_slab_alloc include/linux/kasan.h:201 [inline]
 slab_post_alloc_hook mm/slub.c:3988 [inline]
 slab_alloc_node mm/slub.c:4037 [inline]
 kmem_cache_alloc_noprof+0x135/0x2a0 mm/slub.c:4044
 vm_area_alloc+0x24/0x1d0 kernel/fork.c:471
 mmap_region+0xc3d/0x2090 mm/mmap.c:2944
 do_mmap+0x8f9/0x1010 mm/mmap.c:1468
 vm_mmap_pgoff+0x1dd/0x3d0 mm/util.c:588
 ksys_mmap_pgoff+0x4f1/0x720 mm/mmap.c:1514
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 16:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:579
 poison_slab_object+0xe0/0x150 mm/kasan/common.c:240
 __kasan_slab_free+0x37/0x60 mm/kasan/common.c:256
 kasan_slab_free include/linux/kasan.h:184 [inline]
 slab_free_hook mm/slub.c:2252 [inline]
 slab_free mm/slub.c:4473 [inline]
 kmem_cache_free+0x145/0x350 mm/slub.c:4548
 rcu_do_batch kernel/rcu/tree.c:2569 [inline]
 rcu_core+0xafd/0x1830 kernel/rcu/tree.c:2843
 handle_softirqs+0x2c4/0x970 kernel/softirq.c:554
 run_ksoftirqd+0xca/0x130 kernel/softirq.c:928
 smpboot_thread_fn+0x544/0xa30 kernel/smpboot.c:164
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Last potentially related work creation:
 kasan_save_stack+0x3f/0x60 mm/kasan/common.c:47
 __kasan_record_aux_stack+0xac/0xc0 mm/kasan/generic.c:541
 __call_rcu_common kernel/rcu/tree.c:3106 [inline]
 call_rcu+0x167/0xa70 kernel/rcu/tree.c:3210
 remove_vma mm/mmap.c:189 [inline]
 remove_mt mm/mmap.c:2415 [inline]
 do_vmi_align_munmap+0x155c/0x18c0 mm/mmap.c:2758
 do_vmi_munmap+0x261/0x2f0 mm/mmap.c:2830
 mmap_region+0x72f/0x2090 mm/mmap.c:2881
 do_mmap+0x8f9/0x1010 mm/mmap.c:1468
 vm_mmap_pgoff+0x1dd/0x3d0 mm/util.c:588
 ksys_mmap_pgoff+0x4f1/0x720 mm/mmap.c:1514
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888012015000
 which belongs to the cache vm_area_struct of size 184
The buggy address is located 128 bytes inside of
 freed 184-byte region [ffff888012015000, ffff8880120150b8)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x12015
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
page_type: 0xfdffffff(slab)
raw: 00fff00000000000 ffff88801be90b40 dead000000000100 dead000000000122
raw: 0000000000000000 0000000000100010 00000001fdffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 4814, tgid 4814 (dhcpcd), ts 49914646081, free_ts 49681178375
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1493
 prep_new_page mm/page_alloc.c:1501 [inline]
 get_page_from_freelist+0x2e4c/0x2f10 mm/page_alloc.c:3439
 __alloc_pages_noprof+0x256/0x6c0 mm/page_alloc.c:4695
 __alloc_pages_node_noprof include/linux/gfp.h:269 [inline]
 alloc_pages_node_noprof include/linux/gfp.h:296 [inline]
 alloc_slab_page+0x5f/0x120 mm/slub.c:2321
 allocate_slab+0x5a/0x2f0 mm/slub.c:2484
 new_slab mm/slub.c:2537 [inline]
 ___slab_alloc+0xcd1/0x14b0 mm/slub.c:3723
 __slab_alloc+0x58/0xa0 mm/slub.c:3813
 __slab_alloc_node mm/slub.c:3866 [inline]
 slab_alloc_node mm/slub.c:4025 [inline]
 kmem_cache_alloc_noprof+0x1c1/0x2a0 mm/slub.c:4044
 vm_area_dup+0x27/0x290 kernel/fork.c:486
 dup_mmap kernel/fork.c:695 [inline]
 dup_mm kernel/fork.c:1672 [inline]
 copy_mm+0xc7b/0x1f30 kernel/fork.c:1721
 copy_process+0x187a/0x3dc0 kernel/fork.c:2374
 kernel_clone+0x226/0x8f0 kernel/fork.c:2781
 __do_sys_clone kernel/fork.c:2924 [inline]
 __se_sys_clone kernel/fork.c:2908 [inline]
 __x64_sys_clone+0x258/0x2a0 kernel/fork.c:2908
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 4895 tgid 4895 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1094 [inline]
 free_unref_folios+0x103a/0x1b00 mm/page_alloc.c:2660
 folios_put_refs+0x76e/0x860 mm/swap.c:1039
 free_pages_and_swap_cache+0x5c8/0x690 mm/swap_state.c:335
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:136 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:149 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:366 [inline]
 tlb_flush_mmu+0x3a3/0x680 mm/mmu_gather.c:373
 tlb_finish_mmu+0xd4/0x200 mm/mmu_gather.c:465
 exit_mmap+0x44f/0xc80 mm/mmap.c:3425
 __mmput+0x115/0x390 kernel/fork.c:1345
 exit_mm+0x220/0x310 kernel/exit.c:571
 do_exit+0x9b2/0x27f0 kernel/exit.c:869
 do_group_exit+0x207/0x2c0 kernel/exit.c:1031
 __do_sys_exit_group kernel/exit.c:1042 [inline]
 __se_sys_exit_group kernel/exit.c:1040 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1040
 x64_sys_call+0x2634/0x2640 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888012014f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888012015000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888012015080: fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc fa
                   ^
 ffff888012015100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888012015180: fb fb fb fb fb fb fc fc fc fc fc fc fc fc 00 00
==================================================================


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
