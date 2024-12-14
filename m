Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F769946C
	for <ocfs2-devel@lists.linux.dev>; Sat, 14 Dec 2024 14:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734187857; cv=none; b=fSHRzZ35iJF5NGeyxlQVBxEa14TyX1IkXoJCsJyh3gTfoIMrRrZcTz0d/4EXWE8VE0KeSUm26P9L+edtkfknyU/+7vS/69Y7ehIhDTbbPLpDNQZ1lEDkvESwwiTSXMArO4+oz1LpF23nhrUND5nQJu9E2jo30UDax7t3gliy5RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734187857; c=relaxed/simple;
	bh=dg/dzO9fep+XX1y6Y/rJ063kXWO/oTieZMNAr+CHnhg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l/5Jzgq+JwUFLXzZFbJYf+vEhea/Ds8Lf/Qo9+1W5yVQ3xXTK4U76scyXEydgzeRt3qp5bNJtzYOFk+dosUGhXpPzGfhqunRqXl0aNIAoXYwhI87L8Ej3Q71Bqv4j8zGNdS12LmoC1Sj+7t7Sr0VaanMU5UoCxT48z5UBM7g64g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=VdzvV5lH; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="VdzvV5lH"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734187852; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=USdNKj17Acp2I2efTYDFB7Z+YPKPXFnAV73FLQvZ2pc=;
	b=VdzvV5lH2fcad+8DmDyd3+adl5cBwUYlfTlJ6O2sUz7c4rO4XmKxplm72WTBnfJcTTK3rTtLzHkwt0dbtFT0Ly2GZLMDb9hjBosRQYx9WWH9G02MH8eytGuZ/qYS6A/iyY8TIUx6belPJbMtubXCYMW9xE9RzgklRxNMLZ8FKmE=
Received: from 30.120.185.40(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WLRk4Rc_1734187850 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 14 Dec 2024 22:50:51 +0800
Message-ID: <de9f2d89-ce0d-4753-82bc-09ddc9478445@linux.alibaba.com>
Date: Sat, 14 Dec 2024 22:50:50 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 22/23] ocfs2: Support large folios in
 ocfs2_zero_cluster_folios()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 akpm <akpm@linux-foundation.org>
Cc: Mark Tinguely <mark.tinguely@oracle.com>, ocfs2-devel@lists.linux.dev
References: <20241205171653.3179945-1-willy@infradead.org>
 <20241205171653.3179945-23-willy@infradead.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241205171653.3179945-23-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024/12/6 01:16, Matthew Wilcox (Oracle) wrote:
> From: Mark Tinguely <mark.tinguely@oracle.com>
> 
> Remove assumptions that a folio is one page in size.
> 
> Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/alloc.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 36b536b54a2d..3bff9314f8e0 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -6851,7 +6851,6 @@ static void ocfs2_zero_cluster_folios(struct inode *inode, loff_t start,
>  		u64 phys, handle_t *handle)
>  {
>  	int i;
> -	unsigned int from, to = PAGE_SIZE;
>  	struct super_block *sb = inode->i_sb;
>  
>  	BUG_ON(!ocfs2_sparse_alloc(OCFS2_SB(sb)));
> @@ -6859,21 +6858,18 @@ static void ocfs2_zero_cluster_folios(struct inode *inode, loff_t start,
>  	if (numfolios == 0)
>  		goto out;
>  
> -	to = PAGE_SIZE;
>  	for (i = 0; i < numfolios; i++) {
>  		struct folio *folio = folios[i];
> +		size_t to = folio_size(folio);
> +		size_t from = offset_in_folio(folio, start);
>  
> -		from = start & (PAGE_SIZE - 1);
> -		if ((end >> PAGE_SHIFT) == folio->index)
> -			to = end & (PAGE_SIZE - 1);
> -
> -		BUG_ON(from > PAGE_SIZE);
> -		BUG_ON(to > PAGE_SIZE);
> +		if (to > end - folio_pos(folio))
> +			to = end - folio_pos(folio);
>  
>  		ocfs2_map_and_dirty_folio(inode, handle, from, to, folio, 1,
>  				&phys);
>  
> -		start = (folio->index + 1) << PAGE_SHIFT;
> +		start = folio_next_index(folio) << PAGE_SHIFT;
>  	}
>  out:
>  	if (folios)

