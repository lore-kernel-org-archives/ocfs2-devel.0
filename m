Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A1117BB0C
	for <ocfs2-devel@lists.linux.dev>; Fri, 30 Aug 2024 11:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725016973; cv=none; b=P/AgXuLkr5CQZYG1d1Xt/JBUqAya0Mlz8olSiYJW2Do4EZkiFhPj6azpzhkf+fQpZz03/ZAqWiEReM+Onzz1IobeSi9iP0jsSBkvsGabOZ0bx7iz4IRX9sVKWl/u6/9n6KosPVL1BTTs0FoV3cTUYWrhLV+FU4HiNKF3cbi1i70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725016973; c=relaxed/simple;
	bh=wIwvwUKOG3OEM+ezI3gYak2Vy1upJS1iUcuQZHF6yzA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=epBYVs7wjScNe9J7XwoZ6b3xdPvfWJe5QryaHGOp304dJdKXbxKdu1PookcJhX60WWjHSsJRVikM1V4Pu1OJeX0UVCxkGd4JNxQxRNVG6VWS6QE6E7wM/90QULfIewEQHLdrQLYd6fHbh6EqTx6y93gmLqYL+KaZ5DXVB7peiL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H8+k4xXw; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H8+k4xXw"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2050b059357so13886105ad.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 30 Aug 2024 04:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725016971; x=1725621771; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wIwvwUKOG3OEM+ezI3gYak2Vy1upJS1iUcuQZHF6yzA=;
        b=H8+k4xXwukzerdz9iC6C8qQhM/7o6q8ydu/kWwhM/hBIAUR20je9zGKB0jPC7MIzz6
         u0YRIL3ss+ZnJHcIuDVr9M2YC9mVUaqi4QiyXxjuYYr8QjZrRD37xRn/7eedO7Lg6VaC
         wkWMVgpqukjtiDWQJXGrlIZ6iVDMv9jDF3RSUKlTOu/nrLnq3HhKra3JqquYQi6RSnqx
         2233OSpwQe3UV7oQsTNSlpUIZN54zSmILqaq0yAY68NWbYCrovQBGFuVXVkMgihMdO34
         Gbij29X3iPOE46dApe5nFT3vXk3TgSYQp9l8bWqmC0Um6MgTJodlcfbFz5Z2aARGJG6D
         BYMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725016971; x=1725621771;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wIwvwUKOG3OEM+ezI3gYak2Vy1upJS1iUcuQZHF6yzA=;
        b=M7KZdQeQPppfaLgE88R2l0wwxLsYsFDi6eC1ctx8lMFmsYSbLjIQyqlLAY7mliVVwW
         c4BSjpO0q7hPh9QIqGi7eXE3aBHmjgcoZGhFP/Qc9OpxpPogoKJz/9MHfOavG+OUZ9yL
         jxSqaUOZRHnBgHsDF8NLxeIw2Mn3SpfHqhNIWIAexAmRnTZi6NU7xhH9+J83GDE4fjr3
         zV2WwfiF0uI2fL5kTQgwQxYCyrNBAZpzWj7ncmfHLWnE2XC0WjiQF9bxR/0yFuOEIdPl
         MmYS9SZs98QtWEAnsXSnCShq55u2zoHxFGLGWnr5m6NkwfW1wQWa8b7Z9X68itk8afrX
         3lVA==
X-Forwarded-Encrypted: i=1; AJvYcCWWHQtpyODA26AzdhRkd9PDB+5wAqhCH5T2NfpnQ507l7gi2n3vXmJFoBQXMCf03YZocb8JlJUc/qFxFw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwZWRfeWOfbWLsUJ9nR17VxN3GyNIArXBiUkOdoHgCqyKVGUMso
	JOhD5+acz3vdZp9Jz+t7E7GonWmhiIsMFYVp/dbsxYlPkBCBgyTj
