Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F316E3BF66D
	for <ocfs2-devel@lists.linux.dev>; Fri, 26 Jun 2026 21:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782509250; cv=none; b=UejNrNprycAFeoooniQMP6qMQp6NUQ9NGCQ8kcUUN+ZXiUqbT7xZQe41O11mdkYgfbNOTkw6t1HV0HHkinAU+5+kj2yOpWDc0mBzru+UNB+TnQGSd7q9ptwEwO1fpBtpk1L0ORP39JaBEvNb2KwM4EH5/kOW5d1ccPV3/iPRO20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782509250; c=relaxed/simple;
	bh=4e+0NprnVqRnc6Ycvp0XkMJlor2fj4SQRsR2M8zQXR8=;
	h=Message-ID:Date:Subject:To:Cc:Content-Type:MIME-Version:From; b=F7M9Z0ec2NTVl7M12Rc3bmLWgd+fy49Qxf7i3GvjlpKncFEUkMs6mT7O5TrHUXBkg3cEzK/bcTu5s5F9n09Wdp0k9jEOdIYjT1HQr0ceoOlKbmImSmBiErQ7TFxKrC3kN+pmKcvS9i9idnZnLm8FYfTE4zqT1hPquR5QRFtrVOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QKjbPGAJ; arc=none smtp.client-ip=209.85.217.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QKjbPGAJ"
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-736b7b43ccfso3165137.3
        for <ocfs2-devel@lists.linux.dev>; Fri, 26 Jun 2026 14:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782509248; x=1783114048; darn=lists.linux.dev;
        h=from:mime-version:content-transfer-encoding:content-type:cc:to
         :subject:date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0FH+rnMA5bkxdnQwQTWW4oO24zbz09eQ0koapcwxhH0=;
        b=QKjbPGAJOYteLytxBQhoZPDz9cRQ9BL5CY2MDAYJZM6XvSACd0gPDElpxc4PVl7xrz
         tmRy4XN72F8cJImDHn4PTc3esE8uHab5hcM1CgcZd5bzb75dAfheTInqs866YDYiYJIX
         v6QQXyV+9NnWntQ5z0qr7SpWVzEQ+5KEJJze+ORkO0YMYHBbQohHzJ8n1v0LdWp1ECOU
         rXoa7+kx5Bt+BD6QeixUOvXXA/QUPq0HfA1/Deu66rMI9pYonnxSsPZR8dxufZQmT/Yp
         7GMtHBqoWIl6m6MzXSfCzJ+unrr4Em17F7qpUrcekp60LKCfhKtLKlQHKlGwhgFMRLnF
         QzTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782509248; x=1783114048;
        h=from:mime-version:content-transfer-encoding:content-type:cc:to
         :subject:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=0FH+rnMA5bkxdnQwQTWW4oO24zbz09eQ0koapcwxhH0=;
        b=hjDwI8u5QR+mjJjTdX3qf9AiicNNV2SKMYX3sMCgWgf6Hx/m6TRBAbUh4T0BX5IdDC
         ZSRMCnFKu7UW0RkfQ68h1Jh3NfMF4K8LjfDBDKCe4zMfTYCBEQrafY7DlmLTqOx0idLM
         f07CFktN86+cCUBrcrMfRQIeUu0xifctTsHCb0BsJgvVCtRkMfcRz8dGFWjPATORLGax
         Z8mSH+YIfIgbmmNGp6OESd9sjNzVDHJ5PaCi3vlJREASpC5Jk72Lz9U+WlIBN3e6lVVM
         ADcgEjAPYv1p3ihDhDquYfsmA+KPITqeY1Qj7yEq4+8gtf43/NPypKZrmJeNUhV8LSyn
         2SkQ==
X-Forwarded-Encrypted: i=1; AHgh+RoO4fEpJ6US8M2KDRDDD8cDZuyAUBqUfEyAsEEzWhBCfsz0nMYnm66s2iKTsuiwO0Qi4fcCSdpGD+O/Cg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyj0pUGNrqGAcVKnbG5ckN+eYYoJdqvD/d2uY0Vvd4zOllfqWxp
	YXNcG9IuceoEV48/hCtVAnmRPQriTBeu/dEF21a7CsazSgrxZT1bHfxT
