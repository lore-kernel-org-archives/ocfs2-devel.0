Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC4B19E968
	for <ocfs2-devel@lists.linux.dev>; Fri,  3 Jan 2025 03:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735875091; cv=none; b=D79ge1q9X1+Cs6HPHt4E1LDrh07sh9wMPS5ktrzLzB85+Nrb2LnO5P/jBPv1Cg/gkvyHXKOHaUIBoZWjnLN3Yyio7PztQtTjKiXc0k0Sr/ssoH+2WC+83egy0hD5b+u4FtIuxSRSDQ2iMGDhcb7WrLIb7GKd2CdDBHr5LU+h4Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735875091; c=relaxed/simple;
	bh=BWv0bQhDgA2KGcaXfza+Cv68E7ka2hZIIH/MVWdcTv4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lkRAKPV/WxRg7AtmMfl2cPf4osrZCJVs2yuG3/oO4X9DXagfF7ymbVbIuBe5yNB29DDrjrhCNtrzllgHxxejDtX54b6aMHSGHFi9a2Ak8CUxF775Yl2xL3sZ/1FoR0EA5FlAfUVlt/Rx/D63185g55zeSOc+zrtxUIJYAndkJ4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QhbzSPTg; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QhbzSPTg"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-53f22fd6887so11412816e87.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 02 Jan 2025 19:31:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735875087; x=1736479887; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qPLXpbhnKoH9eP2vA9bLrxLu1+f40z5UESYHZ11D4qg=;
        b=QhbzSPTgFdgNNvtAXA5f02cZBVMJlY6Dafoglun4pjHhQH0Hh7d9h7L4Hhu/Kotqj0
         3u3iudR+Gji+AIuvdkKKIW7do60wIfp4xztzHR5W5dmvS8UmOEvkXVUOnbCyy3kGFD+T
         0/hOeoILW931VytYPGRSybJ/UG8/Sa0ErvwubikIx5srruTxCyq6OVQSfRkH93Jtp3fg
         eRNEEx9w5v+/TEpzlILp+gGChin2WiqAwYc/7+VkuLA+mzV1Lqehy09cFiPH58jhtLs+
         aYRE1dF3ZSsHT5d5Z1tD2cwAFG1+YuriR5YOKD8AizG/y7lncGCJ2KiRZi7czM3Wzn/a
         1v/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735875087; x=1736479887;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qPLXpbhnKoH9eP2vA9bLrxLu1+f40z5UESYHZ11D4qg=;
        b=vpUH6Dd5vEGmlxFF+CXk1TuxzUNVnU5LsqoAsCfkN2k0w4JEhJJDLUVHKeXpGHuhX6
         zPfKpMxEhGP3jKtIHWF3HZ2bfyCPyehkEgvL6NXtQ2bQKZuhwlZ+0f3MfrNSEaynuPRs
         O8BHRLhRNKpHVuGTfW29xc6L3wZSt8NghtEcyEgOfIP2p8JQpU8BwvoJBGA+vfuKFTx5
         qM3LuC/TxDjX5B1IiIJr1Zz4S6kdwNyH7+d9NRkyvI42J0oHXHwB2yY6F+fcevgaQjzz
         uFH8MqI6CW0ie1XLJjnMNqY6wjtzM7naLb5ZgUcHfQRN2/e1zgmEL12Ep120wBbthrNP
         VMuw==
X-Gm-Message-State: AOJu0Yzl/j63BJyW5QRKB5jryZlpEscbrWoN2rPaXeH8gBcOqfADQc4V
	S6xNJqDX1o0VFNvqAb1uVR/j7LEPdhu2FTTenT6aHb0+zU7fBxxvjLYPOFHtz+eN6GL9QxEkZyK
	fOfvQws07seclUDdpYOm/hw2aDjxESKVkR6gYl7l3
X-Gm-Gg: ASbGncsIoANcZpc6goaNqANthi7ECOb3DZlTbTTMVd8M5hDX/GOIHiyywes6nWgbBDz
	u4vaUQQLy22vpT2JJiGtX97X0ybHpDSNGLYX10HLH
