Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14D32F5B
	for <ocfs2-devel@lists.linux.dev>; Mon, 17 Nov 2025 05:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763357528; cv=none; b=NV0GFq9b2gr80aP24TqtlAnvIBghn0BHHJqSdtCWx9MAme1XM1a2N30nqVphGtPL4Z/rNqTo9dNQBBZISYQwU/unwq0O6MeoJE44F01d3d+mtNuMaTCi6ERcgu5KwEyVfV+PrF5M4a7Dwd087NsKAWXtlHYCOlYXLx8Ih7fqACI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763357528; c=relaxed/simple;
	bh=qDNvS4gs4rZScxDqi64CNWzwpI9eznGM3AO2h1Xcvo8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RUwrwm+Wi0mHkRHoycb7SUrL5nGy7mvPI9PZCoCgHh+XD1g2jkgXcdXTvlgdjO0f8j6QZ1Pf7ysrb+/TylkjPXQY8+wQvSFruzFUa6tFfTUsnv9rNmPCmal/Hy+vqTyO2pLhjGwTeqO1Dqj14bDopJ84Uz6mGURIg+cL00Gs1jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LmnKKxsT; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LmnKKxsT"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4779b49d724so1264625e9.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 16 Nov 2025 21:32:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763357524; x=1763962324; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eOTfYi+tVsV8XnFMmLsNAmw9POVor+4niM6A1Xzk09o=;
        b=LmnKKxsTfermpxBG5uucz6uOoPfzdTNeFQ5Npu2oRoW2l2qRrnXvzrZqVIbgFB6LiH
         nJ4G/w2TRPhgvgFrtzPdvT18VKAfcK/KO1IOheriF0ZrXEf8W+FDvujpCAR5NGRH/6DK
         4u3uK/BwJEa6RAlqD2t5y7KmBuOwP2FP+bV5o6s2/MGXZIQ7iQrgzI9yPVHiwvAE1IMi
         2lg20RLVE7vwVXKVLpNZIZIFPPZvJmyibkSZQ1xXheuT8zqyoQUreKmTjgLi9R+YcGgy
         Ti/zx5FfTBFmx/HcjrK4AU0QUbQ2WITU526FFTrH9MXoB3OTxxjaGyjqBsz469r52r3s
         tECw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763357524; x=1763962324;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eOTfYi+tVsV8XnFMmLsNAmw9POVor+4niM6A1Xzk09o=;
        b=hS3mudA7+UtzKchvogboQ0oVQD12vcZykZRG7lo0vIgMYlMWxo/NxJBCbL2Ytxss+7
         jaMtkg2DSGDZo0hScwv+H142ORrFoDbijeWZt23GGRQCvGkxotkUwVn4ROGONN9nByqi
         AYlF8awalx4/LULmOdXvoY5bDIjfjmVndhEByFR0PowvlKnvyioMvI4LRKxHqIIHwgfj
         NYWGV4qkrTJtoMGp0yCz7/wgAHi47pePND3DimEVAkd6LvLVfqZ16tHZ6AMgWVY1+i5S
         MLt35Ofc6WK951NdAvT4gHQuV+b7PE7y89XlupFd1fpCAagqBxjE0SOXVj0cRmJIO0cj
         Ck6Q==
X-Forwarded-Encrypted: i=1; AJvYcCWlbaMRoumPBmYFevqnbA2d33UCFpNKNqcuzHZOgTKbqzjeRv6/6vx5h5nTP77Ih8hQ9kO+jyAYZWwO2Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YzldpH0GnBeiccG2iFSNKUTI3LW9CSyQMDhbt28s+HB7ZrmxNUl
	bU+DsjrQddwOPWnCI7YHcPrBDEo9oQodxtDw8bjGzlcj5bMptJQkBiw3qPsteodNjqngUNdhBIL
	cSUfT
