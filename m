Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4501D8E10
	for <ocfs2-devel@lists.linux.dev>; Mon,  7 Jul 2025 01:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751851984; cv=none; b=LaDzLR3LMa0hRcdnk5O1QqgbpDOE1IItqRn9H7lj8WFlO1B7qPUR93g1x8ElbR7OUGMeZN5A5C8bG1y1GdDTUD6JVb4UnYr5Xz/vlEdkQK7xT7sT6LTCqNK9R1JoQi1HbS8pdIMznHMYtKl4MK9m9DINfpfuMmvTdK5jhy+s6/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751851984; c=relaxed/simple;
	bh=VhBAXVHqA2y0PKoVp3MooK8qYZAANLEWHU3SLrh79x0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NOhxL0lAoYeOIT6DyC6IYYO5sK99qCXFfgEWaHJJk+Io3/6B9IUfYOGYq4PVquT9fj6AODLkMasrQyYu0HE79CjObUIbhs9/AGWZLDv2Xc3M0J8cGWCXcA5J/ixpGAodGhtPHGWhcoAdqYcO+KMU4ekkYxPk2OVP9iLi5y5aCY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Zrn8ej2q; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Zrn8ej2q"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1751851973; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=O+fTTXT8PE7FD3pk+VZsqgiXBxLh6UlUQp+bxT5zKic=;
	b=Zrn8ej2q246Nmx+M4jLo4Nn3v3jmldh3butCz8KdV71o3GxXpUep6OvxvudfGUFUcN9YAdGWkYM0vFy5y9z1y6Af7M5IIW7Pfaw36BeBYelm5GpMyUp5c5mRspuP9rkaaLH1ySjQK5LzaNQbT2iSEw+HQryEP7/hieZjmLVk73A=
Received: from 30.221.128.189(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WhxrwvO_1751851972 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 07 Jul 2025 09:32:52 +0800
Message-ID: <02850dc3-1827-433a-89f1-b66553efe02a@linux.alibaba.com>
Date: Mon, 7 Jul 2025 09:32:52 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: avoid potential ABBA deadlock by reordering
 tl_inode lock
To: Ivan Pravdin <ipravdin.official@gmail.com>, mark@fasheh.com,
 jlbec@evilplan.org, ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Cc: syzbot+6bf948e47f9bac7aacfa@syzkaller.appspotmail.com
References: <20250705175315.225246-1-ipravdin.official@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250705175315.225246-1-ipravdin.official@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/7/6 01:53, Ivan Pravdin wrote:
> In ocfs2_move_extent(), tl_inode is currently locked after the global
> bitmap inode. However, in ocfs2_flush_truncate_log(), the lock order
> is reversed: tl_inode is locked first, followed by the global bitmap
> inode.
> 
It's indeed buggy here.

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
>  fs/ocfs2/move_extents.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> index 369c7d27befd..ab460cb2c9c8 100644
> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -617,6 +617,8 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
>  	 */
>  	credits += OCFS2_INODE_UPDATE_CREDITS + 1;
>  
> +	inode_lock(tl_inode);
> +

The following out_unlock should do the corresponding order changes.

Thanks,
Joseph

>  	/*
>  	 * ocfs2_move_extent() didn't reserve any clusters in lock_allocators()
>  	 * logic, while we still need to lock the global_bitmap.
> @@ -637,8 +639,6 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
>  		goto out_unlock_gb_mutex;
>  	}
>  
> -	inode_lock(tl_inode);
> -
>  	handle = ocfs2_start_trans(osb, credits);
>  	if (IS_ERR(handle)) {
>  		ret = PTR_ERR(handle);

