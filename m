Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3271DC197
	for <ocfs2-devel@lists.linux.dev>; Sun, 17 Nov 2024 21:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731880435; cv=none; b=jwW+5qiUKOIVbMNDEhne+NqX46zTDjruDApQ3x+lCt+WfO1VfDCpXDUUTYsOVn4F4lNOMJ+R3gdg2l1kteaJ8yglppfMuUZ647ZqZbsa2gvEsnNhCHIWcQ+kmtXs8JU7ZKugPHcNhtYxFcHWxQrY14onuVfZ6QfSo7cAI06qgMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731880435; c=relaxed/simple;
	bh=tQFDHxJkmFPFr/ARzBU1zOmRTEgK+j0z8NscZUYKTXs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q21CzUnLAaa/Anet6hcZMQTsuhYwFqcmOOvGGdLWOH0Mq5ifnuZjOydJ7Uv8fiGUBMMWToTBh2x423U2Dm69tYBinJBB1Msf/tGa6VlzJ8K8/m9S4UEGzqV/QUkD6trZEBqIw6RcdEtFO+sFuGsumQLwuXNcJVi9zR98ALSZHco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XIhHViT0; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XIhHViT0"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-6e5cec98cceso17171337b3.2
        for <ocfs2-devel@lists.linux.dev>; Sun, 17 Nov 2024 13:53:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731880433; x=1732485233; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xl6v2lcDSmPgGWlnJakrc1Lm5CUHk6H8asT7A+17yYg=;
        b=XIhHViT0W20deXU2AKWM+itAG0ngpJFK/gpG3vFdC+LDe9I0VAN9MfYQqB0fdpGzct
         5uoPoK8fuuEnNFr49Kw6uN1u6JL4eundsegkl5tQZT7/xc539WDcDn4E8yDyPfuEg+8v
         920r1Hsg+h67iUSxpTadATEqIvt4eNoocVzY6kA0G3J6CkCigOV4Yma0tczUnJ0TrGfU
         u/jNSIca/IqRTim99FtBgEFGUBrpp9ASG8D0/MynaMlY/RQzV7AaVLr0Xu83DJtqbi78
         U925xFR8SP283GrMCFeNdqy1A4EagBAmFLWvLY0aGbyWVXM7WqLIF3ao8UzuRV4SxDE1
         StPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731880433; x=1732485233;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xl6v2lcDSmPgGWlnJakrc1Lm5CUHk6H8asT7A+17yYg=;
        b=e8SJ9GPvye3cQ05VHajcY7XeOwD9/9YZowDmwi9QWN9lENwjHEQznacoKpbRZpWoLb
         SkXmcrWoD6y9Ju6WLPnhYH9jwimFnC9tJkOmcSxP/fkBUlO3E17aNLj5+8N16/xwnC36
         b2zjkntpHiOxCuHwf/5Bco4sDYVcmGyrTqwIrmRMae/GzQSukfEmOCT/uwajvsKSjBcm
         7/EKo1lolQ6mB59W9pkp6p/3Zad8t0nh7Ne4dEJyuJ0NqWK4K1EMLAT0EMRPKv6DDsY5
         rjw11OSykcY0QJqVFwlRl53JcibKLfOD5H3hBnGp3QvoT6DFuSLHG8CZbUABL6OmcLBL
         LUYg==
X-Gm-Message-State: AOJu0Yy8nHf4rJBf4BmdvYi4YI11RvuanMeHfO1pXwZz9AwND/T/1tOE
	K9UEPvrPTtiKtrsWN+2LWZ9YUu3qTcdI5bfL9DCNaMToF1QxEOtupt5BF8Wu3IRzITBaI5nWQAw
	KuM3/HuInHnYiaMsZWlXO3Z6SGJc=
X-Google-Smtp-Source: AGHT+IGvRlSN7yj2pEImEoAlALeMN3fP9oCuhHEeEy/Kmyoa4qxcXAVF07R6JGNBqNkuh1vJzIamy7RbSQxqmGFGaG4=
X-Received: by 2002:a05:690c:c96:b0:6ec:b74d:a0ec with SMTP id
 00721157ae682-6ee55a83a69mr90116067b3.20.1731880432783; Sun, 17 Nov 2024
 13:53:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241115075131.4457-1-danielyangkang@gmail.com> <ce0227ac-0262-46b7-8f77-6f6953b549ae@linux.alibaba.com>
