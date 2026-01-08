Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1B63815E3
	for <ocfs2-devel@lists.linux.dev>; Thu,  8 Jan 2026 14:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767881766; cv=none; b=lx7ts/ew174+K6N8iF1ci1cFRnMBVLL+3kO2o4G2Wed0CWnoajaNKrreg1qhuCPniWPzBwNxVA2TiPQdSEBeLSI8yOjBUB+sW7P0OQir9VuJGOZDkxJbOJGfPbclq1++/0DKHQ+ZMVQ3KecLyVgLcN0fyUj8N3tgT3r9WNnGn1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767881766; c=relaxed/simple;
	bh=OgTPF9PqnlAbVeWG+nKTzR0eNYUZi8ewJQA92WjPvEw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eQdyTFbKTKgGXAXkgAVOIGS4gHNvQ55w5Lyda3PPJyyiI+FfOppEbHyXsWQOaaSp10CeSjhG2RUjmtLkZSJ3cpL8KkaVL4ujQtJS8nIme2ndvMM7qtQip9mrmG4GEhrUprwte3aP8ZxBUKenu7qs8wu6WyEuhgIMso5y2OEr4Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K8YfQp7T; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K8YfQp7T"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6505d3b84bcso4992476a12.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 08 Jan 2026 06:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767881763; x=1768486563; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IcZCdOjv826AnPT02Kou4oSTayPR3rl7Xpc1+OQQYSo=;
        b=K8YfQp7T+baWcgIMJ3bRaPMGAHiCcbMNJbkTxfjhJjFsBRhllATETYHsBdeqJMniN2
         nXL4+F+YBySMKjOyrQJmmmbd154BYB0Fc3bCbuvOqnzKAzqwosxtMFfmqnyDiov1h6r1
         etOsxRzwyfDyK8J9/gddyxsuUiDUV4KJk3ew+tNMusQgpbz5bakhrf51siR3HM4M1PzT
         /ZsRa4E34woE3hwhW1AP9RghZWtvFUfyrvmuz4F/40133mA+iWAwXwZPhvM6lsiakhkF
         FhIznIrP3kHZEbg63K6shp46F6vawAhTfw5RIZd04TRvS60ZqQUtupYztnFbhQsrqZ4g
         qC6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767881763; x=1768486563;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IcZCdOjv826AnPT02Kou4oSTayPR3rl7Xpc1+OQQYSo=;
        b=v9JrReU0Z8G94o7Qiw7Qsk/Z9ql90l7t8b6I6nLzsOKCDkcUYkfOUgP3m0Y35vGGtJ
         KUdp8VxbeDgCzeraxAIdp8VVkr1JHLfDYN3WKpxKv5OxT3FoE5ZaL0PqzudS7KUOoKtB
         n63r4YDtlmOcZhuRp1T/KupctjIklxFBIyR8CDIoUAuMkWNJkfreqNBv3UUmfqS8hk5R
         JSqju53mTj7Ku6EpLH81x6BFK0xXunYVXZ2nYWH4PS4LEfI8+bKQWURGF+xIoj1wiq09
         QK4z+wgJCHK7YJ6zOXKjPWsCpJSsyPdn2hipYwXdraKJ5yclVRPRGbiymP8tcDDUxslv
         DYeg==
X-Gm-Message-State: AOJu0Yy+U/IDPBbTSPSBIknCIqYeAJBT6j+7UGB0R5lRH1e4CWpYG8Pk
	03HZ9E7VHS/3fSUyUXOTV3758fW1tpvLBIoMYOWa4pzDdH/FdBAo+Zy382X4WLWJ6hOa2TgTYiI
	FrpFYWU09j7ia+tUhOOWRlmCdSHYUlEQ=
X-Gm-Gg: AY/fxX4o3t1F5e0BChFfw1X0TmaMGFoaB6tlScSP8yNyLJquTXgdDLzX05ZK6yfmg4i
	giT3ABMHWznY6ldD8QhB2QGY6maRGLw2u38g1rwuSHduWbJosnky9TJUogccPrSVX9mAEZMW24d
	TTlGXR2QKEHW58Rps7oFIfDc0M1X/Cn8Sv8rQp8ICzk5U+n6R6xR1Jh1C0m/JrPvS2k71LZz0hN
	LfjGEW7/DrrdkWNwLpNP3tWfDHm/mMKWQnSl09Bs278mtI5fXzJNI5YP+mFUF7oEhRAFZ/cEg==
X-Google-Smtp-Source: AGHT+IGNPUREUN6NoCYcyDgBt+QRsle65vtRZ4YH5pgmucicJutLow5BRfNqk8B+cvKShbPR7OplPlHBMljSys/ai5U=
X-Received: by 2002:a05:6402:278f:b0:64d:3b22:a595 with SMTP id
 4fb4d7f45d1cf-65097dea481mr5894840a12.12.1767881762596; Thu, 08 Jan 2026
 06:16:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251227174251.121668-1-swilczek.lx@gmail.com> <1e0dba77-e8a3-43e2-b20c-fbac6fdc928f@linux.alibaba.com>
In-Reply-To: <1e0dba77-e8a3-43e2-b20c-fbac6fdc928f@linux.alibaba.com>
From: Szymon Wilczek <swilczek.lx@gmail.com>
Date: Thu, 8 Jan 2026 15:15:51 +0100
X-Gm-Features: AQt7F2rSFKIt9q4PZ1zVtvzvVwp_RsrOdeU0KyfqQVY0AGll81ZAXNaxYEMRgrE
Message-ID: <CAJRoVwh8LUOaFb2OcNtE3Y=LU-tmSGrkOiN43C5SiEunr_coZQ@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: fix circular locking dependency in ocfs2_acquire_dquot
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, mark@fasheh.com, jlbec@evilplan.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	syzbot+51244a05705883616c95@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

