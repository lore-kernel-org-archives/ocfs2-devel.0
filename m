Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBA2DDAD
	for <ocfs2-devel@lists.linux.dev>; Sun, 13 Apr 2025 01:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744506395; cv=none; b=IGyjCMKaWGMj1YrI3h1qiEUzp2aMvPFiydJ5qIbDpROEeEeqePSgFXwrfLMzBkY54Of4mL59dj8Vhtaw29TVrt9Gi17W8F3c2YoZDPFVFkVlPueLYL503DYRlL9yMKiic/KTC9OT25UWbp7/XdSTqqWdfUbtN4OuJBPI1BilhwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744506395; c=relaxed/simple;
	bh=d0wA6a6TtBmEed+kgWCkBfOhY66giIqSV44DkNJ4s8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a3uGbFDjoDMOb3LwSuliu258K+nUhVDEYxbFHH9UStJvh+123WgZRoh+M5YW8LE7yzNbyeO9QRbO21Proo4qAGYKFXFhZ7whZhXkBBWlqwdtFL5tYXYt5DDaNmOW3SvEfW0sf9y1Zkrr4Bf1toTxd3CTy++ONvVfMjKSZOmBKr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=N9GDuLVQ; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="N9GDuLVQ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1744506382; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Zym7YaQFhQbQMwDL8fOjFl5O2aHMu5cA1dfh0u/fOgM=;
	b=N9GDuLVQGXqM57Rx5IUV9M9d+sT7SX4McrO7cevZL0Kw0pV3Cn5zTnu7bmU5MRGezIso77urWGJ335UbfJHCUVQSb+c+gGtJBI10blw/scva3Tjz3MSm+Vty66ht8v8EolfRd23Dz2N6w8tvxeQ9yssoZM3HR1COqf4Hj9i+Dds=
Received: from 30.13.190.220(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WWZdRRE_1744506381 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 13 Apr 2025 09:06:22 +0800
Message-ID: <d48df38c-ff38-45c2-b941-8f51990e4699@linux.alibaba.com>
Date: Sun, 13 Apr 2025 09:06:21 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] ocfs2: fix the issue with discontiguous allocation in
 the global_bitmap
To: Heming Zhao <heming.zhao@suse.com>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 gautham.ananthakrishna@oracle.com
References: <20250408152311.16196-1-heming.zhao@suse.com>
 <20250408152311.16196-2-heming.zhao@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250408152311.16196-2-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/4/8 23:23, Heming Zhao wrote:
> The commit 4eb7b93e0310 ("ocfs2: improve write IO performance when
> fragmentation is high") introduced another regression.
> 
> The following ocfs2-test case can trigger this issue:
>> ${RESV_UNWRITTEN_BIN} -f ${WORK_PLACE}/large_testfile -s 0 -l \
>> $((${FILE_MAJOR_SIZE_M}*1024*1024))
> 
> In my env, test disk size (by "fdisk -l <dev>"):
>> 53687091200 bytes, 104857600 sectors.
> 
> Above command is:
>> /usr/local/ocfs2-test/bin/resv_unwritten -f \
>> /mnt/ocfs2/ocfs2-activate-discontig-bg-dir/large_testfile -s 0 -l \
>> 53187969024
> 
> Error log:
>> [*] Reserve 50724M space for a LARGE file, reserve 200M space for future test.
>> ioctl error 28: "No space left on device"
>> resv allocation failed Unknown error -1
>> reserve unwritten region from 0 to 53187969024.
> 
> Call flow:
> __ocfs2_change_file_space //by ioctl OCFS2_IOC_RESVSP64
>  ocfs2_allocate_unwritten_extents //start:0 len:53187969024
>   while()
>    + ocfs2_get_clusters //cpos:0, alloc_size:1623168 (cluster number)
>    + ocfs2_extend_allocation
>      + ocfs2_lock_allocators
>      |  + choose OCFS2_AC_USE_MAIN & ocfs2_cluster_group_search
>      |
>      + ocfs2_add_inode_data
>         ocfs2_add_clusters_in_btree
>          __ocfs2_claim_clusters
>           ocfs2_claim_suballoc_bits
>           + During the allocation of the final part of the large file
> 	    (around 47GB), no chain had the required contiguous
>             bits_wanted. Consequently, the allocation failed.
> 
> How to fix:
> When OCFS2 is encountering fragmented allocation, the file system should
> stop attempting bits_wanted contiguous allocation and instead provide the
> largest available contiguous free bits from the cluster groups.
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> Fixes: 4eb7b93e0310 ("ocfs2: improve write IO performance when fragmentation is high")
> ---
>  fs/ocfs2/suballoc.c | 36 +++++++++++++++++++++++++++++-------
>  1 file changed, 29 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index fde75f2af37a..2e1689fc6cf7 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -1796,6 +1796,7 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
>  {
>  	int status;
>  	u16 chain;
> +	u32 contig_bits;
>  	u64 next_group;
>  	struct inode *alloc_inode = ac->ac_inode;
>  	struct buffer_head *group_bh = NULL;
> @@ -1821,10 +1822,23 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
>  	status = -ENOSPC;
>  	/* for now, the chain search is a bit simplistic. We just use
>  	 * the 1st group with any empty bits. */
> -	while ((status = ac->ac_group_search(alloc_inode, group_bh,
> -					     bits_wanted, min_bits,
> -					     ac->ac_max_block,
> -					     res)) == -ENOSPC) {
> +	while (1) {
> +		if (ac->ac_which == OCFS2_AC_USE_MAIN_DISCONTIG) {
> +			contig_bits = le16_to_cpu(bg->bg_contig_free_bits);
> +			if (!contig_bits)
> +				contig_bits = ocfs2_find_max_contig_free_bits(bg->bg_bitmap,
> +						le16_to_cpu(bg->bg_bits), 0);
> +			if (bits_wanted > contig_bits)
> +				bits_wanted = contig_bits;
> +			if (bits_wanted < min_bits)
> +				bits_wanted = min_bits;

This seems only valid when bits_wanted changed?

BTW, the previous fix hasn't been merged yet:
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/fs/ocfs2?h=next-20250411&id=767ba8b7cba3ca7a560d632f267f7aea35d54810

So should we drop that first and fold it into a whole one?

Thanks,
Joseph
> +		}
> +
> +		status = ac->ac_group_search(alloc_inode, group_bh,
> +				bits_wanted, min_bits,
> +				ac->ac_max_block, res);
> +		if (status != -ENOSPC)
> +			break;
>  		if (!bg->bg_next_group)
>  			break;
>  
> @@ -1984,6 +1998,7 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
>  	victim = ocfs2_find_victim_chain(cl);
>  	ac->ac_chain = victim;
>  
> +search:
>  	status = ocfs2_search_chain(ac, handle, bits_wanted, min_bits,
>  				    res, &bits_left);
>  	if (!status) {
> @@ -2024,6 +2039,16 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
>  		}
>  	}
>  
> +	/* Chains can't supply the bits_wanted contiguous space.
> +	 * We should switch to using every single bit when allocating
> +	 * from the global bitmap. */
> +	if (i == le16_to_cpu(cl->cl_next_free_rec) &&
> +	    status == -ENOSPC && ac->ac_which == OCFS2_AC_USE_MAIN) {
> +		ac->ac_which = OCFS2_AC_USE_MAIN_DISCONTIG;
> +		ac->ac_chain = victim;
> +		goto search;
> +	}
> +
>  set_hint:
>  	if (status != -ENOSPC) {
>  		/* If the next search of this group is not likely to
> @@ -2432,9 +2457,6 @@ int ocfs2_claim_clusters(handle_t *handle,
>  {
>  	unsigned int bits_wanted = ac->ac_bits_wanted - ac->ac_bits_given;
>  
> -	if (ac->ac_which == OCFS2_AC_USE_MAIN_DISCONTIG)
> -		bits_wanted = min_clusters;
> -
>  	return __ocfs2_claim_clusters(handle, ac, min_clusters,
>  				      bits_wanted, cluster_start, num_clusters);
>  }

