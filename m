Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D156415FD1A
	for <ocfs2-devel@lists.linux.dev>; Wed, 29 May 2024 06:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716965947; cv=none; b=EJDkA9lWCBKb0IyPRJarPNBHdqK6wKqoLGbwPaLQFuJrj/gE2qlktQqhcHNLYxAitSY7n9mTX/aLC/XEdcjVzem48C2IHj7u7Gw+HY+k6d4l8guh7ULMLEzeChjBZukRWlqiKVJA8De0Bq4EXFhORo84Jy25txCL0Tb5Zcuzyjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716965947; c=relaxed/simple;
	bh=m2S20M1iz5MhWZRVNBCOMRA9juLWxQI9W+jycbDmAiE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mQ8M2oclJq6CmhMXRcuUdKXiw4Wye5iDign5dWaRkdqqrcazug2w6Wclmb6YK1tOM2NUvUAQsD4yESqMcxmV0hwHXPuZyN3JeVXUMRsq/Q4rcGSAJwI9vUSDMBKTLMtsO5xfIMtg3lcGtERgljJR9YbtVLbjk/MpVUhqBzkpRYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PRG68MWn; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PRG68MWn"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-62a2424ec39so16606237b3.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 28 May 2024 23:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716965945; x=1717570745; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KR9ZQ0jJDbfk3C8hO+ne9vLbi+yl/2Fq1lg4wLA1jqI=;
        b=PRG68MWnTVW7CWnUY47IUu378CAWwwgFUTRYbGwMgyc9NtGseqQo0We2t6jZSxWVDN
         uUOncN23nQWRqHEaiwZ1W7kWyUlrpyEUM50GwjgNx+qf03/6WcPXPIEcyWQ6L75BUadV
         UbOPy8/S7FTK5P0qZ0jCrvUp+A9p6C9iC1C4BtvJ4ull7Odn0Cw7JRbziBmlGKUc1bh2
         h1qc+5E2lWNDU7dV9ooCLPQPKST8HNviWslQsJ0KtWnt23wl6B1+QUEXB1rck7cs7ZeH
         KRA6VNVmkBkWSCxd+sKi9HJOisEFxz1MBgSsDgP2Q1U/lXSvROIDBDshE2QREM94e32e
         z4sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716965945; x=1717570745;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KR9ZQ0jJDbfk3C8hO+ne9vLbi+yl/2Fq1lg4wLA1jqI=;
        b=qjrGs9fJLA5PSAkTDBrYKxOaF2L4b0sgwwsoQKfO5+fA/M1gwSJqKb2xnnyyz/slS+
         LTMUNfWmujLDMXbPAWxwYQu4ylslZ+z8j+iVrYlSj822kyqGGmqgjSuv+31Kl9fvBZkk
         rrz7MDk99JjwelXgX38FGlgvtCgYCf2ZQIcLcb0kO+/AyWKvnRrnSmV1Y7zuV1SCNLYc
         ywPg7nSn2TDZ9L2UG3LvYrOMHK2Luzavnw6R+vCa90ZVmrZIobYJcR2JwWXzB55ZVT2p
         k/3SHKtLf0YHBJs8WMBrdLlpDsKZdFQMn70UEmuRNnWPHv8jU+O33PsGxDx4yKulz0+i
         /4+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXgu9ir8TsmfCVXTlQ39oLBZVMLsF96EpgQbCvZKxe6hbhMY1l/1E2fZI3n7uy2NlaqAjdykwkkyYrjuHLOxOPui1YjfXdMpfEPsLg=
X-Gm-Message-State: AOJu0YxdUb8RVUt4HEL3yH7UbMdYvuBYxzepx0C8CLyt0eNoXlFcTsS6
	gInsDUWVZCDlaR9DR501opjJojw20+Ul1epyOqeWIZmZKgrlYg34F+DDjDgSeoT2OMc6vV23S1m
	zPmN9YTExpG9lkN3HDi6kxTjSNDc=
X-Google-Smtp-Source: AGHT+IGRIw7DIU9jMC9HDiI20hSsIEbMZQs9mAfaByjOZ0ZRQI8MLBtF39KfiqUHJQKUaV3/WfB5K8larC8bGivCWys=
X-Received: by 2002:a81:ac5b:0:b0:61b:1c6f:830e with SMTP id
 00721157ae682-62a08f3a353mr138267547b3.43.1716965944061; Tue, 28 May 2024
 23:59:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240528120140.15550-1-llfamsec@gmail.com> <22f06d3c-5781-43d8-8169-678ef2299ddb@linux.alibaba.com>
 <CAEBF3_bE4vkF3En7MKJFbgvRruS-n61g5RiuMDk6nT4ig7GmZg@mail.gmail.com> <89f8c4b1-46c5-4eec-9595-5cf456621887@linux.alibaba.com>
