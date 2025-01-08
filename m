Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AAB08634F
	for <ocfs2-devel@lists.linux.dev>; Wed,  8 Jan 2025 21:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736372789; cv=none; b=g/zhNYkfEReUTRE0I5z6qKnZ2QtGwHaUM+q4s3Tyfn2fjyRXxP+GCtM2usVUGhzMh//vNZSA8YU3cOs46RsoIeTstaQmxqXnVwLDvR4D0BucSGkAwrO45kF1ZpXRUFdnqifQniqwZPjvl5tbe1POloUlYxOirbLQVdjRPejLoHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736372789; c=relaxed/simple;
	bh=IUnjuQpZw9zQAUbqCuypQjdYSIJK/X/aXnrGz3WN/eA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=PJiB6nm3v2uja7drE4Zhx8Qtjkg7S3LQGY4i51X9Dp/i8xLAUWOv8RHE28fi5KDcIyeanADLdBCyuAKbu/QuqiCclCUtkfNKcBNxaekoQf26UFAO9OyVsl4oHVpmgAPLEHiqLrVMYP5PGziRQUarWRO4aZVQ6Pb0Dq5WQgRL2oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3a9d195e6e5so2249115ab.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 08 Jan 2025 13:46:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736372787; x=1736977587;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3bEiBcnRttBwPMkKswSuBaPHzWVavKSsLRt6Wc9Itug=;
        b=uTHVr/XczxEUX/aZun0sPi1bQYRwkVJbG3+wLZJjRt0ZN5DW6QmFQSK7gdxpKi0QUR
         sc/uJELlzdmlWXvHbgter8vR2KH9tWQ2kqxWaFc+MVkn3mNd92Y81IAdWxjLqeIHvtWZ
         z2/BQ+xBy6SV4+7pOm+00EiSWlpldQTnxfJYhpktfloe7TGiZ4Yse/nplXHmkXs2z3cE
         /CnGVVzuDWdpDjuFWLqLDCWSaEdzMGYNadjBXBs0ZqhgWe/cN9aCN0ED1dgLfXpjoZaW
         5g9r83Z2HY2Khaq4H2LXh1xtX4HBkAdoh21n2pW6MS5/6H0S1qU1dxp73tsmPkiz9RA1
         qcdQ==
X-Forwarded-Encrypted: i=1; AJvYcCW//S8sgjl4S6yZpC/EqciSzdXlOKcbayqsUc1JS29IhFLxkJ/KWzzV25k6Ly+1lXbgJiWw6gSpuMpNIA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz3Vp6TjJvD5gsSTY258VD6W43bs7M+THFThZfecj0FIqKw+FBf
	VThjtPSk6PYCLgEDvVezbeyx9loQb3dIuL/qsRkhvURSYUhI0SBUpE1UOs/kebnBqKKk566eFcj
	1FRnC7Jit4o0A+FyNxx2MJirIX2TF0J2Y/vcfZvAVyZ2tVPtZ74HX9AE=
X-Google-Smtp-Source: AGHT+IFEFIP0pxsyP5Upr5UZSC+voHMeSlLlNOLQosxSHnmJ3OcsTGewiJcyRSWIlUUgHHX1bjvmRDL1cH9fAwujsHlDRcEWp4nE
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:154b:b0:3a7:e286:a572 with SMTP id
 e9e14a558f8ab-3ce3a86a535mr37212995ab.3.1736372786824; Wed, 08 Jan 2025
 13:46:26 -0800 (PST)
Date: Wed, 08 Jan 2025 13:46:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <677ef232.050a0220.25a300.01a3.GAE@google.com>
Subject: [syzbot] [ocfs2?] KASAN: slab-use-after-free Read in ocfs2_get_next_id
From: syzbot <syzbot+e99798b93795f4d743a5@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    573067a5a685 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=17c59418580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cd7202b56d469648
dashboard link: https://syzkaller.appspot.com/bug?extid=e99798b93795f4d743a5
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=142ef8b0580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=122ef8b0580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/9d3b5c855aa0/disk-573067a5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0c06fc1ead83/vmlinux-573067a5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3390e59b9e4b/Image-573067a5.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/333713e92087/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e99798b93795f4d743a5@syzkaller.appspotmail.com

JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
==================================================================
BUG: KASAN: slab-use-after-free in ocfs2_lock_global_qf fs/ocfs2/quota_global.c:303 [inline]
BUG: KASAN: slab-use-after-free in ocfs2_get_next_id+0x244/0x8e4 fs/ocfs2/quota_global.c:900
Read of size 8 at addr ffff0000c26e0828 by task syz-executor321/6411

