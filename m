Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794565649;
	b=sEB8bMTZ6Jed+mkZHCFFqIsIow5KYBU8vQNBcvp8SXJWf/4i+shMZotKKZ1AMRNok9A1
	 UfiY33/osbpQ/rcM+fTLXKgNiK9+HV1P35sh+Y6GT74fCf12saMB+6yuoiZuT0/Ql4iwy
	 dQdRCI7hsrtRrlfJK1uegVRws76Gt6n6XlUTlxcXooxuNQuxs7sch6XKCTv8oazlGu6RA
	 50W/ck2Q16dgAAhIoxe7qZtH9MtqfziatqEpWVjI2L/GH4Rs3jnvUX07xSr5HbP9gUKcn
	 6RnFeXvN2dCDXif2Hoip867jaR42Yn1eXdj1yB6sUFE7VKT+dOMTjEvNmhZ5W6skmaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794565649;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=TXY31nY7nMCHyiOZTp7Dn0JSWYPda+tFg8CPAdTq7II=;
	b=jBx/N3D/Je9vVfbqNmrOByFPTYBEll4mTLrrS9T6olg1XT4SLXnqWzakV8+JbV/Wyqau
	 8cGRqKoxxno+RUKv1h5+A0Bn3jOEuxmo4SBaC6Rz6nC8NiZzhWR8QOXkel9WucsiiwtS1
	 NBbsT4/CLxkGDHwGRvPn9ydjOyKgpy5mIZgnbPYtyfyobvl7H3fxF5JehtLFBLHTHBg4i
	 XvmEjHWc26VQbQr2imdrMgWtOz+0xWcWCOl+htTQ/TqHf7HZubp3wVGYvfYs99Gddm8lK
	 +wG5LJlh6jLNzFpt+3Xl2Xk+H+NGnPhk5iPP55+A/7NKkpGzQod/XprI+FR64oal/GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=P2Ovnntx;
	arc=none smtp.remote-ip=209.85.221.54
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E8F606A338
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 10:27:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56E8F606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=P2Ovnntx
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-491846221ffso783337f8f.3
        for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 02:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794565647; x=1795170447; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=TXY31nY7nMCHyiOZTp7Dn0JSWYPda+tFg8CPAdTq7II=;
        b=P2OvnntxZklgGup/ZCAKqCiR1BnSGRhZX++h/K+LxEVACpcdsdiAP8aEbgxELzDp04
         fyqJW0hKmvcMvXAUsmAZq5rzuw6DOnAzSl4En1EX63jjNTRhhcRQjMKZEBsvf/yY6qjh
         aQSM+biz1Od5VE8AG0xfPooy3uuM9dKpCM1lc6NyGrPt0pcEH8r0yCoObFji3GZawpg6
         59buDiramCqFSt4U3TQM0Cjf9uaOHjxU+0RLkw+vlWOpzT9FFabgSW0bIGOjhv+0APjP
         RLKwx4XintCLJCvQbx6tUNVbtWObeEbkkD/kdoW7bz1WNnoVmH9V9zbAonV5/31qWhTC
         JFeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794565647; x=1795170447;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TXY31nY7nMCHyiOZTp7Dn0JSWYPda+tFg8CPAdTq7II=;
        b=wsV6FQUXd4DVdrFLuknKnBa6I6mPfSwfFpZyOilBzb0IdU8mdP7WAu5Tp+p5ldiM1Z
         rebEzCsx4vGe+uwgMZgcSXAGqp9JssB759lsQxrXUoYQ73EBBLJEPi0KFNPZ8PzLgF5d
         PAjSFIju+K6AI0Ug2PQthG+rQVQfuC6PWkEaXvx5cseRZ8nv0CaPxosSiOiUXHKtKQ11
         EJNcMRwK53hxfuLE2nstuR/uX4iAnsNhm+kNc13wJOEjMSRW6bKg/rE64FJgWcoi2HWZ
         wmnC8NPPGPcm1BgXPGtJSa6t/czKEeAePGFxEviXgrPd2dS2aZnwIvOuEenNTq3laiy9
         G1sQ==
X-Forwarded-Encrypted: i=1; AL+hErHvUIlHcYtctx12epi51wa0fvCUqYlAABYCvp+L+floS8S5BlU8kqFEYfvK3nIq0smgSYxNHFpZTiLhLw==@lists.linux.dev
X-Gm-Message-State: APuU4Z+jt3VPdbymgccdIO9fM+mup2bjd6a9PanA8LUdCpO4/FP/0d7b
	OnE7gd1lprzeIP8KkDI7aIqeQ63a7o0qzGTDXBid6To7wq/matkxHiBHaWG3u0JpHo0V
