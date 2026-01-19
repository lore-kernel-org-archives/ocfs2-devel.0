Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8C1225390
	for <ocfs2-devel@lists.linux.dev>; Mon, 19 Jan 2026 14:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768834207; cv=none; b=AhpwJhvTktf8/qacIruS8ECyauH+mbECpPUa7TzseFKI/cgqj/8VIqi7+EkUeiFBfZmdRmaaSwl3Pje0+I2MSEyPW0SoM17DlBOmxAwLeO0US5q8x2XieoBKpQHZYQVOvYs38smeR7J7FrQqSuK7+2qqcUNpG/ExCoeoEzUW/ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768834207; c=relaxed/simple;
	bh=LYsOlMWu2hmPL3oO4GTDVdAFFX13hsEL7FSPUh0wwuU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GwFQvyKOV5NJ+qNKWKL38DdJuDNQ3yQKPP/zg+sBICd6jeMFpAnLfGcuxI+RySjZPzeAb0FPu9PZBPBjzip17EDjjdHmOauwkQkULLNhsNQY2ekPWzoGT1O1WlwSZiJ3rC8k5mSk5BF8wgHVeLY/7agSLINVXwBD8/UamuAk3LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bvb66bmr; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bvb66bmr"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-47ee57c478eso1962095e9.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 19 Jan 2026 06:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768834204; x=1769439004; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nTGin9onPXJqX84mu3B1L8Z1ww67PPt6c2c9vvin0tc=;
        b=bvb66bmrAJl9vn3RvDEJiPPKL70D5OK6OVMSJiN5yXpQTWedFHZ7DYfysI242we508
         sSrCMt9zYn9wDvbSScyhsQbowldFkxKTVzZIyHl6I826CitaecjYkjImz/8J3Q3m+Jxh
         O78rnYse4BrhJ7kTEazp8ndSm1aRCX+dS4PTkXnuq/2sWLEHfTe8tBGpjOlOSWP7H3ia
         iG8DR9xITG9cu8Z175uI7vCbaRFZQlYW9C7RFTOHWsyyFzlJHZSsD3Yrq2P7Fc5zWgUY
         pswYNcQ3yfnuxdfLapX77M7xh5bp+/QB+Ng0Vrc6ZOJd0QSVWECDA3HDK3d4+QaJ46s6
         4QJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768834204; x=1769439004;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nTGin9onPXJqX84mu3B1L8Z1ww67PPt6c2c9vvin0tc=;
        b=Dg8J7+ZQmnvWEnHhbrFU66wNuw/ZKnE3uw4ZMebhLcKlrmAfz4+xbe0QNL33tCgzCa
         QwEPXF62R9KOGhMOdAe7fQKYBVNG4ycU0ApDUW0Y84GiXffz7Yg0aZNmCXNZckroYYLJ
         RWfFEhlsYQgWck0jEm/F8RwpRMb3HC9KtsJIOIqXvX2WdEi0vVZhyiREqMMT5IDgg/tI
         Y8g7GcjTxngy1pv380RtcVJnl1tSeO83UvtJxAroevxGkPDhSNCuSkjNdAwQlAPThnvp
         D+BPCdwu7hgUukbFlUwhZJjSwdECDcZbqjyZfCKrR4Tx4QFvFMam15GY7YDjTyMiw3ev
         k8RQ==
X-Forwarded-Encrypted: i=1; AJvYcCVc8PvQ2AXBkBfTwmi1PGf2l41I52zm2Tg5G/z67++7k9YsiW41qYSZi6pw47kEjy+8e5f7y9ytyxVzng==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx6ibZUWMaiNZnZ4HO+5Fgw03VW2YT0eEGMl4XjTXnz13AHX2qb
	p2CogztZ6rOsphNOPWs1q/Rvpy9cDJRzOEUKDGrjOXfPWzec5I0hOh8yECxxOP0swwc=
X-Gm-Gg: AY/fxX4BENbj6xOh0Jv+CPen5gx+Z7p3KOd8MolTC1yD0WxhIZ65aLoUQnk6CrwBmAC
	1+T5H1ZWCcMCW0eC1ptrvU5EwjJzXoALFMWWvnDbAP9FHglRd+cx28Hr0LlXWVX2sPe3WQQMA6g
	eh+zeRqujI+VGoSQztHk4l9jRHbvqQJigfrmlsitYxnf+dXxA1yXmvVMlgcLlO2SOufhgTScgwA
	/pcAJ3GwCFeNbLyswOsfN5S73+T7rxr1iBwg04OA8pFqUuC0ntbfNBKh2O1v9MmX6LHBxj7LJs1
	+snBhOcQvYuMGXPLUMTqdOmcao/FwGXHtg/eqiFXGH2luv6y912wxuKD6+54yGtgKJkrkQOXu5g
	8byEQpJBXPWedyLrIV7BuLzxb3HhKxIrmLbjyPTZOXAtYMC+nj5MB6CR1GEkvjbOUmOTG71GCmP
	P6Dxbm+xH/ZQ==
X-Received: by 2002:a05:600c:64cf:b0:477:a6f1:499d with SMTP id 5b1f17b1804b1-4801e33c5ecmr80680595e9.3.1768834203994;
        Mon, 19 Jan 2026 06:50:03 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81fa10bdc65sm9616599b3a.21.2026.01.19.06.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 06:50:03 -0800 (PST)
Date: Mon, 19 Jan 2026 22:50:00 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, linux-kernel@vger.kernel.org, ocfs2-devel@lists.linux.dev
Subject: Re: [PATCH] ocfs2: fix slab-out-of-bounds in
 ocfs2_rotate_requires_path_adjustment
Message-ID: <nvaagj2qdkgifr7lwyzybwyvfvuwmxunpjinklepvtyoi5v6tw@vsihwyqiu2i4>
References: <20260116172113.22143-1-jiashengjiangcool@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116172113.22143-1-jiashengjiangcool@gmail.com>

On Fri, Jan 16, 2026 at 05:21:13PM +0000, Jiasheng Jiang wrote:
> In ocfs2_rotate_requires_path_adjustment(), the variable 'next_free' is
> assigned the value of 'left_el->l_next_free_rec'. This value is then used
> to index the 'l_recs' array as 'next_free - 1'.
> 
> If the filesystem is corrupted or in an unexpected state such that
> 'l_next_free_rec' is 0, this leads to an array index of -1, triggering
> a slab-out-of-bounds access.
> 
> Other functions in alloc.c, such as ocfs2_rotate_leaf() and
> ocfs2_update_edge_lengths(), effectively guard against this condition.
> This patch adds a similar check to return 0 immediately if 'next_free'
> is 0, preventing the out-of-bounds access.

Do you have reproduction steps to support your analysis?

- Heming
> 
> Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
> ---
>  fs/ocfs2/alloc.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 58bf58b68955..b15c6f751d99 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -2327,6 +2327,10 @@ static int ocfs2_rotate_requires_path_adjustment(struct ocfs2_path *left_path,
>  
>  	left_el = path_leaf_el(left_path);
>  	next_free = le16_to_cpu(left_el->l_next_free_rec);
> +
> +	if (unlikely(next_free == 0))
> +		return 0;
> +
>  	rec = &left_el->l_recs[next_free - 1];
>  
>  	if (insert_cpos > le32_to_cpu(rec->e_cpos))
> -- 
> 2.25.1
> 
> 