X-Gm-Gg: ASbGncuG2Aj6CIrAzxYtD690Px0zmof/4if5mArDr/l5dx4cA9uTE+SQnksi+zrjkxu
	KEAyRoE/n6jc1VauuMMEjkgAQ1l4wursRt0YOzqIg9E6x1VgQuvrO14SETFTdK5wayjvO41YX1s
	Air8CYbflnl55JNHwcgZT/w+5BHopBG0jzh5PwYpGbqSeghX5NfHIUwiiCVR4LNFm04m5j1Dx3v
	yrRy8Ggu+D1Rsp3PIHqHbRk++CK0VG6luxuOVJRrbahZ4JM+ByrpawfuVFfLU8LXHZFX9HR6r0N
	2AwGtgF9FKg41HRm7womegUYNDzf7YH6BXZb6xvIyQNCQqGg3NK2cHHY0SU58/kTCGDu/ZY22HY
	BDL0TqofSgqkJP8cr82PmI3XZqAcxdN7VwVQUg9rw5gNuMFDjwCwztkcckNs3oxhzxo7+qUh7UF
	oclnBwM6WcbA==
X-Google-Smtp-Source: AGHT+IE/Sn+NHjmFPkX+qDLBz/tmkuljOojgxRyZSKcbpO5UM4orDk6yBzdR3NijuuYD+wAGs5CY7Q==
X-Received: by 2002:a05:600c:4e93:b0:477:9fa8:bc99 with SMTP id 5b1f17b1804b1-4779fa8bd59mr16387885e9.4.1763357524134;
        Sun, 16 Nov 2025 21:32:04 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2b0bf0sm126604445ad.71.2025.11.16.21.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Nov 2025 21:32:03 -0800 (PST)
Date: Mon, 17 Nov 2025 13:32:01 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] ocfs2: Avoid -Wflex-array-member-not-at-end warning
Message-ID: <7vsq3tvjuv3ppiot3lgithyp76r4jbbssoiiuni6zvj5pajsov@nketwax66jss>
References: <aRKm_7aN7Smc3J5L@kspp>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRKm_7aN7Smc3J5L@kspp>

On Tue, Nov 11, 2025 at 12:01:19PM +0900, Gustavo A. R. Silva wrote:
> -Wflex-array-member-not-at-end was introduced in GCC-14, and we are
> getting ready to enable it, globally.
> 
> Use the new TRAILING_OVERLAP() helper to fix the following warning:
> 
> fs/ocfs2/xattr.c:52:41: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
> 
> This helper creates a union between a flexible-array member (FAM) and a
> set of MEMBERS that would otherwise follow it.
> 
> This overlays the trailing MEMBER struct ocfs2_extent_rec er; onto the
> FAM struct ocfs2_xattr_value_root::xr_list.l_recs[], while keeping the
> FAM and the start of MEMBER aligned.
> 
> The static_assert() ensures this alignment remains, and it's
> intentionally placed inmediately after the related structure --no
> blank line in between.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

LGTM.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>

> ---
>  fs/ocfs2/xattr.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index d70a20d29e3e..09069defd7e1 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -49,9 +49,13 @@
>  #include "ocfs2_trace.h"
>  
>  struct ocfs2_xattr_def_value_root {
> -	struct ocfs2_xattr_value_root	xv;
> -	struct ocfs2_extent_rec		er;
> +	/* Must be last as it ends in a flexible-array member. */
> +	TRAILING_OVERLAP(struct ocfs2_xattr_value_root, xv, xr_list.l_recs,
> +		struct ocfs2_extent_rec		er;
> +	);
>  };
> +static_assert(offsetof(struct ocfs2_xattr_def_value_root, xv.xr_list.l_recs) ==
> +	      offsetof(struct ocfs2_xattr_def_value_root, er));
>  
>  struct ocfs2_xattr_bucket {
>  	/* The inode these xattrs are associated with */
> -- 
> 2.43.0
> 
> 
