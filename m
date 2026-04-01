Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086962D5C83
	for <ocfs2-devel@lists.linux.dev>; Wed,  1 Apr 2026 01:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775008159; cv=pass; b=ePs9fI3sl0xbWdQCTr8Gz6C7ePbuOLgkikueL7kj9crxyqoOsEqHD63d+Z0ZAfGp1IbmL2y3lgt2Ewfu3qGT2aTsBhkEgrvbe0k3AR+9EEbFW3Y9ImV5NxIerWJQamicRgPH22NpOiUk4nEDvy7z3cDB/lQ+AOMvj4F+DjTtbCA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775008159; c=relaxed/simple;
	bh=7YzeBmQuUCPabNyT0VJ170w/i9ektq7rCVtZ8ofmbKU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XITysaBuLFj+DD5f4iTIXG60wgTNuyFLjksCIks/mLzeCKLORomP/GVzRuaL7lU3Fhfxnh+yF0czozbWf2Eg+aN9frt2RPtrkSTv0YXMfmoZcNdKP15dKvLFFqmTZtFc14SyYbDLnGxcXx/ZUnLx9uqeBQQfHm+C4Bu9BfcVd4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P4Oki7Ue; arc=pass smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P4Oki7Ue"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-66a851e62c6so6580716a12.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 31 Mar 2026 18:49:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775008156; cv=none;
        d=google.com; s=arc-20240605;
        b=ANXG+uTcXn9S16DbugEaAYgMiSMic3bzQsSvSoPFSQJQkwj8ARR5vL3jouz1nbE7Qa
         ZMsukTTX9dB8JfofFfKuoC79yx0odYANbERgQHcGV0Nqm0HTKZPy2EBgH9pTo/k9Yvdq
         pTb5qTfnStDTkr4ZrDCkyVX75GfDV5pw23L98DHNs+GercEd+5Mgj79uvHw+5JiVcNPh
         lbbDZgrbd/qVywaQzIb78qZ+cMquBWcftfG+XDHIJKPVOBN+n89k8QAU1kyJiCt7/6cz
         1jpidsu50QfokB/CjWLZDgDZeMbls4vHsFINy0A/+USbnBRVJ3IquTlD85VY+1nVaAas
         MkJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Q0XHdXW8EXzPNR0FuD+9FpaIts5gvvX5mgwKB+VTBRw=;
        fh=FLRldhW73fzzUGsTXchr7wQPBS3DwSWYsZYi7QDX0Vc=;
        b=D9ERJp4YOU1vj9+R04lVYY9DFr9WSTvEekHZXSQOxfGWaWXFINshYgPbtVSRTmkDDP
         SdAWwJDoTAuhon4xfqazqfX+7s0Ik8bolv1eVx3BYU5KzFex6Z3iezYRyJGuhX3BJLUh
         Npg1akoNuv6/W9vhCZ1bJ6NMvgAoAvrVWIFLtHNAXvb7+uQMgwczCu1SDxUiMbjPw5DW
         tTSP1ZG+JuhLAgUUBItiXxtBi04sSf9nnakWLP2NSlKxYAQoZbFwl0n2kWIHCfeCtCPY
         5s5et2d03O1H/cMGsU0UVoHLC1XT6LUKmZKrV6ncK0GzQ2yDgu/fQ0noABM4r1ELQ5sa
         /QKg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775008156; x=1775612956; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q0XHdXW8EXzPNR0FuD+9FpaIts5gvvX5mgwKB+VTBRw=;
        b=P4Oki7Uelv7pDpCoxSluSEyh//ZXcmH4ljEFRbLPzW19BN3aQLOm6M62+lKP1rjulV
         aPC+21ZU2DiXWb2CQkXgkOS5Dih8YXdefDeUyhVYB/FYezMfb0mwdKi8haf9/46BPUnG
         AHPWQSnJrZkuPfnz9oGPKjGVsGX3aw2KZ49obnroc+ZLW149XPYQJ8sG7cL7wGS5RFiW
         y2mDq/Qy/dI+eAhPQkhg4zpMVck/5GOAdoH8LpVm5xkk7zmBON2peIE/Bobs/MMeL6hn
         8J8WS123FwFpPf4PooY5vNdm5HZDFtKwJUCym58lwD23SuEuRqIarLllGxEnzyLfOxpP
         hkkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775008156; x=1775612956;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q0XHdXW8EXzPNR0FuD+9FpaIts5gvvX5mgwKB+VTBRw=;
        b=IZmOqgPW1Q6Oq4q9hA3rzW3Crgg5HnvehV/pg30TuBoNLj0gaMkiMUQsYQc+jEA8Oj
         REddBk0Q3U7DmRW1+zLz+dwJO0wfc09cY43/1MkrfsFdIDUqcjCRPKQ1YxQoW5JYKnRd
         ZwHVSCh7sNApr9V/Zqay1yOag9UP0/MxeJ/JruFT9gVxvfqrvZtzt0aiUE8Sr1d01Cml
         ls9+jrH3gYfhijBSSza+jAQAKU9czdSs0KN4LSoFbPD39fnOHPSalNGmioeYzlkiySQf
         dopNTlFkeoxdBSLYoxNFAR+JJeRRRD7MediSSYf93jHKYAzP64ti/D6cB3Kp/BKIIMPA
         PAlw==
