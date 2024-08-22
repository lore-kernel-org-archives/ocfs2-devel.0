Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD11615749E
	for <ocfs2-devel@lists.linux.dev>; Thu, 22 Aug 2024 08:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724314285; cv=none; b=M48BSRfLz7jY5fUBScGeMZ8w8tOgFI63vCsAXiVQSV/3vy50oYCdm0pWajOy+PxdwmNnNfREM+wQMWn4OmxuTVdnJHS9LHZa0hW10w1vmwcPnTqVit9VddI2cAHdM1A4A7hQhMy++a0Q7+Fy0BW+1yfxhUwQ3dybLMKAcieDAOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724314285; c=relaxed/simple;
	bh=tVkdswe9xQVmknWB9VRAPZTc/NJtTaQcFvU1o/Sm3ro=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=PfkDeyaiNngA5wDNF1LVRUzmDxqIDB6rLIuqdw1pEJLp1TmT+6E0C/i1KUKdoFDI3bElVGbQKa2f08CUaaV4vlIaWCorhqYxYpto+fhlmyiYXzLDXbiMOg2RLzWZHBxyhr/kmETDpEiZ37Ixx/f0Anv9IMPQvs4NrAemvYVlCAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-81f8293cdb1so53067939f.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 22 Aug 2024 01:11:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724314283; x=1724919083;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8n6TomVcgKymYoaWYHCdRFzPAq8H4Qhml/yUWttNS9w=;
        b=FThe53/0owFVbfgEAHvBN+5WiJwWSbpv8rU7P+WM0arEhPktc8DptvICXpNBj48IyQ
         IDaiGK93lswhQr6yDXurPqgtJrLaxClz4WkZ3+Ao+1tbR1eAOZLX/Ns2ZYxk66/REnHq
         8yFsCewsTNDZNw+SVCjkgDWhrrcrUx8AOgMWWan6c6MKWe2HYT2WK7UDrgyX4TtmWh2T
         oyq6rao+/mpg9aV6OWdSp4xczQXfXXDaskphIA7ar8oF/ggJrL5lRr+QfSrX7G9dHDpX
         Q8l1I8JzwaiiGmqV9KnXxVWxhQXLUVSPEotExLOM2zNCNYS3jv0Rc6RmPmeJ8LzrGzQ5
         uLAg==
X-Forwarded-Encrypted: i=1; AJvYcCWdCN/6BDdxbGOtr+yWja7J4sU4nu6nMok6eqM3gAvhxHbSpcu15P6gi6tqMJfyQP5Dea0aSRkzLh4p1Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YwgU2LNPKTcoLu0nZKczUb9cuZlYNBYQtLrGxcIFVZIBO7pxwaq
	Nlys+UtXxCHCYPrbynScSf+A3aN9ssx48yx8wqHkoceR41DWyfZR7Jaz3L9Z0/Qxe/nE2szyvwM
	scjrgOcYBegc59jspk22mWRkNgpu6VpW0hjwrF5+NIEEDvGSiymJfXTs=
X-Google-Smtp-Source: AGHT+IGoqcoF3Dr/k+a7ZnoC5QQeN7XY6eTPsPVDTkUcCe91GvpszITyq7s+q+D4VWSfwIyCohK1TAMjpKf7XykmdD8cX5zGxmgv
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:8416:b0:4ce:54dc:fa44 with SMTP id
 8926c6da1cb9f-4ce62da0098mr199462173.1.1724314283016; Thu, 22 Aug 2024
 01:11:23 -0700 (PDT)
Date: Thu, 22 Aug 2024 01:11:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000052138306204134f2@google.com>
Subject: [syzbot] [ocfs2?] KASAN: use-after-free Read in ocfs2_claim_suballoc_bits
From: syzbot <syzbot+5054473a31f78f735416@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    b311c1b497e5 Merge tag '6.11-rc4-server-fixes' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1459247b980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=df2f0ed7e30a639d
dashboard link: https://syzkaller.appspot.com/bug?extid=5054473a31f78f735416
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=124009a7980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=112e6dd5980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-b311c1b4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/1c99fa48192f/vmlinux-b311c1b4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/16d5710a012a/bzImage-b311c1b4.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/1ed1386176c5/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5054473a31f78f735416@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
==================================================================
BUG: KASAN: slab-use-after-free in ocfs2_find_victim_chain fs/ocfs2/suballoc.c:1445 [inline]
BUG: KASAN: slab-use-after-free in ocfs2_claim_suballoc_bits+0x10d3/0x2570 fs/ocfs2/suballoc.c:1982
Read of size 4 at addr ffff888038568000 by task syz-executor335/5105

