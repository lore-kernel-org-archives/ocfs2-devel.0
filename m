Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839A91991B6
	for <ocfs2-devel@lists.linux.dev>; Mon,  6 Jan 2025 05:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736141433; cv=none; b=OzugcppdZITSOl6GMxT5SBjXL4bifR7JekguYSazQPTiL/y6wvVuH2AY9+G2/Z1oQnUhJx4oVDs6bbkuFZfvwO9+DU8Mxry7J5rdPGcNv9CLbCkrCStX3jEP00r+lb2VyU7FsSTj56zZmkSfIYG5Rg1oOeDek6OPzFuvigScMQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736141433; c=relaxed/simple;
	bh=bIQCwxjexX4Z/taRcssk0UNEmGE4Adh0+4WLbmrNvaE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NmzDpYJYSdBQ3EEIpI4T/wFiazPV/YPrB5ztn6Ew2HG3utgT98uwpqKDrUjQvVQuDyV/uYyvW7PLJBwrI/Ej2infTDkGN/yZYZruI976AqEMOGn0wtBXLh1ZodfhBZv4iXWh0FGB66YPqYf0n9eqWlxbd+WsLJhYLW+2aWv73hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=CxBn0wr6; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="CxBn0wr6"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1736141427; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=qPwdxQdHahBahfJiQr2KlNnPEz5NnTOe6acq3b/Ym5o=;
	b=CxBn0wr6kFzXSlLxg2W4emsfYUMFJJQfb49k2e0xYyu7xFWshvoanD6kB6JjAoZEIwCFH248hcG8PgCwV7bOwvpRdPoF0dWaBJUyB+tqBPlIVsRMPgnAFkAj/7C/DzwG46VSklp0+rJz3G3E2TZx3l/qyD3DF7QAAi6miUHN7QA=
Received: from 30.221.130.9(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WN-J-kM_1736141426 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 06 Jan 2025 13:30:26 +0800
Message-ID: <becf44a7-f244-4598-937f-52075a3613e5@linux.alibaba.com>
Date: Mon, 6 Jan 2025 13:30:26 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/2] ocfs2: Correct l_next_free_rec in online check
To: Julian Sun <sunjunchao2870@gmail.com>, ocfs2-devel@lists.linux.dev,
 akpm <akpm@linux-foundation.org>
Cc: mark@fasheh.com, jlbec@evilplan.org
References: <20250106023432.1320904-1-sunjunchao2870@gmail.com>
 <20250106023432.1320904-2-sunjunchao2870@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250106023432.1320904-2-sunjunchao2870@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/1/6 10:34, Julian Sun wrote:
> Correct the value of l_next_free_rec to l_count during the online
> check, as done in the check_el() function in ocfs2_tools.
> 
> Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>


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

