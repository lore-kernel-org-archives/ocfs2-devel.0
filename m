Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C463385B9
	for <ocfs2-devel@lists.linux.dev>; Mon, 12 Oct 2026 06:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791786048; cv=none; b=LgmkDaVbsky7+xa8WDPJmAypmY8uI3MPg+Z7Rp8kZfYbqj8G1P7Vg/e5PjcTZKkK3eTrQ+k+uKGxVhyWN/7AhoLGVr2Ta1B2nyP6uHDn7b1IQccI9q9o27gzp/OP3w1QbTMNgQY6NVUu4Gr4FGa9tcz2dl2rebtZ2bekEnGL6Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791786048; c=relaxed/simple;
	bh=GKMqNLJR/8xtoMMLWGOSPFKNNCvW2uPkW9AmRIEBzao=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a9rulCKMAyjqbv5Xpw1No9fj+VZBfPIwJf299Vc9HL9k5LP5OvMnwsfxmEFHTmxoI6xmMVgjJgzn1UTu9Fo41N4mGCvBCJgxS+pToCAWe+mcatpSer0u3qYBlqXNmAm4Pppcr0WZb+Oh5+56Vjmg66mneug5QJAh1KiipWmEN5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=eXhJcuFZ; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="eXhJcuFZ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791786036; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=iLpJKdmpDT4DXhDsHwu9FG8PDA6jGo0dR9QUXu50XhE=;
	b=eXhJcuFZjmovOSpfxKthqjFLzT3J+JZRLbwpX2WGfO11VYgubGeql+6az8xiYXjhHOLe7/l2yzCKfyaOI1JWN9kMTt/XDXZjmTiHGMoaRU15MYbcxsrD2yyZ3qYLCyylfqOfeUVkJ5N6PZZrDuccl6+XWI6mrOktkG2KqmQ0ph8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R821e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XCb4pPR_1791786034;
Received: from 30.221.146.44(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XCb4pPR_1791786034 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 12 Oct 2026 14:20:35 +0800
Message-ID: <bed4a096-31a1-4e2a-bd18-330d7ecbb866@linux.alibaba.com>
Date: Mon, 12 Oct 2026 14:20:34 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2/dlm: Protect the recovery list during debugfs
 reads
To: Cen Zhang <zzzccc427@gmail.com>, akpm@linux-foundation.org
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com,
 rollkingzzc@gmail.com, brauner@kernel.org, jack@suse.cz, rppt@kernel.org,
 kees@kernel.org, hexlabsecurity@proton.me, sunil.mushran@oracle.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-objects-candidate-0049-v3-184e46c47f5283f06191@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <pm-ocfs2-objects-candidate-0049-v3-184e46c47f5283f06191@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/11/26 11:35 PM, Cen Zhang wrote:
> Recovery participant records must remain alive while debug_state_print()
> walks reco.node_data and formats their fields. The formatter holds
> dlm->spinlock, but the recovery participant list is protected by
> dlm_reco_state_lock. In particular, dlm_destroy_recovery_area() detaches
> the list under dlm_reco_state_lock and frees the detached records after
> releasing it. A concurrent debugfs open can therefore read freed memory.
> 
> Protect the participant traversal and field reads in debug_state_print()
> with dlm_reco_state_lock, matching the existing list writers. This also
> serializes the traversal against list_add_tail() during recovery-area
> initialization. Make the existing lock available to the debug code
> through dlmcommon.h; the lock remains internal to the OCFS2 DLM module.
> 
> Release dlm->spinlock after formatting the other domain state and before
> acquiring dlm_reco_state_lock, so the debug reader does not nest the two
> locks. Leave recovery list insertion, detachment and freeing unchanged.
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

Cc: <stable@vger.kernel.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> Changes in v2:
> - Use dlm_reco_state_lock in debug_state_print() to protect recovery
>   participant traversal and field reads.
> - Serialize the read with recovery participant insertion, and leave list
>   teardown unchanged.
> - Release dlm->spinlock before acquiring the recovery list lock.
> 
> Link to v1: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0049-v2-a5d5091b8900dc3f9849@gmail.com
> 
>  fs/ocfs2/dlm/dlmcommon.h   | 2 ++
>  fs/ocfs2/dlm/dlmdebug.c    | 5 ++++-
>  fs/ocfs2/dlm/dlmrecovery.c | 2 +-
>  3 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
> index 20f790a47484a72cba1cd71b3d505f36c1b2d5a4..58b28dfa8d34ef237df7b1eb789f0b461187174e 100644
> --- a/fs/ocfs2/dlm/dlmcommon.h
> +++ b/fs/ocfs2/dlm/dlmcommon.h
> @@ -435,6 +435,8 @@ enum {
>  	DLM_DEREF_LOCKRES_DONE		= 522,
>  };
>  
> +extern spinlock_t dlm_reco_state_lock;
> +
>  struct dlm_reco_node_data
>  {
>  	int state;
> diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
> index ce6d301cb9420385211d20d59637069154a89993..a91f167ed683931da0e44638875b36debe4eb702 100644
> --- a/fs/ocfs2/dlm/dlmdebug.c
> +++ b/fs/ocfs2/dlm/dlmdebug.c
> @@ -736,8 +736,11 @@ static int debug_state_print(struct dlm_ctxt *dlm, char *buf, int len)
>  				 buf + out, len - out);
>  	out += scnprintf(buf + out, len - out, "\n");
>  
> +	spin_unlock(&dlm->spinlock);
> +
>  	/* Recovery Node State: */
>  	out += scnprintf(buf + out, len - out, "Recovery Node State:\n");
> +	spin_lock(&dlm_reco_state_lock);
>  	list_for_each_entry(node, &dlm->reco.node_data, list) {
>  		switch (node->state) {
>  		case DLM_RECO_NODE_DATA_INIT:
> @@ -769,7 +772,7 @@ static int debug_state_print(struct dlm_ctxt *dlm, char *buf, int len)
>  				node->node_num, state);
>  	}
>  
> -	spin_unlock(&dlm->spinlock);
> +	spin_unlock(&dlm_reco_state_lock);
>  
>  	return out;
>  }
> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> index 9d4a2695b9594d1ad8bd60de9cec8ee701355f09..7d519e31fcf17e96116315ac33ab3f5baace354f 100644
> --- a/fs/ocfs2/dlm/dlmrecovery.c
> +++ b/fs/ocfs2/dlm/dlmrecovery.c
> @@ -80,7 +80,7 @@ static int dlm_lockres_master_requery(struct dlm_ctxt *dlm,
>  
>  static u64 dlm_get_next_mig_cookie(void);
>  
> -static DEFINE_SPINLOCK(dlm_reco_state_lock);
> +DEFINE_SPINLOCK(dlm_reco_state_lock);
>  static DEFINE_SPINLOCK(dlm_mig_cookie_lock);
>  static u64 dlm_mig_cookie = 1;
>  

