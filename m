Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729692C859
	for <ocfs2-devel@lists.linux.dev>; Fri, 24 Oct 2025 01:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761268204; cv=none; b=qjWPCAtkCaKKWLrBB6NP6Thu6N/dmPunA6Oxc+OQLKOSz/65mFEE8ZM3l80WBJKxozwtoUjZxEPZRAPiH97qPI3qzdnRdKnFvl1NkpQnRIoEooURDyOvkXpazZY4FDP6z4ykJUlhdy+dG9BDyaLIzAsD6UQtmRRsSDIRmCLsvEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761268204; c=relaxed/simple;
	bh=zpfxKeHCsLHDUNXoQFTSUqAfIm/3o9T79BPPu6F4Ja8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PgS/ndBtEb6spetzFJWIS3ggGMobMVY4VXM6GLYvhMXpJ0G97ainUVVH/QFuOzoeEdfqh6LqU63VO5FfO0CigzNGLGxFLLqblG8eAgZu+W6bEsRTW+8OzqzjV9s0BL0QyJHge3gklxofOihNsHEZtlGOnsx8bJAYoJMD9CnfkUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Hbtb0D6P; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Hbtb0D6P"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761268192; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=DXDEkvHieeL4zvEL9pa3Yx0ykB40RuTvaiBbZ2gNXuY=;
	b=Hbtb0D6Pbq62Bmmnnwvb9V+E21ki9s9hOfjUbJCrn8SYnChnJQU6GrBePgydNlg+ekALMY2dzqFxmh0Mz6Oxg7pniAEKMqE6XGXrBPpfn8PtdcArLEzBHI0x0WyLpw4b0pXwcre0kPFsrOGCTc8Wnr46Q84Sa7aPEh2NT4TXmDo=
Received: from 30.221.128.124(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WqsNkGr_1761268191 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 24 Oct 2025 09:09:51 +0800
Message-ID: <75608a44-e803-4265-9000-f93d048cc30e@linux.alibaba.com>
Date: Fri, 24 Oct 2025 09:09:51 +0800
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
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
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

s/has no clusters/has clusters?

> an invalid inode from being passed to 'ocfs2_evict_inode()' and below.
> 
> Reported-by: syzbot+c16daba279a1161acfb0@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=c16daba279a1161acfb0
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
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

