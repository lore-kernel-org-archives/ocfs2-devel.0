Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868C1199939
	for <ocfs2-devel@lists.linux.dev>; Fri, 31 Oct 2025 08:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761899481; cv=none; b=oUoLuy42udPoopOtAt/0bQWrhUXkd/Q2pH7ElttGkZOjx56CPCSs2GSr9mYNN5fN4k2XL5jbKRNUivs6MRCU725TVjWHA9MREDkxuC5qqKdCxWYXVyzG9IG6f9CbW0D9LLt5ISGQIvxeScFimFESWuw7KLqZA1c03iPiaRBqv6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761899481; c=relaxed/simple;
	bh=9xa4fbrMzghevYSrX+PKnXbfMpznaCrWbpFD8hOqaRU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JgvD1usTPn0KDNuKDZTcIe+WWV5lCf4QwfjXdsXKr7h0aIqZsXAVUMr8tm1jyMECYIWkPFD1ieEGyllb0ZbQTFBBSBsDosYPMnvSgeGJ5bkqxGyR4gI1YmPJRZpaa9FKCtBS+3my8PlucSflCOrKb/406pfDA0eTv4vgIxDXlNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=W7QAdL8A; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="W7QAdL8A"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761899468; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=REQcaW4NFbLNvR2DXD/23aVdy3x81CSBfSbaRpzsXUg=;
	b=W7QAdL8AXFwpMoSaWMrDubSlwTMgUp4Hy7nIitiP799VQ261YC9f0Yc0bOxlx2pBTKbD3g6poMRJjqFjX2X3I2LATUVL4UEDweEbvoPOmyv1T06ama3ysjuVhImVPBLgMXpFzKROxcMegDQ7rejAW+vohPC+pFYwWu8qKNlucPE=
Received: from 30.221.128.132(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WrOQIXI_1761899466 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 31 Oct 2025 16:31:07 +0800
Message-ID: <4b7bc645-3eff-41a4-bf11-3c893055d61b@linux.alibaba.com>
Date: Fri, 31 Oct 2025 16:31:06 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] ocfs2: add extra consistency checks for chain
 allocator dinodes
To: Dmitry Antipov <dmantipov@yandex.ru>, Heming Zhao <heming.zhao@suse.com>,
 Deepanshu Kartikey <kartikey406@gmail.com>, akpm <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+77026564530dbc29b854@syzkaller.appspotmail.com,
 syzbot+5054473a31f78f735416@syzkaller.appspotmail.com
References: <20251030153003.1934585-1-dmantipov@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251030153003.1934585-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/10/30 23:30, Dmitry Antipov wrote:
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

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> v2: unchanged since v1
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

