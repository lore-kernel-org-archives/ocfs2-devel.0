Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F4A2D627
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Aug 2024 08:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724142758; cv=none; b=thDu6KLGbdNhk0LLKgqaCRFn+UzH4nCR78s57cMj5hFDguMqfjRJYQRrhwya0tpjibBXTNHIx/vF+t/0kYSn86kWN2oIWkzynhRnYk+iGwLO77MwycJdHNzfeCbw5UOx2c7K3ZtF7lbopFUXj2g2NrX68moGc0gs5zdvv22R0Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724142758; c=relaxed/simple;
	bh=PgAAwi3ABtUV2uBhW15Onu0kh0z8ocEuwBZ2+wxVxVo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mUL9Uawkqtf0FHJ1MNz+IH7SDIL7WSSpOzlloqrA0gkj2CIwcJP8CRSpO1K2NW08BqEwHa6KcuDGiNqN83kJqVdKOLupAOSzSSKWKXAdrZ9xZsJAcTCh10HJwzsoNNdLSQuXc8WnMgIBK1+Qpjo5DEEVeErT0GgyWTYkl+n2iXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aBBFHXNG; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aBBFHXNG"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2f3cb747fafso34603711fa.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 20 Aug 2024 01:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1724142754; x=1724747554; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wlH8CopQ7GW3XFywQZo01UHpbUpx8ne/x30K0676QQ0=;
        b=aBBFHXNGCLKi1t7wa38FGsm9M/RhKP0KKZ0j9vSfjARA9mLOjmhVfCXhsX8o69FF2v
         iMNjy6lKgCBzMvkPcsfjm297xMJJNiggMgk/snk9WXnh2KDD5ZTl/0YwIqusR+uNCwZQ
         Ia+efRZN0HoFntvR+j5S2vcVkYa+g7Vq3oW8eanvh2XfLUvD5WhnUTeKHPEmx9FO0CdS
         KyDWR2Huz0nD42uabRjY9cMH9IHnQ8n6siocrTAfNaOgoBq6WR2h51Zr6BHtCQ/sjdI/
         0NtXWcGUrUco7TlZoujo/YnFB+Ug/NXb5amSbqFen3PlbD5Tqbmh+GJJMNPoRzPKIgKc
         pSdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724142754; x=1724747554;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wlH8CopQ7GW3XFywQZo01UHpbUpx8ne/x30K0676QQ0=;
        b=doqZtM8acYFPu7KgubonrQdNOOjJHZ6a83PaElzjxQkMeEwrun0jZLCrneqGE7gK7O
         l4jIPDh3+07hKkCiwpA0WK4lihVe65ac3VnzSjfme7nKCa8W14KXxQ9OUqKItXkQE1qt
         1uArEJzI83u9T4pJ2GNmctyPcDyWlzVDYfoz7ZXEO0Aig2s3B0+WytYwmv1KlJ3CUxrI
         k48gDjJRaPNN182RllLO+d3jfi2EMBZCfRoLlI0+OTXmg0H+pEHGgNiXr5iMEJr8H+wo
         cfddwPFyMmAdnh9z9yyfEpVm9ma95mqCoy2pMFe3BfeqCCBWD/Kt6ugbxWK5LslUobrg
         +boA==
X-Forwarded-Encrypted: i=1; AJvYcCW4b7sDRxdgu4lxKBketzHgcLkr3CNWEX5U00IOuvqaQM6IS0F8AYlgixC9i/TX82/1yIq9ZBdecVtsMzWeQWv0XqctTKiu4gqBug0=
X-Gm-Message-State: AOJu0Yy1If3QGU66R1UBQT1qaibWalRp0D91VD9spx41H1VPYmeuYHdc
	mj669WQR5Tkrk4IQv6VMC6S/UpawG83FdcrvkoYrKXZwiGEn1jfNut6zmu0EgQc=
X-Google-Smtp-Source: AGHT+IElV8FXU9Q6EEmABmhvrh+lahp6xj2LFEIEf1QhrKDweKz1u5w5NdpW4uS1wZNhYW+l1Xol9w==
X-Received: by 2002:a2e:3515:0:b0:2f1:a337:958d with SMTP id 38308e7fff4ca-2f3be597903mr82730551fa.24.1724142753616;
        Tue, 20 Aug 2024 01:32:33 -0700 (PDT)
Received: from [10.202.0.23] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d3e2b65a9csm8678000a91.3.2024.08.20.01.32.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Aug 2024 01:32:33 -0700 (PDT)
Message-ID: <980b3f4d-f265-4eb4-96a3-8f1a75588193@suse.com>
Date: Tue, 20 Aug 2024 16:32:29 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3] ocfs2: Fix uaf in ocfs2_set_buffer_uptodate
Content-Language: en-US
To: Lizhi Xu <lizhi.xu@windriver.com>
Cc: jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev,
 syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com
References: <2d6499d6-fd03-43d8-9595-5babfd82481d@suse.com>
 <20240820073739.1289567-1-lizhi.xu@windriver.com>
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20240820073739.1289567-1-lizhi.xu@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Could you resend v3 with both patches?
And add my "Reviewed-by" tag to another patch.

btw, you miss change log area from v2.

-Heming

On 8/20/24 15:37, Lizhi Xu wrote:
> In the for-loop after the 'read_failure' label, the condition
> '(bh == NULL) && flags includes OCFS2_BH_READAHEAD' is missing.
> When this contidion is true, this for-loop will call ocfs2_set_buffer
> _uptodate(ci, bh), which then triggers a NULL pointer access error.
> 
> Reported-and-suggested-by: Heming Zhao <heming.zhao@suse.com>
> Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> ---
>   fs/ocfs2/buffer_head_io.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
> index e62c7e1de4eb..8f714406528d 100644
> --- a/fs/ocfs2/buffer_head_io.c
> +++ b/fs/ocfs2/buffer_head_io.c
> @@ -388,7 +388,8 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
>   		/* Always set the buffer in the cache, even if it was
>   		 * a forced read, or read-ahead which hasn't yet
>   		 * completed. */
> -		ocfs2_set_buffer_uptodate(ci, bh);
> +		if (bh)
> +			ocfs2_set_buffer_uptodate(ci, bh);
>   	}
>   	ocfs2_metadata_cache_io_unlock(ci);
>   

