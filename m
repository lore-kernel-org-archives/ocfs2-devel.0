Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71214DB562
	for <ocfs2-devel@lists.linux.dev>; Tue, 19 May 2026 12:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779193369; cv=none; b=tR/GvPgliCrEE5oDS/gdH82+Ckj58LQETCprIT49lCtIFY3tOhuUuqvEG3ftAHYX/26spbCn228TR3+Wb5EpO5F764xpwYdvdXddUaT2aOqGBk7yqUDEC69sZOTbHRS1DAUPX3u4RlWQSFH1gZq8E5tOLlGUKcP9NwXU/AKwysM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779193369; c=relaxed/simple;
	bh=bppVxK+iLdFF3+8ha/bQX+yxiXkj8Q9V2KKG51kAD28=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t4BoSMSc6J+BvZXtMdKEQJ2qgAP53V2jJPyAe15uRvAG7G5ZhLJUnjaXM1EhaED6rUfcxnEh2U9kma9rs+o1FsTISFLjWOPXxXqp4Rd5zpbnwmJ4+fb480dbs3HvfmzoeP49QYulZX8sK9Rqia7Nf62iQN0TibTc1iG9dVYHv5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=r1VOEH4R; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="r1VOEH4R"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779193359; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=WXf7YDCNaS97nzCGk4VOVrDTc56F+4FGwflgrKyJZd4=;
	b=r1VOEH4R7vKmjAxleIJaSdqIVXcCzC2jQB18mT2fdENKNmdLJkpvjZ8h4sURIMx/zYWfBPFZLKXcm0sVpyvJxDR2OVtsa6D+ar6vmdFRC5tttP5I3/eP+EIpYPfD/7UtCKMiVRQBc0p4kY69Fphab7XdRrXmdQzr4i/bayXHlbg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X3FZemA_1779193357;
Received: from 30.221.130.5(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X3FZemA_1779193357 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 19 May 2026 20:22:38 +0800
Message-ID: <8a53297d-b498-44e3-8121-a6320e64bed5@linux.alibaba.com>
Date: Tue, 19 May 2026 20:22:37 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] ocfs2: reject non-inline dinodes with i_size and
 zero i_clusters
To: Michael Bommarito <michael.bommarito@gmail.com>,
 akpm <akpm@linux-foundation.org>
Cc: ZhengYuan Huang <gality369@gmail.com>, ocfs2-devel@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <20260519110404.1803902-1-michael.bommarito@gmail.com>
 <20260519110404.1803902-4-michael.bommarito@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260519110404.1803902-4-michael.bommarito@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/19/26 7:04 PM, Michael Bommarito wrote:
> On a volume mounted without OCFS2_FEATURE_INCOMPAT_SPARSE_ALLOC, a
> non-inline regular file with non-zero i_size and zero i_clusters is
> structurally malformed: the extent map declares no allocated clusters
> yet the size header claims content exists.  Keep rejecting that shape,
> but express it through a shared predicate so the same invariant is
> available to normal inode reads and online filecheck.
> 
> The same zero-cluster shape is also malformed for non-inline directories.
> ocfs2 directory growth allocates backing storage before advancing
> i_size, and ocfs2_dir_foreach_blk_el() later walks until ctx->pos reaches
> i_size_read(inode).  A forged directory dinode with a huge i_size and no
> clusters would repeatedly fail on holes while advancing through the
> claimed size.
> 
> Sparse regular files remain exempt: on sparse-alloc volumes, truncate can
> legitimately grow i_size without allocating clusters.  System inodes and
> inline-data dinodes also retain their separate storage rules.
> 
> Mirror the check in ocfs2_filecheck_validate_inode_block() as well.
> filecheck reports through its own error namespace, so malformed
> size/cluster state is logged as a filecheck invalid-inode result rather
> than via ocfs2_error(), but it must not proceed into
> ocfs2_populate_inode().
> 
> Fixes: b657c95c1108 ("ocfs2: Wrap inode block reads in a dedicated function.")
> Cc: stable@vger.kernel.org
> Link: https://sashiko.dev/#/patchset/20260517111015.3187935-1-michael.bommarito%40gmail.com
> Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> Assisted-by: Claude:claude-opus-4-7

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/inode.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 60 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 992980ea98046..432eac01c1763 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -82,6 +82,24 @@ static bool ocfs2_dinode_has_unexpected_rdev(struct ocfs2_dinode *di)
>  	return !S_ISCHR(mode) && !S_ISBLK(mode) && di->id1.dev1.i_rdev != 0;
>  }
>  
> +static bool ocfs2_dinode_has_size_without_clusters(struct super_block *sb,
> +						   struct ocfs2_dinode *di)
> +{
> +	umode_t mode = le16_to_cpu(di->i_mode);
> +
> +	if (le32_to_cpu(di->i_flags) & OCFS2_SYSTEM_FL)
> +		return false;
> +	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL)
> +		return false;
> +	if (!le64_to_cpu(di->i_size) || le32_to_cpu(di->i_clusters))
> +		return false;
> +
> +	if (S_ISDIR(mode))
> +		return true;
> +
> +	return !ocfs2_sparse_alloc(OCFS2_SB(sb)) && S_ISREG(mode);
> +}
> +
>  void ocfs2_set_inode_flags(struct inode *inode)
>  {
>  	unsigned int flags = OCFS2_I(inode)->ip_attr;
> @@ -1563,6 +1581,33 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		goto bail;
>  	}
>  
> +	/*
> +	 * Non-inline directories must not have i_size without allocated
> +	 * clusters: directory growth adds storage before advancing i_size,
> +	 * and readdir walks i_size block-by-block.  A forged directory
> +	 * with zero clusters and a huge i_size would repeatedly fault on
> +	 * holes while advancing through the claimed size.
> +	 *
> +	 * Non-inline regular files have the same invariant on non-sparse
> +	 * volumes.  Sparse regular files are different: truncate can
> +	 * legitimately grow i_size without allocating clusters, so keep
> +	 * the sparse-alloc carveout for S_IFREG only.  System inodes and
> +	 * inline-data dinodes have their own storage rules.
> +	 */
> +	if (ocfs2_dinode_has_size_without_clusters(sb, di)) {
> +		if (S_ISDIR(le16_to_cpu(di->i_mode)))
> +			rc = ocfs2_error(sb,
> +					 "Invalid dinode #%llu: directory i_size %llu with i_clusters 0 and no inline-data flag\n",
> +					 (unsigned long long)bh->b_blocknr,
> +					 (unsigned long long)le64_to_cpu(di->i_size));
> +		else
> +			rc = ocfs2_error(sb,
> +					 "Invalid dinode #%llu: regular file i_size %llu with i_clusters 0 and no inline-data flag on non-sparse volume\n",
> +					 (unsigned long long)bh->b_blocknr,
> +					 (unsigned long long)le64_to_cpu(di->i_size));
> +		goto bail;
> +	}
> +
>  	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {
>  		struct ocfs2_inline_data *data = &di->id2.i_data;
>  
> @@ -1712,6 +1757,21 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
>  		     le16_to_cpu(di->i_mode),
>  		     (unsigned long long)le64_to_cpu(di->id1.dev1.i_rdev));
>  		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
> +		goto bail;
> +	}
> +
> +	if (ocfs2_dinode_has_size_without_clusters(sb, di)) {
> +		if (S_ISDIR(le16_to_cpu(di->i_mode)))
> +			mlog(ML_ERROR,
> +			     "Filecheck: invalid dinode #%llu: directory i_size %llu with i_clusters 0 and no inline-data flag\n",
> +			     (unsigned long long)bh->b_blocknr,
> +			     (unsigned long long)le64_to_cpu(di->i_size));
> +		else
> +			mlog(ML_ERROR,
> +			     "Filecheck: invalid dinode #%llu: regular file i_size %llu with i_clusters 0 and no inline-data flag on non-sparse volume\n",
> +			     (unsigned long long)bh->b_blocknr,
> +			     (unsigned long long)le64_to_cpu(di->i_size));
> +		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
>  	}
>  
>  bail:

