Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C8B27932B
	for <ocfs2-devel@lists.linux.dev>; Sat, 11 Oct 2025 12:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760185683; cv=none; b=CSvCuVPUo0c2HLrL+mP94WWx5G4FuKQ1Z4bQmYYpBCji8TheptaUlIUpZ0nfY+gKzhR4n+31v4ciqy9VqxG4P8h9XdWbtsWZXBAGrbfK1BqUv26ZM+9Cl/lF+Vc/7IT4TpFzsjrDOrtBX5NQuwEMoLwj7DBMRhX4p/M2zyL8DL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760185683; c=relaxed/simple;
	bh=U/bl4ufAGST0N6pp6P6QL/PdrCDtrBFQXgxa3SEYU5Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FOen0lcUtQu3RHK7jsNbdYucCJHQ5syLbh4Quvx1yIr1/Gz8cNF3+XoipKwCOZNXMlHU+P5rKUYC498+tXmQQiKTI5Eel5yx/PrbLNMkTxTB4QP9dfa7DHq6hhnjPTv2mFIkYT/rrWCgQbzjthdzlpJwKPGxyaUJVDntketkefs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YewftKdo; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YewftKdo"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-46e704b11afso2395085e9.2
        for <ocfs2-devel@lists.linux.dev>; Sat, 11 Oct 2025 05:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760185676; x=1760790476; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ua7lmyd27eInt35pO6SDJb7mOB6WFfFMRzMLdmFDywU=;
        b=YewftKdoGFWl7M7UbD/LeUkSoNVgpKZqrK8zz0ToGpsxEfse+Y7AhN/taAozzl1482
         2cug+Xt95DtMG4NusEq4lvV/4bfmFxB8Zq4g4BU3E5nxU0QCZnoYPtupc/4zcNcGPBHT
         cjlGehuIQLkEyScavScEmoOCDCLkfJ8zDf+1GgVKfQU+R+4vLoiMpEMPJNFhR3YuNH9R
         d6UaqXi93Ra/s+Rbtuca+rKDFOT5B7TFpi4yH3LFZwBvWIjk824+/RiNXOdR1QD4jJYw
         Rrk9f0wLysCqtrDBna+DWXh1iMumARAfdBgkJR3YClHUE+7CnYsZpLdaXdiUGeeF8z2N
         SGbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760185676; x=1760790476;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ua7lmyd27eInt35pO6SDJb7mOB6WFfFMRzMLdmFDywU=;
        b=W8ywShkiZVW99y6lwTPXzr0O9sPS9plV42A1nxEgDH1PijeoZ4DrwzX6KS2pXbPiBg
         ubUq6KMT2+gCC7OhTftLXA7RLDmV9jFZCR0A4BcIsx3z4sf8zJ4Ojiy+XfBac7W24o4M
         Thhpl9qmXdy8QeWxtYjl5ERAOhGDhjaWsGXHP1mHg6Yh4KsUidaPUrPk5i7oqgfvfA5f
         15Gh0FEz2Bdl8ogER6NrUsCdf+RERSuHDlozNBiCtVLZtbLIi5dKa1OydtUDU5KvYmnH
         ggmhaENE9ylozA55gPnZfstBGZFfDn5wYKA8Zo5uTc1yLWpyiU124qvBRw8eMGI2bLAl
         Ln1w==
X-Gm-Message-State: AOJu0YxQ8SsimVjYDtfD+EvK9fiAAIHh81T0/KMi+e+iDOeuQWpTeO4P
	4Xq/9J1s2JAl57ASA8CP7pMpRIUYi95S8Li0nAerGQCXZ7GhU3odu/pGA3KRyxO79t0OysRTA7z
	7Lvoi
X-Gm-Gg: ASbGncujImkWGDpEIjBfHo5U4PH1h2RTQ/y7Pga8c6XBRC2/bdfDQx97brd8XkGPHw/
	YcyOYHie0zPGLhO+w21dh6CCLWljFl2j0MzFd/GYAs4YuIDYBH3wTsMtvzpcrQICQ+eOwurw4tl
	m20Y4EZgi8jBzUnivJ/Tq6wm7n87tv9aCLp9WokR48DGU//twoRZ77oS5tq1J5B+TyZHeOGI7o8
	moxQM+vgyZJSxfjTeZEF3ud6GAvryZKJbCBAg2RnLvTBZQt8Cr7TKo+f1Zl8ZX3LMoQxyTobCBc
	tA8t3NKrBDhUlSs7oemgYib4sGaeY9x+eww5Cv1qVdrrh+lz8m8lo1dz1xoFnECYC66UB/SDwzt
	pgQ97fq00pOFXnK8eKR5cghfK83j4mHy9H8c56Aly4Avl8FrqvcKNVB00kG8=
X-Google-Smtp-Source: AGHT+IEAdlg2Gh0gcg1uE0GMJdTUfQcPJt3WUFLJaaVI49VLpHYy7PNu8N1h46WTGsXqH8cxSdbBGg==
X-Received: by 2002:a05:6000:2401:b0:3f3:1be5:ecbf with SMTP id ffacd0b85a97d-4266e8e1e70mr5314151f8f.7.1760185675736;
        Sat, 11 Oct 2025 05:27:55 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034e1cc8bsm83288575ad.38.2025.10.11.05.27.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Oct 2025 05:27:55 -0700 (PDT)
Message-ID: <7eb9af90-9ed0-43ec-ba8c-fb78a57ea099@suse.com>
Date: Sat, 11 Oct 2025 20:27:50 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix stale extent map cache during COW operations
To: Deepanshu Kartikey <kartikey406@gmail.com>, joseph.qi@linux.alibaba.com,
 mark@fasheh.com, jlbec@evilplan.org
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 syzbot+6fdd8fa3380730a4b22c@syzkaller.appspotmail.com
References: <20251011083244.822985-1-kartikey406@gmail.com>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <20251011083244.822985-1-kartikey406@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Deepanshu,

Good catch! With following explanation, your patch looks good to me.

Thanks,
Heming

On 10/11/25 16:32, Deepanshu Kartikey wrote:
> Hi Heming,
> 
> Thank you for the detailed analysis and feedback.
> 
> After further investigation, I discovered that the ioctl call in the reproducer
> (0x40406f06) is NOT FITRIM as the syzbot comment suggested. Decoding the ioctl
> number shows:
>    - Type: 'o' (0x6f)
>    - Number: 6
>    - This is OCFS2_IOC_MOVE_EXT (defined in fs/ocfs2/ocfs2_ioctl.h:222)
> 
> So the actual call path in the reproducer is:
> 1. copy_file_range() - creates reflinked extent with flags=0x2
> 2. ioctl(OCFS2_IOC_MOVE_EXT) - calls ocfs2_move_extents() ->
>     __ocfs2_move_extents_range()
> 3. write() - triggers BUG_ON
> 
> Inside __ocfs2_move_extents_range(), the while loop:
>    - Calls ocfs2_get_clusters() which caches the extent with flags=0x2
>    - Then calls ocfs2_move_extent() -> __ocfs2_move_extent()
>    - __ocfs2_move_extent() at line 50 clears the refcount flag on disk:
>        replace_rec.e_flags = ext_flags & ~OCFS2_EXT_REFCOUNTED;
>    - But the extent cache is not invalidated
> 
> This is exactly what my v2 patch fixes by adding ocfs2_extent_map_trunc()
> after the move operation completes.
> 
> Thanks for your time!
> 
> Best regards,
> Deepanshu

