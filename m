Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFAD18FDBE
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Apr 2026 02:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775789176; cv=none; b=GJ9WZcNR7CQUH7lMQRCKqiZ/opQQsmsLWyaNJ/pckq1I1HBhDre8O9NuOP2ysFovsyjLRo4gwTm9Wpu6Apk8k+22FyD0r4Gbxeylmwg2JxYTNYUensBbwUc/vtBibn65RDaRdjD6BkuccO8jLiJs1W5DjRuCYfJV1yU22Gmw+I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775789176; c=relaxed/simple;
	bh=FqrggStE1z86hI19C2xcw/iYiJn6clbomTJts3mUzK0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tUOJlMKKs5NT+xide3tbkF3P8eHEpNBUl5sFJB7XjFSouxpCOneJTTDFNCaod53snikGHFDw5WUUw2E2EqiWn0vKvs4P9lbHsgcJdOOg29uS+R7yStxp7Gg+YIRSY8ItLpREkZvrP7KJ0OX/5uRgRxju8Bn4DLO784OJ/5Aq0Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=JUB3c6vT; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="JUB3c6vT"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775789170; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=1wlZF6xwICJoiVizurpoB/39+aXUNasYw+NuV4IiuhQ=;
	b=JUB3c6vTEYLFDb0BOYpHs10DyG056GcgCRzU9Nh1RCZB756ECzZ7yQZiZ1Am7p4JQbJ7uC6my77I821d7rYqh8m3PKo4THvWl+cB8qmjyAd36PDQx8N7CyYP4YyYTrklwtQREIQ7XB95UuLIH0gi+iFhwQhwQ2kulyJCYJFobcs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R891e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X0jlaXX_1775789168;
