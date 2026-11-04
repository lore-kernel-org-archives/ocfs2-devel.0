Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793793037;
	b=ke29fx69yhCndTRPtv8yAlBkie1m/cR2NsOeIhthxmbVXCtjVC3cntFvMTYdq6uCcDaH
	 ZpiymnTXeHbtF7WHKopcJ46s4U/0TRcaf2leCxZq5/20TVKjerjNFasCTxMI2m2EiGT/U
	 lC/dHFHORmnkZbMEi5lSUGL5i5qmV009XSJo8qZAEZA/EHh4Su6l3lmMAXyLcU8dD85eQ
	 5nawYjDFooyw+8g1F/ewmL9MKNcFg78VW24ZLadABm4JjFz2Sy0x0jo6+cSlo9TseZWUI
	 VdJ+ywTDgYydtFpAB2zo4u6eme7oiasrwyDNpKULHaP14IaJwNReMfKoQIM0ffEkMGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793793037;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=n7TyH3nFFVmHIHs1ldKKybFU/npM5rqhaAbZSesudpM=;
	b=MhluWwcMHV0o8NuyUZpAynijpglwp6hxiwL3PLgaHxqfBWIwRvV0jh/oBSu37gROQooU
	 ra6aR7ETtp/E2D5M1rwrERiD/mHTwbgypA5F3XAbdDlTl7G78kjTosk5/IKwtGahWB/V8
	 MMSUsL2ziLEwsM4aJ72VpkOba7P7N+6BvQrJNQQU7OGwdmtMi+tg1ixVRwVmqWy9d3Lv/
	 PH0OpczbgIRDEIPUDBqnEntlu294vlPjtyvxpplb/33ne9MyeSxd7cTxPu4Eu+MKiwUk0
	 MkSAWZ1hUbeIG/sD6mSyes2QADT2htNgrtYXyrF9UyQfCbQ2nRQo5guXwLLqqIimjEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=IyAkye7K;
	arc=none smtp.remote-ip=115.124.30.111
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12AB9606A330
	for <ocfs2-devel@lists.linux.dev>; Wed,  4 Nov 2026 11:50:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12AB9606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=IyAkye7K
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793793027; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=n7TyH3nFFVmHIHs1ldKKybFU/npM5rqhaAbZSesudpM=;
	b=IyAkye7KlN0k5MZn8XmzO48xcXyboR/u+PygsLMVtkFN2uy90dGtgdxqQRd5d16cv03e8SndsNWvc9zlrI6qdfKkfuGoUQOWHqPHljTsNvj9ktoZv3d/wAZd/044kRuTH/wrT8NX4Qni/Wo1GvxKgVHOZZPHjNPpmxnw4Wp/hm0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R251e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XE5fcDP_1793793025;
