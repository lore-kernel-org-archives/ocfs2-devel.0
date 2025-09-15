Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A886530C357
	for <ocfs2-devel@lists.linux.dev>; Mon, 15 Sep 2025 13:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757944126; cv=none; b=jolUCLGOBWI6gjzR4nbm/4TkRLgzzZMXjy+SHt9F9x8TZ5BA0HavR+iI0RJV9FGxOlGZcIF2wm3I0bmrhY68oT8IopziGaa3/jP9czCZwYADYvP5pKOaVGrxCN7xFHc4hPX8LUn0NifPZevXod1IjsNkpfJbHdfqZv5tyv5bsLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757944126; c=relaxed/simple;
	bh=ZQub+XOP6AHhSCrQS8OLhNc41tiEetqbLr9I34JJKfI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DbqI1M+qASR/P+PulgZGqcXOS35vL+cjrXR6UJgvrXf8liL/8uUiVd9ERdTToMoWf1rYhIcInq1Ag7HCxxkdw0gZ8uXfvRubLVMvsZ2/zC+652CJq6ZD0p2pDtDezNRmBSSoW95uEImoRt64fcF16GEBlJ1YR/nLCLyxopIMo5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HTMgiwAV; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HTMgiwAV"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-62f5bfd0502so18287a12.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 15 Sep 2025 06:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757944123; x=1758548923; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZQub+XOP6AHhSCrQS8OLhNc41tiEetqbLr9I34JJKfI=;
        b=HTMgiwAVdjNo/FYER+DvacLM7tUcqn/Hus6SSMDv0/Zr4oshaOCs+OF3dnVVFYoPvK
         9L+7UyMqwTxOSH/KBumgYXdzCbXDdbcnJERYpRXw/w3Jl6NGgHTFzOTzQj1/DONalSeD
         WyHpNHAxOr38kBOtjUdeP/Ot/jF+mafnxxSpGd982GVg6URkBp5u6P0W4ht1bUwtluXO
         Utg2aep9W3gttcvzXivaHfE0rtLIE/FVkSD2AWFlYLdRhgHDIKPWrrC7q67DcAXOMTc8
         KDEZHne6sW2jSPWohEuME7tgJ/Xg4twn3IDph3bm6LynHykQzllSMfYsCiOzZiWJwi9B
         MwNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757944123; x=1758548923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZQub+XOP6AHhSCrQS8OLhNc41tiEetqbLr9I34JJKfI=;
        b=nWgF7XIXQYGHewoq7Ve3d6kfPpDKCxC5/Mj58Hw0xtIvCdwku7on6zHRN8jfPGTpRE
         GV1nU1NqBIw/IdXWTTl2TL9Ifogb2YNPHusW8NDU4Jwr6U1y2BuPK0/lkFb2P+UAJJFP
         DY34k7crA3jk50bZ+Xs5aliXUozhZk2uQpCPme2Z2u/PReng7z8+36bFwKJJApnmg1C/
         1zv5uHpRT8MWzMeIZKXCT7zkeDqnWmoC1H+ZsSbvX7UZJ5TXliRnCLUQbGjo1rYuw6J8
         J8n4BrfZx1Ky9BDmWGIkLGduj8vSCjRL6WciZLut/f8Tb+CFW7uSwtPIeTEeLS4eVJOy
         KUsg==
X-Forwarded-Encrypted: i=1; AJvYcCWIQpFtaZnmEOHeaKMUpNKKMhGyOTW3A0kEHlk620zOU4I9l/mhb+r75ne6jC3VVXo39etwS6cCnBdmiA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxonIvASO5NPI38q2CxdQ/UNG/Etm6ycuTZ/wrrxTQFof5RvYzU
	BVgE8pJwoP5BlCwJNcIsJQ771DNdrv4IzX3mj3ihNf9yGlHX0VBMyyTYAdRpTvP92mCGBL6SgN1
	1exr9goCzS7fFZYQj6GeHEIZDW4trKog=
