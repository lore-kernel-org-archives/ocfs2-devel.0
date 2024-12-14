Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C238B191F89
	for <ocfs2-devel@lists.linux.dev>; Sat, 14 Dec 2024 14:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734186512; cv=none; b=jt+na2WaNLKcsxLzd+983H3maxrX8pjDTgqM8GfryVserIm1PEE6GUXvQuqD28w+d+A+YswrcE36R7rRtHEAV8zGd+6BuX6+4PD0EWCcYqtC6d4Q8RUHX4DMbhDBWbfWkBDaEoz8T1WEwBLm6YDgbkEWa/3AW/WvKWs6cJboAPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734186512; c=relaxed/simple;
	bh=kkWb8r/XAUS6ILYxXiz8rLvgNlZ5cds1EOnTDUGJ5w4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g+WuYfuYRRR+B/wTxaB6k3LVNaNzOynyu/UZsH81JcYVJmMZl9KBVx/kUkoZ8wtPohBRVtH/3inxIbxHR8VCkvnWrGVIwvB56za7CcjZC6KSAqCvsI8YKJSC3cqeoqPWy2iVk8qoak6EZvJy5qvqKJ8rOYSqecvYW24SnlHYaZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=s7P9blLM; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="s7P9blLM"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734186506; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=7XE2gJHrUnjytBNk4XK5cBnDebe4eOllL4XKdCmng+I=;
	b=s7P9blLMDNZRrubmzYf+FhGo9kD/aFqxBvXd/7GhXD9qmnWw8y2ma1TrtHW0zf636lRwR4ttigKLpbsdNtaDAyOGlJna5m+/U+ujwYlc01czqz8W41L7dzvm+A9oWbH5bgOMCnTVnftgyYfUWnd8Xmm0v9Sd7catRx2fKmhaGmU=
Received: from 30.120.185.40(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WLRk.fm_1734186505 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 14 Dec 2024 22:28:25 +0800
Message-ID: <149c3cd4-bbe9-46b3-857c-f77dc4d36619@linux.alibaba.com>
Date: Sat, 14 Dec 2024 22:28:25 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/23] ocfs2: Convert ocfs2_map_page_blocks() to
 ocfs2_map_folio_blocks()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 akpm <akpm@linux-foundation.org>
Cc: Mark Tinguely <mark.tinguely@oracle.com>, ocfs2-devel@lists.linux.dev
References: <20241205171653.3179945-1-willy@infradead.org>
 <20241205171653.3179945-15-willy@infradead.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241205171653.3179945-15-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024/12/6 01:16, Matthew Wilcox (Oracle) wrote:
> From: Mark Tinguely <mark.tinguely@oracle.com>
> 
> All callers now have a folio, so pass it in instead of converting
> folio->page->folio.
> 
> Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/alloc.c |  2 +-
>  fs/ocfs2/aops.c  | 18 ++++++++----------
>  fs/ocfs2/aops.h  |  2 +-
>  3 files changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index e95fe65b6a74..cfe9535a27f9 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -6817,7 +6817,7 @@ void ocfs2_map_and_dirty_page(struct inode *inode, handle_t *handle,
>  	loff_t start_byte = folio_pos(folio) + from;
>  	loff_t length = to - from;
>  
> -	ret = ocfs2_map_page_blocks(page, phys, inode, from, to, 0);
> +	ret = ocfs2_map_folio_blocks(folio, phys, inode, from, to, 0);
>  	if (ret)
>  		mlog_errno(ret);
>  
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 9ce8debbd282..cbc8bc6d95f3 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -560,7 +560,7 @@ static void ocfs2_clear_page_regions(struct page *page,
>  /*
>   * Nonsparse file systems fully allocate before we get to the write
>   * code. This prevents ocfs2_write() from tagging the write as an
> - * allocating one, which means ocfs2_map_page_blocks() might try to
> + * allocating one, which means ocfs2_map_folio_blocks() might try to
>   * read-in the blocks at the tail of our file. Avoid reading them by
>   * testing i_size against each block offset.
>   */
> @@ -585,11 +585,10 @@ static int ocfs2_should_read_blk(struct inode *inode, struct folio *folio,
>   *
>   * This will also skip zeroing, which is handled externally.
>   */
> -int ocfs2_map_page_blocks(struct page *page, u64 *p_blkno,
> +int ocfs2_map_folio_blocks(struct folio *folio, u64 *p_blkno,
>  			  struct inode *inode, unsigned int from,
>  			  unsigned int to, int new)
>  {
> -	struct folio *folio = page_folio(page);
>  	int ret = 0;
>  	struct buffer_head *head, *bh, *wait[2], **wait_bh = wait;
>  	unsigned int block_end, block_start;
> @@ -971,12 +970,11 @@ static int ocfs2_prepare_folio_for_write(struct inode *inode, u64 *p_blkno,
>  		map_to = map_from + user_len;
>  
>  		if (new)
> -			ret = ocfs2_map_page_blocks(page, p_blkno, inode,
> -						    cluster_start, cluster_end,
> -						    new);
> +			ret = ocfs2_map_folio_blocks(folio, p_blkno, inode,
> +					cluster_start, cluster_end, new);
>  		else
> -			ret = ocfs2_map_page_blocks(page, p_blkno, inode,
> -						    map_from, map_to, new);
> +			ret = ocfs2_map_folio_blocks(folio, p_blkno, inode,
> +					map_from, map_to, new);
>  		if (ret) {
>  			mlog_errno(ret);
>  			goto out;
> @@ -999,8 +997,8 @@ static int ocfs2_prepare_folio_for_write(struct inode *inode, u64 *p_blkno,
>  		map_from = cluster_start;
>  		map_to = cluster_end;
>  
> -		ret = ocfs2_map_page_blocks(page, p_blkno, inode,
> -					    cluster_start, cluster_end, new);
> +		ret = ocfs2_map_folio_blocks(folio, p_blkno, inode,
> +				cluster_start, cluster_end, new);
>  		if (ret) {
>  			mlog_errno(ret);
>  			goto out;
> diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
> index dcf4b0dc82c4..17ca359c6051 100644
> --- a/fs/ocfs2/aops.h
> +++ b/fs/ocfs2/aops.h
> @@ -13,7 +13,7 @@ handle_t *ocfs2_start_walk_page_trans(struct inode *inode,
>  							 unsigned from,
>  							 unsigned to);
>  
> -int ocfs2_map_page_blocks(struct page *page, u64 *p_blkno,
> +int ocfs2_map_folio_blocks(struct folio *folio, u64 *p_blkno,
>  			  struct inode *inode, unsigned int from,
>  			  unsigned int to, int new);
>  

