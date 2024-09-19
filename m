Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD6E1957F8
	for <ocfs2-devel@lists.linux.dev>; Thu, 19 Sep 2024 08:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726733620; cv=none; b=N0P3ldVWdmEh6JNimuy0/RhMyyklKUeOJZuULpQq8J5aa59DKQ0k1D4tshh6+xbiDrK8UKWV7KDLZV8f4tToyh5Coo6wjN3ZXDgX4dfvIPuzP3nxovb6XjbZDlHcfO+qTny7CNaFmliFi7yABwp5haZg1GgWc1c/5zNycAw40RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726733620; c=relaxed/simple;
	bh=/K69nVLEcIWxNDNpRWx7rCcqnjzJo3uCpRufVr1clJM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DDEtTBqz0Y3WSHXNYIn+d0ssKJZduahss/l9ta2ZQF/f2mNnZm4c7HssB5VeEEAzUndxV3ippj9lwDEl2yeieIIWk7s2MS5HHfjsm+iTmeGwZ02BnYNLKhXbdHqIlCcculBWlB9oL4pGfnZQG0WQqXStIxn4Uglpx20dO5tq050=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Nx789p2r; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Nx789p2r"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-378f90ad334so18584f8f.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 19 Sep 2024 01:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1726733616; x=1727338416; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DiM72tMP3gxKJwMlvFMrAxAdtPBT77eodGymGn5dVag=;
        b=Nx789p2rkX3ECqD75aj2R1JSth9/qOFKtGBXQzh+i8clPZHyMmKSbISvHpd9Q0VYZ0
         BlahMuRHgslEs3oQvsKtZ6/BG+SQ0NeTpPmvJbIKx8aH7x3b7eq9F+iWui4yw9VxlcJ6
         gIJdcXtbEHqBYu+AhpbtoBW+8w6pfGWaEWvXpa2VO9mILGtPQwMp1T07autN5nKF4ksP
         NBtyLqZwm9An6Mm/6y11WJEzQW7e+Va8RqBng0yVMDmYgGgA23hZD2pI1+lNHaJao5H8
         t/MRJF0RxiIpjaDosh/nxV4XPMGMkrUYvY+q3jyxho2MtVvPluUeY2qMSuv8F3otkaNz
         fhTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726733616; x=1727338416;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DiM72tMP3gxKJwMlvFMrAxAdtPBT77eodGymGn5dVag=;
        b=GfHB7ajYzvPD/ScLqOY3bddcH2LYgXSrEC/teXpFtIJziONju7c6U2DNA9r3lXQ7xS
         wWmbqBHmoVYO1bcrCW6tg6h80M3JzPztIQBVBCpqklLzV06UN5bRBkhr/nD/WqidQn3W
         iKizwE8vZpBUU8Q5FKSu7ewErSGIguBWv3rolyesftvrn7d0+YUOBc1/0D0gwJ5puiPo
         Ft1d3fE1TFcoa2mn8WOaaRkagLYTY/LBlVFu8smEcIJ2G1ILz5wXcTwH1Pj/jXG9EIoi
         rFOhsH8Fjgf/7edQYIw6fZpj+mt9H/zqagaG2b0QBWknlx7N5IqZMcB1OVjDp6v6T4rd
         mTUA==
X-Forwarded-Encrypted: i=1; AJvYcCU1E7WIMnY9YKQYGkwyy8nQNpf0VcP0yw7dLsy5Db4dBttGa0cW2nwYRrl/ZvdqA+ZjqvDIFtiPKrHi/Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YyyquQsBgGGG1rMk63Pl7wAptRzZhnOtTPcu3ghUIgW+VLmGGau
	sASALx9vX76BrrG+KHGUtABAuMcsIr7/Au/zsweiB0LTgjubuIEwYqVx0Jg6Lh4=
X-Google-Smtp-Source: AGHT+IEcmmdy/00oElpFksWs4lsAsMJXe4ZQ0aVnGocJkWEcop5ZUHKg12MuKLRImgdJxyEubGoH+A==
X-Received: by 2002:a05:6000:1f89:b0:374:d2b4:d9d0 with SMTP id ffacd0b85a97d-378c295451cmr7365205f8f.0.1726733616350;
        Thu, 19 Sep 2024 01:13:36 -0700 (PDT)
