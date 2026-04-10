Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1835523BCF7
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Apr 2026 02:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775789574; cv=none; b=H54IjrHd5ztSKBdM+1AIUTka3dVoKSgF2GpCUL9JSzpuZWzcPWlF8R3b6JmI/IDXgzqlrT0ESQ21eSg6LJH8eOj1G6F6KGFAM1ZfwOCW14G2ThFu1hX28M7ezuQ/u5cKu/Nk6a6kRdN2L2QwiKokYQDrXaIsBtjU5YiJ1w/DuHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775789574; c=relaxed/simple;
	bh=edLMqPGc5dCB+CxL4pSRCcDHQ8UcVttiN1rH/aqbJdk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r2ooSdPIAdWG16ObpUDo2PV64+sECxtILIgN913pD3rUT43Xqq87IvvV/om9hUOFuCKil6880fCdER3pk7OYHlYh5rv+DRRXX2ppyfGL5/NYqrYAWyp98TeQh7VjEL6Bh5Ka41gx1cxinur7tZL2o/aCCHjQShVuemNcuJYJm0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=BNH1j+6A; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="BNH1j+6A"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775789570; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=bRSkDuF6REETesaGfYw712tupsbwu+bSlTOuKLHJDMo=;
	b=BNH1j+6Az+QDefNd5ePZ006nQZ4B9Ok8/OJnZFcaXTzMOLqwE0mAt89vqzFIQ1emWAEmttk1eAaCoEAkaQ1NWt/cZ2JzhqnjBqWpZZALZjZRsaMRn/2QZscVRKpTdppFcWBSsTfBijabENGf/UH9PsoD2BwL1Zxih3rBY0K7f/0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X0jo8Q8_1775789569;
Received: from 30.221.145.28(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X0jo8Q8_1775789569 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Apr 2026 10:52:49 +0800
Message-ID: <48f5b77d-4d33-4792-9a68-6eeac3016223@linux.alibaba.com>
Date: Fri, 10 Apr 2026 10:52:48 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ocfs2: validate group add input before caching
To: ZhengYuan Huang <gality369@gmail.com>, akpm <akpm@linux-foundation.org>,
 Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <20260410020209.3786348-1-gality369@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260410020209.3786348-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/10/26 10:02 AM, ZhengYuan Huang wrote:
> [BUG]
> OCFS2_IOC_GROUP_ADD can trigger a BUG_ON in
> ocfs2_set_new_buffer_uptodate():
> 
> kernel BUG at fs/ocfs2/uptodate.c:509!
> Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
> RIP: 0010:ocfs2_set_new_buffer_uptodate+0x194/0x1e0 fs/ocfs2/uptodate.c:509
> Code: ffffe88f 42b9fe4c 89e64889 dfe8b4df
> Call Trace:
>  ocfs2_group_add+0x3f1/0x1510 fs/ocfs2/resize.c:507
>  ocfs2_ioctl+0x309/0x6e0 fs/ocfs2/ioctl.c:887
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl fs/ioctl.c:583 [inline]
>  __x64_sys_ioctl+0x197/0x1e0 fs/ioctl.c:583
>  x64_sys_call+0x1144/0x26a0 arch/x86/include/generated/asm/syscalls_64.h:17
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x93/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> RIP: 0033:0x7bbfb55a966d
> 
> [CAUSE]
> ocfs2_group_add() calls ocfs2_set_new_buffer_uptodate() on a
> user-controlled group block before ocfs2_verify_group_and_input()
> validates that block number. That helper is only valid for newly
> allocated metadata and asserts that the block is not already present in
> the chosen metadata cache. The code also uses INODE_CACHE(inode) even
> though the group descriptor belongs to main_bm_inode and later journal
> accesses use that cache context instead.
> 
> [FIX]
> Validate the on-disk group descriptor before caching it, then add it to
> the metadata cache tracked by INODE_CACHE(main_bm_inode). Keep the
> validation failure path separate from the later cleanup path so we only
> remove the buffer from that cache after it has actually been inserted.
> This keeps the group buffer lifetime consistent across validation,
> journaling, and cleanup.
> 
> Fixes: 7909f2bf8353 ("[PATCH 2/2] ocfs2: Implement group add for online resize")
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> v3:
> - keep out_free_group_bh as the brelse() label
> - add out_remove_cache for failures after cache insertion
> - send ocfs2_start_trans() failure to out_remove_cache
> 
> v2:
> - add the missing Fixes tag for the group-add introduction commit
> - keep the validation failure path separate so cache removal only happens
>   after the buffer has been inserted into main_bm_inode's cache
> ---
>  fs/ocfs2/resize.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
> index b0733c08ed13..5c6975d90ad6 100644
> --- a/fs/ocfs2/resize.c
> +++ b/fs/ocfs2/resize.c
> @@ -504,14 +504,14 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
>  		goto out_unlock;
>  	}
>  
> -	ocfs2_set_new_buffer_uptodate(INODE_CACHE(inode), group_bh);
> -
>  	ret = ocfs2_verify_group_and_input(main_bm_inode, fe, input, group_bh);
>  	if (ret) {
>  		mlog_errno(ret);
>  		goto out_free_group_bh;
>  	}
>  
> +	ocfs2_set_new_buffer_uptodate(INODE_CACHE(main_bm_inode), group_bh);
> +
>  	trace_ocfs2_group_add((unsigned long long)input->group,
>  			       input->chain, input->clusters, input->frees);
>  
> @@ -519,7 +519,7 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
>  	if (IS_ERR(handle)) {
>  		mlog_errno(PTR_ERR(handle));
>  		ret = -EINVAL;
> -		goto out_free_group_bh;
> +		goto out_remove_cache;
>  	}
>  
>  	cl_bpc = le16_to_cpu(fe->id2.i_chain.cl_bpc);
> @@ -573,9 +573,11 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
>  out_commit:
>  	ocfs2_commit_trans(osb, handle);
>  
> -out_free_group_bh:
> +out_remove_cache:
>  	if (ret < 0)
> -		ocfs2_remove_from_cache(INODE_CACHE(inode), group_bh);
> +		ocfs2_remove_from_cache(INODE_CACHE(main_bm_inode), group_bh);
> +
> +out_free_group_bh:
>  	brelse(group_bh);
>  
>  out_unlock:

