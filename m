Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2FC6F06D
	for <ocfs2-devel@lists.linux.dev>; Mon, 25 Nov 2024 03:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732506619; cv=none; b=QvR4tkeBC0O2pieQ84MSlquUOjttd6TAHW3zYQLYxepcxInywCOnegb8HeW8e3CynW4M5Iw0mLFCaVgZooejzrBSTCrHH0Knc+Ck/Lu5clWXoqbts4/1idKyKWa0XlUx5NfdmeSFzCy/OV5FvneVUALlBCr6BVh+dqldYx844bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732506619; c=relaxed/simple;
	bh=grSWf9m/ByqnxFDNHxiET3R01mPFPrUEgUmOESmOLYM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=lLpjWjNfKKCjEg5DAIrEuOQlVmL9+vuXxyHflU/ufaaMJKqtsTCvFA+mfgZwR6PsagSVws78vb55okQH9aRezTuZpBaoYr3elFZWDNiL0/CrAUq9y2Vcz3lrMuH5vLy6tvngfy6w11CyHkMnC61OC2kZSoLHw9sepVd0Ha60KV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-84181157edbso77462739f.2
        for <ocfs2-devel@lists.linux.dev>; Sun, 24 Nov 2024 19:50:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732506616; x=1733111416;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BnzPYDG7ibbxn2GLmMWaZoAYyinp5DyikidJhDJE28Y=;
        b=UtS09U5WDpxYfoZZE61EnNyNIAXLOoNiLL22lchwY25crubDS3Vt2IdpAdJ8CYYAY0
         1ZXYlnCMzIoB2f9uyiWuPUuTscLP1ct3ba5r5RhJuGNlrrD4aB4VsiOu7Gch4iz7WNT4
         /Zbdmw95ZTriZq4F7yJ5+KzwuEp7+wbc3ZiFYVl1gxAEyTpHok66GsGG8THUwJREGvuL
         mq1f0aqZXTuColLS11uc+lajgADTcQpMrip6GFgmB4IGbObaem33tpP+/lZIqzFBnE2e
         1hRSJ5WQ6Wu9f/2W15764j2ZBh/V+SDmccTKs1q4PMh558CdDd1Qbu6zMBlAT6Ut4O2k
         gehQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+VPcUFGFtU44uBDAP1BqZz+GZByv6Y/jYihKiJHaES6SnpJuRyYMPTEvVL74sEyImpccyiexL+HPswg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4hYMeqZ5DudGJ8zc/mUH6KstRntkqlChiolJ4jLHBoY/vOzee
	Q8Sr400RHcGGM8oKX/Mz5Z2W4b+xW+3u98NEwMLllJseuey8ChnzGhBajsi6zzxJqYgjKiyEMby
	82B+Jj3qcgfTHHprjUsn4GcYJOP3tiDW7UjQ5KE9m7JlhQEEcs9O0Mes=
X-Google-Smtp-Source: AGHT+IFgQUvrCHsLhF3yJ7VJx/bv1HR/HlMLT76o4b95NSvlCBKHSznbSOILwP1soLQAbromYNEj4rq/O9YEMqDdVIufIY2wt5lJ
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1609:b0:3a7:7c07:c001 with SMTP id
 e9e14a558f8ab-3a79aff16cbmr100231725ab.23.1732506616056; Sun, 24 Nov 2024
 19:50:16 -0800 (PST)
Date: Sun, 24 Nov 2024 19:50:16 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6743f3f8.050a0220.1cc393.0058.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_read_blocks
From: syzbot <syzbot+eb5c9acb3e83269a22d8@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    cfba9f07a1d6 Add linux-next specific files for 20241122
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14fcbec0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=45719eec4c74e6ba
dashboard link: https://syzkaller.appspot.com/bug?extid=eb5c9acb3e83269a22d8
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/be35516c7ba5/disk-cfba9f07.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/70295210dc7d/vmlinux-cfba9f07.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8b5d044072ee/bzImage-cfba9f07.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+eb5c9acb3e83269a22d8@syzkaller.appspotmail.com

ocfs2: Mounting device (7,8) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
6.12.0-next-20241122-syzkaller #0 Not tainted
------------------------------------------------------
syz.8.2761/14732 is trying to acquire lock:
ffff88802606a468 (&oi->ip_io_mutex){+.+.}-{4:4}, at: ocfs2_read_blocks+0x228/0x1600 fs/ocfs2/buffer_head_io.c:233

