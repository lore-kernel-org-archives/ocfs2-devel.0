Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7701430FC1E
	for <ocfs2-devel@lists.linux.dev>; Sat, 10 Jan 2026 05:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768023511; cv=none; b=A+avk+BGBJ49cZOCI+yYGfouuPkBZGhOA/uIw+uNVrB1QMqFqju+enEddAV6bBujf+3iMn9+Kj6Jp2E3jmpoLNd2ugS9nXY2k8xx/ZyQx8LyTJcIjFhVVcjGP20GtBF9sANayB2qzm6b7leHUHHNzar8b8sogUZFedVK4xtUB4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768023511; c=relaxed/simple;
	bh=lr91WETsQhvwGxA4YBFNGJu5pbkLgoMyM9mXGrzF/Ws=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ey3HsEv6r0YHU1kQbJ+OtQqpGK2e39E98B6KH0tae4/U+5I59+g8BDwH57GStdvvuOG5EIt7xcn8Nxys1PbBBIR1NA+K15yCjcWozzJL5Ba6PMHcRJX6LTI0A9sa9BU4Y/KaoggzwcKdmKh3g4HTfqf8d5i+cWapAOsQo5iMWww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YKobfdUF; arc=none smtp.client-ip=74.125.224.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YKobfdUF"
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-6447743ce90so5101018d50.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 09 Jan 2026 21:38:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768023509; x=1768628309; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lr91WETsQhvwGxA4YBFNGJu5pbkLgoMyM9mXGrzF/Ws=;
        b=YKobfdUF3NEdJPygIJCACRbknhWeAvt3LSDK1pI4SjIA6QW8k5+SftBvTAHz9r2FY9
         M1BvGpayJUCC84cXGZ02j/6F7LWtxEl8fQJrblFKtkHCMQQP0eCQr4tvHOWTUvsfsgXh
         L8RzEeAK3BCnAUzsn6nCgwA+GgiLTOuSaC1K8WTmKSGmZ/RoifexuRHgGt07CnzjgczO
         69p9G9ENAQaDSIF5cF887TLhsOl1rtUiknjCMu6EtOpLMZKCxBsw2YGD/v+TD1va9K95
         OOLSQnEGvAlEZV4BaJfo/xctS5PLqW2FqwJv0pz7nxajTzZmXGIRzEWdSW7Z2zO2JzzK
         OQFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768023509; x=1768628309;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lr91WETsQhvwGxA4YBFNGJu5pbkLgoMyM9mXGrzF/Ws=;
        b=FDLtP/glVuXEe6rWWhfnfuaEQP58RGLT/S20F7IQjJi8h0yE3eNrFujlkhow4o0Hf6
         WfXmMMqDT1Vcd3jUkbAMMss9EoejFP6K/I6R8DO9m84pE4DjN3jwqGmkoYeItaLYZPeN
         sY8zBe08bLn2r+uL6aYW0UTY9MjprNu6w7l8JHVu8/l4+OVww853xbMjq30Sd4YCXjfg
         CwjgPBp+9oajm2hZzViLBjmIgNwO6afZFd9rB/RKRHxS+URlzZx/N4Cvj6B1ryHBqGFj
         o5ZMZ8cVVQpz141cSr9Mk6rnGcvQjMp2WtPXXpmtsQ8rp10Aek9/zwdoExwU0sRfXzMR
         WNEw==
X-Gm-Message-State: AOJu0Yyc0AqZbQ/2beejUAZQuBvF1N+o/3crvEQKh5hladScvC39sjR2
	g8/B9ARAjfMSlzuqJbX7qwtkv7sGW/K3GkTESOYtE+4WMMtD9W48zTvktMY+ewt7YwUOJpEStbF
	Irw9XLngVsvBhu7WuAvPRf6tTnwVRWpo=
X-Gm-Gg: AY/fxX6k7y5QDYt3R70BLBB6fINZ6hbzA90QqH/xsqv1kQMpt4ReiMT35Mx49Scdsqh
	b1l/1WGWETowfdfWVPwAOsCHrj0wFUhhnket1z65iRzSsy1U7WJDLhpKMYHSdofr0pRKyaLeRVx
	AWBUsPa2Dv1QyAYc7tHVkerFOLox62Gn9nsWhyqzYMhTsVqVS8EaQJ0TcMf81urxmOIVlxuKBqH
	NUDzaKy/Lbl5oiTp9X396n9Ir4VOsoNsxdg4+QI0S9h/gMoja9U60NOMMFS/eHj5j+s7RpUCVnB
	Om69NDbkByd6Iiq9Xo2suJIZOx7554lQLdOWiWzR5L7W0VSqpJpLewpm+Dvo
X-Google-Smtp-Source: AGHT+IHcEJFlu5ntWFDQvpAsncsGw6xYMy7KPCrsGVaAPHQ6cqZR9Ymd+SbENZqTCdIDI6vdktHckN2so6H1+/2pu0g=
X-Received: by 2002:a05:690e:134c:b0:647:116a:f67f with SMTP id
 956f58d0204a3-64716d089c4mr9096701d50.94.1768023509387; Fri, 09 Jan 2026
 21:38:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260104014028.305029-1-kartikey406@gmail.com> <10be03f1-1ab1-44d0-b9c8-89cfc668c304@linux.alibaba.com>
In-Reply-To: <10be03f1-1ab1-44d0-b9c8-89cfc668c304@linux.alibaba.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Sat, 10 Jan 2026 11:08:18 +0530
X-Gm-Features: AZwV_Qh76SZCwg86nOqvD91QsNHER6F_nGxVEEJKAW2dbB5oaBlCVBA_NSMKfBs
Message-ID: <CADhLXY5W32uoKPWrtZaKDruA9pdiZAADL-7O9a3Pnp8znh5t1Q@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: validate allocator type to prevent BUG_ON in ocfs2_block_group_search
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	syzbot+44c564a3cb08605f34a1@syzkaller.appspotmail.com, 
	Joel Becker <jlbec@evilplan.org>, Mark Fasheh <mark@fasheh.com>, Heming Zhao <heming.zhao@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 8, 2026 at 1:55=E2=80=AFPM Joseph Qi <joseph.qi@linux.alibaba.c=
om> wrote:
>
>
>
> On 2026/1/4 09:40, Deepanshu Kartikey wrote:
> > A corrupted filesystem image can have an inode allocator with the
> > OCFS2_BITMAP_FL flag incorrectly set, making ocfs2_is_cluster_bitmap()
> > return true. When the code later calls ocfs2_block_group_search(),
> > it triggers BUG_ON(ocfs2_is_cluster_bitmap(inode)) causing a kernel pan=
ic.
> >
> But ocfs2_is_cluster_bitmap() checks ip_blkno.
>
> Thanks,
> Joseph
>

Hi Joseph,

Thanks for the correction. You're right, ocfs2_is_cluster_bitmap()
compares ip_blkno with osb->bitmap_blkno, not a flag.

I will send a v2 with the corrected commit message.

Thanks, Deepanshu
