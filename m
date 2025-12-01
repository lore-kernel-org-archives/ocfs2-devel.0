Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77D030215C
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Dec 2025 10:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764583598; cv=none; b=PUACGrlv+i02jW/ndNfU9TTXZadONUaK9ciLkVcfvMAiP2aKiInxiwvkuei2ufLHxRrFF7i2SgkQIabga3LVYFdgXl9PRiwm5p9sKw1LsJJPCZYeqd+bPPcqpuf5lXdDSMPHe57IkhTu5StAYBOSZrbD40nRa+OWAKMEazVNtd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764583598; c=relaxed/simple;
	bh=/RXCU9YMtZFIq/MLgD8PmUQsD/aM9+YYw8N1WW/ZQzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IV2OHekzWLkG5gk4PMuTZC7s6UpO8k89z89Qg1ink6s1j3GFYAR0IY++Zne/jJgtA2jTMmFrYELVD1Hj2ycEB7rsZ5hazLHHBrpqTq0lLwN1yn/ZuYI4LIRgjzMXAdxbp4btnEvLF4IGhiFqyBWXxqYtBJ7QzZHPBXn9HWarIgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WWn5SmYJ; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WWn5SmYJ"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7ba49f92362so2266849b3a.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Dec 2025 02:06:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764583596; x=1765188396; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=o/z5pMVIch3yE7Wi6Gwka6LLcLmOaOln6MJU3xeFk0M=;
        b=WWn5SmYJIIMardrf/KwNfgtk2Hr5atAXTQpTlmHYcWPSBTdTLNWpZ8UlqCqA8/oGbY
         BsRLtP5nZklExiLKMCRKB8g2scwf6vlQVrbd3wJIbLg2r1jyN5+GE8dlZGwI1sYgpN7S
         5rpxXHbz3R89bxs4nHt7VZRQFIQoskKF3gWtwRF374so3cjmO+a8Iz05pH2pQEXUmdrD
         FdekNAdX48zui+W2YkmPyBLKrDOhiIzfiIVzU7v2M3OrlmLHRGFVQ8NhI/CbEgsvnZRs
         gkcXAfvE/7McYUjloSfHwEyaCmui0tC60Bx7zKc7NI0ncUKVHJ8tWw6Kr5i0yfsI/lks
         4TZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764583596; x=1765188396;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o/z5pMVIch3yE7Wi6Gwka6LLcLmOaOln6MJU3xeFk0M=;
        b=DKvLerKJyyA+xdomRj5YW34cjOEz3dw0HypXfX+prKTDcuZ29Yv94TTY/bAb2a5vXs
         Eh6dPjmuZ9bc9BrAlCkOJMQsM7pOSC6UBjAV1Hlo/jcYOPIwhcG8oMhGmggdlV3wMzLr
         fk7rJvgqKvv5mOnxZt/HFgWNl7fkNAhEceR6ovA7lAB1WIXunq3vC5Km0awTAg5pd1gP
         /8MlaH8UVyW7a9Og84EBOcg/oHqUUfJYXsY3lBECvPF53Ev1rQB8NTTuuiT8HhDl8A2A
         /Oyou8Mx0+VcD747leuTqSpQPstT3F/YyHVwN54WILCZcbs7BbWrtVPlptIgtPhNV1bR
         fiyw==
X-Forwarded-Encrypted: i=1; AJvYcCWI0b2BQeDoWUTIMQZujXKCkMb5t8aX6nOm0ShvfX6RbpEHu7hPq5eAu8Cmn8SJBfb7tAy0j3l4/JW1zw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxBTizavLKv/QGW7M1gkdOi5lNZ3zAUBi+9VGVe3xw18lHlgh0M
	ys0LF+u2CGZ+l9t2PP6E0JsRBW+Y/TgaE1u9yD5LRReCb0adjA1B9fKZ
X-Gm-Gg: ASbGnct5A8G/8jHcst8bgOUn8HgOEuiY1kvjM6mxGmcM/O92pO7708AC/hBTRqnkAer
	jvVRsksQFUZdlSH/vTEibOlxecIx3JplXta1V4UCJpM1lXfk6ICi4DWgYWOLPq+a+cUUYFn0cDM
	lPzL4SBBLv7PFYEZjeU8ymeti2W4bDdRojln0iIvxRqlFUMVlKaGA2YbISmNtyiSJndJPPuLFV6
	J25iF+1eBhD6AOWjMW+3ihAyaL02ycMLQpaCB2P2Ef2t1fdonp/pYEBNSsCGvpQqkp64gNmY3NN
	TY7VgYMSo7xL4C3Aw5vcAVnZlpmrX/kV3vVQShNHQF5wIeA43cptJWFqn6+XlW4pfIv6rlQ0LWW
	CT0WHDeBwiDl2+6QAHmW65/8X0NM2M2Mnz32HByAMME8QhgGXfzkPzDeZGU4n154+chynbyHDXm
	1Vr5vq5usjWwTTUalP21tn
