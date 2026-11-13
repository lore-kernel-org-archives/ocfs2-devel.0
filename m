Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564378;
	b=cAKmKU1DeXRhPSuXpupIjyKxvhOpvFPw6w6ZDO1lfwgxpzz1i9aLAUVEb4k7+nr6RNe2
	 lCp69zTom33B3utSI6xHYLziiGDJXRVgRRyyIhaeKvwmnT5ecVashfmC9eBKrT3xwIC5m
	 8agHqit9S6O4rDoRnRRQEVrTc1M8SSCDtfSlYUpB8L/x5LFbONKxGzVwT5TmtsfVVwMI6
	 aS3lTe05xkF/NRahxdMSyA+LD2hklR5ESnDF1WUvqnLdNcW4XNzVp7Cgq3O+Oq2lsg7wN
	 5jNf6pQNMMhnuiFnEIJuxR3JSJcUa4uMkbRL2nJ94o5KUfieTR9uKeMvMYHMmUNT4/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564378;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=oBVCWZMOabVq55k67Q8GIm9NBAOJHOxllLRlvncSbis=;
	b=QKdDSAtFTOG1h2UGVg/lk5JuXJebGnPuso0Lqwl0vOikjZLote93sWfrZBgPWv37UynO
	 C5ugvI+F+eYV3kR7VZU+gVdkuRIlfFz5gD0hMiikFCXj4+9IkmA69htueYPng01GbpN1P
	 ak8DnYUfs1nYbUc3aDbWdX1n/VppiqwJvg+5lrmaT1oSmYkYuHe1Um0Gla3TKWB/syGAN
	 sToHXgflZ+hKXq6bsHFJJMKeZzvKG3y8FjgWcPi+LDEzBfCK2zO0MBV7K5TDIY/agRrdv
	 /wT+JJUU2yWKtPsoLeHmDHkXHYg9vzsR4L8pZ4gK6g9uCtf2pqocJ+pEl05Gq5LeECA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=GgjqTCm7;
	arc=none smtp.remote-ip=209.85.208.41
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA53B606A333
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 10:06:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA53B606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=GgjqTCm7
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6b6e8b6d424so1596907a12.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 02:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564376; x=1795169176; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=oBVCWZMOabVq55k67Q8GIm9NBAOJHOxllLRlvncSbis=;
        b=GgjqTCm7Kj5MQFDKFqubD1FnGJCHeJvNTYTUuQ2gPiceCfH1RyQMlmD5DRF+oa/BoR
         BCdYuYqjNoInmO5e+o68ivjTe6m5iMAF+wWKmuQ5qo5ZTedHmBnbD97mBHzXq9tl5zyL
         6HzB7kynfUXQ1gQICGGSwSbb164cboI66lYa0zrHE5fZSQXzsu2i63guruX+a12jWTAB
         MmLnokqXzngoDK0e7I+hhbAD9ncEFvoN1/2P2Ha1Ev2o2Bpv5Jla3GWUmPGWvPfDMkI1
         UOCMEwjyYDO+RfZT3UJXeqjNblrjJ9zs1h6n0v05XtnFSpD18LDuYEzyI2Pt05y7bwS6
         HL2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564376; x=1795169176;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oBVCWZMOabVq55k67Q8GIm9NBAOJHOxllLRlvncSbis=;
        b=i83+1Q5Vmo7fGpc3vJCoRIQsVYtxuoN9kYvz/8N3wl9Wh0BR4ThHtnJ5q2kaETFB0E
         Fs4xNbxM3Rg1nYjeKXv7CDJ43TRo+RHzvz0p6SNDe0ywWYxMPYmuuwjMVImg93XSDITH
         F17D24uKTtGZ8UC36JlUmZCZrOuLfRpmcuksOBwQhEnIu/tVAVbiK0SsWvV6Wmh16+xU
         /6EChMV/g1sWTjflQOcOogrAAiDVUWYW55QKPyYJL8+rygjHh2gNAe1tJBicJqb8NIvf
         zt2xBdDtsm2LgWXhNSR1YTvfRAPgkQ1JTtNiVD3W9VeOCysFjAucvcFpi1KnyZ1HIR3d
         vv6g==
X-Forwarded-Encrypted: i=1; AL+hErHVjtGWugmKEr1+5kxg0hCwl1P2lvzDtUYOt2WWYLicQKt1BSCzitBl25pMjdsNBqUHtZWwDs2U+TuOmg==@lists.linux.dev
X-Gm-Message-State: APuU4Z8rw4tx7daLe0BFP0IuRt/HzwTFmEQg8OnKOl6Lm/8waVh2sXWL
	Bo/R5C6mHZ0hO/Y1kFbDwsryW+tNCxG6OginIoehjTCFNa40VMrW8bPlYc3koLtNDISl
X-Gm-Gg: AYBFou0XTY8lHk1tc2r/TlKWu9FtSW0pQvBT1orEokfUY6uWNqHialZNEH92V1/LkNQ
	WKevSq6TFVyH3RyYIMg7ZJZrq/twNAzXc0AnyCZoDvlPnYPhzBdZAqQV77rdcnf3P8miaZT+n2u
	TlFlQjDq/0XDMLWLdJtx7yJAGszWBnjhPpGMKmgv45OgtkNfPgo7OmSc7nSQk2Uf8U4eQfsYBOm
	1br/DrH2BtcrlkYekPwWl7zvrd78XLPLVTc8YUXb227mnkEB4W4AwOCwANkJLoPHzjXsFB1qfk3
	4dYYuotN706LccNjlpR3+BPAGugnOIvJJ8xKRKSYGiFGMsQ/QJT2yExBIactYl+HXiZ2vUZFNiP
	tvNMjVy7o4/PVYQkLkGRjRNCiXlV29jxGuHtArZZH+tUXMOSvYSHwAM6n0towfx6g0ONt59yqx+
	/l/kjkObAVibh4RNVPvHdOnRvF9d6G7aWwY+SJmoow88jZtCaDsOeLpQL+1NCxCTvm567aTC0/l
	n0C8Yq/B/t7RXhPFXGqevWT+xqpb/sBIrE5gQnkd0Ev2AoHENCQboTmkaa0iV7ob3hWfdpimtTv
	4gxcpjSGevN5wZv28A9xDd7uAeiZnvwgT3yvbI7jGWen1ZSRe5Ji4lE2osFjGz0=
X-Received: by 2002:a05:6402:280d:b0:6b6:4dcd:967e with SMTP id 4fb4d7f45d1cf-6b7c0bbc394mr1685420a12.20.1794564376161;
        Fri, 13 Nov 2026 02:06:16 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7c21b1b5asm706711a12.4.2026.11.13.02.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:06:15 -0800 (PST)
Message-ID: <4dfa19dd41ec1a202182284d9617926a259288a7.camel@amutable.com>
Subject: Re: [PATCH RFC 16/41] configfs: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:06:14 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-16-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-16-4c998976c6c7@kernel.org>
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
> Initialize configfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. configfs never holds executables or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/configfs/mount.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
> index d8cac1cbf3bd..60ba24e7ae2b 100644
> --- a/fs/configfs/mount.c
> +++ b/fs/configfs/mount.c
> @@ -13,6 +13,7 @@
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/pagemap.h>
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/slab.h>
> @@ -106,6 +107,7 @@ static const struct fs_context_operations
> configfs_context_ops =3D {
> =C2=A0
> =C2=A0static int configfs_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &configfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
