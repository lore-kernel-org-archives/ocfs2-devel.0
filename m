Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEC2D53C
	for <ocfs2-devel@lists.linux.dev>; Sat, 14 Dec 2024 14:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734185417; cv=none; b=EG+jwVUQSm0Rgj/rowk8Px14kvEbWGJyhGr0r42yBiHk6oCqtizWCLFQLwoutTzcbm+58VOrTgU3IcgC7O4jEQGjwvG4gSmyoSyryIPT3s5OlFgipfGb0WI1gKVZoazTd3AHrCyLwLmqlXq/QkI9XH0G3Nl4aPBcCu6zls3QmZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734185417; c=relaxed/simple;
	bh=N2l0Tkxcnq/408IrAbdYvclnGFQ4uorARe4X+CW3lvc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LYXU4o6Fyw0ThQP8CKm+qxT59aT+Vw2pgy6+GY2VrSZmUgEJ/9o3iMbysS4LeQXTv9q4wWzwSpMf5uXI0gEcWg0B9O9L7AV7iFU1Ddlg9DiLO0lEjhOE+cBQZauuKAZl8l2BsTsd6GbzO1ccrvq4o6eQDuvx/7ddLIjedqAgGkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=V2IOir3j; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="V2IOir3j"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734185405; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=5Oz220WKFk/DHVnQ7+DBHRH5+g5oMgrGK2Ur9MOZjPQ=;
	b=V2IOir3jN9eehSJjlUGzISQ+gZ1gNxJ/uPw8flFEaucvyKuY6cu/nsg6ewT5jrNJ+nX/kWxFY2e04ZI+4NvydvOwxsGN1yoHdLFAaGt4KaWAixyIJ69ZSYyPiSowrc47D5Ws1aw9R/J/qQJ0sUf5MALEnwHnMg01IyGbAf54qLo=
Received: from 30.120.185.40(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WLReV03_1734185403 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 14 Dec 2024 22:10:04 +0800
Message-ID: <809c9259-8f74-4c00-80c8-0028285116e7@linux.alibaba.com>
Date: Sat, 14 Dec 2024 22:10:03 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/23] ocfs2: Convert ocfs2_inode_lock_with_page() to
 ocfs2_inode_lock_with_folio()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 akpm <akpm@linux-foundation.org>
Cc: Mark Tinguely <mark.tinguely@oracle.com>, ocfs2-devel@lists.linux.dev
References: <20241205171653.3179945-1-willy@infradead.org>
 <20241205171653.3179945-9-willy@infradead.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241205171653.3179945-9-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024/12/6 01:16, Matthew Wilcox (Oracle) wrote:
> From: Mark Tinguely <mark.tinguely@oracle.com>
> 
> Saves a hidden call to compound_head().
> 
> Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/aops.c    |  2 +-
>  fs/ocfs2/dlmglue.c | 18 ++++++++----------
>  fs/ocfs2/dlmglue.h |  6 ++----
>  3 files changed, 11 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 1896a1d24173..161f2dc00b00 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -283,7 +283,7 @@ static int ocfs2_read_folio(struct file *file, struct folio *folio)
>  
>  	trace_ocfs2_readpage((unsigned long long)oi->ip_blkno, folio->index);
>  
> -	ret = ocfs2_inode_lock_with_page(inode, NULL, 0, &folio->page);
> +	ret = ocfs2_inode_lock_with_folio(inode, NULL, 0, folio);
>  	if (ret != 0) {
>  		if (ret == AOP_TRUNCATED_PAGE)
>  			unlock = 0;
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 60df52e4c1f8..acebfa19ea6f 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -2529,30 +2529,28 @@ int ocfs2_inode_lock_full_nested(struct inode *inode,
>  
>  /*
>   * This is working around a lock inversion between tasks acquiring DLM
> - * locks while holding a page lock and the downconvert thread which
> - * blocks dlm lock acquiry while acquiring page locks.
> + * locks while holding a folio lock and the downconvert thread which
> + * blocks dlm lock acquiry while acquiring folio locks.
>   *
> - * ** These _with_page variantes are only intended to be called from aop
> - * methods that hold page locks and return a very specific *positive* error
> + * ** These _with_folio variantes are only intended to be called from aop
> + * methods that hold folio locks and return a very specific *positive* error
>   * code that aop methods pass up to the VFS -- test for errors with != 0. **
>   *
>   * The DLM is called such that it returns -EAGAIN if it would have
>   * blocked waiting for the downconvert thread.  In that case we unlock
> - * our page so the downconvert thread can make progress.  Once we've
> + * our folio so the downconvert thread can make progress.  Once we've
>   * done this we have to return AOP_TRUNCATED_PAGE so the aop method
>   * that called us can bubble that back up into the VFS who will then
>   * immediately retry the aop call.
>   */
> -int ocfs2_inode_lock_with_page(struct inode *inode,
> -			      struct buffer_head **ret_bh,
> -			      int ex,
> -			      struct page *page)
> +int ocfs2_inode_lock_with_folio(struct inode *inode,
> +		struct buffer_head **ret_bh, int ex, struct folio *folio)
>  {
>  	int ret;
>  
>  	ret = ocfs2_inode_lock_full(inode, ret_bh, ex, OCFS2_LOCK_NONBLOCK);
>  	if (ret == -EAGAIN) {
> -		unlock_page(page);
> +		folio_unlock(folio);
>  		/*
>  		 * If we can't get inode lock immediately, we should not return
>  		 * directly here, since this will lead to a softlockup problem.
> diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
> index e5da5809ed95..a3ebd7303ea2 100644
> --- a/fs/ocfs2/dlmglue.h
> +++ b/fs/ocfs2/dlmglue.h
> @@ -137,10 +137,8 @@ int ocfs2_inode_lock_full_nested(struct inode *inode,
>  			 int ex,
>  			 int arg_flags,
>  			 int subclass);
> -int ocfs2_inode_lock_with_page(struct inode *inode,
> -			      struct buffer_head **ret_bh,
> -			      int ex,
> -			      struct page *page);
> +int ocfs2_inode_lock_with_folio(struct inode *inode,
> +		struct buffer_head **ret_bh, int ex, struct folio *folio);
>  /* Variants without special locking class or flags */
>  #define ocfs2_inode_lock_full(i, r, e, f)\
>  		ocfs2_inode_lock_full_nested(i, r, e, f, OI_LS_NORMAL)

