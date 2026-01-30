Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8C838A29C
	for <ocfs2-devel@lists.linux.dev>; Fri, 30 Jan 2026 22:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769812330; cv=pass; b=jADNGLPWsEq6TU9uvyBO9M+Iiw6x+G++yjzFCuJjprdhWHwlI1DD4c8EDP3/7nk8VQdq+8mUC8JZK1V3R2LGVAoIp6oBlm36RIo+N8smhyHiI96tBvMuvqM8Dau8IPat+g4Xo+pgpdRzo4uctnafl7kLmFGITBgDm3a7YS6sI3c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769812330; c=relaxed/simple;
	bh=1L9Z4WjLTMd/nETiB4o0uKotvQN4Rh7dUtNkmBInouo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TC5lYGwERIc4Z4U+oxKDFKWxc5k7ah3jPfSU8dj/0clB1aNbPaDoNXkdArN8wtDmEKPiSt6gt1ybnDMiFuibpXEbLMT+R1xOV5sdPHd9C7o0jS6aWFzzpdSrOLcUFOVWB+UOjHP7XSfjMoY8YdgrmmZ+x72nSHeYNXcW8WN5tSA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qh0p65Q5; arc=pass smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qh0p65Q5"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b884a84e622so403504366b.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 30 Jan 2026 14:32:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769812326; cv=none;
        d=google.com; s=arc-20240605;
        b=bh3Re3vIJK7UonNqiMv2ggpl8XRuWJC8UEnJ9+5hf5fHDSTAC9hnWBRgegfW/sLsUw
         i+Wc2T+UwikaqNUdPlepjbRXgeTgrCfXuGOo8p6nbaDY+/838DTeVNy6HF6bjTe0SM1t
         jvnxrHmVwSU4hKTc5XbLE73ZMyWG4/32pSxcVzrt7tec4WkollR9X+2wBOVOEvJiJtFZ
         O14gHPFEEjyX37sbaZTfyf9h1tci0C5TS5ufnm3lh2fuEy/rWHLVpsGlGpuOoass8Iy+
         D8XmHU8Pb7GEAZcsyF7D7cHEqOE0q8x+rxtmAg6KdWM7zp+u0w8qScSeYKSU1rLa75gx
         /QWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=V5nbc6oPm8LRFAHxRjfK4s+TrvKdniacoUK6JWeX1CM=;
        fh=k6e2yKOgTfheTy4d4J57btOnqa3pZ8HT8V8x51vDpG4=;
        b=VeTWC7u3FWy93hzXNC1smvx1jzmPIC4UFpySqwuLv+yFRx18/1CS7G6zlh1fHZy8gk
         nd9wJefSO37Nhd0SJiIiA8cbr4athYk9zS3vkI2394Gu803HpGNX+df+pQPzjX2XRC62
         4pPqqSs/Fm4cBaoFr9IdEC6k+3zsx89uPzaWVEVyMyCo4U6oleTKxSllcZXOfeYZKooB
         GaUgxNkbcK/Qc7Ezm59u5dqQLgYDtn3R1l7WP6BfPAxFFYjHM5llDVtviL8bxjI7xnI3
         Xkf+f88FDenZYkXfkY4wirczz13AMa9zMsHEmb6paTXcuiwFcO92ZzHxy/BXo7eXVgcq
         vlRA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769812326; x=1770417126; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V5nbc6oPm8LRFAHxRjfK4s+TrvKdniacoUK6JWeX1CM=;
        b=qh0p65Q5aLoGE1vE0xa/YAGDLx6tbvUWvf6RlywpVQfC2MJctpD/qlnXPMWAv2Z3bW
         jBWjf9xqeoBd588cMl8I4bofnk+7v1fXzm6ubc9Ja2wItGihE8gSxYF8WJoLTjUa1UY8
         Nycl/ZvwPuQMEEChs23Y+8aDB459mC3LHL12Szp7g85axNYN2b1QltHeFcVb2k/K/EjK
         GdH8zAKTC9MuE6UcA6QuCP0PC4A2qDIPd2wzse7rei5MJLex3GgCEACs4nVjeQcbVnHX
         jEmbAlWpcCWDz6nR9JCTmJleAJk+r4o8muKCCzhtPj7S/tY+qszIVA1Cj+S+aMdf6JYg
         XLTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769812326; x=1770417126;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V5nbc6oPm8LRFAHxRjfK4s+TrvKdniacoUK6JWeX1CM=;
        b=om3S9exT9IwdJBTuISDAT3Uhw/VtnXyiXYWe3bjYdC4uyAT95R7LgSJTRbjwgcMdzC
         tWnoHOBOAAiaLvcK7ebLLw/ClfHfhhWTpYpO5Ki/frgHsmLIxPkG0NW4ytiDi1bFXv8S
         A4JwHKmsBCvcmQsknF+tUvnybCSj9bEyyebUVgErzSYJ3YfYfcOPgbeUVBmkwAgqssKb
         5+Ps1AF4ZKFqTLcY0uxarlzVcitR1hOAmPYkTVdJCo4fpvAFVoZaUYF1DLnEYP1Jp6fV
         onv1Ld+iixHKmi3ENpW7L0+QY3YQ6Ivfd2BBQD8OIxOhbSQjS62K2nbq/0SjpevXc6Q/
         5tbQ==
