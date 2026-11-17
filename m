Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794904089;
	b=O9AxuF//wUFB0NXN09JBoBu7Eho3J+J5MZq5WseDRRs6o7PO6X5CiOOpuR7kNo8Lzp+c
	 5F0hPyDhS4TwQVlz/B95efay1x82zaZGXt+8SW51KApZjP6K+5s60qbAROatgEsrc0gwF
	 8SjojG12s0L5dB9nxX4lZJ6DfSzF+xcheGis8njTYoanwblvdD0WQQy1m5eYlaNwTGVli
	 y1o6LiFsGcDtxXYxXl3XVxrmv+Y85/+JLSrKaL5woSkvn7MFipbrIPb9DNWcoyG/fRknq
	 yH4XDS2Q/GtpHNswlXudg7aTTQFk8Maib1zR8li07lAzVwIpG144jhOyOSPC7GCS3MQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794904089;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=AET1JHslkSzLNTOs00e5qdhXA33kuZnL+yhN5Q6hFHY=;
	b=4anTOXOWLzBQvAoKRvNl7qx83DE/KN0woPbxO3UVDs9tuGZp601s1PgA4GcljetWke5i
	 NFa1o+TLAno3kv3k+XFlhtvvvbdMpegxcl2EjZWzXhmp80dZ3IKquhksnN8EbjhvJ25ga
	 qK63f4vjvtcZPr5npW3qjCSVCI8b6Omggr1URlyEwjX1Z0scE6wOyhZK9poRXf6JtEBHU
	 6K1kaEv9rQ37SXRvLOdjtYDfFY7Srfo3bI7jLXWB8ZZk0ygDUNdQzhy3GOMNPNRsssejP
	 DciTVlgW/wNZev75vjBaF94W8gTPRGKssPl0qzAsoQUIqZXVGcxPIQOSBA4laEMftOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=DyCDe7SN;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16113606A8A0
	for <ocfs2-devel@lists.linux.dev>; Tue, 17 Nov 2026 08:28:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16113606A8A0
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=DyCDe7SN
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4bb6c7b6dbdso26232715e9.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 17 Nov 2026 00:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904086; x=1795508886; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=AET1JHslkSzLNTOs00e5qdhXA33kuZnL+yhN5Q6hFHY=;
        b=DyCDe7SNSyTjN7ARNq2r6DBLnJR3AnbwAMjqkw6oWWqi0VP+lt4bzcc+Biv2jt4pmK
         9FnByKXHpsWexx2uVZCNJSfWJppGJHWm+hjzckrUlZOVGMIKxJJ9gDZ1h2egBiGpIwWA
         ZKz/XD6orkSwQ1yi/OCHpiB8FIxs/Gq/lyWgk98W0rCPZa0b/WWNbRVUo0c7Zgr9FfuC
         pOJAT5nV2PusxKIwhzPn4VieWnlUK6zwsUKaRmUeGLqpe46CRxf3QCTkT7OxbuxDx47n
         kkqI6H0P7jtozyWX8pM5NeZFbJfKgZGvKaGc79eKEDTLu3HLvv3jOrIzbzAOQZxNHQb3
         +70Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904086; x=1795508886;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AET1JHslkSzLNTOs00e5qdhXA33kuZnL+yhN5Q6hFHY=;
        b=RY8qGeLD+E6cK0UFaVFlzslTAz4mQ63Gw+4wcZA8J6e1bzPXp/TkscoaeVXfpW3C2g
         41t7tko6VKqYLr9y5ljk52yC0gOfWhJBy9H7S5X8r0g9mQVhBjX7VCosxAGihxWAPG8R
         kG7PZpddrXrNdM9sXUzY+vBZ2cAK8SU0WvsidvC7qvZfO7U3NNrrro27gDcZLynFU/KH
         xf7nkpKOZ52LJHE31dngOnmry/IkXSHh33nBaQs1As03/3Jg/0WBCW7sHm+KKtajYrqI
         JP8iHmmrHOE4p/Wz9D82ZmhPrvH1virszOY0TJwfk9EhFFuQnUzZ5dfcUhC7vT/RlcOU
         o99w==
X-Forwarded-Encrypted: i=1; AL+hErEt0eb7rzBWURlKSx1khaUGI3TR1wPVa1nUhn8W5Km2YSGqe/uE3iCe2bDSTzWgZQXBcWWg9IWkg04FbQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z+S6A8mu7U7B5tvFX7TUo01BC1P1AlsrYoFspuUIPNzK78KczIo
	H8urvqihX6OU5uVNT97qvghwZR+l5jiBiOJkkYIzwZ2x+eDNqVmswqGLhBFhpA6s2BoA
X-Gm-Gg: AYBFou3/iE9Dimu9DIJLzmSeaFLj2ZdqJwRRjDqbLKtXkIyYSRO5YnhQSlU75PApbHD
	rfYK/pskSfVE+JsuiWJ6MAmeeO9nSxPH8KN2NRaJiZ/76Sq0x11lhDgcl4pwuRc45v0Q8qjBK/A
	wgztzYNQW6U1qkMht+lGRjbtU25gV1el6sFb3a7kUzRQARPFhvhOpaJmADVZN/8SzPRblXpW0ZN
	XZ0wd5tsmCaARGJOkCITra8CEuU5+YLVi8gzTVw4a0vRJPLMDO6eONDo9h9uxuPu1QD93jfhwo4
	m2YrpQPgapPoUQVibKod+sLrQ91KolZdxVU8LckJQg35UsufTS9s7i98EnyvtyZp9qywlL5NH8u
	lTv4XbFfWGNRokoQsq03fsAb5Gq+fmsTQXApYWV9Lc0a9kQ6BeTCQh3x6g0vkSmvqKZSLoTPnjs
	lJwJGqaz2Cb6iyXdS4GPDldvObArmLD2hleJ7hN34fT1PkT76bos9EawbrDSD3M4Ou1OV96knA4
	TDjx7ZGecxQ/uDmgVxXGwKAv8HpH/N+dBtFpGYLOIl1bZiqdG0aqtCMemB9GV53ggwfPrG1GemC
	64umZQb294kPHhFvtfPZHhmo6ijdoSabjazQvh8+ESS3MShFGwHoq2ND8YBYPQkHWtAwxEhOLmS
	g6F4dd0sD8GX4q/hzRXPaXB2uvGY8pZVcFY+6gVjzkRYS4NK9Q4V03qjN
X-Received: by 2002:a05:600c:512:b0:4a2:a9:ed87 with SMTP id 5b1f17b1804b1-4bb55a5aa47mr209766355e9.19.1794904086313;
        Tue, 17 Nov 2026 00:28:06 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb78418853sm74782845e9.8.2026.11.17.00.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:28:05 -0800 (PST)
Message-ID: <fa0ce0f7ecdbe91cc6773bcbe86be137d2129944.camel@amutable.com>
Subject: Re: [PATCH RFC v3 21/44] nfsd: use fc_init_pseudo()
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
 linux-kselftest@vger.kernel.org, Chuck Lever	 <cel@kernel.org>, Chris Down
 <chris@chrisdown.name>
Date: Tue, 17 Nov 2026 09:28:04 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-21-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-21-8cbbea1cf34f@kernel.org>
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

On Mon, 2026-11-16 at 12:04 +0100, Christian Brauner wrote:
> Initialize the nfsd filesystem as a pseudo filesystem. This raises
> SB_I_PSEUDO and also SB_I_NOEXEC and SB_I_NODEV. It never holds
> executables or device nodes.
>=20
> Acked-by: Chuck Lever <cel@kernel.org>
> Reviewed-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0fs/nfsd/nfsctl.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
> index f32311f2d7cf9..ce2666deddbd9 100644
> --- a/fs/nfsd/nfsctl.c
> +++ b/fs/nfsd/nfsctl.c
> @@ -9,6 +9,7 @@
> =C2=A0#include <linux/namei.h>
> =C2=A0#include <linux/ctype.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0
> =C2=A0#include <linux/sunrpc/cache.h>
> =C2=A0#include <linux/sunrpc/svcsock.h>
> @@ -1375,6 +1376,7 @@ static int nfsd_init_fs_context(struct
> fs_context *fc)
> =C2=A0{
> =C2=A0	put_user_ns(fc->user_ns);
> =C2=A0	fc->user_ns =3D get_user_ns(fc->net_ns->user_ns);
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &nfsd_fs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
