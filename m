Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5226C3F210A
	for <ocfs2-devel@lists.linux.dev>; Tue,  4 Aug 2026 09:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785836166; cv=none; b=GhOlbuch8OQGWTZ0+b+yI+SIMMY564JVrAYX45jcbhyw9bQRlBb2GiUdR6lDANxlDFIyDbUmVZoF50H8EiIQvl6eMcmx4ujLfnulqr8JVvRkSkSHEZZcxZVkUagcTZEfYQF1W1KhLK7v/ENBBhxXMbs9EdEb+ZuuFg0SPxNP9hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785836166; c=relaxed/simple;
	bh=2m3J4AWx5HbMm1ngdju3UquEDfHXddtULQZybCD0a0g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UH6AAkwa2LScvnpjL6VCcJsv1aQ6+KwJZryG8e1z6FeoiD+xrK+1z8VaOzJsKeqB3+RuokT7HQaYPU1t2Tp0KCFH5WKcV65iChqN5gmKyOFgnkr+kGnNjbPrAOWggaZvw5JTMTc4X3GRUZdbGa3nCqIIou+cw9jOSfzhWwrBleE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nhzp0Dte; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nhzp0Dte"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cea3004256so48383945ad.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 04 Aug 2026 02:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785836150; x=1786440950; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zgwG+Y2OoJZe+95Tnfh3eYocmZmbsshoqNYLjGZMgvE=;
        b=Nhzp0DteUPkI5wh7NpvDZ4AOUlSsGu51YfwPUbX0TRa0TCSJYzcmQzhwBItpC95svP
         JOWPMOTeaaK1kf1qbowT+8HFfotXtDrngt9heFfY+Y265W7m0GKpdGuRw5QL7WtbRAGs
         A4Pne3R5pjykwHbd8LO75ZH2AkZwc7fBGaecT1M+dwTVeMKi7TFo3b3MJB/B+lC552f9
         dLPiARs1sH03lHCoCtLhQO0cE8TlivjxxgI9ng5BQQlJtQ5mSYLC5dv0ScZRvwa7UDoF
         cjQ297CCTjjvLZZvwnZazRpvo3aE0ZJFZBJsRQoy0XCKmNag3y9VKSrYrfk4t4Hb+0zH
         pA0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785836150; x=1786440950;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zgwG+Y2OoJZe+95Tnfh3eYocmZmbsshoqNYLjGZMgvE=;
        b=HFKHy3smCunqCkdEK/B77ZfycrWtVR6Fb2tMdpRp0NdCsV+BZ3YVJEtZICAuxTu3BZ
         sscQ5IxYhDjyCNciSFLzSYNAeHHy4IWEwdJ5JGD33wwvASPXERndfjDWs65Av15XrkWP
         slLpPJdiGJkIp/PV+0XuwuuH1ArBStQ5UESdQavhZVSQo2iuT8HmiK5LqoMx2+Q00GTs
         YdzXLyKm0ZQL4MU1kD+qUdf7sZV19eZjqBUI1BtJ7ApSNPVH+gY0JKvKaFmCW3lNGGQQ
         m4FmsH60kV3zZRIFX2abSrtgilBlXPD5x6gzjt73uI8Mu8AcqCmLjzy9VrpBoNYYAczb
         E2pQ==
X-Gm-Message-State: AOJu0Yz64DJxlc1uy2DFR7q4N/QMXsFSChm3SbEtUATCV/lx8RlC1y8f
	G8RHADY+HI8ty5ASaDS3UIqTOPrhAWDUoNS04fjlqMgURzGUBvTbJONn
