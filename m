Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF0613777E
	for <ocfs2-devel@lists.linux.dev>; Wed, 21 Aug 2024 02:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724207991; cv=none; b=CTkMombC8uxmn3ZkDt9QncDYIV1UiHkBxiKhdiU5JKCn2Kx6Rgi4kYrZJ8xK0iSJr51FuNEI6sai9ETP9i2i03+NaTY/uAt3Xogdd+KUcWW35voCnGrsuKzWeHbawD/6jCpsS9EcyqXLBnQrSJzI7m8WFaczmfZsAaZw0Tu4jEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724207991; c=relaxed/simple;
	bh=EtQQAVX3GwJ7qAKmImobztHO0L2sHL/F/d+8MdB/t+k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QJf6Nul7+avnnrOw0bH90Y5HSmMMj4YseHqM/2L3OxDmPSBtp4b/FGHbcDeQxzOinN/fK2ZCkDkX2oGxigw3tR56XkSzNHbVivzIEeA78xkLfXdYB/C7Z2FZWe9rAJGFrsAopH/3ec868LADkjvJYPxvNNkGSKTWt/U1ZdlQKO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Lt3zL/jq; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Lt3zL/jq"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-371a939dab9so62914f8f.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 20 Aug 2024 19:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1724207985; x=1724812785; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yzqNjKXw4GB1hmL31K3QO0CK6YmKcJ4/8qF1DvRA9zE=;
        b=Lt3zL/jq+B/CecjXVBiHZmf42MK4lfyy+ZyWnvMPhy+DViBtsEftIOkYFukl/+GWp1
         96yAohab7BIrbJltWQjF2f80/L0g/ryv96XpWzKXZeRQSFwTL3SXjlKv2SNKMwfKFV4C
         0/RHcl8qbQBzWRGd8MCVjyPBnv8GPDcq7w0tfIMoQhCEwDH7Qlx+PTfleDVCopyhYhrW
         OZ3Dy08WIUP38mba3qi5D+VO294V4j3eL2srilGijV8vW/0i5oeAJONBreyRJ6F8Z+sP
         fIXwxV1e/Fz26qb2BYwK1U4rwJVKBgjPg/pKbaIQDhiW+vDk9dT5sjZo8MbLllgRmvhn
         KeKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724207985; x=1724812785;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yzqNjKXw4GB1hmL31K3QO0CK6YmKcJ4/8qF1DvRA9zE=;
        b=xHhyRTzKlxjAdeYXpNdoQ+/CGsc2L7g0pY3iMvRt0g4t7g4CRE4lOJI9VIKraW3vg8
         wUHuq3Zo7HDo2HRPVaVlY5iMFURVwvRSez+30Htph7LdAYNatt0bUv/JRpOCScNPvIjA
         V8CEiAP1nj+MaHATd3mPG+GJ+w2kmJoosZpD5CYa0MmwIsFeXJ2QoIKMcycxrsmNH6tB
         X0WQpkIYEEiwj75HI0/VSEqCd5/bVEnhb+8LzfzKlehc+8qksyMJh8A3daR+bbwDzyJ+
         j75H2USmP8ul6Pf66THHeD3zoSOfbF9lgZOYn5oGVQiFQ180fdIueYN89zDWvsvLtk+G
         sVrw==
X-Forwarded-Encrypted: i=1; AJvYcCU9aMaG1a6JmOnmZVPhOq2EaLY+WW5Q2EI57doYaAXeOYyA99XBqzpcMVuEdhH0NYSNxtxknlbOjcS9dg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw1yl+x7t2FbjZq5xx7bP1f8dcDBmyZFS5gd8QT3lHq/kuNY5dA
	e7+d1vfOXuEdX+5ag+YCUeK7v+R7JklHvrrM9L/Y1/zEHFtIX0YEpqiP0uS55d0=
