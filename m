Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817602F28EA
	for <ocfs2-devel@lists.linux.dev>; Wed, 22 Oct 2025 07:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761118766; cv=none; b=OPc6fIdLXenf1TOQ4qDbbW/vRtB43FVrTQrLEKZUSUb4Yv/yaQekCKh+36QiWoSFaEeSeGYAMvsnr7lJ/2nLiL4qQyE0IkamfuAtc6mQdi97hnXhixa6c2/vFvCkK+Y02RkZj3aQJR3DQLiTrmJothhJeOyM42jmg9ftudaM2bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761118766; c=relaxed/simple;
	bh=1UfJyDUIks1vxH1FbS6Cvd77yqmwrg+w+bj2jY4f62c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qcy2iG6H0RMbHCPnArA0aDuk2Z7Y/l0skDl74lsCNDdH4n/RXR+V/rzuzOV5HJEp4gmYTWnx+nu7MizXtA2zlDm5kfKHUOZ0Hmj85Yzn1jSdFihAiy8ClHimDF0YoswfF87eSZWZBmsj73rj1FMP+CKK8x5FMIyD2kNRRrhmSRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WyOp4v6I; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WyOp4v6I"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-427054641f0so980481f8f.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 22 Oct 2025 00:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761118761; x=1761723561; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zDabq8PDu9wX3R0wzqBQvDddehb78pUgpQxLOLuzpFQ=;
        b=WyOp4v6I8y5vMcQjAKIS74V2srflM67wV/oNanjr1B7fnfvTrjeVVNDX4x6kI/L1aP
         8+C5Z5EKK5YrauV6K1NoL4skRvTu3gtA8ymVe4gPCJ44zYDsmF5OUgumImLbnn7elyUl
         SYvX09wscOZm+LXW/yEo39OLkUuD2wN3x/j0fvO+2vM8/evkTuOKkm/x7sIJS9c7Td7J
         b6gSFSPvVDCMW87GsBVqH229RfOWt0fdCfLAPWsqSh3aw3pgerKv6i5xvwsOn378AZ34
         0xPi8+DOuF17vu8euWbA5Nug7Dgo7ps32MDgiJTEvPj/LgyOkUU2QWOl6/EJLOq2c6xD
         0d5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761118761; x=1761723561;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zDabq8PDu9wX3R0wzqBQvDddehb78pUgpQxLOLuzpFQ=;
        b=BPjwNRkubgIDlYIGDo3LIrMTWQvGeNKiI5SqqOZOcujIxOIT4hP5kPxH/C4yee6oYo
         YWtOcinv9mlWpdyWF/xPw/HxQ790QbtAb1qnblvAdfBDbX63PYlgZAttsLZJF8uGvvdo
         CmzDd/hhhUOI6W4UXlGskPRzUrz9lHR69FfRafQK7gIdOZ2cYORZEklntNquWQLeKp66
         +YZyFHqQHWJdvRcsO/ypmhFcUkQvsPVugkJUwXKFyGiuq7/k1gbbE+Rv47e7M7MjGv2U
         LFGjkckbU8JhJg5nkCm0waz0D3gt8ovsN4XaLw1ZZje0dcVVfk0w0s9IA8KbpnQF6bud
         /C2w==
X-Gm-Message-State: AOJu0Yz+YpkBp5tSdMrK5aWrra64bZtb6mvQHLkkYkOHONygP71g9DT3
	GpEOBZ0txDRaWpWUQqEqmMFtZ2/bMiILCc+zihXGqIqWdEc/k1Ye5b6KtHXuC5eBUOA=
