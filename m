Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC71630BF5C
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Apr 2026 03:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775791403; cv=none; b=eMrCU/cFbRMOJ9hDZnW7gUw2bWjf3RLxIrfXNfWAhif86gxCpdvbbjIfuaZt5t8J9TmLDFgMT5LOQmXvw1xYc2AVEqLk2iu+4U8GSzAVOHy6vaA11JXsKKxql/HBnSI5xT1a7ynl/XfKR3Hjt7nfRKBZ8aCfEALyONA9WFs00yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775791403; c=relaxed/simple;
	bh=04eUzvqMXlFikBxXegGM1zYXikxy0l7hON4sTYFrY4g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LFssdGbVcKR4QcxaYi+kjFavftbOccdb5TiqEEkqazf4p2xv6KNtF/vnFPmANI9+K35kprw8zLrS+RaLEkvaJR0K81qICI7lqUrCXKDyD0uScKJ1Dki9/3O6XG7mCcHixShXnqxzCycfTTNJs7LYBsVlel0GUHf8PM+TS4sGSx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=TbYbDFrf; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="TbYbDFrf"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775791396; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=7pruV5udF9JiPCvJJbSFBm80/dk1U0HTxYoQJp0ZJAw=;
	b=TbYbDFrfa+GCvFdj1JbYcey8AszpFkva+VaHZXjKxSCiSrkotyvFVOL3R2iJqgOHZy/ZauwfSXi1Ue0ruteKg0yHj1Ox8Rei0Eq3UXyj4QNELu/0d2+mvpm6xIIB5+b01BMRDQFEpZSEKcBiYP1O1XJmgQAnxrp0mT5ZjwVsoLs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X0joJ7B_1775791394;
Received: from 30.221.145.28(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X0joJ7B_1775791394 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Apr 2026 11:23:15 +0800
Message-ID: <45706dfa-6a4c-4e62-bddb-cebd206e469f@linux.alibaba.com>
Date: Fri, 10 Apr 2026 11:23:14 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] ocfs2: validate bg_bits during freefrag scan
To: ZhengYuan Huang <gality369@gmail.com>, Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <20260410030004.3810769-1-gality369@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260410030004.3810769-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/10/26 11:00 AM, ZhengYuan Huang wrote:
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
> Fixes: d24a10b9f8ed ("Ocfs2: Add a new code 'OCFS2_INFO_FREEFRAG' for o2info ioctl.")
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> ---
> v4:
> - add the freefrag introduction commit as a Fixes tag
> - use cluster allocator bitmap sizing with ocfs2_group_bitmap_size(..., 0, ...)
> - drop the unnecessary 8U suffix and tighten the mlog() formatting
> 
> v3:
> - restore the empty-group fast path before computing bitmap limits
> - move the bg_bits clamp below bg_free_bits_count to skip extra work
>   for empty groups
> 
> v2:
> - use ocfs2_group_bitmap_size() instead of the on-disk bg_size field
> - clamp bg_bits to the computed bitmap capacity and continue scanning
> ---
>  fs/ocfs2/ioctl.c | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
> index b6864602814c..82d8e69dd575 100644
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
> @@ -474,11 +474,26 @@ static int ocfs2_info_freefrag_scan_chain(struct ocfs2_super *osb,
>  		}
>  
>  		bg = (struct ocfs2_group_desc *)bh->b_data;
> -
>  		if (!le16_to_cpu(bg->bg_free_bits_count))
>  			continue;
>  
>  		max_bits = le16_to_cpu(bg->bg_bits);
> +		max_bitmap_bits = 8 *
> +			ocfs2_group_bitmap_size(osb->sb, 0,
> +						osb->s_feature_incompat);
> +

max_bitmap_bits is unchanged, so it could be moved out of loop.
Other looks good me.

Thanks,
Joseph

> +		/*
> +		 * Non-coherent scans read raw blocks and do not get the
> +		 * bg_bits validation from
> +		 * ocfs2_read_group_descriptor().
> +		 */
> +		if (max_bits > max_bitmap_bits) {
> +			mlog(ML_ERROR,
> +			     "Group desc #%llu has %u bits, max bitmap bits %u\n",
> +			     (unsigned long long)blkno, max_bits, max_bitmap_bits);
> +			max_bits = max_bitmap_bits;
> +		}
> +
>  		offset = 0;
>  
>  		for (chunk = 0; chunk < chunks_in_group; chunk++) {

