Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C031B87EC
	for <ocfs2-devel@lists.linux.dev>; Fri,  3 Jan 2025 09:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735898072; cv=none; b=Ty5XT9Kss1Q75pROt76a+xtapBPlygL6A3ASUVdMALLJ595VR70+t0yZibnOm6MGvyDzJvqunA+rO5mW5jHxa9YRhIzrCum5mHg2pDpXbwkpmt1NuSRYhqYtUuR9XLk2yVGX9Uohg0WsQgV4Q6ismHXOcIf7IfuzBrNyEjeX8W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735898072; c=relaxed/simple;
	bh=Uu6GlRU1XZpOIePyFJjiPNFbM4Tm9n5OrfYdmzK2rWk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eMiYXb0aFbqohggMECDWauu5idvG4oYTEmmLPq3MUFpXsw8RGAixoT4qo52XBs7s1DtL9GQw2g1QicSfnYwqRPRYYjTmkANAvrA+UgnzUaUFX1F/3gCMr2ecnIky0EX2jif23yX0q0sDMrPptMtF518pseuw/nzXKw2yIfDJVoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=jCjJZ4se; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="jCjJZ4se"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1735898059; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=SeyzzZhHlf5Q4Fro5pEMFrHsl5pNoReQfeQuAPW436I=;
	b=jCjJZ4seV2sB0Tb7WQguf7InDITFf83qagKWN1MzFhD8X2KX/YZX5A9fbL94up0SoVXIdRHfrJ1PjUAsR2Zj/LYHG1jz7z9KwUvUI49oDa0A0E32k0YYR4d0f6CoQocu0NHyiAxj8LLh59U8YmrARXavm/8GtZLQY8FtkO3aDq4=
Received: from 30.221.128.253(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WMsy1-a_1735898058 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 03 Jan 2025 17:54:18 +0800
Message-ID: <3ffdfa39-17f8-4d92-ba16-147810ed0031@linux.alibaba.com>
Date: Fri, 3 Jan 2025 17:54:17 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] ocfs2: Correct l_next_free_rec in online check
To: Julian Sun <sunjunchao2870@gmail.com>, ocfs2-devel@lists.linux.dev
Cc: mark@fasheh.com, jlbec@evilplan.org
References: <20250103050202.825893-1-sunjunchao2870@gmail.com>
 <20250103050202.825893-2-sunjunchao2870@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250103050202.825893-2-sunjunchao2870@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/1/3 13:02, Julian Sun wrote:
> Correct the value of l_next_free_rec to l_count during the online
> check, as done in the check_el() function in ocfs2_tools.
> 
> Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/inode.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 2cc5c99fe941..1c396c547d9d 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -200,6 +200,20 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
>  	return inode;
>  }
>  
> +static int ocfs2_dinode_has_extents(struct ocfs2_dinode *di)
> +{
> +	/* inodes flagged with other stuff in id2 */
> +	if (di->i_flags & (OCFS2_SUPER_BLOCK_FL | OCFS2_LOCAL_ALLOC_FL |
> +			   OCFS2_CHAIN_FL | OCFS2_DEALLOC_FL))
> +		return 0;
> +	/* i_flags doesn't indicate when id2 is a fast symlink */
> +	if (S_ISLNK(di->i_mode) && di->i_size && di->i_clusters == 0)
> +		return 0;
> +	if (di->i_dyn_features & OCFS2_INLINE_DATA_FL)
> +		return 0;
> +
> +	return 1;
> +}
>  
>  /*
>   * here's how inodes get read from disk:
> @@ -1547,6 +1561,16 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
>  		     le32_to_cpu(di->i_fs_generation));
>  	}
>  
> +	if (ocfs2_dinode_has_extents(di) &&
> +	    le16_to_cpu(di->id2.i_list.l_next_free_rec) > le16_to_cpu(di->id2.i_list.l_count)) {
> +		di->id2.i_list.l_next_free_rec = di->id2.i_list.l_count;
> +		changed = 1;
> +		mlog(ML_ERROR,
> +		     "Filecheck: reset dinode #%llu: l_next_free_rec to %u\n",
> +		     (unsigned long long)bh->b_blocknr,
> +		     le16_to_cpu(di->id2.i_list.l_next_free_rec));
> +	}
> +
>  	if (changed || ocfs2_validate_meta_ecc(sb, bh->b_data, &di->i_check)) {
>  		ocfs2_compute_meta_ecc(sb, bh->b_data, &di->i_check);
>  		mark_buffer_dirty(bh);

