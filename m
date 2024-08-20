Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39BCB19049D
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Aug 2024 15:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724167189; cv=none; b=kTJPAOcZrqaa+VC4t71+YiBJIQt+kQF5LYO+yACUNw+WrICNqgSu8ARv8lc/W1hEBEMh6v7qOqVg9No0Iqxav+gvIsdd5kgjA1O9Z0I/rGVuFtoAM9Ew4ceLBvjCt8HJeXrYn9GXcpsZKXZlpL8ZgPX/LZlBi9u+1WeBESq1t2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724167189; c=relaxed/simple;
	bh=nEgGVoWTfaKoJQLoAuM5Ym2ThQOdaI/WPppvGNkvGG0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZQkus9gI8tkEL5PvPIt6eh86Nw2rcTBFqpqoVSuum3cntN/00YqEsf/Qtb4wePUmn/OevfHv2Am9kb9+E9o5XuBcNh8QdND1fds2idncpYWajTxRJ+RSTtrBokWyVtaSeBj8Klpv1vSZoIzAFJxR1rxjXVCx+vCgNTpij6EdG0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N17SNmlI; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N17SNmlI"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5becd359800so4556887a12.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 20 Aug 2024 08:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724167185; x=1724771985; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PprvUJrxQUOH49R9k0o79l48WriG2pW2tsdn8VDcu84=;
        b=N17SNmlIw8enpURmuzFUJ9J7qcoTlsDQisc2Wm3X1SpCOLa3o+0v0SC0PpLL8/VvTv
         1ft+JJ2/RYL8TlrSe8r/DLFTVpexMCeKNtyFnKUIkm+5k/0iOO2NvAsYhJrNsDENZvjD
         4YTYeh+ZS6uo0Yi8R1H2Nt93JPSVHXI1mJwy6DnSP0gMYiZwggJkNXCZGBVArLKreJkR
         l5ChOvFCK7GAKBkuPyouB8zv4/aiA5uAyjZAV68zrAUxdKMzyU+NS37Ewc+9ZWZLOr77
         M3o5zObebI8UjApGOAX9bfarLp/XZIpjfTHis7xTvwWeLTbCsLTxtzvcWy8TR8BWq6ai
         hMag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724167185; x=1724771985;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PprvUJrxQUOH49R9k0o79l48WriG2pW2tsdn8VDcu84=;
        b=fFXJGKbOarxlDPiEGcGBRPmZ+YIeKRzxQdrPLjo8FKNAVaAStMB4ztMyI9aC8tP1dd
         soJVkEjkWScSYbFOLpTt7YOMQLUoldTWCWQis0z7OZzhUesxV416TiUgdPxWmDoijwOA
         QPVuYDbtKRNwqM3LMsChFtEURHX4YLoj/NmrjZ3PcKA1d95qwFzawS9Qku3Srq4IVE8R
         MeXj1c3m/wLTAUFQ7k0SoVekAK6NisdEYoQZr6hsYN+P8jsAjF0gyxbIOizl79myTh9p
         6e6s7wkk0+6HI2HYWeK6+gCWwBcG+o/HoYM2cy7gx2MEhdGrfAZGkF6e3F+WYt0LQevD
         h9Rg==
X-Gm-Message-State: AOJu0YwNXvP+FCEHwb5TAWFzOlZU7ghh5mQPkerAs+Qb1UO6ryTFfPDx
	UFjulcLrBoWfDkbU/zTZXsBEeewFxsZ0AYfapW1aFNnauq1Zh9Sl1HoADSFvW9Kk4zcgHgLXPKm
	fRaE+iN/V4cu4E8cTgpIeVsdn+zA=
X-Google-Smtp-Source: AGHT+IGMXIN9j0Fn6f0wyWyUf6zPzKUCCA6gBR55DFwVdUXCGC092HqclA7+XYNBEbqphFebaOfjl0SIqyLB7iKXoLY=
X-Received: by 2002:a05:6402:40cd:b0:5be:fe26:daac with SMTP id
 4fb4d7f45d1cf-5befe26db97mr4281656a12.17.1724167184840; Tue, 20 Aug 2024
 08:19:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240819131120.746077-1-sunjunchao2870@gmail.com> <26da607a-530d-4dc1-9040-bf56b406b98f@linux.alibaba.com>
In-Reply-To: <26da607a-530d-4dc1-9040-bf56b406b98f@linux.alibaba.com>
From: Julian Sun <sunjunchao2870@gmail.com>
Date: Tue, 20 Aug 2024 23:19:33 +0800
Message-ID: <CAHB1NaiJJmf838FwSGM8UZX6ebQn8L2hhFxNAcdmRDfBo1VUyg@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: fix null-ptr-deref when journal load failed.
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, jlbec@evilplan.org, mark@fasheh.com, 
	syzbot+05b9b39d8bdfe1a0861f@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Joseph Qi <joseph.qi@linux.alibaba.com> =E4=BA=8E2024=E5=B9=B48=E6=9C=8820=
