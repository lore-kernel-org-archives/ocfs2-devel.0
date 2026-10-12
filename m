Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776CB31354F
	for <ocfs2-devel@lists.linux.dev>; Mon, 12 Oct 2026 12:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791806515; cv=pass; b=LmrDLzrdDG4Vgm7qwOT/J+xRreHECKZazow8MBd+j+pf587EArLpCWsqkqzsYeXA+Z692DLIkaKYeS2UQWxsmwZsHFiJw1FKFH48S/IPiPZjsIPaBLA7iTtfRxNEO7BgY7+jiWt8AHBve+I1VrE+mm0jW6RzXZ/cfQNpOFDK3pg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791806515; c=relaxed/simple;
	bh=gV5B2sBpBlIQzBgTg+Qlc96+XsC83/hddevESU1nvNg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nKm/CXjEGkMjdmnXHRAV7ZiWDIEgY+oetro5F/669vUvnUpr4M2heei/57q5HxD7XuVD7dOtQrAANXTKM1EKL/CRPR0ts3YWV0tYYtK653zj+p/jl7crSBpXDPiJIJ9plrmqvP4ax6WdwMxUzF42IxZJS4M49pJmUYv+kN51HC0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aUQGuWCu; arc=pass smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aUQGuWCu"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-8ac9d666d4eso11298487b3.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 12 Oct 2026 05:01:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791806513; cv=none;
        d=google.com; s=arc-20260327;
        b=prjjivOh5wCvJBmI3UjwsMb+uGwsznTBAbbNDGnclAGnq/hJ+90mmNHn4NbWVtVmjo
         qs4apgDrAE+Reck0pgJHeX5xL1S0pwuU9SZRg+oiIPPT6WtT0xBZNJ2wyxssCOmhQAK+
         nSUkEDvOr5fkBj26Y4CnAWDhZQwKQ04dY4iiwn2qYMoBNz/4PuA92DPJ26xsWoFV7SAU
         /1LI4vqD57WA81tu26WEYgva9+EW5JSnw/9CCUUfUX1pC7UE9rsiOAH2ism6ZUjWEX3H
         O3Df+1IBzGRmdyujWOgUw1hVszi+ZiGuHnlQNWjt/EzvSHZN2O9Efe0RkHeSlk16uGOs
         z5xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gV5B2sBpBlIQzBgTg+Qlc96+XsC83/hddevESU1nvNg=;
        fh=wNF1LoRgP6DCGT6Rwe5nPOP8EjSCalS/txi9O6Ei5o4=;
        b=Jcyrmt4/vzfJDFG3kZwyilnkgyXZHNMBHND0/uH3nlOCXOP+IcmaS2EJZRchg2qflp
         POsbaEYQgMnmxMg2zfHpQJpYVLHMd88TKli2r01rtNeGgSylv0ItBg6Yj7zyTJE4BQe2
         2FiHRq63Y4rWmxCBBoq+o5vqGM18lGgi3FRU52SMVh94c4jnd1xJgyVzM00YvJc5aHU7
         IrZpD8ErvPYeC2p2RZ7mDDWtwt4hfQnalFMmU64N8rIMTGTBqslGGInPBC2xU02m9Owz
         BKNTiAHlGKKVlU9NU1ot8oPX8ZEAE+M2GSCAqsmYdR9w25Is1MaDAnq0PQ5QRC/kXb4v
         DM9w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791806513; x=1792411313; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gV5B2sBpBlIQzBgTg+Qlc96+XsC83/hddevESU1nvNg=;
        b=aUQGuWCuwWOa9YM2Ek08SXafQB+WWN8QrSJ0ZkmrEiazf0jg3+NscO0uEZZ88oSjsJ
         jJvcoCGAqDiLhKaTehhnto+4IDrui2ij2yz4+Jy2lnO2dliLxv/pPZFHwEfg34bjjhJr
         pARgIGQanwwGKb5Xzyp1/mjGDlLtgtlvfe+gF/S8oBO8F77gOko/+suJvehJtiL9q7b+
         2IAx+GlqZNE+SDQH4N9p5eYa3Kieo+jVZgIAScnD6SOaxXS/igIpz9c+rLH2w/jIQDSH
         Fys+Kq8rW2HzY5Q+uvyD7ex+wVFxbippQBv/Na0nQ2J/DLieKkNIGR963TgdfR2bI3P3
         xrYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791806513; x=1792411313;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gV5B2sBpBlIQzBgTg+Qlc96+XsC83/hddevESU1nvNg=;
        b=W2PDopGRLWuq1v0gIdI/QsZdQ1kBa4lZ6BL3Ac3pLAsBRr5ywuBihqdx3hsvPT8Oub
         dNYa98fljlX3z9Fxm37ri52D3wKMbxCDV24uvYnMiwlAPZNsHCoLyy5y/3OT5E0sloeL
         knox3xszOZvASLxVyDMYrnsy017YpzfTz4Cm54eyOcjf+5zWZeHM2RRFdLlpDFQJ6Suj
         vsOTdArwAHFYAzUBmvsv7y9iS5+zQ/hZTinm8oN1zYBf2UZl4ZlbZoTOosdH9k/eqnTr
         uBxDrUywTmNalcfGT3tI3LbMCGDE2v2ZQZmaSOLi0Jb6P/UkU6PFif5d0779AcCfIq/a
         JKFg==
