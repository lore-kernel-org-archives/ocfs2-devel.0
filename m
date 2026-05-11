Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C914F9E8
	for <ocfs2-devel@lists.linux.dev>; Mon, 11 May 2026 06:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778481158; cv=none; b=BKAC2YxR0NLHU0yWtaAdG8ZsRv/nYYPgKrFB5yeFV2Z/Dp1uL1p4G+liYIYj32zQkI1XBeEtiIZbvZAQDyNgtesG7JAU5gbBUlSSrgZ2SWb2kCRBykzNM9kBA6BgoT0mmc6u1/7R8iBjYOp3Oth/MoCXlpvtBh03vRNCwDnJCqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778481158; c=relaxed/simple;
	bh=KRgdJrzk8qS4NCyc8Mkpo5Y8zujv26uIrg2BUMtGcSA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u2GHfy7DAbKLSVy+eT4KDrz+MydN+H4ZhjPgzlnX6hanht7VxXZoHCHGe9s06iYww6bc/BS2qZEpL6LUBPqldWDSSVNODuj8fEve7F0Ne48b23RfFlvsZBdrXTh75Ip86V8oyh0FR+N2jirNfifPgZg9WcwKWg/IhA8yd5e2JJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=cKe5Lnmo; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="cKe5Lnmo"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778481154; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=wmCNvmmX03ZESk4ONl6IWOFpcJa1dWLmRIzRVx89Xwc=;
	b=cKe5Lnmo8Ha3+uJTzuYeuOpmp3k8OscnllXwAfKlq6AYsvcXLckwJXXCP0lu1on9TzndAKF0HeGnDAy8M/oYQJFU1PeUX8cw53qA2V4TaqWndA1/QBEDKOOUg+cn679139btzgqSgOMS0+svcWm6MOy07BmHwUFGuNcKZ4s8K0w=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R821e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X2ew.0n_1778481152;
Received: from 30.221.128.206(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X2ew.0n_1778481152 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 11 May 2026 14:32:33 +0800
Message-ID: <84335cce-00e6-466e-a2a3-960afbde75b7@linux.alibaba.com>
Date: Mon, 11 May 2026 14:32:32 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] ocfs2: validate inline xattr header before ibody
 remove
To: ZhengYuan Huang <gality369@gmail.com>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <20260508085914.61647-1-gality369@gmail.com>
 <20260508085914.61647-4-gality369@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260508085914.61647-4-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/8/26 4:59 PM, ZhengYuan Huang wrote:
> [BUG]
> A corrupt inline xattr header can make ocfs2_xattr_ibody_remove() pass an
> unchecked header into ocfs2_remove_value_outside() during inode xattr
> teardown.
> 
> [CAUSE]
> ocfs2_xattr_ibody_remove() still rebuilt the ibody xattr header directly
> from di->i_xattr_inline_size and then handed it to code that iterates
> xh_count and entry geometry.
> 
> [FIX]
> Validate the inline xattr header with the shared helper before handing it
> to the outside-value removal path, and propagate -EFSCORRUPTED on bad
> metadata instead of traversing the unchecked header.
> 
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/xattr.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 05f6f0a886cf..bbb25a01b097 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -2476,9 +2476,9 @@ static int ocfs2_xattr_ibody_remove(struct inode *inode,
>  		.vb_access = ocfs2_journal_access_di,
>  	};
>  
> -	header = (struct ocfs2_xattr_header *)
> -		 ((void *)di + inode->i_sb->s_blocksize -
> -		 le16_to_cpu(di->i_xattr_inline_size));
> +	ret = ocfs2_xattr_ibody_lookup_header(inode, di, &header);
> +	if (ret)
> +		return ret;
>  
>  	ret = ocfs2_remove_value_outside(inode, &vb, header,
>  					 ref_ci, ref_root_bh);

