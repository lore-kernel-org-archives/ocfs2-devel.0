Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17921F12FB
	for <ocfs2-devel@lists.linux.dev>; Thu, 15 Oct 2026 01:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792026588; cv=none; b=XB3cMb1CpACONkDL+S/2GGFwo7TB4BkQUXjRabrcy9t/+WAlol9GJj+FsFJB1T9g49YWRfJo50BA3b7RvTNi3s7Pv3bBN5OgCTzz+iHqn/g4Pu44fO483QfLedJ/IViQP0WL/2kdHcYp9JSRHqtIXB5OayHKDcBEXwWBVMdGa/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792026588; c=relaxed/simple;
	bh=J/C897un7tM+lEbJsERBEExBx3tG5CejoLFiNR8+Jew=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t2dIAHGtNamsBbypn8QWUOc/iZoPlvLKk/pYh/hBX9HxstSaUJvMkpkxFi7M9oDYgcFiUlCg0kmybrbQbC7I09H6WbDuxo7zdPulNYjybtlJkvenReKPP9PQ2l6Dch8zOjRwuMuWCDcNtpQOXMsfr8HMtbsbLy4zEtjyJ2R34lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=W4zobbnP; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="W4zobbnP"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792026582; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=pKLT2wt3qHcuFmumNRVrow25TICg0yfDfRm2oggRHMo=;
	b=W4zobbnPBRd8Kr5f4kU2QkucEm5TILxMS6o/6JmScaspFVMVSjqQHO2Gd/zyBfcrDrh3I7ZGdMTil0WvjcPRXs0vnJfeyQuwMkoLlENJZtaje7yBh86t0mBv0gcdTLWisBJLsi569u9xjZ2Ob3wiT6wkwXtZfoGuARDFzqNxce8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XCq1gQz_1792026580;
