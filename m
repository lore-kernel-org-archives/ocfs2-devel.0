Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10B32D23A4
	for <ocfs2-devel@lists.linux.dev>; Tue,  9 Sep 2025 09:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757411598; cv=none; b=NlWRnxR8PnjaKTeqijmYW9UgDCciGmslEFeoKwj49UzrWSIkx+Nkh9WuZvxmryQu92BExgO8VqOysuGvbOkCtSKPSR0NYEPXWH43rpUWMY9vAVZ6k/8EhmbhqxmL+Y6egh5v1c8RWmNpT71NkSj96I4gDgYfXXgkFjzHe6znvvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757411598; c=relaxed/simple;
	bh=fMLxq6TiucmvR7bYhmILcv7h/Uv9JsbdS4EC9Fmg0gY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uzBt1p5WNh/C1mc56M3Y0gIMO+C+4MU5hcxAy5lKegbtHGwBQesaZrCKjUMKlTOMT4HjU9TpIHEaNsVeORw+0MV47qet/8lJCibYgCwCb1kLxGPqEP0EXZpJwEC6lJJzYBLJXx/alWFWuQWjKckaQxSCJP1kBD3L5i6Ngu8SYdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cqnn+bzM; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cqnn+bzM"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b042eb09948so1046657366b.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 09 Sep 2025 02:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757411593; x=1758016393; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fMLxq6TiucmvR7bYhmILcv7h/Uv9JsbdS4EC9Fmg0gY=;
        b=Cqnn+bzM0ysCkWBdDaAfa6i//b2P19UwDD0LSGt0G0JVjSeVNKwZxaiFSEq9JspT0a
         7SIvV0p/RE2GEk8B+tVck1i1Osl14rnIj1BuA2vmluynpw2ZUXyjyxkPRluKWrbxqjAh
         hHn9B35r5eqCO80sGTYrSBMkFW84oLtm5oIKlx4sZWXTP4/l6Sd5eZAwqO0K94aa2vVp
         2m0Axq+cCL92gacJuIzO0pWLXyiYqkPeiZiNXLjNBMuAHrkwLHXTbVioK7zU7vWgIyN+
         C0Ih9rVlodXA7VM0xnivKxSM5elgVv6L4Fhvszp2HnCl0NkTSa4xBHCA3NiH1APxXOpe
         3kAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757411593; x=1758016393;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fMLxq6TiucmvR7bYhmILcv7h/Uv9JsbdS4EC9Fmg0gY=;
        b=ii2fW9TY6KZkSEnICQ6FUlhe+EHlKZj5ZBGIfyXCih/UH8ifGvu8Fj6uB4P5I6ELqT
         FvQpdJzisL3oLlKjNfNE3ATVH7ZGMOjLVNFVO1OXnR3Kh1N/qLcT4WE0Bl+vhgq2P65P
         gzff80UpVhr7E9anu6yZ6t9v6DHUqqxyguPFhFI21MExRzlBymr6S/uJiQ6s9vObZoJY
         9Z/mbD/ClK4L1gutCf0YUClZ3fxxqZoNTPqVb8Cra9+QjAPdrbEyfxx5LiEWMSuUEyey
         PhJM1a/IUKuSFyxLXwqu4x9NUbKhTcsYSXYtIsZ6OaRpZicZ1advWCgrcEfVZx7LIAnk
         MWoQ==
X-Forwarded-Encrypted: i=1; AJvYcCUfPl3/E7OWjrgaqygb7d2GlF74AuaY2AQ/rhPsjR+jih64C0Nc8AERLWPfXYSII50EPX0WajrmhvgwOg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxlw1V2c9VH20mMsQvQdFo7xcIK6k6dxNihD4/fZUmb63tir7aw
	pCk6dza6xK0kc+EQH2FUayHGX8ixAncHWokltTNtYbn6LXsAMFWZ9zSRo9X+ifMNpy1UGiVP3Qr
	JVAvsUHNS6cWWZ/Ikiqk0jugNvZVSmAc=
X-Gm-Gg: ASbGncuAJC4P2/ghAfq70Cx5zZHxHRW4vIIfs1viHzkgG6UPeTymJFLsLXwqYDKEw7M
	72NWC3PobTXwWuq8NfB/PL5oqcaSQSIneuRIkv8Ejs0k4A8Io1rqHqh1GUw6Y0Xo/vnXyFCh313
	1/MkrPm69E3hMlqYiDXAJb2QMxUs3zHagpMOgHJUqFMOjerxkcx0Zbl10J9KHAmwernSVCghapD
	rt4VgFGsov/Z3X/CQ==
X-Google-Smtp-Source: AGHT+IE5lbqVo6j80scniqpSUIcsKgunf5VRTh8IsKCrX6AXDUK5P5Dj58UVpkT6jLLAC0fHmgDiA+ax2oWOoXko3OE=
X-Received: by 2002:a17:907:3e20:b0:b04:8955:ec71 with SMTP id
 a640c23a62f3a-b04b14abdd1mr1040581066b.23.1757411592835; Tue, 09 Sep 2025
 02:53:12 -0700 (PDT)
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
 <CAGudoHGui53Ryz1zunmd=G=Rr9cZOsWPFW7+GGBmxN4U_BNE4A@mail.gmail.com> <tmovxjz7ouxzj5r2evjjpiujqeod3e22dtlriqqlgqwy4rnoxd@eppnh4jf72dq>
In-Reply-To: <tmovxjz7ouxzj5r2evjjpiujqeod3e22dtlriqqlgqwy4rnoxd@eppnh4jf72dq>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Tue, 9 Sep 2025 11:52:59 +0200
X-Gm-Features: AS18NWDFJ_osJRVbnAUraWGjWXB7TrxUdlg8pq3rQrOexAxnp7yjh67liY3VHfc
Message-ID: <CAGudoHHNhf2epYMLwmna3WVvbMuiHFmPX+ByVbt8Qf3Dm4QZeg@mail.gmail.com>
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

On Tue, Sep 9, 2025 at 11:51=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> On Mon 08-09-25 17:39:22, Mateusz Guzik wrote:
> > I think generic_delete_inode is a really bad name for what the routine
> > is doing and it perhaps contributes to the confusion in the thread.
> >
> > Perhaps it could be renamed to inode_op_stub_always_drop or similar? I
> > don't for specifics, apart from explicitly stating that the return
> > value is to drop and bonus points for a prefix showing this is an
> > inode thing.
>
> I think inode_always_drop() would be fine...

sgtm. unfortunately there are quite a few consumers, so I don't know
if this is worth the churn and consequently I'm not going for it.

But should you feel inclined... ;-)
--=20
Mateusz Guzik <mjguzik gmail.com>
