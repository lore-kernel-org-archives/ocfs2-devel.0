Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8A9386
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 Mar 2024 02:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711593400; cv=none; b=GTqYZuTmbLAdGxgH8GgZEQYDFXQU8dEWBKFqFJwcIGNwbhLFTUK1Bj1odJcw1ogZGb1VBvu1vULRg5GuH/VM/hyaVEZE0Lpht7GADvZC/ZlV99iLrdK3JzSGl+uBQ1VAU7CaCD3guIaWOE1Hh1ZeiU08WXhoaheq4s4flSl9q38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711593400; c=relaxed/simple;
	bh=WBwSwmxbOYL8bhXkYWIsVwoTaEylsSyPyOVRR4KH8Fc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tjdIljPI0617pOfuf9OG/VNLPnySvysEdshjJhmCP9ZuQ16bI8RzWKN5NMYHHqKnY9fOME56NjYs+NntYtIe85qzmgVT/j9kgbvc1gHwwwLv2PlbhJxTTYuEQn4q7+Ur19GbDm1TfLjgojkadFdtEPyJyPcx0YM0arXLKutd3EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Adg3V+/9; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Adg3V+/9"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2d687da75c4so4648951fa.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 27 Mar 2024 19:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711593395; x=1712198195; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DQkq/RbaDowI2ybr6cEIpebBuMB/ncoDwgo8YxM78B8=;
        b=Adg3V+/9Y+8m5tC0sAM7fAlFm1bCieR+wMNr09wozO/OdXFYUPUFBEb+3lhH38SCv/
         nEe4aB9c2YMV39f89b3qaBwxIVCJR5SnGLEAxKLL/CJfffg6zSNFJ9IOkO/v3t8oe9Ho
         cmC/UuI5EuEfloD8c6D1n0yE3nZALoAYY9q1sv1xC6cZi17I8dD9wiVV25t1tzaVBE7Z
         3oJQ6ju3/jo/v2OZ85iEoSgmDU1F4uA2ydMrhR9zlC1GydWEZnPAo0ucJhE4m0yXrluF
         FFaZd/Emo7XImPkmR4MuoYgffU4u2QzDAYJD2lPED6T/8tSh26G8M2hOS3L7RSV05xjd
         +P7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711593395; x=1712198195;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DQkq/RbaDowI2ybr6cEIpebBuMB/ncoDwgo8YxM78B8=;
        b=btPZtbIi5pqefKvYLtHIreqo6bff9BrNPW2mHjcfzkAFhZXCd/KnBxXFnuyrqVte+0
         SyS8hPYpThcs0e79L3SW6n7qjFLpLnD5Qym2uLLh49aYjJ/yArV3d5T5Qrt04wxa6QwX
         Dk5DVyhWVO6M7M4EY/+gB0OFHfZVxOH3Be3J3ED+O4f41psYh89RRMGoMMhxQGoyc3aA
         UP62yURPHst3wD16m9Bha8oUmq0mibdtqb/ICR1PpWpnslK1vVmwd7CDtQBN9398DKpL
         Z8n/TB4xlqlaOeAKZYw7ztjt8LOdS0zNHRDzNi2njfRc4qYlBsmQk9k/0pKQ3hTca4AY
         7BjA==
X-Gm-Message-State: AOJu0YzJo2rOZi0lug215AFhOiuYTEl5la+J9SMNKr8BxxF83lbk9i5N
	IlEx5R0GHh6bR21RSZRpCHOuni9tq7g2veNp8OQmAZfUR3K1G/cG89kVLJTiZts=
X-Google-Smtp-Source: AGHT+IHc331Fy/zVjM35c+ZddpeZ7/xmnZZ4+D6j7r+cGBGj7dyC0XqSzib3QSEJ1u3If9qKh7rBfA==
X-Received: by 2002:a2e:b80b:0:b0:2d6:f5db:4d6e with SMTP id u11-20020a2eb80b000000b002d6f5db4d6emr693874ljo.40.1711593395281;
        Wed, 27 Mar 2024 19:36:35 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id i18-20020a63cd12000000b005e438ea2a5asm216426pgg.53.2024.03.27.19.36.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Mar 2024 19:36:34 -0700 (PDT)
