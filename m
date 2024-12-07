Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB5B146A60
	for <ocfs2-devel@lists.linux.dev>; Sat,  7 Dec 2024 21:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733606783; cv=none; b=Gd8VuM7UUMTHErsFAO4Jt/Lx7Qme3pccRJhYO5vYXXGnnth723EfpIjrAOvA02QD3FoYQ9/ThWaQWbnqdqEJSYfOFeMbb5cOKO8+aqfvhFighz+kG1r0cDHb8AHKwC/4C1UuOp8wbNV6su3jptQIewmItObIvJUR/kL8PIUmlAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733606783; c=relaxed/simple;
	bh=kQooa2yAZQtm5CJI2zs+lsCX3lxw6wysKNsa6c1XgYM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=BlmtutVFi0utgfSOuzW1+7LuLViV7E+QY7e9naqzP3+/Bjz19xZxm9o5oRr+1mNebHYdH7fS3xeRXYOHukibEGNBILnu6SSAQWxnllmSHuxiZ71c4m3aK7pdNIx7FORJF6xXPNkCF989IKJmZoxy4jua+/ERRyYH2SZFJWf8mSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3a77a2d9601so36725885ab.3
        for <ocfs2-devel@lists.linux.dev>; Sat, 07 Dec 2024 13:26:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733606781; x=1734211581;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cBxfsJ7c+nMZqXEaNnnaCVoq6oaUFsTh5qLGrSo3jRY=;
        b=Xv4B0xGP9dZAuv01cqAVWsFgQH6Z3L4Z9F7Nw5Up+pXocpBBJ4zOI/fVI8ALeky0LU
         zb/15sTdP94Sg7AzOaSixOPd1kX1PkvM6CDIwtW6E6p2sl9zdLesnWADY0UvNShXOkgq
         5j8iSDwdy5FfKaz7gCuPY/JMZSR5sVnoxaV5+vwIO/EJJR9T3G4ye3L/CCnG9v8DWQXC
         MmIRth+wxwNc/xr0hLI2rzd/a3uyG9i/PQCa8WGmaR1fFoVjLEzLXpZ1JF4rRsnxFNGy
         DdeyIn5DzMjSQxiJAveorI2etTi1H/CUXvOJ8vFrkZjXGsvSV6DrbZUNH4q9RyXovvQh
         ljwA==
X-Forwarded-Encrypted: i=1; AJvYcCUJMXYl/r9ZO4LeN6ILzAUGHMs5J1WZZdYxKz2PBCVa8YOWrP+A8fqJckX+fiuXSEiqiqiYPwcmozeO2A==@lists.linux.dev
X-Gm-Message-State: AOJu0YyMaLQo6ecjZQKvr5SCfM18GzZdKigo0IncmzNz4xtWSipseBiE
	8HVhvZTSynexSnquOguZf+YnmuUAkobFTNlURXdqPezZoz9aarhmykRImsAp8H2tW+prTlGMGlV
	jln6cR5IfdPSBJ5J6aMWYkQridlQmP/QClCv0fUlgZ8WXH5DxZO4QQ/w=
X-Google-Smtp-Source: AGHT+IFVXNetjDJbyqsvkr9CAzBlOxsVGALzO8ogq2Ie52I3oPN5gKwtrmNBY57TTnh1ORQgzA/dQGHABgcGirID1NeKg/C5t6uT
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:c249:0:b0:3a7:bc2a:2522 with SMTP id
 e9e14a558f8ab-3a811d915demr73041595ab.7.1733606780912; Sat, 07 Dec 2024
 13:26:20 -0800 (PST)
Date: Sat, 07 Dec 2024 13:26:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6754bd7c.050a0220.2477f.001e.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_mark_dquot_dirty
From: syzbot <syzbot+dd17bab3ec54faea9945@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ceb8bf2ceaa7 module: Convert default symbol namespace to s..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10bff5e8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=50c7a61469ce77e7
dashboard link: https://syzkaller.appspot.com/bug?extid=dd17bab3ec54faea9945
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/0ecb23b000ef/disk-ceb8bf2c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fc78e1aa09e8/vmlinux-ceb8bf2c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e534bb3b7c6f/bzImage-ceb8bf2c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+dd17bab3ec54faea9945@syzkaller.appspotmail.com

JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,1) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
6.13.0-rc1-syzkaller-00005-gceb8bf2ceaa7 #0 Not tainted
------------------------------------------------------
syz.1.2554/13704 is trying to acquire lock:
ffff888079d7c210 (&s->s_dquot.dqio_sem){++++}-{4:4}, at: ocfs2_mark_dquot_dirty+0x609/0xe00 fs/ocfs2/quota_global.c:961

but task is already holding lock:
ffff88807d378958 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0x1e94/0x2110 fs/jbd2/transaction.c:448

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
       vm_mmap_pgoff+0x1dd/0x3d0 mm/util.c:580
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
       process_scheduled_works+0xa68/0x1840 kernel/workqueue.c:3310
       worker_thread+0x870/0xd30 kernel/workqueue.c:3391
       kthread+0x2f2/0x390 kernel/kthread.c:389
       ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #3 (&q->q_usage_counter(queue)#50){++++}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       blk_queue_enter+0xe1/0x600 block/blk-core.c:328
       blk_mq_alloc_request+0x4fa/0xaa0 block/blk-mq.c:651
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
       process_scheduled_works+0xa68/0x1840 kernel/workqueue.c:3310
       worker_thread+0x870/0xd30 kernel/workqueue.c:3391
       kthread+0x2f2/0x390 kernel/kthread.c:389
       ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #2 (&q->limits_lock){+.+.}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x1ac/0xee0 kernel/locking/mutex.c:735
       queue_limits_start_update include/linux/blkdev.h:949 [inline]
       loop_reconfigure_limits+0x43f/0x900 drivers/block/loop.c:998
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

