Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D84BDF53
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Aug 2024 07:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724138135; cv=none; b=UI1d34/0M/P/gIXo9kvheKKzMn578jazABZQQ32kJN3o475jH63EHSpI9QjHWR3tudfe629G5qhmWnQnuBrAdMUvU52qzZzxtKuIPt9gz1lutz6ny1Y9K2XXLKx08xBzeQsL/pAbL+hu6loDgE+/H3dwBzICzTBWnfFSinuKoTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724138135; c=relaxed/simple;
	bh=2iyxmBwE+Dhna9XByPTzsauwyf2HIFCEXZhVnfkCnNM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SQ86cCTqyHTKxJiWhtuFV7yrX7SklBvQ+Gz1q/jCPtPVVyshv9YJwody2b10FORFDLX8wtJjf8juFihTMoime2dOqiRbnYr+7H+wuSlEZYhC4IhNhVX2RdyJEX1mGPpZRnX/Ps0403Bmj5W06XAiCbbTaZ+dcgS5uIBs918CDmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ebL6rSHD; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ebL6rSHD"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-371893dd249so2735872f8f.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 20 Aug 2024 00:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1724138131; x=1724742931; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yYmRAALLdtRDEwzcXRpN1JVYbuII2jz/aV++mavgkqo=;
        b=ebL6rSHDj1jmuQd55wBNdXf48n3X3Ylcn1n9bWxHZfmgUAnGoqJOOfCtbsC03xg+4m
         uCL5OOkmFqF040vSsV3Ugu7RPBYvhdbn7Icb/c62O01DlOmAwIdnKU5pyV5PJ1gu364x
         PYATdRmtih4YJ1IXyubn/15CzkEcfcGO00D+KAIYppkssdBfwpe8UjCgKp7J/eG/N0wD
         YF4zHoKRXjfnORWMNl747w1Jjl4MY948qt2FuPyWu6pf3Yhw184QEqm6acExIUAVGd+w
         EpraQUae4iB+1IX4yBjN7JzVl/3YFwQSGZ1vmK1H4eoEI9f6bJ90h+W9oc1kclS/44Rn
         2Yyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724138131; x=1724742931;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yYmRAALLdtRDEwzcXRpN1JVYbuII2jz/aV++mavgkqo=;
        b=lIoGlabIs6B9nMZzuu1R//omuOEHd/lIQop7FyUkK8GJva+yxiX1RABkAYdCWjZR7p
         mFc95mCf1EYiAP/Jrxodqu7G/ZaiOUzlWmHaqEbJw0NmBt8GMHkfxgRC2qf9eLvGcyRt
         cJHKZ/MF0T743MC7K//6XMJeoVbTXT2zcd0Yt0i62qjgYEWhGNb/WJ9wEnaW/bsjbzQ5
         jhSMcYx//VsakDFoiHvEyd0MeePITIGjXjKPkPJRNkXtBDV/PBSKfDs1cq1Ds1QkRsf3
         6hFr/fN5cef9qV+k8bdSA0Qo2BzI6w8zg/pWP68DGP9VVsr2G9dhdXATv9iJQ5lBnrst
         dKkQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdooGUllQnzvFTtMDzzhLa84YKc25xsHJBZ075sakNmddaGmCidobD8nLeOdoMG8/SYdNhWUrH5gATZA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxhkg/8J0DHzfSum7ogGaTa8Rk8bw3wlEo/rtcuVvFiYCD3JxKJ
	MbGVr8kcoer1e44uzqLnd6HLzTCIqmwr63Y4wfhMtHrAmkY24tF/NyLARUQD87w=
X-Google-Smtp-Source: AGHT+IHLxDvudl34MzQn/Jyw7XR+SaCk77UNwaeIDhFNTcRpyK+SyTtix/ir08jgvJJk0WfAJX/oXw==
X-Received: by 2002:a05:6000:124a:b0:368:4626:1327 with SMTP id ffacd0b85a97d-371c5fcaf67mr632387f8f.23.1724138131094;
        Tue, 20 Aug 2024 00:15:31 -0700 (PDT)
Received: from [10.202.0.23] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f02fff81sm72327425ad.11.2024.08.20.00.15.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Aug 2024 00:15:30 -0700 (PDT)
Message-ID: <2d6499d6-fd03-43d8-9595-5babfd82481d@suse.com>
Date: Tue, 20 Aug 2024 15:15:26 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 2/2] ocfs2: Fix uaf in ocfs2_read_blocks
Content-Language: en-US
To: Lizhi Xu <lizhi.xu@windriver.com>
Cc: jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev,
 syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com
References: <2e662cb6-47d9-4bbd-855d-1f6d5edb8633@suse.com>
 <20240820065511.996453-1-lizhi.xu@windriver.com>
 <20240820065511.996453-2-lizhi.xu@windriver.com>
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20240820065511.996453-2-lizhi.xu@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/24 14:55, Lizhi Xu wrote:
> In the for-loop after the 'read_failure' label, the condition
> '(bh == NULL) && flags includes OCFS2_BH_READAHEAD' is missing.
> When this contidion is true, this for-loop will call ocfs2_set_buffer
> _uptodate(ci, bh), which then triggers a NULL pointer access error.
> 
> Reported-and-suggested-by: Heming Zhao <heming.zhao@suse.com>
> Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> ---
>   fs/ocfs2/buffer_head_io.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
> index e62c7e1de4eb..b4a76f45253d 100644
> --- a/fs/ocfs2/buffer_head_io.c
> +++ b/fs/ocfs2/buffer_head_io.c
> @@ -384,6 +384,8 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
>   					goto read_failure;
>   			}
>   		}
> +		if (!bh)
> +			continue;

If you like the style of the above two lines, put them after the
line "bh = bhs[i];", or the code below is more concise:
```
                   * completed. */
+ 		if (bh)
   			ocfs2_set_buffer_uptodate(ci, bh);
```

Thanks,
Heming
>   
>   		/* Always set the buffer in the cache, even if it was
>   		 * a forced read, or read-ahead which hasn't yet


