Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794859450;
	b=EysqKfFh+uJ7QpLyS8YjGx8sieDx0Hs/xHM9b+1MUv5rI56J2gxraY0zkIGcky34Ghrh
	 0vn0n3fVCEr1EkRLjjf1a/P9KKGQy80i3F6scA+nAULxjxNZGYgyTDk0E8kuaRQEwxHsp
	 El4M+OvGuj0XOH99PXJ+6EmTDqjKMkQWXjGVna9w/uPvHBR1YGXiKL9I0b93a+v7b+USE
	 fAU4w5qLNxIEF18CBhCRqwalbtlWtaK0ZbWWgls3m+eTEm3GmVkAgaEVoEexQBdIw/Wu0
	 yEvXwpMEp1YbyncAad8pUyvpIGplMipMQSjFAK8guPw3oQhex7P+XbNvN9wFXBnkbNg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794859450;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=FEtpE65JhLGyAYaL/FOW2ebUIws2WwBZ/4Zy8VNXUuw=;
	b=BpVm7Z51KS4fxzrMiW5hcd2QJD+mA3Di4yqywHVxBmgnboTxmYGvFON0ROV3YHAusztm
	 3TOsNi6aIPAGcqTEfCSfYFyzE6BBolxuPcZYFTNdh3Ja3QBpjPoHPwW4+UHySdvz8TjJE
	 bQk79hhaHZXTLoxCv2+sAM5F3LACNFeLzv1pJ8d0KDlhSLKnkNjgJOIN3drpcOLEI1X9c
	 bq9lStiHzcAJDBCcbL8YyDA4pJ6pTSQN4/eGgdcN9iqzsyfpLQlUKFZQKFIgF/4g563tD
	 iBfKlC5j+mkHo5ZjyGARgMyhz3DKUKR83s3xbog00LxvkJbIeW78QnHyzHSdKXKMqqg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uHbfv6zw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.51
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3622A606A334
	for <ocfs2-devel@lists.linux.dev>; Mon, 16 Nov 2026 20:04:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3622A606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uHbfv6zw
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-4a32576da88so240834f8f.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 16 Nov 2026 12:04:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794859448; cv=none;
        d=google.com; s=arc-20260327;
        b=PvE3oZH7tBm1zlp9oKLZOK2G5zB0tRWk47W8TuoSDryR1/AO0g39H5aYtu/bL/WAGl
         bJ0Wlceyop1qM/XnTeAr6VAyakHOxpdbMbGzmbjIlsvLDbEuMKpUtd9I7n9jlwk2lHS+
         gGHXu6YE8oN+mHZwnmVyUl4FIzXOiHop8ZHKp009QZzMvqlgxX1eGis9vEUSlHsgzpqa
         7vl9nYlOIu3KIgXLGNsGnyQ5BJz/HU5/BZ5cRlthI9Pfmcb8cDZPZA1CgF8y255TEcSi
         BajCPDjE6UOd8ICAjuJYiTNyWFpeMQjLRg7HEZUjUPdhhK5BlrQtppNDmY4abI842tI3
         b7rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FEtpE65JhLGyAYaL/FOW2ebUIws2WwBZ/4Zy8VNXUuw=;
        fh=dQJrzOJqZn3cmyvyiqNC7iYa7EtN4ErpHmWIXZI2nh8=;
        b=KDMsiZr+U9+HIexdrFe0EY3KnGkIMt3wnXDUV6A+IK9smX3mUyEBnnFLtNfWh2QLQr
         NfMIEs1tkY5m9lNNiK6Xd9JnFnYwemgSF+9h77E1z6X6TSehN8mC5xaoHN6zpRkRQoMn
         7ny7vF1rkYbs4puVNjpnEsej2fvaDGS2twHYvF7Ldln8W6NEaRWTye7MIS2eNje2meA4
         pN5KufKUTeZ4CNRSsuKuN52USEM+ZJEs+oZ2RONE/ILed7quVafx0oJodf3JorAgg4o1
         VwOgEsI8o7it/gLgAyZCPMCwtWHNxVTGFACmNwCESAF/1EZGVfVY0EobV8/SJDtOdzvL
         fJZg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794859448; x=1795464248; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FEtpE65JhLGyAYaL/FOW2ebUIws2WwBZ/4Zy8VNXUuw=;
        b=uHbfv6zwy1lrNLaaDDbEkVO8ssYj/qyFKtfSbCf6dCSR34pFTLKtssc0BSUTVKDnMu
         mUY/++Qcz1KX8Ogb2sP0/Jz1g/BWEGgoFm5oS+25+X2no/pwBQ3/X78Kepr/irGJMSNE
         3gT/frU4pMxR7n1+ps02VbwjRh4tMLWxLxyNLP8keSVXnpjBVZPYnTT+c5wZ+iecIZv2
         7S2V/VFSlcgm0o5RvV16ycxlulKRs40excOeL7ZbwOsDzxUCMlYvUBzfGE+BrYAVAPFl
         i5boq8/bHOyLGWd4pfpgYpy2FKsVJAt6V8aPFCGg5KeRIJDFvIDXcerxrzKv91ysSK+Q
         s1GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794859448; x=1795464248;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FEtpE65JhLGyAYaL/FOW2ebUIws2WwBZ/4Zy8VNXUuw=;
        b=OsB2xp2W0yuTU9Bz/6xlZ95w5SyN79aCTf5IBfdpCIOjTQEsrz0ubnve0oI9+OY/tS
         zlNp3wGf/81X595jGAXnLY5yffWPaA+CF7ggs/eUWwRkJQYirl1BP69uF6vcRq1XLLb+
         UlPEOkXQUQyanAwm6aEoLEk+0uZgRwxUqQLhcaprEG67LRykGR3c/N8PLqHr2QAKciS9
         FSji5Xq5RrWm3gZ/FLHyIO1geXrG0bMlHwAtxI+WmGLfr6C36vJx51jGLhK6LutXUgxF
         PJHfO3YzaDWCIJCKIJgGaIpzVaaQdQwfw1lazKUaRAX7Mj7iUo7u1/gN6UfeltA5T8Qt
         J95Q==
