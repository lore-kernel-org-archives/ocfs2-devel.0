Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080FA35E930
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Jun 2026 12:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780317925; cv=none; b=nbIPUDHPGo+3Asu1D6Fs+Z+g0vihqy1KTkxt4dtiwz04kIhtp1/UknOiqPW0HOLtm6kvsh2bEZTikQ3HfZv40F80qaQggO8uyFppbayXyPYYm5LqtK00wRDXx3qb0ckJBzyhAEN9Db1KdKzQxezCJiJiCJ8iYf5xTZ3SmlC/NmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780317925; c=relaxed/simple;
	bh=CzPl7Wk78Phv9q5e8upWhDc73u5k/7xyy3xuKv7QEiw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qnsFc4IHWwk8v6ZeHf2NyhKL/dqGe/Wuy1W1EchsugUv9ebiPnQ7JitRUEQeXEwBLUCPQ2KxWb4TWtH+q0mKsXGcx7b5wsvpnergqa7b6U1M7snCOoGetfBpcGQLXYMMq5QXDpHr0yWzqmiaUctboPKtIuYUG5r74XVEes0zIzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=gUhnjRWi; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="gUhnjRWi"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780317920; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=6Rqr5i8DAp6a3D8qir1QVgpRFsPdy3stl1Nq91jjLc4=;
	b=gUhnjRWiBPRV6bIM5ssNT5Ma18RS0Mwafayqg1NMRYOEwisV1KFHyHUehP79nlDL57mEm4+c/kpu09tQ5a8yYEqc3BAB7hW1CF5I0RCw5yNgIgu5ueNcVulH9yo/wkMIlKO5OtGf2IOhUuQ6WXCI4m0BJgyG+EbV4ZbSCqzhZb4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X4.U.zd_1780317919;