X-Gm-Gg: AR+sD10drvJUGsKE5UvWm7/6FKM50AtSkGlNWCWG/GSqnvG40GqqKNHBSYgo7ymq2mA
	VkmimMtv3Bk8/gVkirXMGC4XRgcdGRHs8ZXNPOGQxFNg1RamBckqJ+dCmzGuL/T2AKKvuNT2KDg
	8TVxel1FJrOmubga2NXM4upYCMIi1WMrVs79DHuSn5QkLWSxAeEs3MQuTeEObwT9yc/926QhHgP
	kRzTP+I6vuDPeE/6HX/mHNjLZ7H6OSeAJ6jDD8BlAHScqJ8YyzmwSF4lfAmIqAT5D0lK178Exxf
	2hTYvV2qN6tDaSos4g7KV7JR3fptfLubg5OJhrAReBQMtoPTIoBUmJr+zI0BP7/nxNBzhkoFQi/
	HiMkoiZkpxAmJ5o7TAPDDozt39A37n6vCV0mmJYsGiXWGWlgK/AdsoxHc0/OU59Jo3W/6xUZKT1
	d171Y59/leUlxNH5Ptt0kmzQHlOz4AyWfxawqiq8D5ziLMfQgpJQNvn5oNsZAEx8ELiZfBOr5g+
	op5MP+XR7Gxj0xfJ79hqsNjDWs4cmFETAMnNotSrQ==
X-Received: by 2002:a17:902:d2c4:b0:2ce:b7b7:30e3 with SMTP id d9443c01a7336-2d0522510efmr138913095ad.17.1785836150223;
        Tue, 04 Aug 2026 02:35:50 -0700 (PDT)
Received: from gmail.com ([138.199.21.246])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0aa4d68easm3467685ad.68.2026.08.04.02.35.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 02:35:49 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	alex.chen@huawei.com,
	akpm@linux-foundation.org,
	piaojun@huawei.com,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH] ocfs2: annotate parent ACL lookup for lockdep
Date: Tue,  4 Aug 2026 17:35:37 +0800
Message-ID: <20260804093538.1023838-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
WARNING: possible circular locking dependency detected
------------------------------------------------------
syz.0.7/359 is trying to acquire lock:
ffff888018a53ff8 (&oi->ip_xattr_sem){++++}-{4:4}, at: ocfs2_init_acl+0x2b9/0x6d0 fs/ocfs2/acl.c:366

but task is already holding lock:
ffff88800ca42950 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0x5c1/0x13c0 fs/jbd2/transaction.c:444

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #4 (jbd2_handle){++++}-{0:0}:
       start_this_handle+0x5c7/0x13c0 fs/jbd2/transaction.c:444
       jbd2__journal_start+0x397/0x690 fs/jbd2/transaction.c:501
       jbd2_journal_start+0x31/0x50 fs/jbd2/transaction.c:540
       ocfs2_start_trans+0x39b/0x870 fs/ocfs2/journal.c:374
       ocfs2_complete_local_alloc_recovery+0xfd/0x6d0 fs/ocfs2/localalloc.c:572
       ocfs2_complete_recovery+0x527/0xd00 fs/ocfs2/journal.c:1356
       process_one_work+0x8e0/0x1980 kernel/workqueue.c:3263
       process_scheduled_works kernel/workqueue.c:3346 [inline]
       worker_thread+0x683/0xf80 kernel/workqueue.c:3427
       kthread+0x3f0/0x850 kernel/kthread.c:463
       ret_from_fork+0x50f/0x610 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #3 (&journal->j_trans_barrier){.+.+}-{4:4}:
       down_read+0x9c/0x4a0 kernel/locking/rwsem.c:1537
       ocfs2_start_trans+0x390/0x870 fs/ocfs2/journal.c:372
       ocfs2_complete_local_alloc_recovery+0xfd/0x6d0 fs/ocfs2/localalloc.c:572
       ocfs2_complete_recovery+0x527/0xd00 fs/ocfs2/journal.c:1356
       process_one_work+0x8e0/0x1980 kernel/workqueue.c:3263
       process_scheduled_works kernel/workqueue.c:3346 [inline]
       worker_thread+0x683/0xf80 kernel/workqueue.c:3427
       kthread+0x3f0/0x850 kernel/kthread.c:463
       ret_from_fork+0x50f/0x610 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #2 (sb_internal#2){.+.+}-{0:0}:
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs.h:1916 [inline]
       sb_start_intwrite include/linux/fs.h:2099 [inline]
       ocfs2_start_trans+0x2a8/0x870 fs/ocfs2/journal.c:370
       ocfs2_xattr_set+0x1401/0x2610 fs/ocfs2/xattr.c:3643
       ocfs2_xattr_security_set+0x37/0x50 fs/ocfs2/xattr.c:7241
       __vfs_setxattr+0x14f/0x1c0 fs/xattr.c:200
       __vfs_setxattr_noperm+0x10b/0x5c0 fs/xattr.c:234
       __vfs_setxattr_locked+0x172/0x240 fs/xattr.c:295
       vfs_setxattr+0x167/0x390 fs/xattr.c:321
       do_setxattr+0x13c/0x180 fs/xattr.c:636
       file_setxattr fs/xattr.c:646 [inline]
       file_setxattr+0x139/0x1a0 fs/xattr.c:640
       path_setxattrat+0x236/0x280 fs/xattr.c:711
       __do_sys_fsetxattr fs/xattr.c:761 [inline]
       __se_sys_fsetxattr fs/xattr.c:758 [inline]
       __x64_sys_fsetxattr+0xcc/0x150 fs/xattr.c:758
       x64_sys_call+0x1c6c/0x26a0 arch/x86/include/generated/asm/syscalls_64.h:191
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x93/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x76/0x7e

-> #1 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
       down_write+0x8f/0x200 kernel/locking/rwsem.c:1590
       inode_lock include/linux/fs.h:980 [inline]
       ocfs2_reserve_suballoc_bits+0x131/0x3e00 fs/ocfs2/suballoc.c:788
       ocfs2_reserve_new_metadata_blocks+0x53d/0xc10 fs/ocfs2/suballoc.c:984
       ocfs2_init_xattr_set_ctxt fs/ocfs2/xattr.c:3277 [inline]
       ocfs2_xattr_set+0x1782/0x2610 fs/ocfs2/xattr.c:3634
       ocfs2_xattr_security_set+0x37/0x50 fs/ocfs2/xattr.c:7241
       __vfs_setxattr+0x14f/0x1c0 fs/xattr.c:200
       __vfs_setxattr_noperm+0x10b/0x5c0 fs/xattr.c:234
       __vfs_setxattr_locked+0x172/0x240 fs/xattr.c:295
       vfs_setxattr+0x167/0x390 fs/xattr.c:321
       do_setxattr+0x13c/0x180 fs/xattr.c:636
       file_setxattr fs/xattr.c:646 [inline]
       file_setxattr+0x139/0x1a0 fs/xattr.c:640
       path_setxattrat+0x236/0x280 fs/xattr.c:711
       __do_sys_fsetxattr fs/xattr.c:761 [inline]
       __se_sys_fsetxattr fs/xattr.c:758 [inline]
       __x64_sys_fsetxattr+0xcc/0x150 fs/xattr.c:758
       x64_sys_call+0x1c6c/0x26a0 arch/x86/include/generated/asm/syscalls_64.h:191
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x93/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x76/0x7e

-> #0 (&oi->ip_xattr_sem){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x14ae/0x21e0 kernel/locking/lockdep.c:5237
       lock_acquire kernel/locking/lockdep.c:5868 [inline]
       lock_acquire+0x169/0x2f0 kernel/locking/lockdep.c:5825
       down_read+0x9c/0x4a0 kernel/locking/rwsem.c:1537
       ocfs2_init_acl+0x2b9/0x6d0 fs/ocfs2/acl.c:366
       ocfs2_mknod+0xd2e/0x2400 fs/ocfs2/namei.c:413
       ocfs2_create+0x158/0x390 fs/ocfs2/namei.c:676
       lookup_open.isra.0+0x10a1/0x1460 fs/namei.c:3796
       open_last_lookups fs/namei.c:3895 [inline]
       path_openat+0x11fe/0x2ce0 fs/namei.c:4131
       do_filp_open+0x1f6/0x430 fs/namei.c:4161
       do_sys_openat2+0x117/0x1c0 fs/open.c:1437
       do_sys_open fs/open.c:1452 [inline]
       __do_sys_openat fs/open.c:1468 [inline]
       __se_sys_openat fs/open.c:1463 [inline]
       __x64_sys_openat+0x15b/0x220 fs/open.c:1463
       x64_sys_call+0x161b/0x26a0 arch/x86/include/generated/asm/syscalls_64.h:258
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x93/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x76/0x7e

other info that might help us debug this:

Chain exists of:
  &oi->ip_xattr_sem --> &journal->j_trans_barrier --> jbd2_handle

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(jbd2_handle);
                               lock(&journal->j_trans_barrier);
                               lock(jbd2_handle);
  rlock(&oi->ip_xattr_sem);

 *** DEADLOCK ***

8 locks held by syz.0.7/359:
 #0: ffff888015402420 (sb_writers#14){.+.+}-{0:0}, at: open_last_lookups fs/namei.c:3884 [inline]
 #0: ffff888015402420 (sb_writers#14){.+.+}-{0:0}, at: path_openat+0x1ed8/0x2ce0 fs/namei.c:4131
 #1: ffff888018a542c0 (&type->i_mutex_dir_key#7){++++}-{4:4}, at: inode_lock include/linux/fs.h:980 [inline]
 #1: ffff888018a542c0 (&type->i_mutex_dir_key#7){++++}-{4:4}, at: open_last_lookups fs/namei.c:3892 [inline]
 #1: ffff888018a542c0 (&type->i_mutex_dir_key#7){++++}-{4:4}, at: path_openat+0x1186/0x2ce0 fs/namei.c:4131
 #2: ffff888018ac1800 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:980 [inline]
 #2: ffff888018ac1800 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x131/0x3e00 fs/ocfs2/suballoc.c:788
 #3: ffff888018ac5f40 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:980 [inline]
 #3: ffff888018ac5f40 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x131/0x3e00 fs/ocfs2/suballoc.c:788
 #4: ffff8880189a1800 (&ocfs2_sysfile_lock_key[LOCAL_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:980 [inline]
 #4: ffff8880189a1800 (&ocfs2_sysfile_lock_key[LOCAL_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_reserve_local_alloc_bits+0xf6/0xa10 fs/ocfs2/localalloc.c:636
 #5: ffff888015402610 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_mknod+0xbf3/0x2400 fs/ocfs2/namei.c:364
 #6: ffff88800ae588e8 (&journal->j_trans_barrier){.+.+}-{4:4}, at: ocfs2_start_trans+0x390/0x870 fs/ocfs2/journal.c:372
 #7: ffff88800ca42950 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0x5c1/0x13c0 fs/jbd2/transaction.c:444

Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0xbe/0x130 lib/dump_stack.c:120
 dump_stack+0x15/0x20 lib/dump_stack.c:129
 print_circular_bug+0x285/0x360 kernel/locking/lockdep.c:2043
 check_noncircular+0x14e/0x170 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x14ae/0x21e0 kernel/locking/lockdep.c:5237
 lock_acquire kernel/locking/lockdep.c:5868 [inline]
 lock_acquire+0x169/0x2f0 kernel/locking/lockdep.c:5825
 down_read+0x9c/0x4a0 kernel/locking/rwsem.c:1537
 ocfs2_init_acl+0x2b9/0x6d0 fs/ocfs2/acl.c:366
 ocfs2_mknod+0xd2e/0x2400 fs/ocfs2/namei.c:413
 ocfs2_create+0x158/0x390 fs/ocfs2/namei.c:676
 lookup_open.isra.0+0x10a1/0x1460 fs/namei.c:3796
 open_last_lookups fs/namei.c:3895 [inline]
 path_openat+0x11fe/0x2ce0 fs/namei.c:4131
 do_filp_open+0x1f6/0x430 fs/namei.c:4161
 do_sys_openat2+0x117/0x1c0 fs/open.c:1437
 do_sys_open fs/open.c:1452 [inline]
 __do_sys_openat fs/open.c:1468 [inline]
 __se_sys_openat fs/open.c:1463 [inline]
 ...

[CAUSE]
ocfs2_init_acl() reads the parent directory's default ACL after the
mknod path has already started a transaction. That lookup takes the
parent inode's ip_xattr_sem, while ocfs2_xattr_set() takes the target
inode's ip_xattr_sem before starting a transaction. Lockdep treats both
per-inode semaphores as the same class and reports a circular
dependency through j_trans_barrier and jbd2_handle.