X-Google-Smtp-Source: AGHT+IFV+QOFwIbgxkIXTta9oiGaj8O2uodMFcCv3JtloLD3IcPzHdZB4atL7Tljg2zC2VeKT+l0hg==
X-Received: by 2002:a05:6a00:12e3:b0:7ab:242b:95c6 with SMTP id d2e1a72fcca58-7c41e30b4dfmr38632843b3a.6.1764583595927;
        Mon, 01 Dec 2025 02:06:35 -0800 (PST)
Received: from inspiron ([114.79.136.226])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d15e9c3f0dsm12944959b3a.37.2025.12.01.02.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 02:06:35 -0800 (PST)
Date: Mon, 1 Dec 2025 15:36:27 +0530
From: Prithvi Tambewagh <activprithvi@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
	khalid@kernel.org,
	syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] ocfs2: fix kernel BUG in ocfs2_find_victim_chain
Message-ID: <aS1oo9AyyRGER6Xx@inspiron>
References: <20251201092450.84991-1-activprithvi@gmail.com>
 <fa898d5b-ac9d-44bf-ab98-a520f89dbc28@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <fa898d5b-ac9d-44bf-ab98-a520f89dbc28@linux.alibaba.com>

On Mon, Dec 01, 2025 at 05:56:43PM +0800, Joseph Qi wrote:
>
>
>On 2025/12/1 17:24, Prithvi Tambewagh wrote:
>> syzbot reported a kernel BUG in ocfs2_find_victim_chain() because the
>> `cl_next_free_rec` field of the allocation chain list is 0, triggring the
>> BUG_ON(!cl->cl_next_free_rec) condition and panicking the kernel.
>>
>> To fix this, `cl_next_free_rec` is checked inside the caller of
>> ocfs2_find_victim_chain() i.e. ocfs2_claim_suballoc_bits() and if it is
>> equal to 0, ocfs2_error() is called, to log the corruption and force the
>> filesystem into read-only mode, to prevent further damage.
>>
>> Reported-by: syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=96d38c6e1655c1420a72
>> Tested-by: syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
>> ---
>> v1->v2:
>>  - Remove extra line before the if statement in patch
>>  - Add upper limit check for cl->cl_next_free_rec in the if condition
>>
>>  fs/ocfs2/suballoc.c | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
>> index 6ac4dcd54588..1257c39c2c11 100644
>> --- a/fs/ocfs2/suballoc.c
>> +++ b/fs/ocfs2/suballoc.c
>> @@ -1992,6 +1992,13 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
>>  	}
>>
>>  	cl = (struct ocfs2_chain_list *) &fe->id2.i_chain;
>> +	if (!le16_to_cpu(cl->cl_next_free_rec) ||
>> +	    le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count)) {
>> +		status = ocfs2_error(ac->ac_inode->i_sb,
>> +					"Chain allocator dinode %llu has 0 chains\n",
>
>The log message also has to be updateed. How about:

Apologies for the mistake. I will rectify it.  

>
>if (!le16_to_cpu(cl->cl_next_free_rec) ||
>    le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count)) {
>	status = ocfs2_error(ac->ac_inode->i_sb,
>			     "Chain allocator dinode %llu has invalid next "
>			     "free chain record %u, but only %u total\n",
>			     (unsigned long long)le64_to_cpu(fe->i_blkno),
>			     le16_to_cpu(cl->cl_next_free_rec),
>			     le16_to_cpu(cl->cl_count));

Thanks for the feedback! I will make v3 for the patch with these suggested 
changes.

>
>Joseph
>
>> +					(unsigned long long)le64_to_cpu(fe->i_blkno));
>> +		goto bail;
>> +	}
>>
>>  	victim = ocfs2_find_victim_chain(cl);
>>  	ac->ac_chain = victim;
>>
>> base-commit: 939f15e640f193616691d3bcde0089760e75b0d3
>

Best Regards,
Prithvi