X-Gm-Gg: AfdE7clxQZfaqBTbCoRdmppIBNzOnue2DNMUQsJFY8rED6gCqSGUYavJealecJdMPr+
	UPtepDyNJIp7McDHdWHSQBPxSu+qWyQln45C0RW5azT82bfC8rULrV6nrCp1gS0sZXf8pFhlRLG
	5S6anosC94slX2ubtc6titWp1BfkIVkg0bC/dTS6OTLW6PKwtt9Xs7t9DzzTIKHVDL0GY/gLhky
	2VT3C48xDlwdaTye2V3F9USck/YRlHSSGjekcfP9hZlX2WPOnkPu8owHd7+OlNJbXo7mSu4g39K
	B1IHbz3lDIM6R6Ii8WIGU53kdTq8PecPV9Dr+/+xxkftIaMArPUYXu4d6aVnHBrms8O7FjJNzfp
	9S0SQiL+rkxORImJN6vsMZ90obPHftZUU0Lu7R7m3TFnBfCDGnVBnsWolL+sL6qIErlTFUVEbim
	YkAx7SehRjmLfvrFXFc5IEIXHiXvBM5zU5CiQ2K9dUT/AWTs6RIhKT9EEFkZT4D4bxJ1WIamJUC
	hjoTe4+mINh
X-Received: by 2002:a05:6102:2b94:b0:631:4d32:a86 with SMTP id ada2fe7eead31-73436af6676mr1414036137.7.1782509247919;
        Fri, 26 Jun 2026 14:27:27 -0700 (PDT)
Received: from [192.168.10.115] ([132.170.207.48])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-9691704797fsm1683527241.10.2026.06.26.14.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 14:27:27 -0700 (PDT)
Message-ID: <6a3eeebf.69ba1f9d.22b155.4f82@mx.google.com>
Date: Fri, 26 Jun 2026 14:27:27 -0700 (PDT)
Subject: possible deadlock in ocfs2_reserve_suballoc_bits
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Cc: syzkaller@googlegroups.com, contact@pgazz.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: sanan.hasanou@gmail.com

Good day, dear maintainers,

We found a bug using a modified version of syzkaller.

Kernel Branch: 7.0-rc1
Kernel Config: <https://drive.google.com/open?id=1pN21FuDB9QSbn_3jaZGO1S5v7x7Qe-yl>
Reproducer: <https://drive.google.com/open?id=15-cf1VkZkONsoO8rIBctEFJLxKxRJoEq>
Thank you!

Best regards,
Sanan Hasanov

JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,5) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
7.0.0-rc1 #1 Not tainted
------------------------------------------------------
syz.5.5814/32747 is trying to acquire lock:
ffff8880200209c0 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1028 [inline]
ffff8880200209c0 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x164/0x4520 fs/ocfs2/suballoc.c:857

but task is already holding lock:
ffff88801b200660 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_expand_inline_dir fs/ocfs2/dir.c:2846 [inline]
ffff88801b200660 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_extend_dir+0x623/0x4780 fs/ocfs2/dir.c:3227

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #5 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}:
       down_write+0x96/0x1e0 kernel/locking/rwsem.c:1590
       ocfs2_try_remove_refcount_tree+0xb6/0x320 fs/ocfs2/refcounttree.c:933
       ocfs2_xattr_set+0x5c1/0x1220 fs/ocfs2/xattr.c:3700
       ocfs2_set_acl+0x701/0x7b0 fs/ocfs2/acl.c:255
       ocfs2_iop_set_acl+0x1aa/0x2a0 fs/ocfs2/acl.c:287
       set_posix_acl fs/posix_acl.c:955 [inline]
       vfs_set_acl+0x8f9/0xbf0 fs/posix_acl.c:1134
       do_setxattr fs/xattr.c:633 [inline]
       filename_setxattr+0x2f4/0x610 fs/xattr.c:664
       path_setxattrat+0x356/0x3a0 fs/xattr.c:708
       __do_sys_setxattr fs/xattr.c:742 [inline]
       __se_sys_setxattr fs/xattr.c:738 [inline]
       __x64_sys_setxattr+0xbc/0xd0 fs/xattr.c:738
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x11c/0x800 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x4b/0x53

