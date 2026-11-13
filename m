Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564840;
	b=kcwtG/Eec+r98M8r/tvCzfViFkrY7RvNJBJ0cQIgORvHSVFYO5+jZiC2CFwnkMHpQRN7
	 4ebt3luTKLani0cdYSnUKX91sw96r4xY8v1SHPoPJCuR3qQaufLtUkshlzEEATYdjzHSK
	 OnXAW1hsETkNFztE4vYHUXx9pF94g8Mwwz1wSA64C5qFOKdks51x7DmVFYK3ZPZF11W/T
	 SEDNtONBLzy+W3MavZ+5ENFhR8u7pp3VYKJUoRi432wbohrqmYMKjWj4tLYRP/hZ3E8IT
	 wZb3jRDKUlG8VqARc8kytq4qMnxnMp1aSvGAI/girrwdfcD+5P9e7BjwXUhERsUGhHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564840;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=LWRhkHq/o14g3eGvU8PB/2eVsiZ8AcgjQiitoPu4Uko=;
	b=gqTfSi15mIW7jmk4MB/OmT3Md6LxTggWEpVGjFTfACrBKLMt9+7wbiuiHYMXgRXDdzpH
	 PyGNgc44ipy/a7iVzWptPBwoIsT7d31AKULCSNIGUmLFI8e+FV/aFO7PSu7NjsY4KGT5v
	 GKD//klG7PYA7+FL2rGZO2irRw+89t6+5Na7Ftis2s4Li78h9z5WC28rZlJImAlyavd9t
	 h8aE+Yq3a51lIufNxGWHjmXl6HhTZMuAjVopfh4gM0oNxt6Ug/dTDccdOEiWow1xGi0GV
	 ewqoSDX9ixOJ4SuEWF3CDSSlvaivgHMHrHbd608fEQOoxw9iWFYhyQZiyyxekEfUCvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=VkmPFwxl;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AF5606A33D
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 10:14:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46AF5606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=VkmPFwxl
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48dee593f18so1055772f8f.3
        for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 02:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564839; x=1795169639; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=LWRhkHq/o14g3eGvU8PB/2eVsiZ8AcgjQiitoPu4Uko=;
        b=VkmPFwxlBt1DKCLk7Md5fLX4sExE7Go0YTW2KyJ3Ob+xcELI51Gh5kBlyEza3uk2CW
         2/BltvRAiDBCN1EanEp0V5TXUOPBojZ/0AmskP7ksgrYEBLZINv3oPPLN6dBk0PQHKvO
         eNO6bnwI73kRLHO5IgQoWQTWfDMrsisQOaOhi7paYOrkWbd1IvwmpIBJ5cWsUqt65JU4
         +yEvymNmPLliHA69w7R1xHWzwpXdNq8OK+bAuYJRQewpZfkioB1HnG4LEz7Dt0dLX/Ru
         ePSIMvsdbHb7sRM/LmdWTqC+di/we1OoAsFHrXsXAr3EK6Wu+aCaZYLtG8/7MLDF25fG
         kKjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564839; x=1795169639;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LWRhkHq/o14g3eGvU8PB/2eVsiZ8AcgjQiitoPu4Uko=;
        b=1udBe+htISsDZNzVP9Hk17K2gLLB20PwCGCGV2QqfeG9/NSz+mfaVn4vuRbNfcdhvg
         +YZHzn0+B7fQh9yD1CZ5W7Z7DsIafsLzlCAtLqZTxnNFqeZ2M6JGgNliIdBgI6dqXb05
         YbOQV0RjMU5ArrY0k+jTBXRb+Gl7skBshVZr/TyT4DRYIpHZ53l1u0ycGRrJ/DoW1tWF
         u+W4E0cuGFZ1X0g1awb97fH8YxkVgsd4xwTEFQJNzVktuZ+oPsROfQNu0KXIeMm6xJrG
         /DU9ZMlKsIIgYgSrIjZbPgwMGs2hbh7ZmtwITZo2Rv7EpbuALgcDzyiL1TPakgE9fnzc
         rzdg==
