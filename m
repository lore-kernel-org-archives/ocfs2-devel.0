Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C5E364045
	for <ocfs2-devel@lists.linux.dev>; Wed, 19 Nov 2025 14:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763562453; cv=none; b=qMZePUy7c08GNSBGYOsW5OChru1u16iy6CStlHbqibSkpgyyJkDV9AW2ZWQ9mpuFVgw5s3nsHLLPZhKuIECKxhYA1E+gxHOFP8OOrPZDwpe92EJ9TMBH868LfwWOQ/IAIAdnG0bZkdMMvP3uLhXHDEYLyqU4IgPfdQdhyydJzJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763562453; c=relaxed/simple;
	bh=ZkqwoacP1hJ7Ru6b7lhukC9gg9iCcAZjZ9uK9e5IZoc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k++esUCFrNvaPG/9DCXVCxoWjL2DMYcv6dkmzYaxjtBU10JAw00XqhVCVEgpAlCN33a7YPTRd137BZn7x+7RrTMoYq/mdnWLl+VGnuIlulQq5FShz8NezzE4VQ1oJ8gQf4WqX0TqnDhHz46QlabX2M1Xw0AWxSxvu26q7kyIa7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Tv9OyMAI; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Tv9OyMAI"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-477aa91e75dso1865965e9.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 19 Nov 2025 06:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763562449; x=1764167249; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tHpY6wH8DwcQSkk9TsIZjPrAN8N7O6UnJAiO5J2IYiU=;
        b=Tv9OyMAIZQtZt/4+XIWMZCdb0DHJJOHEmzcVE0LBZlhasHYyusdi7YmA8KzH/dVDNZ
         uZOBavY7UQ3ZbIcodVkeGRZBdQixxnFNLZuWIbzx3YHZfHShrGAX19CxQhEzRMyDkZLM
         B7IgJIn4e4cGbBdgIH1hoJ1HnmYMgBMYIALAZ8xG7+gvUN/K6Lp0X+ng+cDvqeunSGZg
         5jJMvGnIoW1Ac0zgBpMp6XM4Wrlhu4RSohvKRXpPRwhIr0VTNtwbL0IFrMSqq1GDojAd
         /l1F2BAmnFU8yK+oxe4Z7IEO3VtBj9uE0Uasgy22bNO1ZZnvZU8Xaio9FxQNOQhW70Ha
         4V9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763562449; x=1764167249;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tHpY6wH8DwcQSkk9TsIZjPrAN8N7O6UnJAiO5J2IYiU=;
        b=dH7knkU+LFhD2O9Z9xzYl5eyo4wZYDSEInZe+d84bm4T+jd3rFrKtEaR/x6LEZ/FGd
         SQ2CZvQ3x985dGv4RPYRNEU+rczo7s6Hqhz3H6kvhpxb9liY+i73eWMIjbdrcgKc5gUa
         5CGyNZD3f0+oC5dKzRsVgWsKJaPQmMKrExyIICYcF0cuErodPxT3sSMRcVHO0ui+LsJe
         349q90xPpPnjsfQvusMscWxjxDWdYc11pJlcH84QX0FXm/kChC/Hw48jILqKR+OfQzIT
         5+x1Ty64N7brfZIjUOtuQ+FYTTSuyJ+HGeifEWSCqq4ai3DgyPjinw4VYIH8bUeXuRl5
         e58w==
X-Forwarded-Encrypted: i=1; AJvYcCUEpITTrAOadITtkuS+lAkTltL5fFj1bXC9W7kbYA92DA9L88ITcBYsF32lU5cwrOQq3ppPyU4BGcZ7Fg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzEOUeUQ2PfD07KrD0Ms2HeiNi1XWHJ+i9TEw3LzsCIKmEUSSYe
	Z/KXPHBbfZWXAtkDNns0rQ768i0shW6T7LHLc8aol9YHLoqQbrV8J2bTt/nRTAlJ0/Y=
