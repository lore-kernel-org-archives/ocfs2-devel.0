Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4D5199FCD
	for <ocfs2-devel@lists.linux.dev>; Fri, 30 Aug 2024 10:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725012714; cv=none; b=ZCQM4vEgGLe++XhAWWhC2DrGEIji4BDNZpdRH2aJ8KU5dueBmZds+69eVUHEe6jamk7snKEryyqBppOc2TRp6fPhSe6iRDs2fuMQ9eJPCOY/20uIkPSezefxA/DAYqgY/IZ6wAEHA9D/o/euQm4LPdXWy+5+NY19uj89Ys69ScY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725012714; c=relaxed/simple;
	bh=26Ca6vMm1oviq71AbCgAIOw9/GdoUlRwpZXXZkEb4Fk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IzHI45Ud6wJ6NMtuw834eWMeb4EMSge+ceuwnsntO45UXmm5yvegdNdklzdQkACS5YVVT+839vz0aN2z+m1u4oUokgNx3pH0BxJZ83V2D84yba/sAdlrgdUyuQfyWcevqIDUIYOnroDO+NsIKLITT0TkfymQe3yQZa7RVKtogxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IilerUpl; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IilerUpl"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2020ac89cabso17391475ad.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 30 Aug 2024 03:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725012712; x=1725617512; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=26Ca6vMm1oviq71AbCgAIOw9/GdoUlRwpZXXZkEb4Fk=;
        b=IilerUplpdzSndrSmRuVjDOd5OXC303IWTSNkLEj7sXXLY1JC2Vr62uYgD+B2QNkIu
         FhPvfrXlHAYbJnEEOU9ClSAE+jc71J3E8dkDFcmGZwtQdyM7Fo+B405ySEwxlvvinlOm
         lL2Ix66IPlNYgeNk7q283+W2x6eg8xmcTNwMdQbjJxiTBD7T86kVRzqow+GV//ZoxXp8
         ik/h9ZHoLy2Ar0Ut4mcr5HTztfzYFhbADlqmnFrdvmPY+YBXSePDyZFaGb17ZrryEE+M
         lxwtnrCnTddDdFf3BZO6rdT0PVFzHt5zYGUa0rUt4h+vwV7Wivw/zAJnAkdMwGb9GACp
         hAaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725012712; x=1725617512;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=26Ca6vMm1oviq71AbCgAIOw9/GdoUlRwpZXXZkEb4Fk=;
        b=PVCxMR6Y/ufMNCezy8ZuBO2pNnmyRFBqX23xlTQpdOPEkG0JbnMAMpcuYhdKgpXepA
         zKGdVo1xFxlDdCQN3hjRkNISc4VVBAWogM3sGdVrWJDv00N13SL7hynNtMUFZsYy3eo4
         IX2AC+CGhnp0a3Mlwc5RHRIrl6IQNv0M2Ou0dY39/aeZ3/zw6pui0zLhDagY64VJImgi
         orOLCw9GrZRwmBYsD3S0T486kwPH7IrJvtm1xbHdbf44a6+3y2YiwZsRuVVZ/FUJZeTi
         ECmBTctkJYt+wNFCEGP73NxcK05/kYTMx/PcgfkmDv75RBzQhw4Ir+53URXd8GPZIgU4
         R0xg==
X-Forwarded-Encrypted: i=1; AJvYcCWNJzdvmw7dy5WiWSUcocouSGaih1G2lfGbh6gsFxHSSY/IifJkAi8H/XRxBYbi/2D9LFod98l9z4eA4A==@lists.linux.dev
X-Gm-Message-State: AOJu0YyIVRdrg2KFKyqw2330/HDm2rhnWg/1j0XH2mvOTeWOV/RcfhCz
	5Xrcqg2yojWqbPapo+P6H5AmRYine3deoICVHxD+NtJHC0qkSnEB
X-Google-Smtp-Source: AGHT+IEPl32t/Wy2FfG64Z9IGfE7a6++/+S6tHLrG4sBCisl4W+4mnWpNDiEmFvkNBahXNHCyeWqgg==
X-Received: by 2002:a17:902:c94b:b0:202:1176:5e39 with SMTP id d9443c01a7336-2050c4891cdmr51843845ad.56.1725012711735;
        Fri, 30 Aug 2024 03:11:51 -0700 (PDT)
