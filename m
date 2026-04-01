Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B85732A3DA
	for <ocfs2-devel@lists.linux.dev>; Wed,  1 Apr 2026 03:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775014184; cv=none; b=Sn8TN4n8zNJcakqD3tsG2hgVxh5NmaRTWBSWM9oq2CkJLo6ltVxhTPwXTBO7nFcM68HLHdfudGKltwwT0fpvps3kYMr6QHlS7N52x+3wKoJmwLCt2mSwt3wbNsp64X79EkvGgvbQwNGN+CaFnQWVo97GMExDoSV1MlahIaOjbWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775014184; c=relaxed/simple;
	bh=wnxARK+owZgpnXQVR8wVBGdXWPjJ3fyzmQa41WIQHbc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CcquH22D1nDlWUibggwlygGjfxsz/P+/y6VYPKNVJZwwBlj38zaGow41KPfdb2Oy0DGnGtaU1l3SE4J1qOpDHigSKo4xPg/SP2iHHq2RnWJONweQvdYEtlkozUtRfJ3zTslLKivc28AC+tTkKnN5JwDNqLgGbm/0TAphqpWdS2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=pHOdkPYK; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="pHOdkPYK"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775014180; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=vTDKu1MTZgt+yKLQ585rB4NZHIpa28DY0kQBhhjsBfM=;
	b=pHOdkPYK1yK2hZ04vVZ2yN18Bzte7sDyReHmIEbtkIZXqtUVTA31L1HFtJangkYJNtkZLq9hWfVe4TQjks5rB0J3n0ZHitV7NVBbbHRsR34pe+Kal/1tdNDcTqxLsBbRbUoD8+DQAdi7K1p5aikiRFmOBMVYFf1wpAp/czMTkwE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X06pJ63_1775014178;
Received: from 30.221.145.27(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X06pJ63_1775014178 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 01 Apr 2026 11:29:39 +0800
Message-ID: <99c4c231-01d8-4dea-a65d-bf59bd2b38eb@linux.alibaba.com>
Date: Wed, 1 Apr 2026 11:29:38 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: validate bg_list extent bounds in discontig
 groups
To: ZhengYuan Huang <gality369@gmail.com>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Heming Zhao <heming.zhao@suse.com>
References: <20260401021622.3560952-1-gality369@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260401021622.3560952-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/1/26 10:16 AM, ZhengYuan Huang wrote:
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
> Validate discontiguous bg_list.l_count against
> ocfs2_extent_recs_per_gd(sb), then reject l_next_free_rec values that
> exceed l_count. This keeps the on-disk extent list self-consistent and
> matches how the rest of ocfs2 uses l_count as the extent-list bound.
> 
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> Changes in v2:
> - Validate bg_list.l_count against ocfs2_extent_recs_per_gd(sb).
> - Bound bg_list.l_next_free_rec by bg_list.l_count.
> - Update the changelog text to explain the l_count validation.
> ---
>  fs/ocfs2/suballoc.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 6ac4dcd54588..29a8a878c2df 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -196,6 +196,31 @@ static int ocfs2_validate_gd_self(struct super_block *sb,
>  			 8 * le16_to_cpu(gd->bg_size));
>  	}
>  
> +	/*
> +	 * For discontiguous block groups, validate the on-disk extent list
> +	 * against the maximum number of extent records that can physically
> +	 * fit in a single block.
> +	 */
> +	if (ocfs2_gd_is_discontig(gd)) {
> +		u16 max_recs = ocfs2_extent_recs_per_gd(sb);
> +		u16 l_count = le16_to_cpu(gd->bg_list.l_count);
> +		u16 l_next_free_rec = le16_to_cpu(gd->bg_list.l_next_free_rec);
> +
> +		if (l_count != max_recs) {
> +			do_error("Group descriptor #%llu bad discontig l_count %u expected %u\n",
> +				 (unsigned long long)bh->b_blocknr,
> +				 l_count,
> +				 max_recs);
> +		}
> +
> +		if (l_next_free_rec > l_count) {
> +			do_error("Group descriptor #%llu bad discontig l_next_free_rec %u max %u\n",
> +				 (unsigned long long)bh->b_blocknr,
> +				 l_next_free_rec,
> +				 l_count);
> +		}
> +	}
> +
>  	return 0;
>  }
>  

