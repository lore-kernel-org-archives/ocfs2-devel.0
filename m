Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28D934B404
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Apr 2026 06:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775717446; cv=none; b=tfckeKp81irrxBAUBDtF/xbfaAoZuAja4/YUmKEnsBFAk1/IgmX0nmU726nRqMzMS5V7F8tPEWBiTJmAC9ZcOUtAHVDb7oxqefasB1At/rI+gHeXLGpk+PEQjW31Tzb8LCveFU8nfejK4IxEr8HQYrkQ4v9skBtFRZuc0YNNuNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775717446; c=relaxed/simple;
	bh=lv+TgQKgk9aD+IBCeefCaICIT9Do49KLpnUZFSTDQxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IgvFX32NtRrHlFMuIBecjKjBeDDFjqaub3FKYtBJoODuwbyC6YxvKcylDGNhetIx2mD9MRMJg5HizY4jIqQ7aqUxBoKeR6ccAd/uL8Pux/Z1Jpdmm9yx+8U6eicWx331dkQaA7mH/Xh+KCUz9eEVeLEoxsfuy9SflfNm0W0VBvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZEId1b3X; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZEId1b3X"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-483ad568d68so814685e9.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 08 Apr 2026 23:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775717443; x=1776322243; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0mdJnUKHya6g+DBgg7y++HRK5g7F/G9qfYeglO8ljDY=;
        b=ZEId1b3XgQd8dWn6JGwvZ2K2ph8gs5TDZzc479ma74HZEMlCDt9ksgHK4TmbEnUu4B
         bTmqeM8yGKxmZnqkrkWpfkqolwVfISlhfbOBhuGCx0k+kkGFMvQGYS2SPXQzYISl9G7p
         +uYbrDQuT9YROU7z8vB50eSsZDtyvik1HEdCM+9W5ObxPWKxMYtEhI2XwHbom9Hd4svP
         mtLCQgPWIg2lKZMNH1GKllPxK5DCgORB7EGDvWCX22I1xjzL7hsLXDc0d33imvmnBo//
         eaRrkOmC5d6JI3+4dDFKeml6yW9yX+pbohilLLDBzN+3oORjGeiLcMdGCLCvyJ1/0avz
         ypWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775717443; x=1776322243;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0mdJnUKHya6g+DBgg7y++HRK5g7F/G9qfYeglO8ljDY=;
        b=rasy+j1MtNrRbym9Elujzf6RHE6Y5dq2gt1cPy7eK/sCBaTg6iRbXYWca1ZhtprYBm
         tjgS0L9nuoHA/4A7psVGJKKb5gEm4WbgICpEMWQCq0jklqY42N3qj+Oy0gydmf9I+CfW
         wj2iYThMV+B61beD1KE8f2OQULZhT7uOqjMo5RjnjZCxCssCS5byPn2ieZmAa+2+Y+oO
         hhCGoAAN91TNiwSXccgis/CowVyj6AgXzJHEBkCi2cvOR8K6SpDaeMuKjSvV/0MLeDKj
         Nag2WMt21ZJXsUsYJ6lBmCbVlQHqXwPYLe8I2Hdn58COE/HvOusdLqUjHrBHWOP5Kq/w
         Ba8A==
X-Forwarded-Encrypted: i=1; AJvYcCXLv5+aU6Fla2HXCBEt/xgr91J6LFqQVZKcEg3GkAiwuEs+jxJIB3vWTraV3aMbvBR+CY9kDTHasqZIMQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5RaxfkDjS1w0YRLmdqmDYIH/LCZC/8Q9TPTr8g4ClkkhJKnwa
	/AL5484gz+SdHF677aSjKSowoF0xsrXveKmsMbmrByTIryLLllfCQ9vs3E8xDIznD9U=
X-Gm-Gg: AeBDieuF2q31H1CYbf2drVXoRw/S2n3O5oXpr0obRKhqFt5I+VtbZHrKVfY21Uy5Ib5
	GAomCFRdxpH55CS45IIKarsXuA9DzAw/AvJrGR9oVTkV6rHnPG+XCiAFMudfpW85gNgSPbQVB/p
	Dlq/xIJxODzc1gAewVRZ9Zy9EN282RSJvNOu9LNR5yw4WbwvgwbwDJjDZuUBiuimH7PxOsiEFOF
	XRipTcM+4zwUO78xJA9SZ0PP1ViStPLvnYwR5w+ieYGDUtQ15UJCzCik2wdVqAPvEf9ctoxAsnH
	SKBGS1rR4c8T8W8Tj9TjkKZnAPLOlNKLZTrHVoZ+zla5DRGqzan71TGMBRo3DxSbHfJO/gwh7iu
	hr1fh83/VEeyVYLizIPliiny7EyjOhwW+L7d6UJDdbNDn5r4+eBFsftYj7LlBGzWQL/Kf2yzbK6
	WyS8rP8GK91K35MIhEqyM1vw==
X-Received: by 2002:a05:600c:1f8f:b0:485:f1d6:2b1d with SMTP id 5b1f17b1804b1-488995d1535mr184252195e9.0.1775717443309;
        Wed, 08 Apr 2026 23:50:43 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9b3dc9csm22117793b3a.20.2026.04.08.23.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 23:50:42 -0700 (PDT)
Date: Thu, 9 Apr 2026 14:50:39 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: ZhengYuan Huang <gality369@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, 
	r33s3n6@gmail.com, zzzccc427@gmail.com
Subject: Re: [PATCH] ocfs2: validate bg_bits during freefrag scan
Message-ID: <gyzh7hjexqrnjn334l3ev6dwo6yfb6deaynvnqsetjvqc4flpf@z2plhmz7vigo>
References: <20260409060241.3344855-1-gality369@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409060241.3344855-1-gality369@gmail.com>

On Thu, Apr 09, 2026 at 02:02:41PM +0800, ZhengYuan Huang wrote:
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
> ocfs2_read_group_descriptor(), which enforces bg_bits <= bg_size * 8.
> The non-coherent path uses ocfs2_read_blocks_sync() instead and skips
> that validation, so an impossible bg_bits value can drive the bitmap
> walk past the end of the block.
> 
> [FIX]
> Check bg_bits against the actual bitmap capacity before scanning the
> group bitmap and fail the ioctl with -EIO if the descriptor is
> impossible. This keeps the coherent path unchanged and gives the
> non-coherent path the same bound needed to avoid walking beyond the
> buffer.
> 
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> ---
>  fs/ocfs2/ioctl.c | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
> index b6864602814c..a341a599e440 100644
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
> @@ -474,11 +474,27 @@ static int ocfs2_info_freefrag_scan_chain(struct ocfs2_super *osb,
>  		}
>  
>  		bg = (struct ocfs2_group_desc *)bh->b_data;
> +		max_bits = le16_to_cpu(bg->bg_bits);
> +		max_bitmap_bits = 8U * le16_to_cpu(bg->bg_size);

The bg->bg_size can also change.
It is better to use ocfs2_group_bitmap_size(osb->sb, 1, osb->s_feature_incompat)*8
to retrieve the max_bitmap_bits value.

> +
> +		/*
> +		 * Non-coherent scans read raw blocks and do not get the
> +		 * bg_bits <= bg_size * 8 validation from
> +		 * ocfs2_read_group_descriptor().
> +		 */
> +		if (max_bits > max_bitmap_bits) {
> +			mlog(ML_ERROR,
> +			     "Group desc #%llu has %u bits but bitmap holds %u\n",
> +			     (unsigned long long)blkno,
> +			     max_bits,
> +			     max_bitmap_bits);
> +			status = -EIO;
> +			goto bail;

Since this function is used to report chain states, it's better to continue
instead of breaking. In my view, reporting the error message and overwriting
max_bits with max_bitmap_bits is sufficient.

Thanks,
Heming
> +		}
>  
>  		if (!le16_to_cpu(bg->bg_free_bits_count))
>  			continue;
>  
> -		max_bits = le16_to_cpu(bg->bg_bits);
>  		offset = 0;
>  
>  		for (chunk = 0; chunk < chunks_in_group; chunk++) {
> -- 
> 2.43.0
> 
> 
