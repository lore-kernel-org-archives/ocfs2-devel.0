Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F6C31327A
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Apr 2026 04:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775796527; cv=none; b=i2tj6MVg7L2KVTo9RiHzp0RR5V21vyqESEXn2aFlfShZTXdZ7j4BA7Jhh9XeCbalxQL2KE6Gr0os7Wd/eyN5HG9/puEZq5C1eLX36ZmNfzh4Ww+9PZkaetbzztmLG9J9E2L+p7bmKKALDs8cx7ZN2vFu/s8Z+FPw+5eB5pHye2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775796527; c=relaxed/simple;
	bh=x62Bfz6PwUwmNSTR+bUQ3GiiT5MyoRj5zIyWT3iFwUE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GnAyRS4mci4ddg6xSki7CjV0Nq+KQFtx512m+R3FCAwII9Hk+3p1hgEzIVIKw5X/eHj7vGgevYJ1N3doOW3Ajk3tVJFmSYpkuxsqx6JMdyTUOKZXpVl9V+lFqPzJOzCaew8z/nrFAWboEGUvOZkIyOvflScgwWHFKs5DC4QQ0iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=uD9tVZm0; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="uD9tVZm0"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775796516; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=McOZ6YH91rrFMXHgA8NeNn+4rHqeVrg9eBs9xVooaWo=;
	b=uD9tVZm01oo6w5vo+iYInU3qfleIy31SmaEmcGhlQhFivbz+WA0wT/wo9eSgJFye8tYr18fuXHuka7bjLO/KaRiqG5lyVENjlslWF6MNgGqp0arApcUcVZ8tJC4TjLHbOXQjmUfPhZpee/DEn7O5u3FRNZz2uxSSuskN08hM63c=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X0k4o8o_1775796514;
Received: from 30.221.145.28(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X0k4o8o_1775796514 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Apr 2026 12:48:35 +0800
Message-ID: <6e71b245-233f-4cab-a7bc-ccf75f555f97@linux.alibaba.com>
Date: Fri, 10 Apr 2026 12:48:33 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] ocfs2: validate bg_bits during freefrag scan
To: Heming Zhao <heming.zhao@suse.com>, ZhengYuan Huang
 <gality369@gmail.com>, akpm <akpm@linux-foundation.org>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, r33s3n6@gmail.com,
 zzzccc427@gmail.com
References: <20260410034220.3825769-1-gality369@gmail.com>
 <snsyc4uqirdsl6bcz3u2nvntuhgq3t3ixa5u2cnlfowofc6y4c@rxkb5z5lcrjv>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <snsyc4uqirdsl6bcz3u2nvntuhgq3t3ixa5u2cnlfowofc6y4c@rxkb5z5lcrjv>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/10/26 11:56 AM, Heming Zhao wrote:
