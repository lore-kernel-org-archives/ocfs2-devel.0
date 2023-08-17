Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B9F1400C
	for <ocfs2-devel@lists.linux.dev>; Thu, 17 Aug 2023 13:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692277342;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CmwH07w5fyy3pvNX0bl7s81W4p0ZB0NuiFuXPpkj2yY=;
	b=XKDeC/tjFZSulj+OSmWwKXhh2JrWmdB/evdgn6V2ld3ucOft7TfsyjCyrnG8/xw9UqBk2a
	wazWCg3vxdqBSSdqX0zF4Rk5Qbc6LDHucpD0NPMEz6J5CV9ouDm+wPLA5O0g6wloNx6wFp
	XP5ruu1nlRH4hYCeGLCyI2q5KkckGIA=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-130-jIWgFM2iN4K1i77yrC2HKA-1; Thu, 17 Aug 2023 09:02:21 -0400
X-MC-Unique: jIWgFM2iN4K1i77yrC2HKA-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-4fe27502459so7525455e87.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 17 Aug 2023 06:02:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692277339; x=1692882139;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CmwH07w5fyy3pvNX0bl7s81W4p0ZB0NuiFuXPpkj2yY=;
        b=iDfymeDyGDoQB6gtYEGKlvuEeqPBBeZXHHAHhr/LKc6EdZbeiB7lXuiVs+3Tss24AJ
         7vjJ+HPwIWQSgqlkm8cxp5wcW28nnli8X28ki4yBBQ4sFGazcV9j5FII94MMO/+kZ4BB
         Tx3BpL3qABehzLNDbMaRxTKnaz71uP2KaHGvJBBonQ6vQb8iopwbPalVEwrWbTwjHZZR
         omi8GyUdUy3Ii/eI9DbonTOg7jUAColnnCopeIJOAriGr/NGI0c8S/1/w34IN14oIMiy
         l6JpdF/ivmJTrOIaSNb+t096FtUIcNom+t5cmE7+3PGfLd/8fdURz5/8xXDBiqPKJ4Yx
         7S9A==
X-Gm-Message-State: AOJu0Yyb/jH4vPWKBBEZ5E6aWYBAyV5t+IgmI5I5FUX9x+r2FkdWANCc
	ssg0YAE6nj4hjo73DkdzU1dZ48mM71y7YgXJPNz9KDgUgdMh9wYoWz/8qLi5ZLTAYf/yaVQHbot
	IWVhKhMfS9VZ54bDpLpNPjgsIAkVBZ5cLSeew7N4=
X-Received: by 2002:a05:6512:2149:b0:4fc:3756:754e with SMTP id s9-20020a056512214900b004fc3756754emr3620824lfr.56.1692277339113;
        Thu, 17 Aug 2023 06:02:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHF/W240XLQ+e6Phb4JU0Im3xg6glWU3oArtomKJAuH6Nr56XJ4O+HytbRYxjpPEyRvYX5BslhfhJT54YxNc5Y=
X-Received: by 2002:a05:6512:2149:b0:4fc:3756:754e with SMTP id
 s9-20020a056512214900b004fc3756754emr3620800lfr.56.1692277338728; Thu, 17 Aug
 2023 06:02:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230814211116.3224759-1-aahringo@redhat.com> <20230814211116.3224759-7-aahringo@redhat.com>
 <bd76489a6b0d2f56f4a68d48b3736fcaf5b5119b.camel@kernel.org>
 <CAK-6q+i3oKN3M_kdoQ99hMnzSZyRH1sPdxZ0MQMwp+vSixUhwg@mail.gmail.com> <bb8806020ade39f6db9d209b0a4a34dc4d69bdb8.camel@kernel.org>
In-Reply-To: <bb8806020ade39f6db9d209b0a4a34dc4d69bdb8.camel@kernel.org>
From: Alexander Aring <aahringo@redhat.com>
Date: Thu, 17 Aug 2023 09:02:06 -0400
Message-ID: <CAK-6q+jNceDDJwJK6as6TKvaRoFaxmuWao=gnbLGjTiwHbywXA@mail.gmail.com>
Subject: Re: [RFCv2 6/7] dlm: use FL_SLEEP to check if blocking request
To: Jeff Layton <jlayton@kernel.org>
Cc: linux-nfs@vger.kernel.org, cluster-devel@redhat.com, 
	ocfs2-devel@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	teigland@redhat.com, rpeterso@redhat.com, agruenba@redhat.com, 
	trond.myklebust@hammerspace.com, anna@kernel.org, chuck.lever@oracle.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Aug 17, 2023 at 7:27=E2=80=AFAM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> On Wed, 2023-08-16 at 21:19 -0400, Alexander Aring wrote:
> > Hi,
> >
> > On Wed, Aug 16, 2023 at 9:07=E2=80=AFAM Jeff Layton <jlayton@kernel.org=
> wrote:
> > >
> > > On Mon, 2023-08-14 at 17:11 -0400, Alexander Aring wrote:
> > > > This patch uses the FL_SLEEP flag in struct file_lock to check if i=
t's a
> > > > blocking request in case if the request coming from nfs lockd proce=
ss
> > > > indicated by lm_grant() is set.
> > > >
> > > > IF FL_SLEEP is set a asynchronous blocking request is being made an=
d
> > > > it's waiting for lm_grant() callback being called to signal the loc=
k was
> > > > granted. If it's not set a synchronous non-blocking request is bein=
g made.
> > > >
> > > > Signed-off-by: Alexander Aring <aahringo@redhat.com>
> > > > ---
> > > >  fs/dlm/plock.c | 38 ++++++++++++++++++++++----------------
> > > >  1 file changed, 22 insertions(+), 16 deletions(-)
> > > >
> > > > diff --git a/fs/dlm/plock.c b/fs/dlm/plock.c
> > > > index 0094fa4004cc..524771002a2f 100644
> > > > --- a/fs/dlm/plock.c
> > > > +++ b/fs/dlm/plock.c
> > > > @@ -140,7 +140,6 @@ int dlm_posix_lock(dlm_lockspace_t *lockspace, =
u64 number, struct file *file,
> > > >       op->info.optype         =3D DLM_PLOCK_OP_LOCK;
> > > >       op->info.pid            =3D fl->fl_pid;
> > > >       op->info.ex             =3D (fl->fl_type =3D=3D F_WRLCK);
> > > > -     op->info.wait           =3D IS_SETLKW(cmd);
> > > >       op->info.fsid           =3D ls->ls_global_id;
> > > >       op->info.number         =3D number;
> > > >       op->info.start          =3D fl->fl_start;
> > > > @@ -148,24 +147,31 @@ int dlm_posix_lock(dlm_lockspace_t *lockspace=
, u64 number, struct file *file,
> > > >       op->info.owner =3D (__u64)(long)fl->fl_owner;
> > > >       /* async handling */
> > > >       if (fl->fl_lmops && fl->fl_lmops->lm_grant) {
> > > > -             op_data =3D kzalloc(sizeof(*op_data), GFP_NOFS);
> > > > -             if (!op_data) {
> > > > -                     dlm_release_plock_op(op);
> > > > -                     rv =3D -ENOMEM;
> > > > -                     goto out;
> > > > -             }
> > > > +             if (fl->fl_flags & FL_SLEEP) {
> > > > +                     op_data =3D kzalloc(sizeof(*op_data), GFP_NOF=
S);
> > > > +                     if (!op_data) {
> > > > +                             dlm_release_plock_op(op);
> > > > +                             rv =3D -ENOMEM;
> > > > +                             goto out;
> > > > +                     }
> > > >
> > > > -             op_data->callback =3D fl->fl_lmops->lm_grant;
> > > > -             locks_init_lock(&op_data->flc);
> > > > -             locks_copy_lock(&op_data->flc, fl);
> > > > -             op_data->fl             =3D fl;
> > > > -             op_data->file   =3D file;
> > > > +                     op->info.wait =3D 1;
> > > > +                     op_data->callback =3D fl->fl_lmops->lm_grant;
> > > > +                     locks_init_lock(&op_data->flc);
> > > > +                     locks_copy_lock(&op_data->flc, fl);
> > > > +                     op_data->fl             =3D fl;
> > > > +                     op_data->file   =3D file;
> > > >
> > > > -             op->data =3D op_data;
> > > > +                     op->data =3D op_data;
> > > >
> > > > -             send_op(op);
> > > > -             rv =3D FILE_LOCK_DEFERRED;
> > > > -             goto out;
> > > > +                     send_op(op);
> > > > +                     rv =3D FILE_LOCK_DEFERRED;
> > > > +                     goto out;
> > >
> > > A question...we're returning FILE_LOCK_DEFERRED after the DLM request=
 is
> > > sent. If it ends up being blocked, what happens? Does it do a lm_gran=
t
> > > downcall with -EAGAIN or something as the result?
> > >
> >
> > no, when info->wait is set then it is a blocked lock request, which
> > means lm_grant() will be called when the lock request is granted.
> >
>
> Ok, that's probably problematic with the current code too. lockd will
> time out the block after 7s, so if the lock isn't granted in that time
> it'll give up on it.
>

that's why blocked lock requests (meaning F_SETLKW, FL_SLEEP is set)
need to use NLM_NEVER? It will never give up on it.

I thought NLM_TIMEOUT is just the polling frequency for doing a
blocked request by doing non-blocking requests. Means trylocks in a
loop with a polling frequency.

> > >
> > > > +             } else {
> > > > +                     op->info.wait =3D 0;
> > > > +             }
> > > > +     } else {
> > > > +             op->info.wait =3D IS_SETLKW(cmd);
> > > >       }
> > > >
> > > >       send_op(op);
> > >
> > > Looks reasonable overall.
> > >
> > > Now that I look, we have quite a number of places in the kernel that
> > > seem to check for F_SETLKW, when what they really want is to check
> > > FL_SLEEP.
> >
> > Yes, so far I understand FL_SLEEP is F_SETLKW when you get only
> > F_SETLK in case of fl->fl_lmops && fl->fl_lmops->lm_grant is true. It
> > is confusing but this is how it works... if it's not set we will get
> > F_SETLKW and this should imply FL_SLEEP is set.
> >
> >
>
> Yeah. Might be good to consider how to make this more consistent across
> the kernel.

ok. I will do some grep and try to find those places.

- Alex

