Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A0E26CE0A
	for <ocfs2-devel@lists.linux.dev>; Tue, 14 Oct 2025 01:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760406286; cv=none; b=Gpqeey+vSpXRxyYyh67B+fol+Xw840cdc6S7tekLGrq3WOQFfsjYyo05ogpGwmHkHPuVCYVTLlMndJleZQuc/JpbVHHz6ye0eIuzbTiZ59BJoRm7CZmWNV+oFO7sFL+fCkp31u3f0jdWiKgbKAXl9MqNUUW6ywK1EfhzKdazNxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760406286; c=relaxed/simple;
	bh=VT7G6mqN89QQ8OmwZqF0EU1MDv8lnPZ3uhm0234Y86s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q8AHiLniaBKsvCv7jz9+B4VFrRDK5v8g0nKESSiwGO1SF3sL54T4HMae2AsEYm0A4hMSDlF3HtZj4trHTJpCAsBqJY50zHjb5vV/X01yVgiTY6N+vOwHIUDAQSTr2GGhXeh4NbrB5HofOo73L6l1e3ZMpYEMDdrNtxPokBcRWA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fh4uClq1; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fh4uClq1"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-46e3e16d7fbso7867515e9.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 13 Oct 2025 18:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760406282; x=1761011082; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OCpviY36qxZ0JRaaGhalr1jb4kcPqBSNSDaCvWUGbeE=;
        b=fh4uClq1rGpYKDP3V6CFhkUQCjMC3og+nXccjSIa0SAc/79CBUlzt5n5BnxNKCDPJ4
         a/NNv1gieSF28AtrAknGxgvmSaxpU2LJ/agtc0wd7YbVHUg4jcZJPZDgQ/qhMtbQo7Fm
         EjumYPXjLnxM0zpS8QwgPvSc8qIlGMyplvfedOc68gcXOXHzr8Cc0DbsN8ZXfhzX/ayS
         mzfqr53MQw3Tfh70xWvqWJjJHP0EeVy3/OD0KATYVKXStd/QWvLdwjYP5Mbd3OWBz2Ms
         GRtZIT1QYAWDgS7+xmDfHeEAsTS2zMn74jh0AfL4s1mNmOSC3XHQf+wSQZ1r0hKDUly/
         KoCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760406282; x=1761011082;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OCpviY36qxZ0JRaaGhalr1jb4kcPqBSNSDaCvWUGbeE=;
        b=dDbVFek9a4wqpNKf+V697sFWQlB7LC7+dvgFHJ/YUZ9xBH3BEP+MAxt2iZuQHjwgoB
         a3IgG7gVGRx9QgXfSAAKEAs7KVKqMIbaFrAISeAtO6pESxITO0kXQvqMv1YZup9y5vV4
         FlPkcIYndEN/hV+cP4P3Kb2XV78drcLh5nfI9zk4AmLJqo5+C55PDp1daexLtDmmFTg8
         wh7l8Gzl4Zf0E+HC6n7t7Sx5h5C3GzJL73jqdDxmFMalne96b5tNQ4TefilHDUD8GuEb
         0KDnY4kQJ4L7dkL9VMbowOJvO2hAfcn6z7y0OpdwbmmJOir2/OKOimW4dzFuMTG7IFfI
         OaLQ==
X-Gm-Message-State: AOJu0YxEpwr37vZcdwE2YPTRVBCnvc1lpt68Uvaf66Nmd/JA2vHJHXO1
	/erR1CHy7/feBdXFn6yWN+uGMArVOT+g9r6B9CyDfg8SIlxVHKjLqrVz/dRjYS97hA4Ps72FtyI
	v5ri5
