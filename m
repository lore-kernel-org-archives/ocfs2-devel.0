Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1738379
	for <ocfs2-devel@lists.linux.dev>; Thu, 17 Aug 2023 01:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692235441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XjasKeXZqylsbZptWllQNMerqPBUwmOArgVba6SAq8Q=;
	b=AYb2uIcb1ca7+EYAEdCrRVQ4XqVdYfRhoFydnamNpb1znZ1ZKnzLcNhSepIPNzkKsZOB8Z
	kgzAYJHBFFBEuhG6YOdvODFziL/zso2UJRbGcgEIdo/QVUw0XQN4BijSoXmGRxDFhfA3Yd
	WEAg2C+qlmfm+4RvqNpsdgpSbr6Ld90=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-466-7kG0ovCaMtCpnGYQZuzTLQ-1; Wed, 16 Aug 2023 21:24:00 -0400
X-MC-Unique: 7kG0ovCaMtCpnGYQZuzTLQ-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5256fdb3e20so1745511a12.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 16 Aug 2023 18:23:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692235439; x=1692840239;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XjasKeXZqylsbZptWllQNMerqPBUwmOArgVba6SAq8Q=;
        b=hpjFDziBdUlaCkv6d0eqRvoaclcI7KB6syRnArRefrXZ121AhDZE4BRBxzkm2AVHkS
         it7k8hicYRwPm5/1gTITr94k7P/4NNAsS6+YS7Y4cCw6mNb+bPcHSjvnGww6KZtcksoH
         n6e4Cj1h61GWoy5MVCyB8tVKI/6chg/kXY4+iMr7Cgo66qxhwRiWaBghI+NP2FQG2Niv
         CTro9J0KMr2lsOlkLiow14XmXDnlEsqT+hc9XUHg3hQAxswxDLAgpfAHNON6VFG8/psV
         2yS3ndAqxmYpHttawY2jiVSfj0t2+2r1evmECR4O8NFMQDY4QcOBPLMv8Izbt5whxqr4
         ZWkw==
X-Gm-Message-State: AOJu0YzvCZ943BonAoU3KKZYc/QHIF2ZyxzO/fRdYv7SB96ZC5aeo5jM
	QEsmFV0KdESBv4gOEsxNgtOC6gJUszN+UUc+KPb7E5jE8S8pNYyXzBQ2t1bnWombOLE+4zeo/9g
	ih2jl6GQ+RBrx0tTF4vDDMX9JkcDPHGElMli1Ehk=
X-Received: by 2002:aa7:c545:0:b0:524:5e4c:2fa4 with SMTP id s5-20020aa7c545000000b005245e4c2fa4mr2839454edr.14.1692235438944;
        Wed, 16 Aug 2023 18:23:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGXDmfKQ7ys1l6lXBj07FDJ7WlcIO7oafTPjac90Yx5immK+W1gBVjH7vhGznIaT59kMvjiA8PZ+Qat0vf3KLE=
X-Received: by 2002:aa7:c545:0:b0:524:5e4c:2fa4 with SMTP id
 s5-20020aa7c545000000b005245e4c2fa4mr2839440edr.14.1692235438645; Wed, 16 Aug
 2023 18:23:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230814211116.3224759-1-aahringo@redhat.com> <20230814211116.3224759-5-aahringo@redhat.com>
 <ca18531b54306d27218daf8e90b72ef3a4b8e44f.camel@kernel.org>
In-Reply-To: <ca18531b54306d27218daf8e90b72ef3a4b8e44f.camel@kernel.org>
From: Alexander Aring <aahringo@redhat.com>
Date: Wed, 16 Aug 2023 21:23:47 -0400
Message-ID: <CAK-6q+iTe86JKqeEsfUanwmu6wOxz=CqL_H_NEiq2vZ8PwcWQA@mail.gmail.com>
Subject: Re: [RFCv2 4/7] locks: update lock callback documentation
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

On Wed, Aug 16, 2023 at 8:01=E2=80=AFAM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> On Mon, 2023-08-14 at 17:11 -0400, Alexander Aring wrote:
> > This patch updates the existing documentation regarding recent changes
> > to vfs_lock_file() and lm_grant() is set. In case of lm_grant() is set
> > we only handle FILE_LOCK_DEFERRED in case of FL_SLEEP in fl_flags is no=
t
> > set. This is the case of an blocking lock request. Non-blocking lock
> > requests, when FL_SLEEP is not set, are handled in a synchronized way.
> >
> > Signed-off-by: Alexander Aring <aahringo@redhat.com>
> > ---
> >  fs/locks.c | 28 ++++++++++++++--------------
> >  1 file changed, 14 insertions(+), 14 deletions(-)
> >
> > diff --git a/fs/locks.c b/fs/locks.c
> > index df8b26a42524..a8e51f462b43 100644
> > --- a/fs/locks.c
> > +++ b/fs/locks.c
> > @@ -2255,21 +2255,21 @@ int fcntl_getlk(struct file *filp, unsigned int=
 cmd, struct flock *flock)
> >   * To avoid blocking kernel daemons, such as lockd, that need to acqui=
re POSIX
> >   * locks, the ->lock() interface may return asynchronously, before the=
 lock has
> >   * been granted or denied by the underlying filesystem, if (and only i=
f)
> > - * lm_grant is set. Callers expecting ->lock() to return asynchronousl=
y
> > - * will only use F_SETLK, not F_SETLKW; they will set FL_SLEEP if (and=
 only if)
> > - * the request is for a blocking lock. When ->lock() does return async=
hronously,
> > - * it must return FILE_LOCK_DEFERRED, and call ->lm_grant() when the l=
ock
> > - * request completes.
> > - * If the request is for non-blocking lock the file system should retu=
rn
> > - * FILE_LOCK_DEFERRED then try to get the lock and call the callback r=
outine
> > - * with the result. If the request timed out the callback routine will=
 return a
> > + * lm_grant and FL_SLEEP in fl_flags is set. Callers expecting ->lock(=
) to return
> > + * asynchronously will only use F_SETLK, not F_SETLKW; When ->lock() d=
oes return
>
> Isn't the above backward? Shouldn't it say "Callers expecting ->lock()
> to return asynchronously will only use F_SETLKW, not F_SETLK" ?
>

So far I know lockd will always use F_SETLK only, if it's a blocking
or non-blocking request you need to evaluate FL_SLEEP. But if
lm_grant() is not set we are using a check on cmd if it's F_SETLK or
F_SETLKW to check if it's non-blocking or blocking.

If lm_grant() is set and checking on F_SETLKW should never be the
case, because it will never be true (speaking from lockd point of
view).

- Alex

