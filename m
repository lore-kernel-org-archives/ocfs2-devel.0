Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8EE37D135
	for <ocfs2-devel@lists.linux.dev>; Mon, 30 Mar 2026 09:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774862861; cv=none; b=hyCOdzykiReVaX9NpJJjqUXfO6POWXTyuHiq1QWqibvCcDquvh/m6fwDzm+02KOIH8uHbI12KJ8Vyqi05deW6QtG3Fujxz4w0/juep+wXjjrEDimCpPjDqFbIxzl/Om3G4ZiHB3PR++yWuwdxIkq4kiS3z+crlwYhpl8X1zvRY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774862861; c=relaxed/simple;
	bh=Nf2bA1AP6Vv+TAwi3JhVKxnC1T3/6+f/fbsjhGuKRiY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eaw9yIpAsFNwGYZdxalv9oHHRylBSbrtKBi6jwaNJWsVlxCo0awfnqVNyaUaFJjgDUwkNEy2RtFMO6EgOaQ99TiOEL3sGHIh+lK8Ldr0HV/QY7fLXem4lOutDYEL1QP44dRAd8AObepFVxVTtCaBNZaeKYWNyzst1zWLLAYv168=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q4bl7KDc; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q4bl7KDc"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-82c68339cf0so2826373b3a.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 30 Mar 2026 02:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774862859; x=1775467659; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZswUPr3SnFD0liUeSOa4ZnrMSqnNFgX3lxqC/FsA5zE=;
        b=Q4bl7KDc48zTyWNevVyJk24Sy5le7dNwaXykSklrN4en622AWhliPXocX1aG4YoMAB
         kwacTddY6XskbsUqi6mPKM66X1Q1tPK0gcl5sqtDnuIexSY7rVtrc4PAIkPtYUsEDqZl
         +Z2rqmk/E7fNVc/Z7muLZ14SV+p8rPUasnxJw11f+1Lj4L7E9GpRBIMZGWSJ3oEIhwAi
         bThy3bOJ3QOFprQ/W1/D0yhxWlAr3Gqwwo7EMl9IDGZHiUBYoJ2vOij6asfyTDYmNtTC
         2AR0pvM/052x/4cJzYzADByjj5adbF0nOIC8yIRh5UhnvzVQHjSfTa4GRfqyta4UvBa8
         os0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774862859; x=1775467659;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZswUPr3SnFD0liUeSOa4ZnrMSqnNFgX3lxqC/FsA5zE=;
        b=U4AouH8aqJRY3gmA6aMANT/xqmpEhDjV+G81QzbDcvhg4RKjtZi3I1GzTM3IYSDKos
         SOTK98h35CJBS7MpBZg7TyQeNqmAKboCd+DVP1685K+a2SikVna+5Fa+GTJmBsPRF4oB
         xd3pQYJN7BkBSGSjJGf37i32c4GRI1OEZ9n5bQQ2CPErOrtYZQ0mqpIeZy88fWXmunkT
         d4x9rQ/iYKe4BwP9w2sqGSkDFZp7mve15sbpxeGpqbNvLre4+rAODoNTpp+6Qrtb7NiQ
         i900syU2gYs5LZxYqrAHBZoyfeDyfMFqHnU424hE81ZaFr1jQkhb2ZPhMXZ3Qwi31arj
         Ldkg==
X-Gm-Message-State: AOJu0YzuQ0GykHFezjvjy8k2aiN8RGQhJlg4Pe3SJuGV6o6wo9GTinoi
	MBReQCU2knuiiWgbmOkaBp/5p20IDLb6dIjsu0zTHf5Y0Q4+WzjiGjQZixYO2J+S
X-Gm-Gg: ATEYQzz3dO1yZvHGbDxaJnL03wK6NqKt3flmFUWWaByCmKg8NXrDmErkiA5L1dAlO8T
	ksMkpgnIEyOi/6Gc9qYQFitUoc/XyxH8lLgD4r3AQTsVf4IV5QLFuwQ/haEO0fYnfHcUkuFdiLB
	Cg/rzp4Gy18bFT49GwdXNYCruwKtW+33fcH4MiANCoAtcPhJD4tGCVSVf12xCkuutn8TE5Va8vQ
	bGKcXnt8bwBRT2lrk8hXxbgkCn492XSnCzndEMzGQKcZ65YF/jiSofKhGZkOaqzv6gpoizmFZ72
	YQySaI2Ws/i061W+uoHw9vLsFnJ006R8j4rWKuhbv/hi3KC5E3Vcn04bhJCjFGUbzwFbfHVwoBj
	E0l5mgDmrf/0SM99IaZSSaLlRnLjr+GEDIXYfO+hib46zCTokWjkuq4x+3cSOJhYHWQ5ci3Jqnv
	JhGuDlC1wMmGNiUy2/Z/58CW8bnCjvAxdVyphUys/fYBdTkwWZOGmtZaTpeXPPCQWqUPdXg3w=
