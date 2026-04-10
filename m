Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7002124466C
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Apr 2026 03:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775790202; cv=pass; b=T+CHBek29HwCYlbr6amVzt8WPibrmO82fA1R/R7BBphU8xFGHiXcbYtwjqlHAiKEYg9UAZzXjLqapQcJgaLEenrjnRKadXy9KUgJFCriYqlEvd5ot3zwwepPwPFt3J9YTjF1lyC85BQbqnHgUv/Ur1rWKSnP0Pm+tmNYXR+K7nU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775790202; c=relaxed/simple;
	bh=Y2Ld9+tKC/IqBrt5WoI4fV0f4NRBonU4mPfAlxC5Q5A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=khceWRUIxIwd3PuS1UkYezhMMFaBp1FWoStOhFBBK4RFlyjUw2lBp+6AxD5P4yjV5blsysjCnV09GTPD318vr11cC4ic/Cb1mVvFpEcjWI6bjs+Ysx0ferajI8I22eRfzmDbKq8kJvEKWTR8RMGZDfzpV9cw0CLCtisDKImhZiw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hBy0A6iJ; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hBy0A6iJ"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-66c05fb27e4so2797635a12.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 09 Apr 2026 20:03:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775790200; cv=none;
        d=google.com; s=arc-20240605;
        b=Trt3zvNX3coAVfLM/YP5IurnrjCjdxugYrxVR7HPJ8/PJbV4jkyPhNyrJbUrCuuv7F
         xiRhvXUPvgoY7XmOaYX3vit4Stv3Qq9be1Mv6YQdFV2uUDlUW/M3FbSprEtTljVmdLu6
         8WqoIdiSbJvFzrspV3gbXHr8lGmdm7vG6JfA3G+KE5twdtq7oGz/hB963/z44ipmma5B
         oxRwLxPDx+TXLX72uOf3MA32+9aVFOUcPtQPxwoI2ZkKcFMN5dwkUpI+T6qc9eIHKHk4
         +z5c7fy0/Lj4L+OEqEuGXJPvb4y2K0uaWcsTg/+0E9DmRUB6bHglIi5KsBVkSTcj+KVW
         ToyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=U53ePXj22h7ibdYF6VVMkMaFvqVGrB6sUo7oZ5DQhWA=;
        fh=hpEzt1PmiYZHwxeTJjC6cGClle/4OY7Bfdm1dqiAtGk=;
        b=AluweZ16z9KepYQyyBN20yoIuALJ9sG21nJwKDbQSnjaD1wOQpc/Muo79BM//X0Z4r
         BAj0vUJqYzUNyKMh8sZpQBMP7DZR28HKuk4F4kfBOqQ5slVxURRIezJ0VYSA8LGaOopr
         703+zzlOpZ2NlPTOpv9zi6/QgsYAjVAx/Vv5uvj8ppbRcSRTC55/0D+VDyxv36phcb0t
         cph7XqFupyFFYQspDzdm5ZuuRP0PlWsgV6td+JVHXTgFi5JiQ1+AJJ1230amgdcxQr4e
         SAwzis6PpWUCwlARJ0Fg+5clBUP7W2QnEMGcPuto/CA8ekOY4gjFL7wmiOgr+nAmhukQ
         tNdg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775790200; x=1776395000; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U53ePXj22h7ibdYF6VVMkMaFvqVGrB6sUo7oZ5DQhWA=;
        b=hBy0A6iJ60r0xFod0kTkDPegSvvkBbkPbnC0dHKz1YfBXHrwfJBk+I+91xYiEzAetD
         Z2wlTCN6823JQYs+41X15mncwk1t55dDbKGy2mfTw5T+oDHkCiNi3ldggI4rYC/m074b
         xE19tUcCvyUGRCVq44c6NfbkBEaG0wmmvTvH7wcMKgaTRgkOeGYB1HcQD0mB4oL2ITjT
         R7jmdP6SMZki1u+tRqBU1AJzqLNpQ5VfzlwmL0glWflJvWfV6ppmWDU0K7THowqphtmW
         9wusEPFzUYIr230fK1i1+G1LkOVjY7hvRo8pQP5pFzzaGVni00WvqhovB8AaAkDfIZ5d
         PWZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775790200; x=1776395000;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=U53ePXj22h7ibdYF6VVMkMaFvqVGrB6sUo7oZ5DQhWA=;
        b=bugFiboTvIPmp+BrqmdE+G2r77OCMRUiAiJawuBBBHM6M8K0HgTwm5og5d112ijDla
         gdnStRJNW1sBqmUYOOpDnxc8vB3hB8x1dzfh6OX3ZbUYUs0Jrq2s2Cm5mrNeDbHqQCkv
         hjBXA/HRgscLPU9p6B2VLba79iPvql+cn5KDffFIa6oglyuXL4Nsm2iF6L7G3LZJxSFr
         La/+xfmz5WWg8G+CoKh7AR7HLRgrhT9TwPw7+/AtT2zlUYhN/IPxYrATOtBk4n43xNoQ
         G0d89Gq6FknfdxDg6+F7vpazdhzn6T9TguArrFp8Q84siGr5Kkrlib75/YA9UqYx0QqI
         3AIg==
