Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794904346;
	b=MuyRkvlqQs3Y1Gjko+FJ9YuDSnxVh7JUzlFKTe5QmdnA1CoXih98TR9a8co7kM6UtCaa
	 dH6DhcBZyQbuhzpQ4LpgYWGAwG43DqxwHhofXmIeYgzAeoQcqMsVawtm2fonegIeB49Km
	 fu5UNxjoYOfF38NwDg9ep185p/NuAnJY2Dv7J+UnzL3Dsu+91M4egpvxde2BZkn+qGg1X
	 L7G3E2rz0p/58hDjWdCrOsKtY6/yJy2MwIcFbvuwV6wt7iDKFP0hMp1HhY4RWhbaMEdVr
	 LXsrVsIXEfJ7C6RxQMBGQR3L9U33+q0KLZfVVfBzNrkJz9xsRwuki40uIUfsG+VujXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794904346;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=iGZ2JImQ8AaSp09QdDpLN1PoylGc+Kk+7WphF44IQ4E=;
	b=lmg9z4yVjjP6pOi3zXLhON3Y7A+NA30t2fw2olKJOiPTO1/tNsFp3ie/96tKBf8rvn9W
	 q23rJYoOWvpmOX7yRzZGcp7KlbDkR9faC4jDtfq3ec2/ZJcX7kzfyglmCu4pLAfIK/FAq
	 gYFn3zNyPACmF7mlBrqzKqSrM7i7b6Q4rH5QGsQODXsBlcQN5Eq7pudKTVvlgDcGbMtUr
	 v+RwKbCV7IYKEdpj6LyQU6IYSLYfeqrQU4UEx+xOk92clJb4nW1LiDZA9bbVe/URV9Ggw
	 4mR8dBDhbX2wWJnhgjmXi0GG+zVcKOdWhupJgFOqSS6PhHhiqZ21vJ15Nn7+dWEEMGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=jPfu0DYs;
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA9E606A333
	for <ocfs2-devel@lists.linux.dev>; Tue, 17 Nov 2026 08:32:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DBA9E606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=jPfu0DYs
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-4a3e706b5dfso178009f8f.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 17 Nov 2026 00:32:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904343; x=1795509143; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=iGZ2JImQ8AaSp09QdDpLN1PoylGc+Kk+7WphF44IQ4E=;
        b=jPfu0DYsnhQtr/mqX/UMkNCVP5/36h6J+OzgxseJXEKFg2OSvwC6DciwjVf8p6kVZk
         SYcOS6EtexiH85saG11Xzuyvcim3gsYZwLTKGUumi2TT1qWkxrcCpGY0jQUY8x///OXU
         EVYmlDEHqjmiBc9KhnXU57dwEnlwoyvy7D0MytltmsqUm7UGakcMA43tRGtj1OpGzvYY
         2BLFZns4KvnUVMkKQ6+cjLD9zn9J2bumSnbI3MQAD6IKY/VIH2b71H7xZ0nQNdYpdgAi
         3lmiG0z7sp8azGKk5UvTpMQwuUp9uqSFTU5ElbSr/7K2IZVRAMpHv8IfEUdM/eBYHdd3
         b3mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904343; x=1795509143;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iGZ2JImQ8AaSp09QdDpLN1PoylGc+Kk+7WphF44IQ4E=;
        b=ZHX8VjE8XYvlGlLO6AGr07cYtqQh6u+oeXe6+XZ40yPXwh3ksA3wDpvNj/H7oDV7XA
         ZiO2UcNE2dL092BpjI/0LN4RcvNEVy6rMbfIHqloNAI+/Gsn66ID5eVHwhsJNlUze27U
         +bNglK3oBGFjqOydlNSodRtOo+I/LAeWcLrdvBkKvCTIDE/J/dHfOm1eZqEUHuDSi2Jb
         VxyzYm+7vMb6I8ffjzVKwstE/maL4T0jInWQkZRFOw72QcnXT3a4T7AvAp1+E100uyTo
         LRe94ZjzSV6B0OU9b+byUHmrHBBjWOI2mD4D/N03X1YkTBeMX5gLiwNR3Z8GAw+G/9e0
         H7rA==
