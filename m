Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564658;
	b=h3upl9oTTv7GwbVAaLb2K+f6GZN+2RQTmxXxs0+VAHqoj584Ff4b2xWxSYu8zQob5HpW
	 7xex965U6e0g/MlTLcNzLCYItL7U5mdRvc/fmIVKOaprPTFjrn0rYG413ZuYhdujzZrlC
	 2+Oxo/JYkTiEmCViMxHJ3X8k04EUxFbkZegRachD7Sz1dILGr5wgJ5ihp3YS9bZ/voZcQ
	 JfwqGJPfDk1X4Elif/XwRveggOo8eZIOBI+Gh+Srup5Lf08tsk6BCIBbc5yvSVQZg8okK
	 aBdXwQLS3E2D01swffvQhnrW5XZu0f56+LwXjFSHxS2yZwkqX7fNtygWH63wCoEmEvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564658;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=RUn5HyOzv5zK74OCIfLVACQcizuS/sHn5qpIQd0Zvv8=;
	b=Abzd+BBhf+8TKP75J/3fS5RPE7ex3ooaBFmKHOEJttLy1cuzFk4BK0E9RZNPFKqbwe8G
	 NKfXoInRMV5RieuzZ/hf4TDQZJ2vhrTqZ1aLMR2dqMtPt7xaQgcHsxMEzq6kvkZfNt5rX
	 i2VAsyDFOk9ZJxAnD+/BaKynBG95gcQWCfdV+v/wPw03ifQwGcBMaGVdcZtg659CgtMSM
	 PzikDyAOdhtdxs2wFhMIslxtmJykjOIFGcb3MVmcjjOZ3eHL0o3CDXmh6Yhn9B503bkfj
	 5c8k2/Cthzf3vyvIjQlTv1B0mwFHSAoiA/l1+REGRlDNLQ7kWbi/JIpc0ix3bINWAqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=YyixsAnn;
	arc=none smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179BB606A337
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 10:10:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 179BB606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=YyixsAnn
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-490f38e9688so497684f8f.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 02:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564655; x=1795169455; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=RUn5HyOzv5zK74OCIfLVACQcizuS/sHn5qpIQd0Zvv8=;
        b=YyixsAnnapd/Rvl8+lSQ84+ZBeTkaw3lSU/fX19g+6gwoyuLlKK6O5pBNAaN2kK0V9
         pAlc9aYEcGEdP447rFkDIE1Jfd0MxIxafvSKI7iUrbOTbUzGnHFCBux10U0kAQl7l7BY
         jkYrYsh5ZRWlEgih7tBguRHpmMgebEDwJKuZFSbTgial0etuxKeuNofRZwluQF0x7ULZ
         6QIE6hE7AhwB/rQYo9lr5GVEbiXYUz2mqaVCPuVeqp3eEevDcFVfnkOvNsdKWxq0LeGF
         uNfgjgazNULaHD9VYriD2ZUPJJLdjenC8V76iDgDz4n8gl7Di+StEW8D+aA8weVhaPI8
         77VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564655; x=1795169455;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RUn5HyOzv5zK74OCIfLVACQcizuS/sHn5qpIQd0Zvv8=;
        b=Qgwqw8IxU/9/EDC3KfohWvW/2ebJYqLQXz0pP7nxHX1+Eyz8IEI4R676tDpccGNPfM
         rYjyVnfmHxMDebdzptvcTURrOAs30NPvkS+/9qde5F3DZiM5Jv6n8HCkW00MUSFFGkUx
         vvG6dVEjFv6MqoCv3qqkj80pIKXf9AByXXe0MfmB8/YijiAsO4ydtW5lAz+jqnj74yRQ
         xJs7or44YH6tE3xEnbhseUl+G06DpHIiIVaMsRb5sf8zFDrRMo804wnhztQeB+cG6gBy
         Bru9bm940EDx0INkxbmTEGS7Nz7gccBJ/yweGbtBolYY0pR9TOue51B6/GNWToP4nZjy
         +OVQ==
X-Forwarded-Encrypted: i=1; AL+hErHnC+bWR21E2LyaniXU3z0VkEA7gmZn1FuwfeoqixJzILxgIb1Gse/XP+91RwMYqZvsbFMowgO9/V1VlA==@lists.linux.dev
X-Gm-Message-State: APuU4Z+iMCrnSjr3dHgftPv0l/wykqElOQ/lpkhcd4y7ZbfdQvppqW4R
	NFImeEJPYK4L4FZUvEynC4fZfu/NSOhoIQoboT1tglwHYvXpGCmlz3/zu4ML8E1EL1in
X-Gm-Gg: AYBFou134GdK0lo4CAj5ORD2wJVD9Il5ftKmybchV+IUz2SBXfcsNr/KmlWz+gPHgM+
	/QhjGkfosU/BYSeG2UBv/7lOCkF/fgqHL04Jbh6XYcAsuOgbj1rVWRg+3t6x5/BEGMtuaty7AbJ
	WyPkIb0j0Hdm80jHdT8+MRSip14qzRcE+04aCCFK7SkNvZ6NiJPK2sCGOtwbYXfPkvSgXaFhRDH
	E+zAjzO95PRHX3musvCG0cu+KV2jg5jOMnJAR3rRCvFhlyPp0FCmDnCwPBtdXaEy8U76cRNf1qN
	UglJmCY1d4IjrT5L4f5Kz/5oYim+NpnB6afL75Gh5hEHfHiJbR8WQX1tzaCPfoE8J5uBwPfzK8U
	zGhAAi06Z3aI1KVmp3LfU3hSb/UC4/hwIGY7j1fEQCy4UC8cyTu0rwmUGSTLJTGOWRR0yTvTX92
	EoXUD/gdK2smiz+m/u9DCWGck/oiZ16iKwL8gV7hyh/2wd/UMZKAa9mMeBPtpawLdmzN5tYLB7q
	U/683y2tIEYnll26FCB1tvywS6qf4JrUd7imKR5VZ19seHGSTMwbK6ASlNPJHbyxOY1Dt7SBgEB
	8tljv/dDsDMwr7hkNrpYCb2tQ6lVQvQmYfjjENPtNb6orD2IBfTah7e9l80EY5Y=
X-Received: by 2002:a05:6000:470e:b0:499:ffd4:f519 with SMTP id ffacd0b85a97d-49b02d4c2cfmr11662822f8f.23.1794564655454;
        Fri, 13 Nov 2026 02:10:55 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5a32d336sm4988050f8f.0.2026.11.13.02.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:10:55 -0800 (PST)
Message-ID: <0894c601b3f3c5b92008c6c399faaa539b658307.camel@amutable.com>
Subject: Re: [PATCH RFC 17/41] securityfs: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:10:52 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-17-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-17-4c998976c6c7@kernel.org>
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
> Initialize securityfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. securityfs never holds executables
> or
> device nodes.
>=20
> AppArmor puts a .null device node into securityfs but only ever opens
> it via dentry_open() which doesn't care about SB_I_NODEV.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0security/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/security/inode.c b/security/inode.c
> index 080402367674..93997a9f16fc 100644
> --- a/security/inode.c
> +++ b/security/inode.c
> @@ -14,6 +14,7 @@
> =C2=A0#include <linux/kobject.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/pagemap.h>
> =C2=A0#include <linux/init.h>
> @@ -64,6 +65,7 @@ static const struct fs_context_operations
> securityfs_context_ops =3D {
> =C2=A0
> =C2=A0static int securityfs_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &securityfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
