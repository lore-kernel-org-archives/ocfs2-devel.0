Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0691E200BA3
	for <ocfs2-devel@lists.linux.dev>; Wed, 27 Nov 2024 16:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732725396; cv=none; b=j6/HwlvGZ7XUd9ojvdpVnsXKim7ZHbwYUdwdBR8wZy4xzKverV9HOfHhKCRPcucwfPxB+VtJ5aKYldSWh6LZ1awlzvU0IroZUbra4EZVs2Tq+AaPZpDTVvHQ8pbOmuI4el+AwUkKqn87VkEcdXCTxwSubZqtQtslyyBXEpsvqhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732725396; c=relaxed/simple;
	bh=dl4V4BNBWcJCkcve9hl5Zg/24NXJzaOnLOqZKnDXQRI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=UZn1kO6yikMQz+KdDS2yEorgpIPkKKoUyUWxrFJzb0T0IpzpO+G2iVGVRb65ajOarCkq+hifsAr/5tKm4kbjZiv+00H5ZxB4uiZ3ofZHgXVXEdzJmnM0s7NSCEwMhUQ82+dgGsIrh8B5VPE3wbrJIYzI2TdUwJYJujTTOaWv36Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a77de12c48so77354225ab.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 27 Nov 2024 08:36:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732725393; x=1733330193;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JoC209QXL8lZkaxaW9WdcwemrX9MlbKQZwlmpmNmMVo=;
        b=Dec/aBH0Rt84r031IqVXC0bmgq4c9ei4NAAhoml6GfrqseDO315lNM9NRBW1AGDyug
         8UogONcA2b+2wr2ytl7vol+4rjuOPAgVafTZ1qFN/MP9YgqS+wAq3RT3C+9Yvg3EtT4f
         DRTQA5ciG5KlzsJjnibE/m8uH3zApVnsuWz1cg3tz1wkIU3LW0J1VcQ1r7Je3ZgcyPWY
         AJlXfcUyYoUrMATzisB2q0xjdwARNiVxyWHBRSDbNXqOBNY/cAGFH4cGxVIf0RHgI2Uz
         GeUSh7w/L10WSY2Z8cT1/KY+z+DkKiDpdqB/rIkmUKebYY8gzpVGPidPbXLrdVgGHsod
         YrYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVRBRTUsSUbWUFB7j6y6wOSgs1l/85nIGoRa8DHyHksz05TQ60oZd6ofy46k9YSEWjyP9lDXF6cYtmJjQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyhsaPo/8Ef/aP2QPjo2a70ZIz/eYAx4VLQHxjFFZolIM/vo+qu
	jfa3rKPFeEAKNzO9+oNWdIL5fvhzndaby/zlVKgH519pe5184eO8J7qSU+u2Jfk8z+lhnGudrP2
	jDZxfu0HNUwoZ0s7/x91eDU7QwYXyfHZiE4IlE3jkRcLWJRPwa4UZEMw=
X-Google-Smtp-Source: AGHT+IGkIgnT/VpG8aSEbN+Plo/CjF7ypIYS9ZKajIr8nLFV/D1+DVsW7NqW4aedoHzqDcFJhaZ6694oE7rjUm+fk0i4GPWgeg/5
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:4507:10b0:3a7:c5c8:aa53 with SMTP id
 e9e14a558f8ab-3a7c5c8aa9dmr22326135ab.13.1732725393288; Wed, 27 Nov 2024
 08:36:33 -0800 (PST)
Date: Wed, 27 Nov 2024 08:36:33 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67474a91.050a0220.21d33d.0025.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_update_inode_atime
From: syzbot <syzbot+37721597fd5383ded930@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    228a1157fb9f Merge tag '6.13-rc-part1-SMB3-client-fixes' o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1091a9c0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=461a3713d88227a7
dashboard link: https://syzkaller.appspot.com/bug?extid=37721597fd5383ded930
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/666caa5d13a8/disk-228a1157.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/19a30e0561d3/vmlinux-228a1157.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ec166161d78e/bzImage-228a1157.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+37721597fd5383ded930@syzkaller.appspotmail.com

