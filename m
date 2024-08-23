Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985452B9D4
	for <ocfs2-devel@lists.linux.dev>; Fri, 23 Aug 2024 02:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724379760; cv=none; b=a12jmDHF659PtZ7gWf+9YkUs8UX/CpKjEbiqaqEoJvS2P6zm9cmSc72qb/QGRUwXRlX6vUBnmYT8pum6rq+/UHfS6jNx/HjHP7MBeGx5KP6ftYQI/Suf0tjM6PMH/48WCvyBGiQ76ld6drvqUMT6JBkRmHV5ViauUfYjfC+XY8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724379760; c=relaxed/simple;
	bh=erTdsxzbdZT/QQcG88bZo9dzUVWNjSrm087p9lCbGFY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mzgoSsnLoqgr1pfrF9vsU5otiYlNPbpy4/jXtlRNu0hZ6i0PJAz80EGhUCJJrJHDoDCzYaBqjV4NZBP29Fy+9Hsgs3B1I82f4Zwu7MAaKbjv5yFhRy3gFHMhPAWs3ymqjH0xuCmgWc57ggpKa94fijmuvWofM4y4ybFMnlI4EK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MvXLZWXr; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MvXLZWXr"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-20227ba378eso13490535ad.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 22 Aug 2024 19:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724379758; x=1724984558; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=erTdsxzbdZT/QQcG88bZo9dzUVWNjSrm087p9lCbGFY=;
        b=MvXLZWXr2ETsSZL3h18cVJI9z86nVWKBxQ4WLuB4L1s2STBCcq8moQJLXXkVhj+VRw
         ImKUeBpGDY7zHziLLPTcSZdkZYslm+3vCqNykrrjgXxi2WgioOhFcECG9twtSmWMOt5v
         K4aA+IfF4jyTF3ECjUM/ZOHja5gwSdGBFFZ3egY/38cT9Y+fUQP276OIgPf98QNODL7S
         kO69/bOYly+/vNgAG5Gl1EKbXxIheaYMOHn6i2CoEkkKTji9PIqVmSIJxLMQlFkmZPO0
         P+sTiIpOJ6beGz7qo7ys42oDg0/AWROmIsKL353oiKXau0SOOFOPWB0wvp0xJECdwQ9m
         5n3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724379758; x=1724984558;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=erTdsxzbdZT/QQcG88bZo9dzUVWNjSrm087p9lCbGFY=;
        b=wFTdkUwDxGoMEiUXxBDd61IbU4RiIJGH3Sit5AvE2E/ftm80XZt+QPGNKyiRmCi55T
         uhp3ZIUS4BUSC17yezPZjBLLuH9gbHaMBN0IgEpz6PssrCQK1mvfOchUsJZraPP5+iND
         FKdZ9Ovu82FHUC+BbbnGyzKOIUeB4YgbOvT8WcyEvtZl8kQ1LO06IodUO4WEyF4DZx7/
         4HYhZ12b8qEKaW/xrt7+51UgbPcT/UW2Hk0GVKZug5xZg120i2F1iswZdK1yaMXsMjp/
         htaHhIQs4aTvs83aTRTxScF6oMl8P+qPA9Vt+OGf67IUJFbUQlXVRATEFnIW6GUNSzwX
         UVvw==
X-Gm-Message-State: AOJu0YznTjoJpTFb/ds/kzdWTp7qeyGdyDXCgUeQ0O31+jaVX+zdYHBX
	IGzaOXV9IIkP11IIhVSTRd0QfRghKZMmhFAzeCnzfsovFPrsRQGn
X-Google-Smtp-Source: AGHT+IF25cioZhWU+vFz7RFv8QJuvVfHDsr4NbB9b3LhriDV2uxCqPMpjAXwgvgWp6S5BYGMymycmQ==
X-Received: by 2002:a17:902:e850:b0:1fb:6663:b648 with SMTP id d9443c01a7336-2039e46ce19mr7731365ad.21.1724379757301;
        Thu, 22 Aug 2024 19:22:37 -0700 (PDT)
