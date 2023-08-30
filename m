Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21891FBB
	for <ocfs2-devel@lists.linux.dev>; Wed, 30 Aug 2023 12:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693398777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Erz6cxRhavR+eFjn2ml7y6CKu0btp/kDCdMoxTnwygw=;
	b=BZ6SB89aplU8TZnHKIAyhPyVxMz3gPiseXIHXzcZAxBgzQmaL/IdED7K9MlaQwdGm63KWB
	gleYc/X1Ol6+WUQAAiFMJkxu023X2ElrDR5wxDeIFn6uJ+iJZeAZ0edJ4ZgjpbJenmK7jv
	wAeuippit7ULrmyQubXn6IYCpFd4PS8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-328-T4qCH9ttOaagfpUlnOOrNw-1; Wed, 30 Aug 2023 08:32:56 -0400
X-MC-Unique: T4qCH9ttOaagfpUlnOOrNw-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5256fdb3e20so3933140a12.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 30 Aug 2023 05:32:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693398775; x=1694003575;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Erz6cxRhavR+eFjn2ml7y6CKu0btp/kDCdMoxTnwygw=;
        b=CTY3Z/3jtnVNgWn9DrQFCBw7LCPbCd0D10xfX/H7IEpKd0TFV/gxgKiQSvI0J9oeuM
         5G0ucMPhC45WMzzL7TwTn1o5rDWNSdTrBw3SxI7sByfN6cMr7iF3TJH8ns2HRrhXSLZ5
         4SCh1ZIliWeeF32GtRCnoLf73vxRpNVGMwdwB2NWthmSrd7l8q4BbWPlbVPWYEV2J642
         6z6AbC99tzA5d7RdI2x62FY3Ig6BAIx21MszMKYt5rWotvxwJTE/r+4NSVhPDCTw13kv
         C0LzBixSLeAxuJ2UKI4f90OqK1n0milgYlrkdKWKvax1O+vruego5BmX1jABjZusyodX
         e9Gw==
X-Gm-Message-State: AOJu0YwlXEg0lpwXrOexiOpRneeMSw/aLYmpBcDETSgqgRdNAKJpqdgh
	lMLD9hLI9iS221oi76EJPubB+tKjz3ApsYTWngIXJe9cSbT4CtqlqSGAbcQAufFI6N0V8AmbxTP
	yQ7VZCAY7I3ehx0YpYTeNlep7W+2RWlsw86/5iEs=
X-Received: by 2002:a05:6402:34b:b0:525:69ec:e1c8 with SMTP id r11-20020a056402034b00b0052569ece1c8mr1447418edw.40.1693398774989;
        Wed, 30 Aug 2023 05:32:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFVR4gqrbUrIqm3ap2wmzJ9x7oRy05/4CnWXfkWg6XD8Hi7Lbv3su/CkWBYl1dmyacqR/LenFtmecm6xJF5+nI=
X-Received: by 2002:a05:6402:34b:b0:525:69ec:e1c8 with SMTP id
 r11-20020a056402034b00b0052569ece1c8mr1447405edw.40.1693398774678; Wed, 30
 Aug 2023 05:32:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230823213352.1971009-1-aahringo@redhat.com> <20230823213352.1971009-2-aahringo@redhat.com>
 <ZOjjB0XeUraoSJru@tissot.1015granger.net>
In-Reply-To: <ZOjjB0XeUraoSJru@tissot.1015granger.net>
From: Alexander Aring <aahringo@redhat.com>
Date: Wed, 30 Aug 2023 08:32:43 -0400
Message-ID: <CAK-6q+igvE4y-jEvdrjJHW_PnnATtcZGzCkTzp41dFBhynE+Fw@mail.gmail.com>
Subject: Re: [PATCH 1/7] lockd: introduce safe async lock op
To: Chuck Lever <chuck.lever@oracle.com>
Cc: linux-nfs@vger.kernel.org, cluster-devel@redhat.com, 
	ocfs2-devel@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	teigland@redhat.com, rpeterso@redhat.com, agruenba@redhat.com, 
	trond.myklebust@hammerspace.com, anna@kernel.org, jlayton@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Aug 25, 2023 at 1:21=E2=80=AFPM Chuck Lever <chuck.lever@oracle.com=
