Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B1429E10F
	for <ocfs2-devel@lists.linux.dev>; Wed, 20 Aug 2025 05:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755668111; cv=none; b=NLFh7A0ozMOnkJ+bjRddA02AvGY747wivB6h9k3J/ztvw8YzHscWX3B5h99spBuCkxpC+xs2yo9wQYvdis4b/YXJha+gnR1lkpC6IvSlsBF0ZPyRNqWNVbG/l3uYPEtC1gD0L62QYUNLPufjDH5AuLGav7d2fRC0LZWoJurI144=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755668111; c=relaxed/simple;
	bh=ILaNbJn5HNYKVnX5VFPhvmllfQaHUS+n+I/U4jSWibA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F/qw9WkXnrKG/Ed0LEglUOvJv/AKlJKigR/M2WeeJUsq2Jjq6wmcp72ksjcscVSufKl5x61bvEQn/HPIW+H8/tbK/alpWh4Akr3AR6+scpcce46Xxeu5WjLOESmo5psAJR4B7hAVGEMr0SDpx2OS+iQb8Hq6wNV3ea10Cs4ZOwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=K5Glo0rh; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="K5Glo0rh"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755668099; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=G5p+r4JljAf2GgtlwI0TDUe77jYdbD2CY8bO7sSENRI=;
	b=K5Glo0rhzjg5G+POB1iwc5oUHRM8DuuMRs+Em/Hq/WvmE/GQABVeXAHQGa8SXr7bXCufq4yPd0+gMwTdeXzWohFK6mCDC+DbOysHLs2GTkRoMEQABzmPBh6YYHHhsrLf72tn06gvrtSSEgatWyKAiQg4DPZV3S115N/w/K9OSIw=
Received: from 30.221.144.123(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WmAN9rA_1755668098 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 20 Aug 2025 13:34:58 +0800
Message-ID: <e1d33394-c6c9-4f0e-a180-af743772a1e3@linux.alibaba.com>
Date: Wed, 20 Aug 2025 13:34:57 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: remove unnecessary NULL check in
 ocfs2_grab_folios()
To: Dan Carpenter <dan.carpenter@linaro.org>, Mark Fasheh <mark@fasheh.com>,
 akpm <akpm@linux-foundation.org>
Cc: Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <aKRG39hyvDJcN2G7@stanley.mountain>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <aKRG39hyvDJcN2G7@stanley.mountain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/8/19 17:41, Dan Carpenter wrote:
> Smatch complains that checking "folios" for NULL doesn't make sense
> because it has already been dereferenced at this point.  Really passing a
> NULL "folios" pointer to ocfs2_grab_folios() doesn't make sense, and
> fortunately none of the callers do that.  Delete the unnecessary NULL
> check.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/alloc.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 821cb7874685..162711cc5b20 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -6928,8 +6928,7 @@ static int ocfs2_grab_folios(struct inode *inode, loff_t start, loff_t end,
>  
>  out:
>  	if (ret != 0) {
> -		if (folios)
> -			ocfs2_unlock_and_free_folios(folios, numfolios);
> +		ocfs2_unlock_and_free_folios(folios, numfolios);
>  		numfolios = 0;
>  	}
>  