CPU: 0 UID: 0 PID: 5105 Comm: syz-executor335 Not tainted 6.11.0-rc4-syzkaller-00019-gb311c1b497e5 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:93 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:119
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 ocfs2_find_victim_chain fs/ocfs2/suballoc.c:1445 [inline]
 ocfs2_claim_suballoc_bits+0x10d3/0x2570 fs/ocfs2/suballoc.c:1982
 ocfs2_claim_metadata+0x16d/0x580 fs/ocfs2/suballoc.c:2057
 ocfs2_create_refcount_tree+0x699/0x15f0 fs/ocfs2/refcounttree.c:590
 ocfs2_reflink_remap_blocks+0x2f6/0x1f30 fs/ocfs2/refcounttree.c:4634
 ocfs2_remap_file_range+0x600/0x8e0 fs/ocfs2/file.c:2724
 vfs_copy_file_range+0xc1f/0x1530 fs/read_write.c:1522
 __do_sys_copy_file_range fs/read_write.c:1612 [inline]
 __se_sys_copy_file_range+0x3f2/0x5d0 fs/read_write.c:1575
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f73908ff1e9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 21 18 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe3ab025f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000146
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f73908ff1e9
RDX: 0000000000000004 RSI: 0000000000000000 RDI: 0000000000000006
RBP: 0000000000000000 R08: 0000000000000006 R09: 0000000000000000
R10: 00000000200000c0 R11: 0000000000000246 R12: 00007ffe3ab0262c
R13: 0000000000000001 R14: 431bde82d7b634db R15: 00007ffe3ab02660
 </TASK>

Allocated by task 5091:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 unpoison_slab_object mm/kasan/common.c:312 [inline]
 __kasan_slab_alloc+0x66/0x80 mm/kasan/common.c:338
 kasan_slab_alloc include/linux/kasan.h:201 [inline]
 slab_post_alloc_hook mm/slub.c:3988 [inline]
 slab_alloc_node mm/slub.c:4037 [inline]
 kmem_cache_alloc_noprof+0x135/0x2a0 mm/slub.c:4044
 vma_lock_alloc kernel/fork.c:445 [inline]
 vm_area_dup+0x61/0x290 kernel/fork.c:498
 dup_mmap kernel/fork.c:695 [inline]
 dup_mm kernel/fork.c:1672 [inline]
 copy_mm+0xc7b/0x1f30 kernel/fork.c:1721
 copy_process+0x187c/0x3e10 kernel/fork.c:2387
 kernel_clone+0x226/0x8f0 kernel/fork.c:2800
 __do_sys_clone kernel/fork.c:2943 [inline]
 __se_sys_clone kernel/fork.c:2927 [inline]
 __x64_sys_clone+0x258/0x2a0 kernel/fork.c:2927
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5093:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:579
 poison_slab_object+0xe0/0x150 mm/kasan/common.c:240
 __kasan_slab_free+0x37/0x60 mm/kasan/common.c:256
 kasan_slab_free include/linux/kasan.h:184 [inline]
 slab_free_hook mm/slub.c:2252 [inline]
 slab_free mm/slub.c:4473 [inline]
 kmem_cache_free+0x145/0x350 mm/slub.c:4548
 vma_lock_free kernel/fork.c:457 [inline]
 __vm_area_free+0xe3/0x110 kernel/fork.c:513
 remove_vma mm/mmap.c:187 [inline]
 exit_mmap+0x645/0xc80 mm/mmap.c:3436
 __mmput+0x115/0x390 kernel/fork.c:1345
 exec_mmap+0x680/0x710 fs/exec.c:1089
 begin_new_exec+0x12c6/0x2050 fs/exec.c:1355
 load_elf_binary+0x969/0x2680 fs/binfmt_elf.c:996
 search_binary_handler fs/exec.c:1827 [inline]
 exec_binprm fs/exec.c:1869 [inline]
 bprm_execve+0xaf8/0x1770 fs/exec.c:1920
 do_execveat_common+0x55f/0x6f0 fs/exec.c:2027
 do_execve fs/exec.c:2101 [inline]
 __do_sys_execve fs/exec.c:2177 [inline]
 __se_sys_execve fs/exec.c:2172 [inline]
 __x64_sys_execve+0x92/0xb0 fs/exec.c:2172
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888038568000
 which belongs to the cache vma_lock of size 152
The buggy address is located 0 bytes inside of
 freed 152-byte region [ffff888038568000, ffff888038568098)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x38568
flags: 0x4fff00000000000(node=1|zone=1|lastcpupid=0x7ff)
page_type: 0xfdffffff(slab)
raw: 04fff00000000000 ffff8880166fcc80 ffffea00006ec940 0000000000000002
raw: 0000000000000000 0000000000120012 00000001fdffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 5052, tgid 5052 (dhcpcd-run-hook), ts 70503623283, free_ts 70500820923
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
 vma_lock_alloc kernel/fork.c:445 [inline]
 vm_area_dup+0x61/0x290 kernel/fork.c:498
 dup_mmap kernel/fork.c:695 [inline]
 dup_mm kernel/fork.c:1672 [inline]
 copy_mm+0xc7b/0x1f30 kernel/fork.c:1721
 copy_process+0x187c/0x3e10 kernel/fork.c:2387
 kernel_clone+0x226/0x8f0 kernel/fork.c:2800
 __do_sys_clone kernel/fork.c:2943 [inline]
 __se_sys_clone kernel/fork.c:2927 [inline]
 __x64_sys_clone+0x258/0x2a0 kernel/fork.c:2927
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 5056 tgid 5056 stack trace:
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
 ffff888038567f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888038567f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff888038568000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff888038568080: fb fb fb fc fc fc fc fc fc fc fc fa fb fb fb fb
 ffff888038568100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc
==================================================================


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
