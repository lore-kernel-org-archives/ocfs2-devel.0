Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CD43D648F
	for <ocfs2-devel@lists.linux.dev>; Wed, 27 May 2026 16:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779897760; cv=pass; b=fBENJgpQxIeK/Xh6p5mM0n05tWkHARtdeqZTSpmwPlQ5Rw3D7tfxX2gYSHqBkIeEiXcPGzANFZhqdq+v0VefZ07nfIEvF1KgGYGi0ngs1tKwkcOiUW/1JEkZkLxzohV0XsIXg3Du/psHFefpKIrqa+bD4nVbgSoKu07882Vk1Yk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779897760; c=relaxed/simple;
	bh=AHt0+86vpId0YnypIvt+8kocwI6bTxlsvlDW/zwRB5c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eENRfpbxWwNoJCHDfaPR+UBkCO/xhpiKas5984ZRm7WoinmynBBGMVuRe/7qTAg+VhwK/1j7HtNZfbR3JhZFgrgGEo6HqCyJZwY+SJ7opaEGfttGsc1zI4tXENPhuroR9geb/X+YLtszHQLOOgfux2/n5r8QIAaEEjIK5GaRtgg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n6pSEdM5; arc=pass smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n6pSEdM5"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5a40d02b58bso8071390e87.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 27 May 2026 09:02:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779897756; cv=none;
        d=google.com; s=arc-20240605;
        b=Z1ZQ99EKIHVWv3DXyGi55BdldgANKnWMq2Mhs05sGAd4DxlfOqwl5tSz2rap3Ya3om
         BU1vdP2VzHyy6GnTqr2kIxAnL3QTzSJL3bWVntgSzL5oc/5QYDaLztii0Oi8FQyXIX48
         PSMKwm2O5vYT/9U/uMewzpFORlHmP/mfiwpp+fUvdgfrQkkmOdYIo4aXXOOedWsNSMi5
         hOKTcrLDm6gWMCnQYpsgwFTu9LPincywls1FhxOqbJmaMhJtZULTWsOb7OVLVwfLMLNy
         iXqUlLeXAbthggcDZU1/x1ZRBkkerM7lSwqTVoVi+wgnegb2SfH/PS+ppD+ROb2G0v9M
         Tc/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=z2Cy0T5Ytizh+1Br6nvrDriJnRVK9iMYXygh/HS+xaY=;
        fh=+TyxIHAzkKSRDeBnOtTUl4nyb5djKk5riskVTwqxTtw=;
        b=U4raoHhKDpp7r1g2Fc3P3DRHNU22vBXowOpQ+/MgZR+EMYZK43JnbUVCNa6rLFkCyJ
         Gt5HbsgFTJCJYf5tMp7qIzytWNih6jhRY3VZiFNC+vmf/PHzYSfXfywOddNOqWKCI1PA
         +5pb0rGnWZfoNu6rzKJPrPdUyxfbmLEN4nY56bMVkj2/7+HEuHgBd7m0XlEraffTKhQz
         W8emhctivGDQPC9/4nHetpp1hJPbMDLS7ULjEgmlE9nWUbMAWgyq4qmHQgS0F1doN5Wn
         kmmevRYQlTDgBQY7XXChr2dpEF5s6Vmveo602ibTwHQxymyzBYBNN24Cz8NsBKZ2jvGF
         4hyg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779897756; x=1780502556; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z2Cy0T5Ytizh+1Br6nvrDriJnRVK9iMYXygh/HS+xaY=;
        b=n6pSEdM5ljcnl4IuOsfehaFwlzMtJ5mnwZeZr2gE6kD0lvdo8PD61f/R9r3J9ABvw6
         haEHPnylH5idKKJax4SVjnjz0gCrbILecGY6JbJkkB4i8HptuiNuh8kHJzhdpAU2aNhv
         KN5e/nXpnEjNTUcLqzMd1ri1F1Vxd3zQyHV4UQwInYt7PzPmwWHXTb03TaLOsEbNHo4O
         0D7LkLrQH7Zb580JbmjUQ+/ONbKrPVtlMiB6HZlNglK4Hyw5TIlekjmahjmuW2MTiCfY
         uTs8vQMZzTtQw93MTXqCYYGKBwLGDP7JNOWqgVntN8d+YvQF+jI0XJsIGXB2rUeFuPoF
         4/dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779897756; x=1780502556;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=z2Cy0T5Ytizh+1Br6nvrDriJnRVK9iMYXygh/HS+xaY=;
        b=Bq8M2b+/qvOim7KWxCAoJJ3ofRoaHaa+26jMB9eGRZCHXkv4xFx09hm9xkdm7k7TsJ
         1P6w6EeyHZ97zV/fDLkFAtai30yqjITw5mPF+kxET6YrgWVNa3jN+sPFQ/OAhyb5GDP1
         TK9mUzNecn7D9z+mev1Mu9GubexD1ioL8k5xlAcAaVqiUpuMEhhvv2puL+459hpIKgWv
         iU3/gVR6avuU0HewHPwYOISbCVyzIj9NoB9JQeiUM88QZTdubv4q1ATkn/L4N2sp4nSW
         GF1dBAODwxaTM6V+3T7ct17RnW1xuF6ap0QQ6yTWquB93026UH+cO/2qZTVCqFTMTJcG
         Mqzw==