X-Gm-Gg: ASbGncv+2XV78kQiWWvkJF1xzEY9zU94DAiHj08re7X8u+dSHlb9OJxnA7xvALdHfnT
	p2AHvGhJ/+gFOil7lqH+VxwxrHZ8oHtrUmGwKRzKikpHoQqXUPk8TDzoLZwF0hnav0NtMZcCfyl
	V+7xiRtnUR+CTuaEY7GCKVv1BdHWp0AwTYFPwM3agZvh2BKhlNfPuuarZEv5bvlybN0S2ghLAEx
	H7CxtmuAWpCA+mIl+thGFiVTZREkGGQou3PK+is3CvhxzDK7A==
X-Google-Smtp-Source: AGHT+IHKOjA1HGcuEvHra72Dd+b7paytkVEuO8cRpT6BW/OBg2GvOxuDt2DlAqGkxcef1Fdd4odGq3BTUr41/Ykmo58=
X-Received: by 2002:a05:6402:4556:b0:62a:53ad:c5f6 with SMTP id
 4fb4d7f45d1cf-62ed80d0d53mr10005029a12.7.1757944122921; Mon, 15 Sep 2025
 06:48:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250911045557.1552002-1-mjguzik@gmail.com> <20250911045557.1552002-3-mjguzik@gmail.com>
 <20250915-erstflug-kassieren-37e5b3f5b998@brauner> <CAGudoHG7uPDFH9K9sjnEZxZ_DtXC-ZqSkwzCJUmw1yKAzEA+dQ@mail.gmail.com>
 <20250915-tricksen-militant-406d4cb8ebda@brauner>
In-Reply-To: <20250915-tricksen-militant-406d4cb8ebda@brauner>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Mon, 15 Sep 2025 15:48:29 +0200
X-Gm-Features: AS18NWBzKunwGtJz0IldCwMc_KnnKbN39RwVHQ4hFOW8fT-nO1xKAbfCWtkbTJc
Message-ID: <CAGudoHETnk1NJe_7TAsweokKia2xtKH0bLn-V7+hcE1voiqrhw@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] fs: hide ->i_state handling behind accessors
To: Christian Brauner <brauner@kernel.org>
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, josef@toxicpanda.com, kernel-team@fb.com, 
	amir73il@gmail.com, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org, ocfs2-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 15, 2025 at 3:41=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Mon, Sep 15, 2025 at 03:27:16PM +0200, Mateusz Guzik wrote:
> > On Mon, Sep 15, 2025 at 2:41=E2=80=AFPM Christian Brauner <brauner@kern=
el.org> wrote:
> > >
> > > On Thu, Sep 11, 2025 at 06:55:55AM +0200, Mateusz Guzik wrote:
> > > > Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
> > > > ---
> > >
> > > I would do:
> > >
> > > inode_state()
> > > inode_state_raw()
> > >
> > > Similar to
> > >
> > > rcu_derefence()
> > > rcu_dereference_raw()
> > >
> >
> > I don't follow how to fit this in here.
> >
> > Here is the complete list:
> > inode_state_read
> > inode_state_read_unstable
> >
> > first is a plain read + lockdep assert, second is a READ_ONCE
> >
> > inode_state_add
> > inode_state_add_unchecked
> > inode_state_del
> > inode_state_del_unchecked
> > inode_state_set_unchecked
> >
> > Routine with _unchecked forego asserts, otherwise the op checks lockdep=
.
> >
> > I guess _unchecked could be _raw, but I don't see how to fit this into
> > the read thing.
>
> _raw() is adapted from rcu which is why I'm very familiar with what it
> means: rcu_dereference() performs checks and rcu_dereference_raw()
> doesn't. It's just a naming convention that we already have and are
> accustomed to.
>
> >
> > Can you just spell out the names you want for all of these?
>
> just use _raw() imho
>

For these no problem:
inode_state_add
inode_state_add_raw
inode_state_del
inode_state_del_raw
inode_state_set_raw

But for the read side:
inode_state_read
inode_state_read_unstable

The _unstable thing makes sure to prevent surprise re-reads
specifically because the lock is not expected to be held.
Giving it the _raw suffix would suggest it is plain inode_state_read
without lockdep, which is imo misleading.

But I'm not going to die on this hill.
