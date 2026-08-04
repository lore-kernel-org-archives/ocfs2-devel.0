Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C95B33A9E1
	for <ocfs2-devel@lists.linux.dev>; Tue,  4 Aug 2026 06:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785826124; cv=pass; b=M1l0bG2C3YD2CkUgx6L6Ss1TlquNojJldarwyscmLQLN9NJpKfCj+RQTT2SGFDKOgsSYYwfKr1kdoOjZzP+uzNtCDwf3FY9s5fHpyMhWQ7ED1Lpmj99jhwjfy4KcGfN8OMP9T8AHBHUPhglvl3zky6bQEgi2LCAyRbe5MpN0b08=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785826124; c=relaxed/simple;
	bh=gLA/TrNXOJ7d129j/A4JZO6DZ6bYwBeG7nNh071o5yc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YvkxTSU71uMp5aGTFACjhW8Ryv0ATPm75RgrIksb5q+biGPMi9fNmb6WQBmCTCHBzXsHp/Rl9vugo5h/OOAGF6luTEBttzgeTPnQDj2S5Z2aHrmmaauzQRCF3Bzm625whoetfbxXZE6XnD4fHQAyalH2t1laljqF9aPq+zPbQo8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hT/Q4qs9; arc=pass smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hT/Q4qs9"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c15ca7a7ca9so413042966b.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 03 Aug 2026 23:48:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785826121; cv=none;
        d=google.com; s=arc-20260327;
        b=hJPi87txkWFE6me/m3kjj8mxm5fj9aBH+Q0gWItYupM6fxhVfSAanldQ9ZVJL17xoq
         wRh5wWGZ+s9B+X0H4N+tA1scpBkiNmVPE/coK/Y4cs34r+rgVO92Pz5hRjoTxq0mTzf6
         8pE+gdg89IMPBTwsJOiMqoh+7zGCJE+qpPVn5rq66HE1DktJtnWrMRwBZMjiBFBVvJkH
         pgwAu5/5o5ltXIDR6tQhft5UJquIqvkzRkj56RdCCaEqL3d+eXz5k5IJ5EHPiNRfQ76o
         gTrAtJgtW7rA82PIQYFwuclUTH73+7fceWlkL5EQTniVVWcKd3q5INTC8pHOqK+kVbPi
         wemA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zEVXlrHL1Mp76Yn2gUaccJHB2Am9dI97FF7RVMZ7+yU=;
        fh=tC8yD67Odx2Lj+NjJ4Fv4TtaKlr7gALy4fRGJ+tb06M=;
        b=p89hS951oXoO/V2rNitIbj1gToZeOjI/UpwUfwT00sk4bANfl1XxCgdRZ5Vt8sp3qf
         sjvgmR8YzOvIeXiT/GHUUSc7XeqBJg8sbCO5mEVybeIuElPtFDarANSIxDAfwcmgNu4x
         0jT2qx8fUjagqGl7E7ZJ2NTHoe6dBMtGTunFDuvXzkKU5F1sUF/+KCg4dlUp+uM7h4Gi
         e7OscfhFrQtSkfs1r/1qbMN24L19MuPfrvGIYv5RpPNJ9SnzhIB45FW2RSZvOxfMQJyr
         3xMqRhV9bOCfuv0hsZPcS5McXLDH2LUJj85Vp3/W1pfy0gwTlZawxKvPCA3YLzS/M6NZ
         sMBw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785826121; x=1786430921; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zEVXlrHL1Mp76Yn2gUaccJHB2Am9dI97FF7RVMZ7+yU=;
        b=hT/Q4qs92DoRzG484xVnVcl27vcz3G4QiM1a2TknGUpR88Rft1BBZuVHUVbIF2ONve
         Ai9tiRwiPraFJQ1d6dq04W0puIMkt4R8IKt/VOSpJIGAp9v9sOCZo5e77f9979lb22oo
         LYlJHn9gZR/cV53FykV8QJa3VDlJWQujYIPO1Bu7BX7LuEhQ8AiMk4AS18XMUbpqqwrs
         LtHZ3yvHXPDo+iu5Fen2Z82jalILk/mcjwxJtyzNSKYZSt3vgr/guRWd6cXRcPKOFqxN
         Lcf0Dmu88Rpf9IfWe2E3tfa3ps4TyOFDz7yWZquv7Ds0LWOahcpcLEu07sO/2jEEJsZJ
         g9Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785826121; x=1786430921;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zEVXlrHL1Mp76Yn2gUaccJHB2Am9dI97FF7RVMZ7+yU=;
        b=r+OrmLGvvxHuiK1hFK+M+F5wHjGfFsB8jUfZ+RGjFjuRWZmWXJitHfVjRLnWT2yK+M
         Br6t/9v1JdeJu6fm2RV3SEkry0CalTMKsC82bDzL2SlJtAkYQzWwHmWuNAnI5/SZHVAz
         kPn6RyjWAXmEkOislDGgfH0ixQWLXTMsdILtkFWfSzmW/onTVyllCENw+ckUNoH/LBfw
         FhWRfS97pksPJw4M6pBb6z3MeSg6yhbhdMKlOoVp4f4OwnlX5fwol1qVDcH3XoUdQXVs
         /KxB0/38ymwwRXq5AqVQRvNbRN2Sn10MJaEatbOPSH+PIIVipcDq2qG3WBpJH9z0acqB
         vbjQ==
