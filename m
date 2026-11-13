Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564809;
	b=YWEQAwZfSjco0sF6+Ue8gnl/gmeuwdo0tr45PSdFypDVj0ap3ywqagy2f39vFA4QEu2K
	 O0cpPkFPKKp9QSLUPxVtFBE2+RPnIdeD2JD+4uiag9vZ5hYk0nv7Hur2m7i2dNlPWWzqw
	 fobgPHPNR3ykc3gbCoIBTcH5d6T7/UxKXnix7cxfPxKCrlJci3X6W2QOGF9gzFZEEe5Bg
	 O/zlx3VLcK7q8fio41Op4BSW37nOxIOQelbqp/cIJ+83ymLmMHi8hFJZFUjHaJsVWko5F
	 gnk4U4zwkf38n/gGE2hDxRrXPzKjyYBxHUs167/i2JdtHegOF02YLnFClSvGJgn2lTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564809;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=UX3uQO58FXw3i2m3kzI3o8uINYIcsljrdUAfEKBly4o=;
	b=pd9nSCzwZbz9ykOYNHv4YHS3UM2/i62CB7S+cEN2h5+o61+V5/psugOnGGnPKS5kXN2l
	 wbbHqUukmOFDOOBbydvSrQTGsvmq+bp29jss6U04Pej8Es/tkbVaqHsMidzqxswert9tP
	 UDiIi7vL6+/78mRv+xnTPnCtsVQyiTZCnR4+BvXaYvJebt686oyIlM6V5fTXPvVtdZGuW
	 ksXfh5GUh835CMkX51UXh5LSGMZfyqSeRBtrW8JDF7CTrogRs98a8j4zRXiDDCo3N6a04
	 aMS4KFqALuffrGHSc650XmGrv6EjWE4sja7N7qfYcrol9yuVRSckI0evbfXOlNrnG4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=bPteaYF0;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01E4606A897
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 10:13:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F01E4606A897
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=bPteaYF0
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a2d6d01ecbso7001965e9.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 02:13:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564806; x=1795169606; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=UX3uQO58FXw3i2m3kzI3o8uINYIcsljrdUAfEKBly4o=;
        b=bPteaYF0LDLBhb4MMDrCQcGeBSYdEW8BR1KwVfhIGgPljNrsneiCwDwCEK9a5QlXNc
         tB/NVenooRESnkhjGXly3Q1Et6fehkL1U8U2E2ukOdtymki7dwsktQWlFRxZ11a7bzSe
         hji1GHW2DiXcv3Cnt80tThLj7kjseVPyDyN3t/EE9cQpMSvp7wgFveomObVqSHV5KJbA
         xTiwHsGIqBNzj/OOrSUqXhclJHqjr0Y/e6nO5oN0JD2f0DO4pN2kZpwlf48BmDKyAfJs
         BuAeimIkBNjxJq96KRmplvgcCfOOwtkZ68xFMnVL6czkbH5SzDP2Bq5leyi+KXzlgjwR
         7Hjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564806; x=1795169606;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UX3uQO58FXw3i2m3kzI3o8uINYIcsljrdUAfEKBly4o=;
        b=xspHAyWvoOLC8rnzWgV2D4/SdBYKZhvW2oQim/H/E8yCHqGOzlBhIO8OIkig1tL4fy
         peJyozEx/K2pzWJWfUpEMbyNdNsDX7SYPoEtOon64KNPRnLxOsTQKRmRcT1avsYd3KcJ
         8OooovIZhE+bYQCy9Lf28EZKOtOZ5o7qj581VDTDGdTsqfPCl4u1/mrGPkVQ4c9GV5qw
         MWhNRYO46UjezFzO/fxnVjAvH/64ZYeketlBy8wooZpeWqAMGudeuuootWDXApgu5fh/
         3iMWeIGU6KZJGYyPJXveRlLG/nZiJRWPDxbNCkF/Ub4WaHilRNRRpUYT1/rvyF3kk5jl
         PEmw==
