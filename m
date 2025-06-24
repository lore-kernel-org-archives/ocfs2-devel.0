Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF996256D
	for <ocfs2-devel@lists.linux.dev>; Tue, 24 Jun 2025 02:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750732825; cv=none; b=SUGT68JBlCKK9Z1xlwIXGnyUpJxrUZifCSe7f8UzDmRPWAdO60GRlxNofMwNBCvxMRxjYmvuxEioFtBzPnkK8aFIkcMUlCe/VqnVgtfDAhbcdVRVqXnFNXp1yIz6f8kRSsZj6L14cGZdJQz+Zyb6i7fVCXc7aRgiiEoDXPX+V1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750732825; c=relaxed/simple;
	bh=enTOF6FIzn9wWsAyYbgHTZ9l+Kvoh1jGzhMq4Ig/1JY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kJ+Czn5zVZpGeawCQZB/m+j3KP0XnMRNg8lipFEwRM05hSMxvAfWxPo3iQpuqeRxz8wRsWaVs2gY+E3+clqUPJ8fsaGQCyMdINH6s+CNBJWneCTQ3HS9nNyJAWJQ9kT1YrZ1ypNVHpkjEMHY6fBqiufBYBYT8pemsqtPtqUst9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gIDvxfvi; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gIDvxfvi"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3a4e57d018cso702022f8f.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 23 Jun 2025 19:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1750732820; x=1751337620; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NwpXcIqfYnXwglQhFL6GpMu90ycYFYBcj7QErSUqSgA=;
        b=gIDvxfvi9oEGhbLMcub00qdRSEPLraCLT/vfrKQsVZeBBbiM5y+AiyO+lP/bELbsR1
         ZK6TlvAm3Fo6hYxkogDJsn4/NNN5qvYDlgPhcJ/prXfmNeNNV1iKBrbPOouJUL6PWEPg
         JWC0db6h5AIwHUOoZTdLjxcnNS03HyB7yvVHVoXyz7D07oHiFKZ5b3L5Jrodv9h1u+W2
         r+srdfJivBHu5t/QOvYG/ACfhU6/gXsFmt7VAf4Uus70DFrdSTzvgrdpySPdRRz36T9C
         cqphG3BY5gi3H9Zbqfl5kZvj6t5lX4cAd7gbHeaDzzsK9pV7neSMmLkj6JXaMNBiuFmq
         4z9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750732820; x=1751337620;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NwpXcIqfYnXwglQhFL6GpMu90ycYFYBcj7QErSUqSgA=;
        b=O39Rztcyk/1wLWIAF913oFRb0MnatoVsbJZE/gVs5whABb5y7qqH2vMcyOO4mYNUJn
         cGDkp9TCdGEXViYflfLAC/HyFSbbIgmTesBQrfpvYlHk1KBLp0/cjCrrvoI4uZjrpzLZ
         iIwH8yWeIwzWOtQcb+ZbGACZaUKkVcPoZLMJUYSb+cEe32z2xj+9tV4CoermWpOB4/cw
         DpFF/bhl05AI9KYq8KQBGkJyM8lIiIp1PxTG9XhnRm/spOR+rkkXDwmqIGEDqfvYTNyr
         +l/O6hVVOFdLDUogjZu7UwZmfhOoIhqQdAmAHzn2gmqpXvzmyrt/2s2h/y5fsWwTnFYE
         qGdw==
X-Forwarded-Encrypted: i=1; AJvYcCUqasU7m8n61bJJQGfLr+LxVFqQTnJchiwYPv7t184khXug6RrhMwID4c0UNK94yHMYK9GfejNkpXAQZg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzYhdeKheeCqXfK7ILrIyr6Z9j51FnFuxWTrxhjerol5jJ7+qcU
	FkOQLNyuXMDM7yGA7fbCse1BeOW3lM9HtZZ/tRh9RDqrbExBbTYeKANoErC5lUXXyAEPMm6LzYj
	561RP
