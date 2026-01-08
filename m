Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3C4352F9F
	for <ocfs2-devel@lists.linux.dev>; Thu,  8 Jan 2026 08:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767860731; cv=none; b=dxLp/w0Nym0hDTcUxTtZ9s/6sVww0IuITlfrOi1Rk8BNNMQ/1YARI0kVy0ArxDo5obC5J8yygOt9J0En0Krqenw+A4Egs3u3Ot606BdjgdyUs6vms8II7+bCIBIjbRCMekKpdz/vmqR6cM0xBqp0egP9HnCxCwsNXVJJ5gzBx1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767860731; c=relaxed/simple;
	bh=bfeEfHMQaDrQNinik7TO3kCTHlpsWHqJnhPSxXvQJPg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PJSR+zyRO7OimTBYoZ/9c/RsR3/Axb9PPQdN3s8DuOYyqbmn3ihNOpJtSboOfSeyQPupPU5haFS5fmwzkf78O6H2ou9q86zsovrcr75IHl9iomF+7oDYX8m5BXIXHhnFoPfHoNEva+KDqbQ5Ppxpo26wENGHm34DKKMRM90+OPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=mLlplkIY; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="mLlplkIY"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1767860717; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=abCUZ0Z15kokdt39d/Hn8TdF31AqbSwwRDC7QUQ/fT8=;
	b=mLlplkIYadNtqh3sLhWjn/KNeq8qckzkZ5pCUEfHTCYsXYafYcVmv55XAzO4jX7KoFF0VDTQlJ8WWoS9Gnroqge54zaATxS29cZYre5z1KRr/9jXgL//YQEhVbLpFzTANGjjdMSlUR+glmEluOERlTKmJ6TmTmMVXd835P5JSmA=
Received: from 30.221.145.71(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WwbwG8h_1767860715 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 08 Jan 2026 16:25:16 +0800
Message-ID: <10be03f1-1ab1-44d0-b9c8-89cfc668c304@linux.alibaba.com>
Date: Thu, 8 Jan 2026 16:25:14 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: validate allocator type to prevent BUG_ON in
 ocfs2_block_group_search
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 syzbot+44c564a3cb08605f34a1@syzkaller.appspotmail.com,
 Joel Becker <jlbec@evilplan.org>, Mark Fasheh <mark@fasheh.com>,
 Heming Zhao <heming.zhao@suse.com>
References: <20260104014028.305029-1-kartikey406@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260104014028.305029-1-kartikey406@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2026/1/4 09:40, Deepanshu Kartikey wrote:
> A corrupted filesystem image can have an inode allocator with the
> OCFS2_BITMAP_FL flag incorrectly set, making ocfs2_is_cluster_bitmap()
> return true. When the code later calls ocfs2_block_group_search(),
> it triggers BUG_ON(ocfs2_is_cluster_bitmap(inode)) causing a kernel panic.
> 
But ocfs2_is_cluster_bitmap() checks ip_blkno.

Thanks,
Joseph

> Call trace:
>   ocfs2_block_group_search+0x1c7/0x2c0 fs/ocfs2/suballoc.c:1611
>   ocfs2_search_chain+0x38a/0x1010 fs/ocfs2/suballoc.c:1764
>   ocfs2_claim_suballoc_bits+0x3a4/0x650 fs/ocfs2/suballoc.c:1978
>   ocfs2_claim_new_inode+0x95/0x130 fs/ocfs2/suballoc.c:2137
>   ocfs2_mknod_locked+0x129/0x510 fs/ocfs2/namei.c:568
>   ocfs2_mknod+0x5c7/0x11d0 fs/ocfs2/namei.c:802
>   ocfs2_create+0x136/0x170 fs/ocfs2/namei.c:852
> 
> Add validation in ocfs2_reserve_suballoc_bits() to check that the
> allocator inode type matches the expected type:
> - Global bitmap allocator must have OCFS2_BITMAP_FL flag set
> - Other allocators (inode, extent) must NOT have OCFS2_BITMAP_FL set
> 
> This follows the existing pattern of validating OCFS2_CHAIN_FL in the
> same function and uses ocfs2_error() for graceful error handling.
> 
> Reported-by: syzbot+44c564a3cb08605f34a1@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=44c564a3cb08605f34a1
> Tested-by: syzbot+44c564a3cb08605f34a1@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
>  fs/ocfs2/suballoc.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 8e6e5235b30c..fb72c062a8d5 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -813,6 +813,26 @@ static int ocfs2_reserve_suballoc_bits(struct ocfs2_super *osb,
>  		goto bail;
>  	}
>  
> +	/*
> +	 * Validate allocator type matches expected bitmap type.
> +	 * Global bitmap must have BITMAP flag, other allocators must not.
> +	 * This prevents a corrupted filesystem from triggering BUG_ON
> +	 * in ocfs2_block_group_search() or ocfs2_cluster_group_search().
> +	 */
> +	if (type == GLOBAL_BITMAP_SYSTEM_INODE) {
> +		if (!ocfs2_is_cluster_bitmap(alloc_inode)) {
> +			status = ocfs2_error(alloc_inode->i_sb,
> +					     "Global bitmap %llu missing bitmap flag\n",
> +					     (unsigned long long)le64_to_cpu(fe->i_blkno));
> +			goto bail;
> +		}
> +	} else if (ocfs2_is_cluster_bitmap(alloc_inode)) {
> +		status = ocfs2_error(alloc_inode->i_sb,
> +				     "Allocator %llu has invalid bitmap flag\n",
> +				     (unsigned long long)le64_to_cpu(fe->i_blkno));
> +		goto bail;
> +	}
> +
>  	free_bits = le32_to_cpu(fe->id1.bitmap1.i_total) -
>  		le32_to_cpu(fe->id1.bitmap1.i_used);
>  