> On Fri, Apr 10, 2026 at 11:42:20AM +0800, ZhengYuan Huang wrote:
>> [BUG]
>> A crafted filesystem can trigger an out-of-bounds bitmap walk when
>> OCFS2_IOC_INFO is issued with OCFS2_INFO_FL_NON_COHERENT.
>>
>> BUG: KASAN: use-after-free in instrument_atomic_read include/linux/instrumented.h:68 [inline]
>> BUG: KASAN: use-after-free in _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
>> BUG: KASAN: use-after-free in test_bit_le include/asm-generic/bitops/le.h:21 [inline]
>> BUG: KASAN: use-after-free in ocfs2_info_freefrag_scan_chain fs/ocfs2/ioctl.c:495 [inline]
>> BUG: KASAN: use-after-free in ocfs2_info_freefrag_scan_bitmap fs/ocfs2/ioctl.c:588 [inline]
>> BUG: KASAN: use-after-free in ocfs2_info_handle_freefrag fs/ocfs2/ioctl.c:662 [inline]
>> BUG: KASAN: use-after-free in ocfs2_info_handle_request+0x1c66/0x3370 fs/ocfs2/ioctl.c:754
>> Read of size 8 at addr ffff888031bce000 by task syz.0.636/1435
>> Call Trace:
>>  __dump_stack lib/dump_stack.c:94 [inline]
>>  dump_stack_lvl+0xbe/0x130 lib/dump_stack.c:120
>>  print_address_description mm/kasan/report.c:378 [inline]
>>  print_report+0xd1/0x650 mm/kasan/report.c:482
>>  kasan_report+0xfb/0x140 mm/kasan/report.c:595
>>  check_region_inline mm/kasan/generic.c:186 [inline]
>>  kasan_check_range+0x11c/0x200 mm/kasan/generic.c:200
>>  __kasan_check_read+0x11/0x20 mm/kasan/shadow.c:31
>>  instrument_atomic_read include/linux/instrumented.h:68 [inline]
>>  _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
>>  test_bit_le include/asm-generic/bitops/le.h:21 [inline]
>>  ocfs2_info_freefrag_scan_chain fs/ocfs2/ioctl.c:495 [inline]
>>  ocfs2_info_freefrag_scan_bitmap fs/ocfs2/ioctl.c:588 [inline]
>>  ocfs2_info_handle_freefrag fs/ocfs2/ioctl.c:662 [inline]
>>  ocfs2_info_handle_request+0x1c66/0x3370 fs/ocfs2/ioctl.c:754
>>  ocfs2_info_handle+0x18d/0x2a0 fs/ocfs2/ioctl.c:828
>>  ocfs2_ioctl+0x632/0x6e0 fs/ocfs2/ioctl.c:913
>>  vfs_ioctl fs/ioctl.c:51 [inline]
>>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>>  __se_sys_ioctl fs/ioctl.c:583 [inline]
>>  __x64_sys_ioctl+0x197/0x1e0 fs/ioctl.c:583
>>  ...
>>
>> [CAUSE]
>> ocfs2_info_freefrag_scan_chain() uses on-disk bg_bits directly as the
>> bitmap scan limit. The coherent path reads group descriptors through
>> ocfs2_read_group_descriptor(), which validates the descriptor before
>> use. The non-coherent path uses ocfs2_read_blocks_sync() instead and
>> skips that validation, so an impossible bg_bits value can drive the
>> bitmap walk past the end of the block.
>>
>> [FIX]
>> Compute the bitmap capacity from the filesystem format with
>> ocfs2_group_bitmap_size(), report descriptors whose bg_bits exceeds
>> that limit, and clamp the scan to the computed capacity. This keeps the
>> freefrag report going while avoiding reads beyond the buffer.
>>
>> Fixes: d24a10b9f8ed ("Ocfs2: Add a new code 'OCFS2_INFO_FREEFRAG' for o2info ioctl.")
>> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> 
> LGTM.
> Reviewed-by: Heming Zhao <heming.zhao@suse.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> 
>> ---
>> v5:
>> - move max_bitmap_bits computation out of the group loop
>> - restore the untouched blank line after assigning bg
>>
>> v4:
>> - add the freefrag introduction commit as a Fixes tag
>> - use cluster allocator bitmap sizing with ocfs2_group_bitmap_size(..., 0, ...)
>> - drop the unnecessary 8U suffix and tighten the mlog() formatting
>>
>> v3:
>> - restore the empty-group fast path before computing bitmap limits
>> - move the bg_bits clamp below bg_free_bits_count to skip extra work
>>   for empty groups
>>
>> v2:
>> - use ocfs2_group_bitmap_size() instead of the on-disk bg_size field
>> - clamp bg_bits to the computed bitmap capacity and continue scanning
>> ---
>>  fs/ocfs2/ioctl.c | 19 ++++++++++++++++++-
>>  1 file changed, 18 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
>> index b6864602814c..10f573a8b6b6 100644
>> --- a/fs/ocfs2/ioctl.c
>> +++ b/fs/ocfs2/ioctl.c
>> @@ -441,13 +441,16 @@ static int ocfs2_info_freefrag_scan_chain(struct ocfs2_super *osb,
>>  	struct buffer_head *bh = NULL;
>>  	struct ocfs2_group_desc *bg = NULL;
>>  
>> -	unsigned int max_bits, num_clusters;
>> +	unsigned int max_bits, max_bitmap_bits, num_clusters;
>>  	unsigned int offset = 0, cluster, chunk;
>>  	unsigned int chunk_free, last_chunksize = 0;
>>  
>>  	if (!le32_to_cpu(rec->c_free))
>>  		goto bail;
>>  
>> +	max_bitmap_bits = 8 * ocfs2_group_bitmap_size(osb->sb, 0,
>> +					      osb->s_feature_incompat);
>> +
>>  	do {
>>  		if (!bg)
>>  			blkno = le64_to_cpu(rec->c_blkno);
>> @@ -479,6 +482,19 @@ static int ocfs2_info_freefrag_scan_chain(struct ocfs2_super *osb,
>>  			continue;
>>  
>>  		max_bits = le16_to_cpu(bg->bg_bits);
>> +
>> +		/*
>> +		 * Non-coherent scans read raw blocks and do not get the
>> +		 * bg_bits validation from
>> +		 * ocfs2_read_group_descriptor().
>> +		 */
>> +		if (max_bits > max_bitmap_bits) {
>> +			mlog(ML_ERROR,
>> +			     "Group desc #%llu has %u bits, max bitmap bits %u\n",
>> +			     (unsigned long long)blkno, max_bits, max_bitmap_bits);
>> +			max_bits = max_bitmap_bits;
>> +		}
>> +
>>  		offset = 0;
>>  
>>  		for (chunk = 0; chunk < chunks_in_group; chunk++) {
>> -- 
>> 2.43.0
>>
>>

