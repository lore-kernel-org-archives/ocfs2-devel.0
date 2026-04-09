Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1AC234CFC3
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Apr 2026 06:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775717760; cv=pass; b=ZUxSMaV+e8UJdOi0SKcycsTZcFn7RoNzs3xa4baorhbCSkZCXNiDvh/7VdLfl0ZTyBSHQW60p6JQXtS0JvJXbEXzdx2+JeiXBZLsQvr/BBMtf9li6Pm5FU2IfzVHGEwX5K+74Rc6U572RYwm+zwou5Nw/xaMbUT1ufx0tIvmJBw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775717760; c=relaxed/simple;
	bh=3IpANIu28JfqdLaLo0/WJ5ofLI7wVFWWIdbcEAVUVRI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pC8dF+VqbwPPCdxIiDyAimNVAwVqsWzu69INwdZCvqINGHijq3i/ac0y0BlVFdHeoOoem8Lbj5Ep4ZjseYjQ2NClvUM+uDD3gfpvUP56Qs0O/pJjt8BI5Kmz3ZF1bPKmwNv8F69x/MWvgcWb447w8GtNOYn8TkTaYmLXWSpFrR8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G60UJhjl; arc=pass smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G60UJhjl"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b936331786dso56347566b.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 08 Apr 2026 23:55:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775717757; cv=none;
        d=google.com; s=arc-20240605;
        b=bv4PL5j1eiBm82OJfHWbSAOgJ5jlZHZ0v85QN8y5JFh9DhM5AU/F2tFkJ4vGVU5Err
         XwcWAy/9JHN4+92KYSv2qxTVkb6L3kIpCjovb6dSoiLkIunThjL2wOu6pshgjkzMaYV1
         kq9vzdjNGw6V1zaVYoke4dGDdyzwD4qtfUNz/Sel3KQu5dWo/57N+UyJLEV8Wuo1urse
         BQz2hsNOeXExkJzfljvS4os75ZOqsDFUXvF0g+fL6vYdSnUNjNifMQOl++j6vU2mfWmd
         WQbOrcm21rMOvoFzcrqMhTeqLAO5nZ+62sifuYaoctQSzdnBMSnt5UfFetSuHR0RWKx/
         8FWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Fwsb2faRkE5i5QesOX+w0NhXPiYQaot6ZK97Msmq42E=;
        fh=0Ppj+Xh+6eiqR230IDpxSbKU0UI/Ma2Vy80qWMAtlxc=;
        b=fmo0Lo+Hdg1XmNaP37Ne2yXElP8aTT2/qtW2+7HvD72uh2Gf5YYnAzlJmfSkvv0F7L
         0I76mUrXLcSf/6cQxDqKcnMu/CONcY1cYxZ0ALn7VnvOauqmuf8EIBn2kIc75wE1tyUm
         FzLlGRjrE03R/Eb9V7FJfNXpMkOaIv8VM6W7fwc6gOH13QsuDRzEASKs/3Mav2lCBo2N
         Wdy4/LPePctHf+jUtRDNYaarPMJLwNR5Giv7Kxp8zX+kHhwdOUngy3+S28beoRJ3LGDW
         jTN9wZOUJXi8D0NRJJ66287qyooF8jfWyHom4lNBCMWOVPLjMiEswz87Hfq01xiCk9sS
         JmMw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775717757; x=1776322557; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fwsb2faRkE5i5QesOX+w0NhXPiYQaot6ZK97Msmq42E=;
        b=G60UJhjl9nzzvyylw8iIDWRfJA+utVGmv6LavTPfnV61KsaFs0cncoCdO6VzTid6dm
         kO7LC3UYiVl0YL37pE+hMBg8PYsgBPR0zgpEPTZt4F/Eoh+RYnlB2ioNAawPjjYXGmcs
         V6157ChTb5InEEo/D4jabnqRQfnvSiZDv9G5vSA9gmCn6r9xFvj7aR+HGXutSQ1Y8xtE
         z/kbNjGWKwGcKVgInoOFABnCW8ueFb5pXLOdET8wj7qsA0264iQwL0xWwkyKXKSVJgQf
         rhDyM5M6cG7mQjOwf9+Toxh3exlbIpuYkdaOyTAlkM8mj2goMAoA9fIMSZIUvPP8datk
         /Y4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775717757; x=1776322557;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Fwsb2faRkE5i5QesOX+w0NhXPiYQaot6ZK97Msmq42E=;
        b=Sw30jZX8dKN/HgmuJN39ziCj18bZgHJWtaHqrsChLRieI7UuaMpg07z5cVSWMzXkUd
         dIhLqivsLqzJG3i1hH1m0YL289Y5RWDdIKsdWdO+CogEiTJb8lkFErbjOs0vg2rt80LK
         M/yFhVyySySXm9jYmaEwR3K1uHYNyST+jJiRfhkFDmJ4gkvJYljKakYiSGSgGmBr9e9i
         CIMtbcaX+miIdLKkrNFsKvj5IlHXpjFcCTRxVoQ3FLdyjzvtL/gLCy3V6B2rLC8F2L4a
         I/BtQcKI/eB6lXAFRHmY3Itg7XiSComkEfdX7Pc1g1K9p764uUc/jH0dSOcD9Q5a4Jzg
         PibQ==
