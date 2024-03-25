Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDAE145B15
	for <ocfs2-devel@lists.linux.dev>; Mon, 25 Mar 2024 15:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711379346; cv=none; b=sGhaz9HoazEH8K9wjjolxzAvGNdhje/RRMau5EnTvzcZAdqywBEakOfFHLQah3fvNA1jGgb4LjjVtZGoK5tpPrZB5OiNVL2lO9xkAMaxyi7T1mLC9YpB7tZ7hEVbBEXw0l05jWQTpaaFo+T/X+vWWi+r5mpSIUvzMtZlKrdU+10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711379346; c=relaxed/simple;
	bh=pbm1EISx33/ONj4CYpX7ozKjxBWhZ9zbJG6j2YI4lfk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kp4ajLyTkuL2iayVSf8YmmqU2PipZSyaKkEIcqUdlwTzu6/73xqqFMWfaAa2KwtrNCqlXdQ0rgjOX956+36MbUZNHnXiXtSDe2T8fafwTkRzLEIhH9pTcHK/Qjbg4LFoUEoLi+KtCVaR7CdR9O/HyeJ1sTITib0Em2q28HTsPac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DZr3K91i; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DZr3K91i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711379343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BtfEAxMpIBj12+f7fi2yKD9vQpHirZsmYwJFHRu47ec=;
	b=DZr3K91ip9lLOguz+zxtjL6Z9z7Xl6ImMljNEeXnAGUI0FJoY+mtH6t965tk/VF+t0vbCj
	Hm4J7wFsw6Ip01/vxC9wJFsAt6HjCHhtyULmxG+2LBwhncdRA/jQ/v6XemOBKeLPBxpIYI
	CDJLw0ZveRWJ3DMbBqQLjjFHeksqekE=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-153-8sRGh4wKOjan8V9f_TEYlA-1; Mon, 25 Mar 2024 11:09:02 -0400
X-MC-Unique: 8sRGh4wKOjan8V9f_TEYlA-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1e0c5faf1d0so5962235ad.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 25 Mar 2024 08:09:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711379341; x=1711984141;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BtfEAxMpIBj12+f7fi2yKD9vQpHirZsmYwJFHRu47ec=;
        b=CfgFzDQS0RPQl3tRdcYMfYogO/ZJGFBaTk7aL14pidobQ/3NcgJu/aqmGi0qmWuiVo
         qpUye3OjUwCXGUChkr5tO74SrL5plQRGbPfYlqkczYX3bgV8rWZPsSMZDXkk3HKCqx+m
         FjeooxjeqakZZFsI2uvhJibqcaZXIW81lpaYoPxeLyMMXY0u+6ETDt+PaWIdEslm/c8M
         W6ULV1YfYxK7m7KVb6EjXJO3gGTbN2JeJ9Vz3RGyP8Wixc2kZGQZNKAQiYNKQ4hJa89r
         53nN8gkw7W7BZjAncGAIGW85NRAKoTx9k1EOOsBlLOZf6XCQwN0LCHCOraBNXe+wGQGv
         Dffw==
X-Forwarded-Encrypted: i=1; AJvYcCWH0h8361X1da8Semsl5pmLjrwUcMd8eYa1aRXT7ekKBiYXdRvnRwDY+jeTB/JFyp2goiy0exr1Ot8n/53yLnKtiSYYN0Mj/ex2frc=
X-Gm-Message-State: AOJu0YyyKS/MbYGJiiRPu3Ju+LJpWTf3z9tdB0ojd3k+/btS1ZaCt4Oi
	gKEVpmZz0MgM9fNw4sUvrPRb1m23xGdUIDmrJdRI+2JNS5oNS8oKqBhhs1O5CPjttcmp6pGKNjq
	PzFcjX1vy8s+FTxhl8wlq969dKAwBT+nHFN0FBLlJAQwsWrp+bfZB0a+FaQNvzYh0oNeTcmSwlh
	I0TdxHolUQlrBfHOF8dBoeOGxbdEg96as3MZA=
