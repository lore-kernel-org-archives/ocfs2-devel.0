Received: from mail-lj1-f193.google.com (mail-lj1-f193.google.com [209.85.208.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0AD7260D
	for <ocfs2-devel@lists.linux.dev>; Sun, 14 Jun 2026 01:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.193
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781400783; cv=pass; b=BOMpkMZfkadyd/SueWWVwK3m61FXwIegzn1zOiFq9SkkeVp/PylZlN12SSJb+Mi1Uk0lFy4cU0IeEFhe1/h5YEiWMfBcyi+UlC8fnKo5yS70c5GoOULvIPR/cSand8/gVVmGeP+ccSkhXfWxYzPyfLKrkmCiDe8BP60QCmK0ul8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781400783; c=relaxed/simple;
	bh=1KCDUnl8pw/eN5Yiv3AWp5ArcgVeaSevnIrsoUQ/5co=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RYZRzt1Zjid+3HQPIXdVlWvcP6WmjWOcKxVReR3XkbGVbxB77Q3ynxnkE6aQGfrcwQOiRFcDTq1Zz6GGV2azYAkG3Q5RtDgZIi7bOVugeYe6orHTovkRUBdXWYWfhmw15G5RQIfiMXTrK5SibazqEfhqhqB/lEzz7HOcGozDiaA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FEeNS41r; arc=pass smtp.client-ip=209.85.208.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FEeNS41r"
Received: by mail-lj1-f193.google.com with SMTP id 38308e7fff4ca-3967724bed1so24793071fa.1
        for <ocfs2-devel@lists.linux.dev>; Sat, 13 Jun 2026 18:33:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781400780; cv=none;
        d=google.com; s=arc-20240605;
        b=MsI1a93dEWx5TLhrLzTtWiJErqLmCiWrniNYFcCm7VzcQAnVjAuPQQEM83nzm6FANU
         EOcBicjkkYTUNlkfpcSX5E45PkCWd8Olpczo+sQXjRqABL2/vCMzVU7+aQJwds/1WuwB
         8ZqRKAgzo8vTG0Afrjkd53ztu3WOVQd5d6Q9mR1ns0+wqjH+hMNJDpEJM3mJY9VIbkg5
         u3paOrXrPjo0cyX3ogPtK6mofn8CmsXGI8B8AhH+l2Fk5LBrRl0fV+FBaqahR1lDy/2+
         9qaHzOV7QHCt4zhpSNA1x/jKKzo2d4TTTugd9wjDyTvEg2alebLpd7AA2/akd/h6wW5+
         ZK7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tGNwxXgvPBrU30+ol/pmAdDTdpdT4DGWuuV7B8A0X4U=;
        fh=03m5+eNLbtApDDs/duJGc/Fv/6ndu0DyInaK//2Ww8I=;
        b=OEhzd+eddW1xU52Gvy3CL/dFnbwSxx0ruHUApJTJpnCXtugXveLwQROjrgxku0zSeA
         rSdl5tNp9hQmrVuZQCL2kW7Luwxr7NJDrNacYDFsJqA5UTxAf9n4TFpBPAml/SN2c2uM
         dtmuyVK4+4zn3s8Wn0E7/zPioiC8XHLUT2ZiqYfiqQN5bF/rfueQ7kdJEwAIl9IPxu4m
         Hg/wznqXwa7UOKEn/q5ipPNvwW0TnmSLO3+VvFadcE/q0jTt7RAWlkpTQ+C1iJRv0INz
         jOE+ibzlvEFmgivUTYKoROwNtDJ+Lvf4HdufcOC2mc66gH4PRdzawGHCgXvn1TBuLVX7
         jEPg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781400780; x=1782005580; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tGNwxXgvPBrU30+ol/pmAdDTdpdT4DGWuuV7B8A0X4U=;
        b=FEeNS41rrfzFTYdPGDQ6E/XhXDAoEKQ3Pydn38uPhixrjBFuDllr3XJS6FGt4qakeZ
         y46MHnAquK1vI4T+jhqdnPkFVwtfhXm5CNwSEkNZSdJpps1O5wgE/4jm3cAmhFxB2C03
         JfPtjsFz0LtQJtLPReEke5wV6/8ckhIvUQGU0p+ccFu6bQKMeaxc+M5P/ujr6yGB3xVr
         cm0H6Opj2RAFOYwN8hWKz3v8U4NezsnzBI3E6F5SD3Srn501wX/QqQAV/apAamSz1dWR
         XUyPXBW09B1gXT/d2t5csHP9iWIs+TWTJiyqD79r4IoKRL38m/XSPa5QpQkpqIsbC7Jf
         CQog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781400780; x=1782005580;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tGNwxXgvPBrU30+ol/pmAdDTdpdT4DGWuuV7B8A0X4U=;
        b=qRlneJWli8qxn+6Q7uR0zbM3M1Sf+KF3ehXzxAMXSRV3HiaCwBaKuHnqa9DTNiGH8s
         wT9C5JVRH/CqgUf1gFkh18pXm+NepTEKCtV68rNBV2I7bS0W1XkHV1s0WUf5D7V4gtN/
         NmBEcnFVII2kx2sneW0r0zomfcO7ftvgSbELenlRlSuad12Yz0miE+00Z+MsYYvsjQwC
         +8XKOzXF/lqQ8LR3FMAX/Ah5zrLrTELibADAsqZVqW3nDsA0uTNH5lO+my3sj1vjxftZ
         soihWK+zHRM8FSnEyx6xIHFXjfmMzrlNR4kAjPBXrD6ERmBkqqHv6lAk61l6v5pvOMSX
         ehaQ==
X-Gm-Message-State: AOJu0YwIEErwEYesm6sIpSgBfQULn1Donj19Djb7N+iu+uYPTUAmBtXo
	AiDwxNEGKJ7yvQqx8Afbi8CvuuVYTKPgU6nGUIFHsQ3aJ9Sfbyck7S9sTIilYKOab5JY38D8p7j
	T6RVK03NydWMELmxWHJRuxCFZXIjkxvqgHwSKCLOVOmOxIH8=
X-Gm-Gg: Acq92OF38lzE2L8rv6ESXyF/dzg+KoMVxBCQWlecd7fXe2r5WH3+srPuuieW3eXiIUD
	oYNlrHFYnt3y5WJQZwh219JksUKjPC0d+irZdv4Dt3EYQ9C33/6CZcPNG4ir+AZsA7xm/TBOcOA
	ZuNeJ44XKZFeh+/QtcSaQQlpNQfAz+CgnhYRaZjhLLbrdZTkZxkuMfNoLPDytex0dAEdqXfVpBw
	xazar+t+ISskic3qIyXefxaKsRX9q1eUa+7uplUo9+tADl2tINoEtfCLcQNWeElPxu3pZgCgX0U
	qlWQD2DaCVk2KOZTHD7wCJwFn44HSIO8QhdyS7Zj6XkgAWmpF1mwKy+pMaGtE+WRUFs=
X-Received: by 2002:a2e:a98d:0:b0:396:76f9:ac7c with SMTP id
 38308e7fff4ca-3993558708bmr13525671fa.1.1781400780187; Sat, 13 Jun 2026
 18:33:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260526034040.3602377-1-rollkingzzc@gmail.com>
In-Reply-To: <20260526034040.3602377-1-rollkingzzc@gmail.com>
From: Cen Zhang <rollkingzzc@gmail.com>
Date: Sun, 14 Jun 2026 09:32:48 +0800
X-Gm-Features: AVVi8Cfa7hDYgmoCvpcbQx14VOmYVMCee-SnKKQmyblZDLdBgv6ljmjlqn4Qhj4
Message-ID: <CAB7XQsH2TcdhX93+HMkaxCWkLPeN_OQs=CF16M=_bDLqUgDqsg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] ocfs2: validate xattr metadata bounds
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, zerocling0077@gmail.com, 2045gemini@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi all,

Just a gentle ping on this series.

I would appreciate any feedback or guidance on whether further changes
are needed.

Thanks for your time and review.

Best regards,
Zhang Cen

Zhang Cen <rollkingzzc@gmail.com> =E4=BA=8E2026=E5=B9=B45=E6=9C=8826=E6=97=
=A5=E5=91=A8=E4=BA=8C 11:40=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi,
>
> This small series rejects corrupted OCFS2 xattr metadata before the
> getxattr and listxattr paths walk filesystem-controlled inline, external
> block, or indexed bucket storage.
>
> Patch 1 validates the inline xattr header placement and entry count
> before ocfs2_xattr_ibody_get() parses it. Patch 2 builds on that helper
> and validates listxattr entry counts and name ranges against the storage
> that backs each walk.
>
> Both issues were reproduced with crafted OCFS2 images under KASAN.
>
> v2:
> - Resend as a proper two-patch series. The previous send was malformed
>   by the transport and appeared as a single combined email.
>
> Zhang Cen (2):
>   ocfs2: validate inline xattr metadata in ocfs2_xattr_ibody_get
>   ocfs2: validate listxattr entry bounds
>
>  fs/ocfs2/xattr.c | 122 +++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 101 insertions(+), 21 deletions(-)
>
> --
> 2.43.0