Message-ID: <0c640d4a-295a-4d5a-8193-6d5b936836f8@suse.com>
Date: Thu, 28 Mar 2024 10:36:31 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] ocfs2: adjust enabling place for la window
Content-Language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, ailiop@suse.com
References: <20240327082146.6258-1-heming.zhao@suse.com>
 <20240327082146.6258-3-heming.zhao@suse.com>
 <326496c2-ab47-462d-87ca-bb98aa796dfc@linux.alibaba.com>
 <b7879679-e0e9-43e6-8cc8-1fe3014363d5@suse.com>
 <b6038cf4-9966-47ad-b3e5-e0ad76270deb@linux.alibaba.com>
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <b6038cf4-9966-47ad-b3e5-e0ad76270deb@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/28/24 09:58, Joseph Qi wrote:
> 
> 
> On 3/27/24 8:59 PM, Heming Zhao wrote:
>> On 3/27/24 19:05, Joseph Qi wrote:
>>>
>>>
>>> On 3/27/24 4:21 PM, Heming Zhao wrote:
>>>> After introducing gd->bg_contig_free_bits, the code path
>>>> 'ocfs2_cluster_group_search() => ocfs2_local_alloc_seen_free_bits()'
>>>> becomes death when all the gd->bg_contig_free_bits are set to the
>>>> correct value. This patch relocates ocfs2_local_alloc_seen_free_bits()
>>>> to a more appropriate location. (The new place being
>>>> ocfs2_block_group_set_bits().)
>>>>
>>>> In ocfs2_local_alloc_seen_free_bits(), the scope of the spin-lock has
>>>> been adjusted to reduce meaningless lock races. e.g: when userspace
>>>> creates & deletes 1 cluster_size files in parallel, acquiring the
>>>> spin-lock in ocfs2_local_alloc_seen_free_bits() is totally pointless and
>>>> impedes IO performance.
>>>>
>>>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>>>> ---
>>>>    fs/ocfs2/localalloc.c | 15 ++++++++-------
>>>>    fs/ocfs2/suballoc.c   |  9 ++-------
>>>>    2 files changed, 10 insertions(+), 14 deletions(-)
>>>>
>>>> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
>>>> index c803c10dd97e..2391b96b8a3b 100644
>>>> --- a/fs/ocfs2/localalloc.c
>>>> +++ b/fs/ocfs2/localalloc.c
>>>> @@ -212,14 +212,15 @@ static inline int ocfs2_la_state_enabled(struct ocfs2_super *osb)
>>>>    void ocfs2_local_alloc_seen_free_bits(struct ocfs2_super *osb,
>>>>                          unsigned int num_clusters)
>>>>    {
>>>> -    spin_lock(&osb->osb_lock);
>>>> -    if (osb->local_alloc_state == OCFS2_LA_DISABLED ||
>>>> -        osb->local_alloc_state == OCFS2_LA_THROTTLED)
>>>> -        if (num_clusters >= osb->local_alloc_default_bits) {
>>>> +    if (num_clusters >= osb->local_alloc_default_bits) {
>>>> +        spin_lock(&osb->osb_lock);
>>>> +        if (osb->local_alloc_state == OCFS2_LA_DISABLED ||
>>>> +            osb->local_alloc_state == OCFS2_LA_THROTTLED)
>>>>                cancel_delayed_work(&osb->la_enable_wq);
>>>> -            osb->local_alloc_state = OCFS2_LA_ENABLED;
>>>> -        }
>>>> -    spin_unlock(&osb->osb_lock);
>>>> +
>>>> +        osb->local_alloc_state = OCFS2_LA_ENABLED;
> 
> Seems the above should be along with cancel_delayed_work()?

Good catch! My stupid mistake.

-Heming

> 
>>>> +        spin_unlock(&osb->osb_lock);
>>>> +    }
>>>
>>> This makes checking osb->local_alloc_default_bits outside osb_lock.
>>>
>>> Joseph
>>
>> I known, in my view, osb->local_alloc_default_bits doesn't change
>> after mounting the volume. So, using osb_lock to protect this
>> variable is pointless.
>>
> 
> Okay, it will be only set during fill super, so I think it's fine.
> 

