Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D77D2FF641
	for <ocfs2-devel@lists.linux.dev>; Thu, 29 Jan 2026 00:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769648352; cv=pass; b=MY6nmopqxHp0XNL9DZ6zESqlctW5EnGq/e4CxAqHeF2dzWBT8YcMK3XoBRU/FtYSnM02sJyESVmMraN0JltpmDA49dPJeNWxeuOPiK7pM+f8FZlY8Oa0BHchZktp8/jVslbIwG+CtfPO40enAw7dqWWd12QnmOG0KVLmM9wtGmI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769648352; c=relaxed/simple;
	bh=+L+EqsxFGbq9nKKnaprPm9Ir3tOy0vr3+xqa2zLh1T0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gi0/QvzcPDJxyoO7qcyEMmqTC3AfGE37qsQmYQ5Z8xC/rp1gFoeb9IKOH/KLa3H2u0tuugMUVddRKss8SZuqJ+P3r0IyjV6eHuuK2L2Vq0dJp0DHhw4qkTybff2nRb9bOT+4qRZ0UZwkHmRBb2Q8X4H3m2QcpyJnzXt0MvuTFdc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YgILYiiS; arc=pass smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YgILYiiS"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b86ed375d37so62490366b.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 28 Jan 2026 16:59:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769648348; cv=none;
        d=google.com; s=arc-20240605;
        b=cTuZwUfvqku5LSv8WMYhUrBccrvMrpR1TOntzZOBaQpV6RFjxPLUpPHRy9jPsAz+V5
         Jj0cSwtMoZkRIqRQUx5Ygl+9gtYtX01h0Sy+xa+HAZ75Q37asFyEu4SG/jwdd5Dxmn+U
         zjwDxgmXJhDcSPy+0V6UL83kT5yU+z1mWH4f06VP1JPDJ/RWzeonr7lev8qUr0mnWJJh
         1lXWFQIQZQTf11m24gGmJj3f8UKl3qWQJ0E3eUBdOnTmDhVEZHZVLNfBrgbWXhNrjnUW
         xofllPHRoqr1jjuR1MyrHYqZinCfVN4t8UG3gpBSpxNDJMuMuD3FYo+k8Vnmktb4w/Fw
         NZNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ho5qTXSu2PZYffnzQVL+2Xc6poCFB6UxCVa5s6rbRlA=;
        fh=BIyzN89ZkpIMe2jqHCYUevtWXIyLFFNnU20MsaKS2qU=;
        b=aMawQFW7byhrBALwrUWt2t1e/TKGJb6umOL3Q6O+LYmxX9gaXiGnBsJdPUrulQj/5t
         qfxyEBqSk85OM+CVffznbUbOHcw6aWM0ETZApUNaSQytddX425KglWV+9tZd6ns1xJfe
         WHNQo6k43h3rAGrBup/v+PqFDBYNLm7F7VOg8CRkJ6PJ60oLvhOg4aPIZEeubZ8b6ys/
         Wf3d10GO2oMSCxz7UldvwO6aSW3gg5mBX/x6mfe2mD3EEFhT4g5ZTIRXQq4wTrINqpRI
         Zc/N2ktRIbJjD5Zy7ZWKuVywtfo1TrecQ+HVc04hs7Fp4DUdGTsNYpjboYEBjtgSD9MY
         Clcg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769648348; x=1770253148; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ho5qTXSu2PZYffnzQVL+2Xc6poCFB6UxCVa5s6rbRlA=;
        b=YgILYiiSE9l7DUfM3iAbxhKQCWSWqj7kc8XsK+Ktl3aE/yk9C+3yPu29Vtj1IGyTxt
         yncOu8v4WJH+kf/Lc5STTuces2o34D8onCP3gwhxjhGelykKV04FZcH1Fcuyfb2s/vE9
         pw1eNmJSLFMZmltL5QEXoVlToIPWZ1RBPeP0V0St9lOKnr99WFiYNA7oiNofJv4GdcD1
         33LgcC9w2VtxEaECe7PmqHZBkl/cZe7PaZRmAAZwC7hn4vDuQMhmwmPG6truvjP6hnef
         8DcVBzz2ou8Cf7Pb+popr4Y9bXx7fLfoMshgNpUBcLSBcRKZJqDx1FVeAnOZIYr/Ht9m
         GPiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769648348; x=1770253148;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ho5qTXSu2PZYffnzQVL+2Xc6poCFB6UxCVa5s6rbRlA=;
        b=n2lgHKl/K9efgVpUes5H7Go5xmaCAaErwZYLNP0d1rVf3eYfL9lMcQcnlOiJudcdKy
         fdEaldS1Kp1YZurnYMZ8j9Y5RrL7pq7SKxjqalYSa0l/xk0uLNCxTmO7T2nNSk1BtY+F
         Fky287DtLMqJa3m3BrtvXZoUQ/ENN6In7aL1z8c8Q1T697+loN2/zwlVb+blQ56az3wx
         Cpi2EChkIg3xZbmVmuPbQwWk2aug3PXS6cS3aaVP6uveROdBlTD2Ca9LFgDELxurK2HR
         k34X4ZqbOVqxhCv+GpPuGn6iGnpavYulQqcHbHgxTJlT44ZYydl4DhR5yrW30Q2tqbLn
         k70g==
