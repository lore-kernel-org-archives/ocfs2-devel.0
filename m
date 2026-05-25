Received: from mail-lj1-f193.google.com (mail-lj1-f193.google.com [209.85.208.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29475184
	for <ocfs2-devel@lists.linux.dev>; Mon, 25 May 2026 03:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.193
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779680539; cv=pass; b=AHn5mEO5kHPzpkW0zdRlkWrjc4Z/zsUKF6AxtDwXXO6R7xlZ2Is4ShshcRinfMS6ees41Jtqxjj5ETJ1Qsodad4PcMhBipBkhra0Ci3EW2HBGp9jYrzXDlOwUuiLPqb1danpTKpBHL8rnb3Xw8j7prFJiFHilS+GDz6IXzlDaII=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779680539; c=relaxed/simple;
	bh=JKgezLr8wuFXAmnnJF9Gj996P0bFVIbKvEZ0lLnMvjs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t3mNbm9xcV4HKTMzbYqaF+lWOYF7OAxSHJDKWvTbrOc1Ujqp/3vRCODRGfT2LOtUk90p9vt/dxtoRNbkaIMohRmeaI889Qg3ulbpyw1jscWpvyPgSIwSBD8QWb0dbj2Lbc+wwQM71+XUVrgG2eLHEF6HWO2wlwiP7RWM5XVwbL0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eGiQxrpN; arc=pass smtp.client-ip=209.85.208.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eGiQxrpN"
Received: by mail-lj1-f193.google.com with SMTP id 38308e7fff4ca-38be5e86918so113180271fa.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 24 May 2026 20:42:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779680536; cv=none;
        d=google.com; s=arc-20240605;
        b=egcbirKqqlS6ASD3dSDzZCXqumDoKsjtVGH5jfAH3uMaoN3UnBxddmGeFHteyNSjrK
         ZpW4lGm2UYxC+Ophz5YQ0piUtDQKoX1pFUYcjjfXS7CRCIsJsSYbnVMKuiV8D3SpztwI
         fsHd5eJuwjKlX/ElKjCUfDs6ej9LTPWPUOPQ47Dzyiommu38Y75tKEBHYYcZ0QdjUtDg
         tl3qklSb+STfeodXzM6/MhyXWuD/WqwV46tjG5FWpt3F68UD63i0YpYs5bbFHi13/dBW
         7uZxNzWqwoxbC3qWDvi86gL3OcYYP3e/1FJQY42ocsEhAUeIkPAz7xPR2EB7b+EHYBvb
         yHow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5TGRjNrfEmxZSNjrpXehuVPdATFKm7mx2fAEE9yKvRA=;
        fh=vU9d5jo4RCKxXhxn4sS8Yb9t+Z8woZxPs1Ks1UePbt8=;
        b=eJJfDtGNJCeaS4mUvOxG1uH9MNX6Ad+SNcbdVBB0rDNHBPfojGfXvGYqgRn2gJ3KhL
         iDI0tx8jK2i8O4RWJTDUGEroDsVcVBXoBpzNm26Jk7OXid4910bYIPZ+RoswEoMvoR7f
         C2lA301jpXKSYUcA/dmvHD8dHeLqJQjq7NNfxDLp9ZVB/gmHEpbCPXJWp95oqzfgfOz0
         izzgufzBsTtd0UG/Qj2s7+N13AmbjihTeZxpvuzu5yVJOJEeVebU+dTo51clx0JLvOoz
         VDWe5x8XrkdLruaVKYzg2E3hr7tHJ07GsEHP2UnABYRKrPTHtuP+XNwNRvYHEopk4OSd
         v7qw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779680536; x=1780285336; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5TGRjNrfEmxZSNjrpXehuVPdATFKm7mx2fAEE9yKvRA=;
        b=eGiQxrpNrNmD/6TPfTNtiIxg6tO3ZTauisxSCsBdF38FXTkw4nz8L91TvMZMt4oxX/
         qJ5fQLkPjgLXQPYdM6bQkQeF9EzG67O5pP+2NH3DemF+Iz/brGXOLat1DzW7O1pNvL5l
         TMXFM4lJiX1V3Ptu3LmxXj9TB2szPqCjUhqUWnvixf0BQ55sQApioWQTQpOfhU/+IiWm
         XXas137/jxs2fomeVQz9qxqlYqOGqjEQzECmwdsUbi0J6bVCv82+Os0pCPGHk5FzqSAY
         b58mpHhrrhPqT1ZuPRw/soybCO5FbQyGeqyQVn7ewK1EKGCEzvnIiz67wIcnIaK4/TAV
         +sBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779680536; x=1780285336;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5TGRjNrfEmxZSNjrpXehuVPdATFKm7mx2fAEE9yKvRA=;
        b=ZWO7Xh+kklI0qg7BfGu9nwpscZ6WWPlz9ghYkdCqTD04FaXl7h4yn4eXQ87Ks4bwbS
         HzAey4T6yOYZSKi6KWMQVF085c4efV7OfoB3XIT+aUAr29cihkQd8TiTs9/HmTQsP7Lc
         bWxI/OUt29RfkwomLes3XPbE83J/J6ejWrLFlihUeLokwXIAjVYWiIV2OSGyRvVHYY2h
         hsTyUW6XAY/7H44DPSplSrhKzCVbkh5osSQnNwjpbNFA1pw/A9cguEEWfp2zl00iOezO
         kRBh4kaPmsqzqscnzt/dwIKKNU+Epw/yefETDSRgDA29LlWKMXHFtrZ7ASpbez9rWI9c
         FhcA==
X-Gm-Message-State: AOJu0Yy/eE2XkxH0SShbBw+opCF92WmnCGfhjFsw2uGklxUJz6eYjJaQ
	S/HBXFrLd1abAyfeau08B0U/aEs7FAAYfnJRJ8mpk4B2xyk19z3NRNAK7xWg1I/i36eT027amOt
	2BTevrFwBI9tvAKEE/N1q4K0oHwvRxek=
X-Gm-Gg: Acq92OE1Rgaa4PoCQ3re0scSMrAEGX2Ihr1SoEoEhmYEgqWnI/nn+gosLJjq73QwV0e
	zSYM8wyaDKxHlpvJBnjT2ut+9HjPUdjol5PlmEtyssYCyqmjD9lfVWk/+xJoHl3WKIx6IZFJlfz
	4ZfP6I+Ms+PwfmV0uEt6bAQFjzbxCgP2RCKTIxIdWkxObPNf6j7LEhgkkcncuuubOH8Rx+yjEwm
	kz1AF/cYhCObdXozs0KHsP8qDOMrsyX5fEQjE+czsRz1MZZp73SfZlEZlUWj6uuqH0ctg8jnerT
	cE5Jxaubq/JutBLfEFW6
X-Received: by 2002:a05:651c:1143:b0:394:2b4:ca36 with SMTP id
 38308e7fff4ca-395d8e1aadbmr38129561fa.30.1779680535983; Sun, 24 May 2026
 20:42:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260524110749.1416771-1-rollkingzzc@gmail.com> <5095d804-41e9-4803-bc81-21197750161e@linux.alibaba.com>
In-Reply-To: <5095d804-41e9-4803-bc81-21197750161e@linux.alibaba.com>
From: Cen Zhang <rollkingzzc@gmail.com>
Date: Mon, 25 May 2026 11:42:03 +0800
X-Gm-Features: AVHnY4J01zdA_SxMNBhsSwR6CpaKHyjj7wXJ9lQa-wc1xRpaaco4xNCjkj1hOX0
Message-ID: <CAB7XQsFfaaymc_2B5O0dA6YmR9vGDqXTpM=QvWmSf+g5BNtmxw@mail.gmail.com>
Subject: Re: [PATCH v2] ocfs2: rebase copied fsdlm LVB pointers in locking_state
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, zerocling0077@gmail.com, 2045gemini@gmail.com, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Joseph,

Thanks for checking. Yes, the commit log in v2 was accidentally
truncated in a few places. Sorry about that.

I'll send a v3 with the commit message fixed. The code change itself is
unchanged.

Thanks,
Zhang Cen

Joseph Qi <joseph.qi@linux.alibaba.com> =E4=BA=8E2026=E5=B9=B45=E6=9C=8825=
=E6=97=A5=E5=91=A8=E4=B8=80 11:26=E5=86=99=E9=81=93=EF=BC=9A
>
>
>
> On 5/24/26 7:07 PM, Zhang Cen wrote:
> > value under ocfs2_dlm_tracking_lock and later formats that copy in
>
> Seens it is cut off at the beginning?
>
> > ocfs2_dlm_seq_show(). That is fine for the inline fields, but the
> > userspace fsdlm stack stores the LVB through lksb_fsdlm.sb_lvbptr. Once
> > the iterator drops the tracking lock, a copied non-NULL sb_lvbptr still
> > points into the original lockres owner, so teardown can free that
> >
>
> This is also incomplete.
>
> > Rebase the copied sb_lvbptr to the copied l_lksb before dumping the raw
> > LVB. The seq snapshot already carries the inline LVB storage reserved i=
n
> > without borrowing the original lockres lifetime.
> >
> > The buggy scenario involves two paths, with each column showing the ord=
er
> > within that path:
> >
> > locking_state reader:                  lockres teardown:
> > 1. ocfs2_dlm_seq_start()/next()        1. file release or another owner
> >    copies struct ocfs2_lock_res           teardown reaches
> > 2. ocfs2_dlm_seq_show() formats           ocfs2_lock_res_free()
> >    the copied row                      2. the lockres is removed from t=
he
> > 3. ocfs2_dlm_lvb() follows the            tracking list
> >    copied sb_lvbptr                   3. the owner frees the original
> >                                           lockres container
> >
> > Validation reproduced this kernel report:
> > KASAN slab-use-after-free in ocfs2_dlm_seq_show+0x1bd/0x430
> > RIP: 0033:0x7f8ec4b1e29d
> > The buggy address belongs to the object at ffff88810a1e0800 which belon=
gs
> >
>
> And here.
>
> Thanks,
> Joseph
>
> > Fixes: cf4d8d75d8ab ("ocfs2: add fsdlm to stackglue")
> > Assisted-by: Codex:gpt-5.5
> > Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
> > ---
> > v2:
> > Document the introducing fsdlm stackglue commit.
> >
> >  fs/ocfs2/dlmglue.c | 17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> >
> > diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> > index 7283bb2c5a31..a23dd8f86c89 100644
> > --- a/fs/ocfs2/dlmglue.c
> > +++ b/fs/ocfs2/dlmglue.c
> > @@ -3134,6 +3134,22 @@ static void *ocfs2_dlm_seq_next(struct seq_file =
*m, void *v, loff_t *pos)
> >   *   - Add last pr/ex unlock times and first lock wait time in usecs
> >   */
> >  #define OCFS2_DLM_DEBUG_STR_VERSION 4
> > +
> > +/*
> > + * The debug iterator snapshots lockres by value, so a userspace-stack=
 LVB
> > + * pointer copied from the original lockres must be rebased to the cop=
ied
> > + * lksb before the dump walks the raw bytes.
> > + */
> > +static void ocfs2_dlm_seq_rebase_lvb(struct ocfs2_lock_res *lockres)
> > +{
> > +     if (!ocfs2_stack_supports_plocks())
> > +             return;
> > +
> > +     if (lockres->l_lksb.lksb_fsdlm.sb_lvbptr)
> > +             lockres->l_lksb.lksb_fsdlm.sb_lvbptr =3D
> > +                     (char *)&lockres->l_lksb + sizeof(struct dlm_lksb=
);
> > +}
> > +
> >  static int ocfs2_dlm_seq_show(struct seq_file *m, void *v)
> >  {
> >       int i;
> > @@ -3191,6 +3207,7 @@ static int ocfs2_dlm_seq_show(struct seq_file *m,=
 void *v)
> >                  lockres->l_blocking);
> >
> >       /* Dump the raw LVB */
> > +     ocfs2_dlm_seq_rebase_lvb(lockres);
> >       lvb =3D ocfs2_dlm_lvb(&lockres->l_lksb);
> >       for(i =3D 0; i < DLM_LVB_LEN; i++)
> >               seq_printf(m, "0x%x\t", lvb[i]);
>
