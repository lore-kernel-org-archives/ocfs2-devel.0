Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C986D211473
	for <ocfs2-devel@lists.linux.dev>; Fri, 21 Feb 2025 16:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740156750; cv=none; b=O0l2vAuL77/PoMRZDyzcIzVNdh+ir26HT0ksMcXDNFkdZH/9QCzrxLHEmQXBfjeJ8u3NkEMJYxRWiLgiWItVOcPiJIDt0yQu/4VfecD6YhC3GTf9tlWpWpm1gvDQ5Bkdf2pw+31CLLROg0/rMgHmK9lRfG4iFrzogcCMEY5y7FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740156750; c=relaxed/simple;
	bh=pCJoqNCoACUMz+eZ2zJ2SCJkTc8EuZTnmB+dtAwsn1o=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=t7qM+AfobKiUoEPxMOGLCh1ITxEv9/YrE0waQYndKSq2/xBhYzLz3qgI6QydMv6taTFv5FRjePuYnyBiKI8v527+9znqOz2uOKvDQ1qDt0YakU2gZlEvrxP9FAeWs2T9O0JhIvr4V6woms9OeJnZxTfM4HOcFqL1T3y1Pqn+0jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3ce3bbb2b9dso17373605ab.3
        for <ocfs2-devel@lists.linux.dev>; Fri, 21 Feb 2025 08:52:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740156748; x=1740761548;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VvwegZTiR6u5/D/n3179ZMNei5T993GLZphkxxYz40c=;
        b=oemJy4gvo1ru1IdnEAH90n/ZviLfnFB4uHNIuj+Bpa7pLqHjkPsplhRLg9MMLB9O9A
         H00GMLQmxGaFariM+l/+OmqmGHc5dDxqmLZ3sH2tT6Avcb8WJ/liMk4g0qGEZlP/Ezmw
         S5E0xE0L+Slc/TaJnG6xzQdoiqXRtngZAcY3Us5s3UR9H9J0DUZuM19Y6fc/wsWW62Xs
         0mIe0jaBGTiovDZ9tyeR5ClVArOiscadiXW2NGStEFQw2nsG/Y6jjYAvG+B7902ALrPk
         G2lI8GA8tyFc3GuXVkBFpAOOjzwkNlw4pJX8C1kphvPO4fmzyk+Eg4RwopY5CWNKBu2E
         Nt1A==
X-Forwarded-Encrypted: i=1; AJvYcCUVf1RXWJ5FtZPU9P//lbN25+eFo0/+EmVhr8YGLf4slrntZxC9Ed/ujPvOw5idaGfgwqbeHjzLGhRrtg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzyYu1WTgxOk9e4lVj/1fTcBG0vgr8mN0COzBH1VjYuUeCJ5xcG
	BEQAgsM4lRcGLFZVnlax4mQFEm5AGCNOdQwEp4nWMNjV1ByhnJyylP8OGDd8hhODYdQQ7VAuPVc
	GC3A/JqflcAKI6/GO5n7R4JuKT3rpS6fkTLpzH/ES5L4Wk9QI+HgyK18=
X-Google-Smtp-Source: AGHT+IEkOPsCnvsrWuVfBQbLFDeH3sem4pt8aP4l9Mj/55rW12U8+brqxjBdIDyGqaPe5zbgbKKdxF1M0hXDjPfnN6ExcoW8veMY
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:23c1:b0:3d1:78f8:7490 with SMTP id
 e9e14a558f8ab-3d2caf00ef0mr36527275ab.14.1740156747877; Fri, 21 Feb 2025
 08:52:27 -0800 (PST)
Date: Fri, 21 Feb 2025 08:52:27 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67b8af4b.050a0220.14d86d.057b.GAE@google.com>
Subject: [syzbot] [ocfs2?] KASAN: slab-out-of-bounds Read in ocfs2_get_system_file_inode
From: syzbot <syzbot+4d14d219a2e7941c8ff1@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    0ad2507d5d93 Linux 6.14-rc3
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=112575a4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b7bde34acd8f53b1
dashboard link: https://syzkaller.appspot.com/bug?extid=4d14d219a2e7941c8ff1
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-0ad2507d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/dfb4fc7c042e/vmlinux-0ad2507d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1682113b81f5/bzImage-0ad2507d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4d14d219a2e7941c8ff1@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in ocfs2_get_system_file_inode+0x1cb/0x840 fs/ocfs2/sysfile.c:102
Read of size 8 at addr ffff8880121e3b48 by task syz.0.0/5319

