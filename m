Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD1728151C
	for <ocfs2-devel@lists.linux.dev>; Tue,  6 Jan 2026 04:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767673500; cv=none; b=Ti6TPtDrUXhobmlB9thuDIfQ6fJvfOaE7KooKTolGF/unp/WmvdzCgIc7CNYxse7BgZjs12qp1UqimRxtXe0GrTUN3uJOztUuFH0or12n7+2vwclYKZKVDnZHgHyTl+RaZe8yjKJ+Mjdz63zpThwRG76gBEDaUbAjmCPskr4bJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767673500; c=relaxed/simple;
	bh=Jpbps//cwARc1XquVrU1tc+JNu605lG0eh135KspRYU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RyJy3/STHE9WbwZ0VY6URHkzn3Dmn22ykN0eRLFdkiZy9EM/stdfu0DZgDZqFUBciEuAdI7bNEKF0nZK/SaafahZlir/oFNIhgqvDkkz60eG0AQTRpr8Hh0vEUjYCuHh1TwgJUZCH9Puunvzc1qRyCihis2+Y2FpnJF9P5HpJuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Aszw2+Kr; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Aszw2+Kr"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1767673489; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=zYMEBifjXil6F91v7+0wlCFzZNGBJa98+MntA/4nORo=;
	b=Aszw2+Kr8bQCixipbJbFgWXXdX3JJ+6VacpUATxkFQvYM8cnBqcR+Rmi91UKpphFZ2c9nhnjjb3HEoRt4LfdVcrBBYZPDoQK41lrHTVEWhAW7z19x1Ij3blulqaeJ8NhgxGyRynTbSZ1fP/R3jpmdpVukkzGOxtPeW2Dq5PoF2Q=
Received: from 30.41.143.132(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WwUUiTy_1767673487 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 06 Jan 2026 12:24:48 +0800
Message-ID: <891d26e3-8930-4fe8-847b-c3919934de0a@linux.alibaba.com>
Date: Tue, 6 Jan 2026 12:24:47 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: add check for free bits before allocation in
 ocfs2_move_extent()
To: Deepanshu Kartikey <kartikey406@gmail.com>, mark@fasheh.com,
 jlbec@evilplan.org, akpm <akpm@linux-foundation.org>,
 Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 syzbot+7960178e777909060224@syzkaller.appspotmail.com
References: <20260104133504.14810-1-kartikey406@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260104133504.14810-1-kartikey406@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2026/1/4 21:35, Deepanshu Kartikey wrote:
> Add a check to verify the group descriptor has enough free bits before
> attempting allocation in ocfs2_move_extent(). This prevents a kernel
> BUG_ON crash in ocfs2_block_group_set_bits() when the move_extents ioctl
> is called on a crafted or corrupted filesystem.
> 
> The existing validation in ocfs2_validate_gd_self() only checks static
> metadata consistency (bg_free_bits_count <= bg_bits) when the descriptor
> is first read from disk. However, during move_extents operations,
> multiple allocations can exhaust the free bits count below the requested
> allocation size, triggering BUG_ON(le16_to_cpu(bg->bg_free_bits_count)
> < num_bits).
> 
> The debug trace shows the issue clearly:
>   - Block group 32 validated with bg_free_bits_count=427
>   - Repeated allocations decreased count: 427 -> 171 -> 43 -> ... -> 1
>   - Final request for 2 bits with only 1 available triggers BUG_ON
> 
> By adding an early check in ocfs2_move_extent() right after
> ocfs2_find_victim_alloc_group(), we return -ENOSPC gracefully instead of
> crashing the kernel. This also avoids unnecessary work in
> ocfs2_probe_alloc_group() and __ocfs2_move_extent() when the allocation
> will fail.
> 
> Reported-by: syzbot+7960178e777909060224@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=7960178e777909060224
> Link: https://lore.kernel.org/all/20251231115801.293726-1-kartikey406@gmail.com/T/ [v1]
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
> v2:
>   - Fixed missing '<' in commit message (Joseph)
>   - Moved check right after ocfs2_find_victim_alloc_group() to fail
>     early and avoid unnecessary work (Joseph)
> ---
>  fs/ocfs2/move_extents.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> index 99637e34d9da..c037fb34b1e3 100644
> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -662,6 +662,12 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
>  		goto out_commit;
>  	}
>  
> +	gd = (struct ocfs2_group_desc *)gd_bh->b_data;
> +	if (le16_to_cpu(gd->bg_free_bits_count) < len) {
> +		ret = -ENOSPC;
> +		goto out_commit;
> +	}
> +
>  	/*
>  	 * probe the victim cluster group to find a proper
>  	 * region to fit wanted movement, it even will perform
> @@ -682,7 +688,6 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
>  		goto out_commit;
>  	}
>  
> -	gd = (struct ocfs2_group_desc *)gd_bh->b_data;
>  	ret = ocfs2_alloc_dinode_update_counts(gb_inode, handle, gb_bh, len,
>  					       le16_to_cpu(gd->bg_chain));
>  	if (ret) {

