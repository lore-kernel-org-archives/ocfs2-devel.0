Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8F54F890
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 Mar 2024 08:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711616307; cv=none; b=DI1vFPNqd91TAmZ+B6DQyDtN+SyftilD+KFQgD4W5VVJLDeGvCmaZLb2ZY71knZ7h1GPGvdRTj307ztbLwax60TqWj66q76jh5+KmZz2p8ObNmnWUXuirgl3wAAwUmJiIrNWKZWL/O8UlzLzdaeRBe+akw+IfUdB+n012efCsNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711616307; c=relaxed/simple;
	bh=n9qwIpQ4KzI4C6XIPVFt3KVECJ/Cgo6Tg7qP8URKPO0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m85yoCVzfqbMXm0Vu7cUi7/1vWhM27NRH08PWkvgkBrZhp8+UPx4OI8iSxmn9MutEaMSeEg5kfAqzUtuCsyEs0j76DhdTWc1OGAdP/AitcO2i9c//jau/Gh5sVEACy4lp9IpctG5f8WRyGmvWY/EGc2Kl35Vax6YeNzbofFoSoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=KPQNUF/r; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="KPQNUF/r"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1711616302; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=TF4Vx84nVd4NhY/4DxbMdh6fProJZ3HRH5Gq0u8OOP4=;
	b=KPQNUF/r3DB+BrLbjm9W6hjvX26VzrhI1xtMmEJaKO3KfhwcZNP2zOvjlFIi4l/61R421me3/P18wtCe18yLybndLApVfEViYtlvQD6bBbOkyNmaMySqRTmH/ZX/Y9Cf56xVQr0pYHpEoI4aI27XZzYA7YHZuMQr3Wya/hkkFBI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0W3SiEZd_1711616282;
Received: from 30.221.129.70(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W3SiEZd_1711616282)
          by smtp.aliyun-inc.com;
          Thu, 28 Mar 2024 16:58:21 +0800
Message-ID: <99bc72b7-54d5-4823-9fb3-d8fa7018659a@linux.alibaba.com>
Date: Thu, 28 Mar 2024 16:58:21 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/4] ocfs2: speed up chain-list searching
Content-Language: en-US
To: Heming Zhao <heming.zhao@suse.com>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, ailiop@suse.com
References: <20240328082943.20251-1-heming.zhao@suse.com>
 <20240328082943.20251-4-heming.zhao@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240328082943.20251-4-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/28/24 4:29 PM, Heming Zhao wrote:
> Add short-circuit code to speed up searching
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
> v5: 
> - split 'sparse warnings' fix to a separate patch
> - amend the commit log according to patch change
> 
> v4: first version
> ---
>  fs/ocfs2/suballoc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index fc80cb3dbcd1..823e2ec38b2d 100644
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
