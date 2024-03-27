Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8855512F39F
	for <ocfs2-devel@lists.linux.dev>; Wed, 27 Mar 2024 12:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711544357; cv=none; b=RLXF1ELhlvc+T/nFQ1xvWORYxoIabwLpv+Vxj0XCXRmzSP1j3+QLaSv8PI3FcwB7LatALBbIyjdznyy5LKr2xspNpQy/f+6mVc6pjNpbuF/Fzam+apWm7OfS8I39hDZipUV6As7GegvWrcwp8/YNEwKYxkBLbVEm7bWzE8f55tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711544357; c=relaxed/simple;
	bh=KO+yXsc5teydBRvLS+gk3SERZRODBNa7YgDg/kDvqz8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gmWVI6P7pqNWvZMMkmzisTIUMpVdV9/+DIfAn8+x2xQMjLJPQt4QdIZyi7/H7Yq5BagF//0k3ZQTtqoJbIcsYsjEoIa6NXGXkSKTxmCdD/RV4MEdEv3UZw0CfX1W0ZP3quaDLyNaimM81k8A+nIYoz9XJ3Dyg2PP/JFPR/BbR8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=D9ad2TrW; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="D9ad2TrW"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2d6dda3adb9so32426131fa.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 27 Mar 2024 05:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711544353; x=1712149153; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T+9alh8mu/Vm+A2iOd2sV0AMD9J1Khr4w565xx0IY3U=;
        b=D9ad2TrWbdAodBcnsCp65mJ6fxmY3JU7XuOaD+Uc9cLcYKXXkdIpNwt9BCvkHdiFMa
         r7i/qaHdp7DKCUch9VtagyRo2aiZ/H8QOFvGF5akTJqeK626mMsh7sl/0xy+aUPvnRJV
         ZNrldOKH7w2Ja3oPqwtZTGPxFA42GCpnKBJ8svryuT5AICUGJNbPgw2mKtA6MplmEy4Z
         UCxKrD4Mg7561SvYQHKk8AZGSLW1nN+PcukwcEfLWXJ/BHYkKr0PuHrUN61L18digIU8
         BIZ+qhhlugnzyBVhut7sMokt12COW7R4d5EJ8L61s5loe5+8kFPJWfa6EqvM6qGdliyH
         hyuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711544353; x=1712149153;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T+9alh8mu/Vm+A2iOd2sV0AMD9J1Khr4w565xx0IY3U=;
        b=Sm2qsmYat06MHBBfJCysU+4Uui2B3tszgbq8zKfwThFh/3pt54tBtXu0OVDOSZGLCM
         ALWvWQLGbXrMyQ3r5Z4NIVkJIIll4pJ6HCAnO5BGe9WDE5qWWCI16XkR7DilzYlJl+ml
         6mdkLJ+BuK8nq5DmhxpGQZLwuMzw3mjP7kvdIqxnDJ1cqGrwDekVAF12kew7bBnRTAOQ
         uQc0S7AWgLEjnCV0YkS2WWJOM2eQU8Rv9/wOBUri6pv2cGTfW1eE+iFfi9ZIJ+IPO1uq
         ZJWdYVBeOUId72zQDqa6/bPQ5kGxlySjHpoc47prF2apnpM5z9g1xNNdVm7my12wShyj
         AWdg==
X-Gm-Message-State: AOJu0Yx6IP/oOLCxcDaBC8BeS6ribp3c6Tkk+4hI0YhX1yFhNrdi4lnf
	FGfUB8RcsvzEliwUjOIVqTnW87w/JmOxR/hXxp45LzFhnVGiwW1FUidnHIIF6kA=
X-Google-Smtp-Source: AGHT+IHR6TRg1M0nHshdvbuMa5jN0wKzsNA10zuSbk+cGh9dnragqks7K+2ot5r7h1AgdyTiB+Xmyw==
X-Received: by 2002:a2e:7315:0:b0:2d6:ca7c:7e2 with SMTP id o21-20020a2e7315000000b002d6ca7c07e2mr3661715ljc.2.1711544353577;
        Wed, 27 Mar 2024 05:59:13 -0700 (PDT)
Received: from [10.202.0.23] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id y12-20020a170902864c00b001e0f5034e95sm3410362plt.288.2024.03.27.05.59.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Mar 2024 05:59:13 -0700 (PDT)
Message-ID: <b7879679-e0e9-43e6-8cc8-1fe3014363d5@suse.com>
Date: Wed, 27 Mar 2024 20:59:10 +0800
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
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <326496c2-ab47-462d-87ca-bb98aa796dfc@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/24 19:05, Joseph Qi wrote:
> 
> 
> On 3/27/24 4:21 PM, Heming Zhao wrote:
>> After introducing gd->bg_contig_free_bits, the code path
>> 'ocfs2_cluster_group_search() => ocfs2_local_alloc_seen_free_bits()'
>> becomes death when all the gd->bg_contig_free_bits are set to the
>> correct value. This patch relocates ocfs2_local_alloc_seen_free_bits()
>> to a more appropriate location. (The new place being
>> ocfs2_block_group_set_bits().)
>>
>> In ocfs2_local_alloc_seen_free_bits(), the scope of the spin-lock has
>> been adjusted to reduce meaningless lock races. e.g: when userspace
>> creates & deletes 1 cluster_size files in parallel, acquiring the
>> spin-lock in ocfs2_local_alloc_seen_free_bits() is totally pointless and
>> impedes IO performance.
>>
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>> ---
>>   fs/ocfs2/localalloc.c | 15 ++++++++-------
>>   fs/ocfs2/suballoc.c   |  9 ++-------
>>   2 files changed, 10 insertions(+), 14 deletions(-)
>>
>> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
>> index c803c10dd97e..2391b96b8a3b 100644
>> --- a/fs/ocfs2/localalloc.c
>> +++ b/fs/ocfs2/localalloc.c
>> @@ -212,14 +212,15 @@ static inline int ocfs2_la_state_enabled(struct ocfs2_super *osb)
>>   void ocfs2_local_alloc_seen_free_bits(struct ocfs2_super *osb,
>>   				      unsigned int num_clusters)
>>   {
>> -	spin_lock(&osb->osb_lock);
>> -	if (osb->local_alloc_state == OCFS2_LA_DISABLED ||
>> -	    osb->local_alloc_state == OCFS2_LA_THROTTLED)
>> -		if (num_clusters >= osb->local_alloc_default_bits) {
>> +	if (num_clusters >= osb->local_alloc_default_bits) {
>> +		spin_lock(&osb->osb_lock);
>> +		if (osb->local_alloc_state == OCFS2_LA_DISABLED ||
>> +		    osb->local_alloc_state == OCFS2_LA_THROTTLED)
>>   			cancel_delayed_work(&osb->la_enable_wq);
>> -			osb->local_alloc_state = OCFS2_LA_ENABLED;
>> -		}
>> -	spin_unlock(&osb->osb_lock);
>> +
>> +		osb->local_alloc_state = OCFS2_LA_ENABLED;
>> +		spin_unlock(&osb->osb_lock);
>> +	}
> 
> This makes checking osb->local_alloc_default_bits outside osb_lock.
> 
> Joseph

I known, in my view, osb->local_alloc_default_bits doesn't change
after mounting the volume. So, using osb_lock to protect this
variable is pointless.

-Heming

