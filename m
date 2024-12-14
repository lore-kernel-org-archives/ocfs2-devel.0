Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E716A193429
	for <ocfs2-devel@lists.linux.dev>; Sat, 14 Dec 2024 14:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734187427; cv=none; b=uA4ngD+tOek+5reX3B2dV8HgYaykug3Dqs5nvUPzu06yU1N+ZUth1IBR1cOm7IM4yDR6c0xH2d+OLTSDcgZGRdPsTF27ct2aY0nXQP0WYZLXHk1m6lkKF55p3dHq76ey+oAVMfZ7B4eUDcfgnQSF7NS8N2LUInBWtYEeOp41O2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734187427; c=relaxed/simple;
	bh=AtC6cAWNfOjYuY5rBEUsgBN4u2QGyRo0hXGU2nmo2HM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UiyZtzUap/XUWf8uXKOvaB3QdptopGNVKDpGB3Je2hDW5PnxQYmaOL4Y8e6J8D6cgpiE4WTHvE+rSzBvmem9my5srUCZZdPFsnApdrMyP7+BpvInwYdan6rGTSxvYwUSwHE/qeDBb3GECA7VqI/TuhU18NYDvMdKIuwb0daV4mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=gcilJ3JI; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="gcilJ3JI"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734187421; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=JCJ9eOE4z83n2tuGoX2tA4yDfRD1Cw2s1dWXdgK0zXU=;
	b=gcilJ3JILHw6zsCaXLiuZ4305eA/k60iWRUDcClh5PQ4E45HyfqV1yvb/PTyPq/mbn/tySu9Tu8Ka6IZoI8147lrzRJQbcCluJb7uufSjwgWetBsmd2MQHpjJtQ/tIEr6okk7+Sgi62QuFJTJ+K5qH/QOtCw3qJNu5+bqyQ2guI=
Received: from 30.120.185.40(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WLRk2lK_1734187419 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 14 Dec 2024 22:43:40 +0800
Message-ID: <5f6fdb83-7f86-4947-b56e-5cf479ccd718@linux.alibaba.com>
Date: Sat, 14 Dec 2024 22:43:38 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 20/23] ocfs2: Use a folio in
 ocfs2_fast_symlink_read_folio()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, Mark Tinguely <mark.tinguely@oracle.com>
References: <20241205171653.3179945-1-willy@infradead.org>
 <20241205171653.3179945-21-willy@infradead.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241205171653.3179945-21-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024/12/6 01:16, Matthew Wilcox (Oracle) wrote:
> Use folio_end_read() instead of SetPageUptodate() and unlock_page().
> Use memcpy_to_folio() instead of open-coding a kmap_atomic() sequence.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/symlink.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ocfs2/symlink.c b/fs/ocfs2/symlink.c
> index f5cf2255dc09..ad8be3300b49 100644
> --- a/fs/ocfs2/symlink.c
> +++ b/fs/ocfs2/symlink.c
> @@ -54,13 +54,11 @@
>  
>  static int ocfs2_fast_symlink_read_folio(struct file *f, struct folio *folio)
>  {
> -	struct page *page = &folio->page;
> -	struct inode *inode = page->mapping->host;
> +	struct inode *inode = folio->mapping->host;
>  	struct buffer_head *bh = NULL;
>  	int status = ocfs2_read_inode_block(inode, &bh);
>  	struct ocfs2_dinode *fe;
>  	const char *link;
> -	void *kaddr;
>  	size_t len;
>  
>  	if (status < 0) {
> @@ -72,12 +70,9 @@ static int ocfs2_fast_symlink_read_folio(struct file *f, struct folio *folio)
>  	link = (char *) fe->id2.i_symlink;
>  	/* will be less than a page size */
>  	len = strnlen(link, ocfs2_fast_symlink_chars(inode->i_sb));
> -	kaddr = kmap_atomic(page);
> -	memcpy(kaddr, link, len + 1);
> -	kunmap_atomic(kaddr);
> -	SetPageUptodate(page);
> +	memcpy_to_folio(folio, 0, link, len + 1);
>  out:
> -	unlock_page(page);
> +	folio_end_read(folio, status == 0);
>  	brelse(bh);
>  	return status;
>  }