X-Received: by 2002:a17:903:1206:b0:1e0:583c:f6ae with SMTP id l6-20020a170903120600b001e0583cf6aemr9736521plh.35.1711379341221;
        Mon, 25 Mar 2024 08:09:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG6io+WxqN17wK/CRcNFzWPA+CfoRy1G+1SeOU+Nnf8bAfQrLajiNQ58HHM1HDzg8vVhsQacFWNpPN9lyFotNw=
X-Received: by 2002:a17:903:1206:b0:1e0:583c:f6ae with SMTP id
 l6-20020a170903120600b001e0583cf6aemr9736489plh.35.1711379340871; Mon, 25 Mar
 2024 08:09:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230718180721.745569-1-aahringo@redhat.com> <20230718180721.745569-3-aahringo@redhat.com>
In-Reply-To: <20230718180721.745569-3-aahringo@redhat.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Mon, 25 Mar 2024 16:08:47 +0100
Message-ID: <CAHc6FU7LBm6RSk_M8BqZRz0LOCmDORKj0bBWSmDjM=3_iB8guQ@mail.gmail.com>
Subject: Re: [PATCHv3 v6.5-rc2 2/3] fs: dlm: allow to F_SETLKW getting interrupted
To: Alexander Aring <aahringo@redhat.com>
Cc: gfs2 <gfs2@lists.linux.dev>, teigland@redhat.com, mark@fasheh.com, 
	jlbec@evilplan.org, joseph.qi@linux.alibaba.com, ocfs2-devel@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 18, 2023 at 8:07=E2=80=AFPM Alexander Aring <aahringo@redhat.co=
