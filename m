Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002C2B640
	for <ocfs2-devel@lists.linux.dev>; Wed, 29 Oct 2025 00:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761696299; cv=none; b=hdKtDXkS+3SRozmtAxOm+81jRgDtoB/Q6zNAPZHsnOsI/dky2FwwWeecie2qOWFkeVB/1yNoxvhAAy0P6FPoO67xqc6fx7Ucsjm7XB9oqRAjD77z4dSoAdIFAsdQRHgptaKRBUXKgxHdLFBmATYVaea/a9IEoLNyl1HrBKiYs4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761696299; c=relaxed/simple;
	bh=qF3NtATOlOxjmKjh31CoJ8+W1noziSRiCQPVNghpJQk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fo4uvKIUL1N98LdDgqEmeVWq8nFaXUj7JG85PdIQRwfRsrtW19W1nKeB+ugNaTo1s2qCntMbCkN5+6k0UZvgfDMEWY1MJlFWdOS2CnwlPOxUOlbLiNYeC525bUDz3DQxKbT6KHZ80Yj30ZS9hgV6IPxObTal2hubNK3Nt4DMdQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=MkV3ZrNK; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="MkV3ZrNK"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-34029cee97fso1595592a91.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 28 Oct 2025 17:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1761696296; x=1762301096; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BerLOcBoWrV1cLwn2WvSsreg5PxA+PLtgWK6veAyVuE=;
        b=MkV3ZrNKTPVugBhFpGZHOUz8vY7n5ZUb6r8B56VUu+8FGJ7GiRqmV3a/Ph4HUF6OSQ
         tsUs2Y/OC+fMupNxGzWQJ21qcFRgKvPTqT+XTESRu3S9UF+rWBGWxApTfw9sS3qHYn6G
         WFoBo+QpnTfirwVtzBJk+KCTCLnvVJjJQJd4WiOmZF3w+T2Z8Fi+p6xtASwfX6v9/bfo
         oBC9msf6URYpYl6VUTKRXYpVsgTEYRcyaRwZZ2AfoNaUEw+D3y+l0w9S1IIg7oAInUXA
         Fxv6uhwNpfwCccq0IRILNOxwPufFMocAP6JYKIr3s2prqVhJxeYEnYkuaikrqZzjMObE
         6z6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761696296; x=1762301096;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BerLOcBoWrV1cLwn2WvSsreg5PxA+PLtgWK6veAyVuE=;
        b=Ai0GtYhMjnyPzGwFff+QfovZowtbcgjPNG+BdT6OTuPnrJOk7K3dEdkT9+hoTEtXYQ
         S63q0we54KcEgQIrrYkdR/vTuZRdfZHJ2FvjdElctzSZAyGRuIeXzNTStLHXRspOr711
         vunbz2aRtwTRher8WZi9gsosoZFK98CWr1Y4fQEtyoUyhv5heni0RfwPp4ZCEqiw+wAa
         gZTraeprfzJXqK14SH+cNxJrIjG3aNp5Wva8W/sRfE9ssD6kEHgjJ54caCC8zOvhwzkm
         gNYyP5hQnILS+EO4QwveGIWEgFz/WWfp7beNGidCgvxRjR9wRj4soM8/uvi1sN5D0YyY
         0P3A==
X-Forwarded-Encrypted: i=1; AJvYcCX4LIxwWRpqhpOKJGE4hROoMdhaggMrKHZKEo4O8sgnRArQNZnGYyaYVw4CNHHGbL5HOPxLJpEYelNigA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxJq0ezQKssXzNfJ1MbXSghmjaBwK0quo9DrPpThFRiCv2RO0aJ
	LkCd8DelrXZ5ZL4E1lGa4VaD+Qb7ifvD8DkIyLuV4OZpt1FeQu+JrEqCwKcEBVUVuBl0tmZRQ+v
	cv3O4D7AwYdWmbwMbP1CKCbxpLTflHCkgcFc0Jsnc
X-Gm-Gg: ASbGncu20Ofq16PHJXK2SuwKbxjr6Hp1b/aLwYqbQR2ujzt52Sslcvi1UJ03kjoD9vt
	eJFVjBKzqxyLkWR2n3hug3f9nOfvjYO1PI1veDOedcYZgrekjcFcQ39K3acqJF+A5D4ZgNrIDCM
	gnm3M1GtrhFJrY04ofnqeHEkjkkigGsYX0O2QHT25pHxIFzYJ1dro3T0r5TJEDD2ZCh4Zdg+Kg3
	9CXCsCwq4tcYL4cUI+DXPblljbDho1iMn76g3b7ytD7iy1FREfJoVT0SRE68pe91DslvHU=
X-Google-Smtp-Source: AGHT+IF9Sg8XTJhY1XF+gNJzXx33YCPJNPvD397jHY3K37ysFCuyvsRKOtkLfk2UKLtdow89RUSTsoGqlzXNXJIH+YE=
X-Received: by 2002:a17:90b:3147:b0:33e:1ae2:a4a7 with SMTP id
 98e67ed59e1d1-3403a2604b4mr1039988a91.12.1761696296385; Tue, 28 Oct 2025
 17:04:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk> <20251028004614.393374-50-viro@zeniv.linux.org.uk>
In-Reply-To: <20251028004614.393374-50-viro@zeniv.linux.org.uk>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 28 Oct 2025 20:04:44 -0400
X-Gm-Features: AWmQ_blrbvCvNMESns84vcg9Bs91_mExO5kolf7cbCdCoz5ngCaqmvIG7Oeo_oM
Message-ID: <CAHC9VhQH--uP=fWo0MsH5=BojV2qG=qy7A9tHTVOnLYOxKbV5Q@mail.gmail.com>
Subject: Re: [PATCH v2 49/50] kill securityfs_recursive_remove()
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
> it's an unused alias for securityfs_remove()
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  include/linux/security.h | 2 --
>  1 file changed, 2 deletions(-)

That's annoying.  Another case of
let-me-know-if-this-patchset-dies-so-I-can-take-this-patch-regardless.

Acked-by: Paul Moore <paul@paul-moore.com>

--=20
paul-moore.com
