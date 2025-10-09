Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716AE27B342
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Oct 2025 09:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760001310; cv=none; b=omH5QpKHM2RRMf0KIAOFYGXKv/9wr48fdiCJPtEr9NsB4t1pOVvxh+NaCxIEDEktIr0vc9uwHef0nKjAt9JHqK9HyuhSuh+SzyqQy1XM6Dxk0wSDLwPYNRf9oWegiW99dMyfbipeh9wW3WlRW7XfTHTb3ONA5Xu//+Jmj8W4jTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760001310; c=relaxed/simple;
	bh=7SGUzqyUJZHvFwZ16mc+1zyoNOQpMYmkPY6TjKFtEbc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jYwW80IWQTi6Sai/rKAuYF7GGAbLn1Ael8QxLM1RDMVnSF/xYDmeDf5ymXzfk8dGRbsu/jf/Jg0HLHfd236rUL6CLo0CqFYkCKP6+tN3ZqUcfnO/HYzcCRHlI2UB4W8VG3hApd5TbKSoAnzwuKkvFmLeU/ms2NsIgXnfGH9a8jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=oB0EAaNy; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="oB0EAaNy"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760001301; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=wHZZUx1woEi/c4dZM/+PmkYrh/pa772nCixw7ltkYBA=;
	b=oB0EAaNyp0xh4r6wM8ko0nsXDFTl7pEW0dmQlb/IYEffk/VQP/yc+0jt2D1zpHKaHkbnxcNWe4yvYuWasCtY0jbMOKCn0gw2GhqklGGuUpua2B+UPY175fcG2opuzoOie2Dm8/+kN/qeRaL6DYN875c9x6qYTrf1vk/bgPBqU9A=
Received: from 30.221.128.150(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Wpl.JdO_1760001298 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 09 Oct 2025 17:14:59 +0800
Message-ID: <7901a72a-0ba3-4093-a2f3-692e642e970f@linux.alibaba.com>
Date: Thu, 9 Oct 2025 17:14:58 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix stale extent map cache during COW operations
To: Deepanshu Kartikey <kartikey406@gmail.com>, mark@fasheh.com,
 jlbec@evilplan.org
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 syzbot+6fdd8fa3380730a4b22c@syzkaller.appspotmail.com
References: <20251008042325.468846-1-kartikey406@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251008042325.468846-1-kartikey406@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 2025/10/8 12:23, Deepanshu Kartikey wrote:
> The extent map cache can become stale during COW operations, causing
> ocfs2_refcount_cal_cow_clusters() to see an outdated extent state.
> 
> The problem occurs when:
> 1. ocfs2_get_clusters() reads and caches an extent with OCFS2_EXT_REFCOUNTED
> 2. ocfs2_refcount_cow_hunk() performs COW, clearing the REFCOUNTED flag
> 3. The extent map cache still contains the stale REFCOUNTED flag
> 4. Subsequent access on the same extent via the cache gets incorrect flags,
>    triggering BUG_ON(!(rec->e_flags & OCFS2_EXT_REFCOUNTED))
> 

At the end of ocfs2_refcount_cow_hunk(), it has:

	/*
	 * truncate the extent map here since no matter whether we meet with
	 * any error during the action, we shouldn't trust cached extent map
	 * any more.
	 */
	ocfs2_extent_map_trunc(inode, cow_start);

It seems the cached extent record has already been forgotten. So how
does the above step 3 happen?

Thanks,
Joseph


> Fix by clearing the extent map cache at the start of COW operations.
> This ensures that ocfs2_get_clusters() always reads fresh extent data
> from disk during COW instead of using stale cached data.
> 
> Reported-by: syzbot+6fdd8fa3380730a4b22c@syzkaller.appspotmail.com
> Tested-by: syzbot+6fdd8fa3380730a4b22c@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
>  fs/ocfs2/refcounttree.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index 267b50e8e42e..e8c8fcdc3dd9 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -3451,7 +3451,8 @@ int ocfs2_refcount_cow(struct inode *inode,
>  	int ret = 0;
>  	u32 p_cluster, num_clusters;
>  	unsigned int ext_flags;
> -
> +	/* Clear extent map cache before COW operations to avoid stale data */
> +	ocfs2_extent_map_trunc(inode, 0);
>  	while (write_len) {
>  		ret = ocfs2_get_clusters(inode, cpos, &p_cluster,
>  					 &num_clusters, &ext_flags);

