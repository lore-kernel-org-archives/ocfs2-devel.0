Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564141;
	b=cZvG6RMS0BEwrySN2jZBqR9xshAQu81r6ksvkTmXhQYE38CO5yRoQY+nJ3oyXfgskLd2
	 uzj59AF+0QMOegIVaqVeycgfdjsqL7ctWh6/MJnZyu6h5ab1iVSTSO2bvJ47dT11iH3PY
	 ox98N7fXaKAJQkUf3K51mNTn2mMIcf84cYFg4lHCGa2tvcGIuQhuMg2dgUuP3dm0A7au7
	 Ci6PLRnyj5uwQMc2ALN8EuG6ybvEPlYYLnleanMFsG0gHXBl9LzLke1qebfE0j6yRFcpw
	 x2oCFB6buNm/dRT6w4y0azMrQX7AzsOcy8tEMeFOYaJ3NtApPrLZyE/P+rcyJ+OWLFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564141;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=Ee4ggwaa7pvqsvjnONVsvhhjx7Blw4b1QTFG8P7u7TE=;
	b=kj3NqyFZ79FKo9LpStSApxUuyn1S5+0jF/QCMmp8HskEKfaSDgi568LLnKL/CsahUgd7
	 HOk1xq3PRAUU/7sziswlhIkeXYFJejJB14YpmlChfkNQWgQm9c5rUWMAH85y9w3vz/4gL
	 lQ3Gj1B5B62ZwjOTi23NQdMDJJpAiiPvVUSGkmQkGS/z2QViwmZp7kGyJg7ZtPFlR51x/
	 8Td/1uk1HA2vwPtpljgE7UaopZm4WKnUir6Q6zL1Paj63YCNM29iKGU/w4woP23KOxJ0x
	 nqOVesJ9EI5inwVToKabudASLyEMqVTVr81rO6Rk/XzlV78ry8g6EU0TLjIcJ668SCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ggJN0w7o;
	arc=none smtp.remote-ip=209.85.208.45
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA83606A334
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 10:02:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EAA83606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ggJN0w7o
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6b70880c0a4so1097610a12.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 02:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564138; x=1795168938; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Ee4ggwaa7pvqsvjnONVsvhhjx7Blw4b1QTFG8P7u7TE=;
        b=ggJN0w7o4OBGyMU0n0Uw13SgI6jYSwEIOuWiy64uSAPbyZySLGT3tf0UWrZ9eRz2Sb
         bOrkDXu8pRz2peCHlKWysnlK5aS6x/Bc33hvYKz/AOx3zUDwL8snp5pVvni9O4m2mmKw
         1Z6JBPykfuzGFof/fsPq3noEw7kBFmTr+Jrgkscu5wsPZ50Z3g9kVh9Bz5P8Zofw8ecQ
         k+SNcRAw4KlUB227trMMXjzYDca9vvgTYmHeU/Yon8GX6ieRzNytvdnE6adYjKHS29JF
         qEYEhzyk46psYTkndGQ6nz1/Mg0lMmsnlszdXqq8BDqqFteqwF2iogFLXUTun2QW1M6P
         n4Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564138; x=1795168938;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ee4ggwaa7pvqsvjnONVsvhhjx7Blw4b1QTFG8P7u7TE=;
        b=gOO9Uckn87D+FQ2XEzl3oOpJaLhjR3/Nw1LrJiNe4BHXQ9nEEvsbd4JpKaiXl3WYzO
         N5hhy4nZjvee6KoyAurKUD4o5ImtRiBFh3wluXjK91uLyaGs8gxss4tJwIshjCviphfB
         JkfqcyrrEdQEbrdsW3Zo6sFgpM/pmfhZXidjtQSLULI5lkKFJ0FCJfOFmMixPqUnvxGY
         g0snmJtyD+XiJFNRLswZwulFuMyiPDBjagT0YdyZahG2N9Ls88CIBSGvFg0gyIBlKGXW
         mmTxv3S/7euarZnhDv6WD8qL6ZxXACs8YYO2Sle7rzzjLsr/5djYKDYhbXu4dELgmYl0
         NfMw==
X-Forwarded-Encrypted: i=1; AL+hErEw23y5zVOs5YfU+jGESyjefCwkANgSEEKHz7Lxx4QdsHcRknKsDZZdpxVOsi+xOLOsVpwfgldJKPwUAA==@lists.linux.dev
X-Gm-Message-State: APuU4Z+syIgxocpewAL+Oo1257ZLt35/zJrbSWVl18rLZugZuhSAlCAB
	9WqKWjlNq3lWLe55A2Us0s3pbygDZMo6/v+VrjR564DT/Z0PQAZbHk2Dyz+lEq/P4peb
X-Gm-Gg: AYBFou00TtjzYgBNyfnoxEiqj9MsMUs3+CT2cbveZW56hck7eXQg7h2oZ4KiCEo2PzS
	9vSCt4EOKoZCFTS26/LiaCER0NGmnMKv82jWRtidaNUVsyR1eTXdSjFoWIdIovFQ19d+EnSSmLY
	KUxPfCItxkNEmZ9Y0evuzK/EhzrNXke2eFArnw7MCBaEVfLGaCZyzbx2+tkJnDLZkIvtKwujcG6
	mbGhzkMrc+uLhpu0DZP9mAjfjV6BZFH6ARYULYvcUL2xOeQZz3kcORfKaoPMWUHpdAcIhootJoy
	pgojgNRxg4za8hWZ3oGdE2H42bni6WRzBe3Dl9Ank3zc+Lx3bZoZKLjmErByrcdv3bKXLx8Nqur
	T8hknwpXcyqDrEUiOBZ6/LIsxH9EGzdV9v90/0Vy06lKrvctILbgWBts4ySitElz3sDa6Xa2Azt
	OVvKmae3G1sOcsKFMbPM3PK5Y99qetZzCJZtrwZrSmtf+QhEQp/O2ICAXYPtm4DSOYxgfwRQOKH
	0lvCSne1sbbTWEwp79y7oihLNDJaHLpxx91Qd6R/Rd3Qag2omqmtsTswqLLBsuW543x8O7Hwu7A
	lpoBdieo542KDQm33JGgyHez6Wlzq0VM9DyCG05DsLyPhZ93D74tVlyFyr7hkbo=
