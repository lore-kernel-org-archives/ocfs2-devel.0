Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3621384A8
	for <ocfs2-devel@lists.linux.dev>; Wed, 27 Mar 2024 12:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711544391; cv=none; b=sQ394vuBhgf+KEHVOiLL/ZW0MTG+g8R6UHFO0vwHgebNqHKVImfoyP5Mqh7bYH4RGnIfOnze/cUIlnjB3HOEd+G1CV9vQz7rkWHG4Eiq0eJPxdT8b1YFwzDSg6OLaE1+Pqi0PJFCpn/lJTURo0Od5yEST/Kt1D0OL9Ff8fPpcGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711544391; c=relaxed/simple;
	bh=OoLZVUbyxaGrrnORRLvuL8VzwG/wV2iAGcZik9sHs00=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AZ7i0Xw//vcyVuBL/KpnasHekuBfjuWbyieD+HJhPdkfF9gtDPGUVUN6SL8QF1GcGfysB/GBmIc6tOwpFmjZB3Q5kU7DhacSsadW61IBvdtOsmpGDizzeWsM84l6uYeDAxTI+Oq43CLK7lXF9OesjOcMTcC0kun07cneAujkxKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dLUVcuWG; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dLUVcuWG"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2d23114b19dso97972871fa.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 27 Mar 2024 05:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711544387; x=1712149187; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cqfbyoCXyofy1iOjIUKt0RKicUXzZMRjgxI5lcdSmvw=;
        b=dLUVcuWGTDO2TVvl9sW+NnTTp14Fn2A7M8KbAqwPnL0/aJu4fs4296XTRMCkQcCo6N
         up6eynusE1PevGWhfHBwycsiuog7inxwhVLuu6BQ8aLAN99Ah52CoI3h6MvYCqJOKA97
         h6AwYb52UN5ZYOcYvwEtkQRQELBL+hZdznzNH1SLE+og6zzXdDHZP8QE43dkrJU9ZQgo
         JlYZFwq2819g9aghUnAygndeITGsWmuh8lZjwQnkEH1VEvkKFPx5M1o61mG/uCIyqeeP
         GFWfn97ijPWmRAVDnTraFAWtSYP6EwQOsX8FTYmWP3LYTdB7i0KvTryyhFogH+8NEt3i
         qv2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711544387; x=1712149187;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cqfbyoCXyofy1iOjIUKt0RKicUXzZMRjgxI5lcdSmvw=;
        b=SFr8W7xcba9sbpS+XKUbVqhD8n0Coj4uCIF2nGr+78Rb3UK6G7k2q9B5DgdAGOMdkZ
         7wO9ro8fNFsN0NoUhlxBhV3w4eEk0PnRYLqCUzbiQX7cypz7q8uK2b3LpyUmDLmndHSd
         pJB2qEC9yfR97y+ASkn9P606g3dLQFo75/5darFRNkxTMhHoIeJQlC57Q1meTLLKaUMa
         i3azWES3DTGgUzEwQ67RQGGyPZnlrz8pw8mzIfIaVIKLxxYS/7ECIqLEYNlIghwhJ/a6
         6mkzqV1JoxoNGBV6BKuvqCqpw5/HVV8I2CYGZO/GFxEIU5Oa1h+VNRhWWpJ46Gda0ShZ
         IHHA==
X-Gm-Message-State: AOJu0YwcMqCJYdCa/n3fDRFgyAeJTW62IJiTYxPIrjEnM34XW7098I3u
	edGydQiYufh8xwoTwwicNMxzfp0LiZiQYsebiYYPMMI6SsJjjBaNdHuR70eO3AE=
X-Google-Smtp-Source: AGHT+IFgzSOEScuAUP0e8iXSjgyXhdHUZheLdBZtt1ExJLGbKqnxSPW4KUOWUnUF7vNLHG0VDYzG/A==
X-Received: by 2002:a05:651c:1502:b0:2d2:c8ff:d2b6 with SMTP id e2-20020a05651c150200b002d2c8ffd2b6mr5250738ljf.1.1711544386932;
        Wed, 27 Mar 2024 05:59:46 -0700 (PDT)
Received: from [10.202.0.23] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id y12-20020a170902864c00b001e0f5034e95sm3410362plt.288.2024.03.27.05.59.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Mar 2024 05:59:46 -0700 (PDT)
Message-ID: <f8488499-341d-437a-a28a-799d994d1460@suse.com>
Date: Wed, 27 Mar 2024 20:59:45 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] ocfs2: speed up chain-list searching
Content-Language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, ailiop@suse.com
References: <20240327082146.6258-1-heming.zhao@suse.com>
 <20240327082146.6258-4-heming.zhao@suse.com>
 <d9ab276e-5d68-4759-8d15-3a94bd9ff4ab@linux.alibaba.com>
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <d9ab276e-5d68-4759-8d15-3a94bd9ff4ab@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/24 19:17, Joseph Qi wrote:
> 
> 
> On 3/27/24 4:21 PM, Heming Zhao wrote:
>> ocfs2_claim_suballoc_bits():
>> - Add short-circuit code to speed up searching
>>
>> ocfs2_local_alloc_new_window():
>> - remove 1 sparse warning
>> ```
>> fs/ocfs2/localalloc.c:1224:41: warning: incorrect type in argument 1 (different base types)
>> fs/ocfs2/localalloc.c:1224:41:    expected unsigned long long val1
>> fs/ocfs2/localalloc.c:1224:41:    got restricted __le32 [usertype] la_bm_off
>> ```
> 
> Could you please split the sparse warning into a separate patch?
> For 'la_bm_off', it seems that other place may also has similar warning,
> e.g. ocfs2_load_local_alloc().
> 
> Joseph

No problem.

-Heming

