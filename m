Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E242F37
	for <ocfs2-devel@lists.linux.dev>; Sun, 21 Sep 2025 20:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758487482; cv=none; b=fSA9EG8EH1jir2cgV9XMYmEw34m7YR20CuH2irYa/ZvJYm06OLUk6gefZay6INfnN0Kh8NRUzCuBgM8KEbp0Kd/VjBaSA+6T+1zYRGO1MyqQ5i52G3FhmmmtnwGECRB2I8nNB7xGFeYI6YaV731uBc7Be2HXihc0X4Ix+uY8F4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758487482; c=relaxed/simple;
	bh=Wxk78sm4WTiUf+x56XODeSTjFI7Tre8+DrBZx8G9zJ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pD3BPX5nulMZ0C9vtWywxFdjZ0FMWFNUjmh+JxGoKXdzQ9nhiHTt/Qru4JiAR/VOOL+hCoVn93E7G5Wjgtjxq4T31n+mq1/z5mrHlHUjmu1xDDsAWDIvqqArN1Hbswf3Tme20uxCO15J7NpL1F4hDPrfusxa5ry95n9sIn6KqFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=WiEwuaQT; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="WiEwuaQT"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b4ee87cc81eso3660596a12.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 21 Sep 2025 13:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1758487480; x=1759092280; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lrp1vYn8+/NUY8DL+Z+wSSTE0867IgQjPinmMLmeavI=;
        b=WiEwuaQTZPQS4JLQ5Eu1kVaZmODm6Wc2PUtXQyCzisGHS4qdWslC2R5aTcYOzq67Ml
         Jbdnrkxg7rMxUELctAFgM6LU/irPywtuxdTe8NlksybD6b5YJE+gPW9wKEi4lQ+/wTGh
         y8VjgCmoKCpzSWllZfnW639MTsPpPY05v4zZs3iFNF+J2DvG4Ij2SvXJXUfKK+OxCdTq
         kfrzf52lYLAympbSANeK5qW2TYpdI1nbjYdszRqqBhKwdEUNdV3DKrMxG51HY7SOltLJ
         iAVWHpawv3L0lgyByq75NkTdR+zX//mkVGqlVhMwKJe/tlTBzVZ3BTHxYsIqfx8T/7s+
         pQjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758487480; x=1759092280;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lrp1vYn8+/NUY8DL+Z+wSSTE0867IgQjPinmMLmeavI=;
        b=K+lZxIDrmRR72sLw/2wPqF7A7+wych2uRJswuYsojpm5Umab6bxGOfGp5fAHJWGw9+
         M92nKyX11ais/Vu208ErBZKRmwKNeuspQS0BMlyJ8v8gZp5xqHa3ZRv2ljcsNMixPUoH
         WcQc7YgzZzSvAk7FFV5g/vNaQ7B0IKhWPhHk/fksuddCz07JZy/7ofJ7LS4oHVwEwbL3
         ZvYMe5kh08au40AorguHD96Dm6/flWkLcyOyYtlYAphoalfh6YJLklOivJbZMq3x5Fte
         Kni1CisMoUz1qghjKnBW8fKQ/+kW04pVjg7Jo5it/QkStEQV/C8wynm0YNOxciHuiSh3
         BoIg==
X-Forwarded-Encrypted: i=1; AJvYcCVjpa1EvpubipoRVYe8mkulSp/IbUmwJI2bWQ0T/ii4wl2hRfmL1H89lYKamj9y3nyWe8gVLmwqXo6WVw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwYtyElVIYK24eCCv+cpCWyTb25f2QHQtst8hx6DGYPG4dpUlYq
	R/KCH8WEVUzKdKVt3T0eMu2Z41TBo2sLaVKGoBvnW2BWGWX+I860rgQs+RxVjiCd2Lmtd2Whato
	AwKD7tw8aXklYXQ/3+YWowCG3TNFu+z0QhcxD94BI
X-Gm-Gg: ASbGncuXA3SLrKSzolACgKuxOAHezPynBjiGIwnRID9umgzDtQy4NlaSqQ9IBgqvGah
	W1wC0GwC94TiEhGavgRVMPuZrXSgjYdbcHwFRHRerQMKBvaXciZHk9erJHDDYgA6/nj9JXteT/n
	USDpJ/MZBTFZT4eXT75Vzuanvqu9NMQDu3hO6OgjOLHyfJSti7MwmuR93Iz6pb/DKH5GUqZ1T+g
	68Volg=
