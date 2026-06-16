Received: from mail-108-mta137.mxroute.com (mail-108-mta137.mxroute.com [136.175.108.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44DA38D6B1
	for <ocfs2-devel@lists.linux.dev>; Tue, 16 Jun 2026 02:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781575516; cv=none; b=T8p8EnRtbzPfW82SccxlTz2su+WedFk6TrFQe3EQaD27BMBN/yARvbtW+sLDaIUpFoO+/Er1s3SqPIUGYZGn+V0QAeGDmkkxPx5yipAuuDd4sZ3Xzgbf6Ub9Wdy5LPsnfTdPQ0+i99GfX9csmISjo8vLxW0gbhZdvczLwHXmmhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781575516; c=relaxed/simple;
	bh=YEJE5A/tSDkKwkjtFWrjNHEEnfdWd56Iws8cKs+fWgo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=jz8O101eN+XstF7kIEbTYgxAAJB+TclFPwL/Cn6jfb4fVJ5kMt4PODbawK6pKLPrvJTmxTDVp7Cg6xDPcXgjkJzCCvTXpwJxDMxQiVHGIYVsML89NzigM++14/vLF/EZ6TyvVzL5GOII8KS9DkuNMHSU/H8G/J1pu7gMkyOjLnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=LN+Jz9WG; arc=none smtp.client-ip=136.175.108.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="LN+Jz9WG"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta137.mxroute.com (ZoneMTA) with ESMTPSA id 19ece28349500067f7.007
 for <ocfs2-devel@lists.linux.dev>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Tue, 16 Jun 2026 02:00:01 +0000
X-Zone-Loop: 97c7b5d1a3843b5d8d9345b18ebd02e3db05f01508dd
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:Date:References:In-Reply-To:
	Subject:Cc:To:From:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1TGmJBeCmoASDuhfZSVp4cyz9t64lKgvUFvXZKSeS4U=; b=LN+Jz9WGN0Gnwvydwu9LpRtfvQ
	RbLwsCljjv5bJI8IX2YQ1HBiNIjOPANWt4dK9oWUqZ19lPyOzCD9lrEK6kvG3IkDKLq7ywPOKGyk0
	nh5HIRuXxYbAduR38QdVI+PMQyy+zIpPg9GZ8hSv//7GEX4dfFqkPtvltH09ZTrysFW6yy17uHMXj
	NMBT7Ba+JRhpHFYOhb4kw90JGiAluA79S0xCsuf/xADCetRWhnibvOMI79Eq/cW9sUu5HaPi8yAul
	iB86+NjIABk6CZWDHDHZuZ1iKUlkXFmN7kZIHG+N/2oSFynJsFW2r8PFx80fMgxBv8uIE37iFNRtM
	9iJsGAFQ==;
From: Su Yue <l@damenly.org>
To: Zhang Cen <rollkingzzc@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>,  Joel Becker <jlbec@evilplan.org>,
  Joseph Qi <joseph.qi@linux.alibaba.com>,  ocfs2-devel@lists.linux.dev,
  zerocling0077@gmail.com,  2045gemini@gmail.com
Subject: Re: [PATCH] ocfs2: remove debugfs before shutting down recovery
In-Reply-To: <20260525070604.360875-1-rollkingzzc@gmail.com> (Zhang Cen's
	message of "Mon, 25 May 2026 15:06:04 +0800")
References: <20260525070604.360875-1-rollkingzzc@gmail.com>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Tue, 16 Jun 2026 09:59:47 +0800
Message-ID: <tsr3tfcc.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org

On Mon 25 May 2026 at 15:06, Zhang Cen <rollkingzzc@gmail.com> 
wrote:

> ocfs2_osb_debug_open() builds the per-mount fs_state snapshot by 
> calling
> ocfs2_osb_dump(), which reads osb->recovery_map. During normal 
> unmount,
> ocfs2_dismount_volume() currently calls ocfs2_recovery_exit() 
> before it
> removes osb->osb_debug_root, so a concurrent fs_state open can 
> still
> enter ocfs2_osb_dump() after the recovery map has been freed.
>
> operations, so moving it ahead of ocfs2_recovery_exit() closes 
> the
>
"operations,"? Seems one line is missing.

> post-free/pre-remove window without changing the recovery-state 
> logic.
> This also makes the normal unmount path match the existing 
> mount-error
> state.
>
> The buggy scenario involves two paths, with each column showing 
> the
> order within that path:
>
> 1. Open the per-mount fs_state file      1. 
> ocfs2_dismount_volume() starts
> 2. ocfs2_osb_debug_open() calls          2. 
> ocfs2_recovery_exit() frees
>    ocfs2_osb_dump()                         osb->recovery_map
>    osb->recovery_map                        runs later
>
> Validation reproduced this kernel report:
>
Please paste the link of report or steps to reproduce.

The codes LGTM.

--
Su

> KASAN slab-use-after-free in ocfs2_osb_debug_open+0x478/0xaa0
> RIP: 0033:0x7f65fc97a001
> The buggy address belongs to the object at ffff8881049c3da0 
> which belongs
> to the cache kmalloc-8 of size 8
> The buggy address is located 0 bytes inside of freed 8-byte 
> region
> [ffff8881049c3da0, ffff8881049c3da8)
> Read of size 4
> Call trace:
>   dump_stack_lvl+0x66/0xa0 (?:?)
>   print_report+0xd0/0x630 (?:?)
>   ocfs2_osb_debug_open+0x478/0xaa0 (fs/ocfs2/super.c:343)
>   srso_alias_return_thunk+0x5/0xfbef5 (?:?)
>   __virt_addr_valid+0x188/0x2f0 (?:?)
>   kasan_report+0xe4/0x120 (?:?)
>   full_proxy_open_regular+0x113/0x170 (?:?)
>   do_dentry_open+0x233/0x7f0 (?:?)
>   vfs_open+0x5a/0x1b0 (?:?)
>   security_inode_permission+0x19/0x60 (?:?)
>   path_openat+0x679/0x1540 (?:?)
>   kmem_cache_alloc_noprof+0x1ea/0x5f0 (?:?)
>   do_getname+0x2e/0x1d0 (?:?)
>   do_sys_openat2+0xa4/0x150 (?:?)
>   __x64_sys_openat+0xd0/0x140 (?:?)
>   do_syscall_64+0x10c/0x640 (arch/x86/entry/syscall_64.c:87)
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f (?:?)
>   do_file_open+0x190/0x2a0 (?:?)
>   __lock_acquire+0x42f/0x1a60 (?:?)
>   _raw_spin_unlock+0x23/0x40 (?:?)
>   alloc_fd+0x210/0x350 (?:?)
>   do_sys_openat2+0xce/0x150 (?:?)
>   irqentry_exit+0xac/0x6e0 (?:?)
> Freed by task stack:
>   kasan_save_stack+0x33/0x60 (?:?)
>   kasan_save_track+0x14/0x30 (?:?)
>   kasan_save_free_info+0x3b/0x60 (?:?)
>   __kasan_slab_free+0x5f/0x80 (?:?)
>   kfree+0x30f/0x580 (?:?)
>   ocfs2_dismount_volume+0x168/0x560 (fs/ocfs2/super.c:1868)
>   generic_shutdown_super+0xc3/0x220 (fs/ocfs2/super.c:?)
>   kill_block_super+0x29/0x60 (fs/ocfs2/super.c:?)
>   deactivate_locked_super+0x66/0xe0 (fs/ocfs2/super.c:?)
>   cleanup_mnt+0x13d/0x210 (?:?)
>   task_work_run+0xfa/0x170 (?:?)
>   exit_to_user_mode_loop+0xd6/0x430 (?:?)
>   do_syscall_64+0x3cb/0x640 (arch/x86/entry/syscall_64.c:87)
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f (?:?)
>
> Fixes: 5e7a3ed9f1a6 ("ocfs2: further debugfs cleanups")
> Assisted-by: Codex:gpt-5.5
> Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
> ---
>  fs/ocfs2/super.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index b875f01c9756..357f210b6a43 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1826,6 +1826,9 @@ static void ocfs2_dismount_volume(struct 
> super_block *sb, int mnt_err)
>
>  	ocfs2_truncate_log_shutdown(osb);
>
> +	ocfs2_blockcheck_stats_debugfs_remove(&osb->osb_ecc_stats);
> +	debugfs_remove_recursive(osb->osb_debug_root);
> +
>  	/* This will disable recovery and flush any recovery work. */
>  	ocfs2_recovery_exit(osb);
>
> @@ -1865,9 +1868,6 @@ static void ocfs2_dismount_volume(struct 
> super_block *sb, int mnt_err)
>
>  	ocfs2_dlm_shutdown(osb, hangup_needed);
>
> -	ocfs2_blockcheck_stats_debugfs_remove(&osb->osb_ecc_stats);
> -	debugfs_remove_recursive(osb->osb_debug_root);
> -
>  	if (hangup_needed)
>  		ocfs2_cluster_hangup(osb->uuid_str, 
>  strlen(osb->uuid_str));
