Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D1F3595C
	for <ocfs2-devel@lists.linux.dev>; Tue, 24 Jun 2025 02:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750733483; cv=none; b=AhdBOcxgS/ET4Rqaao9Sy2CLWf85M2wDEfZLNPbxQHvb3H2wg/ziTfqDJWc9iXTsI5RmAULt6sRnSThBasK18CrzHB5sAlbpkqXPlKbZMVPeC15Spp3TFRuV1fSted50sFOL/k6x6JTjKOa6cfhMb4iradCRFsvdXokA58jJPwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750733483; c=relaxed/simple;
	bh=EEJR6sXU0/BLALTA+1+eUAFyAkGYctDGzduMwikFMd0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HNXvv24DB1MoF9mnHl5fNP2yHeAT3CzPex2B0RQNSFDJkbKugF7Z/ziylJGM1k6Jxk9D6qT233xo5twUgmf/OiGjch3Oy+KZPInA2eAt0U/Yv4D90yVzQkHk/6gHMn12f1MPpsZuIsEsLCAryGLwqkwDvXTv+FVjgGEDnuOmRfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HkiNxFPo; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HkiNxFPo"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3a577ab8c34so686235f8f.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 23 Jun 2025 19:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1750733479; x=1751338279; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r2kkjtXLzuAokXE5IqJVyYKA9iqEVlvjjhxCskYZ3Ao=;
        b=HkiNxFPoKh2LNu5wU8GsHLLn9O2Hs4USAeZvZgtB2eM8t3v9V8XM//mOhz5b+CW0DN
         0CO70zjj5CXHymAg4g1Qm3VRj0PeJ+bxNauqH501SZiokPV8qJCpCfppQiWt/DBfLfwT
         Qb9vg+92Yp/Lafhds/YC8TXcDO9bH6uOUNuyttb4Pq48a1319gCfnd+RyB0E/asT0d9g
         2fdTZGYG88j7kecra2HH8BS710zSCjApF8pGz1U+8h0vDJ+D8F7Jg2skZXOFxAnfEHz8
         dZgDQq4enNx3NK++4Ppp/RAac8xhrP7avraTwFUzsF/zlNhJlw9zzo2PcsrEZSpZ9OLr
         K8ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750733479; x=1751338279;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r2kkjtXLzuAokXE5IqJVyYKA9iqEVlvjjhxCskYZ3Ao=;
        b=baWcuip+l3pWiog89YyYy6SAbFGIeIU7+det7mBBHrDOuQHkIU23w7f/AC8Mn+8VNE
         r6uXMD0KssqFK/d3wB89G9IRqAH5JUQruOnYIrK+Y7GuTI/5XRTtpy+ukxdKbf6vjGBy
         XYl1imvQpFrPoPSCr1bEsHyllUckVinwcxhyfOLP9TEAl3mnkbmz5SYvngY3xpF20Jfi
         YsUpkh36vOe5OkHU3Ouslf4sGXJfsixT8nNrfLOWUrTOtAjtld1BQ+/yy3R0ZqcvS0A9
         sC7mEluwrb2v+4/5RxDGpG2NOMrgBBU4Evx8aqq4sSRzD80vMOgJq8IVCspzM31xB7QG
         eOFA==
X-Forwarded-Encrypted: i=1; AJvYcCWAtecclfaFX12kmerWpaNK0pCW57aI9gEBrsQo15YwgeGI5+bYfpo2qIYTi2l5sQNCLsyzcb+W1Z0egw==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywwqa6QPiFQ3Bk5zYE028dtqIDCkps8Ca2GQC/HWV4U/xE7n2kM
	zb1Q1Ux1jtcR9kFg9fzr0cVCUWyLfbQnOovW/rXdbALholUwupdKL3EeX55ditGF2Fo=
X-Gm-Gg: ASbGnctFFD8PMkzbWXVJ5eMvHr4JCn2Bw7gAUxhNE/H79BQWu1i01n6NBBgGubk0MMi
	27ENSzjjEwGywYJEP4s1WG9HmYm5aKhVJJaZbaX6ukYXJi2rU0xNa/VlSgiFUnrG3Isf8Ya8qhm
	pveoU4EL1LS2wiz8m6wuKD53qud2mPsyJLh2hZy/D6iUzsNSBYmm3clfcdXhspInEkuv32WXfjm
	Qg100Hi5yepeHgR+wngMF1F4J7/BSDIGWDvZtonaGAkI9Cu1n7gHgVdhEO3wKoVKZekAwgHAuPS
	CfS1cBeOb60BndAkxxR3jxUrfSeTVJUCPG929Mn+1YZ0Dwe/eBZ7gtA3CDjj9v5JUjf32mmeeMq
	M+A==
X-Google-Smtp-Source: AGHT+IGSJY3cPvwzUW+IxhjN3qW2fYFuXMaP6dq+d1HMtkEOnrp1h/q9v4NOKvlr1Mao5vhieQTt6A==
X-Received: by 2002:a05:6000:2f83:b0:3a4:f7ea:a638 with SMTP id ffacd0b85a97d-3a6d128bc58mr4225162f8f.3.1750733478981;
        Mon, 23 Jun 2025 19:51:18 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-749b5e405a7sm535120b3a.64.2025.06.23.19.51.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 19:51:18 -0700 (PDT)
Message-ID: <be064737-f78e-494f-99ad-4686feb69eff@suse.com>
Date: Tue, 24 Jun 2025 10:51:14 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: kill osb->system_file_mutex lock
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
 Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: LKML <linux-kernel@vger.kernel.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, jiangyiwen <jiangyiwen@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@lists.linux.dev,
 Diogo Jahchan Koike <djahchankoike@gmail.com>
References: <934355dd-a0b1-4e53-93ac-0a7ae7458051@I-love.SAKURA.ne.jp>
 <faf70481-09dd-4c7a-bd43-f1e8bec877cb@suse.com>
 <1c0f49ac-2634-4126-abcd-7859fc71f134@I-love.SAKURA.ne.jp>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <1c0f49ac-2634-4126-abcd-7859fc71f134@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello Joseph,

Do you agree that we need to add a rule for the ocfs2 read/write (IO) path?
- When an ocfs2 volume is in the process of mounting, all write
   operations must fail immediately.

- Heming

On 6/24/25 09:55, Tetsuo Handa wrote:
> On 2025/06/24 10:33, Heming Zhao wrote:
>> Hello,
>>
>> Protecting refcnt with a mutex is the right approach, and commit 43b10a20372d
>> did it properly.
>> However, I don't see how your patch fixes the syzbot report [1]. Could you
>> elaborate on the root cause analysis?
>>
>> My review comments are inline below.
>>
>> [1]: https://syzkaller.appspot.com/bug?extid=1fed2de07d8e11a3ec1b
> 
> My patch does not fix [1]. My patch fixes a bug which syzbot reported at
> https://lkml.kernel.org/r/000000000000ff2d7a0620381afe@google.com
> when testing with Diogo's patch at
> https://syzkaller.appspot.com/x/patch.diff?x=178f93d5980000 for [1].
> 
>>> Reported-by: Diogo Jahchan Koike <djahchankoike@gmail.com>
>> 'Reported-by' should be: https://syzkaller.appspot.com/bug?extid=1fed2de07d8e11a3ec1b
> 
> Since there is not yet a bug link for my patch, I don't choose syzbot as reporter.
> Diogo will post a formal patch for fixing [1] after returning from vacation.
> 
> 

