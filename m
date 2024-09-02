Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4309D1388
	for <ocfs2-devel@lists.linux.dev>; Mon,  2 Sep 2024 01:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725239027; cv=none; b=FsiFa1N5b6AmBzLuY/6hw58Y+NFTUuIWOudSzrclDZNTeq83Zn7/GJ8T1Bc/eFgZgkn8HbYMoY+01Nf6A8cX6BZipLbmClQJ4sRK0QvQhO0HYut+u6ZJCdc+zt8F/mHo9o8HG2xyUhjtDSkqbiW25dxPQPOaTgIBFFozUF44Fmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725239027; c=relaxed/simple;
	bh=fsYVC+tRluVQCdwwY+bKcaaUnBiGi0rTwc3GN8Yg8Cg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=TgHmLvficI0c0MfiiTH6JoZu8CxhU9/9r6ofMras0JX+S2G3927u68KYlVdruXGR8rJDpCNCRnD92ihrYj8czBmdAOIv8NdtpDHTLM8w2tAA5b0tmkmAcjHqEZ2fVrE4sQg9cRCibYKWMST7voqxp7bM4KTvSj/1MAA+qZV8gEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KMjol/2d; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KMjol/2d"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-42c7bc972a5so1756255e9.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 01 Sep 2024 18:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725239024; x=1725843824; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mndv8DRB4gi1GjBSiLtZXqU5jiAp3af5moutOmXPzIE=;
        b=KMjol/2dmtSeCpXsbZpEsljOVLNjIc2q6QIDafbOtTznsLDS5pKdPM4aMgkqtmtF9A
         tt+yYDRZnjrr5g3H40Nw5zvOLUfkreswWJO/MHapDzpNQzTf2DOw79a1pmt13IfQWyOK
         2Y7e4srS5LcAYqyJzSMI6Ktw5QfbwW2chyY2gDQHPiErSRnQ/U7FjEtx6Zc8HlhS/3vI
         jl8o6C2U3wUD0RQoBtWMIgG/jmUou73CrLeBaUI/RAn5BofbuHZ66HXv5IXoc2mXFyud
         kRpgo3/UaFg6F4FWilKQKYy1i67ikzMjg0FHLFbd4WHZtf64Ye5abSKMmuZH3B9LlAsp
         bCWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725239024; x=1725843824;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mndv8DRB4gi1GjBSiLtZXqU5jiAp3af5moutOmXPzIE=;
        b=etD6fokFp4TAHFt4Icupiq+5/Bnp06eko8QOgKCTg337MIJB3HJv7032cSGgXfjD0i
         54NuFiOYbkcW1RTgaWHwCpsv0wvK40PBuoWEfAAwBasPTFzr+Fdv0+23BU0JPD2PZtjV
         KLU6NaHMPIDp1lHlXSjG/HhkMTz38WjmcQSB2B8370V8sHAEnrv4TJPOxV6LHg6g3XYF
         ZM6reN9FdYcIeMkhh1tOR/d6imN7BNS70aSYeTB1/TezaHPqs8tDYg+YL+s82U8wnp2G
         +Bq917IeYeU6Ro8h3MLLmu822wF4j9qT+rlvrIPcj5xFMy++oTeCGYzHnPTeGem8TnDN
         yEqg==
X-Forwarded-Encrypted: i=1; AJvYcCXhCu+xqrxtwCDfz15C/emJM2MyNA7KSRGtkbbzXsYkSTGKyLD3AopII0hhegORonD4ESY63Kw5MwrKog==@lists.linux.dev
X-Gm-Message-State: AOJu0YyTeR8Y1nFiGzMO1c8aSZ7CEv+jfT7DkylsbvtA+fKdR0A3Rzfx
	IEhko+VHehAEZ7snzmx2RK7nV4km6f2qlN158oVAhKJh0YAdBc/PfbcuOMloJZw=
X-Google-Smtp-Source: AGHT+IFLeyaCM6YzT5deLam+r6JrfsCR7XaQszIQ/J0VOEZvMDpwkzlj543XeMkf6pJ4Yxqjnf31qA==
X-Received: by 2002:a05:600c:4f4a:b0:426:6fc0:5910 with SMTP id 5b1f17b1804b1-42bbb10d61dmr35742415e9.1.1725239023016;
        Sun, 01 Sep 2024 18:03:43 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2056f4158b9sm10495865ad.120.2024.09.01.18.03.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Sep 2024 18:03:42 -0700 (PDT)
Message-ID: <b716d079-1725-4a89-8998-e0c88b8ea7c5@suse.com>
Date: Mon, 2 Sep 2024 09:03:37 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 2/2] ocfs2: Fix possible null-ptr-deref in
 ocfs2_set_buffer_uptodate
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>,
 Lizhi Xu <lizhi.xu@windriver.com>, joseph.qi@linux.alibaba.com,
 jlbec@evilplan.org, linux-kernel@vger.kernel.org, mark@fasheh.com,
 ocfs2-devel@lists.linux.dev,
 syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com
References: <1a063827-5cf3-42df-a690-f3c644c10996@linux.alibaba.com>
 <20240821091459.681136-1-lizhi.xu@windriver.com>
 <25f2be6c-3e9c-4484-a44e-d26e9c4c8a74@suse.com>
 <20240821143911.cec82fac50c08947523da2e6@linux-foundation.org>
 <20240901175402.816203db096c2e9e49d75363@linux-foundation.org>
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20240901175402.816203db096c2e9e49d75363@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/2/24 08:54, Andrew Morton wrote:
> On Wed, 21 Aug 2024 14:39:11 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> OK I think I found the correct patches - v3 of [1/2] and v4 of [2/2].
>>
>> For clarity can we please have a full resend of both patches?
>>
>> And let's please have a [0/n] cover letter which describes the problems
>> which are being addressed and which also briefly describes how they
>> were addressed.
>>
>> Also, it appears that both of these fixes should be backported into
>> -stable kernels.  So let's please try to identify when these bugs were
>> introduced and to add a suitable Fixes: to the individual changelogs.
>>
> 
> Again, can we please have a full resend of these two patches with the
> above issues addressed?  Particularly the identification of the Fixes:
> targets.
> 
> Thanks.

Hello Andrew & Joseph,

If Lizhi still doesn't respond by this Friday, I will send his latest patch set again.

-Heming
