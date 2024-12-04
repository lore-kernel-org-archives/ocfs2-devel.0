Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B191B6D12
	for <ocfs2-devel@lists.linux.dev>; Wed,  4 Dec 2024 11:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733310677; cv=none; b=EHAkelly86AbldlmbOlR79Xulp8Xa3sfBam8stSTUBbpRHdsEJ7gdFOJJ2lCrxI/mVqaTkDdyf9qkna9nvBTgfYhzn/cF+WTnKwHjULeCB1SSL3MjrYLFswo5UZata4eH0zZGYS6S5K9mcyI3xqDdFex5E/i4/EucrDz6amDwZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733310677; c=relaxed/simple;
	bh=L5IyQ5nL3Vx0ii5rBZ5S9yZ06JCRh5nJS/h/hJf1L4E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=phiLMIxNDP9GjiklvsYjE59aVLIPv36/yd/odpn9VtOYMuuNr3TEd3D0un7/ib95bs+8n3d1r9rQdqZOwysP2nIBSzXRp5TLRyMzXciF5lco9GAD9zaDNobTPt7kCJdo3k+avDNYq3SqVoJNp2NygOElCvxDCqp3/DSf7TAgpSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HDufIevV; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HDufIevV"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-385e44a1a2dso174460f8f.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 04 Dec 2024 03:11:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733310673; x=1733915473; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VhaMZOPSYfWc16c/uIlUKV87o3EICb3QAE0FT4FA0n4=;
        b=HDufIevVxqhBKB3vjtrliWnwryZdGAd9Vmq32cxcu3RJZcC/VVszLe5opyOYFl3xSv
         8wpSb318e9lyzEM2zmnkHxkT27flYe+RgNOyHksJBJRSqXk6rDTYcOz7fqIXEJysa0Ga
         bo9P9knWclrYN3qFWKde00XiPhNE00cdu7Ncuu4Clfvu4SWJxy9wouv77gWE7Zm5tGHi
         JF1yMHnJ4nKUrVrT9T72QdKCJHfFdQFjvACS/WFHFpjjkI+lw+NdEgignxefzixGWyKq
         xvMNKui0dbRp5fsDQ0ibwM7D/PcimKOtIvEb+khxIiWL/iki4RJosqGbRJVIHZ66N5SE
         Qryw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733310673; x=1733915473;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VhaMZOPSYfWc16c/uIlUKV87o3EICb3QAE0FT4FA0n4=;
        b=WsgkxrXKM1CMb3v+zRCXYEYO+w9X+hXdVHr6wACLWI3Wh3mtNmbVNoOltBmVovZ3Om
         qWJcNlmfTHqUQ0meTn8cmAkkCqXerBKh7c4yeXzF1jlLYoYBOjgNUmbiEWSZpUHTbDDz
         Iu/2ek0/fNQSO2ZX9ss1yYdl0fORLu0EVxoC3kuj4vcf9cmTfnINhiWw6gf+L8Uv8dWv
         8DEy7tSzOPF/PbEh1HUJ5TyMJDO0t4e6c7eMjXf0a+Vo5oKXI2HQx3JM7zM1WobJ7cPa
         HdbRkJKAnOuiMR0NCB2BQ//4sxq7eLfxkkj9Y4KrXNvUJiOs2z+QaRsWWOCkRRnlX64p
         v94A==
X-Forwarded-Encrypted: i=1; AJvYcCWhGzuYu3sZRY4A27JAG3iT0zdJeNQLut2DMy+EuPfgdo2i5rfRUYKfRCjzfpgci9KpKnKjj07URRQreA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyD8KSNaVz7X9ehLsEChWHN8o/yY2pWBiDlwuwJy8dNEZPvCPs9
	lBWZbMGwG52vrrYMK2bOA/MqcPtGdT+RaoZJngIBt41vGxPtMytwUCEprhZS5U8=
X-Gm-Gg: ASbGncuprmKIBicbZ5FRfvsIHTwJvYknA5YYwky5IPOms/vplHZniyL3ETneV91tbGm
	7XcGWzN/TPBOvpgfElxOSey6GcMAQ6unGsPEgBfUQLR/QSsBU9x82nM4JDC6vsjl+TtJnthn2uP
	wVCFR+/fFtHVD+L0HQHE5IDxvR2ndNwyXOtxCWVyphzZc7Qcq661wY7WRYWVseDvSFChh/LT0Ag
	5KQLpFMEyG0L/U6gPLbly39P27zAzA7zsN8+n7N7iIAJ8J9bOWzUw==
X-Google-Smtp-Source: AGHT+IHXyIRahTiY0jxdbWML3F/Qt7hDAusTvFHNbRMxDzDB3YlFm4EzkttRkB/g/4jkv3ZXZ8+ebA==
X-Received: by 2002:a05:6000:1a86:b0:385:f909:eb33 with SMTP id ffacd0b85a97d-385fd40ad98mr2091506f8f.10.1733310672843;
        Wed, 04 Dec 2024 03:11:12 -0800 (PST)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7254181464csm12058921b3a.157.2024.12.04.03.11.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2024 03:11:12 -0800 (PST)
Message-ID: <87cfb429-175f-4d3a-a399-98264056536b@suse.com>
Date: Wed, 4 Dec 2024 19:11:09 +0800
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

OK.

> 2. fix 30dd3478c3cd in following way:

It looks good to me.

I will send v2 patch.

-Heming
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

