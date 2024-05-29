Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35FD18BE0
	for <ocfs2-devel@lists.linux.dev>; Wed, 29 May 2024 03:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716952707; cv=none; b=mhYbo9p98Rh4iDh2sVFaK5vRv4KIxLxxFDd3clcZpUo+3IoKxIbzHbjrsVrBeoKHNa16DneZYncutaTm7YHdfOA5QOMsbaYZJgQtV2Nv6HvzopwIj8qgJ+brRZDEpMF9qWhqyAOlh6sem4S+Lzj1dWbsMVeDCfmo0eJgaUD1MQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716952707; c=relaxed/simple;
	bh=MhkBnLWr3OG9I5X0w+w0/XJp/Uk92zGn2zW+q0RutCE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EdmBIIZ0q36GcgVS4dNTrMUtMNMZsi6woLbIpOLZNnX7jGmboYQvwlEX5aueIQWqcnMAUi39tEZgV+Rfbl9en41OrT3ll/QKYfW6hddTJMhE4/l4rLGZN1JYSMu5otSOo5WJFSv+f6ibxcOSeuP8EnI2nlwwta/uNL+6LA9zueg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HyW/pPJN; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HyW/pPJN"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-62a2424ecdaso16589397b3.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 28 May 2024 20:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716952705; x=1717557505; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qmq4m0IQ6xON+ZxC6loPzv+5qpFRwZFai6lk8nt9dn0=;
        b=HyW/pPJN+eNyftH5+Nm5mv176lIFWTCzTT5BBN0lT41K3tawR5YNA+1ydKvzcVzwPX
         Hv7ZZ6lK43BbpVSTtEhR9OR05xrpTpvSsORDJoQsNDsta7VpfgRBMTnrHTbYcnNdhvSb
         fDnuRBw0Pm8viOkP8ExoRdNbfyOcJZSEdp1XGn1y7dsNXg7Ei57hCk8efst7szJfkfNh
         M0krISp5Hw5njoe4XKgN8SrSn4itkgViajBZDcvq+YB8Eq3Pb9k//sNObgXQcjASM3XJ
         2oKha5DPmM6oHxaqU8iMrKy10cAticjZl0M9DdEZ5a9hXc51vkdBV9dMQR2etHzU4jJ5
         QH6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716952705; x=1717557505;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qmq4m0IQ6xON+ZxC6loPzv+5qpFRwZFai6lk8nt9dn0=;
        b=ZgsW6HSvomUPR64oRUQFFZohypVvJeI+qb+b5wv3Z0xIAIlmTetkwZbwa59h8DRed0
         p1YYlieQc5OaIWQFgQEo9hJEC4A6+iyTau0FuWSfQM1ct8pGj39RexAztL4Ofva3tmEl
         N0/AoNrnEBrpgZ1cPEmpEv7MjxOvT93cmGYOBj45EvZ5CPe0VJ/UIN4sxbZ6JkxZ/kSF
         ZvTa+juOXtcGkRYdKP1c7f0+hyw0HdHo/12n3tOB1Sy6ZwaMynK+4JYjTvrHqwx3goVj
         P2tLsTSTFHKvslW3McYDdgFz7rIWVM0sp7NJmP9imO63wcgYaHWdZVQohVz1sw7A83DU
         U6tA==
X-Forwarded-Encrypted: i=1; AJvYcCWCiWpXkzsPrzs0uM+doU/4EaGvnC0v1z4sRKorWrDGT4lFsJlgK5P2tdTsawwy31Rjx+wnkToS+KJ4nuQpZ3S08AzNotYjYsTJiDw=
X-Gm-Message-State: AOJu0YxhWnXBDW/ziLe4g/63b2O1WxXu4KRGDvHp5opsyB1y5dYmS2DL
	8oXMUtOjdbJNoqUnI7S6pp3f9IkAJ1gZ+hYvvM25jjDK/ikVx09LObHxjMcwG88siAmgmGengI0
	C1reS8XMZdhJAuRDbvCkA9NW+IUg=