X-Google-Smtp-Source: AGHT+IHYJCrabfqoq6HEID/rZUxdkVcto5JDM35M7hdVtQrhH1CDWQhq+BLjTnVh81pXTal/OhJwrw==
X-Received: by 2002:a05:6000:178b:b0:35f:2f97:e890 with SMTP id ffacd0b85a97d-372fd4d3feamr271662f8f.0.1724207984217;
        Tue, 20 Aug 2024 19:39:44 -0700 (PDT)
Received: from [10.202.0.23] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d5ebbd9d72sm383568a91.49.2024.08.20.19.39.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Aug 2024 19:39:43 -0700 (PDT)
Message-ID: <7d0d7bbc-6265-4f60-ba2c-a9c15771e95e@suse.com>
Date: Wed, 21 Aug 2024 10:39:39 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 2/2] ocfs2: Fix uaf in ocfs2_set_buffer_uptodate
To: Joseph Qi <joseph.qi@linux.alibaba.com>, Lizhi Xu <lizhi.xu@windriver.com>
Cc: jlbec@evilplan.org, linux-kernel@vger.kernel.org, mark@fasheh.com,
 ocfs2-devel@lists.linux.dev,
 syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com
References: <980b3f4d-f265-4eb4-96a3-8f1a75588193@suse.com>
 <20240820094512.2228159-1-lizhi.xu@windriver.com>
 <20240820094512.2228159-2-lizhi.xu@windriver.com>
 <7da687ce-ffb7-44e3-bddc-d5c2f4f48c95@linux.alibaba.com>
 <416247e6-5da7-401c-815f-a4cf8ae37d51@linux.alibaba.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <416247e6-5da7-401c-815f-a4cf8ae37d51@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/21/24 10:34, Joseph Qi wrote:
> And this is not a UAF case, but NULL pointer dereference.
> So I suggest change the subject to:
> ocfs2: fix possible NULL pointer dereference in ocfs2_set_buffer_uptodate

I agree with above too.
I didn't care about the patch subject in previous review jobs, 'UAF' is not suitable.

-Heming

> 
> On 8/21/24 8:08 AM, Joseph Qi wrote:
>>
>>
>> On 8/20/24 5:45 PM, Lizhi Xu wrote:
>>> In the for-loop after the 'read_failure' label, the condition
>>> '(bh == NULL) && flags includes OCFS2_BH_READAHEAD' is missing.
>>> When this contidion is true, this for-loop will call ocfs2_set_buffer
>>> _uptodate(ci, bh), which then triggers a NULL pointer access error.
>>>
>>
>> Or it may simplified as the following:
>>
>> When doing cleanup, if flags without OCFS2_BH_READAHEAD, it may trigger
>> NULL pointer dereference in the following ocfs2_set_buffer_uptodate() if
>> bh is NULL.
>>
>>> Changes from V2:
>>> * Make the code more concise
>>>
>>
>> This is not the right place for changelog.
>>
>> Thanks,
>> Joseph
>>
>>> Reported-and-suggested-by: Heming Zhao <heming.zhao@suse.com>
>>> Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
>>> Reviewed-by: Heming Zhao <heming.zhao@suse.com>
>>> ---
>>>   fs/ocfs2/buffer_head_io.c | 3 ++-
>>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
>>> index e62c7e1de4eb..8f714406528d 100644
>>> --- a/fs/ocfs2/buffer_head_io.c
>>> +++ b/fs/ocfs2/buffer_head_io.c
>>> @@ -388,7 +388,8 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
>>>   		/* Always set the buffer in the cache, even if it was
>>>   		 * a forced read, or read-ahead which hasn't yet
>>>   		 * completed. */
>>> -		ocfs2_set_buffer_uptodate(ci, bh);
>>> +		if (bh)
>>> +			ocfs2_set_buffer_uptodate(ci, bh);
>>>   	}
>>>   	ocfs2_metadata_cache_io_unlock(ci);
>>>   