CPU: 1 UID: 0 PID: 6411 Comm: syz-executor321 Not tainted 6.13.0-rc3-syzkaller-g573067a5a685 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:466 (C)
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x198/0x538 mm/kasan/report.c:489
 kasan_report+0xd8/0x138 mm/kasan/report.c:602
 __asan_report_load8_noabort+0x20/0x2c mm/kasan/report_generic.c:381
 ocfs2_lock_global_qf fs/ocfs2/quota_global.c:303 [inline]
 ocfs2_get_next_id+0x244/0x8e4 fs/ocfs2/quota_global.c:900
 dquot_get_next_dqblk+0x7c/0x348 fs/quota/dquot.c:2702
 quota_getnextquota+0x264/0x650 fs/quota/quota.c:250
 do_quotactl+0x52c/0x698 fs/quota/quota.c:800
 __do_sys_quotactl fs/quota/quota.c:961 [inline]
 __se_sys_quotactl fs/quota/quota.c:917 [inline]
 __arm64_sys_quotactl+0x2c0/0xc9c fs/quota/quota.c:917
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

Allocated by task 6411:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x40/0x78 mm/kasan/common.c:68
 kasan_save_alloc_info+0x40/0x50 mm/kasan/generic.c:568
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0xac/0xc4 mm/kasan/common.c:394
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __kmalloc_cache_noprof+0x2cc/0x428 mm/slub.c:4329
 kmalloc_noprof include/linux/slab.h:901 [inline]
 ocfs2_local_read_info+0x1b8/0x15bc fs/ocfs2/quota_local.c:699
 dquot_load_quota_sb+0x6e4/0xb24 fs/quota/dquot.c:2459
 dquot_load_quota_inode+0x280/0x4f4 fs/quota/dquot.c:2496
 ocfs2_enable_quotas+0x17c/0x3cc fs/ocfs2/super.c:926
 ocfs2_fill_super+0x3e30/0x48d0 fs/ocfs2/super.c:1141
 mount_bdev+0x1d4/0x2a0 fs/super.c:1693
 ocfs2_mount+0x44/0x58 fs/ocfs2/super.c:1188
 legacy_get_tree+0xd4/0x16c fs/fs_context.c:662
 vfs_get_tree+0x90/0x28c fs/super.c:1814
 do_new_mount+0x278/0x900 fs/namespace.c:3507
 path_mount+0x590/0xe04 fs/namespace.c:3834
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount fs/namespace.c:4034 [inline]
 __arm64_sys_mount+0x4d4/0x5ac fs/namespace.c:4034
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

Freed by task 6411:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x40/0x78 mm/kasan/common.c:68
 kasan_save_free_info+0x54/0x6c mm/kasan/generic.c:582
 poison_slab_object mm/kasan/common.c:247 [inline]
 __kasan_slab_free+0x64/0x8c mm/kasan/common.c:264
 kasan_slab_free include/linux/kasan.h:233 [inline]
 slab_free_hook mm/slub.c:2353 [inline]
 slab_free mm/slub.c:4613 [inline]
 kfree+0x180/0x478 mm/slub.c:4761
 ocfs2_local_free_info+0x724/0x890 fs/ocfs2/quota_local.c:869
 dquot_disable+0xef0/0x1814 fs/quota/dquot.c:2304
 dquot_suspend include/linux/quotaops.h:85 [inline]
 ocfs2_susp_quotas+0x190/0x2d4 fs/ocfs2/super.c:892
 ocfs2_remount+0x464/0x9cc fs/ocfs2/super.c:647
 legacy_reconfigure+0xfc/0x114 fs/fs_context.c:685
 reconfigure_super+0x1d0/0x6e8 fs/super.c:1083
 do_remount fs/namespace.c:3047 [inline]
 path_mount+0xc0c/0xe04 fs/namespace.c:3826
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount fs/namespace.c:4034 [inline]
 __arm64_sys_mount+0x4d4/0x5ac fs/namespace.c:4034
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

The buggy address belongs to the object at ffff0000c26e0800
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 40 bytes inside of
 freed 1024-byte region [ffff0000c26e0800, ffff0000c26e0c00)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1026e0
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0x5ffc00000000040(head|node=0|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 05ffc00000000040 ffff0000c0001dc0 dead000000000122 0000000000000000
raw: 0000000000000000 0000000080100010 00000001f5000000 0000000000000000
head: 05ffc00000000040 ffff0000c0001dc0 dead000000000122 0000000000000000
head: 0000000000000000 0000000080100010 00000001f5000000 0000000000000000
head: 05ffc00000000003 fffffdffc309b801 ffffffffffffffff 0000000000000000
head: 0000000000000008 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff0000c26e0700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff0000c26e0780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff0000c26e0800: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                  ^
 ffff0000c26e0880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff0000c26e0900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
(syz-executor321,6411,1):ocfs2_block_check_validate:402 ERROR: CRC32 failed: stored: 0x2c7b5077, computed 0x28030c75. Applying ECC.
(syz-executor321,6411,1):ocfs2_block_check_validate:416 ERROR: Fixed CRC32 failed: stored: 0x2c7b5077, computed 0x28d1d8ae
(syz-executor321,6411,1):ocfs2_read_quota_phys_block:160 ERROR: status = -5
(syz-executor321,6411,1):ocfs2_quota_read:201 ERROR: status = -5
Quota error (device loop0): find_next_id: Can't read quota tree block 5
(syz-executor321,6411,1):ocfs2_get_next_id:916 ERROR: status = -5


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