=E6=97=A5=E5=91=A8=E4=BA=8C 21:03=E5=86=99=E9=81=93=EF=BC=9A
>
>
>
> On 8/19/24 9:11 PM, Julian Sun wrote:
> > During the mounting process, if the jbd2_journal_load()
> > call fails, it will internally invoke journal_reset()
> > ->journal_fail_superblock(), which sets journal->j_sb_buffer
>
>
> > This description is not right.
> > journal_reset() fails because of too short journal, then lead to
> > jbd2_journal_load() fails with NULL j_sb_buffer.
yeah. That's exactly what I described.
>
> > to NULL. Subsequently, ocfs2_journal_shutdown() calls
> > jbd2_journal_flush()->jbd2_cleanup_journal_tail()->
> > __jbd2_update_log_tail()->jbd2_journal_update_sb_log_tail()
> > ->lock_buffer(journal->j_sb_buffer), resulting in a
> > null-pointer dereference error.
> >
> > To resolve this issue, a new state OCFS2_JOURNAL_INITED
> > has been introduced to replace the previous functionality
> > of OCFS2_JOURNAL_LOADED, the original OCFS2_JOURNAL_LOADED
> > is only set when ocfs2_journal_load() is successful.
>
>
> > Or set OCFS2_JOURNAL_LOADED only after JBD2_LOADED?
I don't think this is correct. We first call ocfs2_journal_init(),
which allocates some resources, before calling jbd2_journal_load(). If
ocfs2_journal_init() succeeds but jbd2_journal_load() fails, this
solution may lead to a resource leak.
If there is anything important I'm missing, please let me know, thanks.

>
> Thanks,
> Joseph
>
> > The jbd2_journal_flush() function is allowed to be called
> > only when this flag is set. The logic here is that if the
> > journal has even not been successfully loaded, there is
> > no need to flush the journal.
> >
> > Link: https://syzkaller.appspot.com/bug?extid=3D05b9b39d8bdfe1a0861f
> > Reported-by: syzbot+05b9b39d8bdfe1a0861f@syzkaller.appspotmail.com
> > Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
> > ---
> >  fs/ocfs2/journal.c | 9 ++++++---
> >  fs/ocfs2/journal.h | 1 +
> >  2 files changed, 7 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> > index 530fba34f6d3..6f837296048f 100644
> > --- a/fs/ocfs2/journal.c
> > +++ b/fs/ocfs2/journal.c
> > @@ -968,7 +968,7 @@ int ocfs2_journal_init(struct ocfs2_super *osb, int=
 *dirty)
> >
> >       ocfs2_set_journal_params(osb);
> >
> > -     journal->j_state =3D OCFS2_JOURNAL_LOADED;
> > +     journal->j_state =3D OCFS2_JOURNAL_INITED;
> >
> >       status =3D 0;
> >  done:
> > @@ -1039,6 +1039,7 @@ void ocfs2_journal_shutdown(struct ocfs2_super *o=
sb)
> >       int status =3D 0;
> >       struct inode *inode =3D NULL;
> >       int num_running_trans =3D 0;
> > +     enum ocfs2_journal_state state;
> >
> >       BUG_ON(!osb);
> >
> > @@ -1047,8 +1048,9 @@ void ocfs2_journal_shutdown(struct ocfs2_super *o=
sb)
> >               goto done;
> >
> >       inode =3D journal->j_inode;
> > +     state =3D journal->j_state;
> >
> > -     if (journal->j_state !=3D OCFS2_JOURNAL_LOADED)
> > +     if (state !=3D OCFS2_JOURNAL_INITED)
> >               goto done;
> >
> >       /* need to inc inode use count - jbd2_journal_destroy will iput. =
*/
> > @@ -1076,7 +1078,7 @@ void ocfs2_journal_shutdown(struct ocfs2_super *o=
sb)
> >
> >       BUG_ON(atomic_read(&(osb->journal->j_num_trans)) !=3D 0);
> >
> > -     if (ocfs2_mount_local(osb)) {
> > +     if (ocfs2_mount_local(osb) && state =3D=3D OCFS2_JOURNAL_LOADED) =
{
> >               jbd2_journal_lock_updates(journal->j_journal);
> >               status =3D jbd2_journal_flush(journal->j_journal, 0);
> >               jbd2_journal_unlock_updates(journal->j_journal);
> > @@ -1174,6 +1176,7 @@ int ocfs2_journal_load(struct ocfs2_journal *jour=
nal, int local, int replayed)
> >               }
> >       } else
> >               osb->commit_task =3D NULL;
> > +     journal->j_state =3D OCFS2_JOURNAL_LOADED;
> >
> >  done:
> >       return status;
> > diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
> > index e3c3a35dc5e0..a80f76a8fa0e 100644
> > --- a/fs/ocfs2/journal.h
> > +++ b/fs/ocfs2/journal.h
> > @@ -15,6 +15,7 @@
> >
> >  enum ocfs2_journal_state {
> >       OCFS2_JOURNAL_FREE =3D 0,
> > +     OCFS2_JOURNAL_INITED,
> >       OCFS2_JOURNAL_LOADED,
> >       OCFS2_JOURNAL_IN_SHUTDOWN,
> >  };


Thanks,
--=20
Julian Sun <sunjunchao2870@gmail.com>
