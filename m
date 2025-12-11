Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCA54317D
	for <ocfs2-devel@lists.linux.dev>; Thu, 11 Dec 2025 15:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765467212; cv=none; b=O/fCnQ8py4pxJMW4gwMvTMFx98ar1jtD5JeYIHo8ipYebp2VCelgCqlrdJPUHjj0WYnGWhJuZ9/fFPpBfe68+JHzshnmbXrfqQRuE3oUwRg+TAtAiFLtjJOxt0DE5rsSv14U8oCKPE6poYh5C1jQBNAgbEVxdhJmZYnvtPrxHmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765467212; c=relaxed/simple;
	bh=J2nOeexQJsU1rE0wh21lDr2AN0ESBLH+KCaJHZGeUi8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MiVOTANGL1CGP6L/UtFrz8sCD5qprOeERiUGkpo1VXhOcVPaVWqCEEwq0KalnF7/RPvJSB2iqiFKx6XvGC13G/1jntjf/d95EPHX7i89kdoMoVyay4ly9aBjEvio8FaxvnxGK5bW5P8yijdexg59SomHl1duswyt35T2XLoith0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Wm1k7Ubt; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Wm1k7Ubt"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-429c844066fso21117f8f.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 11 Dec 2025 07:33:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765467208; x=1766072008; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TYz/U3AWaTq5Ito9haEgBklwzsyseH3j6RVRRhN2ACQ=;
        b=Wm1k7UbtjNPfWHX94xwGguaW1Yg7EGzm+dOXagVSkKjNvqShobtNLvVjv7B8gTIZGc
         UZ80BYupniQP9uImQQeyCAimlKEhbFja1F+SklgcbWqB6XMO0InPvsZKQ+0YjMS5vK2l
         IhCIaxGbDp9WHBc6inYN4Lkk6pvBUhlnFgFEvMLNzpBM4EZuWpHis6RwpXSC8YKrs9Zm
         9/fIdRonpfQ3ThxH1LQrbAod2s9gnCIRULMGI/1AdzJySiIlpLIcXYTjjIawRInsVoz4
         amhguJx5NC4DIJ6AyQRBE/byaCPZBonyl5G30TMk8ywG6rQs9zLObwvwQdaf1EgLVrVf
         N84g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765467208; x=1766072008;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TYz/U3AWaTq5Ito9haEgBklwzsyseH3j6RVRRhN2ACQ=;
        b=qtcSLKb2JwDA90ogfum7UJNov6QZIIt+slFLpivQY+BkNaQaHmUDp4kOul9AnS+UEe
         nIoZuvN+wEM7PU5UdHHyKFagXpuqxIW/0XAUm/XB68DxQemx/FmNNNlXELNdoWPjP5Wk
         DzCv9q94jLFGi55rs4b9oPRmTQQFZowmC8R0We9YjtCQcqVcZBgXn6sMmd6FXm8pkqzM
         oXKm15YdI2+yv6+fIHSNzbaS2L6xjLRmmJZrz7eYW3Guko3XatKDJNZeLNMgk12O8xxf
         8uwY6IE80OgC+cxCppcqvMgZoPTyBkzJ6I50cpwW/s/UlBfN6TR7tHDTi0U7ZENPqdSR
         wNmA==
X-Forwarded-Encrypted: i=1; AJvYcCVo9cIyvQr+PTd4ONO14fIbshAot1dJqQMR4osaTZ66G/QbbVPkCW6Fonn4FYQ5ryTPhfOgKmFZ7tLR9A==@lists.linux.dev
X-Gm-Message-State: AOJu0YyJwabKhNfKYE+20yTuFKLiidCQuCJFMyQtFMLTJWqWByQsmSaq
	jO3zXOQLXa3okoGocKCmsdrjUrCy6wx4UR5Jw6xSDnTMF2IvwHPXH1rkg0WuscfAuLc=
