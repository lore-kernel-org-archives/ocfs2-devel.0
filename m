Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564824;
	b=CxAXPuzwZlEkDNCtjBW4Sr72de0KeVOjqoKgrL3mu5ONEdLo03lkfDquWtuPkdUzVs5G
	 qYEDxyWl7diOmx0fFzAcnn/v4mIN10Wwy7wx4V+WZ71mqu7hYy2tydcb5MLyDgUG30Jvx
	 yYqKTfMlNlLE6wRsrPMppy6qppYdRgBeTBM6iVMFegNAdV1wjwTxPVF6gg5e+G4Z552Tv
	 SWBdWUeYeaS56iPjTjroUbWkMBbmSaVdvCHWCwR7StJDhZjNNypLiJRzb1mdA19XuW3qx
	 QIKsx2dGp2/fS2ZKhIOowYEVXWqfJ+n9mYaIwf0mkEgP/CLcNU0V0b4jCzy/m5H+enQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564824;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=ycFr7tcHP3BtNSevVHScuCcUOF/OuOrXOdu+rsUd7U8=;
	b=QOv4SNRxHHPKBzF4nOj/Vxn4OPm3j/4CVftyxNdeWU1oppaj5Kbw7HD8p3v8R/KiCtzR
	 Ok4W+CZAdrFnLVLhmx/uhOsrC/Kn1rkJuWqVy4FEurF8sT7FA+9nC78ok79ltFpWkHPXB
	 dnSWdR8sUXqg4uuhd8cqBLhSrbAOc3SkMsvL4ekYy80T8af/iz7oCs8utgEIFpKjFsZLy
	 x4LYtiVfHCT40pk3bc6NGws+k/Dqn3m+fNp+NI2BJuNki2lcjgYMSu6jDO5R0HonRWOdZ
	 a+23ZB5qE5pRqPu9sIgoas2C7vBdTNril3/D8O7JnEznvtTQdjfcPkt/8DpUi5RrO/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=dITlcekz;
	arc=none smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3C8606A89D
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 10:13:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA3C8606A89D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=dITlcekz
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b581b6b0e9so1096345a12.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 02:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564822; x=1795169622; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ycFr7tcHP3BtNSevVHScuCcUOF/OuOrXOdu+rsUd7U8=;
        b=dITlcekzeKl3qmskAXnNLGUfDGpVhiFMiTE4D1OeFYCVMO4tCp+xhEDm+GRZW/FgVe
         fOoZ9pPCsVkkgGWDJDCR/44+Oo/sA8GkLA4P2sqtoO4EgEo/PB+Yxfqo92dLSZTasa+b
         fsidJyaKs8e+ynTZZdf0xSjssmHfKTvWZnZvXnA2fyV5HRtAjGgSmVHi3e0ZG60L92tq
         WG60vz8l471Ay4hwM0HLbO3CTd1QCo/ZJMlvoNriwauWu4F/9Aq13rDRmsfXU2Ni8sVM
         SDBGR7CVc7wRveRLk8WWn2n25Oek95cbs9U+R4i30EdOOpdYULXbQ2YEL4e+KRFpYNl9
         j+qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564822; x=1795169622;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ycFr7tcHP3BtNSevVHScuCcUOF/OuOrXOdu+rsUd7U8=;
        b=I4AqWMc6Zc5/Pjznj7wTgynCBhwvVWY+lVjnlPsCJovp/rjyFNifJAyySEDPmm98aD
         w/ruFeVey32Bzy6mST8wYSqdbqWsiFWc+S4Z9J6BOaEOPdgb9KXSLHECcOnvs6zsOEQa
         H+yyTd0sgdkl7QJsTPXKXDx4X0xyRL0ZrcKUlUo/xXRCbEwGRv6XyXlIxUHJ44LLaNIx
         DylV2TyrAPwCaGhLYFSY0BGaFzPnCBNTFxaRlMHOauA7km4NiCehOoDCVzAY6JDPY2a4
         WXVMEeWpdXNkJWX0i+5D+JBFne16Is7Tz+PWP1/HdYpyUuLymVJdGHNhVFBXegDYUscq
         24Hw==
X-Forwarded-Encrypted: i=1; AL+hErGIxV9mdZMxczAn/Q6HrhHqwAFezET8572MmWFAVF07em7Li/reLahaKTw0baCXToKGV3xyYFgMjOzvIw==@lists.linux.dev
X-Gm-Message-State: APuU4Z9n5ts2z3rz8IOQ+UyXkqoSJ8IFOs9dMOGUDDI74DB8mfY5fWDI
	lb3Wui+qI90Zxc2snRBXna1YBkfTk5gjKIJVts+e2m71yWAi1i35EfvBUm5n9sE6axKP
X-Gm-Gg: AYBFou3VJC4vCthjaEnaF+5L/1Rs4QLDmmKcFQyBLieM43BbZR9SQ4jkucIb/Dn+YV6
	RJVWWmCbpaEcYWrdYVYz9RGKAIHiJSRN4rrpQdxeramZOY3oEm56lxDECaU2pjz69/I9ZDUiRZY
	oBUi+cLiWwlCAgXz8jWer/diMLi05Vm3VPWKltET7DlkKE1KKYBwy7eaV1OJ33+kur5veymgWAl
	8pcrK8bnjb+WwCBr931YzAtvG/9WAR8A3NQdbSm0KNUoK1iNDyS9rBK2f0tA/eoshaehTO2ghrT
	NyRI/Ox9DkomOVcyuejAE/eyBNfL4DDGQFPGxkkoYnk4jcz4ni99TLg/lb+16UME/ewppAEsr0j
	cXEc8c8qKyNQ45FzGf3Bqs5q8I6sK7Vn60+chJWCCeLcWMj6gJYiaovOKchi2gbsH6DnKYNcaX8
	FqaQd9BsgugJSGKIiKG72dnqG8YLyyuSz/igwN2ILJLzJdDc7d+61DivtEBNr1CA7Myabuh1GZ6
	LiHf8d6s/1OiuXu1ZpEmLVqmYMJ3k07b2A4AK7BBHlq3NKLm/2/5LtW0FqN1cqkUCMxCcK/zDoO
	O7OB7PnQcZeIkn6t0T112hkzTQSk+6UxHPINBMVLwt30tm1+7PqNzqvQjl9Cs03rXbM6xl6F7sS
	dCuM+A3rN
X-Received: by 2002:a05:6402:208c:20b0:6b5:69f4:e7ce with SMTP id 4fb4d7f45d1cf-6b7c0c62bacmr1415990a12.39.1794564822367;
        Fri, 13 Nov 2026 02:13:42 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c603f4d29sm4332158f8f.35.2026.11.13.02.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:13:42 -0800 (PST)
Message-ID: <3546dd28b1d63c1478d391a2015fff4c1b976639.camel@amutable.com>
Subject: Re: [PATCH RFC 24/41] efivarfs: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:13:40 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-24-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-24-4c998976c6c7@kernel.org>
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
> Initialize efivarfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. efivarfs never holds executables or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/efivarfs/super.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
> index 12746ced6dc6..e598d42c5f42 100644
> --- a/fs/efivarfs/super.c
> +++ b/fs/efivarfs/super.c
> @@ -8,6 +8,7 @@
> =C2=A0#include <linux/efi.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/pagemap.h>
> @@ -554,6 +555,7 @@ static int efivarfs_init_fs_context(struct
> fs_context *fc)
> =C2=A0	}
> =C2=A0
> =C2=A0	fc->s_fs_info =3D sfi;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &efivarfs_context_ops;
> =C2=A0
> =C2=A0	return 0;
