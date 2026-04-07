Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C9D3A5E83
	for <ocfs2-devel@lists.linux.dev>; Tue,  7 Apr 2026 14:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775571996; cv=none; b=FTOalMzbReBJoGAga0cFwbbbb04YvjFzPfq3xjfAu1lm94Ug3YWO1Va15P9PeewznawqulnQSkLzXO/TtQQCmnDwf5FC9LotPBheulebz9Em1hH4oMA59+Z6d0rHLorO18SvHNliH3ghFf59CA1r2vbyOStt4+Hr1qQwEwuMzFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775571996; c=relaxed/simple;
	bh=4c8no9fDprUrNiYDoETNf99A8/sc5pzgx3IW6csPyI4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m/sYR1KHgBNBG6fmIVm1rFG88VSBSmH+nhHAiGGX4V8+lWlNDP95IbPAjCn2uys/+H/YmqBQ6+nwpmBSkaz0RuthgYANMG4zmh/63B0TCcCo9dn9UhZzYFleFiw8o2SKTvF/CmEGGp9UAwGnrrtOyoW6R/cMyqKFet4Yl+GrXL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZEXpNNEh; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZEXpNNEh"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-483708b697cso7714185e9.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 07 Apr 2026 07:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775571993; x=1776176793; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xhmea/zy/n9VFzU+MdOt1xdYztZFqc98q/O032fVdm8=;
        b=ZEXpNNEhIgR+sQrkkSwRqmZzOZR4cndS/n8scmLcAPgm74isM08YFzwTfMTi+Bc7Xs
         dhGJvi3raNI5TDh+qVYMAyYSE1HRUOHaAOmOIYYHwkOhrWpm/bsvvbZH0i5y9yMDQ1Rq
         Rzs6m8iA1z1MdtUW0yONE9bT+wL6yPtyGOXpTFTiwFa2odPrL/Kuku6d5pu3lO7iptBT
         jj9HXOEdkQSejWYcJEN9MU7sLmd8x8/STpXqb+Gyuy2MA/aDs3M5R3b9fgZjmjJ/4u72
         OKPzgYgt9D7UTe1qRR2VZEBSurUm45MYGwi+WHmhxItXl9UZW0RAxmBaH3xKcmFy/7Ha
         a0Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775571993; x=1776176793;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xhmea/zy/n9VFzU+MdOt1xdYztZFqc98q/O032fVdm8=;
        b=QS5nvmp6SGQsB9TzldkuSu3NmDn0q5bkczz4/uZQWBKBX96x0lXiSia2SRA3z5B1rV
         9vA0ceAPKa/GMg9xLt8DZlIuct1cELYiWSoctctYFj1km463cqD5SrhUuJ3bA1qI+jd0
         /SbBmltTlbratRZDmEG9Pk7wyXDRBUkOTkNIpq3s12Hlys68vzemYZh7lxlPfJZfwSZ3
         MCp8HWEDsrLxYvYI/0XJ/Hwb+vo0HoT5kZ5C2hHH/dMxXLPVWK+s5GD/4dw7X5k7Nr2a
         xG12W3A/MNYV6Tkiqg77Qi3NGwjR+GoILgAX8BilVbTNY25SRrFbsf5RCi0VB2djdB6o
         U5tg==
X-Forwarded-Encrypted: i=1; AJvYcCXrqHz5Xq+bYEwOcL1Pe6RfB/xzrVNcWX5CVjSuw+3PPcd6/T1MucnbxbmIFwlVhaFPBsFpkj1rcUjCaw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwKYLVWRNkZLAeZgPdmL9nLePK+k25efmTECv1m/JuXa8AaG0+x
	CQoGoloSYK25MYTf0JFiVkIEGVJcJdlC0MM2/tUFW6D/DcTF7UEiBu1EcduJW0xRN1hFdYYLhPk
	yL67By5U=
