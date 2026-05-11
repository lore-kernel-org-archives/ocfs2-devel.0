Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0912BE02A
	for <ocfs2-devel@lists.linux.dev>; Mon, 11 May 2026 06:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778481013; cv=none; b=UVnRz8dItC5PaiO2pXm1Q/WKmUBE5TeMAV3FP2Ka5bCJ7QN5uFPM1ieCIQXdwvAeby8dm20wdmrf/IXyyhwHP5rHvgGFFzYz9MPzlcPGZ6uxscOO4tr85RcuN1f/vxK+cVmK91JcCwjugLYRcg5qxpOD9hIBA6eq2pzxAn9bVfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778481013; c=relaxed/simple;
	bh=RQfspkujNbsrNp4kmxdzXYeln0u5Scv8wzIgV9MFlUQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CZL1SI/Sr9M/kW8o86ZkI97Ji5ScsHzUcghNKRMbd+9C9EyPuth6CNDILsMEFO3KphE+escuAJ5UKXA0Gy6h8lIEpVIS8y1RWq9MEmQJ9kBd9p1kfNOcnQj05ps9/QeDrrvXkHoDRwADN6DopqzQ/ewnwLIlL5DmUaJ6lgrLGng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=X3/zlEGY; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="X3/zlEGY"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778481007; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=NnP3IIBIJeiWGTdtsTfmcFDWpZNPBU+hGUJqL1qXHq4=;
	b=X3/zlEGYDlTIQYhPGNK1uN90m86Dl0Qou5mVKpcYe1E9cCYjSJEVw516gPYZuUcCATlutldrnh1yAJ98ceSnQVxgGObPEIP+l5Tc9++KCzNvJn7lGNCTAD1HewqzRtDz4Ua5vkKgXXvRV4zdx4izBHEJ0h0hEcFPUOEAd+1RuOs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R591e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X2fE5H5_1778481005;
Received: from 30.221.128.206(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X2fE5H5_1778481005 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 11 May 2026 14:30:05 +0800
Message-ID: <79f645c2-b97f-4c0f-8ba7-8e0ef541d455@linux.alibaba.com>
Date: Mon, 11 May 2026 14:30:04 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] ocfs2: validate inline xattr header before checking
 outside values
To: ZhengYuan Huang <gality369@gmail.com>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <20260508085914.61647-1-gality369@gmail.com>
 <20260508085914.61647-3-gality369@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260508085914.61647-3-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/8/26 4:59 PM, ZhengYuan Huang wrote:
> [BUG]
> A corrupt inline xattr header can make
> ocfs2_has_inline_xattr_value_outside() walk xh_count from an unchecked
> header while refcount-tree teardown decides whether inline xattrs still
> point outside the inode body.
> 
> [CAUSE]
> ocfs2_has_inline_xattr_value_outside() still computed the inline header
> directly from di->i_xattr_inline_size and immediately iterated xh_count.
> That is the same unchecked metadata boundary as the ibody lookup bug.
> 
> [FIX]
> Reuse the shared inline-header helper before iterating xh_count. Because
> this helper returns a boolean-style answer to its caller, treat a corrupt
> header conservatively as "has outside values" instead of walking it.
> 
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/xattr.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 3a5a17cdcf7e..05f6f0a886cf 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -989,11 +989,12 @@ int ocfs2_has_inline_xattr_value_outside(struct inode *inode,
>  					 struct ocfs2_dinode *di)
>  {
>  	struct ocfs2_xattr_header *xh;
> +	int ret;
>  	int i;
>  
> -	xh = (struct ocfs2_xattr_header *)
> -		 ((void *)di + inode->i_sb->s_blocksize -
> -		 le16_to_cpu(di->i_xattr_inline_size));
> +	ret = ocfs2_xattr_ibody_lookup_header(inode, di, &xh);
> +	if (ret)
> +		return 1;
>  
>  	for (i = 0; i < le16_to_cpu(xh->xh_count); i++)
>  		if (!ocfs2_xattr_is_local(&xh->xh_entries[i]))