-> #4 (&oi->ip_xattr_sem){++++}-{4:4}:
       down_read+0x97/0x2c0 kernel/locking/rwsem.c:1537
       ocfs2_init_acl+0x2f7/0x7a0 fs/ocfs2/acl.c:367
       ocfs2_mknod+0x128d/0x20d0 fs/ocfs2/namei.c:414
       ocfs2_create+0x160/0x3e0 fs/ocfs2/namei.c:677
       lookup_open fs/namei.c:4483 [inline]
       open_last_lookups fs/namei.c:4583 [inline]
       path_openat+0x1388/0x3730 fs/namei.c:4827
       do_file_open+0x203/0x440 fs/namei.c:4859
       do_sys_openat2+0x105/0x1d0 fs/open.c:1366
       do_sys_open fs/open.c:1372 [inline]
       __do_sys_openat fs/open.c:1388 [inline]
       __se_sys_openat fs/open.c:1383 [inline]
       __x64_sys_openat+0x138/0x160 fs/open.c:1383
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x11c/0x800 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x4b/0x53

-> #3 (&journal->j_trans_barrier){.+.+}-{4:4}:
       down_read+0x97/0x2c0 kernel/locking/rwsem.c:1537
       ocfs2_start_trans+0x36a/0x6d0 fs/ocfs2/journal.c:369
       ocfs2_shutdown_local_alloc+0x1ff/0x9f0 fs/ocfs2/localalloc.c:417
       ocfs2_dismount_volume+0x1aa/0x850 fs/ocfs2/super.c:1825
       generic_shutdown_super+0x137/0x2c0 fs/super.c:646
       kill_block_super+0x44/0x90 fs/super.c:1725
       deactivate_locked_super+0xb6/0x410 fs/super.c:476
       cleanup_mnt+0x320/0x3a0 fs/namespace.c:1312
       task_work_run+0x1ce/0x250 kernel/task_work.c:233
       resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
       __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
       exit_to_user_mode_loop+0xef/0x4d0 kernel/entry/common.c:98
       __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
       syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
       syscall_exit_to_user_mode include/linux/entry-common.h:325 [inline]
       do_syscall_64+0x292/0x800 arch/x86/entry/syscall_64.c:100
       entry_SYSCALL_64_after_hwframe+0x4b/0x53

-> #2 (sb_internal#2){.+.+}-{0:0}:
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs/super.h:19 [inline]
       sb_start_intwrite include/linux/fs/super.h:177 [inline]
       ocfs2_start_trans+0x26b/0x6d0 fs/ocfs2/journal.c:367
       ocfs2_mknod+0xdfb/0x20d0 fs/ocfs2/namei.c:365
       ocfs2_create+0x160/0x3e0 fs/ocfs2/namei.c:677
       lookup_open fs/namei.c:4483 [inline]
       open_last_lookups fs/namei.c:4583 [inline]
       path_openat+0x1388/0x3730 fs/namei.c:4827
       do_file_open+0x203/0x440 fs/namei.c:4859
       do_sys_openat2+0x105/0x1d0 fs/open.c:1366
       do_sys_open fs/open.c:1372 [inline]
       __do_sys_openat fs/open.c:1388 [inline]
       __se_sys_openat fs/open.c:1383 [inline]
       __x64_sys_openat+0x138/0x160 fs/open.c:1383
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x11c/0x800 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x4b/0x53

