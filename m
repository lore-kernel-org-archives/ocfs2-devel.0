Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3EB6286D57
	for <ocfs2-devel@lists.linux.dev>; Tue, 28 Oct 2025 04:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761625324; cv=none; b=IyM4PWFxkD5SfHqw7Am7mcnA9asBr2kvQPZLVhekHIvn7V+xHoh7BMbq+spuByu71+CBRxS20s5e7Ph1V2lBtrH/emqnJC0FFPVb2XFxGgNShEnkcOBSq/Kwt90ki7fEhIUfhB8pBzYPRWEmjEu7PEv3cACBzTac1XFomz1HkDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761625324; c=relaxed/simple;
	bh=9+EoAbr01F6ROd3ypwDMT0beFvOipyIxdcEfFRsVw7M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uugJPbwqNDlJ+O5po3naWpP/LjmfzvdwNSoTu2Kegutc9BkHtHH4tGsmHOuY7UlRVAYgo3w5T9rw7XgD9ko2DrzduJARbtm96kRLF4FwgLH/2BOh2uLgpOWxKDiTZcYPW66ETl1bOf3CBKg3au1fsHhbTHjmjEQnK0xJtO+lZek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b7PohOPs; arc=none smtp.client-ip=74.125.224.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b7PohOPs"
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-63e255e9a20so5903153d50.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 27 Oct 2025 21:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761625321; x=1762230121; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9+EoAbr01F6ROd3ypwDMT0beFvOipyIxdcEfFRsVw7M=;
        b=b7PohOPsCPYgVqyRghSTRXzkqmRd82kkTrIwc5P5sENmeWTpU2Xov9c1InGrnhNC9L
         LROiC/fuU07crGNGUF5bEtlaprbrdA8tjm2wlysmuirMh8qAsu3H4wiXP/9l5e4PRq6a
         aMWBfbBjgUI8ar95WKBFUPaVhQrKWGrydgJPel3of5v2lm0NrSsWB7Tu1Amty56dsVyy
         M4G9S+I9jEGOJMjEjAviwsnv2azYdJtLvjnyLaOSFlii/tl7gGYRm7Kr/Arru3SCqWrw
         mbu0h4qr2s80QrkLsNrBo/AlnKvQutxminRBF8Ju3WW2j5tYuQyouONrA0qZ7YnjRHuc
         yaTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761625321; x=1762230121;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9+EoAbr01F6ROd3ypwDMT0beFvOipyIxdcEfFRsVw7M=;
        b=GpmcHgHCRvPhILnt4qMJFc52uyim9ua8Cs0Cr6zmk+ZUkKzWONArXpZ7OmJL5c+FX4
         QBLDHITmZhDgvL30gmz4kPhv8wKkwXgMLpkoC7KtY3HU0qcuXNyQGUG3nPLXlcQqDwD1
         0ijrZ0eVT4yzySsfycGu5QKQJdDPnurlrMV/csMMFL4L4q3UBak0VPBYBWEyF0JHChYU
         G87qeNFlgMn7ySSvVJJYxpbiIFZBpBWrldadhprhTIeIhc1zgKI/mpv5k0W2fb+bgeTw
         o/2OP+FXzYW5nlc6ANwai9APVj8ojp5GMsnNxnvxPNLjxekBu5XYlrZK/dT63r54Meav
         wPMA==
X-Forwarded-Encrypted: i=1; AJvYcCUWZ1/qnQlFL+zLilm1T8fv9NFb3Tx31aaw70ygfuPTiy7yD8Xn5lvWE5PRPwDwxq3O36iP+ldH2G+ymQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy2o8o7s/CZ8nvX4gedCLCUedXpr5beedmI8HgAiAc7Wt4mFvJ/
	vaGv2gA3WgE+o3NXySPqsWTzFf42eRmmNQ6/el0/iddRprmC1mjZ2JYz3oBVSlh+ojUFsuWgCRG
	rcva0QLcj4I+Sog7kwBajj+pWwaQJ30M=
X-Gm-Gg: ASbGnct3AigKWd/j3nsvuvOOtGRQjw3POIbeuin8N4lTmMtFKYbljlmi2+ngWjeyk+j
	JpwlncD0dvSF0jOJWZ4yGfqSGf/ZI/xcKdR1TYA79I/DhwC+5fDTahXwU/r9tavQZJdV5/zjzhS
	IDRcUESQoCJAv+mXYfGLi8Yz6aKfAtpfAJT2sGlpJ18Ju+oVZLY4yLKANB9T/TCYXEaE1ks117H
	bRBTyMGHW5KvIUUiIq2XUiLSmxDQjQm3+dNB+AAiNzHz7jz76e6MUM3tzT/KYhPaAmzrIjZXSLZ
	pV93gtZuqWEpa/5x
X-Google-Smtp-Source: AGHT+IGMTXOSH+1otoOmPpgppIzojzxMHCoPoNd3/E1I8BSrUGiO+jquir/tS1M6i1lmHcTBFrd98tiEcY1rENFzwIg=
X-Received: by 2002:a05:690e:160c:b0:63c:e837:5d89 with SMTP id
 956f58d0204a3-63f6ba4025cmr1640634d50.31.1761625321649; Mon, 27 Oct 2025
 21:22:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251027124131.10002-1-kartikey406@gmail.com> <ba3241ff-d2ef-478a-ae75-c670cd40015e@linux.alibaba.com>
In-Reply-To: <ba3241ff-d2ef-478a-ae75-c670cd40015e@linux.alibaba.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Tue, 28 Oct 2025 09:51:48 +0530
X-Gm-Features: AWmQ_bmV8z18noL75ZLv6WTQIQEKPBPgLzKcGX0FLlBP186fDheuTDAzSMrGNOI
Message-ID: <CADhLXY7iAWVD390=A2A=mjABi+rS0Da1HUb7DHXfPvg696gJeg@mail.gmail.com>
Subject: Re: [PATCH v2] ocfs2: validate cl_bpc in allocator inodes to prevent divide-by-zero
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

Hi Joseph,

Thank you for the review! I'll make those changes:
- Remove local osb variable and use OCFS2_SB(sb) directly
- Add blank line before rc = 0

I'll send v3 shortly.

Thanks,
Deepanshu
