Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D323235B653
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Apr 2026 10:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775815388; cv=none; b=Xq+3PYftuoe9CjHF4WNKfP+bTXcYlqg+SVw6d2Eq3g12M521QcQ4dPccH/rBvdVweD8dm0cwRvrY2Peq3PjTU8B9EuvF7VsFeuESpNMLBLbtbojWVMH/sR0CB29NHMuoeDGjZGMJ09/j56wTXkF9vDsVdi3GqneTHHTFPXh1NDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775815388; c=relaxed/simple;
	bh=9Y95Kcm0ue4HfmOYu5vLLHdeGi55mz17ClLCts4w/fA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O1iPeG8K3YFKvAoqvKADRXIjBJ7CWWmW+NiV0fGsEU1ji21EylOqsNyY6RNl3F3ut4/Gm8CGlRxV+sGVGKOgfyLOStNXnOpPprrpuhDzwhEzLB5czOkzY6qzubQyzkmscA/SB7RgZVLHUZJKR2EtF6vobvuJQ9S/Ae6o5h6LRz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=tcSYOMCY; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="tcSYOMCY"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775815383; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ZgBzVzdXsw+GHkcZagHgdqOEQaBAwNvZFvRO4VZ5scY=;
	b=tcSYOMCYrM7roa5wK20A2Fimdmb/ayV4r51TwxGF3HfMabk7zD4R5EMB4uKYaK1pF+R54sNjbJJm6EGBgEGN1Tq9YKGMFWRMcdp/vG5ZrwiQNDcAzxYYef3XWgxCuyYaGtptA0FPhnI5yhSYajBxjDqQjbVYXYbkpJNojGfFY4A=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R571e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X0kw187_1775815381;
Received: from 30.221.145.28(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X0kw187_1775815381 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Apr 2026 18:03:02 +0800
Message-ID: <1dbba5a6-a7e2-49b4-8475-9f1d338efb5c@linux.alibaba.com>
Date: Fri, 10 Apr 2026 18:03:00 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: validate inline dir size in
 ocfs2_dir_foreach_blk_id
To: ZhengYuan Huang <gality369@gmail.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <20260410062227.3881209-1-gality369@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260410062227.3881209-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/10/26 2:22 PM, ZhengYuan Huang wrote:
> [BUG]
> A crafted inline-data directory can set i_size larger than id_count.
> readdir then walks past data->id_data and KASAN reports:
> 
> BUG: KASAN: use-after-free in ocfs2_check_dir_entry.isra.0+0x31f/0x370 fs/ocfs2/dir.c:305
> Read of size 2 at addr ffff8880088f0008 by task syz.0.1936/4656
> Call Trace:
>  ...
>  ocfs2_check_dir_entry.isra.0+0x31f/0x370 fs/ocfs2/dir.c:305
>  ocfs2_dir_foreach_blk_id+0x203/0xa70 fs/ocfs2/dir.c:1805
>  ocfs2_dir_foreach_blk fs/ocfs2/dir.c:1933 [inline]
>  ocfs2_readdir+0x4ba/0x520 fs/ocfs2/dir.c:1977
>  wrap_directory_iterator+0x9c/0xe0 fs/readdir.c:65
>  shared_ocfs2_readdir+0x29/0x40 fs/ocfs2/file.c:2822
>  iterate_dir+0x276/0x9e0 fs/readdir.c:108
>  __do_sys_getdents64 fs/readdir.c:410 [inline]
>  __se_sys_getdents64 fs/readdir.c:396 [inline]
>  __x64_sys_getdents64+0x143/0x2a0 fs/readdir.c:396
>  ...
> 
> [CAUSE]
> ocfs2_dir_foreach_blk_id() uses i_size_read(inode) as the loop bound
> after reading the inode block. Inline directories are only valid while
> i_size <= le16_to_cpu(data->id_count), but that invariant is never
> checked on read. Once ctx->pos reaches id_count, data->id_data +
> ctx->pos points past the inode block and can land in a freed neighbor
> page.
> 

ocfs2_read_inode_block() has already validated dinode->i_size.
So how it happens for the corrupted in-memory i_size?

Thanks,
Joseph

> [FIX]
> Validate i_size_read(inode) against data->id_count immediately after
> ocfs2_read_inode_block(). If the inline directory size exceeds its
> on-disk capacity, return -EFSCORRUPTED before constructing any dirent
> pointer. Keep the change local to ocfs2_dir_foreach_blk_id() so the
> patch stays scoped to the readdir bug.
> 
> Fixes: 23193e513d1c ("ocfs2: Read support for directories with inline data")
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> ---
>  fs/ocfs2/dir.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index 8c9c4825f984..fa537505d1a9 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -1761,6 +1761,7 @@ static int ocfs2_dir_foreach_blk_id(struct inode *inode,
>  				    struct dir_context *ctx)
>  {
>  	int ret, i;
> +	int error = 0;
>  	unsigned long offset = ctx->pos;
>  	struct buffer_head *di_bh = NULL;
>  	struct ocfs2_dinode *di;
> @@ -1777,6 +1778,12 @@ static int ocfs2_dir_foreach_blk_id(struct inode *inode,
>  	di = (struct ocfs2_dinode *)di_bh->b_data;
>  	data = &di->id2.i_data;
>  
> +	if (unlikely(i_size_read(inode) > le16_to_cpu(data->id_count))) {
> +		error = -EFSCORRUPTED;
> +		mlog_errno(error);
> +		goto out;
> +	}
> +
>  	while (ctx->pos < i_size_read(inode)) {
>  		/* If the dir block has changed since the last call to
>  		 * readdir(2), then we might be pointing to an invalid
> @@ -1819,7 +1826,7 @@ static int ocfs2_dir_foreach_blk_id(struct inode *inode,
>  	}
>  out:
>  	brelse(di_bh);
> -	return 0;
> +	return error;
>  }
>  
>  /*

