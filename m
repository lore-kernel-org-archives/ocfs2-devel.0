Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD9F3232
	for <ocfs2-devel@lists.linux.dev>; Fri,  3 Jan 2025 01:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735867346; cv=none; b=WBjP2lGVRPustj7LtjBhyELcDk/xX5/Ty/sxyxDo/5iME7nijMZsNfgfGufmWaBjzGaK9Pn+ZUcesREmNiqy8e6WkNwRHigWfB3T3ZcXwCP27jmmi1N+rEH0PhaUH5zkbQwKub6hCaPrzO2dChydQFHvTGwnX94ow7/St5pkHwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735867346; c=relaxed/simple;
	bh=q5T66mfGa9pwYkZo+srCwo1N6VNf/HZ23vmi8Fk9I2Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bDjbqg9XWY74rFmeXKwRcJIWhggVsvwJ6WyidVJOoUhUMDqpeO0JbToB8P+tLE/wmG9tcb44g8//9HV+ViK4mr+uLrborBi5Pq+Gwx+U+10ZtcSEbonb5F7CRiZlojW2YLVktmn6FkY1tat7lZmnY2WosyhZs9+661yqV+1U9LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=JisTXLdM; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="JisTXLdM"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1735867341; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Dboa1Th6ME3R4fLZ0g/A0QdM8GLCX1PGUT/xTYvBniY=;
	b=JisTXLdMBLngnSQDNieZ3OnTl2pJiX0vuMhE1rGcXctJZXHPreReMGnDgaA3p/n+tPpiYRDc/N9ZTaKPmkcW1ZLQDgjWsLDEvqG6LpJobXxZ9voSsytu0+LZN3If9B5bzPhP/AZ3H+FS2CmOoR9pWNb6/ZYiznSA4kdl1ICXL3g=
Received: from 30.221.128.253(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WMrPyyn_1735867339 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 03 Jan 2025 09:22:20 +0800
Message-ID: <d0cae4f9-f9de-42d6-b2a6-0a7e1352746b@linux.alibaba.com>
Date: Fri, 3 Jan 2025 09:22:19 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ocfs2: Correct l_next_free_rec in online check
To: Julian Sun <sunjunchao2870@gmail.com>, ocfs2-devel@lists.linux.dev
Cc: mark@fasheh.com, jlbec@evilplan.org
References: <20250102124539.711325-1-sunjunchao2870@gmail.com>
 <20250102124539.711325-2-sunjunchao2870@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250102124539.711325-2-sunjunchao2870@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/1/2 20:45, Julian Sun wrote:
> Correct the value of l_next_free_rec to l_count during the online
> check, as done in the check_el() function in ocfs2_tools.
> 
> Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
> ---
>  fs/ocfs2/inode.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 2cc5c99fe941..c19f40b4c876 100644
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
> +	if (ocfs2_dinode_has_extents(di) && le16_to_cpu(di->id2.i_list.l_next_free_rec) >
> +	    le16_to_cpu(di->id2.i_list.l_count)) {

Seems the following way looks better.

if (ocfs2_dinode_has_extents(di) &&
    le16_to_cpu(di->id2.i_list.l_next_free_rec) > le16_to_cpu(di->id2.i_list.l_count)) {
	...
}

So could you please resend this series with prefix 'PATCH v2'?

Thanks,
Joseph

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

