Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600DC1CB51B
	for <ocfs2-devel@lists.linux.dev>; Tue, 26 Nov 2024 07:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732607908; cv=none; b=Ep3yfnQ3Sy6klEwJHiH/6QUcNxHqLL7w4NgdS5P2zaEQYBM7RYHf7VYmlW8wj2ZUjgEWyZMkhR2T+58Pbw79tI6tp4DWpE2TCHqB+Rd2WO7YV5mWeR9LtdPchIslvh4nFr97hS3DEY6+wQJRi74IeZdL7bju1zprUV9xWRNDN7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732607908; c=relaxed/simple;
	bh=0F5jXetk2H1yuRkwDzyPoE1qKfuPTDdGgNESVMPD7Kg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=XBsIlLegSkxw6Nrg4re2KfZVLQqejEMdiaL51asRWhL0Qbm6a6l3AAsEFclQH5Qj05+hdounmRlTl/IYj6+wEtzIvgI5FFVaqRrDk+cYeNOl8rF2fHfz67r2WNmcfBCJrwOGjXdNU22oNjuxIDb5nAqgg9VNovJS1YG+gEFWy6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a76690f813so63838915ab.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 25 Nov 2024 23:58:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732607905; x=1733212705;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=For1ClnK2GW9UU09719MaeDDqVyjEPRL1KqXlV9KwHA=;
        b=karEnLURhPLmmVhVMFTMtdx1GScckP/6mZsxmJexQ+2gNPZRKQsapkAxpJjRAgNbXt
         p9ahC/XI2EcGCAVTCb+j2dYfpz08XyTd6JX8bVBcFTqXmJNaA8iNUxZzDVl5/mD9l5VP
         PxKG3+RzEQYmsGiarz9uaXDYwYrjp92A41l1ahMNU38Od05sDGD38DUVe0uGlnox/j1P
         Xq+ID0gCDkGE/LU+hCnCQGh7iNUo6lPVvYXduit2AHI1F6cQxjrN7qCoK28AfFdAnYV8
         VMwL3uB7PRVHnisIxnyfJMUOJCOuN1z+KHDwNNSRdrnv6sZ5jbBJHwBil2HOTARYZ1Wa
         fY3w==
X-Forwarded-Encrypted: i=1; AJvYcCVfg4hf2y8yXf3xLJukLDVZHnXEjiBwEt5zNf6Y3qTpAWcnHYca7Ysc6ClvajKhmRbyUSpiYBB3fvbeSQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzxy9ZFRcDypwqvQN/2/hl0jblH1gqROsVdHLCZ7ZZPq3xIdIJs
	AoAhiPAduIveQdqegagno8dcCDMZPOAGUX9Vu67KmLVT1pG3fyhRIgi9UgFKUZ7R8Au+OmHKVRc
	1EKfP34qaIUxfU0wxEALxAy14FGVMDMNSNp35ZQQbMY5rKxnsihtQdRY=
X-Google-Smtp-Source: AGHT+IHgthwBm3EAm2nAQzF+P+U/QUNE53oFpPFPcs9aKKepfrOxgaUAcLpmlNiwwt6G7QrzxMWBUmdlJwy+jrJODY7RQ8YkU/Cc
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2149:b0:3a7:8720:9dea with SMTP id
 e9e14a558f8ab-3a79ad9aeb2mr150556425ab.9.1732607905556; Mon, 25 Nov 2024
 23:58:25 -0800 (PST)
Date: Mon, 25 Nov 2024 23:58:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67457fa1.050a0220.21d33d.0012.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in __ocfs2_journal_access
From: syzbot <syzbot+e3b76b437ea8b580e4d0@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    9f16d5e6f220 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10fa375f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5073f0bff19a2470
dashboard link: https://syzkaller.appspot.com/bug?extid=e3b76b437ea8b580e4d0
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/5f2746321903/disk-9f16d5e6.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2dda5d116bf7/vmlinux-9f16d5e6.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b2021123cc31/bzImage-9f16d5e6.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e3b76b437ea8b580e4d0@syzkaller.appspotmail.com

ocfs2: Mounting device (7,1) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
6.12.0-syzkaller-09073-g9f16d5e6f220 #0 Not tainted
------------------------------------------------------
syz.1.240/7056 is trying to acquire lock:
ffff8880577c4f28 (&oi->ip_io_mutex){+.+.}-{4:4}, at: __ocfs2_journal_access+0x4a1/0x8a0 fs/ocfs2/journal.c:684

