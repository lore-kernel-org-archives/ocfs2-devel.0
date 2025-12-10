Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338D0307AC0
	for <ocfs2-devel@lists.linux.dev>; Wed, 10 Dec 2025 23:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765409246; cv=none; b=H9swvQerXLVh1cGUxEQpCIYAChtYJ7KAiAsA1KI+DRygwa7WyK9+DyDT/fohhzyWOJYi+3fnLoMWi+PQybA7HOrx3i7/aQTI4Vo2NGXTAM2T33VqiD5D697/NtIscyJuFA+Nkg/KaKDeCv5yOlcSLRgQYcgaMr19YmcX2PHsdY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765409246; c=relaxed/simple;
	bh=DoXwjGhLfQ6O0INuzypaERYkTOf/Xfv/Nd6aB7ZCJdw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Hg4j5+20lv3h2UYPFb2o8eVREnUyZJ/OqCnWPri/iNjwjRCSWA+d527vcFq+RNb0uCAEHQjNFqQdPhQ+8aMGerZGvyRV3X3zryMM6cCsVaHAUEPa7arJf94XzY3bFraDfPSz6otlyYWQuKDPfQWpBFkxIAVIuFJVwttHEbgudgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bvLAUVnl; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bvLAUVnl"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b79af62d36bso64555266b.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 10 Dec 2025 15:27:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765409237; x=1766014037; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lN8NB55nHLjC7gpWBKUqwQHD/ijjW2pyznq7L+gzEBA=;
        b=bvLAUVnlCC03HUTrG127uv9QpK6ME3ZiEhZUB4/YG/PJzq8c0UzsqVaNKKTRZJTBUq
         jUPPJLQ97csxOR/7c85mtTXHD1/AcOFcZkURdhrw3uN6DHKCAHAFnTk3Vnx7cBQn+nwQ
         tU0wUmS7scI774l0VwT6gF5/ar7rsKm9p306Vs0rIwb+yDK+TpYTrjICP87pb4pNeISK
         32W9uTb6f2zK2mVZmwt+Jto9nBVeiq9ne2pDQJ1lhyfZpZ9oSz7B6pWoQVpAbjkAHTpM
         8FmsF3M7XrIEcRwTg/njh+jomSUHjhCmRIlee2Ic7Qi2fH9ZPoX4PyuPDAePf7R2OZ0H
         iwdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765409237; x=1766014037;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lN8NB55nHLjC7gpWBKUqwQHD/ijjW2pyznq7L+gzEBA=;
        b=rYz0nsfKE1Rh49bHuh6ZJu2s0alMvhlz7j6rDgxLriqO9MMtlVpJXlaI/O2SO4mcpR
         7x6vYtVSvsWmUGrTBbb9nAAmRP6qnU1nwE+WqAYgB1C+sgVGyPuKUbKuU6g0co3vb5el
         bVB+8uwzTEFvfMyk8mDcCzbnZtJKoKojHbC1g7/rgnEWBiGDYF1Po1FtrR6b/x+75blt
         9c2jzwWqWHMDqfxpIIDzZj2Ozi84RjIZiFxEuIEpghhQIbsR8FhraSGEdT4bUYWgDDQY
         lYFY3UXdCgPM6d4UgCFrWHsmq2ZKt25lbeAD4tQ+PWa3UsIEeT8plnFzMryF5VsLU8x1
         HFDg==
X-Forwarded-Encrypted: i=1; AJvYcCVSNliqDLKPgUcLkjD7I798io4WpArTI5/NrqCxSbmGuTZeP673eim/vR+07v759BogLBgVo2A9w362PA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzcovlfS5hXqGxrGTfDZEbP0NLAjHPKibhmn9yCIwhBnGeQLaaK
	75DGxbr8vIB6aoCiJmxJIgY/VcKwQ/XfQwizrFvt4sRjpfDwuew3nI87CAmfI/eKiH77/dUlUrg
	H+vcoYxcxFqQi953R2RgRCBGb51EMtC8=
X-Gm-Gg: ASbGncuuUV3UCcgmwn6Vv0hx2rtBLK3mrx/xfZrPDNk22Fgpm5AWBe5KmJTcR156L8E
	yt2ofxVkQr3ABh5L7OUi5AsTfSfPQdQVIADAJITKkz9LR1Dqpbv1F8+JgW77jDa2tiKbhaaawOI
	bcQEYmTZr3oFg21bf2MEAdG6YHa53Q7bo2Ppz0mrtpHtg7ZzVqkO/bfF3H1vb/696iwZN2r66jj
	sRuG7ugYnHS7rF0Xu7GZcuzc/Eohmxk3kMSAEoeom8bSwQGzji/YtOpTuDCaDlS7j+4Lw2Uaf9d
	EsFZ0iNE1llfV6kGS5x2pPG+b7s3xSZC2cUj0Q==
X-Google-Smtp-Source: AGHT+IHGEOnQKiygEwmbu2JK8/4cUAiCBQ0NcgrrJh0q1P/i3d91XhaklIYwZdtfdem+xPxGhzLd1L0bXLJ/uH2w/bA=
X-Received: by 2002:a17:907:7e8e:b0:b79:cb08:30e with SMTP id
 a640c23a62f3a-b7ce8493888mr430540266b.58.1765409237245; Wed, 10 Dec 2025
 15:27:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6w4u7ysv6yxdqu3c5ug7pjbbwxlmczwgewukqyrap3ltpazp4s@ozir7zbfyvfj>
 <6930e200.a70a0220.d98e3.01bd.GAE@google.com> <CAGudoHE0Q-Loi_rsbk5rnzgtGfbvY+Fpo9g=NPJHqLP5G_AaUg@mail.gmail.com>
 <20251204082156.GK1712166@ZenIV> <CAGudoHGLFBq2Fg5ksJeVkn=S2pv6XzxenjVFrQYScA7QV9kwJw@mail.gmail.com>
 <7e2bd36e-3347-4781-a6fd-96a41b6c538d@I-love.SAKURA.ne.jp>
 <wqkxevwtev5p77czk2com5zvbbwcpxxeucrt7zbgjciqxjyivx@c7624klburuh>
 <CAGudoHE+WQBt4=Fb39qoYtwceHTWdgAamZDvDq1DAsAU9Qh=ng@mail.gmail.com> <20251210211404.GA1712166@ZenIV>
