Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6FC1885B4
	for <ocfs2-devel@lists.linux.dev>; Mon, 14 Apr 2025 02:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744597773; cv=none; b=ovoyc8idjjn67Yjdk3YRHZJE/hTHRnzltDgR81Mq455C8J3Iefquw8YURDg34KRqPImKrP+rEp0bn/MbEdEvgSFKNx6A0SsLPO72m/e+wlIp365LknUqOGMcY4z1MvqH2YAWOAVhiZD5HPAGOsOxySjTcAVDclCMt0X8KY+887o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744597773; c=relaxed/simple;
	bh=duUdqV/PyusSf4IrhTIyC8v5JbWgR40LB41+sVv0tUs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TrUCVxhEDf0mQxj2P1KgLOSc02RUMLYCGZlJAs1HvjPY7aT9Y/yAJFyZpNi/Rly7rr+2QRl2GjKi+YGZAo6EnlPTcEBYSFTIRNS8mpKr51tya4D6XvFotdbH+O+C22x/KnnJ4UgeFFvKnKAUWlLFMSm/D7GYKkqJcqQa1RyHxKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FkIdJtY4; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FkIdJtY4"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-39123d2eb7fso148161f8f.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 13 Apr 2025 19:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1744597769; x=1745202569; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hR0gizsErti/TGxroMR8utxXV6Vg5v4cpuJKOHjP578=;
        b=FkIdJtY46zBC3h8pFI4yNN52cBV8iMIV7D7ci9iYDqVMxDoJJLLG+jN3Gaq2e3XtaS
         7TWggfxNIRhkkIPKQiWZGpgnkiCbSahAG2iJgMgKy/2RG3s5ZgG9qjTX9/UgV7gEiEJb
         9icmATUzBf3irrI7L46uffGl5T40iRzHL6XQp98LAWUVqMmrjtdHnwkCdLMj7dm41Mo8
         8xKD8/siQmaMrtH1di1lEjP6T3BgjqwLDC3AHmCfX0q2Euu4M5ZOB9HsIsxw8wA9USsW
         z/0MtPePZXE1+K2QOhFFkloymEPdPyxOnJIjD6zYknRjrdwJHviYIGR0RZVUe2zZhz3a
         BNVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744597769; x=1745202569;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hR0gizsErti/TGxroMR8utxXV6Vg5v4cpuJKOHjP578=;
        b=IYPb1ajdEgWLFHDCzmPqBIeAJ0o5EkoI392+uv2ieqHdR61fRiD6gaopI/zZ3Bibfg
         q/59DrZs+GnB8P5z+4syMV57gCKwsDVmO/3umUg6f0sObwpJ83tmpuBZT4kuADWKzA2a
         EdC60AL3z/ynffgxkqVyR7r2ZyKZgHmkWiTMWEJiXZ88ou403hhU08x/vBb0RWRjyOiX
         t+MKdIxMwUi/CPkOVND9flKMZua6v64+CpzDWToDbXvZNW/kwKwEgJM7Idj/MBV7kI7I
         ztKhdXKe4Pz2RyYNIn2UhSKE/SUjS4qnXEEpIq23VzGaDHZrx1dajwlQyoUG2XxNNucw
         +6Sg==
X-Gm-Message-State: AOJu0YzWKzhCN+6gN7w/AdaMsAo1kD+uYyF2qEvrW/NPqujENPmwYm4j
	JaJriMtdg7WJ7oct4HS5Q9oIi7LYqxivMeAy8sQomoO7MvfdRBW8YmBSev7DVJc=
X-Gm-Gg: ASbGncsJ44MuMMWnyFNhRXig0ts15f42sHgFQmjv4WXMbB4O7ztcPHytlXopXTGEt07
	e0PlTCmZwyp4fPtfMshemW5gMt84aQ5VjWFEx6lxIF5ONjtrRhdS38EJrvkdcuI9BrKJypPjc+B
	qVabyQyCvtXGwJT30/Ui8nzk8oLwfsi4xGDBi9ZYgrVnylippGZSTpdNNQcQaWp2tn41+maSRIp
	8+Xz/geG/M2gjXRdEyARz68sO+jx7O0NcKprAtJ+OU271sfG/WvuDGakA0XhUTJFj8yHnrLaeKc
	6WV9cle83U7YljPoL5EsCX68x/JA7HjJawC9WQ+kpGu6THo=
X-Google-Smtp-Source: AGHT+IFmUpcwPvEBGN8XjxBXwOtk2acq8URqHo+Q36iwySwg1DCxzO2m9xibFGCavUkHKNEgnyHH+w==
X-Received: by 2002:a05:6000:2484:b0:39c:1258:2c32 with SMTP id ffacd0b85a97d-39ec37565b1mr2676998f8f.16.1744597769246;
        Sun, 13 Apr 2025 19:29:29 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b02a11d2654sm8369962a12.35.2025.04.13.19.29.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Apr 2025 19:29:28 -0700 (PDT)
Message-ID: <b8c3e32e-02d8-4f80-8c2c-5bad9a31ac59@suse.com>
Date: Mon, 14 Apr 2025 10:29:24 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] ocfs2: fix the issue with discontiguous allocation in
 the global_bitmap
