Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762F178F59
	for <ocfs2-devel@lists.linux.dev>; Wed, 29 Oct 2025 01:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761700558; cv=none; b=gZ5zkXzSNhu1o3pu5c6iCuQOlZT//mKmpL6uUo8YgTNRGDqXUFd/4cHHRyjzxrCB8CeUMBKWZckYqCfDeKfHJRXTUhdTeVJ9nTlKp6THJSKlN1HEcAyf3eqAZGdiTtXfMwqfMbO6qO6mo80TiCCjmprxNsSVuWJlPBjicgqoIrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761700558; c=relaxed/simple;
	bh=aXlwRAIVh/S7+MtjziVSDFBCnI6a6HMuOL9LKZ1JmEI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ab6C/wj6Kn5XIAJwjgSz+7vW3T6/jaxsu4Bcxbs4q2Jco1Yigva4dY6pnIuplF8nancOtSmQf77YNQxwt7wrU3hS+F7h/Dzzb4b8t0CAeXKg2mFqk1EPGa9tPMqDrCEwjMnmWFV9sMnQpFnYhIslHWm71ReWK7QiMFZBvJgrMVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=p4JVHweY; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="p4JVHweY"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761700547; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=hla+Fr31Bylph42bANWGZQhEKuFdf5plGK7ianD2Yyg=;
	b=p4JVHweYewM6VaD4Ey0OzL0I4VFtzHHPFEJ5zfuhn9EQsA6JYf+nMbGFUdY+zADLt/+d0JRfS5XSHMHDpXXObXbXamkEVqD8OVH0vNm6UjTpWa48f/33dUBVCOO1fYiOcnmoVNUi1s03fB07BLcuXqwUqnMd8jxZeTQSFRcIopM=
Received: from 30.221.128.184(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WrDdEA7_1761700545 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 29 Oct 2025 09:15:46 +0800
Message-ID: <9461385f-235d-40fc-8da6-b1f2dfb47d6c@linux.alibaba.com>
Date: Wed, 29 Oct 2025 09:15:45 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: add extra consistency checks for chain allocator
 dinodes
To: Dmitry Antipov <dmantipov@yandex.ru>, Heming Zhao <heming.zhao@suse.com>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+77026564530dbc29b854@syzkaller.appspotmail.com,
 syzbot+5054473a31f78f735416@syzkaller.appspotmail.com
References: <20251028101447.693289-1-dmantipov@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251028101447.693289-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/10/28 18:14, Dmitry Antipov wrote:
> When validating chain allocator dinode in 'ocfs2_validate_inode_block()',
> add an extra checks whether a) the maximum amount of chain records in
> 'struct ocfs2_chain_list' matches the value calculated based on the
> filesystem block size, and b) the next free slot index is within the
> valid range.
> 
> Reported-by: syzbot+77026564530dbc29b854@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=77026564530dbc29b854
> Reported-by: syzbot+5054473a31f78f735416@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=5054473a31f78f735416
> Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

BTW, it would be better to combine another fix for divide zero you've
sent before as a series, since they all checks chain list and can be
in the same if clause.

[PATCH v3] ocfs2: validate cl_bpc in allocator inodes to prevent divide-by-zero
https://lore.kernel.org/ocfs2-devel/3080b006-a093-4aad-ae7b-de7d0ae9d6d9@linux.alibaba.com/T/#t

So could you please resend the two as a series?
 
> ---
> note: this is going to replace "ocfs2: introduce chain list sanity check
>       with ocfs2_check_chain_list()" because it looks more consistent and
>       allows to filter out damaged/inconsistent dinodes earlier (immediately
>       after being read).
> ---
>  fs/ocfs2/inode.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index fcc89856ab95..1b6bdd9d7755 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1503,6 +1503,23 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		goto bail;
>  	}
>  
> +	if (le32_to_cpu(di->i_flags) & OCFS2_CHAIN_FL) {
> +		struct ocfs2_chain_list *cl = &di->id2.i_chain;
> +
> +		if (le16_to_cpu(cl->cl_count) != ocfs2_chain_recs_per_inode(sb)) {
> +			rc = ocfs2_error(sb, "Invalid dinode %llu: chain list count %u\n",
> +					 (unsigned long long)bh->b_blocknr,
> +					 le16_to_cpu(cl->cl_count));
> +			goto bail;
> +		}
> +		if (le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count)) {
> +			rc = ocfs2_error(sb, "Invalid dinode %llu: chain list index %u\n",
> +					 (unsigned long long)bh->b_blocknr,
> +					 le16_to_cpu(cl->cl_next_free_rec));
> +			goto bail;
> +		}
> +	}
> +
>  	rc = 0;
>  
>  bail:

