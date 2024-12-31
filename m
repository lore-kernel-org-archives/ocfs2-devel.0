Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B0F17C230
	for <ocfs2-devel@lists.linux.dev>; Tue, 31 Dec 2024 07:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735629430; cv=none; b=DX2xDNjGxBSqYuFIcwVMadJENLxG6RTOtZ2zCMN+NZP7+0/qcPzhDNN5K0beWmLLaJrCB2JUFR9gl8JyLB8/eRgIutzhxFIHz6mxLhh8afCyXCMcUqpUBAUkxG831iLQx0rQp1TILZEDb4MWPB2DAU6mVHy9kcOuVqgUq74Rtfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735629430; c=relaxed/simple;
	bh=sgN4FlfLzHROxQfIYsloYkcDgguN04D2sEqIqW7NQIc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S8bAw7nJCJ9+yD+UpcLoxfLLaWryfGfOijAqWZRwi+hCtXAVY08MPmYgfVxh3sVs91u7vSussVx65jPaFZtNqlGZczgLk5h/915aVJbrdUuymFXi/q/HXVHNZW7HMqRcw9/Qi6QaEkeDaZm1jmLh1ljgoQQlV8hawuevp0cCHVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=HJIqVIw6; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="HJIqVIw6"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1735629418; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Rkikyf8pCM6pzNjhUAdb7p3r2yXLIgDKbxluHMhKX5s=;
	b=HJIqVIw6EzzWX0w7syO7XxgwNhT7QbgB3LT0raOxGrz8EUv3ysMYoMvNeiLgLD3nvuB7s30zfJCVTtwgUMNAZW1ckGretXlTfBf3pmKjzJgOvCrZOlLLudKCvvBQl7K+VTHzgqhFyj2Gsua4BlY2w5I76f4ES4gKgH38K7n+5z4=
Received: from 30.221.128.146(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WMdE728_1735629416 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 31 Dec 2024 15:16:57 +0800
Message-ID: <df33d96d-e8fb-4de9-99cd-f21e0eee8195@linux.alibaba.com>
Date: Tue, 31 Dec 2024 15:16:55 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: Add a sanity check for corrupted file system.
To: sunjunchao <sunjunchao2870@gmail.com>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
Cc: mark@fasheh.com, jlbec@evilplan.org, sunjunchao <sunjunchao@zspace.cn>,
 syzbot+2313dda4dc4885c93578@syzkaller.appspotmail.com
References: <20241210130827.121584-1-sunjunchao@zspace.cn>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241210130827.121584-1-sunjunchao@zspace.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024/12/10 21:08, sunjunchao wrote:
> Hi,
> 
> Recently syzbot reported a use-after-free issue[1].
> 
> The root cause of the problem is that the journal
> inode recorded in this file system image is corrupted.
> The value of "di->id2.i_list.l_next_free_rec" is 8193,
> which is greater than the value of "di->id2.i_list.l_count" (19).
> 
> To solve this problem, an additional check should be added
> during the validity check. If the check fails, an error will
> be returned and the file system will be set to read-only.
> Also correct the l_next_free_rec value if online check is triggered,
> same as what fsck.ocfs2 does.
> 
> [1]: https://lore.kernel.org/all/67577778.050a0220.a30f1.01bc.GAE@google.com/T/
> 
> Reported-and-tested-by: syzbot+2313dda4dc4885c93578@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=2313dda4dc4885c93578
> Signed-off-by: sunjunchao <sunjunchao@zspace.cn>
> ---
>  fs/ocfs2/inode.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 2cc5c99fe941..d3df54467d73 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1358,6 +1358,21 @@ void ocfs2_refresh_inode(struct inode *inode,
>  	spin_unlock(&OCFS2_I(inode)->ip_lock);
>  }
>  
> +static int has_extents(struct ocfs2_dinode *di)
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
> +
>  int ocfs2_validate_inode_block(struct super_block *sb,
>  			       struct buffer_head *bh)
>  {
> @@ -1386,6 +1401,15 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  
>  	rc = -EINVAL;
>  
> +	if (has_extents(di) && le16_to_cpu(di->id2.i_list.l_next_free_rec) >

Seems has_extent() is used to identify type of extent list?
IMO, ocfs2_validate_inode_block() is a common validation function, so I
don't it is proper to check extent list here.
So how about add the check into ocfs2_get_clusters_nocache()?

> +	    le16_to_cpu(di->id2.i_list.l_count)) {
> +		rc = ocfs2_error(sb, "corrupted dinode #%llu: next_free_rec is %u, count is %u\n",
> +				 (unsigned long long)bh->b_blocknr,
> +				 le16_to_cpu(di->id2.i_list.l_next_free_rec),
> +				 le16_to_cpu(di->id2.i_list.l_count));
> +		goto bail;
> +	}
> +
>  	if (!OCFS2_IS_VALID_DINODE(di)) {
>  		rc = ocfs2_error(sb, "Invalid dinode #%llu: signature = %.*s\n",
>  				 (unsigned long long)bh->b_blocknr, 7,
> @@ -1483,6 +1507,16 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
>  		rc = -OCFS2_FILECHECK_ERR_GENERATION;
>  	}
>  
> +	if (has_extents(di) && le16_to_cpu(di->id2.i_list.l_next_free_rec) >
> +	    le16_to_cpu(di->id2.i_list.l_count)) {
> +		mlog(ML_ERROR,
> +		     "Filecheck: invalid dinode #%llu: l_next_free_rec is %u, l_count is %u\n",
> +		     (unsigned long long)bh->b_blocknr,
> +		     le16_to_cpu(di->id2.i_list.l_next_free_rec),
> +		     le16_to_cpu(di->id2.i_list.l_count));
> +		rc = -OCFS2_FILECHECK_ERR_FAILED;
> +	}
> +
>  bail:
>  	return rc;
>  }
> @@ -1547,6 +1581,16 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
>  		     le32_to_cpu(di->i_fs_generation));
>  	}
>  
> +	if (has_extents(di) && le16_to_cpu(di->id2.i_list.l_next_free_rec) >
> +	    le16_to_cpu(di->id2.i_list.l_count)) {
> +		di->id2.i_list.l_next_free_rec = di->id2.i_list.l_count;
> +		changed = 1;
> +		mlog(ML_ERROR,
> +		     "Filecheck: reset dinode #%llu: l_next_free_rec to %u\n",
> +		     (unsigned long long)bh->b_blocknr,
> +		     le16_to_cpu(di->id2.i_list.l_next_free_rec));
> +	}
> +

For file check, I'd like to post it as a separate patch.

Thanks,
Joseph

>  	if (changed || ocfs2_validate_meta_ecc(sb, bh->b_data, &di->i_check)) {
>  		ocfs2_compute_meta_ecc(sb, bh->b_data, &di->i_check);
>  		mark_buffer_dirty(bh);

