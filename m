Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4832196D9D
	for <ocfs2-devel@lists.linux.dev>; Tue, 29 Oct 2024 17:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730224164; cv=none; b=YEYfn/WWN57dUdLyeBVe+wNkz0kcoC74AlG5iwetvuYclT5jPAEJef6q1/7mX+Mov8PdGF8UnajH4B2l78T0VEzx+0R0XRpidH0lNpFs5/qDxdvsn/t4E69c4eBNv8mRrtbvRBpIH2AYb08Kgxg67+qZfcXO0PuKdTnt7b2g/pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730224164; c=relaxed/simple;
	bh=v9FcYbdc8oNUuLYBmqu+05VscTa0cr3dZnDMafd9WCc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=QSsUKUaLR/ZACSnL1v8gZaCJbfCPTtZS5tFe9ChZjynw08Phi25CXSWIsftQQp4cAUxZJhLoJvA8XC7TIXJCiSVjPFXHsJegCE9rlpNyxIgfG2rJnIcbEuhBKAvdIxQPXYV+lGcoyQvwyECiHuucWBIams5YUOdg3vXjcJb8yRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a3c4554d29so51231065ab.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 29 Oct 2024 10:49:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730224161; x=1730828961;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sRQrusRNJf38zUHFOuTpNiEov4y+QOY79xt1z6RqcII=;
        b=R1Rcq7KLQS0lt+vA8pKc9RwShn198iTJuxzRuVAU3oWYOFFLty2wOHS6kvkhVjJAn0
         +Wdo1zBoDNJ5U/DVUtoa5wbXY6VuelaDE+prlxwq7Gb4magIcnqf9o4YVrfUc6ADZmLJ
         0WfEtZfB/SIWsDgEmLs3tR9MmLg38/WTBP2/QNApkFvtUYrF43l9uMjg7aGFTq0iyiHx
         tjj+P5AvBD5D7IuhU0q+CJigLE6i7hfvPn6Ng07O2op7B9QVN733e0/Ul928MoPcrx2r
         d1oRDFFDSY0W7mpoEZXWPQM1bd7Cmp2zf06jYy4rZ8SvhQ3YbTcS6mbgLcn4/wVBOllx
         133w==
X-Forwarded-Encrypted: i=1; AJvYcCVc9deTPxnMob8PRNUN4cWt9narV1+GvkO/Iiag/t/tl7xJkYLCtSteOPiHPlkwEPv3xefXMYQd9XEEog==@lists.linux.dev
X-Gm-Message-State: AOJu0YydmOtPb1SKlSiSTRS5H4FrDWadkQL+jGld7qajLO/P1kAV5PyJ
	s2+zFW4HFP1lmrNAx8YAlDMllf/twvTStOwEBkeEG7SjmdMwZa1Po5OLz8fmurLpqyINa8u5x95
	6yTD4vVqYzjjBSPflx8hGgmBTBIZwHdWZe00RXVLrbfq6bRwY5+Z5KVE=
X-Google-Smtp-Source: AGHT+IExR9jQugmuJZ8ciAXnBAqg6k0PWbBbV+h/n6DjFo47ur9I5gL7bxe/jnCs+87FpMxOquNdOcvZ5t9VE+ULDhiScv2U7hNx
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:164b:b0:3a2:7651:9867 with SMTP id
 e9e14a558f8ab-3a4ed2b28damr128429795ab.13.1730224160879; Tue, 29 Oct 2024
 10:49:20 -0700 (PDT)
Date: Tue, 29 Oct 2024 10:49:20 -0700
In-Reply-To: <66f6bfa7.050a0220.38ace9.001a.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67212020.050a0220.11b624.04c4.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] KASAN: use-after-free Read in ocfs2_dir_foreach_blk
From: syzbot <syzbot+b20bbf680bb0f2ecedae@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    e42b1a9a2557 Merge tag 'spi-fix-v6.12-rc5' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=170b064b980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4aec7739e14231a7
dashboard link: https://syzkaller.appspot.com/bug?extid=b20bbf680bb0f2ecedae
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=108b064b980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14a5f0e7980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-e42b1a9a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3e2253169da8/vmlinux-e42b1a9a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b9d2f5008f24/bzImage-e42b1a9a.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/1da7d3546e21/mount_0.gz
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/019e0246868a/mount_3.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b20bbf680bb0f2ecedae@syzkaller.appspotmail.com

