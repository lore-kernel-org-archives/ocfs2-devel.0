Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225A22264D5
	for <ocfs2-devel@lists.linux.dev>; Wed, 29 Oct 2025 06:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761719194; cv=none; b=p+YIVgi3PryqubBVdyii2tzKUV5D4U7VwrwfRZTd30CxHmel96/tdI2MByAmYiA1oUj1vN4fNVQmY/8L5yni3GvWX8oziQ/id0Hqo0gA6e+hszb3UOBqtfFXyCjMgi5NjcQIEl8W+UWyc5fRVg11r8gT24Q45qqsDmRp1iczLME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761719194; c=relaxed/simple;
	bh=NhtgJ4hpH0NlSvrusEx8JKVl/ABVPRZwnP/6fBxJBU8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oEELlWAwPAyDvVZ9nCZY7DTVyOv7QILezL3RObaWs6mrkp18q+mwJh0Pf6yz5CgTQzr8/JYjKX6d4ZcPLCvJ/hCyfjfAHeTvj5AVIj15jMsaxTDaARB5dQC/aCdmQLTUVs6lUQF/DCUgUeO9hG8R6vK5i/i0JeYEDKPlOfnaH/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e6HFT2EU; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e6HFT2EU"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-784966ad073so86868467b3.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 28 Oct 2025 23:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761719192; x=1762323992; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QDF5Imk0wQgp4Kj5CR5fnsrS5T7uQ8SxpT67VhH9w/o=;
        b=e6HFT2EUQgfNDjpyG0kuSJdFuIifwuIl/Hwvi88bh7ZsTIwsvnK0lGU0vO8DGKEJeq
         O5hpjyo0wXg4zdM+HUtuUPBRzZsLRPR2UeCAtx/xM1uVwfXqLmhL6AkVo3gk0m5PJzdF
         Z/1CuPw96f0hX3jUyGB9iwle1alWnUrLBzTZN12Z0RMFlOm3iRBrJnrKXluELJ6zpXEY
         O9nTNnkvHI4W1+qkbd2+1K/COV5BmsVLKhWVDahB/TnyAEf8d1ST7KBoh4AcdgmrGlF+
         YsOs5pUyxkZ4iV/yHnvUtNWCNeNxw59lZS3y1AQG9JWmd/esMyS20hA91kilysKOxqKa
         C0TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761719192; x=1762323992;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QDF5Imk0wQgp4Kj5CR5fnsrS5T7uQ8SxpT67VhH9w/o=;
        b=IBFXP58ztHMoyfdajGuLji2wBgaCKc0+HlL6620h7mtPS4hpt9J9Dzd4bUixDp3ynq
         r5lTgu9X5q293hLzcfMop+PrKQQImfi+rsCdQyNt5595UYPAzcv90lpmdbg9whakQLNp
         /lr15UI6v1oVHloAmMDHis5hTqO3LgfXdUxP5zjrFAHfNrsUia285FDxtpnou3/fnE/V
         ztt8sHmk1xQkIG5pxuzULq34fi08rtscTL5GwKc///vjOyZADrRFWrs2BirEnoNVsyig
         hI9AxlxiTGASIV8AJlsrys3lwTbYNHm6+RemLUXk6lq46YKbyYE1tlwityWFUjY1/5j7
         uY4g==
X-Forwarded-Encrypted: i=1; AJvYcCV7j2/tt1h0gYNqwwqsUtm5FYHs94VYx2svDx4BeIvuC3H3qHcmxSjJDNpck6EyVmGivEzKX3tc+mz9/w==@lists.linux.dev
X-Gm-Message-State: AOJu0YyJ03UhpdB6svwugA0DJxcfbrAizOJt2GYEne0XsP0lza0vsPD5
	nxNULRSfsGkKUdQBpNTcXx9/Zi9MRgRRfLgX63UT94weac++q3eh7I7GbJaqZAC/Tgpx3MXZD1z
	srgjxtipLbcnICzLhUZuPDb33vuFB+c8=
X-Gm-Gg: ASbGncuVIrCKxSpKI78H3Q2SZTZTu/yjgpTjsZ9U2q9ZnQ6yU3s/uQNKzbPF2YdFxRC
	C4yG9GsyApUz+K+355G7n5tBD7ARi+OCUmEqapMYKfhP7u4wq+EBAA+RFQZxBC8MV4GUanzS7K/
	dU4soTShxt+tutKNJiDUIVie30dTR1JPwL6BE27dEz++2kc2bzEFUcwygRyThXI78Vlf8gIaQ3V
	HgT/F03i3QH3033dOavey6o+qEMR1GwB85jnqODOqyAb9OnJB0JibISk7Iw6+HIZGp/ZLDCnNmb
	pQKTbnnOZb64jFv+sg==
X-Google-Smtp-Source: AGHT+IGuER6xdb7kIgTZnYnKFAqkmSzlHxXNgqTbBTBhg9kQwL2OAFigNW3w5ec3cEi0LulJDAszj5Sp7dUAJEVRAEE=
X-Received: by 2002:a05:690c:6205:b0:783:68bd:4fbb with SMTP id
 00721157ae682-78628ea4e27mr16680947b3.31.1761719191848; Tue, 28 Oct 2025
 23:26:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <9461385f-235d-40fc-8da6-b1f2dfb47d6c@linux.alibaba.com>
 <20251029055338.1192000-1-dmantipov@yandex.ru> <20251029055338.1192000-2-dmantipov@yandex.ru>
In-Reply-To: <20251029055338.1192000-2-dmantipov@yandex.ru>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Wed, 29 Oct 2025 11:56:20 +0530
X-Gm-Features: AWmQ_blyv0Zv3Mjicsaq0DYDULkCgJ6fW-IHq43VpyQ0CNSuaFLPARYmh6W4isk
Message-ID: <CADhLXY5pOn-URoQs10X6R_WHFJG64AFOPNQaoHPbH_7r_8OG_A@mail.gmail.com>
Subject: Re: [PATCH 2/2] ocfs2: validate cl_bpc in allocator inodes to prevent divide-by-zero
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, Heming Zhao <heming.zhao@suse.com>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev, 
	lvc-project@linuxtesting.org, 
	syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

Hi Dmitry,

Thanks for combining the patches! The series looks good overall.  One
suggestion: Would it be possible to display both the corrupted and
expected values in the error message?
Like: "Invalid dinode %llu: bits per cluster %u, expected %u\n" . This
would help administrators understand what the correct value should be,
which is especially useful during fsck operations. Everything else
looks great!


Thanks,
Deepanshu
