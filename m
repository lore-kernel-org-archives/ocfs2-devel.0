Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8673D29408
	for <ocfs2-devel@lists.linux.dev>; Thu, 18 Jul 2024 02:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721268692; cv=none; b=Ipf7vzD67of7+QXPPoPHdI1xxtFTAd0/kO8PJr3JC/dBBpWHHrr2tGMAaOoaq9qfoWSToJ8wusVd4zvfrroRpcC7KKf6+fZwBn2ldvKBFCWPwd7aS+1qcuxBxXnefVRGNBnhKkPnEX48I+MPOmK91ajt/JTfPaFq8Vh2HqkCgEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721268692; c=relaxed/simple;
	bh=4xzfcsuqTxZwY7RlHZV+7qhI82rLx6TQ8ftnCZb8uRc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fAcXr6sPRxQDeeiBopB7GqYRGYLw6/MkpLhm0cqDcVZLexoY6wqnHUKpd1WVRdUOHTui/bVhTQCseASejZ+T0a9JzWOYD9NpnPm1VZj8eEkI5leZ1hThHrJ5LeEzqkCRdJjPZY8Svs/jR7qYdyD5uQ1VVNLW6JIQlVpZTMIea/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TRZfXMgE; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TRZfXMgE"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4266ea6a488so2188395e9.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 17 Jul 2024 19:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721268687; x=1721873487; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QcHRkM/E3xz0ekTu3V5t7izz9CLt++l/6sLoKNCq8qk=;
        b=TRZfXMgEMgmY93aMTMHMDtZcbvnn68ClSStX4ulEyVS5BJzmN6nTvyKtlF8rxLUn9E
         dMozmsZMC5Luhh4Ua0CDIymH1xCmqUPA6lI8qPQ2oTLikj1+hVGiPuyRtBf949UNpg14
         arHmw2zpSgjD9GDnsWI1hDSDCjLVoxdLJ9oOSPJrOOpZCzcq9oo7lA5VTaOKwlYAYj6O
         vn3RwyZEZMdLZuTZVSNq106xZjoLNp6IQwzoTGwvJIytNqzktNmz6Ji01K4MaHRFmqaP
         9QxWsjTKOpYF7X928qtZ6344dGY8AOF60nE87iJ2rLwBab9FSZlv1/4QUv9SwQQ/DhY9
         2Nqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721268687; x=1721873487;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QcHRkM/E3xz0ekTu3V5t7izz9CLt++l/6sLoKNCq8qk=;
        b=NxumCuXGgjaD7vPVMVHQPfSmC5/Lul7F6GH/iSRQmkOMSzwC2H64bcYovxbkPhOAK+
         3Mr5Wg1SMgvx7/svm7wVuP3jFvAAveUv5HvyvuzFwsqmmCKz4sDqelichr4KdOgK/TB7
         XA+p43SRASIcINIiZ0+SUaiHj2sHGaV8WLncLzvhl8+wBvy0EKP8E1nQNoJ4slBrf40x
         /1d0fjtvZY70BGeDwSclOCzxizg2IRY8vPe3k7N2I9ey5+QM9kegZ0SZFXVZxqPB7VqH
         7u9lqTrqISb4slQwyGQsj8pQxBNV5WN96wNN77k2bSqZwN0nxcqQ11oHY3DOeY4KpCcY
         pyxw==
X-Gm-Message-State: AOJu0YwIjyAksLnUmbG6isBqTWAIe+lyO1s5shclhk+JoAgU9av1nWld
	SwkrIwS1vXWPNEn4TuGA6gVTlxaRKxse5D7R/I/uZvvxPkkNoMwTXPS7j6xIqIg=
X-Google-Smtp-Source: AGHT+IHfPvPSqN3rRuoatWI2gOK5YWf5iNEuIylI0uwaqR5PkbO8ljlfr4dmbYsfwFNBaH2pVWqszw==
X-Received: by 2002:a05:6000:1fa9:b0:366:e986:22ef with SMTP id ffacd0b85a97d-368315f1eeamr3826301f8f.4.1721268686807;
        Wed, 17 Jul 2024 19:11:26 -0700 (PDT)
Received: from [10.202.0.23] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-790d5e0732csm5601298a12.63.2024.07.17.19.11.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jul 2024 19:11:26 -0700 (PDT)
Message-ID: <814c5492-0d03-48b0-8fa8-6bdff6771a65@suse.com>
Date: Thu, 18 Jul 2024 10:11:22 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ocfs2: fix the la space leak when unmounting an ocfs2
 volume
To: Su Yue <glass.su@suse.com>, joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev
References: <20240717064424.11090-1-heming.zhao@suse.com>
 <1eda17b9-113a-481b-b5a8-a3c7173a5476@suse.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <1eda17b9-113a-481b-b5a8-a3c7173a5476@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/17/24 21:54, Su Yue wrote:
> [resent because gmail webapp appended html content after plain text]
> 
> On 2024/7/17 14:44, Heming Zhao wrote:
>> This bug has existed since the initial OCFS2 code. The code logic
>> in ocfs2_sync_local_to_main() is wrong, as it ignores the last
>> contiguous free bits, which causes an OCFS2 volume to lose the
>> LA window size space on each umount command.
>>
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> 
> LGTM:
> Reviewed-by: Su Yue <glass.su@suse.com>
> One nitpick below.
> 
>> ---
>>   fs/ocfs2/localalloc.c | 19 +++++++++++++++++++
>>   1 file changed, 19 insertions(+)
>>
>> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
>> index 5df34561c551..0c45b139d9b9 100644
>> --- a/fs/ocfs2/localalloc.c
>> +++ b/fs/ocfs2/localalloc.c
>> @@ -1002,6 +1002,25 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
>>           start = bit_off + 1;
>>       }
>> +    /* clear the contiguous bits until the end boundary */
>> +    if (count && (start <= left)) {
> 
> IMO if (count) is enough. start can not be left + 1 as start is calculated from bit_off + 1 in the above loop. So start - count is safe.
> 

You are right, thanks for the review.

-Heming