-> #1 (&ocfs2_sysfile_lock_key[LOCAL_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
       down_write+0x96/0x1e0 kernel/locking/rwsem.c:1590
       inode_lock include/linux/fs.h:1028 [inline]
       ocfs2_reserve_local_alloc_bits+0x12a/0x2980 fs/ocfs2/localalloc.c:636
       ocfs2_reserve_clusters_with_limit+0x1be/0xba0 fs/ocfs2/suballoc.c:1237
       ocfs2_mknod+0xda8/0x20d0 fs/ocfs2/namei.c:358
       ocfs2_create+0x160/0x3e0 fs/ocfs2/namei.c:677
       lookup_open fs/namei.c:4483 [inline]
       open_last_lookups fs/namei.c:4583 [inline]
       path_openat+0x1388/0x3730 fs/namei.c:4827
       do_file_open+0x203/0x440 fs/namei.c:4859
       do_sys_openat2+0x105/0x1d0 fs/open.c:1366
       do_sys_open fs/open.c:1372 [inline]
       __do_sys_openat fs/open.c:1388 [inline]
       __se_sys_openat fs/open.c:1383 [inline]
       __x64_sys_openat+0x138/0x160 fs/open.c:1383
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x11c/0x800 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x4b/0x53

-> #0 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x1591/0x2870 kernel/locking/lockdep.c:5237
       lock_acquire+0xe0/0x290 kernel/locking/lockdep.c:5868
       down_write+0x96/0x1e0 kernel/locking/rwsem.c:1590
       inode_lock include/linux/fs.h:1028 [inline]
       ocfs2_reserve_suballoc_bits+0x164/0x4520 fs/ocfs2/suballoc.c:857
       ocfs2_reserve_new_metadata_blocks+0x403/0x940 fs/ocfs2/suballoc.c:1053
       ocfs2_expand_inline_dir fs/ocfs2/dir.c:2865 [inline]
       ocfs2_extend_dir+0xc2b/0x4780 fs/ocfs2/dir.c:3227
       ocfs2_prepare_dir_for_insert+0x3080/0x4e90 fs/ocfs2/dir.c:4345
       ocfs2_mknod+0x7e3/0x20d0 fs/ocfs2/namei.c:298
       ocfs2_mkdir+0x160/0x3f0 fs/ocfs2/namei.c:660
       vfs_mkdir+0x408/0x620 fs/namei.c:5233
       filename_mkdirat+0x27b/0x500 fs/namei.c:5266
       __do_sys_mkdirat fs/namei.c:5287 [inline]
       __se_sys_mkdirat fs/namei.c:5284 [inline]
       __x64_sys_mkdirat+0x8f/0x190 fs/namei.c:5284
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x11c/0x800 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x4b/0x53

other info that might help us debug this:

Chain exists of:
  &ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE] --> &oi->ip_xattr_sem --> &ocfs2_file_ip_alloc_sem_key

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_file_ip_alloc_sem_key);
                               lock(&oi->ip_xattr_sem);
                               lock(&ocfs2_file_ip_alloc_sem_key);
  lock(&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]);

 *** DEADLOCK ***

3 locks held by syz.5.5814/32747:
 #0: ffff8880208d2410 (sb_writers#27){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:493
 #1: ffff88801b2009c0 (&type->i_mutex_dir_key#20/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1073 [inline]
 #1: ffff88801b2009c0 (&type->i_mutex_dir_key#20/1){+.+.}-{4:4}, at: __start_dirop fs/namei.c:2923 [inline]
 #1: ffff88801b2009c0 (&type->i_mutex_dir_key#20/1){+.+.}-{4:4}, at: start_dirop fs/namei.c:2934 [inline]
 #1: ffff88801b2009c0 (&type->i_mutex_dir_key#20/1){+.+.}-{4:4}, at: filename_create+0x1fb/0x360 fs/namei.c:4922
 #2: ffff88801b200660 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_expand_inline_dir fs/ocfs2/dir.c:2846 [inline]
 #2: ffff88801b200660 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_extend_dir+0x623/0x4780 fs/ocfs2/dir.c:3227

