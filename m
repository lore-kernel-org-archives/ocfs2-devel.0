Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF141E517
	for <ocfs2-devel@lists.linux.dev>; Sat, 14 Dec 2024 14:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734185311; cv=none; b=kc6ogebfo5EtG6dZYoILKbgehUHdUa6jw8zEo2IcrQBj9+GDVEzYfPrXY4zF5G1Ytjxwsv+g7/l3569Pp/fm9YbgCnZ1/iQKN2YfzbWe3+dor+GG9NScIjVHM0MLpLlSvTo4rs79Q8tWUmWkeW7JX+/MqslfSe0FILxUxR2IrxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734185311; c=relaxed/simple;
	bh=zXSyStmpMH8Q8EExyr4b/iarxb+tOvEH97iM66EGnYc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V3NevnzU24gA9nI2yW7VRxx+SabWUv4sAKL6gF8LW4crsI5BeflSSrxYQFg/eQAoK/Hf/PMe5yRfMhIQmRhx4Ec4JiQXyH76EiDfsRgZSEDncfHiFOb1TIxq70jOya7Q0Z1RY0qb4wPUAwXsXcRET7fqfeZPE5mBe1PJ3eUNdpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=du24RYAh; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="du24RYAh"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734185301; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Vu3P+dhlCYCjcSGiprA5gIJakviijhgbovMuDZZFj8s=;
	b=du24RYAhKV1VUBdHQokkBkZo/fRISsKN4o5zYrdCv+K/cKXgzwyyBgAOmUsxt68rhiS1548wk/xnfYjYb/3nVPMboRPIUJQpM+YWcnEjp0EpRp0a+g/FppuLHMboEnGY5d2w+OkIZqssGgxIf1ztC/F+4fnh7gzUWbocXNVPIQA=
Received: from 30.120.185.40(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WLRjxIY_1734185298 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 14 Dec 2024 22:08:18 +0800
Message-ID: <de8c793d-124c-4906-9c44-22fa522b57c6@linux.alibaba.com>
Date: Sat, 14 Dec 2024 22:08:17 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/23] ocfs2: Pass mmap_folio around instead of mmap_page
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, Mark Tinguely <mark.tinguely@oracle.com>
References: <20241205171653.3179945-1-willy@infradead.org>
 <20241205171653.3179945-7-willy@infradead.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241205171653.3179945-7-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024/12/6 01:16, Matthew Wilcox (Oracle) wrote:
> Saves a few hidden calls to compound_head() and accesses to
> page->mapping.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/aops.c | 37 ++++++++++++++++++-------------------
>  fs/ocfs2/aops.h |  6 +++---
>  fs/ocfs2/mmap.c |  2 +-
>  3 files changed, 22 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index c5e9c3462b84..aac644a0d25d 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -1023,7 +1023,7 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
>  				      struct ocfs2_write_ctxt *wc,
>  				      u32 cpos, loff_t user_pos,
>  				      unsigned user_len, int new,
> -				      struct page *mmap_page)
> +				      struct folio *mmap_folio)
>  {
>  	int ret = 0, i;
>  	unsigned long start, target_index, end_index, index;
> @@ -1068,18 +1068,18 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
>  			 * and wants us to directly use the page
>  			 * passed in.
>  			 */
> -			lock_page(mmap_page);
> +			folio_lock(mmap_folio);
>  
>  			/* Exit and let the caller retry */
> -			if (mmap_page->mapping != mapping) {
> -				WARN_ON(mmap_page->mapping);
> -				unlock_page(mmap_page);
> +			if (mmap_folio->mapping != mapping) {
> +				WARN_ON(mmap_folio->mapping);
> +				folio_unlock(mmap_folio);
>  				ret = -EAGAIN;
>  				goto out;
>  			}
>  
> -			get_page(mmap_page);
> -			wc->w_pages[i] = mmap_page;
> +			folio_get(mmap_folio);
> +			wc->w_pages[i] = &mmap_folio->page;
>  			wc->w_target_locked = true;
>  		} else if (index >= target_index && index <= end_index &&
>  			   wc->w_type == OCFS2_WRITE_DIRECT) {
> @@ -1536,9 +1536,8 @@ int ocfs2_size_fits_inline_data(struct buffer_head *di_bh, u64 new_size)
>  }
>  
>  static int ocfs2_try_to_write_inline_data(struct address_space *mapping,
> -					  struct inode *inode, loff_t pos,
> -					  unsigned len, struct page *mmap_page,
> -					  struct ocfs2_write_ctxt *wc)
> +		struct inode *inode, loff_t pos, size_t len,
> +		struct folio *mmap_folio, struct ocfs2_write_ctxt *wc)
>  {
>  	int ret, written = 0;
>  	loff_t end = pos + len;
> @@ -1553,7 +1552,7 @@ static int ocfs2_try_to_write_inline_data(struct address_space *mapping,
>  	 * Handle inodes which already have inline data 1st.
>  	 */
>  	if (oi->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
> -		if (mmap_page == NULL &&
> +		if (mmap_folio == NULL &&
>  		    ocfs2_size_fits_inline_data(wc->w_di_bh, end))
>  			goto do_inline_write;
>  
> @@ -1577,7 +1576,7 @@ static int ocfs2_try_to_write_inline_data(struct address_space *mapping,
>  	 * Check whether the write can fit.
>  	 */
>  	di = (struct ocfs2_dinode *)wc->w_di_bh->b_data;
> -	if (mmap_page ||
> +	if (mmap_folio ||
>  	    end > ocfs2_max_inline_data_with_xattr(inode->i_sb, di))
>  		return 0;
>  
> @@ -1644,9 +1643,9 @@ static int ocfs2_zero_tail(struct inode *inode, struct buffer_head *di_bh,
>  }
>  
>  int ocfs2_write_begin_nolock(struct address_space *mapping,
> -			     loff_t pos, unsigned len, ocfs2_write_type_t type,
> -			     struct folio **foliop, void **fsdata,
> -			     struct buffer_head *di_bh, struct page *mmap_page)
> +		loff_t pos, unsigned len, ocfs2_write_type_t type,
> +		struct folio **foliop, void **fsdata,
> +		struct buffer_head *di_bh, struct folio *mmap_folio)
>  {
>  	int ret, cluster_of_pages, credits = OCFS2_INODE_UPDATE_CREDITS;
>  	unsigned int clusters_to_alloc, extents_to_split, clusters_need = 0;
> @@ -1669,7 +1668,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
>  
>  	if (ocfs2_supports_inline_data(osb)) {
>  		ret = ocfs2_try_to_write_inline_data(mapping, inode, pos, len,
> -						     mmap_page, wc);
> +						     mmap_folio, wc);
>  		if (ret == 1) {
>  			ret = 0;
>  			goto success;
> @@ -1721,7 +1720,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
>  			(unsigned long long)OCFS2_I(inode)->ip_blkno,
>  			(long long)i_size_read(inode),
>  			le32_to_cpu(di->i_clusters),
> -			pos, len, type, mmap_page,
> +			pos, len, type, mmap_folio,
>  			clusters_to_alloc, extents_to_split);
>  
>  	/*
> @@ -1797,7 +1796,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
>  	 * extent.
>  	 */
>  	ret = ocfs2_grab_pages_for_write(mapping, wc, wc->w_cpos, pos, len,
> -					 cluster_of_pages, mmap_page);
> +					 cluster_of_pages, mmap_folio);
>  	if (ret) {
>  		/*
>  		 * ocfs2_grab_pages_for_write() returns -EAGAIN if it could not lock
> @@ -1848,7 +1847,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
>  	 * to VM code.
>  	 */
>  	if (wc->w_target_locked)
> -		unlock_page(mmap_page);
> +		folio_unlock(mmap_folio);
>  
>  	ocfs2_free_write_ctxt(inode, wc);
>  
> diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
> index 1d1b4b7edba0..1cb46072ad84 100644
> --- a/fs/ocfs2/aops.h
> +++ b/fs/ocfs2/aops.h
> @@ -37,9 +37,9 @@ typedef enum {
>  } ocfs2_write_type_t;
>  
>  int ocfs2_write_begin_nolock(struct address_space *mapping,
> -			     loff_t pos, unsigned len, ocfs2_write_type_t type,
> -			     struct folio **foliop, void **fsdata,
> -			     struct buffer_head *di_bh, struct page *mmap_page);
> +		loff_t pos, unsigned len, ocfs2_write_type_t type,
> +		struct folio **foliop, void **fsdata,
> +		struct buffer_head *di_bh, struct folio *mmap_folio);
>  
>  int ocfs2_read_inline_data(struct inode *inode, struct page *page,
>  			   struct buffer_head *di_bh);
> diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
> index 93b886f16c40..6a314e9f2b49 100644
> --- a/fs/ocfs2/mmap.c
> +++ b/fs/ocfs2/mmap.c
> @@ -91,7 +91,7 @@ static vm_fault_t __ocfs2_page_mkwrite(struct file *file,
>  		len = ((size - 1) & ~PAGE_MASK) + 1;
>  
>  	err = ocfs2_write_begin_nolock(mapping, pos, len, OCFS2_WRITE_MMAP,
> -				       &locked_folio, &fsdata, di_bh, &folio->page);
> +				       &locked_folio, &fsdata, di_bh, folio);
>  	if (err) {
>  		if (err != -ENOSPC)
>  			mlog_errno(err);

