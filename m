Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41444AA3F0
	for <ocfs2-devel@lists.linux.dev>; Mon, 19 Oct 2026 11:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792408813; cv=none; b=aLsNPgCraUXMDVyuakOWcGc0WjTXDU66NHMCBf8Z1gHYfJHbxjzz8Xh2TJk6LP3qwunKQ8QtbhpHErf3ZvDVqD5FswFxX04bYb1qxtA9iimoaKRaBQW+D3Hqb5wrptVKDwU591oyTifH1cx4GmhJErTHF6iZKsSH/h9joo22pP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792408813; c=relaxed/simple;
	bh=Bh3JFEeSOgD04v+jIOgFLNwqHkEIEEaaV1/NLO2q1zo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m+p9uQ6ufU39qbTQO/wA3dRlnsqbr8WnzD1Gs6uBsqJ/X7giBg4Iain2Di5Bkwo/uIPBxinqxi90Wb87aMFaH/UufRUEn9VZts2m/hE0BcalAbnJGG+m+nWoo4HZBaf9MyOv6I0CPbyxIB8llyty6Pdo7V88UHVDestO+3hMqEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=BxlJitY1; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="BxlJitY1"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792408804; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=SCCN1hNOBzyFuMh0WPo9IiSvrFw2wKE+VBW+2gR8D4E=;
	b=BxlJitY1z3dLwltUaMl8AGAltNz4Nk8dKLf3jVdjcJLDSGyCyGU9oCwiX6FpF7n1YFmWOhtlhyxwCFV/2JAakP5+i72i4QBnWAvuKcJiKG7z5boCILdmY13QhaHzvi9dRf7niC23SWQ9Ct+9oAYRxLs2ZO4tG4T2UV+tVqNQuE4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R541e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0XD69E9b_1792408802;
