Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE64466B1B
	for <ocfs2-devel@lists.linux.dev>; Wed,  5 Aug 2026 12:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785932440; cv=none; b=Dj6RXeve/G/kMzGy8Kj/+bWQBdKFLx2Zo1jGVPHnMvLyzjDH2nOJ9YD/mZ1tx65v5F+L77e0/8l60VBoaZUL0hC6dyBX9k6TevYsmTvGsSxsP49KzidKBMky3YuX5WKHgUFF1dXP+XPPJIERUiQwunw+xWu/17/vvqNLUIEOcXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785932440; c=relaxed/simple;
	bh=4YJTDVeOeIRLjPdssMiKpCtEkXBGtAE7s1KHPClF8Ts=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e1riSlHcDQek9uXcXadzqiTASD4Kbdwocqd1GZ2JxUuU7KDWsM13sGScHTrfnQQtiILYaKdgnLuYmDeLlGxKZqz12buYRMlfeSzZy9pQ+SvN327kPqoOu94/Qk7fTf68TvhfWKKWpSyTZ1gISx9qLqgbaNEP5/vjVjTCjQZRMwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=RmnRsxAU; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="RmnRsxAU"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785932433; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=6Q520ukcQ1Nk1m20jSH/LeAVwsrTmKfiKDR865ByMFY=;
	b=RmnRsxAUbIPn3hFQgGGF5SsuU0V8Z/2M/18dI5nvV4U1d+aKvO4HPjcrExRpxWxQl6rqgDnRBQLNZxb2mQ2XlKd1eIDadATstn5dSefTlXg2wZG1wx3nLU5slb9YONLQCEr1HPkoqAFV/K0Td0ztugKTFiIV3GmCFpm39HIbEWo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X8R8OgX_1785932432;
Received: from 30.166.0.128(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X8R8OgX_1785932432 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 05 Aug 2026 20:20:32 +0800
Message-ID: <1de59a4f-49be-4f3f-b11f-6cf38cd31222@linux.alibaba.com>
Date: Wed, 5 Aug 2026 20:20:29 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: fix cached cluster count after suballocator
 reclaim
To: Matthias Goergens <matthias.goergens@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: heming.zhao@suse.com, mark@fasheh.com, jlbec@evilplan.org,
 glass.su@suse.com, ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260805070837.3390148-1-matthias.goergens@gmail.com>
 <anL1pYKZK8UqYwsI@p15> <20260805113920.385959-1-matthias.goergens@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260805113920.385959-1-matthias.goergens@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/5/26 7:39 PM, Matthias Goergens wrote:
> When reclaiming a suballocator block group, first reduce the on-disk
> cluster count by cl_cpg.  The current code then subtracts that new
> count (fe->i_clusters) from the old cached count
> (OCFS2_I(alloc_inode)->ip_clusters).
> 
> For an allocator with N block groups, that leaves the cache at
> 
>     N * cl_cpg - (N * cl_cpg - cl_cpg) = cl_cpg
> 
> i.e. ip_clusters -= (fe->i_clusters - cl_cpg) leaves ip_clusters equal
> to cl_cpg regardless of N.  This happens to be correct when reclaiming
> from two block groups, but undercounts the clusters from three block
> groups onwards.  The incorrect cache value is also used immediately to
> update i_blocks.
> 
> Assign the updated on-disk count to the cache, matching the allocation
> and inode refresh paths.
> 
> In a QEMU test using a clean 256 MiB OCFS2 image and a 10,000-file
> create/delete workload, the first buggy reclaim left the on-disk
> (fe->i_clusters) and cached (ip_clusters) counts at 2048 and 512
> clusters respectively; later reclaims underflowed the cache.  With this
> change, the cache matched the on-disk count across all four reclaims:
> 2048, 1536, 1024, and 512 clusters.
> 
> Fixes: 4a54331616b3 ("ocfs2: give ocfs2 the ability to reclaim suballocator free bg")
> Cc: stable@vger.kernel.org
> Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> 
> v2: commit-log wording revisions suggested by Heming Zhao; code unchanged.
>  fs/ocfs2/suballoc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index a4a2b87a45fe3..20c3aec6b9873 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -2759,7 +2759,7 @@ static int _ocfs2_reclaim_suballoc_to_main(handle_t *handle,
>  	fe->i_clusters = cpu_to_le32(tmp_used - le16_to_cpu(cl->cl_cpg));
>  
>  	spin_lock(&OCFS2_I(alloc_inode)->ip_lock);
> -	OCFS2_I(alloc_inode)->ip_clusters -= le32_to_cpu(fe->i_clusters);
> +	OCFS2_I(alloc_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
>  	fe->i_size = cpu_to_le64(ocfs2_clusters_to_bytes(alloc_inode->i_sb,
>  					     le32_to_cpu(fe->i_clusters)));
>  	spin_unlock(&OCFS2_I(alloc_inode)->ip_lock);

