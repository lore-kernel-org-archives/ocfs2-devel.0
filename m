Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F400165EEF
	for <ocfs2-devel@lists.linux.dev>; Mon, 19 Aug 2024 14:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724078845; cv=none; b=iQ8PekzbOstuwGo7F4J+3wEfTzD0lPxZGL5z040EAgK8LsT6IllpSJSrrINC+NGfeYdskzM+TYgki9L47/leoQnAHbv4ylPKyLEGVUcCBpyBu3D2LtDWeVZT4efZUDkElyT5aO8bSFtGXUCXDI7CxPysveW5uXfwOxDxPp8l1wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724078845; c=relaxed/simple;
	bh=LNWJB2QBA6KMPjATkJ4SgTGYhAcgrGcClYZNgtavaRQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nsuCO6k5aJIY12p/zu6SbgREarebj2+uZ9c0hjXjVEFY0TAid1gASOPFdldESIZSk0ZMDMODzeinZPda0wX9EROMd+g327wega5OlCxYG54xkj8ghjlJf8SwP6UbggFjjpg/4K4Cy2RHQ4jBz5D+WjzZgcOUL+fwsbhGj9Wnk2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KDrmF+af; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KDrmF+af"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2f16767830dso48220041fa.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 19 Aug 2024 07:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724078841; x=1724683641; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+hvQ3u52v0qJKkhIMSDWdBwGwmYs7vrpYpWLlGJR548=;
        b=KDrmF+afOBCBxufehvc8yIPlJs5NDXS4C93S/6wlAAjEk3YMTXShGnFy6/aqAsYCdW
         AsfgV0ShouQjQ1cNacQIb76S1WObaivR1dP8onOzU5yRRKe2Kq2MHxyGLo425mbFL2TC
         jWrKLyHfbUx5XXopnJeDvjDmae2biWOIoTBL8xLAoIl/EjfkXPRX9MFMaICKcVcL+64W
         OR2zqRZ+QrFivMrO83VY+iutmzftyOt0Sy7DWS4RedyYZgZ5dF86jQkxYmwIy6/yJaFQ
         PusC1kYSZtJq/CBLeORc8kKfhAaFSCcUfCgaea+UmljvQghQko1NkEJnW4zHqtSx2G2h
         SMdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724078841; x=1724683641;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+hvQ3u52v0qJKkhIMSDWdBwGwmYs7vrpYpWLlGJR548=;
        b=YRtfMjm0u/c0GZUJO2P4/pgLwP2zazTDQcA/AAqVBgyWe/nCvfeKMm09SB5RzewVMI
         l026ak+ncNKCHz6Fn7BwBwbegpzkeW7+/Jh6ZcXuHP3hV7BybHq/4Ra5eOWuVGra7jZi
         FiL2snkZREEbJQ2di4t2cFax6bE8UeCmjm0VUdFBL5ROOFAk/6ACLBb7Y+CJffv1+Ikr
         xc+IF0G+frAIhCfh/lveAQM2qvY4+jKfWE/gL5ZiMNNLqmVOKmQAghAehuA7lONSPEwC
         Ox57ZZvDLokWO+uRaG2dZzeLbM/NpLXKBKSiE8A6D9nBBAZAEmXJjbKYuKs7o+AWbFxB
         XorA==
X-Gm-Message-State: AOJu0YzessuKcgIPwqJfLX68ii3LnJslKoI4uXEqhqBW9a73/S6sXXds
	o+j/Qf3K+06XqraWFNZybW2sc7bCsey+o5iGfcABC2vS/9cvr9wVbLuHbtHmUlJUsxnSKplOSpQ
	qg16ka0OurfpZDIHwLQaytjSZUtFxxrIR
X-Google-Smtp-Source: AGHT+IEs88zzlUiuNbET+7jZKVbZCJAg+gVxCpDfydrYqpD4f+qGR1PPXZpThAya2cO9HgynDqIUPpCO8CGLkUCkizw=
X-Received: by 2002:a05:651c:a0a:b0:2f3:cbc3:b093 with SMTP id
 38308e7fff4ca-2f3cf4caf48mr46052731fa.43.1724078840620; Mon, 19 Aug 2024
 07:47:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240819131120.746077-1-sunjunchao2870@gmail.com>