X-Gm-Gg: AYBFou2izGkjqNpDDi79zPdRHcIjLUgexgHTlcGkgoYoUt3VAPH2+p+5mu4KIbvumzt
	jCSHFgfprsnd9E3HJiHonao3QSgFyBMyTS33U50xTZZbblV/Ee3NNzfgyFqG0M1Di6z2pgjox+E
	O211+KPbw8KkQecpSTJl5/FPziIrFZ5tDSF8JrGZqwWB4gkR/+PLT+TN3UQUjF/kKeJoldmN6dl
	ihW2HUdwkagmZCuNTwWlktL3e4Vg+G3NDU/KRrTZ1bcdScFWxmy21LxMme2x21L8Am7TN8J/yPW
	6r7FARyOR5sWsw72f222RndrXYvRHtwp+Cg3lHLQcPs7GDm/fA2YcLlOp38tiBH9/jmqtZxz6TQ
	axAspACfIGM7EwjdoK45adY/YKM/1ZyHAtvL267ZcAseW+Q3A/DMsApGwxTrIv0dOM+HgsZCbrE
	fD0WdBQO9dQWDzJiVZV0eHMmaCJduI1POCp4jNvInT8vJ/7SZ5bFnCdiF2pUtCwamuECL6vECWP
	h9j05wCu5aPhs5BgUjWLdJ6WByW/YpnrdBc6B2ZQwVdUYlAU0qIAjZ3yAxSXIvGm+IK8eVlCfUS
	gjRZdJa4/Y4l0gUU/sR1K4Q/VcRdCbpltbxH2MuoLX90UJHdMiT37SAJhlipyec=
X-Received: by 2002:a05:6000:4707:b0:498:c419:3728 with SMTP id ffacd0b85a97d-49c713ae367mr4463557f8f.22.1794565646661;
        Fri, 13 Nov 2026 02:27:26 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5a32d336sm5077482f8f.0.2026.11.13.02.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:27:26 -0800 (PST)
Message-ID: <0c109a58804a2d782e549af6ad13e89532d9f9d2.camel@amutable.com>
Subject: Re: [PATCH RFC 40/41] erofs: refuse files on pseudo filesystems as
 backing files
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
Date: Fri, 13 Nov 2026 11:27:24 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-40-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-40-4c998976c6c7@kernel.org>
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
> File-backed mounts take any regular file as the image and the same
> goes
> for the extra devices of such a mount. erofs reads them with the
> credentials of the mounter so this doesn't hand out anything the
> mounter
> couldn't read anyway. But files on pseudo filesystems aren't images.
> Refuse them just like loop does.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/erofs/super.c | 6 +++++-
> =C2=A01 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/erofs/super.c b/fs/erofs/super.c
> index ce05557bd998..980d5fc2b576 100644
> --- a/fs/erofs/super.c
> +++ b/fs/erofs/super.c
> @@ -158,7 +158,8 @@ static int erofs_init_device(struct erofs_buf
> *buf, struct super_block *sb,
> =C2=A0		if (!erofs_is_fileio_mode(sbi)) {
> =C2=A0			dif->dax_dev =3D
> fs_dax_get_by_bdev(file_bdev(file),
> =C2=A0					&dif->dax_part_off, NULL,
> NULL);
> -		} else if (!S_ISREG(file_inode(file)->i_mode)) {
> +		} else if (!S_ISREG(file_inode(file)->i_mode) ||
> +			=C2=A0=C2=A0 file_is_pseudo(file)) {
> =C2=A0			fput(file);
> =C2=A0			return -EINVAL;
> =C2=A0		}
> @@ -835,6 +836,9 @@ static int erofs_file_get_tree(struct fs_context
> *fc)
> =C2=A0{
> =C2=A0	struct erofs_sb_info *sbi =3D fc->s_fs_info;
> =C2=A0
> +	if (file_is_pseudo(sbi->dif0.file))
> +		return invalfc(fc, "source is on a pseudo
> filesystem");
> +
> =C2=A0	if (!test_opt(&sbi->opt, SUPERBLOCK_SHARE))
> =C2=A0		return get_tree_nodev(fc, erofs_fc_fill_super);
> =C2=A0
