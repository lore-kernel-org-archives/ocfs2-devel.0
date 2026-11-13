Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564363;
	b=KhzSxyguMFrHM1NKPrdprXpAigI1IhF46G8rYH2PxS4bwXi/Wsr1a7xu5ZPqC/ekkbCv
	 Rc4YfP9kByhAeoZhWBdrdnRCnoU83iFFZ/03/GxtLsYT1qj3PHjZfH8SRv0LH6B/GRbEA
	 LtmJmFtdclFHQpXvqidunGd2/svOxf4eNEhOsxtlECTDN5nE8O6OyOK0BKhJ+zjczSD0s
	 oPSpFWr5/YRJt7wKpFVlcCnMKvLEnXPpWWwWV7altAyDB7rjtDPVsyB/UFXz4qmrV/IdR
	 st/XuBEQ5jToccP0i7x0jqoSpGiFPveSx6ffiaG4aYhM7Jk7wV0XE+CjwUJ3fq4wzuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564363;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=TjkCmA8zoLhZK8u7U4HhR7QcElVzore/o+jClE5BdRs=;
	b=sTrmh+jAIIjbL6buGuxHjm4QOeUxEHNKgU5ADeU5M0I2tkUg7bk4Tw0wMfEK0Vv8F2gC
	 s1H8wagwLsaaREu+basDdwj2sX+8qJmI/4DzcfGgATTSjEMRmA0maZbmT3MVm+IZ+oJy9
	 Fu8qih8qBDLXNOd80aIUJcF1PcGiKTuYULUPsKqQEv/g5Bp3KQ/Z8PJ3/yT+3guslgULA
	 0XEe8NbWF+U79DgJsM4hfTFbrI3r5fv9lls0M17GZC9dtUzv2+LG2cxha1m+sLbFoVc5t
	 UFMwhxzXYZYkQXWLHj/w4nduxOPkvb0VQKbCjwe4KjGg1KbEvVipcvg05rZ9nrTzIyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=XkasCFgR;
	arc=none smtp.remote-ip=209.85.208.45
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF7B60A380B
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 10:06:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1AF7B60A380B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=XkasCFgR
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6b587591414so1168102a12.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 02:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564361; x=1795169161; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=TjkCmA8zoLhZK8u7U4HhR7QcElVzore/o+jClE5BdRs=;
        b=XkasCFgRcW2n/QtIYXNSvlZBXNIBBsqMLGJuJmkERtFMR5+6z0hqHlKgD/xMArveUW
         J2VXj8PiVwQ563gSQKA8C7zD1fnQ6Z35WpYPA65ISHAeJr7NugcLhnhIpruuH2y5fXWE
         GCouy1L2EhCfo93wX0075MjqQecCEYGUhFZPMB+ht3XYgLTPxWRv5+/LxJIMNRojVtnb
         n+dz5X7qgHwxsAu7bmUE+fDNj7BJNQ2r/uCX9NDMfa6/4v6bkGqxnd/26Ch3aJiF7soK
         OlD2oi7cJ4f8SSw4zxIykCl7xjg4Aorga6OmCWorwRAb3B1KEikWq4Ep0Qnx4WWbTfoM
         Qu9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564361; x=1795169161;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TjkCmA8zoLhZK8u7U4HhR7QcElVzore/o+jClE5BdRs=;
        b=YdL/EWvYF+T//av7To37XlJvADBG97OQtEqxBVR0mOxG6lM7dtNVEqij2DB/Kvn8On
         j1H3EbA+4j30vjCEnVILprKf4b8ZZPTh+5MtLQ7qrcyc0eDG0ew+5zHL26gfkGbhZnOj
         68RHACOuqvXA2JMwmnG5dA83YtCurth3/2iP1buLvN/BkauDTHPB6fUx8/EvSAPaUBgF
         yFYMOvhz8Dy9flsQAk95lOl5l+L0mvSjEIH88ab6UlL84QnkWcMoP22IuvUxtc+Gz6g5
         S27FpcxZOpJanJgq6Ak9fyr0WAA4uVlNQEOMRSUqC6HH7NfNj+uAgYr/YUkjjw+k3F+F
         YPFw==
