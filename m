Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F63B39B49D
	for <ocfs2-devel@lists.linux.dev>; Wed,  1 Apr 2026 10:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775037625; cv=none; b=cHGkh8M2Z9yYhomzw6rNZgmvMTJsxQErBcRedEofOpd15Mt1sKpDw2r0a2AKskZceCZAh4udDqI283fKlgQhxWiFJftwGPMoIcyeqFoTjahOhV6NraWJCOHpkF/O0xueBGEiBRgp99gbyobUJ5Gyk6HpGnAh8j8s4Q9Lf+u+GT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775037625; c=relaxed/simple;
	bh=uJTwv599PHz936vgBK7BXRWHdTkK5YFbXR/3mcy1dlg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m4a7WExLrfWEwY+l0tNXrSmAk+nAWjMP/Nunx5f4zq9IZ+Sg5V6FRixr6+OSx7ClRnbcNQ3Lt9T6FOMgK6/mfZYyxA3s/IyYQ1IW2ToM8X22TmwZsfpW2IznmlZwMem6b0HxcOsm5EjKTcxNkFAujaDKivlIlJdwYFVlSBzTrT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=NCZw3KAh; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="NCZw3KAh"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775037614; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=cI1dNycY7yichGWRiRFg+/poiw8N+OXrXdXyJB1KWcE=;
	b=NCZw3KAhwDbLDxaKOu07IbftzxK8Oy2CJhUeDRzgWTee9xYCpiViz0b0Mh90eKYWzW6QsGXcRXyO9LsGBfvBDrc9v7G9o5K49aGlzHxdLsmgbPyw58VDYXWjCaHhhWWHPL7R4bHSGT5PMYx7Wp4Q6Mk5+ILL9PAzlrS/jzipb1c=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X0AdNe6_1775037611;
Received: from 30.221.145.27(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X0AdNe6_1775037611 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 01 Apr 2026 18:00:12 +0800
Message-ID: <342f0be0-6d4c-44aa-aadb-86741b9bfadc@linux.alibaba.com>
Date: Wed, 1 Apr 2026 18:00:11 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: handle invalid dinode in ocfs2_group_extend
To: ZhengYuan Huang <gality369@gmail.com>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <20260401092303.3709187-1-gality369@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260401092303.3709187-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/1/26 5:23 PM, ZhengYuan Huang wrote:
> [BUG]
> kernel BUG at fs/ocfs2/resize.c:308!
> Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
> RIP: 0010:ocfs2_group_extend+0x10aa/0x1ae0 fs/ocfs2/resize.c:308
> Code: 8b8520ff ffff83f8 860f8580 030000e8 5cc3c1fe
> Call Trace:
>  ...
>  ocfs2_ioctl+0x175/0x6e0 fs/ocfs2/ioctl.c:869
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl fs/ioctl.c:583 [inline]
>  __x64_sys_ioctl+0x197/0x1e0 fs/ioctl.c:583
>  x64_sys_call+0x1144/0x26a0 arch/x86/include/generated/asm/syscalls_64.h:17
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x93/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>  ...
> 
> [CAUSE]
> ocfs2_group_extend() assumes that the global bitmap inode block
> returned from ocfs2_inode_lock() has already been validated and
> BUG_ONs when the signature is not a dinode. That assumption is too
> strong for crafted filesystems because the JBD2-managed buffer path
> can bypass structural validation and return an invalid dinode to the
> resize ioctl.
> 
> [FIX]
> Validate the dinode explicitly in ocfs2_group_extend(). If the global
> bitmap buffer does not contain a valid dinode, report filesystem
> corruption with ocfs2_error() and fail the resize operation instead of
> crashing the kernel.
> 
> Fixes: 10995aa2451a ("ocfs2: Morph the haphazard OCFS2_IS_VALID_DINODE() checks.")
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/resize.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
> index b0733c08ed13..ed7ed15ad9a7 100644
> --- a/fs/ocfs2/resize.c
> +++ b/fs/ocfs2/resize.c
> @@ -303,9 +303,13 @@ int ocfs2_group_extend(struct inode * inode, int new_clusters)
>  
>  	fe = (struct ocfs2_dinode *)main_bm_bh->b_data;
>  
> -	/* main_bm_bh is validated by inode read inside ocfs2_inode_lock(),
> -	 * so any corruption is a code bug. */
> -	BUG_ON(!OCFS2_IS_VALID_DINODE(fe));
> +	/* JBD-managed buffers can bypass validation, so treat this as corruption. */
> +	if (!OCFS2_IS_VALID_DINODE(fe)) {
> +		ret = ocfs2_error(main_bm_inode->i_sb,
> +				  "Invalid dinode #%llu\n",
> +				  (unsigned long long)OCFS2_I(main_bm_inode)->ip_blkno);
> +		goto out_unlock;
> +	}
>  
>  	if (le16_to_cpu(fe->id2.i_chain.cl_cpg) !=
>  		ocfs2_group_bitmap_size(osb->sb, 0,

