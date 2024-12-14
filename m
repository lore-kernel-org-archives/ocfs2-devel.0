Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4923E191F89
	for <ocfs2-devel@lists.linux.dev>; Sat, 14 Dec 2024 14:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734186599; cv=none; b=KSrsSa+CvSVI14aoI0rPHxo4DohdnNYRLd8jYosDQJL7Ots0VQYTnQF0YYBp8ssI4+WndfEpkfJdtnrFFDN8THJ21yHp+IL7A33XNZ8H2Lb4YQFoMSSFYvGdp5mUy8Jst9VWwd3SjElWgwUUbeM4jNOxciWcepKXQsKJne5Z99Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734186599; c=relaxed/simple;
	bh=UNdUVhWaXgRObJDXdijf1ufV9NYi+zewF/Uole5x4QI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H8tMJgzF1SagEY9yWo5sY1fD5F9TRql67JjL2640MQVERfpeEvLxLoe2DYnOuAAYix6jXfLEbRNDo6YupbRaH0inqE1F2McXC22C3xCayQy8EqSm2Co6gpSgme7JnbkhxFl+LkwE2JHEFHqLmtsQVykFO3+G9WDBKm5Nh5ZAnrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=RIbUoVt2; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="RIbUoVt2"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734186588; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=uih+x9K+8tdaNBVlA7Kl4hZf+LSV45PtU5+QWJ4hN+g=;
	b=RIbUoVt2NqzUNeNkVVauz02dKQvc92LU9PErUmRbwuUiJAtC0isw13AT/HJJsJL5gJL3aRNtqC/6wamYqJvdjA6J2ByITsydLLDUBkC0YIDhrvxMBl/qYA0JBLFC/tq7ZCdb+HhASnFU164LSuejlRFGTlVMP01jJbv8wJHzQvU=
Received: from 30.120.185.40(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WLRk.va_1734186586 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 14 Dec 2024 22:29:47 +0800
Message-ID: <39617f6f-9cf7-4aff-b500-1a0468d8189c@linux.alibaba.com>
Date: Sat, 14 Dec 2024 22:29:46 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 15/23] ocfs2: Convert ocfs2_clear_page_regions() to
 ocfs2_clear_folio_regions()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 akpm <akpm@linux-foundation.org>
Cc: Mark Tinguely <mark.tinguely@oracle.com>, ocfs2-devel@lists.linux.dev
References: <20241205171653.3179945-1-willy@infradead.org>
 <20241205171653.3179945-16-willy@infradead.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241205171653.3179945-16-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024/12/6 01:16, Matthew Wilcox (Oracle) wrote:
> From: Mark Tinguely <mark.tinguely@oracle.com>
> 
> Pass in and use the folio instead of its page.
> 
> Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/aops.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index cbc8bc6d95f3..644680ac1414 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -534,7 +534,7 @@ static void ocfs2_figure_cluster_boundaries(struct ocfs2_super *osb,
>   *
>   * from == to == 0 is code for "zero the entire cluster region"
>   */
> -static void ocfs2_clear_page_regions(struct page *page,
> +static void ocfs2_clear_folio_regions(struct folio *folio,
>  				     struct ocfs2_super *osb, u32 cpos,
>  				     unsigned from, unsigned to)
>  {
> @@ -543,7 +543,7 @@ static void ocfs2_clear_page_regions(struct page *page,
>  
>  	ocfs2_figure_cluster_boundaries(osb, cpos, &cluster_start, &cluster_end);
>  
> -	kaddr = kmap_atomic(page);
> +	kaddr = kmap_local_folio(folio, 0);
>  
>  	if (from || to) {
>  		if (from > cluster_start)
> @@ -554,7 +554,7 @@ static void ocfs2_clear_page_regions(struct page *page,
>  		memset(kaddr + cluster_start, 0, cluster_end - cluster_start);
>  	}
>  
> -	kunmap_atomic(kaddr);
> +	kunmap_local(kaddr);
>  }
>  
>  /*
> @@ -950,7 +950,6 @@ static int ocfs2_prepare_folio_for_write(struct inode *inode, u64 *p_blkno,
>  		struct ocfs2_write_ctxt *wc, struct folio *folio, u32 cpos,
>  		loff_t user_pos, unsigned user_len, int new)
>  {
> -	struct page *page = &folio->page;
>  	int ret;
>  	unsigned int map_from = 0, map_to = 0;
>  	unsigned int cluster_start, cluster_end;
> @@ -1016,7 +1015,7 @@ static int ocfs2_prepare_folio_for_write(struct inode *inode, u64 *p_blkno,
>  	 * been zero'd from being read in as a hole.
>  	 */
>  	if (new && !folio_test_uptodate(folio))
> -		ocfs2_clear_page_regions(page, OCFS2_SB(inode->i_sb),
> +		ocfs2_clear_folio_regions(folio, OCFS2_SB(inode->i_sb),
>  					 cpos, user_data_from, user_data_to);
>  
>  	flush_dcache_folio(folio);

