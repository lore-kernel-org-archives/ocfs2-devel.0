Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EC318A922
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 Nov 2024 09:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732787064; cv=none; b=sUK8QoViT13SspRBJtfEVI2UxNFjaKB9CtyC4ZGiacv/1lnsDxHdyzD2qLYlSPxtVgtS/lR4wMWj3EVk/D4ftd+XB33p2++/aVKUW3W0h1Ko/TXww1oATY9/7WoQayKBW5UnLABfBMvW2uxP3IETqm5D5m2FTq4vxHPPbMZKeZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732787064; c=relaxed/simple;
	bh=Mzx7lBXglZpnjqm8JI51b2nRkbAhB+vlHrQFuUhWCtA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Ud6kXKmtyGM5sQttr4EZZ7qVLjf6J5ebRpIUhmIrwGKuqJcHBIDL7+nLvy3ODZYvjwDYCsX7vnqMuSXLhzTv+2PCcea1uOi+NK1Z54ee7rAHd5iyh7wrnUMBMZjP5IACc5ff/p+RsCnLlGJnY6r3MH5f9qZSfWoyt5CmddxNXIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a78421a2e1so6029445ab.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 28 Nov 2024 01:44:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732787061; x=1733391861;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=llL0BbO7X1MaDWARYJWLSps5jkKt7gspEfHo8uKEfLc=;
        b=VVF50vT1ysTNK9FaklfKSzQBbO3VyuTrNmnCBLSwoZkUwgka5QdRLT5+DUHCmEou1z
         PWXMRKdXqTi8tyE/0y327g2KWPf8Ft872TbsLhGCw90tU5MRhB3QCZnImloJt7G6wbt/
         Flx7pCj0VauPWHeBM1myOAW1lqfZt6qn3hGyI72iGCLD0FrVCI9Ow5qlGRol1jdI3SPd
         cfa6ifU11W9vRw3wT+ALSdHF1CpDET+zZYFsz6shXLBxdJ2E0iXz+DPWIgoZaQqrnvrq
         cEhC26DDWe61kxpoK7kBAJv+oFlnUzUE2HX9VCuOQHIxguoC6VlTexTSWdh1nE/zyX8B
         vMkQ==
X-Forwarded-Encrypted: i=1; AJvYcCXu6wIq6wih6Qz9Hl1MbT8NmNwaJn3SqsqlhDJNj7LWWfGQT6qRu9emUqtQ86P76kZ5ZU/dqi3XaGvXtQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxM1w3Tb+lL6hVxvKeh6T5GiSF5ypPIOfLhlURSMyMfKScQOVYC
	QkWIY8C8E3eELlO6s0FwSI1iTUEI7X+i2xZWTjMZU42dy3lEH+F/PTOx0kP6JOCfuykLgL3PzqX
	A3Ys1nrZfT9akD60OF6V20+4ja8FQnEjCokK1zd992urvumhKkuTwAFY=
X-Google-Smtp-Source: AGHT+IGOtTtrRJqhtjzWWVPBKJ54ycG+gBfcBWkZt9l7FAd9zlSfTT8QYcYraSQxBia6Dp6JyViR4tWeNy4Yte44hF8v+1T5X0kM
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:cdab:0:b0:3a7:c32f:be58 with SMTP id
 e9e14a558f8ab-3a7c557c7d1mr75361355ab.13.1732787061675; Thu, 28 Nov 2024
 01:44:21 -0800 (PST)
Date: Thu, 28 Nov 2024 01:44:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67483b75.050a0220.253251.007c.GAE@google.com>
Subject: [syzbot] [ocfs2?] KASAN: slab-out-of-bounds Read in ocfs2_dx_dir_lookup_rec
From: syzbot <syzbot+20282c1b2184a857ac4c@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2f87d0916ce0 Merge tag 'trace-ringbuffer-v6.12-rc3' of git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14ec545f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cfbd94c114a3d407
dashboard link: https://syzkaller.appspot.com/bug?extid=20282c1b2184a857ac4c
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-2f87d091.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2704ba6867a8/vmlinux-2f87d091.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9f7121fd532b/bzImage-2f87d091.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+20282c1b2184a857ac4c@syzkaller.appspotmail.com

