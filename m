Received: from mail-oi1-f205.google.com (mail-oi1-f205.google.com [209.85.167.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2081282F2E
	for <ocfs2-devel@lists.linux.dev>; Fri, 24 Apr 2026 03:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777000836; cv=none; b=JmGfMFGF1ymhQNfyezji+JilwLb5+OMo5QIrzcHAlXe1sAAx6khqEVekNyaiFk6t+Yodkn719myXPSt8xCvBs84HblHac+g7aEt9eJR7UxtkuuaUNhSeBD3n8/m2BMdga8xOywqZwJWkRDVl2xOqWv0V1T5bSVBxsWXgcM9KXUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777000836; c=relaxed/simple;
	bh=+S9mn7D8CbnKngrXFSr8h66K/QHTiD1M2Zol50AdmLg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=jJbYYfvWlRmFjnzubwAXBrm1c29pZQ4YnIvUKBBVtlbbTwFnqwPGNoEEX3onGkDUkZb5nHay4XO82IKFDLko5VHbtrFIDJ5twUu+E32l9Ch1qhkYwCG76jdF/aZOUl+J5MXc+o6xwqnbk2zykRxYdsKMvsvvyfg/leT2NcnTJZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f205.google.com with SMTP id 5614622812f47-46ff0cb3a36so10917722b6e.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 23 Apr 2026 20:20:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777000834; x=1777605634;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h/dDaBOe1Un2QP6UKqpR+ZiUdOIKC//1e41lwsGujnU=;
        b=F82OeNxnWnmYE4GvCJU8ffIpsVJlWiYj9gbyHqHDZzhfFQ00qD9TYTvNIGks3aAcTn
         tJo7Ws+zS25Obv1FfAQoheD+a5AVZA5QmjMfGuGYsEDYlqxYOS6zY//B6orb4MBVFxPv
         jUWUhrP3CZLCqV8FZXbjt0+cj7ZeraGRuOx82SB/bWpF6joJTPgB/ioRtHaPMPAnGauQ
         wbKWAUsvTamnVjd4WUGOrrKP4wMPHsVq7NnQbAwBfUbuNBzjrq+a2EpWCF9Jmhe110ys
         rwhXjq6iZYw0zUhVKlSN6+If2Tp6a7lNDdQyF9hZwnfBlmDAUYSn/jlbPUqrltTx5jZD
         g8iQ==
X-Forwarded-Encrypted: i=1; AFNElJ9PFEjGB9g7nBwuWMKDux8s4E+60aAK4FobxLd7gVPKKdPDhqQ5QDrKO+CXk7W4R48AP2gjSc2z2+c95g==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzbf5QH/jNNMgszVOHeMd0VEz4bZAR2dUGAzO9oJ1OIDuqsz5P2
	jP0VEAMo/Kq0D7fI4qCL6SFmuY1eON2mNTEv+JQcLJScMJxwVAS+kewvUJj5AB0w+NGp15ZMdC4
	JUEa8l3eGHhtYoUUSjq+m7sZv673V7REbxpbsZDwpDYPXeIuUAjkdn+G6b6M=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1c9e:b0:694:9206:5bdf with SMTP id
 006d021491bc7-69492065ff0mr9966596eaf.4.1777000833993; Thu, 23 Apr 2026
 20:20:33 -0700 (PDT)
Date: Thu, 23 Apr 2026 20:20:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69eae181.a00a0220.17a17.0051.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_lock_refcount_tree (4)
From: syzbot <syzbot+7aaed0c45ce3fceccefa@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    bea8d77e45a8 Merge tag 'staging-7.1-rc1' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16739906580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f8c5ce991a39e5d9
dashboard link: https://syzkaller.appspot.com/bug?extid=7aaed0c45ce3fceccefa
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-bea8d77e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fa29d85c34c6/vmlinux-bea8d77e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c65a4276191b/bzImage-bea8d77e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7aaed0c45ce3fceccefa@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.0.0/5346 is trying to acquire lock:
ffff88804246f090 (&new->rf_sem){+.+.}-{4:4}, at: __ocfs2_lock_refcount_tree fs/ocfs2/refcounttree.c:428 [inline]
ffff88804246f090 (&new->rf_sem){+.+.}-{4:4}, at: ocfs2_lock_refcount_tree+0x1b7/0xa40 fs/ocfs2/refcounttree.c:463

but task is already holding lock:
ffff888046bf4fa0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1029 [inline]
ffff888046bf4fa0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_wipe_inode fs/ocfs2/inode.c:854 [inline]
ffff888046bf4fa0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
ffff888046bf4fa0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_evict_inode+0xe97/0x43b0 fs/ocfs2/inode.c:1299

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}:
       down_write+0x96/0x200 kernel/locking/rwsem.c:1625
       inode_lock include/linux/fs.h:1029 [inline]
       ocfs2_del_inode_from_orphan+0x12e/0x7a0 fs/ocfs2/namei.c:2728
       ocfs2_dio_end_io_write fs/ocfs2/aops.c:2379 [inline]
       ocfs2_dio_end_io+0xf9c/0x1370 fs/ocfs2/aops.c:2418
       dio_complete+0x25b/0x790 fs/direct-io.c:281
       __blockdev_direct_IO+0x2e5d/0x34e0 fs/direct-io.c:1303
       ocfs2_direct_IO+0x251/0x2c0 fs/ocfs2/aops.c:2455
       generic_file_direct_write+0x1db/0x3e0 mm/filemap.c:4258
       __generic_file_write_iter+0x11d/0x230 mm/filemap.c:4427
       ocfs2_file_write_iter+0x1663/0x1e70 fs/ocfs2/file.c:2476
       iter_file_splice_write+0x9a1/0x10f0 fs/splice.c:736
       do_splice_from fs/splice.c:936 [inline]
       direct_splice_actor+0x101/0x160 fs/splice.c:1159
       splice_direct_to_actor+0x53a/0xc70 fs/splice.c:1103
       do_splice_direct_actor fs/splice.c:1202 [inline]
       do_splice_direct+0x195/0x290 fs/splice.c:1228
       do_sendfile+0x535/0x7d0 fs/read_write.c:1372
       __do_sys_sendfile64 fs/read_write.c:1433 [inline]
       __se_sys_sendfile64+0x144/0x1a0 fs/read_write.c:1419
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
       down_write+0x96/0x200 kernel/locking/rwsem.c:1625
       inode_lock include/linux/fs.h:1029 [inline]
       ocfs2_reserve_suballoc_bits+0x16d/0x4840 fs/ocfs2/suballoc.c:882
       ocfs2_reserve_new_metadata_blocks+0x415/0x9a0 fs/ocfs2/suballoc.c:1078
       ocfs2_add_refcount_flag+0x372/0xe60 fs/ocfs2/refcounttree.c:3674
       ocfs2_reflink_remap_extent fs/ocfs2/refcounttree.c:4554 [inline]
       ocfs2_reflink_remap_blocks+0xbb2/0x1a30 fs/ocfs2/refcounttree.c:4681
       ocfs2_remap_file_range+0x451/0x6f0 fs/ocfs2/file.c:2747
       vfs_clone_file_range+0x42c/0x7b0 fs/remap_range.c:403
       ioctl_file_clone fs/ioctl.c:239 [inline]
       ioctl_file_clone_range fs/ioctl.c:257 [inline]
       do_vfs_ioctl+0xe0f/0x1530 fs/ioctl.c:544
       __do_sys_ioctl fs/ioctl.c:595 [inline]
       __se_sys_ioctl+0x82/0x170 fs/ioctl.c:583
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&new->rf_sem){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
       down_write+0x96/0x200 kernel/locking/rwsem.c:1625
       __ocfs2_lock_refcount_tree fs/ocfs2/refcounttree.c:428 [inline]
       ocfs2_lock_refcount_tree+0x1b7/0xa40 fs/ocfs2/refcounttree.c:463
       ocfs2_commit_truncate+0xb64/0x2310 fs/ocfs2/alloc.c:7375
       ocfs2_truncate_for_delete fs/ocfs2/inode.c:701 [inline]
       ocfs2_wipe_inode fs/ocfs2/inode.c:868 [inline]
       ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
       ocfs2_evict_inode+0x1023/0x43b0 fs/ocfs2/inode.c:1299
       evict+0x61e/0xb10 fs/inode.c:841
       ocfs2_dentry_iput+0x24d/0x390 fs/ocfs2/dcache.c:407
       __dentry_kill+0x1a2/0x5e0 fs/dcache.c:670
       finish_dput+0xc9/0x480 fs/dcache.c:879
       __fput+0x691/0xa60 fs/file_table.c:518
       task_work_run+0x1d9/0x270 kernel/task_work.c:233
       resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
       __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
       exit_to_user_mode_loop+0xed/0x480 kernel/entry/common.c:98
       __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
       syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:238 [inline]
       syscall_exit_to_user_mode include/linux/entry-common.h:328 [inline]
       do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &new->rf_sem --> &ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE] --> &ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
                               lock(&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]);
                               lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
  lock(&new->rf_sem);

 *** DEADLOCK ***