X-Gm-Gg: AY/fxX6qAF6E342fdpK/LjYDgqyEASH5RnL07POgShGLwm1rCKY6bH3LzVMyDoogD4w
	tAK/AVi2m3qA4z+MumzCXfakTpUKYJYAsAIEX8K98g6wuKR2A/R+Z40QI/txd8ggB2ixOuXNcyW
	Q3m+iY7FeROHn00CrXgSV6bFd9Onc1ubuegl0vKSKMuqizHGCdgSP0egvFFxziEhmT7XHu50SQ7
	cKPBUVgOzhXnuRDzs4+4HVrtVngGlTL3y63UmWZTdUY6qTAzTtbAguLxBVkluRjPH1Zo6ypkgdl
	Kw0qICiwJjJPeZB+5T5ZIferiQPj0m6SaxYQdVlj9PkgXE/x5dBlzKzpMNTIcpuq9XK8ac7YuHv
	1IMeptOyrjx1IWprqJA6gQ+bSEJCfwlD4h7FwWe2cuvvTOg0nWUG4CU8HqUmapKw380VZJHSpe6
	RqlN6B1bH18w==
X-Google-Smtp-Source: AGHT+IE30JMG0AYwzRCT2ecSrMzWoEBsLvyNqbUSykaYjiIwFUTZRT1NWtEylvthxvscngptkH72fg==
X-Received: by 2002:a05:600c:45d5:b0:471:ab1:18f5 with SMTP id 5b1f17b1804b1-47a89a39719mr17937985e9.7.1765467208585;
        Thu, 11 Dec 2025 07:33:28 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29ee9b37c33sm28972705ad.10.2025.12.11.07.33.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 07:33:28 -0800 (PST)
Date: Thu, 11 Dec 2025 23:33:25 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Deepanshu Kartikey <kartikey406@gmail.com>, 
	ocfs2-devel@lists.linux.dev, syzbot+cf96bc82a588a27346a8@syzkaller.appspotmail.com
Subject: Re: [PATCH] ocfs2: adjust ocfs2_xa_remove_entry() to match UBSAN
 boundary checks
Message-ID: <lhnx6meceuvndkxjpxaapwkiqvlp6recho77b4yjirznjn62jr@fu5gq2gsg2yu>
References: <20251211120350.693428-1-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251211120350.693428-1-dmantipov@yandex.ru>

On Thu, Dec 11, 2025 at 03:03:50PM +0300, Dmitry Antipov wrote:

please add:
Commit 2f26f58df041 ("...") introduced the flexible array member check feature.
Following this, UBSAN began reporting issue:

```
UBSAN: array-index-out-of-bounds in fs/ocfs2/xattr.c:1955:3
index 2 is out of range for type 'struct ocfs2_xattr_entry[] __counted_by(xh_count)'
(aka 'struct ocfs2_xattr_entry[]')
```

For fixing this warning:
> In 'ocfs2_xa_remove_entry()', perform 'xh_entries[]' member removal
> before actually changing 'xh_count', thus making sure that all array
> accesses matches the boundary checks performed by UBSAN.
> 
> Reported-by: syzbot+cf96bc82a588a27346a8@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=cf96bc82a588a27346a8
> Fixes: 2f26f58df041 ("ocfs2: annotate flexible array members with __counted_by_le()")

Commit 2f26f58df041 didn't introduce a bug, it merely exposes an existing issues.
Remove this tag is better.

following code looks good to me.

Thanks,
Heming

> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> ---
>  fs/ocfs2/xattr.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index dc1761e84814..de99276d12f0 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -1941,8 +1941,7 @@ static void ocfs2_xa_remove_entry(struct ocfs2_xa_loc *loc)
>  	ocfs2_xa_wipe_namevalue(loc);
>  	loc->xl_entry = NULL;
>  
> -	le16_add_cpu(&xh->xh_count, -1);
> -	count = le16_to_cpu(xh->xh_count);
> +	count = le16_to_cpu(xh->xh_count) - 1;
>  
>  	/*
>  	 * Only zero out the entry if there are more remaining.  This is
> @@ -1957,6 +1956,8 @@ static void ocfs2_xa_remove_entry(struct ocfs2_xa_loc *loc)
>  		memset(&xh->xh_entries[count], 0,
>  		       sizeof(struct ocfs2_xattr_entry));
>  	}
> +
> +	xh->xh_count = cpu_to_le16(count);
>  }
>  
>  /*
> -- 
> 2.52.0
> 
> 
