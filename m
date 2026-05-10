Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046CA214A9B
	for <ocfs2-devel@lists.linux.dev>; Sun, 10 May 2026 03:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778385245; cv=none; b=mxruNZIsv5Soa8EBVS03LMBO9wkmXvnRo6KiKA8HialVqfBgl/jW01aZDHFcOvsx5D7wu/Sjdx+/WbsxHiclTIV0UKZ+XJqbaXPr8sDt/V9XXSQ7xLvvbmvifnb9HS6yqIrvGl7qI8Gj6zGbjCY+yFNH6m2tcZ5ldOu2sbue6kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778385245; c=relaxed/simple;
	bh=Fo3Dfey27MNp00JfxQ1xp9iutd+O9o4cpVfCgC/FPh4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rD0FcrgxwqOl7qO7H8PF/hD95xT8hxNHUkXHApKqD17wAkmN3RgjjEQlm6f/UOG4fWsmHWtxj8shacXCD6PPy09/ie9W4NoTZ6xvpwAZVEDCJV29Gg1gKSWqV0Rl/a3gv5rOQc8z7E+zaR3XP8VyyzLlGg552QlxAJB/8qycDhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=NWnOWOeB; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="NWnOWOeB"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778385240; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=9QgZlxJjVt1LsgABW27Tg8WZNnO8ZDpkHKKX1Kgio3c=;
	b=NWnOWOeBjwPj+J5koSL+kbP9HYkqmZuBpGeND1N2Fjn1qGAzEVaeRaQgYsK41kZsrkQyIfqwgJViLCOmaeN+EFGswx3eh+KLXEgsjGKcaxY+UGt7vBqgRhi6J6UStWy3Z2fG8l+QtNcH1Jip5DGTQg0Jpb6zzzWETt/xB3b+MXY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X2beYux_1778385239;
Received: from 30.41.171.241(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X2beYux_1778385239 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 10 May 2026 11:53:59 +0800
Message-ID: <cd56254b-1ff0-4058-b67e-1a6cd4e10ead@linux.alibaba.com>
Date: Sun, 10 May 2026 11:53:58 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: reject inconsistent inode size before truncate
To: ZhengYuan Huang <gality369@gmail.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <20260509091004.758218-1-gality369@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260509091004.758218-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/9/26 5:10 PM, ZhengYuan Huang wrote:
> [BUG]
> openat(..., O_WRONLY|O_CREAT|O_TRUNC) can hit:
> 
> kernel BUG at fs/ocfs2/file.c:454!
> Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
> RIP: 0010:ocfs2_truncate_file+0x1204/0x13c0 fs/ocfs2/file.c:454
> Call Trace:
>  ocfs2_setattr+0xa6d/0x1fd0 fs/ocfs2/file.c:1212
>  notify_change+0x4b5/0x1030 fs/attr.c:546
>  do_truncate+0x1d2/0x230 fs/open.c:68
>  handle_truncate fs/namei.c:3596 [inline]
>  do_open fs/namei.c:3979 [inline]
>  path_openat+0x260f/0x2ce0 fs/namei.c:4134
>  do_filp_open+0x1f6/0x430 fs/namei.c:4161
>  do_sys_openat2+0x117/0x1c0 fs/open.c:1437
>  do_sys_open fs/open.c:1452 [inline]
>  __do_sys_openat fs/open.c:1468 [inline]
>  __se_sys_openat fs/open.c:1463 [inline]
>  __x64_sys_openat+0x15b/0x220 fs/open.c:1463
>  ...
> 
> [CAUSE]
> ocfs2_truncate_file() treats di_bh->i_size matching inode->i_size as an
> internal code invariant and BUGs if it is broken.
> 
> That assumption is too strong for corrupted metadata. The dinode block can
> still be structurally valid enough to pass ocfs2_read_inode_block() while
> no longer matching an already-instantiated VFS inode. On local mounts,
> ocfs2_inode_lock_update() skips refresh entirely, so truncate can
> observe the mismatch directly and crash instead of rejecting the
> corruption.
> 
> [FIX]
> Turn the BUG_ON into normal OCFS2 corruption handling. If truncate sees
> di_bh->i_size disagree with inode->i_size, report it with ocfs2_error() and
> abort before touching truncate state.
> 
> This keeps the fix at the first boundary that actually requires the
> sizes to match and avoids widening checks into hotter generic
> inode-lock paths.
> 
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> ---
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -444,15 +444,17 @@ int ocfs2_truncate_file(struct inode *inode,
>  	int status = 0;
>  	struct ocfs2_dinode *fe = NULL;
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>  
> -	/* We trust di_bh because it comes from ocfs2_inode_lock(), which
> -	 * already validated it */
> +	/*
> +	 * ocfs2_inode_lock() validated the dinode block, but truncation
> +	 * still needs to reject an inode state that no longer matches
> +	 * di_bh.
> +	 */

In commit log, you mention the case is local mount.
So here comments should refer it.

Thanks,
Joseph

>  	fe = (struct ocfs2_dinode *) di_bh->b_data;
>  
>  	trace_ocfs2_truncate_file((unsigned long long)OCFS2_I(inode)->ip_blkno,
>  				  (unsigned long long)le64_to_cpu(fe->i_size),
>  				  (unsigned long long)new_i_size);
>  
> -	mlog_bug_on_msg(le64_to_cpu(fe->i_size) != i_size_read(inode),
> -			"Inode %llu, inode i_size = %lld != di "
> -			"i_size = %llu, i_flags = 0x%x\n",
> -			(unsigned long long)OCFS2_I(inode)->ip_blkno,
> -			i_size_read(inode),
> -			(unsigned long long)le64_to_cpu(fe->i_size),
> -			le32_to_cpu(fe->i_flags));
> +	if (unlikely(le64_to_cpu(fe->i_size) != i_size_read(inode))) {
> +		status = ocfs2_error(inode->i_sb,
> +				     "Inode %llu has inconsistent i_size: inode = %lld, dinode = %llu, i_flags = 0x%x\n",
> +				     (unsigned long long)OCFS2_I(inode)->ip_blkno,
> +				     i_size_read(inode),
> +				     (unsigned long long)le64_to_cpu(fe->i_size),
> +				     le32_to_cpu(fe->i_flags));
> +		goto bail;
> +	}
>  
>  	if (new_i_size > le64_to_cpu(fe->i_size)) {
>  		trace_ocfs2_truncate_file_error(
>  			(unsigned long long)le64_to_cpu(fe->i_size),

