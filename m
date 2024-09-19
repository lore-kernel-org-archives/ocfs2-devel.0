Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03E722098
	for <ocfs2-devel@lists.linux.dev>; Thu, 19 Sep 2024 07:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726731888; cv=none; b=kbx9AVmpMFgA2Hf7Db7Q/bDy1fWOysE2AFf0wFwHRGkWWIpLVXQtA9kaS1iqtySyVKv8a1WEJpCzrmYcCt7s1AqN0A4brfOZ1D3wcdVophUeL4UCl7Z6F/qmWedBzsHst3MTcbpuepS+I0L8DbVhO+PwEH7G/MGrgx+PoL5vQfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726731888; c=relaxed/simple;
	bh=4QhxGoyk5nQU1ZqkTKte61SE9/xYOOBpuxmqOGCRHBU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sQr5n100JzcM/iEdMewgMQ2cbRZtzzxst7AUQ0Cz3ujVaewRQFGofGL2P1diLOlDOnXXVqcD9MkunwUCDvu8y9kg/gsOu8mDLFBfbAh8yF+sSckJ/64hiqHogYEptKiclsqTg4Wc3/IrC10alDXPY9D98QvW5aIGDNXFQRBiGn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TheLN/wl; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TheLN/wl"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-374be2ad12dso14336f8f.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 19 Sep 2024 00:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1726731884; x=1727336684; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lYgS1bx6CKLlYwen0cd10S/R5x4JBVI14kwUyO677dw=;
        b=TheLN/wl2z0ofwfs9w+GB2mEFo8jUgLUg12+BE+hkaw/6rMiUdniINMa/D+QujU+hj
         4RfaDSv1Bg5Q38r6J8iaEPsVURdv+6B7fpQ3DJpbck9mpsWGNWS0sD5aOLkl+EKRqeNw
         wdz3agIty5l1sSXE4dFMLaSmRFMyAu3qlOdJvJqJMaIzt8wO2Aod0VV6QKzV9B3L3fjR
         WpovBhWSaOJ0dd+WkcalWCf5P0Iwp/j0KR+kPw9ovFZFc9ZrlTuVxV2x7gBnF1mTMwMg
         Be+Kk5KU5//iyU0aFgnyQs/r4HFn9CeNhaQfbh+TuM2YPzxtznUtikPAH+9hKSTQDjTt
         7pOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726731884; x=1727336684;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lYgS1bx6CKLlYwen0cd10S/R5x4JBVI14kwUyO677dw=;
        b=MFEWGHrodb5piWq7YrKBCrSVmTEbI14b/SJ2zDKFzIiGF/uhREplc4CLKHdoWabxjf
         SdbRI36jWO0hhSlIbHPohE1P3t5iqO9ja/liq/52MQtlslj49ZrijyIwBmA61Gc0wGgx
         kOHHi8Pw1/fdUtLIMVWi/qazzzpvoExqwdWTydvPdhyG5ZPQk5ZQlUJAV4C//8Ru1423
         8SHVy2F+cRTSMMR3OtUq+SG9Gy6hnV/KwOoxSMed1LJipPbAkH9sVHYcT1hNt0xQv8nq
         wwJVzOQPBeo0JCS1Q+7IqCbhi6Su6oMCwRZYeLlFZ3m/P8V4rDfRpTKX+Ri6Cf40EPw+
         AaxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUp8KRPjFQZZvxNfuo4+Z9O6HLyVLSrBzGp14/TXrIDmTBGYXhXHRBoli4CroPJLG3iTkTq/vZwD5OjhQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxtTmn4TOZGbKpLfGnCUN+yvlP0qePL+TvL959Bv3STJYjPKk3j
	6pqaVR2BOxUM3nLHJigDqU/gCa4R3QCKfoyTOsITRk3C240Yqa4r+ACfT1Dm1PA=
X-Google-Smtp-Source: AGHT+IFApZ8JUxsqP+nFEp/TdVEQ7Zsf62AeqvRIT6tCZLHeH3EkmftxsPYqWjkQTXZISA69jun0Tg==
X-Received: by 2002:a05:6000:1f89:b0:374:d2b4:d9d0 with SMTP id ffacd0b85a97d-378c295451cmr7335912f8f.0.1726731884033;
        Thu, 19 Sep 2024 00:44:44 -0700 (PDT)
Received: from ?IPV6:2408:8409:2432:371d:7607:a570:bf1c:aad6? ([2408:8409:2432:371d:7607:a570:bf1c:aad6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ef93b2fsm1033853a91.49.2024.09.19.00.44.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Sep 2024 00:44:43 -0700 (PDT)
Message-ID: <e068a56d-959c-43ad-aaea-839b89344693@suse.com>
Date: Thu, 19 Sep 2024 15:44:38 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] osfs2: Fix kernel BUG in ocfs2_write_cluster
To: Mohammed Anees <pvmohammedanees2003@gmail.com>,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>,
 syzbot+18a87160c7d64ba2e2f6@syzkaller.appspotmail.com
References: <20240918172026.2532-1-pvmohammedanees2003@gmail.com>
 <20240918172026.2532-3-pvmohammedanees2003@gmail.com>
Content-Language: en-US
From: "heming.zhao@suse.com" <heming.zhao@suse.com>
In-Reply-To: <20240918172026.2532-3-pvmohammedanees2003@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/19/24 01:20, Mohammed Anees wrote:
> syzbot has found a kernel BUG in ocfs2_write_cluster_by_desc [1].
> 
> The issue arises because ocfs2_insert_extent receives start_blk
> as 0, which incorrectly maps to a physical address of 0. This
> occurs when block is 0 after the call to ocfs2_clusters_to_blocks
> which is invoked inside the ocfs2_add_clusters_in_btree. The block
> value is then passed to ocfs2_insert_extent, leading to the problem.
> 
> [1] https://syzkaller.appspot.com/bug?extid=18a87160c7d64ba2e2f6
> 
> Reported-and-tested-by: syzbot+18a87160c7d64ba2e2f6@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=18a87160c7d64ba2e2f6
> Signed-off-by: Mohammed Anees <pvmohammedanees2003@gmail.com>
> ---
>   fs/ocfs2/alloc.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 395e23920..926ffeed8 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -4843,6 +4843,13 @@ int ocfs2_add_clusters_in_btree(handle_t *handle,
>   	}
>   
>   	block = ocfs2_clusters_to_blocks(osb->sb, bit_off);> +	if (block == 0) {
> +		mlog(ML_ERROR, "Conversion resulted in zero block number");
> +		status = -EIO;
> +		need_free = 1;
> +		goto bail;
> +	}
> +

If you check this function, there is no IO operation, so -EIO is not suitable.
In the the ocfs2_clusters_to_blocks() code, there are two possible cases where
the result is zero:
bit_off is 0 or bit_off is out of range for a u64 after a bit shift.
It seems that the root cause is that __ocfs2_claim_clusters allocates an
incorrect bit_off.

-Heming

>   	trace_ocfs2_add_clusters_in_btree(
>   	     (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
>   	     bit_off, num_bits);