CPU: 0 UID: 0 PID: 5319 Comm: syz.0.0 Not tainted 6.14.0-rc3-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:489
 kasan_report+0x143/0x180 mm/kasan/report.c:602
 ocfs2_get_system_file_inode+0x1cb/0x840 fs/ocfs2/sysfile.c:102
 ocfs2_xattr_free_block fs/ocfs2/xattr.c:2517 [inline]
 ocfs2_xattr_remove+0xac4/0x18d0 fs/ocfs2/xattr.c:2600
 ocfs2_wipe_inode fs/ocfs2/inode.c:820 [inline]
 ocfs2_delete_inode fs/ocfs2/inode.c:1093 [inline]
 ocfs2_evict_inode+0x1f5e/0x4630 fs/ocfs2/inode.c:1230
 evict+0x4e8/0x9a0 fs/inode.c:796
 ocfs2_dentry_iput+0x232/0x380 fs/ocfs2/dcache.c:407
 __dentry_kill+0x20d/0x630 fs/dcache.c:643
 dput+0x19f/0x2b0 fs/dcache.c:885
 __fput+0x60b/0x9f0 fs/file_table.c:472
 task_work_run+0x24f/0x310 kernel/task_work.c:227
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x13f/0x340 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb48a78cde9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffedc7a6ae8 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: 0000000000000000 RBX: 0000000000010c75 RCX: 00007fb48a78cde9
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
RBP: 00007fb48a9a7ba0 R08: 0000000000000001 R09: 0000001edc7a6ddf
R10: 00007fb48a5ff040 R11: 0000000000000246 R12: 00007fb48a9a5fac
R13: 00007fb48a9a5fa0 R14: ffffffffffffffff R15: 00007ffedc7a6c00
 </TASK>

Allocated by task 5303:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0x98/0xb0 mm/kasan/common.c:394
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __do_kmalloc_node mm/slub.c:4294 [inline]
 __kmalloc_node_track_caller_noprof+0x28b/0x4c0 mm/slub.c:4313
 kmalloc_reserve+0x111/0x2a0 net/core/skbuff.c:609
 __alloc_skb+0x1f3/0x440 net/core/skbuff.c:678
 alloc_skb include/linux/skbuff.h:1331 [inline]
 netlink_dump+0x1ee/0xe10 net/netlink/af_netlink.c:2284
 __netlink_dump_start+0x5a2/0x790 net/netlink/af_netlink.c:2433
 genl_family_rcv_msg_dumpit net/netlink/genetlink.c:1076 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:1192 [inline]
 genl_rcv_msg+0x894/0xec0 net/netlink/genetlink.c:1210
 netlink_rcv_skb+0x206/0x480 net/netlink/af_netlink.c:2543
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1219
 netlink_unicast_kernel net/netlink/af_netlink.c:1322 [inline]
 netlink_unicast+0x7f6/0x990 net/netlink/af_netlink.c:1348
 netlink_sendmsg+0x8de/0xcb0 net/netlink/af_netlink.c:1892
 sock_sendmsg_nosec net/socket.c:718 [inline]
 __sock_sendmsg+0x221/0x270 net/socket.c:733
 __sys_sendto+0x363/0x4c0 net/socket.c:2187
 __do_sys_sendto net/socket.c:2194 [inline]
 __se_sys_sendto net/socket.c:2190 [inline]
 __x64_sys_sendto+0xde/0x100 net/socket.c:2190
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5303:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:576
 poison_slab_object mm/kasan/common.c:247 [inline]
 __kasan_slab_free+0x59/0x70 mm/kasan/common.c:264
 kasan_slab_free include/linux/kasan.h:233 [inline]
 slab_free_hook mm/slub.c:2353 [inline]
 slab_free mm/slub.c:4609 [inline]
 kfree+0x196/0x430 mm/slub.c:4757
 skb_kfree_head net/core/skbuff.c:1086 [inline]
 skb_free_head net/core/skbuff.c:1098 [inline]
 skb_release_data+0x6a0/0x8a0 net/core/skbuff.c:1125
 skb_release_all net/core/skbuff.c:1190 [inline]
 __kfree_skb net/core/skbuff.c:1204 [inline]
 consume_skb+0x9f/0xf0 net/core/skbuff.c:1436
 netlink_recvmsg+0x632/0x11a0 net/netlink/af_netlink.c:1970
 sock_recvmsg_nosec net/socket.c:1023 [inline]
 sock_recvmsg+0x22f/0x280 net/socket.c:1045
 __sys_recvfrom+0x202/0x380 net/socket.c:2237
 __do_sys_recvfrom net/socket.c:2252 [inline]
 __se_sys_recvfrom net/socket.c:2248 [inline]
 __x64_sys_recvfrom+0xde/0x100 net/socket.c:2248
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff8880121e0000
 which belongs to the cache kmalloc-8k of size 8192