X-Forwarded-Encrypted: i=1; AL+hErFjOsOIADZHMZz9t4+1YBd+wuQHyW9yvlONlBR+sSDuu2xvSIoJmFMleLc8IqS4eedUsxDrSO3ZeXPcwA==@lists.linux.dev
X-Gm-Message-State: APuU4Z/V42Ekkb5sFpzTMTBb9JPq/c8+693VB3cczZDgtyewlpvk3of/
	KeoIgMFVjObQzE8RpFsdY0YGXhPIlulPAMIA2OtUjMMLn9c0iCVIMgpzdmYKxmNZuBCe
X-Gm-Gg: AYBFou2jG2elaLCI5JEEbonSYWcyZkchlrRrx6Jdajd+COV2VJuishNU0hYMr7NKxBu
	M9awSIFJZBueUKgVSfm4wB/fLTf6pT4YQiXL4AGkwuUEppNml9jHdMqNatXViQrNcoAcDeiEokS
	Fdj1n27WaVMm2B/OD67YW5AHkqQf4lIIQUlp06L6IZ7CG5Yl2omLMG/fAKh/OshU+9XrTpk3qjI
	KN+j3GtYmpfbgioECY65fZ8hiKInsvqTX/Mr9uPPFvDtl68t6bfu9MrbnLCfQoLht1XmvQczRFt
	LDNoXB896EvD/MFqEq/c65+anM0ZCEy+pgBH1PavU6pHBIyy1yn90a2yyjDS+Ox3ITKOSO//rcL
	N42Id9qyMidraLFBrAjSys3dziZGoRCSo9PxW8na/TRgYpeTWU3+nDylcdj3lMYMtK8HnzHHfSG
	0hPbo8h/v0zY3ZX+L+MchWcz4THdLW+7ZkNlrRENadqutskVvfnSH+Ir6cQfMn9xSWyDRO78Izt
	r5X5g5k4gEUn/eeI1rXiHVJV/OIWyCfnHYWbr+KtjyouTB9JldMtruNci90Bim6sajLUEptM+mg
	jS3pyHjnDgsfsMwxsukx+2OgGe9uBNg9o1VbX9I1pcrI5/NECnOjY5ZmKP62rgY=
X-Received: by 2002:a05:6000:993:b0:48f:bc59:ab9c with SMTP id ffacd0b85a97d-49c6fd932f0mr4358101f8f.12.1794564838578;
        Fri, 13 Nov 2026 02:13:58 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49d673ce75fsm190118f8f.55.2026.11.13.02.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:13:58 -0800 (PST)
Message-ID: <77855be3fb9f0e1888c6dddc56d73a1683c820f0.camel@amutable.com>
Subject: Re: [PATCH RFC 25/41] pstore: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:13:56 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-25-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-25-4c998976c6c7@kernel.org>
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
> Initialize pstore as a pseudo filesystem. This raises SB_I_PSEUDO and
> also SB_I_NOEXEC and SB_I_NODEV. pstore never holds executables or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/pstore/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
> index cf499ba72702..4658561cf90b 100644
> --- a/fs/pstore/inode.c
> +++ b/fs/pstore/inode.c
> @@ -18,6 +18,7 @@
> =C2=A0#include <linux/ramfs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/sched.h>
> =C2=A0#include <linux/magic.h>
> =C2=A0#include <linux/pstore.h>
> @@ -491,6 +492,7 @@ static int pstore_init_fs_context(struct
> fs_context *fc)
> =C2=A0	ctx->kmsg_bytes =3D kmsg_bytes;
> =C2=A0
> =C2=A0	fc->fs_private =3D ctx;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &pstore_context_ops;
> =C2=A0
> =C2=A0	return 0;
