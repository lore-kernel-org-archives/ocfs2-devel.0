Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2A336D9E7
	for <ocfs2-devel@lists.linux.dev>; Mon, 27 Apr 2026 21:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777326422; cv=none; b=Jtt+rFhEV9XbWVPBJPRoV3swFbzXFT1vbqjcvfgrnN4HnYsOiohltiNP3eqrt85SpxX/5tGs9ThXvoxiqTqBQ8VfURjvZXwBRa6WXpLrZU90fkCmi/jYUOTfGJQYssypsu9p+TJ/6hkskBcSz2TgkPA+x2LODIZ0lbHvRlCAQBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777326422; c=relaxed/simple;
	bh=i/k46YQbNxc6jmDhpSrBTZQploRe2hY24KQV/uGHVj8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tIqLYqoMxB1QUHlO5vhI12gFhpZEWJCiYJj3BAqj2FdSuG/hGbTKMGNEUYy/uawd5XXmDxGFVwgTVEZNid5P5ncQ04CuUv56TN1ep1w1EI8Mm4AltDr0LPAJdYy+b2Ha1GYl4re3TvYfyXyivMGEX/NeTiOuwc05E52sxxYfXs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QgqOKxS9; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QgqOKxS9"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-65c4152313fso14724197a12.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 27 Apr 2026 14:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1777326419; x=1777931219; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DjF1Jdn4Kp6xFyaBmAP2391GfFF2q7kuOVlruTChM90=;
        b=QgqOKxS9q7VLu0WE5j7ZM4XqKOvXfTz2ugQqtaXjzpJOeKiyjqZOixsMe2csxekHkj
         JMLjUqTlFfHCXNRoRvfGmOZLam9B98LFQfME7LnArDgaY0VtNmJdJaNsNnsv5O7+OYLd
         dGSy0pttQNCtAHyQ4+DpRq1wk8+vHE3Xa0v1A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777326419; x=1777931219;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DjF1Jdn4Kp6xFyaBmAP2391GfFF2q7kuOVlruTChM90=;
        b=TtjjjbCUT+9ChbYLEaRdJ7x8vlpN5q/j9mMJ5bJGf5oAtulTvCIBhF72tza5aK/cTE
         CVnIfgw1vxHvRyk5SohgGeFl4WdtUbfLLbqPAJlTNDOYY5xGEcuyQZVMymrO9gBVex1S
         wlqIx/9ShytWSRRHyGmAxCM+OJ9uchowSjWP5NecbUFq4NdYE6EBraGb3nz6jVg4P9hI
         kgeRP0KkSA6D/DelZUIDuRhUjGanak0cl3ITQzIKoZc79dnRmKPPSqdB1MMTqgFK79YH
         KJFIeyqZ/3h/Y3albTt+wLV12jlF9STxSZwHAzQrXQtY5o02P6CIfadsmRomM8AbH4F0
         bdBQ==
X-Forwarded-Encrypted: i=1; AFNElJ/EI150XVnaThB0Xgd8UTHjF4YMMDXgf7QGV4TrJ4BcN9FjNMiXaELqBs9F/u9vdZipc7g5XmX6WmCfKw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzECUI6Y6yJATFKBPrm30BV5i/EKsqPp2fkGJgbnAN49seu/i4O
	X9khgh3MTVduKb5gLgSVx8ib2JgQbeWvyK2fdv5Go0ylm83aRNw4RLPRQDShR9t3CGxZk5/o0dP
	jrqSh+Ueotw==
