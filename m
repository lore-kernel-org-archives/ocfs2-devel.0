Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A1B1C01
	for <ocfs2-devel@lists.linux.dev>; Thu, 14 Mar 2024 03:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710388104; cv=none; b=e9b7QWJRa70qG6+SvCNFYHT3nl3LGEIjHuGI6Tm5+uZ9Ik9oZHziXevxKzVTif3yzr68YXgTWLqkq1dkS57XQpKmFo6LnpKUGQY0wpbOqyfYITgzsiwWBhVUI8CqrTVus4DkyzXsJA/uoqkflGDsFmGkGbcN3xFBhkv9LznXIB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710388104; c=relaxed/simple;
	bh=hxGPW6F/lRn8Hp1h9GJ0iQTIXaGQa9HhBxPLkGiSKmM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hoBBK3ClyU6LLlydfCOIP0s+NjPdtd7A8IS0aMKzhz7r5RvLsyFJaL8eZgEY8RkG5tDRnU5fwujnHPrXPTfitXL6uomk7NROgDoSWvFV6A4YQ9DS9HeLuBtXu9VQRWvNBUIHqVFaHHLjtO0E9otvPUH0d6v/c5300mo1U3vrMRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ub1jNB3C; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ub1jNB3C"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-33e70d71756so968621f8f.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 13 Mar 2024 20:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1710388100; x=1710992900; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eOviLiryVX1T/R4dsTzREYljWy5mbWzek3/dO7jc7QQ=;
        b=Ub1jNB3CKraYcNmSg6TlQJsxs+HFY6jbqqQQPMkM44JnAEkfdRfccLuEt5I1bO68nb
         O+ZtGOBnt69tUC3s1z619H1rs0k9QkLxaoFTfbj13guuelHEDiueMjhsHZ7AnADq+qQJ
         TN/Sn1gfK66R2z7oZJ2WMHQyhycQ/iAWrqSNGDRKcXyXD4EDc6/bEbQzZE0BJPEWddbt
         y7OKln2eVKa9uwNkAEJIrYTxuYu/qpxB7IliwM30UTEJWCAZdbzYyv5cmFpgkoBO+dhD
         KKBAytuzpUFQMhS37V4a84Tj5gBn4M/h9LoAkW87rkzGn//sUkoo74keMbVylpBP0/Rg
         ZbRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710388100; x=1710992900;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eOviLiryVX1T/R4dsTzREYljWy5mbWzek3/dO7jc7QQ=;
        b=aumgVKJvpA4SlihUsSW9DD5D0D5xhlwukCVmrf3xXaKm0mcp/lE+1Yj9E7go79Nw36
         pChupqFeyuZV+lgifC1uVpT7+FIfDsK2u79h1sb6nPxfTECZY8tEjmWaE2vaek1IWRT2
         ucwc4qkZrBP4Uu4q1QUaxaTfSNzYnSy3KvruVNpk2X3gvbL1QTSADdSu7jmvFJLeqQ9T
         YcTe7CbDO3ao23ZtFMztlLva60jCzgDUB2A+0vbbfJJDGyOpmaxPbYWPbhYAhA8AcLwH
         CZlyn77cRp5cAnDc2CdDygc128rVfP4zk2jw/vN5DHDhIEYyFq+WvxFtmiPbk2XPwwT7
         pUbQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJgid1DwJeFq0QRg/UHT8+dhLg6zvSRDQMkwfhyr3h2UgOd3Hn7H3k6M7idJ2WbSJEA4TOiZtGrgYWBbcsZe+8EuFSpvbudupBMNY=
X-Gm-Message-State: AOJu0YyCesvrn2u0yVQJ4eR9fnPfteNjUTDD4yhCdLuZkL1MaHWGUq/8
	BtCXUt4r9bmTDh4DULnziBIom8wHZ2ceC2c0Rb6RWBrkOhG/Bzbbx6We6s/ZeSX7pMYgYNxoABt
	6
X-Google-Smtp-Source: AGHT+IEpMQh+0GH30zPWWTqqfR6CYRv564vV5j+bO7a6lxi/1w+xUc1X9nXUtj88GXpy6vaJAjWWLg==
X-Received: by 2002:adf:f4d0:0:b0:33e:c071:7769 with SMTP id h16-20020adff4d0000000b0033ec0717769mr1456101wrp.11.1710388100281;
        Wed, 13 Mar 2024 20:48:20 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id l14-20020a170903120e00b001dcfaf4db22sm420951plh.2.2024.03.13.20.48.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Mar 2024 20:48:19 -0700 (PDT)
Message-ID: <9e034592-a296-4a46-9434-dd041adbeeea@suse.com>
Date: Thu, 14 Mar 2024 11:48:16 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: correctly use ocfs2_find_next_zero_bit()
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@lists.linux.dev
Cc: Andrew Morton <akpm@linux-foundation.org>
References: <20240314021713.240796-1-joseph.qi@linux.alibaba.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20240314021713.240796-1-joseph.qi@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/24 10:17, Joseph Qi wrote:
> If no bits are zero, ocfs2_find_next_zero_bit() will return max size, so
> check the return value with -1 is meaningless.
> Correct this usage and cleanup the code.
> 
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>   fs/ocfs2/localalloc.c   | 19 ++++++-------------
>   fs/ocfs2/reservations.c |  2 +-
>   fs/ocfs2/suballoc.c     |  6 ++----
>   3 files changed, 9 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index c803c10dd97e..33aeaaa056d7 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -863,14 +863,8 @@ static int ocfs2_local_alloc_find_clear_bits(struct ocfs2_super *osb,
>   
>   	numfound = bitoff = startoff = 0;
>   	left = le32_to_cpu(alloc->id1.bitmap1.i_total);
> -	while ((bitoff = ocfs2_find_next_zero_bit(bitmap, left, startoff)) != -1) {
> -		if (bitoff == left) {
> -			/* mlog(0, "bitoff (%d) == left", bitoff); */
> -			break;
> -		}
> -		/* mlog(0, "Found a zero: bitoff = %d, startoff = %d, "
> -		   "numfound = %d\n", bitoff, startoff, numfound);*/
> -
> +	while ((bitoff = ocfs2_find_next_zero_bit(bitmap, left, startoff)) <
> +	       left) {
>   		/* Ok, we found a zero bit... is it contig. or do we
>   		 * start over?*/
>   		if (bitoff == startoff) {
> @@ -976,9 +970,9 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
>   	start = count = 0;
>   	left = le32_to_cpu(alloc->id1.bitmap1.i_total);
>   
> -	while ((bit_off = ocfs2_find_next_zero_bit(bitmap, left, start))
> -	       != -1) {
> -		if ((bit_off < left) && (bit_off == start)) {
> +	while ((bit_off = ocfs2_find_next_zero_bit(bitmap, left, start)) <
> +	       left) {
> +		if (bit_off == start) {
>   			count++;
>   			start++;
>   			continue;
> @@ -1002,8 +996,7 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
>   				goto bail;
>   			}
>   		}
> -		if (bit_off >= left)
> -			break;
> +
>   		count = 1;
>   		start = bit_off + 1;
>   	}
> diff --git a/fs/ocfs2/reservations.c b/fs/ocfs2/reservations.c
> index a9d1296d736d..1fe61974d9f0 100644
> --- a/fs/ocfs2/reservations.c
> +++ b/fs/ocfs2/reservations.c
> @@ -414,7 +414,7 @@ static int ocfs2_resmap_find_free_bits(struct ocfs2_reservation_map *resmap,
>   
>   	start = search_start;
>   	while ((offset = ocfs2_find_next_zero_bit(bitmap, resmap->m_bitmap_len,
> -						 start)) != -1) {
> +					start)) < resmap->m_bitmap_len) {
>   		/* Search reached end of the region */
>   		if (offset >= (search_start + search_len))
>   			break;
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 166c8918c825..961998415308 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -1290,10 +1290,8 @@ static int ocfs2_block_group_find_clear_bits(struct ocfs2_super *osb,
>   	found = start = best_offset = best_size = 0;
>   	bitmap = bg->bg_bitmap;
>   
> -	while((offset = ocfs2_find_next_zero_bit(bitmap, total_bits, start)) != -1) {
> -		if (offset == total_bits)
> -			break;
> -
> +	while ((offset = ocfs2_find_next_zero_bit(bitmap, total_bits, start)) <
> +	       total_bits) {
>   		if (!ocfs2_test_bg_bit_allocatable(bg_bh, offset)) {
>   			/* We found a zero, but we can't use it as it
>   			 * hasn't been put to disk yet! */

I found the same issue when I was writing the IO performance patch.
(So my patch doesn't follow the existing handling style.)
Thank you for taking time to fix it.

Reviewed-by: Heming Zhao <heming.zhao@suse.com>

Thanks,
Heming