> wrote:
>
> On Wed, Aug 23, 2023 at 05:33:46PM -0400, Alexander Aring wrote:
> > This patch reverts mostly commit 40595cdc93ed ("nfs: block notification
> > on fs with its own ->lock") and introduces an EXPORT_OP_SAFE_ASYNC_LOCK
> > export flag to signal that the "own ->lock" implementation supports
> > async lock requests. The only main user is DLM that is used by GFS2 and
> > OCFS2 filesystem. Those implement their own lock() implementation and
> > return FILE_LOCK_DEFERRED as return value. Since commit 40595cdc93ed
> > ("nfs: block notification on fs with its own ->lock") the DLM
> > implementation were never updated. This patch should prepare for DLM
> > to set the EXPORT_OP_SAFE_ASYNC_LOCK export flag and update the DLM
> > plock implementation regarding to it.
> >
> > Acked-by: Jeff Layton <jlayton@kernel.org>
> > Signed-off-by: Alexander Aring <aahringo@redhat.com>
> > ---
> >  fs/lockd/svclock.c       |  5 ++---
> >  fs/nfsd/nfs4state.c      | 13 ++++++++++---
> >  include/linux/exportfs.h |  8 ++++++++
> >  3 files changed, 20 insertions(+), 6 deletions(-)
>
> I'm starting to look at these. Just so you know, it's too late for
> inclusion in v6.6, but I think we can get these into shape for v6.7.
>

ok. I base my work on [0], is this correct?

> More below.
>
>
> > diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
> > index c43ccdf28ed9..6e3b230e8317 100644
> > --- a/fs/lockd/svclock.c
> > +++ b/fs/lockd/svclock.c
> > @@ -470,9 +470,7 @@ nlmsvc_lock(struct svc_rqst *rqstp, struct nlm_file=
 *file,
> >           struct nlm_host *host, struct nlm_lock *lock, int wait,
> >           struct nlm_cookie *cookie, int reclaim)
> >  {
> > -#if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
> >       struct inode            *inode =3D nlmsvc_file_inode(file);
> > -#endif
> >       struct nlm_block        *block =3D NULL;
> >       int                     error;
> >       int                     mode;
> > @@ -486,7 +484,8 @@ nlmsvc_lock(struct svc_rqst *rqstp, struct nlm_file=
 *file,
> >                               (long long)lock->fl.fl_end,
> >                               wait);
> >
> > -     if (nlmsvc_file_file(file)->f_op->lock) {
> > +     if (!export_op_support_safe_async_lock(inode->i_sb->s_export_op,
> > +                                            nlmsvc_file_file(file)->f_=
op)) {
> >               async_block =3D wait;
> >               wait =3D 0;
> >       }
> > diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
> > index 3aefbad4cc09..14ca06424ff1 100644
> > --- a/fs/nfsd/nfs4state.c
> > +++ b/fs/nfsd/nfs4state.c
> > @@ -7430,6 +7430,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_c=
ompound_state *cstate,
> >       struct nfsd4_blocked_lock *nbl =3D NULL;
> >       struct file_lock *file_lock =3D NULL;
> >       struct file_lock *conflock =3D NULL;
> > +     struct super_block *sb;
> >       __be32 status =3D 0;
> >       int lkflg;
> >       int err;
> > @@ -7451,6 +7452,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_c=
ompound_state *cstate,
> >               dprintk("NFSD: nfsd4_lock: permission denied!\n");
> >               return status;
> >       }
> > +     sb =3D cstate->current_fh.fh_dentry->d_sb;
> >
> >       if (lock->lk_is_new) {
> >               if (nfsd4_has_session(cstate))
> > @@ -7502,7 +7504,9 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_c=
ompound_state *cstate,
> >       fp =3D lock_stp->st_stid.sc_file;
> >       switch (lock->lk_type) {
> >               case NFS4_READW_LT:
> > -                     if (nfsd4_has_session(cstate))
> > +                     if (nfsd4_has_session(cstate) ||
> > +                         export_op_support_safe_async_lock(sb->s_expor=
t_op,
> > +                                                           nf->nf_file=
->f_op))
> >                               fl_flags |=3D FL_SLEEP;
> >                       fallthrough;
> >               case NFS4_READ_LT:
> > @@ -7514,7 +7518,9 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_c=
ompound_state *cstate,
> >                       fl_type =3D F_RDLCK;
> >                       break;
> >               case NFS4_WRITEW_LT:
> > -                     if (nfsd4_has_session(cstate))
> > +                     if (nfsd4_has_session(cstate) ||
> > +                         export_op_support_safe_async_lock(sb->s_expor=
t_op,
> > +                                                           nf->nf_file=
->f_op))
> >                               fl_flags |=3D FL_SLEEP;
> >                       fallthrough;
> >               case NFS4_WRITE_LT:
> > @@ -7542,7 +7548,8 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_c=
ompound_state *cstate,
> >        * for file locks), so don't attempt blocking lock notifications
> >        * on those filesystems:
> >        */
> > -     if (nf->nf_file->f_op->lock)
> > +     if (!export_op_support_safe_async_lock(sb->s_export_op,
> > +                                            nf->nf_file->f_op))
> >               fl_flags &=3D ~FL_SLEEP;
> >
> >       nbl =3D find_or_allocate_block(lock_sop, &fp->fi_fhandle, nn);
> > diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
> > index 11fbd0ee1370..10358a93cdc1 100644
> > --- a/include/linux/exportfs.h
> > +++ b/include/linux/exportfs.h
> > @@ -3,6 +3,7 @@
> >  #define LINUX_EXPORTFS_H 1
> >
> >  #include <linux/types.h>
> > +#include <linux/fs.h>
> >
> >  struct dentry;
> >  struct iattr;
> > @@ -224,9 +225,16 @@ struct export_operations {
> >                                                 atomic attribute update=
s
> >                                               */
> >  #define EXPORT_OP_FLUSH_ON_CLOSE     (0x20) /* fs flushes file data on=
 close */
> > +#define EXPORT_OP_SAFE_ASYNC_LOCK    (0x40) /* fs can do async lock re=
quest */
>
> We haven't been good about this recently, but the addition of new
> EXPORT_OP flags need to be accompanied by updates to
> Documentation/filesystems/nfs/exporting.rst.
>

ok.

> I will see about adding documentation for other recent flags, but
> please include an update to exporting.rst with this patch.
>

ok.

> I'm not sure we need _SAFE_ in the flag name. Would
> EXPORT_OP_ASYNC_LOCK be OK with you?
>

sure, a vfs_file_lock() can return FILE_LOCK_DEFERRED as well, even
without having this export flag set. How non upstream users use it, I
have no idea as it has some races.

>
> >       unsigned long   flags;
> >  };
> >
> > +static inline bool export_op_support_safe_async_lock(const struct expo=
rt_operations *export_ops,
> > +                                                  const struct file_op=
erations *f_op)
> > +{
> > +     return (export_ops->flags & EXPORT_OP_SAFE_ASYNC_LOCK) || !f_op->=
lock;
> > +}
> > +
>
> I'd like some cosmetic changes to this API, since this seems to be
> the first utility function for checking EXPORT_OP flags.
>
> - The function name is unwieldy. How about exportfs_lock_op_is_async() ?
>

ok.

> - Break up the long lines. It's OK with me if the return value type
>   is left on a different line than the function name and parameters.
>

ok.

> - This function is globally visible, so a kdoc comment is needed.
>

ok.

> - The f_op->lock check is common to all the call sites, but it is
>   not at all related to the export AFAICT. Can it be removed from
>   this inline function?
>

This flag implies it makes only sense if the filesystem has its own
lock() implementation, if it doesn't have that I guess the core fs
functions for local file locking are being used.
I guess it can be removed, but it should not be used when there is no
own ->lock() implementation, at least not now until somebody might
update the fs core functionality for local file locking to handle
blocking lock requests asynchronously.

- Alex

[0] https://git.kernel.org/pub/scm/linux/kernel/git/cel/linux.git/log/?h=3D=
nfsd-next