X-Received: by 2002:a05:6402:c4e1:10b0:6b6:eefc:ae7a with SMTP id 4fb4d7f45d1cf-6b7c088f8ecmr1236733a12.4.1794564138223;
        Fri, 13 Nov 2026 02:02:18 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7c23c672asm734155a12.15.2026.11.13.02.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:02:17 -0800 (PST)
Message-ID: <f4ce8239f22046e90cf4807853282a570c73707a.camel@amutable.com>
Subject: Re: [PATCH RFC 04/41] fs: add SB_I_PSEUDO
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
Date: Fri, 13 Nov 2026 11:02:15 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-4-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-4-4c998976c6c7@kernel.org>
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
> Currently, there's no way to tell whether the files of a filesystem
> store data or whether they are kernel interfaces. Files on pseudo
> filesystems such as procfs or sysfs generate their contents when
> they're
> read and writes to them are commands to the kernel.
>=20
> But a few places in the kernel take an arbitrary file and use it as
> storage: loop, zloop, the nvme target's file backend, the scsi
> target's
> fileio backend, fuse passthrough, the usb mass storage gadget and
> erofs
> file-backed mounts. At most they check the file type and whether the
> file implements ->read_iter() and ->write_iter(). That's not enough.
> kernfs provides both for every sysfs attribute for example.
>=20
> Add SB_I_PSEUDO so a filesystem can state that its regular files are
> kernel interfaces and must not be used as storage.
>=20
> Pseudo filesystems also never hold executables or device nodes. But
> currently each of them decides on its own whether to raise
> SB_I_NOEXEC
> and SB_I_NODEV. Some do, most don't. Add fc_init_pseudo() as the
> common
> initialization point for all pseudo filesystems that raises all three
> flags and switch init_pseudo() over to it. The following patches
> convert the mountable pseudo filesystems.
>=20
> Nothing checks SB_I_PSEUDO yet so no functional changes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/libfs.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +=
-
> =C2=A0include/linux/fs/super_types.h |=C2=A0 1 +
> =C2=A0include/linux/pseudo_fs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 11 ++++++=
+++++
> =C2=A03 files changed, 13 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/libfs.c b/fs/libfs.c
> index 96a6e9b1535f..8c8789489fdf 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -735,7 +735,7 @@ struct pseudo_fs_context *init_pseudo(struct
> fs_context *fc,
> =C2=A0		fc->fs_private =3D ctx;
> =C2=A0		fc->ops =3D &pseudo_fs_context_ops;
> =C2=A0		fc->sb_flags |=3D SB_NOUSER;
> -		fc->s_iflags |=3D SB_I_NOEXEC | SB_I_NODEV;
> +		fc_init_pseudo(fc);
> =C2=A0		fc->global =3D true;
> =C2=A0	}
> =C2=A0	return ctx;
> diff --git a/include/linux/fs/super_types.h
> b/include/linux/fs/super_types.h
> index 72f4288e16c5..472200bdf081 100644
> --- a/include/linux/fs/super_types.h
> +++ b/include/linux/fs/super_types.h
> @@ -359,5 +359,6 @@ struct super_block {
> =C2=A0#define SB_I_NOIDMAP	0x00002000	/* No idmapped mounts on
> this superblock */
> =C2=A0#define SB_I_ALLOW_HSM	0x00004000	/* Allow HSM events on this
> superblock */
> =C2=A0#define SB_I_NO_DATA_INTEGRITY	0x00008000 /* fs cannot guarantee
> data persistence on sync */
> +#define SB_I_PSEUDO	0x00010000	/* regular files are kernel
> interfaces, not storage */
> =C2=A0
> =C2=A0#endif /* _LINUX_FS_SUPER_TYPES_H */
> diff --git a/include/linux/pseudo_fs.h b/include/linux/pseudo_fs.h
> index a651e60d9410..0ca408aa60af 100644
> --- a/include/linux/pseudo_fs.h
> +++ b/include/linux/pseudo_fs.h
> @@ -2,6 +2,7 @@
> =C2=A0#define __LINUX_PSEUDO_FS__
> =C2=A0
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/fs/super_types.h>
> =C2=A0
> =C2=A0struct pseudo_fs_context {
> =C2=A0	const struct super_operations *ops;
> @@ -15,4 +16,14 @@ struct pseudo_fs_context {
> =C2=A0struct pseudo_fs_context *init_pseudo(struct fs_context *fc,
> =C2=A0				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long magic);
> =C2=A0
> +/*
> + * Common initialization for all pseudo filesystems, mountable or
> not. Their
> + * regular files are kernel interfaces. They don't store data and
> pseudo
> + * filesystems never hold executables or device nodes.
> + */
> +static inline void fc_init_pseudo(struct fs_context *fc)
> +{
> +	fc->s_iflags |=3D SB_I_PSEUDO | SB_I_NOEXEC | SB_I_NODEV;
> +}
> +
> =C2=A0#endif
