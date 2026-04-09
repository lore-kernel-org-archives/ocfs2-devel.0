Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787B53DE43A
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Apr 2026 15:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775749237; cv=pass; b=HArAeMd8TpePyuYSisM3nn7UGUp/m6VJ/efbFFiH68WDUqd4rmqmYBp/Lv1THnKDlrzM9tSur41BFL/LNDJpfyXPyhW0F/iYMPFoEA10jm9FOHurXHTamNmVoJNbmG/7V+M4tYQICNPHv545s68RXqZoJlWWN3EenmpH/aSkZdo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775749237; c=relaxed/simple;
	bh=w6lJJhTJqTByJrwJamwnwGs+0r6SkDkjaIXhfafou3A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EKfmGiAQf+8CKCNizV71fpzDjz4gyCjh3wBqJIwarye5Wo2+hx1ISn6KAyLPYrSPCuRuWreVf0Xx0VIcOhJJpewX2bqraJij4eUTQPrViUiolC/UauoYAduSIGSKdYoPHhuI/usDgpt4QCCXqZix5TxQbXfhuk2+SZqTIWl5Bsg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GPGRs65w; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GPGRs65w"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b9c04152730so172649366b.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 09 Apr 2026 08:40:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775749235; cv=none;
        d=google.com; s=arc-20240605;
        b=KMb93GSPgZbnOgr6Y/g0r7O7WtB/QUljgzDDZ1xSbP3jw22fjZzP9TM5w2TST9O+U3
         c4ife4znYTGhtG/cv/kRTxYot+z6s+ScYqW6q1i6I4krFTcCJ/oy16W+A3MM3HHTN8WP
         fujf7vpB68e6W7QnQW5OeuIJ6N+KnkDE1y33cY8oyaUyjyQt8NDibbSV5cWpj1qWX3in
         E6uUEn7YTPdPgnIhk5mMSq0Fui56IA7iKGYO+OBN5ZmctpB+xb2OxfVF0WRYaXzUuPIy
         rLhQetdLPHyiLIAOjS1O1Z+cqLvfTMwn6FgnLFi69OAdD1G85mMhBtpeArCkedTjJeMe
         xlvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jbcTtf8+OJRtJAaPTY0BAK5Fmj2KNV/J3Yu5abER4bM=;
        fh=Pb6d9W9n+tn3xV5Bi4vsmfallqOlyswDLpgseMW0uFg=;
        b=ZuNVvPMFWo6xiHYqTVMnUpuH/cwebTDanwyfNRMgwtSVR8MPZJ6dY+UDqJPppdO5Io
         /LtgzqGyEHJN5HAL2Dguk34mTi9heeyXT3ZNUtXN8PfZRXgT/cASnEQMKeqocf02o7rM
         sSoUEp7q8BO8Iv/HKfdH9UVjN8VHz3ai6Uf0aZlV/05ug+Ux+d1CSN2N7KikKfygbUt8
         p97+HWtRer6EKX302UinlsqwZpwgINWOuvT19AN9gZ+iq8x+lHwmUXGLYAOeVLtdE52l
         PtLod04NWKn2mbbW1pIc0ADpcY1STnalNqanIU5vO5ZPM6shTE9kSJT3gawSoRnIfEtG
         63Hw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775749235; x=1776354035; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jbcTtf8+OJRtJAaPTY0BAK5Fmj2KNV/J3Yu5abER4bM=;
        b=GPGRs65wXjgDV2HtmsjX1HsDgF++4mWNxTL9T6/XDlfmgPTq/LJLq7Yq09MgOBoEhe
         HuDie1tCsWKA21Pint21xSEJxKSSEbFnK7aRgcV/51rzdR4EF7iD4AFXCKFpZP3phVCx
         1gffw/erNZvjXJCyVoOGyj0AgRKageTlljObZAuAiQ5hJcK+SSRvA+ify/gp1A8iWW2n
         Wy9F0efFiBokb9UryBmSs12+V79up8ZEijzFyxNhVZMfYRxte5S27eNSUc1XT0Ix7W1I
         GsCC4wEeTw44eNhtK7eFSOwNFi5EOc8IJTKzILT4EBIel5r4FDZOvubWFWIHwnXZz9t+
         XDRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775749235; x=1776354035;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jbcTtf8+OJRtJAaPTY0BAK5Fmj2KNV/J3Yu5abER4bM=;
        b=MT4pu+So7veYGSCAC8MdUAYe4wGGh9SCxAyzYXJL9FVVILN4/ReMP06YrIHa/RZWGh
         ikPDntDvINYxqje+YjDR8QDa/9ShGSpZMpx/AvIYrawJx4nRiCaf6iEm0KiIdru+OCVS
         EZIYZEnguVEPMUAnYeFZFLQhVV8H6VedjAjhw7dJaxy0SA++01WYOx6NKDLYSlQYRcMY
         rUZTw+EidAM5eGT1a+YrdgwJ2HRevNC3iohV+qXaLz4EadrNVYMaL6DYohoo3NnE6bIG
         25rNzqFl6njmhHdiC8pqU7AmXryMT4kTUh06DiWQCi4IsfiLBzzooDr4t/smpQXf7Ykc
         ylTA==
