Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E71137E5EE
	for <ocfs2-devel@lists.linux.dev>; Tue, 13 Oct 2026 07:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791878170; cv=none; b=frQ3f9bFKaf9pw4KACowSIpeU2eyw/NCP8B8WCnNmTclQWDzHkpSMlFeWwkyvpVaW/lZEtgV4j88M81zu/1qxc9LiWC5JFe90e5i6f6pIiOs3/QYl24U+eKP7+o85CY89AoKvOSpYq+kklU/QtTIw9Z5cKgBSxhsMO5KzXn29gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791878170; c=relaxed/simple;
	bh=0GWeFJb/qiTJI+X0vmX2m+bo5SlNjkXaEACmBJZEZnU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fbLv9UoFYDP/Xlqz7cgps8gQKyqrptIMwr2exlRAyf5WtLhTaRRrLqnQdlaWX889wqkAgHhIk1OJ50EmxxcH6iz1HHRLyndXfbMXRS0aWFBvZd3RWpvGZPWd2r+XxIDqu29v9VQjHrviwICmQsuWdLlWQH8RYiEIPJL6cKYJ+FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=bHGkC3Uq; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="bHGkC3Uq"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791878162; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=emqpj+xGrdk/1pyDpuwsFKgkPlVWJSnSuEc15c8FnIc=;
	b=bHGkC3UqHIi73zqfec3Wew9H2HsNKB6aaVjZVSaqj7faSjD1w0P2VuBadEsq6rNkcHO/zWaPCeh6RKuhmJ5pn4rs2GzQOZW7wwl++G4Q/1RUAZg8INjWco3OU7RDzOzamYwkP+64Th/izcSG2plMMfuQAD3RjwOc6jtqbjU49CI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0XCl0LN2_1791878160;
