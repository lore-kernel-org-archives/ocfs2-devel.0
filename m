Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3C929A0
	for <ocfs2-devel@lists.linux.dev>; Mon,  6 Jan 2025 06:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736143944; cv=none; b=QTMHlBfv28s269NZH3sERrYJ4uCE8e6znj26/bsylMtZegLV3qBT2d7Jn8dkgeHVBxZGKdk0wu+o5xnThrFhjjcKPxa6VZ8dnLbQ/LVNUGZL6jBfD5SqbB55f4v0fXwVwGv79Wo6f3w8A52Nkebk6Eqx7OQi8iSTnFX/yJhTJwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736143944; c=relaxed/simple;
	bh=PjuEwQkIh6E0dwCoDechuMeQAfz6AEbkoMjwwVr54KA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cGOjXQ49XmHdUlFrlQmzkaz+4XptFjw+GwY6MTWNctm9+hZChJpNL9zkqJnGLx+geePKWsJUIWv3i1hz1bu1O1ryyiFtQPoU0PEpNog+ZpQozz6tALldiavnaM+azPlm+/ZehCJpDPclogJPQgT2tLYoaRVwbr3OqMGK0tc6V6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DegbGObj; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DegbGObj"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-304d760f0dfso29573111fa.2
        for <ocfs2-devel@lists.linux.dev>; Sun, 05 Jan 2025 22:12:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736143941; x=1736748741; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NG7iWSsVdjInDq3pOte5pqLvixSMaEdOmh4efd18XIQ=;
        b=DegbGObjGl8mfufbK9WF7W/olNk6j93U7G2qNzs8Hc/762FGlv4Bh/MOZbSGesfqaS
         nepOVRvgvLE4PxzAy9o5SMqqLmp9ClKON629WY1TVqf43WojduMlosAhN9BFayAx9Ma3
         npruVF4/g/ncWU42J9qiOyK+SpZX6YwLRJb6jBd0c/XlM5cxTdDwwx/7w4OhZm/deKI3
         0eYDEwB41C3OuP7G0EkJjDqkK5D3P8VUjPYVRrNZLSJIarBWLRxJFAo8YBRQflSgsbeR
         j0OaqaAqNTEU9dMQJOs/gi1BbV/ItcszhXxzOQqU4XTRcKvcSm9HuiEBKAM7QunbRCw+
         gPJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736143941; x=1736748741;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NG7iWSsVdjInDq3pOte5pqLvixSMaEdOmh4efd18XIQ=;
        b=ZxIwMP38AU3PwLYqn+0BonpHkCKnVDOFYr2UHMzGR4PS7viJHaGG+TPj/RsyXcWHGY
         S/YpWrkxKh/0StZasj6uR9UlOFbEC13N5bLN93RUsGuAxvJtwo0CiStlgqcWY/PRQxNN
         FEjb3JKMlkVnR5RvGHxZQAHqDJsgpjU597jywX3dJqudBJNfjvW8V8+lnLdogujYb8d5
         vh/WptJisTCIdmULiueouY3sUEsWxY34M9bq6m6kQ6AB1sNjKDYKTu/8uHSdugHL0cW2
         9E/tT8pNthb2tEieAuKC5JLBqRuxJ/AY4mSEl202tTFNXnJNvywH8lvzrP9NRwSOTwVy
         dgWA==
X-Gm-Message-State: AOJu0YysNjQIsbYrOveAWdkFNHx4B5p3Eld0y5KjlBapTGvPcoT4Sp2p
	SvfW4irp1clA+e4JmayvhkgorV8w9YDkPKOXxgyBkKLP0oxRAHfU4cDNdMDCW6U7aGa86bsYzsz
	MWnEci7ef9CfZOCVgBIaEE2daLm1fcK1KdAXJTBtv
X-Gm-Gg: ASbGnctZffo24eAW6NNtlrEZkV9eNswdD5zqoy8pEMWglIJM2MIoz2qzSeZ+W7+ISXV
	hAH6hsGWGgy9DTQq5Oe6fDjLx+y/84B1G6vA8AYo=
X-Google-Smtp-Source: AGHT+IFFG4OW34TSmyzievNUcf97u9SeW5i9tynMi3d4mlApjmB+JtWGGF0s+cSCVA8IqUc91VNGhpBp9TQl9ZT7ULs=
X-Received: by 2002:a05:6512:e98:b0:541:21d7:7056 with SMTP id
 2adb3069b0e04-542295301b4mr18315718e87.17.1736143940416; Sun, 05 Jan 2025
 22:12:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250106023432.1320904-1-sunjunchao2870@gmail.com> <1e00e9b9-8600-4e30-af00-748c8545353e@linux.alibaba.com>
In-Reply-To: <1e00e9b9-8600-4e30-af00-748c8545353e@linux.alibaba.com>
From: Julian Sun <sunjunchao2870@gmail.com>
Date: Mon, 6 Jan 2025 14:12:09 +0800
Message-ID: <CAHB1NagXLbPnbbO9DctCm-YYV-y0ib0AvfAK6nawSRV6o2PWyA@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] ocfs2: Check el->l_next_free_rec in ocfs2_get_clusters_nocache
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, akpm <akpm@linux-foundation.org>, mark@fasheh.com, 
	jlbec@evilplan.org, syzbot+2313dda4dc4885c93578@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I really appreciate your comments and suggestions, thank you!

Joseph Qi <joseph.qi@linux.alibaba.com> =E4=BA=8E2025=E5=B9=B41=E6=9C=886=
=E6=97=A5=E5=91=A8=E4=B8=80 13:30=E5=86=99=E9=81=93=EF=BC=9A
>
>
>
> On 2025/1/6 10:34, Julian Sun wrote:
> > Recently syzbot reported a use-after-free issue[1].
> >
> > The root cause of the problem is that the journal
> > inode recorded in this file system image is corrupted.
> > The value of "di->id2.i_list.l_next_free_rec" is 8193,
> > which is greater than the value of "di->id2.i_list.l_count" (19).
> >
> > To solve this problem, an additional check should be added
> > within ocfs2_get_clusters_nocache(). If the check fails, an error will
> > be returned and the file system will be set to read-only.
> >
> > [1]: https://lore.kernel.org/all/67577778.050a0220.a30f1.01bc.GAE@googl=
e.com/T/
> >
> > Reported-and-tested-by: syzbot+2313dda4dc4885c93578@syzkaller.appspotma=
il.com
> > Closes: https://syzkaller.appspot.com/bug?extid=3D2313dda4dc4885c93578
> > Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
>
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> > ---
> >  fs/ocfs2/extent_map.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
> > index f7672472fa82..930150ed5db1 100644
> > --- a/fs/ocfs2/extent_map.c
> > +++ b/fs/ocfs2/extent_map.c
> > @@ -435,6 +435,16 @@ static int ocfs2_get_clusters_nocache(struct inode=
 *inode,
> >               }
> >       }
> >
> > +     if (le16_to_cpu(el->l_next_free_rec) > le16_to_cpu(el->l_count)) =
{
> > +             ocfs2_error(inode->i_sb,
> > +                         "Inode %lu has an invalid extent (next_free_r=
ec %u, count %u)\n",
> > +                         inode->i_ino,
> > +                         le16_to_cpu(el->l_next_free_rec),
> > +                         le16_to_cpu(el->l_count));
> > +             ret =3D -EROFS;
> > +             goto out;
> > +     }
> > +
> >       i =3D ocfs2_search_extent_list(el, v_cluster);
> >       if (i =3D=3D -1) {
> >               /*
>


--=20
Julian Sun <sunjunchao2870@gmail.com>
