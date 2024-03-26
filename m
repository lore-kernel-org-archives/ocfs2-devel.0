Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F015674BF3
	for <ocfs2-devel@lists.linux.dev>; Tue, 26 Mar 2024 13:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711458145; cv=none; b=N2ztufueZUfrLGfKHeptLOzx5bsyLVE7UGd0uyWjFjnokEw1OnYbvOeltZPOTBwaGOdHoamQ2BbtwXworj/ZA9FWX2LSTilhmoLNCMjDkU//w+ff7us6mvH9vC6IFveIk0IpUFSi4GDVwwCJjL6raXUqPbf+ib3Qn/wjZayCW4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711458145; c=relaxed/simple;
	bh=lkYGFl1rkr9Qje39cuYXFF8Mbt4uaZ9rSH17YfsBEkw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=op3dq3TsRwvE+V1dPn/76sG2HV1fbDwalVv930EWOwSwFM2XjYtWww8OimmOH5Fv49eyJwwLGxmrr0kf0Qjkz5VTmRzYXx3M5qS4HkeS45X+476+EeAD3eh1pS5NMC7lWMUHw/8axHLO9U5TcPcO4mC5fAL2bhSTmWmW7d0e+cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d40tU+/C; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d40tU+/C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711458142;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VDyXEO52B71HjtFK9o5HFFlsTx6/vyJtUl9soEHK5vs=;
	b=d40tU+/CPwBobmj4axas5BxF1UN35uBBknv2X5QexqG1zPEo+MVYzftsIrFC96UHGYG/kr
	6tNKN7Nx/p3/+maTvr2M9vSDz8rkVJK+qhopytlakNYlxQPKdoVo8gTp6Ki6NB0pIRQqva
	ORBFw97Y4n764SeMf15Q8lz/a+jU9WE=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-keygVpvzOLGl8QLwioF1ZQ-1; Tue, 26 Mar 2024 09:02:21 -0400
X-MC-Unique: keygVpvzOLGl8QLwioF1ZQ-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-515bc00320eso26770e87.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 26 Mar 2024 06:02:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711458139; x=1712062939;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VDyXEO52B71HjtFK9o5HFFlsTx6/vyJtUl9soEHK5vs=;
        b=Ux8AGv/PoUExQ/+l8TupkGdc71mD0pkZURzNU1i5UWmZSNFdI6Wg7GeguQo30VMZrP
         qwW7KiutP+fYm1yRaxRFKtRZ+oBAQfgjGrkJpF6HblgI1YDshbQ4UPfjUdjQnAjbU1gm
         gZD4FFjfnZpI4zxik1QeQarJyHR+rKhETtLNVMqRPdxiknhP94GKNxGTQhsu9ZkHnsib
         8sqGvcKqDnyzNejRmoU9ySIYEJCSSfzS1izVZ+Hr5E9E2lhVLsmffXYYVMJDUDo+deN6
         Syahd3G+wIjf5UuC8l2RFLms8t++NtpF4zuVqz3Vvb5NkYjQ8ffgqzaO+AQQkKhG2mpB
         cxYw==
X-Forwarded-Encrypted: i=1; AJvYcCUciXnYZfwTgfGb/WBryeSeqN7+zyMiWYveYtURxnJQXZcqKVA8EZKjBjC7PTBm1MLiAzwjmXdDTX0bQNOVRvStSybOVG/cWEa1CNs=
X-Gm-Message-State: AOJu0YwVGmMI4w3HF3V8HkKJaPHQbue17U9Xuddl+BxoNZQHpUK6asNp
	QqycVeDzp1IZXT7QCBR4LmdyUsTmNlXYyX9jg16qA4/PfIJwQeMCFfb3l9swWMAXfJ6XYm39POC
	INTh213ZRnKO8eLOKXIZavN6FhGsZbJdpQk+RLsrZJOeSDP7a4P5oVcMH7/LPjEQZrG/0E0K1VA
	GDBuIltVnGosQ4AS29IvrDpNSMrCESTlaFTTs=
X-Received: by 2002:a19:8c03:0:b0:513:dd84:a088 with SMTP id o3-20020a198c03000000b00513dd84a088mr614319lfd.21.1711458139657;
        Tue, 26 Mar 2024 06:02:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHk26E+u7dMAZjnk8ePIZel0i7eGW9I4bW9izli9RYMJE2XDj+WEqXD44L19ZGu55aBlSi/q5/thc84LiuzRBs=