To: Joseph Qi <joseph.qi@linux.alibaba.com>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 gautham.ananthakrishna@oracle.com
References: <20250408152311.16196-1-heming.zhao@suse.com>
 <20250408152311.16196-2-heming.zhao@suse.com>
 <d48df38c-ff38-45c2-b941-8f51990e4699@linux.alibaba.com>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <d48df38c-ff38-45c2-b941-8f51990e4699@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Joseph & Andrew,

On 4/13/25 09:06, Joseph Qi wrote:
> 
> 
> On 2025/4/8 23:23, Heming Zhao wrote:
>> The commit 4eb7b93e0310 ("ocfs2: improve write IO performance when
>> fragmentation is high") introduced another regression.
>>
>> The following ocfs2-test case can trigger this issue:
>>> ${RESV_UNWRITTEN_BIN} -f ${WORK_PLACE}/large_testfile -s 0 -l \
>>> $((${FILE_MAJOR_SIZE_M}*1024*1024))
>>
>> In my env, test disk size (by "fdisk -l <dev>"):
>>> 53687091200 bytes, 104857600 sectors.
>>
>> Above command is:
>>> /usr/local/ocfs2-test/bin/resv_unwritten -f \
>>> /mnt/ocfs2/ocfs2-activate-discontig-bg-dir/large_testfile -s 0 -l \
>>> 53187969024
>>
>> Error log:
>>> [*] Reserve 50724M space for a LARGE file, reserve 200M space for future test.
>>> ioctl error 28: "No space left on device"
>>> resv allocation failed Unknown error -1
>>> reserve unwritten region from 0 to 53187969024.
>>
>> Call flow:
>> __ocfs2_change_file_space //by ioctl OCFS2_IOC_RESVSP64
>>   ocfs2_allocate_unwritten_extents //start:0 len:53187969024
>>    while()
>>     + ocfs2_get_clusters //cpos:0, alloc_size:1623168 (cluster number)
>>     + ocfs2_extend_allocation
>>       + ocfs2_lock_allocators
>>       |  + choose OCFS2_AC_USE_MAIN & ocfs2_cluster_group_search
>>       |
>>       + ocfs2_add_inode_data
>>          ocfs2_add_clusters_in_btree
>>           __ocfs2_claim_clusters
>>            ocfs2_claim_suballoc_bits
>>            + During the allocation of the final part of the large file
>> 	    (around 47GB), no chain had the required contiguous
>>              bits_wanted. Consequently, the allocation failed.
>>
>> How to fix:
>> When OCFS2 is encountering fragmented allocation, the file system should
>> stop attempting bits_wanted contiguous allocation and instead provide the
>> largest available contiguous free bits from the cluster groups.
>>
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>> Fixes: 4eb7b93e0310 ("ocfs2: improve write IO performance when fragmentation is high")
>> ---
>>   fs/ocfs2/suballoc.c | 36 +++++++++++++++++++++++++++++-------
>>   1 file changed, 29 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
>> index fde75f2af37a..2e1689fc6cf7 100644
>> --- a/fs/ocfs2/suballoc.c
>> +++ b/fs/ocfs2/suballoc.c
>> @@ -1796,6 +1796,7 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
>>   {
>>   	int status;
>>   	u16 chain;
>> +	u32 contig_bits;
>>   	u64 next_group;
>>   	struct inode *alloc_inode = ac->ac_inode;
>>   	struct buffer_head *group_bh = NULL;
>> @@ -1821,10 +1822,23 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
>>   	status = -ENOSPC;
>>   	/* for now, the chain search is a bit simplistic. We just use
>>   	 * the 1st group with any empty bits. */
>> -	while ((status = ac->ac_group_search(alloc_inode, group_bh,
>> -					     bits_wanted, min_bits,
>> -					     ac->ac_max_block,
>> -					     res)) == -ENOSPC) {
>> +	while (1) {
>> +		if (ac->ac_which == OCFS2_AC_USE_MAIN_DISCONTIG) {
>> +			contig_bits = le16_to_cpu(bg->bg_contig_free_bits);
>> +			if (!contig_bits)
>> +				contig_bits = ocfs2_find_max_contig_free_bits(bg->bg_bitmap,
>> +						le16_to_cpu(bg->bg_bits), 0);
>> +			if (bits_wanted > contig_bits)
>> +				bits_wanted = contig_bits;
>> +			if (bits_wanted < min_bits)
>> +				bits_wanted = min_bits;
> 
> This seems only valid when bits_wanted changed?
> 
> BTW, the previous fix hasn't been merged yet:
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/fs/ocfs2?h=next-20250411&id=767ba8b7cba3ca7a560d632f267f7aea35d54810
> 
> So should we drop that first and fold it into a whole one?

Thanks for the reminder, I rechecked the ocfs2-test cases.
In my view, in Gautham's patch, the analysis is wrong.
the call stack isn't from ocfs2_mkdir(), the correct one should be
OCFS2_IOC_RESVSP64.

Let's recall the first patch, and let me resend the v2 patch with a whole one.

- Heming