X-Gm-Gg: AeBDievfmr+bdbotfL5ntN6CarFtEwmey+FPgLjHlpl9sUP0pLZmmJ6VVys75PO8z7u
	0k7EyMVABdrzyAUUsJfw5n+e/eI+VHtaPLLbH5oYCNA2X9YK5NGFZIQdcOxm2KadFU2xzHPEfmj
	yCPfMhh46+yuLXCfqrQAhrfSwrz9bU1CB3BCNl/yGbpE8dyf6vty1LeHkAWOP462z8/1ztbKUeW
	AxWiSYz2FYc0AFxmSTUg91xOm/8F3lbjESLw6B5uxfQNPgf0f2j5kqAa4L8yRqpxzoWcTbiu/0S
	+NdHfNo3OKbqI6bow65xstSdIiWUVy5X9ZJ8DA9Fhp2xUqdWUbzTUly9eHfkms4g53vSCYL/qbQ
	bKILJ+BFp259W2/yf/S58xGwbtjFgCPUqQiEQ0RcHGXGeY+AjYPpndKl/CtQ2lahsLVea+cF3Fa
	JLuDuxwIQIP0GDGGCDEYnZsrCHryWpDgyIl0c7BTMve9Tv7KSbYzuYGsrUDQGN//7qwe2G06OB4
	fg/SuIGFtUPk0z0Xiw6dw==
X-Received: by 2002:a05:6402:2815:b0:676:20c8:5420 with SMTP id 4fb4d7f45d1cf-679bb0a3952mr143274a12.25.1777326419372;
        Mon, 27 Apr 2026 14:46:59 -0700 (PDT)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com. [209.85.218.46])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-679b6843097sm148063a12.19.2026.04.27.14.46.59
        for <ocfs2-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 14:46:59 -0700 (PDT)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b9c01854477so696769766b.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 27 Apr 2026 14:46:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+RotOVciTOjkXDsu2h30oNd8XvEuRZr+r7GOw2pKKqpX0Umv5NcATLJg8IPGe84c89sBWzeb0GWjJGpA==@lists.linux.dev
X-Received: by 2002:a05:6402:5216:b0:679:1f4f:9d30 with SMTP id
 4fb4d7f45d1cf-679bb04c1a2mr179970a12.4.1777325976937; Mon, 27 Apr 2026
 14:39:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1777306795.git.chleroy@kernel.org> <289b424e243ba2c4139ea04009cf8b9c448a87ff.1777306795.git.chleroy@kernel.org>
 <CAHk-=whC1DZojwdMB1=sJWG2=dsCdfyU8N6tDE1qx50HRZ-WJQ@mail.gmail.com> <20260427222914.1cb2dd3b@pumpkin>
In-Reply-To: <20260427222914.1cb2dd3b@pumpkin>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 27 Apr 2026 14:39:20 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg0SGbRYhdZ1kvJUTv1HEvmRJyQauFtBGV_fMcZVF8UpQ@mail.gmail.com>
X-Gm-Features: AVHnY4I-AxqvQRk42MegvhKMp_z4sSEpEzhzpgw2GyV2bV8dezSPoI0JTlwB18Y
Message-ID: <CAHk-=wg0SGbRYhdZ1kvJUTv1HEvmRJyQauFtBGV_fMcZVF8UpQ@mail.gmail.com>
Subject: Re: [RFC PATCH v1 5/9] uaccess: Switch to copy_{to/from}_user_partial()
 when relevant
To: David Laight <david.laight.linux@gmail.com>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Yury Norov <ynorov@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, 
	linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-um@lists.infradead.org, dmaengine@vger.kernel.org, 
	linux-efi@vger.kernel.org, linux-fsi@lists.ozlabs.org, 
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	intel-gfx@lists.freedesktop.org, linux-wpan@vger.kernel.org, 
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org, 
	linux-spi@vger.kernel.org, linux-media@vger.kernel.org, 
	linux-staging@lists.linux.dev, linux-serial@vger.kernel.org, 
	linux-usb@vger.kernel.org, xen-devel@lists.xenproject.org, 
	linux-fsdevel@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	bpf@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-x25@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-sound@vger.kernel.org, sound-open-firmware@alsa-project.org, 
	linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, 
	linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linux-sh@vger.kernel.org, linux-arch@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 27 Apr 2026 at 14:29, David Laight <david.laight.linux@gmail.com> wrote:
>
> I think there is a slight difference in that the normal copy_to_user()
> will determine the exact offset of the error by retrying with byte copies.

I have this dim memory that we decided that you can't reply on byte
exactness anyway, because not all architectures gave that guarantee
for the user copies.

But that thing came up many years ago, I might mis-remember.

            Linus
