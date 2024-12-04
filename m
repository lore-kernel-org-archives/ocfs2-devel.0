Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8CA1BB6B8
	for <ocfs2-devel@lists.linux.dev>; Wed,  4 Dec 2024 11:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733312093; cv=none; b=jb4VyHixSfeBrv2atqVvYxfRW2PM617vOp/w71J0QYLQwI8T0ep2CNzffFR1j/D10FJZhhD/9qMMRaCCFw3bi7fMx3Vhw8+WpZOkbL3pH+1aROL4snkbn15xoxoMzrVvjjKEPzoaJgqjzxPhY57vHrlvLFxG7LfKoIRjdzGdPp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733312093; c=relaxed/simple;
	bh=Vi2bKt6/rwvZXF2mPJwiHd0rqmSWEQ/lysen1wR0FJc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rRlrvrrUVTcnGxV+ixv7D4C+BSYJDe/g5bZG8iJMXifh0OJlc6gGVQSKQOaz3qQMchuqNvJ7emWe4PkvUWeEbWu1NNluM3CZc+r6G4HHBYMVhC/1VB4TNV2CKpSxdZdEp59S1DsI3LE9+JHp0k0Xt6ApUhv/UHnUi4hn/7UwdoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gZFMJy6Q; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gZFMJy6Q"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-434a1095fe4so7893475e9.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 04 Dec 2024 03:34:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733312090; x=1733916890; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PgJLSQXktaGb+dG/FduPphoyaegpnGmLFV8pWNrBnh8=;
        b=gZFMJy6QZ+L7Xf8jeSRRgyPccioA2lcErEB+L8HwCrTGfd0oyA5/oQI8ydG9MjVSux
         ObSvkOTTdtTDGtzyiZzrD3bG1j78+pigR1/GtCaac1jlGjog05lTVgSOrN629izvrpt+
         iHhrRmzYJsVtxbuXp3KCHMcrFpNdgXVi9/0XLbNDhH0Kwx/wrgg53ofk1AqPo2IBvCKj
         Wdwb+3uTh1Nvv93qtSdjCicBo6a8+O6CGlyapWVIMT7JrQzGoLpU4CwuQXZ6te430te0
         QhrIaIB0kUGkCwgllZ9eMmZanBYAfLRBlK7t08dQkotp0yCII/1IxHtJAvRcD3D5JwTc
         7gRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733312090; x=1733916890;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PgJLSQXktaGb+dG/FduPphoyaegpnGmLFV8pWNrBnh8=;
        b=oP+wEETIPLOIyPX/P9F/hMKKshituuRj9Z+cGmUe2MAewT5jcsEbZ//7paoyiUO8iI
         Ah8vxzETyn6ARaWb4KpsvMZd9ULxBHCjMTB6nIHHSQV7ODsfRLhtpSY89B6qO8XKF1Fn
         Ox+t6TD11C8UOuIClpouMcxaNc9Sj0N+Ro8NJfFTmo60N5B359G3LI5gBvfYKBSWLBoa
         I8/9MNTSIi2m1XR7iIALX0RNP0mskZdNxrWE0GnfZQ3s4OKvZonCGg1hsxW2dr4lmzOL
         orhE4yAIshyIik4EskTK0/+5XMpBc+NTvSu6ScET88rKq7Qo6FR4zu04O8hZbCGjc9HS
         6iQA==
X-Forwarded-Encrypted: i=1; AJvYcCWzQX4r+m9A9OYcDLn4l4nrXoPM0DseqMLimLHf2mPyfmQqGm51fTiay3XCkgSbkiiHS/nX7oB5Wbm0Nw==@lists.linux.dev
X-Gm-Message-State: AOJu0YykOLsMX2DUk4fDDBfayBBeZkBc11N+Fb3d2UAXPsfW8ocnaBm8
	QkuEbUJyhyAuCpdQqEIWYmcGo61L5b/WqE2+tGi2H9UTKIr5aoH9hn43p2FR9Qg=
X-Gm-Gg: ASbGncvtcxDVp5aIocs0jRth71iF727C6YT9F46KTEF96I/wsLLRZSXc5FCk36mabAX
	pCw13KUXpcU2MF1+g7kkOimpIm/Xcqau//ncRHYBmJoFz6c+53LzEUYB23mElWKcrZ1mlhL8FVC
	5cHFohNnSkS099Pe6Z/zo3GrnJdhT+pqWzGMrU7EyY3KtBEPq+c9MqCK9P+GtwEAo9nvzbm8/lQ
	9FBjrWV99TaP68Xb5DiTYHDTT6n6/L8CJ822fOlBliX9t4UCsjcIQ==
X-Google-Smtp-Source: AGHT+IEZ3WECZOCeCaAdxC7d9oRWYnvYRZ+58FiYREc9X1QL+93oiqtvRyOJmgmoLRMAJxFijDNEsQ==
X-Received: by 2002:a05:6000:2cf:b0:385:f092:e10 with SMTP id ffacd0b85a97d-385fd3c3087mr2116720f8f.3.1733312089500;
        Wed, 04 Dec 2024 03:34:49 -0800 (PST)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7254176150dsm12511554b3a.23.2024.12.04.03.34.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2024 03:34:48 -0800 (PST)
Message-ID: <47fe189d-eadc-495d-984e-705fab58acad@suse.com>
Date: Wed, 4 Dec 2024 19:34:45 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] ocfs2: Revert "ocfs2: fix the la space leak when
 unmounting an ocfs2 volume"
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
 gregkh@linuxfoundation.org, stable@vger.kernel.org