The buggy address is located 6984 bytes to the right of
 allocated 8192-byte region [ffff8880121e0000, ffff8880121e2000)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff8880121e0000 pfn:0x121e0
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
ksm flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff88801b042280 ffffea0000fc1a00 dead000000000003
raw: ffff8880121e0000 0000000000020001 00000000f5000000 0000000000000000
head: 00fff00000000040 ffff88801b042280 ffffea0000fc1a00 dead000000000003
head: ffff8880121e0000 0000000000020001 00000000f5000000 0000000000000000
head: 00fff00000000003 ffffea0000487801 ffffffffffffffff 0000000000000000
head: 0000000000000008 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2040(__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 4704, tgid 4704 (init), ts 23677118061, free_ts 23132095136
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f4/0x240 mm/page_alloc.c:1551
 prep_new_page mm/page_alloc.c:1559 [inline]
 get_page_from_freelist+0x365c/0x37a0 mm/page_alloc.c:3477
 __alloc_frozen_pages_noprof+0x292/0x710 mm/page_alloc.c:4739
 alloc_pages_mpol+0x311/0x660 mm/mempolicy.c:2270
 alloc_slab_page mm/slub.c:2423 [inline]
 allocate_slab+0x8f/0x3a0 mm/slub.c:2587
 new_slab mm/slub.c:2640 [inline]
 ___slab_alloc+0xc27/0x14a0 mm/slub.c:3826
 __slab_alloc+0x58/0xa0 mm/slub.c:3916
 __slab_alloc_node mm/slub.c:3991 [inline]
 slab_alloc_node mm/slub.c:4152 [inline]
 __kmalloc_cache_noprof+0x27b/0x390 mm/slub.c:4320
 kmalloc_noprof include/linux/slab.h:901 [inline]
 kzalloc_noprof include/linux/slab.h:1037 [inline]
 tomoyo_print_bprm security/tomoyo/audit.c:26 [inline]
 tomoyo_init_log+0x11f4/0x20d0 security/tomoyo/audit.c:264
 tomoyo_supervisor+0x3b2/0x1860 security/tomoyo/common.c:2198
 tomoyo_audit_env_log security/tomoyo/environ.c:36 [inline]
 tomoyo_env_perm+0x178/0x210 security/tomoyo/environ.c:63
 tomoyo_environ security/tomoyo/domain.c:672 [inline]
 tomoyo_find_next_domain+0x1495/0x1dd0 security/tomoyo/domain.c:888
 tomoyo_bprm_check_security+0x117/0x180 security/tomoyo/tomoyo.c:102
 security_bprm_check+0x86/0x250 security/security.c:1302
 search_binary_handler fs/exec.c:1765 [inline]
 exec_binprm fs/exec.c:1807 [inline]
 bprm_execve+0x8d3/0x1430 fs/exec.c:1859
 do_execveat_common+0x57f/0x710 fs/exec.c:1966
page last free pid 1 tgid 1 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1127 [inline]
 free_frozen_pages+0xe0d/0x10e0 mm/page_alloc.c:2660
 free_reserved_page+0xcc/0x120 mm/page_alloc.c:5737
 free_reserved_area+0x51/0xf0 mm/page_alloc.c:5723
 free_init_pages arch/x86/mm/init.c:932 [inline]
 free_kernel_image_pages arch/x86/mm/init.c:948 [inline]
 free_initmem+0x9a/0x110 arch/x86/mm/init.c:975
 kernel_init+0x31/0x2b0 init/main.c:1466
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Memory state around the buggy address:
 ffff8880121e3a00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880121e3a80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8880121e3b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                                              ^
 ffff8880121e3b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880121e3c00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
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
