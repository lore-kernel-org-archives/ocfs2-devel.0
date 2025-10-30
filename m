Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9B13595B
	for <ocfs2-devel@lists.linux.dev>; Thu, 30 Oct 2025 11:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761822306; cv=none; b=BEvlCcxQJU1M8Qd80om2e+IEHOGFoXpZAP+r5SOyEmfMQIk1mfP4ZFBBhRsNeUwA49SyNGR1h94Qf/OKAihL3jwY8dSZkaLx+gx0CXTF2JwbxSWx2YEReiq3PHL8N4jILTKAzV7dCQJf7QpOBCLTWPwUHdvn3sMugA/ygFmCzZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761822306; c=relaxed/simple;
	bh=mR0Md22AkfSetonbCNiACgcGe7ratHVxtXSz37ihgS0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GgEvmcCI+X1b9mBVMyQcaxyatQeMgtQdUuO0Mvvx6m/5GTRkdE31oxvlE0AyOhOEb1PFE+rFLHoKSwe6jcsnfDXVDnSNHAJSUedLQTsY/r6W7Cm3em8MS2uGcmPMxgQceqpC8nXjKIUYYWzsKpibk8038pEGzE5poZ47B7hPvAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZoHqUK2e; arc=none smtp.client-ip=74.125.224.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZoHqUK2e"
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-63e35e48a27so1011467d50.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 30 Oct 2025 04:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761822304; x=1762427104; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yGdhx3Ml2+3imAeyVSKMzY5bBY7Ad7CiEF+v65sdE2s=;
        b=ZoHqUK2eURLZPErr3air1UzTk5yy5snBTvUWsvSQtclLnXolTDbfUBtdiY0aggExnH
         QAb3H82AvbmbszvY4dZsdGT0wJHzapJdBst5TRz2G3RibjD8pSOLVWLRC/lX3uUiX734
         1R9tLo6OE4+Ik2gKgNGDQCiAPsrt2O1Y7Cq+FqvWZu1kfHmR45iq5AnjyG61Kus8Z+7T
         i6amRMFv5cXuM0w6gVtGQPRTQwhSm2pVo/rD75WlYWMO40v0jF6DJJ7i5DWbBbRZf73h
         xSjtQlX1WsXT0fqmI9tMeH0xHJQTj68zdGCKqtZWyUs0NquHMqkotYjUcAaTsDBACTyE
         84Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761822304; x=1762427104;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yGdhx3Ml2+3imAeyVSKMzY5bBY7Ad7CiEF+v65sdE2s=;
        b=f9DWgORnKT0mMKaurLM77Je/9jZvuat/VVjJfeQcJihm8wXmBgpRRinj1M7vYm9iQL
         wh4kgGKbCc4xzCKQS5P6H5fcxYBwTiyt7knj7QdlAMWPJ191AejRKUROooGCz2iQBH+8
         sIrQQYcDeyM3k3OrIySi/mTrLqokOR90g3AoE5F4JFFT6aVaoArcADntj3CO9cfg2qxG
         auuhmr7Hljvyn087hSLG0KIKHhBCsEXmTveBnnnQnTVZG5AwwJKNWZJjqh2U3MIsfyvW
         Z7PxxciHcyKbBlhuem34wa4Jx23PxgRPSwIv3bAy3YW+HunRX64yxPPELWA5OK9AkP3J
         5Shw==
X-Forwarded-Encrypted: i=1; AJvYcCX0bllrNnDDaJfxFEn4IokpNVwXaUSCQYKEcy4IWpUuRuJ030Q5TgqS6fmnuj4yKGnLsLeQBnjUKo1d5Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YxFs+91JVnUmd1k6ahBQQ2z1lLdvmFf5nIyz7BSVgQbzffnzlWg
	i0jyI1wPAl1zIh1qKQ5wT9ah0ODWicDTfoU0+bwn7gB47Y3PUBXXKZWFLN2xseyfSvLyIBUoR58
	mskxtzCtntN21zOniORzOrALi+odAGDc=