In-Reply-To: <20251210211404.GA1712166@ZenIV>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Thu, 11 Dec 2025 00:27:05 +0100
X-Gm-Features: AQt7F2pNJpaKIuw-0r1AjqkA5nkXEMZ029EnBmE2VhFHHI9ULnRkiIkxrv0pxNs
Message-ID: <CAGudoHEF6O-xR7B2F=6-Gy7t78FvH_f_0YcbmQM9gQAwthFpAA@mail.gmail.com>
Subject: Re: [PATCH for 6.19-rc1] fs: preserve file type in make_bad_inode()
 unless invalid
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, 
	syzbot <syzbot+d222f4b7129379c3d5bc@syzkaller.appspotmail.com>, brauner@kernel.org, 
	jlbec@evilplan.org, joseph.qi@linux.alibaba.com, linkinjeon@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mark@fasheh.com, 
	ocfs2-devel@lists.linux.dev, sj1557.seo@samsung.com, 
	syzkaller-bugs@googlegroups.com, Chuck Lever <chuck.lever@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 10, 2025 at 10:13=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> =
wrote:
>
> On Wed, Dec 10, 2025 at 11:24:40AM +0100, Mateusz Guzik wrote:
>
> > I'm delighted to see the call is considered bogus.
> >
> > As for being able to assert on it, I noted the current flag handling
> > for lifecycle tracking is unhelpful.
> >
> > Per your response, i_state =3D=3D 0 is overloaded to mean the inode is
> > fully sorted out *and* that it is brand new.
> >
> > Instead clear-cut indicators are needed to track where the inode is in
> > its lifecycle.
> >
> > I proposed 2 ways: a dedicated enum or fucking around with flags.
> >
> > Indeed the easiest stepping stone for the time being would be to push
> > up I_NEW to alloc_inode and assert on it in places which set the flag.
> > I'm going to cook it up.
>
> You are misinterpreting what I_NEW is about - it is badly named, no
> arguments here, but it's _not_ "inode is new".
>
> It's "it's in inode hash, but if you find it on lookup, you'll need to wa=
it -
> it's not entirely set up".
>

Comments in the hash code make it pretty clear. The above is a part of
a bigger picture, which I already talked about in the 'light refcount'
patchset or whatever the name was.

The general problem statement is that the VFS layer suffers from a
chronic lack of assertions, which in turn helps people add latent bugs
(case in point: make_bad_inode() armed with asserts on state would
have blown up immediately and this entire thread would have been
avoided).

One of the things missing to create good coverage is reliable inode
lifecycle tracking. Currently *some of it* can be determined with some
of the flags in ->i_state, but even there are important states which
are straight up missing, notably whether the filesystem claims the
inode is ready to use *or* not ready at all (not even in the hash) is
indistinguishable by ->i_state. Trying to figure it out by other means
is avoidable tech debt. Bare minimum denoted states have to
distinguish between just allocated, creation aborted, ready to use, in
teardown and finally torn down.

An important part is validating whether inode at hand adheres to the
API contract when the filesystem claims it is ready. For example
->i_mode has to have a valid type set, but syzkaller convinced ntfs to
let an inode with invalid mode get out, which later resulted in a warn
in execve code because may_open() did not apply any of the checks to
it. This is the kind of a problem which can and should be checked for
before the inode is allowed to be used.

Another benefit is that some of the state can be pre-computed. For example =
this:
 static inline int do_inode_permission(struct mnt_idmap *idmap,
                                        struct inode *inode, int mask)
  {
          if (unlikely(!(inode->i_opflags & IOP_FASTPERM))) {
                  if (likely(inode->i_op->permission))
                          return inode->i_op->permission(idmap, inode,
mask);

                  /* This gets set once for the inode lifetime */
                  spin_lock(&inode->i_lock);
                  inode->i_opflags |=3D IOP_FASTPERM;
                  spin_unlock(&inode->i_lock);
          }
          return generic_permission(idmap, inode, mask);
  }

... will stop setting the flag as this aspect will be already sorted
out. There is another crapper of the sort in vfs_readlink and one can
suspect more will show up over time.

Back to lifecycle tracking, I_NEW could change semantics to mean "this
inode *is not* ready for use yet". unlock_new_inode() already serves
as a "this inode *is* ready for use" indicator, it just happens to not
be mandatory to call. Another routine could be added for filesystems
which don't use the hash to cover that gap.

Then for filesystems which *do* use the hash the entire thing is transparen=
t.

> A plenty of inodes never enter that state at all.  Hell, consider pipes.
> Or sockets.  Or anything on procfs.  Or sysfs, or...
>

So whether I change the meaning of I_NEW or add another flag, I will
still need to patch these suckers to do *something* on the inodes they
create.

That's not the whole story, but should be enough to convey what I'm gunning=
 for.

This will also have a side effect of giving I_NEW a more fitting use.
