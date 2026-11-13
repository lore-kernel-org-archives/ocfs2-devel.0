Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564173;
	b=ViwSZYFhjkaGCUNNL9vu9gIm8ODhV6XS4o/SSbG4HT0jlbXnvPrSen1dATHj0f32Xq5h
	 09xbtq+YcI5hw8fC4T6L+BfsbkTLIXOeyafaqhGi7aJzcIlvEVjHfiGL/ajO4t34atQkg
	 YIfVERmwim5AY/SM1M1JCTmDQjXgayADSXL09rp/p/W2a14ZU1ufI4zsNoCpWrxeBjkBD
	 HYHqhpifKdI8D45InxEBJshUbUbOGPYHre4zYqGRj73vT20PQ0V2P2uiitBFIa0q0PegV
	 +S0c9MKm+aAupqYxDMZMOhNVTP15nmxIf6eYOGgoiVk2xNTSamoK2zZGLvIZhR3ckxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564173;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=QOKRfXbntKilXKCbQIPuMXmISRmnU6cXIBUGi5zYMoA=;
	b=o4KTeY1S7JmKrV71wH7INb71s17EMJTIVtbKuFWpgZMaqbaOFjj8T2HPELOuNo8m0RD1
	 h61RyLofcgChkPD9yH6oMs1gtU/HyEQ3cqEoq3fDo02ryrs+j3j9xCvmtPPqu1SKtWuZ5
	 4m92x4oszf6t0CBN3OaguM04NE5uxlfJXdlnqj7c5OcJPMQ/0mQCBw0kEi10iOEOHbIZh
	 flAox7sjI9RQ4RNaHfnnNNijF5iD+n5nkCqpp6swjEcMNxt1wHPEYaX8MYg6DFK+LW998
	 UFe7DvpelSj7NonEEXtGjeLswT+qdfnb2JwSs0EgaF4s5dwA81PUR6sx9EmbqUYozIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="CE/Let5C";
	arc=none smtp.remote-ip=209.85.208.52
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC822606A8B3
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 10:02:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC822606A8B3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=CE/Let5C
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b408f2d936so1439706a12.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 02:02:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564171; x=1795168971; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=QOKRfXbntKilXKCbQIPuMXmISRmnU6cXIBUGi5zYMoA=;
        b=CE/Let5CxzzBdQGOWfMewQl8H196xi0GSnvrBplcNDnNV+1kYp4PkVMyr+d2SZM08b
         ztpyC8ZUmRyXY/lC8PleWDcqZ9ozuUHcpA5SgwiL0uPF4nV/74u27b91cdI+qyFmwpUx
         J8bpGjpUEp+zxGj5Tn6SK6c6q8Mt6RA0nDgMzrqL7jndZzEkbsZqxddyoVf3BBSaewVA
         08RlDFLoYOfSqLw1R5h3qhfpuggtkAFzk5ZbwpZjvsgpZl8xCz1GAJtGTIa2JpgRfY5H
         48C7QzoCjaJcwqa9p0VYZNO86bahrR7/FQxlXM0qNKyYcrKLG6oN0KhylCMb3fIB3P4W
         gTPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564171; x=1795168971;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QOKRfXbntKilXKCbQIPuMXmISRmnU6cXIBUGi5zYMoA=;
        b=a+HFr52Vgk2okyh82RGmXaYweda2g0nqO/VQj1lICLxHOIPx/3lwbrv0NsoJSTV1W2
         RJoLa+Xw4sC508IHWXRPRhFmuQyQHnUoJ650KEO1ekJ5xJhCHzTxhfAXj7lZeOcKQ0ic
         nAS8STEhZ1A2J8XUcerQPz5GSYjnma0MEq3otiVwgLVxj0E59hxUtWSWiZ91Cqc1nuID
         7KywEDaBQ86Evz9tTmdqzjHue2eECVJOxFPw955aDAo7DMKJduFTlB3jhW/Yp2sdYFk+
         dbM6sfwcCDNKe0ZAkySLI+5psIrqW6nzLXGsoa62teNErmoWMEW3SH27hVhkgrF9vS4P
         Pl3w==
