Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6433ABA42
	for <ocfs2-devel@lists.linux.dev>; Thu,  3 Apr 2025 01:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743643721; cv=none; b=qwflxUi3tH0d5dYaJp6OGbN8/0cEFeQWRjvfzsyypusCuQX5csrAVTSDzu846aDyCrgK63Ff3stHwkH075Z8q7Mihlmk7GpP7v56rwlpxnE4AeExa/Q29xHxNiieHDFnEih8qORPhOykg5s+J6nEs3fORfixPJKQsB2U34YSaJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743643721; c=relaxed/simple;
	bh=GtYlyuf94a0Gm5Rj66g6l9SLfIj4z6sQE2Ecl6GcYs4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XDPuVMIvoce9V/TZc2uWzGC+/7HYX+PMLqHEAQ3osDYdkYiwJfcqr7IvTEvlw61vfZ5OFIumT7E96QETOLpgpM9R/LBTAmMBzY6W47wbLN7AxLaFhCnkwlr2RdVyJG5N6NfegASQzRXuBy1ViNSYZsvMaXLVSoowBVLgt8sHWg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=tWflyXtd; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="tWflyXtd"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1743643715; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=+TZsgvwTk/CSFUdOOKK+WrhZjnrIOBF0J1e92ppW2VM=;
	b=tWflyXtdRJLabH0RYHebZdWhgbOClBscEsy6/WFWw3eHl7Lq2mYNYZNaDN0tvrt72L7GngSlP0Nl0tpvfLSvnGkuLEcZoIYfSXKZGfpt7ohtbwhIfmwlK/rvUFdZA/zGwTDCLNtE2d8DV/en0cBT1D8hHX3k9iy3A/90nJXIgvc=
