Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C612D320B
	for <ocfs2-devel@lists.linux.dev>; Thu, 16 Oct 2025 11:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760615039; cv=none; b=K2Esz3WLCm+6KaL/ODUqZEe2zKKbpeOFtTP04Cx9DJwHOu/ySACmO8w1fBDuE50fR7U1saAisDGqRwpdciEu93KyinDtdBASyU6JnZ2mXltZPo5Qezi98ZpZBXhoJPV7UlWeEWz3Vwr+M4ZYPAHc04xJbV+CPimQBkPMiWyr0gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760615039; c=relaxed/simple;
	bh=tdCGfv+3+0whjitJtYJ3yJ+7clwQP1s2trw3Ge2m+kA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XcuethhH0OU5mdcWiql+efYFX5z963TRqwntWz2LfvkOfdBF3e8BWD/yn/D81I9UrYWL+ye1c/DNRXysvfVUPYocY0zvxap7dS9cWaOlVdXNM8hBDcgF54M7PjzKWDN1paG4pPmqmMPDGrc6b3w3H3Jw5OeCJ91XCpuuotAnbzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UJEgC0km; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UJEgC0km"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-46e38c21fafso1241665e9.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 16 Oct 2025 04:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760615035; x=1761219835; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vTCfXTF2w4yPFztwTlo0R42+J7ccRUGXgE561UvXbCQ=;
        b=UJEgC0kmWsRUHz1F9IddIL2izbWMJZh0YtzzRN+PQ8bOG4WIQSowKNG2D4IIHKIBC9
         H9kJ4dULoXUN8NJG60gVT+hMqNVleIIukeHRCO0ioDc6FiB0qBPfoGAsdwdeq+biccQ5
         15nt4S6o1HKAR/ctfgF6gPHkNLxpOi89QSFxYSoyQgWr5AikfcwFp0FQD5MSXyZq4EjA
         TUmvCyYyeKaCxBlkzQjsIGwkcNgkcQuai4pBT2nq/ehOr27GqoXVeyykSWpJ5MDIZ889
         hNyCXRFkGRoRK3Dk8RxuXz8fUgo5UsjBYa7dDY4tVwkmMKF+AFBS1uZwP1dSJDiOgxql
         izOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760615035; x=1761219835;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vTCfXTF2w4yPFztwTlo0R42+J7ccRUGXgE561UvXbCQ=;
        b=bfszb7QjVROQzOhHtteR/9TujjCQMapThqC+I3eQEJejw8s7TpUqIomdm18yIGFDWe
         Z7f52oIx/82zQAqsmZ5udQlM6uJPCVg9Fnz3Blml9sNYqPSlkXMpbovkUp3eymLKNDkU
         AP6M/I0dk+SdMhkn7fSsbwUHLnSVw4dHVrskMzdTsb4UuY7PWxPglFJdZBBitCANF6O0
         yrH26qJ7vHebO8taDDiaoiWTlo7b9z2sL1jDJaLDqv5lTVEX7jIF+woUZmkGxhPGCH0e
         eM/QCK/tKnK3SDgjHN5fUFC3uqGvBxULu2Y9AVSMLl8RVAAtwM3uRdS7iUm4jjPkPhYa
         Z7Sw==
X-Gm-Message-State: AOJu0Yyc6Nor8nDcgJWTBrMXllEqtynA+Vc3ODP8Eb6p+arTnFBws8hO
	AuPG2HCTIOgZ+/OdClextvDfLN7/KCtEZ3zdOSXzZXjT1S9de3xDV0AnZUWyv5eohPo=
X-Gm-Gg: ASbGnctKOgV8AS8f1uoZu9JcTM9RIH6HCZONoBUhEuTKx72vQrk+BTbZTDkz0987KJS
	Z7KW9u33m1VdZkeBiTIH+cvqUPf9SkgUC+lFKM3vN00VJ4QVnUNaL6gpsOs0chFiENhqMNvEXxS
	c/7TX05l2jraic+clD6n/gqKd880GXzEUfZVbwcGp93xMa3Gsk+CF0IPC/ruJf1UivTX4u9pSU2
	6AzmsK3pYTac/LjmvPL5Qk86NsIMj+Pyp3IH6GAE+51g8gux8RvFdksSuTHTnloG1iMZm/8STan
	yzfe59qvdcHIuSrec9lttZkiMBr/MH9mLgQ/i4h46izr7uH+hSi5XxjiX5Eytv2QVCuAQmv+DFT
	Z7sYffc2E+0aAogF1A6mBRBI71q+4GgpjqnxGHWZ781G4b6xQvWl3BxTJ8RcQ0B0j0zCkm7BjRD
	krrv1DnCOMk3lPL1vkfg==
X-Google-Smtp-Source: AGHT+IFL/uYHLZGLoKXiawRJ5SODFfoQqaWkPNtVCO0sPjEhSwUD2oyalEdMn5yDO4ywl8R5VWfroA==
X-Received: by 2002:a05:600c:470d:b0:45f:2c33:2731 with SMTP id 5b1f17b1804b1-470fc9efdc7mr28397055e9.2.1760615034851;
        Thu, 16 Oct 2025 04:43:54 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29099386fdasm27853675ad.46.2025.10.16.04.43.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 04:43:54 -0700 (PDT)
Message-ID: <4faa0302-0639-4dfc-8406-dee9a65cfc47@suse.com>
Date: Thu, 16 Oct 2025 19:43:50 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: add directory size check to
 ocfs2_find_dir_space_id()
To: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+ded9116588a7b73c34bc@syzkaller.appspotmail.com
References: <20251013103709.146001-1-dmantipov@yandex.ru>
 <b3a5af0b-6b83-4a2c-bd91-b0d43c6946ba@suse.com>
 <62ba08fe-8626-47c0-a3b2-0c63af1ac6c1@yandex.ru>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <62ba08fe-8626-47c0-a3b2-0c63af1ac6c1@yandex.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/25 17:00, Dmitry Antipov wrote:
> On 10/16/25 5:54 AM, Heming Zhao wrote:
> 
>> I can't imagine how the last_de is NULL here.
>> Would you give more details for this patch?
> 
> This happens on a corrupted filesystem where 'i_size_read(dir)' returns
> zero. In such a case, 'while (de_buf < limit)' loop makes no iterations
> and so 'last_de' is NULL.
> 
> In general, OCFS2 is too trustful against the data comes from the block
> layer ('struct buffer_head' etc.), which makes it an easy target for
> syzkaller (which is capable to create very weird filesystem images).
> 
> Dmitry
> 

Thanks for the explanation, I will provide my comments later.

- Heming
