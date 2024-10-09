Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64387710C
	for <ocfs2-devel@lists.linux.dev>; Wed,  9 Oct 2024 02:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728442691; cv=none; b=hxGFSlonoDYibOOE/PNRlP79UUtPAuRbcWFRY+HPlLM88VqB9u6/TCrrfgaCrxmSVPaoccOHrPEJYCgIdSpQY9JPZ/LWT/cnqGDgQyoSSciiEnrZmHPs4/wObZryXyPCgohJJI1IzQoUJKO3RNge8tcIIexQSatc6j1FfIXodAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728442691; c=relaxed/simple;
	bh=OEWK5vI2lCBE3KE/69uvB/ekAtGhUNj6TA+SnKCTdxI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jlBDh6DyeNfDTLiMNYywSFZJGR/NZnsyvrqvkcs/1hTSN9FDwrvgWYsr0bnikd1l6/jgSgrLw3KYKh4NFfv4XxRzs8EpATx88iLyTLiogA2NhpMmZQKYUDS4MAOawKtgbwbYr5drzyEw739yp8JeTv+V1TiIP9DJw7WOJnniOjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=c84BRzgP; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="c84BRzgP"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-430576fe517so1558615e9.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 08 Oct 2024 19:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1728442688; x=1729047488; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X9o3xjneRzpxTeUAgzBHAVPEaaxarVMtSkH9MOjrIyI=;
        b=c84BRzgP5IFXZkd6QgR5/BOS93HkQlu06k+N/Eq1eUgWZ3XzblebeFhzB1dmzok29k
         26rgxODZsQN/ZMIPY/aNQH2Cpad73HmeKG5Ao2tE9UZifgsjJOZMZ1Rf1voQikGN1N10
         vxxXzegNaNE+3mm4Q6XD2rIbpTkNJRvExPLnpm6KacSc0k98atRs1fff2r3tqoDBUjoY
         6orglAH6lWKNYXoebch4g/v27aEk+dRhfhx6L4K976+tOhMm1ykg9b37SBj3zF3Jzc7a
         agIQ6WIJHjO3sDqRAEkvM/VW02hhibIpVB8JJeNM3WG/1PQlfyI164CaD/eBYj8QbBRL
         yKLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728442688; x=1729047488;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X9o3xjneRzpxTeUAgzBHAVPEaaxarVMtSkH9MOjrIyI=;
        b=dKuYjD4njygw0n7BuCbIODR8hC4l2a8fbkYc4FsaLt/xdoD0pOW0BD1w1278wfg0rn
         inj4AB7a5YFMl168ANh7HXa3lFwqfF3t8LuXEEMw0YmqSQx393BYorgLgoolxRvx7lnD
         WwCAO21yUwofQk/92J1ayo+1TAa03HhGdDLF34Mag2/6G8dw6URxGVlhIbVkyQkzQ+G7
         SlbV1gOUJZY7nLcYzWgYJTeN2SHUu1XwkxAWotNDpbvr3XpX1FrOOUGJbPfFwJM63ans
         hYVQllcgnh6aw3/yHpTUWL8jz/c9iUNugBYWQx4sdf4k71e4YKEqnTRBZdFhRIesIUpr
         BVqw==
X-Gm-Message-State: AOJu0YznRPE/cy4W2ETqzvToDcVOFeNscjrrL3UAgcAV2/67Vm4I3xNH
	BR1AVh93cKtLKZczcygxJjeiGHDY2gYjPfEtwZ1xJDXUiXlSuFcw7H+qoRyz0Yw=
X-Google-Smtp-Source: AGHT+IGtoJvehq4riOWexwfNgKdpkMWWE0VfBGLfW/XSk+dwEt34XfmWnzObtfog0UxhNagZVDH6UQ==
X-Received: by 2002:a05:600c:1d11:b0:430:4db0:3ffd with SMTP id 5b1f17b1804b1-430d7487c03mr2369935e9.4.1728442688278;
        Tue, 08 Oct 2024 19:58:08 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71df0d47a4dsm6819793b3a.118.2024.10.08.19.58.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2024 19:58:07 -0700 (PDT)
Message-ID: <262f4d14-1c48-4974-8c14-c01fab7ff98a@suse.com>
Date: Wed, 9 Oct 2024 10:58:06 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] ocfs2: adjust spinlock_t ip_lock protection scope
Content-Language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>, glass.su@suse.com
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240908140705.19169-1-heming.zhao@suse.com>
 <20240908140705.19169-4-heming.zhao@suse.com>
 <52e66e96-5edc-4b31-bc72-df2cf7881a9e@linux.alibaba.com>
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <52e66e96-5edc-4b31-bc72-df2cf7881a9e@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/8/24 15:18, Joseph Qi wrote:
> This is a standalone cleanup, so please send in a separate thread.
> 
> Thanks,
> Joseph

No problem.

-Heming

> 
> On 9/8/24 10:07 PM, Heming Zhao wrote:
>> Some of the spinlock_t ip_lock protection scopes are incorrect and
>> should follow the usage in 'struct ocfs2_inode_info'.
>>
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>> Reviewed-by: Su Yue <glass.su@suse.com>
>> ---
>>   fs/ocfs2/dlmglue.c  | 3 ++-
>>   fs/ocfs2/inode.c    | 5 +++--
>>   fs/ocfs2/resize.c   | 4 ++--
>>   fs/ocfs2/suballoc.c | 2 +-
>>   4 files changed, 8 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
>> index da78a04d6f0b..4a5900c8dc8f 100644
>> --- a/fs/ocfs2/dlmglue.c
>> +++ b/fs/ocfs2/dlmglue.c
>> @@ -2232,6 +2232,8 @@ static int ocfs2_refresh_inode_from_lvb(struct inode *inode)
>>   	else
>>   		inode->i_blocks = ocfs2_inode_sector_count(inode);
>> ... ...
