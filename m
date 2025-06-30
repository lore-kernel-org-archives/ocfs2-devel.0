Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690981FBCAA
	for <ocfs2-devel@lists.linux.dev>; Mon, 30 Jun 2025 07:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751268196; cv=none; b=cQrJ7tpcn15R5k+bT7repoPyjPM5xKF1OCtTKDlqoKRWxQwEj1DzQCEjbW5Ow+2vtXUdQLK1Bfi+HcEl9i7uStgqzeHoIx+mGSlYK+kBoDAv0lGgAi+y/fw2+MAkiKFyDXt3awlbnfv0J0q/qOxGpKhaBvgxvu68ZrZzW8eZUyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751268196; c=relaxed/simple;
	bh=L07bGvTxELmymjUxM2xQnfORKx4Enre4j/1hjyANcNQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=buqh65Tkr/RgvZtX5lePlJs1Q9c9Kk9OPr6mbyIlpdZRbe9QZzxbRUhlUf2C1Q556BKJ8Zddr2YMvsNoan+cFpvSnQ+VCZGLxIIcnIvs3Tn2lBneWLbiNtUDYxCQxvrstasD5JPHwmijDrl1wAyfLOw1AN7lgKiDBi58Ja5QGoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Hle2QYuJ; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Hle2QYuJ"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3a6f24ef3acso443880f8f.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 30 Jun 2025 00:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1751268192; x=1751872992; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LCsXT39Oa/3YIM7cSMzutIRPzrnIV3/KBT6ARtsZFuc=;
        b=Hle2QYuJwQr7JFRSL+SZdwSBLAFbEpsCyVzwrHH/EwRoCMPBWVfwhjcWg4NSBN/76n
         mf59hUeCMVfOqbRhlMXnx59NQKif31ultkZpYAdztcPT876pOuniJaWGrVoDrUYVdtcO
         SZjOj/pPV1bZgyPJZTyIJtVIWzXemf2t27T0MMAVIkXE05MLyUmc0R1X/HirqzmgU66r
         2cmmvWopDq4pKdofOvRQUOudaUL+tlFMXJIheC0chAC4AUTWg73G1+2KaY+BfJdVspBl
         c4fNTLQ/VJN3CIaR7rTIcOKkBxBvZA//x/hnqu3V3z/uI/7ohL131jl0MYNLHEz/qcbK
         QV4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751268192; x=1751872992;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LCsXT39Oa/3YIM7cSMzutIRPzrnIV3/KBT6ARtsZFuc=;
        b=RzozEgT8HeRs0pH+vWW5s2S4xoVpyMMkrcl/TFGvjq7CX1Ce/G/z71+hvzJlijdV88
         e8iERqNvRegLP1gOeah/ioTYbN7wWQtE70CKOBmHCaxDBclUQxR+YOJ2E9mYDnBPYSvG
         dlnq9EO2O9RsYWaM2NKN83Ik6rG1/GER2/vxmwb/2hqu67MliqmmER6wtXLKnEwrvEpD
         y84c6f7aYweu/VXdUBXbakCgRVa5ce9P4ujgKpPBxy+9k/q8HEGlIwDdqGm7eXapyfFN
         4JJrNxAEFaJ+myRhS4tVZh9ax0NiIXvmPm4kRMh65EDuaT6RxSEBeQtgC4bEQLRxwGhx
         PuSA==
X-Forwarded-Encrypted: i=1; AJvYcCUEi0vkV+Lqaw/VV1l1s6ss9juNmYvnSOiB2W1jBR+dC5aHmjX2P7tFvQyASh+WWPexGWQW2CpJettDvA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzX5HE/nQ9iKT5MDx/F2qrIYGwS9HBtSJ0ATwqDKvFCQf7FEV6l
	/49snu7FufYW8Z3o9aYphuoheR1ORjTFC56gVaoPaT1Fa83eArzYxRHp32afH95tFuU=
X-Gm-Gg: ASbGncsV3SQwUDI5ZDTvw9xO0uLyzLaFgwe+6WMUF88TJHYEoGVI9z1s4Ul1zK1fj7B
	DKifq3O19G98mRbmcUoMmESCU97+hBtz10unz2CLqZYqCJdmyjEUGrB5zZggyIHOHTXj/OPX4Fr
	8d6RC+Xsu/9B1uDCGZ+9MuV0qUSu61NHaIzEczOJlTuTTOs7uk41hAIgcgNZrHMS4nsT1VEK3VX
	DGP7TJVX89eGRWuqvX6OFGiNPSmYC/neR5a7RXWwhEn1xyrVI1eqQ5RiQsuW/I7kiZOiiKuhfik
	pcVO6/vs04Gm9g52JpQuOw9XsjmtU8TBiHpx3xaSFWFBByy8vYPaLFSPXNxkdRsXUmYz9mIWDum
	nQws=
