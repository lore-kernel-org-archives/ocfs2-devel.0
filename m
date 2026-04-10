Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA1A31E848
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Apr 2026 03:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775793403; cv=none; b=U5K5OtEzmje5hwMd8qdUiWadkBnfsIrIcdQ59lF4uZd4xJBLTBsr/PH2ak+jip867B79kIkmUXe/HVIuUOZxOvW0Lk3Sg0U/EDC4pf4HX58sv2gQP2YxIb/NTzZqZKnB4f2Mq+G4zpHacdmCq0bOj72yg3p7bVvoh8V/DPHbXQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775793403; c=relaxed/simple;
	bh=F/yH4M8SFrlUrJw5Z8xPbMfG/VvEC2+bDYxkG5S1fUM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f1T0GygtQZpfL1A1eu2Qa38lWi8ASKMCml13HKuD0FKbXjWhvOqKBWeJ9IsdS+BJKErGDf0pTUvJQsIFuLM2tZn/zUIfKD27yPYV94hP4VpfNQl6TVnsQX6F6cfppCdtiwvBeHprIx4I6QOlRiOH1LvG8+d0U3YuJB/OtV/NqlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=arP8wRyL; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="arP8wRyL"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4836cd6e0d4so2608555e9.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 09 Apr 2026 20:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775793400; x=1776398200; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EFKtMAIQKlLRydtfPhD9Y5C0F+s6RIOj+B+d4vCVP9Q=;
        b=arP8wRyLqXiOrk1lBakZWvjp1r40a5dDphK/hcJpgnQGgXCQYBuXblJQ4yuCmyPIYt
         tuACnQrMzyeGPwA6MeVacZyLia9Tx0qkxK8Hq8ZepQj7+xMUa+7+o1qLftUwawfa7/2G
         6mak+ji3qrIcyl5xBNw6A7vVbsLG20pTzZ9j8qD5SISq1j1ZbCjLRG6lG1Vt1OMQcTmm
         F5vuQQSHmpj2MhzTG8EpPdlbC25NkKcJ9mIeYVm/cmF+j2tyWor57DvWqAAvBuxIlJCb
         GSM1QiHGYPg7u9wzIs7xN+KC3+WTI+Fg9dnhV/r2VzTo/s144D7MQu9v1qBsoH4zeCMA
         Ojpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775793400; x=1776398200;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EFKtMAIQKlLRydtfPhD9Y5C0F+s6RIOj+B+d4vCVP9Q=;
        b=P8+AWEKNe21AdmTOL7nUBVPP1+jk5WKSg0ibbitqHlWKVNMA527v/jeSUmFdf6UMb+
         6s4b6slRvxtd1YQUKe4HzaPQFiflnqXpNkXZUnTbhiOIvYZScLrjTpWTnk45hil1HUof
         nfAQsM2E7K881EDRr8U9sioBD7DNzIPR1i5/2X4b/lTSEz+p9RfOkZ21QaEsyzdqxKiF
         Rm2J0PqJMGM/LrEluPKMqAdUJvEqcB9YVVNxQ+30vbK466VDbRg7oqcixPhiv9RyFKgb
         48oo6tJqC6uw+sDiK2tmUGb3lkYDvB17MpZFL7gJH/oas5ePmZssmiLxuhWeGoDcgegm
         T+HQ==
X-Forwarded-Encrypted: i=1; AJvYcCWH0QAzPoG4WgLbGIXYfljwoCl6RDOeZtLIcNSJZkPFNk56qD9imMD9HslhqVjEBVdrTy6E/5UvHp/OSg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwY39sZnTlSYRRolTofLVKbBslF2U0ctw2WSXZBucQpgjjezkDQ
	RaAlK68NGTOvkLrs/oqrGzHzYN79WP61L4cOEGoQtuNQkVNCyAxLTQTdabcUkyExf1o=
X-Gm-Gg: AeBDiesLFUWKyEXKCmYb8i51lNV+zUz68ZmRZz8DLgLKBakyOIUez9uDvd1h/mSQCE/
	FvQ2TZF1LyIMYxxJConSLbs9uSIe8IPToVhUVyOkSNuw1KP9Pa9mEW0/BeRSWFi25/5CDnfcSrN
	CXCrKOZ5bfA44ylvbwn16NAXifTB/gWXNE8LBfxk2mawbysqg7ynz4TYZFGUHxQK0F2L2PaW94f
	JuDEBek6inN20et197l9lJE1i1MV3uie6JJm6jOFb0H2dQHFbDNqd7X1RlOJvhcEaEJGQVbsgfY
	LeRZnx/H41BnSWxY+T7l0tFqy4Q1kVDKTogRf06rGYwMNlLnqmBl5U2f02Cy7eaKMBTu8SxoDSB
	ofdAj34LRs368l8HO8If1oOtznQGfhm2u/ewMxMwBv+XcLyEkmtYe4cXZRydGDBd5hq5HPhw2aH
	F+D/hN73uyySbgOAoqShho4+BtXAo9FDyB
X-Received: by 2002:a05:600c:4504:b0:488:a797:f099 with SMTP id 5b1f17b1804b1-488d6864dddmr8325335e9.3.1775793399841;
        Thu, 09 Apr 2026 20:56:39 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35e4122344esm1445329a91.7.2026.04.09.20.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 20:56:38 -0700 (PDT)
Date: Fri, 10 Apr 2026 11:56:35 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: ZhengYuan Huang <gality369@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, 
	r33s3n6@gmail.com, zzzccc427@gmail.com
Subject: Re: [PATCH v5] ocfs2: validate bg_bits during freefrag scan
Message-ID: <snsyc4uqirdsl6bcz3u2nvntuhgq3t3ixa5u2cnlfowofc6y4c@rxkb5z5lcrjv>
References: <20260410034220.3825769-1-gality369@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410034220.3825769-1-gality369@gmail.com>

On Fri, Apr 10, 2026 at 11:42:20AM +0800, ZhengYuan Huang wrote:
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

LGTM.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>

> ---
> v5:
> - move max_bitmap_bits computation out of the group loop
> - restore the untouched blank line after assigning bg
> 
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
>  fs/ocfs2/ioctl.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
> index b6864602814c..10f573a8b6b6 100644
> --- a/fs/ocfs2/ioctl.c
> +++ b/fs/ocfs2/ioctl.c
> @@ -441,13 +441,16 @@ static int ocfs2_info_freefrag_scan_chain(struct ocfs2_super *osb,
>  	struct buffer_head *bh = NULL;
>  	struct ocfs2_group_desc *bg = NULL;
>  
> -	unsigned int max_bits, num_clusters;
> +	unsigned int max_bits, max_bitmap_bits, num_clusters;
>  	unsigned int offset = 0, cluster, chunk;
>  	unsigned int chunk_free, last_chunksize = 0;
>  
>  	if (!le32_to_cpu(rec->c_free))
>  		goto bail;
>  
> +	max_bitmap_bits = 8 * ocfs2_group_bitmap_size(osb->sb, 0,
> +					      osb->s_feature_incompat);
> +
>  	do {
>  		if (!bg)
>  			blkno = le64_to_cpu(rec->c_blkno);
> @@ -479,6 +482,19 @@ static int ocfs2_info_freefrag_scan_chain(struct ocfs2_super *osb,
>  			continue;
>  
>  		max_bits = le16_to_cpu(bg->bg_bits);
> +
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
> -- 
> 2.43.0
> 
> 
