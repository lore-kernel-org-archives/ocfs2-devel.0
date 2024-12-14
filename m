Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4A418D620
	for <ocfs2-devel@lists.linux.dev>; Sat, 14 Dec 2024 12:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734177823; cv=none; b=iqDWhTfqYPLm4YC3DAHKJEsK2Oq0MQWCzYwV2lGG0V1ji+s9ar1GrxEc7+QsU+hP8cH0OHu7Hk1mtsyGk7SkRD7X5ffAdL8bFodY5q0cc++XNG9EQHCYtvQAwFM9V/Gv2CqoI2HHWgYwesEOZxR7EEU8bNtEL0fMaaPcVqWhfSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734177823; c=relaxed/simple;
	bh=2vKlmrrpIW698UnsIFpSEzPxUWPaGsvoO22QxKykQDA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VM90nsuEqE1uHB/YMkn3tvG9mSrEddOffJGXTsmZ3xKOWazy0e9RBCC2z3khBa7svL5hZi4nwIKCFOWhu2WnKnwlu4zu3p2UiTMyuKiVfV1fooIRQOVs3QawmaO59SXcuzh4HBdQLi028TSY9MPZGuYiuFA+Wr+06nTbckjFeTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=YwaRmx+I; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="YwaRmx+I"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734177812; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=CgI3UuXkNtpIu8Hz80ke2Gq99NhpHVLzX2ZaWjPXS5I=;
	b=YwaRmx+IuJ7qNdG2QCf5dpt8zqqYfl6qNfyfZsiAu7i574ZoYYAYkqDkyBkwmuHe5pxsGvFEwGglwjDbc+8vy+FxXSsPU3KZ4n9U9pP6ehqJ2+RRt6lA5BBzEFj4y3f3b/hK2C49nwndIjhwsodEAV0Li+OS8MXRJ52C0WbD53w=
Received: from 30.120.185.40(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WLRSZeC_1734177810 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 14 Dec 2024 20:03:31 +0800
Message-ID: <f0279f1a-936e-45c2-9f57-0b82c3fffcd9@linux.alibaba.com>
Date: Sat, 14 Dec 2024 20:03:30 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/23] ocfs2: Handle a symlink read error correctly
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: ocfs2-devel@lists.linux.dev, Mark Tinguely <mark.tinguely@oracle.com>,
 stable@vger.kernel.org
References: <20241205171653.3179945-1-willy@infradead.org>
 <20241205171653.3179945-2-willy@infradead.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241205171653.3179945-2-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024/12/6 01:16, Matthew Wilcox (Oracle) wrote:
> If we can't read the buffer, be sure to unlock the page before
> returning.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: stable@vger.kernel.org
> ---
>  fs/ocfs2/symlink.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/symlink.c b/fs/ocfs2/symlink.c
> index d4c5fdcfa1e4..f5cf2255dc09 100644
> --- a/fs/ocfs2/symlink.c
> +++ b/fs/ocfs2/symlink.c
> @@ -65,7 +65,7 @@ static int ocfs2_fast_symlink_read_folio(struct file *f, struct folio *folio)
>  

Better to move calling ocfs2_read_inode_block() here.

Thanks,
Joseph

>  	if (status < 0) {
>  		mlog_errno(status);
> -		return status;
> +		goto out;
>  	}
>  
>  	fe = (struct ocfs2_dinode *) bh->b_data;
> @@ -76,9 +76,10 @@ static int ocfs2_fast_symlink_read_folio(struct file *f, struct folio *folio)
>  	memcpy(kaddr, link, len + 1);
>  	kunmap_atomic(kaddr);
>  	SetPageUptodate(page);
> +out:
>  	unlock_page(page);
>  	brelse(bh);
> -	return 0;
> +	return status;
>  }
>  
>  const struct address_space_operations ocfs2_fast_symlink_aops = {