Received: from ?IPV6:2408:8409:2432:371d:7607:a570:bf1c:aad6? ([2408:8409:2432:371d:7607:a570:bf1c:aad6])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944b7b59csm7772163b3a.103.2024.09.19.01.13.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Sep 2024 01:13:35 -0700 (PDT)
Message-ID: <2690bc1f-049f-4a27-823e-5da0ae1bdcda@suse.com>
Date: Thu, 19 Sep 2024 16:13:30 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] ocfs2: Fix deadlock in ocfs2_read_virt_blocks
Content-Language: en-US
To: Mohammed Anees <pvmohammedanees2003@gmail.com>,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>,
 syzbot+18a87160c7d64ba2e2f6@syzkaller.appspotmail.com
References: <20240918172026.2532-1-pvmohammedanees2003@gmail.com>
 <20240918172026.2532-2-pvmohammedanees2003@gmail.com>
From: "heming.zhao@suse.com" <heming.zhao@suse.com>
In-Reply-To: <20240918172026.2532-2-pvmohammedanees2003@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/19/24 01:20, Mohammed Anees wrote:
> syzbot has found a kernel BUG in ocfs2_write_cluster_by_desc,
> while the next patch in the series resolves this, another
> bug has been detected due to a potential deadlock [1].
> 
> The scenario is depicted here,
> 
> 	CPU0					CPU1
> lock(&ocfs2_file_ip_alloc_sem_key);
>                                 lock(&osb->system_file_mutex);
>                                 lock(&ocfs2_file_ip_alloc_sem_key);
> lock(&osb->system_file_mutex);
> 
> The function calls which could lead to this are:
> 
> CPU0
> ocfs2_write_begin - lock(&ocfs2_file_ip_alloc_sem_key);
> .
> .
> .
> ocfs2_get_system_file_inode - lock(&osb->system_file_mutex);
> 
> CPU1 -
> ocfs2_get_system_file_inode - lock(&osb->system_file_mutex);
> .
> .
> .
> ocfs2_read_virt_blocks - lock(&ocfs2_file_ip_alloc_sem_key);
> 
> This issue can be resolved by making the down_read -> down_read_try
> in the ocfs2_read_virt_blocks.
> 
> [1] https://syzkaller.appspot.com/bug?extid=18a87160c7d64ba2e2f6

I haven't checked this patch, but in my view, following URL is correct.
https://syzkaller.appspot.com/bug?extid=e0055ea09f1f5e6fabdd

Heming
> 
> Reported-and-tested-by: syzbot+18a87160c7d64ba2e2f6@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=18a87160c7d64ba2e2f6
> Signed-off-by: Mohammed Anees <pvmohammedanees2003@gmail.com>
> ---
>   fs/ocfs2/extent_map.c | 16 +++++++++++++++-
>   1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
> index 70a768b62..f83d0a3b6 100644
> --- a/fs/ocfs2/extent_map.c
> +++ b/fs/ocfs2/extent_map.c
> @@ -12,6 +12,7 @@
>   #include <linux/slab.h>
>   #include <linux/types.h>
>   #include <linux/fiemap.h>
> +#include <linux/delay.h>
>   
>   #include <cluster/masklog.h>
>   
> @@ -961,6 +962,8 @@ int ocfs2_read_virt_blocks(struct inode *inode, u64 v_block, int nr,
>   	int rc = 0;
>   	u64 p_block, p_count;
>   	int i, count, done = 0;
> +	int retries, max_retries = 5;
> +	int retry_delay_ms = 30;
>   
>   	trace_ocfs2_read_virt_blocks(
>   	     inode, (unsigned long long)v_block, nr, bhs, flags,
> @@ -973,7 +976,18 @@ int ocfs2_read_virt_blocks(struct inode *inode, u64 v_block, int nr,
>   	}
>   
>   	while (done < nr) {
> -		down_read(&OCFS2_I(inode)->ip_alloc_sem);
> +		retries = 0;
> +		while (retries < max_retries) {
> +			if (down_read_trylock(&OCFS2_I(inode)->ip_alloc_sem))
> +				break; // Lock acquired
> +			msleep(retry_delay_ms);
> +			retries++;
> +		}
> +		if (retries == max_retries) {
> +			rc = -EAGAIN;
> +			mlog(ML_ERROR, "Cannot acquire lock\n");
> +			break;
> +		}
>   		rc = ocfs2_extent_map_get_blocks(inode, v_block + done,
>   						 &p_block, &p_count, NULL);
>   		up_read(&OCFS2_I(inode)->ip_alloc_sem);
