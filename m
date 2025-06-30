Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C662238B
	for <ocfs2-devel@lists.linux.dev>; Mon, 30 Jun 2025 02:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751250766; cv=none; b=GRv/83n5MAEwDLfKprMi7SsqOwEMTiCNykFQvQyKrWPsuoLEJUejy6823KBeZemwht2j+bj+opzcN8mf40zWHY6EU+H9GfT+Hfy68IdL50fXON9HEOgZx0Sm+s/WF7Ne5mlWVWm0paIuSgF+ijei7EzPYpksZsE4C2DTYQDWSyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751250766; c=relaxed/simple;
	bh=y3AHwHar+N9H3e942UyjUO2ocmj/PZKf1yl3Y61feWo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bs65YzYuzE8nEXIG1AqmHQV0yQsJVywhSV+e4ivQVuM+BExXoGFRoHK73huPbg95r/dXy99V8cBUDYTNyVRlJACYESXiJiCjZe9ZP5uYiR7YY6MNE4DzAwDA1Yp+pF79jiq69l3IWmX4zIpLXUF16KD+/3y8Fjxr3xIDE7QTzgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QA90MTb0; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QA90MTb0"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3a577ab8c34so567557f8f.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 29 Jun 2025 19:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1751250761; x=1751855561; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l32+kcHFTvy/thF86Ip4IcL7WEZnxbK2oPIvL0HseaQ=;
        b=QA90MTb02toGRcOqXcOWBdxnRH8NBIrlqwI4y+0OUDFDKXMtVDybTZdcnnuImxyYyS
         /PsNMiOydE7cP5zuaj/ZTUFSbeVzuLGQ7aoC9sQnWa3i4nRYO0tbT8jmvsayICYrAKdv
         s5nxVH1deZXw+la2PDfs4Xs0Kp23JnlidIZMj3p+aZxZEC4FfVHzG8JiOdvcK6OsnVUW
         HoiFh/3MS0D3v72wxBf19S99fn+VuKe14YCZNzPY/EwxaY2xkxJHez7dkZYTEnh8KF0w
         Icb+2e2CIx4dia03n+nA8LlmAptJu+Xbs+YisaUQ+wvGJB2Nd7oNFGV1w9NRtExllOQE
         MdUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751250761; x=1751855561;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l32+kcHFTvy/thF86Ip4IcL7WEZnxbK2oPIvL0HseaQ=;
        b=Lyv6/bulXpdd7QsvvmovTgDIxeae1nqOanQWjQSaJP7gOTfWmtPuuqdyaM2vaioDbg
         VGoJXX6kgqHqRqjkgUqGo55hYL2/12fPUOx6dZWcnacZH6Jz9Y99qYKY6mRakhcvB1Hb
         Buo4/eB1F7gnj0HgsFTUecrqqSOmiXYEqOeejLIXdbnyrVpgMTBpq2SRN4d7k7ArVjtF
         GnD80oKJ8jagXMmUE6ejhjVPc5ssUktsEVMufgw5MR1KMDlRQ2Qj/lNa//QD/2U+Xxs8
         Gjvd1djMI/LBjMbBmQvGamXraUM2OJVFj8EEDjEMC3D2eOIZbyBG5AAYivkFiaqkBOBr
         SjFw==
X-Forwarded-Encrypted: i=1; AJvYcCV4IOgiIVCQLMVgHIXYup/hWz391Bv67AY9yeoBVxC2boaSelIYjPr9cjkpLFn/OJI9YkO8dfHPkCUWoQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwiZ4U1Cel8SgC1NCxLdwhHAgId43k8rDWIqKS6vjM0861BJlkM
	8Y1C+q61Z0NK0ClArDfI1zbX0FZ95o8428LxVGyR+HNjtRW3uOAERAanY90jBhTjji0=
X-Gm-Gg: ASbGnctG1Ojij+t0MBfxS1RmfmO4/rzUYVNBkcin2EzGvH7Yb8JQC+spSW0YFw3ntiK
	Tcvww/PUEilUzWf/9J/mj2dC5bmZ/ZLGg9jdFrnUCHNATy/4jTQODwKWF29owOIYL4s3XtaJdPw
	tqBNZRf74KmCBLReyPLpdjm0sWGygs++ciIVjF2UaQd3FiSdADMdQOPK3qkBMVqpDb8cZjFOPsX
	HznYrEGSnRQTy6wP74fTsTJ6kqyhknjgKv0oh9VtCr4Kx6pO0CaIm/FOpktYIp+9Z5bWBZ2YpZB
	BGr8dMoHEbfeJzsJU5qGMa/Uian/jF7X8ZZOPRmEV5W0DTbGFK000qbCNPwipN3KTnFR