In-Reply-To: <20240819131120.746077-1-sunjunchao2870@gmail.com>
From: Julian Sun <sunjunchao2870@gmail.com>
Date: Mon, 19 Aug 2024 22:47:07 +0800
Message-ID: <CAHB1NaijrAA999WMG=XsSCKhnvvhYR4qqzJ8uOf58Tnk9ms-xQ@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: fix null-ptr-deref when journal load failed.
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com, jlbec@evilplan.org, mark@fasheh.com, 
	syzbot+05b9b39d8bdfe1a0861f@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

CC stable

Julian Sun <sunjunchao2870@gmail.com> =E4=BA=8E2024=E5=B9=B48=E6=9C=8819=E6=
=97=A5=E5=91=A8=E4=B8=80 21:11=E5=86=99=E9=81=93=EF=BC=9A
>
> During the mounting process, if the jbd2_journal_load()
> call fails, it will internally invoke journal_reset()
> ->journal_fail_superblock(), which sets journal->j_sb_buffer
> to NULL. Subsequently, ocfs2_journal_shutdown() calls
> jbd2_journal_flush()->jbd2_cleanup_journal_tail()->
> __jbd2_update_log_tail()->jbd2_journal_update_sb_log_tail()
> ->lock_buffer(journal->j_sb_buffer), resulting in a
> null-pointer dereference error.
>
> To resolve this issue, a new state OCFS2_JOURNAL_INITED
> has been introduced to replace the previous functionality
> of OCFS2_JOURNAL_LOADED, the original OCFS2_JOURNAL_LOADED
> is only set when ocfs2_journal_load() is successful.
> The jbd2_journal_flush() function is allowed to be called
> only when this flag is set. The logic here is that if the
> journal has even not been successfully loaded, there is
> no need to flush the journal.
>
> Link: https://syzkaller.appspot.com/bug?extid=3D05b9b39d8bdfe1a0861f
> Reported-by: syzbot+05b9b39d8bdfe1a0861f@syzkaller.appspotmail.com
> Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
> ---
>  fs/ocfs2/journal.c | 9 ++++++---
>  fs/ocfs2/journal.h | 1 +
>  2 files changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 530fba34f6d3..6f837296048f 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -968,7 +968,7 @@ int ocfs2_journal_init(struct ocfs2_super *osb, int *=
dirty)
>
>         ocfs2_set_journal_params(osb);
>
> -       journal->j_state =3D OCFS2_JOURNAL_LOADED;
> +       journal->j_state =3D OCFS2_JOURNAL_INITED;
>
>         status =3D 0;
>  done:
> @@ -1039,6 +1039,7 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb=
)
>         int status =3D 0;
>         struct inode *inode =3D NULL;
>         int num_running_trans =3D 0;
> +       enum ocfs2_journal_state state;
>
>         BUG_ON(!osb);
>
> @@ -1047,8 +1048,9 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb=
)
>                 goto done;
>
>         inode =3D journal->j_inode;
> +       state =3D journal->j_state;
>
> -       if (journal->j_state !=3D OCFS2_JOURNAL_LOADED)
> +       if (state !=3D OCFS2_JOURNAL_INITED)
>                 goto done;
>
>         /* need to inc inode use count - jbd2_journal_destroy will iput. =
*/
> @@ -1076,7 +1078,7 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb=
)
>
>         BUG_ON(atomic_read(&(osb->journal->j_num_trans)) !=3D 0);
>
> -       if (ocfs2_mount_local(osb)) {
> +       if (ocfs2_mount_local(osb) && state =3D=3D OCFS2_JOURNAL_LOADED) =
{
>                 jbd2_journal_lock_updates(journal->j_journal);
>                 status =3D jbd2_journal_flush(journal->j_journal, 0);
>                 jbd2_journal_unlock_updates(journal->j_journal);
> @@ -1174,6 +1176,7 @@ int ocfs2_journal_load(struct ocfs2_journal *journa=
l, int local, int replayed)
>                 }
>         } else
>                 osb->commit_task =3D NULL;
> +       journal->j_state =3D OCFS2_JOURNAL_LOADED;
>
>  done:
>         return status;
> diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
> index e3c3a35dc5e0..a80f76a8fa0e 100644
> --- a/fs/ocfs2/journal.h
> +++ b/fs/ocfs2/journal.h
> @@ -15,6 +15,7 @@
>
>  enum ocfs2_journal_state {
>         OCFS2_JOURNAL_FREE =3D 0,
> +       OCFS2_JOURNAL_INITED,
>         OCFS2_JOURNAL_LOADED,
>         OCFS2_JOURNAL_IN_SHUTDOWN,
>  };
> --
> 2.39.2
>


--=20
Julian Sun <sunjunchao2870@gmail.com>
