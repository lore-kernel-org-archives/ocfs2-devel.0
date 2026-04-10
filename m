Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3264931619D
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Apr 2026 01:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775783541; cv=none; b=RfTgq92okZ3TdONECWkxbiStG6cTxP2iNL0Mrt3qb0+29rJ4GJZVfqeBrBc0vwmEfjaCOb4UTS5PSU/vZjTzTfajEuhfg1viW1nw5sJdZrUZhWnyKp+Kbu6OLRogYxle/geqOVUDKOw8PkIYRPMqB8u15jFepUd/HwegjsS69AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775783541; c=relaxed/simple;
	bh=1tNUx7Xp+cMXWzDMHkQp2o1tXr3WRCOsCNemJJz3+jo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rFA9TTnYbVv17TnmAD9mkXUXrpVfbViXt3cvZxegWldU4R8hvrGZaMGnHqY1CfY5QxenrBK/gyM6eIg4q897qRgDInOW5SGr6iBRbzyVXKkQ5VsmpjUu0ial9wr4ijcbYiuzs0JD2sz2w1XVvKG5mjnxiG+Fgg8DJhgbXHtVdlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=O9O9CPqK; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="O9O9CPqK"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775783536; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=3+25uG+hOeWyFSbHR3Fhms3TWt/b9Xtvo9Yd939X5/c=;
	b=O9O9CPqK7e363/Psp5bktM7gTm8/c3NfBRl9bo651qrlOnXcpBhoLWfF4mmDlPgrSOO37QG6xBoso/lM7Y2K5d6KpUWqnIbOIZagPEVTEbd6u62Hepy82VQ78V1IzWy/G52/8+SWOyViAdiC4Rdf+8mOuelbzy2R9O5RdcPPANM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X0jWBVG_1775783535;
Received: from 30.221.145.28(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X0jWBVG_1775783535 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Apr 2026 09:12:15 +0800
Message-ID: <2d81b084-1b56-44d3-81c9-32d5bfaa7c3c@linux.alibaba.com>
Date: Fri, 10 Apr 2026 09:12:14 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: validate group add input before caching
To: ZhengYuan Huang <gality369@gmail.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Heming Zhao <heming.zhao@suse.com>
References: <20260409153651.3575131-1-gality369@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260409153651.3575131-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/9/26 11:36 PM, ZhengYuan Huang wrote:
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
> the metadata cache tracked by INODE_CACHE(main_bm_inode). Keep the
> validation failure path separate from the later cleanup path so we only
> remove the buffer from that cache after it has actually been inserted.
> This keeps the group buffer lifetime consistent across validation,
> journaling, and cleanup.
> 
> Fixes: 7909f2bf8353 ("[PATCH 2/2] ocfs2: Implement group add for online resize")
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> ---
> v2:
> - add the missing Fixes tag for the group-add introduction commit
> - keep the validation failure path separate so cache removal only happens
>   after the buffer has been inserted into main_bm_inode's cache
> ---
> 
>  fs/ocfs2/resize.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
> index b0733c08ed13..6bb91b091b29 100644
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
> -		goto out_free_group_bh;
> +		goto out_brelse_group_bh;
>  	}
>  
> +	ocfs2_set_new_buffer_uptodate(INODE_CACHE(main_bm_inode), group_bh);
> +
>  	trace_ocfs2_group_add((unsigned long long)input->group,
>  			       input->chain, input->clusters, input->frees);
>  
> @@ -575,7 +575,9 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
>  
>  out_free_group_bh:

Now this label seems improper.
So I'd like keep it for brelse(), and move ocfs2_remove_from_cache() out
to a new label, e.g. out_remove_cache, and if ocfs2_start_trans() fails,
goto here.

Thanks,
Joseph
 
>  	if (ret < 0)
> -		ocfs2_remove_from_cache(INODE_CACHE(inode), group_bh);
> +		ocfs2_remove_from_cache(INODE_CACHE(main_bm_inode), group_bh);
> +
> +out_brelse_group_bh:
>  	brelse(group_bh);
>  
>  out_unlock:

