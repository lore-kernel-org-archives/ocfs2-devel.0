Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB2F1DD0C7
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Dec 2024 11:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733397008; cv=none; b=XhenmZ1gYkWoQ2Y5os69H2pjoNDnuHDX4eCubJjzuXN5rcTQxBrMSvpdeEPPrwSzupsmmz7qdB/ZbmnZkVJk1swTGwwSTFydw17k32gXPl84VN16IJYl80Y9KLVhY8zA2yYAc8zoJdQlXXTIMCvmPetHfewSc+7lNHlSr9kbUpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733397008; c=relaxed/simple;
	bh=CBk15y+1bosoiqQS4z+r5vbsAgsLzPYuG8w/fSH88vo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SOpSdJzkn0FlqtwzS0FITbgTXlHRrNuRP720udOJf/7Yax49vwvgOzn6oPropMd7pCZZkL0UkbUrjpNAZhrkxPJo+MrtDgxlpQTVbpNnHBC7pBptaAaT2QLdeXBN0Pob2S4vUNRYepHQUPj4fmq6R3HcAxeI/o/fVSJvzQKV9Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=JM7uDiJn; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="JM7uDiJn"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1733397002; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=O4Cy8bh2P+MEfj7/h17yeYf2vJikGyZup4YjTbGEAac=;
	b=JM7uDiJnGiyWjG1aASyLJjL14hc/YOHh1mL5YnvZQoHfh/+E7n8/OzbInUyeL6F5pQYYsXwvIC8PmreKSnYtUfUinTTgS2GpHh4neICr/XaYLnELbiNjhhwXDwDpYMCfT3hjltgQqkOs0QYWhdYpXFYAvEDG0cmdYMvWXuuEhEA=
Received: from 30.221.131.123(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WKt170B_1733397001 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Dec 2024 19:10:02 +0800
Message-ID: <2a72a270-e551-4529-b900-c955cd378ef8@linux.alibaba.com>
Date: Thu, 5 Dec 2024 19:10:01 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] ocfs2: fix the space leak in LA when releasing LA
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@lists.linux.dev,
 akpm <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
References: <20241205104835.18223-1-heming.zhao@suse.com>
 <20241205104835.18223-3-heming.zhao@suse.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241205104835.18223-3-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/5/24 6:48 PM, Heming Zhao wrote:
> Commit 30dd3478c3cd ("ocfs2: correctly use ocfs2_find_next_zero_bit()")
> introduced an issue, the ocfs2_sync_local_to_main() ignores the last
> contiguous free bits, which causes an OCFS2 volume to lose the last free
> clusters of LA window during the release routine.
> 
> Please note, because commit dfe6c5692fb5 ("ocfs2: fix the la space leak
> when unmounting an ocfs2 volume") was reverted, this commit is a
> replacement fix for commit dfe6c5692fb5.
> 
> Fixes: 30dd3478c3cd ("ocfs2: correctly use ocfs2_find_next_zero_bit()")
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/localalloc.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index 5df34561c551..d1aa04a5af1b 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -971,9 +971,9 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
>  	start = count = 0;
>  	left = le32_to_cpu(alloc->id1.bitmap1.i_total);
>  
> -	while ((bit_off = ocfs2_find_next_zero_bit(bitmap, left, start)) <
> -	       left) {
> -		if (bit_off == start) {
> +	while (1) {
> +		bit_off = ocfs2_find_next_zero_bit(bitmap, left, start);
> +		if ((bit_off < left) && (bit_off == start)) {
>  			count++;
>  			start++;
>  			continue;
> @@ -998,6 +998,8 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
>  			}
>  		}
>  
> +		if (bit_off >= left)
> +			break;
>  		count = 1;
>  		start = bit_off + 1;
>  	}

