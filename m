Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3AD347C6
	for <ocfs2-devel@lists.linux.dev>; Wed,  1 Apr 2026 01:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775007272; cv=none; b=R9aO/7An22Lqhp4Rh6upB8lMqQZ04QY3QGFnGLBy7nCuImCf1wk0H34Glk1lla9yxl2LFbCFmruL3WVVs3fpU93pUL/CciabEB+aUks5GHZl/AObHRdb46odV125KQV1IUtWTsCYXAZLxvRh2qSEjTOmYQY/zNmXhbn0vMFa5Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775007272; c=relaxed/simple;
	bh=+mdGuLDHom1N/0eXpxoBGAFQ1OYKyVHb+rrcvuq1gmw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qa84cX3rMfSAT6PhsadDborbQeY9dFrWAqJD3t3zTXySf2T8r49ihGMDmhA3c+Anzus0tHw72ck2XxqYm5cPGtz4qRNQXbZ3LuZExQ75M8Zg6U48/vvKf5tJGkdpUE3YVTMQQi9drdwl22t/u4O9dhiwYtIPa6eUAMigShoe6D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Rjsj7JxH; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Rjsj7JxH"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775007267; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=QESFl//OdetaDgs1GgTY/l+uzoa792xdDuITGTWVMUs=;
	b=Rjsj7JxHRDWXCmxLpihdlGagDj6gKI8D+N69rO74EZmQKYiBS+kR2hyerS9cuPv+fcy3psjwJqBL8WNnSyUg8A8V0PeYa/A/5AcBnDUipltzsVX8IJeDaFXcQRYfSYN4hnbP7MKvWI3xqI9Kl2jrhxGzK10yuGxf/8sPUMMnlf8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X05rruJ_1775007266;