X-Gm-Gg: AeBDietbKXuBBgAggl/Q4C8rZyvCYQcRjPgzvxxCr49Q4g8ZETalil7HLid0X9Wvh6g
	HHvblA43AhJgSE2CXAkcEgdBgdOWGAPYuY/Unein9fOrxa6QEDpKzXSO2bHsSruuiKZPVRjds+7
	gXwYBfNC34wl7bBOMBDj2PnPuSUUSVQq081/Q11WwqdvQ8svdcqtl3Tw0cd0Sc6qA8PDahfiUjF
	zDvf3S9ZBskbST7VCRQLmiUnVeenuJVEwx+rb+MZReALaow3DtrqbGErz76BZcFxXWd8VvxjuPQ
	jw/l3GBgUgsQ/jDHsXlkk1lIvF97nB5x24LsaOeKvW1NsoE8PDbLZbDsLpcwZeRVrPyw5LBaaRV
	NtbmdN0DE+WUk4IrTdqhPwZQF40GPpm1G5MHf9SnpvL0GbpqX6+egyAVt+I8uckGDPfDKMOaSoo
	PPMQD1Ecj1h6lgbvdmPOlr4w==
X-Received: by 2002:a05:600c:4590:b0:488:af08:73c5 with SMTP id 5b1f17b1804b1-488af08754amr62847485e9.4.1775571992861;
        Tue, 07 Apr 2026 07:26:32 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2af067a59sm26382185ad.10.2026.04.07.07.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 07:26:31 -0700 (PDT)
Date: Tue, 7 Apr 2026 22:26:29 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ocfs2: fix out-of-bounds write in ocfs2_write_end_inline
Message-ID: <wetkjod2dfsl2ffszxpse5pf7lmzmz3kkq74ygn2kbu7nq2rdh@lpb3dvfmeetv>
References: <20260403063830.3662739-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260403063830.3662739-1-joseph.qi@linux.alibaba.com>

On Fri, Apr 03, 2026 at 02:38:30PM +0800, Joseph Qi wrote:
> KASAN reports a use-after-free write of 4086 bytes in
> ocfs2_write_end_inline, called from ocfs2_write_end_nolock during a
> copy_file_range splice fallback on a corrupted ocfs2 filesystem mounted
> on a loop device. The actual bug is an out-of-bounds write past the
> inode block buffer, not a true use-after-free. The write overflows into
> an adjacent freed page, which KASAN reports as UAF.
> 
> The root cause is that ocfs2_try_to_write_inline_data trusts the
> on-disk id_count field to determine whether a write fits in inline
> data. On a corrupted filesystem, id_count can exceed the physical
> maximum inline data capacity, causing writes to overflow the inode
> block buffer.
> 
> Call trace (crash path):
> 
>    vfs_copy_file_range (fs/read_write.c:1634)
>      do_splice_direct
>        splice_direct_to_actor
>          iter_file_splice_write
>            ocfs2_file_write_iter
>              generic_perform_write
>                ocfs2_write_end
>                  ocfs2_write_end_nolock (fs/ocfs2/aops.c:1949)
>                    ocfs2_write_end_inline (fs/ocfs2/aops.c:1915)
>                      memcpy_from_folio     <-- KASAN: write OOB
> 
> So add id_count upper bound check in ocfs2_validate_inode_block() to
> alongside the existing i_size check to fix it.
> 
> Reported-by: syzbot+62c1793956716ea8b28a@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=62c1793956716ea8b28a
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Looks good to me.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/inode.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 03a51662ea8e..a2ccd8011706 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1505,6 +1505,16 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  			goto bail;
>  		}
>  
> +		if (le16_to_cpu(data->id_count) >
> +		    ocfs2_max_inline_data_with_xattr(sb, di)) {
> +			rc = ocfs2_error(sb,
> +					 "Invalid dinode #%llu: inline data id_count %u exceeds max %d\n",
> +					 (unsigned long long)bh->b_blocknr,
> +					 le16_to_cpu(data->id_count),
> +					 ocfs2_max_inline_data_with_xattr(sb, di));
> +			goto bail;
> +		}
> +
>  		if (le64_to_cpu(di->i_size) > le16_to_cpu(data->id_count)) {
>  			rc = ocfs2_error(sb,
>  					 "Invalid dinode #%llu: inline data i_size %llu exceeds id_count %u\n",
> -- 
> 2.39.3
> 