In-Reply-To: <89f8c4b1-46c5-4eec-9595-5cf456621887@linux.alibaba.com>
From: lei lu <llfamsec@gmail.com>
Date: Wed, 29 May 2024 14:58:52 +0800
Message-ID: <CAEBF3_ae=MEyoY73q7H4nydjHJiH08jaUKqBZo=EyP_NjvDDKQ@mail.gmail.com>
Subject: Re: [PATCH v2] ocfs2: add bounds checking to ocfs2_search_dirblock()
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks, I apologize for not being very familiar.
Could you take some time to write a patch for this issue.

Thanks,
LL

Joseph Qi <joseph.qi@linux.alibaba.com> =E4=BA=8E2024=E5=B9=B45=E6=9C=8829=
=E6=97=A5=E5=91=A8=E4=B8=89 14:15=E5=86=99=E9=81=93=EF=BC=9A
>
>
>
> On 5/29/24 11:18 AM, lei lu wrote:
> > Joseph Qi <joseph.qi@linux.alibaba.com> =E4=BA=8E2024=E5=B9=B45=E6=9C=
=8829=E6=97=A5=E5=91=A8=E4=B8=89 09:33=E5=86=99=E9=81=93=EF=BC=9A
> >>
> >>
> >>
> >> On 5/28/24 8:01 PM, lei lu wrote:
> >>> Add a check to make sure all members of the ocfs2_dir_entry
> >>> don't stray beyond valid memory region.
> >>>
> >>> Signed-off-by: lei lu <llfamsec@gmail.com>
> >>> ---
> >>>  fs/ocfs2/dir.c | 15 ++++++++-------
> >>>  1 file changed, 8 insertions(+), 7 deletions(-)
> >>>
> >>> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> >>> index d620d4c53c6f..56e2f8c62106 100644
> >>> --- a/fs/ocfs2/dir.c
> >>> +++ b/fs/ocfs2/dir.c
> >>> @@ -352,19 +352,20 @@ static inline int ocfs2_search_dirblock(struct =
buffer_head *bh,
> >>>       de_buf =3D first_de;
> >>>       dlimit =3D de_buf + bytes;
> >>>
> >>> -     while (de_buf < dlimit) {
> >>> +     while (de_buf < dlimit - OCFS2_DIR_MEMBER_LEN) {
> >>>               /* this code is executed quadratically often */
> >>>               /* do minimal checking `by hand' */
> >>>
> >>>               de =3D (struct ocfs2_dir_entry *) de_buf;
> >>>
> >>> -             if (de_buf + namelen <=3D dlimit &&
> >>> +             /* do a full check */
> >>> +             if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
> >>> +                     ret =3D -1;
> >>> +                     goto bail;
> >>> +             }
> >>
> >> What's the difference by moving full check above?
> >> As I commented in v1, we may add a more check in ocfs2_check_dir_entry=
().
> >
> > Thanks for your time.
> >
> > If no match is found, there is no check for de. I'm not sure if there
> > will be any OOB elsewhere when "de->rec_len <
> > OCFS2_DIR_REC_LEN(de->name_len)".
> >
> > I'm not sure what "(de - bh->b_data) + de_len > bytes -
> > OCFS2_DIR_REC_LEN(de->name_len)" means in V1, bh->b_data is the start
> > offset of ocfs2_dinode. bytes is just the size of the de list. Maybe
> > we should check "((char *) de - bh->b_data) + rlen > sizeof(struct
> > ocfs2_dinode) + bytes" which is same as "((char *) de - bh->b_data) +
> > rlen > dlimit".
> >
>
> You can refer ext4_check_dir_entry() for details.
>
> >>
> >>> +
> >>> +             if (de->name + namelen <=3D dlimit &&
> >>
> >> As discussed in v1, this change looks reasonable.
> >>
> >> Thanks,
> >> Joseph
> >>
> >>>                   ocfs2_match(namelen, name, de)) {
> >>> -                     /* found a match - just to be sure, do a full c=
heck */
> >>> -                     if (!ocfs2_check_dir_entry(dir, de, bh, offset)=
) {
> >>> -                             ret =3D -1;
> >>> -                             goto bail;
> >>> -                     }
> >>>                       *res_dir =3D de;
> >>>                       ret =3D 1;
> >>>                       goto bail;