X-Forwarded-Encrypted: i=1; AFNElJ+YKDoxiT1ikIthKyjRhEQ8STnN6mPI7TmOroXKviIAhDQX+zdRp6wr7Fy1Myod8iAtXphzTP8M+KYJrA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyDSv6SVlQv7iyh5mOO9FUDScTRJ2zj5wKz3v++PLkm2KCGFmfp
	F7dabxtXWx2dBvnzh4O67B9ZUylIStmqaiL32R99/PL37JYh8ZAY/YsFwdkJPosH5h0ZoL1prKj
	lHpWkx9wq05UwG4v91yBSG+HFk5kxAU0=
X-Gm-Gg: Acq92OHa2I5POpJby3xWiHNolkJ6u0G+Ym/3sXc3az1+x2XSz5y5wLjt8Ev30s12PHJ
	NmUIUMDzqP8nII3I5sgWkGcFKE8S4G12aUlzfGx7IZu/mn6z0AVakEzVRcA+9NBl8RMDa0vBjA8
	7crmmItai3QnaXm5HlD2ZMrnaDqbLQmNjxg/dmYkjW+wqZJFltaqirWSlSztArUsA6H7fXByQDx
	wG2hrY2JhYK3uzw70LlxS+A0mbHyce72uvo4IzhXTUC9131oLgp9RiNX6/e3YMbLgO+4+FlMKwE
	4m+MZZSR
X-Received: by 2002:a05:6512:1082:b0:5a8:96cf:c8c4 with SMTP id
 2adb3069b0e04-5aa3232a140mr8148267e87.15.1779897755653; Wed, 27 May 2026
 09:02:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org> <20260523-b4-fs-v1-4-275e36a83f0e@kernel.org>
 <1bb537f6dc36b00788b613fb8f71579478418457.camel@redhat.com>
In-Reply-To: <1bb537f6dc36b00788b613fb8f71579478418457.camel@redhat.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 28 May 2026 01:02:19 +0900
X-Gm-Features: AVHnY4KetSSI45sZ2YEgAEZTRsUQAA2DaTD5AcJyh7fDYB4FmiHhDhxOxGAj9DM
Message-ID: <CAKFNMokr_mk8xhMQ7u8RGRd1XPQSSd_uVKXR=-ui5Zjk8AhfTw@mail.gmail.com>
Subject: Re: [PATCH 04/17] nilfs2: replace get_zeroed_page() with kzalloc()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Viacheslav Dubeyko <vdubeyko@redhat.com>, Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Dave Kleikamp <shaggy@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>, Miklos Szeredi <miklos@szeredi.hu>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, Kees Cook <kees@kernel.org>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	linux-nilfs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 26, 2026 at 2:07=E2=80=AFAM Viacheslav Dubeyko wrote:
>
> On Sat, 2026-05-23 at 20:54 +0300, Mike Rapoport (Microsoft) wrote:
> > nilfs_ioctl_wrap_copy() allocates a temporary buffer with
> > get_zeroed_page().
> >
> > kzalloc() is a better API for such use and it also provides better
> > scalability and more debugging possibilities.
> >
> > Replace use of get_zeroed_page() with kzalloc().
> >
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  fs/nilfs2/ioctl.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> > index e0a606643e87..b73f2c5d10f0 100644
> > --- a/fs/nilfs2/ioctl.c
> > +++ b/fs/nilfs2/ioctl.c
> > @@ -69,7 +69,7 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *ni=
lfs,
> >       if (argv->v_index > ~(__u64)0 - argv->v_nmembs)
> >               return -EINVAL;
> >
> > -     buf =3D (void *)get_zeroed_page(GFP_NOFS);
> > +     buf =3D kzalloc(PAGE_SIZE, GFP_NOFS);
> >       if (unlikely(!buf))
> >               return -ENOMEM;
> >       maxmembs =3D PAGE_SIZE / argv->v_size;
> > @@ -107,7 +107,7 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *=
nilfs,
> >       }
> >       argv->v_nmembs =3D total;
> >
> > -     free_pages((unsigned long)buf, 0);
> > +     kfree(buf);
> >       return ret;
> >  }
> >
>
> Makes sense to me.
>
> Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
>
> Thanks,
> Slava.

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

This conversion looks reasonable and won't affect the behavior of the
ioctls that use the modified function.

Thanks,
Ryusuke Konishi