X-Forwarded-Encrypted: i=1; AJvYcCXYgEY0lIWAFc83uUWlNXc47F3DYhIr1k6itrjoFXDrSXMSMRcepIbUfw1uD0F2qAkhq60wBsM6Neyx2Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YxztEoK/cH578Y4HvTO9QeYHlz8L+7zTxNSxq3tT9nxHeW4vcNb
	uOSuxFGdG0dWOpJ0t2BwXhP54b4haMRqKr0FWUoAaQ1a7lVWXC+B3FMXDxDTMr0sgD9DkcdYOVZ
	8YBeJpN9ThcUeSInYzHu/G/kmJYLm+XU=
X-Gm-Gg: AeBDievDR+VjGjLGdY1zLvpmp6cYRxgnE2MzfITYNdaPuFy29POjrcTLMHlI1LJmswc
	L+naGruiG9GEpAqP+eEUbN13f9b2yBRGYoYfE/QFnn76Ye4pv13KWYndUHEUEP5bVdlYNPrgkNG
	3xvQAGqUAhBMKUfJBuzl8H4xc+iIafcpH0yl7OBX+XXNmZMp4MYpNfGSeiDehVVStoc72OVQOB8
	HtFh/Lhvwc568KRUfY0QveRmHmSWGjG9AvitA16sdyQ7L3wXSwl3tg8ev+CPKWBStxoFl/u1qsW
	YNQdA0IGqfqgaKvIpLc9p8yAJD4smHD50QGD3R7Yl4E3cec/U8K4rr0=
X-Received: by 2002:a17:907:984:b0:b9c:1c26:9eb with SMTP id
 a640c23a62f3a-b9c672d42afmr1295935366b.10.1775749234649; Thu, 09 Apr 2026
 08:40:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260409090255.3430951-1-gality369@gmail.com> <5df0ca20-b162-4875-8658-b46d8958fa45@linux.alibaba.com>
In-Reply-To: <5df0ca20-b162-4875-8658-b46d8958fa45@linux.alibaba.com>
From: ZhengYuan Huang <gality369@gmail.com>
Date: Thu, 9 Apr 2026 23:40:03 +0800
X-Gm-Features: AQROBzBvSXABFVGqrAYdOYMjSdw9G5378quWlidqkDS8ZzbX0GWHi0yM6V0KDFg
Message-ID: <CAOmEq9VVDmZZE11zEZWpciPdk_m00abvQb_3n44P_HL6asA4Ow@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: validate group add input before caching
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: akpm <akpm@linux-foundation.org>, Heming Zhao <heming.zhao@suse.com>, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 9, 2026 at 9:05=E2=80=AFPM Joseph Qi <joseph.qi@linux.alibaba.c=
om> wrote:
> Missing Fixes tag:
> Fixes: 7909f2bf8353 ("[PATCH 2/2] ocfs2: Implement group add for online r=
esize")
>
> > ---
> >  fs/ocfs2/resize.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
> > index b0733c08ed13..e45ab5592ee0 100644
> > --- a/fs/ocfs2/resize.c
> > +++ b/fs/ocfs2/resize.c
> > @@ -504,14 +504,14 @@ int ocfs2_group_add(struct inode *inode, struct o=
cfs2_new_group_input *input)
> >               goto out_unlock;
> >       }
> >
> > -     ocfs2_set_new_buffer_uptodate(INODE_CACHE(inode), group_bh);
> > -
> >       ret =3D ocfs2_verify_group_and_input(main_bm_inode, fe, input, gr=
oup_bh);
> >       if (ret) {
> >               mlog_errno(ret);
> >               goto out_free_group_bh;
> >       }
>
> Since ocfs2_set_new_buffer_uptodate is now moved down, the error goto
> above should also be changed.
>
> e.g. do the same ioctl twice, the second will remove the cache which
> should be valid. This is not the expected behavior.
>
> Thanks,
> Joseph

Thanks for pointing this out.

The issue is valid, and I=E2=80=99ve addressed it in v2 by fixing the error
path accordingly.
v2 patch has been sent.

Thanks,
ZhengYuan Huang