X-Gm-Gg: ASbGncsgPoAUkzW1pCxSB4COXipFjXv6sStIQGs9F5ZT9HDti7bYdGKOlw2GKAI3PwO
	oAe1Q6dD4CQ7SCy3v93vyBD7eke/T4PHMWKKeYfZIciW4AE0AC6e/i3o2dFAJSepaKenZEF7X+J
	c3zxyWwHKWp+u6ulVL1fXrmhJ9dQaWWVJKHxB09sFz9UybsKAzU6XKjds0SMzvY2KWPRF8R74ax
	y3anYU8yv/8S9eBEKnARNfi5j0cX/l/a/6In46rCNkCIBjn0tOjOZ9vj/xwLl43xcuPWGGPVO+9
	PRqIfx+bhPA0j3HMdyUyKDlTvw==
X-Google-Smtp-Source: AGHT+IEFs8ig1J/CuPR6Ez6LQ34aRMVObm/bsZJUt1vGfV1XHUEh7fTJgKzlW2lZlLMN6PGnuwj9GsobiLgtYQ4z0As=
X-Received: by 2002:a05:690e:d49:b0:63f:7617:e338 with SMTP id
 956f58d0204a3-63f838e7568mr1543160d50.53.1761822304235; Thu, 30 Oct 2025
 04:05:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251029055338.1192000-2-dmantipov@yandex.ru> <632f9f46-785d-4da9-a422-546fe3d91af3@linux.alibaba.com>
 <523f1272-8bf8-41d4-afb1-36a7ceb11494@yandex.ru> <ruygrlyh5vq5tbcsolpgyxgs6r36yiyph4rzgoti4txq5d6xky@k2q2smssjekq>
 <CADhLXY6rVF8+gVCT3=SjRXB3EerBT3yC8qsk25VU+tjVRkWrcQ@mail.gmail.com>
 <eeee7189-c9ed-4c80-8312-d4d15e0260e4@linux.alibaba.com> <CADhLXY5TPHyVkgB3f9ZNzWUursXcOByEAEch7w4GpqP6CTzv6g@mail.gmail.com>
 <CADhLXY5zFHjm81iU5Jkv2iVYuUNg_18rYqVUmZ+-V=v=P6KjFQ@mail.gmail.com>
 <eba45ee8-1268-4c55-bfa1-c690b28c2e21@linux.alibaba.com> <CADhLXY5QK3vDcXhuW-xq5Bd72uPCVA1MeTnxn_991irOmvhRCg@mail.gmail.com>
 <x4g7symjachxmkyhjqx5x2dfdn4ybvfkbzjvqiso7qbtxdgov7@2xds57btyzt2>
 <f2323939-4939-439c-8fc3-773c60cc25e6@yandex.ru> <a5f617da-ab4a-414b-ba2b-a6f126708620@linux.alibaba.com>
In-Reply-To: <a5f617da-ab4a-414b-ba2b-a6f126708620@linux.alibaba.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Thu, 30 Oct 2025 16:34:52 +0530
X-Gm-Features: AWmQ_bk9WBvZ21byIc30y1PqJeef0zmNl5m66Whdh32QhMFvb49Z6PwbxnsYr9g
Message-ID: <CADhLXY6Ad6aRDENjraG6ZGnKZ_7yYw-ZDtb4MGbhhbFYOadmkg@mail.gmail.com>
Subject: Re: [PATCH 2/2] ocfs2: validate cl_bpc in allocator inodes to prevent divide-by-zero
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Dmitry Antipov <dmantipov@yandex.ru>, Heming Zhao <heming.zhao@suse.com>, 
	akpm <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev, 
	lvc-project@linuxtesting.org, 
	syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

Hi Joseph,

Thank you for the solution! I'll implement the validation as you suggested:

  if (OCFS2_SB(sb)->bitmap_blkno &&
      (OCFS2_SB(sb)->bitmap_blkno != le64_to_cpu(di->i_blkno)) &&
      (le16_to_cpu(cl->cl_bpc) != expected_bpc))

This elegantly handles:
1. Early initialization (when bitmap_blkno is not yet set)
2. Skipping validation for global_bitmap (which uses cl_bpc=1 by design)
3. Validating all other chain allocators

I'll test this with all block sizes (512, 1024, 2048, 4096) and verify
they all mount successfully.

Dmitry, should I send v4 as a standalone patch, or would you prefer to
integrate this fix into your combined series?

Thanks,
Deepanshu
