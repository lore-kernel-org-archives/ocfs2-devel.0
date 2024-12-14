Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B858A192B73
	for <ocfs2-devel@lists.linux.dev>; Sat, 14 Dec 2024 14:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734187493; cv=none; b=V/cuBpD+s1p7C8CMRJezLlAEZGzhGLkMYIPNol2WbeufpV2BjLodZb1j4SQN7jJ4v4Or0fsJwojhNBXaM6eVRORZtRossI7f9HdfmlhbMFMNhJppPV/fse8cxMb3GhDAVbi4gtnJ05rk2nk1z5dsrjaqsIbnZ7krukMF4Zl3nD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734187493; c=relaxed/simple;
	bh=CTiTWqlpIkuDiztSxQrQo/8WqXBBy78Eau/kxo7FYTQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CSbHOqUKUI0FVVKeAPpVQ+xiFvqwIr5GOQzkWcHc+WxSv00IeOGiNpEI+OqyHc8e9or6o5YthXso6xhOYl5mPUfAMZjhVGpiNpETDNSCLgyfvzIsfLqplc8vqouc00NQGIHAFB1UxcJxcjVCTzYK9uLYxFqp6SHRSU1zyFdqRUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=WnzDREMd; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="WnzDREMd"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734187488; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=iiX/4ucw6S+ingsnyyLdP8+jR+ZTyB40QZdKLeQOWXY=;
	b=WnzDREMdLevIPq2ubNWO9AdBzK9/h9ashQOyW7l8OYGL8xWF0GTLvgnIq3RJFQDdwUJOTxXmDgaIx0kCsJKoaYdIca3UH037MSUjNE1DK6M6ACIf3y8BDcnR4A6Uv+AmPGV1Pc6jmKQmXHEKKEPlX7yU3g8UrMSueh2Ric0Odhs=
Received: from 30.120.185.40(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WLRryoQ_1734187486 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 14 Dec 2024 22:44:47 +0800
Message-ID: <eafd2282-d46a-4a01-b48f-132411c6fbbf@linux.alibaba.com>
Date: Sat, 14 Dec 2024 22:44:46 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 21/23] ocfs2: Remove ocfs2_start_walk_page_trans()
 prototype
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, Mark Tinguely <mark.tinguely@oracle.com>
References: <20241205171653.3179945-1-willy@infradead.org>
 <20241205171653.3179945-22-willy@infradead.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241205171653.3179945-22-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024/12/6 01:16, Matthew Wilcox (Oracle) wrote:
> This function no longer exists.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/aops.h | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
> index 6f25066e5756..114efc9111e4 100644
> --- a/fs/ocfs2/aops.h
> +++ b/fs/ocfs2/aops.h
> @@ -8,11 +8,6 @@
>  
>  #include <linux/fs.h>
>  
> -handle_t *ocfs2_start_walk_page_trans(struct inode *inode,
> -							 struct page *page,
> -							 unsigned from,
> -							 unsigned to);
> -
>  int ocfs2_map_folio_blocks(struct folio *folio, u64 *p_blkno,
>  			  struct inode *inode, unsigned int from,
>  			  unsigned int to, int new);

