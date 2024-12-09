Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15A09474
	for <ocfs2-devel@lists.linux.dev>; Mon,  9 Dec 2024 02:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733710101; cv=none; b=Psiinji9bq4dg/UKoyOU0Pezdu9vLjweCzsbj5xftRPtd3WAIp2QluQfk3Gw1qlYCwSxJCsSVvMfKXhfJsoe5yfmWrH0+E3KptKDnU0jRRpnVB4R3X3c+p6nZZVzPaPmIEj0q4O+4jB/g18GvU3BTfg2KIyKHYw7CKDSD+fbR20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733710101; c=relaxed/simple;
	bh=qWLXZEkPQF7gmXwMqALF2or+PUUskyVnccLb5FbIdnY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=KSR5oCh7iHwEt0igRjkqdyQgAFEltdjPsu8rebASk8DT0afym/7QbeBzzvzFMnR+FzSbswtKC7HAQyKVyvTY/iBLxiv3LrV0k6b+qkRdrI1/T8+ox6HKSrTuC5eFtmvQcTq/++yjVKhL0wT5UkRwHeARN3uxDwfKeC2mUwlOMqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3a9cd0b54c1so9602315ab.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 08 Dec 2024 18:08:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733710098; x=1734314898;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xn2ZHNbRYeF2dv5QXiMG3lz/0jPo9gm24tCSwSfrP7Q=;
        b=HXJ3G6PI0zUjXkgRLOjHYFFUyOI+uTw/Mp97lzVNB3ooTrKQAKeogBLjUiR0ErTMOO
         mMUlF6gOFhptAO58pFW+MnpLMpXTWJ9+0Wdu98g2KY2UIBi3CpNYF1uwmz5JAXpVGGgc
         Alpcr8831g6QBRVPbaMdZUhNQT1lG4N5HfUWnpXq+YIiKn69gucap+QSLlpyoHpwxwgP
         E2LSz2xqtYCoOSfLGjWkQAlGo/pqfv+Iv0w3/gEMUgjbon3mudsq3gvmfd8twtmtLc4p
         Xn9OYBKgSw8hA/W/XsrV3XCdHx59oAfmcy4zYMTrYxRWkEwXQViThz/4Al5MIqqlwBQb
         ZE7g==
X-Forwarded-Encrypted: i=1; AJvYcCUu/uBIPpvZJ8CbjcnylzvZSLrsPXGd/b/ZkzbJyA5IwwDhzPhmjT91gJOHSd/CJjyneCeZ9vNUF5NRrg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx8HUb4tBbBAgLnRXaNdyQGgyICu3EWhj/X++tn1xanzn6Nzkyn
	1tOO7a8KFDf90MBpON+pmaGfX8/OC6vMrsYeeqg1ozTopf5F/Yb4xnlU5NpOIirnPUBsUzyvz4F
	pHVIX3LRdARLjeEkplDrB1CHgXTlJyS/h1Z4jvdj6w2NWE3yeIbpMaUw=
X-Google-Smtp-Source: AGHT+IEq2VPVi18isp/4kwL0GOkvqM6KnU9OhT/izEIHSQpp0QDXLR4BlOlfj1N8I5JAaInTGs+3BdpN62NMMDJIXYSFtcP9u9I6
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:19c8:b0:3a7:e592:55cd with SMTP id
 e9e14a558f8ab-3a811dcca00mr114712505ab.14.1733710098047; Sun, 08 Dec 2024
 18:08:18 -0800 (PST)
Date: Sun, 08 Dec 2024 18:08:18 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67565112.050a0220.2477f.0034.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_start_trans
From: syzbot <syzbot+f1635714e1cb9816b1ac@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    feffde684ac2 Merge tag 'for-6.13-rc1-tag' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12b428df980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ad7dafcfaa48849c
dashboard link: https://syzkaller.appspot.com/bug?extid=f1635714e1cb9816b1ac
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c51d22ca6229/disk-feffde68.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/282335ac1978/vmlinux-feffde68.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d341f69bc687/bzImage-feffde68.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f1635714e1cb9816b1ac@syzkaller.appspotmail.com

ocfs2: Mounting device (7,8) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
6.13.0-rc1-syzkaller-00025-gfeffde684ac2 #0 Not tainted
------------------------------------------------------
syz.8.6075/25085 is trying to acquire lock:
ffff888021f6e0e8 (&journal->j_trans_barrier){.+.+}-{4:4}, at: ocfs2_start_trans+0x3ae/0x970 fs/ocfs2/journal.c:350