Received: from 30.39.168.206(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WUXCX1M_1743643713 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 03 Apr 2025 09:28:34 +0800
Message-ID: <5e8fdecc-8003-4eae-8c90-94ecad20061c@linux.alibaba.com>
Date: Thu, 3 Apr 2025 09:28:33 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ocfs2: Fix deadlock in ocfs2_finish_quota_recovery
To: Murad Masimov <m.masimov@mt-integration.ru>, Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 lvc-project@linuxtesting.org,
 syzbot+f59a1ae7b7227c859b8f@syzkaller.appspotmail.com
References: <20250402065628.706359-1-m.masimov@mt-integration.ru>
 <20250402065628.706359-3-m.masimov@mt-integration.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250402065628.706359-3-m.masimov@mt-integration.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/4/2 14:56, Murad Masimov wrote:
> When filesystem is unmounted all pending recovery work is processed. This
> may lead to a deadlock in ocfs2_finish_quota_recovery() as it locks the
> s_umount semaphore while it is already exclusively locked in
> deactivate_super().
> 
> Use down_read_trylock() instead and return if it fails, since that possibly
> means that unmount may be in progress so it is not possible to finish quota
> recovery. According to the description of ocfs2_complete_recovery(), which
> is the caller of ocfs2_finish_quota_recovery(), by the point this job is
> started the node can already be considered recovered. There is also no
> error handling in ocfs2_complete_recovery() which indicates that fail is
> not critical in this context.
> 
> The following warning has been reported by Syzkaller:
> 
> ================================================================
> WARNING: possible circular locking dependency detected
> 6.14.0-rc6-syzkaller-00022-gb7f94fcf5546 #0 Not tainted
> ------------------------------------------------------
> kworker/u4:10/1087 is trying to acquire lock:
> ffff88803c49e0e0 (&type->s_umount_key#42){++++}-{4:4}, at: ocfs2_finish_quota_recovery+0x15c/0x22a0 fs/ocfs2/quota_local.c:603
> 
> but task is already holding lock:
> ffffc900026ffc60 ((work_completion)(&journal->j_recovery_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3214 [inline]
> ffffc900026ffc60 ((work_completion)(&journal->j_recovery_work)){+.+.}-{0:0}, at: process_scheduled_works+0x9c6/0x18e0 kernel/workqueue.c:3319
> 
> which lock already depends on the new lock.
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #2 ((work_completion)(&journal->j_recovery_work)){+.+.}-{0:0}:
>        lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
>        process_one_work kernel/workqueue.c:3214 [inline]
>        process_scheduled_works+0x9e4/0x18e0 kernel/workqueue.c:3319
>        worker_thread+0x870/0xd30 kernel/workqueue.c:3400
>        kthread+0x7a9/0x920 kernel/kthread.c:464
>        ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
>        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> 
> -> #1 ((wq_completion)ocfs2_wq){+.+.}-{0:0}:
>        lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
>        touch_wq_lockdep_map+0xc7/0x170 kernel/workqueue.c:3907
>        __flush_workqueue+0x14a/0x1280 kernel/workqueue.c:3949
>        ocfs2_shutdown_local_alloc+0x109/0xa90 fs/ocfs2/localalloc.c:380
>        ocfs2_dismount_volume+0x202/0x910 fs/ocfs2/super.c:1822
>        generic_shutdown_super+0x139/0x2d0 fs/super.c:642
>        kill_block_super+0x44/0x90 fs/super.c:1710
>        deactivate_locked_super+0xc4/0x130 fs/super.c:473
>        cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1413
>        task_work_run+0x24f/0x310 kernel/task_work.c:227
>        resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>        exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
>        exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
>        __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
>        syscall_exit_to_user_mode+0x13f/0x340 kernel/entry/common.c:218
>        do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> -> #0 (&type->s_umount_key#42){++++}-{4:4}:
>        check_prev_add kernel/locking/lockdep.c:3163 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3282 [inline]
>        validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3906
>        __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5228
>        lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
>        down_read+0xb1/0xa40 kernel/locking/rwsem.c:1524
>        ocfs2_finish_quota_recovery+0x15c/0x22a0 fs/ocfs2/quota_local.c:603
>        ocfs2_complete_recovery+0x17c1/0x25c0 fs/ocfs2/journal.c:1357
>        process_one_work kernel/workqueue.c:3238 [inline]
>        process_scheduled_works+0xabe/0x18e0 kernel/workqueue.c:3319
>        worker_thread+0x870/0xd30 kernel/workqueue.c:3400
>        kthread+0x7a9/0x920 kernel/kthread.c:464
>        ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
>        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> 
> other info that might help us debug this:
> 
> Chain exists of:
>   &type->s_umount_key#42 --> (wq_completion)ocfs2_wq --> (work_completion)(&journal->j_recovery_work)
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock((work_completion)(&journal->j_recovery_work));
>                                lock((wq_completion)ocfs2_wq);
>                                lock((work_completion)(&journal->j_recovery_work));
>   rlock(&type->s_umount_key#42);
> 
>  *** DEADLOCK ***
> 
> 2 locks held by kworker/u4:10/1087:
>  #0: ffff8880403eb148 ((wq_completion)ocfs2_wq){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3213 [inline]
>  #0: ffff8880403eb148 ((wq_completion)ocfs2_wq){+.+.}-{0:0}, at: process_scheduled_works+0x98b/0x18e0 kernel/workqueue.c:3319
>  #1: ffffc900026ffc60 ((work_completion)(&journal->j_recovery_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3214 [inline]
>  #1: ffffc900026ffc60 ((work_completion)(&journal->j_recovery_work)){+.+.}-{0:0}, at: process_scheduled_works+0x9c6/0x18e0 kernel/workqueue.c:3319
> 
> stack backtrace:
> CPU: 0 UID: 0 PID: 1087 Comm: kworker/u4:10 Not tainted 6.14.0-rc6-syzkaller-00022-gb7f94fcf5546 #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> Workqueue: ocfs2_wq ocfs2_complete_recovery
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
>  print_circular_bug+0x13a/0x1b0 kernel/locking/lockdep.c:2076
>  check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2208
>  check_prev_add kernel/locking/lockdep.c:3163 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3282 [inline]
>  validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3906
>  __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5228
>  lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
>  down_read+0xb1/0xa40 kernel/locking/rwsem.c:1524
>  ocfs2_finish_quota_recovery+0x15c/0x22a0 fs/ocfs2/quota_local.c:603
>  ocfs2_complete_recovery+0x17c1/0x25c0 fs/ocfs2/journal.c:1357
>  process_one_work kernel/workqueue.c:3238 [inline]
>  process_scheduled_works+0xabe/0x18e0 kernel/workqueue.c:3319
>  worker_thread+0x870/0xd30 kernel/workqueue.c:3400
>  kthread+0x7a9/0x920 kernel/kthread.c:464
>  ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>  </TASK>
> ================================================================
> 
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
> 
> Fixes: 5f530de63cfc ("ocfs2: Use s_umount for quota recovery protection")
> Reported-by: syzbot+f59a1ae7b7227c859b8f@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=f59a1ae7b7227c859b8f
> Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>
> ---
>  fs/ocfs2/quota_local.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
> index e60383d6ecc1..d3304bb03163 100644
> --- a/fs/ocfs2/quota_local.c
> +++ b/fs/ocfs2/quota_local.c
> @@ -600,7 +600,16 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
>  	printk(KERN_NOTICE "ocfs2: Finishing quota recovery on device (%s) for "
>  	       "slot %u\n", osb->dev_str, slot_num);
> 
> -	down_read(&sb->s_umount);
> +	/*
> +	 * We have to be careful here not to deadlock on s_umount as umount
> +	 * disabling quotas may be in progress and it waits for this work to
> +	 * complete. If trylock fails, we have to skip this step.
> +	 */

Seems we don't have a better way.

> +	if (!down_read_trylock(&sb->s_umount)) {
> +		status = -ENOENT;

Normally EAGAIN is a proper error code when trylock fails, though it
hasn't been handled in caller...
Also we'd better log an error in this case to indicate what happens.

Thanks,
Joseph

> +		goto out;
> +	}
> +
>  	for (type = 0; type < OCFS2_MAXQUOTAS; type++) {
>  		if (list_empty(&(rec->r_list[type])))
>  			continue;
> @@ -608,7 +617,7 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
>  		lqinode = ocfs2_get_system_file_inode(osb, ino[type], slot_num);
>  		if (!lqinode) {
>  			status = -ENOENT;
> -			goto out;
> +			goto out_up;
>  		}
>  		status = ocfs2_inode_lock_full(lqinode, NULL, 1,
>  						       OCFS2_META_LOCK_NOQUEUE);
> @@ -676,8 +685,9 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
>  		if (status < 0)
>  			break;
>  	}
> -out:
> +out_up:
>  	up_read(&sb->s_umount);
> +out:
>  	ocfs2_free_quota_recovery(rec);
>  	return status;
>  }
> --
> 2.39.2

