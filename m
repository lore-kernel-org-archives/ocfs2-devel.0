Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0999F170A13
	for <ocfs2-devel@lists.linux.dev>; Sat, 14 Dec 2024 12:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734179356; cv=none; b=QQawshT6Sc5ii747lv6SuDV+QD9sqo2z37y00zZ89kA+408JV1aK+0tNdgYE80NmMe8zDiHHt/QZ2j+9zvTL5HsmESgmBkOcP0Sc/n6F63C2RdZXMUfU2Q/nb1UU+dPjKJO/DpeU539S+nW1JfwMTLBNKm1qZXJ65ZYYxNCVXvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734179356; c=relaxed/simple;
	bh=uF6Gn2z6xRdGS38qov0iEN5+JV6oYad/G6e87vTWq3Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VjPOQaar3E6Bboz4VphDJVDXvG2+1FKDKMdqQtIb9gSjfxDDgSfdGi3gxqSpCSrlrlJ81EdeEWyWyWJIFtTxj/iXC901/EeA+Kvp7YNS1nsVnGsypRMGrWT6XkIF7YM2Dbp6V+iydQoydKE15DvEdAkUoWeYJcNOHYlu9D3eWIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=oihOS6uy; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="oihOS6uy"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734179345; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=C0t9GuJ9EHf0tUW++bXxz8jewEh95rleDsea6aAT2Nc=;
	b=oihOS6uyVBlHOJJzamUDZnPWxQ1hytClD/h8nkixQKcL0abLPtiTihTj99QpGemTD3Eu34doyW97oCHHGn+w7dplGoWEXHu5xHYoU9yySGeCRI+RyFtT2lLQUVd+uupyuwP0W9Tbhxw8FmIbwMunbArTj+DwsR96fphaadxNSrs=
Received: from 30.120.185.40(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WLRb6Qi_1734179343 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 14 Dec 2024 20:29:04 +0800
Message-ID: <d2c052eb-d78b-4e47-b85b-a59d724315ce@linux.alibaba.com>
Date: Sat, 14 Dec 2024 20:29:03 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/23] ocfs2: Convert w_target_page to w_target_folio
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 akpm <akpm@linux-foundation.org>
Cc: Mark Tinguely <mark.tinguely@oracle.com>, ocfs2-devel@lists.linux.dev
References: <20241205171653.3179945-1-willy@infradead.org>
 <20241205171653.3179945-4-willy@infradead.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241205171653.3179945-4-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024/12/6 01:16, Matthew Wilcox (Oracle) wrote:
> From: Mark Tinguely <mark.tinguely@oracle.com>
> 
> Pass a folio around instead of a page.  Saves a few hidden calls to
> compound_head() and removes a call to kmap_atomic().
> 
> Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/aops.c | 63 ++++++++++++++++++++++++-------------------------
>  1 file changed, 31 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index db72b3e924b3..5f7a33335385 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -731,22 +731,22 @@ struct ocfs2_write_ctxt {
>  	/*
>  	 * Pages involved in this write.
>  	 *
> -	 * w_target_page is the page being written to by the user.
> +	 * w_target_folio is the folio being written to by the user.
>  	 *
>  	 * w_pages is an array of pages which always contains
> -	 * w_target_page, and in the case of an allocating write with
> +	 * w_target_folio, and in the case of an allocating write with
>  	 * page_size < cluster size, it will contain zero'd and mapped
> -	 * pages adjacent to w_target_page which need to be written
> +	 * pages adjacent to w_target_folio which need to be written
>  	 * out in so that future reads from that region will get
>  	 * zero's.
>  	 */
>  	unsigned int			w_num_pages;
>  	struct page			*w_pages[OCFS2_MAX_CTXT_PAGES];
> -	struct page			*w_target_page;
> +	struct folio			*w_target_folio;
>  
>  	/*
>  	 * w_target_locked is used for page_mkwrite path indicating no unlocking
> -	 * against w_target_page in ocfs2_write_end_nolock.
> +	 * against w_target_folio in ocfs2_write_end_nolock.
>  	 */
>  	unsigned int			w_target_locked:1;
>  
> @@ -791,18 +791,18 @@ static void ocfs2_unlock_pages(struct ocfs2_write_ctxt *wc)
>  	/*
>  	 * w_target_locked is only set to true in the page_mkwrite() case.
>  	 * The intent is to allow us to lock the target page from write_begin()
> -	 * to write_end(). The caller must hold a ref on w_target_page.
> +	 * to write_end(). The caller must hold a ref on w_target_folio.
>  	 */
>  	if (wc->w_target_locked) {
> -		BUG_ON(!wc->w_target_page);
> +		BUG_ON(!wc->w_target_folio);
>  		for (i = 0; i < wc->w_num_pages; i++) {
> -			if (wc->w_target_page == wc->w_pages[i]) {
> +			if (&wc->w_target_folio->page == wc->w_pages[i]) {
>  				wc->w_pages[i] = NULL;
>  				break;
>  			}
>  		}
> -		mark_page_accessed(wc->w_target_page);
> -		put_page(wc->w_target_page);
> +		folio_mark_accessed(wc->w_target_folio);
> +		folio_put(wc->w_target_folio);
>  	}
>  	ocfs2_unlock_and_free_pages(wc->w_pages, wc->w_num_pages);
>  }
> @@ -869,8 +869,9 @@ static int ocfs2_alloc_write_ctxt(struct ocfs2_write_ctxt **wcp,
>   * and dirty so they'll be written out (in order to prevent uninitialised
>   * block data from leaking). And clear the new bit.
>   */
> -static void ocfs2_zero_new_buffers(struct page *page, unsigned from, unsigned to)
> +static void ocfs2_zero_new_buffers(struct folio *folio, unsigned from, unsigned to)
>  {
> +	struct page *page = &folio->page;
>  	unsigned int block_start, block_end;
>  	struct buffer_head *head, *bh;
>  
> @@ -918,8 +919,8 @@ static void ocfs2_write_failure(struct inode *inode,
>  		to = user_pos + user_len;
>  	struct page *tmppage;
>  
> -	if (wc->w_target_page)
> -		ocfs2_zero_new_buffers(wc->w_target_page, from, to);
> +	if (wc->w_target_folio)
> +		ocfs2_zero_new_buffers(wc->w_target_folio, from, to);
>  
>  	for(i = 0; i < wc->w_num_pages; i++) {
>  		tmppage = wc->w_pages[i];
> @@ -954,7 +955,7 @@ static int ocfs2_prepare_page_for_write(struct inode *inode, u64 *p_blkno,
>  	new = new | ((i_size_read(inode) <= page_offset(page)) &&
>  			(page_offset(page) <= user_pos));
>  
> -	if (page == wc->w_target_page) {
> +	if (page == &wc->w_target_folio->page) {
>  		map_from = user_pos & (PAGE_SIZE - 1);
>  		map_to = map_from + user_len;
>  
> @@ -1097,7 +1098,7 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
>  		wait_for_stable_page(wc->w_pages[i]);
>  
>  		if (index == target_index)
> -			wc->w_target_page = wc->w_pages[i];
> +			wc->w_target_folio = page_folio(wc->w_pages[i]);
>  	}
>  out:
>  	if (ret)
> @@ -1494,7 +1495,8 @@ static int ocfs2_write_begin_inline(struct address_space *mapping,
>  	 * If we don't set w_num_pages then this page won't get unlocked
>  	 * and freed on cleanup of the write context.
>  	 */
> -	wc->w_pages[0] = wc->w_target_page = page;
> +	wc->w_target_folio = page_folio(page);
> +	wc->w_pages[0] = page;
>  	wc->w_num_pages = 1;
>  
>  	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), wc->w_di_bh,
> @@ -1803,7 +1805,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
>  		 * the operation.
>  		 */
>  		if (type == OCFS2_WRITE_MMAP && ret == -EAGAIN) {
> -			BUG_ON(wc->w_target_page);
> +			BUG_ON(wc->w_target_folio);
>  			ret = 0;
>  			goto out_quota;
>  		}
> @@ -1826,7 +1828,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
>  
>  success:
>  	if (foliop)
> -		*foliop = page_folio(wc->w_target_page);
> +		*foliop = wc->w_target_folio;
>  	*fsdata = wc;
>  	return 0;
>  out_quota:
> @@ -1924,18 +1926,15 @@ static void ocfs2_write_end_inline(struct inode *inode, loff_t pos,
>  				   struct ocfs2_dinode *di,
>  				   struct ocfs2_write_ctxt *wc)
>  {
> -	void *kaddr;
> -
>  	if (unlikely(*copied < len)) {
> -		if (!PageUptodate(wc->w_target_page)) {
> +		if (!folio_test_uptodate(wc->w_target_folio)) {
>  			*copied = 0;
>  			return;
>  		}
>  	}
>  
> -	kaddr = kmap_atomic(wc->w_target_page);
> -	memcpy(di->id2.i_data.id_data + pos, kaddr + pos, *copied);
> -	kunmap_atomic(kaddr);
> +	memcpy_from_folio(di->id2.i_data.id_data + pos, wc->w_target_folio,
> +			pos, *copied);
>  
>  	trace_ocfs2_write_end_inline(
>  	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
> @@ -1973,15 +1972,15 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
>  		goto out_write_size;
>  	}
>  
> -	if (unlikely(copied < len) && wc->w_target_page) {
> +	if (unlikely(copied < len) && wc->w_target_folio) {
>  		loff_t new_isize;
>  
> -		if (!PageUptodate(wc->w_target_page))
> +		if (!folio_test_uptodate(wc->w_target_folio))
>  			copied = 0;
>  
>  		new_isize = max_t(loff_t, i_size_read(inode), pos + copied);
> -		if (new_isize > page_offset(wc->w_target_page))
> -			ocfs2_zero_new_buffers(wc->w_target_page, start+copied,
> +		if (new_isize > folio_pos(wc->w_target_folio))
> +			ocfs2_zero_new_buffers(wc->w_target_folio, start+copied,
>  					       start+len);
>  		else {
>  			/*
> @@ -1991,12 +1990,12 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
>  			 * put page & buffer dirty bits into inconsistent
>  			 * state.
>  			 */
> -			block_invalidate_folio(page_folio(wc->w_target_page),
> +			block_invalidate_folio(wc->w_target_folio,
>  						0, PAGE_SIZE);
>  		}
>  	}
> -	if (wc->w_target_page)
> -		flush_dcache_page(wc->w_target_page);
> +	if (wc->w_target_folio)
> +		flush_dcache_folio(wc->w_target_folio);
>  
>  	for(i = 0; i < wc->w_num_pages; i++) {
>  		tmppage = wc->w_pages[i];
> @@ -2005,7 +2004,7 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
>  		if (tmppage == NULL)
>  			continue;
>  
> -		if (tmppage == wc->w_target_page) {
> +		if (tmppage == &wc->w_target_folio->page) {
>  			from = wc->w_target_from;
>  			to = wc->w_target_to;
>  