stack backtrace:
CPU: 0 UID: 0 PID: 32747 Comm: syz.5.5814 Not tainted 7.0.0-rc1 #1 PREEMPT(full) 
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2f8/0x340 kernel/locking/lockdep.c:2043
 check_noncircular+0x109/0x130 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x1591/0x2870 kernel/locking/lockdep.c:5237
 lock_acquire+0xe0/0x290 kernel/locking/lockdep.c:5868
 down_write+0x96/0x1e0 kernel/locking/rwsem.c:1590
 inode_lock include/linux/fs.h:1028 [inline]
 ocfs2_reserve_suballoc_bits+0x164/0x4520 fs/ocfs2/suballoc.c:857
 ocfs2_reserve_new_metadata_blocks+0x403/0x940 fs/ocfs2/suballoc.c:1053
 ocfs2_expand_inline_dir fs/ocfs2/dir.c:2865 [inline]
 ocfs2_extend_dir+0xc2b/0x4780 fs/ocfs2/dir.c:3227
 ocfs2_prepare_dir_for_insert+0x3080/0x4e90 fs/ocfs2/dir.c:4345
 ocfs2_mknod+0x7e3/0x20d0 fs/ocfs2/namei.c:298
 ocfs2_mkdir+0x160/0x3f0 fs/ocfs2/namei.c:660
 vfs_mkdir+0x408/0x620 fs/namei.c:5233
 filename_mkdirat+0x27b/0x500 fs/namei.c:5266
 __do_sys_mkdirat fs/namei.c:5287 [inline]
 __se_sys_mkdirat fs/namei.c:5284 [inline]
 __x64_sys_mkdirat+0x8f/0x190 fs/namei.c:5284
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x11c/0x800 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x4b/0x53
RIP: 0033:0x7f9b77fa25cb
Code: 0f 1e fa 48 89 f2 b9 00 01 00 00 48 89 fe bf 9c ff ff ff e9 17 f7 ff ff 0f 1f 80 00 00 00 00 f3 0f 1e fa b8 02 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9b78dafe28 EFLAGS: 00000246 ORIG_RAX: 0000000000000102
RAX: ffffffffffffffda RBX: 0000200000000d40 RCX: 00007f9b77fa25cb
RDX: 00000000000001ff RSI: 0000200000000680 RDI: 00000000ffffff9c
RBP: 0000200000000080 R08: 0000000000000001 R09: 0000000000000000
R10: 0000200000000080 R11: 0000000000000246 R12: 0000200000000680
R13: 00007f9b78dafe80 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
OCFS2: ERROR (device loop5): int ocfs2_validate_gd_self(struct super_block *, struct buffer_head *, int): Group descriptor #20 has bad signature 
On-disk corruption discovered. Please run fsck.ocfs2 once the filesystem is unmounted.
OCFS2: File system is now read-only.
(syz.5.5814,32747,1):ocfs2_search_chain:1888 ERROR: status = -30
(syz.5.5814,32747,1):ocfs2_search_chain:2011 ERROR: status = -30
(syz.5.5814,32747,1):ocfs2_claim_suballoc_bits:2098 ERROR: status = -30
(syz.5.5814,32747,1):ocfs2_claim_suballoc_bits:2151 ERROR: status = -30
(syz.5.5814,32747,1):ocfs2_claim_metadata:2176 ERROR: status = -30
(syz.5.5814,32747,1):ocfs2_claim_metadata:2189 ERROR: status = -30
(syz.5.5814,32747,1):ocfs2_dx_dir_attach_index:2357 ERROR: status = -30
(syz.5.5814,32747,1):ocfs2_expand_inline_dir:3049 ERROR: status = -30
(syz.5.5814,32747,1):ocfs2_extend_dir:3231 ERROR: status = -30
(syz.5.5814,32747,1):ocfs2_prepare_dir_for_insert:4349 ERROR: status = -30
(syz.5.5814,32747,1):ocfs2_mknod:302 ERROR: status = -30
(syz.5.5814,32747,1):ocfs2_mknod:506 ERROR: status = -30
(syz.5.5814,32747,1):ocfs2_mkdir:662 ERROR: status = -30

<<<<<<<<<<<<<<< tail report >>>>>>>>>>>>>>>
