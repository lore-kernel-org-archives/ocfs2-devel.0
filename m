Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E8A24C097
	for <ocfs2-devel@lists.linux.dev>; Thu,  3 Apr 2025 11:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743680001; cv=none; b=C7oMqgjKHSUGME1X57G1D17BEwnnjxsVsTlYDYZ4HPPJCNdQL+lk7iYeGn1k4Us+WTf1CwV8V/0sUqy1tAOdNp7UZ2TWPYZgvd/FkzfK+w95PMP4LOSjo9b3FmrUcj9odfOxIYZCYc3m3fZEpcNYuqxH9LMeazhoapbUN2w3XI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743680001; c=relaxed/simple;
	bh=fvFNYyiL3jHgoGPm5sLJkOGdN7KGA8zjp3LJSrv2Ge0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CdUXLjNkRV6/NJGtoWWJaMQ9+k31A3GhV0l6dNtJKq1LjIy9cXh1QMi7mjZUfVQSRQTUu+rhnh5qG8FCY63kezP3HagoCGtaZfNB6AgDe1gsLElJHD/qRJ9vHUhCxge67i0kWk8aY23pRCG/FerDcoPWG87rymvvuz6ZtX2VB3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=oQ6wmXag; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=TTnzvejB; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Dy4YDhnF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7IAPh+TM; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="oQ6wmXag";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="TTnzvejB";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Dy4YDhnF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7IAPh+TM"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id ED307211CD;
	Thu,  3 Apr 2025 11:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1743679989; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SRpp3RRIIbWts3o24hnHo7jwYeOjLd2wCZq6OBJgS0I=;
	b=oQ6wmXag+GGi4pl28RKD7yhuDZFl1ICgqj4zSRdvkFa/5FWv9vyCoHy6/FxXX01PTgc+Lh
	rknL4QfkGMfN/Qp0fQQfuiiJxsJtaV10ER3+JI04HVEl1cmxQAfT5Tay+Z9K8zRT+tSC90
	ll/8KyRgmNGUY0dn3cKA6dIXGUS0iNA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1743679989;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SRpp3RRIIbWts3o24hnHo7jwYeOjLd2wCZq6OBJgS0I=;
	b=TTnzvejBan7BxYRwe8CJyFuO90EsU4wS/afbdXlvaTjVCBV9Q36RQWR2jLSRElUEFa9H3X
	1hpv3aFOQEDn2sCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1743679988; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SRpp3RRIIbWts3o24hnHo7jwYeOjLd2wCZq6OBJgS0I=;
	b=Dy4YDhnFJV+td24a1iNw3W8ldpBj7U/9i0SEl3QQdPIQI5QplxvDJtlB0yTUuqlCMwYHjx
	qgQbulmpi5N9m5WG4dzqJ+z4jiL9+0o0+8Xiv0wtekRzvpJgRNeIRORyPDh1geQ6HPz/OL
	Q9ZNa3b+0ws3jeL7t0EkQRyvSi/ezYA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1743679988;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SRpp3RRIIbWts3o24hnHo7jwYeOjLd2wCZq6OBJgS0I=;
	b=7IAPh+TMOy8g8uJApAfp5FY3BESnAck5AtmpSlcpmFncszSPg4WsXiUO/VUyynuKrMlDFo
	XRh4NMILjgVZfUAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D5D1D13A2C;
	Thu,  3 Apr 2025 11:33:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PbkmNPRx7mckGwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 03 Apr 2025 11:33:08 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8FD12A07E6; Thu,  3 Apr 2025 13:33:08 +0200 (CEST)
Date: Thu, 3 Apr 2025 13:33:08 +0200
From: Jan Kara <jack@suse.cz>
To: Murad Masimov <m.masimov@mt-integration.ru>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Jan Kara <jack@suse.cz>, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org, 
	syzbot+f59a1ae7b7227c859b8f@syzkaller.appspotmail.com
Subject: Re: [PATCH 2/2] ocfs2: Fix deadlock in ocfs2_finish_quota_recovery
Message-ID: <vrxva7wxxd4ajtkvrtltggqfhjvs34xtt7jyrney6g7tlmlw7n@dxwzinbmsumu>
References: <20250402065628.706359-1-m.masimov@mt-integration.ru>
 <20250402065628.706359-3-m.masimov@mt-integration.ru>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250402065628.706359-3-m.masimov@mt-integration.ru>
X-Spam-Level: 
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[f59a1ae7b7227c859b8f];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[9];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -2.30
X-Spam-Flag: NO

On Wed 02-04-25 09:56:28, Murad Masimov wrote:
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

Thanks for looking into this. I have one comment:

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
> +	if (!down_read_trylock(&sb->s_umount)) {
> +		status = -ENOENT;
> +		goto out;
> +	}

So this could skip recovering quotas when we are remounting the superblock
as well and that would result in quotas being off (for modifications stored
in unrecovered local quota file) for the duration of the mount. In fact, we
almost don't need s_umount in ocfs2_finish_quota_recovery() so I think
proper solution is actually to remove it. *But* there's one catch: we need
to make sure quota recovery work cannot happen after ocfs2_disable_quotas()
called from ocfs2_dismount_volume(). I have proposed a solution here [1]
many years ago but it didn't work and then I never got to writing something
better. Looking at it now I think we should implement disabling just quota
recovery in the recovery thread. I've sent patches for that now [2]. I
gave them some basic testing on local mode but that does not stress
recovery code much. It would be great if someone could give them testing in
cluster mode where nodes get killed and recovery happens (I currently don't
have test setup for that).

								Honza

[1] https://lore.kernel.org/all/20180228111802.23967-1-jack@suse.cz/
[2] https://lore.kernel.org/all/20250403112908.13750-1-jack@suse.cz/
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
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
