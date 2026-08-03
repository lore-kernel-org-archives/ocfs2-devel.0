Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71609352C54
	for <ocfs2-devel@lists.linux.dev>; Mon,  3 Aug 2026 06:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785739060; cv=none; b=gcU6wScP6AAY13cp85V+nl394PsztPTMs3lCZyOmQuHW7R/opbqYEShYGZWqU3HlZ3qD/nn/OaROWSec0P62s+jw/vjm/AS6Cw/slVABaQZ7l7DbhPFiIPZeOqWPLKNe9yAAUjH9wHxHXFK36skd9YDdSBaM1i2SDIbSYGDtnBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785739060; c=relaxed/simple;
	bh=jw3ba/wvfD8Ah6zyMXHFHCwWGezpZZhoFih/Fe1tpcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gYUM2jpxvRN8R6kaSr3FnZzGc4MFVIwrfPlxDjTBt2uMdgfLloYW3W+7WJuCJvNydOXk4Hfw/C8xvT2RGMjNFBhwHFkja0EERh8BjlzBrlckmchUizmY/tj5/pqWTRE1IyURc9Si0Qzkq0RBAv/TiQRnygRwhddUtzB0dOJleaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=K91wmUwf; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="K91wmUwf"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-69a33fb0031so563724a12.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 02 Aug 2026 23:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785739057; x=1786343857; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HjtHRYSsspzas55sgzq+ZHE05NUJv5wxQswJPDQ5sBY=;
        b=K91wmUwfQSsz0buBE2pH81ROkw2bouiRUKF+3/hmeH+j/pNR8vDIst3j53cZQWiaFl
         fV7LdYSjkDfM+VXWl1Ij191AISL0nWe6lIH/bkpgJ33N+N9hwNyLmZRGPneypuWzatGd
         jDoJHHgR8nkcmEaE7RNE6TmyOC2rnzFsLkUy6mSYDXYgTQrBDIcdRbg5N9GmL33qnu2C
         DmfD4YMzHDP6dy1yvw3UG/IsspKsrDPo8fiOibwIB1FlOlRJFjWb6oUEtPAaUOwGUBUR
         3nS+FXMoCAxADxISPNz0xQY3gbEx2Lm1IXbAubMvGY6A0duNRh9qhpSC5icj5Pn5J29D
         UlNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785739057; x=1786343857;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HjtHRYSsspzas55sgzq+ZHE05NUJv5wxQswJPDQ5sBY=;
        b=DofgeD8kr4FtLIM198UaeV25Nnu4xJbGof2nU7re8aOC5BmUh2iYgm8l+b4hdJPX/S
         1I5aqpkbPQpGKrEyk+PIuBbcRO2ikr50KJK6SfGT/2bjU4TaL881vGzC8BCyIa76Rl4k
         GmIlF4AWii9TMB8Cl795ypvllEjE6WqCloTRil0VLu6u/w1f1eCaJvD5z98gA6qugDKR
         D1dg8ue8qP60sSY0fpXfV3dvttwdMLDFcEvlXsgDNhkCBv4ebhD21IDKz7vs4UPYEdQy
         2gOwJbwcdvan0L44mCg9xq44g9FlFECV4EFxkhvKq1dTueGMPZRxRuG/cLVQCiF+W/F3
         MbLA==
X-Forwarded-Encrypted: i=1; AHgh+RrG9VEOCyN4NAPa3tBrcZEK5c0tpHwPPZ0oBgAGzpZ9J+b66rswhkPHXB3AYYVn4GpBc2WHnWVLluLcjg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy5d3iu/EiyIXeTL2fa/3pSg7F4wc9d9TThF9SVmmn9DjRfSf7u
	k8DLP22w81OlRkGfijrr68r0+Ycb118M3iGeGvS9vFRj+QaFcqmZqMMhmA5v8nI9tcg=
X-Gm-Gg: AR+sD133KPw+Tg6i4RfgnqBl9y/kuMnWgUrMuNQkM2Q0rLsZwULrdlXzXfmAvy1q+tA
	PhDLX7e9Ojj9BgixZP1M5e55OuA2PWA+C2tfds3HBte82HSinATM+Mj80/dFyPWBRSzafe+Cwyc
	hYoKHH5DBF4Gs9eaQ/DXSfnsItwEQSuo7lO66hyTlvDB53JOBxxB8TRuH9gCTgjuOG6lrIP3aaO
	r+iGp1JLNP+OdpAz3tyueZYBVtvIFV+pHZw6sizml+X77/990ZZWZAOODszFlYVDQJiL2RJV3nb
	yGDinSQ7Y/G3H0l5pAnGBu1rU6qvfkgWLKyar/t1Pdf0nakzw1thWaRXQm5xDUcN3/VMtUUpKTA
	GKhq80PEzu3/Dg6oyDEnKVcPuAGdpUFc8L+L6rU9lVfWT7WTOtCRGPfMdqAdprTgqDwyKHffoH8
	Dii3EjoMObW36mqKNwltgnLd/ZYFfdveHpIFFu6JoJXgKlpRLjAU2tZ+O/QLE=
