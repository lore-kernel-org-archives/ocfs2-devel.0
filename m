Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164FC2D7390
	for <ocfs2-devel@lists.linux.dev>; Mon, 27 Oct 2025 05:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761544505; cv=none; b=lKzt20NiflsYQFeoOfLloLKj8NGanVCxP6/IgbMhFug/9FLI4IrnTkoPQC2sZJ3GnbdHtMWOUHCRGEOe+xMXUscBbAIJ/xm9bulzsMa+2Hm9S0y0mB5OdxN2SOE3f1/zZgmV7V9Yuobvj4QoTg+6MJk8b2rWi0jlFS+ZhFtnVDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761544505; c=relaxed/simple;
	bh=PB8WecR2U1B+Hxs9rgzKpR8yvRUOHT8PkEQpI7oryDw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KkgEsN/AmwVRgSlk3G9NLODYMJk5YVU4GWPSRrTwqMsL/R+EMCWWPm3gB/WIKYGpfbs48Vzwl+nVyqicDmfReRIReByPDxls09nV2tJOozjtNc5Kf4d51AFLXIwtED4Y0kITx0UMmmIrUaDbO9FLz2mW80ka5wUYU5gbpwrbUtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dxHMgTJt; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dxHMgTJt"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-42702037a01so832499f8f.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 26 Oct 2025 22:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761544499; x=1762149299; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7yq4vwZctVyt51YfNqUdUcSX+iGUldMtiGd+UYdT9hA=;
        b=dxHMgTJtMGFXiyxxoY1mnnMv3l2sImAM2RertGUg5YyRCAeGB82hK/E9PwFCj9l3SJ
         8A5fxfSN/l9BAlqQvyUgknfiJz/W0/VkCdOO2zWaHMgP+5/E/GM1H2KmVnzxciP7owv6
         ZX37TbaGs+cMLdbTfO9NwXm2+rwen9Hw7TYJxIJe30rwWgNvTFU9e9Ili2CG3QLTNIri
         RJckRWBaPxftZvb7Al+74X3tOm+a12ZJOaUdNj2ruw4kC0myoBhReL6N6/z62vldv0o1
         Tg/JcqXKw/OKtYL+0PMAs/TiRXQHYE3L6O0hBrCH/9HBeY/UNFKRYZmU4yznDuPj8FnQ
         aXKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761544499; x=1762149299;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7yq4vwZctVyt51YfNqUdUcSX+iGUldMtiGd+UYdT9hA=;
        b=qDvKZOa1boRCUR8rpdXXgLSRHVe621tdHoovWW3avlhCUNUeX4UVfoPMB4f7bEP1+i
         FyzWzmIY7TOZwPaZ/WMcJNyWZDYehXMMEc53380dq6uZGf5bejTmGdl9uevcUOWD79Sj
         ZxdL2iztp0MCcWsuA4dFhgYQXDhwJmLQ/Mmtlkj0X3ddisXGSIPE/HiB2mri7b+v8C25
         veC0TJFc81jCu97KUR2VD636N+AGl2S01YTpeV6UbY61OL0SufZGAKP2xVZs7RxDHSXQ
         4l5pMW0ElltIcgLsQkOGL92LwYdZ14jXGiGQdlnP7Pwovm8Kp8YAnqOZdC0MXceH4sLu
         xXEA==
X-Forwarded-Encrypted: i=1; AJvYcCXPScLsK2gGvzYS8beFj1y9LJHadH7FjW9DCExzFPV0n+r80btS0Ful07rEGu647o+Tynsoje6ABXioWA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5rZJzj9WrQLNWRHWuyCsfw9PnuyCtCVcPwiAnpUVE44n4+0Nr
	rFjWf6vA0eQrDpqJpSAHGoIBklF1IAzuJMjAzoPiH2vQrkZK6Q5/Oyo+EGWt88NF2OY=
X-Gm-Gg: ASbGnctp0a4KnDBUefWkOJ1+Sr/RySbqGMg8foKSEcINdQfAwonXYzNgNkIQRS75GyF
	85IS8DlVsuvOFsU/nVpwM2D/Tam5Dej9j2wvfaanCoxO3EzAhY67amzfhY4QSgMfq56NS6byCgg
	KKvTNrHLKaUnBdsuaNZ2V49zrfNco8G/B1fkifpwoOYxpSy55dQ7RCzgS5p/ITNcYxDr3Pn08al
	PqxvRPMsJvh8jSV7fr61el+BlYlkz5lM1F0KCxde2fVJ2vg01P+sBPRhoV2ROfV+c4yDjeXIU8r
	X12234WZBghdEy+D+YhVwiUiuw3qsZ36mvjKCs4nrLx2Y8so8itO4ExCjsjsCkvoi/uQ/hynWRW
	QNTGuhbqb+4tSCBIf9bTj2VFKKJ8pM728NjXNsBr+y+FfZ8OOUUuwatV0cqXFsoiBDF94Cc3uG8
	afjQQlc8+6HA==
X-Google-Smtp-Source: AGHT+IHb6LEjAqeuzjsWCQ23HOGwypxJZ0QLL76KYcBnRCofwqhTksYZD99UW2uKcwX0zR8fOmjHuw==
X-Received: by 2002:a05:600c:1c06:b0:475:decc:2a0b with SMTP id 5b1f17b1804b1-475decc2de2mr32669325e9.3.1761544499349;
        Sun, 26 Oct 2025 22:54:59 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a414012bf4sm6871227b3a.1.2025.10.26.22.54.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Oct 2025 22:54:58 -0700 (PDT)
Date: Mon, 27 Oct 2025 13:54:56 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ocfs2: convert to host endian in
 ocfs2_validate_inode_block
Message-ID: <honfnctqux4wuiv4dzjzwklavw2uxqyonyyvo3wgb7bzhrseik@bn6ehubxfiuw>
References: <20251025123218.3997866-1-joseph.qi@linux.alibaba.com>
 <20251025123218.3997866-2-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251025123218.3997866-2-joseph.qi@linux.alibaba.com>

On Sat, Oct 25, 2025 at 08:32:18PM +0800, Joseph Qi wrote:
> Convert to host endian when checking OCFS2_VALID_FL to keep consistent
> with other checks.
> 
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 0a0a96054bfe..dc4044a565b5 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1481,7 +1481,7 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		goto bail;
>  	}
>  
> -	if (!(di->i_flags & cpu_to_le32(OCFS2_VALID_FL))) {
> +	if (!(le32_to_cpu(di->i_flags) & OCFS2_VALID_FL)) {
>  		rc = ocfs2_error(sb,
>  				 "Invalid dinode #%llu: OCFS2_VALID_FL not set\n",
>  				 (unsigned long long)bh->b_blocknr);
> -- 
> 2.39.3
> 