but task is already holding lock:
ffff88804bda0958 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0x1e94/0x2110 fs/jbd2/transaction.c:448

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #6 (jbd2_handle){++++}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       start_this_handle+0x1eb4/0x2110 fs/jbd2/transaction.c:448
       jbd2__journal_start+0x2da/0x5d0 fs/jbd2/transaction.c:505
       __ext4_journal_start_sb+0x239/0x600 fs/ext4/ext4_jbd2.c:112
       __ext4_journal_start fs/ext4/ext4_jbd2.h:326 [inline]
       ext4_dirty_inode+0x92/0x110 fs/ext4/inode.c:6038
       __mark_inode_dirty+0x2f0/0xe90 fs/fs-writeback.c:2515
       generic_update_time fs/inode.c:2112 [inline]
       inode_update_time fs/inode.c:2125 [inline]
       touch_atime+0x413/0x690 fs/inode.c:2197
       file_accessed include/linux/fs.h:2539 [inline]
       ext4_file_mmap+0x18c/0x540 fs/ext4/file.c:816
       call_mmap include/linux/fs.h:2183 [inline]
       mmap_file mm/internal.h:124 [inline]
       __mmap_new_file_vma mm/vma.c:2291 [inline]
       __mmap_new_vma mm/vma.c:2355 [inline]
       __mmap_region+0x2206/0x2cd0 mm/vma.c:2456
       mmap_region+0x226/0x2c0 mm/mmap.c:1347
       do_mmap+0x8f0/0x1000 mm/mmap.c:496
       vm_mmap_pgoff+0x1dd/0x3d0 mm/util.c:588
       ksys_mmap_pgoff+0x4eb/0x720 mm/mmap.c:542
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #5 (&mm->mmap_lock){++++}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       __might_fault+0xc6/0x120 mm/memory.c:6751
       _inline_copy_from_user include/linux/uaccess.h:162 [inline]
       _copy_from_user+0x2a/0xc0 lib/usercopy.c:18
       copy_from_user include/linux/uaccess.h:212 [inline]
       __blk_trace_setup kernel/trace/blktrace.c:626 [inline]
       blk_trace_ioctl+0x1ad/0x9a0 kernel/trace/blktrace.c:740
       blkdev_ioctl+0x40c/0x6a0 block/ioctl.c:682
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:906 [inline]
       __se_sys_ioctl+0xf7/0x170 fs/ioctl.c:892
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #4 (&q->debugfs_mutex){+.+.}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x1ac/0xee0 kernel/locking/mutex.c:735
       blk_mq_init_sched+0x3fa/0x830 block/blk-mq-sched.c:473
       elevator_init_mq+0x20e/0x320 block/elevator.c:610
       add_disk_fwnode+0x10d/0xf80 block/genhd.c:413
       sd_probe+0xba6/0x1100 drivers/scsi/sd.c:4024
       really_probe+0x2ba/0xad0 drivers/base/dd.c:658
       __driver_probe_device+0x1a2/0x390 drivers/base/dd.c:800
       driver_probe_device+0x50/0x430 drivers/base/dd.c:830
       __device_attach_driver+0x2d6/0x530 drivers/base/dd.c:958
       bus_for_each_drv+0x250/0x2e0 drivers/base/bus.c:459
       __device_attach_async_helper+0x22d/0x300 drivers/base/dd.c:987
       async_run_entry_fn+0xaa/0x420 kernel/async.c:129
       process_one_work kernel/workqueue.c:3229 [inline]
       process_scheduled_works+0xa65/0x1850 kernel/workqueue.c:3310
       worker_thread+0x870/0xd30 kernel/workqueue.c:3391
       kthread+0x2f2/0x390 kernel/kthread.c:389
       ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #3 (&q->q_usage_counter(queue)#50){++++}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       blk_queue_enter+0xe1/0x600 block/blk-core.c:328
       blk_mq_alloc_request+0x4fa/0xaa0 block/blk-mq.c:652
       scsi_alloc_request drivers/scsi/scsi_lib.c:1222 [inline]
       scsi_execute_cmd+0x177/0x1090 drivers/scsi/scsi_lib.c:304
       read_capacity_16+0x2b4/0x1450 drivers/scsi/sd.c:2655
       sd_read_capacity drivers/scsi/sd.c:2824 [inline]
       sd_revalidate_disk+0x1013/0xbce0 drivers/scsi/sd.c:3734
       sd_probe+0x9fa/0x1100 drivers/scsi/sd.c:4010
       really_probe+0x2ba/0xad0 drivers/base/dd.c:658
       __driver_probe_device+0x1a2/0x390 drivers/base/dd.c:800
       driver_probe_device+0x50/0x430 drivers/base/dd.c:830
       __device_attach_driver+0x2d6/0x530 drivers/base/dd.c:958
       bus_for_each_drv+0x250/0x2e0 drivers/base/bus.c:459
       __device_attach_async_helper+0x22d/0x300 drivers/base/dd.c:987
       async_run_entry_fn+0xaa/0x420 kernel/async.c:129
       process_one_work kernel/workqueue.c:3229 [inline]
       process_scheduled_works+0xa65/0x1850 kernel/workqueue.c:3310
       worker_thread+0x870/0xd30 kernel/workqueue.c:3391
       kthread+0x2f2/0x390 kernel/kthread.c:389
       ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #2 (&q->limits_lock){+.+.}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x1ac/0xee0 kernel/locking/mutex.c:735
       queue_limits_start_update include/linux/blkdev.h:945 [inline]
       loop_reconfigure_limits+0x283/0x9e0 drivers/block/loop.c:1003
       loop_set_block_size drivers/block/loop.c:1473 [inline]
       lo_simple_ioctl drivers/block/loop.c:1496 [inline]
       lo_ioctl+0x1351/0x1f50 drivers/block/loop.c:1559
       blkdev_ioctl+0x57f/0x6a0 block/ioctl.c:693
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:906 [inline]
       __se_sys_ioctl+0xf7/0x170 fs/ioctl.c:892
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&q->q_usage_counter(io)#17){++++}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       bio_queue_enter block/blk.h:75 [inline]
       blk_mq_submit_bio+0x1536/0x23a0 block/blk-mq.c:3092
       __submit_bio+0x2c6/0x560 block/blk-core.c:629
       __submit_bio_noacct_mq block/blk-core.c:710 [inline]
       submit_bio_noacct_nocheck+0x4d3/0xe30 block/blk-core.c:739
       ocfs2_read_blocks+0x8c3/0x1600 fs/ocfs2/buffer_head_io.c:330
       ocfs2_read_inode_block_full fs/ocfs2/inode.c:1593 [inline]
       ocfs2_read_inode_block+0x106/0x1e0 fs/ocfs2/inode.c:1605
       ocfs2_get_clusters+0x3d2/0xbd0 fs/ocfs2/extent_map.c:615
       ocfs2_extent_map_get_blocks+0x24c/0x7d0 fs/ocfs2/extent_map.c:668
       ocfs2_read_virt_blocks+0x313/0xb20 fs/ocfs2/extent_map.c:983
       ocfs2_read_dir_block fs/ocfs2/dir.c:508 [inline]
       ocfs2_find_entry_el fs/ocfs2/dir.c:715 [inline]
       ocfs2_find_entry+0x43b/0x2780 fs/ocfs2/dir.c:1080
       ocfs2_find_files_on_disk+0xff/0x360 fs/ocfs2/dir.c:1981
       ocfs2_lookup_ino_from_name+0xb1/0x1e0 fs/ocfs2/dir.c:2003
       _ocfs2_get_system_file_inode fs/ocfs2/sysfile.c:136 [inline]
       ocfs2_get_system_file_inode+0x305/0x7b0 fs/ocfs2/sysfile.c:112
       ocfs2_init_global_system_inodes+0x32c/0x730 fs/ocfs2/super.c:457
       ocfs2_initialize_super fs/ocfs2/super.c:2248 [inline]
       ocfs2_fill_super+0x2f5b/0x5760 fs/ocfs2/super.c:994
       mount_bdev+0x20c/0x2d0 fs/super.c:1693
       legacy_get_tree+0xf0/0x190 fs/fs_context.c:662
       vfs_get_tree+0x92/0x2b0 fs/super.c:1814
       do_new_mount+0x2be/0xb40 fs/namespace.c:3507
       do_mount fs/namespace.c:3847 [inline]
       __do_sys_mount fs/namespace.c:4057 [inline]
       __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&oi->ip_io_mutex){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
       __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5226
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x1ac/0xee0 kernel/locking/mutex.c:735
       __ocfs2_journal_access+0x4a1/0x8a0 fs/ocfs2/journal.c:684
       ocfs2_shutdown_local_alloc+0x430/0xa90 fs/ocfs2/localalloc.c:433
       ocfs2_dismount_volume+0x1f2/0x8f0 fs/ocfs2/super.c:1877
       generic_shutdown_super+0x13b/0x2d0 fs/super.c:642
       kill_block_super+0x44/0x90 fs/super.c:1710
       deactivate_locked_super+0xc6/0x130 fs/super.c:473
       cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1373
       task_work_run+0x251/0x310 kernel/task_work.c:239
       resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
       exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
       exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
       __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
       syscall_exit_to_user_mode+0x13f/0x340 kernel/entry/common.c:218
       do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &oi->ip_io_mutex --> &mm->mmap_lock --> jbd2_handle

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(jbd2_handle);
                               lock(&mm->mmap_lock);
                               lock(jbd2_handle);
  lock(&oi->ip_io_mutex);

 *** DEADLOCK ***

5 locks held by syz.1.240/7056:
 #0: ffff88803205e0e0 (&type->s_umount_key#93){+.+.}-{4:4}, at: __super_lock fs/super.c:56 [inline]
 #0: ffff88803205e0e0 (&type->s_umount_key#93){+.+.}-{4:4}, at: __super_lock_excl fs/super.c:71 [inline]
 #0: ffff88803205e0e0 (&type->s_umount_key#93){+.+.}-{4:4}, at: deactivate_super+0xb5/0xf0 fs/super.c:505
 #1: ffff8880577c09c0 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
 #1: ffff8880577c09c0 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{4:4}, at: ocfs2_shutdown_local_alloc+0x1d9/0xa90 fs/ocfs2/localalloc.c:408
 #2: ffff88803205e610 (sb_internal#5){.+.+}-{0:0}, at: ocfs2_shutdown_local_alloc+0x218/0xa90 fs/ocfs2/localalloc.c:417
 #3: ffff888074f778e8 (&journal->j_trans_barrier){.+.+}-{4:4}, at: ocfs2_start_trans+0x3be/0x700 fs/ocfs2/journal.c:350
 #4: ffff88804bda0958 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0x1e94/0x2110 fs/jbd2/transaction.c:448

stack backtrace:
CPU: 0 UID: 0 PID: 7056 Comm: syz.1.240 Not tainted 6.12.0-syzkaller-09073-g9f16d5e6f220 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_circular_bug+0x13a/0x1b0 kernel/locking/lockdep.c:2074
 check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2206
 check_prev_add kernel/locking/lockdep.c:3161 [inline]
 check_prevs_add kernel/locking/lockdep.c:3280 [inline]
 validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
 __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5226
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
 __mutex_lock_common kernel/locking/mutex.c:585 [inline]
 __mutex_lock+0x1ac/0xee0 kernel/locking/mutex.c:735
 __ocfs2_journal_access+0x4a1/0x8a0 fs/ocfs2/journal.c:684
 ocfs2_shutdown_local_alloc+0x430/0xa90 fs/ocfs2/localalloc.c:433
 ocfs2_dismount_volume+0x1f2/0x8f0 fs/ocfs2/super.c:1877
 generic_shutdown_super+0x13b/0x2d0 fs/super.c:642
 kill_block_super+0x44/0x90 fs/super.c:1710
 deactivate_locked_super+0xc6/0x130 fs/super.c:473
 cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1373
 task_work_run+0x251/0x310 kernel/task_work.c:239
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x13f/0x340 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2bc597ffba
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f2bc66c0e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffea RBX: 00007f2bc66c0ef0 RCX: 00007f2bc597ffba
RDX: 0000000020004480 RSI: 00000000200044c0 RDI: 00007f2bc66c0eb0
RBP: 0000000020004480 R08: 00007f2bc66c0ef0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000200044c0
R13: 00007f2bc66c0eb0 R14: 0000000000004470 R15: 00000000200000c0
 </TASK>
ocfs2: Unmounting device (7,1) on (node local)


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