ocfs2: Mounting device (7,3) on (node local, slot 0) with writeback data mode.
======================================================
WARNING: possible circular locking dependency detected
6.12.0-syzkaller-08446-g228a1157fb9f #0 Not tainted
------------------------------------------------------
syz.3.2938/16522 is trying to acquire lock:
ffff888029ae0610 (sb_internal#5){.+.+}-{0:0}, at: ocfs2_update_inode_atime+0xee/0x5e0 fs/ocfs2/file.c:261

but task is already holding lock:
ffff888060d8ed20 (&mm->mmap_lock){++++}-{4:4}, at: mmap_write_lock_killable include/linux/mmap_lock.h:122 [inline]
ffff888060d8ed20 (&mm->mmap_lock){++++}-{4:4}, at: vm_mmap_pgoff+0x160/0x360 mm/util.c:586

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #8 (&mm->mmap_lock){++++}-{4:4}:
       __might_fault mm/memory.c:6716 [inline]
       __might_fault+0x11b/0x190 mm/memory.c:6709
       _inline_copy_from_user include/linux/uaccess.h:162 [inline]
       _copy_from_user+0x29/0xd0 lib/usercopy.c:18
       copy_from_user include/linux/uaccess.h:212 [inline]
       __blk_trace_setup+0xa8/0x180 kernel/trace/blktrace.c:626
       blk_trace_setup+0x47/0x70 kernel/trace/blktrace.c:648
       sg_ioctl_common drivers/scsi/sg.c:1121 [inline]
       sg_ioctl+0x65e/0x2750 drivers/scsi/sg.c:1163
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:906 [inline]
       __se_sys_ioctl fs/ioctl.c:892 [inline]
       __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:892
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #7 (&q->debugfs_mutex){+.+.}-{4:4}:
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

-> #6 (&q->q_usage_counter(queue)#50){++++}-{0:0}:
       blk_queue_enter+0x50f/0x640 block/blk-core.c:328
       blk_mq_alloc_request+0x59b/0x950 block/blk-mq.c:652
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

-> #5 (&q->limits_lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x19b/0xa60 kernel/locking/mutex.c:735
       queue_limits_start_update include/linux/blkdev.h:945 [inline]
       loop_reconfigure_limits+0x2da/0x8d0 drivers/block/loop.c:1003
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

-> #4 (&q->q_usage_counter(io)#24){++++}-{0:0}:
       bio_queue_enter block/blk.h:75 [inline]
       blk_mq_submit_bio+0x1fb6/0x24c0 block/blk-mq.c:3092
       __submit_bio+0x384/0x540 block/blk-core.c:629
       __submit_bio_noacct_mq block/blk-core.c:710 [inline]
       submit_bio_noacct_nocheck+0x698/0xd70 block/blk-core.c:739
       submit_bio_noacct+0x93a/0x1e20 block/blk-core.c:868
       __ext4_read_bh fs/ext4/super.c:181 [inline]
       ext4_read_bh+0x19d/0x310 fs/ext4/super.c:206
       ext4_read_bh_lock+0x80/0xd0 fs/ext4/super.c:221
       ext4_bread+0x130/0x190 fs/ext4/inode.c:918
       ext4_quota_read+0x1c0/0x310 fs/ext4/super.c:7239
       find_tree_dqentry+0xb3/0xb40 fs/quota/quota_tree.c:671
       find_dqentry fs/quota/quota_tree.c:716 [inline]
       qtree_read_dquot+0x46a/0x8a0 fs/quota/quota_tree.c:736
       v2_read_dquot+0x163/0x210 fs/quota/quota_v2.c:344
       dquot_acquire+0x1bb/0x6f0 fs/quota/dquot.c:461
       ext4_acquire_dquot+0x27f/0x4e0 fs/ext4/super.c:6934
       dqget+0x694/0x1160 fs/quota/dquot.c:975
       __dquot_initialize+0x588/0xd50 fs/quota/dquot.c:1503
       ext4_xattr_set+0xcf/0x360 fs/ext4/xattr.c:2544
       __vfs_setxattr+0x176/0x1e0 fs/xattr.c:200
       __vfs_setxattr_noperm+0x127/0x660 fs/xattr.c:234
       __vfs_setxattr_locked+0x182/0x260 fs/xattr.c:295
       vfs_setxattr+0x146/0x360 fs/xattr.c:321
       do_setxattr+0x142/0x170 fs/xattr.c:636
       filename_setxattr+0x16d/0x1d0 fs/xattr.c:665
       path_setxattrat+0x1e0/0x290 fs/xattr.c:713
       __do_sys_lsetxattr fs/xattr.c:754 [inline]
       __se_sys_lsetxattr fs/xattr.c:750 [inline]
       __x64_sys_lsetxattr+0xc9/0x140 fs/xattr.c:750
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #3 (&s->s_dquot.dqio_sem){++++}-{4:4}:
       down_write+0x93/0x200 kernel/locking/rwsem.c:1577
       ocfs2_mark_dquot_dirty+0x628/0xf60 fs/ocfs2/quota_global.c:961
       mark_dquot_dirty fs/quota/dquot.c:370 [inline]
       do_set_dqblk fs/quota/dquot.c:2806 [inline]
       dquot_set_dqblk+0x7d8/0x1230 fs/quota/dquot.c:2823
       quota_setquota+0x4c8/0x5f0 fs/quota/quota.c:310
       do_quotactl+0xb00/0x13d0 fs/quota/quota.c:802
       __do_sys_quotactl fs/quota/quota.c:961 [inline]
       __se_sys_quotactl fs/quota/quota.c:917 [inline]
       __x64_sys_quotactl+0x1b4/0x440 fs/quota/quota.c:917
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (jbd2_handle){++++}-{0:0}:
       start_this_handle+0xf92/0x1430 fs/jbd2/transaction.c:448
       jbd2__journal_start+0x394/0x6a0 fs/jbd2/transaction.c:505
       jbd2_journal_start+0x29/0x40 fs/jbd2/transaction.c:544
       ocfs2_start_trans+0x3b9/0x970 fs/ocfs2/journal.c:352
       ocfs2_mknod+0xbcf/0x2440 fs/ocfs2/namei.c:359
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

-> #1 (&journal->j_trans_barrier){.+.+}-{4:4}:
       down_read+0x9a/0x330 kernel/locking/rwsem.c:1524
       ocfs2_start_trans+0x3ae/0x970 fs/ocfs2/journal.c:350
       ocfs2_mknod+0xbcf/0x2440 fs/ocfs2/namei.c:359
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

-> #0 (sb_internal#5){.+.+}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain kernel/locking/lockdep.c:3904 [inline]
       __lock_acquire+0x249e/0x3c40 kernel/locking/lockdep.c:5226
       lock_acquire.part.0+0x11b/0x380 kernel/locking/lockdep.c:5849
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1725 [inline]
       sb_start_intwrite include/linux/fs.h:1908 [inline]
       ocfs2_start_trans+0x29d/0x970 fs/ocfs2/journal.c:348
       ocfs2_update_inode_atime+0xee/0x5e0 fs/ocfs2/file.c:261
       ocfs2_inode_lock_atime+0x39a/0x3c0 fs/ocfs2/dlmglue.c:2608
       ocfs2_mmap+0xd1/0x280 fs/ocfs2/mmap.c:166
       call_mmap include/linux/fs.h:2183 [inline]
       mmap_file mm/internal.h:123 [inline]
       __mmap_region+0x1280/0x21c0 mm/mmap.c:1453
       mmap_region+0x270/0x320 mm/mmap.c:1603
       do_mmap+0xc00/0xfc0 mm/mmap.c:496
       vm_mmap_pgoff+0x1ba/0x360 mm/util.c:588
       ksys_mmap_pgoff+0x32c/0x5c0 mm/mmap.c:542
       __do_sys_mmap arch/x86/kernel/sys_x86_64.c:86 [inline]
       __se_sys_mmap arch/x86/kernel/sys_x86_64.c:79 [inline]
       __x64_sys_mmap+0x125/0x190 arch/x86/kernel/sys_x86_64.c:79
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  sb_internal#5 --> &q->debugfs_mutex --> &mm->mmap_lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&mm->mmap_lock);
                               lock(&q->debugfs_mutex);
                               lock(&mm->mmap_lock);
  rlock(sb_internal#5);

 *** DEADLOCK ***

1 lock held by syz.3.2938/16522:
 #0: ffff888060d8ed20 (&mm->mmap_lock){++++}-{4:4}, at: mmap_write_lock_killable include/linux/mmap_lock.h:122 [inline]
 #0: ffff888060d8ed20 (&mm->mmap_lock){++++}-{4:4}, at: vm_mmap_pgoff+0x160/0x360 mm/util.c:586

stack backtrace:
CPU: 1 UID: 0 PID: 16522 Comm: syz.3.2938 Not tainted 6.12.0-syzkaller-08446-g228a1157fb9f #0
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
 percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
 __sb_start_write include/linux/fs.h:1725 [inline]
 sb_start_intwrite include/linux/fs.h:1908 [inline]
 ocfs2_start_trans+0x29d/0x970 fs/ocfs2/journal.c:348
 ocfs2_update_inode_atime+0xee/0x5e0 fs/ocfs2/file.c:261
 ocfs2_inode_lock_atime+0x39a/0x3c0 fs/ocfs2/dlmglue.c:2608
 ocfs2_mmap+0xd1/0x280 fs/ocfs2/mmap.c:166
 call_mmap include/linux/fs.h:2183 [inline]
 mmap_file mm/internal.h:123 [inline]
 __mmap_region+0x1280/0x21c0 mm/mmap.c:1453
 mmap_region+0x270/0x320 mm/mmap.c:1603
 do_mmap+0xc00/0xfc0 mm/mmap.c:496
 vm_mmap_pgoff+0x1ba/0x360 mm/util.c:588
 ksys_mmap_pgoff+0x32c/0x5c0 mm/mmap.c:542
 __do_sys_mmap arch/x86/kernel/sys_x86_64.c:86 [inline]
 __se_sys_mmap arch/x86/kernel/sys_x86_64.c:79 [inline]
 __x64_sys_mmap+0x125/0x190 arch/x86/kernel/sys_x86_64.c:79
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f980217e819
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9802edc038 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 00007f9802335fa0 RCX: 00007f980217e819
RDX: 0000000000000002 RSI: 0000000000002000 RDI: 0000000020000000
RBP: 00007f98021f175e R08: 0000000000000004 R09: 0000000000000000
R10: 0000000000000011 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f9802335fa0 R15: 00007ffda36d9788
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
