Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E372C136658
	for <ocfs2-devel@lists.linux.dev>; Thu, 17 Oct 2024 21:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729200095; cv=none; b=Jj/v4wgAhgyyapXijmcezZL9TPkDQc7tdQS7Bon801JotfkLkI2q4xJYLOngK8l3xJWNnY2PyUSA5XZR8ziRS5HoCWWk5XxMWRnLNbdkjHZErrgd9yjYHWuWT6hdnJ2RLB+586xRV0c1Pu7Y8SuQAY1cl3ONVucc4Q+4s5yNWEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729200095; c=relaxed/simple;
	bh=TPAFi+YDnRYmSvYW/EO2qgXWsvlyqTz3MBANC5PBkf4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=AkmS45RgVZlFkdWkKYTSoA6KJPEMtCiPh6nseQsJmOTMioRF9XxX1SAG6H2UE/IVD37f2T25XxTODg2k5d9Pvgv8rzYftjjekN6hm/fZCqXHpDbqJTcW1dtLNLTZSNnvqIawZQlQ0qal4ZXKQY/yD/Mw1GwAFFaK/yBJVxlGQpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a3a6afd01eso11120325ab.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 17 Oct 2024 14:21:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729200090; x=1729804890;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Kotyd4snE8baBuA+sQCwzR32Y28QQZjhdeIWnPUdo5o=;
        b=oO5xjqmFILmh8Hmv61+ldvbA4wB9gjlpw8xPsD04RVTOTpyOflt4cZJK25c4Wh+ZZt
         Washp7o7mcP3hpQ0JBtV0uUL3msf5r7zd01RRlOqJM1J+DXJaITegQqkb2mcSz7nm6rr
         Acq6jmYp0KqkvLJxQksl0UHG+z9Suz3A1RHX1L004Gd+o3CfqHwUDWO0kg2ygnxfiFOx
         KRRnCMXFJgnHWuHa70gxoN2M7bKi4w1h//dmgLQ8VWfV47DuUlurR+93ZqpeQkCKviha
         gJJvpZTTd3L631YPwW5PhEbktO5c9ahy5mlgXuvE2R7oIl2mSqCRY+LbuNBQ2+V2A62E
         s5+A==
X-Forwarded-Encrypted: i=1; AJvYcCUgBM5Ts9xWc/+nUmOVKVivf6pyjRKWnTnNibdaRlLx2DKpm753dLuw+dsa77Q9BA/iLuQKYpA5Fwnnxw==@lists.linux.dev
X-Gm-Message-State: AOJu0YziHEZlTKGADEnKUtCjyxC9KNHbYP2TXJ8dgjlhzZkhyjweRzSN
	zj9cVq7NXeHBGz0aWaCalBVEYPmuOD/dsZ+FotwsZJYrZIfOBmCXy3PWZTHvLjOJiga3MADMVKi
	ETSyq1EIIkiTxKpwn2UBZ7BJRiVGnvdUCd2Jh0haGUDgAO+jCKzWytkk=
X-Google-Smtp-Source: AGHT+IHJ6DDyblu1fDGtQbnYrofnV7Mv6m0hOa7gAYTaMOMXXp+ysLy0tqdiiy+k0ounTx6ZSZjUnlgZhTanoWGu9QcJRgaFclcE
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:20c5:b0:3a0:7687:8c2d with SMTP id
 e9e14a558f8ab-3a3f40cc458mr1408345ab.26.1729200089998; Thu, 17 Oct 2024
 14:21:29 -0700 (PDT)
Date: Thu, 17 Oct 2024 14:21:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67117fd9.050a0220.10f4f4.0004.GAE@google.com>
Subject: [syzbot] [ocfs2?] KASAN: slab-use-after-free Read in ocfs2_reserve_suballoc_bits
From: syzbot <syzbot+af14efe17dfa46173239@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    36c254515dc6 Merge tag 'powerpc-6.12-4' of git://git.kerne..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=12c12887980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7a3fccdd0bb995
dashboard link: https://syzkaller.appspot.com/bug?extid=af14efe17dfa46173239
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13444727980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11861440580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/83cbc0a1ac4c/disk-36c25451.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/88a3bfaf55e9/vmlinux-36c25451.xz
kernel image: https://storage.googleapis.com/syzbot-assets/09cc9b57b1d2/bzImage-36c25451.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/76a33c6d871d/mount_0.gz

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14db585f980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16db585f980000
console output: https://syzkaller.appspot.com/x/log.txt?x=12db585f980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+af14efe17dfa46173239@syzkaller.appspotmail.com

ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
==================================================================
BUG: KASAN: slab-use-after-free in ocfs2_find_smallest_chain fs/ocfs2/suballoc.c:413 [inline]
BUG: KASAN: slab-use-after-free in ocfs2_block_group_alloc_contig fs/ocfs2/suballoc.c:430 [inline]
BUG: KASAN: slab-use-after-free in ocfs2_block_group_alloc fs/ocfs2/suballoc.c:699 [inline]
BUG: KASAN: slab-use-after-free in ocfs2_reserve_suballoc_bits+0x1023/0x4eb0 fs/ocfs2/suballoc.c:832
Read of size 4 at addr ffff888074488004 by task syz-executor305/5228

