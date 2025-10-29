Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CBD314A9F
	for <ocfs2-devel@lists.linux.dev>; Wed, 29 Oct 2025 09:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761731590; cv=none; b=kD15u5EDyEqHnJSbmtx1Ef64+3JcZ8VgEiy+AxnzhUuHFDl8v2N1bvdf0XE5Aek2hHnFOlMQBtvqDTlENDrmcWECvO5gqxAvtyNnzbma5pUbI8NrP/WnFZxVxYkABoSPvMDCbxZcfrgamnqbRCU5CIxBWYpMSdwTQC19OmrNu6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761731590; c=relaxed/simple;
	bh=Ylppf0rO6REOgkmrKZ6sUrVxja3QPrVXdNj1T9NqLzc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wh4n3Uq/OQl0voNy6wZ8XbIV2O63RE8mQCYganfha+gJPSojnqJoZeYdbBnicF1G1OJyt1GTlIt+/rWnbe+MPypX5ZIdi3Wskwy3yvDaPht/uT+R9YmYpF6GtibbSRI6B0yZCf9reCGkZl3MJbmRrJ5xTY7LdbDQFFXFLxV6/54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=s3M85dgv; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="s3M85dgv"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761731582; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=CQ5Z9XrIgE+k/qh/vh1P4MoPOyWFPsijOtFTfohLhws=;
	b=s3M85dgvobcN0+988Me/km8uorF741yJ4IoZkP1GMoffBHVCSb2kjSo9ATU7ROuth8NVtnFTgQDAGeuIW+eZ3HPyw0esBrW48erQ+wy8NWTtwjyjXRxvZpNQPUAiqqjJFmZqmBvybgTIoIG/0uQbGp2SZPpS0zgCusFJsAwFDTI=
Received: from 30.221.128.184(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WrFOpDp_1761731580 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 29 Oct 2025 17:53:01 +0800
Message-ID: <632f9f46-785d-4da9-a422-546fe3d91af3@linux.alibaba.com>
Date: Wed, 29 Oct 2025 17:53:00 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ocfs2: validate cl_bpc in allocator inodes to prevent
 divide-by-zero
To: Dmitry Antipov <dmantipov@yandex.ru>,
 Deepanshu Kartikey <kartikey406@gmail.com>, akpm <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev,
 lvc-project@linuxtesting.org,
 syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
References: <9461385f-235d-40fc-8da6-b1f2dfb47d6c@linux.alibaba.com>
 <20251029055338.1192000-1-dmantipov@yandex.ru>
 <20251029055338.1192000-2-dmantipov@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251029055338.1192000-2-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/10/29 13:53, Dmitry Antipov wrote:
> From: Deepanshu Kartikey <kartikey406@gmail.com>
> 
> The chain allocator field cl_bpc (blocks per cluster) is read from disk
> and used in division operations without validation. A corrupted filesystem
> image with cl_bpc=0 causes a divide-by-zero crash in the kernel:
> 
>   divide error: 0000 [#1] PREEMPT SMP KASAN
>   RIP: 0010:ocfs2_bg_discontig_add_extent fs/ocfs2/suballoc.c:335 [inline]
>   RIP: 0010:ocfs2_block_group_fill+0x5bd/0xa70 fs/ocfs2/suballoc.c:386
>   Call Trace:
>    ocfs2_block_group_alloc+0x7e9/0x1330 fs/ocfs2/suballoc.c:703
>    ocfs2_reserve_suballoc_bits+0x20a6/0x4640 fs/ocfs2/suballoc.c:834
>    ocfs2_reserve_new_inode+0x4f4/0xcc0 fs/ocfs2/suballoc.c:1074
>    ocfs2_mknod+0x83c/0x2050 fs/ocfs2/namei.c:306
> 
> This patch adds validation in ocfs2_validate_inode_block() to ensure cl_bpc
> matches the expected value calculated from the superblock's cluster size
> and block size for chain allocator inodes (identified by OCFS2_CHAIN_FL).
> 
> Moving the validation to inode validation time (rather than allocation time)
> has several benefits:
> - Validates once when the inode is read, rather than on every allocation
> - Protects all code paths that use cl_bpc (allocation, resize, etc.)
> - Follows the existing pattern of inode validation in OCFS2
> - Centralizes validation logic
> 
> The validation catches both:
> - Zero values that cause divide-by-zero crashes
> - Non-zero but incorrect values indicating filesystem corruption or
>   mismatched filesystem geometry
> 
> With this fix, mounting a corrupted filesystem produces:
> 
>   OCFS2: ERROR (device loop0): ocfs2_validate_inode_block: Inode 74
>          has corrupted cl_bpc: ondisk=0 expected=16
> 
> instead of a kernel crash.
> 
> Link: https://lore.kernel.org/ocfs2-devel/20251026132625.12348-1-kartikey406@gmail.com/T/#u [v1]
> Link: https://lore.kernel.org/all/20251027124131.10002-1-kartikey406@gmail.com/T/ [v2]
> Reported-by: syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=fd8af97c7227fe605d95
> Tested-by: syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
> Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> [dmantipov: combine into the series and tweak
>  the message to fit the commonly used style]
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/inode.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 1b6bdd9d7755..efb930da0920 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1505,6 +1505,8 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  
>  	if (le32_to_cpu(di->i_flags) & OCFS2_CHAIN_FL) {
>  		struct ocfs2_chain_list *cl = &di->id2.i_chain;
> +		u16 bpc = 1 << (OCFS2_SB(sb)->s_clustersize_bits -
> +				sb->s_blocksize_bits);
>  
>  		if (le16_to_cpu(cl->cl_count) != ocfs2_chain_recs_per_inode(sb)) {
>  			rc = ocfs2_error(sb, "Invalid dinode %llu: chain list count %u\n",
> @@ -1518,6 +1520,12 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  					 le16_to_cpu(cl->cl_next_free_rec));
>  			goto bail;
>  		}
> +		if (le16_to_cpu(cl->cl_bpc) != bpc) {
> +			rc = ocfs2_error(sb, "Invalid dinode %llu: bits per cluster %u\n",
> +					 (unsigned long long)bh->b_blocknr,
> +					 le16_to_cpu(cl->cl_bpc));
> +			goto bail;
> +		}
>  	}
>  
>  	rc = 0;

