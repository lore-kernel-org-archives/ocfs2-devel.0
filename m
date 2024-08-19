Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F32381C2
	for <ocfs2-devel@lists.linux.dev>; Mon, 19 Aug 2024 02:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724035250; cv=none; b=Yyfd9InY+nRrAVisbZvbcNJKwPB/qKzxhParBRFxAN+ScRQRgDAzRXI+lmxB0BNAm3jGpYQPNL9a9oKi9jDJMNwxNmR4Vc9rAXn3YXsNUhXPo7sYl90rHla6q+iu1ciiZT8xOZvwnMdV920R5qr2hUgxm6kWRrqXzvkgxYnuQX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724035250; c=relaxed/simple;
	bh=m8vhVFrXVR342rluGvz0IWZNr0LOtnv5NV+3/+iOcFw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ui7WGyT8KhQvZy/Z4zD540kBnB/GK7NsgtWwiK0T76+pjayh4Dvs4mvwF+znmksW2tt2raw9MglqHE538ZT0ixk4BgYF4vyR5cYfGbbamDNZf3qxSWuRExXkaVCn9lIdqpId0K+pCCU/wioKjBtXDoqQMcjDdtFaV4TOEVjHKXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LO48nmol; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LO48nmol"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-37182eee02dso1916256f8f.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 18 Aug 2024 19:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1724035246; x=1724640046; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Rrz0NLJQUicJg05dix/G7IvIXq0lc24IX6wpTx/j2h8=;
        b=LO48nmolQVYftxxmHBGFlpXmUacpEWxnXzcHZF0TPyCGe2qk1yGKm2BCesiTmuxwGI
         dvK4/W5oMXsloF7dAiGRZQExhyY19j0xQBB97YcHl9l+7rmRftwixclFU6TQOAKPBdSG
         MfsuGqQtNmJqORGOXLOAG+dlyGzvJyhTq/wHolAc5X7/wzd1bDfBUzk87q7d374jjbDH
         J/Gs2JcfYj606PN6iBQ4Ypx/lGD6VWxXpQHtmaqcmXYZZMBb0Hd5O1Lq/R9Blquy8sez
         4gaeTzy7vf1Sp4gCJuko0191vTI5VeODla5hZRFwHf/DvgeQIoP8tdnGADi+IMNmMxkT
         3VMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724035246; x=1724640046;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rrz0NLJQUicJg05dix/G7IvIXq0lc24IX6wpTx/j2h8=;
        b=n2zzjXBgwGPMPtJu/ih8WE34wiytuGbDzFwq35stRYy0jGwJXuq5Mv5Gpu5fhd0Xdt
         gBkwMe1cKbsA8vtQsWpmZ/x6KneKycJHI39TOj9DoIl68o9upFFNHKU+gHIKRQEW6CT8
         GIXLd1t4/C7KwLJGuZw1lXmOjQSsPyZrY8SFYWpAIVXudm02nSgA2sdL3yCNGmyPPlKk
         tagc+HaQ9Nq2cHQ74O3erTsnUKC8PSSdMyV2kfULnsDHpGG5/CQEPO3d1XUwjjYE+BrG
         T94ZPB2lHPvLQApn10W1tHK2erui7Xxcv0waEXBZl+JXvDrVXZar3kea70Cb3uJ+qdVx
         sk9w==
X-Gm-Message-State: AOJu0Yz3HEbprEuRPFjsRLRjmZ9aH4kcCEeA4i9/duDzX5mXwTZs40KA
	GEhvP9EfVqqSfqNJA8MkpyZPf1IM9xl4Geh/u7n9g+geOIcUodA4wFn8fhqX8Fo=
X-Google-Smtp-Source: AGHT+IHaOf4V6+FrjoW2AFVYnVzlxHKwV4FXAIAcNpqtq7OzHYCEUgI4btoqvPqnzDkmrS1JQRVq6A==
X-Received: by 2002:adf:ce0a:0:b0:36b:c65c:661e with SMTP id ffacd0b85a97d-37186c09a03mr7527730f8f.13.1724035246141;
        Sun, 18 Aug 2024 19:40:46 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d3dc9bcdd4sm3066033a91.1.2024.08.18.19.40.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Aug 2024 19:40:45 -0700 (PDT)
Message-ID: <ed71901d-bf43-4b81-88ea-0dac7207c5c5@suse.com>
Date: Mon, 19 Aug 2024 10:40:41 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix unexpected zeroing of virtual disk
To: Joseph Qi <joseph.qi@linux.alibaba.com>, Chi Zhiling
 <chizhiling@163.com>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 starzhangzsd@gmail.com, Chi Zhiling <chizhiling@kylinos.cn>,
 Shida Zhang <zhangshida@kylinos.cn>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
References: <20240815092141.1223238-1-chizhiling@163.com>
 <432954d5-3b8e-42f7-8c06-1a489281129e@suse.com>
 <333c0334-112e-4ac2-9ec2-c81fe73458bc@linux.alibaba.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <333c0334-112e-4ac2-9ec2-c81fe73458bc@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Sorry, I just realized I posted the wrong tag "Signed-off-by: Heming Zhao ...".
The correct should be Reviewed-by: Heming Zhao <heming.zhao@suse.com>.

On 8/19/24 10:32, Joseph Qi wrote:
> Looks good.
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> 
> BTW, ocfs2 hasn't been tested thoroughly under 64k page, so I'm afraid
> there are other bugs when running ocfs2 under 64k page.
> 
> On 8/18/24 6:31 PM, Heming Zhao wrote:
>> On 8/15/24 17:21, Chi Zhiling wrote:
>>> From: Chi Zhiling <chizhiling@kylinos.cn>
>>>
>>> In a guest virtual machine, we found that there is unexpected data
>>> zeroing problem detected occassionly:
>>>
>>> XFS (vdb): Mounting V5 Filesystem
>>> XFS (vdb): Ending clean mount
>>> XFS (vdb): Metadata CRC error detected at xfs_refcountbt_read_verify+0x2c/0xf0, xfs_refcountbt block 0x200028
>>> XFS (vdb): Unmount and run xfs_repair
>>> XFS (vdb): First 128 bytes of corrupted metadata buffer:
>>> 00000000e0cd2f5e: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>> 00000000cafd57f5: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>> 00000000d0298d7d: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>> 00000000f0698484: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>> 00000000adb789a7: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>> 000000005292b878: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>> 00000000885b4700: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>> 00000000fd4b4df7: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>> XFS (vdb): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x200028 len 8 error 74
>>> XFS (vdb): Error -117 recovering leftover CoW allocations.
>>> XFS (vdb): xfs_do_force_shutdown(0x8) called from line 994 of file fs/xfs/xfs_mount.c.  Return address = 000000003a53523a
>>> XFS (vdb): Corruption of in-memory data detected.  Shutting down filesystem
>>> XFS (vdb): Please umount the filesystem and rectify the problem(s)
>>>
>>> It turns out that the root cause is from the physical host machine.
>>> More specifically, it is caused by the ocfs2.
>>>
>>> when the page_size is 64k, the block should advance by 16 each time
>>> instead of 1.
>>> This will lead to a wrong mapping from the page to the disk, which
>>> will zero some adjacent part of the disk.
>>>
>>> Suggested-by: Shida Zhang <zhangshida@kylinos.cn>
>>> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
>>> ---
>>>    fs/ocfs2/aops.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>>> index d6c985cc6353..1fea43c33b6b 100644
>>> --- a/fs/ocfs2/aops.c
>>> +++ b/fs/ocfs2/aops.c
>>> @@ -1187,7 +1187,7 @@ static int ocfs2_write_cluster(struct address_space *mapping,
>>>              /* This is the direct io target page. */
>>>            if (wc->w_pages[i] == NULL) {
>>> -            p_blkno++;
>>> +            p_blkno += (1 << (PAGE_SHIFT - inode->i_sb->s_blocksize_bits));
>>>                continue;
>>>            }
>>>    
>>
>> Looks good to me.
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>