X-Forwarded-Encrypted: i=1; AJvYcCUH5SMs8+NSNsm9enTGvybztTXvd10U8ncGq7VPCT4WroORn9A8ZdmjUB0PP2oiBK9YA/5nz3aJKaUeQA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzVa20GUirBzc+f0R3tXlVLiEglxhbvx0VQ2+KmGBXz40KwPOed
	XkfrhLmSOemwHTa67ZBJBLaq15ecf9h4CiV01kWFH+RCGIAiOanQa5hNKGL0i4Dfcidny+wLw1S
	nkgjTJROfpP8pUm62GLSH4/utdJXPuPSKWfpjXESM
X-Gm-Gg: AZuq6aI0+Uo2eWxRRs1hHUbtrYPk5dYcwDqhoyx5djGt/J0KpZj6nmHfdtVvUYwfG8U
	39Ae0YL7aoG2cnQDC424Zq/TEQl7w8N9Qsl5bkddPzU6rLYOp8+cMPOZRnAYzeqD8gN5qMnTqhH
	gEF9yFU9sWTz7l17dyAsRalQ9J/X4h1+4liS6SVPCBfK9+ONelg7xHVbPQxCl5oxRaOMgRyuSNg
	kAvpgW8biweU84pkCvRF+yfhSEpeRMRmQx3xJWbkpjvj5UEkEya0mH1X3FXwqV+5N2/dQR6nPnR
	Y3koJbZNz0jK8fRoMsn0EzuipRcTmg==
X-Received: by 2002:a17:906:f585:b0:b87:d722:f824 with SMTP id
 a640c23a62f3a-b8dab3cf66amr455166566b.63.1769648348337; Wed, 28 Jan 2026
 16:59:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
 <CAG2KctrjSP+XyBiOB7hGA2DWtdpg3diRHpQLKGsVYxExuTZazA@mail.gmail.com>
 <2026012715-mantra-pope-9431@gregkh> <CAG2Kctoo=xiVdhRZnLaoePuu2cuQXMCdj2q6L-iTnb8K1RMHkw@mail.gmail.com>
 <20260128045954.GS3183987@ZenIV>
In-Reply-To: <20260128045954.GS3183987@ZenIV>
From: Samuel Wu <wusamuel@google.com>
Date: Wed, 28 Jan 2026 16:58:57 -0800
X-Gm-Features: AZwV_Qg5mDXEWLmzjtDFHSng8MB2HQLUBKHQ6Wr860X_lRTmL3Z_ZmvOjLnN07o
Message-ID: <CAG2KctqWy-gnB4o6FAv3kv6+P2YwqeWMBu7bmHZ=Acq+4vVZ3g@mail.gmail.com>
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

On Tue, Jan 27, 2026 at 8:58=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> w=
rote:

> Very interesting...  Does 1544775687f0 (parent of e5bf5ee26663)
> demonstrate that behaviour?

Reverting only 1544775687f0 (functionfs: need to cancel ->reset_work
in ->kill_sb()) does not fix the issue. With 6.19-rc7 as baseline, the
simplest working recipe at the moment is with 6ca67378d0e7,
c7747fafaba0, and e5bf5ee26663 reverted.
