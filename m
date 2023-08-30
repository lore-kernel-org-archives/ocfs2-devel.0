Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA425539C
	for <ocfs2-devel@lists.linux.dev>; Wed, 30 Aug 2023 12:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693399148;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v2sZJy7coZxAVZRyjBbEYGHy7Fw4aLyn9Mmqx4qqxfs=;
	b=WPsERkRm4a330G0taRSjAVNgtKTx/F//CWQqQuzlqfLn3gklJU/fljdPAHuAVVNkGYSnRf
	ldqDcOyr9IND5aAVbh8pZfJiRV1IRTOb3NnzT6KxuUf9Zv/k2Cune+MdQg+VQW6+oNxG+K
	E5O99/QTka2dFUnPi2OWXHsip8V28JY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-439-64tjYFAUOrWcjVhXV75rBA-1; Wed, 30 Aug 2023 08:39:07 -0400
X-MC-Unique: 64tjYFAUOrWcjVhXV75rBA-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5231d9f9e53so4363033a12.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 30 Aug 2023 05:39:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693399146; x=1694003946;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v2sZJy7coZxAVZRyjBbEYGHy7Fw4aLyn9Mmqx4qqxfs=;
        b=ejExfHlb+X++hrmQ8I2wpWe31ah0EvSpTvuk1XFdM0jgyWqFAaxN+Y0QKaU/IvAbyN
         o3V2I1uXcTyvzFPASeYd2V3oY5RbSekBSCWgHe8Fs6HqOQ7YN0ekS30LlJGXuH+NXWyg
         HBVxHR8EpDko73l6n9Zrnum1FGb2s6Y8KyLKg//sSDDvtal57ym3TcbRIE5w2KzzbHXm
         XFZQS/2OmPJBvSqo8Ge5R4NddjEZfCKCVRnHZs52zOTwPGtJ+8UEkVoG2KpLG7ugokdM
         IyPEjh6V8CSzYQX+uTVwAi5eQi6yi42NRWoiwbuqL+yc1c92t9YR32vmJuLnZfLZWETw
         triQ==
X-Gm-Message-State: AOJu0Yy5jXmZ2BIWqiayp5yTnTZxyTMeS91x16rkTU3hlHx/FV+dzPcl
	vwR2sAseO3sStlxHXuHsj0w06+icNNGwNG9m0x+RQEliyOhCZ/7dfS0fp9MkpQX8nfNJ2sucVMa
	1Jmmvc3IBjYFfLFlmzkVCwYwuw+y1Xyb7vNJo2Ms=
X-Received: by 2002:a50:ef1a:0:b0:51b:c714:a2a1 with SMTP id m26-20020a50ef1a000000b0051bc714a2a1mr1972659eds.7.1693399146290;
        Wed, 30 Aug 2023 05:39:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGfewQayRTjS+ETA5KSggFgeSlv49VrL0zQXHu5OfkWiTGdWkUo1JPaTBQ/aMX8Dt5k7rGTtcbDWOy5lMZ3Qew=
X-Received: by 2002:a50:ef1a:0:b0:51b:c714:a2a1 with SMTP id
 m26-20020a50ef1a000000b0051bc714a2a1mr1972643eds.7.1693399146053; Wed, 30 Aug
 2023 05:39:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230823213352.1971009-1-aahringo@redhat.com> <20230823213352.1971009-7-aahringo@redhat.com>
 <9a8ead64cdd32fdad29cae3aff0bd447f33a32c2.camel@kernel.org>
In-Reply-To: <9a8ead64cdd32fdad29cae3aff0bd447f33a32c2.camel@kernel.org>
From: Alexander Aring <aahringo@redhat.com>
Date: Wed, 30 Aug 2023 08:38:54 -0400
Message-ID: <CAK-6q+i+j1TUmWGH+fdYHix5TwujH8_kuR5ayUv9h6Ah8OQecQ@mail.gmail.com>
Subject: Re: [PATCH 6/7] dlm: use FL_SLEEP to determine blocking vs non-blocking
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

On Fri, Aug 25, 2023 at 2:18=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> On Wed, 2023-08-23 at 17:33 -0400, Alexander Aring wrote:
> > This patch uses the FL_SLEEP flag in struct file_lock to determine if
> > the lock request is a blocking or non-blocking request. Before dlm was
> > using IS_SETLKW() was being used which is not usable for lock requests
> > coming from lockd when EXPORT_OP_SAFE_ASYNC_LOCK inside the export flag=
s
> > is set.
> >
> > Signed-off-by: Alexander Aring <aahringo@redhat.com>
> > ---
> >  fs/dlm/plock.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/dlm/plock.c b/fs/dlm/plock.c
> > index 0094fa4004cc..0c6ed5eeb840 100644
> > --- a/fs/dlm/plock.c
> > +++ b/fs/dlm/plock.c
> > @@ -140,7 +140,7 @@ int dlm_posix_lock(dlm_lockspace_t *lockspace, u64 =
number, struct file *file,
> >       op->info.optype         =3D DLM_PLOCK_OP_LOCK;
> >       op->info.pid            =3D fl->fl_pid;
> >       op->info.ex             =3D (fl->fl_type =3D=3D F_WRLCK);
> > -     op->info.wait           =3D IS_SETLKW(cmd);
> > +     op->info.wait           =3D !!(fl->fl_flags & FL_SLEEP);
> >       op->info.fsid           =3D ls->ls_global_id;
> >       op->info.number         =3D number;
> >       op->info.start          =3D fl->fl_start;
>
> Not sure you really need the !!, but ok...
>

The wait is a byte value and FL_SLEEP doesn't fit into it, I already
run into problems with it. I don't think somebody does a if (foo->wait
=3D=3D 1) but it should be set to 1 or 0.

An alternative would be: ((fl->fl_flags & FL_SLEEP) =3D=3D FL_SLEEP). I am
not sure what the coding style says here. I think it's more important
what the C standard says about !!(condition), but there are other
users of this in the Linux kernel. :-/

- Alex

