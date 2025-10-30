Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9612932ABDB
	for <ocfs2-devel@lists.linux.dev>; Thu, 30 Oct 2025 02:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761792074; cv=none; b=ThiMRSS+z7KdIaAGRtHs4FNObNwreGFb49a3jcYdl+aFhZyTPRROkYNTc3d6795b9/enFg7Ak5ESnV1/GkkxxSxqfPRVKaOZj2xB1fMhlnYUb4xtzPjEoYdxhpINuzjcpuLZDVZV9b/D0yYdXe7ZRh3yQqq1WAUdyvN0h00+nug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761792074; c=relaxed/simple;
	bh=MpDW8Oxe3CWbhZtiJx8hmz5VpQRI/XbIq/8AdFwgohQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KIl2C0hhKsBbla2OphhugtzOjb7ARiiciW/Oqiewf4lWAsj8FZ9PojSQf5Hqx4Suo/L5hRkiKnQQyXU6F89wlFpku8FAzhNde7JnnRM+GOdgP2GFNuL5G0aw58HAr84e1WPqHEHrbzqjeVyZ/KlcB+SIhRH/WM0l8eBIq+L11HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AxJjgAYD; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AxJjgAYD"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-71d6014810fso7016937b3.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 29 Oct 2025 19:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761792069; x=1762396869; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MpDW8Oxe3CWbhZtiJx8hmz5VpQRI/XbIq/8AdFwgohQ=;
        b=AxJjgAYDpbNfYy42mz5OTxAfmTcgFBykRwYjht+QX224ThEiAQvANVxDTaBvRqs6Yr
         eVg5vVqJIgaP1AzLqLYHbyfT9IFqd6jrppnumewN63aN5SilwUobM7utfb/ixHRtO2SR
         WzQPRAm+vCbHY91dOer1uQDP2ERJIK4ZGJjhnm26t1Mtxluf1kp1gZzMb4BP7jct5c2z
         dxMl5SfX/TtsS18+f9AUvmwIFQEm/6/Nurimf46KqqSkgDS0smIQfz7G4c6NmbSTBvyb
         AnI0KCtyZ6U91KZsEapnz5dvLrihB3IQZ2Alyk/89ACrrROP7Mfkv7Zy85L1FPJNJg49
         /m5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761792069; x=1762396869;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MpDW8Oxe3CWbhZtiJx8hmz5VpQRI/XbIq/8AdFwgohQ=;
        b=CuRQLDa7IWVZ5pNRypL6csNEOP0Fi5CYIlVbcIrijN0IhD+MjTCy8/I21zWEYGPYe6
         OCwRfXKqAiOf0Wp6QsoxeCPjIWKOpTNJFz4n3QUIniyt+7KT2GtgknMNr8ij1qnOm19g
         XoyExqaqCWBcPAMbFBIB+6qAsgFSHDBmABlrKsMDkGtJi4EX2SKoO9nZ+kkAQuaS4jPf
         JSCVx7Ao2UK2VRV3ah03eag+JDm7s787CXUhlE91in4+lLby821S4kRFQLj5j0jvuyfs
         0As4U4F1AwDrcmeDZGs9IPIhjejToWevDVC+j37CB0meJEonP319OP9rBJlr+zZYrPIG
         x26A==
X-Forwarded-Encrypted: i=1; AJvYcCUT9xJ/NNrwO/CbG9XFqyzRPqGwcHnbbWeIavGidPbUlVcRjtKKGamOu8B1rnE6ekHE6erjvqK5eylwuA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwtXJd69lzrZlDxz85zAebiIsF9VyLOXtEo3NsaUsQtpWARHtI4
	KhOmqDxrPXcvh9ecNX9HST49rzFm6c51X6IdfY0xP5a/RgxffITCgJnMphKw6xSIZFJkbgtt/sK
	Hs6Cj1LidMS13+ybYBHBiwqB5FMPTyj4=
X-Gm-Gg: ASbGncuQkfSrN7XqFjmNXJiqZiAywKVeNTe0OHlkmOGnDTb8zJY+tBrP1bGH7Zvh8eg
	1Zjx9ebDg8N3f+QnV2uveMF88scX/A0/tmVb7rEU7Fe28/X6v9dXmvOLwNPz0yffB8CgRa3zOqz
	WKIo1gKpi9NNIItwj+YvEViFNlrZc/2Te+yyyOJK9iaUudcjqVYbovm5j7ZASX81TsRFmvNOW4q
	rO3TkrlQ+b7SjVIBBJ/jgQkkYTr8zqiJq9yO6KlfBT5aNV0wZhMk58LR4jNSnD4Lz7V77B/Ja7O
	lM/HCKUzetnqGdqU
X-Google-Smtp-Source: AGHT+IGGx441/DdjTFB+ByB+WktshEWpRk2jJDhrtOPbywNJJlRT3xqyI6+NQ4GPWyx2lLyIb4PdAivSs5upyS4Bvmc=
X-Received: by 2002:a05:690c:9b10:b0:782:d301:e1f2 with SMTP id
 00721157ae682-78628e10a57mr51160907b3.3.1761792068856; Wed, 29 Oct 2025
 19:41:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <9461385f-235d-40fc-8da6-b1f2dfb47d6c@linux.alibaba.com>
 <20251029055338.1192000-1-dmantipov@yandex.ru> <20251029055338.1192000-2-dmantipov@yandex.ru>
 <632f9f46-785d-4da9-a422-546fe3d91af3@linux.alibaba.com> <523f1272-8bf8-41d4-afb1-36a7ceb11494@yandex.ru>
 <ruygrlyh5vq5tbcsolpgyxgs6r36yiyph4rzgoti4txq5d6xky@k2q2smssjekq>
 <CADhLXY6rVF8+gVCT3=SjRXB3EerBT3yC8qsk25VU+tjVRkWrcQ@mail.gmail.com> <eeee7189-c9ed-4c80-8312-d4d15e0260e4@linux.alibaba.com>
In-Reply-To: <eeee7189-c9ed-4c80-8312-d4d15e0260e4@linux.alibaba.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Thu, 30 Oct 2025 08:10:57 +0530
X-Gm-Features: AWmQ_blyqKyVOKasszLCeoQrpMP5DinnGq59Q0MBBSq2y6S3tYB--XvsnCJkTeM
Message-ID: <CADhLXY5TPHyVkgB3f9ZNzWUursXcOByEAEch7w4GpqP6CTzv6g@mail.gmail.com>
Subject: Re: [PATCH 2/2] ocfs2: validate cl_bpc in allocator inodes to prevent divide-by-zero
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Heming Zhao <heming.zhao@suse.com>, Dmitry Antipov <dmantipov@yandex.ru>, 
	akpm <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev, 
	lvc-project@linuxtesting.org, 
	syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

Hi Joseph,

I am doing a detailed investigation. Will share the results shortly

Thanks

Deepanshu
