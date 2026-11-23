Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795411369;
	b=5f7ONJjwl52WqTn5xekkmegt7y09hjpyOPtP0qRyr8nln8PhickLy4Gczgaigf+om7sB
	 Q6If43gmh6rx1RLZgc7HIgbnPlgzkkaIG+4MvCz8p86j7yKDlSk64DNaLDcx1MF3gBwQz
	 jAj1dwFWzAEi19vS4Bajqk6qu2PGSJX+XV0ie2esWrK8VFDsVB1HE/8rDh7YOG8WT4Nq3
	 fMJis+pQYrHjIi3HQocwtmky38m5KyzhKu5T34c4LYjQ7wZvwkd/wdlOUNe8ZWgIH+glm
	 /8Xa4vUHVflmSQhWmC81QdDjqdroWocINGv8xunIgvslu8y1QG+Zvr7+gYlZhXD6Q9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795411369;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=3Mldy9DU+r/shbk+s4+9YUnzttoJhNXT94VNGbnnMOg=;
	b=ygWDs1X1Egnfa2apvyAZCuYQ1lxngPzxZ7y1VMZ3sW/kO6jhsfD3zhTGnCVex9gAzY9r
	 8wKIQbc5+RLFsx2ZN3GyVF6TCK4ypgMb0hKjJpUXNAcWaGdLk0E8wyhrrSdCrUgDyUBvB
	 /orE40wttaWMzkrpthyJnAGWR19q8/DU9wG9GYJlH4yLQUJ1k2rqYBcEi2NzchYl6fNAq
	 OIpEp1HSlF98QANtYghXxG25DgKENsaDBifOWaa+Fe0V5cisZ8ZW7s5jwGFpFp7TLsaqr
	 QaqlH0xxDFlFrNcpf4t+Wa+9LZSzrmW+euPOwEj/hTKD8579aOUlc9tZK49dBAdXZVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=bsx4bctM;
	arc=none smtp.remote-ip=209.85.208.41
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79625606A31E
	for <ocfs2-devel@lists.linux.dev>; Mon, 23 Nov 2026 05:22:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79625606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=bsx4bctM
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6b896db8f9bso166547a12.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 22 Nov 2026 21:22:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795411367; x=1796016167; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3Mldy9DU+r/shbk+s4+9YUnzttoJhNXT94VNGbnnMOg=;
        b=bsx4bctMwC9mJ8omlEXBESXlHsaWUT6xkC1rvXRkQnSODT5GU8qd0PYBJjbCHFlmmj
         9JfndpyvtdUHdDIfkwm9z7xBLq8wTVaLjJNyaDuzaSMpzn3ybE670DuKlbCx1NWVtluJ
         wIGhRX4pAdPrnyLZjMtAYjACdwUMWBO10UlHcTodUwAsl8CP64ZFiAmgA02XBJWvY0QC
         j5K1wFsB4R40ZI48ZoRO0kXVqnpb7ukznD3qui8Exegpy3VK3ZIEZfMuqyj9rmX2mEqZ
         3MGY9L4E//K+VX9jlM+LYomvzXj7Q7wh9VqAoSvFL9KwFKA52Xe1lFXMEk2Q3opCIiZ4
         ZJCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795411367; x=1796016167;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3Mldy9DU+r/shbk+s4+9YUnzttoJhNXT94VNGbnnMOg=;
        b=I4KQHK7xBkRWbGUD8oVI4bePil/6ZXGQbvhkLWtNch1sR2Vnp/6cZB8yJS4T2FozQR
         0g617O3HAOpQProygIdH50zACp2PCTY1eYkg+rxRsW7HKnEQTMHRRGWSKt2EtkI/xWb0
         Qt4B2kOwYIXcTQpNlraZYcJJ6nzn4UsNDnyNAMi9xpWBnbceLjFIBrIR9hit1xm3eBLj
         AjcZnGQhHM1yIDPzc7g5N8Ly85esVHCpnDRYJEfIkMnz0WEXSxE5HugJ5grXKLtNJ1h3
         3ZMg59HI4qoZB1rpwTpzQgY/X2HMtFPUCQ3ma/r9esACMiIbdDDPZsOUH3MAHT8+5U/U
         7KDw==
