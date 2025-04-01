Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5381A1FA26C
	for <ocfs2-devel@lists.linux.dev>; Tue,  1 Apr 2025 11:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743507502; cv=none; b=j4hxB0wXJbUXFDetypQijsGOBXAaoQG3JsnKHGQkWNGV0jc50QcrzwjJmlDmwEWtXrHFeQsyUrIXKS6kPuXD9VyWSkwTAW6eZbEforEEJ9AGm2Miad7G+feyMD+e2Bu/GgwM39XDinpozZkuPNNWUpywnxjtUeVQp6X40pTn6/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743507502; c=relaxed/simple;
	bh=5ewUIkcDYDp5CI8gkXADDwYJIM1RS38PD14UJnHj13U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qTYADVtXJDyltP9wEpY6IlqbHgga9IdCFRGCsO82p7PA6z1WDGVCnkGjxJTJKeJ1bLbfeJUu6+MAHSpOrBfYcNTues+0DIEcU2LQdgl+BX6khjfQQ09JhxENONrn9uKXBybsv7WSw3anJ+v/HG8S1c7WClIYrt3xNipVHLHTAeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=dhkpRcac; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="dhkpRcac"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1743507490; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=dPsW6zzNsJ8iBAR6uGrinqus+uX+vXrhwBfcxZTSSyE=;
	b=dhkpRcacSrOuCgDGV7HklXSTB17lMdhaPA428rRU7PmD59V/Axq5vpXiSAh92rkisd8EAYgYKMDBkToCIlh9v+6xyP3Q+HLbZ882YCB+clxFazi+9u0nPVMGgbr0GKwqj4WqQpGPgg0tdtD+L9GwQ58VNcMUR5whk51q0QedTkw=
Received: from 30.221.147.144(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WU041zZ_1743507487 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 01 Apr 2025 19:38:07 +0800
Message-ID: <e1014674-51a4-4d40-9bc9-0906ffbeadac@linux.alibaba.com>
Date: Tue, 1 Apr 2025 19:38:06 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fixing global bitmap allocating failure for
 discontig type
To: Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 gautham.ananthakrishna@oracle.com
References: <20250327062209.19201-1-heming.zhao@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250327062209.19201-1-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/3/27 14:22, Heming Zhao wrote:
> The commit 4eb7b93e0310 ("ocfs2: improve write IO performance when
> fragmentation is high") introduced a regression. In the discontiguous
> extent allocation case, ocfs2_cluster_group_search() is comparing with
> the wrong target length, which causes allocation failure.
> 
> Call stack:
> ocfs2_mkdir()
>  ocfs2_reserve_new_inode()
>   ocfs2_reserve_suballoc_bits()
>    ocfs2_block_group_alloc()
>     ocfs2_block_group_alloc_discontig()
>      __ocfs2_claim_clusters()
>       ocfs2_claim_suballoc_bits()
>        ocfs2_search_chain()
>         ocfs2_cluster_group_search()
> 
> Reported-by: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
> Fixes: 4eb7b93e0310 ("ocfs2: improve write IO performance when fragmentation is high")
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/suballoc.c | 14 +++++++++++---
>  fs/ocfs2/suballoc.h |  1 +
>  2 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index f7b483f0de2a..3dea082f6e91 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -698,10 +698,12 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
>  
>  	bg_bh = ocfs2_block_group_alloc_contig(osb, handle, alloc_inode,
>  					       ac, cl);
> -	if (PTR_ERR(bg_bh) == -ENOSPC)
> +	if (PTR_ERR(bg_bh) == -ENOSPC) {
> +		ac->ac_which = OCFS2_AC_USE_MAIN_DISCONTIG;
>  		bg_bh = ocfs2_block_group_alloc_discontig(handle,
>  							  alloc_inode,
>  							  ac, cl);
> +	}
>  	if (IS_ERR(bg_bh)) {
>  		status = PTR_ERR(bg_bh);
>  		bg_bh = NULL;
> @@ -2365,7 +2367,8 @@ int __ocfs2_claim_clusters(handle_t *handle,
>  	BUG_ON(ac->ac_bits_given >= ac->ac_bits_wanted);
>  
>  	BUG_ON(ac->ac_which != OCFS2_AC_USE_LOCAL
> -	       && ac->ac_which != OCFS2_AC_USE_MAIN);
> +	       && ac->ac_which != OCFS2_AC_USE_MAIN
> +	       && ac->ac_which != OCFS2_AC_USE_MAIN_DISCONTIG);
>  
>  	if (ac->ac_which == OCFS2_AC_USE_LOCAL) {
>  		WARN_ON(min_clusters > 1);
> @@ -2427,7 +2430,12 @@ int ocfs2_claim_clusters(handle_t *handle,
>  			 u32 *cluster_start,
>  			 u32 *num_clusters)
>  {
> -	unsigned int bits_wanted = ac->ac_bits_wanted - ac->ac_bits_given;
> +	unsigned int bits_wanted;
> +
> +	if (ac->ac_which == OCFS2_AC_USE_MAIN)
> +		bits_wanted = ac->ac_bits_wanted - ac->ac_bits_given;
> +	else /* ac_which == OCFS2_AC_USE_MAIN_DISCONTIG */
> +		bits_wanted = min_clusters;

This looks wried. Why can not be other alloc type?

Or it seems you intend to:

unsigned int bits_wanted = ac->ac_bits_wanted - ac->ac_bits_given;

if (ac->ac_which == OCFS2_AC_USE_MAIN_DISCONTIG)
	bits_wanted = min_clusters;

Thanks,
Joseph

>  
>  	return __ocfs2_claim_clusters(handle, ac, min_clusters,
>  				      bits_wanted, cluster_start, num_clusters);
> diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
> index b481b834857d..bcf2ed4a8631 100644
> --- a/fs/ocfs2/suballoc.h
> +++ b/fs/ocfs2/suballoc.h
> @@ -29,6 +29,7 @@ struct ocfs2_alloc_context {
>  #define OCFS2_AC_USE_MAIN  2
>  #define OCFS2_AC_USE_INODE 3
>  #define OCFS2_AC_USE_META  4
> +#define OCFS2_AC_USE_MAIN_DISCONTIG  5
>  	u32    ac_which;
>  
>  	/* these are used by the chain search */