-> #1 (&q->q_usage_counter(io)#26){++++}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       bio_queue_enter block/blk.h:75 [inline]
       blk_mq_submit_bio+0x1536/0x2390 block/blk-mq.c:3091
       __submit_bio+0x2c6/0x560 block/blk-core.c:629
       __submit_bio_noacct_mq block/blk-core.c:710 [inline]
       submit_bio_noacct_nocheck+0x4d3/0xe30 block/blk-core.c:739
       __ext4_read_bh fs/ext4/super.c:181 [inline]
       ext4_read_bh+0x1d7/0x290 fs/ext4/super.c:206
       ext4_bread+0x135/0x180 fs/ext4/inode.c:918
       ext4_quota_read+0x1b8/0x2d0 fs/ext4/super.c:7239
       read_blk fs/quota/quota_tree.c:61 [inline]
       find_tree_dqentry+0x1e5/0xfb0 fs/quota/quota_tree.c:671
       find_dqentry fs/quota/quota_tree.c:716 [inline]
       qtree_read_dquot+0x53e/0x7e0 fs/quota/quota_tree.c:736
       v2_read_dquot+0x11e/0x200 fs/quota/quota_v2.c:344
       dquot_acquire+0x194/0x680 fs/quota/dquot.c:461
       ext4_acquire_dquot+0x301/0x4c0 fs/ext4/super.c:6934
       dqget+0x772/0xeb0 fs/quota/dquot.c:975
       dquot_set_dqblk+0x2b/0xf30 fs/quota/dquot.c:2818
       quota_setquota+0x6de/0x850 fs/quota/quota.c:310
       __do_sys_quotactl fs/quota/quota.c:961 [inline]
       __se_sys_quotactl+0x2c4/0xa30 fs/quota/quota.c:917
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&s->s_dquot.dqio_sem){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
       __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5226
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       down_write+0x99/0x220 kernel/locking/rwsem.c:1577
       ocfs2_mark_dquot_dirty+0x609/0xe00 fs/ocfs2/quota_global.c:961
       mark_dquot_dirty fs/quota/dquot.c:370 [inline]
       do_set_dqblk fs/quota/dquot.c:2806 [inline]
       dquot_set_dqblk+0xcf5/0xf30 fs/quota/dquot.c:2823
       quota_setquota+0x6de/0x850 fs/quota/quota.c:310
       __do_sys_quotactl fs/quota/quota.c:961 [inline]
       __se_sys_quotactl+0x2c4/0xa30 fs/quota/quota.c:917
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &s->s_dquot.dqio_sem --> &mm->mmap_lock --> jbd2_handle

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(jbd2_handle);
                               lock(&mm->mmap_lock);
                               lock(jbd2_handle);
  lock(&s->s_dquot.dqio_sem);

 *** DEADLOCK ***

6 locks held by syz.1.2554/13704:
 #0: ffff888079d7c0e0 (&type->s_umount_key#109){++++}-{4:4}, at: __super_lock fs/super.c:58 [inline]
 #0: ffff888079d7c0e0 (&type->s_umount_key#109){++++}-{4:4}, at: super_lock+0x27c/0x400 fs/super.c:120
 #1: ffff888057641800 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#8){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
 #1: ffff888057641800 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#8){+.+.}-{4:4}, at: ocfs2_lock_global_qf+0x206/0x2b0 fs/ocfs2/quota_global.c:313
 #2: ffff8880576414a0 (&ocfs2_quota_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_lock_global_qf+0x225/0x2b0 fs/ocfs2/quota_global.c:314
 #3: ffff888079d7c610 (sb_internal#7){.+.+}-{0:0}, at: ocfs2_mark_dquot_dirty+0x576/0xe00 fs/ocfs2/quota_global.c:955
 #4: ffff88802177c0e8 (&journal->j_trans_barrier){.+.+}-{4:4}, at: ocfs2_start_trans+0x3be/0x700 fs/ocfs2/journal.c:350
 #5: ffff88807d378958 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0x1e94/0x2110 fs/jbd2/transaction.c:448

stack backtrace:
CPU: 1 UID: 0 PID: 13704 Comm: syz.1.2554 Not tainted 6.13.0-rc1-syzkaller-00005-gceb8bf2ceaa7 #0
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
 down_write+0x99/0x220 kernel/locking/rwsem.c:1577
 ocfs2_mark_dquot_dirty+0x609/0xe00 fs/ocfs2/quota_global.c:961
 mark_dquot_dirty fs/quota/dquot.c:370 [inline]
 do_set_dqblk fs/quota/dquot.c:2806 [inline]
 dquot_set_dqblk+0xcf5/0xf30 fs/quota/dquot.c:2823
 quota_setquota+0x6de/0x850 fs/quota/quota.c:310
 __do_sys_quotactl fs/quota/quota.c:961 [inline]
 __se_sys_quotactl+0x2c4/0xa30 fs/quota/quota.c:917
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe6b337ff19
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe6b423f058 EFLAGS: 00000246 ORIG_RAX: 00000000000000b3
RAX: ffffffffffffffda RBX: 00007fe6b3545fa0 RCX: 00007fe6b337ff19
RDX: 0000000000000000 RSI: 0000000020000040 RDI: ffffffff80000801
RBP: 00007fe6b33f3986 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000020000100 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007fe6b3545fa0 R15: 00007ffca6e0c278
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
