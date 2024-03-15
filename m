Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE34A1C6A7
	for <ocfs2-devel@lists.linux.dev>; Fri, 15 Mar 2024 12:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710505594; cv=none; b=D2f2J0G0rzQph77YTviSGXGnp7MriLVN1yiosXSsnVSPRWhCII1+HdQhmY8PeBrqS2c0gHJYlWpNfTfCjztRAPqVK/TlWAIaUpiG6OG+7a140mAQRLRw7oTPPa9K7EaHwRLa0h6P2IRUHZoH6SoQ4Y6D3ou0zh8BZfrznTduy/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710505594; c=relaxed/simple;
	bh=dE9tgOxuV/pr4l+fOqwXTBe2JyoQ78YgTHa8NAuzBss=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WrtgTMyi3Y+Kbhm/v8frn3DEddWP47FN08VDgF8lGoGfZWCTziTNJlpf4H5pAEdkCeuivqDNR2No4qFfj63AKIldH5BfAh2nRkseTxJaKkxe+C7Fu4BGB+S6zF0/DSz2sOu1goE5p+w5AfcVG++idfIOOBJURBhvBH4oKzDY1iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=V3cCAlOx; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="V3cCAlOx"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2d27fef509eso23703611fa.3
        for <ocfs2-devel@lists.linux.dev>; Fri, 15 Mar 2024 05:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1710505590; x=1711110390; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eitR6fUctadehVkq3Lx4C76HIb5SSoBvdgDKtjexr50=;
        b=V3cCAlOxxRdlxxh5HgeF+uE0Phpjo7drBJRbe52QdNcjMvYmUIrwv7/coeXPQ59zBr
         rM9s+paj8Bcy+1gIIrCawFiI9c0gihquKgfgcnK9vxmQS0PgHS4hToiUz9vhbsIMjzMt
         BxZlucuClj1Y3cfXALwFkUoob34wqydvIEXJGjuI3Fgc+daYFPiWoZA38DO/OjH0f8Cd
         O6OqU9YP/S83xZMbrhsRJexeQNxsIczJro0imt9YxX3R3qMA1dS7cLRTpITEXH+aW7jN
         l6uJd2RZN1l2UUxYJ4xcnltnFUP0+Qk9GN0WFa5u2vALrV0G/PhmjahRzkowB9m+yggQ
         hWnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710505590; x=1711110390;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eitR6fUctadehVkq3Lx4C76HIb5SSoBvdgDKtjexr50=;
        b=WNfd1qpwyPMkMafDZmbGyVpplixuXXCOJI//LC2buIYPhbaCc9PRrQ7z4OooBlkuPj
         1ovw1Ec/JgisdbNS7+5JaliFf2kRinBuiRvEyX8ImUi1NRDwOrBJ7fi6wp3GLjMXX1Z2
         3hKrZHWyq3s6o8BbaVCBN0eNisEH0550Y6eL2tmE9TtLhtzTSArtCGuzCoVvIYbHFvAR
         XzNeC6iC95BZc6Svjhma2GYSmaeSg2V/5Ts8Fv1OUS/ODSF1hCOfMmpSUgDdevWptAcJ
         dDDLsRUIXZo0iuiYZiayJ2NXFvY6A3UQgPcTF9mSZXAbdyX9aVrRbsyKvPNArZHP/2et
         UYJQ==
X-Gm-Message-State: AOJu0Ywj7yKwaqObGfSMB6LCNFkRgUPhQiI5sMXQJLDaBPRnjhMb65Lk
	lKvHLOh4p59lfFMxQ50DNbEbAw/vF1Qtxo7W3SWTiWkgUtXomyxZuOS5Oiu1VCmB8WmreJSKu4f
	0
X-Google-Smtp-Source: AGHT+IGKUISxc/wxlTC2UDrX4KZk9LO5VR4GnMzhJ4heiJTISX6lCHu42BBZ8zwuYQ8brUx561EpLA==
X-Received: by 2002:a2e:98c2:0:b0:2d4:6aba:f19f with SMTP id s2-20020a2e98c2000000b002d46abaf19fmr3185125ljj.32.1710505589773;
        Fri, 15 Mar 2024 05:26:29 -0700 (PDT)
Received: from [10.202.0.23] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id i36-20020a635864000000b005dc507e8d13sm2329960pgm.91.2024.03.15.05.26.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 05:26:29 -0700 (PDT)
Message-ID: <a23556e2-7b15-499f-ba60-0b93c5b796d0@suse.com>
Date: Fri, 15 Mar 2024 20:26:26 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix journal protection issues
Content-Language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev
References: <20240314073353.11489-1-heming.zhao@suse.com>
 <1e0cd8fb-ca1e-4937-bdfe-333284569425@linux.alibaba.com>
 <306d79c8-f327-4c34-b103-a59d8ca87567@suse.com>
 <c535edcc-67da-4c40-bfd2-decd602bfded@linux.alibaba.com>
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <c535edcc-67da-4c40-bfd2-decd602bfded@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/15/24 15:22, Joseph Qi wrote:
> 
> 
> On 3/15/24 10:25 AM, Heming Zhao wrote:
>> On 3/15/24 09:09, Joseph Qi wrote:
>>> Hi,
>>>
>>> On 3/14/24 3:33 PM, Heming Zhao wrote:
>>>> This patch resolves 3 journal-related issues:
>>>> 1. ocfs2_rollback_alloc_dinode_counts() forgets to provide journal
>>>>      protection for modifying dinode.
>>>> 2. ocfs2_block_group_alloc() & ocfs2_group_add() forget to provide
>>>>      journal protection for writing fe->i_size.
>>>> 3. adjusted journal_dirty scope for ocfs2_update_last_group_and_inode().
>>>>      This adjustment ensures that only content requiring protection is
>>>>      included in the journal.
>>>>
>>>
>>> Any real issue you've found for above cases?
>>
>> No. I just found these issues when I was reading code.
>>>
>>> Take ocfs2_rollback_alloc_dinode_counts() for example, it will always be
>>> pair used with ocfs2_alloc_dinode_update_counts(), more precisely, in
>>> the error case of ocfs2_block_group_set_bits(). And the 'di_bh' is
>>> already dirtied before. Since they are in the same transaction, I don't
>>> see any problem here.
>>
>> Yes, they share the same transaction.
>> However:
>> In ocfs2_alloc_dinode_update_counts(), there already uses a jbd2 access/dirty
>> pair to protect metadata. In my view, jbd2_journal_access starts the
>> protection stage, jbd2_journal_dirty closes the protection stage. the rollback
>> function should start a new access/dirty pair to info jbd2 the di_bh had been
>> modified again.
>>
> Refer jbd2_journal_dirty_metadata():
> 
> /*
>   * fastpath, to avoid expensive locking.  If this buffer is already
>   * on the running transaction's metadata list there is nothing to do.
>   * Nobody can take it off again because there is a handle open.
>   * I _think_ we're OK here with SMP barriers - a mistaken decision will
>   * result in this test being false, so we go in and take the locks.
>   */
> 
> So IMO, we don't have to access/dirty again since the buffer head is
> already added before.
> 
> Joseph

Thanks for the detailed info. Regarding the jbd2 code, you are right.

What is your opinion about other modifications of my patch?
(the modifications about the jbd2 protection scope.)
under above buffer protection rule of access/dirty, in function,
the bh is same. It seems like the jbd2 dirty function could be
called anywhere regardless of the end-use point of buffer_head.
it's counterintuitive.

-Heming