X-Gm-Message-State: AOJu0YwLZUnn0hDAjq5N+AbsvKz7/81aNZ1/SBOgEiZitqfL2KFmwvjS
	m1uVrHHNoQdofk6ofbrTF6+lmrJPVhMicIN5USr9ywp1Gb9rPK1tRpSe1JVRD/SAAtjYYsUG3x+
	dKsUA3HlLRCNiJo9KySAL3rYK3cVWHNY=
X-Gm-Gg: ATEYQzy9wEzT3EqjX7vCxXuRFFEXDNX54AnBPJwoq/f7KHvmpi2zeyj4zwf2BqJTwO5
	yEB1Wxfy1s52NBRyVb58BKXoQjiF5ZGWKwIc7XZTQ7Zfav+RlcoW7MRdmmyk9KmXNCZLVhR3y92
	fwHPq1gxv+Rc88+yF2K8vP5EyiKgjhPOhNYWMs7R2nRzBVrgVr63ssm8KVrk51EjhnuB9gAtgbT
	qJ5gIj7GpVExSxwPnZOP3pV2fK8svLsVlzuPF0rdMJgKLoA+QfMDYgTD7TC2BR4Eh2ZaTuuz/ft
	eG1N5eo73XzUKKzj5MAyFd7Es4m6kDdWqcPyALTQlOZNP6GQg4eFMZix
X-Received: by 2002:a05:6402:42c2:b0:66d:d0c1:f87b with SMTP id
 4fb4d7f45d1cf-66dd0c1f8cemr559756a12.10.1775008155873; Tue, 31 Mar 2026
 18:49:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260331133134.1842372-1-gality369@gmail.com> <46fe2e7a-60bc-4d85-9c17-fce665b366fe@linux.alibaba.com>
In-Reply-To: <46fe2e7a-60bc-4d85-9c17-fce665b366fe@linux.alibaba.com>
From: ZhengYuan Huang <gality369@gmail.com>
Date: Wed, 1 Apr 2026 09:48:49 +0800
X-Gm-Features: AQROBzB2MFmgXyHYdTyl8gJUsQNwmbSOujQn53CFmdKvj1b-g3jJr6or1zlgqMg
Message-ID: <CAOmEq9UDbXbCVTks4hCpj=jdz7MgMW-O5ezM11tSp62iiO-+Tg@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: validate bg_list.l_next_free_rec in discontig
 group descriptor
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 1, 2026 at 9:26=E2=80=AFAM Joseph Qi <joseph.qi@linux.alibaba.c=
om> wrote:
> >  fs/ocfs2/suballoc.c | 16 ++++++++++++++++
> >  1 file changed, 16 insertions(+)
> >
> > diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> > index 6ac4dcd54588..6dcf45fda457 100644
> > --- a/fs/ocfs2/suballoc.c
> > +++ b/fs/ocfs2/suballoc.c
> > @@ -196,6 +196,22 @@ static int ocfs2_validate_gd_self(struct super_blo=
ck *sb,
> >                        8 * le16_to_cpu(gd->bg_size));
> >       }
> >
> > +     /*
> > +      * For discontiguous block groups, validate that bg_list.l_next_f=
ree_rec
> > +      * does not exceed the maximum number of extent records that can =
physically
> > +      * fit in a single block.
> > +      */
> > +     if (ocfs2_gd_is_discontig(gd)) {
> > +             u16 max_recs =3D ocfs2_extent_recs_per_gd(sb);
> > +
> > +             if (le16_to_cpu(gd->bg_list.l_next_free_rec) > max_recs) =
{
>
> Since most places only check l_count, so why not validate l_count here
> as well?
> Something like:
>
> if (le16_to_cpu(el->l_count) !=3D max_recs ||
>     le16_to_cpu(el->l_next_free_rec > le16_to_cpu(el->l_count))
>         ......
>
> Thanks,
> Joseph

Thanks for the suggestion!

I=E2=80=99ll incorporate the additional validation for l_count as well and
send a v2 patch shortly.

Thanks,
ZhengYuan Huang
