Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8613D6CD7
	for <ocfs2-devel@lists.linux.dev>; Sat, 10 Oct 2026 08:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791622140; cv=none; b=VSvHlqQ4dPJCQw6gTCalMyMmjIAcI7JncWaCMhDSkgYKGiXRJaZ7KB1hRv1PHEaab1X4doVfr9GFFOWGgtdVKSvKtWGHnwYpebqocW4OHxdqQnUM9cTLbb4Xx+0PGOi7FAvHqORGMQ9Wn8y1DJ/4hAPJKImLe3YZ6dI3vGSw/vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791622140; c=relaxed/simple;
	bh=K4ZxKk79pvRWrYuuRjzAj/xtXo/3o1M9VNlFqX+ZUbE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r6xMijoVVXkgEMOlCk9AA5dVvsTdiM97LQrnG//Ta0IkLfyjrel83StCsHX/19/pujI6koVnjq8ZhIfTVo2qBPaMI4NyAo+9tuOzVUsD8SRsDXRAPqfcdcflp0NFcMEHf2Bs0WpOuLE+9dXJwFVT9zV+xCT2SD0m4Ih6f6qx7IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Hqd6h2sW; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Hqd6h2sW"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791622124; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=b2y2N7FeKcJ8D9RR9jlgBCmtkAzLlNngU7OyifZ+Avg=;
	b=Hqd6h2sW5tOyjB3GTmIAARzTw1J644wLPnXs4EwuBhA5o4NvYdpOEZgK2ApZt4j9ZwYd/JVPwpduZMFWvbNN0vlXdqUE+2oahO8Zj1g6MHFiw7NkykYdLqD8q3GNYZya6EZlbZbB3H7yxzQnBSHjzsD04s83onrAhogQbd2bTrc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XCVjsiu_1791622122;