X-Forwarded-Encrypted: i=1; AL+hErGsxkbiw/zV2w94O6/066qrJ/51bRDKNbzvkcLttlFm36+v2KmQ7cFw8A7+q4euDaDYTkTciNI5tCdQYg==@lists.linux.dev
X-Gm-Message-State: APuU4Z89bRYnBRhcrxSUrLWimnHNPCkI7Bk6T2FJZc1ZEC9XiDrGvchR
	uOPjPUFLa29yCEmuPjDPeHTDN8VNk/ihevVFmtN6IS5YkaXZQwMcjCbwjBI0Ie2pbK/H
X-Gm-Gg: AYBFou1Dz+SWNIyiolh0tALkF9/ynFdqRygPZIL0z5oxmhSeVKgkPaEsN3gITqLH/ib
	qNiuNchEeMZRBuQtDU6wG0hd9b4nhLFwd/OgzRz/s1O40mH2+6rpBtAuEoucaCTAR4MpB0IQbqF
	M9945BgVA0BJhHRlNjYpdc2ZWI0kI9CHM2ofjV72glv6Xi2oVA7GbfLuKsY61tjzlUIJvMrAIKQ
	2A5xhovlPQQ5i6j1JUmSmS42GbuJpDp6K7bUq0/98vn95gK+agI4/lKyWl0GNeg4jeQR6C7IJ/v
	Zx1kNYeWx2UzHDdo7u3HAY1vLHdh4Qot7ZBUJzSKDp9YYoQD8cknBehJnGi7JvZD3t+Z5R3RZDo
	BBgISfMp/U/a/PZJ+swCs70FLbJjtasYtmNHVFbse8wzUxpkVd2FiFUXNXg3hbyaRLDnCOjq2eC
	BCBwp0zZEWsA+N0mWQ0QNeveZvRXp98pKIzfe5ypEOftEPK8DqvMOl059hwQjF9ruFPoLf4HtqY
	ybsDMgeRzZ7Eykv9mMQHODhlq12OQ0D9Z9vrQTrMlGLO+KjB9WKEVEzhlXyMeIvO1uvJl9NzrwC
	v77AYq0xjar1+L3O0l5RVlT77jYseXGiV1D/ZI9uwfgzXlHRXvVhSP2ZeksKgl0=
X-Received: by 2002:aa7:c842:0:b0:6b7:82cf:f69f with SMTP id 4fb4d7f45d1cf-6b7c0ceaefemr1298014a12.41.1794564171137;
        Fri, 13 Nov 2026 02:02:51 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7c262338csm739270a12.33.2026.11.13.02.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:02:50 -0800 (PST)
Message-ID: <06b194053de4f4b65895248d1f2ba29d42a21b17.camel@amutable.com>
Subject: Re: [PATCH RFC 06/41] proc: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:02:49 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-6-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-6-4c998976c6c7@kernel.org>
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
> Initialize procfs as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> =C2=A0fs/proc/root.c | 4 ++--
> =C2=A01 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/proc/root.c b/fs/proc/root.c
> index 7fbbe92bf73a..ca0e75081934 100644
> --- a/fs/proc/root.c
> +++ b/fs/proc/root.c
> @@ -17,6 +17,7 @@
> =C2=A0#include <linux/bitops.h>
> =C2=A0#include <linux/user_namespace.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/pid_namespace.h>
> =C2=A0#include <linux/fs_parser.h>
> @@ -265,8 +266,6 @@ static int proc_fill_super(struct super_block *s,
> struct fs_context *fc)
> =C2=A0	if (ret)
> =C2=A0		return ret;
> =C2=A0
> -	/* User space would break if executables or devices appear
> on proc */
> -	s->s_iflags |=3D SB_I_NOEXEC | SB_I_NODEV;
> =C2=A0	s->s_flags |=3D SB_NODIRATIME | SB_NOSUID | SB_NOEXEC;
> =C2=A0	s->s_blocksize =3D 1024;
> =C2=A0	s->s_blocksize_bits =3D 10;
> @@ -350,6 +349,7 @@ static int proc_init_fs_context(struct fs_context
> *fc)
> =C2=A0	put_user_ns(fc->user_ns);
> =C2=A0	fc->user_ns =3D get_user_ns(ctx->pid_ns->user_ns);
> =C2=A0	fc->fs_private =3D ctx;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &proc_fs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
