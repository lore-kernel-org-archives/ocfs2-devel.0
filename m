Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C2C653
	for <ocfs2-devel@lists.linux.dev>; Sat, 14 Dec 2024 14:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734185793; cv=none; b=l+xBkY8wtC2SLylnuKBSNpHDBTC++ql4Jewf+bEO6UQNbQcOwY9EhUrE8jlgJwxfJ9jXq6aqJDe2/kCxhLcaGoMnAjLUpl14bq0FLpzQ7qOz5lPVMZ5TgF+m5TQp7UznCHSw8Qp7gsQmxShvNoA1icmYCQoKHA3sT1vIzY9j84o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734185793; c=relaxed/simple;
	bh=mSBSUfawubpmdOubPQxG+/mDKrSB4IQls+3rBgQArXM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=azr/U+9B0t9gwIl5j7GlDTi5DS2cginMHBdvgLA1J9k080NQ4HEucYSPOdJzBbPAy3CseWcfTZTjnvdL/IbCDvbKwjPs7+Ts2w3QX1VYSfk3BzoGyTG4Uo98vYE+vqp/7Ifbpm8xIL6KP1JzfJJ6EjCWUZXbHlG7C90zIVLXzic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Z6hbCJeY; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Z6hbCJeY"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734185788; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=jYBoDa+tWA8Mh3GeWaxZ7KjxmjXnQTo+zdGyeYWFflM=;
	b=Z6hbCJeY/G0QhQhK6kaVqiN0uDnbk7/oB0tnxHA43/6mk3LzwMx4+cU682BNhEH+Hh6ryHsUevTyk+bfbboQyp/DeiTkkD1AHomq0TCHf06wAhg5XdjHdJloEvjKUaYHpWbdtg1k3OnNFwRlChH1MfUkBFy8iF7jEAddpXlbVdg=
Received: from 30.120.185.40(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WLRjzAx_1734185786 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 14 Dec 2024 22:16:27 +0800
Message-ID: <663c7c07-9725-4630-9b9b-7e1c9aa4e09b@linux.alibaba.com>
Date: Sat, 14 Dec 2024 22:16:26 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/23] ocfs2: Convert ocfs2_write_failure() to use a folio
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 akpm <akpm@linux-foundation.org>
Cc: Mark Tinguely <mark.tinguely@oracle.com>, ocfs2-devel@lists.linux.dev
References: <20241205171653.3179945-1-willy@infradead.org>
 <20241205171653.3179945-11-willy@infradead.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241205171653.3179945-11-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024/12/6 01:16, Matthew Wilcox (Oracle) wrote:
> From: Mark Tinguely <mark.tinguely@oracle.com>
> 
> Remove the folio->page conversion and just use the folio.
> 
> Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/aops.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index afc20ab52b3e..8dda080743b7 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -930,20 +930,19 @@ static void ocfs2_write_failure(struct inode *inode,
>  	int i;
>  	unsigned from = user_pos & (PAGE_SIZE - 1),
>  		to = user_pos + user_len;
> -	struct page *tmppage;
>  
>  	if (wc->w_target_folio)
>  		ocfs2_zero_new_buffers(wc->w_target_folio, from, to);
>  
>  	for (i = 0; i < wc->w_num_folios; i++) {
> -		tmppage = &wc->w_folios[i]->page;
> +		struct folio *folio = wc->w_folios[i];
>  
> -		if (tmppage && page_has_buffers(tmppage)) {
> +		if (folio && folio_buffers(folio)) {
>  			if (ocfs2_should_order_data(inode))
>  				ocfs2_jbd2_inode_add_write(wc->w_handle, inode,
>  							   user_pos, user_len);
>  
> -			block_commit_write(tmppage, from, to);
> +			block_commit_write(&folio->page, from, to);
>  		}
>  	}
>  }