CPU: 1 UID: 0 PID: 5228 Comm: syz-executor305 Not tainted 6.12.0-rc2-syzkaller-00307-g36c254515dc6 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 ocfs2_find_smallest_chain fs/ocfs2/suballoc.c:413 [inline]
 ocfs2_block_group_alloc_contig fs/ocfs2/suballoc.c:430 [inline]
 ocfs2_block_group_alloc fs/ocfs2/suballoc.c:699 [inline]
 ocfs2_reserve_suballoc_bits+0x1023/0x4eb0 fs/ocfs2/suballoc.c:832
 ocfs2_reserve_new_metadata_blocks+0x41c/0x9c0 fs/ocfs2/suballoc.c:982
 ocfs2_mknod+0x143a/0x2b40 fs/ocfs2/namei.c:345
 ocfs2_create+0x1ab/0x480 fs/ocfs2/namei.c:672
 lookup_open fs/namei.c:3595 [inline]
 open_last_lookups fs/namei.c:3694 [inline]
 path_openat+0x1c03/0x3590 fs/namei.c:3930
 do_filp_open+0x235/0x490 fs/namei.c:3960
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1415
 do_sys_open fs/open.c:1430 [inline]
 __do_sys_open fs/open.c:1438 [inline]
 __se_sys_open fs/open.c:1434 [inline]
 __x64_sys_open+0x225/0x270 fs/open.c:1434
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7cbf1f9749
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 1c 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdbbfdc928 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f7cbf1f9749
RDX: 0000000000000000 RSI: 0000000004008040 RDI: 0000000020000200
RBP: 0000000000000000 R08: 0000000000004441 R09: 00007ffdbbfdc95c
R10: 00007ffdbbfdc7f0 R11: 0000000000000246 R12: 00007ffdbbfdc95c
R13: 0000000000000001 R14: 431bde82d7b634db R15: 00007ffdbbfdc990
 </TASK>

Allocated by task 5158:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 unpoison_slab_object mm/kasan/common.c:319 [inline]
 __kasan_slab_alloc+0x66/0x80 mm/kasan/common.c:345
 kasan_slab_alloc include/linux/kasan.h:247 [inline]
 slab_post_alloc_hook mm/slub.c:4085 [inline]
 slab_alloc_node mm/slub.c:4134 [inline]
 kmem_cache_alloc_noprof+0x135/0x2a0 mm/slub.c:4141
 skb_clone+0x20c/0x390 net/core/skbuff.c:2084
 dev_queue_xmit_nit+0x419/0xc10 net/core/dev.c:2315
 xmit_one net/core/dev.c:3584 [inline]
 dev_hard_start_xmit+0x15f/0x7e0 net/core/dev.c:3604
 sch_direct_xmit+0x29c/0x5d0 net/sched/sch_generic.c:343
 __dev_xmit_skb net/core/dev.c:3821 [inline]
 __dev_queue_xmit+0x1a2d/0x3ed0 net/core/dev.c:4394
 neigh_output include/net/neighbour.h:542 [inline]
 ip_finish_output2+0xe70/0x1390 net/ipv4/ip_output.c:236
 ip_local_out net/ipv4/ip_output.c:130 [inline]
 __ip_queue_xmit+0x118c/0x1b80 net/ipv4/ip_output.c:536
 __tcp_transmit_skb+0x2544/0x3b30 net/ipv4/tcp_output.c:1466
 tcp_cleanup_rbuf net/ipv4/tcp.c:1516 [inline]
 tcp_recvmsg_locked+0x330f/0x3c80 net/ipv4/tcp.c:2821
 tcp_recvmsg+0x25d/0x920 net/ipv4/tcp.c:2851
 inet_recvmsg+0x150/0x2d0 net/ipv4/af_inet.c:885
 sock_recvmsg_nosec net/socket.c:1051 [inline]
 sock_recvmsg+0x1ae/0x280 net/socket.c:1073
 sock_read_iter+0x2c4/0x3d0 net/socket.c:1143
 new_sync_read fs/read_write.c:488 [inline]
 vfs_read+0x9bb/0xbc0 fs/read_write.c:569
 ksys_read+0x183/0x2b0 fs/read_write.c:712
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5158:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:579
 poison_slab_object mm/kasan/common.c:247 [inline]
 __kasan_slab_free+0x59/0x70 mm/kasan/common.c:264
 kasan_slab_free include/linux/kasan.h:230 [inline]
 slab_free_hook mm/slub.c:2342 [inline]
 slab_free mm/slub.c:4579 [inline]
 kmem_cache_free+0x1a2/0x420 mm/slub.c:4681
 packet_rcv+0x16f/0x14b0 net/packet/af_packet.c:2290
 dev_queue_xmit_nit+0xad4/0xc10 net/core/dev.c:2347
 xmit_one net/core/dev.c:3584 [inline]
 dev_hard_start_xmit+0x15f/0x7e0 net/core/dev.c:3604
 sch_direct_xmit+0x29c/0x5d0 net/sched/sch_generic.c:343
 __dev_xmit_skb net/core/dev.c:3821 [inline]
 __dev_queue_xmit+0x1a2d/0x3ed0 net/core/dev.c:4394
 neigh_output include/net/neighbour.h:542 [inline]
 ip_finish_output2+0xe70/0x1390 net/ipv4/ip_output.c:236
 ip_local_out net/ipv4/ip_output.c:130 [inline]
 __ip_queue_xmit+0x118c/0x1b80 net/ipv4/ip_output.c:536
 __tcp_transmit_skb+0x2544/0x3b30 net/ipv4/tcp_output.c:1466
 tcp_cleanup_rbuf net/ipv4/tcp.c:1516 [inline]
 tcp_recvmsg_locked+0x330f/0x3c80 net/ipv4/tcp.c:2821
 tcp_recvmsg+0x25d/0x920 net/ipv4/tcp.c:2851
 inet_recvmsg+0x150/0x2d0 net/ipv4/af_inet.c:885
 sock_recvmsg_nosec net/socket.c:1051 [inline]
 sock_recvmsg+0x1ae/0x280 net/socket.c:1073
 sock_read_iter+0x2c4/0x3d0 net/socket.c:1143
 new_sync_read fs/read_write.c:488 [inline]
 vfs_read+0x9bb/0xbc0 fs/read_write.c:569
 ksys_read+0x183/0x2b0 fs/read_write.c:712
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888074488000
 which belongs to the cache skbuff_head_cache of size 240
