Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A36E39B955
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Apr 2026 11:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775820008; cv=none; b=A+ioO/Zfa55mbwCfpOWRG6fHD61+JCfiwM5LObl4+lswIYnkOQbcrUDLWSXH0QSp2PZgxUT9znydCDQRJgWdQUlWf/7L8ioEMFMTAjhRPldG7Eu0me4mOm/iV8mE+GPcqYoEMjhZPHVL8K+a5XrRsCoJBmGFLlWaZ8PyC6yfxL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775820008; c=relaxed/simple;
	bh=zbReux8eWS2QUjpvqqXGDw1JkXQbyMVJ+JFIRL3Qe8A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eHhmblw9u1q1Z47OB1iErqmV3P0gGS8cdnrbCMQPq9oChvG46vds+1k7q8c9P+GD0wy6DeHS+VaWaGzAAcLbgYNJwOSB/FwT4emNymwgNa93+4Kz2aGaZu32mY6+hJwyQEm/qJT3v8i3quTCXhUlcBzsDDJhdyiWkFXOERvSfGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=f40/0Juu; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="f40/0Juu"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775820003; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=e0jjetCAJ+07gZdA13Xj13l0kcxFTteRog9u5ixsQQA=;
	b=f40/0JuuGRk5v90alSjAQzoRn55RXhh8hkideeBx6NP6eS8L7fSbA/QOuvohLYtFyLW0d66csgg8DegRPB7v0ax4o1hRHpKj0eN2BKMgKOtJ7SMjR/hH0hqCnwelKMi4gWZS7hlP1i6c7zPr9V1vr24akCAO8euIkdIHttqrJs4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X0l9.Ef_1775820001;
Received: from 30.221.145.28(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X0l9.Ef_1775820001 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Apr 2026 19:20:02 +0800
Message-ID: <8d9a93d4-6a38-4b34-bfbf-311a05fcee69@linux.alibaba.com>
Date: Fri, 10 Apr 2026 19:20:01 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix listxattr handling when the buffer is full
To: ZhengYuan Huang <gality369@gmail.com>, akpm <akpm@linux-foundation.org>,
 Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <20260410040339.3837162-1-gality369@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260410040339.3837162-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/10/26 12:03 PM, ZhengYuan Huang wrote:
> [BUG]
> If an OCFS2 inode has both inline and block-based xattrs, listxattr()
> can return a size larger than the caller's buffer when the inline names
> consume that buffer exactly.
> 
> kernel BUG at mm/usercopy.c:102!
> Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
> RIP: 0010:usercopy_abort+0xb7/0xd0 mm/usercopy.c:102
> Call Trace:
>  __check_heap_object+0xe3/0x120 mm/slub.c:8243
>  check_heap_object mm/usercopy.c:196 [inline]
>  __check_object_size mm/usercopy.c:250 [inline]
>  __check_object_size+0x5c5/0x780 mm/usercopy.c:215
>  check_object_size include/linux/ucopysize.h:22 [inline]
>  check_copy_size include/linux/ucopysize.h:59 [inline]
>  copy_to_user include/linux/uaccess.h:219 [inline]
>  listxattr+0xb0/0x170 fs/xattr.c:926
>  filename_listxattr fs/xattr.c:958 [inline]
>  path_listxattrat+0x137/0x320 fs/xattr.c:988
>  __do_sys_listxattr fs/xattr.c:1001 [inline]
>  __se_sys_listxattr fs/xattr.c:998 [inline]
>  __x64_sys_listxattr+0x7f/0xd0 fs/xattr.c:998
>  ...
> 
> [CAUSE]
> Commit 936b8834366e ("ocfs2: Refactor xattr list and remove
> ocfs2_xattr_handler().") replaced the old per-handler list accounting
> with ocfs2_xattr_list_entry(), but it kept using size == 0 to detect
> probe mode.
> 
> That assumption stops being true once ocfs2_listxattr() finishes the
> inline-xattr pass. If the inline names fill the caller buffer exactly,
> the block-xattr pass runs with a non-NULL buffer and a remaining size of
> zero. ocfs2_xattr_list_entry() then skips the bounds check, keeps
> counting block names, and returns a positive size larger than the
> supplied buffer.
> 
> [FIX]
> Detect probe mode by testing whether the destination buffer pointer is
> NULL instead of whether the remaining size is zero.
> 
> That restores the pre-refactor behavior and matches the OCFS2 getxattr
> helpers. Once the remaining buffer reaches zero while more names are
> left, the block-xattr pass now returns -ERANGE instead of reporting a
> size larger than the allocated list buffer.
> 
> Fixes: 936b8834366e ("ocfs2: Refactor xattr list and remove ocfs2_xattr_handler().")
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/xattr.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -906,8 +906,8 @@ static int ocfs2_xattr_list_entry(struct super_block *sb,
>  	prefix_len = strlen(prefix);
>  	total_len = prefix_len + name_len + 1;
>  	*result += total_len;
> 
> -	/* we are just looking for how big our buffer needs to be */
> -	if (!size)
> +	/* No buffer means we are only looking for the required size. */
> +	if (!buffer)
>  		return 0;
>  
>  	if (*result > size)