X-Received: by 2002:a05:6402:5c1:b0:6a0:d411:930d with SMTP id 4fb4d7f45d1cf-6a0d41194b8mr1290830a12.2.1785739056731;
        Sun, 02 Aug 2026 23:37:36 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84edbe593basm3155356b3a.21.2026.08.02.23.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 23:37:35 -0700 (PDT)
Date: Mon, 3 Aug 2026 14:37:31 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: ZhengYuan Huang <gality369@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	tao.ma@oracle.com, ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com, tom442288@tuta.io
Subject: Re: [PATCH] ocfs2: validate global bitmap cl_bpc before resize
Message-ID: <anA2DiyxdwUeJn0V@p15>
References: <20260803031116.3994362-1-gality369@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803031116.3994362-1-gality369@gmail.com>

On Mon, Aug 03, 2026 at 11:11:16AM +0800, ZhengYuan Huang wrote:
> [BUG]
> A corrupted global bitmap inode can make online group extension scan past
> the end of a group descriptor bitmap:
> 
> BUG: KASAN: use-after-free in _find_next_bit+0xef/0x120 lib/find_bit.c:157
> Read of size 8 at addr ffff888021b52000 by task syz.0.34/409
> Call Trace:
>  <TASK>
>  ...
>  _find_next_bit+0xef/0x120 lib/find_bit.c:157
>  find_next_bit include/linux/find.h:73 [inline]
>  find_next_bit_le include/linux/find.h:518 [inline]
>  ocfs2_find_max_contig_free_bits+0x53/0xb0 fs/ocfs2/suballoc.c:1292
>  ocfs2_update_last_group_and_inode fs/ocfs2/resize.c:127 [inline]
>  ocfs2_group_extend+0x83e/0x1ae0 fs/ocfs2/resize.c:350
>  ocfs2_ioctl+0x175/0x6e0 fs/ocfs2/ioctl.c:869
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl fs/ioctl.c:583 [inline]
>  __x64_sys_ioctl+0x197/0x1e0 fs/ioctl.c:583
>  ...
> 
> [CAUSE]
> ocfs2_group_extend() trusts the global bitmap dinode's cl_bpc value.
> If its high byte corrupted from zero to 0xc9 makes cl_bpc 51457.
> Extending by seven clusters narrows their product to a u16 value of
> 32519 and raises a 2048-bit group to 34567 bits, beyond its 32256-bit
> bitmap. The subsequent maximum-free-run scan then reads into the next
> page.
> 
> [FIX]
> Reject a global bitmap whose cl_bpc is not one before using it in any
> resize arithmetic. The global allocator has exactly one bitmap bit per
> cluster, so this validates the invariant at the cold online-resize
> boundary and reports metadata corruption instead of enlarging bg_bits
> past the descriptor.
> 
> Fixes: d659072f7368 ("[PATCH 1/2] ocfs2: Add group extend for online resize")
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> ---
>  fs/ocfs2/resize.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
> index 6375d5035972..556aaa319621 100644
> --- a/fs/ocfs2/resize.c
> +++ b/fs/ocfs2/resize.c
> @@ -311,6 +311,14 @@ int ocfs2_group_extend(struct inode * inode, int new_clusters)
>  		goto out_unlock;
>  	}
>  
> +	cl_bpc = le16_to_cpu(fe->id2.i_chain.cl_bpc);
> +	if (cl_bpc != 1) {

cl_bpc is not a fixed value. Refer from mkfs.ocfs2(8), only both block size
and cluster size are 4K, cl_bpc is 1. Otherwise, cl_bpc is 2, 4, .... 

Btw, is it any possible to put the check in ocfs2_validate_inode_block()?

Thanks,
Heming
> +		ret = ocfs2_error(main_bm_inode->i_sb,
> +				  "Invalid global bitmap bits per cluster %u\n",
> +				  cl_bpc);
> +		goto out_unlock;
> +	}
> +
>  	if (le16_to_cpu(fe->id2.i_chain.cl_cpg) !=
>  		ocfs2_group_bitmap_size(osb->sb, 0,
>  					osb->s_feature_incompat) * 8) {
> @@ -332,7 +340,6 @@ int ocfs2_group_extend(struct inode * inode, int new_clusters)
>  	}
>  	group = (struct ocfs2_group_desc *)group_bh->b_data;
>  
> -	cl_bpc = le16_to_cpu(fe->id2.i_chain.cl_bpc);
>  	if (le16_to_cpu(group->bg_bits) / cl_bpc + new_clusters >
>  		le16_to_cpu(fe->id2.i_chain.cl_cpg)) {
>  		ret = -EINVAL;
> -- 
> 2.43.0
> 
> 
