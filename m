Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79081F17E8
	for <ocfs2-devel@lists.linux.dev>; Tue, 14 Oct 2025 13:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760446816; cv=none; b=gBUpUmGVRrumGih9Zk8m8s5Rf0pX/mzZ7hmCgxy0RCbp3fL5i+Gq75jpcahvyZLu2+gyWt1kYYcA1yhqujeqIaP6m9KQ9/x4GM9z+jw3AzPp86OSq029+aSDX4//poi+aHJfILbDmfvfXvSn7g+iqP1YN+PmLtRciUDes4xQNGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760446816; c=relaxed/simple;
	bh=Nrdb6Ib04hV8cH3eZgb7FaMueTfaW946YEatkbXl13c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fMWV2GDWv9ylrN/XG0A9++VmCbUPLMgG5FEMJMReDAGpxR4qEywxUmYGbDLRlck3jHBPaaFkYXn+v8AF0qFz0rXaUmEnLTJAVwkQaky8Fb1hDlI87cHFIfi4HIkvUdqOrY2ubyCu+QoVVHImFBL62UIdUrQWqgt8P6Beq2XUACw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=klEmaf/6; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="klEmaf/6"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760446810; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=EIdmmatD+rJlzRORAvYNzA4SAmHUvg8wICF+E+YStu4=;
	b=klEmaf/6FPLPYLIpSjztsZzlM4hg5cqZj5+mgHehb3Rq3U/VqWSXxrbFYyiRrKC/6KVJSKEtIAx2NzyMj6flRmhbnkSLd7Ki/6hGC6rdzpKIFm5WCJuof3+kBDyHp5dNOFahBcY7Jqoaq/ayySItEOqtU2Rrta49yNIWNvbYYi4=
Received: from 30.221.128.131(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WqC0Ou3_1760446808 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 14 Oct 2025 21:00:09 +0800
Message-ID: <579ffc80-130e-4829-ad00-a8b7c1e47a36@linux.alibaba.com>
Date: Tue, 14 Oct 2025 21:00:08 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: fix __counted_by_le() usage in
 ocfs2_expand_inline_dx_root()
To: Dmitry Antipov <dmantipov@yandex.ru>, Heming Zhao <heming.zhao@suse.com>,
 akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <9efedaaf-3600-4d1e-9fb7-77f55f1524e5@suse.com>
 <20251014070324.130313-1-dmantipov@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251014070324.130313-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/10/14 15:03, Dmitry Antipov wrote:
> After annotating 'l_recs[]' VLA member of 'struct ocfs2_extent_list'
> with '__counted_by_le(l_count)', 'l_count' should be initialized
> before touching 'l_recs[]' with 'memset()' to avoid false positives
> from buffer overflow guards when CONFIG_UBSAN_BOUNDS is enabled.
> 
> Fixes: aa545adbe491 ("ocfs2: annotate flexible array members with __counted_by_le()")
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
> v2: adjust 'memset()' call to clear 'l_recs[]' of 'dr_list' only
>     and initialize the rest of the members explicitly (Heming Zhao)
> 
> note: since the commit in subject is not merged to upstream yet, Fixes: reference is taken from
> https://web.git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?h=mm-nonmm-unstable&id=aa545adbe491
> ---
>  fs/ocfs2/dir.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index 8c9c4825f984..48b092bc83d4 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -4104,10 +4104,15 @@ static int ocfs2_expand_inline_dx_root(struct inode *dir,
>  	}
>  
>  	dx_root->dr_flags &= ~OCFS2_DX_FLAG_INLINE;
> -	memset(&dx_root->dr_list, 0, osb->sb->s_blocksize -
> -	       offsetof(struct ocfs2_dx_root_block, dr_list));
> +
> +	dx_root->dr_list.l_tree_depth = 0;
>  	dx_root->dr_list.l_count =
>  		cpu_to_le16(ocfs2_extent_recs_per_dx_root(osb->sb));
> +	dx_root->dr_list.l_next_free_rec = 0;
> +	memset(&dx_root->dr_list.l_recs, 0,
> +	       osb->sb->s_blocksize -
> +	       (offsetof(struct ocfs2_dx_root_block, dr_list) +
> +		offsetof(struct ocfs2_extent_list, l_recs)));
>  
>  	/* This should never fail considering we start with an empty
>  	 * dx_root. */