Received: from [127.0.0.1] ([174.139.202.7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-203855df626sm18902745ad.127.2024.08.22.19.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2024 19:22:36 -0700 (PDT)
Message-ID: <e7acce1eb19af9798f0c64bdba5fe75688f37c2c.camel@gmail.com>
Subject: Re: [PATCH] ocfs2: fix null-ptr-deref when journal load failed.
From: Julian Sun <sunjunchao2870@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, jlbec@evilplan.org, mark@fasheh.com, 
	syzbot+05b9b39d8bdfe1a0861f@syzkaller.appspotmail.com
Date: Fri, 23 Aug 2024 10:22:30 +0800
In-Reply-To: <eb9f35a7-e3ab-47cf-a043-c03f11c21c97@linux.alibaba.com>
References: <20240819131120.746077-1-sunjunchao2870@gmail.com>
	 <26da607a-530d-4dc1-9040-bf56b406b98f@linux.alibaba.com>
	 <CAHB1NaiJJmf838FwSGM8UZX6ebQn8L2hhFxNAcdmRDfBo1VUyg@mail.gmail.com>
	 <eb9f35a7-e3ab-47cf-a043-c03f11c21c97@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, 2024-08-23 at 09:59 +0800, Joseph Qi wrote:
>=20
>=20
> On 8/20/24 11:19 PM, Julian Sun wrote:
> > Joseph Qi <joseph.qi@linux.alibaba.com> =E4=BA=8E2024=E5=B9=B48=E6=9C=
=8820=E6=97=A5=E5=91=A8=E4=BA=8C 21:03=E5=86=99=E9=81=93=EF=BC=9A
> > >=20
> > >=20
> > >=20
> > > On 8/19/24 9:11 PM, Julian Sun wrote:
> > > > During the mounting process, if the jbd2_journal_load()
> > > > call fails, it will internally invoke journal_reset()
> > > > ->journal_fail_superblock(), which sets journal->j_sb_buffer
> > >=20
> > >=20
> > > > This description is not right.
> > > > journal_reset() fails because of too short journal, then lead
> > > > to
> > > > jbd2_journal_load() fails with NULL j_sb_buffer.
> > yeah. That's exactly what I described.
> > >=20
> > > > to NULL. Subsequently, ocfs2_journal_shutdown() calls
> > > > jbd2_journal_flush()->jbd2_cleanup_journal_tail()->
> > > > __jbd2_update_log_tail()->jbd2_journal_update_sb_log_tail()
> > > > ->lock_buffer(journal->j_sb_buffer), resulting in a
> > > > null-pointer dereference error.
> > > >=20
> > > > To resolve this issue, a new state OCFS2_JOURNAL_INITED
> > > > has been introduced to replace the previous functionality
> > > > of OCFS2_JOURNAL_LOADED, the original OCFS2_JOURNAL_LOADED
> > > > is only set when ocfs2_journal_load() is successful.
> > >=20
> > >=20
> > > > Or set OCFS2_JOURNAL_LOADED only after JBD2_LOADED?
> > I don't think this is correct. We first call ocfs2_journal_init(),
> > which allocates some resources, before calling jbd2_journal_load().
> > If
> > ocfs2_journal_init() succeeds but jbd2_journal_load() fails, this
> > solution may lead to a resource leak.
> > If there is anything important I'm missing, please let me know,
> > thanks.
> >=20
>=20
> Okay, seems except iput(inode) and kfree(journal), we may have to do
> the
> following cleanup:
> 1) ocfs2_inode_unlock(journal->j_inode);
> 2) brelse(journal->j_bh);
> 3) OCFS2_I(inode)->ip_open_count--
> 4) jbd2_journal_destroy()
> ...
>=20
> So it seems that introducing a new state will be more clear.
>=20
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
> > > > index 530fba34f6d3..6f837296048f 100644
> > > > --- a/fs/ocfs2/journal.c
> > > > +++ b/fs/ocfs2/journal.c
> > > > @@ -968,7 +968,7 @@ int ocfs2_journal_init(struct ocfs2_super
> > > > *osb, int *dirty)
> > > >=20
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ocfs2_set_journal_params(osb);
> > > >=20
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0 journal->j_state =3D OCFS2_JOURNAL_LOADED=
;
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0 journal->j_state =3D OCFS2_JOURNAL_INITED=
;
> > > >=20
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 status =3D 0;
> > > > =C2=A0done:
> > > > @@ -1039,6 +1039,7 @@ void ocfs2_journal_shutdown(struct
> > > > ocfs2_super *osb)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int status =3D 0;
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct inode *inode =3D NULL;
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int num_running_trans =3D 0;
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0 enum ocfs2_journal_state state;
> > > >=20
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BUG_ON(!osb);
> > > >=20
> > > > @@ -1047,8 +1048,9 @@ void ocfs2_journal_shutdown(struct
> > > > ocfs2_super *osb)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 goto done;
> > > >=20
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 inode =3D journal->j_inode;
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0 state =3D journal->j_state;
> > > >=20
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0 if (journal->j_state !=3D OCFS2_JOURNAL_L=
OADED)
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0 if (state !=3D OCFS2_JOURNAL_INITED)
>=20
> This is not right.
> What if journal has already been loaded?
Hi, Joseph

