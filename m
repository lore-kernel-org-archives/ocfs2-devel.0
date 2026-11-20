Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795185362;
	b=QN1bk76P7AhZodi32B5RG08QNcHneOVYyokg8gtPkwca80Wx/UghcPtcp7QqMR5z4gxz
	 2ffC47b8E/oNZ71kF4RhPMEEfBNBKssVKthE3hEhTJl7I3DF00RnNlCJISVpjR0Yznr1q
	 MMBjMm2hum+5BH4N5VOxlj9Rw7el3fRp+MGvocTKXorxvveneurkOLzXKI8dYxBwRKZJp
	 XDUt3nxoSWLM4tnBVQidTEs0+GxP3k90pUueI6LV/mJV5jaMkrc7qt0KgYsmrAkAky3bk
	 wuLFNzDK2SFF9OQirVBZhuqekYh11KjuGYCPCD4V650CbvNOzq5rfNqc8pez54ousbA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795185362;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=5uzUR4nNL6/gBE9a0npJTMPxychcKuNTT6IfVRtsMA4=;
	b=hfi0z7RBOL0actoowX7zhBYWmo37ww0umqFNKbRJI+nE6LUeaKl+ZtWe7VXXU9uiKr7B
	 vpfjeFGqd+FpuIHqWZSXihPvVImkWgsFO24kM3RciHtgdrvq6fCaoQ5pvT8rc73T/6YWq
	 rcVXojcgtqE9eIZJqoIJzORzt6LOik4ur3erMlk2m+I0aVj95Cc6hgDRfNALFvjRshZGF
	 3JF0n07F0eVwQIPtYqnSchrAyl0gOxJnz9IEvtU7iaqdtxIS7t7qPuNsCKGz4TDOyQCjA
	 iMOECMuazIbvrkV3ALXtEpJAO+yUsnlcs6jeNRJR3+oxFNMzuzJzOLXdXNN3Dl0bjdw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RBpe0D8c;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.53
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2A1606A331
	for <ocfs2-devel@lists.linux.dev>; Fri, 20 Nov 2026 14:36:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA2A1606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RBpe0D8c
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b894a5ce3dso1256237a12.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 20 Nov 2026 06:36:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795185360; cv=none;
        d=google.com; s=arc-20260327;
        b=N53/mCpNljnHr3XzlJHY4CuxPgy5s7SVtcJKKhumUFJnloa8ZHfx2bbDxvLacHJEcn
         hw7CcbdI+ozBSdO1ZdVYZFBJA9VyZUiC6wNwMKe6feHBQtnsv21DvxPPQF0lxQ1MwjyO
         /7QWMJ9ZkrbxCPEUhQLkdDUkfMViAcf2gHSnHC3xlijAb2JYnrF27RGfwhLS8YnN4mST
         xY/am8ajLTPgcb1yqIjSvGdah7GF53gSvqJVdPX8z2r0OuJ8vXBswiNZ6aQRTOObb766
         5O4QxWt3XDWGqAz/lNyBc3v2YyTQP9OaCvLnyluCnSEww7x/LNBRirEPLC3SAuYsHA0d
         Pc0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5uzUR4nNL6/gBE9a0npJTMPxychcKuNTT6IfVRtsMA4=;
        fh=G+dH94b1bStq8G629mEnnj0QH6jZCzIZ1phL8KKFuiQ=;
        b=k7dw9Ice6xGWdYuvltHgkdxDEBiVLq3z41KHghJrUcfickmzuTgFzyKgWvlM0cL8r4
         hDuT5CKhmllmbOTPEvYwYDNgREFg5aSPPUETpf2qe8thUeWUq2hpRlDhahCHGuGt41vN
         6VGWViWHT2JS2vcENZjLuQc2RcmbCNvw/w9X5KT2z4vOABpKArX01tnQ4/L5ujbJqDia
         5asJy5VnZzsqGaN+pkIKHhvmj3TMaWltwC6IvmCtzu7+V7CTXu28hTzUJVAs5gbdF4nJ
         9FGQS20dslgCWQBbjLGSvFBOvXrD70HePVB+tn5CFUkcIjgIwANEL3/Hmn8/XtRiySMC
         E0XQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795185360; x=1795790160; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5uzUR4nNL6/gBE9a0npJTMPxychcKuNTT6IfVRtsMA4=;
        b=RBpe0D8cs1jNtPdVi+y1CNmO2me839CDJchWkYVFnTY5da4ISnZtMc68NTYHTHh4vl
         s1R9TBxOLq+p1CNuNY92vpMnBOaUtXIeTubEueoN0QtbLfgfpDs36MtnnntffcZzSY6u
         3jZDdVL7AGszMl2w2uFQT+nkZptBKS6oXWOV5PUNdib5yGSomuQBI1J5enW0mnVXs7yp
         7ks4nQQYarvoDRYfvbRA6lpcGM15yP7liQrOY43a4qEA22Fhwm+fVcxZSJBLiNjiggOL
         C6+sTw7ZStDs3IjLsAdLaDeAC20tR1v6YALOYBtVDBV1PAkGR3yEAdYrTe5QhBfJkL22
         F5CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795185360; x=1795790160;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5uzUR4nNL6/gBE9a0npJTMPxychcKuNTT6IfVRtsMA4=;
        b=tYzRHsSb7nK6zQgWfhMD5EQsok6UKG3XL1v7OhBhMu+V9KXF+dEVOqCNDxyYMoiNvP
         eqlDwotRiO8bXjTrc27cU0wYdXZB6dprYDQ7M5QewCVvGsOFJ85uyDiStqMfO8lf6fyZ
         38eFBFisHUdXMecrHdf6n326vIBctD/MFmDIGIN5p5CdDZ4v8kgJGnQ5Ca/QmCT5xipt
         2qQUqT1wGLb6xjYJPKlrfh/x+rgdnT42i4LhiE1BGJyR3/baqSkiAWQLCqPz02vfEmVI
         8V38Qwo8aJiF6ulFvPizU03e7wAjYeVxhqlVoUg2HVaczXCokb6P0EOlkqjIdlyRMkjd
         SgtA==
