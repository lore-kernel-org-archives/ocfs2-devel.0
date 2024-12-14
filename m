Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581CBD53C
	for <ocfs2-devel@lists.linux.dev>; Sat, 14 Dec 2024 14:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734184895; cv=none; b=h1mSAROHweC/NX5bDdzQD+rxxApdJwlTe+2IDO90279RX3TPBNAVGYNlgS4soj0YWXQp/wV/U3JbLa5n3M7vtL0Sns7lS0SO/N3Lf/u6iEXaPxoDIpWGnZn+ym9J08W9bkp8pBMqCG/3Q9EW2cCLfnSFZRpgF9O2/2jrlVE8r4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734184895; c=relaxed/simple;
	bh=DAfP9QWlVCzr08ZMthUuyE6wQwTu8Eosan0lZYthZ0E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mtN2X21zo4FADA8iBkYWONOBpf80+AzO10U4q7+nwUu86Xh55hWH3zB4sTUjvQX9JywISAjuheaTzfJc+oBgFmdIz7303iydxi6bxP6Q9GyLIK66ORrPQXDB34GTOz5Jtgw6c7aSTkAzFQKTjGFnjm6IdBa73gO22wMLECe7M4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=uU6Oasbh; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="uU6Oasbh"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734184881; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=mRZcHeQJfP2wIMdU19iZs03ms8If1E813QA1Em8bi/w=;
	b=uU6OasbhQRFkQ7PAo2XaAl0D1aPnDQ/A9sE1ykuLCNLnl7R4VEXhvuWqXfzsadK+kISmCEVUXYuJVlbTk4LRtYCfD01pi83MeeYt+YD0RS3mIimVHW4/lFJSP+5ZQObkkFaSMWrilb9aDKX2LyTLKqJsPpFreIESdtRO0AKdWuE=
Received: from 30.120.185.40(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WLRdjDa_1734184880 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 14 Dec 2024 22:01:21 +0800
Message-ID: <bc0eecab-bb1c-45c7-b1fa-504bb56a8b06@linux.alibaba.com>
Date: Sat, 14 Dec 2024 22:01:20 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/23] ocfs2: Use a folio in ocfs2_zero_new_buffers()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 akpm <akpm@linux-foundation.org>
Cc: Mark Tinguely <mark.tinguely@oracle.com>, ocfs2-devel@lists.linux.dev
References: <20241205171653.3179945-1-willy@infradead.org>
 <20241205171653.3179945-5-willy@infradead.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241205171653.3179945-5-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024/12/6 01:16, Matthew Wilcox (Oracle) wrote:
> From: Mark Tinguely <mark.tinguely@oracle.com>
> 
> Convert to the new APIs, saving at least one hidden call to
> compound_head().
> 
> Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/ocfs2/aops.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 5f7a33335385..a1fad246765a 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -869,30 +869,30 @@ static int ocfs2_alloc_write_ctxt(struct ocfs2_write_ctxt **wcp,
>   * and dirty so they'll be written out (in order to prevent uninitialised
>   * block data from leaking). And clear the new bit.
>   */
> -static void ocfs2_zero_new_buffers(struct folio *folio, unsigned from, unsigned to)
> +static void ocfs2_zero_new_buffers(struct folio *folio, size_t from, size_t to)

Don't see why we have to change 'unsigned' to 'size_t'.

Thanks,
Joseph

>  {
> -	struct page *page = &folio->page;
>  	unsigned int block_start, block_end;
>  	struct buffer_head *head, *bh;
>  
> -	BUG_ON(!PageLocked(page));
> -	if (!page_has_buffers(page))
> +	BUG_ON(!folio_test_locked(folio));
> +	head = folio_buffers(folio);
> +	if (!head)
>  		return;
>  
> -	bh = head = page_buffers(page);
> +	bh = head;
>  	block_start = 0;
>  	do {
>  		block_end = block_start + bh->b_size;
>  
>  		if (buffer_new(bh)) {
>  			if (block_end > from && block_start < to) {
> -				if (!PageUptodate(page)) {
> +				if (!folio_test_uptodate(folio)) {
>  					unsigned start, end;
>  
>  					start = max(from, block_start);
>  					end = min(to, block_end);
>  
> -					zero_user_segment(page, start, end);
> +					folio_zero_segment(folio, start, end);
>  					set_buffer_uptodate(bh);
>  				}
>  