X-Google-Smtp-Source: AGHT+IHJ3NA83lSuJiPSZMXnyu4C9IeZszL+f7Y95Ou8Uhmb0EnG9Rp+Ou87ri5n5sK2SBJ4yJXiyQ==
X-Received: by 2002:a5d:64cb:0:b0:3a6:d680:f282 with SMTP id ffacd0b85a97d-3aaf43b95cfmr2011878f8f.7.1751250760988;
        Sun, 29 Jun 2025 19:32:40 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb3bbf9esm68908445ad.191.2025.06.29.19.32.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Jun 2025 19:32:40 -0700 (PDT)
Message-ID: <d6a11613-9763-4d9a-b4ad-5f451f770b70@suse.com>
Date: Mon, 30 Jun 2025 10:32:35 +0800
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
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <d6c72ab8-d600-4cc2-9609-8b749b61703d@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/30/25 09:26, Joseph Qi wrote:
> Hi,
> 
> 
> On 2025/6/27 10:38, Ivan Pravdin wrote:
>> When a directory entry is not found, ocfs2_dx_dir_lookup_rec() prints an
>> error message that unconditionally dereferences the 'rec' pointer.
>> However, if 'rec' is NULL, this leads to a NULL pointer dereference and
>> a kernel panic.
>>
> 
> This looks possible, but syzbot reports slab-out-of-bounds Read in
> ocfs2_dx_dir_lookup_rec(), not NULL pointer dereference.
> 
> So I think it is because it construct a malicious image and set a wrong
> l_recs, then access this damaged l_recs.
> 
> Thanks,
> Joseph

I think this proposed fix (at least the fix method) is acceptable.
the crash occurs at ocfs2_error(), where the pointer 'rec' must be incorrect.
look back at the previous code lines:
         for (i = le16_to_cpu(el->l_next_free_rec) - 1; i >= 0; i--) {
                 rec = &el->l_recs[i];

                 if (le32_to_cpu(rec->e_cpos) <= major_hash) {
                         found = 1;
                         break;
                 }
         }

either 'el->l_next_free_rec' or 'el->l_recs[i]' has an incorrect value.
we can do nothing about this kind of error, simply returning errno to caller is sufficient.

btw, ocfs2-tools has a similar function "static errcode_t ocfs2_dx_dir_lookup_rec()"@libocfs2/dir_indexed.c, which sets ret with OCFS2_ET_CORRUPT_EXTENT_BLOCK and return.

- Heming

> 
> 
>> Add an explicit check for a NULL 'rec' and use an alternate error
>> message in that case to avoid unsafe access.
>>
>> Reported-by: syzbot+20282c1b2184a857ac4c@syzkaller.appspotmail.com
>> Closes: https://lore.kernel.org/all/67483b75.050a0220.253251.007c.GAE@google.com/T/
>> Signed-off-by: Ivan Pravdin <ipravdin.official@gmail.com>
>> ---
>>   fs/ocfs2/dir.c | 16 +++++++++++-----
>>   1 file changed, 11 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
>> index 7799f4d16ce9..dccf0349e523 100644
>> --- a/fs/ocfs2/dir.c
>> +++ b/fs/ocfs2/dir.c
>> @@ -809,11 +809,17 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
>>   	}
>>   
>>   	if (!found) {
>> -		ret = ocfs2_error(inode->i_sb,
>> -				  "Inode %lu has bad extent record (%u, %u, 0) in btree\n",
>> -				  inode->i_ino,
>> -				  le32_to_cpu(rec->e_cpos),
>> -				  ocfs2_rec_clusters(el, rec));
>> +		if (rec) {
>> +			ret = ocfs2_error(inode->i_sb,
>> +					"Inode %lu has bad extent record (%u, %u, 0) in btree\n",
>> +					inode->i_ino,
>> +					le32_to_cpu(rec->e_cpos),
>> +					ocfs2_rec_clusters(el, rec));
>> +		} else {
>> +			ret = ocfs2_error(inode->i_sb,
>> +					"Inode %lu has no extent records in btree\n",
>> +					inode->i_ino);
>> +		}
>>   		goto out;
>>   	}
>>   
> 
> 

