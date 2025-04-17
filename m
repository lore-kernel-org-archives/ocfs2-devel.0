Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE6A19ABC6
	for <ocfs2-devel@lists.linux.dev>; Thu, 17 Apr 2025 05:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744866349; cv=none; b=lh7fiIPZLDP8H8lw+Gu7OqExwn2KXTcUBEEvS2wZaky7pNW9RnlE4RIP7O0LLcVnvI5UI2Ys5xQtJxEhwcGIVScqyVTOb2vyrkD7BwSxxGhRt8OJacz/gS9tndTR6yKezNNhH4tMLbPtA4Zhafzo0hFA1Kddi1E1SvJHP2Ekk7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744866349; c=relaxed/simple;
	bh=GJLzL4W7tGH3HdN0Q5I+YGoEl8Jci+/Z5ADXQz/c/YY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=L3vbSFB/UySq5+jNf3HDExZrAUJVN33iyfWoxZ4Kz5EwPalFAHyFmOaLQ5PFpMLRdTkvkYslczLiiw3jQHDxvVqZ3z6daeAe622F4EP6q4GA4TsabFb/QnyqleIrAEjwN4XaziXC+KsogdC6G8cx+1nye6AiWHgfAHj4bZNMDN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Fiw+tWa1; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Fiw+tWa1"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-39d73b97500so45443f8f.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 16 Apr 2025 22:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1744866345; x=1745471145; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eqgFD33s9tERk+XOzZm6KcVao6q/j/zXR+/Lp4rdROg=;
        b=Fiw+tWa1NbKTxcxzZPvFvK6rqKYxf6CTB7mJRqCd3faGeyHu8UsHFclIj96NM9y6E3
         8vLRpV8LbdIUmHXpiA9hd2A5+FQmKpjVwONJ1SL9A/4yKZJ+9UFlOuFrH0F98+a3NZoz
         TO8btXRoqpNJI4xDSNTfNmEv5tS9TiIpa/F/FPTj6IGpRyUu2b8INlYOkr/Fzr8Ddd/k
         V95BoCNGADjyErqJ2roIXNBFt6OknO0Hdewnhkk92WYqxzDYV0BcwbAuGfPALMaocKRS
         6kEcxokcRemeL+RAg2PGVoq57QPlNNpziQL2LWgPAl2rn3XpfRd6kyyzdmilfL7KyyFz
         6CiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744866345; x=1745471145;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eqgFD33s9tERk+XOzZm6KcVao6q/j/zXR+/Lp4rdROg=;
        b=lnCdSpiO4spXzaw4pU4axN5MSxffYRAWhc/lHhhRfmfb2koS1xM1hjCKuwHhsNxfEi
         9PrZEiOVGX2uvVco6Zph2Y4r796I8JqEtlWoI3ly517WZDhuP9JqzAT7eaKXRRsYpr85
         yBoLMivGJEN0/WGEfgojrLKK6iBWJbVe8sPOru/L2dhhUth1I62rxxItAgchzh3snJDn
         qBtZmYC3MQUgcaqoNbVA65fmJLRdPfAA4/O3cBV4h3t7yVWIV1hLaK4EIdPvePcv7JQi
         ENNPLpBdYEHYtkgEp7sW6+rSTQcjYodNOMPFRva5WgeO6uj1BIBRy8uNdrC9WQzOvHs2
         IUDg==
X-Forwarded-Encrypted: i=1; AJvYcCW3li9VBDxhxtZb60zTtB/GeZqt+2dQp84IisGBrnkrWKYcrU9VMARV7NU+8PfnqkCIDecba7ZaqRTidQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyFL4h9mCeFN/FGWsTq+5CLSWO//SeTgFrUjxxPN0peZJsZJgjt
	5H5ioCsFIhr2PlpspvGKbboPgF3OWiffUtynw0uzWQkeiLp+XREJKXG/+cjoP6M=
X-Gm-Gg: ASbGncswgy6qqeSSknmXHfM4psVaHZH9Ac51iwF3WI+8hk9YDp2/w3ENOhPzPR5ldZQ
	zWpUdpDPa2G4SvScXRCABFCr8BBtp49J6zft/nRQDpdv+kxrE6RbBLlefnquH8/3jJBZicid/TC
	rLX6YH4/Kn7kUsSLTIionasGS6/B9IDYrJmWLECi3E57vGU4sZRRiDVDXMuNnNku6gsJfnn4jzx
	+4e4tv+hHLE0AAWHkgiWPDZJcHA7J7D9Z8v9w3+l/cyy3Pw1rwb9Thdx6OQPRdKDKEZJCtWMAy8
	MG18g7IyJ9FwH/g+riGn8SU61X1yYdTBLYp2zjlOtl28wyU=
X-Google-Smtp-Source: AGHT+IEIW9jNhRjthZn/BEslNneJQaLVBe+fgLEIl/mEON7+W3b64NCMmO3cDGrOFfpRmmABz1KKgg==
X-Received: by 2002:a5d:5c84:0:b0:39a:c6c4:f855 with SMTP id ffacd0b85a97d-39ee5addad3mr1286873f8f.0.1744866345044;
        Wed, 16 Apr 2025 22:05:45 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30861212fa6sm2650958a91.27.2025.04.16.22.05.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Apr 2025 22:05:44 -0700 (PDT)
Message-ID: <e426eaa2-3c17-42d6-906f-c41443ac48d3@suse.com>
Date: Thu, 17 Apr 2025 13:05:40 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [ocfs2?] possible deadlock in
 ocfs2_finish_quota_recovery
To: syzbot <syzbot+f59a1ae7b7227c859b8f@syzkaller.appspotmail.com>,
 jack@suse.cz, joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org,
 m.masimov@mt-integration.ru, ocfs2-devel@lists.linux.dev,
 syzkaller-bugs@googlegroups.com
References: <680081ae.050a0220.d9ef5.0003.GAE@google.com>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <680081ae.050a0220.d9ef5.0003.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/17/25 12:21, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> unregister_netdevice: waiting for DEV to become free
> 
> unregister_netdevice: waiting for batadv0 to become free. Usage count = 3

This is another module's issue, and the deadlock issue disappeared.

- Heming
> 
> 
> Tested on:
> 
> commit:         11376431 ocfs2: Stop quota recovery before disabling q..
> git tree:       https://github.com/zhaohem/linux jans_ocfs2
> console output: https://syzkaller.appspot.com/x/log.txt?x=14183a3f980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=5348e7fd1b89a770
> dashboard link: https://syzkaller.appspot.com/bug?extid=f59a1ae7b7227c859b8f
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> 
> Note: no patches were applied.

