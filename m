Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564223;
	b=itlFeDtPPIclVzzk3XEGCYMF0DLO2XxppQyon/ozuGCXQCtnFeaIdCoVX+lhHIwm16Qb
	 /FUND44LEXA3hdjLYIEpXJ+ClJoNpl6MzxUIfhbxvgXXO7cHNhsT6Xrp/v6/6cEc+KVTA
	 opOjyU+5cajnTLcQfi5+WzlX7FfpC2BGhJp2Uy9b9EBjfRiwYWJZojwmGO5TvC1KjwhZz
	 C+Khz6qo6u/7mXhzAhkPEmAtSZpKHDdKdgVfLkQqRJsE26uPHyEEyURlDMAdbXJxoKZ3l
	 RFDwT+Dy/wBAYszELzTKp4w4txBwzSP3KkWW8iZfejqVB9XgJZRrIEWBnd6tN7AbwNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564223;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=6cN8hpP/bnwcYzPsZf0cUkd2pk5Vve+UdRh8Jmnig90=;
	b=oG25jGunX8TdTpA6IcYzd+Ot2SrvEbkCSNaMX+o+2u5OWlsFKgNjEC+yMaXxH37WwnHh
	 TmJZBoEgQ1/qqejmbWvJPnKMcoRbAPVdhMYN4yB9O4AL09CgDppzHrdj38KJRXDvbnxgp
	 1uUx4wfCLfxbkZQluA2nR9/6IctrM4cFaqmVTS7uiyI6k+Zms/BjSe4OqjD40THPKfJlY
	 jURVSUY5jofXJjWh1Y8MgxPCY3ldhsL9/oGnGEFPAMF1jVAVQ7OJBSM1LxFvafBcGwC/3
	 EAfHhmSFp1QwpTQTk19rvyxA4XpkGbo5o6OjTkNjPY8j0fw5Mra61H0WHvHwvYSSImQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=XtuCWaLL;
	arc=none smtp.remote-ip=209.85.218.45
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B899D60A2625
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 10:03:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B899D60A2625
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=XtuCWaLL
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c40e30c26a4so170618466b.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 02:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564221; x=1795169021; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=6cN8hpP/bnwcYzPsZf0cUkd2pk5Vve+UdRh8Jmnig90=;
        b=XtuCWaLLAUoCtElqLw9E86siXVko3IcX4qHrEQxR3JZFiSsawLD3xX3F9uf5lYAt9U
         AbtcKddMjY/VftVZiQCEsBXnAfLOhTF+EpjgT1Y4TIpetDfk5M8i9CRBaJvnJj58BKs1
         Kv1Wlmqebr8VRi2PSEomcIqiZgj7JIHzj3URu6Cl7UPvQ2vwMZnHNylK6Ev1S5oEsbt8
         u8ZUtX3Wd9oQ/jS29tNjadjzts9S5qAYd4YlzuU64KqaJIYLkIXTEiZgJSxv1HqDyDHE
         K5bOa7vLpK9aipWx12gX6rqhtyGl1gzN6DJmn6PMwbnLbgG5LNMcLv8fOQZJV4JR8WhQ
         xMVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564221; x=1795169021;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6cN8hpP/bnwcYzPsZf0cUkd2pk5Vve+UdRh8Jmnig90=;
        b=2pyerhbNS12pURRUnpxVs2XQpp1QVZ/ROQae93j1L4MaeGRJYls/JpTjpeG+tj7F/O
         8Rn7XTLZ04FyBty4V4Jvxmrt1GZiiN4hSk3SVCNho+ZMp1/BlOXoYphDO5vxcb2zUNRk
         PR+30MGvbOB/cb23KFYa3bdPpOCHwphjl1+n51K+tU4a2DaZKDeWuwnPVJyoOGvKrDX8
         /rGmcBqZJrRxmvIEHXA1tY0+RavvPOOqugjSK6F/6/tETNAs7D8qE8uYvH0gPFHTO3bz
         NTHvwgHuApVpAwRgT5AxMZAewQ/ZNvkYc4jdflPa+gdBOAkiiP89siWlY7KmWWkUF8t/
         28Ow==