X-Google-Smtp-Source: AGHT+IFiyWP43Ki9ShoB8mGIheGcSSTR41rCweT/OLgn0NogsIGLfbqKgWBZ0yW2o//o+Ff+8k2ZCSPm4FL550ejGH8=
X-Received: by 2002:a0d:d9c9:0:b0:627:a7d7:6d76 with SMTP id
 00721157ae682-62a08f47438mr137014977b3.39.1716952705019; Tue, 28 May 2024
 20:18:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240528120140.15550-1-llfamsec@gmail.com> <22f06d3c-5781-43d8-8169-678ef2299ddb@linux.alibaba.com>
In-Reply-To: <22f06d3c-5781-43d8-8169-678ef2299ddb@linux.alibaba.com>
From: lei lu <llfamsec@gmail.com>
Date: Wed, 29 May 2024 11:18:12 +0800
Message-ID: <CAEBF3_bE4vkF3En7MKJFbgvRruS-n61g5RiuMDk6nT4ig7GmZg@mail.gmail.com>
Subject: Re: [PATCH v2] ocfs2: add bounds checking to ocfs2_search_dirblock()
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Joseph Qi <joseph.qi@linux.alibaba.com> =E4=BA=8E2024=E5=B9=B45=E6=9C=8829=
=E6=97=A5=E5=91=A8=E4=B8=89 09:33=E5=86=99=E9=81=93=EF=BC=9A
>
>
>
> On 5/28/24 8:01 PM, lei lu wrote:
> > Add a check to make sure all members of the ocfs2_dir_entry
> > don't stray beyond valid memory region.
> >
> > Signed-off-by: lei lu <llfamsec@gmail.com>
> > ---
> >  fs/ocfs2/dir.c | 15 ++++++++-------
> >  1 file changed, 8 insertions(+), 7 deletions(-)
> >
> > diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> > index d620d4c53c6f..56e2f8c62106 100644
> > --- a/fs/ocfs2/dir.c
> > +++ b/fs/ocfs2/dir.c
> > @@ -352,19 +352,20 @@ static inline int ocfs2_search_dirblock(struct bu=
ffer_head *bh,
> >       de_buf =3D first_de;
> >       dlimit =3D de_buf + bytes;
> >
> > -     while (de_buf < dlimit) {
> > +     while (de_buf < dlimit - OCFS2_DIR_MEMBER_LEN) {
> >               /* this code is executed quadratically often */
> >               /* do minimal checking `by hand' */
> >
> >               de =3D (struct ocfs2_dir_entry *) de_buf;
> >
> > -             if (de_buf + namelen <=3D dlimit &&
> > +             /* do a full check */
> > +             if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
> > +                     ret =3D -1;
> > +                     goto bail;
> > +             }
>
> What's the difference by moving full check above?
> As I commented in v1, we may add a more check in ocfs2_check_dir_entry().

Thanks for your time.

If no match is found, there is no check for de. I'm not sure if there
will be any OOB elsewhere when "de->rec_len <
OCFS2_DIR_REC_LEN(de->name_len)".

I'm not sure what "(de - bh->b_data) + de_len > bytes -
OCFS2_DIR_REC_LEN(de->name_len)" means in V1, bh->b_data is the start
offset of ocfs2_dinode. bytes is just the size of the de list. Maybe
we should check "((char *) de - bh->b_data) + rlen > sizeof(struct
ocfs2_dinode) + bytes" which is same as "((char *) de - bh->b_data) +
rlen > dlimit".

>
> > +
> > +             if (de->name + namelen <=3D dlimit &&
>
> As discussed in v1, this change looks reasonable.
>
> Thanks,
> Joseph
>
> >                   ocfs2_match(namelen, name, de)) {
> > -                     /* found a match - just to be sure, do a full che=
ck */
> > -                     if (!ocfs2_check_dir_entry(dir, de, bh, offset)) =
{
> > -                             ret =3D -1;
> > -                             goto bail;
> > -                     }
> >                       *res_dir =3D de;
> >                       ret =3D 1;
> >                       goto bail;