Thanks for your review and comments.

I'm not sure if I fully understand what you mean.=20
Because the functionality of OCFS2_JOURNAL_INITED is completely
equivalent to the original OCFS2_JOURNAL_LOADED, so do you mean that
there might be an issue with the original OCFS2_JOURNAL_LOADED? If so,
I will dig it into and try to fix.
But in any case, that should be a separate patch.

If there is any misunderstanding, please let me know, thanks.
>=20
> Thanks,
> Joseph
>=20
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 goto done;
> > > >=20
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* need to inc inode use count - jbd=
2_journal_destroy
> > > > will iput. */
> > > > @@ -1076,7 +1078,7 @@ void ocfs2_journal_shutdown(struct
> > > > ocfs2_super *osb)
> > > >=20
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BUG_ON(atomic_read(&(osb->journal->j=
_num_trans)) !=3D 0);
> > > >=20
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0 if (ocfs2_mount_local(osb)) {
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0 if (ocfs2_mount_local(osb) && state =3D=
=3D
> > > > OCFS2_JOURNAL_LOADED) {
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 jbd2_journal_lock_updates(journal->j_journal);
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 status =3D jbd2_journal_flush(journal->j_journal,
> > > > 0);
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 jbd2_journal_unlock_updates(journal->j_journal);
> > > > @@ -1174,6 +1176,7 @@ int ocfs2_journal_load(struct
> > > > ocfs2_journal *journal, int local, int replayed)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 }
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 osb->commit_task =3D NULL;
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0 journal->j_state =3D OCFS2_JOURNAL_LOADED=
;
> > > >=20
> > > > =C2=A0done:
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return status;
> > > > diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
> > > > index e3c3a35dc5e0..a80f76a8fa0e 100644
> > > > --- a/fs/ocfs2/journal.h
> > > > +++ b/fs/ocfs2/journal.h
> > > > @@ -15,6 +15,7 @@
> > > >=20
> > > > =C2=A0enum ocfs2_journal_state {
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 OCFS2_JOURNAL_FREE =3D 0,
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0 OCFS2_JOURNAL_INITED,
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 OCFS2_JOURNAL_LOADED,
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 OCFS2_JOURNAL_IN_SHUTDOWN,
> > > > =C2=A0};
> >=20
> >=20
> > Thanks,