X-Google-Smtp-Source: AGHT+IHAbyCRLo/SSuvdFEQRy5JpOpl0NDRXzF/3drghYuhCInE4K6vDNKt06XHhxx3gZXaSMmGzjnpjA/kIMwyAfV0=
X-Received: by 2002:a17:90b:3c06:b0:32d:17ce:49d5 with SMTP id
 98e67ed59e1d1-33098245d63mr11380894a91.23.1758487480037; Sun, 21 Sep 2025
 13:44:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250920074156.GK39973@ZenIV> <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
 <20250920074759.3564072-31-viro@zeniv.linux.org.uk>
In-Reply-To: <20250920074759.3564072-31-viro@zeniv.linux.org.uk>
From: Paul Moore <paul@paul-moore.com>
Date: Sun, 21 Sep 2025 16:44:28 -0400
X-Gm-Features: AS18NWAIN9lhY1WlDGBZGFYNywlyC9vJx6yZK1w_BS23ADZS6YvZADa5RlquZNs
Message-ID: <CAHC9VhTRsQtncKx4bkbkSqVXpZyQLHbvKkcaVO-ss21Fq36r+Q@mail.gmail.com>
Subject: Re: [PATCH 31/39] convert selinuxfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, raven@themaw.net, miklos@szeredi.hu, 
	a.hindborg@kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, kees@kernel.org, rostedt@goodmis.org, 
	gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, casey@schaufler-ca.com, 
	linuxppc-dev@lists.ozlabs.org, borntraeger@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 20, 2025 at 3:48=E2=80=AFAM Al Viro <viro@zeniv.linux.org.uk> w=
rote:
>
> Tree has invariant part + two subtrees that get replaced upon each
> policy load.  Invariant parts stay for the lifetime of filesystem,
> these two subdirs - from policy load to policy load (serialized
> on lock_rename(root, ...)).
>
> All object creations are via d_alloc_name()+d_add() inside selinuxfs,
> all removals are via simple_recursive_removal().
>
> Turn those d_add() into d_make_persistent()+dput() and that's mostly it.
> Don't bother to store the dentry of /policy_capabilities - it belongs
> to invariant part of tree and we only use it to populate that directory,
> so there's no reason to keep it around afterwards.

Minor comment on that below, as well as a comment style nitpick, but
overall no major concerns from me.

Acked-by: Paul Moore <paul@paul-moore.com>

> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  security/selinux/selinuxfs.c | 52 +++++++++++++++++++++---------------
>  1 file changed, 30 insertions(+), 22 deletions(-)

...

> diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
> index 9aa1d03ab612..dc1bb49664f2 100644
> --- a/security/selinux/selinuxfs.c
> +++ b/security/selinux/selinuxfs.c
> @@ -1966,10 +1973,11 @@ static struct dentry *sel_make_swapover_dir(struc=
t super_block *sb,
>         /* directory inodes start off with i_nlink =3D=3D 2 (for "." entr=
y) */
>         inc_nlink(inode);
>         inode_lock(sb->s_root->d_inode);
> -       d_add(dentry, inode);
> +       d_make_persistent(dentry, inode);
>         inc_nlink(sb->s_root->d_inode);
>         inode_unlock(sb->s_root->d_inode);
> -       return dentry;
> +       dput(dentry);
> +       return dentry;  // borrowed
>  }

Prefer C style comments on their own line:

  dput(dentry);
  /* borrowed dentry */
  return dentry;

> @@ -2079,15 +2088,14 @@ static int sel_fill_super(struct super_block *sb,=
 struct fs_context *fc)
>                 goto err;
>         }
>
> -       fsi->policycap_dir =3D sel_make_dir(sb->s_root, POLICYCAP_DIR_NAM=
E,
> +       dentry =3D sel_make_dir(sb->s_root, POLICYCAP_DIR_NAME,
>                                           &fsi->last_ino);

I'd probably keep fsi->policycap_dir in this patch simply to limit the
scope of this patch to just the DCACHE_PERSISTENT related changes, but
I'm not going to make a big fuss about that.

> -       if (IS_ERR(fsi->policycap_dir)) {
> -               ret =3D PTR_ERR(fsi->policycap_dir);
> -               fsi->policycap_dir =3D NULL;
> +       if (IS_ERR(dentry)) {
> +               ret =3D PTR_ERR(dentry);
>                 goto err;
>         }
>
> -       ret =3D sel_make_policycap(fsi);
> +       ret =3D sel_make_policycap(fsi, dentry);
>         if (ret) {
>                 pr_err("SELinux: failed to load policy capabilities\n");
>                 goto err;

--=20
paul-moore.com
