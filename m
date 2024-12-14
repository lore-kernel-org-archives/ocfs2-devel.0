Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECAB188006
	for <ocfs2-devel@lists.linux.dev>; Sat, 14 Dec 2024 14:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734186977; cv=none; b=Nnw7/Y6yQRZxZ7XrpGrEStSBSp3QjSZuMeGHsjD3EMhBVvbGIn187IvgbzkZ2qUPSqIOUen/yHDb//D9+9bf6261aMa8IY35FCAMtzlQmDNQssOZ+4v8uOG5T3YeU6BlZSL6DcE7IO1BKLH/lEbJxv7ZLbxBolaawj0Rxm/Yztg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734186977; c=relaxed/simple;
	bh=1T1EpD01x1CUn5cn/HhS5895YLhJyZRhOFJRTvvuJHg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BW60520HaNaFfoKd1QVUk4Cx76U5WxipCCS92E0t0ITlC8W2JI/i0J1StmZwL8HEwta8OL5o4d4VaUABBWpbyfFnPZM3E5tC16wdR7xBw62MeSbDvqhtJLfQLgc/lUwnDWualJgobs3+AhbJ7eCS6Aqpa841OJm+bgkWl/0WoD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=j54tk/TR; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="j54tk/TR"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734186970; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=LXvDSzeUCTv6G393wrv9CRLb6EAnnI5ttzdsu/qrAlY=;
	b=j54tk/TRKNSRcALkgPzgCe1GKU8YXB9VrQZvrc5wERkWh3zp8HckYqSiTNrw4eRPWteAatpDsWmQA/soHfCXGBnZRRV57Z4v+Tmu5OVCW0vpgrRAm0yUJnwXdX1jLo1xfAYV3HydpAaVzHMUeu6vQU9qV3MCMAHByVwbfk4CDuA=
Received: from 30.120.185.40(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WLRrBpN_1734186969 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 14 Dec 2024 22:36:09 +0800
Message-ID: <24030fb7-d95e-4958-b473-b29fc08b4cf4@linux.alibaba.com>
Date: Sat, 14 Dec 2024 22:36:08 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/23] ocfs2: Convert ocfs2_duplicate_clusters_by_page()
 to use a folio
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 akpm <akpm@linux-foundation.org>
Cc: Mark Tinguely <mark.tinguely@oracle.com>, ocfs2-devel@lists.linux.dev
References: <20241205171653.3179945-1-willy@infradead.org>
 <20241205171653.3179945-18-willy@infradead.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241205171653.3179945-18-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024/12/6 01:16, Matthew Wilcox (Oracle) wrote:
> From: Mark Tinguely <mark.tinguely@oracle.com>
> 
> Retrieve folios from the page cache, not pages, and use a folio
> throughout this function.  Removes seven calls to compound_head().
> 
> Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/refcounttree.c | 32 +++++++++++++++-----------------
>  1 file changed, 15 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index 004393b13c0a..68e0339690e9 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -2902,7 +2902,6 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
>  	int ret = 0, partial;
>  	struct super_block *sb = inode->i_sb;
>  	u64 new_block = ocfs2_clusters_to_blocks(sb, new_cluster);
> -	struct page *page;
>  	pgoff_t page_index;
>  	unsigned int from, to;
>  	loff_t offset, end, map_end;
> @@ -2921,6 +2920,7 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
>  		end = i_size_read(inode);
>  
>  	while (offset < end) {
> +		struct folio *folio;
>  		page_index = offset >> PAGE_SHIFT;
>  		map_end = ((loff_t)page_index + 1) << PAGE_SHIFT;
>  		if (map_end > end)
> @@ -2933,9 +2933,10 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
>  			to = map_end & (PAGE_SIZE - 1);
>  
>  retry:
> -		page = find_or_create_page(mapping, page_index, GFP_NOFS);
> -		if (!page) {
> -			ret = -ENOMEM;
> +		folio = __filemap_get_folio(mapping, page_index,
> +				FGP_LOCK | FGP_ACCESSED | FGP_CREAT, GFP_NOFS);
> +		if (IS_ERR(folio)) {
> +			ret = PTR_ERR(folio);
>  			mlog_errno(ret);
>  			break;
>  		}
> @@ -2945,9 +2946,9 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
>  		 * page, so write it back.
>  		 */
>  		if (PAGE_SIZE <= OCFS2_SB(sb)->s_clustersize) {
> -			if (PageDirty(page)) {
> -				unlock_page(page);
> -				put_page(page);
> +			if (folio_test_dirty(folio)) {
> +				folio_unlock(folio);
> +				folio_put(folio);
>  
>  				ret = filemap_write_and_wait_range(mapping,
>  						offset, map_end - 1);
> @@ -2955,9 +2956,7 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
>  			}
>  		}
>  
> -		if (!PageUptodate(page)) {
> -			struct folio *folio = page_folio(page);
> -
> +		if (!folio_test_uptodate(folio)) {
>  			ret = block_read_full_folio(folio, ocfs2_get_block);
>  			if (ret) {
>  				mlog_errno(ret);
> @@ -2966,8 +2965,8 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
>  			folio_lock(folio);
>  		}
>  
> -		if (page_has_buffers(page)) {
> -			ret = walk_page_buffers(handle, page_buffers(page),
> +		if (folio_buffers(folio)) {
> +			ret = walk_page_buffers(handle, folio_buffers(folio),
>  						from, to, &partial,
>  						ocfs2_clear_cow_buffer);
>  			if (ret) {
> @@ -2978,12 +2977,11 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
>  
>  		ocfs2_map_and_dirty_page(inode,
>  					 handle, from, to,
> -					 page, 0, &new_block);
> -		mark_page_accessed(page);
> +					 &folio->page, 0, &new_block);
> +		folio_mark_accessed(folio);
>  unlock:
> -		unlock_page(page);
> -		put_page(page);
> -		page = NULL;
> +		folio_unlock(folio);
> +		folio_put(folio);
>  		offset = map_end;
>  		if (ret)
>  			break;

