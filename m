Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BDA2E265A
	for <ocfs2-devel@lists.linux.dev>; Wed, 29 Oct 2025 15:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761750433; cv=none; b=CL+CoFyRavfYNwRp/q3hlj8ZlgXuGNIa8EXPcQ5+JZDNxnCyxMSHbuGKFMg56WfCKyqg6WTCALCCZfxBhXjZaw2oS86ylfH8xnNVIXmu3gpt48W8rEjdy43p2SHcyQEBnQoi2kp9XjP4eKQJn7ixWSzWTOj6koqqrgI3wyFYOBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761750433; c=relaxed/simple;
	bh=f8Fhr45tAG7sziLg9U37nK1+JBvIXcz4AelF+jGe5oE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LsGm7j2CgvIPppU+wqMNSB3FiF3QqN/4r8JgLmRcmJKxpZrPCYuU/mIiuih6VrwVeISn+MhUkWFTRdWTxx7SIMt8JG5Hqj0nMXBZf/A71S4BBZIt3BmUc13cLSck2JEp3bfJAKqtraESkBr5xuhJfVhjoVGjXN1zXVe/ZIAS620=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j2eCXAQJ; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j2eCXAQJ"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-33badfbbc48so12641a91.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 29 Oct 2025 08:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761750431; x=1762355231; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+IfYIDKxJGGNldyfSmZN9xBlg4Ge86/H8w7OAL6l3zA=;
        b=j2eCXAQJpsdBO9XjwJVrefRp687kHVKi52eFYsiIeRGkXzEDCWjIA2qG/iYf+r8pZ5
         cZYe6rmg03T2262pOS1iwT9OuEAQ9tB2fhrQZUmWj+vS0BM2mN3pfFwSnDoAOy8ILv22
         G2Lsq4SSm38xnGVYH4cncEV9/iYU/AfyGwqTfR6HkRIh2wo2b2MfFn6xNekVKV7jOAdS
         yMeUZCixsIc8FkRKqtyJVeANu6vvzkdQrmc0gyqLuDX3UvEBPQqea/ISHR6EmL+x7uwi
         wMhkqwf0Lp8biSiyautCUMRYj3q6BC9cKCrbFUspdI/8mQoXYA3R3xgYd6LQzho33K1q
         REog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761750431; x=1762355231;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+IfYIDKxJGGNldyfSmZN9xBlg4Ge86/H8w7OAL6l3zA=;
        b=bIOb/8zaNJdOzcsvQ7jRettsne8xfRa/ci1Z5g4Isf+Cxci0ROFd55PGOZYlKnYick
         l8VVs6h9Ssjhzbo9zLm7FS3t0VW3UYCKZn2LH3C1MSG8XtYJqRCInKgi2OAX51SEY0oU
         iNbtjSzickV8HpTncc+PslMxYaBtLicaKHJ5vCIgGqJMxXEJNiONIUJHjCi8DOApJUv+
         XOy0bbpboowmqS4L+zucDf4kwMIbn3eMEyGmIuOsC89B/uN2NCmg7Bftbe23cdagM1ZR
         sfRn7Fls5jj3e/m8Z8mRD83+yxtuPvKNF0m+YgIzHFu92dq7HrW8SWRMYboBZiJOL/FW
         aEkg==
X-Forwarded-Encrypted: i=1; AJvYcCWif9ZzZcAL2Zfd6arRPAoiXuswdUn66CIZ63PyLoTVWs7yxyRBSs7Jj4dKJAMHjasH6zeHNVxRy9USnQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwIMuB5ZqwmeFnRNW64yCbouOtM+QrcODCjKoRRv7XMYDwe+bLJ
	FzGIhgC1ItRN7luFbKPugZt8LYevZx4oiR58Bybu2q2hD59VzRJ5xDO1tn1YNsVOdrcPcNMnO16
	dT1w+47hBoA6dC+opTbItW9+2/CPAoPo=
X-Gm-Gg: ASbGnct3D2sfxFfqoxG8eCwxY7pgjv9M2cEBcxIlO+GTZmJ69aeyL4CReIn68AVGbqd
	i4Br2bTmme5PYBSL2Ilq76fM+91uMqHJ7yJWxEOplDr3kn29YtxNoL8dPHxH7Um2XDK3mvBO2+u
	qJ2REIU9+rZdIOWhr4t5H38irR3YB3T8BYS2eDF5OEFxQBkg5OFSMkgl81cJ0r2TL3owLDeXrod
	p1fYDFKicThgXue+upZQjKnxhgxibZZyyCzqYQEjKFocbhMKjUAcRQGN00GJai1+gRTktc=
X-Google-Smtp-Source: AGHT+IFVqO8ewpIAf0wvRQFGIOOwuq6fD8Gg5dHkMSFcg7AR9XFXs/odOiaOENp+NesUqtIMC2BHNrgVUxHGzL0/CTY=
X-Received: by 2002:a17:90b:134b:b0:32d:db5b:7636 with SMTP id
 98e67ed59e1d1-3403a28efb0mr3676582a91.27.1761750430698; Wed, 29 Oct 2025
 08:07:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk> <20251028004614.393374-36-viro@zeniv.linux.org.uk>
In-Reply-To: <20251028004614.393374-36-viro@zeniv.linux.org.uk>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Wed, 29 Oct 2025 11:06:58 -0400
X-Gm-Features: AWmQ_blCWCRSlgnSUoNEZRYW0rUX4EVkF7hJCMWu9E3EunP63rWoSyVWbO7_enY
Message-ID: <CAEjxPJ53wJEK4bzt0VMbY=G9gkzuZZA_XtrT+acwPys3p0byBA@mail.gmail.com>
Subject: Re: [PATCH v2 35/50] convert selinuxfs
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

On Tue, Oct 28, 2025 at 2:00=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> w=
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
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

I took this series for a spin and didn't see any problems with the
selinux-testsuite.
Also re-based my WIP selinux namespaces patch series [1] on top, which
introduces multiple selinuxfs instances (one per selinux namespace),
and didn't see any problems.

Reviewed-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Tested-by: Stephen Smalley <stephen.smalley.work@gmail.com>

[1] https://lore.kernel.org/selinux/20250814132637.1659-1-stephen.smalley.w=
ork@gmail.com/

> ---
>  security/selinux/selinuxfs.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
> index f088776dbbd3..eae565358db4 100644
> --- a/security/selinux/selinuxfs.c
> +++ b/security/selinux/selinuxfs.c
> @@ -1205,7 +1205,8 @@ static struct dentry *sel_attach(struct dentry *par=
ent, const char *name,
>                 iput(inode);
>                 return ERR_PTR(-ENOMEM);
>         }
> -       d_add(dentry, inode);
> +       d_make_persistent(dentry, inode);
> +       dput(dentry);
>         return dentry;
>  }
>
> @@ -1934,10 +1935,11 @@ static struct dentry *sel_make_swapover_dir(struc=
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
>
>  #define NULL_FILE_NAME "null"
> @@ -2080,7 +2082,7 @@ static int sel_init_fs_context(struct fs_context *f=
c)
>  static void sel_kill_sb(struct super_block *sb)
>  {
>         selinux_fs_info_free(sb);
> -       kill_litter_super(sb);
> +       kill_anon_super(sb);
>  }
>
>  static struct file_system_type sel_fs_type =3D {
> --
> 2.47.3
>
>