X-Google-Smtp-Source: AGHT+IH4qxy03ZU6YEWDspSIhNHpqeNPumr98RdKZlI1fyhokku+pMarnnaGqFk9im+rugVwuSHOToX/1CGb8fc/xVE=
X-Received: by 2002:a05:6512:318c:b0:542:2943:db06 with SMTP id
 2adb3069b0e04-54229547836mr13977014e87.33.1735875086989; Thu, 02 Jan 2025
 19:31:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250102124539.711325-1-sunjunchao2870@gmail.com>
 <20250102124539.711325-2-sunjunchao2870@gmail.com> <d0cae4f9-f9de-42d6-b2a6-0a7e1352746b@linux.alibaba.com>
In-Reply-To: <d0cae4f9-f9de-42d6-b2a6-0a7e1352746b@linux.alibaba.com>
From: Julian Sun <sunjunchao2870@gmail.com>
Date: Fri, 3 Jan 2025 11:31:16 +0800
Message-ID: <CAHB1Nai=vu1-zi2MdWXsepi7hRQJ1HOPKzubpzon_wbFP8qz2w@mail.gmail.com>
Subject: Re: [PATCH 2/2] ocfs2: Correct l_next_free_rec in online check
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, mark@fasheh.com, jlbec@evilplan.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Joseph Qi <joseph.qi@linux.alibaba.com> =E4=BA=8E2025=E5=B9=B41=E6=9C=883=
=E6=97=A5=E5=91=A8=E4=BA=94 09:22=E5=86=99=E9=81=93=EF=BC=9A
>
>
>
> On 2025/1/2 20:45, Julian Sun wrote:
> > Correct the value of l_next_free_rec to l_count during the online
> > check, as done in the check_el() function in ocfs2_tools.
> >
> > Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
> > ---
> >  fs/ocfs2/inode.c | 24 ++++++++++++++++++++++++
> >  1 file changed, 24 insertions(+)
> >
> > diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> > index 2cc5c99fe941..c19f40b4c876 100644
> > --- a/fs/ocfs2/inode.c
> > +++ b/fs/ocfs2/inode.c
> > @@ -200,6 +200,20 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, =
u64 blkno, unsigned flags,
> >       return inode;
> >  }
> >
> > +static int ocfs2_dinode_has_extents(struct ocfs2_dinode *di)
> > +{
> > +     /* inodes flagged with other stuff in id2 */
> > +     if (di->i_flags & (OCFS2_SUPER_BLOCK_FL | OCFS2_LOCAL_ALLOC_FL |
> > +                        OCFS2_CHAIN_FL | OCFS2_DEALLOC_FL))
> > +             return 0;
> > +     /* i_flags doesn't indicate when id2 is a fast symlink */
> > +     if (S_ISLNK(di->i_mode) && di->i_size && di->i_clusters =3D=3D 0)
> > +             return 0;
> > +     if (di->i_dyn_features & OCFS2_INLINE_DATA_FL)
> > +             return 0;
> > +
> > +     return 1;
> > +}
> >
> >  /*
> >   * here's how inodes get read from disk:
> > @@ -1547,6 +1561,16 @@ static int ocfs2_filecheck_repair_inode_block(st=
ruct super_block *sb,
> >                    le32_to_cpu(di->i_fs_generation));
> >       }
> >
> > +     if (ocfs2_dinode_has_extents(di) && le16_to_cpu(di->id2.i_list.l_=
next_free_rec) >
> > +         le16_to_cpu(di->id2.i_list.l_count)) {
>
> Seems the following way looks better.
>
> if (ocfs2_dinode_has_extents(di) &&
>     le16_to_cpu(di->id2.i_list.l_next_free_rec) > le16_to_cpu(di->id2.i_l=
ist.l_count)) {
>         ...
> }
>
> So could you please resend this series with prefix 'PATCH v2'?

Fixed it in next version, thanks.
>
> Thanks,
> Joseph
>
> > +             di->id2.i_list.l_next_free_rec =3D di->id2.i_list.l_count=
;
> > +             changed =3D 1;
> > +             mlog(ML_ERROR,
> > +                  "Filecheck: reset dinode #%llu: l_next_free_rec to %=
u\n",
> > +                  (unsigned long long)bh->b_blocknr,
> > +                  le16_to_cpu(di->id2.i_list.l_next_free_rec));
> > +     }
> > +
> >       if (changed || ocfs2_validate_meta_ecc(sb, bh->b_data, &di->i_che=
ck)) {
> >               ocfs2_compute_meta_ecc(sb, bh->b_data, &di->i_check);
> >               mark_buffer_dirty(bh);
>

Thanks,
--=20
Julian Sun <sunjunchao2870@gmail.com>
