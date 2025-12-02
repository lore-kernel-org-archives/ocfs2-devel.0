Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6623078F4F
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Dec 2025 14:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764685934; cv=none; b=uizVCkMPOkql0oCEu34HDY8d6utFeKKs7KAbn0OC73+ODmKOGM2zWwKrG3uRqltawnQqf/RhcHHBYe3G9lcL+97xw11tAYpy5Fv3FQpMdvqGsWqtPM+KqhyuQZLF45F/VA7O3j/GVk7e6AND9CEf5KISaTPYIorZ9h0AGfZuEM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764685934; c=relaxed/simple;
	bh=GtvgRUWIt42eja6ZNe4wBv+SXDBcZHHmT0oxhgkwT/Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=unvuCBMYIAuJ1qZFFjjyxPACEdiZ4zqgChNFKp9ZukZgj0jI8j1NusrVoxWoiseIiUnreB38Q9G4rSa5JjtRTm0vQXs9cUhjKNqhRLcvkxA/HDcjGzDN7Ly3uiuX44ytJKdCwtfG02tLj2QlEv2vQzwezPS0renTF+q/zkOjdcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iB4ejV3M; arc=none smtp.client-ip=209.85.221.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iB4ejV3M"
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-5599b119b4aso1262550e0c.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 02 Dec 2025 06:32:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764685931; x=1765290731; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xrquJ3keCLuu58rTx6QnUgW+j7OzYdWATnoWvggCzgw=;
        b=iB4ejV3MoZ5Oycm0zSh4N/tu354vMZ7ugNQmhZSVMMTx2jCXnPY+eVRvzEtt7RccBG
         PQFAtBTUakc0hknNTPt0Xtwkv0iLmH6ZBbGo0awsi1mw7HACI14E4t5vHgT57EsE5tig
         2pMav+2RuOohdPs0ycj4DBV3FcAdCAaiPK1L1/bwN33vb8gH+SzlpoRXIHkD923TYd3t
         vMporyoz/c1tGtf0tmqFol5LU+kmY6QAXOin+4P356ylw7lx8BsLYFTEzag56QVWtDlm
         BQfJXLxk2qu1u2bBBCnwme2+G2XlalVABAMfhhylN/xuG0F10qcb0gmsf8ODkur6Tko4
         vnZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764685931; x=1765290731;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xrquJ3keCLuu58rTx6QnUgW+j7OzYdWATnoWvggCzgw=;
        b=CzmRzcEnarOvMJgOESDa7wpTVwgk2C5b8IsWp8Fo7cSK9PVL0Mr3+acf5k2igU1gIf
         UakM/ri+z2GQ0r4hobVPcGSPIvn99ZRuiJCvkb36P7Bat4qMKgq6I/j0+H3K8dncNUPE
         BJHsnVDq97u5ON8R0mO0W+7a1jTOVJPGZmK9u2QSANhlyVM1ruO5puy9DqQWkC/rE7ku
         LPfi3ivjYmCrnaLArltyWHc9LfNoB0RgZjB1Va6TiUsQ6ALmEBu+51ib7W8Hc23YYSj4
         kRKObcZY8UabbP++nLMWCu6Pei3rMp5xCEskIlaJE9mr82gIQj7YhoR/beosmclsFwbd
         0IWA==
X-Gm-Message-State: AOJu0YytDRLnb6kmhtLyOS/jCo/T52xrFGlBfz1IzjCnQa2ObQBbepZS
	0fu34Z198OGZI2WsfLCdMeSwuBt6Y0xEPGgsezWFS7XvoXShyeGeUaYG
X-Gm-Gg: ASbGncv+lXcuB68RXJYD1MArhwCeCtobxXmp9B2Gcvbqa4Dnr6vyP8JHF10ZO1r+05t
	Y2x3fU+eRRSTktnXHR1MQSk8jGzjhIONztNv5/JkXmCgeu+LmmG2IRBwzQ59e0aUoJos7MstuHt
	5N+dNEUOrLYLaqsdvUcyCfXCycfgaCsLFYOkoxTby1HiPRB5/nFIPAFouPZLoRfpskMQOkV/XiF
	qqPky7Usd0IyECrmyqCUYI1JTeMyYd69q8Xx4KYnATSym/bk6nkJYxfE+qhPsiSr23p1Nd9D8zJ
	F39vaXQa+vKnkqfijEtGJhE0Iwei/YpEZ7eiW9oqhbPeNZbuGBOO+KbbpqPIGvj2tiUxti8lzMC
	qqbv7i8mEP+Y4CGx28oizrzW9jfXXZG7lS3Q2Npzw9qFkYxJH4gPvgrZzcE1szOPUUMhdEO/Yp4
	xhw92h8ARMjK2yXaXKrDsewZ+wwkI=
X-Google-Smtp-Source: AGHT+IGm3rFQZ0L1MLORZa1WMrEdSFMlwABJYjA6uq9zgTT+EWALwb6/SsKPFK5zvc1KH7GcdN1u/A==
X-Received: by 2002:a05:6122:32c1:b0:544:93b6:a096 with SMTP id 71dfb90a1353d-55b8d6ceea7mr14263046e0c.8.1764685931159;
        Tue, 02 Dec 2025 06:32:11 -0800 (PST)
Received: from [192.168.1.145] ([104.203.11.126])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-55cf4e46cbesm7176561e0c.7.2025.12.02.06.32.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Dec 2025 06:32:10 -0800 (PST)
Message-ID: <d8406da5-cf7f-4e90-b01d-db82011e3a0f@gmail.com>
Date: Tue, 2 Dec 2025 09:32:07 -0500
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] ocfs2: Refactor read-only checks to use
 ocfs2_emergency_state
To: Ahmet Eray Karadag <eraykrdg1@gmail.com>, mark@fasheh.com,
 jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 skhan@linuxfoundation.org
References: <cover.1764640432.git.eraykrdg1@gmail.com>
 <aS5TM7vkdHldOngq@eray-kasa>
Content-Language: en-US
From: David Hunter <david.hunter.linux@gmail.com>
In-Reply-To: <aS5TM7vkdHldOngq@eray-kasa>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/1/25 21:47, Ahmet Eray Karadag wrote:
> Hi all,
> 
> Please ignore this series. I missed a semicolon in patch 2/2 which breaks the build.
> 
> I will send a v3 shortly.
> 
> Sorry for the noise.
> 
> Thanks,
> Eray


Did you test the code before sending your patch?

Thanks,
David Hunter
