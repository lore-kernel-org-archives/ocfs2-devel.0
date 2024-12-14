Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D07169397
	for <ocfs2-devel@lists.linux.dev>; Sat, 14 Dec 2024 14:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734186452; cv=none; b=cpGMMGKalRYRPpTB+dg7F6kYGqpEARCkMfNNkSn+hqudHZB7i49JS13rhtqoo6ICtasGBisefrifgW4Sly9+9QZOq9zlGs/8gL+bc37IukNH9P/Dc3IZS6XzSU+7fW0qOm4W0yyTrtmeRjy0sOQHQNiVaBx7tOasOJrzcqdIoZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734186452; c=relaxed/simple;
	bh=KDVxLt/GsTnlfWeYankEVSvxgsCRI6R+k8ub+mnVDG8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mI96Vcdkk2d/TlMgid+t9Sy8OGJ1XEn8xgsRSaMA07x3T75fdkdN1LlYbjxsiC4O4XNc1RpPYWTQQ9paIwKo/xPj5cHKcQ6KKhQCHlRfYbytI7AcZ6/sEXsfycN07KCCjAvRGqWO9CsEfHhV2hw3UDkbcES4jJ3bi+mUxnTVugM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ZBVU6Cy6; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ZBVU6Cy6"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734186447; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=XRTyzy7W+aWGylQTP/aKc0d1b4h1y47oDI1ZQkaO/TY=;
	b=ZBVU6Cy6hzBs9cKiKDehtbp7Ud3H1P5rctzJEUm2iEanlIztzITvlfXdkJquD/AofDneAV6JH6ThqPGjfaSrMP+vnPl92e7y3AWA/6umu8v5OFCqvWT+n7LQAyxURBnc6XkJRxdZjf5y3FmiE81dSVtOh9UCDBzqPjBmuynFHLs=
Received: from 30.120.185.40(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WLRjGdk_1734186446 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 14 Dec 2024 22:27:26 +0800
Message-ID: <f220464e-892f-4636-9d93-24b0ea38580e@linux.alibaba.com>
Date: Sat, 14 Dec 2024 22:27:25 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/23] ocfs2: Use a folio in ocfs2_map_and_dirty_page()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 akpm <akpm@linux-foundation.org>
Cc: Mark Tinguely <mark.tinguely@oracle.com>, ocfs2-devel@lists.linux.dev
References: <20241205171653.3179945-1-willy@infradead.org>
 <20241205171653.3179945-14-willy@infradead.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241205171653.3179945-14-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024/12/6 01:16, Matthew Wilcox (Oracle) wrote:
> From: Mark Tinguely <mark.tinguely@oracle.com>
> 
> Convert the incoming page to a folio and use it throughout the
> function.  Removes a couple of calls to compound_head().
> 
> Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/alloc.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 395e23920632..e95fe65b6a74 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -6812,8 +6812,9 @@ void ocfs2_map_and_dirty_page(struct inode *inode, handle_t *handle,
>  			      unsigned int from, unsigned int to,
>  			      struct page *page, int zero, u64 *phys)
>  {
> +	struct folio *folio = page_folio(page);
>  	int ret, partial = 0;
> -	loff_t start_byte = ((loff_t)page->index << PAGE_SHIFT) + from;
> +	loff_t start_byte = folio_pos(folio) + from;
>  	loff_t length = to - from;
>  
>  	ret = ocfs2_map_page_blocks(page, phys, inode, from, to, 0);
> @@ -6821,14 +6822,14 @@ void ocfs2_map_and_dirty_page(struct inode *inode, handle_t *handle,
>  		mlog_errno(ret);
>  
>  	if (zero)
> -		zero_user_segment(page, from, to);
> +		folio_zero_segment(folio, from, to);
>  
>  	/*
>  	 * Need to set the buffers we zero'd into uptodate
>  	 * here if they aren't - ocfs2_map_page_blocks()
>  	 * might've skipped some
>  	 */
> -	ret = walk_page_buffers(handle, page_buffers(page),
> +	ret = walk_page_buffers(handle, folio_buffers(folio),
>  				from, to, &partial,
>  				ocfs2_zero_func);
>  	if (ret < 0)
> @@ -6841,9 +6842,9 @@ void ocfs2_map_and_dirty_page(struct inode *inode, handle_t *handle,
>  	}
>  
>  	if (!partial)
> -		SetPageUptodate(page);
> +		folio_mark_uptodate(folio);
>  
> -	flush_dcache_page(page);
> +	flush_dcache_folio(folio);
>  }
>  
>  static void ocfs2_zero_cluster_pages(struct inode *inode, loff_t start,