Received: from 30.221.145.27(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X05rruJ_1775007266 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 01 Apr 2026 09:34:26 +0800
Message-ID: <0ba66c9c-208b-4dd6-9350-96b6dfa33eb3@linux.alibaba.com>
Date: Wed, 1 Apr 2026 09:34:25 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix lock inversion between ip_alloc_sem and
 transaction start
To: ZhengYuan Huang <gality369@gmail.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 akpm <akpm@linux-foundation.org>, Wengang Wang <wen.gang.wang@oracle.com>
References: <20260330092712.1288264-1-gality369@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260330092712.1288264-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/30/26 5:27 PM, ZhengYuan Huang wrote:
> [BUG]
> WARNING: possible circular locking dependency detected
> ------------------------------------------------------
> syz.0.222/733 is trying to acquire lock:
> ffff888018a514a0 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_xattr_ibody_set+0x119/0xc50 fs/ocfs2/xattr.c:2783
> 
> but task is already holding lock:
> ffff88800b8cc950 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0x5c1/0x13c0 fs/jbd2/transaction.c:444
> 
> which lock already depends on the new lock.
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #3 (jbd2_handle){++++}-{0:0}:
>        start_this_handle+0x5c7/0x13c0 fs/jbd2/transaction.c:444
>        jbd2__journal_start+0x397/0x690 fs/jbd2/transaction.c:501
>        jbd2_journal_start+0x31/0x50 fs/jbd2/transaction.c:540
>        ocfs2_start_trans+0x39b/0x870 fs/ocfs2/journal.c:374
>        ocfs2_complete_local_alloc_recovery+0xfd/0x6d0 fs/ocfs2/localalloc.c:572
>        ocfs2_complete_recovery+0x527/0xd00 fs/ocfs2/journal.c:1356
>        process_one_work+0x8e0/0x1980 kernel/workqueue.c:3263
>        process_scheduled_works kernel/workqueue.c:3346 [inline]
>        worker_thread+0x683/0xf80 kernel/workqueue.c:3427
>        kthread+0x3f0/0x850 kernel/kthread.c:463
>        ret_from_fork+0x50f/0x610 arch/x86/kernel/process.c:158
>        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> 
> -> #2 (&journal->j_trans_barrier){.+.+}-{4:4}:
>        down_read+0x9c/0x4a0 kernel/locking/rwsem.c:1537
>        ocfs2_start_trans+0x390/0x870 fs/ocfs2/journal.c:372
>        ocfs2_complete_local_alloc_recovery+0xfd/0x6d0 fs/ocfs2/localalloc.c:572
>        ocfs2_complete_recovery+0x527/0xd00 fs/ocfs2/journal.c:1356
>        process_one_work+0x8e0/0x1980 kernel/workqueue.c:3263
>        process_scheduled_works kernel/workqueue.c:3346 [inline]
>        worker_thread+0x683/0xf80 kernel/workqueue.c:3427
>        kthread+0x3f0/0x850 kernel/kthread.c:463
>        ret_from_fork+0x50f/0x610 arch/x86/kernel/process.c:158
>        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> 
> -> #1 (sb_internal#2){.+.+}-{0:0}:
>        percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
>        percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
>        __sb_start_write include/linux/fs.h:1916 [inline]
>        sb_start_intwrite include/linux/fs.h:2099 [inline]
>        ocfs2_start_trans+0x2a8/0x870 fs/ocfs2/journal.c:370
>        ocfs2_setattr+0x1096/0x1fd0 fs/ocfs2/file.c:1263
>        notify_change+0x4b5/0x1030 fs/attr.c:546
>        chown_common+0x565/0x6d0 fs/open.c:791
>        vfs_fchown fs/open.c:859 [inline]
>        vfs_fchown fs/open.c:851 [inline]
>        ksys_fchown+0xfa/0x160 fs/open.c:871
>        __do_sys_fchown fs/open.c:876 [inline]
>        __se_sys_fchown fs/open.c:874 [inline]
>        __x64_sys_fchown+0x77/0xc0 fs/open.c:874
>        x64_sys_call+0x26b/0x26a0 arch/x86/include/generated/asm/syscalls_64.h:94
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0x93/0xf80 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> -> #0 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}:
>        check_prev_add kernel/locking/lockdep.c:3165 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>        validate_chain kernel/locking/lockdep.c:3908 [inline]
>        __lock_acquire+0x14ae/0x21e0 kernel/locking/lockdep.c:5237
>        lock_acquire kernel/locking/lockdep.c:5868 [inline]
>        lock_acquire+0x169/0x2f0 kernel/locking/lockdep.c:5825
>        down_write+0x8f/0x200 kernel/locking/rwsem.c:1590
>        ocfs2_xattr_ibody_set+0x119/0xc50 fs/ocfs2/xattr.c:2783
>        __ocfs2_xattr_set_handle+0xdb/0xdb0 fs/ocfs2/xattr.c:3322
>        ocfs2_xattr_set+0x1447/0x2610 fs/ocfs2/xattr.c:3650
>        ocfs2_set_acl+0x421/0x510 fs/ocfs2/acl.c:254
>        ocfs2_iop_set_acl+0x1ee/0x2a0 fs/ocfs2/acl.c:286
>        set_posix_acl+0x217/0x2e0 fs/posix_acl.c:954
>        vfs_set_acl+0x538/0x870 fs/posix_acl.c:1133
>        do_set_acl+0xc7/0x190 fs/posix_acl.c:1278
>        do_setxattr+0xd3/0x180 fs/xattr.c:633
>        filename_setxattr+0x16b/0x1c0 fs/xattr.c:665
>        path_setxattrat+0x1d8/0x280 fs/xattr.c:713
>        __do_sys_lsetxattr fs/xattr.c:754 [inline]
>        __se_sys_lsetxattr fs/xattr.c:750 [inline]
>        __x64_sys_lsetxattr+0xd0/0x150 fs/xattr.c:750
>        x64_sys_call+0x1c7b/0x26a0 arch/x86/include/generated/asm/syscalls_64.h:190
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0x93/0xf80 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> other info that might help us debug this:
> 
> Chain exists of:
>   &ocfs2_file_ip_alloc_sem_key --> &journal->j_trans_barrier --> jbd2_handle
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   rlock(jbd2_handle);
>                                lock(&journal->j_trans_barrier);
>                                lock(jbd2_handle);
>   lock(&ocfs2_file_ip_alloc_sem_key);
> 
>  *** DEADLOCK ***
> 
> 7 locks held by syz.0.222/733:
>  #0: ffff888015402420 (sb_writers#13){.+.+}-{0:0}, at: filename_setxattr+0xc2/0x1c0 fs/xattr.c:663
>  #1: ffff888018a51800 (&type->i_mutex_dir_key#7){++++}-{4:4}, at: inode_lock include/linux/fs.h:980 [inline]
>  #1: ffff888018a51800 (&type->i_mutex_dir_key#7){++++}-{4:4}, at: vfs_set_acl+0x2f7/0x870 fs/posix_acl.c:1114
>  #2: ffff888018a51538 (&oi->ip_xattr_sem){++++}-{4:4}, at: ocfs2_xattr_set+0x420/0x2610 fs/ocfs2/xattr.c:3583
>  #3: ffff888018aed100 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:980 [inline]
>  #3: ffff888018aed100 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_reserve_suballoc_bits+0x131/0x3e00 fs/ocfs2/suballoc.c:788
>  #4: ffff888015402610 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_xattr_set+0x1401/0x2610 fs/ocfs2/xattr.c:3643
>  #5: ffff88800ae588e8 (&journal->j_trans_barrier){.+.+}-{4:4}, at: ocfs2_start_trans+0x390/0x870 fs/ocfs2/journal.c:372
>  #6: ffff88800b8cc950 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0x5c1/0x13c0 fs/jbd2/transaction.c:444
> 
> Call Trace:
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0xbe/0x130 lib/dump_stack.c:120
>  dump_stack+0x15/0x20 lib/dump_stack.c:129
>  print_circular_bug+0x285/0x360 kernel/locking/lockdep.c:2043
>  check_noncircular+0x14e/0x170 kernel/locking/lockdep.c:2175
>  check_prev_add kernel/locking/lockdep.c:3165 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>  validate_chain kernel/locking/lockdep.c:3908 [inline]
>  __lock_acquire+0x14ae/0x21e0 kernel/locking/lockdep.c:5237
>  lock_acquire kernel/locking/lockdep.c:5868 [inline]
>  lock_acquire+0x169/0x2f0 kernel/locking/lockdep.c:5825
>  down_write+0x8f/0x200 kernel/locking/rwsem.c:1590
>  ocfs2_xattr_ibody_set+0x119/0xc50 fs/ocfs2/xattr.c:2783
>  __ocfs2_xattr_set_handle+0xdb/0xdb0 fs/ocfs2/xattr.c:3322
>  ocfs2_xattr_set+0x1447/0x2610 fs/ocfs2/xattr.c:3650
>  ocfs2_set_acl+0x421/0x510 fs/ocfs2/acl.c:254
>  ocfs2_iop_set_acl+0x1ee/0x2a0 fs/ocfs2/acl.c:286
>  set_posix_acl+0x217/0x2e0 fs/posix_acl.c:954
>  vfs_set_acl+0x538/0x870 fs/posix_acl.c:1133
>  do_set_acl+0xc7/0x190 fs/posix_acl.c:1278
>  do_setxattr+0xd3/0x180 fs/xattr.c:633
>  filename_setxattr+0x16b/0x1c0 fs/xattr.c:665
>  path_setxattrat+0x1d8/0x280 fs/xattr.c:713
>  __do_sys_lsetxattr fs/xattr.c:754 [inline]
>  __se_sys_lsetxattr fs/xattr.c:750 [inline]
>  __x64_sys_lsetxattr+0xd0/0x150 fs/xattr.c:750
>  ...
> 
> [CAUSE]
> ocfs2_setattr() takes ip_alloc_sem before calling ocfs2_start_trans(),
> which then takes j_trans_barrier and starts a jbd2 handle. Meanwhile,
> ocfs2_xattr_set() starts a transaction first and later takes
> ip_alloc_sem in ocfs2_xattr_ibody_set(). This builds the lock cycle:
> 
>   setattr path: ip_alloc_sem -> j_trans_barrier -> jbd2_handle
>   xattr path:   jbd2_handle -> ip_alloc_sem
> 
> This is a real deadlock, not a lockdep false positive. If
> ocfs2_commit_cache() queues for j_trans_barrier in write mode, rwsem's
> writer preference blocks new readers. That can leave ocfs2_setattr()
> holding ip_alloc_sem while waiting to start a transaction, while the
> xattr path holds a jbd2 handle and waits for ip_alloc_sem, and the
> checkpoint path waits for the xattr transaction to finish.
> 
> [FIX]
> Fix the ordering by starting the transaction before taking
> ip_alloc_sem in ocfs2_setattr(), matching the ordering used by other
> ocfs2 paths that need both locks.

It looks more complicated.
Most places also take ip_alloc_sem first then start transaction. And it
seems that we can't do the changes ealily.
e.g. ocfs2_truncate_file()

Thanks,
Joseph

> 
> The credit calculation depends only on constants and the superblock, so
> this reordering does not change the transaction reservation. Also route
> the transaction start failure path directly to bail_unlock because
> ip_alloc_sem has not been taken yet.
> 
> Fixes: 90bd070aae6c ("ocfs2: fix deadlock between setattr and dio_end_io_write")
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> ---
>  fs/ocfs2/file.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 21d797ccccd0..ac72348371f3 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1247,25 +1247,30 @@ int ocfs2_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  				goto bail_unlock;
>  			}
>  		}
> -		down_write(&OCFS2_I(inode)->ip_alloc_sem);
> +		/*
> +		 * Start the transaction before taking ip_alloc_sem so that
> +		 * ocfs2_setattr() uses the same ordering as the xattr paths
> +		 * and does not invert jbd2_handle against ip_alloc_sem.
> +		 */
>  		handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS +
>  					   2 * ocfs2_quota_trans_credits(sb));
>  		if (IS_ERR(handle)) {
>  			status = PTR_ERR(handle);
>  			mlog_errno(status);
> -			goto bail_unlock_alloc;
> +			goto bail_unlock;
>  		}
> +		down_write(&OCFS2_I(inode)->ip_alloc_sem);
>  		status = __dquot_transfer(inode, transfer_to);
>  		if (status < 0)
>  			goto bail_commit;
>  	} else {
> -		down_write(&OCFS2_I(inode)->ip_alloc_sem);
>  		handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
>  		if (IS_ERR(handle)) {
>  			status = PTR_ERR(handle);
>  			mlog_errno(status);
> -			goto bail_unlock_alloc;
> +			goto bail_unlock;
>  		}
> +		down_write(&OCFS2_I(inode)->ip_alloc_sem);
>  	}
>  
>  	setattr_copy(&nop_mnt_idmap, inode, attr);
> @@ -1277,7 +1282,6 @@ int ocfs2_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  
>  bail_commit:
>  	ocfs2_commit_trans(osb, handle);
> -bail_unlock_alloc:
>  	up_write(&OCFS2_I(inode)->ip_alloc_sem);
>  bail_unlock:
>  	if (status && inode_locked) {