X-Google-Smtp-Source: AGHT+IG4eyyw2abepmK2ynnFXOiM0Oc0Y7o+zdGUgCtbUL2WGGA0BFKUPvEwrIEszUgqgCR7T2o42Q==
X-Received: by 2002:a5d:5cc9:0:b0:3a5:2ee8:ee1d with SMTP id ffacd0b85a97d-3aaf6189135mr1668010f8f.16.1751268192504;
        Mon, 30 Jun 2025 00:23:12 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb2e39f7sm75291535ad.49.2025.06.30.00.23.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jun 2025 00:23:11 -0700 (PDT)
Message-ID: <d049aef6-4dc1-4a20-a8e3-306fd3e3b63a@suse.com>
Date: Mon, 30 Jun 2025 15:23:07 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: Avoid NULL pointer dereference in
 dx_dir_lookup_rec()
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
 Ivan Pravdin <ipravdin.official@gmail.com>, mark@fasheh.com,
 jlbec@evilplan.org, ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Cc: syzbot+20282c1b2184a857ac4c@syzkaller.appspotmail.com
References: <20250627023830.150291-1-ipravdin.official@gmail.com>
 <d6c72ab8-d600-4cc2-9609-8b749b61703d@linux.alibaba.com>
 <d6a11613-9763-4d9a-b4ad-5f451f770b70@suse.com>
 <a259f224-a471-45e3-84de-7071ec6595e9@linux.alibaba.com>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <a259f224-a471-45e3-84de-7071ec6595e9@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/30/25 14:58, Joseph Qi wrote:
> 
> 
> On 2025/6/30 10:32, Heming Zhao wrote:
>> On 6/30/25 09:26, Joseph Qi wrote:
>>> Hi,
>>>
>>>
>>> On 2025/6/27 10:38, Ivan Pravdin wrote:
>>>> When a directory entry is not found, ocfs2_dx_dir_lookup_rec() prints an
>>>> error message that unconditionally dereferences the 'rec' pointer.
>>>> However, if 'rec' is NULL, this leads to a NULL pointer dereference and
>>>> a kernel panic.
>>>>
>>>
>>> This looks possible, but syzbot reports slab-out-of-bounds Read in
>>> ocfs2_dx_dir_lookup_rec(), not NULL pointer dereference.
>>>
>>> So I think it is because it construct a malicious image and set a wrong
>>> l_recs, then access this damaged l_recs.
>>>
>>> Thanks,
>>> Joseph
>>
>> I think this proposed fix (at least the fix method) is acceptable.
> 
> But this seems different from the issue syzbot reports, right?
> https://lore.kernel.org/all/67483b75.050a0220.253251.007c.GAE@google.com/T/
> 
> Thanks,
> Joseph

OK, I think I may have found the problem. In the URL above,
there are two issues/reports:
1> From: syzbot @ 2024-11-28  9:44 UTC
2> From: syzbot @ 2025-03-09 11:40 UTC

Your review comments about report <1>; Ivan's patch is about report <2>.

And the dashboard shows the <2>:
- https://syzkaller.appspot.com/bug?extid=20282c1b2184a857ac4c

It seems syzbot changed the fuzz code and won't trigger issue <1>.

For issue <1>, the rec was an illegal value, and made KASAN report a bug.

> 
>> the crash occurs at ocfs2_error(), where the pointer 'rec' must be incorrect.
>> look back at the previous code lines:
>>          for (i = le16_to_cpu(el->l_next_free_rec) - 1; i >= 0; i--) {
>>                  rec = &el->l_recs[i];
>>
>>                  if (le32_to_cpu(rec->e_cpos) <= major_hash) {
>>                          found = 1;
>>                          break;
>>                  }
>>          }
>>
>> either 'el->l_next_free_rec' or 'el->l_recs[i]' has an incorrect value.
>> we can do nothing about this kind of error, simply returning errno to caller is sufficient.
>>
>> btw, ocfs2-tools has a similar function "static errcode_t ocfs2_dx_dir_lookup_rec()"@libocfs2/dir_indexed.c, which sets ret with OCFS2_ET_CORRUPT_EXTENT_BLOCK and return.
>>
> 
> 
> 

