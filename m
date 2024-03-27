Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE44956B65
	for <ocfs2-devel@lists.linux.dev>; Wed, 27 Mar 2024 11:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711538260; cv=none; b=l/V/MlAiKHN2+s6y9tjt46yd68zSsllMy/CK8q83FurR/UMS/Qk9YBPmbt5Cqw0o0eFADOksWhQxVXFWq/ndvSzUoFMLkQMtHdc09JMdRxGDjBncb1tMguh83Thtk8+Ny49/GTgTpG8Frek1ofcXIJi2SADzf2vxafMBZkjAAek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711538260; c=relaxed/simple;
	bh=VfM5fGTN95J43eODpEU5+KN+ISxXpqKPXJXQoyH9x6g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fr7bi1Sut6pXZ5WRLadz2GcRshXUh9dm0symz3JCXX+SIqLHzyCiVw2a5T2o6Uc5Xj6H6JV8y9R6BBMG9U6SkT0ohq7EC7uFd1A6V4+4obs6NhAZM82EHwbOOCJDcYSRSxe3vkyZ7FLAoUGzLPRRnD1Ndm48y2esKy9JfvKrkaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=BjTjSaHr; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="BjTjSaHr"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1711538256; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=NvNPU0uG9J4bVZtKF05Z6OObPmh8Y65A1eV6eZxXosE=;
	b=BjTjSaHrCrHXWHkt1T7g36wgpJdnJOltHJaeeb60tYkmpLlE00c+e6D6a3FITBjq8ScDuCyTSVJtGtVxfXJ0f5guPw6cJZTUz96qHRU4/tFcqPbM5U/EOZf8vkZJ5e8KgnQ46b2V+bssBFOU72oHYec6rTmp1J/Lin7qYSLy0f0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0W3OZmYP_1711538255;
Received: from 30.221.128.129(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W3OZmYP_1711538255)
          by smtp.aliyun-inc.com;
          Wed, 27 Mar 2024 19:17:36 +0800
Message-ID: <d9ab276e-5d68-4759-8d15-3a94bd9ff4ab@linux.alibaba.com>
Date: Wed, 27 Mar 2024 19:17:35 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] ocfs2: speed up chain-list searching
Content-Language: en-US
To: Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev, ailiop@suse.com
References: <20240327082146.6258-1-heming.zhao@suse.com>
 <20240327082146.6258-4-heming.zhao@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240327082146.6258-4-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/27/24 4:21 PM, Heming Zhao wrote:
> ocfs2_claim_suballoc_bits():
> - Add short-circuit code to speed up searching
> 
> ocfs2_local_alloc_new_window():
> - remove 1 sparse warning
> ```
> fs/ocfs2/localalloc.c:1224:41: warning: incorrect type in argument 1 (different base types)
> fs/ocfs2/localalloc.c:1224:41:    expected unsigned long long val1
> fs/ocfs2/localalloc.c:1224:41:    got restricted __le32 [usertype] la_bm_off
> ```

Could you please split the sparse warning into a separate patch?
For 'la_bm_off', it seems that other place may also has similar warning,
e.g. ocfs2_load_local_alloc().

Joseph

> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/localalloc.c | 2 +-
>  fs/ocfs2/suballoc.c   | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index 2391b96b8a3b..2758ae9164f3 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -1221,7 +1221,7 @@ static int ocfs2_local_alloc_new_window(struct ocfs2_super *osb,
>  			     OCFS2_LOCAL_ALLOC(alloc)->la_bitmap);
>  
>  	trace_ocfs2_local_alloc_new_window_result(
> -		OCFS2_LOCAL_ALLOC(alloc)->la_bm_off,
> +		le32_to_cpu(OCFS2_LOCAL_ALLOC(alloc)->la_bm_off),
>  		le32_to_cpu(alloc->id1.bitmap1.i_total));
>  
>  bail:
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 4163554b0383..ebfa17dccf97 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -2008,7 +2008,7 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
>  	for (i = 0; i < le16_to_cpu(cl->cl_next_free_rec); i ++) {
>  		if (i == victim)
>  			continue;
> -		if (!cl->cl_recs[i].c_free)
> +		if (le32_to_cpu(cl->cl_recs[i].c_free) < bits_wanted)
>  			continue;
>  
>  		ac->ac_chain = i;