X-Forwarded-Encrypted: i=1; AJvYcCWh7tquX79zXcR0DSCQ4vubJerG3M0c6QPyYWgNGAi4XE3ai3PMB3fx+qZ4/wiiS9G+m32Epcg/27VIZg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwuWMl7WDVPxnQMcvUs0Ez36JiyskI7q110H/vgvvXwMW8DVXoV
	0GmEYMoubpyLAJj/qqZfPyrYYDCDqouHMtk8enZ2PdNTbEzZsO6Xg6/dnHzS+ckDzBXObIXhOUy
	lQflXgDkYSb0ewrYl/xUV5MiMsgO85o1AB+jwpg4Q
X-Gm-Gg: AZuq6aIdkNNdGezlNGvEFhEynzO87UOa/EnvzyDID8ubmg4uOIOHuqwuF4AuyhYa3Vs
	YiZS4mr9cztW6qi7lPXCFxDF3MWvCgCFD2p8ucFQ9o+d7wdAk7ek5GGb+ioEf56gqqS5msYssyr
	b30AziYH3+XuwnAxJHqBdZQekvUKbAYyDF+PzKvxtfG6/8S6dC9lAhLcJhSa5+pnznErLMz3Gd6
	fGUB8fo66lVrJXp8SfXkfqk6wSMxTWHrYrXW5tmjuCn6SiCf/AKyQ0hQ+tq+U2KeZip
X-Received: by 2002:a17:907:e0d8:b0:b8e:14cc:9197 with SMTP id
 a640c23a62f3a-b8e14cca990mr91520566b.15.1769812325869; Fri, 30 Jan 2026
 14:32:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
 <CAG2KctrjSP+XyBiOB7hGA2DWtdpg3diRHpQLKGsVYxExuTZazA@mail.gmail.com>
 <2026012715-mantra-pope-9431@gregkh> <CAG2Kctoo=xiVdhRZnLaoePuu2cuQXMCdj2q6L-iTnb8K1RMHkw@mail.gmail.com>
 <20260128045954.GS3183987@ZenIV> <CAG2KctqWy-gnB4o6FAv3kv6+P2YwqeWMBu7bmHZ=Acq+4vVZ3g@mail.gmail.com>
 <20260129032335.GT3183987@ZenIV> <20260129225433.GU3183987@ZenIV>
 <CAG2KctoNjktJTQqBb7nGeazXe=ncpwjsc+Lm+JotcpaO3Sf9gw@mail.gmail.com> <20260130070424.GV3183987@ZenIV>
In-Reply-To: <20260130070424.GV3183987@ZenIV>
From: Samuel Wu <wusamuel@google.com>
Date: Fri, 30 Jan 2026 14:31:54 -0800
X-Gm-Features: AZwV_QjYrhpLENkXIfDxcZ9u-zvP7f57lE4mcVebqUxFVKgl6ULvCT7XG0RHQoc
Message-ID: <CAG2Kctoqja9R1bBzdEAV15_yt=sBGkcub6C2nGE6VHMJh13=FQ@mail.gmail.com>
Subject: Re: [PATCH v4 00/54] tree-in-dcache stuff
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-fsdevel@vger.kernel.org, 
	torvalds@linux-foundation.org, brauner@kernel.org, jack@suse.cz, 
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org, 
	linux-mm@kvack.org, linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	kees@kernel.org, rostedt@goodmis.org, linux-usb@vger.kernel.org, 
	paul@paul-moore.com, casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org, clm@meta.com, 
	android-kernel-team <android-kernel-team@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 29, 2026 at 11:02=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> =
wrote:
> OK.  Could you take a clone of mainline repository and in there run
> ; git fetch git://git.kernel.org:/pub/scm/linux/kernel/git/viro/vfs.git f=
or-wsamuel:for-wsamuel
> then
> ; git diff for-wsamuel e5bf5ee26663
> to verify that for-wsamuel is identical to tree you've seen breakage on
> ; git diff for-wsamuel-base 1544775687f0
> to verify that for-wsamuel-base is the tree where the breakage did not re=
produce
> Then bisect from for-wsamuel-base to for-wsamuel.
>
> Basically, that's the offending commit split into steps; let's try to fig=
ure
> out what causes the breakage with better resolution...

Confirming that bisect points to this patch: 09e88dc22ea2 (serialize
ffs_ep0_open() on ffs->mutex)