X-Forwarded-Encrypted: i=1; AKwUvBzLWtlk3CoqmuK/VrjjXCNx9KHA7OxZU2VwiNd1A8/hzEtxE7lipMcjXwv8Sq9Kmfg+gRO6TZMUfonrpA==@lists.linux.dev
X-Gm-Message-State: AFq9FYJnUza3Cv0lzU0Vz0pv10ZBn3aZc7vla5ooWRNBSISuU65yXEKN
	gVZ96XSfeR0aMUSayPcJueIarbxflH730lo3izIIZgtWuUa9QytDFjc2f+t8gTyBCF1XQUyBemv
	x93mvzlu1cVHia3k4DItHCWVI2F3PL0o=
X-Gm-Gg: AYBFou3NGUF0K71W/34vH5W+wlZIV6xigNAabsxMuei66zEQ7oytqF5gylYadQcfA65
	PvvxPXJr8Mx3SEbHmVi0kO6X3ikUSStw7MYs5W4Oe5v7tUbNoveenfG0lNiWNXuiKoxzO+xhgf2
	cdYXB0+HkGjU9L9gL2n4W5ykDYbwj8swBXVO2neHRvP14aDC89DsENJR3Wqw1DvT4BrsEHWPcKl
	0/CmAe6n4IFTgJbNr2xVINUlhgaq6mPs0asxdnQFVlsyBnlYuOKHvDC4mM+EwoGsa8XOD3eQgKi
	OFEj1cniARLXCVoR457koUiKdrMpSgWy12sQESr0wYSQhnB5gSSVk/Ibaw==
X-Received: by 2002:a05:690c:6d84:b0:8a9:693a:324 with SMTP id
 00721157ae682-8b07eebe1a9mr27465947b3.109.1791806513335; Mon, 12 Oct 2026
 05:01:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <pm-ocfs2-objects-candidate-0089-v2-4c67f48d4e2d0fc85990@gmail.com>
 <asx3pAlqeVkKNRfB@p15>
In-Reply-To: <asx3pAlqeVkKNRfB@p15>
From: Cen Zhang <zzzccc427@gmail.com>
Date: Mon, 12 Oct 2026 20:01:42 +0800
X-Gm-Features: AclHuK9MLaOJLQyfdx9u13-P_RgbYiln9n7RlXoxbs8O1PYqa5uw7ofXstfpRSA
Message-ID: <CAFRLqsXYWo9+ZkdK6xE6Pp1KCanPXmvd-A6-us_NsDmcsCnU4A@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: Pin the node manager module for open debugfs files
To: Heming Zhao <heming.zhao@suse.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	akpm@linux-foundation.org, kmehltretter@gmail.com, ericterminal@gmail.com, 
	kees@kernel.org, sunil.mushran@oracle.com, christophe.jaillet@wanadoo.fr, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com, jjzuming@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Heming,

>
> Thanks for spotting this. I applied the same test to
> /sys/kernel/debug/ocfs2/<id>/fs_state and confirmed the same issue.
> It looks like all debugfs ops in ocfs2 are missing .owner.
> Would you have time to check and fix them?
>
> Thanks,
> Heming
>

Thank you for the reviewing.

I=E2=80=99ll go through the rest of them, add the missing .owner =3D THIS_M=
ODULE
where needed.

Best regards,
Cen Zhang
