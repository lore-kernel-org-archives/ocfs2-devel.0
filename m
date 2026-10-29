Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793237476;
	b=kVW2FRG1x/0eQAP4sDN95PWhHht2xCAelpwnIa6RKcT7zbLQWLQC2OWd32GPNjzT599p
	 POZS3gjr7TmDGcSdT60N9ZLmLh9/QTFt6J9x2up0Md5Evob/mYwklOKNUgJiK1uh1JtnT
	 txkMkOvJv2DtWd78YP+wvtSjSqp8vvYDbFqeBRXTGS+eGDzc+eh5TiQ4/Rm3/eQdLtsZg
	 r2cdekEQdx1EzZHwFBvTDHQZIqUi6/FVkUgBUxdjfqcz3EGwxNpoQj1v9LMFIYrQioj5E
	 dLCoADXSzTxfnHLeEb04Dzpn/39QWgx0UTRFzkMXeU+wT8N95K65DyBBMtrK2Pm8Vyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793237476;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=Z0590QpB748cogHcFAcCK3phqiiApT5UKp+SFf0Zwag=;
	b=CIcGvhnYnnMLxvTOH57TlFZol+jlMT92TB1IjfaOSpK/uscfNJDhYMvRRG1ct58s6cSw
	 KaH9fQX/BGhhUvbVj8ct2nPiKwETrxqNAIkoh44T0BK1BLNyWfmpcg89mBH1E/HFfEHc/
	 NWr5WD1dDPmbPyXSY9jDOgXt7YA1lclJb23IUpE5JM4ZsJWAG7ejgoVebVsv6YAYwa6Mu
	 B1BXPh0QPjQIfF5oGDhSc81hEwviz8zu4ONyB/N+kX6b22JDBd1unYHQTlXysYudRyDm6
	 GRghtj8IfJymSkv9ErFUI4TjNmbss0OWuPtfGrJ+BkVjdSbJ1ZM09YzQjk6gfy6aa7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=uVrwMdOE;
	arc=none smtp.remote-ip=115.124.30.124
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21CF606A31C
	for <ocfs2-devel@lists.linux.dev>; Thu, 29 Oct 2026 01:31:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D21CF606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=uVrwMdOE
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793237472; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Z0590QpB748cogHcFAcCK3phqiiApT5UKp+SFf0Zwag=;
	b=uVrwMdOEAAVl26jdmF6XQ5bigTUS0ZxgdLm/1jF/YyUf0giIdF3V8/dBdueSjD43CKS87hp/tkBSUCbIJnt+gYb92ebGDtmZlQxMGcBk1/SqUjL8TYtN0ujgAd6cfnvShE+8GGKYV4vgM5OXweogVdeH224z6CJj+eVd5fBmwT8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R701e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XDhoUQV_1793237470;
