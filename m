Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA60191F89
	for <ocfs2-devel@lists.linux.dev>; Sat, 14 Dec 2024 14:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734185903; cv=none; b=FI6HDfK9JEsdntd6E9cOpkJoGMfv2wDdjEA96Hcw1Y6/Sve+sPp4AiEuMyv0gSnLkn0NqavhVdXN+fUyocdoUWD4+EHSwOROER7FWF1vjuOinEyZJ2B+0OSubH41Sd2zrJOOu78fuvASyEKa9jKG6JFwkRj81hCwhMq10PaQj5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734185903; c=relaxed/simple;
	bh=k/XQCwy3Ewi7D9+/L+/jV7Vk+3uko/CNQWEMDmTZGUs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tbWQD3FxrgiaZtkQa2FlEuoUe6g1gwfjbLUzwlzwMJae7oiNZDt3rf37ns41/jJS6S/MGRztLMLQY433CvE+mHtpHG6SN4sguHQht8G2KL1Lomw3Dfe5RkCneuEHwXBUiMPrQIhRJAyMHgF4ts+kO3LWJQh4PkHfPjp12N6LIz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=YXaq+WdL; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="YXaq+WdL"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734185892; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=2wnHNtxgZJdQH/jqcE2c0uZvChCO3O28fWbPkJmavYY=;
	b=YXaq+WdLys5w5gvbU+z1cQynIC5NyB5zYhjQgU4HqsrsaTOPVfHuLzud2fJk+umRNnHWMCX9vAXvtzLJFP8f32cEORRqVJWNRavxdbp2PrYUdbXCYG3UjcWTlaSFhW6e6LmbwxNW7xqz7DZSJP4/8JtWh8CdOe+HZQj7zuP8PyA=
Received: from 30.120.185.40(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WLReWps_1734185890 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 14 Dec 2024 22:18:11 +0800
Message-ID: <b308fe4f-089a-4815-ab5e-d927a9d083b1@linux.alibaba.com>
Date: Sat, 14 Dec 2024 22:18:10 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/23] ocfs2: Use a folio in ocfs2_write_end_nolock()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 akpm <akpm@linux-foundation.org>
Cc: Mark Tinguely <mark.tinguely@oracle.com>, ocfs2-devel@lists.linux.dev
References: <20241205171653.3179945-1-willy@infradead.org>
 <20241205171653.3179945-12-willy@infradead.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241205171653.3179945-12-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024/12/6 01:16, Matthew Wilcox (Oracle) wrote:
> From: Mark Tinguely <mark.tinguely@oracle.com>
> 
> Remove an access to page->index.  Remove some PAGE_SIZE assumptions.
> 
> Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/aops.c | 37 +++++++++++++++++--------------------
>  1 file changed, 17 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 8dda080743b7..cc252a1170ad 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -1952,17 +1952,16 @@ static void ocfs2_write_end_inline(struct inode *inode, loff_t pos,
>  	     le16_to_cpu(di->i_dyn_features));
>  }
>  
> -int ocfs2_write_end_nolock(struct address_space *mapping,
> -			   loff_t pos, unsigned len, unsigned copied, void *fsdata)
> +int ocfs2_write_end_nolock(struct address_space *mapping, loff_t pos,
> +		unsigned len, unsigned copied, void *fsdata)
>  {
>  	int i, ret;
> -	unsigned from, to, start = pos & (PAGE_SIZE - 1);
> +	size_t from, to, start = pos & (PAGE_SIZE - 1);
>  	struct inode *inode = mapping->host;
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>  	struct ocfs2_write_ctxt *wc = fsdata;
>  	struct ocfs2_dinode *di = (struct ocfs2_dinode *)wc->w_di_bh->b_data;
>  	handle_t *handle = wc->w_handle;
> -	struct page *tmppage;
>  
>  	BUG_ON(!list_empty(&wc->w_unwritten_list));
>  
> @@ -1993,32 +1992,32 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
>  					       start+len);
>  		else {
>  			/*
> -			 * When page is fully beyond new isize (data copy
> -			 * failed), do not bother zeroing the page. Invalidate
> +			 * When folio is fully beyond new isize (data copy
> +			 * failed), do not bother zeroing the folio. Invalidate
>  			 * it instead so that writeback does not get confused
>  			 * put page & buffer dirty bits into inconsistent
>  			 * state.
>  			 */
> -			block_invalidate_folio(wc->w_target_folio,
> -						0, PAGE_SIZE);
> +			block_invalidate_folio(wc->w_target_folio, 0,
> +					folio_size(wc->w_target_folio));
>  		}
>  	}
>  	if (wc->w_target_folio)
>  		flush_dcache_folio(wc->w_target_folio);
>  
>  	for (i = 0; i < wc->w_num_folios; i++) {
> -		tmppage = &wc->w_folios[i]->page;
> +		struct folio *folio = wc->w_folios[i];
>  
> -		/* This is the direct io target page. */
> -		if (tmppage == NULL)
> +		/* This is the direct io target folio */
> +		if (folio == NULL)
>  			continue;
>  
> -		if (tmppage == &wc->w_target_folio->page) {
> +		if (folio == wc->w_target_folio) {
>  			from = wc->w_target_from;
>  			to = wc->w_target_to;
>  
> -			BUG_ON(from > PAGE_SIZE ||
> -			       to > PAGE_SIZE ||
> +			BUG_ON(from > folio_size(folio) ||
> +			       to > folio_size(folio) ||
>  			       to < from);
>  		} else {
>  			/*
> @@ -2027,19 +2026,17 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
>  			 * to flush their entire range.
>  			 */
>  			from = 0;
> -			to = PAGE_SIZE;
> +			to = folio_size(folio);
>  		}
>  
> -		if (page_has_buffers(tmppage)) {
> +		if (folio_buffers(folio)) {
>  			if (handle && ocfs2_should_order_data(inode)) {
> -				loff_t start_byte =
> -					((loff_t)tmppage->index << PAGE_SHIFT) +
> -					from;
> +				loff_t start_byte = folio_pos(folio) + from;
>  				loff_t length = to - from;
>  				ocfs2_jbd2_inode_add_write(handle, inode,
>  							   start_byte, length);
>  			}
> -			block_commit_write(tmppage, from, to);
> +			block_commit_write(&folio->page, from, to);
>  		}
>  	}
>  

