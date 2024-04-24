Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B802E125C1
	for <ocfs2-devel@lists.linux.dev>; Wed, 24 Apr 2024 01:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713922846; cv=none; b=ARKwONEnebbR+yKHhak/djhLsLXfrh/vYtcOKbcoyUgJD+onKp0WRBQsvu1wXe6qEcwwW53YsCDsm8CoNSWc9TRulKqmr8IzfheVzHGb/DnP+ta8B6rqXobOu/WiNWr8Rr4M+QjkUW6y62No4qSBuHEjr9qgpG6pCL/lyI2ndY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713922846; c=relaxed/simple;
	bh=cjugTrkq9EQuinxIy1ewahKvQw/H2yFnY2sSql1JwWA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WzW4rlRz7HLnbyfTR9VpMKnrHctyAT8ie3f76Q79N7JlEmXW/eQftO9BLBK+UmRhZHznq5cnsoAdsvvH9/c98X0eafvufWHFT863QzfgoVvTyug31olWqIvc7X8PD+ezpOKBlp+ac/wqQJb+kTa08IKuRcs1WIY9+oQ3PmJWAcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Rdiw5KNH; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Rdiw5KNH"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2d9fe2b37acso85299261fa.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 23 Apr 2024 18:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1713922842; x=1714527642; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DPIL1irM9g2LEJoNKgmmO+T5p0jXWSH5GlZLc/wT9xw=;
        b=Rdiw5KNHHXwZtcaJwdsAcBhUpvZFaCWVjb5uq69kaEfjj9hTXMcazJxYEzdWTf+Qpz
         sp8XAq6VZHbLp0PLEQH0iIhT/5oIDvjA6Tc2XnXiy8UGiC5OXEtMB9OWxPXtnISd+UG6
         XZUNqNGj9+0po9U22xZG4OD/J0zXmkEHYjGO3kIJu/JsAQRfCmWdOCQln6tc8TWtb8XR
         uay1nqruVNZ+F3R5Jea6ZzVBLd59jwez/vIcj5jAGxSzPgUWRZHCQEVzLzlmOaqMAI2F
         tYyL+4DOdttls0nVcuY/xEajNZsslJiSMliXR7utcNTRxw5tRL/ngI0WQIGEgSjJy3M1
         zUQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713922842; x=1714527642;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DPIL1irM9g2LEJoNKgmmO+T5p0jXWSH5GlZLc/wT9xw=;
        b=P+p9jii85bln9hpxTNzU5lkmSGggXRrS5Fg9gl9BQeC/GH5DQK69ecnyzkU7HVbB+y
         j3Zmzg28dpzNT8uwkJJQJPi1y17aM2pHbdkNiVeIotaFbDWGLOBX/4ENh0FbocooEwrH
         T0DjAEzwDobDPHFOxNC5RVnr1qTdHbybxLt88VDfKgH9C8+yxy2t5RYR6+1GdV2kBeli
         igYpnP0IPcuFElmNGrMhcN/BRYGmfMGg74J8NM1HnZPkApAQ5vko7GZfm+aT8a7wthfT
         c736lenimnPNSFkvWmhrZD3QgFXsy2yVYX5yj01P1/MbhnK111AZyOVJprB7fuzssJht
         UjcA==
X-Forwarded-Encrypted: i=1; AJvYcCXarSySMOEtxQAzpJDUqNTgV3j1oIEtKHazWDtye/j0U14Y/G9h/+7scMoMVAfpcWxyUoeMpx2yRK97rook2E09FbfgyWSRfxIUF9M=
X-Gm-Message-State: AOJu0Ywo4p5MBYVYi+P7qO45hi6AZ8KeZjjOgHUMqc1wV+EtXB0+dl1Z
	y7GzC+YDQ5Z/FDD88qPXNTrRH6tVVz2QFfh5i5ovN1d0mONmFq6m/YuNzgHmFaw=
X-Google-Smtp-Source: AGHT+IHsyT6umzLMRcLfvPzpfv8xgCe5bd2QZPyaJv4bVGU76feTF13GDko9UUig/6qcN/TMchQpPg==
X-Received: by 2002:a2e:9b17:0:b0:2d8:a98d:18e with SMTP id u23-20020a2e9b17000000b002d8a98d018emr498878lji.8.1713922837392;
        Tue, 23 Apr 2024 18:40:37 -0700 (PDT)
Received: from [10.202.0.23] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id jy15-20020a17090342cf00b001e0d9dcae91sm10669806plb.279.2024.04.23.18.40.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Apr 2024 18:40:36 -0700 (PDT)
Message-ID: <8e22e6d4-4c62-4b78-9809-5648537af775@suse.com>
Date: Wed, 24 Apr 2024 09:40:33 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] ocfs2: remove redundant assignment to variable
 status
To: Colin Ian King <colin.i.king@gmail.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: kernel-janitors@vger.kernel.org, ocfs2-devel@lists.linux.dev
References: <20240423223018.1573213-1-colin.i.king@gmail.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20240423223018.1573213-1-colin.i.king@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/24/24 06:30, Colin Ian King wrote:
> Variable status is being assigned and error code that is never read, it is
> being assigned inside of a do-while loop. The assignment is redundant and
> can be removed.
> 
> Cleans up clang scan build warning:
> fs/ocfs2/dlm/dlmdomain.c:1530:2: warning: Value stored to 'status' is never
> read [deadcode.DeadStores]
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>   fs/ocfs2/dlm/dlmdomain.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
> index 2e0a2f338282..2018501b2249 100644
> --- a/fs/ocfs2/dlm/dlmdomain.c
> +++ b/fs/ocfs2/dlm/dlmdomain.c
> @@ -1527,7 +1527,6 @@ static void dlm_send_join_asserts(struct dlm_ctxt *dlm,
>   {
>   	int status, node, live;
>   
> -	status = 0;
>   	node = -1;
>   	while ((node = find_next_bit(node_map, O2NM_MAX_NODES,
>   				     node + 1)) < O2NM_MAX_NODES) {

This mail cc linux-kernel@vger.kernel.org, it would be better to only
cc ocfs2-devel next time.

This patch is correct, but it's a very trivial fix. I am not sure if
Joseph is willing to take time to push to mainline kernel.

Thanks,
Heming
