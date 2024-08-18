Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464B3C8D7
	for <ocfs2-devel@lists.linux.dev>; Sun, 18 Aug 2024 10:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723977107; cv=none; b=CF2afaZ8kl++Lz0yk9ytsle063vT72DcPVGH91MdsryBcLqpplJ88s49ZYCvO0Pbx4eW53jZ4bpZokc9+Vc0RonhtlYcVT8ug/yqXXqfLG+kT39+rGCcokNg7VOyJ6cuUtPuMyNSmxuLdDDSPh/7HWwN0KjbNvGhSnlAZ1rUeXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723977107; c=relaxed/simple;
	bh=4K7mKnCBdXiqVPpyYPuFnTNVm6B25O8KuVa7kOzymuI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i8ENx4jNvt4RpL0ztE6pzYDbDCwV8CYXzAf9yRy6JLMWZTHPXytd42ElnrXRanGARjBL6DKZFZ4TWdxh1sBHukBuYgc/MKxREWq5IWNvjP1ANpPgTcY/lC+pMF5eweUqH00wDZ5jzNWyr892TlmxcZT9lXGTLZ0mnqFnrpWSRoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IxKc7SBj; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IxKc7SBj"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-371b97cfd6fso237155f8f.2
        for <ocfs2-devel@lists.linux.dev>; Sun, 18 Aug 2024 03:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723977103; x=1724581903; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hT6IIPT/Q7vxLCeBHiJq4nP20R/hkDkoYUOFw2T0UCs=;
        b=IxKc7SBjRMVIGio1+7nILZTNuTBykKHzvSFI3j63q/7tO1U9NpT5ewmPHHYAG+cowk
         6hp8oqJZddIdtVaNuFxvJcdHtLEComDOhuxlCeI5GEgmpCIgWuV9sSIATXISR/UngRvc
         OJuyHKL83GTBiwzL1mfSRPJojRRedxKoJytEoC9xlfEg+N1HuoJ9I4UiYW5arstVh/QB
         G5fkdp/GciO9gMy+uyzyPVJUTd502SmEts1hnsy3rHYsmKy5m+WwjlTvpESSSUk25yki
         w8S8EaRFId8fd6jdQDmQv1JxLeTXLOOJutOod/FFDsdJ7kRnu2qn+2wklQnU603p+6zw
         1Eng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723977103; x=1724581903;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hT6IIPT/Q7vxLCeBHiJq4nP20R/hkDkoYUOFw2T0UCs=;
        b=ZUvRiavf648MjEewn+xlPvoF8GfyZLxQOLXnHQJxWTZoCyC4v+fKdsSlchg9kiVlAW
         JnDAHIidGzGmtStfwLSARuVPCkblQBr18K5kEfMxzWTsR/wMZoorIZYGvhzY0WfaK2vE
         4UAyeelLAdZu2x/oBXa5ILIsJGaF11LDO/STlWtpXzPU0dP2nzYeuh1pUQZzgyWHPlWx
         olBWwsCU5ePa8Yy5DUktmU6BjyxJyIo/X2mWve+AdNGbzLh2AL62RgeipXwvXhCmNkv0
         EfifzvJxuVniIlnskl3nPbl+AxTm/SIOMO+/TkPdh6bsHIilXHUvNp1KIevhe/ubifC5
         kipg==
X-Gm-Message-State: AOJu0Yy6HfuXBeCuo+rQjUApWtsPDcboAzMD67wUJvICxDOBiYLYBssX
	S14WYuJfifKl4xZ6zG9QG2poJdHrTNjwmU4eN8p7qRufpCql7r1rGMQEbRcMHts=
X-Google-Smtp-Source: AGHT+IFCbBc63RMQKFvlgM35DJE5gbz6Ke0sfHq99SQD6oAwbq7SmoSbMUm0DsA+Y09a2JW7CO3HfA==
X-Received: by 2002:a05:6000:b51:b0:368:71bc:2b0c with SMTP id ffacd0b85a97d-37194314f8amr4866508f8f.10.1723977103190;
        Sun, 18 Aug 2024 03:31:43 -0700 (PDT)
Received: from [127.0.0.1] ([192.177.92.77])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7127ae0cb2esm5086164b3a.64.2024.08.18.03.31.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Aug 2024 03:31:42 -0700 (PDT)
Message-ID: <432954d5-3b8e-42f7-8c06-1a489281129e@suse.com>
Date: Sun, 18 Aug 2024 18:31:27 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix unexpected zeroing of virtual disk
To: Chi Zhiling <chizhiling@163.com>, mark@fasheh.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 starzhangzsd@gmail.com, Chi Zhiling <chizhiling@kylinos.cn>,
 Shida Zhang <zhangshida@kylinos.cn>
References: <20240815092141.1223238-1-chizhiling@163.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20240815092141.1223238-1-chizhiling@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/15/24 17:21, Chi Zhiling wrote:
> From: Chi Zhiling <chizhiling@kylinos.cn>
> 
> In a guest virtual machine, we found that there is unexpected data
> zeroing problem detected occassionly:
> 
> XFS (vdb): Mounting V5 Filesystem
> XFS (vdb): Ending clean mount
> XFS (vdb): Metadata CRC error detected at xfs_refcountbt_read_verify+0x2c/0xf0, xfs_refcountbt block 0x200028
> XFS (vdb): Unmount and run xfs_repair
> XFS (vdb): First 128 bytes of corrupted metadata buffer:
> 00000000e0cd2f5e: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> 00000000cafd57f5: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> 00000000d0298d7d: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> 00000000f0698484: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> 00000000adb789a7: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> 000000005292b878: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> 00000000885b4700: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> 00000000fd4b4df7: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> XFS (vdb): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x200028 len 8 error 74
> XFS (vdb): Error -117 recovering leftover CoW allocations.
> XFS (vdb): xfs_do_force_shutdown(0x8) called from line 994 of file fs/xfs/xfs_mount.c.  Return address = 000000003a53523a
> XFS (vdb): Corruption of in-memory data detected.  Shutting down filesystem
> XFS (vdb): Please umount the filesystem and rectify the problem(s)
> 
> It turns out that the root cause is from the physical host machine.
> More specifically, it is caused by the ocfs2.
> 
> when the page_size is 64k, the block should advance by 16 each time
> instead of 1.
> This will lead to a wrong mapping from the page to the disk, which
> will zero some adjacent part of the disk.
> 
> Suggested-by: Shida Zhang <zhangshida@kylinos.cn>
> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
> ---
>   fs/ocfs2/aops.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index d6c985cc6353..1fea43c33b6b 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -1187,7 +1187,7 @@ static int ocfs2_write_cluster(struct address_space *mapping,
>   
>   		/* This is the direct io target page. */
>   		if (wc->w_pages[i] == NULL) {
> -			p_blkno++;
> +			p_blkno += (1 << (PAGE_SHIFT - inode->i_sb->s_blocksize_bits));
>   			continue;
>   		}
>   

Looks good to me.
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