X-Forwarded-Encrypted: i=1; AL+hErGTM5NDyJJcKWk0uIw+NZoYRPWo9Rdfji+MUMktVQhxzpdQ38IZpPNvPJ6jRD9x7gLTKGXg3N0fD9waOg==@lists.linux.dev
X-Gm-Message-State: APuU4Z8V+N2LPseDT2a2nQC4fR9H4fMyU3XpRd95sBQ3bHeRpC9Au421
	fs33BN0iCcrLHaNkp8PWH5/FHi8aayYQ3I38bgle/zkLgEnns3tX7mB1PRUymXqeFJ93
X-Gm-Gg: AYBFou2d/sd1rAeB9ZMXKa0hfq5wUa3NQSAQ/joMuOyGy2oPCcUXw/AvLvIXIOgu+iR
	TayzzZZgf/5SABYU5bsXuSZUqe05RJWrqtfXCfGLdsdTUrx/7I+l4JcnMgAQTTFL/Zsv9R5DyjG
	PXydRCFAmNLTth3/sXxbvuZkWXIMW8j9LBZOTvV/PmAE9coQn8Czww7QlAVpb4N2i6acL1aXSlf
	3kHlLTE5Tq8iSerGJevmmSfWlnzhHOW2vlvB3v8CrMy5IYLeRCSzmCGBls0C9s9sAsC2djES5AH
	qQ3NAQTL1HrU/s5Xi/p+xX+Cij2a96JKG0lcYcS0B4NRkxIUkGMaxSGcIXk3qEEekX05hvtGq4+
	NY3NBNhIOj+JgL/C69Dm6wfL5zLzInjLrBPCCTjL0gqaq5b8/2+E5Eda/MYmb+tgmcZW/4s7l/Z
	1WZcGb/OvXQzc3Cd+VbBzspFIwBDNl1pN/2Px0cO/6DYZLyYruuvn+2sUf6wmIp+ZVbwcT84yJn
	ITo9HSCLW1Jo1el0L0dMYYbwNiSvOfMoi8keOt9jVDO/a74s7noIzOhifKSKwlPtkn/UJZdQJaf
	AhGDRFwnVyLxSBfdjECPbQyzGEsFEju+8C5sYSWNPBCFcpeR6XOqKjdNokapGfE=
X-Received: by 2002:a17:906:ef07:b0:c4d:5820:325a with SMTP id a640c23a62f3a-c50963dc627mr169588066b.39.1794564361325;
        Fri, 13 Nov 2026 02:06:01 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b8651bsm73693366b.78.2026.11.13.02.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:06:01 -0800 (PST)
Message-ID: <e8b71a2778d7d7797d433e7bac1a37ee64aaa30c.camel@amutable.com>
Subject: Re: [PATCH RFC 15/41] tracefs: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:05:59 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-15-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-15-4c998976c6c7@kernel.org>
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
> Initialize tracefs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. tracefs never holds executables or
> device nodes.
>=20
> SB_I_NOEXEC also refuses PROT_EXEC mappings. The only tracefs files
> that can be mapped are the ring buffers and __rb_map_vma() refuses
> VM_EXEC already.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/tracefs/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
> index 5020365ca704..e04febd868eb 100644
> --- a/fs/tracefs/inode.c
> +++ b/fs/tracefs/inode.c
> @@ -12,6 +12,7 @@
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/kobject.h>
> =C2=A0#include <linux/namei.h>
> @@ -510,6 +511,7 @@ static int tracefs_init_fs_context(struct
> fs_context *fc)
> =C2=A0	fsi->mode =3D TRACEFS_DEFAULT_MODE;
> =C2=A0
> =C2=A0	fc->s_fs_info =3D fsi;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &tracefs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
