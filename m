Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5364D53C
	for <ocfs2-devel@lists.linux.dev>; Sat, 14 Dec 2024 14:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734185078; cv=none; b=pul7jNB4kjb+ueNILhLvCaYxevtcC5KVeKTPXQ8b1gu8ofSSTuBLxRZAIQWgAPo7btborkYwqz/BReJEDsnzqeuY5dWDCum/g9k5HXIhdcR1jZ/TzJcx/OBOlJU2Z4YYZdW5Ens0WIYQF3BsmIWow9maSr89f2bOoQKUcVuCwlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734185078; c=relaxed/simple;
	bh=AJjk9cSlrNBakLlUVG5lMjiPqSZkKqwezqKuSoiffYE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eQiArk5DpxBv4/9PvYBer3hepNhh/dAMmbP9jkFWH26U0WmmckDyl8P+vdUo+oISdQfMHaaezsHMYqz11Qg8Ad/DRdJl44inzLVXHnTfSvQJt9aLg4bZXouYdRK30dHq3eJxsnQqrEyyGkBmvPWiID23QWJdSECVeOPqVSGZo0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=MQA6OBFm; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="MQA6OBFm"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734185067; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=iZ+qCXQiIkj52qvcFFvhldlIML2dGRDAdfjDSOPtql4=;
	b=MQA6OBFmqmb4L/mouasX5P+TaP3pO3zLYVTnRciwDPeWoPkbVHn4vxHWBsLy2KiGW3SPExZB0Bm3wKXFj8+lQvzQzCeLdeQY2dkld6j9lcQXoMCPF9H9HOjqmfcnzYfsEhC5auOiSqFxbl7OK41wag0oPdHTKOl/tI59BzKwVrk=
Received: from 30.120.185.40(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WLRbsN8_1734185065 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 14 Dec 2024 22:04:25 +0800
Message-ID: <bfdb499f-fc2e-4eb1-89f3-39bc8f065b40@linux.alibaba.com>
Date: Sat, 14 Dec 2024 22:04:24 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/23] ocfs2: Use a folio in ocfs2_write_begin_inline()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 akpm <akpm@linux-foundation.org>
Cc: Mark Tinguely <mark.tinguely@oracle.com>, ocfs2-devel@lists.linux.dev
References: <20241205171653.3179945-1-willy@infradead.org>
 <20241205171653.3179945-6-willy@infradead.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241205171653.3179945-6-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024/12/6 01:16, Matthew Wilcox (Oracle) wrote:
> From: Mark Tinguely <mark.tinguely@oracle.com>
> 
> Retrieve a folio from the page cache instead of a page and use that
> folio throught the function.  Saves a couple of calls to compound_head().
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Missing Mark's SOB.

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/aops.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index a1fad246765a..c5e9c3462b84 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -1473,7 +1473,7 @@ static int ocfs2_write_begin_inline(struct address_space *mapping,
>  {
>  	int ret;
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> -	struct page *page;
> +	struct folio *folio;
>  	handle_t *handle;
>  	struct ocfs2_dinode *di = (struct ocfs2_dinode *)wc->w_di_bh->b_data;
>  
> @@ -1484,19 +1484,20 @@ static int ocfs2_write_begin_inline(struct address_space *mapping,
>  		goto out;
>  	}
>  
> -	page = find_or_create_page(mapping, 0, GFP_NOFS);
> -	if (!page) {
> +	folio = __filemap_get_folio(mapping, 0,
> +			FGP_LOCK | FGP_ACCESSED | FGP_CREAT, GFP_NOFS);
> +	if (IS_ERR(folio)) {
>  		ocfs2_commit_trans(osb, handle);
> -		ret = -ENOMEM;
> +		ret = PTR_ERR(folio);
>  		mlog_errno(ret);
>  		goto out;
>  	}
>  	/*
> -	 * If we don't set w_num_pages then this page won't get unlocked
> +	 * If we don't set w_num_pages then this folio won't get unlocked
>  	 * and freed on cleanup of the write context.
>  	 */
> -	wc->w_target_folio = page_folio(page);
> -	wc->w_pages[0] = page;
> +	wc->w_target_folio = folio;
> +	wc->w_pages[0] = &folio->page;
>  	wc->w_num_pages = 1;
>  
>  	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), wc->w_di_bh,
> @@ -1511,8 +1512,8 @@ static int ocfs2_write_begin_inline(struct address_space *mapping,
>  	if (!(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL))
>  		ocfs2_set_inode_data_inline(inode, di);
>  
> -	if (!PageUptodate(page)) {
> -		ret = ocfs2_read_inline_data(inode, page, wc->w_di_bh);
> +	if (!folio_test_uptodate(folio)) {
> +		ret = ocfs2_read_inline_data(inode, &folio->page, wc->w_di_bh);
>  		if (ret) {
>  			ocfs2_commit_trans(osb, handle);
>  

