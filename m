Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F3384A40
	for <ocfs2-devel@lists.linux.dev>; Fri, 16 Aug 2024 09:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723801768; cv=none; b=TpY4QAurY9t1MO15mhw0eejHQ3NzXFIryVSUBQNHYbs/4rctwJzVS9nbngp5t3XTHyQXv7bYa7fOf4jXz+L8wOLk3Bqi3Jfu0xgZ6pCCkXCTPj8hREsqewMDPq+t8aMfngFepWFrQbGjMtGDuU8ZFJqOcXWwWTrM6qdcOi6DpuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723801768; c=relaxed/simple;
	bh=BjgvqIq+E7hKUBmo6Pb1gcsq/UqXW4w+ZZG3KS9RLkA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=PAc/Bb6tsG9whBdKgiESYonlakS0vurP64RGqY1dx55XiboCJK1LANR0ZRsylC8m9tTj30FrkVZBFgfx770YruzHVcXAw5RUxPqeQGCfERt9XbeZoB1iddDJMt6XDUgNaeoYQxOk8D2nrJmIvRqz2b1cknqAzDUZvZJ4VrPYUnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-81f8489097eso180173839f.3
        for <ocfs2-devel@lists.linux.dev>; Fri, 16 Aug 2024 02:49:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723801765; x=1724406565;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pZYRJF9iTN2ENnDxn+OtaNAZn2Kita6kUPKBhY+0dSs=;
        b=mWd4Vhj23eYOLZyz5ESYKSMjHMKvYUKUo0RxOQZh1VTQUlGETkhlz7DNIP93VTG9iZ
         okq43sODdNL991GiA6YQ4QTY46fh/OSefut/hWTqnMuhDCL8kMoPrATW4WG9S7EIN4DY
         1WpvdNxtzQyAdvsgkeaQzMsRz1pMqN3nPceR/NYta8xtYR6rVG1fo7m8Mdpw7EmTTelw
         MbYpwRx4539Nc1r2niWpQ8f2FZAMbdXxP9t7QrbfOuCBK99TI+1dtJ8l4cjuX1+gzBV7
         /dMrSDE4+jaOEE9uS8O5l/xCmIKo8O63+LVBLhcWoPEfmWWKSB4GFErVQ6QWxGU3sLVi
         ZugA==
X-Forwarded-Encrypted: i=1; AJvYcCUQxTiabRxLBmo5oLD4s1+J9Hjdq8HFujbULKY9FyRfraik/CozvMKPHk7kBm/SmIwLq2tHGwtZCMS6zMDM/pHPDBzqqwBGThjrR9k=
X-Gm-Message-State: AOJu0YzTM9RUqnn/RCbaQjWjzg21IAjDV0eyZOawbFzLUbH2Lwb6YOZA
	2utnJimWQmKARtIopOjdy86mysbTwooWA4u+ziV13LNfDwY24IJxR1yGl9sAZTANm2WZbq1BojL
	eJKkIcal5cp/2PMXG7X8l+sgLnzEAVtpjzarrJxppGt1BzmggdfwOQB4=
X-Google-Smtp-Source: AGHT+IFx1KLK7ZKIu9mxIvX91Qxsg3Kn4JpkX4KMBed3WC2qRlVqC4IUm1VwZ/wGWa3H49uSXwawCqb3/5Se0x5xVu62sXJCK8Nx
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:cd82:0:b0:39a:e900:7e3e with SMTP id
 e9e14a558f8ab-39d26d61e78mr1293445ab.3.1723801765341; Fri, 16 Aug 2024
 02:49:25 -0700 (PDT)
Date: Fri, 16 Aug 2024 02:49:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e2ff53061fc9dfcf@google.com>
Subject: [syzbot] [ocfs2?] KASAN: use-after-free Read in ocfs2_search_dirblock
From: syzbot <syzbot+b9704899e166798d57c9@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d7a5aa4b3c00 Merge tag 'perf-tools-fixes-for-v6.11-2024-08..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1049fbc5980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7229118d88b4a71b
dashboard link: https://syzkaller.appspot.com/bug?extid=b9704899e166798d57c9
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14c4ba05980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12902209980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-d7a5aa4b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/af15738cca6c/vmlinux-d7a5aa4b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/62dacb1384ee/bzImage-d7a5aa4b.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/f26a3130fa6e/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b9704899e166798d57c9@syzkaller.appspotmail.com

JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
==================================================================
BUG: KASAN: use-after-free in ocfs2_match fs/ocfs2/dir.c:334 [inline]
BUG: KASAN: use-after-free in ocfs2_search_dirblock+0x26b/0x830 fs/ocfs2/dir.c:367
Read of size 1 at addr ffff888012e06982 by task syz-executor341/5089

CPU: 0 UID: 0 PID: 5089 Comm: syz-executor341 Not tainted 6.11.0-rc3-syzkaller-00156-gd7a5aa4b3c00 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:93 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:119
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 ocfs2_match fs/ocfs2/dir.c:334 [inline]
 ocfs2_search_dirblock+0x26b/0x830 fs/ocfs2/dir.c:367
 ocfs2_find_entry_id fs/ocfs2/dir.c:414 [inline]
 ocfs2_find_entry+0x1169/0x2780 fs/ocfs2/dir.c:1078
 ocfs2_find_files_on_disk+0xff/0x360 fs/ocfs2/dir.c:1980
 ocfs2_lookup_ino_from_name+0xb1/0x1e0 fs/ocfs2/dir.c:2002
 ocfs2_lookup+0x292/0xa60 fs/ocfs2/namei.c:122
 lookup_open fs/namei.c:3556 [inline]
 open_last_lookups fs/namei.c:3647 [inline]
 path_openat+0x11cc/0x3470 fs/namei.c:3883
 do_filp_open+0x235/0x490 fs/namei.c:3913
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1416
 do_sys_open fs/open.c:1431 [inline]
 __do_sys_openat fs/open.c:1447 [inline]
 __se_sys_openat fs/open.c:1442 [inline]
 __x64_sys_openat+0x247/0x2a0 fs/open.c:1442
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2501523169
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 21 18 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd9f886d28 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2501523169
RDX: 0000000000105042 RSI: 0000000020000080 RDI: 00000000ffffff9c
RBP: 00000000ffffffff R08: 000000000000447f R09: 0000000002800400
R10: 00000000000001ff R11: 0000000000000246 R12: 00007ffd9f886d70
R13: 00007ffd9f886db0 R14: 0000000001000000 R15: 0000000000000003
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x161 pfn:0x12e06
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000000 0000000000000000 dead000000000122 0000000000000000
raw: 0000000000000161 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 4955, tgid 4955 (dhcpcd-run-hook), ts 57137576415, free_ts 66887393625
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1493
 prep_new_page mm/page_alloc.c:1501 [inline]
 get_page_from_freelist+0x2e4c/0x2f10 mm/page_alloc.c:3442
 __alloc_pages_noprof+0x256/0x6c0 mm/page_alloc.c:4700
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
 getname_flags+0xb7/0x540 fs/namei.c:139
 vfs_fstatat+0x12c/0x190 fs/stat.c:340
 __do_sys_newfstatat fs/stat.c:505 [inline]
 __se_sys_newfstatat fs/stat.c:499 [inline]
 __x64_sys_newfstatat+0x11d/0x1a0 fs/stat.c:499
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 5005 tgid 5005 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1094 [inline]
 free_unref_page+0xd22/0xea0 mm/page_alloc.c:2612
 discard_slab mm/slub.c:2583 [inline]
 __put_partials+0xeb/0x130 mm/slub.c:3051
 put_cpu_partial+0x17c/0x250 mm/slub.c:3126
 __slab_free+0x2ea/0x3d0 mm/slub.c:4343
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x9e/0x140 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x14f/0x170 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x23/0x80 mm/kasan/common.c:322
 kasan_slab_alloc include/linux/kasan.h:201 [inline]
 slab_post_alloc_hook mm/slub.c:3988 [inline]
 slab_alloc_node mm/slub.c:4037 [inline]
 kmem_cache_alloc_noprof+0x135/0x2a0 mm/slub.c:4044
 getname_flags+0xb7/0x540 fs/namei.c:139
 vfs_fstatat+0x12c/0x190 fs/stat.c:340
 __do_sys_newfstatat fs/stat.c:505 [inline]
 __se_sys_newfstatat fs/stat.c:499 [inline]
 __x64_sys_newfstatat+0x11d/0x1a0 fs/stat.c:499
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888012e06880: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888012e06900: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff888012e06980: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                   ^
 ffff888012e06a00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888012e06a80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
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