but task is already holding lock:
ffff888029b76610 (sb_internal#5){.+.+}-{0:0}, at: ocfs2_local_alloc_slide_window+0x454/0x18e0 fs/ocfs2/localalloc.c:1271

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #8 (sb_internal#5){.+.+}-{0:0}:
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1725 [inline]
       sb_start_intwrite include/linux/fs.h:1908 [inline]
       ocfs2_start_trans+0x29d/0x970 fs/ocfs2/journal.c:348
       ocfs2_update_inode_atime+0xee/0x5e0 fs/ocfs2/file.c:261
       ocfs2_inode_lock_atime+0x39a/0x3c0 fs/ocfs2/dlmglue.c:2608
       ocfs2_mmap+0xd1/0x280 fs/ocfs2/mmap.c:166
       call_mmap include/linux/fs.h:2183 [inline]
       mmap_file mm/internal.h:124 [inline]
       __mmap_new_file_vma mm/vma.c:2291 [inline]
       __mmap_new_vma mm/vma.c:2355 [inline]
       __mmap_region+0x1789/0x2670 mm/vma.c:2456
       mmap_region+0x270/0x320 mm/mmap.c:1347
       do_mmap+0xc00/0xfc0 mm/mmap.c:496
       vm_mmap_pgoff+0x1ba/0x360 mm/util.c:580
       ksys_mmap_pgoff+0x32c/0x5c0 mm/mmap.c:542
       __do_sys_mmap arch/x86/kernel/sys_x86_64.c:89 [inline]
       __se_sys_mmap arch/x86/kernel/sys_x86_64.c:82 [inline]
       __x64_sys_mmap+0x125/0x190 arch/x86/kernel/sys_x86_64.c:82
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #7 (&mm->mmap_lock){++++}-{4:4}:
       __might_fault mm/memory.c:6751 [inline]
       __might_fault+0x11b/0x190 mm/memory.c:6744
       _inline_copy_from_user include/linux/uaccess.h:162 [inline]
       _copy_from_user+0x29/0xd0 lib/usercopy.c:18
       copy_from_user include/linux/uaccess.h:212 [inline]
       __blk_trace_setup+0xa8/0x180 kernel/trace/blktrace.c:626
       blk_trace_ioctl+0x163/0x290 kernel/trace/blktrace.c:740
       blkdev_ioctl+0x109/0x6d0 block/ioctl.c:682
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:906 [inline]
       __se_sys_ioctl fs/ioctl.c:892 [inline]
       __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:892
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #6 (&q->debugfs_mutex){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x19b/0xa60 kernel/locking/mutex.c:735
       blk_mq_init_sched+0x42b/0x640 block/blk-mq-sched.c:473
       elevator_init_mq+0x2cd/0x420 block/elevator.c:610
       add_disk_fwnode+0x113/0x1300 block/genhd.c:413
       sd_probe+0xa86/0x1000 drivers/scsi/sd.c:4024
       call_driver_probe drivers/base/dd.c:579 [inline]
       really_probe+0x241/0xa90 drivers/base/dd.c:658
       __driver_probe_device+0x1de/0x440 drivers/base/dd.c:800
       driver_probe_device+0x4c/0x1b0 drivers/base/dd.c:830
       __device_attach_driver+0x1df/0x310 drivers/base/dd.c:958
       bus_for_each_drv+0x15a/0x1e0 drivers/base/bus.c:459
       __device_attach_async_helper+0x1d3/0x290 drivers/base/dd.c:987
       async_run_entry_fn+0x9f/0x530 kernel/async.c:129
       process_one_work+0x9c8/0x1ba0 kernel/workqueue.c:3229
       process_scheduled_works kernel/workqueue.c:3310 [inline]
       worker_thread+0x6c8/0xf00 kernel/workqueue.c:3391
       kthread+0x2c4/0x3a0 kernel/kthread.c:389
       ret_from_fork+0x48/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #5 (&q->q_usage_counter(queue)#50){++++}-{0:0}:
       blk_queue_enter+0x50f/0x640 block/blk-core.c:328
       blk_mq_alloc_request+0x59b/0x950 block/blk-mq.c:651
       scsi_alloc_request drivers/scsi/scsi_lib.c:1222 [inline]
       scsi_execute_cmd+0x1eb/0xf40 drivers/scsi/scsi_lib.c:304
       read_capacity_16+0x213/0xe10 drivers/scsi/sd.c:2655
       sd_read_capacity drivers/scsi/sd.c:2824 [inline]
       sd_revalidate_disk.isra.0+0x1a06/0xa8d0 drivers/scsi/sd.c:3734
       sd_probe+0x904/0x1000 drivers/scsi/sd.c:4010
       call_driver_probe drivers/base/dd.c:579 [inline]
       really_probe+0x241/0xa90 drivers/base/dd.c:658
       __driver_probe_device+0x1de/0x440 drivers/base/dd.c:800
       driver_probe_device+0x4c/0x1b0 drivers/base/dd.c:830
       __device_attach_driver+0x1df/0x310 drivers/base/dd.c:958
       bus_for_each_drv+0x15a/0x1e0 drivers/base/bus.c:459
       __device_attach_async_helper+0x1d3/0x290 drivers/base/dd.c:987
       async_run_entry_fn+0x9f/0x530 kernel/async.c:129
       process_one_work+0x9c8/0x1ba0 kernel/workqueue.c:3229
       process_scheduled_works kernel/workqueue.c:3310 [inline]
       worker_thread+0x6c8/0xf00 kernel/workqueue.c:3391
       kthread+0x2c4/0x3a0 kernel/kthread.c:389
       ret_from_fork+0x48/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #4 (&q->limits_lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x19b/0xa60 kernel/locking/mutex.c:735
       queue_limits_start_update include/linux/blkdev.h:949 [inline]
       loop_reconfigure_limits+0x407/0x8c0 drivers/block/loop.c:998
       loop_set_block_size drivers/block/loop.c:1473 [inline]
       lo_simple_ioctl drivers/block/loop.c:1496 [inline]
       lo_ioctl+0x901/0x18b0 drivers/block/loop.c:1559
       blkdev_ioctl+0x279/0x6d0 block/ioctl.c:693
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:906 [inline]
       __se_sys_ioctl fs/ioctl.c:892 [inline]
       __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:892
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #3 (&q->q_usage_counter(io)#23){++++}-{0:0}:
       bio_queue_enter block/blk.h:75 [inline]
       blk_mq_submit_bio+0x1fb6/0x24c0 block/blk-mq.c:3091
       __submit_bio+0x384/0x540 block/blk-core.c:629
       __submit_bio_noacct_mq block/blk-core.c:710 [inline]
       submit_bio_noacct_nocheck+0x698/0xd70 block/blk-core.c:739
       submit_bio_noacct+0x93a/0x1e20 block/blk-core.c:868
       ext4_commit_super+0x222/0x4c0 fs/ext4/super.c:6236
       ext4_handle_error+0x611/0x730 fs/ext4/super.c:727
       __ext4_error_inode+0x34d/0x650 fs/ext4/super.c:869
       ext4_free_branches+0x58d/0x680 fs/ext4/indirect.c:1020
       ext4_ind_truncate+0x760/0x980 fs/ext4/indirect.c:1164
       ext4_truncate+0xeaa/0x1270 fs/ext4/inode.c:4219
       ext4_process_orphan+0x154/0x410 fs/ext4/orphan.c:339
       ext4_orphan_cleanup+0x742/0x1210 fs/ext4/orphan.c:474
       __ext4_fill_super fs/ext4/super.c:5610 [inline]
       ext4_fill_super+0x9631/0xaab0 fs/ext4/super.c:5733
       get_tree_bdev_flags+0x38e/0x620 fs/super.c:1636
       vfs_get_tree+0x92/0x380 fs/super.c:1814
       do_new_mount fs/namespace.c:3507 [inline]
       path_mount+0x14e6/0x1f20 fs/namespace.c:3834
       do_mount fs/namespace.c:3847 [inline]
       __do_sys_mount fs/namespace.c:4057 [inline]
       __se_sys_mount fs/namespace.c:4034 [inline]
       __x64_sys_mount+0x294/0x320 fs/namespace.c:4034
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (&ei->i_data_sem){++++}-{4:4}:
       down_write+0x93/0x200 kernel/locking/rwsem.c:1577
       ext4_truncate+0xdd5/0x1270 fs/ext4/inode.c:4212
       ext4_setattr+0x1c64/0x2a70 fs/ext4/inode.c:5541
       notify_change+0x6a9/0x1230 fs/attr.c:552
       do_truncate+0x15c/0x220 fs/open.c:65
       do_ftruncate+0x5d9/0x720 fs/open.c:181
       do_sys_ftruncate+0x61/0xb0 fs/open.c:196
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (jbd2_handle){++++}-{0:0}:
       start_this_handle+0xf92/0x1430 fs/jbd2/transaction.c:448
       jbd2__journal_start+0x394/0x6a0 fs/jbd2/transaction.c:505
       jbd2_journal_start+0x29/0x40 fs/jbd2/transaction.c:544
       ocfs2_start_trans+0x3b9/0x970 fs/ocfs2/journal.c:352
       ocfs2_modify_bh+0xbe/0x490 fs/ocfs2/quota_local.c:101
       ocfs2_local_read_info+0xd68/0x1610 fs/ocfs2/quota_local.c:771
       dquot_load_quota_sb+0x83d/0x1050 fs/quota/dquot.c:2459
       dquot_load_quota_inode fs/quota/dquot.c:2496 [inline]
       dquot_load_quota_inode+0x2a3/0x470 fs/quota/dquot.c:2488
       ocfs2_enable_quotas+0x28b/0x5a0 fs/ocfs2/super.c:926
       ocfs2_fill_super+0x2299/0x41d0 fs/ocfs2/super.c:1141
       mount_bdev+0x1e6/0x2d0 fs/super.c:1693
       legacy_get_tree+0x10c/0x220 fs/fs_context.c:662
       vfs_get_tree+0x92/0x380 fs/super.c:1814
       do_new_mount fs/namespace.c:3507 [inline]
       path_mount+0x14e6/0x1f20 fs/namespace.c:3834
       do_mount fs/namespace.c:3847 [inline]
       __do_sys_mount fs/namespace.c:4057 [inline]
       __se_sys_mount fs/namespace.c:4034 [inline]
       __x64_sys_mount+0x294/0x320 fs/namespace.c:4034
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&journal->j_trans_barrier){.+.+}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain kernel/locking/lockdep.c:3904 [inline]
       __lock_acquire+0x249e/0x3c40 kernel/locking/lockdep.c:5226
       lock_acquire.part.0+0x11b/0x380 kernel/locking/lockdep.c:5849
       down_read+0x9a/0x330 kernel/locking/rwsem.c:1524
       ocfs2_start_trans+0x3ae/0x970 fs/ocfs2/journal.c:350
       ocfs2_local_alloc_slide_window+0x454/0x18e0 fs/ocfs2/localalloc.c:1271
       ocfs2_reserve_local_alloc_bits+0x4f0/0xc50 fs/ocfs2/localalloc.c:669
       ocfs2_reserve_clusters_with_limit+0x697/0xe80 fs/ocfs2/suballoc.c:1166
       ocfs2_expand_inline_dir.constprop.0+0x491/0x41a0 fs/ocfs2/dir.c:2837
       ocfs2_extend_dir+0x1e0/0x1c90 fs/ocfs2/dir.c:3182
       ocfs2_prepare_dir_for_insert+0x12a7/0x1700 fs/ocfs2/dir.c:4287
       ocfs2_mknod+0x8f1/0x2440 fs/ocfs2/namei.c:292
       ocfs2_create+0x185/0x450 fs/ocfs2/namei.c:672
       lookup_open.isra.0+0x1177/0x14c0 fs/namei.c:3649
       open_last_lookups fs/namei.c:3748 [inline]
       path_openat+0x904/0x2d60 fs/namei.c:3984
       do_filp_open+0x20c/0x470 fs/namei.c:4014
       do_sys_openat2+0x17a/0x1e0 fs/open.c:1402
       do_sys_open fs/open.c:1417 [inline]
       __do_sys_creat fs/open.c:1495 [inline]
       __se_sys_creat fs/open.c:1489 [inline]
       __x64_sys_creat+0xcd/0x120 fs/open.c:1489
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &journal->j_trans_barrier --> &mm->mmap_lock --> sb_internal#5

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(sb_internal#5);
                               lock(&mm->mmap_lock);
                               lock(sb_internal#5);
  rlock(&journal->j_trans_barrier);

 *** DEADLOCK ***

6 locks held by syz.8.6075/25085:
 #0: ffff888029b76420 (sb_writers#33){.+.+}-{0:0}, at: open_last_lookups fs/namei.c:3737 [inline]
 #0: ffff888029b76420 (sb_writers#33){.+.+}-{0:0}, at: path_openat+0x1f8d/0x2d60 fs/namei.c:3984
 #1: ffff888055791800 (&type->i_mutex_dir_key#26){++++}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
 #1: ffff888055791800 (&type->i_mutex_dir_key#26){++++}-{4:4}, at: open_last_lookups fs/namei.c:3745 [inline]
 #1: ffff888055791800 (&type->i_mutex_dir_key#26){++++}-{4:4}, at: path_openat+0x153e/0x2d60 fs/namei.c:3984
 #2: ffff8880557914a0 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_expand_inline_dir.constprop.0+0x3e7/0x41a0 fs/ocfs2/dir.c:2801
 #3: ffff888052c342c0 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#8){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
 #3: ffff888052c342c0 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#8){+.+.}-{4:4}, at: ocfs2_reserve_local_alloc_bits+0xf1/0xc50 fs/ocfs2/localalloc.c:636
 #4: ffff888057831800 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
 #4: ffff888057831800 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x11d/0x48e0 fs/ocfs2/suballoc.c:786
 #5: ffff888029b76610 (sb_internal#5){.+.+}-{0:0}, at: ocfs2_local_alloc_slide_window+0x454/0x18e0 fs/ocfs2/localalloc.c:1271

stack backtrace:
CPU: 1 UID: 0 PID: 25085 Comm: syz.8.6075 Not tainted 6.13.0-rc1-syzkaller-00025-gfeffde684ac2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 print_circular_bug+0x419/0x5d0 kernel/locking/lockdep.c:2074
 check_noncircular+0x31a/0x400 kernel/locking/lockdep.c:2206
 check_prev_add kernel/locking/lockdep.c:3161 [inline]
 check_prevs_add kernel/locking/lockdep.c:3280 [inline]
 validate_chain kernel/locking/lockdep.c:3904 [inline]
 __lock_acquire+0x249e/0x3c40 kernel/locking/lockdep.c:5226
 lock_acquire.part.0+0x11b/0x380 kernel/locking/lockdep.c:5849
 down_read+0x9a/0x330 kernel/locking/rwsem.c:1524
 ocfs2_start_trans+0x3ae/0x970 fs/ocfs2/journal.c:350
 ocfs2_local_alloc_slide_window+0x454/0x18e0 fs/ocfs2/localalloc.c:1271
 ocfs2_reserve_local_alloc_bits+0x4f0/0xc50 fs/ocfs2/localalloc.c:669
 ocfs2_reserve_clusters_with_limit+0x697/0xe80 fs/ocfs2/suballoc.c:1166
 ocfs2_expand_inline_dir.constprop.0+0x491/0x41a0 fs/ocfs2/dir.c:2837
 ocfs2_extend_dir+0x1e0/0x1c90 fs/ocfs2/dir.c:3182
 ocfs2_prepare_dir_for_insert+0x12a7/0x1700 fs/ocfs2/dir.c:4287
 ocfs2_mknod+0x8f1/0x2440 fs/ocfs2/namei.c:292
 ocfs2_create+0x185/0x450 fs/ocfs2/namei.c:672
 lookup_open.isra.0+0x1177/0x14c0 fs/namei.c:3649
 open_last_lookups fs/namei.c:3748 [inline]
 path_openat+0x904/0x2d60 fs/namei.c:3984
 do_filp_open+0x20c/0x470 fs/namei.c:4014
 do_sys_openat2+0x17a/0x1e0 fs/open.c:1402
 do_sys_open fs/open.c:1417 [inline]
 __do_sys_creat fs/open.c:1495 [inline]
 __se_sys_creat fs/open.c:1489 [inline]
 __x64_sys_creat+0xcd/0x120 fs/open.c:1489
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7faff157ff19
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007faff23c8058 EFLAGS: 00000246 ORIG_RAX: 0000000000000055
RAX: ffffffffffffffda RBX: 00007faff1745fa0 RCX: 00007faff157ff19
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000020000e00
RBP: 00007faff15f3986 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007faff1745fa0 R15: 00007ffe8fb9c9f8
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
