Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D324317D
	for <ocfs2-devel@lists.linux.dev>; Mon, 25 May 2026 05:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779687354; cv=none; b=Ad7OwRK9VDTJLBrj7EYXrz1re1+WhGIKEZZ33aF5bq88JNNnCT5UOVwlOdNZMCm5Da6ub8+e+iY3qnYmsnddv5Dv9aYUNjpJTNIZcCeem8ORGWBqDZvQulJJ33/FKa+FHz7Y5DfRivCwUWFPPaF5/fgDDX1QyODYx4g3pDQcW1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779687354; c=relaxed/simple;
	bh=CFfLMVoV3o9ADAtu5I/5YWehxRZMcw9h3WTlVFO7mmo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nwCgTONM9KwBmDUi9mZnxLfRmnfGuR3Vjlt0s0TKgeyBxBjiIBpHtQ6x6GY8CAq2Y8AdG9dKTP7b911w9Z2+QQkXHtPypOlWJSBEZln1R3OpIgqDMuj+7wM89807ico7bHoWHR6TRNYSUtGL8FQ/SCSnwlUrmQMA4LBAssUcWCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=CJh4T+SZ; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="CJh4T+SZ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779687342; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=/JF3RiRA7+XK8PKHhZbsFYjvqhK/F/OumC/XWRVysyM=;
	b=CJh4T+SZ80pqBJy+ACqdDPi3t6OF2b4Jl7Qnji9gbVxbmySXSvmxg5WIgNlcBf8m8i1F5x9TT1gzQZby01K370lvejDTTAfKfRRLgP5CJFzS7Bm631RJ3/J3Z74zFH8dhrzr3mrWMwJTN2ym2fAC1PRn56WSC3XAct1RTRfjMKA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X3UgiTu_1779687340;
