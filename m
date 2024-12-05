Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CB81DACBB
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Dec 2024 11:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733396953; cv=none; b=IPOg5hPnunQaOPPGqeQtbmDDeuBgbsaPEGZuPp+b6T7bs4R386z+ZcNa45agg7yu5PpOiypKaMwkjHbrngu1FjyzBc0zGeTvEJzX/gZD5SQGTw088hE98VtZuM1BA7ykFZmoSnKHQrmZZIqggHFbmu4oXTl58N40YDSc1SyQ5Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733396953; c=relaxed/simple;
	bh=2lwv7PTuYJ1KSoCkZDbSJ2Fkk3xStOJzhn/LI+XU2d8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oh7WTvxEvSCaWM8X/AFFW3ovLWRnN0RFphAidfpljal7Nfa/bi8pDokcekH1lLFYU842oCG/f6OztJnSlGeRRcE2gh8tdeCCqaMVG4vGa1TSVHhjCdsWYmfRfTl4eW0JaNndp7DyqMHwZDahw2enJ37saLsbDJGxzhVzm0v0uy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=g97roBDJ; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="g97roBDJ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1733396948; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=F1uWlXiJdRS4YGgh84leHN/3o0Drua4QYRdsX3mwS+0=;
	b=g97roBDJ6JjGUrOQG89YyhXAFWkJQAWQSJi4P7pRTmNm7CZpz1bHgpdBzWzVeX/Ie8ni2DTi0FoNfVk/RcBVdb1hYlFDXeqibgKw9UXW95LNiJuYst6nQUO4xBthV/Fq7v6k2bT1EuP7rbGStE4eWh74b8lKFBZX/65wikKRju0=
Received: from 30.221.131.123(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WKt16k9_1733396946 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Dec 2024 19:09:07 +0800
Message-ID: <c994ac21-7412-4df2-b6d9-e810d8c6864b@linux.alibaba.com>
Date: Thu, 5 Dec 2024 19:09:06 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] ocfs2: Revert "ocfs2: fix the la space leak when
 unmounting an ocfs2 volume"
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@lists.linux.dev,
 akpm <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20241205104835.18223-1-heming.zhao@suse.com>
 <20241205104835.18223-2-heming.zhao@suse.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241205104835.18223-2-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/5/24 6:48 PM, Heming Zhao wrote:
> This reverts commit dfe6c5692fb5 ("ocfs2: fix the la space leak when
> unmounting an ocfs2 volume").
> 
> In commit dfe6c5692fb5, the commit log "This bug has existed since the
> initial OCFS2 code." is wrong. The correct introduction commit is
> 30dd3478c3cd ("ocfs2: correctly use ocfs2_find_next_zero_bit()").
> 
> The influence of commit dfe6c5692fb5 is that it provides a correct
> fix for the latest kernel. however, it shouldn't be pushed to stable
> branches. Let's use this commit to revert all branches that include
> dfe6c5692fb5 and use a new fix method to fix commit 30dd3478c3cd.
> 
> Fixes: dfe6c5692fb5 ("ocfs2: fix the la space leak when unmounting an ocfs2 volume")
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> Cc: <stable@vger.kernel.org>
> ---
>  fs/ocfs2/localalloc.c | 19 -------------------
>  1 file changed, 19 deletions(-)
> 
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index 8ac42ea81a17..5df34561c551 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -1002,25 +1002,6 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
>  		start = bit_off + 1;
>  	}
>  
> -	/* clear the contiguous bits until the end boundary */
> -	if (count) {
> -		blkno = la_start_blk +
> -			ocfs2_clusters_to_blocks(osb->sb,
> -					start - count);
> -
> -		trace_ocfs2_sync_local_to_main_free(
> -				count, start - count,
> -				(unsigned long long)la_start_blk,
> -				(unsigned long long)blkno);
> -
> -		status = ocfs2_release_clusters(handle,
> -				main_bm_inode,
> -				main_bm_bh, blkno,
> -				count);
> -		if (status < 0)
> -			mlog_errno(status);
> -	}
> -
>  bail:
>  	if (status)
>  		mlog_errno(status);

