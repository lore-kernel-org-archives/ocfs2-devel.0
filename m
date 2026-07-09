Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1675518EFD1
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Jul 2026 05:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783575397; cv=none; b=WQOqgDXiQd9GwVvpF8S+M1JcNDM65kt17v+1z3y6id6F2QozhAdhpiHugXtE8MHiPIuOKJuYdIcUHt3iYO/f9oub+n96TwENtWfl+qC01H8wrz57xnWcd51qglYT+tS7Z6AB6RhVPthxlYM2zXOLu2GLBXTBVJ/58WHbtWVo4iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783575397; c=relaxed/simple;
	bh=Lc8lfQDV56GZmEp3D7p0F7vinh1DHB8ta9IhnQ9ijBA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ReFGK+3qqOe4BIacd5hVfxnvXYH9jlr8gkBAXUCdiWnmrBu4yynn+Imn2y6O/l2yrgQztL0tNhdTpxAMf5WyeLQtz9U3UzgsET11jrzHHdUe0fH73w7kyssrejiITcQz2NHi5JRWVhxkja6mpwjer3SIN5/6qNlS/npe4rrnI5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=JM+ywILp; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="JM+ywILp"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783575390; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=NfOm/d4EuICrzgXwdJYUAqwZEmqiHNU47jjQksRe5gk=;
	b=JM+ywILpdHIvQ9AjiB4zDTkVSP/SqfyGnZJlDg6h1Q7J32kszml/csN1vewoJAN5oTcuUjchKZF64e+POn/u5zWDR3iVK/UesMBhMW6GY9yMCwcD93CGdzyObkTubI62lwv3cmghPIpORMuR83pb6cOMz7IujuDaMVKnM5KKU6I=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X6jVdv8_1783575388;
Received: from 30.221.145.97(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X6jVdv8_1783575388 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 09 Jul 2026 13:36:29 +0800
Message-ID: <af3d9607-0704-4121-b969-23e1c4b397e4@linux.alibaba.com>
Date: Thu, 9 Jul 2026 13:36:28 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: do not use make_bad_inode() in
 ocfs2_read_inode_block_full()
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: ocfs2-devel@lists.linux.dev, Heming Zhao <heming.zhao@suse.com>,
 Ahmet Eray Karadag <eraykrdg1@gmail.com>,
 Albin Babu Varghese <albinbabuvarghese20@gmail.com>,
 Al Viro <viro@zeniv.linux.org.uk>, lvc-project@linuxtesting.org,
 syzbot+d222f4b7129379c3d5bc@syzkaller.appspotmail.com
References: <20260708070254.149940-1-dmantipov@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260708070254.149940-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/8/26 3:02 PM, Dmitry Antipov wrote:
> This reverts commit 58b6fcd2ab34 ("ocfs2: mark inode bad upon
> validation failure during read").
> 
> Since 'make_bad_inode()' resets inode type to S_IFREG, doing this
> for directory inode during active VFS lookup ls likely to confuse

s/ls/is?

> the latter, including VFS_BUG_ON_INODE() triggered in this case.
> 
> Reported-by: syzbot+d222f4b7129379c3d5bc@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=d222f4b7129379c3d5bc
> Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

Seems missing 'Fixes' tag here.

Thanks,
Joseph

> ---
> Suggested by Al at https://syzkaller.appspot.com/text?tag=Patch&x=10c51a1a580000.
> 
> I've also verified https://syzkaller.appspot.com/bug?extid=b93b65ee321c97861072
> and this issue is no longer triggered when 'make_bad_inode()' is dropped.
> ---
>  fs/ocfs2/inode.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 662dbc845b8b..b5d109cc9edc 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1948,8 +1948,6 @@ int ocfs2_read_inode_block_full(struct inode *inode, struct buffer_head **bh,
>  	rc = ocfs2_read_blocks(INODE_CACHE(inode), OCFS2_I(inode)->ip_blkno,
>  			       1, &tmp, flags, ocfs2_validate_inode_block);
>  
> -	if (rc < 0)
> -		make_bad_inode(inode);
>  	/* If ocfs2_read_blocks() got us a new bh, pass it up. */
>  	if (!rc && !*bh)
>  		*bh = tmp;