2 locks held by syz.0.0/5346:
 #0: ffff888041d8cbc0 (&osb->nfs_sync_rwlock){++++}-{4:4}, at: ocfs2_nfs_sync_lock+0x106/0x270 fs/ocfs2/dlmglue.c:2875
 #1: ffff888046bf4fa0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1029 [inline]
 #1: ffff888046bf4fa0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_wipe_inode fs/ocfs2/inode.c:854 [inline]
 #1: ffff888046bf4fa0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
 #1: ffff888046bf4fa0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_evict_inode+0xe97/0x43b0 fs/ocfs2/inode.c:1299

stack backtrace:
CPU: 0 UID: 0 PID: 5346 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e1/0x300 kernel/locking/lockdep.c:2043
 check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
 down_write+0x96/0x200 kernel/locking/rwsem.c:1625
 __ocfs2_lock_refcount_tree fs/ocfs2/refcounttree.c:428 [inline]
 ocfs2_lock_refcount_tree+0x1b7/0xa40 fs/ocfs2/refcounttree.c:463
 ocfs2_commit_truncate+0xb64/0x2310 fs/ocfs2/alloc.c:7375
 ocfs2_truncate_for_delete fs/ocfs2/inode.c:701 [inline]
 ocfs2_wipe_inode fs/ocfs2/inode.c:868 [inline]
 ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
 ocfs2_evict_inode+0x1023/0x43b0 fs/ocfs2/inode.c:1299
 evict+0x61e/0xb10 fs/inode.c:841
 ocfs2_dentry_iput+0x24d/0x390 fs/ocfs2/dcache.c:407
 __dentry_kill+0x1a2/0x5e0 fs/dcache.c:670
 finish_dput+0xc9/0x480 fs/dcache.c:879
 __fput+0x691/0xa60 fs/file_table.c:518
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
 exit_to_user_mode_loop+0xed/0x480 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:238 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:328 [inline]
 do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7a10b9c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe344c2928 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: 0000000000000000 RBX: 00007ffe344c2a10 RCX: 00007f7a10b9c819
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
RBP: 000000000001cd41 R08: 0000000000000001 R09: 0000000000000000
R10: 00007f7a109ff02c R11: 0000000000000246 R12: 00007ffe344c2a50
R13: 00007f7a10e15fac R14: 000000000001d8d6 R15: 00007f7a10e15fa0
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
