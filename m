Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A95E883F
	for <ocfs2-devel@lists.linux.dev>; Wed, 29 Oct 2025 00:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761696174; cv=none; b=VsuNSYDcehCfhKH4W4/z8SUytZRL9IYEIk++zeRz0VRv7qBYoRGIXygNYw54vFaFUjI16+ibfj+N4vyM3AebquudWGT8coIUI91v3Ett9+/vlRM/3gIwmki1BRQzCQk/bl1OD4VW5NqzBmWsXo2wxwC8HtoTFIIBmUdG5QNHZvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761696174; c=relaxed/simple;
	bh=m1Iz4iCevIOErVXwxDtpkzo89S0mMIU4Qz1L+Q2VZzA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tSPFLANqXOlEu1WJw9+tgY+v2L1wSOTKfIvNg+U+mFuRlYxhXbYbaH817e9ThNO0vkosxLz50CM4BGnIyMmHsV2S2CQYhXlR0V8Ycy2jcvkGAF7oHcIwTWtS5WoBurYgO/yxiPA59/OYgDL1LIpfNg5lYsmSRAORaaQnSm6Tsw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=SGZkBEIp; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="SGZkBEIp"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-34029c5beabso1683148a91.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 28 Oct 2025 17:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1761696171; x=1762300971; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xF6B/bGLrhNZetGrqx7q4mvUW1pHQ5FZufaW6F5zkk4=;
        b=SGZkBEIp+1pMLckun/z20EwZisbk1UEpHSt+jk1/dJQYy9G5z6NFLSGrZNDcFiFxML
         5nQNi22LFnCNOnQzJ3oC+Ed+sDIBtvDV1X9rbN7kUEJBCQVjG5HiP4JaSE7kim8bW6TU
         W/ae6D+sYewK+Z5FodCcthCV4H5jH9rWSonA7KR/ub2FSEDNvW9CmAD/tMyQNvSeMZcl
         n7kUjbVIDjHb/Nfh/0AAsXuw/o3QQGXMoW2qOkNqNnixChzZGL7tKK1BnW8V3pclUn38
         K/lPAeuHR4uAiEDAhBLuOyiH5iBbejfvhekwFySRiJmlZJLX76/Q/3UvrWXiVaN28Xfx
         ItRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761696171; x=1762300971;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xF6B/bGLrhNZetGrqx7q4mvUW1pHQ5FZufaW6F5zkk4=;
        b=Zns0KUCrSbFI/uGUJO3ifB63/Ug2bAIfItimtw8rMbYdCDkv4TwTJc3x5RgYSqy2KF
         GVqTMpa/rm7qriuYmC8An0Hp6PhuZeBV4bWfZvQZLVhtZTvMIcvlAVoKAchlzTgX7bS/
         /gf+imRY0qCOwJuCaH25BUCnvKFjKzjo2JO7tiWvhzyzWW/3gLGpfc6FjJkzXW02cwKM
         D4Cv3rR7TjPToG4OZVEFf9CcnLFc637lwuNTpmWTUj5MrBzTflix8k0eugGOd/qF6vX8
         BwEhKtTjtUTJg8eKpXsXHJSG9QcbFfGkBfocvojn2TJ6vP1quDcF1ng3o5Zl7uB882Td
         Fk0w==
X-Forwarded-Encrypted: i=1; AJvYcCXXy/Az1+1zTqBcJP9ejc/pzyC3nDLxb2eMBHVNVCYwfDzGqFJNO7KuhFOu2yh5Xw5ZUTwCi4vZ8VaTCw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/1YJ6qoldJOC4yl/l+uuByXQkzPrD82QEBHxwOw52Ij1xlWyG
	/Jr0Y0Fo1Z7s8+xx7dRdO2vYDeOH0DeSgnQbSP0QTmO5QGDwGjNBypu+a8wpEI+Cf1bbXPQ7Fw/
	EHILYtec2V5uA8/m+E/7FSB155VvDByGUXZvqvNPY
X-Gm-Gg: ASbGncvuixCXxiQMEFYvXkplQV6PTDWAF3kfjHBASEAzvLvL2ba3OSfJNhS4fgkK9U1
	aTvlPhUUZ7c9d35IgwiEay0adzp0VBNqmomwa3C351oFIE26W8+y+Sd7qqQ/QWIqpOB08JYcnqE
	OtRUs1n5banoNs8fD/aANrDDUh1mYvzh1Vifb8M1ZLPfNXI3AbvDGhgaE6AFpqDp5JCX47DpkcI
	hyK/8oyxTjHstUy7jberytuduZFftP9wt+0+zYEUbe3egjC86tPNWW7R1sL
X-Google-Smtp-Source: AGHT+IF4NZKo/CMR1Xvo4aqvxCL2dK2Kp/y68pib/yspEfnhKPr97BsNeUO4lrcXad0luDAxu81WWX06Cn/QvKa01OM=
X-Received: by 2002:a17:90b:54c6:b0:33f:ebeb:d7ef with SMTP id
 98e67ed59e1d1-3403a2a420cmr1024634a91.35.1761696171255; Tue, 28 Oct 2025
 17:02:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk> <20251028004614.393374-36-viro@zeniv.linux.org.uk>
In-Reply-To: <20251028004614.393374-36-viro@zeniv.linux.org.uk>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 28 Oct 2025 20:02:39 -0400
X-Gm-Features: AWmQ_bmmcbrTxQbk2K0S9dnAz964E4djBpHBaC2BLyDDdj2u6ZdL3nJ0xadT9U0
Message-ID: <CAHC9VhRQNmPZ3Sz496WPgQp-OkijiF7GgmHuR+=Kn3qBE6nj6Q@mail.gmail.com>
Subject: Re: [PATCH v2 35/50] convert selinuxfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, raven@themaw.net, miklos@szeredi.hu, 
	neil@brown.name, a.hindborg@kernel.org, linux-mm@kvack.org, 
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, kees@kernel.org, 
	rostedt@goodmis.org, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, 
	casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2025 at 8:46=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> w=
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

I suppose the kill_litter_super()->kill_anon_super() should probably
be pulled out into another patch as it's not really related to the
d_make_persistent() change, but otherwise this looks okay to me
(assuming I followed the DCACHE_PERSISTENT changes correctly).

Acked-by: Paul Moore <paul@paul-moore.com>

--
paul-moore.com
