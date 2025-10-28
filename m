Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C56730594F
	for <ocfs2-devel@lists.linux.dev>; Tue, 28 Oct 2025 23:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761695477; cv=none; b=eQyOHucvI7prTM+OrqZlb3RwQWOCp4tL25hobAcRBoVT4ydVTUymmbrdFLQPQ+smfg8Cuwc+4tVNrXKdpSJdAVsvZRH/k8Aw5qOLZWeyvR6fbWyfD/Q6Ykm+YeIfy5rLO/sIWoFeQA+XXNpQlESRjEjMXJmHP9pwWXW4cu8/8ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761695477; c=relaxed/simple;
	bh=zhqXyFTzb2t3B9Dp9QKvidvf264lh5WpAlH4hAvSPD4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lqPn11MNUBToi0MMleb2iZawBkeCUMEz0Iz8Azg086TyJ6qs0XhG4wj0vMVLkrfqjJHOBoyPuzww2xfmzNNP7Dgfs6kZGPeKVDkhUxqoxDhEudRapk4bps+h4ignGWaHPHQa7GWhH5B2Lr58PDevpVeuCywwlR0WiyF5hmMupWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=Z4kqoxVB; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="Z4kqoxVB"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b6cf1a95273so4816235a12.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 28 Oct 2025 16:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1761695475; x=1762300275; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ss0xsZDTL1rwOqKY2yzsfuodL2zhm4Ktw8Z3rrAQsGY=;
        b=Z4kqoxVBVnOui7ysht7G0mOGAOTCvzFCfgkSW/04MxAGtgj46VE0WmMzVm8+qRMzO2
         ovubANBnVsLANYFafCE/lIsDeOyh727c6Hm91K9le6Bx3chZ89pDTVwfq5zI6NnvjAzR
         1I1JpA761pMntsCAbUBYYSqkZW3mHKt9zNQ5m9Y6EKBp6pA8Etfh8EB0bMmyaLUXSRYv
         tcghMGgXycfKdoJ3cpuVMzJVfDOJVPhGnZdrxo74AUaTQ3IpjThPIhi/AXWHSZFCSV8C
         SAZorXHljU3t+wcX5kOyMZp7HFZ/09UyPksrh6Rmfg55IM0v6DqGEgfNnbyBbpDZlzzK
         Zwpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761695475; x=1762300275;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ss0xsZDTL1rwOqKY2yzsfuodL2zhm4Ktw8Z3rrAQsGY=;
        b=aCQlBanboKkaKAkTEvShK8N0HVv+ceGgMnWCX03O9nymK69m5YhyegR4Y8LARlNE29
         lykScJDT0+nmA2rg9jaeMY3ZzxPrcScRBaOAqCR7JggbgdI3HG4Hoo7QoX2cXgZ6gyQd
         hNhW2xAdcqeYCrYQrBTI3wa+bjd+a+2RvQ584+cGhxdPAzHdVyR9+rShW4bCVckLBsSn
         QK2v3mmDQwKnWJVMYUX8uR6Z4UV4XGQt3y6P4YQl32cYgJjvM5xRr25XkBX0iKDK2pMk
         3vLqUYnT9FrjWAdavUpLPiuQxo9qV0cN1WPZeEkrY2M80oaUUv3YhLGTj+eyYO8wWtAM
         589g==
X-Forwarded-Encrypted: i=1; AJvYcCV/EcEyHOvxfhjdSyvWeVAI9oIcKeFbHdbSQkCq13S/dLm1QiPeUF8CpXCVY/KSLV9TRz2Tyw29dkEeTQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzes8ltZEjgHEMblScfg2yx1dv2O1kCibUTz2N6yqMSvMOYugpB
	Wp7w+zC88BxGwlX9DtLoIq+8Jt9Vb+5HacrKSPkG/zni+rlQg75vFFkNr3oM2pPALQ9TA35y5eE
	UEj4Rysd50E/ODneiI4pIloXNtnDpUj8/POvjIL9G
X-Gm-Gg: ASbGncv8e3Zum+KhPYk65XfUpwXJUXlUk/kqpbhrAVpuHE88JkQMmPdVaAohzPg0VDL
	TdnlVX1yqBg6hUptbj6Fx5xKe0JsIMmlNvFY3A9f6+5wWL4dXWcU0muTkd00JefuMfcK3+qfL+M
	NrQhI7cCl5M33Hu/Zwa6d/1io1YYwsfqsZQvdKhxukQ8FsPYoye64PN15aARmaYLVS4/5V+sPU9
	kH6eNpXJmKh7Ts553viviYq6F9BWNdAJ5ct0wLnhALGZCYyswACTk2BZac5
X-Google-Smtp-Source: AGHT+IEQNyH4/UIhryBKstXm8OFaWiuLlbUq8UQcH5+4F6rsLQi06Pj91sWwNLFBJTsNKL1LL+PFGKuePdALOMKBWdA=
X-Received: by 2002:a17:903:32c1:b0:267:99bf:6724 with SMTP id
 d9443c01a7336-294deebc1a4mr13124835ad.31.1761695475463; Tue, 28 Oct 2025
 16:51:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk> <20251028004614.393374-35-viro@zeniv.linux.org.uk>
In-Reply-To: <20251028004614.393374-35-viro@zeniv.linux.org.uk>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 28 Oct 2025 19:51:04 -0400
X-Gm-Features: AWmQ_bn3uluZWrDfxLWehWBukesK9g25bn5Thq9tyHBU2hJYs5NTI3fvunVput8
Message-ID: <CAHC9VhRa011jL86779TBk8FK-pcWinLkSkQ1MoxGyyfJg5SMgA@mail.gmail.com>
Subject: Re: [PATCH v2 34/50] selinuxfs: new helper for attaching files to tree
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
> allocating dentry after the inode has been set up reduces the amount
> of boilerplate - "attach this inode under that name and this parent
> or drop inode in case of failure" simplifies quite a few places.
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  security/selinux/selinuxfs.c | 160 +++++++++++++++--------------------
>  1 file changed, 66 insertions(+), 94 deletions(-)

Looks fine to me, thanks Al.  If for some reason the rest of the
patchset doesn't go anywhere, let me know and I can take this patch;
it seems like a nice improvement independent of the rest.

Acked-by: Paul Moore <paul@paul-moore.com>

--=20
paul-moore.com