(kworker/u4:4,1025,0):ocfs2_read_blocks_sync:112 ERROR: status = -12
(kworker/u4:4,1025,0):ocfs2_read_locked_inode:521 ERROR: status = -12
==================================================================
BUG: KASAN: slab-out-of-bounds in ocfs2_check_dir_entry fs/ocfs2/dir.c:321 [inline]
BUG: KASAN: slab-out-of-bounds in ocfs2_dir_foreach_blk_id fs/ocfs2/dir.c:1784 [inline]
BUG: KASAN: slab-out-of-bounds in ocfs2_dir_foreach_blk+0x1ab6/0x1b20 fs/ocfs2/dir.c:1912
Read of size 8 at addr ffff888040701778 by task kworker/u4:4/1025

CPU: 0 UID: 0 PID: 1025 Comm: kworker/u4:4 Not tainted 6.12.0-rc5-syzkaller-00005-ge42b1a9a2557 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Workqueue: ocfs2_wq ocfs2_complete_recovery
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 ocfs2_check_dir_entry fs/ocfs2/dir.c:321 [inline]
 ocfs2_dir_foreach_blk_id fs/ocfs2/dir.c:1784 [inline]
 ocfs2_dir_foreach_blk+0x1ab6/0x1b20 fs/ocfs2/dir.c:1912
 ocfs2_dir_foreach+0xb4/0x100 fs/ocfs2/dir.c:1923
 ocfs2_queue_orphans fs/ocfs2/journal.c:2186 [inline]
 ocfs2_recover_orphans fs/ocfs2/journal.c:2270 [inline]
 ocfs2_complete_recovery+0xcf1/0x25c0 fs/ocfs2/journal.c:1351
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>

Allocated by task 1:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 unpoison_slab_object mm/kasan/common.c:319 [inline]
 __kasan_slab_alloc+0x66/0x80 mm/kasan/common.c:345
 kasan_slab_alloc include/linux/kasan.h:247 [inline]
 slab_post_alloc_hook mm/slub.c:4085 [inline]
 slab_alloc_node mm/slub.c:4134 [inline]
 kmem_cache_alloc_noprof+0x135/0x2a0 mm/slub.c:4141
 __kernfs_new_node+0xd8/0x870 fs/kernfs/dir.c:624
 kernfs_new_node+0x137/0x240 fs/kernfs/dir.c:700
 __kernfs_create_file+0x49/0x2e0 fs/kernfs/file.c:1034
 sysfs_add_file_mode_ns+0x24a/0x310 fs/sysfs/file.c:307
 create_files fs/sysfs/group.c:76 [inline]
 internal_create_group+0x7a7/0x11d0 fs/sysfs/group.c:180
 sysfs_slab_add+0x157/0x290 mm/slub.c:7104
 slab_sysfs_init+0x66/0x170 mm/slub.c:7184
 do_one_initcall+0x248/0x880 init/main.c:1269
 do_initcall_level+0x157/0x210 init/main.c:1331
 do_initcalls+0x3f/0x80 init/main.c:1347
 kernel_init_freeable+0x435/0x5d0 init/main.c:1580
 kernel_init+0x1d/0x2b0 init/main.c:1469
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

The buggy address belongs to the object at ffff888040701690
 which belongs to the cache kernfs_node_cache of size 176
The buggy address is located 56 bytes to the right of
 allocated 176-byte region [ffff888040701690, ffff888040701740)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x40701
flags: 0x4fff00000000000(node=1|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 04fff00000000000 ffff888030407dc0 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000110011 00000001f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 1, tgid 1 (swapper/0), ts 22332972406, free_ts 0
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
 __kernfs_new_node+0xd8/0x870 fs/kernfs/dir.c:624
 kernfs_new_node+0x137/0x240 fs/kernfs/dir.c:700
 __kernfs_create_file+0x49/0x2e0 fs/kernfs/file.c:1034
 sysfs_add_file_mode_ns+0x24a/0x310 fs/sysfs/file.c:307
 create_files fs/sysfs/group.c:76 [inline]
 internal_create_group+0x7a7/0x11d0 fs/sysfs/group.c:180
 sysfs_slab_add+0x157/0x290 mm/slub.c:7104
 slab_sysfs_init+0x66/0x170 mm/slub.c:7184
page_owner free stack trace missing

Memory state around the buggy address:
 ffff888040701600: 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc
 ffff888040701680: fc fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff888040701700: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
                                                                ^
 ffff888040701780: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888040701800: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc 00 00
==================================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
