Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF5F3B47EF
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Jul 2026 06:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783577998; cv=none; b=qN5Z4SVhzgFvT+femUwwA/XOGHDHoE9ZKp28pmdGkVyESKw8wMtjSeKUNseEaoi244gly2sF7fn/zdNodHefrD5H/gwEfEokcQmyTDr96cMXgI6fwWuPTeZB6h3/yqCJ9++s/hVdQmrNNFEB/nsrDfxry1+XsnESfSP1Wk2JbnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783577998; c=relaxed/simple;
	bh=Y8ySMGkkavdoWV+v32kagBZFlqucKXZ5QtFYKGrfDvI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EhB3K5k/O6l1VNsWVDSzDm/tXXDqVYBjj6hbtNXy0twwZAL5PuNPpb8jZs6yhqlD5yE+x+Rg9Rij5KSeg9yyU3z5taIPb4s2GszuCYZ8mewskibCy5WNRURAdP70ZsWvKuSeO3lJFv/kSpdY9y7+8FtXg9PKX6e5BeOMAnRPkkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=eaX0Dg3A; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="eaX0Dg3A"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783577992; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=+eIa6MrxEeRnQfLFd1GuYxBrFZNEZOOfLQOqW4E8Xm8=;
	b=eaX0Dg3AcGZSNpwIvm0wsMxZNI0Q0lIWStMoBVcsl2dsVys9YdNK9TBgkGRuPccXnnrAmkGJXf4/DtQtF26MdjiYwyEXudjW0WyiloZIYLoD0uAmt3reMXWdXL28bth1CurZGyqD7+BBI1TvPqygbIcl9iE0udv5kJoPq2Kg6UA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R431e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X6jm7yA_1783577991;
Received: from 30.221.145.97(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X6jm7yA_1783577991 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 09 Jul 2026 14:19:52 +0800
Message-ID: <b3ef9f59-f428-410e-9825-f487bccf8622@linux.alibaba.com>
Date: Thu, 9 Jul 2026 14:19:51 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: do not use make_bad_inode() in
 ocfs2_read_inode_block_full()
To: Dmitry Antipov <dmantipov@yandex.ru>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, Heming Zhao <heming.zhao@suse.com>,
 Ahmet Eray Karadag <eraykrdg1@gmail.com>,
 Albin Babu Varghese <albinbabuvarghese20@gmail.com>,
 Al Viro <viro@zeniv.linux.org.uk>, lvc-project@linuxtesting.org,
 syzbot+d222f4b7129379c3d5bc@syzkaller.appspotmail.com
References: <af3d9607-0704-4121-b969-23e1c4b397e4@linux.alibaba.com>
 <20260709060101.207262-1-dmantipov@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260709060101.207262-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/9/26 2:01 PM, Dmitry Antipov wrote:
> This reverts commit 58b6fcd2ab34 ("ocfs2: mark inode bad upon
> validation failure during read").
> 
> Since 'make_bad_inode()' resets inode type to S_IFREG, doing this
> for directory inode during active VFS lookup is likely to confuse
> the latter, including VFS_BUG_ON_INODE() triggered in this case.
> 
> Reported-by: syzbot+d222f4b7129379c3d5bc@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=d222f4b7129379c3d5bc
> Fixes: 58b6fcd2ab34 ("ocfs2: mark inode bad upon validation failure during read")
> Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
> v2: fix typo and add Fixes: tag
> 
> Suggested by Al at https://syzkaller.appspot.com/text?tag=Patch&x=10c51a1a580000.
> 
> I've also verified https://syzkaller.appspot.com/bug?extid=b93b65ee321c97861072
> and this issue is no longer triggered when 'make_bad_inode()' is dropped. And note
> https://lore.kernel.org/all/57qlrwjb2kxgolx4yim3jsdflunh2gvqhsqq5ttsfenbjfl4vu@3nliqvyxsnhb
> as well.
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

