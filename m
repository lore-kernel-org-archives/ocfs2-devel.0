Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF23AA31
	for <ocfs2-devel@lists.linux.dev>; Wed, 13 Mar 2024 12:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710333141; cv=none; b=Q1vd1qo52Y8Av+M3TCzkCX9w+nU1CLyExR3dyjKYN4obdvLDzGedL9WxKw2p5MG2Yn7DH/kFJm8KfIk9iCgKdBskarz3IZm0+LvYoBOW1RVYQ4dI/iE2Fqm0Zq2nzPqXU1x4Vgmlfsq/WcE+C6oXGlksyiNvEn+MnBse4gl/8Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710333141; c=relaxed/simple;
	bh=vw2eeISNd3Z5BxUXHp+BIluQ7bmkUASCLCwz7CUrjJc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JcUaQ7GS57rGq0Kyhg/Mq/wLYp/s9ar3bgROd93xc4DKwIheTr7ZV0sn24oDEbFnFPEpmNTkhbGyPNJOY3c3KTIgNF9filwZUCRr6qAijEn6PPtabZDKv7GrV/KftbkzSoECOHpdEhqUWi3pRc5lf5MMh5i2aSlSDz/aeujhSfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Mgn/QnC4; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Mgn/QnC4"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2d46dd8b0b8so5658511fa.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 13 Mar 2024 05:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1710333137; x=1710937937; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OSTAbPvYtIZFDmMQUYZPvnC8WctWDpXq5DObcTL3t94=;
        b=Mgn/QnC4XR6HSIzUkoyxaA/pNOWmfatNO0Uzks/3ABIM54smQlRjuo7t5MPATEZW5y
         P1ygUgtHVZA5CNCL6eR2JyybzLHE4QW/m4UHzKaDTkhu0MKuG+0S1pwrKOSSYgwPT+io
         PA4JDpk5nS6ZZ2oH/TFV4Rno/UhCtUaLSAp2hYxLrXy0zppE7gk86u91PJk8MV7n42Xk
         zdlkSndR7yqrSxkglMJj86b08IYmSOl5e2akZo8EmRqP4kf12+c6LYkCSgbamWRYLabx
         15aSq1sVRxBo7oEJ4xIrTdcY9dAyVJwkQ9QKj15tmFAAWP4iQ081gLIhNOSzO2E3xtQU
         6O7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710333137; x=1710937937;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OSTAbPvYtIZFDmMQUYZPvnC8WctWDpXq5DObcTL3t94=;
        b=rKhJ+mM0TDFEGDJCikqJct629vR2DLM7/GzRLcd3eHAkr9DshW76T0yvt29seBoqXn
         A76R9Wfxb+gPjlyGBEd7ZyXmNztskbo1WxwEsKhxtTFd+58hWNnD4iwRpUYPuXI4xT5/
         ZaHbzWsqEmbqlu/Lkl7r6nWysoyjSZmOSP5PnOf/JwGydWnjF6abaAO6qxpBiYQgMWEK
         f3JYrXiSjWsE9PC2/Psjc1RR1AYD/pwqKtA3vi7KeW1O5IqswTpJO8SAhVdx2bm8MeLp
         7Q+bEXIqa/UKl2/kbLG85p4CMKua+LPIzWh9FHm3b2HN3dozciVnQlscHCtLM93fH85m
         XTtg==
X-Gm-Message-State: AOJu0YwBRQrmDF9vlXgRRQTu/KPjVSeZQ/9A7ViYxO8lFyuRSzzsfBAa
	ytkqw3EU+S8YQatUc58GaAtxeiWdxvdVVJYNQoz1Q3JMuxlurx5oG7wdDf5i1BI=
X-Google-Smtp-Source: AGHT+IFl6aqaK0Zzujz+ua2LXyQZac3NzEjR/nvlkVSdnCeLZcnj+gZj8c/q8uIzVBg5lIOzaW+eDA==
X-Received: by 2002:a2e:be9c:0:b0:2d4:522e:62f3 with SMTP id a28-20020a2ebe9c000000b002d4522e62f3mr5053855ljr.44.1710333136860;
        Wed, 13 Mar 2024 05:32:16 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id r22-20020a17090a0ad600b0029b2e5bc1b9sm1374264pje.23.2024.03.13.05.32.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Mar 2024 05:32:16 -0700 (PDT)
