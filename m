Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44DC2FFFA9
	for <ocfs2-devel@lists.linux.dev>; Wed, 29 Oct 2025 15:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761751193; cv=none; b=nAvepE2KitMzLcwM0Ct3EQO5CNvv3AnUaOllTUALi/QnXdqtj6swaNKNpP1eBGn83jbwKf14yobLr8bqIzo/JesBz5p5vulX9z3IlB4OI9C8h7GlszaSKyA1Niy7oi+jZFbpnV7pE2sWpN6lpgYfKvT8z5FL8L+ZVS4G9H1haUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761751193; c=relaxed/simple;
	bh=XmlYQpf2O8iYK7QwAPdhC5O4544PeopBai3GSa1C/lk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TWJ7p7zqlknrJi7zi4bug2rOaQGVnzsa6IG/kUO7yfrCfDTYrcTDelh00EEv1ZCdfnpEAR2BxwxxMk75ousJa5BGL25iiAAP7Z46D/j8fcV6u3zCtDg1DAW4L2Nb36z+Km6YH/T74RxFaLrg6j1mgnrtdXd/jOsV2Iq1BkN7/fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dua8kACm; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dua8kACm"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-34029cd0cbdso27006a91.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 29 Oct 2025 08:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761751191; x=1762355991; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1CdmUiAXh1HKc3m/r9pA/phMrmd+nlM0IzGmsHncGb4=;
        b=Dua8kACmLTTnnO9uWzJetZfau27i6TeLbQCN7akNiyhH30w4p+Dh3w2BNZ2nPAA1H0
         NUz46JQb21EbLWo0Vs45smfc88emHqHM+mw28uS5Ts6Fj8JZ8Kg1oLyRLet1q0WSOATR
         7RxaFKhxv/5lapgtNeyHEKGcHL1xV/D4C7TFE00LIlzrQhDh07/xjLSNopowwEYjzzfu
         jN7Ph7yWx08vh6RfGOIeq7CZ3t359YGct1N2WwogNhGX20rPyvWnQ8aYV2ZZ5rqMDY3I
         sG11nj5HY1oYiLj7QWJWRGgOdfy2epa/angaZ+RoDzT+3uwqiPGiKiNwaeDgrwHxcXtr
         sI0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761751191; x=1762355991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1CdmUiAXh1HKc3m/r9pA/phMrmd+nlM0IzGmsHncGb4=;
        b=vuB6t9UQUgvmLrFzY/a86fdbIJ3v7WtbKyNBG+oNQ5CQPMymUzg6Mfh2uvzRH1+l5m
         e5jp9Dx6SnAMvarUTszeDUPXvc7jA+R56GAX+McL8DV7fbMWzyHT0ZWIQ8tdMHXsEyAu
         T93/HC8shCzn57saWbGQLCn5tnRNXhmL6A2Sye3VywTV6QpYPWqlekislME5QQzFryn9
         H0TOigOoTAC6tB1GYGnyShmMkgqckTA+bVzJPYa3FLX1oN9ktcR29xbF+8sSGg7ehaAk
         NaKhf4Ta0CUhLQz0QHT1YbrKkyU6/QJoiyRNR93tLrXnmkfXG6WgsrnO6aYXpMPmep3T
         krZg==
X-Forwarded-Encrypted: i=1; AJvYcCXdUz6VzdCWHLG2OKp8M4ovYxON2Ue7a0FTxPqX+VBvD5nz9xtBVqbz6gcgUZ5H5d5gXQCOSGVQNbI1PA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxBNMvZjI8oY63JevyKlxsIs9XthtrMih2t15qyiUFE6INLrJXG
	Yk+cL6XmaqCLxCyqPhHJi6iA1In7aIg2HO1wbF8KNPVYbV3ce0C4Qe+BVzrxBpWeq08LW/c4/cR
	AdJn1oxzEe4CmvqZ00np314PHgDlV6j0=
X-Gm-Gg: ASbGnctI10+bLrvSMtE829ej7PCFNTKNkvfabF1zfzdPu6Ch3k6vFTf2h3yg8/lg3S9
	O0V5G9K3QXlbGj9JLCg9yc8nCI0z2LZogzZ6YOzaKEisZThWXFCdXqW+qbSnYfNBTG+Pve0NC4g
	rKeFFzdz6aqhaCtlqPw0QgkKvgcjMm9pEIAoHPpHrimjRcQr95NauJXliABoU7nw1u1pZ2hss6B
	1e5PwUWw5QOiec7GEGBk97GFb81IJYl87ASmCp/eLJ8631HLGvNceveBhUK6ith4+3EuXk=
X-Google-Smtp-Source: AGHT+IFbcnsAk75YEZiUX3rsU0b/ZmVe83k3NaOxPSYI+q4vlPOeZ92ke++maKcHRCEWJ6+8d/ixoTttE36+ff9pbFg=
X-Received: by 2002:a17:90b:1f8a:b0:33f:eca0:47c6 with SMTP id
 98e67ed59e1d1-3403a2f179cmr3475777a91.30.1761751190939; Wed, 29 Oct 2025
 08:19:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk> <20251028004614.393374-34-viro@zeniv.linux.org.uk>
