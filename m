Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30EC54905
	for <ocfs2-devel@lists.linux.dev>; Tue, 26 Mar 2024 11:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711452698; cv=none; b=t7uBGo1rllQO4mAWXXWoDBEhvU61qC/WE9TOAY2ib2oCEQbNsBABB7gwnhZWFpvoxI7lbKvQoffP/jRoeJvMBEfdpESw68jBOWjGpgLdA6z1/3Sn64hDoPb8SlOALAOXOtI3SaxGP/mObb02KrUU5OgHF1Arz1rWuZS5NegN8Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711452698; c=relaxed/simple;
	bh=AWEkmPX9uFpKY4I/s0S++/9JhTG5mZhP8U/mqo78UDk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I6xygpHAwHJ5u2srdB3/l636iPWPMlFI5fQ7+9JKWoIaVWvN+b6SPsQ9n3jCBkLaPQt4xXvU+Rf+buxn5PpHMVQ1JcIwrzU1VowrqrbvqayS/VNcqh6M26Ovt3nCJq9dlkBuVzNLL/e/Pe9etm+7aP5iH8z9w6v25rxhr0RJfcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KGrg/MA4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KGrg/MA4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711452695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mhZO2i7dPLxzY6rSdjUxVSKHGdXG0M1gLvbv/HJ75vE=;
	b=KGrg/MA4qI/vrSKS3KxL4/iwBepbUxxwxNAbvmSh3Ch7DrFFoqnZrboadO+/KpFdI+jYt6
	EsMmb3VQVTKZsPwtiioSDABfGJnwuvIpSjVp5AIRhOdMwLzw0RER9zHL2aec0sCCboE4og
	85bML/Y9WjpsUe2Ph1cL3ciVAafapeo=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-IY-qN_2EOgi66BJ3JqqPBA-1; Tue, 26 Mar 2024 07:31:34 -0400
X-MC-Unique: IY-qN_2EOgi66BJ3JqqPBA-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1e0a4e28c06so20093295ad.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 26 Mar 2024 04:31:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711452693; x=1712057493;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mhZO2i7dPLxzY6rSdjUxVSKHGdXG0M1gLvbv/HJ75vE=;
        b=KZCvigwTq5mJKz2UW5+/sI0QZ5t7sbfi7ln2RjCVsCVLDj4SFgZrLfA8sT6i51HGgD
         o/m0bahTi96JxNXe9YrMn+E0+aFLcIe0U15KwgWCbETju+tqncArE8A8PKPjTBiCIZX6
         nUT2pNHME+bF71/GW1dM1HQTJGRyl6tueatq/HxVDlwCW/y/sLNr3UD7fVwFgpvJPYjE
         wvvJ+5bL349sw4bc4cnCL2GHhnI5ORscUQXuz7vDvLCJAptHtnwrLWrbx5WUmfbVPUdZ
         OeZPOUoCiT07hHih70pt5YwWJw18OHFFyo/nPIuvyPCgCHNHUZYVYlKW6mSxmGCjCKtL
         gOmQ==
X-Forwarded-Encrypted: i=1; AJvYcCU5ztGYPuAM0nO6DKrnDdiA2tEYc3NRvsGqd9Q38lqg0LTfmsRtwcosvTu8wr4wIh7hMJjbhYyKnBqrTShntuteM2/78suQyI5qnQw=
X-Gm-Message-State: AOJu0YyG7ZQ8oXNEhNazdC9xH4uqEA0ul/WZeXPGkKhjSAbvzV9whqkO
	oIhR8MOTFSZph8w3CcTb95b0Y1Em0MrnTynveUIlCnrw9FcKwchrMOGhL+Vkz+EquQJjeQLZcH6
	wspvn3R1UwX5Fs9Gf14TvXtkoaxy84CwXRtt0sZonTfouwcG1ikZYwRKjlvkK0Ew+BiFZ0ePOW1
	p7h0e3SVE6DMJJMNNyE0X0lHPDD1DMKhh4NoI=