Message-ID: <c94f3dd8-7cc6-4a0c-9073-0bb92e81e863@suse.com>
Date: Wed, 13 Mar 2024 20:32:12 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: improve write IO performance when fragmentation is
 high
Content-Language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, ailiop@suse.com
References: <20240308015251.32041-1-heming.zhao@suse.com>
 <3de83d2c-729b-453f-b874-3d553b8274a7@linux.alibaba.com>
 <ccbfc231-cb82-4455-a137-7d9c9dab44d5@suse.com>
 <70d119b5-53c0-4a92-84ec-9b5053184959@linux.alibaba.com>
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <70d119b5-53c0-4a92-84ec-9b5053184959@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/13/24 17:09, Joseph Qi wrote:
> 
> 
> On 3/13/24 9:34 AM, Heming Zhao wrote:
>> Hi Joseph,
>>
>> Before sending v2 patch, I need to explain ocfs2_find_max_contig_free_bits()
>> for you. See the comment in below.
>>
>> On 3/11/24 19:04, Joseph Qi wrote:
>>>
>>> Hi,
>>>
>>> Please see my comments inline.
>>>
>>> On 3/8/24 9:52 AM, Heming Zhao wrote:
>>>> The group_search function ocfs2_cluster_group_search() should
>>>> bypass groups with insufficient space to avoid unnecessary
>>>> searches.
>>>>
>>>> This patch is particularly useful when ocfs2 is handling huge
>>>> number small files, and volume fragmentation is very high.
>>>> In this case, ocfs2 is busy with looking up available la window
>>>> from //global_bitmap.
>>>>
>>>> This patch introduces a new member in the Group Description (gd)
>>>> struct called 'bg_contig_free_bits', representing the max
>>>> contigous free bits in this gd. When ocfs2 allocates a new
>>>> la window from //global_bitmap, 'bg_contig_free_bits' helps
>>>> expedite the search process.
>>>>
>>>> ... ...
>>>>    +/* caller should initialize contig_bits */
>>>> +void ocfs2_find_max_contig_free_bits(void *bitmap,
>>>> +             unsigned int total_bits, int start,
>>>> +             unsigned int *contig_bits)
>>>> +{
>>>> +    int offset, free_bits;
>>>> +
>>>> +    while (start < total_bits) {
>>>> +        offset = ocfs2_find_next_zero_bit(bitmap, total_bits, start);
>>>> +        if (offset == total_bits)
>>>> +            break;
>>>> +
>>>> +        start = ocfs2_find_next_bit(bitmap, total_bits, offset);
>>>> +        free_bits = start - offset;
>>>> +        if (*contig_bits < free_bits)
>>>> +            *contig_bits = free_bits;
>>>> +    }
>>>
>>> Or we can just return the contig_bits. Something like:
>>> unsigned int ocfs2_find_max_contig_free_bits(void *bitmap,
>>>          unsigned int total_bits, int start)
>>> {
>>>      int offset, start;
>>>      unsigned int contig_bits = 0;
>>>
>>>      while () {
>>>          ...
>>>      }
>>>
>>>      return contig_bits;
>>> }
>>
>> the input *contig_bits has two jobs:
>> - return the max contigous free bits of bitmap
>> - if *contig_bits is not ZERO, it keeps the max-contig-bits
>>    from last search. When the input 'start' not zero
>>    (means start from middle of bitmap), the max-contig-bits
>>    from latter part of bitmap may smaller than first part.
>>    at this case, function should keep & return the input
>>    *contig_bits.
>>
> 
> IC, I don't think it's a good idea to mix up the 2 responsibilities.
> You've hidden the logic that it may change the input contig_bits (not
> the case of first search).
> You can also implement it something like:
> 
> contig_bits = ocfs2_find_max_contig_free_bits();
> if (config_bits > sr_max_contig_bits)
> 	sr_max_contig_bits = contig_bits;
> 
> This will be more explicit for an optimized search.
> 
> Thanks,
> Joseph
> 

Thanks for the explanation, your code logic is better.

- Heming
