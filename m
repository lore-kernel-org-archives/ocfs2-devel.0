Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B2C3D3CEB
	for <ocfs2-devel@lists.linux.dev>; Wed,  5 Aug 2026 20:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785962004; cv=pass; b=H+87BbRMh7Flp/+lzonwT1JeMXowmYXART69QOK+6YT7mhIANvK6uD2G1WOonxhoWx6eQOikrTZnRR0d0o7lRidEg0utUZzDSBg4WojGNbXMgFNh2D/BOCyMZuWjAoDrSp5lOlRf2mOQpHVL6FhhzVYwc3Zruzi+3/3vUe0lP4s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785962004; c=relaxed/simple;
	bh=GI8C7x7/1X74WCp4xq6Tj+lGkjg4R7DvkuG6i1NAga4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=saXhXbkbpq7E0LRl+EciVyoEAsZ8yFC+o94SX3VRsMIcrw/3vbP0OEDNusMe7sJAQGMIFh07NQrZEdMC2QxEO9UxbuwC2ykUreBUqaJCDyf2tpqI+ZeUIJaO5jFtSdFbo8tDpKCM1AjUUYtaxA6D0dZx6O3D3VR97uYk3AA408c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZtMJQsTp; arc=pass smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZtMJQsTp"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7eb545db3afso1077697a34.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 05 Aug 2026 13:33:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785962002; cv=none;
        d=google.com; s=arc-20260327;
        b=VwVnB5eyQw/JbYtZAD4199/sqXacKdzchW0XGBMeqHRmvnwkroxyTxyxolRcbTlyUB
         bulRtUuNkItbEXGn2NpNKEeEjKeevjHKQZt4anOOUE3xzBy/4BP+wKM2Rkru9BbRcSgV
         N81XKi5VpwUQr+FG9DEsXQtSU3Uf0+mZNgkpYJYDA4kohAsEx6n7RAu+wY9YOQX9m5MQ
         LmaMQDtd2bpKZ7osRp/RxdESbusTdfOTsJlm+4l2sn8DFoxjPk9OERrMCzw7spB29vb4
         ADK3eTc9af1H2hIVdVvFmNCsQ5WsL4agtU/8+Nwbq+BeQtq8mWEXOWMC+9iDne5fFOlF
         6XzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WXwiR/pZJKH9ofJG0kWfM6Ol7KNG5CJwWwWByT6iJt0=;
        fh=7wtSiPV9uZZBmSoUY/GnTS/eQfq0E5MBpb/DaOyW4G4=;
        b=Q+vBcHvVSTLQdcpjr3uHJ8DXRpRm/eKqeEB4HW+w46YNlDkMx3U1iaj2dkDY3koFiy
         xcG4dhZN8+sV3F55HobWsqfWrgmd+3n1OvW2pCFL5Njg/hfCg5Ps1D/36mLtfTqUse+8
         zpICI3GYEP8Tn0Oe2ZcyJCR7Epi71oMCeg+3mmOM1QBPMy5T0HChdJnQ7ZOeWkLUD80z
         xgKe2UZ+tnI42woTxhbWmuumzDl43c43bPJLfXOL6E0aCIJygRIjsV+cOPqaDka9rmSX
         4EiCjOHK2A3LPburd+L4SgKq09CfAn/ArOEU6bFpmEOpzKJIxs+JGK/8KWcnhgfM+IPu
         Wbog==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785962002; x=1786566802; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WXwiR/pZJKH9ofJG0kWfM6Ol7KNG5CJwWwWByT6iJt0=;
        b=ZtMJQsTpd3sBDCxI5ojveVuIgw0oKSs5g+lzA5Np/uhRhOq87XEW80hAYS7rfl73gx
         u8J8VzHmnWIBIGvxfnJfJA2gdRQx4UgjW6ttFzos18iFzm+rIWCQvq0t2vVEGsC5Z1Wx
         +UWsIEuQ551oYvYMIawS8M1gNe5fqL4h51Ga6UUd5UD45TIZLCP44ibkIqyuMXyQGvul
         4ahhxRx6ch11f4xuz8Ugy9oOuqZ+J8z1Wk+Y4uxisq8F/QRImBchJGK3/3PCG3yHIFuw
         +Q/rF7bjkYnBaoJcYcYxCsspG+BaSHzDDa8yJv+ABh1cZ08aLvBx+5GsW+7vunuZtnnv
         2Adg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785962002; x=1786566802;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WXwiR/pZJKH9ofJG0kWfM6Ol7KNG5CJwWwWByT6iJt0=;
        b=ODbwh4uvH2WQJBCgzzberMFNB6j3gmFmjKzx1A1Cdpeg/GPOWiscUtyntVi6LLS41a
         3vJA3nmL+UUcs/Djud2bhseQanOJiDUVpBFYtVOMCakzGvMhs9fzwLkZLrSwwj8i+Lk3
         ByDQHLt5+j7RkbVC89f8e2KgAVMrR9zVZHra7btD1eTJ9ZCo7xbja+8dBkhlhOOaYN03
         jfFPvEA3fIVmf2taTpmueQA72tAPteaB1MHNrPla1nGJ7JF+sBLDG8CFEPV8p0iBbQMx
         XjlZuaSl2AciPQijzHry4DI3lTTjPZU8WH/nHoSWYl4wnFT2xn1ArSP5uAOdQ1DZM2PY
         JNTQ==
