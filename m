Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9873358D2
	for <ocfs2-devel@lists.linux.dev>; Thu,  4 Dec 2025 11:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764849526; cv=none; b=VTEwwepHhiyW+kQGP9/dXXgBmMptCisoEdZ9qsbZNLHJn9WrvFjKPltYLIZhP6GUFAT5SppnPi2WXEgWTySduL0vp65P/2ZIWlQ2h6HPP7CMWMXSmygRIiMqncGrza4pEGjCpPNQzVoVUZaZWya31JGe5wm6ynrM5w510RJJBBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764849526; c=relaxed/simple;
	bh=G0P/BjEQyt89BmOUGn/wcDWujkDYsVOGhHTJqZN9U3c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vnbl12gXLU/DbrWRZO1JBitttsnfRD0B8iWLlsg8s6+rAh4Flxoe0bkWiDL+2purK+t3MO5REOYUSoN9l0ae22Eiqx6n+HTtsq/1YZnY7I2+adgtnMqQBacWzs9fBkx00nfl/veuI7AXeWppCTczMLnUpwRgx447bq47LOl+0yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ayLxkjIA; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ayLxkjIA"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b79f98adea4so31581766b.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 04 Dec 2025 03:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764849521; x=1765454321; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kdRxtjV4AYaI8LinC3rLYWwY9We5uYRQ7iuB0whbJMw=;
        b=ayLxkjIA0c3ldOMfi+vzOi5FvUvcLtZVhOn6EItLdlg5BRnofISPnQ/ADmGAA7+36q
         pZoG7OcFSJzB6siw5pg1wevtO14b4r8De9xIcwBN5b7MHQ4Jjr6LcxNrC2U4rOTPL/x4
         hXqRXxafudap+9GkaMKkr06l8l9hIhIS9CLdZKWJIU8IsL67feizm5Jwzv/3ia7CSFFP
         pcQDJeU5NGzTZ2l6kUxhmoW/jpY6eVoqGmF+bwNY936I0r9ZmTUDXb8ZiNorL3rnFuYh
         vuB7wwud6HFdyeoaRvIR5nj7DobkhLx1kqMBKf8AQeXyeE0rxypO/YANjJOTfCUZJc7X
         UOMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764849521; x=1765454321;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kdRxtjV4AYaI8LinC3rLYWwY9We5uYRQ7iuB0whbJMw=;
        b=D1fr3CYvsSDT9xKRcSd0QBPvG2ExZe45RAtel/+9ZQlPxEJXlPVKq130Ybley+jx7s
         hGXRKGpN+mYz1xumINyl13F8gooPDSgWMGRzESvMOrNbivHv37WusEavdCDTuG+haXLf
         QNtvSt5wA24Bx+GBTdnzgoFtdyOjBcttFDDz/U3SccKnGlI4k3/5EgYHFCWYwYoJ6h5a
         gSFf1BNgA00oV0RcmXmRUrlHaE1HB27XvAgM9sW8LcZ33DzfjARP0YV9LefYwstA9DWm
         3kswGqWSha5jUaD6moiLC26peMFOdAuoHgxlpQpcRdg9idIbFUWbKPk9GoL9xjQn8A6b
         aoXA==
X-Forwarded-Encrypted: i=1; AJvYcCUtz8V1YhYgtOolXOXQ22svfwfgx6q3YIoQwECoohwPjkB0w6zb3rqlbPTJtKqJ3iXSV6n7mZWNTBjLEg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy7NS+LUDxtW4TkEjMxN2r0HLTPg/M551PzFdGCMwBk7udYhASE
	EEWKysF2t4jSeseA4RJ1uY77b4lJA9U6Bbhess+GJUUMn7JEfOMi/FE5OVAPasOJFuXeiET0O3P
	w0e77ZR5ZCJQuF5Yfu1dGuAHJ4cWOKBg=
X-Gm-Gg: ASbGncsylHZab/YoIoJhlViY+xYl0suVM/ZYrVtZ5SfQpLmb4yNktnkK+4mC1X1IdfK
	G4Ksyi2i7hHmnDuY7upC9xFA/A+WXRylmaHoGU5wh0xaRbCbd5QNo4sz3PHkrrCqCbVpb1Ps+Yx
	DikHJeg0CTh14iPLgwsR7gdCAaZKxT0N5VeastC94H7crtqGpMBPuhxz6/0ViElXthzF2pB7oob
	vOh/EIakyk7+EU+Ewl9SYePfkLxOWP4kkf1y27SUPgEvg1aoQLkn1EKasaf1XDh9DkRTaVUhNIK
	XhhUqwNvDmGPQIX2FWlS+jbK0gauXOHS+4NF
X-Google-Smtp-Source: AGHT+IEZAg/XFTe1Ny7kp3td3ZFktfRztIAEYhqqLPG+NV2hEX+i0dMxJNlWGlVMUPP51XWp+MDN09fnafSDZDrxxXo=
X-Received: by 2002:a17:907:3f24:b0:b73:b05c:38fd with SMTP id
 a640c23a62f3a-b79dc77dfbfmr569759366b.50.1764849520449; Thu, 04 Dec 2025
 03:58:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <y3ucyzxisq6hcrhynzyhmb7h4vpzkyuueqesw547cx5zmzrvl4@offzqo327t4w> <693176d2.a70a0220.d98e3.01ce.GAE@google.com>
In-Reply-To: <693176d2.a70a0220.d98e3.01ce.GAE@google.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Thu, 4 Dec 2025 12:58:28 +0100
X-Gm-Features: AWmQ_bkIM7DKIOzDV3ZsYcLI4dGCflwhm-WCUoJ2WXb1p2GWU6R9B8YfTmEKDK4
Message-ID: <CAGudoHG-16TCj3+nMseN9RVeybEPm4WTHn2Xqmek6Hc6k+=e0Q@mail.gmail.com>
Subject: Re: [syzbot] [exfat?] [ocfs2?] kernel BUG in link_path_walk
To: syzbot <syzbot+d222f4b7129379c3d5bc@syzkaller.appspotmail.com>
Cc: brauner@kernel.org, jack@suse.cz, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, linkinjeon@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mark@fasheh.com, 
	ocfs2-devel@lists.linux.dev, sj1557.seo@samsung.com, 
	syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 4, 2025 at 12:56=E2=80=AFPM syzbot
<syzbot+d222f4b7129379c3d5bc@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot has tested the proposed patch but the reproducer is still triggeri=
ng an issue:
> kernel BUG in link_path_walk
>
> VFS_BUG_ON_INODE(d_can_lookup(_dentry) && !S_ISDIR(_dentry->d_inode->i_mo=
de)) encountered for inode ffff888074eca4f8
> fs ocfs2 mode 100000 opflags 0x2 flags 0x20 state 0x0 count 2

note the patch at hand made sure to avoid transient states by taking a
lock on the dentry:
+       struct dentry *_dentry =3D nd->path.dentry;
+       struct inode *_inode =3D READ_ONCE(_dentry->d_inode);
+       if (!d_can_lookup(_dentry) || !_inode || !S_ISDIR(_inode->i_mode)) =
{
+               spin_lock(&_dentry->d_lock);
+               VFS_BUG_ON_INODE(d_can_lookup(_dentry) &&
!S_ISDIR(_dentry->d_inode->i_mode), _dentry->d_inode);
+               spin_unlock(&_dentry->d_lock);
+       }

So the state *is* indeed bogus and this is most likely something ocfs2-inte=
rnal.

I'm buggering off this report.
