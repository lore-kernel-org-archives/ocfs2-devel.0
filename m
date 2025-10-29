Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB7E1DDC28
	for <ocfs2-devel@lists.linux.dev>; Wed, 29 Oct 2025 00:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761696644; cv=none; b=GYpe4qcKVxU81eM+b+wFRwI6wkkZ0kA3x8o/CN7VV9ZPKvDx+hZmxxzKb05fc70mC9cxmuiZPWdjyR4yGW1h5Ke/p4MsTpeNH2DdQZnxPEVoJAdbjgaZm5h0Fd6cOOAUlYPlzjPD6r7Hv0XziLKy5Ucb30F/HJn/00yW7Y6jv24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761696644; c=relaxed/simple;
	bh=QloRiWksfwupmAUdBgNLV/svbMoFmzJRlSMrdXPaxnQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QyT/7SHJV04G2G87wbYgDbF3XaMTR+sPIP6koTuT4WLz6IrU5Dhcg5R5eKs+xHb/4zREL+ncvDGic/WDvzGF+6u49Ng2azr6LX6PE88qaY7PuHyRoQxs1rL2PBzaVKLZ+l2NUrOM12KsRpGpHMsbJPNoJFDh9GX3cDL9x8uVDJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=RLDQNkPK; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="RLDQNkPK"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-32ec291a325so5118049a91.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 28 Oct 2025 17:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1761696642; x=1762301442; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OAeYT3sIf5J+urxpWRZdGCYWbbcmjWbjfXki2vhXqBo=;
        b=RLDQNkPKPsuwGaSOl7M4UFlcWfd9TsjWWwIB9Ayet95eoD3OQn9lBIpnjmpAF2gTJ4
         6GZqP+lcfS6K3Z4rSYErXVd1HkaZbrtcLT5t7At52Gp3hhU1ihaEfQr33L/zeKYEmpUE
         NfT7o3+mXJsL1qzQppyZomrN0TSDmHE0cABbC44KhKtmsQwoSAjwyUZm7NtY5kceOAPT
         dybFsZPwla9U+j7JAwfy9CTlz37wuUI6SnFPlluOZxqGlGHiuoVzeC6eI/npPAa03Ejj
         +JUvub9ik9Z7a1ld77tdUb3J2rsKo+002o5yCktuoELiTlraLD/5uNUKM9pgKJQe57ZK
         QqlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761696642; x=1762301442;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OAeYT3sIf5J+urxpWRZdGCYWbbcmjWbjfXki2vhXqBo=;
        b=anX2rLjVu7il8Hj3D6iyd6g2xSXeA655emKzgY3dkJ2LY/vWOIgtU64n28dfc8k2iK
         4nsywNAceJk5lgSc472tAC3xn+dOmSH5G6ezzna0REKFOPALxq79p8SH3N3B8TAdxKx1
         o7SIrPwDCaF0ZViNBiJEqsmxC4z+kpPJ9FxtAwlfsVY2zpXlCb7RlaNxxL02gKJUBJFM
         0zR6X/KXlCHYkW9iSlMJr4JLBeYAJbysZGa126mMlU5giuRroQSoFPRsw0X0eltLvKsu
         5R0UNbR9w2iXGfmPar2ED4JfvGG3KYAnoCJzvfY5qWzqh3X8NkmDeMBbpNLZlTr4x9tf
         oLug==
X-Forwarded-Encrypted: i=1; AJvYcCXIXuwPn3SJ40fP4kZBypuXiUdDgeycdCIfLpGXrFtyFZNWu0E5GoH6aocztzOuxLDE+aHEWcSpczW+MQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyDXIV5AOCY2PlxChlN6c9ntKSH1e94EGlNTxHDqMhmy13v1pSA
	Ih9HUsG4z/bANt5dwaGvfZsMmy834gwY4a5HRr1lxRyGP33TX2Xk9Y6D60W+ZpZ4Ru8sfmuJcIZ
	OsfvmQPsmp2y6jp18bQBjjXHtLgZaNqiJiRQcZzaC
X-Gm-Gg: ASbGnct+RGe4tDWvOqcGxxL1lhK+Vd+lggZCmrfrdzw9yMX7PSIXoLHfb6SHISYkBiD
	fYqJ1wc1EMjhRC20SH+6PxpQ+xcvMJpb8qiqf+1fWk1Ph8r7jzw5Q1jsX/mv6aUkKlCM4wPr8k1
	gVBgORtWXrzDxnY+73tvktSJgQLQFaXvaSubF3hTgpj04w4JYFGil4kjEODihM37cgH3gZYdQit
	20PhQxhi4LdFwUxawGvTUysahX7R8P1GqdtGz2FEN+NPqX76gLk3wnYMubp
X-Google-Smtp-Source: AGHT+IGhjs8q4GiygXwr6DCqhQXMqWhNs5oaPfnq5KAn4id0agHe+xmdqRLWlZPNOFZ/N+dUgAnaM8QQHq+RXzkh3rE=
X-Received: by 2002:a17:90b:4c8c:b0:32e:d600:4fdb with SMTP id
 98e67ed59e1d1-3403a2a1014mr987268a91.18.1761696641654; Tue, 28 Oct 2025
 17:10:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk> <20251028004614.393374-49-viro@zeniv.linux.org.uk>
In-Reply-To: <20251028004614.393374-49-viro@zeniv.linux.org.uk>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 28 Oct 2025 20:10:29 -0400
X-Gm-Features: AWmQ_bnyVa46lrJnSEC4p7b8a6-fhgKBPo6xvMl8XVNnPJL6uMjYjs2dxSO45Ps
Message-ID: <CAHC9VhRX6kqFbbKuOoKOLLve6c+7TN3=fXHrtXyj=osfNYd+2A@mail.gmail.com>
Subject: Re: [PATCH v2 48/50] convert securityfs
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
> securityfs uses simple_recursive_removal(), but does not bother to mark
> dentries persistent.  This is the only place where it still happens; get
> rid of that irregularity.
>
> * use simple_{start,done}_creating() and d_make_persitent(); kill_litter_=
super()
> use was already gone, since we empty the filesystem instance before it ge=
ts
> shut down.
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  security/inode.c | 33 ++++++++++++---------------------
>  1 file changed, 12 insertions(+), 21 deletions(-)

Much cleaner now.

Acked-by: Paul Moore <paul@paul-moore.com>

--=20
paul-moore.com