(Resending to mailing lists - apologies for the private reply)

Hi Joseph,

Thank you for the review.

You are right - my v1 patch was incomplete. Looking at the lockdep
trace again, the issue is that ocfs2_start_trans() acquires sb_internal
while holding ip_alloc_sem (taken by ocfs2_lock_global_qf). This
conflicts with freeze/dismount paths that acquire sb_internal first.

The chain reported by lockdep:
sb_internal -> sysfile_lock_key -> ip_alloc_sem

Problematic sequence was:
ip_alloc_sem (via lock_global_qf) -> sb_internal (via start_trans)

This is a lock inversion.

You correctly identified that my v1 patch left the direct
ocfs2_start_trans() call after ocfs2_lock_global_qf(), which doesn't
fix the problem.

I'm preparing a v2 patch that also moves ocfs2_start_trans() before
ocfs2_lock_global_qf() to properly fix the lock ordering.

Thanks,
Szymon

On Thu, Jan 8, 2026 at 9:43=E2=80=AFAM Joseph Qi <joseph.qi@linux.alibaba.c=
om> wrote:
>
>
>
> On 2025/12/28 01:42, Szymon Wilczek wrote:
> > Move ocfs2_extend_no_holes() to execute before ocfs2_lock_global_qf() t=
o
> > fix a circular locking dependency reported by syzbot.
> >
> > The issue occurs because ocfs2_extend_no_holes() internally calls
> > ocfs2_extend_allocation() which starts a transaction (acquiring
> > sb_start_intwrite). When called while holding the global quota file
> > lock, this conflicts with mount-time operations that acquire
>
> It seems the following locking sequence is fine:
> ocfs2_lock_global_qf -> start_trans
>
> So could you please elaborate more?
>
> > sb_internal first, creating the following circular dependency:
> >
> >   sb_internal -> ocfs2_sysfile_lock_key -> ocfs2_quota_ip_alloc_sem_key
> >
> > By moving the quota file extension before acquiring the global quota
> > file lock, we ensure that any internal transactions complete before
> > quota locks are held, breaking the circular dependency.
> >
> > Reported-by: syzbot+51244a05705883616c95@syzkaller.appspotmail.com
> > Tested-by: syzbot+51244a05705883616c95@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=3D51244a05705883616c95
> > Signed-off-by: Szymon Wilczek <swilczek.lx@gmail.com>
> > ---
> >  fs/ocfs2/quota_global.c | 26 ++++++++++++++------------
> >  1 file changed, 14 insertions(+), 12 deletions(-)
> >
> > diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
> > index e85b1ccf81be..136aaaae27f3 100644
> > --- a/fs/ocfs2/quota_global.c
> > +++ b/fs/ocfs2/quota_global.c
> > @@ -821,6 +821,19 @@ static int ocfs2_acquire_dquot(struct dquot *dquot=
)
> >       trace_ocfs2_acquire_dquot(from_kqid(&init_user_ns, dquot->dq_id),
> >                                 type);
> >       mutex_lock(&dquot->dq_lock);
> > +     /*
> > +      * Extend global quota file before acquiring global qf lock to av=
oid
> > +      * lock inversion with sb_internal (via ocfs2_start_trans).
> > +      */
> > +     if (need_alloc) {
> > +             WARN_ON(journal_current_handle());
> > +             status =3D ocfs2_extend_no_holes(gqinode, NULL,
> > +                     i_size_read(gqinode) + (need_alloc << sb->s_block=
size_bits),
> > +                     i_size_read(gqinode));
> > +             if (status < 0)
> > +                     goto out;
> > +     }
> > +
> >       /*
> >        * We need an exclusive lock, because we're going to update use c=
ount
> >        * and instantiate possibly new dquot structure
> > @@ -843,19 +856,8 @@ static int ocfs2_acquire_dquot(struct dquot *dquot=
)
> >       OCFS2_DQUOT(dquot)->dq_use_count++;
> >       OCFS2_DQUOT(dquot)->dq_origspace =3D dquot->dq_dqb.dqb_curspace;
> >       OCFS2_DQUOT(dquot)->dq_originodes =3D dquot->dq_dqb.dqb_curinodes=
;
> > -     if (!dquot->dq_off) {   /* No real quota entry? */
> > +     if (!dquot->dq_off)     /* No real quota entry? */
> >               ex =3D 1;
> > -             /*
> > -              * Add blocks to quota file before we start a transaction=
 since
> > -              * locking allocators ranks above a transaction start
> > -              */
> > -             WARN_ON(journal_current_handle());
> > -             status =3D ocfs2_extend_no_holes(gqinode, NULL,
> > -                     i_size_read(gqinode) + (need_alloc << sb->s_block=
size_bits),
> > -                     i_size_read(gqinode));
> > -             if (status < 0)
> > -                     goto out_dq;
> > -     }
> >
> >       handle =3D ocfs2_start_trans(osb,
> >                                  ocfs2_calc_global_qinit_credits(sb, ty=
pe));
>
> BTW, even if your analysis is right, here also calls ocfs2_start_trans().
>
> Thanks,
> Joseph
>
