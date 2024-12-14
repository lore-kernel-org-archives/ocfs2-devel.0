Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C1E169397
	for <ocfs2-devel@lists.linux.dev>; Sat, 14 Dec 2024 14:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734186402; cv=none; b=azCNKndhQSHihE03h6IJd5uWXwSBtZJr1SNCbeFi0LVChfAeq0MkUYxBbkcUIeTb5W8+VfOJz9gU6cAChjnJmSUS6wAnEmD2m5B7hhaKr5GDTH6HCC2XPFRpHpBbWDw9jC3JBGKkOWMQVBSxkKLQuYzhtvc7YFMupSwsUsB/4nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734186402; c=relaxed/simple;
	bh=sPHu8u2DwTw6Kc6VYcphjZ4N657lGtXbF2XtktvLSLg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=axDvlKuK4YWEY7OVcJB3JnKbytwbVFgRq25sBmrwQJLqlnx3gpAwS7xTXy3Umn1YbnsiLTy4SLHuPM8jtG9QIuKJlbryaUJcOnmQNWBHjd3xZmjvv0uEi3nmjqBlwQjDacicRl/+6Yx5m7kLH6dF+mQTWcgpTMptWzyAq5zTBVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=r+yf3Act; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="r+yf3Act"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734186388; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ylcQI7yw+qSnyBo4A2aW7sRE4M+FIC2FtWEeC3L9t4s=;
	b=r+yf3ActQuaehjebGyHgpDfNJH52hN4Jx87TUN0luTG628idsd2kx+rp1GKi3n3ptDo9D/kCVuuFkLPaAMcE0SCU9Hm+XRxMexEkKoFHaUrecDv06suk8A8IRDa2+6S4b01XCG/w4y9xhtjKQiWpqxUU0IfonU/8hCATulhCopA=
Received: from 30.120.185.40(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WLRk.ER_1734186387 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 14 Dec 2024 22:26:28 +0800
Message-ID: <71a172a3-4098-49dd-9803-fea0906c1a60@linux.alibaba.com>
Date: Sat, 14 Dec 2024 22:26:26 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/23] ocfs2: Use a folio in
 ocfs2_prepare_page_for_write()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 akpm <akpm@linux-foundation.org>
Cc: Mark Tinguely <mark.tinguely@oracle.com>, ocfs2-devel@lists.linux.dev
References: <20241205171653.3179945-1-willy@infradead.org>
 <20241205171653.3179945-13-willy@infradead.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241205171653.3179945-13-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024/12/6 01:16, Matthew Wilcox (Oracle) wrote:
> From: Mark Tinguely <mark.tinguely@oracle.com>
> 
> Update to the new APIs.  Removes a few page->folio conversions.
> 
> Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/aops.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index cc252a1170ad..9ce8debbd282 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -963,10 +963,10 @@ static int ocfs2_prepare_folio_for_write(struct inode *inode, u64 *p_blkno,
>  	/* treat the write as new if the a hole/lseek spanned across
>  	 * the page boundary.
>  	 */
> -	new = new | ((i_size_read(inode) <= page_offset(page)) &&
> -			(page_offset(page) <= user_pos));
> +	new = new | ((i_size_read(inode) <= folio_pos(folio)) &&
> +			(folio_pos(folio) <= user_pos));
>  
> -	if (page == &wc->w_target_folio->page) {
> +	if (folio == wc->w_target_folio) {
>  		map_from = user_pos & (PAGE_SIZE - 1);
>  		map_to = map_from + user_len;
>  
> @@ -990,7 +990,7 @@ static int ocfs2_prepare_folio_for_write(struct inode *inode, u64 *p_blkno,
>  		}
>  	} else {
>  		/*
> -		 * If we haven't allocated the new page yet, we
> +		 * If we haven't allocated the new folio yet, we
>  		 * shouldn't be writing it out without copying user
>  		 * data. This is likely a math error from the caller.
>  		 */
> @@ -1008,20 +1008,20 @@ static int ocfs2_prepare_folio_for_write(struct inode *inode, u64 *p_blkno,
>  	}
>  
>  	/*
> -	 * Parts of newly allocated pages need to be zero'd.
> +	 * Parts of newly allocated folios need to be zero'd.
>  	 *
>  	 * Above, we have also rewritten 'to' and 'from' - as far as
>  	 * the rest of the function is concerned, the entire cluster
> -	 * range inside of a page needs to be written.
> +	 * range inside of a folio needs to be written.
>  	 *
> -	 * We can skip this if the page is up to date - it's already
> +	 * We can skip this if the folio is uptodate - it's already
>  	 * been zero'd from being read in as a hole.
>  	 */
> -	if (new && !PageUptodate(page))
> +	if (new && !folio_test_uptodate(folio))
>  		ocfs2_clear_page_regions(page, OCFS2_SB(inode->i_sb),
>  					 cpos, user_data_from, user_data_to);
>  
> -	flush_dcache_page(page);
> +	flush_dcache_folio(folio);
>  
>  out:
>  	return ret;

