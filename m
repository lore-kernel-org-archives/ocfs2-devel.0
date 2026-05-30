Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0096B3C1977
	for <ocfs2-devel@lists.linux.dev>; Sat, 30 May 2026 13:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780146792; cv=none; b=toA4FlXEXe54QR9ZVa8l2Xq+4TJj0sVro6AXfgYwr6qFsA+OOxImZoKGgWUvqROrqDIyyX16wKcSx7ErpnYdGHCWOj4yCmYIMfOUs1f7G7iFHXkOhnKT2o6/k7KNSjlmh+CwfqCEhXh4dBBU4Ae56hDQ25AE095wSRHY/YRedBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780146792; c=relaxed/simple;
	bh=AIK7xEmSGqqsESN5wDb9BJNsyx7oaKf+g4VQlNSWK2s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DsBCFsKzmIvI75lASQb1cRM+AecbGTkcmfQjh6m/rtKA00xFiW6Dff9O6h3lUeB84bezVVrMyyq9OxFjjxJQYJpm5XaHr47ZGtGQezr9EA/4mztxZKkbFSsgTY5cFdUJ+m3753AYBQM6MKsLaMgXCgmcY70aEqDFaJoMEevOfjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Nc2fRodG; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Nc2fRodG"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780146780; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=DgCCYSrTKdcpRRHmuBMlUSSYFww9WmOzkE1N8a+s83E=;
	b=Nc2fRodG3Q5+FfRSAAIoMHYUnNwbfC2cyiO6L6PUIscZZA6kmuuV7NLFcvclgU5I1jJVyxUAD3AmBQVaD3tsefiV52p5BS6bduPd24ekhXxHDEk8r6mMynscEA+ABySsO8A2bmimvzHF0pLLuwIaxKI7AtGAAdVypY7YZJbsMdU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R531e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X3rijx0_1780146778;
Received: from 30.134.110.188(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X3rijx0_1780146778 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 30 May 2026 21:12:58 +0800
Message-ID: <6a966a6a-1a9a-489d-97e1-8bb7c3f8414b@linux.alibaba.com>
Date: Sat, 30 May 2026 21:12:58 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: reject FITRIM ranges shorter than a cluster
To: Zhang Cen <rollkingzzc@gmail.com>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, zerocling0077@gmail.com,
 2045gemini@gmail.com, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
References: <20260528151247.361854-1-rollkingzzc@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260528151247.361854-1-rollkingzzc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/28/26 11:12 PM, Zhang Cen wrote:
> ocfs2_trim_mainbm() trims the global bitmap in cluster units, but its
> too-short range validation only checks sb->s_blocksize.
> 
> On filesystems with a cluster size larger than the block size, a FITRIM
> range that is at least one block but shorter than one cluster is
> accepted and shifted down to len == 0. The later start + len - 1 and
> len -= ... arithmetic then underflows and can drive trimming past the
> requested range.
> 
> Reject ranges shorter than s_clustersize instead. That preserves the
> existing -EINVAL behavior for requests that cannot discard even one
> allocation unit and keeps zero-cluster trims out of the group walk.
> 
> Fixes: aa89762c5480 ("ocfs2: return EINVAL if the given range to discard is less than block size")
> Assisted-by: Codex:gpt-5.5
> Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 6e5fd3f12a84..be09e766ac1f 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -7576,7 +7576,7 @@ int ocfs2_trim_mainbm(struct super_block *sb, struct fstrim_range *range)
>  	len = range->len >> osb->s_clustersize_bits;
>  	minlen = range->minlen >> osb->s_clustersize_bits;
>  
> -	if (minlen >= osb->bitmap_cpg || range->len < sb->s_blocksize)
> +	if (minlen >= osb->bitmap_cpg || range->len < osb->s_clustersize)
>  		return -EINVAL;
>  
>  	trace_ocfs2_trim_mainbm(start, len, minlen);

