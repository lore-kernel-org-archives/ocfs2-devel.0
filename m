Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8864D275D6
	for <ocfs2-devel@lists.linux.dev>; Wed, 19 Jul 2023 18:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689791614;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ur/7tY9x/tRgeuGcTOKDecGX+pLOZx869sm+6cI/oO4=;
	b=FU8YZXtEZlcxlDEnbk+QA7fyzHsO4Ukjyd2ea5rI9MFfvC2DJInugPi1at1AiFa8/ON1WW
	0zpHotCRlxZikfIY199CweC4XoPLjlaOr1FpadtEgw7AKFqn6csSsHJBVOsiuEQXJBN8da
	zT/oSsqAbKTi4zW4pKPRHBImoRe7DNA=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-131-1xlCr9zXMaCO_ebqX67hVA-1; Wed, 19 Jul 2023 14:33:33 -0400
X-MC-Unique: 1xlCr9zXMaCO_ebqX67hVA-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-56ff81be091so337057b3.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 19 Jul 2023 11:33:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689791613; x=1692383613;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ur/7tY9x/tRgeuGcTOKDecGX+pLOZx869sm+6cI/oO4=;
        b=jqGWqO28ca7LHlsjAxsE+D3+Gn59+gNi9aSjAARAulE1Yo2EDJ5+QmnxBBRFOAekAq
         oSyQlgS2oQ8/z8qHcpm+bP4uozoUioUrUYY2Afm9QoK8/cjtBV0YysAxQKNW4hHKec/O
         P4Vav1SbkVpPJCSi4ml7Qhnmm3lpsppG9zty/ApK7aHRgC+cxmn/Z6PLCvHY54qSU5EE
         aCikpUFt0veQ7rlGLM2Z65ZcQIgV3EdaL8c0Hx7k1xW2IzqacPP0UcfwOL6nUsMmBh+U
         hO9aO5bo0SXvrOKpLF3RMnAKTObJAsKrrXmkE8RXSb0P8Dko6znVqCXjuqRdnFgnQOE3
         qYfw==
X-Gm-Message-State: ABy/qLafgCMpgSGpxliXcqKBa3uxNeA5pxYUxHXyQ/+1DkhlPAALwcjd
	1XbfGoWa2+BJxLigwmkHq5yGodY1SLiUhD0tQBy/KzZUlHiOUFzZJgcHMTk67mCABwKcvFK1G91
	+n3k7xV6nsmE+4EDSvE5nm0ut9OT1j4aAGHglbHw=
X-Received: by 2002:a81:92d3:0:b0:581:2887:22be with SMTP id j202-20020a8192d3000000b00581288722bemr21774100ywg.37.1689791612865;
        Wed, 19 Jul 2023 11:33:32 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGBzan3MF717TbeJevLQRirLTiedRen/Yjq7rPm4PF2/R07POBpIIAQkupe9F5A+x6nP2ha/T8mDGhgyrdBxNM=
X-Received: by 2002:a81:92d3:0:b0:581:2887:22be with SMTP id
 j202-20020a8192d3000000b00581288722bemr21774082ywg.37.1689791612580; Wed, 19
 Jul 2023 11:33:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230718180721.745569-1-aahringo@redhat.com> <20230718180721.745569-4-aahringo@redhat.com>
In-Reply-To: <20230718180721.745569-4-aahringo@redhat.com>
From: Alexander Aring <aahringo@redhat.com>
Date: Wed, 19 Jul 2023 14:33:21 -0400
Message-ID: <CAK-6q+j10uosheJ=jeU9R7p2kV1niAoMhPOkc7HMtNgkp2e2XQ@mail.gmail.com>
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

here is a:

memset(&info, 0, sizeof(info));

missing.

- Alex

