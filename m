Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4568836
	for <ocfs2-devel@lists.linux.dev>; Thu, 17 Apr 2025 04:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744862992; cv=none; b=jysj9rmAsrhe5f9hgQst2qeKS2TXAHDUR6UrHZV4b1r6VUcF/RNehE6OfEhj0JKB4FrLH2VH1jkD9T0rgT5h8AkGuiXd6kfFUDSqYlasJF1UW4vtlOiGjNF/njRI9nIU0J5SwQY/JERGmoNscLDIJ8/fP7WDLXkCe7WlPOfGXoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744862992; c=relaxed/simple;
	bh=0APB4Z7PYCEtdumoOideDwwUmDkWYhwO6Nq5BUWshck=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qqm8yo4gZ8g0RtSuk6PmnLnUZTHakASG7LKkUYA8CBojKjaAJ22dbhvRvJMREkJma8rHef4sgr0r8nwPzz+qxJd7w0J5/tAE2I6TSI5QnguMILJNFU8TeFir0gy0euFM2zZfQf4Peb7cGuW9DBL/k9Nqt6qkc2pFxjSnGEx/x+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CPF5Mkmu; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CPF5Mkmu"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43eeb4e09b5so559515e9.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 16 Apr 2025 21:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1744862988; x=1745467788; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CmAAgAw+8wjItsnoM1fz7uxksvdaBuvdDr29jpNBkgE=;
        b=CPF5MkmuJdzs/JwkkEOgUyHeFy4+W+/BjmnVpM3FxeQMdatwMtN0MjbgLi1RfLBurj
         lmAnlfaYHq/wsfwL+uTsb56v6HUYtNTQI1xeDrHKcrnj7yCjYtXLEE5HgxpuYGREhkp4
         QGMNFgz0fwe5Gua1uQODm4eVKbhnWkhVnsdsJOtIuL33+V48Q043dyHF+euIFuw3CQhV
         utLtkPZfVJkkFdZftZ1w80+NO0lbic3h33F0mqtYGILBG8PuNIRWRiREl47oBnmEAJ9e
         BnZKzWKavMIdnMzLAPXFaxVht+BQDoHgvy5e7Ns3ZKcNdhfilTu3MdyAhlhYB5GAiiv4
         Nurg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744862988; x=1745467788;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CmAAgAw+8wjItsnoM1fz7uxksvdaBuvdDr29jpNBkgE=;
        b=Bhx7fADiUfZNE1+KMFkpJYhvVcqpXOB6uhbKl71AJRGOutePmkZd9daOogiEFclW5b
         8B1jJbhZOoJI31D1LFe+orGxNnTlhYvY2LDMKdqEnXGzMoa2/FlZEirOSVZcqII6MCoG
         Gfl2daLFFrt5+s/+MY53wZCbBVdEGMtscyQGpWoXXWwrltkue47Whtg590jI8vIjJhEn
         i6QVQHx5l6wwI8nVmiJ3c9o6FMqILBWcUUHcSk+7lWVFi9oy8aVrlLfy1Drzj2SzgXZJ
         uRDP7LTzi3ggHAx7S2f/NlS01xqpxrtizQGbPeIKIjT+Sz21Z6/wyxxar2lfnpkYCJ5Y
         KiEQ==
X-Gm-Message-State: AOJu0YwzUOrTX8xfNUJuSOBdLwsJ72Yj0VgmitVYwRQrDkNjaUup85NH
	CyLOV1qj4CKCq8trM4h4AKU9kz6pypm6lj9Bg4BxaADfKoFmagEk4EIEohvE5Rc=
X-Gm-Gg: ASbGncv/S2Dk1145h8NcYAo+wgmn62aSk9Hf0og+t2lGpcbufuWmTTuoTn86avfTHJ0
	F024GsnH4E2eWpA2RDfvmTHnQC+v5ttUD7HTNocRzQIX8EjQ7ZfVIbhyb09rz6jnS4cI36i9oTi
	MmoilTBLyFIpTxpamtLemyjWnZGp1t+BFx0pIwImdsLZb9dgbVp7ZsuG71TFQDlYmiPWTDeD4fw
	xi7wqUHXCfK70i9F0tJo400MiLFvrCkffCohiq+h7n1VzZmTckyt1GDiYO6cw5kqeEnYOD+sUxO
	NcFSTeNMaHZtJC1fqB9zU8cTUAv4Ma2soW5FUC6eXJfEcZk=
X-Google-Smtp-Source: AGHT+IF/J6KQSYubSxQVK5CyK3J6aeW5I1HGlC0IkrD8ovhYxzyitf5uwoYd2f5CHRYfTlmeYJxVZQ==
X-Received: by 2002:a05:6000:220d:b0:385:de67:229e with SMTP id ffacd0b85a97d-39ee8ff518dmr502594f8f.11.1744862988085;
        Wed, 16 Apr 2025 21:09:48 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73bd230db00sm11666687b3a.130.2025.04.16.21.09.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Apr 2025 21:09:47 -0700 (PDT)
Message-ID: <9ad1e16b-8537-4161-84a6-6f2b4b37dc1f@suse.com>
Date: Thu, 17 Apr 2025 12:09:44 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/1] ocfs2: fix discontig allocating issue
To: joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 gautham.ananthakrishna@oracle.com
References: <20250414060125.19938-1-heming.zhao@suse.com>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <20250414060125.19938-1-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Joseph,

ping...
I see the previous patch was dropped by Andrew, but this v2 patch
is still pending for reviewing.

- Heming

On 4/14/25 14:01, Heming Zhao wrote:
> When running ocfs2-test, I found the same issue [1] regarding
> discontiguous extent allocation. The previous patch [1]'s commit
> is incorrect, and the fix code is insufficient, so I am sending
> this patch.
> 
> PS, there is an ocfs2-test PR [2] pending for review.
> 
> [1]:
> https://lore.kernel.org/ocfs2-devel/1f3049dc-5536-4a27-8768-b264be062f7c@linux.alibaba.com/T/#t
> 
> [2]:
> https://github.com/markfasheh/ocfs2-test/pull/21
> 
> ---
> v1 -> v2.
> - we will recall patch [1], so this patch merges some codes of patch [1].
> - polish the 'if' condition in function ocfs2_search_chain().
> 
> ---
> Heming Zhao (1):
>    ocfs2: fix the issue with discontiguous allocation in the
>      global_bitmap
> 
>   fs/ocfs2/suballoc.c | 38 ++++++++++++++++++++++++++++++++------
>   fs/ocfs2/suballoc.h |  1 +
>   2 files changed, 33 insertions(+), 6 deletions(-)
> 