The buggy address is located 4 bytes inside of
 freed 240-byte region [ffff888074488000, ffff8880744880f0)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x74488
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000000 ffff888140ee6780 dead000000000122 0000000000000000
raw: 0000000000000000 00000000000c000c 00000001f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52820(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 5158, tgid 5158 (sshd), ts 46020041993, free_ts 46019511087
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1537
 prep_new_page mm/page_alloc.c:1545 [inline]
 get_page_from_freelist+0x3039/0x3180 mm/page_alloc.c:3457
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
 skb_clone+0x20c/0x390 net/core/skbuff.c:2084
 dev_queue_xmit_nit+0x419/0xc10 net/core/dev.c:2315
 xmit_one net/core/dev.c:3584 [inline]
 dev_hard_start_xmit+0x15f/0x7e0 net/core/dev.c:3604
 sch_direct_xmit+0x29c/0x5d0 net/sched/sch_generic.c:343
 __dev_xmit_skb net/core/dev.c:3821 [inline]
 __dev_queue_xmit+0x1a2d/0x3ed0 net/core/dev.c:4394
 neigh_output include/net/neighbour.h:542 [inline]
 ip_finish_output2+0xe70/0x1390 net/ipv4/ip_output.c:236
 ip_local_out net/ipv4/ip_output.c:130 [inline]
 __ip_queue_xmit+0x118c/0x1b80 net/ipv4/ip_output.c:536
page last free pid 5158 tgid 5158 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1108 [inline]
 free_unref_page+0xcd0/0xf00 mm/page_alloc.c:2638
 skb_free_frag include/linux/skbuff.h:3399 [inline]
 skb_free_head net/core/skbuff.c:1096 [inline]
 skb_release_data+0x6dc/0x8a0 net/core/skbuff.c:1125
 skb_release_all net/core/skbuff.c:1190 [inline]
 __napi_kfree_skb net/core/skbuff.c:1480 [inline]
 kfree_skb_napi_cache net/core/skbuff.c:7115 [inline]
 skb_attempt_defer_free+0x42f/0x5c0 net/core/skbuff.c:7137
 tcp_eat_recv_skb net/ipv4/tcp.c:1526 [inline]
 tcp_recvmsg_locked+0x2995/0x3c80 net/ipv4/tcp.c:2805
 tcp_recvmsg+0x25d/0x920 net/ipv4/tcp.c:2851
 inet_recvmsg+0x150/0x2d0 net/ipv4/af_inet.c:885
 sock_recvmsg_nosec net/socket.c:1051 [inline]
 sock_recvmsg+0x1ae/0x280 net/socket.c:1073
 sock_read_iter+0x2c4/0x3d0 net/socket.c:1143
 new_sync_read fs/read_write.c:488 [inline]
 vfs_read+0x9bb/0xbc0 fs/read_write.c:569
 ksys_read+0x183/0x2b0 fs/read_write.c:712
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888074487f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888074487f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff888074488000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff888074488080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc
 ffff888074488100: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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