X-Gm-Gg: ASbGncsxHhyxGYqj5NDR9/5rmnWU+w4HMFrcjVxuH+grH9pqMlG+VBOhXaoJPYuV+5N
	390PmHivGP6PgZfhxutR5A9EwxDlgU10ld0ynKwk/kcg8UFSbIXY77o44jzhLPi8TPzUSRJP9DX
	450aLdb8o/tBTYiS2XtltmKaULD/Lh8aMOkrPVk0It2PLhnWS4+2m5TBIEFPgMJqDQFFo6GpefG
	zHAK5i/jsqNJZo5jqaj9WEg6xQIv4jXp4BXBvqW3tv9zZSAEF/BQDaK/SAtdNsVqbj2xs2hfUyd
	U/ULdRqAxdNoTE9lmpUJSqdYN0nMxk07eMo2YIQ9RsknlY+Ql3t+oxLxuZOgwkC/7AEzxMMzk7Q
	re6TFeLEcznaumnWhJ2Ti6Lkn/rzADPbQzgrYDMRUQzJ136Q7R4est/5NwA2AiTRJt7DhMJZoLD
	TC3VHk5JjdKg==
X-Google-Smtp-Source: AGHT+IEbaZEjkiAjmJ7IQjXmG/oDyzxHUKCCkyxQIG6g5LuWqlEgDxkF7F3xx6Ax4kvH0brnme09Hg==
X-Received: by 2002:a05:600c:5248:b0:471:1387:377e with SMTP id 5b1f17b1804b1-477a9c34ee4mr36157865e9.6.1763562449050;
        Wed, 19 Nov 2025 06:27:29 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2346dasm207715635ad.7.2025.11.19.06.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 06:27:28 -0800 (PST)
Date: Wed, 19 Nov 2025 22:27:25 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Ahmet Eray Karadag <eraykrdg1@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, david.hunter.linux@gmail.com, 
	skhan@linuxfoundation.org, syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com, 
	Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Subject: Re: [PATCH v2] ocfs2: Invalidate inode if i_mode is zero after block
 read
Message-ID: <6yyc7qcymassc3fzwut5a3egfocmfrxy6kw4zdrkk3f4t45mxr@2bzksx7pj6m5>
References: <20251108120133.37443-3-eraykrdg1@gmail.com>
 <20251117223506.299511-2-eraykrdg1@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251117223506.299511-2-eraykrdg1@gmail.com>

On Tue, Nov 18, 2025 at 01:35:07AM +0300, Ahmet Eray Karadag wrote:
> A panic occurs in ocfs2_unlink due to WARN_ON(inode->i_nlink == 0) when
> handling a corrupted inode with i_mode=0 and i_nlink=0 in memory.
> 
> This "zombie" inode is created because ocfs2_read_locked_inode proceeds
> even after ocfs2_validate_inode_block successfully validates a block
> that structurally looks okay (passes checksum, signature etc.) but
> contains semantically invalid data (specifically i_mode=0). The current
> validation function doesn't check for i_mode being zero.
> 
> This results in an in-memory inode with i_mode=0 being added to the VFS
> cache, which later triggers the panic during unlink.
> 
> Prevent this by adding an explicit check for (i_mode == 0, i_nlink == 0, non-orphan)
> within ocfs2_validate_inode_block. If the check is true, return -EFSCORRUPTED to signal
> corruption. This causes the caller (ocfs2_read_locked_inode) to invoke
> make_bad_inode(), correctly preventing the zombie inode from entering
> the cache.
> 
> Reported-by: syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com
> Fixes: https://syzkaller.appspot.com/bug?extid=55c40ae8a0e5f3659f2b
> Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
> Previous link: https://lore.kernel.org/all/20251022222752.46758-2-eraykrdg1@gmail.com/T/
> ---
> v2:
>  - Only checking either i_links_count == 0 or i_mode == 0
>  - Not performing le16_to_cpu() anymore
>  - Tested with ocfs2-test
> ---
>  fs/ocfs2/inode.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 14bf440ea4df..6641caa45292 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1456,6 +1456,13 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		goto bail;
>  	}
>  
> +	if (!di->i_links_count || !di->i_mode) {

question:
Why does this code not check both di->i_link_count and di->i_links_count_hi here?

- Heming
> +		mlog(ML_ERROR, "Invalid dinode #%llu: "
> +			"Corrupt state (nlink=0 or mode=0,) detected!\n",
> +		        (unsigned long long)bh->b_blocknr);
> +		rc = -EFSCORRUPTED;
> +		goto bail;
> +	}
>  	/*
>  	 * Errors after here are fatal.
>  	 */
> -- 
> 2.43.0
> 
> 