Received: from 30.221.145.85(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XCVjsiu_1791622122 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 10 Oct 2026 16:48:42 +0800
Message-ID: <9227ec1d-0de0-4e43-830c-fc60d5f8b2c8@linux.alibaba.com>
Date: Sat, 10 Oct 2026 16:48:41 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2/dlm: Serialize recovery list teardown with debug
 reads
To: Cen Zhang <zzzccc427@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, kees@kernel.org, jack@suse.cz,
 rppt@kernel.org, hexlabsecurity@proton.me, sunil.mushran@oracle.com,
 akpm@linux-foundation.org, Heming Zhao <heming.zhao@suse.com>,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-objects-candidate-0049-v2-a5d5091b8900dc3f9849@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <pm-ocfs2-objects-candidate-0049-v2-a5d5091b8900dc3f9849@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/9/26 6:01 PM, Cen Zhang wrote:
> Recovery participant records must remain alive while debug_state_print()
> walks reco.node_data and formats their fields. The formatter holds
> dlm->spinlock, but dlm_destroy_recovery_area() detaches the list under
> dlm_reco_state_lock and frees the records without taking dlm->spinlock.
> 
> When a recovery master finishes recovering a dead node, a concurrent
> open of the domain's dlm_state file can reach the participant list after
> the master's last dlm->spinlock section. The following ordering is
> possible:
> 
>     Debugfs open                      Recovery thread
>     debug_state_print()
>       lock dlm->spinlock
>       select participant
>                                       dlm_destroy_recovery_area()
>                                         lock dlm_reco_state_lock
>                                         detach participant list
>                                         unlock dlm_reco_state_lock
>                                         kfree(participant)
>       read node->state/node_num
>       unlock dlm->spinlock
> 
> The field read or the next list iteration then accesses freed memory.
> Debugfs removal protects the domain lifetime, but session completion
> leaves the file installed, so it does not drain this open callback.
> 
> Take dlm->spinlock around the existing locked list detachment. A debug
> reader must now finish before detachment, and later readers see an empty
> list. Keep the frees outside both locks. This also covers cleanup after
> partial allocation failure in dlm_init_recovery_area().
> 
> KASAN report as below:
> 
>     BUG: KASAN: slab-use-after-free in debug_state_open+0x1169/0x12d0
>     Read of size 4 at addr ffff88810662ef80 by task dlm-state-stres/896
> 
>     CPU: 1 UID: 0 PID: 896 Comm: dlm-state-stres Not tainted 7.3.0-rc4-next-20260921-pmb-ocfs2-functional-v1+ #1 PREEMPT(lazy)
>     Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>     Call Trace:
>      <TASK>
>      dump_stack_lvl+0x93/0xd0
>      print_report+0xce/0x630
>      ? debug_state_open+0x1169/0x12d0
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? __virt_addr_valid+0x20e/0x420
>      ? debug_state_open+0x1169/0x12d0
>      kasan_report+0xe0/0x110
>      ? debug_state_open+0x1169/0x12d0
>      debug_state_open+0x1169/0x12d0
>      ? __pfx_debug_state_open+0x10/0x10
>      full_proxy_open_regular+0x193/0x310
>      do_dentry_open+0x595/0x12d0
>      ? __pfx_full_proxy_open_regular+0x10/0x10
>      vfs_open_consume+0xd1/0x400
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      path_openat+0x18d0/0x2020
>      ? __pfx_path_openat+0x10/0x10
>      do_file_open+0x21e/0x470
>      ? __pfx_do_file_open+0x10/0x10
>      ? _raw_spin_unlock+0x23/0x40
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? alloc_fd+0x3a6/0x6b0
>      do_sys_openat2+0xf4/0x1b0
>      ? __pfx_do_sys_openat2+0x10/0x10
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? __fput+0x5b5/0xa60
>      __x64_sys_openat+0x136/0x1e0
>      ? __pfx___x64_sys_openat+0x10/0x10
>      do_syscall_64+0x114/0x620
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
>     [Register dump omitted.]
>      </TASK>
> 
>     Allocated by task 880:
>      kasan_save_stack+0x33/0x60
>      kasan_save_track+0x14/0x30
>      __kasan_kmalloc+0xaa/0xb0
>      __kmalloc_cache_noprof+0x28d/0x610
>      dlm_remaster_locks+0x147/0x1d90
>      dlm_do_recovery+0xde1/0x1580
>      dlm_recovery_thread+0x109/0x300
>      kthread+0x351/0x460
>      ret_from_fork+0x659/0x940
>      ret_from_fork_asm+0x1a/0x30
> 
>     Freed by task 880:
>      kasan_save_stack+0x33/0x60
>      kasan_save_track+0x14/0x30
>      kasan_save_free_info+0x3b/0x60
>      __kasan_slab_free+0x5f/0x80
>      kfree+0x308/0x580
>      dlm_destroy_recovery_area+0x285/0x460
>      dlm_remaster_locks+0x17c4/0x1d90
>      dlm_do_recovery+0xde1/0x1580
>      dlm_recovery_thread+0x109/0x300
>      kthread+0x351/0x460
>      ret_from_fork+0x659/0x940
>      ret_from_fork_asm+0x1a/0x30
> 
>     The buggy address belongs to the object at ffff88810662ef80
>      which belongs to the cache kmalloc-32 of size 32
>     The buggy address is located 0 bytes inside of
>      freed 32-byte region [ffff88810662ef80, ffff88810662efa0)
> 
>     [Page and memory-state dumps omitted.]
> 
> Fixes: 007dce53a29c ("ocfs2/dlm: Dump the dlm state in a debugfs file")
> Assisted-by: LLM
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
> ---
> 
> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> index 9d4a2695b9594d1ad8bd60de9cec8ee701355f09..5719c2b88e4292cff38e26b10b29c8a4a0deccda 100644
> --- a/fs/ocfs2/dlm/dlmrecovery.c
> +++ b/fs/ocfs2/dlm/dlmrecovery.c
> @@ -764,9 +764,12 @@ static void dlm_destroy_recovery_area(struct dlm_ctxt *dlm)
>  	struct dlm_reco_node_data *ndata, *next;
>  	LIST_HEAD(tmplist);
>  
> +	/* Serialize list detachment with debug_state_print(). */
> +	spin_lock(&dlm->spinlock);
>  	spin_lock(&dlm_reco_state_lock);
>  	list_splice_init(&dlm->reco.node_data, &tmplist);
>  	spin_unlock(&dlm_reco_state_lock);
> +	spin_unlock(&dlm->spinlock);
>  

The race looks real.

But I don't want to involve dlm->spinlock for list dlm->reco.node_data.
While dlm_reco_state_lock is the designed lock to protect list
dlm->reco.node_data.

So why not add the dlm_reco_state_lock in debug_state_print()? This
can keep consitent with all other places that access list
dlm->reco.node_data.

Also it seems also fixes the potential list_add_tail() race in
dlm_init_recovery_area().

Thanks,
Joseph