X-Received: by 2002:a19:8c03:0:b0:513:dd84:a088 with SMTP id
 o3-20020a198c03000000b00513dd84a088mr614300lfd.21.1711458139130; Tue, 26 Mar
 2024 06:02:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230718180721.745569-1-aahringo@redhat.com> <20230718180721.745569-3-aahringo@redhat.com>
 <CAHc6FU7LBm6RSk_M8BqZRz0LOCmDORKj0bBWSmDjM=3_iB8guQ@mail.gmail.com>
 <CAK-6q+h8nUXKX0ecFXeHxc5BPONXrtfD+sOGcDgaWWuvWobTEQ@mail.gmail.com> <CAHc6FU6ii3NXm-_eraNTW-UEKEuR5gr+Qi2WeefRxdxH-GJrtw@mail.gmail.com>
In-Reply-To: <CAHc6FU6ii3NXm-_eraNTW-UEKEuR5gr+Qi2WeefRxdxH-GJrtw@mail.gmail.com>
From: Alexander Aring <aahringo@redhat.com>
Date: Tue, 26 Mar 2024 09:02:07 -0400
Message-ID: <CAK-6q+hUwaumWfXHktsxxzDtGHx-JeCGqxBjSBbYPf8bMHB+Ew@mail.gmail.com>
Subject: Re: [PATCHv3 v6.5-rc2 2/3] fs: dlm: allow to F_SETLKW getting interrupted
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: gfs2 <gfs2@lists.linux.dev>, teigland@redhat.com, mark@fasheh.com, 
	jlbec@evilplan.org, joseph.qi@linux.alibaba.com, ocfs2-devel@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Mar 26, 2024 at 7:31=E2=80=AFAM Andreas Gruenbacher <agruenba@redha=