X-Gm-Gg: ASbGncvFiK0Z6gUUy+YFDgCMJ8BZpksglMR2qhIwvrMtD76rxK69MQvyQgz/9SMiqSq
	Y7HL0jhSGtNp1LYSvGOCCSVeJKOW1zXYJ4y5DGxp6Lvk+7qGI43gFVKcZsFy2o5h/F5ry56XVyM
	4U1d+MlVDeLcu8IpG0QYdwOMT7vFyrYxtX015zkKY+AIMK4lBOQHPW0A2O31aWpb+k+DD+Nrbv1
	6cYgj88Llou3yai1i62OLJ1zY8Nuq5M28ua+nH/pFFs7fg5NO8AKxDd8+gDpicJz9xT8VOd0ae9
	i2xZan/m0nMgR5oKCdqUa7bttQ/OnnRq9oroU/IWHrJ+Y/cEgp/zrUP5EkRI3+VvGAHy9ZuPKT8
	XfT4ExL2IChESNxsZ+3AnKgautE65nEwDoxsP7aU9P1KLXCTs9dj1P58RLmNMvqLyNxEc8Qrg8J
	15DYYuyaUxaZPDmUKvTQ==
X-Google-Smtp-Source: AGHT+IHbPcBV4Jg3z1Nt/xyma/WZObn+nVFRnZ77szpptc4TA1RRvvUBkMvEBMLEOpPwqOJ7C/AHLw==
X-Received: by 2002:a05:600c:6308:b0:45d:da49:c47d with SMTP id 5b1f17b1804b1-474941ec4b9mr22170705e9.0.1761118760686;
        Wed, 22 Oct 2025 00:39:20 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a26a9e5f90sm749867b3a.38.2025.10.22.00.39.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 00:39:19 -0700 (PDT)
Message-ID: <6a446b6f-0405-483f-a3ac-a482eba1b807@suse.com>
Date: Wed, 22 Oct 2025 15:39:15 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: annotate more flexible array members with
 __counted_by_le()
To: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev
References: <20251021105518.119953-1-dmantipov@yandex.ru>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <20251021105518.119953-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/21/25 18:55, Dmitry Antipov wrote:
> Annotate flexible array members of 'struct ocfs2_local_alloc' and
> 'struct ocfs2_inline_data' with  '__counted_by_le()' attribute to
> improve array bounds checking when CONFIG_UBSAN_BOUNDS is enabled,
> and prefer the convenient 'memset()' over an explicit loop to
> simplify 'ocfs2_clear_local_alloc()'.
> 
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

LGTM.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>

> ---
>   fs/ocfs2/localalloc.c | 4 +---
>   fs/ocfs2/ocfs2_fs.h   | 4 ++--
>   2 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index d1aa04a5af1b..56be21c695d6 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -905,13 +905,11 @@ static int ocfs2_local_alloc_find_clear_bits(struct ocfs2_super *osb,
>   static void ocfs2_clear_local_alloc(struct ocfs2_dinode *alloc)
>   {
>   	struct ocfs2_local_alloc *la = OCFS2_LOCAL_ALLOC(alloc);
> -	int i;
>   
>   	alloc->id1.bitmap1.i_total = 0;
>   	alloc->id1.bitmap1.i_used = 0;
>   	la->la_bm_off = 0;
> -	for(i = 0; i < le16_to_cpu(la->la_size); i++)
> -		la->la_bitmap[i] = 0;
> +	memset(la->la_bitmap, 0, le16_to_cpu(la->la_size));
>   }
>   
>   #if 0
> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
> index f7763da5c4a2..c501eb3cdcda 100644
> --- a/fs/ocfs2/ocfs2_fs.h
> +++ b/fs/ocfs2/ocfs2_fs.h
> @@ -641,7 +641,7 @@ struct ocfs2_local_alloc
>   	__le16 la_size;		/* Size of included bitmap, in bytes */
>   	__le16 la_reserved1;
>   	__le64 la_reserved2;
> -/*10*/	__u8   la_bitmap[];
> +/*10*/	__u8   la_bitmap[] __counted_by_le(la_size);
>   };
>   
>   /*
> @@ -654,7 +654,7 @@ struct ocfs2_inline_data
>   				 * for data, starting at id_data */
>   	__le16	id_reserved0;
>   	__le32	id_reserved1;
> -	__u8	id_data[];	/* Start of user data */
> +	__u8	id_data[] __counted_by_le(id_count);	/* Start of user data */
>   };
>   
>   /*

