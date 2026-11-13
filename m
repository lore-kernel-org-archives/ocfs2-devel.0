Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564189;
	b=FPnDRtH1CAuJxd7E9sJ4d5QJy6YqxmN/M3XCidvZ5u3pMBidg2Q39sFjdpT2Tzp8qxYe
	 p+8TvNd7hFtt5Ef/YXjhk+aVptMO01cqOoe8o6peP8Lj8VI7w5JKSx8FlaVv8nON+uW/C
	 dok0Zr4sF8wRUkhRgb1lziU3x1gtlHrQZquNrt6N6yhrFHM0hg2WUMozt5QUYOPF+RQpT
	 CU3/BU/cNJb/y5cujnVh9fO3YK8tqJ2j3Gkz9VlRlGeplsGOrxcts/XAcabeAUT3jQWgO
	 HnFX3DYJtOTN5cwqYMV/lsT6Tz8wstsJDUiFg8dTrtULHEiPOYU1Di1iU3taFMLqQDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564189;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=SoW/gPie2WRRtXdhiV6ow6HDYwH4jtR4w1oiMzBwW74=;
	b=HKQNj2J+DpfYElj98XJV5mo6bcXvvZQV8jCsRoPB6wjUmA2I2Zp65MfO9lc4o0ybTTFo
	 OCyS820rXkJRXCBJcYkmPwqOsrmudqoOPikc8OnxSSxMvrGOJOFldf2ZGWgkirfW8Zoma
	 gi8PruGG2JIo7vM5n72mMnn1LjPRulE5eFogk+B+fg9fGUyWnpzVbFbPvaMvvcBJ4N2R+
	 lVDyvMblduLaPm2D38XeyWIBt4qXs7is01El546hqXbmvBC1UGNXfLhdJPvHJXOJt7LHZ
	 E1sCzx3oMEo5waAbb9ysV+AxrZiWhd7e5mTVts2fvfBDXPtNHD7VtVTnU3sCqs9pvNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=A5AXmBug;
	arc=none smtp.remote-ip=209.85.218.53
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580EE606A887
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 10:03:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 580EE606A887
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=A5AXmBug
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c4d427836e9so121393866b.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 02:03:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564188; x=1795168988; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=SoW/gPie2WRRtXdhiV6ow6HDYwH4jtR4w1oiMzBwW74=;
        b=A5AXmBugVWQHGj7zCfxDZY7ex0LnXQpTthb7C7xEqYHZEtqxyq4pM1iyNZVnvB8O3z
         U+yOzodWK4Mj9EaaHXpMVKTCwYXWzpf+NLKvmzWEVwG0chg51TFVB7t4VZBLaeedN30K
         e2dpZDs7ZLY7mIYQM+KBAXVFjt9iMEALB4qeGXDVJAFVERTqqT3XNB1CAZVYamfSusZK
         tcPvxsyK1ZKzkpsqy8RltsGYx9+kjExuGAWkfh91lIO7fwQJzFrH93g2lW0N0aCZK5Gc
         aKKM5k7XdIF0EfPiBLp1YcBXT7vT/neoCHrjc971xHu0wQGBDCepBMk7ymmm5FEydAnR
         QJkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564188; x=1795168988;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SoW/gPie2WRRtXdhiV6ow6HDYwH4jtR4w1oiMzBwW74=;
        b=YfmSYKDyQpxMg+ly9VBY004aEE1OxlfPx/hVDOeHlnW4XNBlBW1CTFHhAU7YV0c5C0
         lV0WifdI0+Q9DLuGRGlVD+6kQTyFxrjAmpMClVNdyeSWSmUMK9fRKJaIdz9p9oQ4cbU6
         1RQsaKIOsXLBm7QXyXplSqwmekY6x+WiDh60HhXz9detJv1QRBLFK1ynz88PjiHynDLT
         O5woAfbU5CPgqGSYeVS9/Tv6HTIjf/ubkg48lgxiYI8so1/sEg+vjHhuU/oIMyyi5YbQ
         g7tHYtIYdzBqEM33AJqaRfFyTJ6gPNeoblwGjrVMxIxPwhh891F3zqXKm9z5Iw7e5NXQ
         bdbg==