X-Forwarded-Encrypted: i=1; AL+hErGI1kgiyp3FlAcTvFWEk0mDifALYY0UByxrKU0YP4GVKkt3FBinNdVFk6VT8r0KTOjK25lbvTaLS82nQw==@lists.linux.dev
X-Gm-Message-State: APuU4Z9hmMPJisdfjNK6gyrIErES792cEFqEiJRB6hWO9L0ijbn4zWwD
	wHkQqMfqb7NnX/5acS1lU/nB/b3nvYj7o19pH0NAAO2VuQXYfQsAaTmAtVTXptLB2Zcr
X-Gm-Gg: AZFdTZegCRf32YplqFkG0YTdcCBQJWMwNl8LM9uBDdpETVC/1vJcvDrMMHnieTpCOxv
	EaHlIHOVk2u3Dvo0OgN8LxEyh9zCz1R3GA+sJ6905+bGH3l2uvtlT1nDTeOJTuxoMDnxdg4ouZQ
	RzfodcWP7OrNUegthiJjSop33c7nOJk9PgHK9AOR4OJ3CPzHm0dQ6I2W82BEUjlj17csjgxXost
	iXl9KROJfqa47mhxzzzleky1VGzxR/SogkJO1l/miCfMsSdCXmu4JaSL5w3ZaZ9f1vUEPpu1UsO
	HYI+U6JWy1pg0RbW8lkbLC9UZYnFDy56bQWJ1jyA41IC2CS/1EaDs1p3SA1y2F0uAmqn0qDL/zV
	FQNMOXt9yWPj+cUzHQxzmcsf6hjcwiYZgm3iy/YLcHqcyGpp3p0U2HAJ3dE5kbdWMPlK8jkmdA5
	W0IDHlkg8d3jnfGVdAoSstbHianTrGcH26sd3awhLlx/fe0849TRH0Eh2ToYIBZkibBNWaIN1F9
	9uVR607srQ1ymVNBtHjqs//4y4q9WqpKsG9FPpVJb0pGYb/Fehgo1v9T1Z9Ej5o95BgmPGV7Idb
	oKVyM9FWnTws8vWLoFIKk4hWDnGTQu3k8KBudcJzHfl1lx0GaQZ9luLbuqxG2IaGXtVfvjDotGK
	nx1MvkGevieO4JFlBIdJYg/yqQTKUExV9pp2pmLzGhtW00JLP/ACyF9xZ
X-Received: by 2002:a05:6000:3108:b0:48d:f9dd:e3de with SMTP id ffacd0b85a97d-49c7353c415mr27089117f8f.45.1794904343236;
        Tue, 17 Nov 2026 00:32:23 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c608d10b2sm43646659f8f.44.2026.11.17.00.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:32:22 -0800 (PST)
Message-ID: <fd39200976086130cc82d59699a988fc3e0689cf.camel@amutable.com>
Subject: Re: [PATCH RFC v3 27/44] openpromfs: use fc_init_pseudo()
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
Date: Tue, 17 Nov 2026 09:32:20 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-27-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-27-8cbbea1cf34f@kernel.org>
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

On Mon, 2026-11-16 at 12:05 +0100, Christian Brauner wrote:
> Initialize openpromfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. openpromfs never holds executables
> or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/openpromfs/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/openpromfs/inode.c b/fs/openpromfs/inode.c
> index fb8d84bdedfb2..6cd02d456bac9 100644
> --- a/fs/openpromfs/inode.c
> +++ b/fs/openpromfs/inode.c
> @@ -10,6 +10,7 @@
> =C2=A0#include <linux/string.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/slab.h>
> =C2=A0#include <linux/seq_file.h>
> @@ -419,6 +420,7 @@ static const struct fs_context_operations
> openpromfs_context_ops =3D {
> =C2=A0
> =C2=A0static int openpromfs_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &openpromfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
