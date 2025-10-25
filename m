Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644D91DE2A7
	for <ocfs2-devel@lists.linux.dev>; Sat, 25 Oct 2025 12:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761395170; cv=none; b=tzSFajHE8WdUUcRH/lskjTJD4n52bZPxJ94hDaTmr2kJZXPcHk3jsGrGKD9K21X1R6ZR8ShIkCwsO0JWPyZseuXGRA+v7HxI2djVH9bYSFodmoeNcavq2FRhcYGupAaJgZvLiYer29mS2VLiy4pqI4lDWolR1I8J3r8nvqQgn9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761395170; c=relaxed/simple;
	bh=PFRYpBSeaG+WsFE9kggnbUSJURcLRcmxCXXnc0pakmk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G7RrPqZNc3vbTDYRQ0prjtCH+UFAhbJsF5khrIo170NivvCzShIG7YwEgPJt0kIjlIuDU+y8Yi322d/v9X7LTUoVGFPTy7Iuv/7qClmAf4+63TLcUhLm6iTFv+CinTaDNmR+JAGmpZx9j/PUbRiqs/LKJEU1mLu24SPcZ/E0QMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=oic7mynC; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="oic7mynC"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761395157; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=vpn3y7SUv7rkM/sJZYx//FEZr3hBZxrDCBxuTApyz4c=;
	b=oic7mynC8N3UYRZO0ctmXspKr8ZRwdkFxtx4L6w0OiJjec3TUrRi/X57hCVjgmkIWLv2Bg2Xh+pW9IANtvAeTvmSvU8NklVg21UsjYeAGDYi7Z/ErUmCGSsizZThLkK7Rg4n8QcCmnm748mN5L7ythyVZa63xMkWTEnJSQRfHys=
Received: from 30.41.143.132(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WqwzOOH_1761395156 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 25 Oct 2025 20:25:57 +0800
Message-ID: <ec8bf61b-3695-486c-8c35-df39cbd4542c@linux.alibaba.com>
Date: Sat, 25 Oct 2025 20:25:56 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: add inline inode consistency check to
 ocfs2_validate_inode_block()
To: Dmitry Antipov <dmantipov@yandex.ru>, Heming Zhao <heming.zhao@suse.com>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+c16daba279a1161acfb0@syzkaller.appspotmail.com
References: <20251023141650.417129-1-dmantipov@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251023141650.417129-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/10/23 22:16, Dmitry Antipov wrote:
> In 'ocfs2_validate_inode_block()', add an extra check whether an inode
> with inline data (i.e. self-contained) has no clusters, thus preventing
> an invalid inode from being passed to 'ocfs2_evict_inode()' and below.
> 
> Reported-by: syzbot+c16daba279a1161acfb0@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=c16daba279a1161acfb0
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/inode.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index fcc89856ab95..5fad0a56cc98 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1503,6 +1503,14 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		goto bail;
>  	}
>  
> +	if ((le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) &&
> +	    le32_to_cpu(di->i_clusters)) {
> +		rc = ocfs2_error(sb, "Invalid dinode %llu: %u clusters\n",
> +				 (unsigned long long)bh->b_blocknr,
> +				 le32_to_cpu(di->i_clusters));
> +		goto bail;
> +	}
> +
>  	rc = 0;
>  
>  bail:

