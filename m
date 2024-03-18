Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838AE2C692
	for <ocfs2-devel@lists.linux.dev>; Mon, 18 Mar 2024 07:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710748055; cv=none; b=Bv36YcFqCcF4WZLoogHjy2IjmENAOtwnCNaQ9jEKAVKIhzSY08tbVypUSfbZipMxJ/qyqpehWmP9RuUYskdjRek0Jj57AqKR6NuemelEZV5ur30jOuYI+1W8JOsfMnf8sp8desBMShfD/2K/88+jr/ji7JCfwZoURhAMwpSYiWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710748055; c=relaxed/simple;
	bh=TsJuMoomI2snqOSybtpf+bvY+p2Vme9H1+5m4AKE558=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eIScvtqg1/P7+4sfQHlDKi9RIyplNHt+rWd+7Gp5gEL093s7VNMXtPF6J48O6ZwjiGYn747z0pzeMphT/wmo210fb/fgr9mgcDboCYlHr0gdreRfl2cZD3Y9gHp/1DE7MQHWxBYVmQxIWknuZJvi05W4nOsUEpWyJLbz9989UYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Q61PQhQz; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Q61PQhQz"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2d475b6609eso52135471fa.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 18 Mar 2024 00:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1710748049; x=1711352849; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fHpNo1ambGgfCxtl4nOqAP+um9XlbZvdjWdRdUbGHpc=;
        b=Q61PQhQzpdspzzsptK/UZ7zrJPjVg2xtHXEV2/mBohr8456t5Qtz702zZVpnv9QUI2
         YQ4yic0DhaGs6v9BCGIVfDxQxm8JWrX/J9dm+jOsKi9z4qembx3mAkf3XvNEShfnxLTP
         T12t0QzK/Ky5c4Q4NeN7KfAx3mJ4QWom7W4dqah9kjEMtYCCHC1RcNZ3/x2/4hpMouCJ
         YuLo6tgPc2zx6XdnCLdTdQzK4eYv7777N7XFqqhLBhs26rDn13sJYArfGIitMCPuND7q
         JzYlBE+CMq0kjPjrgrzZKBKI8OG8GEKUNCH0o1jf8qUQ9C0zAT9htCdRaU9gi0Hd5hmR
         Uvaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710748049; x=1711352849;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fHpNo1ambGgfCxtl4nOqAP+um9XlbZvdjWdRdUbGHpc=;
        b=Rp6zk5xLoTDbm/34nbnJ+qo0jia5LcfqU8IJU67qmTe/qdP6ZBdVehGEwF/983hQ6C
         /72YoMCtttZwfKg7YXkhswWAoJfhlk8fx0Da/EDnGenA96zJcQ2knjOzd4V+aBCXGAXt
         rQ8xAc7NWozGoPaLno6TTNxi+DNMli/AIYpB6IcSuXDEq09gGL37n/Nbgwakfg/vvUD3
         wf62IAAOPDk9k5GbO1OND2mzrL9ASwH1mosjhoRiCvbMxbTx9grtTzh+crIo3lEqUnyS
         hw24n6c6r1hh60tGpJo/1H4g6RtuYmE0qvU0wEKg0/BwbaggPt0RE0vruCSjpzTyvSpX
         D0zg==
X-Gm-Message-State: AOJu0Yx5Vk0SfnP6tKmBwmTiGvhyTnubR2ZM+bCdaXo2tUgwFw5uNPb+
	1iuy0tbHBtayQUyN3b7eiFO7AOuUdnldC1wM8LZ5mBy8AiMsKyJkhcfOXl0nF/I=
