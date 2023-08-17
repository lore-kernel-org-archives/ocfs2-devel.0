Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969D21805C
	for <ocfs2-devel@lists.linux.dev>; Thu, 17 Aug 2023 18:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692297557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kd4TYVvwU1aUt0kyKry2n2j6BSVfouTESoEkR9Nhxgo=;
	b=aVqj3y+DDBcJyB/tKrfnM3HaG0O6HtxLa5V1HEI4UFASSB2+pW8TCtsesUebR3X7cs3VRN
	Dyj7uuI86j6OXPD+oFzcI/7Z3gw+NWRiiN7MUhavf6R4PpLclii6+Mx69oL9wCR0JtE857
	+boCSYH5ngZ8Jp91zgqxSWQxSJM6QlM=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-524-DyMOOxRqPOObwYrT_w8OFw-1; Thu, 17 Aug 2023 14:39:13 -0400
X-MC-Unique: DyMOOxRqPOObwYrT_w8OFw-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-4fe8771657dso13574e87.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 17 Aug 2023 11:39:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692297552; x=1692902352;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kd4TYVvwU1aUt0kyKry2n2j6BSVfouTESoEkR9Nhxgo=;
        b=gVI71t5n/1LsaAnwAETzzcABjKiuYSSDnFWJ8wSmvUlewYUaoPhFkdz+WMMlmgCrpz
         pGicMtZW+WQhOeyvkq7TNASaeylRWVoITP/aRSzTXnGd1+QQq07uDfcT61IEpY3bdlJP
         qBytSX5ukifYlrpwk+dPPubJvIa25ioiNRG4xrj+pcPxn06HomBwgsT6zeNRVdXpxdl2
         O+S29af1ijUYFEmRliqvYY/0bcXBPCa3XWAp1CR+47NCE4PXu7v/HphcfglbZsZvjzyO
         gmDZpQr2CGjTa+DB+hZl3zrZA3/tN6dbM2du/zdeGF7EOgcNLUr6qtvvfONOwqidqQBJ
         3lMQ==
X-Gm-Message-State: AOJu0YzINJaUQ9UkLeMlULnonmAWPnP6gM6zm+hLB/HOdnCfpet5Dl9W
	+tPpbqFBu5Kt2yXGvAyluTTJcg+QGQ5HviQSyoQNkDpB9kLcqa2w3eGkMj8HZMq4x8K4eUpOxs4
	XnUKo4GAjYdfsq6KZ+VyCOhsS7UcFMv/JKcaTfVQ=
X-Received: by 2002:a19:4359:0:b0:4f8:d385:41bd with SMTP id m25-20020a194359000000b004f8d38541bdmr110677lfj.8.1692297552323;
        Thu, 17 Aug 2023 11:39:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGJHRFT1siW8UZCQGrmU6uj/U7AnLGRKgBpAukshZ1dxmC1RXgn+gE5RQG2Zb/ahcVSaEaUTXYhxNQeTDbt5jg=
X-Received: by 2002:a19:4359:0:b0:4f8:d385:41bd with SMTP id
 m25-20020a194359000000b004f8d38541bdmr110668lfj.8.1692297551910; Thu, 17 Aug
 2023 11:39:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230814211116.3224759-1-aahringo@redhat.com> <20230814211116.3224759-2-aahringo@redhat.com>
 <c049f33344990f74c2b88cc3279a913f6ff6f498.camel@kernel.org> <350395c8906f46ec4634392adb8a9e3927763ef1.camel@kernel.org>
In-Reply-To: <350395c8906f46ec4634392adb8a9e3927763ef1.camel@kernel.org>
From: Alexander Aring <aahringo@redhat.com>
Date: Thu, 17 Aug 2023 14:39:00 -0400
Message-ID: <CAK-6q+iB9AWqbe-cJfHi=nRAsdxXQ_KjpZLd4Hsj1VEtj8CNHQ@mail.gmail.com>
Subject: Re: [RFCv2 1/7] lockd: fix race in async lock request handling
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

On Tue, Aug 15, 2023 at 2:21=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> On Tue, 2023-08-15 at 13:49 -0400, Jeff Layton wrote:
> > On Mon, 2023-08-14 at 17:11 -0400, Alexander Aring wrote:
> > > This patch fixes a race in async lock request handling between adding
> > > the relevant struct nlm_block to nlm_blocked list after the request w=
as
> > > sent by vfs_lock_file() and nlmsvc_grant_deferred() does a lookup of =
the
> > > nlm_block in the nlm_blocked list. It could be that the async request=
 is
