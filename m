Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D086814883F
	for <ocfs2-devel@lists.linux.dev>; Tue,  8 Jul 2025 02:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751941117; cv=none; b=hrL7xj/uBVa6OCNMpn14ID62HsgLaNjLTm8p5UwLCBBHa1hG7yA9xbzw3kW9zvZ/IUTgXEGfvdASqwlSy8zOhpj1rWjDrCDiEgrV8rWZKF1/0Ftk4k63TKvmu2p3Typ9wGMKghMMBukfEkOq1g0dt3yx0BXmGM/6IYoMlj4DRHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751941117; c=relaxed/simple;
	bh=ZNHUZ+tT0yrU7JZLvrS0/qNJmRKMBB0jg8ps7QSu6fA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZXjrAbTmv3Hcp/mhbK5zjkRqfByEMSx1kxzO6FurSE/0yKpxrMSdpXXeKTGZYRxgWStsrBD94zqb8atjkVk53vsSoKtGsMNcjQLjDYscoJKu6krz4U2H3tbBNys6ocQVUa+8SoU/0OG/KxoEpHS+ocI1T+5gqeDhnHGkZB73VEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=H1grJFoS; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="H1grJFoS"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1751941112; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=2jhGGiHmGxaL8Inlgyf0owpRbw5Bsthe4dkvJ4yz/tg=;
	b=H1grJFoSwDVARqKnAIX+VlXX5C/3w4JUvzsOUOtFfmcHWfKeruiUMGPgLlBXguRQUKIUOoHYnnVRt0JPNLiDTKqn6mC8eHU1ujEh4uEZ7oDQs8DvlkITNOjWAqrhhVUaMI6xYVLvMBeUkGlsQw52glhXMxfEnj4AG3DE2Vdos+k=
Received: from 30.221.128.116(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WiJ.KmD_1751940794 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 08 Jul 2025 10:13:15 +0800
Message-ID: <c4f6e4a2-1127-43a0-8566-3c493a2795fe@linux.alibaba.com>
Date: Tue, 8 Jul 2025 10:13:14 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] ocfs2: avoid potential ABBA deadlock by reordering
 tl_inode lock
To: Ivan Pravdin <ipravdin.official@gmail.com>, mark@fasheh.com,
 jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>
Cc: syzbot+6bf948e47f9bac7aacfa@syzkaller.appspotmail.com
References: <20250708020640.387741-1-ipravdin.official@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250708020640.387741-1-ipravdin.official@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/7/8 10:06, Ivan Pravdin wrote:
> In ocfs2_move_extent(), tl_inode is currently locked after the global
> bitmap inode. However, in ocfs2_flush_truncate_log(), the lock order
> is reversed: tl_inode is locked first, followed by the global bitmap
> inode.
> 
> This creates a classic ABBA deadlock scenario if two threads attempt
> these operations concurrently and acquire the locks in different orders.
> 
> To prevent this, move the tl_inode locking earlier in
> ocfs2_move_extent(), so that it always precedes the global bitmap
> inode lock.
> 
> No functional changes beyond lock ordering.
> 
> Reported-by: syzbot+6bf948e47f9bac7aacfa@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/67d5645c.050a0220.1dc86f.0004.GAE@google.com/
> Signed-off-by: Ivan Pravdin <ipravdin.official@gmail.com>

Looks fine.

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> v1 -> v2: Fixed unlocking order in ocfs2_move_extent.
> v2 -> v3: Added missing out_unlock_tl_inode and renamed out_unlock_gb_mutex to                                                                                  
>           out_unlock_gb_inode and out_unlock_gb_inode to out_unlock.
> v3 -> v4: Rearranged gb_inode cleanup.
> 
>  fs/ocfs2/move_extents.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> index 369c7d27befd..cbe2f8ed8897 100644
> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -617,6 +617,8 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
>  	 */
>  	credits += OCFS2_INODE_UPDATE_CREDITS + 1;
>  
> +	inode_lock(tl_inode);
> +
>  	/*
>  	 * ocfs2_move_extent() didn't reserve any clusters in lock_allocators()
>  	 * logic, while we still need to lock the global_bitmap.
> @@ -626,7 +628,7 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
>  	if (!gb_inode) {
>  		mlog(ML_ERROR, "unable to get global_bitmap inode\n");
>  		ret = -EIO;
> -		goto out;
> +		goto out_unlock_tl_inode;
>  	}
>  
>  	inode_lock(gb_inode);
> @@ -634,16 +636,14 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
>  	ret = ocfs2_inode_lock(gb_inode, &gb_bh, 1);
>  	if (ret) {
>  		mlog_errno(ret);
> -		goto out_unlock_gb_mutex;
> +		goto out_unlock_gb_inode;
>  	}
>  
> -	inode_lock(tl_inode);
> -
>  	handle = ocfs2_start_trans(osb, credits);
>  	if (IS_ERR(handle)) {
>  		ret = PTR_ERR(handle);
>  		mlog_errno(ret);
> -		goto out_unlock_tl_inode;
> +		goto out_unlock;
>  	}
>  
>  	new_phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, *new_phys_cpos);
> @@ -703,15 +703,14 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
>  out_commit:
>  	ocfs2_commit_trans(osb, handle);
>  	brelse(gd_bh);
> -
> -out_unlock_tl_inode:
> -	inode_unlock(tl_inode);
> -
> +out_unlock:
>  	ocfs2_inode_unlock(gb_inode, 1);
> -out_unlock_gb_mutex:
> +out_unlock_gb_inode:
>  	inode_unlock(gb_inode);
>  	brelse(gb_bh);
>  	iput(gb_inode);
> +out_unlock_tl_inode:
> +	inode_unlock(tl_inode);
>  
>  out:
>  	if (context->meta_ac) {