X-Forwarded-Encrypted: i=1; AJvYcCVdCcv5aqWccYU5BB5zMnanRZ+FU7kbosHK2nRomtNe00S8BkArDHtukJGbC8E0WlTv7OwlGR4BFQM3Kw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwjRycz61n+gDMG2GmpG+AKdkR2Ha+ZOEPoioa34gljryxuucjS
	rq82+ons1scy1FyHe8hTNTQI8g5hGaQv1XZwYUNXTPsakfUXJ53N9uMrH09DiAnmzBIytje7p+k
	LqSCgHzq+0aWXK4Zhh8tO0/NGkgVFJ3Q=
X-Gm-Gg: AeBDieuCEsfvkVjEhJetFDLsq/UyIrD+cIEvLcPPwsn8uiN/JIaYEmyAFo3FLIB83as
	9QTUCJq+EbMweJKgHJJLBspvm6DKkY/zucjtTS8RM6Ru6fO9XOgKDtOJDvSCgjqbcJmjMhGPxFo
	obNqpx1CCvKOlPJa527LIkZ02+5Z7p+DPq7783ZyY+J3k8ZIblJ3PK07t3RqoroQhn25STJYCvs
	nv/OSnc/+rPFHIjW9qOa6gJRnS2fmNyGlAeMi0srASHoGEUwc848cWUGH9klfkXnRfirFMdIH9i
	1PsM2kSh6Fdw4ik1/U18Lzas5leF7CDG4wjf9ipuNR2lJnVWn1ESQuU=
X-Received: by 2002:a17:907:1caa:b0:b8f:b32e:e196 with SMTP id
 a640c23a62f3a-b9c679518f6mr1334078266b.30.1775717756990; Wed, 08 Apr 2026
 23:55:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260409060241.3344855-1-gality369@gmail.com> <gyzh7hjexqrnjn334l3ev6dwo6yfb6deaynvnqsetjvqc4flpf@z2plhmz7vigo>
In-Reply-To: <gyzh7hjexqrnjn334l3ev6dwo6yfb6deaynvnqsetjvqc4flpf@z2plhmz7vigo>
From: ZhengYuan Huang <gality369@gmail.com>
Date: Thu, 9 Apr 2026 14:55:29 +0800
X-Gm-Features: AQROBzDpXA1W62faH68e_mHjOI48-hwJcrVrXG-A2Q-qXuyeJ_OtCTaehmVDC9o
Message-ID: <CAOmEq9VenRkvGREGXJEse4qgBN7FrTQhBxm0NWzEGf0mhxJY5g@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: validate bg_bits during freefrag scan
To: Heming Zhao <heming.zhao@suse.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 9, 2026 at 2:50=E2=80=AFPM Heming Zhao <heming.zhao@suse.com> w=
rote:
> > diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
> > index b6864602814c..a341a599e440 100644
> > --- a/fs/ocfs2/ioctl.c
> > +++ b/fs/ocfs2/ioctl.c
> > @@ -441,7 +441,7 @@ static int ocfs2_info_freefrag_scan_chain(struct oc=
fs2_super *osb,
> >       struct buffer_head *bh =3D NULL;
> >       struct ocfs2_group_desc *bg =3D NULL;
> >
> > -     unsigned int max_bits, num_clusters;
> > +     unsigned int max_bits, max_bitmap_bits, num_clusters;
> >       unsigned int offset =3D 0, cluster, chunk;
> >       unsigned int chunk_free, last_chunksize =3D 0;
> >
> > @@ -474,11 +474,27 @@ static int ocfs2_info_freefrag_scan_chain(struct =
ocfs2_super *osb,
> >               }
> >
> >               bg =3D (struct ocfs2_group_desc *)bh->b_data;
> > +             max_bits =3D le16_to_cpu(bg->bg_bits);
> > +             max_bitmap_bits =3D 8U * le16_to_cpu(bg->bg_size);
>
> The bg->bg_size can also change.
> It is better to use ocfs2_group_bitmap_size(osb->sb, 1, osb->s_feature_in=
compat)*8
> to retrieve the max_bitmap_bits value.
>
> > +
> > +             /*
> > +              * Non-coherent scans read raw blocks and do not get the
> > +              * bg_bits <=3D bg_size * 8 validation from
> > +              * ocfs2_read_group_descriptor().
> > +              */
> > +             if (max_bits > max_bitmap_bits) {
> > +                     mlog(ML_ERROR,
> > +                          "Group desc #%llu has %u bits but bitmap hol=
ds %u\n",
> > +                          (unsigned long long)blkno,
> > +                          max_bits,
> > +                          max_bitmap_bits);
> > +                     status =3D -EIO;
> > +                     goto bail;
>
> Since this function is used to report chain states, it's better to contin=
ue
> instead of breaking. In my view, reporting the error message and overwrit=
ing
> max_bits with max_bitmap_bits is sufficient.
>
> Thanks,
> Heming

Since this function is mainly used for reporting chain states, it makes sen=
se
to continue instead of failing hard here.

I'll change it to log the error and clamp max_bits to max_bitmap_bits,
so we can still report as much information as possible.

Thanks,
ZhengYuan Huang