Received: from 30.251.227.55(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XD69E9b_1792408802 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 19 Oct 2026 19:20:03 +0800
Message-ID: <b273a680-6b96-4fd6-94e6-c1a79922efc2@linux.alibaba.com>
Date: Mon, 19 Oct 2026 19:20:02 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: Keep the dentry lock inode alive until callbacks
 drain
To: Cen Zhang <zzzccc427@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com, jack@suse.cz,
 akpm@linux-foundation.org, rgoldwyn@suse.de, srinivas.eeda@oracle.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-objects-candidate-0012-v5-a0413a339b72c02fc885@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <pm-ocfs2-objects-candidate-0012-v5-a0413a339b72c02fc885@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/16/26 12:03 AM, Cen Zhang wrote:
> The inode reference held by a DENTRY lock must outlive callbacks on
> that lock. ocfs2_drop_dentry_lock() drops dl_inode before marking the
> lock freeing and waiting for DLM unlock completion, although the BAST
> path still reads dl_inode->i_sb in ocfs2_get_dentry_osb().
> 
> An EX request, such as a remote unlink or rename, can make the
> downconvert worker delete all matching aliases. If no other inode
> reference remains, its post_unlock callback performs the final iput().
> The O2CB DLM can deliver another BAST while the request is still
> blocked, for example when another holder releases the same resource:
> 
>   Downconvert worker                 DLM callback
>   ------------------                 ------------
>   Remove dentry aliases
>   Clear QUEUED; post_unlock()
>   ocfs2_drop_dentry_lock()
>     iput(dl->dl_inode)
>     [inode reclaimed after RCU]
>                                      Duplicate BAST
>                                      ocfs2_blocking_ast()
>                                        ocfs2_get_dentry_osb()
>                                          Read freed dl_inode->i_sb
>   ocfs2_simple_drop_lockres()
> 
> Call ocfs2_simple_drop_lockres() before iput() so the existing inode
> reference remains held while queued work and DLM callbacks are drained.
> The inode can only be evicted after the DENTRY lock has been unlocked.
> 
> KASAN report as below:
> 
>     BUG: KASAN: slab-use-after-free in ocfs2_get_dentry_osb+0x155/0x170
>     Read of size 8 at addr ffff8881100ff888 by task dlm-5B530197BEF/575
> 
>     CPU: 0 UID: 0 PID: 575 Comm: dlm-5B530197BEF Not tainted 7.3.0-rc4-next-20260921-pmb-ocfs2-functional-v1+ #1 PREEMPT(lazy)
>     Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>     Call Trace:
>      <TASK>
>      dump_stack_lvl+0x93/0xd0
>      print_report+0xce/0x630
>      ? ocfs2_get_dentry_osb+0x155/0x170
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? __virt_addr_valid+0x20e/0x420
>      ? ocfs2_get_dentry_osb+0x155/0x170
>      kasan_report+0xe0/0x110
>      ? ocfs2_get_dentry_osb+0x155/0x170
>      ? __pfx_ocfs2_get_dentry_osb+0x10/0x10
>      ? __pfx_o2dlm_blocking_ast_wrapper+0x10/0x10
>      ocfs2_get_dentry_osb+0x155/0x170
>      ocfs2_blocking_ast+0xd3/0x6d0
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? __lock_acquire+0x5a3/0x2140
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? __mlog_printk+0x212/0x2a0
>      ? __pfx_ocfs2_blocking_ast+0x10/0x10
>      ? __pfx_o2dlm_blocking_ast_wrapper+0x10/0x10
>      dlm_do_local_bast+0x20c/0x300
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? __pfx_dlm_do_local_bast+0x10/0x10
>      ? dlm_thread+0x2e36/0x4480
>      dlm_thread+0x32b8/0x4480
>      ? __pfx_dlm_thread+0x10/0x10
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? __kthread_parkme+0xc1/0x220
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? lock_release+0xc8/0x290
>      ? __pfx_autoremove_wake_function+0x10/0x10
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? __kthread_parkme+0x177/0x220
>      ? __pfx_dlm_thread+0x10/0x10
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
>     Allocated by task 584:
>      kasan_save_stack+0x33/0x60
>      kasan_save_track+0x14/0x30
>      __kasan_slab_alloc+0x89/0x90
>      kmem_cache_alloc_lru_noprof+0x205/0x5c0
>      ocfs2_alloc_inode+0x2b/0x100
>      alloc_inode+0x69/0x230
>      new_inode+0x23/0x1a0
>      ocfs2_get_init_inode+0x84/0x190
>      ocfs2_mknod+0x8a3/0x2150
>      ocfs2_create+0x14f/0x3c0
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
>      ocfs2_dentry_lock_put+0xca/0x230
>      ocfs2_process_blocked_lock+0x1fb/0x420
>      ocfs2_downconvert_thread+0x327/0x730
>      kthread+0x351/0x460
>      ret_from_fork+0x659/0x940
>      ret_from_fork_asm+0x1a/0x30
> 
>     The buggy address belongs to the object at ffff8881100ff000
>      which belongs to the cache ocfs2_inode_cache of size 3400
>     The buggy address is located 2184 bytes inside of
>      freed 3400-byte region [ffff8881100ff000, ffff8881100ffd48)
> 
>     [page and shadow-memory details omitted]
> 
> Fixes: 8ed6b23709b3 ("ocfs2: revert iput deferring code in ocfs2_drop_dentry_lock")

This is a revert for performance. Not sure if the regression will come
back with the new order.

> Cc: <stable@vger.kernel.org>
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
> Assisted-by: LLM
> 
> ---
> diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
> index e06774fd89d8..e2b560797f17 100644
> --- a/fs/ocfs2/dcache.c
> +++ b/fs/ocfs2/dcache.c
> @@ -354,8 +354,9 @@ out_attach:
>  static void ocfs2_drop_dentry_lock(struct ocfs2_super *osb,
>  				   struct ocfs2_dentry_lock *dl)
>  {
> -	iput(dl->dl_inode);
> +	/* Keep the inode alive until DENTRY callbacks have completed. */
>  	ocfs2_simple_drop_lockres(osb, &dl->dl_lockres);
> +	iput(dl->dl_inode);
>  	ocfs2_lock_res_free(&dl->dl_lockres);
>  	kfree(dl);
>  }

Commit 9f70968af3e6e ("ocfs2: Re-order iput in ocfs2_drop_dentry_lock")
is what moved iput() above ocfs2_simple_drop_lockres() to begin with, and
it was a deliberate move:

  Do this to avoid a theoretical (I haven't seen this in practice) race where
  the downconvert thread might drop the dentry lock, allowing a remote unlink
  to proceed before dropping the inode locks. This could bounce access to the
  orphan dir between nodes.

With the new order the downconvert thread gives up the dentry lockres and
only afterwards reaches iput() -> ocfs2_evict_inode() ->
ocfs2_delete_inode(), which takes the nfs_sync lock in shared mode and
then the inode lock exclusive.

Thanks,
Joseph