In-Reply-To: <ce0227ac-0262-46b7-8f77-6f6953b549ae@linux.alibaba.com>
From: Daniel Yang <danielyangkang@gmail.com>
Date: Sun, 17 Nov 2024 13:53:16 -0800
Message-ID: <CAGiJo8QB4bwkZ6=FcXk+k+3VxH=XPmOX4DzNq7sXcQ=T3v8K6Q@mail.gmail.com>
Subject: Re: [PATCH v2] ocfs2: heartbeat: replace simple_strtoul with kstrtoul
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: "open list:ORACLE CLUSTER FILESYSTEM 2 (OCFS2)" <ocfs2-devel@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 17, 2024 at 4:37=E2=80=AFAM Joseph Qi <joseph.qi@linux.alibaba.=
com> wrote:
>
>
>
> On 11/15/24 3:51 PM, Daniel Yang wrote:
> > The function simple_strtoul is deprecated due to ignoring overflows and
> > also requires clunkier error checking. Replacing with kstrtoul() leads
> > to safer code and cleaner error checking.
> >
> > Signed-off-by: Daniel Yang <danielyangkang@gmail.com>
> > ---
> > v1->v2: moved ret definition and removed blank lines
> >
> >  fs/ocfs2/cluster/heartbeat.c | 15 +++++++--------
> >  1 file changed, 7 insertions(+), 8 deletions(-)
> >
> > diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.=
c
> > index dff18efbc..84ee5e340 100644
> > --- a/fs/ocfs2/cluster/heartbeat.c
> > +++ b/fs/ocfs2/cluster/heartbeat.c
> > @@ -1536,9 +1536,8 @@ static int o2hb_read_block_input(struct o2hb_regi=
on *reg,
> >  {
> >       unsigned long bytes;
> >       char *p =3D (char *)page;
> > -
> > -     bytes =3D simple_strtoul(p, &p, 0);
> > -     if (!p || (*p && (*p !=3D '\n')))
> > +     int ret =3D kstrtoul(p, 0, &bytes);
> > +     if (ret)
>
> The preferred code style is:
>
> ...
> int ret;
>
> ret =3D kstrtoul(p, 0, &bytes);
> if (ret < 0)
>         return ret;
>
> >               return -EINVAL;
> >
> >       /* Heartbeat and fs min / max block sizes are the same. */
> > @@ -1623,12 +1622,13 @@ static ssize_t o2hb_region_blocks_store(struct =
config_item *item,
> >       struct o2hb_region *reg =3D to_o2hb_region(item);
> >       unsigned long tmp;
> >       char *p =3D (char *)page;
> > +     int ret;
> >
> >       if (reg->hr_bdev_file)
> >               return -EINVAL;
> >
> > -     tmp =3D simple_strtoul(p, &p, 0);
> > -     if (!p || (*p && (*p !=3D '\n')))
> > +     ret =3D kstrtoul(p, 0, &tmp);
> > +     if (ret)
> >               return -EINVAL;
>
> Better to return 'ret' directly since it may be -ERANGE.
>
> >
> >       if (tmp > O2NM_MAX_NODES || tmp =3D=3D 0)
> > @@ -2141,9 +2141,8 @@ static ssize_t o2hb_heartbeat_group_dead_threshol=
d_store(struct config_item *ite
> >  {
> >       unsigned long tmp;
> >       char *p =3D (char *)page;
> > -
> > -     tmp =3D simple_strtoul(p, &p, 10);
> > -     if (!p || (*p && (*p !=3D '\n')))
> > +     int ret =3D kstrtoul(p, 10, &tmp);
> > +     if (ret)
> >                  return -EINVAL;
>
> Prefer to:
>
> ...
> int ret;
>
> ret =3D kstrtoul(p, 10, &tmp);
> if (ret < 0)
>         return ret;
>
> Thanks,
> Joseph
> >
> >       /* this will validate ranges for us. */
>

Thanks for the clarification. I applied the changes and sent a v3 of the pa=
tch.

- Daniel
