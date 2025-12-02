Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803991AE877;
	Tue,  2 Dec 2025 01:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764637217; cv=none; b=IvqCEOf3FENZshnSUKrYtXTxXBkv93DETdugI0EY63TgtIkh4A9/IqVfY8v3zV/X6p5TBflsrxWbui+0LaQj4TcwtjoSjt2rCV0xgf/LKbcPouSyMxL6VEGiXoscslme9FDM7N9rvFUnJ634PkYMXz7nRxTXtxh+H/rKaCkfeuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764637217; c=relaxed/simple;
	bh=nEK9QH8bynrc98oNkTHorxaEp7q1kJpXupWiWuqtfT0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pLo3lkpdeH/dwj5cpVjZfqLZkBlE7lGok14a2QEyZU0iKIlrWyKErRbYeSO9+4aRRZq/EAjr3PyvvW+A+NnXOoAp/Vdn3E4Q9s0R2S5ELpG4Gb+r7puxDqDCgiLL4aulDKSpHSaRCFgrW1IeoNvfz0Uvy+h7rOmL3SRPg2BMFIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=JbLY5+OP; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="JbLY5+OP"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764637210; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=xyaAtchmljGnpNYlfnronNRdUFSHjIrW1uetnyTNnNc=;
	b=JbLY5+OPn3c3YcxVHxDhHPLvXBqfNrUFDJ2fjLAtAlKiNhJILur/yCoICuO7Qdl+YKSd67Q7Zhx8OlWzXU+AYpiSZtzwUJVRJ+mXYNYzj/OGRxpTwOyWzVnmDmRlNyJelrTUmd2AA9BodkNEXbQo9xitNGbO1bIu2fGtO4knRB8=
Received: from 30.221.128.146(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WtuBIOs_1764637209 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 02 Dec 2025 09:00:09 +0800
Message-ID: <7087e14d-80d3-4dcd-ba3e-b03dc0ddf8b1@linux.alibaba.com>
Date: Tue, 2 Dec 2025 09:00:08 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ocfs2: fix kernel BUG in ocfs2_find_victim_chain
To: Prithvi Tambewagh <activprithvi@gmail.com>, mark@fasheh.com,
 jlbec@evilplan.org, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-kernel-mentees@lists.linux.dev, skhan@linuxfoundation.org,
 david.hunter.linux@gmail.com, khalid@kernel.org,
 syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com
References: <20251201130711.143900-1-activprithvi@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251201130711.143900-1-activprithvi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/12/1 21:07, Prithvi Tambewagh wrote:
> syzbot reported a kernel BUG in ocfs2_find_victim_chain() because the
> `cl_next_free_rec` field of the allocation chain list (next free slot in 
> the chain list) is 0, triggring the BUG_ON(!cl->cl_next_free_rec) 
> condition in ocfs2_find_victim_chain() and panicking the kernel.
> 
> To fix this, an if condition is introduced in ocfs2_claim_suballoc_bits(),
> just before calling ocfs2_find_victim_chain(), the code block in it being 
> executed when either of the following conditions is true:
> 
> 1. `cl_next_free_rec` is equal to 0, indicating that there are no free 
> chains in the allocation chain list
> 2. `cl_next_free_rec` is greater than `cl_count` (the total number of 
> chains in the allocation chain list)
> 
> Either of them being true is indicative of the fact that there are no 
> chains left for usage. 
> 
> This is addressed using ocfs2_error(), which prints
> the error log for debugging purposes, rather than panicking the kernel.
> 
> Reported-by: syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=96d38c6e1655c1420a72
> Tested-by: syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com 
> Cc: stable@vger.kernel.org
> Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
> v2->v3
>  - Revise log message for reflecting changes from v1->v2
>  - Format code style as suggested in v2
> 
> v1->v2:
>  - Remove extra line before the if statement in patch
>  - Add upper limit check for cl->cl_next_free_rec in the if condition
> 
>  fs/ocfs2/suballoc.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 6ac4dcd54588..e93fc842bb20 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -1992,6 +1992,16 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
>  	}
>  
>  	cl = (struct ocfs2_chain_list *) &fe->id2.i_chain;
> +	if (!le16_to_cpu(cl->cl_next_free_rec) ||
> +	    le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count)) {
> +		status = ocfs2_error(ac->ac_inode->i_sb,
> +				     "Chain allocator dinode %llu has invalid next "
> +				     "free chain record %u, but only %u total\n",
> +				     (unsigned long long)le64_to_cpu(fe->i_blkno),
> +				     le16_to_cpu(cl->cl_next_free_rec),
> +				     le16_to_cpu(cl->cl_count));
> +		goto bail;
> +	}
>  
>  	victim = ocfs2_find_victim_chain(cl);
>  	ac->ac_chain = victim;
> 
> base-commit: 939f15e640f193616691d3bcde0089760e75b0d3

