Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943DB2FB2
	for <ocfs2-devel@lists.linux.dev>; Thu, 27 Mar 2025 06:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743057815; cv=none; b=jsOkh83PzdD/ryrzD3L+mVdSzFPIiRM1n3xQxshNySpa4+Qy6NKw6/v+YQNfKzcwNR3sElDSBZzboD5mAxnr7/vOvuFeo3WUmxVXpUdiDxAkz0tmFVUM/e6oi4rHmyliF8trEpfd39B38bihQl1ZzbEF/NHcx8RSgZESPS39sZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743057815; c=relaxed/simple;
	bh=n66ybPgUp9VVv9SCPEE/AWLxGlIns+SPIQDz3xX2DrQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p+VfobYhpd4+88TalgWqSVlDnjfyeLdNmxIpI4mn7YWaUX7b1WGpunFhjzRnVrWA3sXH1up2pqyPnTJxRdjhArWk+d/Sx5hEMTUUdkG02Fj070wy+Niaexg7KPL0MPh0vB0qHtMr8tf1SzEAH7exMmC9hy9OOnyzIXQXDmnBT48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SrdSG6VY; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SrdSG6VY"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43cf89f81c5so796435e9.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 26 Mar 2025 23:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1743057810; x=1743662610; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OYQRSLDDu+9ncKrO0EiMnXhUcVzXwRWAsy/yjivhkeY=;
        b=SrdSG6VYn/0xisC6lOk6/V0KxhMoHnQaK5cAgbhFXtUMW1kaKEOdZAwBPf0EBxFHTK
         OWcXUZEVVsFt/Ywr4HiIPhunid2AYVLRQ9nkoJd3L2p0FEe09ZJ/jazfOPEJ5L4kdRzT
         H3uw8rxyNU62UHcLlCP5ZgNSvNp7hyTp08X9zSAJBB5rlXQdktcQ6PKJg8ZMw6XTnKR2
         Sc0b0PJG1G0RNi17vd0Vl00i1M05Q8tJL7HGuPOCCSffk401zcWQMQLwwhT7HKzojvl7
         xEmYuBsEjrjrI7Ch8XigxyhngB4ItsulaMUqL43ZCYgS0DMVhlXVVRZPWgagUrsVOEtm
         ckqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743057810; x=1743662610;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OYQRSLDDu+9ncKrO0EiMnXhUcVzXwRWAsy/yjivhkeY=;
        b=TbSvTE9+EZaPnqRoGv8HM+3wLjpDo1YrZHEK3EcCo9qsu9At9v36BiJ8gLKYjFhYL2
         yLcxyP3lL39XEstGdfOezIxlo4tpnr6QtHcCtzbE+D0wNMsuDM0IQOBwEfkXIV2lmKtQ
         6cXXFnnymD4PRrebKN8typSFOHQibop5k2ZvTioZ/5BPAZHfMTKn1caIZ5pk9gMH8/SV
         CVXH2igUeGMBQgA5UcE1Isugq6jbdVtcSGfXrD3y7c3Sag/HPAFtfdHjvxCYTr2IUOPg
         ZJZL2J9idAPqOCKd1DBM7WjezYRue+3gtZT9lRX4M2OK4VOjkbkcQbmXYc/BlXAyIi4N
         qQKQ==
X-Gm-Message-State: AOJu0Yy18Uy+RaEaocfxeXr1N1OvJuEYPq2mz2ypQeWBnS/xWIrFcNpX
	D0m5MHOp5c5WaYctc3ZY2aezSgVWUbYVM02qWKufGBMmcwqkIq7JVjEwGlWyBvM=
X-Gm-Gg: ASbGnctenY/tj7KudLRnvxkSS7Do1FePO/W8qt2t2WTG1dkxmBpxz2CR+kB2SvD0rv5
	vQC9GuTcweQrT4Bm6PfIIYwpxSuoZMfTyxvXV23a9iXK4+W5et23AlZF0ZiPBxf2n5YwPNou5oN
	kV9/H3Pw7kKpygr1qkW0JBsikjF0dfkSYXfJjGB/jlx+SVn0NbTxXxVVaqSMd+wK5rRzp+dS7VN
	hJwgqvgwTFGRC4ljRcT1Tx507OW5r6I3Al2eBpdDAnGgYkGOGIqJTKsf1AqKfyHM9qI8ak7Wn+n
	xxLNXK+y4fwU5FMpreQDiWcDqgbhSRWusEHRaa7xoiMRJY4t4ZhYtU/VKGiHvw==
X-Google-Smtp-Source: AGHT+IG7uoZZ4cy3JAa+yLXGMZkwdOi8KblqHkzfjjsnlqCUlO76I+Ifh2Yz3Zl2jw/WLzCs0lckWA==
X-Received: by 2002:a5d:47c3:0:b0:382:4e71:1a12 with SMTP id ffacd0b85a97d-39ad2ada142mr343227f8f.1.1743057809776;
        Wed, 26 Mar 2025 23:43:29 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f4d5f5sm121269285ad.79.2025.03.26.23.43.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Mar 2025 23:43:29 -0700 (PDT)
Message-ID: <faef812f-0adc-4a46-951a-5453927c2819@suse.com>
Date: Thu, 27 Mar 2025 14:43:26 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fixing global bitmap allocating failure for
 discontig type
To: joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 gautham.ananthakrishna@oracle.com
References: <20250327062209.19201-1-heming.zhao@suse.com>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <20250327062209.19201-1-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello list,

I wrote this patch based on Gautham's patch code logic. Because I lack a
test script to verify this patch, this patch only passes compilation.

btw, another topic (unrelated to this bug) is that ocfs2-test fails to run
on the latest Linux distributions (e.g., openSUSE Tumbleweed). I am focusing
on fixing this problem, but it requires some time. I have created a personal
repository [1]. Once I finish the verification process for ocfs2-test, I will
submit a PR to the upstream GitHub repository [2] (the suse-py3 branch).

[1]: https://build.opensuse.org/package/show/home:hmzhao:branches:network:ha-clustering:Factory/ocfs2-test
[2]: https://github.com/markfasheh/ocfs2-test

- Heming

On 3/27/25 14:22, Heming Zhao wrote:
> The commit 4eb7b93e0310 ("ocfs2: improve write IO performance when
> fragmentation is high") introduced a regression. In the discontiguous
> extent allocation case, ocfs2_cluster_group_search() is comparing with
> the wrong target length, which causes allocation failure.
> 
> Call stack:
> ocfs2_mkdir()
>   ocfs2_reserve_new_inode()
>    ocfs2_reserve_suballoc_bits()
>     ocfs2_block_group_alloc()
>      ocfs2_block_group_alloc_discontig()
>       __ocfs2_claim_clusters()
>        ocfs2_claim_suballoc_bits()
>         ocfs2_search_chain()
>          ocfs2_cluster_group_search()
> 
> Reported-by: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
> Fixes: 4eb7b93e0310 ("ocfs2: improve write IO performance when fragmentation is high")
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>   fs/ocfs2/suballoc.c | 14 +++++++++++---
>   fs/ocfs2/suballoc.h |  1 +
>   2 files changed, 12 insertions(+), 3 deletions(-)
>