but task is already holding lock:
ffff88802606a640 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
ffff88802606a640 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4){+.+.}-{4:4}, at: ocfs2_group_extend+0x229/0xb30 fs/ocfs2/resize.c:296

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #11 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4){+.+.}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       down_write+0x99/0x220 kernel/locking/rwsem.c:1577
       inode_lock include/linux/fs.h:818 [inline]
       ocfs2_reserve_suballoc_bits+0x192/0x4eb0 fs/ocfs2/suballoc.c:786
       ocfs2_reserve_cluster_bitmap_bits+0xc5/0x1d0 fs/ocfs2/suballoc.c:1132
       ocfs2_local_alloc_reserve_for_window fs/ocfs2/localalloc.c:1125 [inline]
       ocfs2_local_alloc_slide_window fs/ocfs2/localalloc.c:1261 [inline]
       ocfs2_reserve_local_alloc_bits+0x95e/0x2870 fs/ocfs2/localalloc.c:669
       ocfs2_reserve_clusters_with_limit+0x1b8/0xb60 fs/ocfs2/suballoc.c:1166
       ocfs2_symlink+0x13a9/0x2d90 fs/ocfs2/namei.c:1919
       vfs_symlink+0x137/0x2e0 fs/namei.c:4669
       do_symlinkat+0x222/0x3a0 fs/namei.c:4695
       __do_sys_symlink fs/namei.c:4716 [inline]
       __se_sys_symlink fs/namei.c:4714 [inline]
       __x64_sys_symlink+0x7a/0x90 fs/namei.c:4714
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #10 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){+.+.}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       down_write+0x99/0x220 kernel/locking/rwsem.c:1577
       inode_lock include/linux/fs.h:818 [inline]
       ocfs2_reserve_local_alloc_bits+0x132/0x2870 fs/ocfs2/localalloc.c:636
       ocfs2_reserve_clusters_with_limit+0x1b8/0xb60 fs/ocfs2/suballoc.c:1166
       ocfs2_reserve_clusters fs/ocfs2/suballoc.c:1227 [inline]
       ocfs2_lock_allocators+0x30a/0x630 fs/ocfs2/suballoc.c:2746
       ocfs2_extend_allocation+0x4ed/0x1c20 fs/ocfs2/file.c:589
       ocfs2_extend_no_holes+0x1f6/0x4a0 fs/ocfs2/file.c:1027
       ocfs2_acquire_dquot+0x64d/0xb80 fs/ocfs2/quota_global.c:848
       dqget+0x770/0xeb0 fs/quota/dquot.c:975
       ocfs2_setattr+0xe99/0x1f00 fs/ocfs2/file.c:1233
       notify_change+0xbca/0xe90 fs/attr.c:552
       chown_common+0x501/0x850 fs/open.c:778
       do_fchownat+0x16a/0x240 fs/open.c:809
       __do_sys_lchown fs/open.c:834 [inline]
       __se_sys_lchown fs/open.c:832 [inline]
       __x64_sys_lchown+0x85/0xa0 fs/open.c:832
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #9 (&ocfs2_quota_ip_alloc_sem_key){++++}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       down_write+0x99/0x220 kernel/locking/rwsem.c:1577
       ocfs2_create_local_dquot+0x1de/0x1d70 fs/ocfs2/quota_local.c:1231
       ocfs2_acquire_dquot+0x833/0xb80 fs/ocfs2/quota_global.c:878
       dqget+0x770/0xeb0 fs/quota/dquot.c:975
       ocfs2_setattr+0xe99/0x1f00 fs/ocfs2/file.c:1233
       notify_change+0xbca/0xe90 fs/attr.c:552
       chown_common+0x501/0x850 fs/open.c:778
       do_fchownat+0x16a/0x240 fs/open.c:809
       __do_sys_lchown fs/open.c:834 [inline]
       __se_sys_lchown fs/open.c:832 [inline]
       __x64_sys_lchown+0x85/0xa0 fs/open.c:832
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #8 (&dquot->dq_lock){+.+.}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x1ac/0xee0 kernel/locking/mutex.c:735
       wait_on_dquot fs/quota/dquot.c:354 [inline]
       dqget+0x6e6/0xeb0 fs/quota/dquot.c:970
       __dquot_initialize+0x468/0xec0 fs/quota/dquot.c:1503
       __ext4_new_inode+0x852/0x4380 fs/ext4/ialloc.c:992
       ext4_xattr_inode_create fs/ext4/xattr.c:1486 [inline]
       ext4_xattr_inode_lookup_create+0xca3/0x2030 fs/ext4/xattr.c:1596
       ext4_xattr_block_set+0x274/0x3980 fs/ext4/xattr.c:1916
       ext4_xattr_set_handle+0xce0/0x1580 fs/ext4/xattr.c:2458
       __ext4_set_acl+0x54a/0x640 fs/ext4/acl.c:217
       ext4_set_acl+0x468/0x760 fs/ext4/acl.c:259
       set_posix_acl fs/posix_acl.c:954 [inline]
       vfs_set_acl+0x7fd/0xa60 fs/posix_acl.c:1133
       do_set_acl+0xf4/0x180 fs/posix_acl.c:1278
       do_setxattr fs/xattr.c:633 [inline]
       filename_setxattr+0x325/0x430 fs/xattr.c:665
       path_setxattrat+0x440/0x510 fs/xattr.c:713
       __do_sys_lsetxattr fs/xattr.c:754 [inline]
       __se_sys_lsetxattr fs/xattr.c:750 [inline]
       __x64_sys_lsetxattr+0xbf/0xe0 fs/xattr.c:750
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #7 (&ei->xattr_sem){++++}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       down_read+0xb1/0xa40 kernel/locking/rwsem.c:1524
       ext4_readpage_inline+0x36/0x6b0 fs/ext4/inline.c:518
       ext4_read_folio+0x174/0x340 fs/ext4/inode.c:3185
       filemap_read_folio+0x14b/0x630 mm/filemap.c:2366
       filemap_create_folio mm/filemap.c:2497 [inline]
       filemap_get_pages+0x100a/0x2540 mm/filemap.c:2555
       filemap_read+0x45c/0xf50 mm/filemap.c:2646
       __kernel_read+0x513/0x9d0 fs/read_write.c:523
       integrity_kernel_read+0xb0/0x100 security/integrity/iint.c:28
       ima_calc_file_hash_tfm security/integrity/ima/ima_crypto.c:480 [inline]
       ima_calc_file_shash security/integrity/ima/ima_crypto.c:511 [inline]
       ima_calc_file_hash+0xae6/0x1b30 security/integrity/ima/ima_crypto.c:568
       ima_collect_measurement+0x520/0xb10 security/integrity/ima/ima_api.c:293
       process_measurement+0x1351/0x1fb0 security/integrity/ima/ima_main.c:372
       ima_file_check+0xd9/0x120 security/integrity/ima/ima_main.c:572
       security_file_post_open+0xb9/0x280 security/security.c:3121
       do_open fs/namei.c:3830 [inline]
       path_openat+0x2ccd/0x3590 fs/namei.c:3987
       do_filp_open+0x27f/0x4e0 fs/namei.c:4014
       do_sys_openat2+0x13e/0x1d0 fs/open.c:1402
       do_sys_open fs/open.c:1417 [inline]
       __do_sys_openat fs/open.c:1433 [inline]
       __se_sys_openat fs/open.c:1428 [inline]
       __x64_sys_openat+0x247/0x2a0 fs/open.c:1428
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #6 (mapping.invalidate_lock){++++}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       down_read+0xb1/0xa40 kernel/locking/rwsem.c:1524
       filemap_invalidate_lock_shared include/linux/fs.h:873 [inline]
       page_cache_ra_unbounded+0x143/0x8c0 mm/readahead.c:226
       do_async_mmap_readahead mm/filemap.c:3231 [inline]
       filemap_fault+0x82a/0x1950 mm/filemap.c:3330
       __do_fault+0x135/0x460 mm/memory.c:4907
       do_read_fault mm/memory.c:5322 [inline]
       do_fault mm/memory.c:5456 [inline]
       do_pte_missing mm/memory.c:3979 [inline]
       handle_pte_fault+0x3c01/0x66b0 mm/memory.c:5801
       __handle_mm_fault mm/memory.c:5944 [inline]
       handle_mm_fault+0x1106/0x1bb0 mm/memory.c:6112
       faultin_page mm/gup.c:1187 [inline]
       __get_user_pages+0x1c82/0x49e0 mm/gup.c:1485
       __get_user_pages_locked mm/gup.c:1751 [inline]
       get_dump_page+0x155/0x2f0 mm/gup.c:2269
       dump_user_range+0x14d/0x970 fs/coredump.c:943
       elf_core_dump+0x3e9f/0x4790 fs/binfmt_elf.c:2127
       do_coredump+0x214b/0x2e60 fs/coredump.c:758
       get_signal+0x140b/0x1750 kernel/signal.c:3001
       arch_do_signal_or_restart+0x96/0x860 arch/x86/kernel/signal.c:337
       exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
       exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
       irqentry_exit_to_user_mode+0x7e/0x250 kernel/entry/common.c:231
       exc_page_fault+0x590/0x8c0 arch/x86/mm/fault.c:1542
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623

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
       __se_sys_ioctl+0xf5/0x170 fs/ioctl.c:892
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
       really_probe+0x2b8/0xad0 drivers/base/dd.c:658
       __driver_probe_device+0x1a2/0x390 drivers/base/dd.c:800
       driver_probe_device+0x50/0x430 drivers/base/dd.c:830
       __device_attach_driver+0x2d6/0x530 drivers/base/dd.c:958
       bus_for_each_drv+0x24e/0x2e0 drivers/base/bus.c:459
       __device_attach_async_helper+0x22d/0x300 drivers/base/dd.c:987
       async_run_entry_fn+0xa8/0x420 kernel/async.c:129
       process_one_work kernel/workqueue.c:3229 [inline]
       process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
       worker_thread+0x870/0xd30 kernel/workqueue.c:3391
       kthread+0x2f0/0x390 kernel/kthread.c:389
       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
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
       really_probe+0x2b8/0xad0 drivers/base/dd.c:658
       __driver_probe_device+0x1a2/0x390 drivers/base/dd.c:800
       driver_probe_device+0x50/0x430 drivers/base/dd.c:830
       __device_attach_driver+0x2d6/0x530 drivers/base/dd.c:958
       bus_for_each_drv+0x24e/0x2e0 drivers/base/bus.c:459
       __device_attach_async_helper+0x22d/0x300 drivers/base/dd.c:987
       async_run_entry_fn+0xa8/0x420 kernel/async.c:129
       process_one_work kernel/workqueue.c:3229 [inline]
       process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
       worker_thread+0x870/0xd30 kernel/workqueue.c:3391
       kthread+0x2f0/0x390 kernel/kthread.c:389
       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
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
       blkdev_ioctl+0x57d/0x6a0 block/ioctl.c:693
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:906 [inline]
       __se_sys_ioctl+0xf5/0x170 fs/ioctl.c:892
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&q->q_usage_counter(io)#24){++++}-{0:0}:
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
       mount_bdev+0x20a/0x2d0 fs/super.c:1693
       legacy_get_tree+0xee/0x190 fs/fs_context.c:662
       vfs_get_tree+0x90/0x2b0 fs/super.c:1814
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
       ocfs2_read_blocks+0x228/0x1600 fs/ocfs2/buffer_head_io.c:233
       ocfs2_read_inode_block_full fs/ocfs2/inode.c:1593 [inline]
       ocfs2_read_inode_block+0x106/0x1e0 fs/ocfs2/inode.c:1605
       ocfs2_assign_bh fs/ocfs2/dlmglue.c:2414 [inline]
       ocfs2_inode_lock_full_nested+0x300/0x1be0 fs/ocfs2/dlmglue.c:2509
       ocfs2_group_extend+0x246/0xb30 fs/ocfs2/resize.c:298
       ocfs2_ioctl+0x771/0x7d0 fs/ocfs2/ioctl.c:873
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:906 [inline]
       __se_sys_ioctl+0xf5/0x170 fs/ioctl.c:892
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &oi->ip_io_mutex --> &ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3 --> &ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4);
                               lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3);
                               lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4);
  lock(&oi->ip_io_mutex);

 *** DEADLOCK ***

