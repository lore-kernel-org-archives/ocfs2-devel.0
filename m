Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38D129B216
	for <ocfs2-devel@lists.linux.dev>; Wed,  1 Apr 2026 01:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775006794; cv=none; b=VO6xXQ/zKFnBmQvXyuRwzydKpMwkhpQZ1ldNB1Tv/c3MQ5iMTxkE/yKB1yflPzVudIQ8U3brW9JlU1UEJUB5xCqZtrW8CXKZAGCrMh+7iwwLcvDyjoA5R65avnPPdlqOCNgBrN+Ijg9V9TZ3q11fBsTzpfrH53bF8Glq+6y8siw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775006794; c=relaxed/simple;
	bh=RQkKsAtDI/yZwVdQwFc83NTjTa5gyBVe0YDeLuMU7ds=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lfKKKEA01lcKGoQGElwB06Yb6yo8OYmMrpiNkyvhN+1R0jDF/9cLlz+kLqv6PAuSEBYVpij04XSz3zrRWcSE1JikMxXQ5gBWM8XKWNpgeTLO7i7mYkuV4cLMrsv6eza/TL8N/MY/gXOZ5cuHs91C7Q+WJCF+l4/gsSd/v570L30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=cWsbWn8W; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="cWsbWn8W"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775006788; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=YnvuuR/lO7KS6DQzz5vfOIYGZZC/Asif3uKolZer6II=;
	b=cWsbWn8WsIuq5jNNvZD21rbhi8yo469FH6TxWpIV9K3P5naUpoB7lW3/MIR0qZ09wQnYcfcS2FhhSTsrE7nNKJpqSPsMvsQ8cC1Tjb/Ma4LWQnFH1eOa1GOfKGnUXT5E4Ek2fPAZ0C58G9Lcil/J3syC9ZO//tYn4lxinMZf7ME=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X05mGYa_1775006786;
Received: from 30.221.145.27(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X05mGYa_1775006786 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 01 Apr 2026 09:26:27 +0800
Message-ID: <46fe2e7a-60bc-4d85-9c17-fce665b366fe@linux.alibaba.com>
Date: Wed, 1 Apr 2026 09:26:26 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: validate bg_list.l_next_free_rec in discontig
 group descriptor
To: ZhengYuan Huang <gality369@gmail.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <20260331133134.1842372-1-gality369@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260331133134.1842372-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/31/26 9:31 PM, ZhengYuan Huang wrote:
> [BUG]
> Running ocfs2 on a corrupted image with a discontiguous block
> group whose bg_list.l_next_free_rec is set to an excessively
> large value triggers a KASAN use-after-free crash:
> 
> BUG: KASAN: use-after-free in ocfs2_bg_discontig_fix_by_rec fs/ocfs2/suballoc.c:1678 [inline]
> BUG: KASAN: use-after-free in ocfs2_bg_discontig_fix_result+0x4a4/0x560 fs/ocfs2/suballoc.c:1715
> Read of size 4 at addr ffff88801a85f000 by task syz.0.115/552
> 
> Call Trace:
>  <TASK>
>  ...
>  __asan_report_load4_noabort+0x14/0x30 mm/kasan/report_generic.c:380
>  ocfs2_bg_discontig_fix_by_rec fs/ocfs2/suballoc.c:1678 [inline]
>  ocfs2_bg_discontig_fix_result+0x4a4/0x560 fs/ocfs2/suballoc.c:1715
>  ocfs2_search_one_group fs/ocfs2/suballoc.c:1752 [inline]
>  ocfs2_claim_suballoc_bits+0x13c3/0x1cd0 fs/ocfs2/suballoc.c:1984
>  ocfs2_claim_new_inode+0x2e7/0x8a0 fs/ocfs2/suballoc.c:2292
>  ocfs2_mknod_locked.constprop.0+0x121/0x2a0 fs/ocfs2/namei.c:637
>  ocfs2_mknod+0xc71/0x2400 fs/ocfs2/namei.c:384
>  ocfs2_create+0x158/0x390 fs/ocfs2/namei.c:676
>  lookup_open.isra.0+0x10a1/0x1460 fs/namei.c:3796
>  open_last_lookups fs/namei.c:3895 [inline]
>  path_openat+0x11fe/0x2ce0 fs/namei.c:4131
>  do_filp_open+0x1f6/0x430 fs/namei.c:4161
>  do_sys_openat2+0x117/0x1c0 fs/open.c:1437
>  do_sys_open fs/open.c:1452 [inline]
>  __do_sys_openat fs/open.c:1468 [inline]
>  __se_sys_openat fs/open.c:1463 [inline]
>  __x64_sys_openat+0x15b/0x220 fs/open.c:1463
>  ...
> 
> [CAUSE]
> ocfs2_bg_discontig_fix_result() iterates over bg->bg_list.l_recs[]
> using l_next_free_rec as the upper bound without any sanity check:
> 
>   for (i = 0; i < le16_to_cpu(bg->bg_list.l_next_free_rec); i++) {
>           rec = &bg->bg_list.l_recs[i];
> 
> l_next_free_rec is read directly from the on-disk group descriptor and
> is trusted blindly. On a 4 KiB block device, bg_list.l_recs[] can hold
> at most 235 entries (ocfs2_extent_recs_per_gd(sb)). A corrupted or
> crafted filesystem image can set l_next_free_rec to an arbitrarily
> large value, causing the loop to index past the end of the group
> descriptor buffer_head data page and into an adjacent freed page.
> 
> [FIX]
> Fix this by adding a bounds check in ocfs2_validate_gd_self(), which
> is called for every group descriptor read via ocfs2_read_group_descriptor().
> Use ocfs2_gd_is_discontig() to restrict the check to discontiguous
> block groups, and ocfs2_extent_recs_per_gd(sb) as the physical upper
> bound (rather than trusting the on-disk l_count, which could also be
> corrupted). This follows the same do_error() pattern used by the
> existing field sanity checks in ocfs2_validate_gd_self().
> 
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> ---
>  fs/ocfs2/suballoc.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 6ac4dcd54588..6dcf45fda457 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -196,6 +196,22 @@ static int ocfs2_validate_gd_self(struct super_block *sb,
>  			 8 * le16_to_cpu(gd->bg_size));
>  	}
>  
> +	/*
> +	 * For discontiguous block groups, validate that bg_list.l_next_free_rec
> +	 * does not exceed the maximum number of extent records that can physically
> +	 * fit in a single block.
> +	 */
> +	if (ocfs2_gd_is_discontig(gd)) {
> +		u16 max_recs = ocfs2_extent_recs_per_gd(sb);
> +
> +		if (le16_to_cpu(gd->bg_list.l_next_free_rec) > max_recs) {

Since most places only check l_count, so why not validate l_count here
as well?
Something like:

if (le16_to_cpu(el->l_count) != max_recs ||
    le16_to_cpu(el->l_next_free_rec > le16_to_cpu(el->l_count))
	......

Thanks,
Joseph

> +			do_error("Group descriptor #%llu bad discontig l_next_free_rec %u max %u\n",
> +				 (unsigned long long)bh->b_blocknr,
> +				 le16_to_cpu(gd->bg_list.l_next_free_rec),
> +				 max_recs);
> +		}
> +	}
> +
>  	return 0;
>  }
>  