X-Forwarded-Encrypted: i=1; AHgh+RrVCbbK4RvOO7DV8PhHLK48j/UNNrPllWG8v/2TO5NfJ6rbfq4Teb86ep+TEZ/cMwVM/xkD4ajkl46N9Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YzW1YE/b/kZeyFSrEw3w5DvJuNaC4pC/B21P+ecy66gRWrzrDCR
	XgzrfHtOpl5rugqq2dmsozbci1ikr1+DHApRi+Vnu/Ck6IXXnSGoHmzrp3Q7GrUTPkNcphztyj2
	PU7yKlGWta17kJeBYc10ptr/JEKxZico=
X-Gm-Gg: AR+sD11Y2rGggVTvKWg+nVgswm2cMIp3MXf3lH4hVN3BjOv6CIVjQQGJL9NnSUVTD8p
	n6rRSkk11ZuBGKy2W0pBXdBv/epcJ/KS2BkCKKXKbKgYWeqjQaHoKmsXEAh/Vzgaz04KHNJMF9M
	KD6FBewYmRVM2UTyk6KGqHIXkFG5Vre9bHH1ALN3TD655gPvZM3PxE/66VqmVjeYZVuLLB3y/zR
	zohjaxeYG062T56Ndu/gvoTxH4Eqs1ol0w/yRuPPO+Zzh7HTvZa4fsV0v+xDN75Mz+iLigfFpQP
	Rbci2TRpfv6koZJUJlOZq0O/9wlK1DfWjxxvwT0J86Tru0lRG14szRNZWi6i/a+RONZbr7s1Zw9
	g4trGntuJUGkiZ48=
X-Received: by 2002:a17:907:9404:b0:c0b:e9c1:93a7 with SMTP id
 a640c23a62f3a-c1fe8109de3mr1025439266b.29.1785826120945; Mon, 03 Aug 2026
 23:48:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260803031116.3994362-1-gality369@gmail.com> <anA2DiyxdwUeJn0V@p15>
In-Reply-To: <anA2DiyxdwUeJn0V@p15>
From: ZhengYuan Huang <gality369@gmail.com>
Date: Tue, 4 Aug 2026 14:48:13 +0800
X-Gm-Features: AUfX_mz1xnYd2vjRo_Bp6kB150tYr8yFFV48fzorthCl8NhvFZRbVGqyAkIuPfw
Message-ID: <CAOmEq9W_8iOtV4SZPpODbwqwO8kQsEyktGjgXu0nVM+tpW+w1Q@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: validate global bitmap cl_bpc before resize
To: Heming Zhao <heming.zhao@suse.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	tao.ma@oracle.com, ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com, 
	tom442288@tuta.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 3, 2026 at 2:37=E2=80=AFPM Heming Zhao <heming.zhao@suse.com> w=
rote:
>
> On Mon, Aug 03, 2026 at 11:11:16AM +0800, ZhengYuan Huang wrote:
> > [BUG]
> > A corrupted global bitmap inode can make online group extension scan pa=
st
> > the end of a group descriptor bitmap:
> >
> > BUG: KASAN: use-after-free in _find_next_bit+0xef/0x120 lib/find_bit.c:=
157
> > Read of size 8 at addr ffff888021b52000 by task syz.0.34/409
> > Call Trace:
> >  <TASK>
> >  ...
> >  _find_next_bit+0xef/0x120 lib/find_bit.c:157
> >  find_next_bit include/linux/find.h:73 [inline]
> >  find_next_bit_le include/linux/find.h:518 [inline]
> >  ocfs2_find_max_contig_free_bits+0x53/0xb0 fs/ocfs2/suballoc.c:1292
> >  ocfs2_update_last_group_and_inode fs/ocfs2/resize.c:127 [inline]
> >  ocfs2_group_extend+0x83e/0x1ae0 fs/ocfs2/resize.c:350
> >  ocfs2_ioctl+0x175/0x6e0 fs/ocfs2/ioctl.c:869
> >  vfs_ioctl fs/ioctl.c:51 [inline]
> >  __do_sys_ioctl fs/ioctl.c:597 [inline]
> >  __se_sys_ioctl fs/ioctl.c:583 [inline]
> >  __x64_sys_ioctl+0x197/0x1e0 fs/ioctl.c:583
> >  ...
> >
> > [CAUSE]
> > ocfs2_group_extend() trusts the global bitmap dinode's cl_bpc value.
> > If its high byte corrupted from zero to 0xc9 makes cl_bpc 51457.
> > Extending by seven clusters narrows their product to a u16 value of
> > 32519 and raises a 2048-bit group to 34567 bits, beyond its 32256-bit
> > bitmap. The subsequent maximum-free-run scan then reads into the next
> > page.
> >
> > [FIX]
> > Reject a global bitmap whose cl_bpc is not one before using it in any
> > resize arithmetic. The global allocator has exactly one bitmap bit per
> > cluster, so this validates the invariant at the cold online-resize
> > boundary and reports metadata corruption instead of enlarging bg_bits
> > past the descriptor.
> >
> > Fixes: d659072f7368 ("[PATCH 1/2] ocfs2: Add group extend for online re=
size")
> > Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> > ---
> >  fs/ocfs2/resize.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
> > index 6375d5035972..556aaa319621 100644
> > --- a/fs/ocfs2/resize.c
> > +++ b/fs/ocfs2/resize.c
> > @@ -311,6 +311,14 @@ int ocfs2_group_extend(struct inode * inode, int n=
ew_clusters)
> >               goto out_unlock;
> >       }
> >
> > +     cl_bpc =3D le16_to_cpu(fe->id2.i_chain.cl_bpc);
> > +     if (cl_bpc !=3D 1) {
>
> cl_bpc is not a fixed value. Refer from mkfs.ocfs2(8), only both block si=
ze
> and cluster size are 4K, cl_bpc is 1. Otherwise, cl_bpc is 2, 4, ....
>
> Btw, is it any possible to put the check in ocfs2_validate_inode_block()?
>
> Thanks,
> Heming

You're right. Thank you for the guidance.

In the v2 patch, I moved the check into ocfs2_validate_inode_block().
The updated patch has been sent.


Thanks,
ZhengYuan Huang