X-Forwarded-Encrypted: i=1; AL+hErHHFWDnZZpQg7t61qX2qnlTpnWeVTUPoHAJnUTZ/bFW5J39eh1stISQbNMhaNSq10rbt6D2Q/Rqtr6u/Q==@lists.linux.dev
X-Gm-Message-State: APuU4Z/4nbEx8QTOk81frl7SeOSZs5WosNSqNQhr1OFQQtuclvVOzl9b
	XRUBKnjX8YHw11N/w2O3LDAR9yBh5zhw57ZZCGgTe+QDJ4Aes4qzgFfo6ID4ktONhIfd
X-Gm-Gg: AYBFou2Mxf1jfCpuX9IPxUudlGvGMKUSAbUIS0llZCj79qM+aY4hOZY7BMbTkhab0Zl
	o7nBi8QVUnA6dfCtJTJj4jzRkfqAsCRf/XJzkgo5xyyF7PZoF48ih1KJSJBB3ePR8107NbAGP0J
	0IF6ExiNbdIwD4Kyn1EOjDNFUr6CoorrjAni6tClsf3Ou2Q6qZyQfxQuBJ41leWRaeLBCiODSUK
	/5JdTac+nraSbU/i1oh7UbAKMr6VzBgMYaUC1xTddKAa/a0evUt6wTPG0XxXVUaWQB5cEeDLrAb
	eqsgZ9QDvvArFe1KZN/NFLVwWr7dvubhR38wgnZzWNeKnXVxDK/6ApUyT8bNbbTv++ZE/yWc8Nd
	1wmxF+znOC3yHPiqktGO9ntOhtzHGs1ENR/5+tAiPdNpXxET+0dI3sA9FiZ1/MFdpXYwwHa7fgS
	9CaEgywadco9flk59dtJpKiPQwOgf99IOQG842LF3W9OBl8HstGJd3/AzXEX2o3rQ0n/M91oGm8
	bEQZf9e0MAz6jZcRhak4C044vf/u1jtNt9AkwpQ+m2CGLHX+YFM8Pt4Io933Kru9rBiKAU8eQ+I
	BLKxU9ULHx/JKHMeY2pu9laXOyzSir9Aw5vMBinUZhHGEQIEOzNLOwLnswuGzWQ=
X-Received: by 2002:a17:907:7b8c:b0:c42:bc58:f21 with SMTP id a640c23a62f3a-c50963856f2mr175546966b.15.1794564221164;
        Fri, 13 Nov 2026 02:03:41 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b23b3asm74752966b.27.2026.11.13.02.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:03:40 -0800 (PST)
Message-ID: <cfcbef5caf7651b63774549fa1999d34981c78a4.camel@amutable.com>
Subject: Re: [PATCH RFC 09/41] bpf: use fc_init_pseudo() for bpffs
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
Date: Fri, 13 Nov 2026 11:03:39 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-9-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-9-4c998976c6c7@kernel.org>
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
> Initialize bpffs as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0kernel/bpf/inode.c | 4 ++--
> =C2=A01 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
> index c6f328e4752e..57cf3775c076 100644
> --- a/kernel/bpf/inode.c
> +++ b/kernel/bpf/inode.c
> @@ -15,6 +15,7 @@
> =C2=A0#include <linux/namei.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/kdev_t.h>
> =C2=A0#include <linux/filter.h>
> @@ -1197,8 +1198,6 @@ static int bpf_fill_super(struct super_block
> *sb, struct fs_context *fc)
> =C2=A0	sb->s_magic =3D BPF_FS_MAGIC;
> =C2=A0	sb->s_op =3D &bpf_super_ops;
> =C2=A0	sb->s_xattr =3D bpf_fs_xattr_handlers;
> -	sb->s_iflags |=3D SB_I_NOEXEC;
> -	sb->s_iflags |=3D SB_I_NODEV;
> =C2=A0	sb->s_time_gran =3D 1;
> =C2=A0
> =C2=A0	inode =3D bpf_get_inode(sb, NULL, S_IFDIR | 0777);
> @@ -1261,6 +1260,7 @@ static int bpf_init_fs_context(struct
> fs_context *fc)
> =C2=A0	opts->delegate_attachs =3D 0;
> =C2=A0
> =C2=A0	fc->s_fs_info =3D opts;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &bpf_context_ops;
> =C2=A0	return 0;
> =C2=A0}