2 locks held by syz.8.2761/14732:
 #0: ffff88803503e420 (sb_writers#15){.+.+}-{0:0}, at: mnt_want_write_file+0x5e/0x200 fs/namespace.c:559
 #1: ffff88802606a640 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
 #1: ffff88802606a640 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4){+.+.}-{4:4}, at: ocfs2_group_extend+0x229/0xb30 fs/ocfs2/resize.c:296

stack backtrace:
CPU: 0 UID: 0 PID: 14732 Comm: syz.8.2761 Not tainted 6.12.0-next-20241122-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
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
 ocfs2_read_blocks+0x228/0x1600 fs/ocfs2/buffer_head_io.c:233
 ocfs2_read_inode_block_full fs/ocfs2/inode.c:1593 [inline]
 ocfs2_read_inode_block+0x106/0x1e0 fs/ocfs2/inode.c:1605
 ocfs2_assign_bh fs/ocfs2/dlmglue.c:2414 [inline]
 ocfs2_inode_lock_full_nested+0x300/0x1be0 fs/ocfs2/dlmglue.c:2509
 ocfs2_group_extend+0x246/0xb30 fs/ocfs2/resize.c:298
 ocfs2_ioctl+0x771/0x7d0 fs/ocfs2/ioctl.c:873
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:906 [inline]
 __se_sys_ioctl+0xf5/0x170 fs/ioctl.c:892
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9bc837e819
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9bc91df038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f9bc8535fa0 RCX: 00007f9bc837e819
RDX: 00000000200000c0 RSI: 0000000040046f01 RDI: 0000000000000004
RBP: 00007f9bc83f175e R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f9bc8535fa0 R15: 00007ffd4ccc6f68
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
