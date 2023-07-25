Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579921F92E
	for <ocfs2-devel@lists.linux.dev>; Tue, 25 Jul 2023 14:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690295199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZUJ4r2aY+x3CleDJbX/AV/N0fMSOwi5/571RR8N6LrY=;
	b=fOn1uLrtTsrCCuzYy1d7RZm/hKWpnayHcsWBU0jVQUb7ArZiriPP1UCon5nhsesa2OyAG1
	dSppyvzlR87NJc4x4rVG6DjDtsuh1sSMZuutEdEBJH1IQx1ViivqVrxNAkifwDG/xf20o9
	0a/vXTbNmJmWhKjx2gpRToeNTTU+tfI=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-380-g3pEj2xCNx6VpuO_FczPwg-1; Tue, 25 Jul 2023 10:26:36 -0400
X-MC-Unique: g3pEj2xCNx6VpuO_FczPwg-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-583d1d0de65so37964527b3.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 25 Jul 2023 07:26:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690295195; x=1690899995;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZUJ4r2aY+x3CleDJbX/AV/N0fMSOwi5/571RR8N6LrY=;
        b=jaShVHFQI3AC4oFHj2l2vbBIpRVjSiHBzy0itaFfhDhv/+qq5o9NOjIr2fkuuNpHUE
         okU8j276gBAQc0RPOxbwHKVLtULsXcX/PxceT/KeUUZXHjX8bad0ciqqcLLGtzURCArg
         Th0jlbnzyiqk7f05x0eILUkjscurTedS4xiyFsXNKPabs4KmSfRbERCyb1HtXvCwtDQN
         K7A+JgU4PtLwEe0sLFG1aqJQ+/98pyJTpz/Qawvv/vCrzCEkfUMK38Awt624ZZxcz5PQ
         HvTBJBZEYIEaTbnc4Wa+HdUo8T9hHGCmfW1fZSjteW/h2Vvb9zStf3kultEoClMjZ+oN
         FJ9A==
X-Gm-Message-State: ABy/qLZCQAUWKg5HETZLfT4g1YvH0R59PXA1aMThtRQPCFlzvT7lMcOw
	sDbxk63ULHbp2QFnnPxOD52+9gSo2qZ86DhJX/AcHkmTDuk9JnH0VmU9FcGykAB2L9B48I2EVQs
	QZxnGKoump+YhOdyUer5bQLC5XxA/DhJk/sn5pWk=
X-Received: by 2002:a0d:ca0e:0:b0:577:4975:c114 with SMTP id m14-20020a0dca0e000000b005774975c114mr9669220ywd.0.1690295195301;
        Tue, 25 Jul 2023 07:26:35 -0700 (PDT)
X-Google-Smtp-Source: APBJJlE9UQpxq1fveOaxD31SoTyFiUUMp4sUQ52JsLcD5Jz+oFaONTwQ/ahNSrQ+l7hC+lie+j/6Tk+Nu2tfxvLqH8g=
X-Received: by 2002:a0d:ca0e:0:b0:577:4975:c114 with SMTP id
 m14-20020a0dca0e000000b005774975c114mr9669202ywd.0.1690295195091; Tue, 25 Jul
 2023 07:26:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230718180721.745569-1-aahringo@redhat.com> <20230718180721.745569-4-aahringo@redhat.com>
In-Reply-To: <20230718180721.745569-4-aahringo@redhat.com>
From: Alexander Aring <aahringo@redhat.com>
Date: Tue, 25 Jul 2023 10:26:23 -0400
Message-ID: <CAK-6q+hOv6qEnStcWD6_OCZH9XO_m+Dh-2KX5rYaXbuNOgp6gw@mail.gmail.com>
Subject: Re: [PATCHv3 v6.5-rc2 3/3] fs: dlm: fix F_CANCELLK to cancel pending request
To: teigland@redhat.com
Cc: cluster-devel@redhat.com, agruenba@redhat.com, mark@fasheh.com, 
	jlbec@evilplan.org, joseph.qi@linux.alibaba.com, ocfs2-devel@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 18, 2023 at 2:07=E2=80=AFPM Alexander Aring <aahringo@redhat.co=
