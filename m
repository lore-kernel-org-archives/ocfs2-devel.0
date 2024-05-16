Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A7310E3
	for <ocfs2-devel@lists.linux.dev>; Thu, 16 May 2024 01:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715823725; cv=none; b=jy1G6C1ozLaQizdZmYi/7aftIJQ+rDCo5wuE9wC1UwOOU19Qa3tVIb/wa4yr02FBTq2ItSL51Gbzay2x861REMNB8E5ULdv9ur7d8Zh9x5WBxYLBN1Pfo5o8n/pfRRuoRDd0oLZJ3xhBIcGsv6gp773X5Wz0wuoA7PKh0ZzR878=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715823725; c=relaxed/simple;
	bh=sphSLpGX7TeKcLF0fd/4ZGq0GRD9kGI/Sv5KgFRyTKA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vm2WcPvcVJJsqrYh4EEn8CsFIWimDPiPZ7rYqFgw2PWA/SsZ8RisFRjwp6JsaE5LZ84cCa1yPwG+BX5a4Zoe8o5rAaWvqsw/minYdmJLMSlyGS35rYVLoPUFT33vtf1/pDSixhtzDfAMohs3dJPINA5gCjERazj29JTyCzxdTSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=A/uOHvn2; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="A/uOHvn2"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1715823720; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=6l2j1hfJLj/NOswmfviaKoySFrdt0h7TrfH/eLX7gz8=;
	b=A/uOHvn2dexNJX04dZ+KHLaxirLwb/7Si+3TrR1fwnWQfM/OCuBkb8Iyjm6OezPcMBsZKno0ylaDf3/OSBILyasGCskVvLDmT1zMKphU4WY//B/M17cPQB8bQMnR6EYN7B95heRML1x74IbgLxRN+nOuyAJMD1wT+m//3pDkENA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037067112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0W6ZPauu_1715823718;
Received: from 30.221.128.154(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W6ZPauu_1715823718)
          by smtp.aliyun-inc.com;
          Thu, 16 May 2024 09:41:59 +0800
Message-ID: <03f031e5-ed9c-4794-8f08-8a4007c1d704@linux.alibaba.com>
Date: Thu, 16 May 2024 09:41:58 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ocfs2: strict bound check before memcmp in
 ocfs2_xattr_find_entry()
To: Ferry Meng <mengferry@linux.alibaba.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
References: <20240515132934.69511-1-mengferry@linux.alibaba.com>
 <20240515132934.69511-3-mengferry@linux.alibaba.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240515132934.69511-3-mengferry@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/15/24 9:29 PM, Ferry Meng wrote:
> xattr in ocfs2 maybe not INLINE, but saved with additional space
> requested. It's better to check if the memory is out of bound before
> memcmp, although this possibility mainly comes from custom poisonous
> images.

Specifically, this only addresses the case non-indexed xattr. 

> 
> Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>
> ---
>  fs/ocfs2/xattr.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 37be4a286faf..4ceb0cb4cb71 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -1083,10 +1083,15 @@ static int ocfs2_xattr_find_entry(struct inode *inode, void *end,
>  		cmp = name_index - ocfs2_xattr_get_type(entry);

Or define a local variable 'offset' for le16_to_cpu(entry->xe_name_offset).

Thanks,
Joseph

>  		if (!cmp)
>  			cmp = name_len - entry->xe_name_len;
> -		if (!cmp)
> +		if (!cmp) {
> +			if ((xs->base + le16_to_cpu(entry->xe_name_offset) + name_len) > end) {
> +				ocfs2_error(inode->i_sb, "corrupted xattr entries");
> +				return -EFSCORRUPTED;
> +			}
>  			cmp = memcmp(name, (xs->base +
>  				     le16_to_cpu(entry->xe_name_offset)),
>  				     name_len);
> +		}
>  		if (cmp == 0)
>  			break;
>  		entry += 1;
