Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3622D2397
	for <ocfs2-devel@lists.linux.dev>; Mon, 11 May 2026 06:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778480780; cv=none; b=jGBUXTy+m/UeYJN4btbQzWvnZZYHw8s/MLTZtLildN1kICnjjzypr8tJs8rqs1JKx68UHqgOOtAlXPqP48ns33yt0TZdOum7K7PBYc27UlgWPDHSLam3VnZpJXofzVJyrfN19nGfg5bSqPPRoGJqYai5NHt5neWtiqNiW1+fLlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778480780; c=relaxed/simple;
	bh=8dOcgGL/cHnE31qLvoMvHLmWVCMb2fZcJLPw5qS4QIE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ucpISNamIH20xfGXjmFTNVI2Irt3QCDw1dwERctxIwY/E/13h04OD8le/Zsba2GjqylaD+nyf0tjZJFpeKGxteRIIslVtDB9bBGdzqaqeg3zc6XWo7q6/G6zRDefUf9q7gesWFvpzBUcnXk7KU+9kcxW493GUt93Yl0XnB5ZctE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ADTU/x2q; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ADTU/x2q"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778480771; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=kMcRzqueSAvp/+1oEdvXaUzTOSWWakrhZfAhvPb1iNM=;
	b=ADTU/x2qkuxTnoKX6oxZVumdTa5aF5sgBTRq65+/AtmPWBDT99SO1yfFQ03fdAmNUQQmz9oKud/PsCTXuNrZQw/I21OjeBH12WpQ6cBaN/88GZj7cf3Dpa7gAKXA1Sw9cTb/qDw6aXL1L3mycQFOihKwlAveLkEYKI9ULIqU6Sc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X2ff.P6_1778480769;
Received: from 30.221.128.206(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X2ff.P6_1778480769 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 11 May 2026 14:26:10 +0800
Message-ID: <5d1b0c85-fa4c-400c-b432-95260b311673@linux.alibaba.com>
Date: Mon, 11 May 2026 14:26:09 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] ocfs2: validate inline xattr header before ibody
 lookups
To: ZhengYuan Huang <gality369@gmail.com>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <20260508085914.61647-1-gality369@gmail.com>
 <20260508085914.61647-2-gality369@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260508085914.61647-2-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/8/26 4:59 PM, ZhengYuan Huang wrote:
> [BUG]
> mknodat() can read past the end of a dinode block when ACL inheritance
> walks a corrupted inode-body xattr header. Another report shows the same
> unchecked lookup later faulting in the VFS open path after create
> returns a garbage status.
> 
> KASAN: use-after-free in
> ocfs2_xattr_find_entry+0x37b/0x3a0 fs/ocfs2/xattr.c:1078
> Read of size 2 at addr ffff88801c520300 by task syz.0.10/360
> 
> Trace:
>  ...
>  ocfs2_xattr_find_entry+0x37b/0x3a0 fs/ocfs2/xattr.c:1078
>  ocfs2_xattr_ibody_get fs/ocfs2/xattr.c:1178 [inline]
>  ocfs2_xattr_get_nolock+0x2ee/0x1110 fs/ocfs2/xattr.c:1309
>  ocfs2_calc_xattr_init+0x716/0xac0 fs/ocfs2/xattr.c:628
>  ocfs2_mknod+0x935/0x2400 fs/ocfs2/namei.c:333
>  ocfs2_create+0x158/0x390 fs/ocfs2/namei.c:676
>  vfs_create fs/namei.c:3493 [inline]
>  vfs_create+0x445/0x6f0 fs/namei.c:3477
>  do_mknodat+0x2d8/0x5e0 fs/namei.c:4372
>  __do_sys_mknodat fs/namei.c:4400 [inline]
>  __se_sys_mknodat fs/namei.c:4397 [inline]
>  __x64_sys_mknodat+0xb6/0xf0 fs/namei.c:4397
>  ...
> 
> Another report:
>  BUG: unable to handle page fault for address: fffffbfff3e40ec0
>  RIP: 0010:__d_entry_type include/linux/dcache.h:414 [inline]
>  RIP: 0010:d_can_lookup include/linux/dcache.h:429 [inline]
>  RIP: 0010:d_is_dir include/linux/dcache.h:439 [inline]
>  RIP: 0010:path_openat+0xe2f/0x2ce0 fs/namei.c:4134
> 
> Trace:
>  ...
>  do_filp_open+0x1f6/0x430 fs/namei.c:4161
>  do_sys_openat2+0x117/0x1c0 fs/open.c:1437
>  __x64_sys_openat+0x15b/0x220 fs/open.c:1463
>  ...
> 
> [CAUSE]
> ocfs2_xattr_ibody_list() already validates the inline xattr size and
> entry count, but ocfs2_xattr_ibody_get() and ocfs2_xattr_ibody_find()
> still derive the inline header directly from di->i_xattr_inline_size and
> then trust xh_count. A corrupted inline size or entry count can therefore
> move the computed header outside the dinode block before get/find start
> walking it. That can either make ocfs2_xattr_find_entry() dereference
> xs->header->xh_count outside the block or make ocfs2_xattr_get_nolock()
> bubble a garbage status back through ocfs2_calc_xattr_init() into the
> create/open path.
> 
> [FIX]
> Factor the existing ibody header geometry checks into a shared helper.
> Use it in ocfs2_xattr_ibody_get() and ocfs2_xattr_ibody_find(), and have
> ocfs2_xattr_ibody_list() reuse the same helper instead of open-coding
> the validation. Reject corrupt ibody metadata with -EFSCORRUPTED before
> the lookup path can walk bogus xattr geometry or return a garbage status.
> 
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/xattr.c | 82 +++++++++++++++++++++++++++---------------------
>  1 file changed, 47 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 86cfd4c2adf9..3a5a17cdcf7e 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -950,6 +950,41 @@ static int ocfs2_xattr_list_entries(struct inode *inode,
>  	return result;
>  }
>  
> +static int ocfs2_xattr_ibody_lookup_header(struct inode *inode,
> +					   struct ocfs2_dinode *di,
> +					   struct ocfs2_xattr_header **header)
> +{
> +	u16 xattr_count;
> +	size_t max_entries;
> +	u16 inline_size = le16_to_cpu(di->i_xattr_inline_size);
> +
> +	if (inline_size > inode->i_sb->s_blocksize ||
> +	    inline_size < sizeof(struct ocfs2_xattr_header)) {
> +		ocfs2_error(inode->i_sb,
> +			    "Invalid xattr inline size %u in inode %llu\n",
> +			    inline_size,
> +			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	*header = (struct ocfs2_xattr_header *)
> +		((void *)di + inode->i_sb->s_blocksize - inline_size);
> +
> +	xattr_count = le16_to_cpu((*header)->xh_count);
> +	max_entries = (inline_size - sizeof(struct ocfs2_xattr_header)) /
> +		      sizeof(struct ocfs2_xattr_entry);
> +
> +	if (xattr_count > max_entries) {
> +		ocfs2_error(inode->i_sb,
> +			    "xattr entry count %u exceeds maximum %zu in inode %llu\n",
> +			    xattr_count, max_entries,
> +			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	return 0;
> +}
> +
>  int ocfs2_has_inline_xattr_value_outside(struct inode *inode,
>  					 struct ocfs2_dinode *di)
>  {
> @@ -975,39 +1010,13 @@ static int ocfs2_xattr_ibody_list(struct inode *inode,
>  	struct ocfs2_xattr_header *header = NULL;
>  	struct ocfs2_inode_info *oi = OCFS2_I(inode);
>  	int ret = 0;
> -	u16 xattr_count;
> -	size_t max_entries;
> -	u16 inline_size;
>  
>  	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL))
>  		return ret;
>  
> -	inline_size = le16_to_cpu(di->i_xattr_inline_size);
> -
> -	/* Validate inline size is reasonable */
> -	if (inline_size > inode->i_sb->s_blocksize ||
> -	    inline_size < sizeof(struct ocfs2_xattr_header)) {
> -		ocfs2_error(inode->i_sb,
> -			    "Invalid xattr inline size %u in inode %llu\n",
> -			    inline_size,
> -			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
> -		return -EFSCORRUPTED;
> -	}
> -
> -	header = (struct ocfs2_xattr_header *)
> -		 ((void *)di + inode->i_sb->s_blocksize - inline_size);
> -
> -	xattr_count = le16_to_cpu(header->xh_count);
> -	max_entries = (inline_size - sizeof(struct ocfs2_xattr_header)) /
> -		       sizeof(struct ocfs2_xattr_entry);
> -
> -	if (xattr_count > max_entries) {
> -		ocfs2_error(inode->i_sb,
> -			    "xattr entry count %u exceeds maximum %zu in inode %llu\n",
> -			    xattr_count, max_entries,
> -			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
> -		return -EFSCORRUPTED;
> -	}
> +	ret = ocfs2_xattr_ibody_lookup_header(inode, di, &header);
> +	if (ret)
> +		return ret;
>  
>  	ret = ocfs2_xattr_list_entries(inode, header, buffer, buffer_size);
>  
> @@ -1200,8 +1209,9 @@ static int ocfs2_xattr_ibody_get(struct inode *inode,
>  		return -ENODATA;
>  
>  	xs->end = (void *)di + inode->i_sb->s_blocksize;
> -	xs->header = (struct ocfs2_xattr_header *)
> -			(xs->end - le16_to_cpu(di->i_xattr_inline_size));
> +	ret = ocfs2_xattr_ibody_lookup_header(inode, di, &xs->header);
> +	if (ret)
> +		return ret;
>  	xs->base = (void *)xs->header;
>  	xs->here = xs->header->xh_entries;
>  
> @@ -2726,12 +2736,14 @@ static int ocfs2_xattr_ibody_find(struct inode *inode,
>  
>  	xs->xattr_bh = xs->inode_bh;
>  	xs->end = (void *)di + inode->i_sb->s_blocksize;
> -	if (oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL)
> -		xs->header = (struct ocfs2_xattr_header *)
> -			(xs->end - le16_to_cpu(di->i_xattr_inline_size));
> -	else
> +	if (oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL) {
> +		ret = ocfs2_xattr_ibody_lookup_header(inode, di, &xs->header);
> +		if (ret)
> +			return ret;
> +	} else {
>  		xs->header = (struct ocfs2_xattr_header *)
>  			(xs->end - OCFS2_SB(inode->i_sb)->s_xattr_inline_size);
> +	}
>  	xs->base = (void *)xs->header;
>  	xs->here = xs->header->xh_entries;
>  

