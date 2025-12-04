Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F982F25FE
	for <ocfs2-devel@lists.linux.dev>; Thu,  4 Dec 2025 08:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764837617; cv=none; b=MEFaK5FH/wUo8B6BvOOWOLNOG2MGfzruTnkQki0S8iMMnMq1M5MCmPwcXEl3IQzd2fV0nGxs3m1DtvcQndQQXVnpBxnv0K82yvAc97qOxGmNFgVMgn6p/w13itVyhKIFfTQ0SWRYfuKy1fg3qnmRXwDRuygCZ1cqzcdPXyMKi88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764837617; c=relaxed/simple;
	bh=FroCwkTNZSbRQ7TU99YyvaiIjh/ta9/hGMaO6hX8Pms=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e/uj/q79qxcubCARCwoUtkLz7mAhz2f4NxFJj9NAxKU0n2sPWAqM3GGSEiLSdklgdjl5Nh/5BGXMKv8CSs1sdMu2QBftYB4P0jxDVSRoLvr4bSpT3hEzDl+ycUWejoTINwh/stWyeqMEIheOHWz1AsvYM7lXaj6yAfheC/HP5ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kotN+oxd; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kotN+oxd"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6417313bddaso888957a12.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 04 Dec 2025 00:40:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764837614; x=1765442414; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gRRLPG76m6Du1ADzYb/YIlc2W//pdAMonfFY/36m1Uc=;
        b=kotN+oxdzm5oir+IiJKy9SZR85BynWxSwrqyakoMWK4M7gXpZfDOb+p42ciPkasili
         45dDQyEFlJto2sjwE0A2SgEVnHq7poU6WR6pAzZN4zOY0xl5OJ42+zFyjy7Lu8IWy+Xk
         q0W/PdUkP4zZ3pS/WmrFVvNICS6kplr766e2e9a64iSqVAcwogU1e/4Lb30lK1GC64Lm
         RK02ev2awpt5HwLZ0mGM1LoscBCVtLlUu2RlZX2fePH8gWwb7Y+Of7cABhPzo53Ju/hh
         QAFiSxPJcjugzOto2FJMfjbIMasMxP/RS8Tu3MWmCMVFi/vUExtvEsJlosRnDk02Rn3b
         gL1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764837614; x=1765442414;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gRRLPG76m6Du1ADzYb/YIlc2W//pdAMonfFY/36m1Uc=;
        b=PnqXTsH8ATtwVekvWRgBmaxEPUkyEhTFqYLURazHx33Mw/X4iGBxheqf+AOxkeVo2L
         HXZdX6Kq92dHzAyZw4mty8uYepahYbqg/OIwrd+ouZqXunzNLr1fV9npAVKld/0iFYLC
         pthvyXE9qyqCRnVniSTfdp0N3Fr0LTkdUb+gcyiOSfbTR35/HUQG83lwBynDsll5kVsS
         lgXZZC9Nlqtznca4KIc5Lf9Bv4GirbwyjhGrIY2dP76MaSzRJRSXcxFznxwX+fd3hxFx
         diZ+Y7rR72YohtFa7F/csPLKcUTHy479+05e0tTMWZxAz0U0rEFAslEzmzW8BSNORkDA
         SdNw==
X-Forwarded-Encrypted: i=1; AJvYcCUU/dxjgs5AwiXzqQsi3cA3DLpWvTOnJqMwQdR1b8xtvczR7XCLqzrM2fYuVByO4W2nrU8CqsPjSqFypQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwAxsovh3xLwWhwaZ8oyNzWxB28GPBwI7UuAtnaKQ9R9Q2Luwkp
	mpJgKR07ropeZB87IuRxnSvJmlCGKT6mQx85l8M6qKJZ/EHq6cB6tVui7zZw4t6sF1XkHJsfz1Y
	W1n15PzTvD67RoRW1CGpyTs5B8MvQ4CM=
