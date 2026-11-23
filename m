Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795412354;
	b=xYJRZoip31RMbCobCigOUMDDG4Y5Vf16lGBusYpHslzCtdZOxlznk527Rh9qoHwZupmv
	 f/7wrrZy17P2M6gdRpWOihHIHtZXuv3YR++ShvxzT2YHcLKFh0S2bzS6hTnXcqg7cXN80
	 v1Y9KVW5+Gareheo8s8JfSQB0xv5OIjSq6IRGEigL/1SzBMhteLgF+SNWz9VpC1A2m83F
	 xzsunXvWYHO89u6LH9kWX+ArNE9+FliloaBwdV+VlUm1ymaHeoebRMLRkvtElMRSbh6LQ
	 prXk0Ai7j96oTX1uAkB3/x4KFxgCyjSPCivVjdctB5wIVy+hNNDW6vMxaAxFkT4atjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795412354;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=fvhTAiYdeCl5kHtUIEV2YL4HP0g+GBZ1mPbqO9vDWEQ=;
	b=Q5U35DOCM2P3Ww6kdhu2NYCiZwTGQWp8vz5hYNGUBfQpL1HFA+RaxR9qjHzKiWMTQvnH
	 IohFn//wIaG4860IsX2CLZzDUrVaS/CRHZUnczJyLoTfqDQYWFSidWBr5cxCCFlTAMDBc
	 ht5OtzllYvL8u7+0VbUT5UPpUv2EmjKgx7N0qw4m2RPLtYSLg0qXnsVvXe/7Zi7qZ02hn
	 E9hbS6PnQwSG1xBy3S1IruGvCqvBuZLaOOLQxySTcKqmc7Y3rjAuJwQ3ujJ0cuTuf+PhB
	 uQ5Ras5yuzQPgMvRSPisjkUirlRxrgmdPKpdhFNVmUzpnJzL7HctB9YVnN9P+/Sx6MQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=WeZ3yuZo;
	arc=none smtp.remote-ip=209.85.218.45
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BBC606A32D
	for <ocfs2-devel@lists.linux.dev>; Mon, 23 Nov 2026 05:39:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 97BBC606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=WeZ3yuZo
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c50686daf9cso58385966b.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 22 Nov 2026 21:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795412352; x=1796017152; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fvhTAiYdeCl5kHtUIEV2YL4HP0g+GBZ1mPbqO9vDWEQ=;
        b=WeZ3yuZoAMFgO3f1gRMLV3qL5MzyUXJHstUdSJtAyovGp8OBHjc4YOlsA6x/ETTppy
         GHPnatMYCLInGYyCc6AFQdLFbir3Qlx40IKgzTsB3htVlL2PDNalR0UnEHfOSa0M5s/7
         /vs6QSWmYX/zkcyN2e4qdzjm+rXtv84E/Se/+ADUmrXCl4/1kORqw+G234CrIsMVVbe/
         fHT4sS2oQnjS4pdoKFjc+1x+1NWWDY1OtZ47uDm/yJ8kANAnoet7xvmUfA5rywkE5KTh
         rlCpEeAdRaOormswZm+bn7DFSgYub46CvOopT0iAntLHL0fvXKP0iXBuHLMpUxIlLUB4
         NU4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795412352; x=1796017152;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fvhTAiYdeCl5kHtUIEV2YL4HP0g+GBZ1mPbqO9vDWEQ=;
        b=ZY3N14r0dt2MBnTQB1rqTVclwPHa95FgAaRIwSZriY2TduC6sqCEQIazkxQ1B84I/P
         F/eRz8EQw4I4f38UOIrsG3XFuPyyBn1c2SYxnnh74rETDtXuhhDrlTO7KCPtlrmQf+fL
         d2eBbub6S2tzHfoQivxjUaAnNrKgL7DCCjXG8tWxNzD8wwfPmk8hIYqCcM8EBoUtZ1Pv
         6ZqIvFwDfVS2PL2kq6Sb9rqZsFTjK1QxF0Ur8bZKkZG9wd4inVdGE5Pcu6oQ/6OKuOZS
         oZuj/CJQ5Jegt/MVyzDEQn2kUicRvFTzhxui1wFXvyyGvD4rzd62k2G9bafbXaqyI1Ai
         9IlQ==
