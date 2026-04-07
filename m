Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2BE25228D
	for <ocfs2-devel@lists.linux.dev>; Tue,  7 Apr 2026 01:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775527058; cv=none; b=U2dEOHX/vOE3061ULREHxeRVFtTFhv0UolokXPoutz5PK6u1ExHK585LeOVog7irqOi5+pY29h883eIisXL7winIkLgxCsa8rwxk3T+Qy5uL8RbEJvT1ogZGnbD9dvdVzu4uheghvi/y+7OLa4ttuZ7moAwiFYdzyFVyXjdt1Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775527058; c=relaxed/simple;
	bh=OEGYBV4tBgaMe8pexFmzhBQjPUcZtZ3qcGeJVi2O7Tg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X6TEkr1Wpvb7zhFQPmyE3cUiCMa9ICAVQvEGsIP8djdpmYvF7eANkYOqrMc8iyEPZkjTJh8xO7lYaIJI0K5AgTtFDBrngAeTRkCcq2hYblAqx3QZ942KElqsOM87VnuKBBQHGTkHAH26/fwWgvVObmAZlctALyQQKO+arsZs3Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=EXo4uLtx; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="EXo4uLtx"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775527047; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=5/FC/Wmz8VOVkz6T+cUyFs6Dj9JCGpchRUhCqWCWulg=;
	b=EXo4uLtxhumqvohFXUYc4uSCDzBf8wyZivix03X4LF/eK7EWEKoeOmTOgWg/RjUM5HTZF3IBOwWXqR7zSXNs8/FCfncjSU9eeWj7Y+vZWCBsbKknRhDEVfNfdTzjS6f03o73oYpWP+kZRYv7sJkRwEe8cWD8sxY5PmFcisvAnmY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R811e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X0a7ntu_1775527046;
Received: from 30.221.145.153(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X0a7ntu_1775527046 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 07 Apr 2026 09:57:27 +0800
Message-ID: <4ca39fb7-a927-4657-b526-aa2587eac56d@linux.alibaba.com>
Date: Tue, 7 Apr 2026 09:57:26 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ocfs2: use get_random_u32() where appropriate
To: David Carlier <devnexen@gmail.com>, akpm <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260405154720.4732-1-devnexen@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260405154720.4732-1-devnexen@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/5/26 11:47 PM, David Carlier wrote:
> Use the typed random integer helpers instead of
> get_random_bytes() when filling a single integer variable.
> The helpers return the value directly, require no pointer
> or size argument, and better express intent.
> 
> Signed-off-by: David Carlier <devnexen@gmail.com>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index d7c58fd7d438..b875f01c9756 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -2124,7 +2124,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  		osb->osb_cluster_stack[0] = '\0';
>  	}
>  
> -	get_random_bytes(&osb->s_next_generation, sizeof(u32));
> +	osb->s_next_generation = get_random_u32();
>  
>  	/*
>  	 * FIXME