loop0: detected capacity change from 32768 to 32767
==================================================================
BUG: KASAN: slab-out-of-bounds in ocfs2_dx_dir_lookup_rec+0x206/0x810 fs/ocfs2/dir.c:805
Read of size 4 at addr ffff88801181b2c0 by task syz.0.0/5107

CPU: 0 UID: 0 PID: 5107 Comm: syz.0.0 Not tainted 6.12.0-rc3-syzkaller-00044-g2f87d0916ce0 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 ocfs2_dx_dir_lookup_rec+0x206/0x810 fs/ocfs2/dir.c:805
 ocfs2_dx_dir_lookup+0x163/0x930 fs/ocfs2/dir.c:860
 ocfs2_dx_dir_search fs/ocfs2/dir.c:920 [inline]
 ocfs2_find_entry_dx fs/ocfs2/dir.c:1034 [inline]
 ocfs2_find_entry+0x1338/0x2780 fs/ocfs2/dir.c:1070
 ocfs2_find_files_on_disk+0xff/0x360 fs/ocfs2/dir.c:1981
 ocfs2_lookup_ino_from_name+0xb1/0x1e0 fs/ocfs2/dir.c:2003
 ocfs2_lookup+0x292/0xa60 fs/ocfs2/namei.c:122
 lookup_open fs/namei.c:3573 [inline]
 open_last_lookups fs/namei.c:3694 [inline]
 path_openat+0x11a7/0x3590 fs/namei.c:3930
 do_filp_open+0x235/0x490 fs/namei.c:3960
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1415
 do_sys_open fs/open.c:1430 [inline]
 __do_sys_openat fs/open.c:1446 [inline]
 __se_sys_openat fs/open.c:1441 [inline]
 __x64_sys_openat+0x247/0x2a0 fs/open.c:1441
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fefd797dff9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fefd881f038 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007fefd7b36058 RCX: 00007fefd797dff9
RDX: 000000000000275a RSI: 0000000020000280 RDI: ffffffffffffff9c
RBP: 00007fefd79f0296 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007fefd7b36058 R15: 00007ffe17f0ea68
 </TASK>

Allocated by task 5105:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 unpoison_slab_object mm/kasan/common.c:319 [inline]
 __kasan_slab_alloc+0x66/0x80 mm/kasan/common.c:345
 kasan_slab_alloc include/linux/kasan.h:247 [inline]
 slab_post_alloc_hook mm/slub.c:4085 [inline]
 slab_alloc_node mm/slub.c:4134 [inline]
 kmem_cache_alloc_noprof+0x135/0x2a0 mm/slub.c:4141
 getname_flags+0xb7/0x540 fs/namei.c:139
 getname fs/namei.c:225 [inline]
 __do_sys_symlinkat fs/namei.c:4657 [inline]
 __se_sys_symlinkat fs/namei.c:4654 [inline]
 __x64_sys_symlinkat+0x87/0xb0 fs/namei.c:4654
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5105:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:579
 poison_slab_object mm/kasan/common.c:247 [inline]
 __kasan_slab_free+0x59/0x70 mm/kasan/common.c:264
 kasan_slab_free include/linux/kasan.h:230 [inline]
 slab_free_hook mm/slub.c:2342 [inline]
 slab_free mm/slub.c:4579 [inline]
 kmem_cache_free+0x1a2/0x420 mm/slub.c:4681
 do_symlinkat+0x34c/0x3a0 fs/namei.c:4649
 __do_sys_symlinkat fs/namei.c:4657 [inline]
 __se_sys_symlinkat fs/namei.c:4654 [inline]
 __x64_sys_symlinkat+0x95/0xb0 fs/namei.c:4654
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88801181a200
 which belongs to the cache names_cache of size 4096
The buggy address is located 192 bytes to the right of
 allocated 4096-byte region [ffff88801181a200, ffff88801181b200)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x11818
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff888030407780 ffffea000046a400 dead000000000002
raw: 0000000000000000 0000000000070007 00000001f5000000 0000000000000000
head: 00fff00000000040 ffff888030407780 ffffea000046a400 dead000000000002
head: 0000000000000000 0000000000070007 00000001f5000000 0000000000000000
head: 00fff00000000003 ffffea0000460601 ffffffffffffffff 0000000000000000
head: 0000000000000008 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5023, tgid 5023 (rm), ts 59547676990, free_ts 44085069973
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1537
 prep_new_page mm/page_alloc.c:1545 [inline]
 get_page_from_freelist+0x3045/0x3190 mm/page_alloc.c:3457
 __alloc_pages_noprof+0x292/0x710 mm/page_alloc.c:4733
 alloc_pages_mpol_noprof+0x3e8/0x680 mm/mempolicy.c:2265
 alloc_slab_page+0x6a/0x120 mm/slub.c:2412
 allocate_slab+0x5a/0x2f0 mm/slub.c:2578
 new_slab mm/slub.c:2631 [inline]
 ___slab_alloc+0xcd1/0x14b0 mm/slub.c:3818
 __slab_alloc+0x58/0xa0 mm/slub.c:3908
 __slab_alloc_node mm/slub.c:3961 [inline]
 slab_alloc_node mm/slub.c:4122 [inline]
 kmem_cache_alloc_noprof+0x1c1/0x2a0 mm/slub.c:4141
 getname_flags+0xb7/0x540 fs/namei.c:139
 user_path_at+0x24/0x60 fs/namei.c:3015
 user_statfs+0xd6/0x460 fs/statfs.c:103
 __do_sys_statfs fs/statfs.c:195 [inline]
 __se_sys_statfs fs/statfs.c:192 [inline]
 __x64_sys_statfs+0xe8/0x1a0 fs/statfs.c:192
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 4795 tgid 4795 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1108 [inline]
 free_unref_page+0xcfb/0xf20 mm/page_alloc.c:2638
 __slab_free+0x31b/0x3d0 mm/slub.c:4490
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x9a/0x140 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x14f/0x170 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x23/0x80 mm/kasan/common.c:329
 kasan_slab_alloc include/linux/kasan.h:247 [inline]
 slab_post_alloc_hook mm/slub.c:4085 [inline]
 slab_alloc_node mm/slub.c:4134 [inline]
 __do_kmalloc_node mm/slub.c:4263 [inline]
 __kmalloc_noprof+0x1a6/0x400 mm/slub.c:4276
 kmalloc_noprof include/linux/slab.h:882 [inline]
 tomoyo_add_entry security/tomoyo/common.c:2023 [inline]
 tomoyo_supervisor+0xe0d/0x11f0 security/tomoyo/common.c:2095
 tomoyo_audit_path_log security/tomoyo/file.c:168 [inline]
 tomoyo_path_permission+0x243/0x360 security/tomoyo/file.c:587
 tomoyo_check_open_permission+0x2fb/0x500 security/tomoyo/file.c:777
 security_bprm_check+0x86/0x250 security/security.c:1297
 search_binary_handler fs/exec.c:1740 [inline]
 exec_binprm fs/exec.c:1794 [inline]
 bprm_execve+0xa56/0x1770 fs/exec.c:1845
 do_execveat_common+0x55f/0x6f0 fs/exec.c:1952
 do_execve fs/exec.c:2026 [inline]
 __do_sys_execve fs/exec.c:2102 [inline]
 __se_sys_execve fs/exec.c:2097 [inline]
 __x64_sys_execve+0x92/0xb0 fs/exec.c:2097
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff88801181b180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88801181b200: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88801181b280: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                                           ^
 ffff88801181b300: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88801181b380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
