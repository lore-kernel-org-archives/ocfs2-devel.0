Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE1B1E98EF
	for <ocfs2-devel@lists.linux.dev>; Tue, 14 Oct 2025 00:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760403352; cv=none; b=tH+P+2ArMevFejE2fZy4eogIx0VqJLtn75F7cBInz1Z50h3M9f5Xm+UY8+eKmnTF6TEutbjJNuKn3oJ8SgS0AYauBVT5t49M8UXeIDs2S24n7dd076zgzdDB2KLnOTVJ1MAtam2J7Ny9LEc/J8FID65n4r2+MiK6gC2YCkc9oo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760403352; c=relaxed/simple;
	bh=9+MWk44b2CZWlVYJuYjqSW86+hVeoQyTDIV4/yKMOLg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BfjkhYThkp8t+hHsIpdaTGD4IhBe36Ski2qFEY+MUUTBOCrqtebarrUoFIlRDriIdldwF0/SQBxF8xinbB7TqRx1NGreHywTmso2ol22dJkUFtc0hsEGViVsD9rxas6Q+6JW9lXf20smRum/JAnP+6f6RI0oGkf9ceewQdHB7a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=qGIDcOGi; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="qGIDcOGi"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760403346; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=4n9m5WOqiXlGu9zGkX/wYwuI/TCPiVYZiQSTAZ03UNc=;
	b=qGIDcOGiSKQ9ZSOf4Gmwy/LTLRdku8TdEvhCa5o91G0E1vmVCDnt7VcwVG+fMOSd0OdjHzRkGD/N+TEiX43dtAjsGk0pt5/rRQFS4W3tjuVZVtaCyuyoKiNnZeeUOom/BGAVLplQ3tHoNV/5OiiE9YFHXUmqKhT9RTsx4CDrDYM=
Received: from 30.221.128.131(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Wq9adDY_1760403344 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 14 Oct 2025 08:55:44 +0800
Message-ID: <0383ab66-9b8a-4e10-b6a9-d25d127dd797@linux.alibaba.com>
Date: Tue, 14 Oct 2025 08:55:43 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix __counted_by_le() usage in
 ocfs2_expand_inline_dx_root()
To: Dmitry Antipov <dmantipov@yandex.ru>, akpm <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@lists.linux.dev,
 lvc-project@linuxtesting.org, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
References: <20251013153002.167377-1-dmantipov@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251013153002.167377-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/10/13 23:30, Dmitry Antipov wrote:
> After annotating 'l_recs[]' VLA member of 'struct ocfs2_extent_list'
> with '__counted_by_le(l_count)', 'l_count' should be initialized
> before touching 'l_recs[]' with 'memset()' to avoid false positives
> from buffer overflow guards when CONFIG_UBSAN_BOUNDS is enabled.
> 
> Fixes: aa545adbe491 ("ocfs2: annotate flexible array members with __counted_by_le()")
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Andrew, could you please help fold this into the origin patch? Thanks.

> ---
> note: since the commit in subject is not merged to upstream yet, Fixes: reference is taken from
> https://web.git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?h=mm-nonmm-unstable&id=aa545adbe491
> ---
>  fs/ocfs2/dir.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index 3c2dacba9b0a..d9a2fcb63bbb 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -4133,10 +4133,10 @@ static int ocfs2_expand_inline_dx_root(struct inode *dir,
>  	}
>  
>  	dx_root->dr_flags &= ~OCFS2_DX_FLAG_INLINE;
> -	memset(&dx_root->dr_list, 0, osb->sb->s_blocksize -
> -	       offsetof(struct ocfs2_dx_root_block, dr_list));
>  	dx_root->dr_list.l_count =
>  		cpu_to_le16(ocfs2_extent_recs_per_dx_root(osb->sb));
> +	memset(&dx_root->dr_list, 0, osb->sb->s_blocksize -
> +	       offsetof(struct ocfs2_dx_root_block, dr_list));
>  
>  	/* This should never fail considering we start with an empty
>  	 * dx_root. */

