Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76A11B81B0
	for <ocfs2-devel@lists.linux.dev>; Wed, 21 Aug 2024 07:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724225842; cv=none; b=Jva+XH5pLZ2vUiZwCFMUdZogUdZ9qPTLiJPNtrxrRV2wuOswyn96PG8CJYE9gYVFoMNHhLmPKvMJzi63okuMIqpCa9TviBp4LURUNS7G2Rim7rphzJaTBW9VaAB8wHf0F38on409Mr4ZUxB36n/0uGQTFkZQ0u0N69BJ7ZqNF84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724225842; c=relaxed/simple;
	bh=JxeIMOH7tHkUbbP7UxL38C9nZ0hVrilR89mYIuejGhA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ORZRhGfX4FTdWena1O8QEA5u5MvnJIwLswMhghY6cp7Q4L+FGzta6lqDL9xN5E5zmfrL0jOkJLIFbbpQ7m+uTYr3Ym/ZEYKI82JiZR4fV4sQm2PGhQg0whCE0c9TCc4fHcv3u84XCiXkIAIiZlIB4TvxRegSgt8oiej8XCRJqyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=andqbkSn; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="andqbkSn"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4290075c7e1so715605e9.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 21 Aug 2024 00:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1724225839; x=1724830639; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lL7B6IjERhBSc0QSjdaMtUg31mh3lLJGucO+gpGJk6s=;
        b=andqbkSnvyvjJPgWyCbg9JhUy8bdfPnOuVfYOXC0Yd2zsXgzX6jeBvV4VlXgbeyuWS
         BnnT3ELD/LUZiRBD6G64rKRi2aFriCrIT4+Kn+m7QLU6uqCpXf3Q9iq+JgnS3DCwiwuO
         hsVgMNOPv48qABRYlJTGfRIZeGkUyPyxGihm8pAicDEAYTs8QMWAsoySvu8Yc0CPnZlt
         InhTbWA42aG8nsD3DQKJSFzB6i+LXrW1TDsEbce0ZkUseZKZbkAbhEzROVX76gO6r2d6
         ocRrbIE2WAbGokvG+wmwazaqWUOmudY/ipfq1r+G0e8SAtm0i2vFyceIGYVx5DKZizl8
         J2UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724225839; x=1724830639;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lL7B6IjERhBSc0QSjdaMtUg31mh3lLJGucO+gpGJk6s=;
        b=C0rerz0STquPEF2T+CZwgN3xqChjHFk0Ej+cyt88f27TkTH/hPhx4RFzz5e6xeScZI
         x0aEvYLSHLONXCTJjDEW5b0L8fRVevaTlsbqBy8hOHq7iohLMwyuJh/269M8V0VRBbit
         1/RAhweI6CcL3mchfhmUOVc6iqwK0ToaQDV4I5c8sVb4e24Cs/VLsxd3gXlC+rVyyM/i
         z8dY6gVrFcanKdzWF04HioNy3S8Da91jHlhEGmhDROkPQH7nEbYWEKVcz5G294UeUY4j
         3dC+3cQN6QNkoYstVwLxJ1b8IzU5WqJQdxZm+3Kq7tApgjzduphmsYKWsKXpMXYrSfke
         Ds2g==
X-Forwarded-Encrypted: i=1; AJvYcCVDysU2kB4SmNmR/E75XiSHRQtW84aVigGDWm0KA0HrKMD5RF9TqUatWtSJluDnppgttoHlgSckRB1fuA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwnjcgKWEbZrp7Z2FdQN0NRzr+ON4ADfe9yVqfZX9XTDNPD80ML
	WLST7Fsvm1YXsNitT3RaUOxncFlZCDcadZsOXaC0NE2bhCPNcDyJKpydLecGfvs=
X-Google-Smtp-Source: AGHT+IG43W+r2EfrrKQ35MWuJIlDTBeKYES1yVcjwENM5hwanqQ1S/tnZbm2TleEW9AHkY3K/2H23Q==
X-Received: by 2002:a5d:59a9:0:b0:368:aa2:2b4f with SMTP id ffacd0b85a97d-372fd5753e5mr482295f8f.2.1724225838688;
        Wed, 21 Aug 2024 00:37:18 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f02fa4e0sm88132775ad.7.2024.08.21.00.37.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Aug 2024 00:37:18 -0700 (PDT)
Message-ID: <9e4daf9b-a8f6-4d95-8e4b-125ef7b03911@suse.com>
Date: Wed, 21 Aug 2024 15:37:14 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 2/2] ocfs2: Fix possible null-ptr-deref in
 ocfs2_set_buffer_uptodate
To: Lizhi Xu <lizhi.xu@windriver.com>, joseph.qi@linux.alibaba.com
Cc: jlbec@evilplan.org, linux-kernel@vger.kernel.org, mark@fasheh.com,
 ocfs2-devel@lists.linux.dev,
 syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com
References: <0dd1d1b4-5e83-449e-af48-3811abd2e6a4@suse.com>
 <20240821065517.3844044-1-lizhi.xu@windriver.com>
Content-Language: en-US
From: "heming.zhao@suse.com" <heming.zhao@suse.com>
In-Reply-To: <20240821065517.3844044-1-lizhi.xu@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 8/21/24 14:55, Lizhi Xu wrote:
> On Wed, 21 Aug 2024 14:23:08 +0800, Heming Zhao wrote:
>> Where is my "Reviewed-by" tag, and where is [patch 1/2]?
> Sorry about your "Reviewed-by" tag, I remove it, if you don't mind, you can
> add it by yourself.

Good answer!

This patch issue was found by me, and I also pointed out how to fix it, then take the time
to review your code. But in the end, you removed my "Reviewed-by" tag.

> 
> In my previous email, I explicitly stated that only this patch should
> be sent separately, as the first patch has already been reviewed by two
> reviewers. If the second patch is updated with the first patch, I
> personally think it is unnecessary.
> 
> [patch 1/2]: https://lore.kernel.org/all/20240820094512.2228159-1-lizhi.xu@windriver.com/
> 
> Lizhi

It looks like you don't have basis knowledge of how to send patches.

I will never reply to or review any of your mails/patches.
