Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C673CE494
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Apr 2026 13:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775739923; cv=none; b=LQMFxiQGVwNR/B2pR9nujyAxwegcS6UNoSBY1QaqWXtytSpGM6QmsczjJ3XMOOiTYIJsmuYDwQOppO22d1QNWm4cJMswL4EbR617VEMzKrSs0DwjI8bS3dWdclLQOLUzh4kBJhAZunZl6zHto36BIEFYvTu0DwmrJiVwG7B7/lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775739923; c=relaxed/simple;
	bh=5rdomzAosDnG/xgHznhPi8YK+yKC57R3/La+Vliq2gc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HlycG8vigl5xctcaQRt3yCRsCcZvN47OE3XgfdTfGaTKXozjXQkSaDxi3qPjcqSZ5rlfG/afCOJhJgt++TBilxIai3QCBhaLAGsMUavVhbl9P7YLxS58mmQ0p1MWulUaEHxLYvwXM+uzO0fgbqkJoSxfXpjuPtO6yNYCspRcRfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=RwfCwpZe; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="RwfCwpZe"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775739918; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=HmPTnvmn8PMDM3p1/+aVg2SM44/IE7gQhWFkALk4qDo=;
	b=RwfCwpZeigSgFdzoTKrVMt7pZSNoTcaXN7bIn7MmDsE+hWBBIgZlBmzRkj3BTnkIBgdD4U7jew/vLkRXRWZU6Bcf+r3YLpkApI2AIDCF30Q3bpCWwjiOl1hhjAzid4LPg0oasIDIvqfOLI7R/Tt9z9pWBLeLzydkMM7aBjloKt0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X0iWMCQ_1775739916;
Received: from 30.221.146.1(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X0iWMCQ_1775739916 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 09 Apr 2026 21:05:16 +0800
Message-ID: <5df0ca20-b162-4875-8658-b46d8958fa45@linux.alibaba.com>
Date: Thu, 9 Apr 2026 21:05:15 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: validate group add input before caching
To: ZhengYuan Huang <gality369@gmail.com>, akpm <akpm@linux-foundation.org>,
 Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <20260409090255.3430951-1-gality369@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260409090255.3430951-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/9/26 5:02 PM, ZhengYuan Huang wrote:
> [BUG]
> OCFS2_IOC_GROUP_ADD can trigger a BUG_ON in
> ocfs2_set_new_buffer_uptodate():
> 
> kernel BUG at fs/ocfs2/uptodate.c:509!
> Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
> RIP: 0010:ocfs2_set_new_buffer_uptodate+0x194/0x1e0 fs/ocfs2/uptodate.c:509
> Code: ffffe88f 42b9fe4c 89e64889 dfe8b4df
> Call Trace:
>  ocfs2_group_add+0x3f1/0x1510 fs/ocfs2/resize.c:507
>  ocfs2_ioctl+0x309/0x6e0 fs/ocfs2/ioctl.c:887
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl fs/ioctl.c:583 [inline]
>  __x64_sys_ioctl+0x197/0x1e0 fs/ioctl.c:583
>  x64_sys_call+0x1144/0x26a0 arch/x86/include/generated/asm/syscalls_64.h:17
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x93/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> RIP: 0033:0x7bbfb55a966d
> 
> [CAUSE]
> ocfs2_group_add() calls ocfs2_set_new_buffer_uptodate() on a
> user-controlled group block before ocfs2_verify_group_and_input()
> validates that block number. That helper is only valid for newly
> allocated metadata and asserts that the block is not already present in
> the chosen metadata cache. The code also uses INODE_CACHE(inode) even
> though the group descriptor belongs to main_bm_inode and later journal
> accesses use that cache context instead.
> 
> [FIX]
> Validate the on-disk group descriptor before caching it, then add it to
> the metadata cache tracked by INODE_CACHE(main_bm_inode). Update the
> error path to remove the buffer from the same cache context so the group
> buffer lifetime stays consistent across validation, journaling, and
> cleanup.
> 
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>

Missing Fixes tag:
Fixes: 7909f2bf8353 ("[PATCH 2/2] ocfs2: Implement group add for online resize")

> ---
>  fs/ocfs2/resize.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
> index b0733c08ed13..e45ab5592ee0 100644
> --- a/fs/ocfs2/resize.c
> +++ b/fs/ocfs2/resize.c
> @@ -504,14 +504,14 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
>  		goto out_unlock;
>  	}
>  
> -	ocfs2_set_new_buffer_uptodate(INODE_CACHE(inode), group_bh);
> -
>  	ret = ocfs2_verify_group_and_input(main_bm_inode, fe, input, group_bh);
>  	if (ret) {
>  		mlog_errno(ret);
>  		goto out_free_group_bh;
>  	}

Since ocfs2_set_new_buffer_uptodate is now moved down, the error goto
above should also be changed.

e.g. do the same ioctl twice, the second will remove the cache which
should be valid. This is not the expected behavior.

Thanks,
Joseph

>  
> +	ocfs2_set_new_buffer_uptodate(INODE_CACHE(main_bm_inode), group_bh);
> +
>  	trace_ocfs2_group_add((unsigned long long)input->group,
>  			       input->chain, input->clusters, input->frees);
>  
> @@ -575,7 +575,7 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
>  
>  out_free_group_bh:
>  	if (ret < 0)
> -		ocfs2_remove_from_cache(INODE_CACHE(inode), group_bh);
> +		ocfs2_remove_from_cache(INODE_CACHE(main_bm_inode), group_bh);
>  	brelse(group_bh);
>  
>  out_unlock:

