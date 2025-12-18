Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE62626ED59
	for <ocfs2-devel@lists.linux.dev>; Thu, 18 Dec 2025 14:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766068692; cv=none; b=n6IVh7NlWj/p0mFNTB+EyJHMpbBgvaV/tCtgKCQiLc/IH9aHEgQaVF+zFlW/mIDK3WQJ9lHNzlcRwRpGq3fuyhiDZ7nhDWLSjNG4qio9zO4liOsRugjzpxRMHuMajGUtwmr+i7wmTdbnAHzz3wM9fKlHI51LLTu5SUaWytZxi0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766068692; c=relaxed/simple;
	bh=LarlpyuotCqh9GYgqvYzoSlKsYedg1v0wDIa9/aebnA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KbkbyMcujGIdWHZ0lRvn4shJPlULJnNvaY1qykeJlP7q8HI7mKtzh/wm43FgYyCjr+6TGSi3zy1v7q29r2SoRSDtjrQF8A5JfN5eLfQBy0JOMem56schexeqehbD4I14ZV59rOJ2+CqVWZT3Y6H+BlXEbL2TxN0JdEQyAS5zyOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LbYY5IKw; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LbYY5IKw"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-42fb8aa0c3eso94854f8f.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 18 Dec 2025 06:38:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766068688; x=1766673488; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SjCMaC1S8CkpoZOF3d6ZyegK4dr/PLSFBbwtvaN9JEo=;
        b=LbYY5IKwn80JnkWMzC5UjPHiF+t6wsUdcWfwzePS1QmXcs9R6WXNs+i5IH/HBMXk5+
         dT5UHZAFt5PU+En3bjKHl9wiFTjJNK2uzigZUshekaR5WqTE7/p86iB3A5i/iBxQRRHp
         u07v4kR4wcRTn3ycu3m9A1aJ3hkgNKpIuggUyOoOxb0cELpviQtxkxLw6FOAsbj96RBz
         kCjZJqE5SrxfOzGpKOJncmGd04+DBjX2MsW0VGVTA8OhEMBUA9HSGXTA84rNgy2bIOYu
         HZuK2Dd+3zmxmIOfiaEmdn7IAEQVcB0u8lytodwG5J8bYlnXlRNvlslrsXg7FkZqLzm6
         WoHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766068688; x=1766673488;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SjCMaC1S8CkpoZOF3d6ZyegK4dr/PLSFBbwtvaN9JEo=;
        b=kM+X+/n59dzu5JplUSpXCqzF0zjwk+qW0HIEJaRmEAiW3K0ObKEoLquGO8kAFMn9fn
         4e318AFeq4pVRUzcjdnjMi9RKmatcw7z+cqzGfSfb3TwerS5+lwfs9cLs10jltDnOU0m
         d3J6jMt+Nsl+ofPk8OdTIMZ+nmTkl7YevUX7p+2SKscqmoLlZYeNHzOeUvX9YgdoUsjY
         gjvZj6mdq7CC6bYEi2L6Vd4m6rpZ6k/bST/47OnFo/Pamf3qKVeyFSk7q/GK2X7v9BO3
         bYaDqEtOOxxn8BuIH7Md5WL7JLJWOVp0H1o3gQ62oIHrZ+CGKMSdqQOLjM4mgHqX9Ttb
         FSdw==
X-Forwarded-Encrypted: i=1; AJvYcCXdFPmt0SvZLMyQsv2VkIlpIOlBhl0mTKD9ZkHGSi9yOj+i1b3tEDeGdEmi5Xf7NapnDmkDOOEoFutGIQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzfSVxnWyyx61ofwTKnCL5dHW2sMb6HOU9sOhNGeQtyA4nJc6EY
	C+LIZRqXSv9Dyux2Rrf500D50SPG2kUSHTGHS7Tqw7U313cxz6+O28jpvzRCzR04T4Q=
X-Gm-Gg: AY/fxX7CD4VU1I0MWq6W/mF0Q+aeBDSfFIpImz2WzlITQZNBo70gbkd2rw3s1y4tozJ
	hqOI/3zLpiaefwE7tS/9lJaXs+OM6B8+qIwukERSg93X36C01i+jD0GnHEW+QO1IDUY6hqEWpCf
	59xfFG/XX8Xu8vKGbID4oP/AvoB5bSbVGC6cDN3gagKPGNGn1eVfSYID9pcSIpIkWcuPoy8ONGY
	umJ05w3/i+//zw5Z1CKKRif5Kju8p/IvIeD4kHQhR/nZ8C1EMoQLAYZPQTt0SRk3IUqA5YCJo9k
	j+XNp8aHoE5/5aixAMjbjTHTKr2wrk9O5zXD0VQnNjjyI0A3E8RJOMaV9TiM66JAMbmI6EbqdAA
	+uy+Eu8vKdsXUmO7ik5seUmFokynLAAdvKCnUS7kjFtoAz/EVBfKqzHKtpjc2PlEEEdFQEbvKHy
	jnvwNOEvQSxA==
X-Google-Smtp-Source: AGHT+IHw237JMww1QdnpwuTThD/iHkZZUobR+JbAiNFI2FwbAevCZMDd+6cP/chrZstsL2U7uXLgOQ==
X-Received: by 2002:a05:600c:628c:b0:477:563a:fc9c with SMTP id 5b1f17b1804b1-47be3c79d92mr14821285e9.1.1766068688104;
        Thu, 18 Dec 2025 06:38:08 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7fe147635e5sm2835140b3a.63.2025.12.18.06.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 06:38:07 -0800 (PST)
Date: Thu, 18 Dec 2025 22:38:04 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Su Yue <glass.su@suse.com>, ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ocfs2: fix uninitialized variable in
 ocfs2_test_suballoc_bit()
Message-ID: <edd223sc52jmxr255onvp5qwbwoyjv5douhrwxhor5qk7m2q6c@r4uqvboctxjx>
References: <cover.1766043917.git.dan.carpenter@linaro.org>
 <dc37519fd2470909f8c65e26c5131b8b6dde2a5c.1766043917.git.dan.carpenter@linaro.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc37519fd2470909f8c65e26c5131b8b6dde2a5c.1766043917.git.dan.carpenter@linaro.org>

On Thu, Dec 18, 2025 at 10:48:12AM +0300, Dan Carpenter wrote:
> The ocfs2_read_hint_group_descriptor() function sets "*released = 1;"
> but nothing ever sets it to zero so it's used without being
> initialized.  Initialize it to zero.
> 
> Fixes: acb8a8335a64 ("ocfs2: detect released suballocator BG for fh_to_[dentry|parent]")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>

Many thanks for catching this bug.
I will try the config CONFIG_INIT_STACK_ALL_PATTERN=y

Reviewed-by: Heming Zhao <heming.zhao@suse.com>

> ---
> These days everyone has CONFIG_INIT_STACK_ALL_ZERO enabled so we never
> detect these bugs.  There are a couple distros which don't, I've heard.
> But in testing, I always encourage people to use
> CONFIG_INIT_STACK_ALL_PATTERN=y
> 
>  fs/ocfs2/suballoc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 72c7559c1a2b..79d1325b2111 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -3163,7 +3163,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
>  	struct ocfs2_group_desc *group;
>  	struct buffer_head *group_bh = NULL;
>  	u64 bg_blkno;
> -	int status, quiet = 0, released;
> +	int status, quiet = 0, released = 0;
>  
>  	trace_ocfs2_test_suballoc_bit((unsigned long long)blkno,
>  				      (unsigned int)bit);
> -- 
> 2.51.0
> 
