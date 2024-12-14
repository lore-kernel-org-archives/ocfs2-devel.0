Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28ECD53C
	for <ocfs2-devel@lists.linux.dev>; Sat, 14 Dec 2024 14:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734185346; cv=none; b=DOKmQFVAMycAKuoFTJoUzmmIg4l0w6vEIpg1esfs8dCdwurisuODFWpeNxYu2MaeIuvPh+ISimjwQX36JHG77LJp0WvbXJTUxRcTKmGgIbr0OsXdJeV/cIxqTWlho+WDPwriNegCexc/vnowll2riq4g1ZTM+j7U4LYs7XVMTW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734185346; c=relaxed/simple;
	bh=0lGojVxo5XH25MYfuSYVjas1WNSa2TTOa1ZAag18opI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EijLdmxOVCtrE9msKeSUbUQDpHed4wcd0ZmYJls5u0YWSszmOy+lxeiZ77dFTeRWkUGJQsdbgwzLUp6fEWPOg5oABCy1Awqm3YIhmyvVNbBayQxirC1YBMraJeBPsxr0NhC9riF5kvVRg8bq7/X9igubcYl9SASkN0dfbMXiTUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=dycj0c8I; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="dycj0c8I"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734185341; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=FFfUJEid6t2Q+X5lpTNnDb5Cwg9LaWWvPeaN1iwsWGQ=;
	b=dycj0c8IiCLCATIz71HStLirZluVTH/nF+9VM4JBgUs/KmiFCr+tBG/wsVVNsZBTidfpA0ip/I6komLseRm9y1bVBZNm2bTE8YwK/BQVRQDsuKcmKDp+fueOV0moC0UteSbgD6Ec3Uu9OrPInRNI068RjamlsQKIvFTFncFoKPs=
Received: from 30.120.185.40(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WLRjCTv_1734185339 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 14 Dec 2024 22:09:00 +0800
Message-ID: <970aecd3-0c0c-4ddd-9b76-d2f26f5f1bc1@linux.alibaba.com>
Date: Sat, 14 Dec 2024 22:08:59 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/23] ocfs2: Convert ocfs2_readpage_inline() to take a
 folio
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 akpm <akpm@linux-foundation.org>
Cc: Mark Tinguely <mark.tinguely@oracle.com>, ocfs2-devel@lists.linux.dev
References: <20241205171653.3179945-1-willy@infradead.org>
 <20241205171653.3179945-8-willy@infradead.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241205171653.3179945-8-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024/12/6 01:16, Matthew Wilcox (Oracle) wrote:
> From: Mark Tinguely <mark.tinguely@oracle.com>
> 
> Save a couple of calls to compound_head() by using a folio throughout
> this function.
> 
> Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/aops.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index aac644a0d25d..1896a1d24173 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -252,12 +252,12 @@ int ocfs2_read_inline_data(struct inode *inode, struct page *page,
>  	return 0;
>  }
>  
> -static int ocfs2_readpage_inline(struct inode *inode, struct page *page)
> +static int ocfs2_readpage_inline(struct inode *inode, struct folio *folio)
>  {
>  	int ret;
>  	struct buffer_head *di_bh = NULL;
>  
> -	BUG_ON(!PageLocked(page));
> +	BUG_ON(!folio_test_locked(folio));
>  	BUG_ON(!(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL));
>  
>  	ret = ocfs2_read_inode_block(inode, &di_bh);
> @@ -266,9 +266,9 @@ static int ocfs2_readpage_inline(struct inode *inode, struct page *page)
>  		goto out;
>  	}
>  
> -	ret = ocfs2_read_inline_data(inode, page, di_bh);
> +	ret = ocfs2_read_inline_data(inode, &folio->page, di_bh);
>  out:
> -	unlock_page(page);
> +	folio_unlock(folio);
>  
>  	brelse(di_bh);
>  	return ret;
> @@ -322,7 +322,7 @@ static int ocfs2_read_folio(struct file *file, struct folio *folio)
>  	}
>  
>  	if (oi->ip_dyn_features & OCFS2_INLINE_DATA_FL)
> -		ret = ocfs2_readpage_inline(inode, &folio->page);
> +		ret = ocfs2_readpage_inline(inode, folio);
>  	else
>  		ret = block_read_full_folio(folio, ocfs2_get_block);
>  	unlock = 0;