Received: from 30.221.129.93(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDhoUQV_1793237470 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 29 Oct 2026 09:31:11 +0800
Message-ID: <55770941-6d17-4dce-b70a-225d06a7fa09@linux.alibaba.com>
Date: Thu, 29 Oct 2026 09:31:09 +0800
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: stop recovery before shutting down local
 allocators
To: Cen Zhang <zzzccc427@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-objects-candidate-0019-v6-7241e0b915991218f315@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <pm-ocfs2-objects-candidate-0019-v6-7241e0b915991218f315@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/26/26 11:01 PM, Cen Zhang wrote:
> Recovery completion needs the local allocators until it has finished
> reclaiming a failed node's allocation window and truncate log. During
> unmount, quota recovery is stopped first, but that leaves recovery_state
> at OCFS2_REC_QUOTA_DISABLED. New non-quota recovery can still start.
> 
> ocfs2_truncate_log_shutdown() drains existing completion work and releases
> osb_tl_bh before ocfs2_recovery_exit() closes that publication path:
> 
>   Unmount                             Recovery
>   -------                             --------
>   stop quota recovery; disable quotas
>   truncate_log_shutdown()
>     flush existing completion work
>                                       recover another failed node
>                                         queue completion
>     flush local log; release buffer
>                                       complete_truncate_log_recovery()
>                                         use released osb_tl_bh
>   recovery_exit(): disable and drain
> 
> An extra buffer reference alone would still let completion append new
> records after the final truncate-log flush.
> 
> Split stopping and draining recovery from freeing its state. Stop all
> recovery producers and drain completion work before shutting down either
> local allocator. Keep recovery-state release at its existing later point,
> so its lifetime relative to other teardown users stays unchanged. The
> second stop at recovery_exit() is harmless once recovery is disabled.
> 
> KASAN report as below:
> 
>     BUG: KASAN: slab-use-after-free in ocfs2_truncate_log_needs_flush+0x23d/0x360
>     Read of size 8 at addr ffff8881093711e8 by task kworker/u16:3/53
>     
>     CPU: 0 UID: 0 PID: 53 Comm: kworker/u16:3 Not tainted 7.3.0-rc4-next-20260921-pmb-ocfs2-functional-v1+ #1 PREEMPT(lazy) 
>     Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>     Workqueue: ocfs2_wq ocfs2_complete_recovery
>     Call Trace:
>      <TASK>
>      dump_stack_lvl+0x93/0xd0
>      print_report+0xce/0x630
>      ? ocfs2_truncate_log_needs_flush+0x23d/0x360
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? __virt_addr_valid+0x20e/0x420
>      ? ocfs2_truncate_log_needs_flush+0x23d/0x360
>      kasan_report+0xe0/0x110
>      ? ocfs2_truncate_log_needs_flush+0x23d/0x360
>      ocfs2_truncate_log_needs_flush+0x23d/0x360
>      ? __pfx_ocfs2_truncate_log_needs_flush+0x10/0x10
>      ? __pfx_down_write+0x10/0x10
>      ocfs2_complete_truncate_log_recovery+0x315/0x780
>      ? trace_hardirqs_on+0x18/0x160
>      ? __pfx_ocfs2_complete_truncate_log_recovery+0x10/0x10
>      ? ocfs2_complete_recovery+0x666/0x11b0
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? kfree+0x308/0x580
>      ocfs2_complete_recovery+0x676/0x11b0
>      ? __pfx_ocfs2_complete_recovery+0x10/0x10
>      ? reacquire_held_locks+0xdd/0x200
>      ? process_one_work+0x7c8/0x1b40
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? lock_acquire+0x190/0x300
>      ? __pfx_autoremove_wake_function+0x10/0x10
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
>     Allocated by task 538:
>      kasan_save_stack+0x33/0x60
>      kasan_save_track+0x14/0x30
>      __kasan_slab_alloc+0x89/0x90
>      kmem_cache_alloc_noprof+0x20b/0x5c0
>      alloc_buffer_head+0x26/0x120
>      folio_alloc_buffers+0x122/0x1d0
>      bdev_getblk+0x299/0x4f0
>      ocfs2_read_blocks_sync+0x513/0xbc0
>      ocfs2_iget+0x9cd/0x1a00
>      ocfs2_get_system_file_inode+0x25e/0x7a0
>      ocfs2_fill_super+0x1b05/0x3930
>      get_tree_bdev_flags+0x35d/0x5f0
>      vfs_get_tree+0x93/0x320
>      fc_mount+0x1d/0x200
>      path_mount+0x592/0x1e00
>      __x64_sys_mount+0x24b/0x2d0
>      do_syscall_64+0x114/0x620
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
>     
>     Freed by task 553:
>      kasan_save_stack+0x33/0x60
>      kasan_save_track+0x14/0x30
>      kasan_save_free_info+0x3b/0x60
>      __kasan_slab_free+0x5f/0x80
>      kmem_cache_free+0x242/0x580
>      free_buffer_head+0x4b/0xc0
>      try_to_free_buffers+0x1dc/0x330
>      ocfs2_truncate_log_shutdown+0x789/0x1290
>      ocfs2_dismount_volume+0x1da/0x940
>      generic_shutdown_super+0x15f/0x490
>      kill_block_super+0x40/0xa0
>      deactivate_locked_super+0xae/0x120
>      deactivate_super+0xa2/0xc0
>      cleanup_mnt+0x217/0x450
>      task_work_run+0x144/0x230
>      exit_to_user_mode_loop+0x17d/0x570
>      do_syscall_64+0x4d1/0x620
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
>     
>     The buggy address belongs to the object at ffff8881093711c0
>      which belongs to the cache buffer_head of size 160
>     The buggy address is located 40 bytes inside of
>      freed 160-byte region [ffff8881093711c0, ffff888109371260)
>     
>     The buggy address belongs to the physical page:
>     page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x109371
>     flags: 0x200000000000000(node=0|zone=2)
>     page_type: f5(slab)
>     raw: 0200000000000000 ffff8881008883c0 dead000000000100 dead000000000122
>     raw: 0000000000000000 0000000000120012 00000000f5000000 0000000000000000
>     page dumped because: kasan: bad access detected
>     
>     Memory state around the buggy address:
>      ffff888109371080: 00 00 00 00 fc fc fc fc fc fc fc fc 00 00 00 00
>      ffff888109371100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>     >ffff888109371180: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
>                                                               ^
>      ffff888109371200: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
>      ffff888109371280: fc fc fc fc 00 00 00 00 00 00 00 00 00 00 00 00
>     ==================================================================
> 
> Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
> 
> ---
>  fs/ocfs2/journal.c | 11 ++++++++---
>  fs/ocfs2/journal.h |  1 +
>  fs/ocfs2/super.c   |  3 +++
>  3 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index a3938a03e93b..065076b1278d 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -227,13 +227,18 @@ void ocfs2_recovery_disable_quota(struct ocfs2_super *osb)
>  	ocfs2_recovery_disable(osb, OCFS2_REC_QUOTA_WANT_DISABLE);
>  }
>  
> +/* Stop producers and drain completion work without freeing recovery state. */
> +void ocfs2_recovery_stop(struct ocfs2_super *osb)
> +{
> +	ocfs2_recovery_disable(osb, OCFS2_REC_WANT_DISABLE);
> +}
> +
>  void ocfs2_recovery_exit(struct ocfs2_super *osb)
>  {
>  	struct ocfs2_recovery_map *rm;
>  
> -	/* disable any new recovery threads and wait for any currently
> -	 * running ones to exit. Do this before setting the vol_state. */
> -	ocfs2_recovery_disable(osb, OCFS2_REC_WANT_DISABLE);
> +	/* Disable producers and drain work before freeing recovery state. */

I think the dropped "Do this before setting the vol_state." still matters.
recovery completion work can block in __ocfs2_wait_on_mount(), whose own
comment says "ocfs2 will wait on our recovery thread before changing it to
something other than MOUNTED or DISABLED", and the write it must stay ahead
of is atomic_set(&osb->vol_state, VOLUME_DISMOUNTED) late in dismount.

So I'd like also keep this comments.

Thanks,
Joseph

> +	ocfs2_recovery_stop(osb);
>  
>  	/*
>  	 * Now that recovery is shut down, and the osb is about to be
> diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
> index 19fc920d26b1..4b52bf7b0938 100644
> --- a/fs/ocfs2/journal.h
> +++ b/fs/ocfs2/journal.h
> @@ -147,6 +147,7 @@ void ocfs2_complete_recovery(struct work_struct *work);
>  void ocfs2_wait_for_recovery(struct ocfs2_super *osb);
>  
>  int ocfs2_recovery_init(struct ocfs2_super *osb);
> +void ocfs2_recovery_stop(struct ocfs2_super *osb);
>  void ocfs2_recovery_exit(struct ocfs2_super *osb);
>  void ocfs2_recovery_disable_quota(struct ocfs2_super *osb);
>  
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 0af2245ae303..3072b0386db8 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1831,6 +1831,9 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
>  	/* Wait for worker to be done with the work structure in osb */
>  	cancel_work_sync(&osb->dquot_drop_work);
>  
> +	/* Stop recovery producers before releasing their local allocators. */
> +	ocfs2_recovery_stop(osb);
> +
>  	ocfs2_shutdown_local_alloc(osb);
>  
>  	ocfs2_truncate_log_shutdown(osb);

