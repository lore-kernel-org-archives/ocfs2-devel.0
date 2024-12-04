Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7661D4C8F
	for <ocfs2-devel@lists.linux.dev>; Wed,  4 Dec 2024 06:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733294783; cv=none; b=Ht3/n/XPrRPsl42fBvgvVK1I3AABj1HHKaitTkYwE5CJYGsueijpqK27UpQnJZRIvzJwq6QLJiL972WCAGwCzTAeHhLt8Df782wGf+1KF4/oI/OaC5OYc3peB2eCht1Bko5XIot7OXUyKZAxJRKh+girDwob8vrCEj4nki14u0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733294783; c=relaxed/simple;
	bh=zwYDImrZs15aV8zEx0o5xD0LCFWwlvzYATVfdWzhG5c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rHXM7NW9cHdMwqR4eFOZjAnwebNp4YK7tEFKxaNN0BYsBh7NBizjZkns6JYhOq6W5+Blfw2nrL7FFY3ORwAScIiE1giZgu0O5NWW9RDdv6EWKISLHif3e/QDr/LA4xmH/QpowAGEdhX370e26gCqXsort18wbMBqNsHyrvVamY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=S2Hs/XI/; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="S2Hs/XI/"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4349ec4708bso5511075e9.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 03 Dec 2024 22:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733294780; x=1733899580; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nKLCwyYRyRhRV+7HHjXl1CRS1Do8/otxgiGgDTGtFOg=;
        b=S2Hs/XI/akXIDC0uFtcyvPkMRPmU9FsRSrHRWNuoZRTgNlGgCT5O/y0rxC67JiATX9
         34wsKRE+gs77sLhcPyXaI5UCj6FnMvixTLsn1q33+n9HiGg0+obmQW6u9cgSeN/0h1/P
         YaKlgqHsFR/VNqC/pPfx5/BS2Q50YPW1GZwKvy5zHSx6nAM1xiPQv/V0iuzcdxKyePst
         65FXS7YrwzfkA9idmgSn0P+GKx5fKxAgbEGdI1cM/ukX4Qvm+t1pgVchJkMYvk3NfXoJ
         btTzYaNpqln7avecA3174zX1KHoLLSGxjMrCbmC3iey75pboV1KdzJw36cPxwU02FDZs
         E4aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733294780; x=1733899580;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nKLCwyYRyRhRV+7HHjXl1CRS1Do8/otxgiGgDTGtFOg=;
        b=d3aC6AjXuHNkPrhkipEjzraEOnGFTCGaeuUUs4N+wUFmmeTuNqk8mr0u9prOWTVk0F
         7JwJQQPcEPz1KFf8wKPy1hpBdSDAVx2x+thXSzLTAp/6T9iTszwNsEIW0Mmc750e/ZDT
         vB3VfEXn3/qo/R6MWbKskA/dyys6GqNupgYyAuQ4AzxMeCf/mnDiUMmSc3iD2DBe+sB+
         guHWXge6bD1x7h8go1ioKv3FsChVZJ798tYhDhL1Ij9wS8HpNRXcydl1E3//pRY5+S0/
         6XDnV6K011M2dEd+6jur7Hj87KSr8dDPthzNYfsSoeBpkCCySFWEZ1x53ksO/mBqjZ8m
         ILUg==
X-Forwarded-Encrypted: i=1; AJvYcCXmDZndtEXhgYsfL7kiDMkT9+w1W0Vr7vZXdQsgBEaIyssPPNgfLWQJIe4cydxcDTvo4EzozWqlBW5VXQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyzSC1iD+8oJ03SJy2o60Jx3IXP9WYJRBy0/2tGLeVJZPrC5tR1
	TV0x0astbuV+lrLzru26ZjfSDsR56jdthyKg/yYvUz8HbYzSVrNQI0I3c423aa0=
X-Gm-Gg: ASbGncsxXpXpvrnrp5ENMRliCHfCQYvquQnewXNBcGWf7DME4YNQqVe5v51YZgoOm98
	y9ADHKa6xRbqS48i4RxuW4D0leCjVOgt5ULQpH8TjY54Sl5aV9eEWrxkm9nZM7M5m99jGA5KeRU
	Vlh3hqHWEUFnlSh4Ht/6b/0wCa9FdOd+W1kpnIpk92h7RilQbFYeSyzySTjJlCWbjRyRjT2X9qQ
	C6GnnFaDiJEkuqaThPJo2ZRhyQ/IbhDJkSrZg4sv6Cotf7vATifrg==
