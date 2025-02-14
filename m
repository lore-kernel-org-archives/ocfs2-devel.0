Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73CB173
	for <ocfs2-devel@lists.linux.dev>; Fri, 14 Feb 2025 01:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739496759; cv=none; b=m5iCvoV1iMtBildtgeMMwTr/tJy8r5fmS+fxgvkB5ppj0EFKuiDHZQ8lAkp8Ag+wMT/s1Bh63gTJXn6RGlMYLk63K0XDYM2d7SsEBSb9g5/goEQKpvtXBXtf1oR2JYIQBHlOZEcHRqaJ4voR57Ex9qlemdFqaX7BTsfdw4HTb8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739496759; c=relaxed/simple;
	bh=2uSckVcs76p3zYym1bAgvw9YRROzbo19nGBzSrVElAo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t+5O64O9Wug65stRAqwF10rOVvKdHC693YRsXROOcGrameXJ2LmKAUl6UTJQx+nvlYB7j1AB+V3LL2nhv8dJNHGTI1Ep2n2NhF55WaGmktQp/62KclytzkK6qdyIZ252KlQmoznyN3OoG2W7kL/QsyjJqxKDsjktcj6FYw43Zzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=uw4ze9uM; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="uw4ze9uM"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1739496753; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=RBKILsyIl1yZ1hVvw97X7/UfLhWAE5fedW8tf0jFanE=;
	b=uw4ze9uMpAwqtJlLiFxVUxis89ogqtI/m1JMglmMZlh+eH9deQJe5rIUqz0WuaDvliWoU0h/s9LarK9UZ5WYZKDsWZ5ubZTUA9VKkbSSRxOj0yydA20fQicES284Argq4mynVrsR7uY7fSRPBTPy7i55gGuXjwhzb1+67MpEJFc=
Received: from 30.221.128.236(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WPP0Lgc_1739496751 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 14 Feb 2025 09:32:32 +0800
Message-ID: <1528e1cb-278c-4c8c-994b-ce7ed9731f63@linux.alibaba.com>
Date: Fri, 14 Feb 2025 09:32:31 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] ocfs2: Use memcpy_to_folio() in
 ocfs2_symlink_get_block()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 akpm <akpm@linux-foundation.org>
Cc: Mark Tinguely <mark.tinguely@oracle.com>, ocfs2-devel@lists.linux.dev,
 linux-fsdevel@vger.kernel.org
References: <20250213214533.2242224-1-willy@infradead.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250213214533.2242224-1-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/2/14 05:45, Matthew Wilcox (Oracle) wrote:
> Replace use of kmap_atomic() with the higher-level construct
> memcpy_to_folio().  This removes a use of b_page and supports
> large folios as well as being easier to understand.  It also
> removes the check for kmap_atomic() failing (because it can't).
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/aops.c | 17 +++++------------
>  1 file changed, 5 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 5bbeb6fbb1ac..ccf2930cd2e6 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -46,7 +46,6 @@ static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
>  	struct buffer_head *bh = NULL;
>  	struct buffer_head *buffer_cache_bh = NULL;
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> -	void *kaddr;
>  
>  	trace_ocfs2_symlink_get_block(
>  			(unsigned long long)OCFS2_I(inode)->ip_blkno,
> @@ -91,17 +90,11 @@ static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
>  		 * could've happened. Since we've got a reference on
>  		 * the bh, even if it commits while we're doing the
>  		 * copy, the data is still good. */
> -		if (buffer_jbd(buffer_cache_bh)
> -		    && ocfs2_inode_is_new(inode)) {
> -			kaddr = kmap_atomic(bh_result->b_page);
> -			if (!kaddr) {
> -				mlog(ML_ERROR, "couldn't kmap!\n");
> -				goto bail;
> -			}
> -			memcpy(kaddr + (bh_result->b_size * iblock),
> -			       buffer_cache_bh->b_data,
> -			       bh_result->b_size);
> -			kunmap_atomic(kaddr);
> +		if (buffer_jbd(buffer_cache_bh) && ocfs2_inode_is_new(inode)) {
> +			memcpy_to_folio(bh_result->b_folio,
> +					bh_result->b_size * iblock,
> +					buffer_cache_bh->b_data,
> +					bh_result->b_size);
>  			set_buffer_uptodate(bh_result);
>  		}
>  		brelse(buffer_cache_bh);