This is not a real deadlock. When ocfs2_init_acl() is called from
ocfs2_mknod(), VFS already holds dir->i_rwsem exclusively, so a
concurrent ocfs2_xattr_set(dir) cannot run on the same directory
instance. The report comes from missing hierarchy information, not from
an ABBA cycle between two runnable paths.

[FIX]
Model the parent-child hierarchy explicitly by taking the parent
lookup with down_read_nested(). That matches the way OCFS2 already uses
nested locking annotations for parent/child inode relationships and
teaches lockdep that the ACL lookup is at a higher level than the usual
subclass-0 xattr updates.

Fixes: 16c8d569f570 ("ocfs2/acl: use 'ip_xattr_sem' to protect getting extended attribute")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
The full lockdep output is quite large for a commit message. I have included
it here to aid analysis, but I am unsure whether such lengthy content would
be better placed outside the commit message.

Please let me know if you would prefer a different approach.
---
 fs/ocfs2/acl.c | 15 ++++++++++++++-
 fs/ocfs2/acl.h | 19 ++++++++++++++-----
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index 62464d194da3..7abee5185bce 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -363,7 +363,20 @@ int ocfs2_init_acl(handle_t *handle,
 
 	if (!S_ISLNK(inode->i_mode)) {
 		if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
-			down_read(&OCFS2_I(dir)->ip_xattr_sem);
+			/*
+			 * This lookup reads the parent directory's default ACL while
+			 * the mknod path already holds a live jbd2 handle. Use a
+			 * distinct subclass to model the parent-child hierarchy for
+			 * lockdep: ocfs2_xattr_set() grabs subclass-0 ip_xattr_sem on
+			 * the file being updated before starting the transaction.
+			 *
+			 * This does not hide a real deadlock. When ocfs2_init_acl()
+			 * is called from ocfs2_mknod(), VFS already holds dir->i_rwsem
+			 * exclusively, so a concurrent ocfs2_xattr_set(dir) cannot run
+			 * in parallel on the same directory instance.
+			 */
+			down_read_nested(&OCFS2_I(dir)->ip_xattr_sem,
+					 OCFS2_XATTR_SEM_OWNER_PARENT);
 			acl = ocfs2_get_acl_nolock(dir, ACL_TYPE_DEFAULT,
 						   dir_bh);
 			up_read(&OCFS2_I(dir)->ip_xattr_sem);
diff --git a/fs/ocfs2/acl.h b/fs/ocfs2/acl.h
index 667c6f03fa60..00242c11d9b0 100644
--- a/fs/ocfs2/acl.h
+++ b/fs/ocfs2/acl.h
@@ -10,6 +10,15 @@
 
 #include <linux/posix_acl_xattr.h>
 
+/*
+ * ocfs2_init_acl() reads the parent directory's default ACL while
+ * ocfs2_mknod() already holds a transaction handle. ocfs2_xattr_set()
+ * takes ip_xattr_sem on the target inode before starting a transaction,
+ * so tell lockdep that the parent directory lookup is a higher-level
+ * acquisition in the parent-child hierarchy.
+ */
+#define OCFS2_XATTR_SEM_OWNER_PARENT	1
+
 struct ocfs2_acl_entry {
 	__le16 e_tag;
 	__le16 e_perm;
@@ -19,10 +28,10 @@ struct ocfs2_acl_entry {
 struct posix_acl *ocfs2_iop_get_acl(struct inode *inode, int type, bool rcu);
 int ocfs2_iop_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 		      struct posix_acl *acl, int type);
-extern int ocfs2_acl_chmod(struct inode *, struct buffer_head *);
-extern int ocfs2_init_acl(handle_t *, struct inode *, struct inode *,
-			  struct buffer_head *, struct buffer_head *,
-			  struct ocfs2_alloc_context *,
-			  struct ocfs2_alloc_context *);
+int ocfs2_acl_chmod(struct inode *inode, struct buffer_head *bh);
+int ocfs2_init_acl(handle_t *handle, struct inode *inode, struct inode *dir,
+		   struct buffer_head *di_bh, struct buffer_head *dir_bh,
+		   struct ocfs2_alloc_context *meta_ac,
+		   struct ocfs2_alloc_context *data_ac);
 
 #endif /* OCFS2_ACL_H */
-- 
2.43.0

