Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F23726E6F9
	for <ocfs2-devel@lists.linux.dev>; Mon, 27 Oct 2025 01:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761530232; cv=none; b=AJC1p3xNNLK8Gm67Cbmj/aI03n2lhU2LCdxLeRRDrIsB7eKjAQmhWswLmicI1jibPzIM5H84oPGBFm8Bya0uLYW10YWNrjsRPZfTX/7FWid7D5DUEZhTlUFEfK6cY4J5QHFJM7HNHOToXZKV6YimmhC/p91etwka+L1ACYfsyN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761530232; c=relaxed/simple;
	bh=aka16XwcDegTOTiRo+6ClsthRi4H1pIKXMeOo88C1QI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gRObBxfawlk2nWe1cF/Sbuu1Xp5CxD3fLitnBMpL4t0kxVXNsU2UKygHn8Sd+JNwMcNVfPJ34ucRrVebtsHYG+gEA+2gwSpNiw0CHP/lxDVNgWHmK1qOl6Bi5J60TIWJMxSsWE7bDx58jMQeX9aMSq+6N+6Ztc/pV2p6h9xO0ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=gpkwKrT4; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="gpkwKrT4"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761530218; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=/12Uegp36FrwdhS6ETXyGSIHX/NUQbbDMFM/hMiYIIw=;
	b=gpkwKrT4BQG+AaMjcvzxlrgjrTKl93s5o0hn+10o7jay+INalG30I3LWevojzNk27rGY7ruzu3WiOSQBc7vFrSPD4IM5eVTTVGO0lQAeD3MMHsamb+5t/PqJfrmFfco2spFGSGryC6EXUxO7kED4xx9e9XLBMiYT1m4AulHGrCA=
Received: from 30.221.128.238(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Wr-c35q_1761530217 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 27 Oct 2025 09:56:58 +0800
Message-ID: <0b618470-a8ad-4045-86a0-a8327d613a28@linux.alibaba.com>
Date: Mon, 27 Oct 2025 09:56:57 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: validate cl_bpc in ocfs2_block_group_alloc to
 prevent divide-by-zero
To: Deepanshu Kartikey <kartikey406@gmail.com>, mark@fasheh.com,
 jlbec@evilplan.org, Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
References: <20251026132625.12348-1-kartikey406@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251026132625.12348-1-kartikey406@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/10/26 21:26, Deepanshu Kartikey wrote:
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
> This patch adds validation in ocfs2_block_group_alloc() to ensure cl_bpc
> matches the expected value calculated from the superblock's cluster size
> and block size. This validation follows the same pattern used elsewhere
> in OCFS2 to verify on-disk structures against known-good values derived
> from the superblock parameters.
> 
> The check is performed early in the allocation path, before any resources
> are allocated or transactions started, ensuring clean error propagation.
> If validation fails, the filesystem is marked read-only and the operation
> returns -EUCLEAN (Structure needs cleaning), prompting the administrator
> to run fsck.ocfs2.
> 
> The validation catches both:
> - Zero values that cause divide-by-zero crashes
> - Non-zero but incorrect values indicating filesystem corruption or
>   mismatched filesystem geometry
> 
> With this fix, mounting a corrupted filesystem produces:
>   OCFS2: ERROR (device loop0): ocfs2_block_group_alloc: Chain allocator
>          74 has corrupted cl_bpc: ondisk=0 expected=16
>   OCFS2: File system is now read-only.
> 
> Instead of a kernel crash.
> 
> Reported-by: syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
> Tested-by: syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=fd8af97c7227fe605d95
> Tested-by: syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
>  fs/ocfs2/suballoc.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 6ac4dcd54588..9f3db59890c3 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -667,10 +667,22 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
>  	u16 alloc_rec;
>  	struct buffer_head *bg_bh = NULL;
>  	struct ocfs2_group_desc *bg;
> +	u16 cl_bpc, expected_bpc;
>  
>  	BUG_ON(ocfs2_is_cluster_bitmap(alloc_inode));
>  
>  	cl = &fe->id2.i_chain;
> +	cl_bpc = le16_to_cpu(cl->cl_bpc);
> +	expected_bpc = 1 << (osb->s_clustersize_bits - alloc_inode->i_sb->s_blocksize_bits);

'cl_bpc' is 'bits per cluster'.

> +	if (cl_bpc != expected_bpc) {
> +		ocfs2_error(alloc_inode->i_sb,
> +			"Chain allocator %llu has corrupted cl_bpc: ondisk=%u expected=%u\n",
> +			(unsigned long long)le64_to_cpu(fe->i_blkno),
> +			cl_bpc, expected_bpc);
> +		status = -EUCLEAN;
> +		goto bail;
> +	}
> +

Why not check this in ocfs2_validate_inode_block()? This may benifit all paths.

Thanks,
Joseph

>  	status = ocfs2_reserve_clusters_with_limit(osb,
>  						   le16_to_cpu(cl->cl_cpg),
>  						   max_block, flags, &ac);