X-Forwarded-Encrypted: i=1; AL+hErF9vSJcmAFRKTBxMAHorv5XGt/rgAGuRMd2Xu8i4SzHZ1ib+MWohdkTozz269nasgHkJcGdaaCudyCsdQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z/V561feMb48yQ5AKh7mqw8o140SjLHQLZ6MlKwXH7J+mNIjEa6
	pvZp1sita+dvb6nUK2ozieIi4iJJQ5R3rFMt3G9q1RSOPnMw9sgglzBvXOs5b8Tz8u0qeyirXTO
	L1BnsOWE=
X-Gm-Gg: AZFdTZcOI9JlrwUEkKik1M162xK3TsnXsfQZbZs1qI3q4tabBr9+hBgWv5z70W6/1iU
	eyTOGT5chcPbyB8NYfH2aqyVA77DnGh8rioO7yF2s43mrnMVxE+XKyi55h0hUORnMbDQy4fTMlV
	X6+Bzwa3oy+0k57fxCZdsbqrExpAER9n/LEk1BeXuM2VLiafRVmC3T8DbEjrCh+gXixuocaEMEf
	aob9Ee9pC2wXtra7DaZnme598g7bSAjKG6u/MCjm5Le+yIrdHyeHMA+DCs2S7wMDQ+PP3VMNnbj
	431P9yYqpRTKW1iy38eQjcEhmzZzJv6nn20fL+j7uXVqsfhcPOnP5kebn1kA1Zp1quBmrl0X9ag
	2wjkKCWHhfugoHxH6Fw6Kly5ANM/4LHFEFyt3u4rD8oA1xzSDZf06OLpZf7D/2VKpKI7SQF57Lq
	PS7nvcD4zlj7r7XSfS+3gsvnPwvmi5j/OLvkcTXJ6Pfli5CmOTlMmcCUvGF818lGCBCFP1APR/v
	3sTOjMFHgT+8PxUQNoLmFieb7xDMFrbyYKQkpqbC7mkVNbdJkSAtXP/4HKTtnIoRcc37Oqk3Rn7
	gBmf0RadioFm4JJnt5rP9OHau8wRKXl8ioU=
X-Received: by 2002:a17:907:932:b0:c51:8bf:9f22 with SMTP id a640c23a62f3a-c513a5c0549mr753217366b.2.1795412347619;
        Sun, 22 Nov 2026 21:39:07 -0800 (PST)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f118c88sm46640605ad.56.2026.11.22.21.39.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 21:39:06 -0800 (PST)
Message-ID: <32151907-21a5-4655-b4ae-253dc7934588@suse.com>
Date: Mon, 23 Nov 2026 13:39:01 +0800
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v9 1/3] ocfs2: Add new ocfs2_map_blocks() to introduce
 iomap feature
To: Christoph Hellwig <hch@lst.de>
Cc: joseph.qi@linux.alibaba.com, mark@fasheh.com, jlbec@evilplan.org,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20261120060014.12087-1-heming.zhao@suse.com>
 <20261120060014.12087-2-heming.zhao@suse.com> <20261120183415.GA2450@lst.de>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <20261120183415.GA2450@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/21/26 02:34, Christoph Hellwig wrote:
> On Fri, Nov 20, 2026 at 02:00:11PM +0800, Heming Zhao wrote:
>> As part of migrating OCFS2 DIO read/write code paths towards the modern
>> and performant iomap framework, here introduces ocfs2_map_blocks() to
>> replace the legacy, high-overhead buffer_head based block mapping
>> routines.
> 
> Do you have numbers to antiy the high overhead?  Or should this be toned
> down a bit?

Thanks for the review.
"high-overhead buffer_head" means that regardless of the IO chunk size
(per IOCB), the OCFS2 buffer_head DIO path splits the IO into 4KB page-sized
IOs. This logic cannot fully utilize the bandwidth and easily leads to
fragmentation. In contrast, with this patch set, iomap can handle up to 16MB
per IO chunk.

-Heming
> 
>> In addition, OCFS2_MAP_* flags are defined to gridge OCFS2 internal block
>> mapping flags with the iomap API requirements.
> 
> "gridge"?
> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

