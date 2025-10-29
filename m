Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC452F6586
	for <ocfs2-devel@lists.linux.dev>; Wed, 29 Oct 2025 09:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761730754; cv=none; b=HO196PlyKJRtKtVdakvuhXxosyjSYs3rdIwX5wMK4g/MUL8wLBbk+sFLkL0F2+tOwj0j4cTOBBybDVUSLxgz4lTnxVjk+XsXXIQiDtWMQV2zaqHiijxWop/F4VjdSKqCfZq3jtaCivrnNpxGjUPPAaqlRN+EFUJddG7xswGWjdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761730754; c=relaxed/simple;
	bh=n+SI9MhpWpfBOpljt6sItiLgn7PVdVWk8oqXbd4MuVQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b9BlBW1P23YrduRp0eDOmzX2GSDPIvW0bRyNCLBTtPo7PMY99/rToOUXxbfT4LGTQvi6eRp9fyqRZKqh3CMta87BwaRLQJXbS+j79X4y5UbQCFxwkO5A9qML1tK0ZCxSvnHeDZB4DAy9XoZHN/A6Xq96I8foqgCsqePG/Ipoui4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=X4pg4IHG; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="X4pg4IHG"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761730747; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=hyLQzmI+m9FnvWkKjlRNsWYTrLWqFGYsITYDAsIk2dc=;
	b=X4pg4IHGrArEsZ1nNP0SW+RdqNwKu+Jchn4yc8r21aPYWbgL3e9b464IxGfBnWUOWZegUJtClLgff2/2IqcpPIHMWDHxEBD1WZDyuu92ijDmiH6Xld6cBY183xi+pE6cCB+3sfDf9QRmZbRsQYjiBIdnEqfjInoDuBHNGS0TFDc=
Received: from 30.221.128.184(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WrFOlO8_1761730746 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 29 Oct 2025 17:39:07 +0800
Message-ID: <d22db71b-17fe-4861-95a7-c8d431c91e97@linux.alibaba.com>
Date: Wed, 29 Oct 2025 17:39:06 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] ocfs2: add extra consistency checks for chain
 allocator dinodes
To: Dmitry Antipov <dmantipov@yandex.ru>,
 Deepanshu Kartikey <kartikey406@gmail.com>, akpm <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev,
 lvc-project@linuxtesting.org,
 syzbot+77026564530dbc29b854@syzkaller.appspotmail.com,
 syzbot+5054473a31f78f735416@syzkaller.appspotmail.com
References: <9461385f-235d-40fc-8da6-b1f2dfb47d6c@linux.alibaba.com>
 <20251029055338.1192000-1-dmantipov@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251029055338.1192000-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/10/29 13:53, Dmitry Antipov wrote:
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

