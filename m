Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F92407CCF
	for <ocfs2-devel@lists.linux.dev>; Tue, 11 Aug 2026 07:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786433815; cv=none; b=bENuv8EW48oxfhpQhv6fxwnnfIWNK2aTjENoLLtbiIIdowccfGsHV37B2A+8kwobDeTeI++QZoVzyjmv0xxXCbxmbq7oDyFpudA/Km+Lv7V74X6qyoPtYG+BG4mvISN17a4zbzLDNAWB91pOKBcOtF2cXPXwoAFavvcpi+0InA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786433815; c=relaxed/simple;
	bh=45vsj8+RVmcyRgsX0elOXHPIKCYp9OA7K4xGkOKz/4Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i+FN4aDaoqTeYeX92G5+ScK6UrNE8e4J+Ebdnb0ScoLAnOYcLBzYJHnFAEWoX/aeWqkYS6k+Trth4YPSQAK7vAI0rDdvbCCgrwMqZq4I5FvgXLBZx7fK3VEJGdbBZ5rm0yfpUDxxCqS5rnpR5fCfRN9J9BhOGRnOJGKTZchT8ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=p6CyW5X9; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="p6CyW5X9"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786433806; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=47mTht+YyABypsG6GqT7gAl8442ywU7k/7UZ1XGh+Is=;
	b=p6CyW5X9EWG19OAkfNNWzK1+nrOhWfqeeyDjN6RS0Bx1lk7CZbKQhUOiUUAPUhIp0NkGZZemUH+PCYQbMjLMispSUJcCdFyVQKqfHoYbyT+QAL0rVioJwdkJVOxm2eyMamSceS4Tz4pVBcCfl1f5tWv2fe+4z3fhqRsJKAUdC4Y=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R241e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X8ndZVH_1786433804;
Received: from 30.221.129.51(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X8ndZVH_1786433804 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 11 Aug 2026 15:36:45 +0800
Message-ID: <fe4f24eb-b882-4fdd-86b2-56886b2d34e5@linux.alibaba.com>
Date: Tue, 11 Aug 2026 15:36:43 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: validate global bitmap cl_bpc before resize
To: ZhengYuan Huang <gality369@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, r33s3n6@gmail.com,
 zzzccc427@gmail.com, tom442288@tuta.io
References: <20260804064445.766072-1-gality369@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260804064445.766072-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/4/26 2:44 PM, ZhengYuan Huang wrote:
> [BUG]
> A corrupted global bitmap inode can make online group extension scan past
> the end of a group descriptor bitmap:
> 
> BUG: KASAN: use-after-free in _find_next_bit+0xef/0x120 lib/find_bit.c:157
> Read of size 8 at addr ffff888021b52000 by task syz.0.34/409
> Call Trace:
>  ...
>  _find_next_bit+0xef/0x120 lib/find_bit.c:157
>  find_next_bit include/linux/find.h:73 [inline]
>  find_next_bit_le include/linux/find.h:518 [inline]
>  ocfs2_find_max_contig_free_bits+0x53/0xb0 fs/ocfs2/suballoc.c:1292
>  ocfs2_update_last_group_and_inode fs/ocfs2/resize.c:127 [inline]
>  ocfs2_group_extend+0x83e/0x1ae0 fs/ocfs2/resize.c:350
>  ocfs2_ioctl+0x175/0x6e0 fs/ocfs2/ioctl.c:869
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl fs/ioctl.c:583 [inline]
>  __x64_sys_ioctl+0x197/0x1e0 fs/ioctl.c:583
>  ...
> 
> [CAUSE]
> ocfs2_group_extend() consumes the global bitmap dinode's cl_bpc value in
> resize arithmetic. The existing inode validation checked cl_bpc only for
> non-global chain allocators, so a corrupted global bitmap value could reach
> the resize path. With cl_bpc changed from 1 to 51457, extending by seven
> clusters wraps the u16 bit count and grows a 2048-bit group to 34567 bits,
> exceeding its 32256-bit bitmap capacity.
> 
> [FIX]
> Validate cl_bpc in ocfs2_validate_inode_block() for every chain allocator,
> including the global bitmap, against the value derived from the
> filesystem's cluster and block sizes. This rejects the corrupted dinode
> when it is read and removes the resize-local check that incorrectly assumed
> cl_bpc is always one. The resize path still uses the validated value for
> its arithmetic.
> 
> Fixes: d659072f7368 ("[PATCH 1/2] ocfs2: Add group extend for online resize")
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> ---
> v2:
> - Derive the expected cl_bpc from the filesystem block and cluster sizes.
> - Extend the existing inode-block validation to cover the global bitmap.
> - Remove the resize-local hardcoded cl_bpc check.
> ---
> ---
>  fs/ocfs2/inode.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 41db7dd39ed9..0e1f9ae0eb73 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1683,12 +1683,11 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  					 le16_to_cpu(cl->cl_next_free_rec));
>  			goto bail;
>  		}
> -		if (OCFS2_SB(sb)->bitmap_blkno &&
> -		    OCFS2_SB(sb)->bitmap_blkno != le64_to_cpu(di->i_blkno) &&
> -		    le16_to_cpu(cl->cl_bpc) != bpc) {
> -			rc = ocfs2_error(sb, "Invalid dinode %llu: bits per cluster %u\n",
> +		if (le16_to_cpu(cl->cl_bpc) != bpc) {

For global bitmap inode, its cl_bpc is legitimately 1.
So this is wrong and will break mount during fill super.
NAK.

Thanks,
Joseph

> +			rc = ocfs2_error(sb,
> +					 "Invalid dinode %llu: bits per cluster %u (expected %u)\n",
>  					 (unsigned long long)bh->b_blocknr,
> -					 le16_to_cpu(cl->cl_bpc));
> +					 le16_to_cpu(cl->cl_bpc), bpc);
>  			goto bail;
>  		}
>  	}