Received: from 30.221.145.28(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X0jlaXX_1775789168 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Apr 2026 10:46:09 +0800
Message-ID: <2c314914-e6d8-42ce-83dc-351f3f85fcaf@linux.alibaba.com>
Date: Fri, 10 Apr 2026 10:46:07 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: validate bg_bits during freefrag scan
To: ZhengYuan Huang <gality369@gmail.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Heming Zhao <heming.zhao@suse.com>
References: <20260409070624.3357378-1-gality369@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260409070624.3357378-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/9/26 3:06 PM, ZhengYuan Huang wrote:
> [BUG]
> A crafted filesystem can trigger an out-of-bounds bitmap walk when
> OCFS2_IOC_INFO is issued with OCFS2_INFO_FL_NON_COHERENT.
> 
> BUG: KASAN: use-after-free in instrument_atomic_read include/linux/instrumented.h:68 [inline]
> BUG: KASAN: use-after-free in _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
> BUG: KASAN: use-after-free in test_bit_le include/asm-generic/bitops/le.h:21 [inline]
> BUG: KASAN: use-after-free in ocfs2_info_freefrag_scan_chain fs/ocfs2/ioctl.c:495 [inline]
> BUG: KASAN: use-after-free in ocfs2_info_freefrag_scan_bitmap fs/ocfs2/ioctl.c:588 [inline]
> BUG: KASAN: use-after-free in ocfs2_info_handle_freefrag fs/ocfs2/ioctl.c:662 [inline]
> BUG: KASAN: use-after-free in ocfs2_info_handle_request+0x1c66/0x3370 fs/ocfs2/ioctl.c:754
> Read of size 8 at addr ffff888031bce000 by task syz.0.636/1435
> Call Trace:
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0xbe/0x130 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xd1/0x650 mm/kasan/report.c:482
>  kasan_report+0xfb/0x140 mm/kasan/report.c:595
>  check_region_inline mm/kasan/generic.c:186 [inline]
>  kasan_check_range+0x11c/0x200 mm/kasan/generic.c:200
>  __kasan_check_read+0x11/0x20 mm/kasan/shadow.c:31
>  instrument_atomic_read include/linux/instrumented.h:68 [inline]
>  _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
>  test_bit_le include/asm-generic/bitops/le.h:21 [inline]
>  ocfs2_info_freefrag_scan_chain fs/ocfs2/ioctl.c:495 [inline]
>  ocfs2_info_freefrag_scan_bitmap fs/ocfs2/ioctl.c:588 [inline]
>  ocfs2_info_handle_freefrag fs/ocfs2/ioctl.c:662 [inline]
>  ocfs2_info_handle_request+0x1c66/0x3370 fs/ocfs2/ioctl.c:754
>  ocfs2_info_handle+0x18d/0x2a0 fs/ocfs2/ioctl.c:828
>  ocfs2_ioctl+0x632/0x6e0 fs/ocfs2/ioctl.c:913
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl fs/ioctl.c:583 [inline]
>  __x64_sys_ioctl+0x197/0x1e0 fs/ioctl.c:583
>  ...
> 
> [CAUSE]
> ocfs2_info_freefrag_scan_chain() uses on-disk bg_bits directly as the
> bitmap scan limit. The coherent path reads group descriptors through
> ocfs2_read_group_descriptor(), which validates the descriptor before
> use. The non-coherent path uses ocfs2_read_blocks_sync() instead and
> skips that validation, so an impossible bg_bits value can drive the
> bitmap walk past the end of the block.
> 
> [FIX]
> Compute the bitmap capacity from the filesystem format with
> ocfs2_group_bitmap_size(), report descriptors whose bg_bits exceeds
> that limit, and clamp the scan to the computed capacity. This keeps the
> freefrag report going while avoiding reads beyond the buffer.
> 
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>

Missing fixes tag:
Fixes: d24a10b9f8ed ("Ocfs2: Add a new code 'OCFS2_INFO_FREEFRAG' for o2info ioctl.")

> ---
> v2:
> - Use ocfs2_group_bitmap_size() instead of the on-disk bg_size field
> - Clamp bg_bits to the computed bitmap capacity and continue scanning
> ---
>  fs/ocfs2/ioctl.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
> index b6864602814c..fa0ca014c6d5 100644
> --- a/fs/ocfs2/ioctl.c
> +++ b/fs/ocfs2/ioctl.c
> @@ -441,7 +441,7 @@ static int ocfs2_info_freefrag_scan_chain(struct ocfs2_super *osb,
>  	struct buffer_head *bh = NULL;
>  	struct ocfs2_group_desc *bg = NULL;
>  
> -	unsigned int max_bits, num_clusters;
> +	unsigned int max_bits, max_bitmap_bits, num_clusters;
>  	unsigned int offset = 0, cluster, chunk;
>  	unsigned int chunk_free, last_chunksize = 0;
>  
> @@ -474,11 +474,28 @@ static int ocfs2_info_freefrag_scan_chain(struct ocfs2_super *osb,
>  		}
>  
>  		bg = (struct ocfs2_group_desc *)bh->b_data;
> +		max_bits = le16_to_cpu(bg->bg_bits);
> +		max_bitmap_bits = 8U *
> +			ocfs2_group_bitmap_size(osb->sb, 1,
> +						osb->s_feature_incompat);

This is not right. It scans cluster allocator, not suballocator, so the
second parameter for ocfs2_group_bitmap_size() should be 0 instead of 1.

BTW, it seems we don't have to explictly mark it as unsigned int.


> +
> +		/*
> +		 * Non-coherent scans read raw blocks and do not get the
> +		 * bg_bits validation from
> +		 * ocfs2_read_group_descriptor().
> +		 */
> +		if (max_bits > max_bitmap_bits) {
> +			mlog(ML_ERROR,
> +			     "Group desc #%llu has %u bits, max bitmap bits %u\n",
> +			     (unsigned long long)blkno,
> +			     max_bits,
> +			     max_bitmap_bits);

Better to fold them into same line.

Thanks,
Joseph

> +			max_bits = max_bitmap_bits;
> +		}
>  
>  		if (!le16_to_cpu(bg->bg_free_bits_count))
>  			continue;
>  
> -		max_bits = le16_to_cpu(bg->bg_bits);
>  		offset = 0;
>  
>  		for (chunk = 0; chunk < chunks_in_group; chunk++) {