X-Received: by 2002:a05:6a21:3086:b0:39b:fb7f:8a80 with SMTP id adf61e73a8af0-39c7382104emr13636494637.32.1774862858666;
        Mon, 30 Mar 2026 02:27:38 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76916da892sm5685064a12.14.2026.03.30.02.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 02:27:38 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org,
	wen.gang.wang@oracle.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH] ocfs2: fix lock inversion between ip_alloc_sem and transaction start
Date: Mon, 30 Mar 2026 17:27:12 +0800
Message-ID: <20260330092712.1288264-1-gality369@gmail.com>
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
syz.0.222/733 is trying to acquire lock:
ffff888018a514a0 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_xattr_ibody_set+0x119/0xc50 fs/ocfs2/xattr.c:2783

but task is already holding lock:
ffff88800b8cc950 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0x5c1/0x13c0 fs/jbd2/transaction.c:444

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #3 (jbd2_handle){++++}-{0:0}:
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

-> #2 (&journal->j_trans_barrier){.+.+}-{4:4}:
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

-> #1 (sb_internal#2){.+.+}-{0:0}:
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs.h:1916 [inline]
       sb_start_intwrite include/linux/fs.h:2099 [inline]
       ocfs2_start_trans+0x2a8/0x870 fs/ocfs2/journal.c:370
       ocfs2_setattr+0x1096/0x1fd0 fs/ocfs2/file.c:1263
       notify_change+0x4b5/0x1030 fs/attr.c:546
       chown_common+0x565/0x6d0 fs/open.c:791
       vfs_fchown fs/open.c:859 [inline]
       vfs_fchown fs/open.c:851 [inline]
       ksys_fchown+0xfa/0x160 fs/open.c:871
       __do_sys_fchown fs/open.c:876 [inline]
       __se_sys_fchown fs/open.c:874 [inline]
       __x64_sys_fchown+0x77/0xc0 fs/open.c:874
       x64_sys_call+0x26b/0x26a0 arch/x86/include/generated/asm/syscalls_64.h:94
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x93/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x76/0x7e

-> #0 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x14ae/0x21e0 kernel/locking/lockdep.c:5237
       lock_acquire kernel/locking/lockdep.c:5868 [inline]
       lock_acquire+0x169/0x2f0 kernel/locking/lockdep.c:5825
       down_write+0x8f/0x200 kernel/locking/rwsem.c:1590
       ocfs2_xattr_ibody_set+0x119/0xc50 fs/ocfs2/xattr.c:2783
       __ocfs2_xattr_set_handle+0xdb/0xdb0 fs/ocfs2/xattr.c:3322
       ocfs2_xattr_set+0x1447/0x2610 fs/ocfs2/xattr.c:3650
       ocfs2_set_acl+0x421/0x510 fs/ocfs2/acl.c:254
       ocfs2_iop_set_acl+0x1ee/0x2a0 fs/ocfs2/acl.c:286
       set_posix_acl+0x217/0x2e0 fs/posix_acl.c:954
       vfs_set_acl+0x538/0x870 fs/posix_acl.c:1133
       do_set_acl+0xc7/0x190 fs/posix_acl.c:1278
       do_setxattr+0xd3/0x180 fs/xattr.c:633
       filename_setxattr+0x16b/0x1c0 fs/xattr.c:665
       path_setxattrat+0x1d8/0x280 fs/xattr.c:713
       __do_sys_lsetxattr fs/xattr.c:754 [inline]
       __se_sys_lsetxattr fs/xattr.c:750 [inline]
       __x64_sys_lsetxattr+0xd0/0x150 fs/xattr.c:750
       x64_sys_call+0x1c7b/0x26a0 arch/x86/include/generated/asm/syscalls_64.h:190
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x93/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x76/0x7e

other info that might help us debug this:

Chain exists of:
  &ocfs2_file_ip_alloc_sem_key --> &journal->j_trans_barrier --> jbd2_handle

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(jbd2_handle);
                               lock(&journal->j_trans_barrier);
                               lock(jbd2_handle);
  lock(&ocfs2_file_ip_alloc_sem_key);

 *** DEADLOCK ***

7 locks held by syz.0.222/733:
 #0: ffff888015402420 (sb_writers#13){.+.+}-{0:0}, at: filename_setxattr+0xc2/0x1c0 fs/xattr.c:663
 #1: ffff888018a51800 (&type->i_mutex_dir_key#7){++++}-{4:4}, at: inode_lock include/linux/fs.h:980 [inline]
 #1: ffff888018a51800 (&type->i_mutex_dir_key#7){++++}-{4:4}, at: vfs_set_acl+0x2f7/0x870 fs/posix_acl.c:1114
 #2: ffff888018a51538 (&oi->ip_xattr_sem){++++}-{4:4}, at: ocfs2_xattr_set+0x420/0x2610 fs/ocfs2/xattr.c:3583
 #3: ffff888018aed100 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:980 [inline]
 #3: ffff888018aed100 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x131/0x3e00 fs/ocfs2/suballoc.c:788
 #4: ffff888015402610 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_xattr_set+0x1401/0x2610 fs/ocfs2/xattr.c:3643
 #5: ffff88800ae588e8 (&journal->j_trans_barrier){.+.+}-{4:4}, at: ocfs2_start_trans+0x390/0x870 fs/ocfs2/journal.c:372
 #6: ffff88800b8cc950 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0x5c1/0x13c0 fs/jbd2/transaction.c:444

