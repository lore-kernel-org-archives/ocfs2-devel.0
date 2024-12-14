Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FE6EC0
	for <ocfs2-devel@lists.linux.dev>; Sat, 14 Dec 2024 14:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734187023; cv=none; b=A5mxSPUcQKrALduWQm1uRQnQpRznYYLo3e/Co1MMJFx8ZUokRlQ3mJBe9vdbVduPrYIwuHytjN7HGd4RngEXdd71ZQ/dM/+qxwcWjv0gfGnCRCkF2d7PrHE/myHa0N3rgFN6xru8dRCSvQZpx9riopEb1eewBpwLwQPSvHPHEcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734187023; c=relaxed/simple;
	bh=6VPeBfAtFnP3Nvn5xYQHDsYrIpHFJr77eMOSIR6w/mk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QNbvvuW7fpAO5rBtY1o2r9N5sSEJ/4TAQcPngxTZnq23CRBUOb1CbrSIOkb1IjmZE4D6Ngls23BOKh2T7WriyPwSPuA9o4S+m5hZgnEKyf0U9JCZe4ygf7qhsreAjBJrzVMWw/vtZFFEzHwhbfyFwXRHoPrq3wex1zZSMpqBnaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=TmIO5z2K; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="TmIO5z2K"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734187018; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=tmUrZf1Q9wrlBlZRf2lYuBG2X/SIv6o+wf8wRQzc+e4=;
	b=TmIO5z2KE66ZL8jZRaVQC7NQUVevplCzKlYeaF6mHDzXB9OsCGKCE4ffqEXvsnVQ3hsHLpRmJrpgiQjuRYrACrYd7dLgWjLnTA4FT4I49XVvdInf0CRUyQ7ZkCtygmIyG/FwGyRmpREKh0CshdmEgh/7xMz6GEMdhh1ps+gbeK0=
Received: from 30.120.185.40(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WLRphA6_1734187016 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 14 Dec 2024 22:36:57 +0800
Message-ID: <b1c3e7bc-f358-4317-9243-3de316ec4426@linux.alibaba.com>
Date: Sat, 14 Dec 2024 22:36:56 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 18/23] ocfs2: Convert ocfs2_map_and_dirty_page() to
 ocfs2_map_and_dirty_folio()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 akpm <akpm@linux-foundation.org>
Cc: Mark Tinguely <mark.tinguely@oracle.com>, ocfs2-devel@lists.linux.dev
References: <20241205171653.3179945-1-willy@infradead.org>
 <20241205171653.3179945-19-willy@infradead.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241205171653.3179945-19-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024/12/6 01:16, Matthew Wilcox (Oracle) wrote:
> From: Mark Tinguely <mark.tinguely@oracle.com>
> 
> All callers now have a folio, so skip the folio->page->folio conversion.
> 
> Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/alloc.c        | 17 ++++++++---------
>  fs/ocfs2/alloc.h        |  6 +++---
>  fs/ocfs2/refcounttree.c |  5 ++---
>  3 files changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index dfcdafc11377..c8d9d5e9a7fd 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -6808,11 +6808,10 @@ static int ocfs2_zero_func(handle_t *handle, struct buffer_head *bh)
>  	return 0;
>  }
>  
> -void ocfs2_map_and_dirty_page(struct inode *inode, handle_t *handle,
> -			      unsigned int from, unsigned int to,
> -			      struct page *page, int zero, u64 *phys)
> +void ocfs2_map_and_dirty_folio(struct inode *inode, handle_t *handle,
> +		size_t from, size_t to, struct folio *folio, int zero,
> +		u64 *phys)
>  {
> -	struct folio *folio = page_folio(page);
>  	int ret, partial = 0;
>  	loff_t start_byte = folio_pos(folio) + from;
>  	loff_t length = to - from;
> @@ -6871,8 +6870,8 @@ static void ocfs2_zero_cluster_folios(struct inode *inode, loff_t start,
>  		BUG_ON(from > PAGE_SIZE);
>  		BUG_ON(to > PAGE_SIZE);
>  
> -		ocfs2_map_and_dirty_page(inode, handle, from, to, &folio->page, 1,
> -					 &phys);
> +		ocfs2_map_and_dirty_folio(inode, handle, from, to, folio, 1,
> +				&phys);
>  
>  		start = (folio->index + 1) << PAGE_SHIFT;
>  	}
> @@ -7120,7 +7119,7 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
>  
>  		/*
>  		 * Save two copies, one for insert, and one that can
> -		 * be changed by ocfs2_map_and_dirty_page() below.
> +		 * be changed by ocfs2_map_and_dirty_folio() below.
>  		 */
>  		block = phys = ocfs2_clusters_to_blocks(inode->i_sb, bit_off);
>  
> @@ -7143,8 +7142,8 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
>  			goto out_unlock;
>  		}
>  
> -		ocfs2_map_and_dirty_page(inode, handle, 0, page_end, &folio->page, 0,
> -					 &phys);
> +		ocfs2_map_and_dirty_folio(inode, handle, 0, page_end, folio, 0,
> +				&phys);
>  	}
>  
>  	spin_lock(&oi->ip_lock);
> diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
> index 6a2aca1a062e..1c0c83362904 100644
> --- a/fs/ocfs2/alloc.h
> +++ b/fs/ocfs2/alloc.h
> @@ -254,9 +254,9 @@ static inline int ocfs2_is_empty_extent(struct ocfs2_extent_rec *rec)
>  	return !rec->e_leaf_clusters;
>  }
>  
> -void ocfs2_map_and_dirty_page(struct inode *inode, handle_t *handle,
> -			      unsigned int from, unsigned int to,
> -			      struct page *page, int zero, u64 *phys);
> +void ocfs2_map_and_dirty_folio(struct inode *inode, handle_t *handle,
> +		size_t from, size_t to, struct folio *folio, int zero,
> +		u64 *phys);
>  /*
>   * Structures which describe a path through a btree, and functions to
>   * manipulate them.
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index 68e0339690e9..693665a36855 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -2975,9 +2975,8 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
>  			}
>  		}
>  
> -		ocfs2_map_and_dirty_page(inode,
> -					 handle, from, to,
> -					 &folio->page, 0, &new_block);
> +		ocfs2_map_and_dirty_folio(inode, handle, from, to,
> +				folio, 0, &new_block);
>  		folio_mark_accessed(folio);
>  unlock:
>  		folio_unlock(folio);

