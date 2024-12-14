Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84230EC0
	for <ocfs2-devel@lists.linux.dev>; Sat, 14 Dec 2024 14:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734187159; cv=none; b=gyqAXDeQPQHcJhe9X/fWFP6U9d+bYd3Y9LwxUajliCto7sBJA5eSSh+8xBZ5tp2yI8KbsMarloo9pdLvi3HKTa6IV+JRuPHiPwgHjCUb2A8CyzaBZk4UIILOfEDPXtWiRc15uK/LzPo5szPhLYL6PwsbDeG7LGuMbQ5zT7k/Yc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734187159; c=relaxed/simple;
	bh=kSvPfqKGkLoYsJBMAS5FIdhhO0xl8wJ9ugamBs8RJSA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vh7QgtArIWhnpwlSdS2tQ7bAuXxLbPa8RjaBwmDE2S+owGP5k/Mu1GIjB8KqHVxMJMxdptMUKAHZH2r6T7e4JOqDIy9dKeuHO68ccY/c1N8jl4fJLoFdaAMtvPT+ZoowsqXZW8XHDCKg2EFKCAQ579NUyp6nqnH8rgm4FF7x6z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=uDQhp/A7; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="uDQhp/A7"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734187148; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=mEfVID3xjqGDIjfJ4Whevql29GKyV4lovGCC6HCq7N8=;
	b=uDQhp/A7NcR40MjWz5bFebZXfILRRrOgKWPKaDnTK+ZHqAiV409MjFT9bgXo+s8XYaFbJF2O6hc42L7DhC1/D7a9pblj+7jH2fOZpbRdxV0ew5HoMC2mdAy6ZTJG46jj7eZP4t8G7KX1T/Q7y1+X8nc5V8Ho/uFq6Z1VNSx88iU=
Received: from 30.120.185.40(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WLRphfw_1734187146 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 14 Dec 2024 22:39:07 +0800
Message-ID: <e3201069-a679-456f-84aa-fef7e6faafaf@linux.alibaba.com>
Date: Sat, 14 Dec 2024 22:39:06 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 19/23] ocfs2: Convert ocfs2_read_inline_data() to take a
 folio
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, Mark Tinguely <mark.tinguely@oracle.com>
References: <20241205171653.3179945-1-willy@infradead.org>
 <20241205171653.3179945-20-willy@infradead.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241205171653.3179945-20-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024/12/6 01:16, Matthew Wilcox (Oracle) wrote:
> All callers now have a folio, so pass it in.  We can use
> folio_fill_tail() instead of open-coding it.  Saves a call to
> compound_head().
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/alloc.c |  2 +-
>  fs/ocfs2/aops.c  | 20 ++++++--------------
>  fs/ocfs2/aops.h  |  2 +-
>  3 files changed, 8 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index c8d9d5e9a7fd..36b536b54a2d 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -7135,7 +7135,7 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
>  		 * This should populate the 1st page for us and mark
>  		 * it up to date.
>  		 */
> -		ret = ocfs2_read_inline_data(inode, &folio->page, di_bh);
> +		ret = ocfs2_read_inline_data(inode, folio, di_bh);
>  		if (ret) {
>  			mlog_errno(ret);
>  			need_free = 1;
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index f1eba968563f..80fe7a68cbcc 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -215,10 +215,9 @@ int ocfs2_get_block(struct inode *inode, sector_t iblock,
>  	return err;
>  }
>  
> -int ocfs2_read_inline_data(struct inode *inode, struct page *page,
> +int ocfs2_read_inline_data(struct inode *inode, struct folio *folio,
>  			   struct buffer_head *di_bh)
>  {
> -	void *kaddr;
>  	loff_t size;
>  	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
>  
> @@ -230,7 +229,7 @@ int ocfs2_read_inline_data(struct inode *inode, struct page *page,
>  
>  	size = i_size_read(inode);
>  
> -	if (size > PAGE_SIZE ||
> +	if (size > folio_size(folio) ||
>  	    size > ocfs2_max_inline_data_with_xattr(inode->i_sb, di)) {
>  		ocfs2_error(inode->i_sb,
>  			    "Inode %llu has with inline data has bad size: %Lu\n",
> @@ -239,15 +238,8 @@ int ocfs2_read_inline_data(struct inode *inode, struct page *page,
>  		return -EROFS;
>  	}
>  
> -	kaddr = kmap_atomic(page);
> -	if (size)
> -		memcpy(kaddr, di->id2.i_data.id_data, size);
> -	/* Clear the remaining part of the page */
> -	memset(kaddr + size, 0, PAGE_SIZE - size);
> -	flush_dcache_page(page);
> -	kunmap_atomic(kaddr);
> -
> -	SetPageUptodate(page);
> +	folio_fill_tail(folio, 0, di->id2.i_data.id_data, size);
> +	folio_mark_uptodate(folio);
>  
>  	return 0;
>  }
> @@ -266,7 +258,7 @@ static int ocfs2_readpage_inline(struct inode *inode, struct folio *folio)
>  		goto out;
>  	}
>  
> -	ret = ocfs2_read_inline_data(inode, &folio->page, di_bh);
> +	ret = ocfs2_read_inline_data(inode, folio, di_bh);
>  out:
>  	folio_unlock(folio);
>  
> @@ -1506,7 +1498,7 @@ static int ocfs2_write_begin_inline(struct address_space *mapping,
>  		ocfs2_set_inode_data_inline(inode, di);
>  
>  	if (!folio_test_uptodate(folio)) {
> -		ret = ocfs2_read_inline_data(inode, &folio->page, wc->w_di_bh);
> +		ret = ocfs2_read_inline_data(inode, folio, wc->w_di_bh);
>  		if (ret) {
>  			ocfs2_commit_trans(osb, handle);
>  
> diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
> index cf8d202d9a8b..6f25066e5756 100644
> --- a/fs/ocfs2/aops.h
> +++ b/fs/ocfs2/aops.h
> @@ -41,7 +41,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
>  		struct folio **foliop, void **fsdata,
>  		struct buffer_head *di_bh, struct folio *mmap_folio);
>  
> -int ocfs2_read_inline_data(struct inode *inode, struct page *page,
> +int ocfs2_read_inline_data(struct inode *inode, struct folio *folio,
>  			   struct buffer_head *di_bh);
>  int ocfs2_size_fits_inline_data(struct buffer_head *di_bh, u64 new_size);
>  