t.com> wrote:
>
> On Tue, Mar 26, 2024 at 1:32=E2=80=AFAM Alexander Aring <aahringo@redhat.=
com> wrote:
> > Hi,
> >
> > On Mon, Mar 25, 2024 at 11:09=E2=80=AFAM Andreas Gruenbacher
> > <agruenba@redhat.com> wrote:
> > >
> > > On Tue, Jul 18, 2023 at 8:07=E2=80=AFPM Alexander Aring <aahringo@red=
hat.com> wrote:
> > > > This patch implements dlm plock F_SETLKW interruption feature. If a
> > > > blocking posix lock request got interrupted in user space by a sign=
al a
> > > > cancellation request for a non granted lock request to the user spa=
ce
> > > > lock manager will be send. The user lock manager answers either wit=
h
> > > > zero or a negative errno code. A errno of -ENOENT signals that ther=
e is
> > > > currently no blocking lock request waiting to being granted. In cas=
e of
> > > > -ENOENT it was probably to late to request a cancellation and the
> > > > pending lock got granted. In any error case we will wait until the =
lock
> > > > is being granted as cancellation failed, this causes also that in c=
ase
> > > > of an older user lock manager returning -EINVAL we will wait as
> > > > cancellation is not supported which should be fine. If a user requi=
res
> > > > this feature the user should update dlm user space to support lock
> > > > request cancellation.
> > > >
> > > > Signed-off-by: Alexander Aring <aahringo@redhat.com>
> > > > ---
> > > >  fs/dlm/plock.c                 | 56 ++++++++++++++++++++++--------=
----
> > > >  include/uapi/linux/dlm_plock.h |  1 +
> > > >  2 files changed, 37 insertions(+), 20 deletions(-)
> > > >
> > > > diff --git a/fs/dlm/plock.c b/fs/dlm/plock.c
> > > > index a34f605d8505..a8ffa0760913 100644
> > > > --- a/fs/dlm/plock.c
> > > > +++ b/fs/dlm/plock.c
> > > > @@ -74,30 +74,26 @@ static void send_op(struct plock_op *op)
> > > >         wake_up(&send_wq);
> > > >  }
> > > >
> > > > -/* If a process was killed while waiting for the only plock on a f=
ile,
> > > > -   locks_remove_posix will not see any lock on the file so it won'=
t
> > > > -   send an unlock-close to us to pass on to userspace to clean up =
the
> > > > -   abandoned waiter.  So, we have to insert the unlock-close when =
the
> > > > -   lock call is interrupted. */
> > > > -
> > > > -static void do_unlock_close(const struct dlm_plock_info *info)
> > > > +static int do_lock_cancel(const struct dlm_plock_info *orig_info)
> > > >  {
> > > >         struct plock_op *op;
> > > > +       int rv;
> > > >
> > > >         op =3D kzalloc(sizeof(*op), GFP_NOFS);
> > > >         if (!op)
> > > > -               return;
> > > > +               return -ENOMEM;
> > > > +
> > > > +       op->info =3D *orig_info;
> > > > +       op->info.optype =3D DLM_PLOCK_OP_CANCEL;
> > > > +       op->info.wait =3D 0;
> > > >
> > > > -       op->info.optype         =3D DLM_PLOCK_OP_UNLOCK;
> > > > -       op->info.pid            =3D info->pid;
> > > > -       op->info.fsid           =3D info->fsid;
> > > > -       op->info.number         =3D info->number;
> > > > -       op->info.start          =3D 0;
> > > > -       op->info.end            =3D OFFSET_MAX;
> > > > -       op->info.owner          =3D info->owner;
> > > > -
> > > > -       op->info.flags |=3D DLM_PLOCK_FL_CLOSE;
> > > >         send_op(op);
> > > > +       wait_event(recv_wq, (op->done !=3D 0));
> > > > +
> > > > +       rv =3D op->info.rv;
> > > > +
> > > > +       dlm_release_plock_op(op);
> > > > +       return rv;
> > > >  }
> > > >
> > > >  int dlm_posix_lock(dlm_lockspace_t *lockspace, u64 number, struct =
file *file,
> > > > @@ -156,7 +152,7 @@ int dlm_posix_lock(dlm_lockspace_t *lockspace, =
u64 number, struct file *file,
> > > >         send_op(op);
> > > >
> > > >         if (op->info.wait) {
> > > > -               rv =3D wait_event_killable(recv_wq, (op->done !=3D =
0));
> > > > +               rv =3D wait_event_interruptible(recv_wq, (op->done =
!=3D 0));
> > >
> > > It seems that this patch leads to an unnecessary change in behavior
> > > when a fatal signal is received (fatal_signal_pending()): before, the
> > > process would terminate. Now, it will try to cancel the lock, and whe=
n
> > > that fails, the process will keep waiting. In case of a fatal signal,
> > > can we skip the cancelling and do what we did before?
> >
> > From my understanding interruptible() "reacts" on everything that is
> > also killable() and returns -ERESTARTSYS on "fatal signal". I even
> > tested it because wait_event_killable() has an issue, see reproducer
> > [0]. The issue was that it cleans too many waiters, the other waiter
> > of child in F_SETLKW was also cleared and it will never get a result
> > back from dlm_controld. I fixed that with an additional check on pid
> > in [1], but I have no idea about other side effects that could have
> > occurred as FL_CLOSE is also being used on other parts in the DLM
> > plock handling.
> >
> > I rechecked the behaviour with the cancellation feature and sent
> > SIGKILL and the issue was gone without changing anything in user
> > space. The only thing I see why it would not have the old behaviour
> > (killable - that having the mentioned issue above) is that the
> > dlm_controld version is too old. To not run into this known issue we
> > just do a wait_event() that does not have those issues.
> >
> > The mentioned "cancellation fails" - is not that it failed to cancel
> > the lock, there is some unexpected behaviour of dlm_controld, only
> > then we do wait_event() e.g. when we receive -EINVAL because
> > dlm_controld does not understand the op.
>
> What happens on a system that has this kernel change, but doesn't have
> the corresponding dlm_controld change for DLM_PLOCK_OP_CANCEL support?
> In this scenario, when a process is killed with SIGKILL, the kernel
> will send a DLM_PLOCK_OP_CANCEL request to dlm_controld. dlm_controld
> doesn't understand the DLM_PLOCK_OP_CANCEL request, so I assume that
> it will return a value other than 0 or -ENOENT. As a consequence, we
> will end up in wait_event(), which isn't interruptible. So before this
> kernel change, the process would be killable, but with this kernel
> change, it isn't killable anymore.
>
> I'm worried about this scenario because it isn't entirely unrealistic
> for a system to end up with this kernel change but without the
> corresponding user-space change.
>

as I said before the previous behaviour had broken cases. I am more
worried about that somebody runs into this case as somebody realize
its not killable anymore but will may then figure out to upgrade
dlm_controld.

- Alex

