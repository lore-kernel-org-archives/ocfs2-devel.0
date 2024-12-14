Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20BD170A13
	for <ocfs2-devel@lists.linux.dev>; Sat, 14 Dec 2024 12:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734178872; cv=none; b=mbxqA8Zvv08AzXs6mCMMTodX/ialkvmM44KuW8aj1f+fzhhRlmiAZEWYgh7HiD0B5FvVUfnPtmCxzL2ZYfvZ3smLKELnL8vn1JY/KqRUEfQIPkJQMK+dWwjsQeXJ32TH5GcPF7zVxihflfBL7kQ4C8yyOCQuCZulO7wz05S6P2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734178872; c=relaxed/simple;
	bh=4Jexqe7NryxnwMnjjXJAsRHZtUyZL9o+oHMPDkUVZy0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UdJG3OyimSZQvWzpP7cgV/CzmWUx980gMxUeF3J9ZwHdusA4wkygAFqJYZx4QJFlW6VYTHxvvFjD1xCdATTe7oQJacAeb4CKjp7ONnJqnD2yjOyVALGmPHyL/tYon7xyXTmzmlnUXqW+HPLZOrr1dgKqtW3nP/DWcij794K1kOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=lgfgiJLu; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="lgfgiJLu"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734178859; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=fp/GLA+sOQovUTS0H0oK3gQ8qtnnChn3DnY9MbrIb4k=;
	b=lgfgiJLurwymLXDALRPXgJqPpGWQDs6iEFWqZKFdBPEng/Ixz1ZMnM2/5E0SpvAlpoz7r8Ox7gT9prZ1m82xbEHaplp+y/mRpG1iYkkkyjJv9BkSEBQ/xAvXPEazvhay/SumCgAdfsV5Sj2Ob0D7mpcz74MDiHkK2I18Bm534zQ=
Received: from 30.120.185.40(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WLRU608_1734178858 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 14 Dec 2024 20:20:59 +0800
Message-ID: <e311cbdd-24b8-4721-904c-1b788f4667f7@linux.alibaba.com>
Date: Sat, 14 Dec 2024 20:20:57 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/23] ocfs2: Convert ocfs2_page_mkwrite() to use a folio
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, Mark Tinguely <mark.tinguely@oracle.com>
References: <20241205171653.3179945-1-willy@infradead.org>
 <20241205171653.3179945-3-willy@infradead.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241205171653.3179945-3-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024/12/6 01:16, Matthew Wilcox (Oracle) wrote:
> Pass the folio into __ocfs2_page_mkwrite() and use it throughout.
> Does not attempt to support large folios.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/mmap.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
> index 6ef4cb045ccd..93b886f16c40 100644
> --- a/fs/ocfs2/mmap.c
> +++ b/fs/ocfs2/mmap.c
> @@ -44,13 +44,13 @@ static vm_fault_t ocfs2_fault(struct vm_fault *vmf)
>  }
>  
>  static vm_fault_t __ocfs2_page_mkwrite(struct file *file,
> -			struct buffer_head *di_bh, struct page *page)
> +			struct buffer_head *di_bh, struct folio *folio)
>  {
>  	int err;
>  	vm_fault_t ret = VM_FAULT_NOPAGE;
>  	struct inode *inode = file_inode(file);
>  	struct address_space *mapping = inode->i_mapping;
> -	loff_t pos = page_offset(page);
> +	loff_t pos = folio_pos(folio);
>  	unsigned int len = PAGE_SIZE;
>  	pgoff_t last_index;
>  	struct folio *locked_folio = NULL;
> @@ -72,9 +72,9 @@ static vm_fault_t __ocfs2_page_mkwrite(struct file *file,
>  	 *
>  	 * Let VM retry with these cases.
>  	 */
> -	if ((page->mapping != inode->i_mapping) ||
> -	    (!PageUptodate(page)) ||
> -	    (page_offset(page) >= size))
> +	if ((folio->mapping != inode->i_mapping) ||
> +	    !folio_test_uptodate(folio) ||
> +	    (pos >= size))
>  		goto out;
>  
>  	/*
> @@ -87,11 +87,11 @@ static vm_fault_t __ocfs2_page_mkwrite(struct file *file,
>  	 * worry about ocfs2_write_begin() skipping some buffer reads
>  	 * because the "write" would invalidate their data.
>  	 */
> -	if (page->index == last_index)
> +	if (folio->index == last_index)
>  		len = ((size - 1) & ~PAGE_MASK) + 1;
>  
>  	err = ocfs2_write_begin_nolock(mapping, pos, len, OCFS2_WRITE_MMAP,
> -				       &locked_folio, &fsdata, di_bh, page);
> +				       &locked_folio, &fsdata, di_bh, &folio->page);
>  	if (err) {
>  		if (err != -ENOSPC)
>  			mlog_errno(err);
> @@ -112,7 +112,7 @@ static vm_fault_t __ocfs2_page_mkwrite(struct file *file,
>  
>  static vm_fault_t ocfs2_page_mkwrite(struct vm_fault *vmf)
>  {
> -	struct page *page = vmf->page;
> +	struct folio *folio = page_folio(vmf->page);
>  	struct inode *inode = file_inode(vmf->vma->vm_file);
>  	struct buffer_head *di_bh = NULL;
>  	sigset_t oldset;
> @@ -141,7 +141,7 @@ static vm_fault_t ocfs2_page_mkwrite(struct vm_fault *vmf)
>  	 */
>  	down_write(&OCFS2_I(inode)->ip_alloc_sem);
>  
> -	ret = __ocfs2_page_mkwrite(vmf->vma->vm_file, di_bh, page);
> +	ret = __ocfs2_page_mkwrite(vmf->vma->vm_file, di_bh, folio);
>  
>  	up_write(&OCFS2_I(inode)->ip_alloc_sem);
>  

