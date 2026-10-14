Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626C253E2EA
	for <ocfs2-devel@lists.linux.dev>; Wed, 14 Oct 2026 14:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791987259; cv=none; b=GRA2UiUDBV+ugEgWFsov0orcS3EsMozUUSbbADDhZZvHofcDD5FsqN4aTZdnJt7Liuo5R1Yv/VQaWZ8gYjoSB3GFWtr/c4Dte/tWidTeVraI9NuhF3MrXV57Up8kmjgg8d27HQeUUAS4YDKZNzl265oJeLe3txVBx10pfmmC2Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791987259; c=relaxed/simple;
	bh=AoJAQZYSo41iEMK+7sT0aKFtUq3U6b6oKPWCZTFKUCQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fezCJ7ZPQ7VgbIIbkY4zWaaXPS+Oxm45Gy1Qe/2H34qQuojhE0akl2DN5myHA09QVdyb5OJsWXo0P4xOlz7OmM4lFH/PLPI+E0tU8rOJ3zMWbc9eeZYLV6mkgmTEeb+7Cx2vT7E0nbOncF/2QTeBd174KGBTq7+E2HlwL54fffo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=H5TC5xdj; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=XtQdN2eG; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=H5TC5xdj; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=XtQdN2eG; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="H5TC5xdj";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="XtQdN2eG";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="H5TC5xdj";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="XtQdN2eG"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4DF921FB66;
	Wed, 14 Oct 2026 14:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791987255; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xZK2tXtr1EEATnsZ9uDLRVkZR5uAVy89NFi5xbcUArY=;
	b=H5TC5xdjtF+s56Ornz1q3EZJPZVQd2kQoBUWJet3X7K5+IjcmAqq8LmgiMgOcE+PuGdEgp
	JcMdIU3wziQf+k96ZOUEiHC1BD52qFVksQmc/tDXeaQxviL6Z4DwOsuzyCOxXrHV7uEe11
	N8AHpqw/C07h/z5MsfZc9N+/YdLDgYA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791987255;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xZK2tXtr1EEATnsZ9uDLRVkZR5uAVy89NFi5xbcUArY=;
	b=XtQdN2eGN/WUUOmlsktWy4B3egqUkfgufP/NysZ9qI0817ZiNHRk9rge3IHqK98Q++wQzy
	mRHbGrF5G8Fi1YBg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=H5TC5xdj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XtQdN2eG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791987255; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xZK2tXtr1EEATnsZ9uDLRVkZR5uAVy89NFi5xbcUArY=;
	b=H5TC5xdjtF+s56Ornz1q3EZJPZVQd2kQoBUWJet3X7K5+IjcmAqq8LmgiMgOcE+PuGdEgp
	JcMdIU3wziQf+k96ZOUEiHC1BD52qFVksQmc/tDXeaQxviL6Z4DwOsuzyCOxXrHV7uEe11
	N8AHpqw/C07h/z5MsfZc9N+/YdLDgYA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791987255;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xZK2tXtr1EEATnsZ9uDLRVkZR5uAVy89NFi5xbcUArY=;
	b=XtQdN2eGN/WUUOmlsktWy4B3egqUkfgufP/NysZ9qI0817ZiNHRk9rge3IHqK98Q++wQzy
	mRHbGrF5G8Fi1YBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 17A70133F1;
	Wed, 14 Oct 2026 14:14:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Xve5NjaOz2qBbgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 14 Oct 2026 14:14:15 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4EE53A140F; Wed, 14 Oct 2026 16:14:10 +0200 (CEST)
Date: Wed, 14 Oct 2026 16:14:10 +0200
From: Jan Kara <jack@suse.cz>
To: Cen Zhang <zzzccc427@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	heming.zhao@suse.com, chao@kernel.org, jack@suse.cz, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, baijiaju1990@gmail.com, 
	jjzuming@gmail.com