X-Gm-Gg: ASbGncs94Bkp3h+1iMHNqy+DGI8lyDR8lvhj46U5UMmz9KQPrFFNWfSVJEnBLxrFMf9
	bx/MZZi3dWsniMfb24fOXzwZzJcicS/NVViRlxe9tUOFYjiguOsrtYGpwhBLsKF59yNsWf5oDzh
	MgYIJ5gx3jQAZ439lZKsjgg8gkZN9mASP/tcG/VeLDolAr0tNeFG4/VqUVS/Pn9z3+AV3F9ey21
	XHzRVLb3Y95pPH9GI6qpn5V2JLFeMEHirFnx7i9znn24xXEPsBCBnhKkSej9Wbpc+8K1IVDiPGQ
	uh/qjxUFwE0MOttiSVXv2fw6uKpo4P+Lp7rUAn8klILVl+y3b/7OdClf67Tga3oRWI4TqcGCR+p
	OOGIOZYTuAK56/YstwM2/jHeqlCr+vqRE+Fybrce+TgSBjao=
X-Google-Smtp-Source: AGHT+IEcG3j42ZK7ZlscKTRNA6r/Mt9ftIanQzq2aN8SNCeTFstPuIFpMg0rpxuYrUTSXWo07LIQmw==
X-Received: by 2002:a05:6000:1846:b0:425:5d25:ffc7 with SMTP id ffacd0b85a97d-4266e7d4864mr8870878f8f.6.1760406281787;
        Mon, 13 Oct 2025 18:44:41 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-799283c1a14sm13256938b3a.0.2025.10.13.18.44.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 18:44:41 -0700 (PDT)
Message-ID: <9efedaaf-3600-4d1e-9fb7-77f55f1524e5@suse.com>
Date: Tue, 14 Oct 2025 09:44:36 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix __counted_by_le() usage in
 ocfs2_expand_inline_dx_root()
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
 Dmitry Antipov <dmantipov@yandex.ru>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <20251013153002.167377-1-dmantipov@yandex.ru>
 <0383ab66-9b8a-4e10-b6a9-d25d127dd797@linux.alibaba.com>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <0383ab66-9b8a-4e10-b6a9-d25d127dd797@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I have a different view.

On 10/14/25 08:55, Joseph Qi wrote:
> 
> 
> On 2025/10/13 23:30, Dmitry Antipov wrote:
>> After annotating 'l_recs[]' VLA member of 'struct ocfs2_extent_list'
>> with '__counted_by_le(l_count)', 'l_count' should be initialized
>> before touching 'l_recs[]' with 'memset()' to avoid false positives
>> from buffer overflow guards when CONFIG_UBSAN_BOUNDS is enabled.
>>
>> Fixes: aa545adbe491 ("ocfs2: annotate flexible array members with __counted_by_le()")
>> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> 
> Looks fine.
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> 
> Andrew, could you please help fold this into the origin patch? Thanks.
> 
>> ---
>> note: since the commit in subject is not merged to upstream yet, Fixes: reference is taken from
>> https://web.git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?h=mm-nonmm-unstable&id=aa545adbe491
>> ---
>>   fs/ocfs2/dir.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
>> index 3c2dacba9b0a..d9a2fcb63bbb 100644
>> --- a/fs/ocfs2/dir.c
>> +++ b/fs/ocfs2/dir.c
>> @@ -4133,10 +4133,10 @@ static int ocfs2_expand_inline_dx_root(struct inode *dir,
>>   	}
>>   
>>   	dx_root->dr_flags &= ~OCFS2_DX_FLAG_INLINE;
>> -	memset(&dx_root->dr_list, 0, osb->sb->s_blocksize -
>> -	       offsetof(struct ocfs2_dx_root_block, dr_list));
>>   	dx_root->dr_list.l_count =
>>   		cpu_to_le16(ocfs2_extent_recs_per_dx_root(osb->sb));

If the memset cleans dx_root->dr_list->l_recs[], or "osb->sb->s_blocksize -
(offsetof(struct ocfs2_dx_root_block, dr_list) + offsetof(struct ocfs2_extent_list, l_recs))" this patch is correct.

But the subsequent memset() call cleans all the members of dr_list.
Therefore, dr_list.l_count is reset to ZERO and the data is corrupted.

- Heming>> +	memset(&dx_root->dr_list, 0, osb->sb->s_blocksize -
>> +	       offsetof(struct ocfs2_dx_root_block, dr_list));
>>   
>>   	/* This should never fail considering we start with an empty
>>   	 * dx_root. */
> 