X-Forwarded-Encrypted: i=1; AL+hErFb/W5ikFNY9bWietLcRJsQlivHxJXMlvDmHyGiQS0vXeNrNgYNpUhrda96Xj6cCgkfxXHRH6tZ8k/iTA==@lists.linux.dev
X-Gm-Message-State: APuU4Z9r51TgUWX+1S2YzcCIT0mdsFoof2Vdh/CSHJXBRGxAzH1m2A/U
	P3pAJNwyjxIg1IZJi5JGFmzlP//OPUw3SnnJGRLp0QmT+0owDxRN4OD783L96bkEjDZ8oMkY9hB
	rlog4ERydUicbkiDNTat/7ZrfzGF57lI=
X-Gm-Gg: AZFdTZerQhRj/+H0Dw8QjjSMJtVlI82aO5cb+Zk7MXdIMQrpfr10GntXBYTaHJV4Mlf
	1EfiDk4gNAw3urpPpC65IRu2PSQOrSULW563j5PkEYPlZix/8ZbqxV0iFGD/fDKb7JBhF3zCMqF
	aIvrT3AzdTCnA03Od4Fsu0R9CD11KYszAjEY4WS0U4pHfrKE7VfpISRPAosUdNosqb3IjT3FctR
	QLLvs1w8T2HYHvWW/TZpYli+9aHhyjgxyMMVp3kHHHrfVF4EE3yoSroI5LyCag+6ada3YIu6kF3
	qiXoVGOh9TsEQReGmozBgxw7ZXJP5yY81rH5u1hsFvWe0QebYBt/cChzLQYwu6f0WGoyu7a+gq6
	lBX07xCaE6XjYxSVyKMWiNx80sJRpj0Nh6jDaYO7vd8DVrLiGJDuXw8uRmyCTrSC5hhSfT3Ao+H
	NVJtzh3DQlOflyrD5AX0g=
X-Received: by 2002:a05:6000:4692:b0:491:3fdd:af34 with SMTP id
 ffacd0b85a97d-49d61c80db3mr13343868f8f.36.1794859448335; Mon, 16 Nov 2026
 12:04:08 -0800 (PST)
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org> <20261116-work-loop-pseudo-v3-9-8cbbea1cf34f@kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-9-8cbbea1cf34f@kernel.org>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Mon, 16 Nov 2026 12:03:57 -0800
X-Gm-Features: Aa3M54q6P4M0RFDCKQ8HHGNCWJafItTSPdWR1qNwVGtToDAv2VOv8vDfWHzYR6A
Message-ID: <CAEf4BzbLFVawibuX0wk=8uzy0WZSYHbkgK55d7rqLab2qAM1Fg@mail.gmail.com>
Subject: Re: [PATCH RFC v3 09/44] bpf: use fc_init_pseudo() for bpffs
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org, 
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, 
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org, 
	Alexander Mikhalitsyn <alex@amutable.com>, Chris Down <chris@chrisdown.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 16, 2026 at 3:21=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> Initialize bpffs as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
> Reviewed-by: Chris Down <chris@chrisdown.name>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  kernel/bpf/inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>

Acked-by: Andrii Nakryiko <andrii@kernel.org>

> diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
> index c6f328e4752e1..57cf3775c0766 100644
> --- a/kernel/bpf/inode.c
> +++ b/kernel/bpf/inode.c
> @@ -15,6 +15,7 @@
>  #include <linux/namei.h>
>  #include <linux/fs.h>
>  #include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
>  #include <linux/fs_parser.h>
>  #include <linux/kdev_t.h>
>  #include <linux/filter.h>
> @@ -1197,8 +1198,6 @@ static int bpf_fill_super(struct super_block *sb, s=
truct fs_context *fc)
>         sb->s_magic =3D BPF_FS_MAGIC;
>         sb->s_op =3D &bpf_super_ops;
>         sb->s_xattr =3D bpf_fs_xattr_handlers;
> -       sb->s_iflags |=3D SB_I_NOEXEC;
> -       sb->s_iflags |=3D SB_I_NODEV;
>         sb->s_time_gran =3D 1;
>
>         inode =3D bpf_get_inode(sb, NULL, S_IFDIR | 0777);
> @@ -1261,6 +1260,7 @@ static int bpf_init_fs_context(struct fs_context *f=
c)
>         opts->delegate_attachs =3D 0;
>
>         fc->s_fs_info =3D opts;
> +       fc_init_pseudo(fc);
>         fc->ops =3D &bpf_context_ops;
>         return 0;
>  }
>
> --
> 2.53.0
>
>