m> wrote:
>
> This patch fixes the current handling of F_CANCELLK by not just doing a
> unlock as we need to try to cancel a lock at first. A unlock makes sense
> on a non-blocking lock request but if it's a blocking lock request we
> need to cancel the request until it's not granted yet. This patch is fixi=
ng
> this behaviour by first try to cancel a lock request and if it's failed
> it's unlocking the lock which seems to be granted.
>
> Note: currently the nfs locking handling was disabled by commit
> 40595cdc93ed ("nfs: block notification on fs with its own ->lock").
> However DLM was never being updated regarding to this change. Future
> patches will try to fix lockd lock requests for DLM. This patch is
> currently assuming the upstream DLM lockd handling is correct.
>
> Signed-off-by: Alexander Aring <aahringo@redhat.com>
> ---
>  fs/dlm/plock.c            | 102 +++++++++++++++++++++++++++++++++-----
>  fs/gfs2/file.c            |   9 ++--
>  fs/ocfs2/stack_user.c     |  13 ++---
>  include/linux/dlm_plock.h |   2 +
>  4 files changed, 97 insertions(+), 29 deletions(-)
>
> diff --git a/fs/dlm/plock.c b/fs/dlm/plock.c
> index a8ffa0760913..84510994b177 100644
> --- a/fs/dlm/plock.c
> +++ b/fs/dlm/plock.c
> @@ -42,6 +42,27 @@ static inline void set_version(struct dlm_plock_info *=
info)
>         info->version[2] =3D DLM_PLOCK_VERSION_PATCH;
>  }
>
> +static struct plock_op *plock_lookup_waiter(const struct dlm_plock_info =
*info)
> +{
> +       struct plock_op *op =3D NULL, *iter;
> +
> +       list_for_each_entry(iter, &recv_list, list) {
> +               if (iter->info.fsid =3D=3D info->fsid &&
> +                   iter->info.number =3D=3D info->number &&
> +                   iter->info.owner =3D=3D info->owner &&
> +                   iter->info.pid =3D=3D info->pid &&
> +                   iter->info.start =3D=3D info->start &&
> +                   iter->info.end =3D=3D info->end &&
> +                   iter->info.ex =3D=3D info->ex &&
> +                   iter->info.wait) {
> +                       op =3D iter;
> +                       break;
> +               }
> +       }
> +
> +       return op;
> +}
> +
>  static int check_version(struct dlm_plock_info *info)
>  {
>         if ((DLM_PLOCK_VERSION_MAJOR !=3D info->version[0]) ||
> @@ -334,6 +355,73 @@ int dlm_posix_unlock(dlm_lockspace_t *lockspace, u64=
 number, struct file *file,
>  }
>  EXPORT_SYMBOL_GPL(dlm_posix_unlock);
>
> +/*
> + * NOTE: This implementation can only handle async lock requests as nfs
> + * do it. It cannot handle cancellation of a pending lock request sittin=
g
> + * in wait_event(), but for now only nfs is the only user local kernel
> + * user.
> + */
> +int dlm_posix_cancel(dlm_lockspace_t *lockspace, u64 number, struct file=
 *file,
> +                    struct file_lock *fl)
> +{
> +       struct dlm_plock_info info;
> +       struct plock_op *op;
> +       struct dlm_ls *ls;
> +       int rv;
> +
> +       /* this only works for async request for now and nfs is the only
> +        * kernel user right now.
> +        */
> +       if (WARN_ON_ONCE(!fl->fl_lmops || !fl->fl_lmops->lm_grant))
> +               return -EOPNOTSUPP;
> +
> +       ls =3D dlm_find_lockspace_local(lockspace);
> +       if (!ls)
> +               return -EINVAL;
> +
> +       info.pid =3D fl->fl_pid;
> +       info.ex =3D (fl->fl_type =3D=3D F_WRLCK);
> +       info.fsid =3D ls->ls_global_id;
> +       dlm_put_lockspace(ls);
> +       info.number =3D number;
> +       info.start =3D fl->fl_start;
> +       info.end =3D fl->fl_end;
> +       info.owner =3D (__u64)fl->fl_pid;
> +
> +       rv =3D do_lock_cancel(&info);
> +       switch (rv) {
> +       case 0:
> +               spin_lock(&ops_lock);
> +               /* lock request to cancel must be on recv_list because
> +                * do_lock_cancel() synchronizes it.
> +                */
> +               op =3D plock_lookup_waiter(&info);
> +               if (WARN_ON_ONCE(!op)) {
> +                       rv =3D -ENOLCK;
> +                       break;

missing spin_unlock() here. I will add it to my upcoming patch series.

- Alex