X-Forwarded-Encrypted: i=1; AHgh+RpBay4WdohEW5VGQeh0s4ku8vQu79D4PJJeJHQ4yeRdpD1e3/2v66aVLLHe/MftTY3JRzkFXSeDsE4Lew==@lists.linux.dev
X-Gm-Message-State: AOJu0YyTBWsOCzRRA28GwihPGTnahZfkbWaQj60SqwBvMI9lqOWQ8ckR
	a48LV3uOs46FwNV2hVItc79DWyAPMCXf3ZJmGjIuT2e9MgH703cqe0K7IINJdyjNAXliqzxvbe0
	lgSoUV0aGRfElF/u85a7YM96bvca3SiE=
X-Gm-Gg: AR+sD10zQ8gW2ayrh+l37AGdWPBLO3r5JXWVNnw2ThvUr2VdAzZ8Fx4KQo1eryPWY0t
	d5YMRMB76Wg/msSYpoRUfShYobgBfAPUr2S9cAaXAk1s8ksROP7TMGQkC1kztJuK/t6DA2f6o/W
	oFnoYAUwSQ71AsycT5iupK4jP+0/3RdyGRPjoJ9mewbrO0xxqrJUGFhE+ejjYA2A8gncRo0rBkf
	NRZB1en6LAkctkvpF4j1bHE4spu8IEG7XMl4Uwdj2WwDQZxjq3j2AKM/gvy+84UCL7goRuaCSRX
	XOUiG9P7NDQw4usTP2vT3N4Qc4YSm1LggE/Ro+GMmAYF
X-Received: by 2002:a05:6820:4b8e:b0:6a1:4a27:cd22 with SMTP id
 006d021491bc7-6ae968d0ddbmr5568777eaf.0.1785962002030; Wed, 05 Aug 2026
 13:33:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1785621505.git.coshi036@gmail.com> <f0e0fd8516487b774d8cf1384949a0c616921fbd.1785621505.git.coshi036@gmail.com>
 <ppnbgcljrjb5wqqvqiyh254wkunfutydykgbi7zheuf2mfdjqv@j6lngn5vywxj> <7qfbpj66hdtxc23lox63hqss42yo5xz2dazigf7nwdorplmec5@vv6jsnqa6viu>