References: <20241204033243.8273-1-heming.zhao@suse.com>
 <20241204033243.8273-2-heming.zhao@suse.com>
 <6c3e1f5a-916c-4959-a505-d3d3917e5c9c@linux.alibaba.com>
 <79b86b7b-8a65-49b8-aa33-bb73de47ad37@suse.com>
 <58618b80-f1ab-4b22-a3fc-9d29969615a0@linux.alibaba.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <58618b80-f1ab-4b22-a3fc-9d29969615a0@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/4/24 17:28, Joseph Qi wrote:
> 
> 
> On 12/4/24 2:46 PM, Heming Zhao wrote:
>> On 12/4/24 11:47, Joseph Qi wrote:
>>>
>>>
>>> On 12/4/24 11:32 AM, Heming Zhao wrote:
>>>> This reverts commit dfe6c5692fb5 ("ocfs2: fix the la space leak when
>>>> unmounting an ocfs2 volume").
>>>>
>>>> In commit dfe6c5692fb5, the commit log stating "This bug has existed
>>>> since the initial OCFS2 code." is incorrect. The correct introduction
>>>> commit is 30dd3478c3cd ("ocfs2: correctly use ocfs2_find_next_zero_bit()").
>>>>
>>>
>>> Could you please elaborate more how it happens?
>>> And it seems no difference with the new version. So we may submit a
>>> standalone revert patch to those backported stable kernels (< 6.10).
>>
>> commit log from patch [2/2] should be revised.
>> change: This bug has existed since the initial OCFS2 code.
>> to    : This bug was introduced by commit 30dd3478c3cd ("ocfs2: correctly use ocfs2_find_next_zero_bit()")
>>
>> ----
>> See below for the details of patch [1/2].
>>
>> following is "the code before commit 30dd3478c3cd7" + "commit dfe6c5692fb525e".
>>
>>     static int ocfs2_sync_local_to_main()
>>     {
>>         ... ...
>>   1      while ((bit_off = ocfs2_find_next_zero_bit(bitmap, left, start))
>>   2             != -1) {
>>   3          if ((bit_off < left) && (bit_off == start)) {
>>   4              count++;
>>   5              start++;
>>   6              continue;
>>   7          }
>>   8          if (count) {
>>   9              blkno = la_start_blk +
>> 10                   ocfs2_clusters_to_blocks(osb->sb,
>> 11                                start - count);
>> 12
>> 13               trace_ocfs2_sync_local_to_main_free();
>> 14
>> 15               status = ocfs2_release_clusters(handle,
>> 16                               main_bm_inode,
>> 17                               main_bm_bh, blkno,
>> 18                               count);
>> 19               if (status < 0) {
>> 20                   mlog_errno(status);
>> 21                   goto bail;
>> 22               }
>> 23           }
>> 24           if (bit_off >= left)
>> 25               break;
>> 26           count = 1;
>> 27           start = bit_off + 1;
>> 28       }
>> 29
>> 30     /* clear the contiguous bits until the end boundary */
>> 31     if (count) {
>> 32         blkno = la_start_blk +
>> 33             ocfs2_clusters_to_blocks(osb->sb,
>> 34                     start - count);
>> 35
>> 36         trace_ocfs2_sync_local_to_main_free();
>> 37
>> 38         status = ocfs2_release_clusters(handle,
>> 39                 main_bm_inode,
>> 40                 main_bm_bh, blkno,
>> 41                 count);
>> 42         if (status < 0)
>> 43             mlog_errno(status);
>> 44      }
>>         ... ...
>>     }
>>
>> bug flow:
>> 1. the left:10000, start:0, bit_off:9000, and there are zeros from 9000 to the end of bitmap.
>> 2. when 'start' is 9999, code runs to line 3, where bit_off is 10000 (the 'left' value), it doesn't trigger line 3.
>> 3. code runs to line 8 (where 'count' is 9999), this area releases 9999 bytes of space to main_bm.
>> 4. code runs to line 24, triggering "bit_off == left" and 'break' the loop. at this time, the 'count' still retains its old value 9999.
>> 5. code runs to line 31, this area code releases space to main_bm for the same gd again.
>>
>> kernel will report the following likely error:
>> OCFS2: ERROR (device dm-0): ocfs2_block_group_clear_bits: Group descriptor # 349184 has bit count 15872 but claims 19871 are freed. num_bits 7878
>>
> 
> Okay, IIUC, it seems we have to:
> 1. revert commit dfe6c5692fb5 (so does stable kernel).
> 2. fix 30dd3478c3cd in following way:
> 
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index 5df34561c551..f0feadac2ef1 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -971,9 +971,9 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
>   	start = count = 0;
>   	left = le32_to_cpu(alloc->id1.bitmap1.i_total);
>   
> -	while ((bit_off = ocfs2_find_next_zero_bit(bitmap, left, start)) <
> +	while ((bit_off = ocfs2_find_next_zero_bit(bitmap, left, start)) <=
>   	       left) {

The ocfs2_find_next_zero_bit() always returns a value within the range [0, left],
do you like the following code?

-	while ((bit_off = ocfs2_find_next_zero_bit(bitmap, left, start)) <
-		left) {
+	for(;;) {
+		bit_off = ocfs2_find_next_zero_bit(bitmap, left, start);


-Heming

> -		if (bit_off == start) {
> +		if ((bit_off < left) && (bit_off == start)) {
>   			count++;
>   			start++;
>   			continue;
> @@ -997,7 +997,8 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
>   				goto bail;
>   			}
>   		}
> -
> +		if (bit_off >= left)
> +			break;
>   		count = 1;
>   		start = bit_off + 1;
>   	}
> 
> Thanks,
> Joseph
> 
> 

