Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235CB20DD0
	for <ocfs2-devel@lists.linux.dev>; Mon, 18 Mar 2024 05:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710739760; cv=none; b=BndOXWoyAWVRSAcv12nAtzqkcfX+i+2TnL6k8InweZofqXL8unfPQ7ZlwenkR3TRFNiXu2Ud63LMHyh8foBE9jY/Ruj+p1csf55/ZtGu5HZecuKj0sIhchyJ/NMxtTLT83z6MelpPUZ2Apo+H5pEA3SlYofelHka2Nj+fbxDNfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710739760; c=relaxed/simple;
	bh=CfdvJdjunkCmaFaE5SWNqYrI6NoL8R4L2HiesAvU+HA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tzttlIkFh2GrAD2ov8uKZrOWhuvgCoO6PJDIPpDoSKSKPRjqpHDlECgLnkB8fM5GxuKeMd/MrnvT+h/EWKB/0rn2a34PpXjf3NAHM1j/AZidFg0rtjToANYQTeNIg8HPtkhEzeVGD8/OgFlfRrtyoB3cZ7zBObiL6v0Nm1KIUrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PkWz42Nf; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PkWz42Nf"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2d4541bf57eso51651571fa.2
        for <ocfs2-devel@lists.linux.dev>; Sun, 17 Mar 2024 22:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1710739755; x=1711344555; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ipGwt5yR9UX6npEOzrtnTV4jlAIMHFjxLngNmt387Xc=;
        b=PkWz42NfDiurWu2zONDJrlO2w9UDl9u2YmH1IBp5qLKEWaOg79dFFNnqKkhie5QRFo
         CaaMmsfRSKV/YebXZoWby8enhsCToz8NigkNk4WUEv+46DwK9KBEN2bOl1VgxNAvnVJR
         VpKCWsN4PSNp9RJ5lPxeD8osQKTyXYrdX/ABzlaqspf7ZNEhZmWFX8ABls6r4c0JIe1S
         LKp1c2cNr3r3+axlTDPLSpdbDxx+fttRowt5plDFKPect8pnVJXGLG+ab+6yO7ZrJSsE
         rFznVuxG0xiKHvWalrash8ae+xd8Uh24GXGu7PhdqFZgl6Vdb580hkHPQ0iLdSxXCS5Q
         f+sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710739755; x=1711344555;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ipGwt5yR9UX6npEOzrtnTV4jlAIMHFjxLngNmt387Xc=;
        b=b4ohqV5AZmXQjCrbmzu30YbL2E2u/KENAcTC6vcrS/Z3wVDjNNZsbqu9t8TTnyJaBv
         XMeqJCin8TQs0WWArqBZlsNVNuVia/7ZSDrMTAO6tgvdMzY5HSwkTWKb13R+qX6u79MX
         3UYHNmJVpVWM8p9XRXfeLQjUZl5eHS5F+FbZmyQYJuxxZl2/TPZVYmLBoHyOi5tkw1DT
         a9/1V5XWReEY3ROdVMAda/gd6w3rv+d9YZNBZF26N7IRxM57eVY5hzDEy918zi3NAW7s
         Nwpt4v7pr7DX4AsbjBSPUBumdVu8tnqqZLwmAhT+FdvZxyN0FuscBJnUD/lB5EbK3fDz
         3kiQ==
X-Gm-Message-State: AOJu0Yw89KJlJqgCB5AHePxkqKRB97kupp14WWk6NtbMZyPcHsrKtYxv
	HTdwViO8YNVPK3xnVuadopOOvsS7rQOiKGX45O8OQAg17jce/wZqI/3OwCExusI=
X-Google-Smtp-Source: AGHT+IHmMu037Utzb1FDakoSKVZ5u841XGfCaeE3CzM4ikD8Dd1ZeQHnwKrJ0eZ7cdTm6PSIaJAKCw==
X-Received: by 2002:a2e:9019:0:b0:2d4:6e71:59ef with SMTP id h25-20020a2e9019000000b002d46e7159efmr6796869ljg.5.1710739755126;
        Sun, 17 Mar 2024 22:29:15 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id l23-20020a17090a3f1700b0029bce05b7dfsm7434885pjc.32.2024.03.17.22.29.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Mar 2024 22:29:14 -0700 (PDT)
Message-ID: <1f8715a2-cc77-4203-9d38-ecf99bb71198@suse.com>
Date: Mon, 18 Mar 2024 13:29:12 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: improve write IO performance when fragmentation
 is high
Content-Language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, ailiop@suse.com
References: <20240316034457.16893-1-heming.zhao@suse.com>
 <b09feb83-c506-4c5b-a6dd-c5a7d24f45e3@linux.alibaba.com>
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <b09feb83-c506-4c5b-a6dd-c5a7d24f45e3@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/18/24 09:39, Joseph Qi wrote:
> 
> 
> On 3/16/24 11:44 AM, Heming Zhao wrote:
>> The group_search function ocfs2_cluster_group_search() should
>> bypass groups with insufficient space to avoid unnecessary
>> searches.
>>
>> This patch is particularly useful when ocfs2 is handling huge
>> number small files, and volume fragmentation is very high.
>> In this case, ocfs2 is busy with looking up available la window
>> from //global_bitmap.
>>
>> This patch introduces a new member in the Group Description (gd)
>> struct called 'bg_contig_free_bits', representing the max
>> contigous free bits in this gd. When ocfs2 allocates a new
>> la window from //global_bitmap, 'bg_contig_free_bits' helps
>> expedite the search process.
>>
>> Let's image below path.
>>
>> 1. la state (->local_alloc_state) is set THROTTLED or DISABLED.
>>
>> 2. when user delete a large file and trigger
>>     ocfs2_local_alloc_seen_free_bits set osb->local_alloc_state
>>     unconditionally.
>>
>> 3. a write IOs thread run and trigger the worst performance path
>>
>> ```
>> ocfs2_reserve_clusters_with_limit
>>   ocfs2_reserve_local_alloc_bits
>>    ocfs2_local_alloc_slide_window //[1]
>>     + ocfs2_local_alloc_reserve_for_window //[2]
>>     + ocfs2_local_alloc_new_window //[3]
>>        ocfs2_recalc_la_window
>> ```
>>
>> [1]:
>> will be called when la window bits used up.
>>
>> [2]:
>> under la state is ENABLED, and this func only check global_bitmap
>> free bits, it will succeed in general.
>>
>> [3]:
>> will use the default la window size to search clusters then fail.
>> ocfs2_recalc_la_window attempts other la window sizes.
>> the timing complexity is O(n^4), resulting in a significant time
>> cost for scanning global bitmap. This leads to a dramatic slowdown
>> in write I/Os (e.g., user space 'dd').
>>
>> i.e.
>> an ocfs2 partition size: 1.45TB, cluster size: 4KB,
>> la window default size: 106MB.
>> The partition is fragmentation by creating & deleting huge mount of
>> small files.
>>
>> before this patch, the timing of [3] should be
>> (the number got from real world):
>> - la window size change order (size: MB):
>>    106, 53, 26.5, 13, 6.5, 3.25, 1.6, 0.8
>>    only 0.8MB succeed, 0.8MB also triggers la window to disable.
>>    ocfs2_local_alloc_new_window retries 8 times, first 7 times totally
>>    runs in worst case.
>> - group chain number: 242
>>    ocfs2_claim_suballoc_bits calls for-loop 242 times
>> - each chain has 49 block group
>>    ocfs2_search_chain calls while-loop 49 times
>> - each bg has 32256 blocks
>>    ocfs2_block_group_find_clear_bits calls while-loop for 32256 bits.
>>    for ocfs2_find_next_zero_bit uses ffz() to find zero bit, let's use
>>    (32256/64) (this is not worst value) for timing calucation.
>>
>> the loop times: 7*242*49*(32256/64) = 41835024 (~42 million times)
>>
>> In the worst case, user space writes 1MB data will trigger 42M scanning
>> times.
>>
>> under this patch, the timing is '7*242*49 = 83006', reduced by three
>> orders of magnitude.
>>
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>> ---
>> v2:
>> 1. fix wrong length converting from cpu_to_le16() to cpu_to_le32()
>>     for setting bg->bg_contig_free_bits.
>> 2. change ocfs2_find_max_contig_free_bits return type from 'void' to
>>     'unsigned int'.
>> 3. restore ocfs2_block_group_set_bits() input parameters style, change
>>     parameter 'failure_path' to 'fastpath'.
>> 4. after <3>, add new parameter 'unsigned int max_contig_bits'.
>> 5. after <3>, restore define 'struct ocfs2_suballoc_result' from
>>     'suballoc.h' to 'suballoc.c'.
>> 6. modify some code indent error.
>>
>> ---
>>   fs/ocfs2/move_extents.c |  2 +-
>>   fs/ocfs2/ocfs2_fs.h     |  4 +-
>>   fs/ocfs2/resize.c       |  7 +++
>>   fs/ocfs2/suballoc.c     | 99 +++++++++++++++++++++++++++++++++++++----
>>   fs/ocfs2/suballoc.h     |  6 ++-
>>   5 files changed, 106 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
>> index 1f9ed117e78b..f9d6a4f9ca92 100644
>> --- a/fs/ocfs2/move_extents.c
>> +++ b/fs/ocfs2/move_extents.c
>> @@ -685,7 +685,7 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
>>   	}
>>   
>>   	ret = ocfs2_block_group_set_bits(handle, gb_inode, gd, gd_bh,
>> -					 goal_bit, len);
>> +					 goal_bit, len, 0, 0);
>>   	if (ret) {
>>   		ocfs2_rollback_alloc_dinode_counts(gb_inode, gb_bh, len,
>>   					       le16_to_cpu(gd->bg_chain));
>> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
>> index 7aebdbf5cc0a..eae18d772e93 100644
>> --- a/fs/ocfs2/ocfs2_fs.h
>> +++ b/fs/ocfs2/ocfs2_fs.h
>> @@ -883,14 +883,14 @@ struct ocfs2_group_desc
>>   	__le16	bg_free_bits_count;     /* Free bits count */
>>   	__le16   bg_chain;               /* What chain I am in. */
>>   /*10*/	__le32   bg_generation;
>> -	__le32	bg_reserved1;
>> +	__le32   bg_contig_free_bits;  /* max contig free bits length */
> 
> I've found some parts you are using le32, while others using le16.
> It seems that le16 is enough here. So why not:
> __le16 bg_contig_free_bits;
> __le16 bg_reserved1;
> 
> Joseph

IIUC, From the comment before ocfs2_la_default_mb(), the max cluster
size is 1MB. And from 'struct ocfs2_group_desc', the offset of
bg_bitmap is 0x40. Therefore, the max contiguous bit of gd:
(1024*1024 - 0x40)*8 = 8388096 (23-bit length, bigger than __le16)

-Heming