Received: from 30.134.110.188(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X4.U.zd_1780317919 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 01 Jun 2026 20:45:19 +0800
Message-ID: <6d98322e-876c-42e9-a9bc-e8f464fb8562@linux.alibaba.com>
Date: Mon, 1 Jun 2026 20:45:18 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2/dlm: require a ref for locking_state debugfs open
To: Zhang Cen <rollkingzzc@gmail.com>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, zerocling0077@gmail.com,
 2045gemini@gmail.com, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
References: <20260531044714.1640172-1-rollkingzzc@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260531044714.1640172-1-rollkingzzc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/31/26 12:47 PM, Zhang Cen wrote:
> debug_lockres_open() copies inode->i_private into struct debug_lockres and
> debug_lockres_release() later drops that pointer with dlm_put(). That only
> works if open successfully pins the struct dlm_ctxt.
> 
> Today open calls dlm_grab(dlm) but ignores its return value. Once the last
> domain unregister has removed the context from dlm_domains, dlm_grab()
> returns NULL, yet open still stores the raw pointer and returns success.
> The later release path is outside the debugfs removal barrier, so it can
> call dlm_put() after dlm_free_ctxt_mem() has freed the context. KASAN
> reports this as a slab-use-after-free in dlm_put() called from
> debug_lockres_release().
> 
> Fail the open when dlm_grab() cannot acquire the reference and unwind the
> seq_file private state before returning. That keeps locking_state from
> handing out a file descriptor whose release path does not own the dlm_ctxt.
> 
> The buggy scenario involves two paths, with each column showing the order
> within that path:
> 
> locking_state debugfs open:          last domain unregister:
> 1. debug_lockres_open() reads        1. dlm_unregister_domain() calls
>    inode->i_private.                    dlm_complete_dlm_shutdown().
> 2. debug_lockres_open() calls        2. shutdown removes the dlm_ctxt from
>    dlm_grab(dlm) and gets NULL.         dlm_domains.
> 3. open still stores the raw dlm     3. final teardown reaches
>    pointer in dl->dl_ctxt and           dlm_free_ctxt_mem() and frees it.
>    returns success.
> 4. debug_lockres_release() later
>    calls dlm_put(dl->dl_ctxt).
> 
> Validation reproduced this kernel report:
> KASAN slab-use-after-free in dlm_put+0x82/0x200
> RIP: 0033:0x7f4d349bc9e0
> The buggy address belongs to the object at ffff888103a3c000 which belongs
> to the cache kmalloc-2k of size 2048
> The buggy address is located 816 bytes inside of freed 2048-byte region
> [ffff888103a3c000, ffff888103a3c800)
> Write of size 4
> Call trace:
>   dump_stack_lvl+0x66/0xa0 (?:?)
>   print_report+0xd0/0x630 (?:?)
>   dlm_put+0x82/0x200 (?:?)
>   srso_alias_return_thunk+0x5/0xfbef5 (?:?)
>   __virt_addr_valid+0x188/0x2f0 (?:?)
>   kasan_report+0xe4/0x120 (?:?)
>   kasan_check_range+0x105/0x1b0 (?:?)
>   debug_lockres_release+0x53/0x80 (fs/ocfs2/dlm/dlmdebug.c:587)
>   dlm_put+0x9/0x200 (?:?)
>   debug_lockres_release+0x5c/0x80 (fs/ocfs2/dlm/dlmdebug.c:587)
>   full_proxy_release+0x67/0x90 (?:?)
>   __fput+0x1df/0x4b0 (?:?)
>   do_raw_spin_lock+0x10f/0x1b0 (?:?)
>   fput_close_sync+0xd2/0x170 (?:?)
>   __x64_sys_close+0x55/0x90 (?:?)
>   do_syscall_64+0x10c/0x640 (arch/x86/entry/syscall_64.c:87)
>   irqentry_exit+0xac/0x6e0 (?:?)
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f (?:?)
> Freed by task stack:
>   kasan_save_stack+0x33/0x60 (?:?)
>   kasan_save_track+0x14/0x30 (?:?)
>   kasan_save_free_info+0x3b/0x60 (?:?)
>   __kasan_slab_free+0x5f/0x80 (?:?)
>   kfree+0x30f/0x580 (?:?)
>   dlm_put+0x1ce/0x200 (?:?)
>   dlm_unregister_domain+0xf6/0xb30 (?:?)
>   o2cb_cluster_disconnect+0x6b/0x90 (?:?)
>   ocfs2_cluster_disconnect+0x41/0x70 (?:?)
>   ocfs2_dlm_shutdown+0x1c4/0x220 (?:?)
>   ocfs2_dismount_volume+0x38a/0x550 (?:?)
>   generic_shutdown_super+0xc3/0x220 (?:?)
>   kill_block_super+0x29/0x60 (?:?)
>   deactivate_locked_super+0x66/0xe0 (?:?)
>   cleanup_mnt+0x13d/0x210 (?:?)
>   task_work_run+0xfa/0x170 (?:?)
>   exit_to_user_mode_loop+0xd6/0x430 (?:?)
>   do_syscall_64+0x3cb/0x640 (arch/x86/entry/syscall_64.c:87)
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f (?:?)
> 
> Fixes: 4e3d24ed1a12 ("ocfs2/dlm: Dumps the lockres' into a debugfs file")
> Assisted-by: Codex:gpt-5.5
> Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/dlm/dlmdebug.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
> index fe4fdd09bae3..564567358620 100644
> --- a/fs/ocfs2/dlm/dlmdebug.c
> +++ b/fs/ocfs2/dlm/dlmdebug.c
> @@ -560,6 +560,7 @@ static int debug_lockres_open(struct inode *inode, struct file *file)
>  	struct dlm_ctxt *dlm = inode->i_private;
>  	struct debug_lockres *dl;
>  	void *buf;
> +	int status = -ENOMEM;
>  
>  	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
>  	if (!buf)
> @@ -572,16 +573,23 @@ static int debug_lockres_open(struct inode *inode, struct file *file)
>  	dl->dl_len = PAGE_SIZE;
>  	dl->dl_buf = buf;
>  
> -	dlm_grab(dlm);
> -	dl->dl_ctxt = dlm;
> +	/* ->release uses dl_ctxt after open, so it needs a real pin. */
> +	dl->dl_ctxt = dlm_grab(dlm);
> +	if (!dl->dl_ctxt) {
> +		status = -ENOENT;
> +		goto bailseq;
> +	}
>  
>  	return 0;
>  
> +bailseq:
> +	seq_release_private(inode, file);
>  bailfree:
>  	kfree(buf);
>  bail:
> -	mlog_errno(-ENOMEM);
> -	return -ENOMEM;
> +	if (status != -ENOENT)
> +		mlog_errno(status);
> +	return status;
>  }
>  
>  static int debug_lockres_release(struct inode *inode, struct file *file)