In-Reply-To: <7qfbpj66hdtxc23lox63hqss42yo5xz2dazigf7nwdorplmec5@vv6jsnqa6viu>
From: Chris S <coshi036@gmail.com>
Date: Wed, 5 Aug 2026 16:33:07 -0400
X-Gm-Features: AUfX_mwz8K3T1Z_fWdMufWIMTQu1kthOhf45o3aWABfKf2Yu8afHwh21AjQl4bU
Message-ID: <CACd_6n2fBNVQF3UXth_WxGWHMLm7SysDbcQ3PrJc32nDfpMwCQ@mail.gmail.com>
Subject: Re: [PATCH 16/19] jbd2: report journal write errors with BH_Write_EIO
To: Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org, 
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, 
	Bob Copeland <me@bobcopeland.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Andreas Gruenbacher <agruenba@redhat.com>, linux-ext4@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, gfs2@lists.linux.dev, 
	linux-karma-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Done in v2, and 'success' it is - thanks for the follow-up, that is what
fs/buffer.c calls it.

        if (!success)
                   mark_buffer_write_io_error(bh);

Patch 21 adds a clear_buffer_write_io_error() to the success side, so the
final shape has both arms again, but nothing touches BH_Uptodate either way=
.

Best,
Chao

On Tue, Aug 4, 2026 at 5:10=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> On Tue 04-08-26 10:54:37, Jan Kara wrote:
> > On Sat 01-08-26 18:01:00, Chao Shi wrote:
> > > The journal's own write completion handler,
> > > journal_end_buffer_io_sync(), reports a failed write by clearing
> > > BH_Uptodate, and the three places that wait for journal writes look f=
or
> > > that.  This series is removing that convention: a buffer whose write =
failed
> > > still holds the data that was supposed to reach the disk, and saying =
it is
> > > not up to date makes callers rewrite, re-read or WARN over data that =
was
> > > never wrong.
> > >
> > > Set BH_Write_EIO instead, with mark_buffer_write_io_error(), and test=
 it in
> > > journal_wait_on_commit_record() and in the two commit-phase waits.
> > >
> > > The two changes have to go together, because commit phase 4 waits on =
a
> > > mixed list: descriptor blocks are submitted with
> > > journal_end_buffer_io_sync(), while revoke blocks go through
> > > write_dirty_buffer() and land in bh_end_write().  bh_end_write() alre=
ady
> > > sets BH_Write_EIO, so converting the consumer alone would keep workin=
g for
> > > revoke blocks and silently stop detecting failed descriptor writes.  =
With
> > > the handler converted, both halves of the list report the same way.
> > >
> > > mark_buffer_write_io_error() is safe on all of these buffers.  The sh=
adow
> > > buffers from jbd2_journal_write_metadata_buffer() have no folio and n=
o
> > > associated mapping, so it does nothing beyond setting the flag.  Desc=
riptor
> > > and commit blocks are ordinary buffers on the journal device, and mar=
king
> > > the journal's mapping with the error is what write_dirty_buffer() alr=
eady
> > > does for revoke blocks on the same device.
> > >
> > > Signed-off-by: Chao Shi <coshi036@gmail.com>
> > > ---
> > >  fs/jbd2/commit.c | 8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> > > index 60273cddf434..8912786ebebb 100644
> > > --- a/fs/jbd2/commit.c
> > > +++ b/fs/jbd2/commit.c
> > > @@ -39,7 +39,7 @@ static void journal_end_buffer_io_sync(struct bio *=
bio)
> > >     if (uptodate)
> > >             set_buffer_uptodate(bh);
> > >     else
> > > -           clear_buffer_uptodate(bh);
> > > +           mark_buffer_write_io_error(bh);
> >
> > There's no need to set uptodate flag here at all (all callers set it be=
fore
> > submitting IO). So you can just simplify this to:
> >
> >       if (!uptodate)
> >               mark_buffer_write_io_error(bh);
> >
> > Also I'd rename the local variable from 'uptodate' to 'ioerr' or someth=
ing
> > like that.
>
> Sorry, not 'ioerr' but rather 'success'. I can see fs/buffer.c names it l=
ike
> that.
>
>                                                                 Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
