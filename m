Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CFC257841
	for <ocfs2-devel@lists.linux.dev>; Tue, 28 Oct 2025 01:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761616399; cv=none; b=r4kYoctXNFfqfEACV5F4Qlrom8KeNa8TzBRvt/Nideqh9XrmPyUfyTmmoTocu8CmYUI9YHab7op5vkvyjcbq9Ut1Oi9nGARFqsc+eGmWJYvMDGurvPQeMCjNoe1tkFCfULYUQEbkbxUVFKFxHeL8Dj/7rA4POstKgcVRZ14HGyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761616399; c=relaxed/simple;
	bh=ed2/At/TJIopFtPLLswH790oEXO5DiR28JdMfeQR8AM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IUWCJ8c4XjiTz47FCtKRruXEEz3xxEZuk1vTteA6XMeX1I3o2tg/oPlpDrRwZzcFu56Lc23O80UCd1KFeSER3ZnT1rbOem9WcOlkVh7hUPtnFqTvesSmmMwc50NsJwJ3Yu0ZvWWxZG+FS4Ny0JGZopE9zYf+NngUPe+il4MTLHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Sty7806a; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Sty7806a"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761616388; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=cfSePWPhK2TN2gDAKtWVOMf6+MTnBXm7WsDuEd98vj0=;
	b=Sty7806aDF4rw8Dp1FW6RmE5Fn8LPudIDQOpmGpeFHRDtiCTkTtxC9mrFroa0TXheXA+T5UYFVP16d0kA5+glWg55OkEvsTU2CK6rdI0f1MjcpCfaXrfTxpCByxeIWDiRjvCagr+J8i9Fz8arXg/4D4wNwBJc57GeB06UOjnWtA=
Received: from 30.221.128.145(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WrA9IrU_1761616387 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 28 Oct 2025 09:53:07 +0800
Message-ID: <9e9f5ed7-5c37-462c-9970-3da7dd957e4e@linux.alibaba.com>
Date: Tue, 28 Oct 2025 09:53:06 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND PATCH v2] ocfs2: introduce chain list sanity check with
 ocfs2_check_chain_list()
To: Dmitry Antipov <dmantipov@yandex.ru>, Heming Zhao <heming.zhao@suse.com>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+77026564530dbc29b854@syzkaller.appspotmail.com,
 syzbot+5054473a31f78f735416@syzkaller.appspotmail.com
References: <20251027125654.312153-1-dmantipov@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251027125654.312153-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,
It seems that these checks can also been moved into ocfs2_validate_inode_block()?

Thanks,
Joseph

On 2025/10/27 20:56, Dmitry Antipov wrote:
> Introduce 'ocfs2_check_chain_list()' to check whether a) the maximum
> amount of chain records in 'struct ocfs2_chain_list' matches the value
> calculated based on the filesystem block size, and b) the next free slot
> index is within the valid range, and use the aforementioned function
> in 'ocfs2_block_group_alloc()' and 'ocfs2_claim_suballoc_bits()'.
> 
> Reported-by: syzbot+77026564530dbc29b854@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=77026564530dbc29b854
> Reported-by: syzbot+5054473a31f78f735416@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=5054473a31f78f735416
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> ---
> note: resend to ensure that it's reviewed and hopefully good enough for
>       mm-nonmm-unstable of -mm
> v2: bail on cl->cl_next_free_rec > cl->cl_count (the name is misleading,
>     cl_next_free_rec is a member count (and so can be equal to array
>     size) rather than member index)
> ---
>  fs/ocfs2/suballoc.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 6ac4dcd54588..9969a041ab18 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -649,6 +649,16 @@ ocfs2_block_group_alloc_discontig(handle_t *handle,
>  	return status ? ERR_PTR(status) : bg_bh;
>  }
>  
> +static int ocfs2_check_chain_list(struct ocfs2_chain_list *cl,
> +				  struct super_block *sb)
> +{
> +	if (le16_to_cpu(cl->cl_count) != ocfs2_chain_recs_per_inode(sb))
> +		return -EINVAL;
> +	if (le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count))
> +		return -EINVAL;
> +	return 0;
> +}
> +
>  /*
>   * We expect the block group allocator to already be locked.
>   */
> @@ -671,6 +681,10 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
>  	BUG_ON(ocfs2_is_cluster_bitmap(alloc_inode));
>  
>  	cl = &fe->id2.i_chain;
> +	status = ocfs2_check_chain_list(cl, alloc_inode->i_sb);
> +	if (status)
> +		goto bail;
> +
>  	status = ocfs2_reserve_clusters_with_limit(osb,
>  						   le16_to_cpu(cl->cl_cpg),
>  						   max_block, flags, &ac);
> @@ -1992,6 +2006,9 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
>  	}
>  
>  	cl = (struct ocfs2_chain_list *) &fe->id2.i_chain;
> +	status = ocfs2_check_chain_list(cl, ac->ac_inode->i_sb);
> +	if (status)
> +		goto bail;
>  
>  	victim = ocfs2_find_victim_chain(cl);
>  	ac->ac_chain = victim;

