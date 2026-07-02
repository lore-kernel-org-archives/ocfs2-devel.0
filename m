Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34BE31691A
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Jul 2026 03:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782964484; cv=none; b=FtAm6GEPMwjcH9VOqd0s6jelmIOVHbq7ARoU3LoPbHmz7yI4OTPORZoKXR2kQi1BHUCrCIH9fVyIvJI768Xbwzi2Wexus/FWN2uJq9IvtmDP6vzGZO4tD3vfZjTkAUjqXGLXTFn5BsFN2msQ7zr/6sN978rNJAU0wOMRFxRaE/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782964484; c=relaxed/simple;
	bh=zBP1I8t6EPMrnTXbhBb9yn9l+0LBdLA3JQYEuourW8g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=imIOOuruJu8iJooSu5XxAyQtYvO198ocnLy4XJhupdB97tUIMLQY7KGPvR5ObpCoRniJRzM0TIqGTjm8ywTb66Qgnox9m2kjVCiT7bqJOCch9k3ubS1Nzd4R2T6dW7T6dGUP6fAHasgTCuj99lIsHacdTMcwYHjXHBeXi4OcRS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=dkwM9aAQ; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="dkwM9aAQ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782964474; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=skYOmBD3tKVUe7vKNtr9Lw4E7NCEJ/FG5fK414Imq/s=;
	b=dkwM9aAQ23M2VyJoebd1LvKJX9Hl+RrnjGvCAbCPYGjA7aZImVSCU3OQFUnltuxjlI+rRjSe+MDDAyQjQn8hcoqcPvkfKWH4BZxwNSeW3vRTEilXHUiq+mtEOOcthD5hR97xwxAkwA74ideXBun4olhdI/Hrja3OSlLo0FgWDzc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X6CfuWR_1782964472;
Received: from 30.221.145.54(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X6CfuWR_1782964472 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 02 Jul 2026 11:54:32 +0800
Message-ID: <fc9e15ad-5e53-4aab-88f0-61c73e6739c9@linux.alibaba.com>
Date: Thu, 2 Jul 2026 11:54:31 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix hung task in orphan recovery
To: Jiaming Zhang <r772577952@gmail.com>, mark@fasheh.com, jlbec@evilplan.org
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@lists.linux.dev,
 syzkaller@googlegroups.com
References: <CANypQFbWH76Y6LWHEwAvTP7aQL04uMJ=dDyL6YDmxa3fv3Tyjg@mail.gmail.com>
 <20260701091613.1008755-1-r772577952@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260701091613.1008755-1-r772577952@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/1/26 5:16 PM, Jiaming Zhang wrote:
> A crafted OCFS2 image with corrupted orphan-directory extent metadata can make
> umount hang.
> 
> During unmount, ocfs2_recovery_disable() waits for the ocfs2_complete_recovery
> work item to finish. The worker scans the orphan directory through
> ocfs2_queue_orphans() and ocfs2_dir_foreach(). If ocfs2_read_dir_block() fails
> on a corrupted directory block, ocfs2_dir_foreach_blk_el() skips the block and
> continues walking. On a badly corrupted directory this can keep orphan recovery
> busy for a long time, leaving umount blocked while flushing osb->ocfs2_wq.
> 
> Return the read error immediately for full directory scans and propagate the
> error from ocfs2_dir_foreach(). When ocfs2_empty_dir() receives such an error,
> report the directory as non-empty so unlink/rmdir does not proceed on an
> unreadable directory.
> 
> Closes: https://lore.kernel.org/lkml/CANypQFbWH76Y6LWHEwAvTP7aQL04uMJ=dDyL6YDmxa3fv3Tyjg@mail.gmail.com/
> Assisted-by: Codex:gpt-5.5-xhigh
> Signed-off-by: Jiaming Zhang <r772577952@gmail.com>
> ---
>  fs/ocfs2/dir.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index 8e6b03238327..9bebf28f4b77 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -1866,6 +1866,7 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
>  	struct super_block * sb = inode->i_sb;
>  	unsigned int ra_sectors = 16;
>  	int stored = 0;
> +	int ret = 0;
>  
>  	bh = NULL;
>  
> @@ -1873,9 +1874,13 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
>  
>  	while (ctx->pos < i_size_read(inode)) {
>  		blk = ctx->pos >> sb->s_blocksize_bits;
> -		if (ocfs2_read_dir_block(inode, blk, &bh, 0)) {
> +		ret = ocfs2_read_dir_block(inode, blk, &bh, 0);
> +		if (ret) {
> +			if (persist)
> +				return ret;
>  			/* Skip the corrupt dirblock and keep trying */
>  			ctx->pos += sb->s_blocksize - offset;
> +			offset = 0;
>  			continue;
>  		}
>  
> @@ -1950,7 +1955,7 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
>  		if (!persist && stored)
>  			break;
>  	}
> -	return 0;
> +	return ret;
>  }
>  
>  static int ocfs2_dir_foreach_blk(struct inode *inode, u64 *f_version,
> @@ -1969,8 +1974,7 @@ static int ocfs2_dir_foreach_blk(struct inode *inode, u64 *f_version,
>  int ocfs2_dir_foreach(struct inode *inode, struct dir_context *ctx)
>  {
>  	u64 version = inode_query_iversion(inode);
> -	ocfs2_dir_foreach_blk(inode, &version, ctx, true);
> -	return 0;
> +	return ocfs2_dir_foreach_blk(inode, &version, ctx, true);
>  }
>  
>  /*
> @@ -2189,8 +2193,10 @@ int ocfs2_empty_dir(struct inode *inode)
>  	}
>  
>  	ret = ocfs2_dir_foreach(inode, &priv.ctx);
> -	if (ret)
> +	if (ret) {
>  		mlog_errno(ret);
> +		return 0;

Here returns 0 when a read fails, and it then converts to -ENOTEMPTY.
It seems we'd better not swallow the real error. So a cleaner approach
would be to propagate the actual error. And caller distinguish it like:

status = ocfs2_empty_dir(inode);
if (status < 0)
	goto leave;
if (inode->i_nlink != 2 || !status) {
	status = -ENOTEMPTY;
	goto leave;
}

Thanks,
Joseph

> +	}
>  
>  	if (!priv.seen_dot || !priv.seen_dot_dot) {
>  		mlog(ML_ERROR, "bad directory (dir #%llu) - no `.' or `..'\n",

