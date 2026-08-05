Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6523DAAC8
	for <ocfs2-devel@lists.linux.dev>; Wed,  5 Aug 2026 20:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785962046; cv=pass; b=Gm4kTFymieSCuwYe9M5ns0dNqyTAOgzrXn2VNI7alaE1u2lJ8lH7mBrDBSSvye8UfstPgvup3yXA6yFwUupHNVPOxf/1lqHL1MeSW6/qvYr0e484HOLDIBcoK8GZ5oEHoRv8e7aGhcppYzyxRErHz6QxXjSHYra+hVn2SgIv3hM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785962046; c=relaxed/simple;
	bh=Tq1GUshZ0URB5eunwgA44UJvtqfscr+nNVhjP+E6wLw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m7i08MmzkWyCfyDGL8Z0548iI6boodp0XjC2K1ZzT0IypzcVenteeujsm4tcEMupEWDFPLeBHpzWzo3t7fTUzkYmR2Los7ayLW+XCJJ+M1FX8tCq2VBjyT35eqQtXOD+Tfg1SYtyvyCU4e3m4a/SgAVQXNqX7m/cyUPRaENdXlE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ewQI3diE; arc=pass smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ewQI3diE"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-49fa951b2c6so921290b6e.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 05 Aug 2026 13:34:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785962044; cv=none;
        d=google.com; s=arc-20260327;
        b=grwKq93m0h+OPMBMygwl00SGSdAHhRoPvv+856JJDG1kPivW7IbuAUefXTYR7UbdPV
         xdjgSmPvdD/vTWkIZWZ/16tkWPAWI8tmzEhSZGVuRZtZkjKPgCpHSOXhopwU/gCZ1Zdt
         rYnX1Vz4FmjsFEOb+1nmdlyuy38vm4B4VkzFw6ojv88dvHKqSVlhb4kY2KEqU6Q5r+8m
         NQXcnQ6qZqZ5b4rt21966MHW+7MH5X0DzRttW7OkyUKhU7s/kkz+teXeJbyNw4qxDn9g
         mBPzMMbgdt/URRc3GzVIl33ctr6eRcF5H1Lc3jTiBuYRNGV40lVMwc5I5n9YfzAiWN9y
         VASw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kA/AU2w3280P+roGG7oJQqeX77M5dx6w+CVBmDt93wg=;
        fh=shDrqEcz8sFd/MBY3miVlkFPdrRuf3Pwg63DeNHka4U=;
        b=rTsKAUNCqBcBOfte2s12JZNLZvxFQXD/IJmpSPrJ/42Xycn5DBvOuIQrQtwIPcCDYK
         xQ5nN3F7f9tjeoYnge+icLTMklpy5fW4VbdVo17VtZNWlLy8qf1EBCvpLgV2/95cpzwH
         bQxhqkIhtpzCveDGiR9eivL/kIh9c5H3C/PcMRn/2Rkm6Rg/j6pu93PFAxpco/lDbAb+
         +Fyc1t8vCQ1R3h9d5VAX7Ntn58HnjpYahul3fOrm08eEsRyCRr1t6/6Gdo/TAj9Epv9L
         XY8o47OefLUOOFKQY+2/MrjsHVdiyn8A+MrJQx+kb8y6ag40qoZkHKE0SrpyV+9IiLRc
         +laQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785962044; x=1786566844; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kA/AU2w3280P+roGG7oJQqeX77M5dx6w+CVBmDt93wg=;
        b=ewQI3diEAbjgeINLiEhfn90V0OgpantzUswVOsXYBwjtYIoN6Jie1lbWnofxCAtlab
         uERPAkJUzVk1FQbfi7JmFH/hO3ykN649qtn4eMXda/hNkk8Ws2cuUaq/HbUmZN7royOw
         jZzG7Ud7Ghr5GNaRwa//reOIEY/7zd1prNfmcvHKa4qTy51wfva/mE3W/BUYffhPz1Gl
         lbtHEq+IXrZV+3Ex1ujJKuEEmp/WYulYzDjKb1+q5gCm2McjXcIizSUL7FE7lLUeG1Tc
         njpXySjQMMx1RdosO1P8E2bDdo9AH/wOGUMLvs3lIVQLJMpwZeUwFqE1LcBMPab6Uhzl
         YxGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785962044; x=1786566844;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kA/AU2w3280P+roGG7oJQqeX77M5dx6w+CVBmDt93wg=;
        b=X20ZoJU2OTMHxoVrzN+W89INmDTm1jFzcobpYsf+aomush4ZYaCNVigIxU6Ty0o2oE
         CGZC1WdRPQgIx3mtDgopkTe0u+437TxtynYX1qLXtKRsjHjCfB0CU1fcykxYhICyneKl
         lwDtf4RgCZFRSRW6tkES5ja3HaIPuugIrFLZn25JEUPbJl0eujNQ8p67DJ4NImay9rDc
         q2mIGv6IL+/JhzjGvzf5xPpB3u4+zEayYNgVofa7REyED/8P7zWLorfygBl+/O+fdwNU
         S2D+E6axfSe5R5SWdVJmNGIXLXv0+42BRlqOx/yHAA2Tp5jvv34S/8gkfMOoVv1oRHdM
         DoxA==