Received: from 30.221.145.59(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X3UgiTu_1779687340 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 25 May 2026 13:35:41 +0800
Message-ID: <f60f10e2-564e-4d10-987c-4e3979966247@linux.alibaba.com>
Date: Mon, 25 May 2026 13:35:39 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ocfs2: rebase copied fsdlm LVB pointers in
 locking_state
To: Zhang Cen <rollkingzzc@gmail.com>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, zerocling0077@gmail.com,
 2045gemini@gmail.com, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
References: <20260525041726.4112882-1-rollkingzzc@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260525041726.4112882-1-rollkingzzc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/25/26 12:17 PM, Zhang Cen wrote:
> The locking_state debugfs iterator snapshots struct ocfs2_lock_res by
> value under ocfs2_dlm_tracking_lock and later formats that copy in
> ocfs2_dlm_seq_show(). That is fine for the inline fields, but the
> userspace fsdlm stack stores the LVB through lksb_fsdlm.sb_lvbptr. Once
> the iterator drops the tracking lock, a copied non-NULL sb_lvbptr still
> points into the original lockres owner, so teardown can free that
> container before the debugfs dump walks the raw LVB bytes.
> 
> Rebase the copied sb_lvbptr to the copied l_lksb before dumping the raw
> LVB. The seq snapshot already carries the inline LVB storage reserved in
> struct ocfs2_dlm_lksb, so the debugfs reader can dump the copied bytes
> without borrowing the original lockres lifetime.
> 
> The buggy scenario involves two paths, with each column showing the order
> within that path:
> 
> locking_state reader:                  lockres teardown:
> 1. ocfs2_dlm_seq_start()/next()        1. file release or another owner
>    copies struct ocfs2_lock_res           teardown reaches
> 2. ocfs2_dlm_seq_show() formats           ocfs2_lock_res_free()
>    the copied row                      2. the lockres is removed from the
> 3. ocfs2_dlm_lvb() follows the            tracking list
>    copied sb_lvbptr                   3. the owner frees the original
>                                           lockres container
> 
> Validation reproduced this kernel report:
> KASAN slab-use-after-free in ocfs2_dlm_seq_show+0x1bd/0x430
> RIP: 0033:0x7f8ec4b1e29d
> The buggy address belongs to the object at ffff88810a1e0800 which belongs
> to the cache kmalloc-1k of size 1024
> The buggy address is located 368 bytes inside of freed 1024-byte region
> [ffff88810a1e0800, ffff88810a1e0c00)
> Read of size 1
> Call trace:
>   dump_stack_lvl+0x66/0xa0
>   print_report+0xce/0x630
>   ocfs2_dlm_seq_show+0x1bd/0x430 (fs/ocfs2/dlmglue.c:3137)
>   srso_alias_return_thunk+0x5/0xfbef5
>   __virt_addr_valid+0x19f/0x330
>   kasan_report+0xe0/0x110
>   seq_read_iter+0x29d/0x790
>   seq_read+0x20a/0x280
>   find_held_lock+0x2b/0x80
>   rcu_read_unlock+0x18/0x70
>   full_proxy_read+0x9e/0xd0
>   vfs_read+0x12c/0x590
>   ksys_read+0xd2/0x170
>   do_user_addr_fault+0x65a/0x890
>   do_syscall_64+0x115/0x6a0 (arch/x86/entry/syscall_64.c:87)
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> Allocated by task stack:
>   kasan_save_stack+0x33/0x60
>   kasan_save_track+0x14/0x30
>   __kasan_kmalloc+0xaa/0xb0
>   ocfs2_file_open+0x13e/0x300
>   do_dentry_open+0x233/0x7f0
>   vfs_open+0x5a/0x1b0
>   path_openat+0x66d/0x1540
>   do_file_open+0x186/0x2b0
>   do_sys_openat2+0xce/0x150
>   __x64_sys_openat+0xd0/0x140
>   do_syscall_64+0x115/0x6a0 (arch/x86/entry/syscall_64.c:87)
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> Freed by task stack:
>   kasan_save_stack+0x33/0x60
>   kasan_save_track+0x14/0x30
>   kasan_save_free_info+0x3b/0x60
>   __kasan_slab_free+0x5f/0x80
>   kfree+0x313/0x590
>   ocfs2_file_release+0x138/0x260
>   __fput+0x1df/0x4b0
>   fput_close_sync+0xd2/0x170
>   __x64_sys_close+0x55/0x90
>   do_syscall_64+0x115/0x6a0 (arch/x86/entry/syscall_64.c:87)
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> Fixes: cf4d8d75d8ab ("ocfs2: add fsdlm to stackglue")
> Assisted-by: Codex:gpt-5.5
> Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> v3:
> Fix the truncated commit log in v2.
> Include the complete KASAN use, allocation, and free stacks from validation.
> No code changes.
> 
> v2:
> Document the introducing fsdlm stackglue commit.
> 
>  fs/ocfs2/dlmglue.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 7283bb2c5a31..a23dd8f86c89 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -3134,6 +3134,22 @@ static void *ocfs2_dlm_seq_next(struct seq_file *m, void *v, loff_t *pos)
>   *	- Add last pr/ex unlock times and first lock wait time in usecs
>   */
>  #define OCFS2_DLM_DEBUG_STR_VERSION 4
> +
> +/*
> + * The debug iterator snapshots lockres by value, so a userspace-stack LVB
> + * pointer copied from the original lockres must be rebased to the copied
> + * lksb before the dump walks the raw bytes.
> + */
> +static void ocfs2_dlm_seq_rebase_lvb(struct ocfs2_lock_res *lockres)
> +{
> +	if (!ocfs2_stack_supports_plocks())
> +		return;
> +
> +	if (lockres->l_lksb.lksb_fsdlm.sb_lvbptr)
> +		lockres->l_lksb.lksb_fsdlm.sb_lvbptr =
> +			(char *)&lockres->l_lksb + sizeof(struct dlm_lksb);
> +}
> +
>  static int ocfs2_dlm_seq_show(struct seq_file *m, void *v)
>  {
>  	int i;
> @@ -3191,6 +3207,7 @@ static int ocfs2_dlm_seq_show(struct seq_file *m, void *v)
>  		   lockres->l_blocking);
>  
>  	/* Dump the raw LVB */
> +	ocfs2_dlm_seq_rebase_lvb(lockres);
>  	lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
>  	for(i = 0; i < DLM_LVB_LEN; i++)
>  		seq_printf(m, "0x%x\t", lvb[i]);

