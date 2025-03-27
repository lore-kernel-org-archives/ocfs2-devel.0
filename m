Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7082262BE
	for <ocfs2-devel@lists.linux.dev>; Thu, 27 Mar 2025 06:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743055786; cv=none; b=YWeHWa60FApCnDdM7T8o5Ao8f1YuaC0SgDQOE+9ad7e388ADzHJBJ3AMf/a0eSzX58MUJsDIzY9r2uA8TN0P9ZRgKgg4xFt+B/+CJ16lrdeywLsmlGDepsbW8w/MxWz8CwvYo63SdUdr+iPqrt+UPIcrkf7fqlsN7/SfA5nozsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743055786; c=relaxed/simple;
	bh=uvkcYrknQHKPV0dudUcYVvBBCVyrTONRTWEpan0+x/M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RvIHbLnpJqZAbfPTVwxqyg3evwAea7doXfLLYnjuegSe2068PHuQhmUrUxwks3iFhY5S9+sA4pvFY2I63yMTgxNl02Hi1h+roPHbNWml17FV3Eehv4Ls4klMzXQEg7lMRz7g5p+Mgy/Rmlppgr3vCNLo21f5Qwl6+i4sidcbqJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aD1bXfIR; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aD1bXfIR"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-39127effa72so49435f8f.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 26 Mar 2025 23:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1743055783; x=1743660583; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HM7gFMQ5jRKrlxt7NfSaAhYPHmSzldvP/qg6bOXGtLE=;
        b=aD1bXfIRRHc5MUbgu5jCJHn6viwZ6hrrLHy40ViJqc0pGMK217QbqwfLu4pcmVR1j0
         4gtpSnKsVbrwaiTv3LJ2i9xL0+hgs1tUELSKQB35qDqIKLAeWxEUZkHiuoRWEPSKV+wx
         UOKv7VQXxihf4UftvLHAfDGY2U3gjJk1yMiEPiQHh+8wr+9ztpl1Kkb+eka3YX2fYaNa
         bW5Bt4K/LxsEfaxZPQyrpsvBqHkMrpuRVYYTshgpDDC7IfdpIWFtZWng2cVpTrxf/4Hf
         B2C2gQdU+kgv40C9tE8YoIf914t0Lv97wkFF2jpM84OWf4n7irpwc0uyuNlR+qM1E8Gz
         s5GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743055783; x=1743660583;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HM7gFMQ5jRKrlxt7NfSaAhYPHmSzldvP/qg6bOXGtLE=;
        b=SsmiCKipGlRKKHsWQorQ0wmHXpWbi9YWDPqcd6OfceHPkE5BpjZ2c1rY1yAbKEHTqJ
         h3OM3bDnuXPVsU7oppIo/b/KgZd1jzC9BtZ2RKXRpMm5bt3AX3a5gOWB60P7yF/mt1H6
         Pxyso9w8Fa5Y2VEgvcESjNOWa3quYurBCZSe/cnD+ybrGDZQR/FYqPidcZCQBVb+sywA
         GVs489U9WhT5DMVt+Mwx8F57psoK2w6ldiFAJt3gT/O1RSZQ+k3nH6D4dnZWjeALWTj6
         U6nVNabIfM2XS9nBVxKIM0nBtv2IxqVds3dYjGH6Ub5C6hdT8QPnIkXuvcmYDHJRUk6q
         BWyg==
X-Forwarded-Encrypted: i=1; AJvYcCU5dJDCbImykM0H4NVu7330AZGnp3yVyQXrvLDE/A7M4c6GmUu6J05DdYeFN2bNJQkR+9zWOlyIydK4Ig==@lists.linux.dev
X-Gm-Message-State: AOJu0YzGCa2rgaCbKL+HaIzS495XilhrtTwyvePyJ7uNgjVp0ii3Qyfw
	J2d8YmPhOwURu7FmabQBSd+5l87nIK80mIkItO04Kzfo+kjKBFbUSaSbZIoOYao=
X-Gm-Gg: ASbGnct87Xl7svbLK2ivNONDskev8mau7zDRtJ9Uw2qloYM68pC8WYUupNW3I9hNeM/
	O26guB+TGYGPDXzFLj54Mj/OPCJXPfD2M3LojU8+X7j3vOwHwKejQjYjnL6osT9ElBYiYGL0jqP
	3BIA8skPFlMXhudONJu0OFKRv7a6InoVUyF0jPTHSrE3Ts7g7ZOTlkzuOOWcabjjuDwYFLBm6tl
	4BdKrEKLCpzf6v9TzJDgHKFFPUeeqZd8CHsVo8i57eZzrNz4RZgbCAoBpGt568H7LOB7dY0z0Ss
	d7pF77sKb5FwZEnyFGIOPkcM5Tm1kesEDEskypP/ksv5knWSC7YJkS66V/ly3w==
X-Google-Smtp-Source: AGHT+IFBpl13uznEPbpL0leSZsm5pJwcTCvF5mI/ucN0wAkZbTaUXop/xETfBhOfiRHhHsmgfUqsMA==
X-Received: by 2002:a5d:64a4:0:b0:391:2b54:5f9e with SMTP id ffacd0b85a97d-39ad2ae2851mr353949f8f.6.1743055782988;
        Wed, 26 Mar 2025 23:09:42 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f3b3f2sm120411865ad.29.2025.03.26.23.09.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Mar 2025 23:09:42 -0700 (PDT)
Message-ID: <199205d8-20fb-463d-9065-8021b3cf7cb8@suse.com>
Date: Thu, 27 Mar 2025 14:09:38 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/1] ocfs2: fix write IO performance improvement for
 high fragmentation
To: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>,
 joseph.qi@linux.alibaba.com
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@lists.linux.dev,
 rajesh.sivaramasubramaniom@oracle.com, junxiao.bi@oracle.com,
 akpm@linux-foundation.org
References: <20250324054851.2509325-1-gautham.ananthakrishna@oracle.com>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <20250324054851.2509325-1-gautham.ananthakrishna@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello Gautham,

Thanks for locating the issue and submitting a patch.
Is it possible to share your test case for this bug?

The key of this bug is ocfs2_cluster_group_search() comparing with wrong
bits size. I have another fix for this bug and will send it to this mailing
list later.

Thanks,
Heming

On 3/24/25 13:48, Gautham Ananthakrishna wrote:
> The commit 4eb7b93e03101fd3f35e69affe566e4b1e3e3dca caused a regression
> in our test suite in discontig extent tests. Upon troubleshooting I found
> The following issues.
> 
> 1. The function ocfs2_cluster_group_search() was called for discontig allocations
> as well. But it checks only the contiguous bits 'bg_contig_free_bits'.
> It hit the ENOSPC in the following case in one of the tests.
> 
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
> Looked like the commit did not consider discontig searches. To fix this,
> I have split ocfs2_cluster_group_search() into *_common(), *_contig() and
> *_discontig()
> 
> 2. That commit enforced ocfs2_cluster_group_search() to search only the
> 'bits_wanted' number of bits whereas ocfs2_block_group_find_clear_bits()
> fills the best available size and the function ocfs2_cluster_group_search()
> itself is supposed to search 'min_bits' at the minimum and need not be
> 'bits_wanted' always.
> 
> Fixed the above issues in this patch.
> This patch fixes 4eb7b93e03101fd3f35e69affe566e4b1e3e3dca
> 
> Signed-off-by: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
> ---
>   fs/ocfs2/suballoc.c | 146 ++++++++++++++++++++++++++++----------------
>   1 file changed, 95 insertions(+), 51 deletions(-)
> 