Received: from 30.221.145.80(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XCl0LN2_1791878160 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 13 Oct 2026 15:56:01 +0800
Message-ID: <d5522bb5-17f1-4315-b50d-390f1cbde9f4@linux.alibaba.com>
Date: Tue, 13 Oct 2026 15:56:00 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: hold a lock reference across grant AST enqueue
To: Cen Zhang <zzzccc427@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com,
 kees@kernel.org, sunil.mushran@oracle.com, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-objects-candidate-0043-v4-24e62761a79be6b84b55@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <pm-ocfs2-objects-candidate-0043-v4-24e62761a79be6b84b55@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/12/26 9:30 AM, Cen Zhang wrote:
> A newly granted remote lock must remain alive until its grant AST is
> queued. dlmlock_master() publishes the lock on res->granted with its
> base and queue references, then drops res->spinlock before calling
> dlm_queue_ast(). The resource's reserved AST count does not retain the
> lock itself.
> 
> This can fail when a peer dies with an immediately grantable CREATE
> buffered on its socket. O2NET's node-down callback flushes receive work
> before DLM cleanup, but the flush only waits for work queued on entry.
> A data-ready callback that already selected the socket container can
> queue new receive work after the flush advances its work color. Socket
> shutdown does not discard bytes already queued for TCP receive.
> 
> The following ordering leaves the CREATE handler using a freed lock:
> 
> 1. o2net_data_ready() selects the socket container while holding the
>    socket callback read lock.
> 2. o2net_disconnect_node() queues shutdown and starts its flush. The
>    callback queues sc_rx_work after the color change, then unlocks,
>    allowing shutdown to unregister callbacks and shut down the socket.
> 3. The flush completes without waiting for the new receive work. That
>    work consumes the buffered CREATE and dlmlock_master() grants the
>    lock before DLM cleanup reaches the resource, then drops
>    res->spinlock.
> 4. dlm_hb_node_down_cb() reaches dlm_free_dead_locks(), which takes
>    res->spinlock, unlinks the lock and drops both references to free it.
> 5. The CREATE handler calls dlm_queue_ast(). __dlm_queue_ast() reads
>    lock->lockres before acquiring its AST-list reference, causing UAF.
> 

It is better to illustrate the race case with a sequence diagram.

Also please change the patch title to "ocfs2/dlm: xxx".

> Take a temporary lock reference under res->spinlock when a grant AST
> will be queued, and drop it after dlm_queue_ast(). This keeps the lock
> alive across cleanup until the AST path has taken its own reference,
> without reversing the existing AST/resource lock order.
> 
> KASAN report as below:
> 
>     BUG: KASAN: slab-use-after-free in __dlm_queue_ast+0x8a4/0xc00
>     Read of size 8 at addr ffff88810ead5940 by task kworker/u16:3/52
> 
>     CPU: 3 UID: 0 PID: 52 Comm: kworker/u16:3 Not tainted 7.3.0-rc4-next-20260921-pmb-bt-functional-v1+ #1 PREEMPT(lazy)
>     Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>     Workqueue: o2net o2net_rx_until_empty
>     Call Trace:
>      <TASK>
>      dump_stack_lvl+0x93/0xd0
>      print_report+0xce/0x630
>      ? __dlm_queue_ast+0x8a4/0xc00
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? __virt_addr_valid+0x20e/0x420
>      ? __dlm_queue_ast+0x8a4/0xc00
>      kasan_report+0xe0/0x110
>      ? __dlm_queue_ast+0x8a4/0xc00
>      __dlm_queue_ast+0x8a4/0xc00
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? do_raw_spin_lock+0x130/0x270
>      ? __pfx___dlm_queue_ast+0x10/0x10
>      ? __pfx_do_raw_spin_lock+0x10/0x10
>      ? _raw_spin_unlock_irqrestore+0x45/0x60
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? lockdep_hardirqs_on_prepare+0xeb/0x1a0
>      dlm_queue_ast+0x46/0x70
>      dlmlock_master+0x51f/0xf50
>      ? __pfx_dlmlock_master+0x10/0x10
>      ? dlm_create_lock_handler+0x2b2/0x870
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? lock_release+0xc8/0x290
>      dlm_create_lock_handler+0x35b/0x870
>      ? __pfx_dlm_create_lock_handler+0x10/0x10
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? trace_hardirqs_on+0x18/0x160
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? kvm_clock_get_cycles+0x31/0x60
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? __pfx_dlm_create_lock_handler+0x10/0x10
>      o2net_rx_until_empty+0x1dae/0x32c0
>      ? reacquire_held_locks+0xdd/0x200
>      ? __pfx_o2net_rx_until_empty+0x10/0x10
>      ? lock_acquire+0x190/0x300
>      ? process_one_work+0x935/0x1b40
>      ? process_one_work+0x834/0x1b40
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? lock_release+0xc8/0x290
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      process_one_work+0x9a8/0x1b40
>      ? __pfx_process_one_work+0x10/0x10
>      ? lock_acquire+0x190/0x300
>      ? lock_is_held_type+0x8f/0x100
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      worker_thread+0x65c/0xe40
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? __kthread_parkme+0x177/0x220
>      ? srso_alias_return_thunk+0x5/0xfbef5
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
>     Allocated by task 52:
>      kasan_save_stack+0x33/0x60
>      kasan_save_track+0x14/0x30
>      __kasan_slab_alloc+0x89/0x90
>      kmem_cache_alloc_noprof+0x20b/0x5c0
>      dlm_new_lock+0x39/0x5f0
>      dlm_create_lock_handler+0x16e/0x870
>      o2net_rx_until_empty+0x1dae/0x32c0
>      process_one_work+0x9a8/0x1b40
>      worker_thread+0x65c/0xe40
>      kthread+0x351/0x460
>      ret_from_fork+0x659/0x940
>      ret_from_fork_asm+0x1a/0x30
> 
>     Freed by task 603:
>      kasan_save_stack+0x33/0x60
>      kasan_save_track+0x14/0x30
>      kasan_save_free_info+0x3b/0x60
>      __kasan_slab_free+0x5f/0x80
>      kmem_cache_free+0x242/0x580
>      dlm_lock_release+0x1df/0x2f0
>      dlm_lock_put+0x51/0x80
>      __dlm_hb_node_down+0x15be/0x2710
>      dlm_hb_node_down_cb+0x6c/0xa0
>      o2hb_run_event_list+0x34a/0x500
>      o2hb_do_disk_heartbeat+0x1a07/0x2950
>      o2hb_thread+0x1ed/0xdc0
>      kthread+0x351/0x460
>      ret_from_fork+0x659/0x940
>      ret_from_fork_asm+0x1a/0x30
> 
>     The buggy address belongs to the object at ffff88810ead5900
>      which belongs to the cache o2dlm_lock of size 184
>     The buggy address is located 64 bytes inside of
>      freed 184-byte region [ffff88810ead5900, ffff88810ead59b8)
> 
>     [Page and shadow memory dumps omitted.]
> 
> Fixes: 2c5c54aca9d0 ("ocfs2/dlm: Add missing dlm_lock_put()s")
> Assisted-by: LLM

Cc: <stable@vger.kernel.org> is missing here.

Thanks,
Joseph

> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
> ---
> diff --git a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
> index 46120eb75d90..660237c0d7cd 100644
> --- a/fs/ocfs2/dlm/dlmlock.c
> +++ b/fs/ocfs2/dlm/dlmlock.c
> @@ -138,6 +138,8 @@ static enum dlm_status dlmlock_master(struct dlm_ctxt *dlm,
>  					  res->lockname.len)) {
>  			kick_thread = 1;
>  			call_ast = 1;
> +			/* Keep the lock alive through AST enqueue. */
> +			dlm_lock_get(lock);
>  		} else {
>  			mlog(0, "%s: returning DLM_NORMAL to "
>  			     "node %u for reco lock\n", dlm->name,
> @@ -166,10 +168,12 @@ static enum dlm_status dlmlock_master(struct dlm_ctxt *dlm,
>  	wake_up(&res->wq);
>  
>  	/* either queue the ast or release it */
> -	if (call_ast)
> +	if (call_ast) {
>  		dlm_queue_ast(dlm, lock);
> -	else
> +		dlm_lock_put(lock);
> +	} else {
>  		dlm_lockres_release_ast(dlm, res);
> +	}
>  
>  	dlm_lockres_calc_usage(dlm, res);
>  	if (kick_thread)