X-Forwarded-Encrypted: i=1; AL+hErHrNnDAJzMEcuTmGAhOSIVCcozLSeaYexKXJQpOK8xWrIG6oAgeSW7DRZtG8YSWZFZc2Y7unOGLQ3esMw==@lists.linux.dev
X-Gm-Message-State: APuU4Z9NuTwOVSh3DyHHbDk+5SHLHXHcWHGhHoxVW2oBfSC75rdZXKwY
	iDbJU0R8MwfyLd77syiHlvCH2fSHkoz4WSC9Z7mWa8oUIuBvvXn1YsES+rQHJZQP9fQC
X-Gm-Gg: AYBFou0wy07MVBh5xgfUMBWo8qhYKwY2q2vnchfyJ1I6KLdx/TKummKreNB5nCGfFmD
	Skg8akhRG+sUIYrHmugiXerwldl8k81D7e+wc7bQeZ/OvW1kjICl8hFRCImDZ0F1cFMwxv92o7j
	TT7E9dQ9frNGYiAL3c93JPmR3vP5FNQ9bxQks3P6aPkS5Ql52DksK405ZL3EC/jnWImo6TJolxO
	9VYZBcw4vcFPX90JldxQHhyooM0P5hbIBqdZ8/t0b3qz98E88TEj2BVCgXlMF/TXdJqBTMBn7th
	NtHXWJDUUpgH9KU4e6dwRfqT9LEwUbJjbybe8kS//gtKLSKGIsJaYY5g6WUQi/nZz9DhMOIRuZC
	mLjKd7retgsKqkTypSWwzsng/T9E4ZnjTQirGWvTrRTxy1B9ByHOrdCjeoHj47/6mzvR9d14fdV
	dnnQwa1ay+zzQrw44olevokxJhH29YFGRGpte27wzBqSBz2b47QOkTzXiuQh3UTakwnxb8YgyTJ
	7GXvrf+64L962t06YP/HZQB68nHr2XTvWR6c0btYZFuxaFPolVStLabMnL/N+Bad/2Wm9m/Ufha
	yJ0tZXdDU5KxDxcGQ9aPem6r/jtVOhZuhnB47yZ7UDA/XTTJB0/LXC0B0Pp8H68=
X-Received: by 2002:a05:600c:45d4:b0:4a0:23f:8b0d with SMTP id 5b1f17b1804b1-4bb559f6f31mr43583035e9.2.1794564806374;
        Fri, 13 Nov 2026 02:13:26 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c609c8a77sm4362275f8f.49.2026.11.13.02.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:13:26 -0800 (PST)
Message-ID: <23edc29c421f5d4c1103004f79e104e9f94d42c2.camel@amutable.com>
Subject: Re: [PATCH RFC 23/41] fuse: use fc_init_pseudo() for fusectl
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, Josef
 Bacik	 <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, 	driver-core@lists.linux.dev,
 linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org,
 netdev@vger.kernel.org, 	fuse-devel@lists.linux.dev,
 linux-efi@vger.kernel.org, 	xen-devel@lists.xenproject.org,
 ocfs2-devel@lists.linux.dev, 	linux-s390@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, 	linux-usb@vger.kernel.org, Amir Goldstein
 <amir73il@gmail.com>, 	linux-erofs@lists.ozlabs.org,
 linux-kselftest@vger.kernel.org
Date: Fri, 13 Nov 2026 11:13:24 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-23-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-23-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> Initialize fusectl as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. fusectl never holds executables or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/fuse/control.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/fuse/control.c b/fs/fuse/control.c
> index 21ffde596d61..4497362e7df0 100644
> --- a/fs/fuse/control.c
> +++ b/fs/fuse/control.c
> @@ -10,6 +10,7 @@
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/namei.h>
> =C2=A0
> =C2=A0#define FUSE_CTL_SUPER_MAGIC 0x65735543
> @@ -334,6 +335,7 @@ static const struct fs_context_operations
> fuse_ctl_context_ops =3D {
> =C2=A0
> =C2=A0static int fuse_ctl_init_fs_context(struct fs_context *fsc)
> =C2=A0{
> +	fc_init_pseudo(fsc);
> =C2=A0	fsc->ops =3D &fuse_ctl_context_ops;
> =C2=A0	return 0;
> =C2=A0}