Received: from [127.0.0.1] ([103.85.75.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-205152b33eesm24116395ad.32.2024.08.30.03.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2024 03:11:51 -0700 (PDT)
Message-ID: <cf4174af158587cabd525ae23d35c0b399eade47.camel@gmail.com>
Subject: Re: [PATCH v2] ocfs2: fix null-ptr-deref when journal load failed.
From: Julian Sun <sunjunchao2870@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@lists.linux.dev
Cc: lbec@evilplan.org, mark@fasheh.com, 
	syzbot+05b9b39d8bdfe1a0861f@syzkaller.appspotmail.com, 
	"linux-kernel@vger.kernel.org"
	 <linux-kernel@vger.kernel.org>, Heming Zhao <heming.zhao@suse.com>
Date: Fri, 30 Aug 2024 18:11:48 +0800
In-Reply-To: <07dea72e-8b93-4095-9347-4ff765a2539d@linux.alibaba.com>
References: <20240823083150.17590-1-sunjunchao2870@gmail.com>
	 <07dea72e-8b93-4095-9347-4ff765a2539d@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, 2024-08-30 at 17:40 +0800, Joseph Qi wrote:
>=20
>=20
> On 8/23/24 4:31 PM, Julian Sun wrote:
> > During the mounting process, if journal_reset() fails
> > because of too short journal, then lead to
> > jbd2_journal_load() fails with NULL j_sb_buffer.
> > Subsequently, ocfs2_journal_shutdown() calls
> > jbd2_journal_flush()->jbd2_cleanup_journal_tail()->
> > __jbd2_update_log_tail()->jbd2_journal_update_sb_log_tail()
> > ->lock_buffer(journal->j_sb_buffer), resulting in a
> > null-pointer dereference error.
> >=20
> > To resolve this issue, a new state OCFS2_JOURNAL_INITED
> > has been introduced to replace the previous functionality
> > of OCFS2_JOURNAL_LOADED, the original OCFS2_JOURNAL_LOADED
> > is only set when ocfs2_journal_load() is successful.
> > The jbd2_journal_flush() function is allowed to be called
> > only when this flag is set. The logic here is that if the
> > journal has even not been successfully loaded, there is
> > no need to flush the journal.
> >=20
> > Link: https://syzkaller.appspot.com/bug?extid=3D05b9b39d8bdfe1a0861f
> > Reported-by: syzbot+05b9b39d8bdfe1a0861f@syzkaller.appspotmail.com
> > Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
> > ---
> > =C2=A0fs/ocfs2/journal.c | 9 ++++++---
> > =C2=A0fs/ocfs2/journal.h | 1 +
> > =C2=A02 files changed, 7 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> > index 530fba34f6d3..da0ffcc5de0a 100644
> > --- a/fs/ocfs2/journal.c
> > +++ b/fs/ocfs2/journal.c
> > @@ -968,7 +968,7 @@ int ocfs2_journal_init(struct ocfs2_super *osb,
> > int *dirty)
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ocfs2_set_journal_param=
s(osb);
> > =C2=A0
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0journal->j_state =3D OCFS2_J=
OURNAL_LOADED;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0journal->j_state =3D OCFS2_J=
OURNAL_INITED;
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0status =3D 0;
> > =C2=A0done:
> > @@ -1039,6 +1039,7 @@ void ocfs2_journal_shutdown(struct
> > ocfs2_super *osb)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int status =3D 0;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct inode *inode =3D=
 NULL;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int num_running_trans =
=3D 0;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0enum ocfs2_journal_state sta=
te;
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0BUG_ON(!osb);
> > =C2=A0
> > @@ -1047,8 +1048,9 @@ void ocfs2_journal_shutdown(struct
> > ocfs2_super *osb)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0goto done;
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inode =3D journal->j_in=
ode;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0state =3D journal->j_state;
> > =C2=A0
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (journal->j_state !=3D OC=
FS2_JOURNAL_LOADED)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (state !=3D OCFS2_JOURNAL=
_INITED && state !=3D
> > OCFS2_JOURNAL_LOADED)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0goto done;
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* need to inc inode us=
e count - jbd2_journal_destroy will
> > iput. */
> > @@ -1076,7 +1078,7 @@ void ocfs2_journal_shutdown(struct
> > ocfs2_super *osb)
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0BUG_ON(atomic_read(&(os=
b->journal->j_num_trans)) !=3D 0);
> > =C2=A0
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ocfs2_mount_local(osb)) =
{
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ocfs2_mount_local(osb) &=
& state =3D=3D
> > OCFS2_JOURNAL_LOADED) {
>=20
> The only intent of the new introduced state is to identify if journal
> is
> truly loaded or not.
> So it seems that the simplest way to fix this is just check
> JBD2_LOADED
> here.
>=20
> if (ocfs2_mount_local(osb) &&
> =C2=A0=C2=A0=C2=A0 (journal->j_journal->j_flags & JBD2_LOADED)) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0...
> }
Hi, Joseph, thanks for your review and comments.=C2=A0

Yeah! It's absolutely the simplest and cleanest way to fix this issue.
Thanks for your suggestion.
>=20
> BTW, could you please also replace 'osb->journal->j_num_trans' to
> 'journal->j_num_trans'?
Sure.
>=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0jbd2_journal_lock_updates(journal->j_journal);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0status =3D jbd2_journal_flush(journal->j_journal=
, 0);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0jbd2_journal_unlock_updates(journal->j_journal);
> > @@ -1174,6 +1176,7 @@ int ocfs2_journal_load(struct ocfs2_journal
> > *journal, int local, int replayed)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0} else
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0osb->commit_task =3D NULL;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0journal->j_state =3D OCFS2_J=
OURNAL_LOADED;
>=20
> It seems that this has to be moved just after jbd2_journal_load().
> Anyway, I don't think we have to introduce a new state. See above.
>=20
Agreed. And now OCFS2_JOURNAL_LOADED is set when ocfs2_journal_init()
succeed, it may led to some misunderstanding: the journal was not
really loaded when OCFS2_JOURNAL_LOADED was set. I would like to rename
it to OCFS2_JOURNAL_INITED in another patch to make it clearer.
> Joseph
>=20
> > =C2=A0
> > =C2=A0done:
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return status;
> > diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
> > index e3c3a35dc5e0..a80f76a8fa0e 100644
> > --- a/fs/ocfs2/journal.h
> > +++ b/fs/ocfs2/journal.h
> > @@ -15,6 +15,7 @@
> > =C2=A0
> > =C2=A0enum ocfs2_journal_state {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0OCFS2_JOURNAL_FREE =3D =
0,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0OCFS2_JOURNAL_INITED,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0OCFS2_JOURNAL_LOADED,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0OCFS2_JOURNAL_IN_SHUTDO=
WN,
> > =C2=A0};

Thanks,
--=20
Julian Sun <sunjunchao2870@gmail.com>