X-Forwarded-Encrypted: i=1; AL+hErGo8eg+xTptvsv74D7RMru3NZsVPZqNfYzhcx3YqxnbEGSbWGNBWUyedmuapFiauvwdKbxHn2Fbvcd1pw==@lists.linux.dev
X-Gm-Message-State: APuU4Z9GlezGtTOCYkh9L8Pxh27BYfsHEt9yHZlB1bmC5KNR9lwNv02r
	zjwur4n2UtbuJLglrYQ4UhB58ORSZjy920rH2ypCDqVjFegI5hnuHPsDEfXLLzLiGKk=
X-Gm-Gg: AZFdTZejKIVkkrdmbIpg2SKV18jqKeKio9wskdoSMXcZ5IHDUcVRJC8S29Hm10M87nH
	IgCWeOx8JlCN4Q27zUgfxBBHj8096ICaNlXnoSPuRy+XOYfrS5DxAV2hfsW4+sOhULP2dV0scQC
	dI7+Caxm2/QVzzVT0P9aqtt+HJib6i6XRdFj2foIuCeBq9M8R697VA6r0qmcVIlWIuE6Meq3mUm
	+w/2S0NHEda4Kt89Zfkz8/qc94Za/JE7qznzgLncK9lPkSjG3nDbcUqyXm6ZlLMyiHuFWnTOd+P
	tPaIKsgXg4U5lL+0Iu1Aq5MMfYb5+UohyXYJJBgbKNFXJSyaqfD0i/8hxuPaupwcBtwnLaqg1HG
	D7V1e+GTy2i7+Jw7+qAqn33CGu3loE+4N0CVTx0vZgCZOiCJuxXbR4qQZcOIpEhP++NZddsVFwV
	kQY6QEGVMc9TAnMWxF6uYfCMs8KxE5dRlSppxd1esYjFgK6OMg/Ji8/g0+DhO+y7z44SD+8EukP
	pXd6ygCwaEgzVe2ttcvUslLEjR7tVFyOnZoOrertHqmqg/BnBPn+G9Q2bmZd0mCw2J5OXCy2uNE
	KL6P4PoD8k8CX2CII3+A6FN66FaMkZaAliQ=
X-Received: by 2002:a05:6402:90d:b0:6b7:dace:635d with SMTP id 4fb4d7f45d1cf-6ba37ac9214mr8144108a12.0.1795411366855;
        Sun, 22 Nov 2026 21:22:46 -0800 (PST)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f0c1aa3sm45726785ad.21.2026.11.22.21.22.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 21:22:45 -0800 (PST)
Message-ID: <d233c82d-4723-477e-b51b-4beaee503082@suse.com>
Date: Mon, 23 Nov 2026 13:22:40 +0800
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
To: Joseph Qi <joseph.qi@linux.alibaba.com>, Christoph Hellwig <hch@lst.de>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20261120060014.12087-1-heming.zhao@suse.com>
 <20261120060014.12087-2-heming.zhao@suse.com> <20261120183415.GA2450@lst.de>
 <85cd5f2f-5b08-4aa5-9b4d-7e271d021c1e@linux.alibaba.com>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <85cd5f2f-5b08-4aa5-9b4d-7e271d021c1e@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/22/26 22:29, Joseph Qi wrote:
> 
> 
> On 11/21/26 2:34 AM, Christoph Hellwig wrote:
>> On Fri, Nov 20, 2026 at 02:00:11PM +0800, Heming Zhao wrote:
>>> As part of migrating OCFS2 DIO read/write code paths towards the modern
>>> and performant iomap framework, here introduces ocfs2_map_blocks() to
>>> replace the legacy, high-overhead buffer_head based block mapping
>>> routines.
>>
>> Do you have numbers to antiy the high overhead?  Or should this be toned
>> down a bit?
>>
>>> In addition, OCFS2_MAP_* flags are defined to gridge OCFS2 internal block
>>> mapping flags with the iomap API requirements.
>>
>> "gridge"?
>>
> 
> I think it is a typo for "bridge".
> 

Yes, bridge.

>> Otherwise looks good:
>>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> 

