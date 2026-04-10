Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E52820B22
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Apr 2026 03:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775790780; cv=none; b=hQBwOeLV2LYM3huJ6PQQsRfZmNftOSGWXBBAEKK+H07CYxOYQSuQ1hmQbPrsgagpZc0h5SvFuiSy1P+xfzFeiwB6XzVSCvf7Q/4kbJQhVaNmA8nv98YcowDVjHGaPvauUg1lB/tsryw1elKJs80HNZLz4LLutlHod174S/fTuxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775790780; c=relaxed/simple;
	bh=EjQgGc3yp1VMn3r4SI7CglfF1rcgHqOnNNvLPofq8b0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j36eYelmIhi+gZpGubFbAMAImFoCkmmLDuPEgsr+LKcBuUbEploMp6eqT3SVXuzXyYnCrScdqT+wOqD8d3GehS4pz5sNvt42FMT0F1+636TB/bb5GuNaTK31I4PqrV9NGnCRkssmdrG0KQlOl1HCXQfuzof0EK/9xuaoVlZpLho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EFViUg8K; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EFViUg8K"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-488ac04e13dso2282625e9.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 09 Apr 2026 20:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775790777; x=1776395577; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xWKRam2xYdlx+pLvfywopQxkEx5Y++zugW3qz5oZ9HE=;
        b=EFViUg8Ky/273NtIngp38wK8U9OXUzoNlKNp77ehuxwcU1dh/mnOda4VxGTpvuC1/w
         5010vvXaMANeacJ8BDsvOg0rujWezV5RACW2G8/a55EwV+lFSY/Uhk1mcgye1wmc98pe
         pbHE6fZ4fd1HhPNqV0fkYMFUm62TlL1apCocla1iihlUBPYjhP9FpV7O/kwnhgfF/hHE
         XjSxvC3gpY/lwoAb9aYWpUR/scwXkBVF7wkmImtKI+JFf6H0yCXn5wJL2bQLNWxMP5L7
         lBod+24RpmUTZp7yiuTC2uEZpjFEDfceEnCrrVvqAtZBPtymXr7pl8qRP+PHfoO2NKsT
         ZhJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775790777; x=1776395577;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xWKRam2xYdlx+pLvfywopQxkEx5Y++zugW3qz5oZ9HE=;
        b=qCYdxEX3r36hv9GTk9nRiI3gOqpgPhmCAHhjsDuvcTccyO5bMDRYkNzgkACL95BoU8
         oV+PMVcjeRGOfVmAdWs89iYKlGpUS/AlP190nh0wH4Xg3oNC6QhZhyr2vog1Qhoa2+Rt
         KA8/gOY44rn05MN+SEgDWrxWxu65gBSPBuewrD7+Oaaei4WsajYoqZ8m05wCo6uyb7RW
         nYSypijmKxhAA3seJEBJiyI0baSpUTcNbbB5VgMwjaWE5xJ7Pv+6wVlxuIPPZPi6GhM4
         UiQ8SG7Y1oCCu3gb5H1Xt63xMSTKQvLO9w3amqxq2UowM+t5o1l+NTmgE4MQZvqxP3zl
         jByQ==
X-Forwarded-Encrypted: i=1; AJvYcCXhj6vuupxOwTrb9VtoOCUGca7l2owtnffyMQFQxPo6Ezb3aMAsLFsoryypg0+UmP1GB84y48QxgZGJdg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw2KurWRemRmSBqVovGjO/jgWHaBi48a7cW+mK3KoBibtNucgjK
	/s9Hpr1bM5Bfm2cjdzK0kM7wv31qBjLmnXSfTrh+DZydCqeQnd97BvMZIbp3P8nK3eMUEz21vex
	Ucs4QJrI=
X-Gm-Gg: AeBDiesUoFMj6UOwdqts+vJMXxF3kUxo6W+u5jr4P3DvILcqaM+ir3p9ffMDkMtuIY1
	+X2OQNAle5CnKMOo9VzI7A/FzphP25in0Z8ZiFVDwLt5cinC0oQmClwsC1L01no0Q2LF0U1HEIf
	9jn0IlEenT9zykIbYtrO8wYJLjWX1JMaidJJUSAtNPusJdjWhCDRO8R7JbLU79+Kr/rJ+SThtjY
	o8ngFPk6SejM2lQfY4TYbUEh8GIa6oiSCQaBSVSnE1heji5alwtEzYwxA5nhtAA8oAahuSmRIf6
	rHVSmiOmlp7wWj1vCXo1RMtOkGLG6mIcVrVJ/Zst492KojZm6igRIw5v7T99tbdcRWM3S5BQn8t
	m/aTkO/xKeOzGzvlrv0pKtBsGRZeb4XDBij/IRatvXF44SXmHD33vxEI23FPnEe7vCxFyc4gM2R
	liZK71sGRoy0IEKnylCpVk+wrrjYAG80B1
X-Received: by 2002:a05:600c:1d14:b0:486:f634:f2e with SMTP id 5b1f17b1804b1-488d68b4086mr7507595e9.4.1775790776751;
        Thu, 09 Apr 2026 20:12:56 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2d4f32c76sm10174275ad.67.2026.04.09.20.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 20:12:55 -0700 (PDT)
Date: Fri, 10 Apr 2026 11:12:52 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: ZhengYuan Huang <gality369@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, 
	r33s3n6@gmail.com, zzzccc427@gmail.com
Subject: Re: [PATCH v4] ocfs2: validate bg_bits during freefrag scan
Message-ID: <zzcnbk4w2aa4buuazr57iuiqbcewgit4pglptf35lb3ig6gqvk@zl2bg4yqaoul>
References: <20260410030004.3810769-1-gality369@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410030004.3810769-1-gality369@gmail.com>

On Fri, Apr 10, 2026 at 11:00:04AM +0800, ZhengYuan Huang wrote:
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

Don't touch unrelated line. Others looks good to me.

- Heming
>  
>  		max_bits = le16_to_cpu(bg->bg_bits);
> +		max_bitmap_bits = 8 *
> +			ocfs2_group_bitmap_size(osb->sb, 0,
> +						osb->s_feature_incompat);
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