Subject: Re: [PATCH] ocfs2: Cancel quota sync work before freeing quota info
Message-ID: <sjyz6ukoaxczc7vwjdbobzjihdep5wqid4bkgcpxqbbbpbme5w@6taeo52a4wwd>
References: <pm-ocfs2-objects-candidate-0052-v3-b4904bd6c85daf033adf@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pm-ocfs2-objects-candidate-0052-v3-b4904bd6c85daf033adf@gmail.com>
X-Rspamd-Action: no action
X-Spam-Score: -4.01
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[fasheh.com,evilplan.org,linux.alibaba.com,suse.com,kernel.org,suse.cz,lists.linux.dev,vger.kernel.org,gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Level: 
X-Rspamd-Queue-Id: 4DF921FB66
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

On Wed 14-10-26 11:43:40, Cen Zhang wrote:
> OCFS2 quota info owns dqi_sync_work and must outlive both its timer
> and qsync_work_fn(). ocfs2_local_free_info() frees that owner without
> cancelling the work, relying on the quota suspend/disable wrappers.
> 
> Loading quotas on a read-only to read-write remount can successfully
> queue the work in ocfs2_global_read_info() and then fail while attaching
> a dquot to an existing inode in add_dquot_ref(). The quota core unwinds
> that failure directly through dquot_disable(), bypassing the OCFS2
> wrapper:
> 
>   Remount task (s_umount write)        Timer/workqueue
>   ocfs2_global_read_info()
>     schedules dqi_sync_work
>   add_dquot_ref() returns an error
>   dquot_disable()
>     ocfs2_local_free_info()
>       frees oinfo
>                                      delayed-work timer expires
>                                      qsync_work_fn() reads oinfo
> 
> The timer core can then write to the freed embedded timer, or
> qsync_work_fn() can read oinfo->dqi_gqinode before its s_umount trylock.
> The outer ocfs2_disable_quotas() cleanup skips the failed type because
> dquot_disable() has already cleared its loaded state.
> 
> Cancel dqi_sync_work synchronously at the start of
> ocfs2_local_free_info(), before dropping the global inode or freeing any
> owner state. The work is initialized whenever read_file_info() succeeds.
> dquot_disable() holds s_umount for write, so the callback skips its quota
> scan via down_read_trylock() and can finish without waiting for teardown.
> The synchronous cancel also handles its self-rearm.
> 
> KASAN report as below:
> 
>     BUG: KASAN: slab-use-after-free in __run_timers+0x9e9/0xa10
>     Write of size 8 at addr ffff888111b0aad0 by task swapper/3/0
> 
>     Call Trace:
>      <IRQ>
>      dump_stack_lvl+0x93/0xd0
>      print_report+0xce/0x630
>      ? __run_timers+0x9e9/0xa10
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? __virt_addr_valid+0x20e/0x420
>      ? __run_timers+0x9e9/0xa10
>      kasan_report+0xe0/0x110
>      ? __run_timers+0x9e9/0xa10
>      __run_timers+0x9e9/0xa10
>      ? __pfx___run_timers+0x10/0x10
>      ? __lock_acquire+0x5a3/0x2140
>      ? __pfx_do_raw_spin_lock+0x10/0x10
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      timer_expire_remote+0xfa/0x160
>      ? __pfx_timer_expire_remote+0x10/0x10
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? trace_hardirqs_on+0x18/0x160
>      tmigr_handle_remote_up+0x4ba/0x9d0
>      ? __pfx_tmigr_handle_remote_up+0x10/0x10
>      ? tmigr_handle_remote+0x21a/0x340
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? lock_release+0xc8/0x290
>      ? __pfx_tmigr_handle_remote_up+0x10/0x10
>      __walk_groups_from+0x5a/0x160
>      tmigr_handle_remote+0x24f/0x340
>      ? __pfx_tmigr_handle_remote+0x10/0x10
>      ? lock_acquire+0x190/0x300
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? lock_release+0xc8/0x290
>      run_timer_softirq+0x222/0x270
>      ? __pfx_run_timer_softirq+0x10/0x10
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? lockdep_hardirqs_on_prepare+0xb8/0x1a0
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      handle_softirqs+0x1fa/0x8d0
>      ? __pfx_handle_softirqs+0x10/0x10
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? _raw_spin_unlock+0x23/0x40
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? __hrtimer_rearm_deferred+0x1fb/0x5d0
>      __irq_exit_rcu+0x113/0x1e0
>      irq_exit_rcu+0xe/0x20
>      sysvec_apic_timer_interrupt+0x6c/0x80
>      </IRQ>
>      <TASK>
>      asm_sysvec_apic_timer_interrupt+0x1a/0x20
>      ? ct_kernel_exit.constprop.0+0xc5/0xf0
>      ? do_idle+0x3ae/0x650
>      default_idle+0x9/0x10
>      default_idle_call+0x6c/0xb0
>      do_idle+0x3ae/0x650
>      ? cpuhp_online_idle+0x9c/0xb0
>      ? __pfx_do_idle+0x10/0x10
>      ? __entry_text_end+0x1020f6/0x1020f9
>      ? lockdep_hardirqs_on_prepare+0xeb/0x1a0
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? trace_hardirqs_on+0x18/0x160
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      cpu_startup_entry+0x54/0x60
>      start_secondary+0x223/0x2d0
>      ? __pfx_start_secondary+0x10/0x10
>      common_startup_64+0x13e/0x158
>      </TASK>
> 
>     Allocated by task 523:
>      kasan_save_stack+0x33/0x60
>      kasan_save_track+0x14/0x30
>      __kasan_kmalloc+0xaa/0xb0
>      __kmalloc_cache_noprof+0x28d/0x610
>      ocfs2_local_read_info+0x181/0x1580
>      dquot_load_quota_sb+0x69e/0x11c0
>      dquot_load_quota_inode+0x227/0x3e0
>      ocfs2_enable_quotas+0x27c/0x520
>      ocfs2_reconfigure+0x964/0xd00
>      reconfigure_super+0x3ca/0xa70
>      path_mount+0x141e/0x1e80
>      __x64_sys_mount+0x24b/0x2d0
>      do_syscall_64+0x114/0x620
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
>     Freed by task 523:
>      kasan_save_stack+0x33/0x60
>      kasan_save_track+0x14/0x30
>      kasan_save_free_info+0x3b/0x60
>      __kasan_slab_free+0x5f/0x80
>      kfree+0x308/0x580
>      ocfs2_local_free_info+0x47b/0x800
>      dquot_disable+0x5d9/0x17a0
>      dquot_load_quota_sb+0xd3c/0x11c0
>      dquot_load_quota_inode+0x227/0x3e0
>      ocfs2_enable_quotas+0x27c/0x520
>      ocfs2_reconfigure+0x964/0xd00
>      reconfigure_super+0x3ca/0xa70
>      path_mount+0x141e/0x1e80
>      __x64_sys_mount+0x24b/0x2d0
>      do_syscall_64+0x114/0x620
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
>     The buggy address belongs to the object at ffff888111b0a800
>      which belongs to the cache kmalloc-1k of size 1024
>     The buggy address is located 720 bytes inside of
>      freed 1024-byte region [ffff888111b0a800, ffff888111b0ac00)
> 
> Host details, register and page dumps omitted.
> 
> Fixes: 1a6152d36dee ("quota: propagate error from __dquot_initialize")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
> Assisted-by: LLM

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> ---
> diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
> index 76e7dd5aecc8..a2ce25a33607 100644
> --- a/fs/ocfs2/quota_local.c
> +++ b/fs/ocfs2/quota_local.c
> @@ -840,6 +840,9 @@ static int ocfs2_local_free_info(struct super_block *sb, int type)
>  	int mark_clean = 1, len;
>  	int status = 0;
>  
> +	/* Quota-core error paths can bypass ocfs2_disable_quotas(). */
> +	cancel_delayed_work_sync(&oinfo->dqi_sync_work);
> +
>  	iput(oinfo->dqi_gqinode);
>  	ocfs2_simple_drop_lockres(OCFS2_SB(sb), &oinfo->dqi_gqlock);
>  	ocfs2_lock_res_free(&oinfo->dqi_gqlock);
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
