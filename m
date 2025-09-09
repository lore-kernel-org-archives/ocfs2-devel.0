Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8E82D23BC
	for <ocfs2-devel@lists.linux.dev>; Tue,  9 Sep 2025 09:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757411847; cv=none; b=mF1j5C8r3KNNzUtdm+rZyqagFdgbS/O1S9cqnBk1Y2OfvwLdSQ7fYv77/56VuO+LG8tXkd6SnxntTfSIFrfWiwRkcr00JOL2bFNbfMlw5X4CrQv9Tz4AvxlGMdRNo4u7xjmH5S8llFcQuw2BwOw4LZpvrwKoFYazhS97O8P5kTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757411847; c=relaxed/simple;
	bh=RAE17ZYZWlIDCZkrsAY+6DPY1arC89Zp2iFLktMJp94=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M82jEnyv4sV8I/pGuhsmJNx4D5d7lTpE6Q6J80jBc67U+5JQeMzVpHs5nA8qoVXprM3X+ILH0xtzDSSu93Mp3rlpvAMRgoI3kVT65V3kT6UL/1gXV4TnkuQmG1bfBcblhUs2dWeBSHOTcd+6E8Y62vCgvP5yGvW01MfOgYBrMlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N6B5w9af; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N6B5w9af"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-620724883e6so9058088a12.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 09 Sep 2025 02:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757411844; x=1758016644; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RAE17ZYZWlIDCZkrsAY+6DPY1arC89Zp2iFLktMJp94=;
        b=N6B5w9afW7XRRBFmEtZfz28g9iraeXrMRyLzJThFch8I//RhjbGQRQz87Z+EVDqgMj
         KQCUDdRv7fHZ6sJb9R3zJ1j9ThEDdDv65OWd6/SEaA+BkIt4ZdmnMFjmFp4VEzOPg9jn
         eAhKBVYkXPWFQ/uB3z0kUc9tQWs0I39bAAB/yUn5HxpjNKotm5eVKSSMIYzQ6pOixp6Z
         N5OU+nulKPq686+le48SzpnDfBtG4vWwg/3JTYe3RqB2WSI/SSO9LMldzgYYddNTFS1N
         GJU+LLKRi3JIyRxLCTy8XJ94hkwQZAAxFQI2KQAOGVDoFZsG7Vg2bGJ+5g39GEjOvkmC
         EBFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757411844; x=1758016644;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RAE17ZYZWlIDCZkrsAY+6DPY1arC89Zp2iFLktMJp94=;
        b=xUySl8aJAEVDnEVG8FDEeKMgkElVAXUaLGsMe+jQTIVQx9YpZqIFTnrtZiFcpAFwUK
         JMYbFynTEY1PqZVRwjUpOJCQdYBpMTyzC1xOshALRR9wKW4Ie6dlsofa5oL8+QWig6Nz
         n3ipUUwwl6e5nTUYZDhJGIeIWijY0y3AqFm7VKcEs47cs48EaqQC+zCql2u1ZNsFIROe
         y45D6orJFh0Ade4ixgEA8gyMZX40HjYhhUSvPNOq6Ro1arK56r+fMzxVoIhtr4D92Ekz
         CxppFfU+nOz4+J7maDe3OyaSmh074IdF7t8RZHifYzRiMUP/fAifgTdJQ/3ckbbGNL1f
         6hew==
X-Forwarded-Encrypted: i=1; AJvYcCUCuTi+5VsQxFGeYvn+e6h4h+4cdGmvlTcTCj3W89Orud2pUzncCtGLI1H/LrWrH958CnWmGA8aa2FIdQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwhFCLSBNOTthxYqjJz1X1bl6GhAyj/W2sgc/hecw8e66YwvCIE
	QSO75fw0UCMdAs4Ju7P21m9so7SLUyFYGSbUbxsiaTX0cVS7Xs9OR9kWBu0ZGeH+k25qXOhcYHk
	CmlyUy66/blT8jrnwHjE6zEc2P0gXYFA=
X-Gm-Gg: ASbGncslPDMvzQkavHY4B80HY1nmjdt5ZHBsBjdDk+Mac3bKsgxkrYT4UpcAAwC5wox
	B1ZK30HYxsVM/GqGlA5pu/An/qmt39at1wx9mf1KNA4qN9Yy6Y7GQKPhd/kopzZQYzhLyN+YISz
	Vyy6GIo1Z0gtazrtArwxkpXKZW2r3vp+MJxtTew18aX+oozSyC2BVQPNU2YSj+kdxsFYC48NVoN
	GeryeQ=
X-Google-Smtp-Source: AGHT+IFf/ZoRT5HaF6kxr9rOT2RZ/8rZlOcLf23MX89bg8+alXq2taVr5i1vpDSwq2raUZjmK7nkmcK3Ji+N/jYHCSo=
X-Received: by 2002:a05:6402:2794:b0:62b:2f0:974f with SMTP id
 4fb4d7f45d1cf-62b02f09bebmr3813819a12.15.1757411843927; Tue, 09 Sep 2025
 02:57:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <766vdz3ecpm7hv4sp5r3uu4ezggm532ng7fdklb2nrupz6minz@qcws3ufabnjp>
 <20250904154245.644875-1-mjguzik@gmail.com> <f3671198-5231-41cf-b0bc-d1280992947a@oracle.com>
 <CAGudoHHT=P_UyZZpx5tBRHPE+irh1b7PxFXZAHjdHNLcEWOxAQ@mail.gmail.com>
 <8ddcaa59-0cf0-4b7c-a121-924105f7f5a6@linux.alibaba.com> <rvavp2omizs6e3qf6xpjpycf6norhfhnkrle4fq4632atgar5v@dghmwbctf2mm>
 <f9014fdb-95c8-4faa-8c42-c1ceea49cbd9@linux.alibaba.com> <fureginotssirocugn3aznor4vhbpadhwy7fhaxzeullhrzp7y@bg5gzdv6mrif>
 <CAGudoHGui53Ryz1zunmd=G=Rr9cZOsWPFW7+GGBmxN4U_BNE4A@mail.gmail.com>
 <tmovxjz7ouxzj5r2evjjpiujqeod3e22dtlriqqlgqwy4rnoxd@eppnh4jf72dq> <CAGudoHHNhf2epYMLwmna3WVvbMuiHFmPX+ByVbt8Qf3Dm4QZeg@mail.gmail.com>
In-Reply-To: <CAGudoHHNhf2epYMLwmna3WVvbMuiHFmPX+ByVbt8Qf3Dm4QZeg@mail.gmail.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Tue, 9 Sep 2025 11:57:11 +0200
X-Gm-Features: AS18NWDvNMnekQfsZG-s3JBWxVpGxDm3JdJDNsFjC1VMfTBR1aZ0-dcOy76lqUQ
Message-ID: <CAGudoHEBDA1XKu8WTPQ4Nn+GTUWg_FMUavcAddBQ=5doY1aQxw@mail.gmail.com>
Subject: Re: [External] : [PATCH] ocfs2: retire ocfs2_drop_inode() and
 I_WILL_FREE usage
To: Jan Kara <jack@suse.cz>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, Mark Tinguely <mark.tinguely@oracle.com>, 
	ocfs2-devel@lists.linux.dev, viro@zeniv.linux.org.uk, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	josef@toxicpanda.com, jlbec@evilplan.org, mark@fasheh.com, brauner@kernel.org, 
	willy@infradead.org, david@fromorbit.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 9, 2025 at 11:52=E2=80=AFAM Mateusz Guzik <mjguzik@gmail.com> w=
rote:
>
> On Tue, Sep 9, 2025 at 11:51=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
> >
> > On Mon 08-09-25 17:39:22, Mateusz Guzik wrote:
> > > I think generic_delete_inode is a really bad name for what the routin=
e
> > > is doing and it perhaps contributes to the confusion in the thread.
> > >
> > > Perhaps it could be renamed to inode_op_stub_always_drop or similar? =
I
> > > don't for specifics, apart from explicitly stating that the return
> > > value is to drop and bonus points for a prefix showing this is an
> > > inode thing.
> >
> > I think inode_always_drop() would be fine...
>
> sgtm. unfortunately there are quite a few consumers, so I don't know
> if this is worth the churn and consequently I'm not going for it.
>
> But should you feel inclined... ;-)

Actually got one better: inode_just_drop(), so that it is clear this
is not doing anything else.

Perhaps something to do after the dust settles.
--=20
Mateusz Guzik <mjguzik gmail.com>