X-Forwarded-Encrypted: i=1; AL+hErHC2vHEzA+74KR1Hgibnfk2gnT/9gZAtlY8/BPKUngCQrRViIbq/dE/XNyiU99ZQsjuZa7cgeJS4hrzfA==@lists.linux.dev
X-Gm-Message-State: APuU4Z/R4GakSpQQYzFHS9RiieRnzIh/nCGvisgN+rYaznKBgnHWEcBR
	8SAi3pXV3OIqKWWKaCaBXdQrnuXxxxr2LDExZWo5ZI6Md+LpXt+fQNxR8k1wko8k6gi6
X-Gm-Gg: AYBFou0aqLX82hXHpGBfM203o0P6TMOLZhrWWJKMFHsRnSJB8kU+Aq1sxZ+NLEGmeG8
	kcRHtRQvRLCqisj8Dpet9/Kc3TxYV0ua0iVfU7sHydIRqFrcMCr9A9x7CyvyIsM/SyPB5i6mKae
	3EVkNn+pDg6igy6Ie2xuoSJKbgMkkucMfDabVYdJVSGT6pvGGq99RxyHCKYBX2bLf4zO0ZPWaGC
	VD1euQtJ3RssUViZkxqZ08gXDs8Ed1htZs297/RwyXKvi6+xwl0puwtGVKdtTb6KwtraKa4XItu
	JiEw9uAsCnLOyqzjXtfT5TuFCwKY80KD8mYFFNA8Jg/hIXOx2TgD7ImuGCZlFjtuXACeA6ZWxLR
	n3AXUcwGityf9CC+z0GLy3ex6FSCIfdmrFDFo+4IA/dsvtKGHZcsur1T2E2nrD6M3LW59vDwPg8
	KfBnm9bUsrUQVhU9aBbXqsUxQ7iZJ5QmUF0Zu39tLzEFOWCp5ROpvHMQztRBkcC2blErcZz3/et
	VQ2RzJAVNJZIYY7lVTUZuTybSVqkrxk9ZWgYefhmcNyoL4N/cD5nD6qEu6LglUHg8cg632ZbZaT
	FcociuXGPWwH+TQ4P+3YPkgZsF21PZ5vmCgr0Fl7tW+qpmMg
X-Received: by 2002:a17:907:d12:b0:c4c:b4fe:c9e8 with SMTP id a640c23a62f3a-c50963dbee5mr161853166b.38.1794564187801;
        Fri, 13 Nov 2026 02:03:07 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b3dbaesm74933966b.32.2026.11.13.02.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:03:07 -0800 (PST)
Message-ID: <fffc4f7f87fd5f03d1ef409df76f71ddad552213.camel@amutable.com>
Subject: Re: [PATCH RFC 07/41] binfmt_misc: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:03:05 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-7-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-7-4c998976c6c7@kernel.org>
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
> Initialize binfmt_misc as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/binfmt_misc.c | 5 +++--
> =C2=A01 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index d945b4f6e158..7dc233becd98 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -22,6 +22,7 @@
> =C2=A0#include <linux/file.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/kstrtox.h>
> =C2=A0#include <linux/limits.h>
> @@ -1575,8 +1576,7 @@ static int bm_fill_super(struct super_block
> *sb, struct fs_context *fc)
> =C2=A0	if (user_ns !=3D current_user_ns())
> =C2=A0		return -EINVAL;
> =C2=A0
> -	/* Never exec off this instance and never let anything stack
> on it. */
> -	sb->s_iflags |=3D SB_I_NOEXEC | SB_I_NODEV;
> +	/* Never let anything stack on this instance. */
> =C2=A0	sb->s_stack_depth =3D FILESYSTEM_MAX_STACK_DEPTH;
> =C2=A0
> =C2=A0	/*
> @@ -1660,6 +1660,7 @@ static void bm_kill_sb(struct super_block *sb)
> =C2=A0
> =C2=A0static int bm_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &bm_context_ops;
> =C2=A0	return 0;
> =C2=A0}
