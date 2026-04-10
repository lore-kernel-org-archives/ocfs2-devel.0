Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29A22BE05E
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Apr 2026 02:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775787963; cv=none; b=cgxEpc5hoPEY+ey22+BBPGaqtxEPyEPGQ3e/mCZNfE2AfWZi7jkuZc5be/VgRYqv3oCCa75u//EAcyvJTuBTqRHIZnUL3y9VFSjJTk0oEROYMkL9W351aqHxW5H0VHd1malb3raM6Ko6D8AVYr5jgy7zsVzGa0/gBdCsPZegByA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775787963; c=relaxed/simple;
	bh=y+tYya1WyEOjhzRjJg25taF7fl4cF/UdHeWpfI1xkyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F5qwPEvtggNohxghfGlQfXCh3VyyXm0H3LahitnF2XWKx0Xa61ixX5nIXtAqDhfCiYcl9zSBbVmBWh0ybXiVUi4rGAC65F55EEFAWNS4pdcv3+8aMG5ZWrcZD5ivT2dg1nb8tWE7RLVj8b5yvmm48WAnz7hzYDLHRlZdays0Rj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QKqV31Fl; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QKqV31Fl"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4836fc075d2so2254335e9.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 09 Apr 2026 19:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775787959; x=1776392759; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=g2upHh+CAfQ0tuDm0rVFEqpcgLeWwPiSma3r2hEAaY8=;
        b=QKqV31Fl7Q3n33V29BG47/0ZspsiXY3gzjhFaa+Ue5/6/yFoC5IUdn3BF0eNvOU/cQ
         zC6fqYAG9HfmYBqMK0g3mhzYU4OyVvLtePdmTQBM6jruyjHDi6f2pCTx3/ObQZvNOUIP
         44ld4DT1JoncUUhTTwvse10cUnftOKryQgKw6z1S75ca6m9kupBJF2+wllVxv4L1hWf+
         mILiilgrjBEx7binoGXZER12UD0BzwQWvktVpgb42ZYepViNbHODLrkukjJfMpcpXpvX
         /fdrARaCpK883cs3N1JRLniiza0b6m8eSBGa7ucYeVcqyfcAXbGfrYnCMVl81crBHU81
         NJtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775787959; x=1776392759;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g2upHh+CAfQ0tuDm0rVFEqpcgLeWwPiSma3r2hEAaY8=;
        b=goT2mmOxVjBTqbVRcKXb9NH/eejRUNwAZV5G3L4LyxX/tWcPfQEBD6Kq7AedL8qQ76
         Jv4BmrGZQ2yEUONdOun+tCFh8B2qs3jaU8WMYgjKU7SaRgx3l9eW0n8WEYCcJZXieC+E
         ojkxMyY/b/9ufByAtqFCU4UyBzBNRtyA5B1+raS3+DFzFB5wPZ743M91thohPD1K2Jx/
         hqcXT3s83xfyhSiZrtHcLJHPRaGeJ2OxEByQJ0yyGNNl2GSQfc6UN65orFXLx45nuCTY
         rLgeLprwgbQqGPOwAnHGJBLo140hoCQcwk5w3joHk2qahgzJ3ZnBqmQZKRLEHtzSH5By
         7Wxw==
X-Forwarded-Encrypted: i=1; AJvYcCUBcNsdNR9yUcVyzRAHpJzdIH18E2VMJpm+4wPi/O+8Fhe2TvI4FkOeGGyMjOgCkrp24SGcfgWoL31T6g==@lists.linux.dev
X-Gm-Message-State: AOJu0YwwbPGUUl07lRIdtlo0E7/qazm4V1xdLMyKp2fClUgnrOCoFzWh
	clbtlxlMklxuKd1jo2k+PjVu0DID9jktq1UtlKjlL6OLs3fhNnyYIWHlji2bcQofs5s=
X-Gm-Gg: AeBDietPfkU3fzC0FsocmoK0OOhDmQbgb1oy5DXH8Me995R5LOy1q73KzQyB4yagn0P
	C1FETbStQZGPlCOGMKb45pFJYyyaTVWnb7oai36+16tDWvBi3UqbD7+KCbNrQbqritAc958c1bP
	0TpWKxtKbBP/h0WfR14y1HOkqF6ypB+0Yg1c/Z84CEh4k4wsft/FxyQl0ur4ED9wRzN4z/FE2Au
	gAOJXN0JOQALR+CcaMJq1589blRLy7jE1Wt4fOD5kdIDdIeWaIguXNO0ySjBbGIqdoLZivkDOen
	Zc/Ra6ngc8LLSb0NaGYpFtS2zhxOD7PQ4YtFqtX/zIPERvAQSr9OVQS0BV+oG+J7GfNoZF+F6fj
	PzVwnAm69W5A3RtJtIV47djMzrGzQOpfXd85ZSwiCfqlgxv91Yd6XO4Z6o5HEdw/hd2IPV7G+bg
	7fdQ1QpTAtmsPXVqe9m3MfBylcuPSOIshU
X-Received: by 2002:a05:600c:46c8:b0:488:9e7e:e1e3 with SMTP id 5b1f17b1804b1-488d67f5115mr7610455e9.2.1775787959244;
        Thu, 09 Apr 2026 19:25:59 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c79219f55c4sm746160a12.22.2026.04.09.19.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 19:25:58 -0700 (PDT)
Date: Fri, 10 Apr 2026 10:25:55 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: ZhengYuan Huang <gality369@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, 
	r33s3n6@gmail.com, zzzccc427@gmail.com
Subject: Re: [PATCH v2] ocfs2: validate bg_bits during freefrag scan
Message-ID: <2erouzhgetyqstucsh7tfaucgxfm2wvarvja2g4gulwuqrwsmg@ch3y6xawctzp>
References: <20260409070624.3357378-1-gality369@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409070624.3357378-1-gality369@gmail.com>

On Thu, Apr 09, 2026 at 03:06:24PM +0800, ZhengYuan Huang wrote:
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
> +			max_bits = max_bitmap_bits;
> +		}
>  
>  		if (!le16_to_cpu(bg->bg_free_bits_count))
>  			continue;
>  
> -		max_bits = le16_to_cpu(bg->bg_bits);

Restore this line and move the code here.
This will save cpu cycles when bg->bg_free_bits_count is zero, which is a
frequent occurrence.

- Heming
>  		offset = 0;
>  
>  		for (chunk = 0; chunk < chunks_in_group; chunk++) {
> -- 
> 2.43.0
> 
> 