Call Trace:
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
 down_write+0x8f/0x200 kernel/locking/rwsem.c:1590
 ocfs2_xattr_ibody_set+0x119/0xc50 fs/ocfs2/xattr.c:2783
 __ocfs2_xattr_set_handle+0xdb/0xdb0 fs/ocfs2/xattr.c:3322
 ocfs2_xattr_set+0x1447/0x2610 fs/ocfs2/xattr.c:3650
 ocfs2_set_acl+0x421/0x510 fs/ocfs2/acl.c:254
 ocfs2_iop_set_acl+0x1ee/0x2a0 fs/ocfs2/acl.c:286
 set_posix_acl+0x217/0x2e0 fs/posix_acl.c:954
 vfs_set_acl+0x538/0x870 fs/posix_acl.c:1133
 do_set_acl+0xc7/0x190 fs/posix_acl.c:1278
 do_setxattr+0xd3/0x180 fs/xattr.c:633
 filename_setxattr+0x16b/0x1c0 fs/xattr.c:665
 path_setxattrat+0x1d8/0x280 fs/xattr.c:713
 __do_sys_lsetxattr fs/xattr.c:754 [inline]
 __se_sys_lsetxattr fs/xattr.c:750 [inline]
 __x64_sys_lsetxattr+0xd0/0x150 fs/xattr.c:750
 ...

[CAUSE]
ocfs2_setattr() takes ip_alloc_sem before calling ocfs2_start_trans(),
which then takes j_trans_barrier and starts a jbd2 handle. Meanwhile,
ocfs2_xattr_set() starts a transaction first and later takes
ip_alloc_sem in ocfs2_xattr_ibody_set(). This builds the lock cycle:

  setattr path: ip_alloc_sem -> j_trans_barrier -> jbd2_handle
  xattr path:   jbd2_handle -> ip_alloc_sem

This is a real deadlock, not a lockdep false positive. If
ocfs2_commit_cache() queues for j_trans_barrier in write mode, rwsem's
writer preference blocks new readers. That can leave ocfs2_setattr()
holding ip_alloc_sem while waiting to start a transaction, while the
xattr path holds a jbd2 handle and waits for ip_alloc_sem, and the
checkpoint path waits for the xattr transaction to finish.

[FIX]
Fix the ordering by starting the transaction before taking
ip_alloc_sem in ocfs2_setattr(), matching the ordering used by other
ocfs2 paths that need both locks.

The credit calculation depends only on constants and the superblock, so
this reordering does not change the transaction reservation. Also route
the transaction start failure path directly to bail_unlock because
ip_alloc_sem has not been taken yet.

Fixes: 90bd070aae6c ("ocfs2: fix deadlock between setattr and dio_end_io_write")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/ocfs2/file.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 21d797ccccd0..ac72348371f3 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1247,25 +1247,30 @@ int ocfs2_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 				goto bail_unlock;
 			}
 		}
-		down_write(&OCFS2_I(inode)->ip_alloc_sem);
+		/*
+		 * Start the transaction before taking ip_alloc_sem so that
+		 * ocfs2_setattr() uses the same ordering as the xattr paths
+		 * and does not invert jbd2_handle against ip_alloc_sem.
+		 */
 		handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS +
 					   2 * ocfs2_quota_trans_credits(sb));
 		if (IS_ERR(handle)) {
 			status = PTR_ERR(handle);
 			mlog_errno(status);
-			goto bail_unlock_alloc;
+			goto bail_unlock;
 		}
+		down_write(&OCFS2_I(inode)->ip_alloc_sem);
 		status = __dquot_transfer(inode, transfer_to);
 		if (status < 0)
 			goto bail_commit;
 	} else {
-		down_write(&OCFS2_I(inode)->ip_alloc_sem);
 		handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
 		if (IS_ERR(handle)) {
 			status = PTR_ERR(handle);
 			mlog_errno(status);
-			goto bail_unlock_alloc;
+			goto bail_unlock;
 		}
+		down_write(&OCFS2_I(inode)->ip_alloc_sem);
 	}
 
 	setattr_copy(&nop_mnt_idmap, inode, attr);
@@ -1277,7 +1282,6 @@ int ocfs2_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 
 bail_commit:
 	ocfs2_commit_trans(osb, handle);
-bail_unlock_alloc:
 	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 bail_unlock:
 	if (status && inode_locked) {
-- 
2.43.0