m> wrote:
> This patch implements dlm plock F_SETLKW interruption feature. If a
> blocking posix lock request got interrupted in user space by a signal a
> cancellation request for a non granted lock request to the user space
> lock manager will be send. The user lock manager answers either with
> zero or a negative errno code. A errno of -ENOENT signals that there is
> currently no blocking lock request waiting to being granted. In case of
> -ENOENT it was probably to late to request a cancellation and the
> pending lock got granted. In any error case we will wait until the lock
> is being granted as cancellation failed, this causes also that in case
> of an older user lock manager returning -EINVAL we will wait as
> cancellation is not supported which should be fine. If a user requires
> this feature the user should update dlm user space to support lock
> request cancellation.
>
> Signed-off-by: Alexander Aring <aahringo@redhat.com>
> ---
>  fs/dlm/plock.c                 | 56 ++++++++++++++++++++++------------
>  include/uapi/linux/dlm_plock.h |  1 +
>  2 files changed, 37 insertions(+), 20 deletions(-)
>
> diff --git a/fs/dlm/plock.c b/fs/dlm/plock.c
> index a34f605d8505..a8ffa0760913 100644
> --- a/fs/dlm/plock.c
> +++ b/fs/dlm/plock.c
> @@ -74,30 +74,26 @@ static void send_op(struct plock_op *op)
>         wake_up(&send_wq);
>  }
>
> -/* If a process was killed while waiting for the only plock on a file,
> -   locks_remove_posix will not see any lock on the file so it won't
> -   send an unlock-close to us to pass on to userspace to clean up the
> -   abandoned waiter.  So, we have to insert the unlock-close when the
> -   lock call is interrupted. */
> -
> -static void do_unlock_close(const struct dlm_plock_info *info)
> +static int do_lock_cancel(const struct dlm_plock_info *orig_info)
>  {
>         struct plock_op *op;
> +       int rv;
>
>         op =3D kzalloc(sizeof(*op), GFP_NOFS);
>         if (!op)
> -               return;
> +               return -ENOMEM;
> +
> +       op->info =3D *orig_info;
> +       op->info.optype =3D DLM_PLOCK_OP_CANCEL;
> +       op->info.wait =3D 0;
>
> -       op->info.optype         =3D DLM_PLOCK_OP_UNLOCK;
> -       op->info.pid            =3D info->pid;
> -       op->info.fsid           =3D info->fsid;
> -       op->info.number         =3D info->number;
> -       op->info.start          =3D 0;
> -       op->info.end            =3D OFFSET_MAX;
> -       op->info.owner          =3D info->owner;
> -
> -       op->info.flags |=3D DLM_PLOCK_FL_CLOSE;
>         send_op(op);
> +       wait_event(recv_wq, (op->done !=3D 0));
> +
> +       rv =3D op->info.rv;
> +
> +       dlm_release_plock_op(op);
> +       return rv;
>  }
>
>  int dlm_posix_lock(dlm_lockspace_t *lockspace, u64 number, struct file *=
file,
> @@ -156,7 +152,7 @@ int dlm_posix_lock(dlm_lockspace_t *lockspace, u64 nu=
mber, struct file *file,
>         send_op(op);
>
>         if (op->info.wait) {
> -               rv =3D wait_event_killable(recv_wq, (op->done !=3D 0));
> +               rv =3D wait_event_interruptible(recv_wq, (op->done !=3D 0=
));

It seems that this patch leads to an unnecessary change in behavior
when a fatal signal is received (fatal_signal_pending()): before, the
process would terminate. Now, it will try to cancel the lock, and when
that fails, the process will keep waiting. In case of a fatal signal,
can we skip the cancelling and do what we did before?

>                 if (rv =3D=3D -ERESTARTSYS) {
>                         spin_lock(&ops_lock);
>                         /* recheck under ops_lock if we got a done !=3D 0=
,
> @@ -166,17 +162,37 @@ int dlm_posix_lock(dlm_lockspace_t *lockspace, u64 =
number, struct file *file,
>                                 spin_unlock(&ops_lock);
>                                 goto do_lock_wait;
>                         }
> -                       list_del(&op->list);
>                         spin_unlock(&ops_lock);
>
> +                       rv =3D do_lock_cancel(&op->info);
> +                       switch (rv) {
> +                       case 0:
> +                               /* waiter was deleted in user space, answ=
er will never come
> +                                * remove original request. The original =
request must be
> +                                * on recv_list because the answer of do_=
lock_cancel()
> +                                * synchronized it.
> +                                */
> +                               spin_lock(&ops_lock);
> +                               list_del(&op->list);
> +                               spin_unlock(&ops_lock);
> +                               rv =3D -EINTR;
> +                               break;
> +                       case -ENOENT:
> +                               /* cancellation wasn't successful but op =
should be done */
> +                               fallthrough;
> +                       default:
> +                               /* internal error doing cancel we need to=
 wait */
> +                               goto wait;
> +                       }
> +
>                         log_debug(ls, "%s: wait interrupted %x %llx pid %=
d",
>                                   __func__, ls->ls_global_id,
>                                   (unsigned long long)number, op->info.pi=
d);
> -                       do_unlock_close(&op->info);
>                         dlm_release_plock_op(op);
>                         goto out;
>                 }
>         } else {
> +wait:
>                 wait_event(recv_wq, (op->done !=3D 0));
>         }
>
> diff --git a/include/uapi/linux/dlm_plock.h b/include/uapi/linux/dlm_ploc=
k.h
> index 63b6c1fd9169..eb66afcac40e 100644
> --- a/include/uapi/linux/dlm_plock.h
> +++ b/include/uapi/linux/dlm_plock.h
> @@ -22,6 +22,7 @@ enum {
>         DLM_PLOCK_OP_LOCK =3D 1,
>         DLM_PLOCK_OP_UNLOCK,
>         DLM_PLOCK_OP_GET,
> +       DLM_PLOCK_OP_CANCEL,
>  };
>
>  #define DLM_PLOCK_FL_CLOSE 1
> --
> 2.31.1
>

Thanks,
Andreas

