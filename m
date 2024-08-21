Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C516158A23
	for <ocfs2-devel@lists.linux.dev>; Wed, 21 Aug 2024 11:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724240410; cv=none; b=KK0r0yFagkLhfleAUyePG5n/fCID4NU0zarZocx+AuSlziyFBUlziNsbJ/aoX/DHvHSpNOrF8Nbg6eeGOQPBZyOICq/9+FTP7R5YyoSqrz5EvJNUMxsR01KnpHqp/VKwM22Gvt659MKDqs1cysKrDh6cD1V+DaggShASwzulfqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724240410; c=relaxed/simple;
	bh=TxdPXmFR5vjV3UXtB2DcKHBS9FQbWYVADGjWJRmGmK4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TTLuR4mmQT0/tFB3pXpjv+AY5Z9GECWuSDEgvF0can9L/N/aSMhgdoUKlFx1BpyRcFpzXGbI+eKQU3zuhAcRnrtHSGCCEc2CZvVWaxSYs9bXqwe3SLH5bCBfK/mL3Kuvn41747uGExJubhH9Wh3iGwJjthkZyA1ZX/EHItW2rTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cBprnIeF; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cBprnIeF"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4290075c7e1so1015395e9.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 21 Aug 2024 04:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1724240407; x=1724845207; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XQy9LBwp51k85doIAWOjWZXnls3PlfVEFpR3aoQxmj8=;
        b=cBprnIeFY6SvzNO5mh5Hho0dBBJuW4zKyQLioHgKZCeJZ6OWEVyGKTewdmJTjgnACX
         MYsIvSi0OVN15tRvyIO6msNXTj7J+kL12kREBVCPlz3Hr3j8QA2gO39wS3+xPowD0AQB
         TBAlRgJqLDI5BA5DIYkjyCTaVbySfGUt7LaDRnv8H6aiLJiiWTKp+980zv0uqA5PN2Z1
         N2dw5f1vt9sEtkFWXGCwRz2W+vNbe+xnAfiGuhV15Qq6o8oJz7ZZdcv/7sZWbycjM245
         QMPNMarmycUILEZGQyqB6DfLa4ZxMc3pjH2WOYRZOTq+6tKZkd0rB9Q5chpxt3GoKuzf
         QwIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724240407; x=1724845207;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XQy9LBwp51k85doIAWOjWZXnls3PlfVEFpR3aoQxmj8=;
        b=HBBRDdsjYA9eTp25MLFZ1KN+8UDooFvg8zKi+uZ8Gx1wCo3lBzXeoXloR4oNlJvT1K
         b2hbnSaMYX3WbfSu/7wtCviPLCxCUZcW7JsVi6KyxvkejLvR1R+FmaV1Rb+zlRz7kIiw
         V6Aq/wF8YLt2OmqUbQi0LbOJdmhg5i0hOWUJCppgcF5dRMDO02OEds+e40KiWnZRn7jt
         Svkipb1MKzqL7SXQo2e3PERnj8gRPLrNe+peiri1DN1wM2xy10jSHuQCduB3sPX/MsJq
         jp/cS7JRjYbWxYEpwz2YTtXXGtHpgFv7PX5yYdTbEGM9jQaqanYRFvYBfRYKbRtyNNDC
         UgmA==
X-Forwarded-Encrypted: i=1; AJvYcCUEWX6NFmt/i9akALXrGpVU+d8WxF2OObHq7tdbkOvTZHa1R8JoyhnyK1f4MYIACrUmzqdik67FtfbkTQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzCnSOEctd5UEThq9bVfenfTjGbMdz5L0IezZcHDUZuJMYGZsEA
	02otu075w7deOqOkXyY0M/Oma+3vJlAUROR4+XioeNQ3g6p46FyRLlguUT0fsJc=
X-Google-Smtp-Source: AGHT+IFu+co3QmulLWZnBNYh0+MKW+hT0OnXrUqee+tKbGDEErfOYOQtHNV/NVXtiH45oA614+eEng==
X-Received: by 2002:a5d:5846:0:b0:367:2da6:aa1b with SMTP id ffacd0b85a97d-372fd710240mr685060f8f.7.1724240406292;
        Wed, 21 Aug 2024 04:40:06 -0700 (PDT)
Received: from [10.202.0.23] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2036fbec3c6sm8908245ad.124.2024.08.21.04.40.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Aug 2024 04:40:05 -0700 (PDT)
Message-ID: <25f2be6c-3e9c-4484-a44e-d26e9c4c8a74@suse.com>
Date: Wed, 21 Aug 2024 19:40:01 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 2/2] ocfs2: Fix possible null-ptr-deref in
 ocfs2_set_buffer_uptodate
Content-Language: en-US
To: Lizhi Xu <lizhi.xu@windriver.com>, joseph.qi@linux.alibaba.com
Cc: jlbec@evilplan.org, linux-kernel@vger.kernel.org, mark@fasheh.com,
 ocfs2-devel@lists.linux.dev,
 syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com
References: <1a063827-5cf3-42df-a690-f3c644c10996@linux.alibaba.com>
 <20240821091459.681136-1-lizhi.xu@windriver.com>
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20240821091459.681136-1-lizhi.xu@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/21/24 17:14, Lizhi Xu wrote:
> On Wed, 21 Aug 2024 15:58:36 +0800, Joseph Qi wrote:
>> On 8/21/24 3:37 PM, heming.zhao@suse.com wrote:
>>> Hi,
>>>
>>> On 8/21/24 14:55, Lizhi Xu wrote:
>>>> On Wed, 21 Aug 2024 14:23:08 +0800, Heming Zhao wrote:
>>>>> Where is my "Reviewed-by" tag, and where is [patch 1/2]?
>>>> Sorry about your "Reviewed-by" tag, I remove it, if you don't mind, you can
>>>> add it by yourself.
>>>
>>> Good answer!
>>>
>>> This patch issue was found by me, and I also pointed out how to fix it, then take the time
>>> to review your code. But in the end, you removed my "Reviewed-by" tag.
>>>
>>
>> Seems a misunderstanding, take it easy:)
>> Lizhi may think since this is a new version, it needs a new round review.
> Yeah, the subject and comments have all been changed.
> Thank you for defending me:)

OK.

> 
> BR,
> Lizhi

