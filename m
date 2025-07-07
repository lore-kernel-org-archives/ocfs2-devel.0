Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF592701CE
	for <ocfs2-devel@lists.linux.dev>; Mon,  7 Jul 2025 05:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751867930; cv=none; b=ufrfldPemnRoYoxaOyTCzxXECKPMktuZRv584isUOkoRtHifqrrqlhGrvMrwnk32aE20mt5yXqkX3hoLQAjHGcXixWQe/jb1TmSbp/JHvIR0EwYB43dqEkcycxx+yS6O+tsqwgLMzOmtJzr1W6mmlh36b+zjDy3UZJHR+dIoDGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751867930; c=relaxed/simple;
	bh=erAIkB7LOGpYmvxNujH0O3YRFgx/4b8oQ5Whg1F3pEM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SybVlKOar/6iq/UGKTFjgzWHxEyffB2H06QZR9R+qmZg+I1PdzqUdPMZTH1XipFU3l2LbW0LXTkjm56PHnLJpfsSw3gbCHv4eYECRjK64+dCL0T3MDiUsu2YIBqCq8ZgKEMIvL4Sj9/rHW3DWLfJoiEczyczhy6oWZsEFrulqB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=RRW3xVTV; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="RRW3xVTV"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1751867919; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=D61ZKyC8LaaZiR6mn2bz16JWb4bNVaWHG2B8QtKxwxM=;
	b=RRW3xVTV9ZybrmudggqcQkXeixQVREpv9TZAxX9Q1JxEdHAzO0bw+iO35uOaDiUu6pyqmgFrDRfXx+NbGDfDXTGMi2N2zXmLjr7/uuXCSlFfkes7x6GnW2Uq0gl1couZ77Dx3G3vzmTneeXY/1lNW8nfxEYWu5i0kaHjo92uYkE=
Received: from 30.221.128.189(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Wi.8bTO_1751867915 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 07 Jul 2025 13:58:36 +0800
Message-ID: <11999e4c-b0ef-4718-8e93-75363729515a@linux.alibaba.com>
Date: Mon, 7 Jul 2025 13:58:35 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: avoid potential ABBA deadlock by reordering
 tl_inode lock
To: Ivan Pravdin <ipravdin.official@gmail.com>, mark@fasheh.com,
 jlbec@evilplan.org, ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Cc: syzbot+6bf948e47f9bac7aacfa@syzkaller.appspotmail.com
References: <20250707032951.361331-1-ipravdin.official@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250707032951.361331-1-ipravdin.official@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/7/7 11:29, Ivan Pravdin wrote:
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
> ---
> v1 -> v2: Fixed unlocking order in ocfs2_move_extent.
> 
>  fs/ocfs2/move_extents.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> index 369c7d27befd..aaf8eb2693a4 100644
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
> @@ -637,13 +639,11 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
>  		goto out_unlock_gb_mutex;
>  	}
>

You've missed unlock tl_inode when ocfs2_get_system_file_inode() fails.

  
> -	inode_lock(tl_inode);
> -
>  	handle = ocfs2_start_trans(osb, credits);
>  	if (IS_ERR(handle)) {
>  		ret = PTR_ERR(handle);
>  		mlog_errno(ret);
> -		goto out_unlock_tl_inode;
> +		goto out_unlock_gb_inode;
>  	}
>  
>  	new_phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, *new_phys_cpos);
> @@ -704,12 +704,13 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
>  	ocfs2_commit_trans(osb, handle);
>  	brelse(gd_bh);
>  
> -out_unlock_tl_inode:
> -	inode_unlock(tl_inode);
> -
> +out_unlock_gb_inode:
>  	ocfs2_inode_unlock(gb_inode, 1);
> +
>  out_unlock_gb_mutex:

inode lock has changed to rw_semaphore, so 'mutex' is no longer proper. 

>  	inode_unlock(gb_inode);
> +
> +	inode_unlock(tl_inode);
>  	brelse(gb_bh);
>  	iput(gb_inode);
>  

How about the following alternative:

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 369c7d27befd..d56c337204f6 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -611,6 +611,8 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
 		goto out;
 	}
 
+	inode_lock(tl_inode);
+
 	/*
 	 * need to count 2 extra credits for global_bitmap inode and
 	 * group descriptor.
@@ -626,7 +628,7 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
 	if (!gb_inode) {
 		mlog(ML_ERROR, "unable to get global_bitmap inode\n");
 		ret = -EIO;
-		goto out;
+		goto out_unlock_tl_inode;
 	}
 
 	inode_lock(gb_inode);
@@ -634,16 +636,14 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
 	ret = ocfs2_inode_lock(gb_inode, &gb_bh, 1);
 	if (ret) {
 		mlog_errno(ret);
-		goto out_unlock_gb_mutex;
+		goto out_unlock_gb_inode;
 	}
 
-	inode_lock(tl_inode);
-
 	handle = ocfs2_start_trans(osb, credits);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		mlog_errno(ret);
-		goto out_unlock_tl_inode;
+		goto out_unlock;
 	}
 
 	new_phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, *new_phys_cpos);
@@ -703,16 +703,14 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
 out_commit:
 	ocfs2_commit_trans(osb, handle);
 	brelse(gd_bh);
-
-out_unlock_tl_inode:
-	inode_unlock(tl_inode);
-
+out_unlock:
 	ocfs2_inode_unlock(gb_inode, 1);
-out_unlock_gb_mutex:
+out_unlock_gb_inode:
 	inode_unlock(gb_inode);
 	brelse(gb_bh);
 	iput(gb_inode);
-
+out_unlock_tl_inode:
+	inode_unlock(tl_inode);
 out:
 	if (context->meta_ac) {
 		ocfs2_free_alloc_context(context->meta_ac);


