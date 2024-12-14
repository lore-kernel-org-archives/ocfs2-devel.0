Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E613946C
	for <ocfs2-devel@lists.linux.dev>; Sat, 14 Dec 2024 14:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734187896; cv=none; b=pOah6NEPrjqHKHIOIgrhwPNmLz8sa0Th43GUSAEojtWWnTOhfm4+f9HBcYSYZ0qOjjGU4z37EyF0uruOYm6zPKyTvJe4lUqULHvciGXI+hO2LiNMKzKeeHKcXdhODLuYog8pFPEZtmog6GV2rp66jS2HTD0lpZeIz0edrcWM4Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734187896; c=relaxed/simple;
	bh=+JscpvjFWstL2riJZGlr4+1jrfizk7n8Nj8TShktThg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jt558PNP7jk1A2Uw+W4U+h/VjPQukCrwOBDuvyiJAptWOvbN4tqPTovlWx6Zbo1QC025ipiyI37zLvp+WG649NjIHo69YbePd7Ef6iINOlUu0DnGFKftVjhdsC3uK58ax5Hn2KeMRIwDV7Ri/drqemxPD7U80y8kKKRfKzkFhfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=v60UWbU/; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="v60UWbU/"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734187891; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=jAt0xJMq2VtweKpdjNZ5+RuzNax26rTHhZQHAjozrR8=;
	b=v60UWbU/WkwHbAM/4PX6nT1OsedZN2LoYzrlQ46JzQSMHos0dQnFXOi5kTZNi1kONGbqj6WD89LRFHtuqtZz6C4YJhCuAvUCnAMcSjvgYdeOreJyZkUnb3sABXa3/RRp7t61NVQSI7PmQh1KPKdy+PMr04vxy7XpC9HZVmxXsFY=
Received: from 30.120.185.40(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WLRjLo6_1734187890 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 14 Dec 2024 22:51:30 +0800
Message-ID: <c1412f33-f466-4b35-981e-085676f1d50b@linux.alibaba.com>
Date: Sat, 14 Dec 2024 22:51:29 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 23/23] ocfs2: Support large folios in
 ocfs2_write_zero_page()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 akpm <akpm@linux-foundation.org>
Cc: Mark Tinguely <mark.tinguely@oracle.com>, ocfs2-devel@lists.linux.dev
References: <20241205171653.3179945-1-willy@infradead.org>
 <20241205171653.3179945-24-willy@infradead.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241205171653.3179945-24-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024/12/6 01:16, Matthew Wilcox (Oracle) wrote:
> From: Mark Tinguely <mark.tinguely@oracle.com>
> 
> Remove assumptions that a folio is PAGE_SIZE.
> 
> Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/file.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 957ced628eb1..e54f2c4b5a90 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -782,11 +782,11 @@ static int ocfs2_write_zero_page(struct inode *inode, u64 abs_from,
>  		goto out_commit_trans;
>  	}
>  
> -	/* Get the offsets within the page that we want to zero */
> -	zero_from = abs_from & (PAGE_SIZE - 1);
> -	zero_to = abs_to & (PAGE_SIZE - 1);
> +	/* Get the offsets within the folio that we want to zero */
> +	zero_from = offset_in_folio(folio, abs_from);
> +	zero_to = offset_in_folio(folio, abs_to);
>  	if (!zero_to)
> -		zero_to = PAGE_SIZE;
> +		zero_to = folio_size(folio);
>  
>  	trace_ocfs2_write_zero_page(
>  			(unsigned long long)OCFS2_I(inode)->ip_blkno,

