Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA18946C
	for <ocfs2-devel@lists.linux.dev>; Thu, 16 Oct 2025 02:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760581366; cv=none; b=K9SxSI6yRq86q9R2NfZeUZWt5cMvIG/SgwjVDJFWWnq8qcWE0vYXMsH1o06AmXY1m/s2ETCUMugGJ27NYimXtPetJAEojLeXsMuAdW6C2EdUP2uaCD30Bx2XwLARq3dMf9eXVn9SjUHlIpYlsh3hw4DCsn33rpzAK0SfXl8Ymxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760581366; c=relaxed/simple;
	bh=DjFMOqTJdGz2ALQVc/zOl4bS75JVickU8pI1Jj6PNyg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iGQsOl3SJdtK73ZEBXNzV5Q3mwWZejZ2FFAAzvCTwWumcn8EPX78L9+8SJTSAx+0gA/Ntp67EaPpz/Ss+b7uwifXO/jqq82Zig60OT2JUq5MuTp//iokF3xl+Rp5LmDPjYUdyR1Uc4g3eATABI1MaswIgWUSuFitoL2ElDxEr68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SO+GljSe; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SO+GljSe"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-401ce0cae36so13652f8f.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 15 Oct 2025 19:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760581362; x=1761186162; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2uS8bfBhOyVrU+c04z3SvKj2gVbAxdtxi3q8QGsK0TA=;
        b=SO+GljSeusZstiaCofc3ikwTJwjlvVnTw+1lSMCP9rKHtHOVp50v8txpMdAYf04RyD
         aX5serzLk1eVfu5xRpKtU3wI6/KsXCcLJtpIUItZOiRG2tevkvnIcH41CzZcwrpnmEur
         8bENg8MndXKZXJMrYFXUQHeqkCJhJqjoIMp5bROC8KWpMhASGlNROxwRt1Q+fDWaRAeP
         c2Oha+xgUm0d1q5sOZ0MHUDXXtBbSM/kYbtuWWxh2tx5xNvvLHZZVOsyS/eDTwPtwoEd
         O82j3h12m0YlzTH5cI3ROR5FeBVpso+hAstLhm/ibp4ifhTmZ65DTOaSJYyjWzA7VYAJ
         HqLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760581362; x=1761186162;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2uS8bfBhOyVrU+c04z3SvKj2gVbAxdtxi3q8QGsK0TA=;
        b=h43UFctoyJegpWDNktDohr/DH//mLGerSHZ2Kx5vemO5jBGJ36sRejSTMAWTdrVPT7
         vLoq8KwVW2uwC+eyDZ0u6Vt2scRMVUOr3wMJp1HOpdWpaVIFfR5eDUhF++3P9lHQeXfP
         7D2AiEcmaQLdc5fH5Z2rRFvPPa6yB5NH14pWbdAZV2YMSFufm5f5tC0sdTW8lmtzrOm8
         xAjw3c4tULS/lfWjuNBj6rJTp01GwEJNZ/o2r7W0f9+S445LGOlwlCgmwUjvMz1PUdWM
         Du8cvMVofEj2Gsoqc4PVgkIzXq6bijEeFy3OCaj/KejL4JXNfVlOEB9XuwW0GXt1eVNk
         SCkw==
X-Gm-Message-State: AOJu0YynG2IQceVJQ4ZFqgfGG4ev+ize6iA9J2f5qmy8OuuTiodmGpIQ
	YevWhlq0R6TYqNKlb/s0KfvwktolAtInnRNcZoYYzJp7xh8zflEBovSmM2gNHxFHz+Y=
X-Gm-Gg: ASbGncsapHoZlOT8P2aVr/N/DPGrJcJnmlm+f4TcbkkE44S5IqUMbdrsXLypM/nL6pk
	6KJvZJ7wSL3PnZnAowdSWycZBsNepVphxK1Qlz0O9AuCMHbZiNblHKnajJvrZAtZR+jFPjjd/TK
	bWHegWFvZw4RhiWQIfN01vCeSHX45Sgb56NK44IQSIdTxKwnei/HOO44u0BtR16NrU8BBlv6vg+
	oC2con04hZeQYUSZSsVp1bHaqZsOrKicamcwELZtlrOILwQVLrMWQIUN4iPJWyYzwE53lSSehiT
	AkIuMke32lKx5utuCttfT8N7XRN+xYpTkxtJjoqO+FfRLHmaMLDDbQWbZ2+NeBGK5OPhmg31a+f
	oNxziMD2fJCES5wx5CTBkyQei2g1rQrH6RbIiKXLcqkHRQAdVNq0zRmc0eoKd6z/f2hXdu/BU0X
	W9IelPWPI=
X-Google-Smtp-Source: AGHT+IEYq0KiiFHzmYpY7pvjgzWI2Xh2EGUq/4LqFXPBVNBYtfrim7z9Rsuf8S1WghuIXoCvN5ztdg==
X-Received: by 2002:a05:600c:46c8:b0:46e:46de:ebdb with SMTP id 5b1f17b1804b1-46fa9b1b132mr130368115e9.7.1760581361776;
        Wed, 15 Oct 2025 19:22:41 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29099313b28sm11193995ad.3.2025.10.15.19.22.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Oct 2025 19:22:41 -0700 (PDT)
Message-ID: <2d6351d4-c753-4a95-8036-95c991524de6@suse.com>
Date: Thu, 16 Oct 2025 10:22:36 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: add chain list sanity check to
 ocfs2_block_group_alloc()
To: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+77026564530dbc29b854@syzkaller.appspotmail.com
References: <20251015064837.281929-1-dmantipov@yandex.ru>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <20251015064837.281929-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi

the code logic LGTM, but there are a few minor issues. see comments below.

On 10/15/25 14:48, Dmitry Antipov wrote:
> In 'ocfs2_block_group_alloc()', add an extra check whether the maximum
> amount of chain records in 'struct ocfs2_chain_list' matches the value
> calculated based on the filesystem block size.
> 
> Reported-by: syzbot+77026564530dbc29b854@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=77026564530dbc29b854
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> ---
>   fs/ocfs2/suballoc.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 6ac4dcd54588..99eb651d5593 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -671,6 +671,13 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
>   	BUG_ON(ocfs2_is_cluster_bitmap(alloc_inode));
>   
>   	cl = &fe->id2.i_chain;
> +	/* If these two doesn't match, the filesystem is most likely corrupted. */

Since the sanity check explains itself, the comment above is unnecessary.> +	if (le16_to_cpu(cl->cl_count) != ocfs2_chain_recs_per_inode(osb->sb)) {
> +		status = -EINVAL;
> +		mlog_errno(status);

As mlog_errno() is handled in the 'bail' section, we don't need to repeat the same task here.

Thanks
Heming> +		goto bail;
> +	}
> +
>   	status = ocfs2_reserve_clusters_with_limit(osb,
>   						   le16_to_cpu(cl->cl_cpg),
>   						   max_block, flags, &ac);