Received: from 30.221.144.234(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XCq1gQz_1792026580 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 15 Oct 2026 09:09:41 +0800
Message-ID: <5f71eb6a-f773-4c66-a1a9-c0ab9d385f39@linux.alibaba.com>
Date: Thu, 15 Oct 2026 09:09:40 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: dlmfs: Hold l_lock through the unlock wakeup
To: Cen Zhang <zzzccc427@gmail.com>, mark@fasheh.com, jlbec@evilplan.org,
 heming.zhao@suse.com
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-objects-candidate-0055-v4-c1574edc9949e3a22edf@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <pm-ocfs2-objects-candidate-0055-v4-c1574edc9949e3a22edf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 10/14/26 11:46 AM, Cen Zhang wrote:
> The user_lock_res embedded in a DLMFS inode must remain alive until the
> final unlock AST finishes accessing it. user_unlock_ast() clears
> USER_LOCK_BUSY under l_lock, but releases that lock before calling
> wake_up() on the embedded l_event. user_dlm_destroy_lock() waits only
> for BUSY to clear, so it can return before the callback's last access.
> 
> With the native userspace stack, fs/dlm dispatches the unlock AST
> asynchronously. Unlinking an attached lock with no remaining local
> holders can therefore reach the following order while the parent domain
> stays mounted:
> 
>   Unlink and inode release          Native unlock AST
>   ------------------------          -----------------
>   submit final unlock
>                                     clear BUSY under l_lock
>                                     release l_lock
>                                     delay before wake_up()
>   observe BUSY clear under l_lock
>   return from the destroy wait
>   unlink and evict the child
>   RCU callback frees the inode
>                                     wake_up(&lockres->l_event)
> 
> The initial condition check in wait_event() can succeed without joining
> the waitqueue. The callback holds no inode reference, and keeping the

It seems a bit misleading.

___wait_event() calls prepare_to_wait_event() before the first if condition.
The race is real but happens the other way round:
the waiter is queued, sees BUSY already cleared, breaks, runs finish_wait(),
user_dlm_destroy_lock() returns, the inode is freed via RCU — and only then
does the AST reach wake_up().

> parent domain alive avoids disconnect draining the callback workqueue.
> The delayed wakeup then accesses freed inode storage, causing a
> use-after-free in waitqueue locking.
> 
> Keep l_lock held through wake_up(), as ocfs2_unlock_ast() already does.
> user_check_wait_flag() takes the same lock, so teardown cannot observe
> the cleared BUSY flag until the wakeup has finished. The callback and
> its wrappers do not access the lock resource after this final unlock.
> The waitqueue lock is released before wait_event() tests BUSY, so
> extending the critical section does not invert their lock order.
> 
> KASAN report as below:
> 
>     BUG: KASAN: slab-use-after-free in _raw_spin_lock_irqsave+0x3d/0x60
>     Read of size 1 at addr ffff888117dc93c0 by task kworker/u17:0/871
> 
>     CPU: 2 UID: 0 PID: 871 Comm: kworker/u17:0 Not tainted 7.3.0-rc4-next-20260921-pmb-ocfs2-functional-v1+ #1 PREEMPT(lazy)
>     Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>     Workqueue: dlm_callback dlm_callback_work
>     Call Trace:
>      <TASK>
>      dump_stack_lvl+0x93/0xd0
>      print_report+0xce/0x630
>      ? _raw_spin_lock_irqsave+0x3d/0x60
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? __virt_addr_valid+0x20e/0x420
>      ? _raw_spin_lock_irqsave+0x3d/0x60
>      kasan_report+0xe0/0x110
>      ? _raw_spin_lock_irqsave+0x3d/0x60
>      ? _raw_spin_lock_irqsave+0x3d/0x60
>      __kasan_check_byte+0x36/0x50
>      lock_acquire+0x113/0x300
>      ? __pfx_pmbd_probe_hit_cookie+0x10/0x10
>      ? pmbd_probe_hit_cookie+0xee/0x1c0
>      _raw_spin_lock_irqsave+0x3d/0x60
>      ? __wake_up_common_lock+0x27/0xb0
>      __wake_up_common_lock+0x27/0xb0
>      user_unlock_ast+0x21a/0x490
>      ? __pfx_user_unlock_ast+0x10/0x10
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? process_one_work+0x7c8/0x1b40
>      fsdlm_lock_ast_wrapper+0xf2/0x130
>      dlm_do_callback+0x2e9/0x6c0
>      ? __pfx_fsdlm_lock_ast_wrapper+0x10/0x10
>      process_one_work+0x9a8/0x1b40
>      ? __pfx_process_one_work+0x10/0x10
>      ? lock_acquire+0x190/0x300
>      ? lock_is_held_type+0x8f/0x100
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      worker_thread+0x65c/0xe40
>      ? __pfx_worker_thread+0x10/0x10
>      kthread+0x351/0x460
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? __pfx_kthread+0x10/0x10
>      ret_from_fork+0x659/0x940
>      ? __pfx_ret_from_fork+0x10/0x10
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? __switch_to+0x74f/0xf70
>      ? __pfx_kthread+0x10/0x10
>      ret_from_fork_asm+0x1a/0x30
>      </TASK>
> 
>     Allocated by task 492:
>      kasan_save_stack+0x33/0x60
>      kasan_save_track+0x14/0x30
>      __kasan_slab_alloc+0x89/0x90
>      kmem_cache_alloc_lru_noprof+0x205/0x5c0
>      dlmfs_alloc_inode+0x2a/0x50
>      alloc_inode+0x69/0x230
>      new_inode+0x23/0x1a0
>      dlmfs_get_inode+0x47/0x2d0
>      dlmfs_create+0x18f/0x2f0
>      lookup_open+0x88f/0x13e0
>      path_openat+0x95e/0x2020
>      do_file_open+0x21e/0x470
>      do_sys_openat2+0xf4/0x1b0
>      __x64_sys_openat+0x136/0x1e0
>      do_syscall_64+0x114/0x620
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
>     Freed by task 0:
>      kasan_save_stack+0x33/0x60
>      kasan_save_track+0x14/0x30
>      kasan_save_free_info+0x3b/0x60
>      __kasan_slab_free+0x5f/0x80
>      kmem_cache_free+0x242/0x580
>      dlmfs_free_inode+0x25/0x60
>      i_callback+0x4b/0x80
>      rcu_core+0x6be/0x1ed0
>      handle_softirqs+0x1fa/0x8d0
>      __irq_exit_rcu+0x113/0x1e0
>      irq_exit_rcu+0xe/0x20
>      sysvec_apic_timer_interrupt+0x6c/0x80
>      asm_sysvec_apic_timer_interrupt+0x1a/0x20
> 
>     Last potentially related work creation:
>      kasan_save_stack+0x33/0x60
>      kasan_record_aux_stack+0xa7/0xc0
>      __call_rcu_common.constprop.0+0x80/0x280
>      destroy_inode+0x131/0x1b0
>      evict+0x543/0x9f0
>      iput+0x680/0xb80
>      filename_unlinkat+0x36d/0x660
>      __x64_sys_unlinkat+0xb0/0x110
>      do_syscall_64+0x114/0x620
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
>     The buggy address belongs to the object at ffff888117dc92c0
>      which belongs to the cache dlmfs_inode_cache of size 1464
>     The buggy address is located 256 bytes inside of
>      freed 1464-byte region [ffff888117dc92c0, ffff888117dc9878)
> 
> [Physical-page and shadow-memory dumps omitted.]
> 
> Fixes: cbe0e331fdbd ("ocfs2_dlmfs: Enable the use of user cluster stacks.")

cbe0e331fdbd only swaps ocfs2_cluster_connect() ->
ocfs2_cluster_connect_agnostic() inside user_dlm_register(), but never
touchs user_unlock_ast(). It seems it has existed since user_unlock_ast()
was introduced in 8df08c89c668.

The code change looks good. So after the above comments addressed, feel
free to add:

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> Cc: <stable@vger.kernel.org>
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
> Assisted-by: LLM
> 
> ---
> diff --git a/fs/ocfs2/dlmfs/userdlm.c b/fs/ocfs2/dlmfs/userdlm.c
> index 617c92e7b925..60653db7b411 100644
> --- a/fs/ocfs2/dlmfs/userdlm.c
> +++ b/fs/ocfs2/dlmfs/userdlm.c
> @@ -253,9 +253,9 @@ static void user_unlock_ast(struct ocfs2_dlm_lksb *lksb, int status)
>  
>  	lockres->l_flags &= ~USER_LOCK_BUSY;
>  out_noclear:
> -	spin_unlock(&lockres->l_lock);
> -
> +	/* Complete the wakeup before a BUSY waiter can free lockres. */
>  	wake_up(&lockres->l_event);
> +	spin_unlock(&lockres->l_lock);
>  }
>  
>  /*