X-Forwarded-Encrypted: i=1; AHgh+RqMRsd0LAe1Sr2xqf7+SQEs6rnPfPj5fQ4qaKrRG7Kvkg4/LP2eJH9Ds3kzocK7EzbPliUtTRb52QaosA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz3kNitlDnx+CT6y10i81ozIffcS+yFRrGEfuoxczATPu/Z1XFh
	ofUuPAP65dIo8VGgKwMa4hvHHlZ5jKgOdlBNAKp5FRhFvEWqebo7FkD5EsKr/gW7jh5yhQQFiH8
	JiWMfzJFQgo2BfsxmPslHtBHR0aqX3Ns=
X-Gm-Gg: AR+sD13iReSK/04sZcLmTpzlvh7nTc13XRv8db3gZqpnqJxHAIlwD53DVYC2hdDVMKy
	3GzWQGIgRuAW+rb67pYfE9X39ElNijbZwFI9w31C/4bQLq5tlgHtaSMsVuNraSVYC1RO/aIAv4M
	notSxf1kUFLjqMpMu6/xhbWY8wLSzlTZGRH/9RKXICtJy90R8TpaIAjLQPmMsSDEKpBOYG8pfAy
	Wii1Y205cCS66avRbxOw6XKru8QrQq8Mid5B6PQE+VT2dBZ3jLp8CuOhJgS4me7IVqE2rurVkLQ
	k+t0ANUDqto5/k9rNlD2DIXDKtWADKzmaPFfmI3sViTW
X-Received: by 2002:a05:6820:208c:b0:6ac:a539:bc41 with SMTP id
 006d021491bc7-6ae96c8ef34mr4814921eaf.12.1785962043824; Wed, 05 Aug 2026
 13:34:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1785621505.git.coshi036@gmail.com> <8aa2ee674d147d3630f73f7b53fef7781f2aeccc.1785621505.git.coshi036@gmail.com>
 <3dqz5hq2phvgugscfk56q2h6ukf2fc3xfgjhoat222sonbhnr3@62pmosi6frzu>
In-Reply-To: <3dqz5hq2phvgugscfk56q2h6ukf2fc3xfgjhoat222sonbhnr3@62pmosi6frzu>
From: Chris S <coshi036@gmail.com>
Date: Wed, 5 Aug 2026 16:33:51 -0400
X-Gm-Features: AUfX_myim6QhFCyzhdj6B0pWIapAMcNebREVxjcQh-jpAusyaGfXWmZ1mZSgYNA
Message-ID: <CACd_6n2WkaxmmKMi7WidJKLJF7sUGfXzXkeQp4pW1W-tjTn4OA@mail.gmail.com>
Subject: Re: [PATCH 17/19] jbd2: assert on a failed write, not on a buffer
 that is not up to date
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

Taken - v2 keeps the assertion on buffer_uptodate() and only changes the
message to "Buffer not uptodate!\n".

You are right that a write error is fine here.  I had converted it on the
grounds that BH_Uptodate stops meaning "the last write worked", but that wa=
s
answering the wrong question: what this assert is guarding is that there is
valid data to copy at all, which is still exactly what BH_Uptodate says.

Best,
Chao

On Tue, Aug 4, 2026 at 5:05=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> On Sat 01-08-26 18:01:01, Chao Shi wrote:
> > jbd2_freeze_jh_data() asserts that the buffer it is about to copy out i=
s up
> > to date.  Once this series stops clearing BH_Uptodate on write error, t=
hat
> > assertion stops firing for the case it was written for, because a buffe=
r
> > whose write failed stays up to date - which is the point: the in-memory
> > copy being frozen is still the data the filesystem wants written.
> >
> > Assert on the condition that still means something went wrong.  The mes=
sage
> > loses its "Possible", because BH_Write_EIO is not a guess.
> >
> > Suggested-by: Jan Kara <jack@suse.cz>
> > Signed-off-by: Chao Shi <coshi036@gmail.com>
> ...
> > diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> > index 5cc7d097b2ac..fdabe34a7e22 100644
> > --- a/fs/jbd2/transaction.c
> > +++ b/fs/jbd2/transaction.c
> > @@ -920,7 +920,7 @@ static void jbd2_freeze_jh_data(struct journal_head=
 *jh)
> >       char *source;
> >       struct buffer_head *bh =3D jh2bh(jh);
> >
> > -     J_EXPECT_JH(jh, buffer_uptodate(bh), "Possible IO failure.\n");
> > +     J_EXPECT_JH(jh, !buffer_write_io_error(bh), "IO failure.\n");
>
> After some more thought I think getting here a buffer_write_io_error()
> buffer is actually OK and we'll rewrite it. Instead this assert should ju=
st
> have a different message:
>
>         J_EXPECT_JH(jh, buffer_uptodate(bh), "Buffer not uptodate!\n");
>
> to verify the buffer has valid data.
>
>                                                                 Honza
>
>
> >       source =3D kmap_local_folio(bh->b_folio, bh_offset(bh));
> >       /* Fire data frozen trigger just before we copy the data */
> >       jbd2_buffer_frozen_trigger(jh, source, jh->b_triggers);
> > --
> > 2.43.0
> >
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