> > > completed before the nlm_block was added to the list. This would end
> > > in a -ENOENT and a kernel log message of "lockd: grant for unknown
> > > block".
> > >
> > > To solve this issue we add the nlm_block before the vfs_lock_file() c=
all
> > > to be sure it has been added when a possible nlmsvc_grant_deferred() =
is
> > > called. If the vfs_lock_file() results in an case when it wouldn't be
> > > added to nlm_blocked list, the nlm_block struct will be removed from
> > > this list again.
> > >
> > > The introducing of the new B_PENDING_CALLBACK nlm_block flag will han=
dle
> > > async lock requests on a pending lock requests as a retry on the call=
er
> > > level to hit the -EAGAIN case.
> > >
> > > Signed-off-by: Alexander Aring <aahringo@redhat.com>
> > > ---
> > >  fs/lockd/svclock.c          | 100 ++++++++++++++++++++++++++--------=
--
> > >  include/linux/lockd/lockd.h |   2 +
> > >  2 files changed, 74 insertions(+), 28 deletions(-)
> > >
> > >
>
> [...]
>
> > > diff --git a/include/linux/lockd/lockd.h b/include/linux/lockd/lockd.=
h
> > > index f42594a9efe0..91f55458f5fc 100644
> > > --- a/include/linux/lockd/lockd.h
> > > +++ b/include/linux/lockd/lockd.h
> > > @@ -185,10 +185,12 @@ struct nlm_block {
> > >     struct nlm_file *       b_file;         /* file in question */
> > >     struct cache_req *      b_cache_req;    /* deferred request handl=
ing */
> > >     struct cache_deferred_req * b_deferred_req
> > > +   struct mutex            b_cb_mutex;     /* callback mutex */
> >
> > There is no mention at all of this new mutex in the changelog or
> > comments. It's not at all clear to me what this is intended to protect.
> > In general, with lockd being a single-threaded service, we want to avoi=
d
> > sleeping locks. This will need some clear justification.
> >
> > At a glance, it looks like you're trying to use this to hold
> > B_PENDING_CALLBACK steady while a lock request is being handled. That
> > suggests that you're using this mutex to serialize access to a section
> > of code and not one or more specific data structures. We usually like t=
o
> > avoid that sort of thing, since locks that protect arbitrary sections o=
f
> > code become difficult to work with over time.
> >
> > I'm going to go out on a limb here though and suggest that there is
> > probably a way to solve this problem that doesn't involve adding new
> > locks.
> >
> > >     unsigned int            b_flags;        /* block flags */
> > >  #define B_QUEUED           1       /* lock queued */
> > >  #define B_GOT_CALLBACK             2       /* got lock or conflictin=
g lock */
> > >  #define B_TIMED_OUT                4       /* filesystem too slow to=
 respond */
> > > +#define B_PENDING_CALLBACK 8       /* pending callback for lock requ=
est */
> > >  };
> > >
> > >  /*
> >
> > Do we need this new flag at all? It seems redundant. If we have a block
> > on the list, then it is sort of by definition "pending callback". If
> > it's not on the list anymore, then it's not. No?
> >
>
> Do we need anything more than a patch along these lines? Note that this
> is untested, so RFC:
>
> ---------------------8<-----------------------
>
> [RFC PATCH] lockd: alternate fix for race between deferred lock and grant
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/lockd/svclock.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
> index c43ccdf28ed9..e9a84363c26e 100644
> --- a/fs/lockd/svclock.c
> +++ b/fs/lockd/svclock.c
> @@ -446,6 +446,8 @@ nlmsvc_defer_lock_rqst(struct svc_rqst *rqstp, struct=
 nlm_block *block)
>
>         block->b_flags |=3D B_QUEUED;
>
> +       /* FIXME: remove and reinsert w/o dropping spinlock */
> +       nlmsvc_remove_block(block);
>         nlmsvc_insert_block(block, NLM_TIMEOUT);
>

a insert should just be okay, because there is an atomic switch if
it's already part of nlm_blocked and it will just update the timeout
of nlm_block in the list and it's order (because nlm_blocked is kind
of sorted according their timeouts in nlm_blocked).

>         block->b_cache_req =3D &rqstp->rq_chandle;
> @@ -535,6 +537,9 @@ nlmsvc_lock(struct svc_rqst *rqstp, struct nlm_file *=
file,
>         if (!wait)
>                 lock->fl.fl_flags &=3D ~FL_SLEEP;
>         mode =3D lock_to_openmode(&lock->fl);
> +
> +       /* Append to list of blocked */
> +       nlmsvc_insert_block(block, NLM_NEVER);
>         error =3D vfs_lock_file(file->f_file[mode], F_SETLK, &lock->fl, N=
ULL);
>         lock->fl.fl_flags &=3D ~FL_SLEEP;
>
> @@ -542,6 +547,7 @@ nlmsvc_lock(struct svc_rqst *rqstp, struct nlm_file *=
file,
>         switch (error) {
>                 case 0:
>                         ret =3D nlm_granted;
> +                       nlmsvc_remove_block(block);
>                         goto out;
>                 case -EAGAIN:
>                         /*
> @@ -552,6 +558,7 @@ nlmsvc_lock(struct svc_rqst *rqstp, struct nlm_file *=
file,
>                         if (wait)
>                                 break;
>                         ret =3D async_block ? nlm_lck_blocked : nlm_lck_d=
enied;
> +                       nlmsvc_remove_block(block);
>                         goto out;
>                 case FILE_LOCK_DEFERRED:
>                         if (wait)
> @@ -570,8 +577,6 @@ nlmsvc_lock(struct svc_rqst *rqstp, struct nlm_file *=
file,
>
>         ret =3D nlm_lck_blocked;
>
> -       /* Append to list of blocked */
> -       nlmsvc_insert_block(block, NLM_NEVER);

ok. I will try to start with that.

- Alex