Received: from 30.221.129.178(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XE5fcDP_1793793025 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 04 Nov 2026 19:50:25 +0800
Message-ID: <68eea5f0-f320-4bbb-906a-46f9fb17dd44@linux.alibaba.com>
Date: Wed, 4 Nov 2026 19:50:25 +0800
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
Subject: Re: [PATCH v2] ocfs2: drain fs_state readers before journal teardown
To: Cen Zhang <zzzccc427@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-objects-candidate-0003-v7-1522d068e5b943786c3e@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <pm-ocfs2-objects-candidate-0003-v7-1522d068e5b943786c3e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/31/26 1:13 PM, Cen Zhang wrote:
> The per-mount fs_state open callback formats journal fields through
> osb->journal. Its debugfs active-user guard protects the open callback,
> but does not keep the journal allocated after journal shutdown.
> 
> Both unmount and the mount-error path in ocfs2_mount_volume() can free
> and clear the journal before the debugfs subtree is removed:
> 
>   fs_state reader                       Mount cleanup
>   ---------------                       -------------
>   enter ocfs2_osb_debug_open()
>     ocfs2_osb_dump()
>       load osb->journal
>                                         ocfs2_journal_shutdown()
>                                           free journal; clear pointer
>       read journal fields
>   leave the open callback
>                                         remove the debugfs subtree
> 
> Remove fs_state before cleanup releases its backing state in both
> callers of ocfs2_journal_shutdown(). Debugfs removal prevents new opens
> and waits for admitted open callbacks to finish. Later reads and release
> use only the per-open snapshot buffer, so they do not need the journal.
> 
> Keep removal in the caller paths while the per-mount debugfs parent is
> still present. The remaining debug files retain their teardown order.
> 
> KASAN report as below:
> 
>     ==================================================================
>     BUG: KASAN: slab-use-after-free in ocfs2_osb_debug_open+0x967/0x15e0
>     Read of size 4 at addr ffff888116a56028 by task cat/502
> 
>     Call Trace:
>      <TASK>
>      dump_stack_lvl+0x93/0xd0
>      print_report+0xce/0x630
>      kasan_report+0xe0/0x110
>      kasan_check_range+0x105/0x1b0
>      ocfs2_osb_debug_open+0x967/0x15e0
>      full_proxy_open_regular+0x193/0x310
>      do_dentry_open+0x595/0x12d0
>      vfs_open_consume+0xd1/0x400
>      path_openat+0x18d0/0x2020
>      do_file_open+0x21e/0x470
>      do_sys_openat2+0xf4/0x1b0
>      __x64_sys_openat+0x136/0x1e0
>      do_syscall_64+0x114/0x620
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
>      </TASK>
> 
>     Allocated by task 495:
>      kasan_save_stack+0x33/0x60
>      kasan_save_track+0x14/0x30
>      __kasan_kmalloc+0xaa/0xb0
>      __kmalloc_cache_noprof+0x28d/0x610
>      ocfs2_journal_alloc+0x91/0x450
>      ocfs2_initialize_super.isra.0+0x11b8/0x3070
>      ocfs2_fill_super+0x801/0x38f0
>      get_tree_bdev_flags+0x35d/0x5f0
>      vfs_get_tree+0x93/0x320
>      fc_mount+0x1d/0x200
>      path_mount+0x592/0x1e00
>      __x64_sys_mount+0x24b/0x2d0
>      do_syscall_64+0x114/0x620
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
>     Freed by task 504:
>      kasan_save_stack+0x33/0x60
>      kasan_save_track+0x14/0x30
>      kasan_save_free_info+0x3b/0x60
>      __kasan_slab_free+0x5f/0x80
>      kfree+0x308/0x580
>      ocfs2_journal_shutdown+0x10a/0xc20
>      ocfs2_dismount_volume+0x315/0x940
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
>     The buggy address belongs to the object at ffff888116a56000
>      which belongs to the cache kmalloc-512 of size 512
>     The buggy address is located 40 bytes inside of
>      freed 512-byte region [ffff888116a56000, ffff888116a56200)
>     ==================================================================
> 
> Fixes: da5e7c87827e ("ocfs2: cleanup journal init and shutdown")
> Cc: stable@vger.kernel.org
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
> ---
> Changes in v2:
> - Address the osb dereference before BUG_ON(!osb) raised by Sashiko:
>   https://sashiko.dev/#/patchset/98583
> - Remove fs_state after BUG_ON(!osb) in ocfs2_dismount_volume().
> - Trim the KASAN report.
> 
> Assisted-by: LLM
> 
> Link to v1: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0003-v6-2f69dbb7417fcd537be6@gmail.com
> 
>  fs/ocfs2/super.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 0af2245ae303..c02896e127e5 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1783,6 +1783,9 @@ static int ocfs2_mount_volume(struct super_block *sb)
>  	return 0;
>  
>  out_system_inodes:
> +	/* Drain fs_state readers before releasing their backing state. */
> +	debugfs_lookup_and_remove("fs_state", osb->osb_debug_root);
> +
>  	if (osb->local_alloc_state == OCFS2_LA_ENABLED)
>  		ocfs2_shutdown_local_alloc(osb);
>  	/* Drain pending suballoc reclaim work before the journal goes away */
> @@ -1812,6 +1815,9 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
>  	osb = OCFS2_SB(sb);
>  	BUG_ON(!osb);
>  
> +	/* Drain fs_state readers before releasing their backing state. */
> +	debugfs_lookup_and_remove("fs_state", osb->osb_debug_root);
> +
>  	/* Remove file check sysfs related directories/files,
>  	 * and wait for the pending file check operations */
>  	ocfs2_filecheck_remove_sysfs(osb);

'fs_state' is created in ocfs2_fill_super(), so it looks weird to clean
here.
I see now ocfs2_mount_volume() also calls ocfs2_release_system_inodes()
and ocfs2_free_slot_info(), so it seems we have to do more refactor.

Thanks,
Joseph