X-Gm-Gg: ASbGncseLTMfV7OSucIgJOxzAbxPnXk8NtHqSSt7qR1oEC0Q4OqSi7by3wdGTUMmakZ
	We8Zoug0WSkipZ+DN3D0iWnfqQyV0wwNsgebmk5zeeUNalAThwROLhBFPSsS5xSgw9Ilgjb9vE1
	Yyhag/1IP131JBO0ls8mk4P1e7ntFwxSFfQ2Y40gJrJvB444lWgk01bOFw7I28x2Fq/5q0N9gRe
	YSTJfMLTXzVgfnNENvtidiAb/b/Yw34xx5kMmA5yToqJ7SjBWjDCq8+8sjXNBITM9x2tTIZOAd2
	gZpepA4hkUvMIgs1F7bdmmeHoLNKiPpQCGBDGgVdiFhBXYmRwIsHpSI7JelQhQvkmr0=
X-Google-Smtp-Source: AGHT+IEbqdclaAWUAWaYHwVY2zKq3xTnPeMuXhaeWz6w8mGwqFsDw03lzO3ccYAE94DQmRS/3SPWxA==
X-Received: by 2002:a05:6000:2486:b0:3a5:3369:52f3 with SMTP id ffacd0b85a97d-3a6d12d736emr3843326f8f.3.1750732820059;
        Mon, 23 Jun 2025 19:40:20 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3158a331babsm11877556a91.46.2025.06.23.19.40.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 19:40:19 -0700 (PDT)
Message-ID: <c9467d9e-5cac-49b8-b839-179dc79d0bce@suse.com>
Date: Tue, 24 Jun 2025 10:40:15 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: kill osb->system_file_mutex lock
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>, jiangyiwen <jiangyiwen@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@lists.linux.dev,
 Diogo Jahchan Koike <djahchankoike@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
References: <934355dd-a0b1-4e53-93ac-0a7ae7458051@I-love.SAKURA.ne.jp>
 <faf70481-09dd-4c7a-bd43-f1e8bec877cb@suse.com>
 <675ea747-5c05-410c-888c-fe6dd2b48d87@I-love.SAKURA.ne.jp>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <675ea747-5c05-410c-888c-fe6dd2b48d87@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/24/25 10:17, Tetsuo Handa wrote:
> On 2025/06/24 10:33, Heming Zhao wrote:
>>> @@ -112,11 +110,10 @@ struct inode *ocfs2_get_system_file_inode(struct ocfs2_super *osb,
>>>        inode = _ocfs2_get_system_file_inode(osb, type, slot);
>>
>> In my view, the key of commit 43b10a20372d is to avoid calling
>> _ocfs2_get_system_file_inode() twice, which lead refcnt+1 but no place to
>> do refcnt-1.
> 
> My understanding is that concurrently calling _ocfs2_get_system_file_inode() itself
> is OK, for the caller of ocfs2_get_system_file_inode() is responsible for calling
> iput().

We have different perspectives on calling _ocfs2_get_system_file_inode().
In the current code logic, _ocfs2_get_system_file_inode() is expected to
be called only once. Subsequent local system inodes will be retrieved from
the cache (via get_local_system_inode()).

> 
> The problem commit 43b10a20372d fixed is that there was no mechanism to avoid
> concurrently calling
> 
>    *arr = igrab(inode);
> 
> which will result in failing to call iput() for raced references when
> ocfs2_release_system_inodes() is called.
> 
>>
>>>          /* add one more if putting into array for first time */
>>> -    if (arr && inode) {
>>> -        *arr = igrab(inode);
>>> -        BUG_ON(!*arr);
>>> +    if (inode && arr && !*arr && !cmpxchg(&(*arr), NULL, inode)) {
>>
>> Bypassing the refcnt+1 here is not a good idea. We should do refcnt+1
>> before returning to the caller.
>>
>>> +        inode = igrab(inode);
> 
> We do refcnt+1 immediately after cmpxchg() succeeds, for
> ocfs2_release_system_inodes() which clears *arr is the place for
> doing refcnt-1.
> 
>>> +        BUG_ON(!inode);
>>>        }
>>> -    mutex_unlock(&osb->system_file_mutex);
>>>        return inode;
>>>    }
>>>    
>>
> 

In my view, your patch has logical errors - at least from my perspective,
I have to vote NAK.

In my view, for this syzbot bug, the better solution is to block/deny write
operations during the ocfs2 mounting phase.
There are many syzbot bugs related to writing data during the mounting phase.
I don't believe there is any reason a user would want to write data before the
filesystem is mounted.