In-Reply-To: <20251028004614.393374-34-viro@zeniv.linux.org.uk>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Wed, 29 Oct 2025 11:19:39 -0400
X-Gm-Features: AWmQ_bk3QGrfeacG4nKn1A56jExYpoFICsJu3Aq8X6pMLjFJYWj1N_7Lqh37COA
Message-ID: <CAEjxPJ60geP6mJsKW41Pj12tPCf-dGk=ys8vr5fEiO2tVj1Rdg@mail.gmail.com>
Subject: Re: [PATCH v2 33/50] selinuxfs: don't stash the dentry of /policy_capabilities
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, raven@themaw.net, miklos@szeredi.hu, 
	neil@brown.name, a.hindborg@kernel.org, linux-mm@kvack.org, 
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, kees@kernel.org, 
	rostedt@goodmis.org, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, 
	paul@paul-moore.com, casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2025 at 8:48=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> w=
rote:
>
> Don't bother to store the dentry of /policy_capabilities - it belongs
> to invariant part of tree and we only use it to populate that directory,
> so there's no reason to keep it around afterwards.
>
> Same situation as with /avc, /ss, etc.  There are two directories that
> get replaced on policy load - /class and /booleans.  These we need to
> stash (and update the pointers on policy reload); /policy_capabilities
> is not in the same boat.
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Reviewed-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Tested-by: Stephen Smalley <stephen.smalley.work@gmail.com>

> ---
>  security/selinux/selinuxfs.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)
>
> diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
> index 232e087bce3e..b39e919c27b1 100644
> --- a/security/selinux/selinuxfs.c
> +++ b/security/selinux/selinuxfs.c
> @@ -75,7 +75,6 @@ struct selinux_fs_info {
>         struct dentry *class_dir;
>         unsigned long last_class_ino;
>         bool policy_opened;
> -       struct dentry *policycap_dir;
>         unsigned long last_ino;
>         struct super_block *sb;
>  };
> @@ -117,7 +116,6 @@ static void selinux_fs_info_free(struct super_block *=
sb)
>
>  #define BOOL_DIR_NAME "booleans"
>  #define CLASS_DIR_NAME "class"
> -#define POLICYCAP_DIR_NAME "policy_capabilities"
>
>  #define TMPBUFLEN      12
>  static ssize_t sel_read_enforce(struct file *filp, char __user *buf,
> @@ -1871,23 +1869,24 @@ static int sel_make_classes(struct selinux_policy=
 *newpolicy,
>         return rc;
>  }
>
> -static int sel_make_policycap(struct selinux_fs_info *fsi)
> +static int sel_make_policycap(struct dentry *dir)
>  {
> +       struct super_block *sb =3D dir->d_sb;
>         unsigned int iter;
>         struct dentry *dentry =3D NULL;
>         struct inode *inode =3D NULL;
>
>         for (iter =3D 0; iter <=3D POLICYDB_CAP_MAX; iter++) {
>                 if (iter < ARRAY_SIZE(selinux_policycap_names))
> -                       dentry =3D d_alloc_name(fsi->policycap_dir,
> +                       dentry =3D d_alloc_name(dir,
>                                               selinux_policycap_names[ite=
r]);
>                 else
> -                       dentry =3D d_alloc_name(fsi->policycap_dir, "unkn=
own");
> +                       dentry =3D d_alloc_name(dir, "unknown");
>
>                 if (dentry =3D=3D NULL)
>                         return -ENOMEM;
>
> -               inode =3D sel_make_inode(fsi->sb, S_IFREG | 0444);
> +               inode =3D sel_make_inode(sb, S_IFREG | 0444);
>                 if (inode =3D=3D NULL) {
>                         dput(dentry);
>                         return -ENOMEM;
> @@ -2071,15 +2070,13 @@ static int sel_fill_super(struct super_block *sb,=
 struct fs_context *fc)
>                 goto err;
>         }
>
> -       fsi->policycap_dir =3D sel_make_dir(sb->s_root, POLICYCAP_DIR_NAM=
E,
> -                                         &fsi->last_ino);
> -       if (IS_ERR(fsi->policycap_dir)) {
> -               ret =3D PTR_ERR(fsi->policycap_dir);
> -               fsi->policycap_dir =3D NULL;
> +       dentry =3D sel_make_dir(sb->s_root, "policy_capabilities", &fsi->=
last_ino);
> +       if (IS_ERR(dentry)) {
> +               ret =3D PTR_ERR(dentry);
>                 goto err;
>         }
>
> -       ret =3D sel_make_policycap(fsi);
> +       ret =3D sel_make_policycap(dentry);
>         if (ret) {
>                 pr_err("SELinux: failed to load policy capabilities\n");
>                 goto err;
> --
> 2.47.3
>
>
