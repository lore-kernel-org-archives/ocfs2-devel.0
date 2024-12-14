Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA662EAE6
	for <ocfs2-devel@lists.linux.dev>; Sat, 14 Dec 2024 14:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734186870; cv=none; b=bwes8jCWcQZoBlpJCqNvnX7XbZzG5QiNaEumRNbB15Q83I+fb3SIskUObPzeMTuJCPPFhXbLv0poMpJmDXkGxGCB9eqpd6/3hXGskDI/9HI6KBaR/OErPxR69QY9aXPEFbZmnu0I913E3mRT/nVLxbq5CRoP0mBkw286MghvUrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734186870; c=relaxed/simple;
	bh=LHq2EOupKTa7HIu9KmsN+i2XubklbZ5KtOHa0lLl0pI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iexFYF2++U26yIEtCFKL7TUwsEiFpp89W+rQQObngMD2oIEELC8f1eWf6tnZtmqlfX5m7lX7jGgQiqQi1Rph8H+myeOxeMRquiGCm+wHuPS5EXxtsFliRyNl2i4aKc0OpyWSmykWOd9ZF/WbM3epUvy8YlNCflULFOSN7RVo9ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=BH0EY5Bx; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="BH0EY5Bx"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734186858; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=+6nko+HuyqARzA9G298Kgx2xLHq8EQ5wYvmoV2anqEU=;
	b=BH0EY5BxvplvlANg/VL/FI2KGdgoDZfwl0e7E1mPSTsVwC5vkX4B7lCo7WGhFawgr0k5Vr0THyLPZYjPkk+vo/ll2ptIkdmgYBCj0ebFtqIciBo/6n4bcCjIJp/w5aoEMKRPtnf/MHVy+BxocLx+nP/uZ9g6TTQ0d2q1tMB6Pq8=
Received: from 30.120.185.40(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WLRrBMJ_1734186856 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 14 Dec 2024 22:34:17 +0800
Message-ID: <7ede4cc2-8026-4622-87ae-23d2eec5b4c4@linux.alibaba.com>
Date: Sat, 14 Dec 2024 22:34:16 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/23] ocfs2: Use an array of folios instead of an array
 of pages
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 akpm <akpm@linux-foundation.org>
Cc: Mark Tinguely <mark.tinguely@oracle.com>, ocfs2-devel@lists.linux.dev
References: <20241205171653.3179945-1-willy@infradead.org>
 <20241205171653.3179945-17-willy@infradead.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241205171653.3179945-17-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024/12/6 01:16, Matthew Wilcox (Oracle) wrote:
> From: Mark Tinguely <mark.tinguely@oracle.com>
> 
> The ocfs2_zero_cluster_folios() / ocfs2_grab_folios() /
> ocfs2_grab_eof_folios() family of functions pass around an array of
> pages.  Convert them to pass around an array of folios.  This removes
> the last caller of ocfs2_unlock_and_free_pages(), so delete it.
> 
> Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/alloc.c | 98 ++++++++++++++++++++++++------------------------
>  fs/ocfs2/alloc.h |  2 -
>  fs/ocfs2/aops.c  | 13 -------
>  fs/ocfs2/aops.h  |  1 -
>  4 files changed, 49 insertions(+), 65 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index cfe9535a27f9..dfcdafc11377 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -6847,87 +6847,87 @@ void ocfs2_map_and_dirty_page(struct inode *inode, handle_t *handle,
>  	flush_dcache_folio(folio);
>  }
>  
> -static void ocfs2_zero_cluster_pages(struct inode *inode, loff_t start,
> -				     loff_t end, struct page **pages,
> -				     int numpages, u64 phys, handle_t *handle)
> +static void ocfs2_zero_cluster_folios(struct inode *inode, loff_t start,
> +		loff_t end, struct folio **folios, int numfolios,
> +		u64 phys, handle_t *handle)
>  {
>  	int i;
> -	struct page *page;
>  	unsigned int from, to = PAGE_SIZE;
>  	struct super_block *sb = inode->i_sb;
>  
>  	BUG_ON(!ocfs2_sparse_alloc(OCFS2_SB(sb)));
>  
> -	if (numpages == 0)
> +	if (numfolios == 0)
>  		goto out;
>  
>  	to = PAGE_SIZE;
> -	for(i = 0; i < numpages; i++) {
> -		page = pages[i];
> +	for (i = 0; i < numfolios; i++) {
> +		struct folio *folio = folios[i];
>  
>  		from = start & (PAGE_SIZE - 1);
> -		if ((end >> PAGE_SHIFT) == page->index)
> +		if ((end >> PAGE_SHIFT) == folio->index)
>  			to = end & (PAGE_SIZE - 1);
>  
>  		BUG_ON(from > PAGE_SIZE);
>  		BUG_ON(to > PAGE_SIZE);
>  
> -		ocfs2_map_and_dirty_page(inode, handle, from, to, page, 1,
> +		ocfs2_map_and_dirty_page(inode, handle, from, to, &folio->page, 1,
>  					 &phys);
>  
> -		start = (page->index + 1) << PAGE_SHIFT;
> +		start = (folio->index + 1) << PAGE_SHIFT;
>  	}
>  out:
> -	if (pages)
> -		ocfs2_unlock_and_free_pages(pages, numpages);
> +	if (folios)
> +		ocfs2_unlock_and_free_folios(folios, numfolios);
>  }
>  
> -int ocfs2_grab_pages(struct inode *inode, loff_t start, loff_t end,
> -		     struct page **pages, int *num)
> +static int ocfs2_grab_folios(struct inode *inode, loff_t start, loff_t end,
> +		struct folio **folios, int *num)
>  {
> -	int numpages, ret = 0;
> +	int numfolios, ret = 0;
>  	struct address_space *mapping = inode->i_mapping;
>  	unsigned long index;
>  	loff_t last_page_bytes;
>  
>  	BUG_ON(start > end);
>  
> -	numpages = 0;
> +	numfolios = 0;
>  	last_page_bytes = PAGE_ALIGN(end);
>  	index = start >> PAGE_SHIFT;
>  	do {
> -		pages[numpages] = find_or_create_page(mapping, index, GFP_NOFS);
> -		if (!pages[numpages]) {
> -			ret = -ENOMEM;
> +		folios[numfolios] = __filemap_get_folio(mapping, index,
> +				FGP_LOCK | FGP_ACCESSED | FGP_CREAT, GFP_NOFS);
> +		if (IS_ERR(folios[numfolios])) {
> +			ret = PTR_ERR(folios[numfolios]);
>  			mlog_errno(ret);
>  			goto out;
>  		}
>  
> -		numpages++;
> -		index++;
> +		index = folio_next_index(folios[numfolios]);
> +		numfolios++;
>  	} while (index < (last_page_bytes >> PAGE_SHIFT));
>  
>  out:
>  	if (ret != 0) {
> -		if (pages)
> -			ocfs2_unlock_and_free_pages(pages, numpages);
> -		numpages = 0;
> +		if (folios)
> +			ocfs2_unlock_and_free_folios(folios, numfolios);
> +		numfolios = 0;
>  	}
>  
> -	*num = numpages;
> +	*num = numfolios;
>  
>  	return ret;
>  }
>  
> -static int ocfs2_grab_eof_pages(struct inode *inode, loff_t start, loff_t end,
> -				struct page **pages, int *num)
> +static int ocfs2_grab_eof_folios(struct inode *inode, loff_t start, loff_t end,
> +				struct folio **folios, int *num)
>  {
>  	struct super_block *sb = inode->i_sb;
>  
>  	BUG_ON(start >> OCFS2_SB(sb)->s_clustersize_bits !=
>  	       (end - 1) >> OCFS2_SB(sb)->s_clustersize_bits);
>  
> -	return ocfs2_grab_pages(inode, start, end, pages, num);
> +	return ocfs2_grab_folios(inode, start, end, folios, num);
>  }
>  
>  /*
> @@ -6941,8 +6941,8 @@ static int ocfs2_grab_eof_pages(struct inode *inode, loff_t start, loff_t end,
>  int ocfs2_zero_range_for_truncate(struct inode *inode, handle_t *handle,
>  				  u64 range_start, u64 range_end)
>  {
> -	int ret = 0, numpages;
> -	struct page **pages = NULL;
> +	int ret = 0, numfolios;
> +	struct folio **folios = NULL;
>  	u64 phys;
>  	unsigned int ext_flags;
>  	struct super_block *sb = inode->i_sb;
> @@ -6955,17 +6955,17 @@ int ocfs2_zero_range_for_truncate(struct inode *inode, handle_t *handle,
>  		return 0;
>  
>  	/*
> -	 * Avoid zeroing pages fully beyond current i_size. It is pointless as
> -	 * underlying blocks of those pages should be already zeroed out and
> +	 * Avoid zeroing folios fully beyond current i_size. It is pointless as
> +	 * underlying blocks of those folios should be already zeroed out and
>  	 * page writeback will skip them anyway.
>  	 */
>  	range_end = min_t(u64, range_end, i_size_read(inode));
>  	if (range_start >= range_end)
>  		return 0;
>  
> -	pages = kcalloc(ocfs2_pages_per_cluster(sb),
> -			sizeof(struct page *), GFP_NOFS);
> -	if (pages == NULL) {
> +	folios = kcalloc(ocfs2_pages_per_cluster(sb),
> +			sizeof(struct folio *), GFP_NOFS);
> +	if (folios == NULL) {
>  		ret = -ENOMEM;
>  		mlog_errno(ret);
>  		goto out;
> @@ -6986,18 +6986,18 @@ int ocfs2_zero_range_for_truncate(struct inode *inode, handle_t *handle,
>  	if (phys == 0 || ext_flags & OCFS2_EXT_UNWRITTEN)
>  		goto out;
>  
> -	ret = ocfs2_grab_eof_pages(inode, range_start, range_end, pages,
> -				   &numpages);
> +	ret = ocfs2_grab_eof_folios(inode, range_start, range_end, folios,
> +				   &numfolios);
>  	if (ret) {
>  		mlog_errno(ret);
>  		goto out;
>  	}
>  
> -	ocfs2_zero_cluster_pages(inode, range_start, range_end, pages,
> -				 numpages, phys, handle);
> +	ocfs2_zero_cluster_folios(inode, range_start, range_end, folios,
> +				 numfolios, phys, handle);
>  
>  	/*
> -	 * Initiate writeout of the pages we zero'd here. We don't
> +	 * Initiate writeout of the folios we zero'd here. We don't
>  	 * wait on them - the truncate_inode_pages() call later will
>  	 * do that for us.
>  	 */
> @@ -7007,7 +7007,7 @@ int ocfs2_zero_range_for_truncate(struct inode *inode, handle_t *handle,
>  		mlog_errno(ret);
>  
>  out:
> -	kfree(pages);
> +	kfree(folios);
>  
>  	return ret;
>  }
> @@ -7060,7 +7060,7 @@ void ocfs2_set_inode_data_inline(struct inode *inode, struct ocfs2_dinode *di)
>  int ocfs2_convert_inline_data_to_extents(struct inode *inode,
>  					 struct buffer_head *di_bh)
>  {
> -	int ret, has_data, num_pages = 0;
> +	int ret, has_data, num_folios = 0;
>  	int need_free = 0;
>  	u32 bit_off, num;
>  	handle_t *handle;
> @@ -7069,7 +7069,7 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>  	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
>  	struct ocfs2_alloc_context *data_ac = NULL;
> -	struct page *page = NULL;
> +	struct folio *folio = NULL;
>  	struct ocfs2_extent_tree et;
>  	int did_quota = 0;
>  
> @@ -7124,8 +7124,8 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
>  		 */
>  		block = phys = ocfs2_clusters_to_blocks(inode->i_sb, bit_off);
>  
> -		ret = ocfs2_grab_eof_pages(inode, 0, page_end, &page,
> -					   &num_pages);
> +		ret = ocfs2_grab_eof_folios(inode, 0, page_end, &folio,
> +					   &num_folios);
>  		if (ret) {
>  			mlog_errno(ret);
>  			need_free = 1;
> @@ -7136,14 +7136,14 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
>  		 * This should populate the 1st page for us and mark
>  		 * it up to date.
>  		 */
> -		ret = ocfs2_read_inline_data(inode, page, di_bh);
> +		ret = ocfs2_read_inline_data(inode, &folio->page, di_bh);
>  		if (ret) {
>  			mlog_errno(ret);
>  			need_free = 1;
>  			goto out_unlock;
>  		}
>  
> -		ocfs2_map_and_dirty_page(inode, handle, 0, page_end, page, 0,
> +		ocfs2_map_and_dirty_page(inode, handle, 0, page_end, &folio->page, 0,
>  					 &phys);
>  	}
>  
> @@ -7175,8 +7175,8 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
>  	}
>  
>  out_unlock:
> -	if (page)
> -		ocfs2_unlock_and_free_pages(&page, num_pages);
> +	if (folio)
> +		ocfs2_unlock_and_free_folios(&folio, num_folios);
>  
>  out_commit:
>  	if (ret < 0 && did_quota)
> diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
> index 4af7abaa6e40..6a2aca1a062e 100644
> --- a/fs/ocfs2/alloc.h
> +++ b/fs/ocfs2/alloc.h
> @@ -254,8 +254,6 @@ static inline int ocfs2_is_empty_extent(struct ocfs2_extent_rec *rec)
>  	return !rec->e_leaf_clusters;
>  }
>  
> -int ocfs2_grab_pages(struct inode *inode, loff_t start, loff_t end,
> -		     struct page **pages, int *num);
>  void ocfs2_map_and_dirty_page(struct inode *inode, handle_t *handle,
>  			      unsigned int from, unsigned int to,
>  			      struct page *page, int zero, u64 *phys);
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 644680ac1414..f1eba968563f 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -783,19 +783,6 @@ void ocfs2_unlock_and_free_folios(struct folio **folios, int num_folios)
>  	}
>  }
>  
> -void ocfs2_unlock_and_free_pages(struct page **pages, int num_pages)
> -{
> -	int i;
> -
> -	for(i = 0; i < num_pages; i++) {
> -		if (pages[i]) {
> -			unlock_page(pages[i]);
> -			mark_page_accessed(pages[i]);
> -			put_page(pages[i]);
> -		}
> -	}
> -}
> -
>  static void ocfs2_unlock_folios(struct ocfs2_write_ctxt *wc)
>  {
>  	int i;
> diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
> index 17ca359c6051..cf8d202d9a8b 100644
> --- a/fs/ocfs2/aops.h
> +++ b/fs/ocfs2/aops.h
> @@ -18,7 +18,6 @@ int ocfs2_map_folio_blocks(struct folio *folio, u64 *p_blkno,
>  			  unsigned int to, int new);
>  
>  void ocfs2_unlock_and_free_folios(struct folio **folios, int num_folios);
> -void ocfs2_unlock_and_free_pages(struct page **pages, int num_pages);
>  
>  int walk_page_buffers(	handle_t *handle,
>  			struct buffer_head *head,