X-Gm-Message-State: AOJu0YzHdd/S42AYRq0mcFkxFvA/bNL2NWEvkKJtiusM7yPFDCFhLoS8
	FfH4N6gmPZThLsaqsINR4ixfjWPqcMbqI7ACMAjgYY6a2qa1Bl5hRZeLNakjX12i+yUcolpJhZ/
	eMuEAiRscndQzZUZKHw7pd5iuXZEtmNU=
X-Gm-Gg: AeBDietp75aaa12BS4p+8w1L6sJkBSVqnt00Fp4Gl/xC5QgMC0KWz8+5YY0TnRvw/RG
	s+ZD0bGd2JCWKdZekDxSTMMtDJJ9ABLZbCKnDauPLKPnTCrHb6+yf3Q9fmUKkg3rNo5izXX4zVx
	y13Wq/7J7Ug/oci21i/fYenQJNq7944HcrV359+qVoiPAtgMdjB7nZ3j0Ro0ynJGc1sK0k5+GMc
	5ahNQfqD669KwjGiBEjsibuzNv0IhUap4EoBD54ojXkirfT9TK4wzec9htWoS8upfFwvENDT9QC
	e8jAM2LL5JyBCem7wYmwJqaX+VZOzkIvvDAJah0xhdyCr39oSHjHKPE=
X-Received: by 2002:a17:907:c80e:b0:b96:f863:deba with SMTP id
 a640c23a62f3a-b9d7298089dmr96857966b.32.1775790199478; Thu, 09 Apr 2026
 20:03:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260409070624.3357378-1-gality369@gmail.com> <2c314914-e6d8-42ce-83dc-351f3f85fcaf@linux.alibaba.com>
In-Reply-To: <2c314914-e6d8-42ce-83dc-351f3f85fcaf@linux.alibaba.com>
From: ZhengYuan Huang <gality369@gmail.com>
Date: Fri, 10 Apr 2026 11:02:51 +0800
X-Gm-Features: AQROBzDTWd7BAatEPIqXhX4BkYqf_15t7tFO9pb7T_Hfp-hQnyG5mccjQQWwGwc
Message-ID: <CAOmEq9V5ZORfKXf25ot3NSKnw+ewuqHeOghza3jHe_F2RTXORA@mail.gmail.com>
Subject: Re: [PATCH v2] ocfs2: validate bg_bits during freefrag scan
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Heming Zhao <heming.zhao@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 10, 2026 at 10:46=E2=80=AFAM Joseph Qi <joseph.qi@linux.alibaba=
.com> wrote:
> Missing fixes tag:
> Fixes: d24a10b9f8ed ("Ocfs2: Add a new code 'OCFS2_INFO_FREEFRAG' for o2i=
nfo ioctl.")
>
> > ---
> > v2:
> > - Use ocfs2_group_bitmap_size() instead of the on-disk bg_size field
> > - Clamp bg_bits to the computed bitmap capacity and continue scanning
> > ---
> >  fs/ocfs2/ioctl.c | 21 +++++++++++++++++++--
> >  1 file changed, 19 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
> > index b6864602814c..fa0ca014c6d5 100644
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
> > @@ -474,11 +474,28 @@ static int ocfs2_info_freefrag_scan_chain(struct =
ocfs2_super *osb,
> >               }
> >
> >               bg =3D (struct ocfs2_group_desc *)bh->b_data;
> > +             max_bits =3D le16_to_cpu(bg->bg_bits);
> > +             max_bitmap_bits =3D 8U *
> > +                     ocfs2_group_bitmap_size(osb->sb, 1,
> > +                                             osb->s_feature_incompat);
>
> This is not right. It scans cluster allocator, not suballocator, so the
> second parameter for ocfs2_group_bitmap_size() should be 0 instead of 1.
>
> BTW, it seems we don't have to explictly mark it as unsigned int.
>
>
> > +
> > +             /*
> > +              * Non-coherent scans read raw blocks and do not get the
> > +              * bg_bits validation from
> > +              * ocfs2_read_group_descriptor().
> > +              */
> > +             if (max_bits > max_bitmap_bits) {
> > +                     mlog(ML_ERROR,
> > +                          "Group desc #%llu has %u bits, max bitmap bi=
ts %u\n",
> > +                          (unsigned long long)blkno,
> > +                          max_bits,
> > +                          max_bitmap_bits);
>
> Better to fold them into same line.
>
> Thanks,
> Joseph

Thanks for the review.

Fixed in the next version.

Best regards,
ZhengYuan Huang