X-Received: by 2002:a17:903:2445:b0:1e0:f279:915d with SMTP id l5-20020a170903244500b001e0f279915dmr1144946pls.39.1711452693546;
        Tue, 26 Mar 2024 04:31:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE/xtdKvRAvEtxWlLj9MQf1VdmM8qe6iPnvd7QPLQXFwKO1mIm/48q5NZoY1dZHu7KLssNu+3ZtYT0mvqHYRy0=
X-Received: by 2002:a17:903:2445:b0:1e0:f279:915d with SMTP id
 l5-20020a170903244500b001e0f279915dmr1144924pls.39.1711452693201; Tue, 26 Mar
 2024 04:31:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230718180721.745569-1-aahringo@redhat.com> <20230718180721.745569-3-aahringo@redhat.com>
 <CAHc6FU7LBm6RSk_M8BqZRz0LOCmDORKj0bBWSmDjM=3_iB8guQ@mail.gmail.com> <CAK-6q+h8nUXKX0ecFXeHxc5BPONXrtfD+sOGcDgaWWuvWobTEQ@mail.gmail.com>
In-Reply-To: <CAK-6q+h8nUXKX0ecFXeHxc5BPONXrtfD+sOGcDgaWWuvWobTEQ@mail.gmail.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Tue, 26 Mar 2024 12:31:20 +0100
Message-ID: <CAHc6FU6ii3NXm-_eraNTW-UEKEuR5gr+Qi2WeefRxdxH-GJrtw@mail.gmail.com>
Subject: Re: [PATCHv3 v6.5-rc2 2/3] fs: dlm: allow to F_SETLKW getting interrupted
To: Alexander Aring <aahringo@redhat.com>
Cc: gfs2 <gfs2@lists.linux.dev>, teigland@redhat.com, mark@fasheh.com, 
	jlbec@evilplan.org, joseph.qi@linux.alibaba.com, ocfs2-devel@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 26, 2024 at 1:32=E2=80=AFAM Alexander Aring <aahringo@redhat.co=
m> wrote:
> Hi,
>
> On Mon, Mar 25, 2024 at 11:09=E2=80=AFAM Andreas Gruenbacher
> <agruenba@redhat.com> wrote:
> >
> > On Tue, Jul 18, 2023 at 8:07=E2=80=AFPM Alexander Aring <aahringo@redha=
t.com> wrote:
> > > This patch implements dlm plock F_SETLKW interruption feature. If a
> > > blocking posix lock request got interrupted in user space by a signal=
 a
> > > cancellation request for a non granted lock request to the user space
> > > lock manager will be send. The user lock manager answers either with
> > > zero or a negative errno code. A errno of -ENOENT signals that there =
is
> > > currently no blocking lock request waiting to being granted. In case =
of
> > > -ENOENT it was probably to late to request a cancellation and the
> > > pending lock got granted. In any error case we will wait until the lo=
ck
> > > is being granted as cancellation failed, this causes also that in cas=
e
> > > of an older user lock manager returning -EINVAL we will wait as
> > > cancellation is not supported which should be fine. If a user require=
s
> > > this feature the user should update dlm user space to support lock
> > > request cancellation.
> > >
> > > Signed-off-by: Alexander Aring <aahringo@redhat.com>
> > > ---
> > >  fs/dlm/plock.c                 | 56 ++++++++++++++++++++++----------=
--
> > >  include/uapi/linux/dlm_plock.h |  1 +
> > >  2 files changed, 37 insertions(+), 20 deletions(-)
> > >
> > > diff --git a/fs/dlm/plock.c b/fs/dlm/plock.c
> > > index a34f605d8505..a8ffa0760913 100644
> > > --- a/fs/dlm/plock.c
> > > +++ b/fs/dlm/plock.c
> > > @@ -74,30 +74,26 @@ static void send_op(struct plock_op *op)
> > >         wake_up(&send_wq);
> > >  }
> > >
> > > -/* If a process was killed while waiting for the only plock on a fil=
e,
> > > -   locks_remove_posix will not see any lock on the file so it won't
> > > -   send an unlock-close to us to pass on to userspace to clean up th=
e
> > > -   abandoned waiter.  So, we have to insert the unlock-close when th=
e
> > > -   lock call is interrupted. */
> > > -
> > > -static void do_unlock_close(const struct dlm_plock_info *info)
> > > +static int do_lock_cancel(const struct dlm_plock_info *orig_info)
> > >  {
> > >         struct plock_op *op;
> > > +       int rv;
> > >
> > >         op =3D kzalloc(sizeof(*op), GFP_NOFS);
> > >         if (!op)
> > > -               return;
> > > +               return -ENOMEM;
> > > +
> > > +       op->info =3D *orig_info;
> > > +       op->info.optype =3D DLM_PLOCK_OP_CANCEL;
> > > +       op->info.wait =3D 0;
> > >
> > > -       op->info.optype         =3D DLM_PLOCK_OP_UNLOCK;
> > > -       op->info.pid            =3D info->pid;
> > > -       op->info.fsid           =3D info->fsid;
> > > -       op->info.number         =3D info->number;
> > > -       op->info.start          =3D 0;
> > > -       op->info.end            =3D OFFSET_MAX;
> > > -       op->info.owner          =3D info->owner;
> > > -
> > > -       op->info.flags |=3D DLM_PLOCK_FL_CLOSE;
> > >         send_op(op);
> > > +       wait_event(recv_wq, (op->done !=3D 0));
> > > +
> > > +       rv =3D op->info.rv;
> > > +
> > > +       dlm_release_plock_op(op);
> > > +       return rv;
> > >  }
> > >
> > >  int dlm_posix_lock(dlm_lockspace_t *lockspace, u64 number, struct fi=
le *file,
> > > @@ -156,7 +152,7 @@ int dlm_posix_lock(dlm_lockspace_t *lockspace, u6=
4 number, struct file *file,
> > >         send_op(op);
> > >
> > >         if (op->info.wait) {
> > > -               rv =3D wait_event_killable(recv_wq, (op->done !=3D 0)=
);
> > > +               rv =3D wait_event_interruptible(recv_wq, (op->done !=
=3D 0));
> >
> > It seems that this patch leads to an unnecessary change in behavior
> > when a fatal signal is received (fatal_signal_pending()): before, the
> > process would terminate. Now, it will try to cancel the lock, and when
> > that fails, the process will keep waiting. In case of a fatal signal,
> > can we skip the cancelling and do what we did before?
>
> From my understanding interruptible() "reacts" on everything that is
> also killable() and returns -ERESTARTSYS on "fatal signal". I even
> tested it because wait_event_killable() has an issue, see reproducer
> [0]. The issue was that it cleans too many waiters, the other waiter
> of child in F_SETLKW was also cleared and it will never get a result
> back from dlm_controld. I fixed that with an additional check on pid
> in [1], but I have no idea about other side effects that could have
> occurred as FL_CLOSE is also being used on other parts in the DLM
> plock handling.
>
> I rechecked the behaviour with the cancellation feature and sent
> SIGKILL and the issue was gone without changing anything in user
> space. The only thing I see why it would not have the old behaviour
> (killable - that having the mentioned issue above) is that the
> dlm_controld version is too old. To not run into this known issue we
> just do a wait_event() that does not have those issues.
>
> The mentioned "cancellation fails" - is not that it failed to cancel
> the lock, there is some unexpected behaviour of dlm_controld, only
> then we do wait_event() e.g. when we receive -EINVAL because
> dlm_controld does not understand the op.

What happens on a system that has this kernel change, but doesn't have
the corresponding dlm_controld change for DLM_PLOCK_OP_CANCEL support?
In this scenario, when a process is killed with SIGKILL, the kernel
will send a DLM_PLOCK_OP_CANCEL request to dlm_controld. dlm_controld
doesn't understand the DLM_PLOCK_OP_CANCEL request, so I assume that
it will return a value other than 0 or -ENOENT. As a consequence, we
will end up in wait_event(), which isn't interruptible. So before this
kernel change, the process would be killable, but with this kernel
change, it isn't killable anymore.

I'm worried about this scenario because it isn't entirely unrealistic
for a system to end up with this kernel change but without the
corresponding user-space change.

Andreas