X-Google-Smtp-Source: AGHT+IGYH4zeaZiE7s4YcdQPS+jXDgKkEuUNU8+eF5sMaKEAwGSy6gVFnffZH3wiZ30aAyYxGMCatg==
X-Received: by 2002:a5d:47cb:0:b0:382:4b5e:5244 with SMTP id ffacd0b85a97d-385fd3f2432mr1531946f8f.7.1733294779809;
        Tue, 03 Dec 2024 22:46:19 -0800 (PST)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2155da906f2sm70317925ad.87.2024.12.03.22.46.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 22:46:19 -0800 (PST)
Message-ID: <79b86b7b-8a65-49b8-aa33-bb73de47ad37@suse.com>
Date: Wed, 4 Dec 2024 14:46:15 +0800
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
 gregkh@linuxfoundation.org, Heming Zhao <heing.zhao@suse.com>,
 stable@vger.kernel.org
References: <20241204033243.8273-1-heming.zhao@suse.com>
 <20241204033243.8273-2-heming.zhao@suse.com>
 <6c3e1f5a-916c-4959-a505-d3d3917e5c9c@linux.alibaba.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <6c3e1f5a-916c-4959-a505-d3d3917e5c9c@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/4/24 11:47, Joseph Qi wrote:
> 
> 
> On 12/4/24 11:32 AM, Heming Zhao wrote:
>> This reverts commit dfe6c5692fb5 ("ocfs2: fix the la space leak when
>> unmounting an ocfs2 volume").
>>
>> In commit dfe6c5692fb5, the commit log stating "This bug has existed
>> since the initial OCFS2 code." is incorrect. The correct introduction
>> commit is 30dd3478c3cd ("ocfs2: correctly use ocfs2_find_next_zero_bit()").
>>
> 
> Could you please elaborate more how it happens?
> And it seems no difference with the new version. So we may submit a
> standalone revert patch to those backported stable kernels (< 6.10).

commit log from patch [2/2] should be revised.
change: This bug has existed since the initial OCFS2 code.
to    : This bug was introduced by commit 30dd3478c3cd ("ocfs2: correctly use ocfs2_find_next_zero_bit()")

----
See below for the details of patch [1/2].

following is "the code before commit 30dd3478c3cd7" + "commit dfe6c5692fb525e".

    static int ocfs2_sync_local_to_main()
    {
    	... ...
  1  	while ((bit_off = ocfs2_find_next_zero_bit(bitmap, left, start))
  2  	       != -1) {
  3  		if ((bit_off < left) && (bit_off == start)) {
  4  			count++;
  5  			start++;
  6  			continue;
  7  		}
  8  		if (count) {
  9  			blkno = la_start_blk +
10   				ocfs2_clusters_to_blocks(osb->sb,
11   							 start - count);
12
13   			trace_ocfs2_sync_local_to_main_free();
14
15   			status = ocfs2_release_clusters(handle,
16   							main_bm_inode,
17   							main_bm_bh, blkno,
18   							count);
19   			if (status < 0) {
20   				mlog_errno(status);
21   				goto bail;
22   			}
23   		}
24   		if (bit_off >= left)
25   			break;
26   		count = 1;
27   		start = bit_off + 1;
28   	}
29
30 	/* clear the contiguous bits until the end boundary */
31 	if (count) {
32 		blkno = la_start_blk +
33 			ocfs2_clusters_to_blocks(osb->sb,
34 					start - count);
35
36 		trace_ocfs2_sync_local_to_main_free();
37
38 		status = ocfs2_release_clusters(handle,
39 				main_bm_inode,
40 				main_bm_bh, blkno,
41 				count);
42 		if (status < 0)
43 			mlog_errno(status);
44  	}
    	... ...
    }

bug flow:
1. the left:10000, start:0, bit_off:9000, and there are zeros from 9000 to the end of bitmap.
2. when 'start' is 9999, code runs to line 3, where bit_off is 10000 (the 'left' value), it doesn't trigger line 3.
3. code runs to line 8 (where 'count' is 9999), this area releases 9999 bytes of space to main_bm.
4. code runs to line 24, triggering "bit_off == left" and 'break' the loop. at this time, the 'count' still retains its old value 9999.
5. code runs to line 31, this area code releases space to main_bm for the same gd again.

kernel will report the following likely error:
OCFS2: ERROR (device dm-0): ocfs2_block_group_clear_bits: Group descriptor # 349184 has bit count 15872 but claims 19871 are freed. num_bits 7878

thanks,
Heming