X-Forwarded-Encrypted: i=1; AL+hErF2Z9b8AC5vQ2zqC/m6yqc65AcKmUD/5mjhMqAWfw5eBIkEEV9B68m4bUO2tlrLkFU1of2mlobmVAcAzQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z++U715+G+Uko6V2KRLfU89Qje2Wnftt3Z+67HaWTV3eV+qMXHB
	QtS2zoOS8ZVmpO7SGqzxLcoGyCr0ErIh5mcXfAYDxcbvass3Tdr+zqqZ3gC4otRfBnNihETMLJG
	RryR+FPFZrO2fLllcMQcjkEB1FXFjOxc=
X-Gm-Gg: AZFdTZeIScHtOGHocuuwEeVUdb0LRs4GOR1Yix1yH8B0CH5EOHsNqJXvDqvXp1CZ6+Y
	TO5/KR6LhuzJGRBpHIPV7ZvcC0VismV47XHTK7npeIDSQcr9hADl1A4ulMcLr+tIqJqxpRWhZk3
	pJm2WLcw1bXH2Bqq2rdFSZi0puVxoiJsbgmzhUva+C+ZkHOWCcviUHM/7RfXK2ugyDpbGfxhLS5
	otJxvkIA1zR3sn8NLaE3SHBLLfpYUgX/ZgxsOa9d4HS9hDNE+yDx8kVYdh3Hq5dUoWxHPUWznQ0
	rNWPg4UY4LYdXgQcSHkElmaxDJV5Mg4IMg/6HQ6ZJ1a4Tu3kcnJW1V+GyBvtmFQh6SLMUHtgZDm
	t1kki4O058ft7M6rOWKv6gKPlUvz3yFVhPYVDwgFXW/smkblKHnzO3GkvcQHojw42xUnnSw==
X-Received: by 2002:a05:6402:448e:b0:6b8:7769:ffea with SMTP id
 4fb4d7f45d1cf-6ba37ece3efmr2475801a12.45.1795185359456; Fri, 20 Nov 2026
 06:35:59 -0800 (PST)
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <av4Hn9u80fs8iHZ6@dread> <20261119095943.85048-1-lauri.gates@gmail.com>
 <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com> <CAOQ4uximow25oc=3XEN1ATgQvonQaTXtDPmQufxo75tJ=e355A@mail.gmail.com>
 <DMZJDGMJ1RVF.32ES391JKNFGP@gmail.com> <CAOQ4uxjVQ9cjV=_jBjQtNg9zCuWUEJT9KNYMKV+1jwBkHen5OA@mail.gmail.com>
 <DN03LWNSDYP5.11FTQ5KCWU2X7@gmail.com>
In-Reply-To: <DN03LWNSDYP5.11FTQ5KCWU2X7@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 20 Nov 2026 15:35:47 +0100
X-Gm-Features: Aa3M54oxXjJW5NIYEP5VP8q0nzSYgFKLfJAws7Wa7snJYDGBmmJmUUUXbQQ7PSo
Message-ID: <CAOQ4uxg0oq7VjhSQ0h8dBucdPfON2Q6tJQQqUy05sCaE10QRoQ@mail.gmail.com>
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF buffer lock
To: koraynilay <koray.fra@gmail.com>
Cc: Lauri Gates <lauri.gates@gmail.com>, Dave Chinner <dgc@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, Christian Brauner <christian@brauner.io>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, linux-nfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, Theodore Tso <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 3:12=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
> > With non-zero xflags_mask, internal contact masks
> > can be used for -EINVAL not for silent ignoring.
>
> What do you mean by "internal contact masks"?
>

I mean that users do file_setattr() with a bunch of flags
some of them are just ignored randomly without any any way
for user to know about it, because this logic is some internal kernel const=
ant,
which cannot and should not be documented in the API.

Thanks,
Amir.