X-Gm-Gg: ASbGncsB6SnNg3bFgrM8dORXTQ6M8E5yJ4DSFm8ZZGG0QW63delpus2z/ktbhul1MwT
	awmOz9CvCPjcxg80wz3v0BL9QLoHKUfk+UEjy1psiHW4tTWC3k1ZXttpLzd9OuChhDxMZ1ezDL9
	OeZBQJD9SBDPa7d3BMv1frOolIgbrAZ9Z0LsxHiJZenS5KUAiTsXgKRVEwhXlHHyoOMtbX8hn7d
	trHbcrnO8rXMwCzU3Wi46HAWGY1P/+X/m0L7RzooAQEJx6RcpxkywdeEKtEP7cSvGBZedZpMmCc
	VpX4km9Co7/POMg5SNhU0H7IIr3IAdkeOUIq
X-Google-Smtp-Source: AGHT+IGlFWje4U/u/Ih/ONo6YwiZd7raWA7THK9IcGYx+25tDvWlw2E3FAkL0bv0Df4dVPXNv3OSYE+s0HYI7vSQfuo=
X-Received: by 2002:a05:6402:234a:b0:634:ce70:7c5 with SMTP id
 4fb4d7f45d1cf-647abdcf6camr1736379a12.17.1764837613800; Thu, 04 Dec 2025
 00:40:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6w4u7ysv6yxdqu3c5ug7pjbbwxlmczwgewukqyrap3ltpazp4s@ozir7zbfyvfj>
 <6930e200.a70a0220.d98e3.01bd.GAE@google.com> <CAGudoHE0Q-Loi_rsbk5rnzgtGfbvY+Fpo9g=NPJHqLP5G_AaUg@mail.gmail.com>
 <20251204082156.GK1712166@ZenIV>
In-Reply-To: <20251204082156.GK1712166@ZenIV>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Thu, 4 Dec 2025 09:40:01 +0100
X-Gm-Features: AWmQ_bmNCQYBKlBK115x3hqZe8lwJ60rwoZL8UAGeBOKbtZYBd__aUpRO-CzYk8
Message-ID: <CAGudoHGLFBq2Fg5ksJeVkn=S2pv6XzxenjVFrQYScA7QV9kwJw@mail.gmail.com>
Subject: Re: [syzbot] [exfat?] [ocfs2?] kernel BUG in link_path_walk
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: syzbot <syzbot+d222f4b7129379c3d5bc@syzkaller.appspotmail.com>, 
	brauner@kernel.org, jack@suse.cz, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, linkinjeon@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mark@fasheh.com, 
	ocfs2-devel@lists.linux.dev, sj1557.seo@samsung.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 4, 2025 at 9:21=E2=80=AFAM Al Viro <viro@zeniv.linux.org.uk> wr=
ote:
>
> On Thu, Dec 04, 2025 at 08:45:08AM +0100, Mateusz Guzik wrote:
>
> > Or to put it differently, lookup got entered with a bogus state of a
> > dentry claiming it is a directory, with an inode which is not. Per the
> > i_mode reported in the opening mail it is a regular file instead.
> >
> > While I don't see how this can happen,
>
> ->i_op set to something with ->lookup !=3D NULL, ->i_mode - to regular.
> Which is to say, bogus ->i_mode change somewhere.
>
> Theoretically it should bail out, having detected the type change
> (on inode_wrong_type()).  I'd suggest slapping
>         BUG_ON(inode_wrong_type(inode, new_i_mode_value));
> in front of all reassignments (ocfs2_populate_inode() is the initializati=
on
> and thus exempt; all other stores to ->i_mode of struct inode in there
> are, in principle, suspect.  Something like inode->i_mode &=3D ~S_ISUID
> doesn't need checking - we obviously can't change the type there.
> Unpleasant part is that struct ocfs2_dinode also has a member called
> i_mode (__le16, that one), so stores to that clutter the grep results...

Now that I wrote this I suspect there is at least one way, regardless
of whether ocfs2 is culprit.

Suppose you are in rcu-walk and someone continuously issues mkdir,
rmdir, creat, unlink on the same pathname. Affected dentry will keep
flipping between directory, negative entry and regular.

While such fuckery will be caught with seq changes, perhaps the
intermediate state can indeed result in finding such a mismatch but
only because of a race.

I'm going to have to chew on it, I don't know if I';ll have time today
to deal with it. Worst case the fix will be to check if this is a dir
in lookup_inode_permission_may_exec instead of merely asserting on it.
