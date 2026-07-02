Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABE43148D3
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Jul 2026 12:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782994728; cv=none; b=KmLNyX7bET7DhBUwrK7M7ebLionTj54kl097Ucy8fBAUtL4LxMRqr9MKYCK+E/bVD/mO0Yi3BE4U3K/xTsoXj75AtAjKTQ8WJJyH2IlnsV1sBKv2qj3yFPocfBzvpdKUEakZJWiG2+taJwWLUJpLwaP+f4QPjZmb5x7PFIqq8Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782994728; c=relaxed/simple;
	bh=rNBqgvorMrpoL/nv7+1/I+Ep2pUoN3/X7SIVQ2GhuPg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UACgxDLEE/kzhq5OLGf78fj8S6FcKXhKrEuZoc0ZmzIEOHwjGkjVyxC8q5JlHWTL3vfHT9HKmQmmNCPiSJfMwc2Db96/7Eqtn3LbUTqfEGdsZC3N6gkqzLbcNWnrAUKhqWI852lBQqW96KUghj1JXU3LnHu1JvgmBnRcIYS1Fiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=iWpOI9WV; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="iWpOI9WV"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782994721; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=df8f+9IStg8FVjWse//uTN+GljTERXGNzDjxxSCZggE=;
	b=iWpOI9WVbXReiZCUkIXXmyl84/avQM57xYmB549p+XD6RrXO9FuqwM2JtFHXqeResDIOKeYjoy96NDT8QSl5YOTjsVZ3OHxc0d7SdNJYNpfOGkwsSFP8FJsE1VJ+Ls82nEC7KR/3+u8Ium5AlLZHNChNpUkySD5nied/dkesaYs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X6EfAij_1782994720;
Received: from 30.221.145.54(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X6EfAij_1782994720 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 02 Jul 2026 20:18:40 +0800
Message-ID: <05f7e478-513b-43a7-9167-1eb426472a42@linux.alibaba.com>
Date: Thu, 2 Jul 2026 20:18:39 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: fix hung task in orphan recovery
To: Jiaming Zhang <r772577952@gmail.com>, akpm <akpm@linux-foundation.org>
Cc: jlbec@evilplan.org, linux-kernel@vger.kernel.org, mark@fasheh.com,
 ocfs2-devel@lists.linux.dev, syzkaller@googlegroups.com
References: <fc9e15ad-5e53-4aab-88f0-61c73e6739c9@linux.alibaba.com>
 <20260702090507.446517-1-r772577952@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260702090507.446517-1-r772577952@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/2/26 5:05 PM, Jiaming Zhang wrote:
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

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
> Changes in v2:
> - Propagate the actual error from ocfs2_empty_dir() to caller.
> - Update ocfs2_unlink() and ocfs2_rename() to distinguish errors from a
>   non-empty directory result.
> 
>  fs/ocfs2/dir.c   | 20 ++++++++++++++------
>  fs/ocfs2/namei.c | 11 ++++++++---
>  2 files changed, 22 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index 8e6b03238327..baf3eca7b4e4 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -1866,6 +1866,7 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
>  	struct super_block * sb = inode->i_sb;
>  	unsigned int ra_sectors = 16;
>  	int stored = 0;
> +	int ret;
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
> @@ -2167,7 +2171,7 @@ static int ocfs2_empty_dir_dx(struct inode *inode,
>  /*
>   * routine to check that the specified directory is empty (for rmdir)
>   *
> - * Returns 1 if dir is empty, zero otherwise.
> + * Returns 1 if dir is empty, zero if not, and a negative errno on error.
>   *
>   * XXX: This is a performance problem for unindexed directories.
>   */
> @@ -2180,8 +2184,10 @@ int ocfs2_empty_dir(struct inode *inode)
>  
>  	if (ocfs2_dir_indexed(inode)) {
>  		ret = ocfs2_empty_dir_dx(inode, &priv);
> -		if (ret)
> +		if (ret) {
>  			mlog_errno(ret);
> +			return ret;
> +		}
>  		/*
>  		 * We still run ocfs2_dir_foreach to get the checks
>  		 * for "." and "..".
> @@ -2189,8 +2195,10 @@ int ocfs2_empty_dir(struct inode *inode)
>  	}
>  
>  	ret = ocfs2_dir_foreach(inode, &priv.ctx);
> -	if (ret)
> +	if (ret) {
>  		mlog_errno(ret);
> +		return ret;
> +	}
>  
>  	if (!priv.seen_dot || !priv.seen_dot_dot) {
>  		mlog(ML_ERROR, "bad directory (dir #%llu) - no `.' or `..'\n",
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 1277666c77cd..abce59e1f180 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -945,7 +945,10 @@ static int ocfs2_unlink(struct inode *dir,
>  	child_locked = 1;
>  
>  	if (S_ISDIR(inode->i_mode)) {
> -		if (inode->i_nlink != 2 || !ocfs2_empty_dir(inode)) {
> +		status = ocfs2_empty_dir(inode);
> +		if (status < 0)
> +			goto leave;
> +		if (inode->i_nlink != 2 || !status) {
>  			status = -ENOTEMPTY;
>  			goto leave;
>  		}
> @@ -1499,8 +1502,10 @@ static int ocfs2_rename(struct mnt_idmap *idmap,
>  
>  	if (target_exists) {
>  		if (S_ISDIR(new_inode->i_mode)) {
> -			if (new_inode->i_nlink != 2 ||
> -			    !ocfs2_empty_dir(new_inode)) {
> +			status = ocfs2_empty_dir(new_inode);
> +			if (status < 0)
> +				goto bail;
> +			if (new_inode->i_nlink != 2 || !status) {
>  				status = -ENOTEMPTY;
>  				goto bail;
>  			}