X-Google-Smtp-Source: AGHT+IErjP0D6RKllvAb7gUkYZwg48gl2oGqB/1lqa8kY/FIEYH8slpwneV2kGtGyF3uvURQmH7Tjw==
X-Received: by 2002:a17:902:e54d:b0:202:e83:eb11 with SMTP id d9443c01a7336-2050c3fac93mr65673575ad.29.1725016970833;
        Fri, 30 Aug 2024 04:22:50 -0700 (PDT)
Received: from [127.0.0.1] ([103.85.75.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-205152b3175sm25047205ad.54.2024.08.30.04.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2024 04:22:50 -0700 (PDT)
Message-ID: <df71a155cb7b9cad2cc2d8c4262dfcc075f18946.camel@gmail.com>
Subject: Re: [PATCH v2] ocfs2: fix null-ptr-deref when journal load failed.
From: Julian Sun <sunjunchao2870@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@lists.linux.dev
Cc: lbec@evilplan.org, mark@fasheh.com, 
	syzbot+05b9b39d8bdfe1a0861f@syzkaller.appspotmail.com, 
	"linux-kernel@vger.kernel.org"
	 <linux-kernel@vger.kernel.org>, Heming Zhao <heming.zhao@suse.com>
Date: Fri, 30 Aug 2024 19:22:47 +0800
In-Reply-To: <fe86da76-555d-424a-828f-ea99b05b363f@linux.alibaba.com>
References: <20240823083150.17590-1-sunjunchao2870@gmail.com>
	 <07dea72e-8b93-4095-9347-4ff765a2539d@linux.alibaba.com>
	 <cf4174af158587cabd525ae23d35c0b399eade47.camel@gmail.com>
	 <fe86da76-555d-424a-828f-ea99b05b363f@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, 2024-08-30 at 18:58 +0800, Joseph Qi wrote:
>=20
>=20
> On 8/30/24 6:11 PM, Julian Sun wrote:
> > On Fri, 2024-08-30 at 17:40 +0800, Joseph Qi wrote:
> > >=20
> > >=20
> > > On 8/23/24 4:31 PM, Julian Sun wrote:
> > > > During the mounting process, if journal_reset() fails
> > > > because of too short journal, then lead to
> > > > jbd2_journal_load() fails with NULL j_sb_buffer.
> > > > Subsequently, ocfs2_journal_shutdown() calls
> > > > jbd2_journal_flush()->jbd2_cleanup_journal_tail()->
> > > > __jbd2_update_log_tail()->jbd2_journal_update_sb_log_tail()
> > > > ->lock_buffer(journal->j_sb_buffer), resulting in a
> > > > null-pointer dereference error.
> > > >=20
> > > > To resolve this issue, a new state OCFS2_JOURNAL_INITED
> > > > has been introduced to replace the previous functionality
> > > > of OCFS2_JOURNAL_LOADED, the original OCFS2_JOURNAL_LOADED
> > > > is only set when ocfs2_journal_load() is successful.
> > > > The jbd2_journal_flush() function is allowed to be called
> > > > only when this flag is set. The logic here is that if the
> > > > journal has even not been successfully loaded, there is
> > > > no need to flush the journal.
> > > >=20
> > > > Link:
> > > > https://syzkaller.appspot.com/bug?extid=3D05b9b39d8bdfe1a0861f
> > > > Reported-by:
> > > > syzbot+05b9b39d8bdfe1a0861f@syzkaller.appspotmail.com
> > > > Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
> > > > ---
> > > > =C2=A0fs/ocfs2/journal.c | 9 ++++++---
> > > > =C2=A0fs/ocfs2/journal.h | 1 +
> > > > =C2=A02 files changed, 7 insertions(+), 3 deletions(-)
> > > >=20
> > > > diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> > > > index 530fba34f6d3..da0ffcc5de0a 100644
> > > > --- a/fs/ocfs2/journal.c
> > > > +++ b/fs/ocfs2/journal.c
> > > > @@ -968,7 +968,7 @@ int ocfs2_journal_init(struct ocfs2_super
> > > > *osb,
> > > > int *dirty)
> > > > =C2=A0
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ocfs2_set_journal_p=
arams(osb);
> > > > =C2=A0
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0journal->j_state =3D OCF=
S2_JOURNAL_LOADED;
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0journal->j_state =3D OCF=
S2_JOURNAL_INITED;
> > > > =C2=A0
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0status =3D 0;
> > > > =C2=A0done:
> > > > @@ -1039,6 +1039,7 @@ void ocfs2_journal_shutdown(struct
> > > > ocfs2_super *osb)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int status =3D 0;
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct inode *inode=
 =3D NULL;
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int num_running_tra=
ns =3D 0;
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0enum ocfs2_journal_state=
 state;
> > > > =C2=A0
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0BUG_ON(!osb);
> > > > =C2=A0
> > > > @@ -1047,8 +1048,9 @@ void ocfs2_journal_shutdown(struct
> > > > ocfs2_super *osb)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0goto done;
> > > > =C2=A0
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inode =3D journal->=
j_inode;
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0state =3D journal->j_sta=
te;
> > > > =C2=A0
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (journal->j_state !=
=3D OCFS2_JOURNAL_LOADED)
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (state !=3D OCFS2_JOU=
RNAL_INITED && state !=3D
> > > > OCFS2_JOURNAL_LOADED)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0goto done;
> > > > =C2=A0
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* need to inc inod=
e use count - jbd2_journal_destroy
> > > > will
> > > > iput. */
> > > > @@ -1076,7 +1078,7 @@ void ocfs2_journal_shutdown(struct
> > > > ocfs2_super *osb)
> > > > =C2=A0
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0BUG_ON(atomic_read(=
&(osb->journal->j_num_trans)) !=3D 0);
> > > > =C2=A0
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ocfs2_mount_local(os=
b)) {
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ocfs2_mount_local(os=
b) && state =3D=3D
> > > > OCFS2_JOURNAL_LOADED) {
> > >=20
> > > The only intent of the new introduced state is to identify if
> > > journal
> > > is
> > > truly loaded or not.
> > > So it seems that the simplest way to fix this is just check
> > > JBD2_LOADED
> > > here.
> > >=20
> > > if (ocfs2_mount_local(osb) &&
> > > =C2=A0=C2=A0=C2=A0 (journal->j_journal->j_flags & JBD2_LOADED)) {
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0...
> > > }
> > Hi, Joseph, thanks for your review and comments.=C2=A0
> >=20
> > Yeah! It's absolutely the simplest and cleanest way to fix this
> > issue.
> > Thanks for your suggestion.
> > >=20
> > > BTW, could you please also replace 'osb->journal->j_num_trans' to
> > > 'journal->j_num_trans'?
> > Sure.
> > >=20
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0jbd2_journal_lock_updates(journal->j_journal)=
;
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0status =3D jbd2_journal_flush(journal->j_jour=
nal,
> > > > 0);
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0jbd2_journal_unlock_updates(journal-
> > > > >j_journal);
> > > > @@ -1174,6 +1176,7 @@ int ocfs2_journal_load(struct
> > > > ocfs2_journal
> > > > *journal, int local, int replayed)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0} else
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0osb->commit_task =3D NULL;
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0journal->j_state =3D OCF=
S2_JOURNAL_LOADED;
> > >=20
> > > It seems that this has to be moved just after
> > > jbd2_journal_load().
> > > Anyway, I don't think we have to introduce a new state. See
> > > above.
> > >=20
> > Agreed. And now OCFS2_JOURNAL_LOADED is set when
> > ocfs2_journal_init()
> > succeed, it may led to some misunderstanding: the journal was not
> > really loaded when OCFS2_JOURNAL_LOADED was set. I would like to
> > rename
> > it to OCFS2_JOURNAL_INITED in another patch to make it clearer.
>=20
> Umm... You can treat it as ocfs2 journal state only, not jbd2.
> Also jbd2 doesn't have 'initialized' state either.
> So I don't think we have to do this change in the fix.
>=20
> Joseph=C2=A0=20
Got it. Thanks for your explanation.

Thanks,
--=20
Julian Sun <sunjunchao2870@gmail.com>