X-Google-Smtp-Source: AGHT+IEgeV/5XFZTSqdSjzxP3IeFCdJDgGdi/kwWBX1gDrgA9tkb6F3Iuo04Drz6AvfWdJ5zD0vehw==
X-Received: by 2002:a2e:bc24:0:b0:2d4:aae0:1d71 with SMTP id b36-20020a2ebc24000000b002d4aae01d71mr1247393ljf.43.1710748048680;
        Mon, 18 Mar 2024 00:47:28 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id b5-20020a170902650500b001dd7d66ac95sm8643465plk.78.2024.03.18.00.47.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Mar 2024 00:47:28 -0700 (PDT)
Message-ID: <0fc73316-6639-44aa-9cd2-b561a4caa93d@suse.com>
Date: Mon, 18 Mar 2024 15:47:25 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: improve write IO performance when fragmentation
 is high
Content-Language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, ailiop@suse.com
References: <20240316034457.16893-1-heming.zhao@suse.com>
 <b09feb83-c506-4c5b-a6dd-c5a7d24f45e3@linux.alibaba.com>
 <1f8715a2-cc77-4203-9d38-ecf99bb71198@suse.com>
 <75a0425a-1e31-42bf-9095-e4a3e00b0e01@linux.alibaba.com>
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <75a0425a-1e31-42bf-9095-e4a3e00b0e01@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/18/24 13:49, Joseph Qi wrote:
> 
> 
> On 3/18/24 1:29 PM, Heming Zhao wrote:
>> On 3/18/24 09:39, Joseph Qi wrote:
>>>
>>>
>>> On 3/16/24 11:44 AM, Heming Zhao wrote:
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
>>>> Let's image below path.
>>>>
>>>> 1. la state (->local_alloc_state) is set THROTTLED or DISABLED.
>>>>
>>>> 2. when user delete a large file and trigger
>>>>      ocfs2_local_alloc_seen_free_bits set osb->local_alloc_state
>>>>      unconditionally.
>>>>
>>>> 3. a write IOs thread run and trigger the worst performance path
>>>>
>>>> ```
>>>> ocfs2_reserve_clusters_with_limit
>>>>    ocfs2_reserve_local_alloc_bits
>>>>     ocfs2_local_alloc_slide_window //[1]
>>>>      + ocfs2_local_alloc_reserve_for_window //[2]
>>>>      + ocfs2_local_alloc_new_window //[3]
>>>>         ocfs2_recalc_la_window
>>>> ```
>>>>
>>>> [1]:
>>>> will be called when la window bits used up.
>>>>
>>>> [2]:
>>>> under la state is ENABLED, and this func only check global_bitmap
>>>> free bits, it will succeed in general.
>>>>
>>>> [3]:
>>>> will use the default la window size to search clusters then fail.
>>>> ocfs2_recalc_la_window attempts other la window sizes.
>>>> the timing complexity is O(n^4), resulting in a significant time
>>>> cost for scanning global bitmap. This leads to a dramatic slowdown
>>>> in write I/Os (e.g., user space 'dd').
>>>>
>>>> i.e.
>>>> an ocfs2 partition size: 1.45TB, cluster size: 4KB,
>>>> la window default size: 106MB.
>>>> The partition is fragmentation by creating & deleting huge mount of
>>>> small files.
>>>>
>>>> before this patch, the timing of [3] should be
>>>> (the number got from real world):
>>>> - la window size change order (size: MB):
>>>>     106, 53, 26.5, 13, 6.5, 3.25, 1.6, 0.8
>>>>     only 0.8MB succeed, 0.8MB also triggers la window to disable.
>>>>     ocfs2_local_alloc_new_window retries 8 times, first 7 times totally
>>>>     runs in worst case.
>>>> - group chain number: 242
>>>>     ocfs2_claim_suballoc_bits calls for-loop 242 times
>>>> - each chain has 49 block group
>>>>     ocfs2_search_chain calls while-loop 49 times
>>>> - each bg has 32256 blocks
>>>>     ocfs2_block_group_find_clear_bits calls while-loop for 32256 bits.
>>>>     for ocfs2_find_next_zero_bit uses ffz() to find zero bit, let's use
>>>>     (32256/64) (this is not worst value) for timing calucation.
>>>>
>>>> the loop times: 7*242*49*(32256/64) = 41835024 (~42 million times)
>>>>
>>>> In the worst case, user space writes 1MB data will trigger 42M scanning
>>>> times.
>>>>
>>>> under this patch, the timing is '7*242*49 = 83006', reduced by three
>>>> orders of magnitude.
>>>>
>>>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>>>> ---
>>>> v2:
>>>> 1. fix wrong length converting from cpu_to_le16() to cpu_to_le32()
>>>>      for setting bg->bg_contig_free_bits.
>>>> 2. change ocfs2_find_max_contig_free_bits return type from 'void' to
>>>>      'unsigned int'.
>>>> 3. restore ocfs2_block_group_set_bits() input parameters style, change
>>>>      parameter 'failure_path' to 'fastpath'.
>>>> 4. after <3>, add new parameter 'unsigned int max_contig_bits'.
>>>> 5. after <3>, restore define 'struct ocfs2_suballoc_result' from
>>>>      'suballoc.h' to 'suballoc.c'.
>>>> 6. modify some code indent error.
>>>>
>>>> ---
>>>>    fs/ocfs2/move_extents.c |  2 +-
>>>>    fs/ocfs2/ocfs2_fs.h     |  4 +-
>>>>    fs/ocfs2/resize.c       |  7 +++
>>>>    fs/ocfs2/suballoc.c     | 99 +++++++++++++++++++++++++++++++++++++----
>>>>    fs/ocfs2/suballoc.h     |  6 ++-
>>>>    5 files changed, 106 insertions(+), 12 deletions(-)
>>>>
>>>> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
>>>> index 1f9ed117e78b..f9d6a4f9ca92 100644
>>>> --- a/fs/ocfs2/move_extents.c
>>>> +++ b/fs/ocfs2/move_extents.c
>>>> @@ -685,7 +685,7 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
>>>>        }
>>>>          ret = ocfs2_block_group_set_bits(handle, gb_inode, gd, gd_bh,
>>>> -                     goal_bit, len);
>>>> +                     goal_bit, len, 0, 0);
>>>>        if (ret) {
>>>>            ocfs2_rollback_alloc_dinode_counts(gb_inode, gb_bh, len,
>>>>                               le16_to_cpu(gd->bg_chain));
>>>> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
>>>> index 7aebdbf5cc0a..eae18d772e93 100644
>>>> --- a/fs/ocfs2/ocfs2_fs.h
>>>> +++ b/fs/ocfs2/ocfs2_fs.h
>>>> @@ -883,14 +883,14 @@ struct ocfs2_group_desc
>>>>        __le16    bg_free_bits_count;     /* Free bits count */
>>>>        __le16   bg_chain;               /* What chain I am in. */
>>>>    /*10*/    __le32   bg_generation;
>>>> -    __le32    bg_reserved1;
>>>> +    __le32   bg_contig_free_bits;  /* max contig free bits length */
>>>
>>> I've found some parts you are using le32, while others using le16.
>>> It seems that le16 is enough here. So why not:
>>> __le16 bg_contig_free_bits;
>>> __le16 bg_reserved1;
>>>
>>> Joseph
>>
>> IIUC, From the comment before ocfs2_la_default_mb(), the max cluster
>> size is 1MB. And from 'struct ocfs2_group_desc', the offset of
>> bg_bitmap is 0x40. Therefore, the max contiguous bit of gd:
>> (1024*1024 - 0x40)*8 = 8388096 (23-bit length, bigger than __le16)
>>
> bg_bits and bg_free_bits_count are already using __le16 now.

You are right.
I rechecked the code. The gd block size should be blocksize not
clustersize. and the value of blocksize should not be bigger than
PAGE_SIZE, so the max value of bg_free_bits_count is
(4096-0x40)*8=32256, which is smaller than __le16.

I will modify all the code related to __le32.

-Heming

