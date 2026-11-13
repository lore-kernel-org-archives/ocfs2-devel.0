Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794573510;
	b=L2MWLR4YCHjfUePXNDk7ST8gYCg+j8CgjgCi744W0oQNeotK2uyJGvNQACOWeR0EXGib
	 v7mJ/MHh8Wk7ket4UAVJnyBVHBiOWMeMo7nZ91JJYP4YjM7fjXM2rOS7KC9q8Cfj+kPI6
	 XMEtWRfF8T22GUNWzTdIv8ejKFVGhlxLtBygdjUY8cEanxm8+zjBbZDcbB4c6EN5elUtl
	 vo81hQ6AOxjcWOV7L4w2wYFrjdX86a+1cvkJqj6gBcNZEsRNYnf0BYPlzD7nIGbM9jlEc
	 C0IhmEmfvHf7izBePLIAPzhjTDtJKHBi5mVIZm2IEPP7EmI+UdFNb5dH1rSKu7I5KaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794573510;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=Ny+1veWg8VD0eIDxFJ1X48Kguf5Oe9PbJZTpbcgMiOk=;
	b=GFkjGyjkbeMsfjx2X4TVNN6/F69/fptcl0H8guKOSWkhiMi7jC0e8MrlgqhNTi+2+QjK
	 HXQG1T7YvMLDc2Shc2IiX/k4orIjb6crQxmQ+RUHQl9d0AYVhU2NQTSbFKcO+o/UdT4LK
	 LEJsmhT4QWqlCN3dspAmBhPW8rH702RQzaX0vz9BrK25mV4qtt6QgW+zkWd1VWwVLwPMu
	 B+d85tvd6+3NzQmR6Zzg7gkZo9p/Cgz+XkP5s6bdOmyD6HNgQQQC3w1GbbZEGbvReZeGB
	 1UPW4bCCLRFY2+ipfz0Qw4HwCoObykaltbZMm0m9w/wuv9l2Pn77yqN0BIgka1mz0wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=mcKaUtOY;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58A7606A332
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 12:38:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D58A7606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=mcKaUtOY
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so9108205e9.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 04:38:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794573508; x=1795178308; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Ny+1veWg8VD0eIDxFJ1X48Kguf5Oe9PbJZTpbcgMiOk=;
        b=mcKaUtOY/8jjtvzRE5qjUlv9fzWN8ZvABpSu3SQX+v+XSJ2RFcC9malGCf3/dlbzK7
         /nLavONCv2LzTKlliQtJQBtOF7VlURcs39Le3LXRxZkUgnCL27FlI4LG/nLao5uK70R9
         54cPKpqz0XAsR5ZhZ6+xJt+jCGosym81QeL197lFwBtxxOI1IpKUAkAFToqUL2Q6m26Q
         Zh/qNrNZ7YjApnYTAx7mCWhe+KxZM71gT4Fmfl7V/q9HWNwsz+RRAqbJL3D9JsYOyh89
         uJrDipXKn+1J8Y+KdTL6+JP3bp36G8Z5U8KVX/eYE6uOrFBPYtw+R9W9osHvG1G9R9lj
         SWhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794573508; x=1795178308;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ny+1veWg8VD0eIDxFJ1X48Kguf5Oe9PbJZTpbcgMiOk=;
        b=xbzDqqAnBk1WjcrdKTfxDS9zgktLdL4LxRcFQMbmOXr/vpRBqWWSUowCi/qiHry6p8
         rq0n0cBD98v4sCC+ZlvvNGfAcyG0h4746xr+C0t90E8mz13I+drLmySH74Mwaz52LwvB
         VQQUIykQuF99BkqCLn8trQwWxhPeHPzjpMqWEEEonaamp3AD34wh+nTvTZ5dBDmsrP2y
         Ze1mNPrgRXeW/HCoCQwrAi0pxVHWY8Rq6ac8upx7X/SwEYm8Ir2wMm0/HQfeXs0JWFen
         OtFDnzPwvoFROiL4OZshPdQlOZH79bgg0pZqvJz70+gapVbzYEeASts632rTugSWciy5
         CxzA==
X-Forwarded-Encrypted: i=1; AL+hErEq+tipxOkVDGdujhQvPWkimjc33Chqb4qQmaZrIVwsRbQoJNxnHE/kXq1UhJH2CsUTw3had+QnUdZjcw==@lists.linux.dev
X-Gm-Message-State: APuU4Z8KJosoBz6FfyPsg/DFTd5n01kQjGvwrmZgo87Gb81qQsAHvXNX
	WhOY8dBHQt2F1/MIrZfzfA1oG+rVYXIM7nzFq2/5bPSX6/crJJdMgt3hFkfoXWJtmSd8
X-Gm-Gg: AYBFou3eYh9UGThMQdhE4Wz1Tdo/qNBEBEsOkbpuijqz2Dcjvsy8Q+Z2rT3jttInRzh
	23fWhHmQBhLnBSFM/DHtc6Ng7kSI5evYZmVliZ46UD3IcSOl0LjZUhCDjgv9fOy1TZ5OFy+FMi0
	hVWD2yzWw6pnsM3L3XEl2hfJ6rQjv70CANAMqPJcFhitEqlvuPNtfdXLaV2Dg6o2+PJDAxXY27c
	XBdN5Ub/w/IHS1e8FmhyLOLOOYwAjbfd8XkUaKEQnd+1/Wzuf3en80bMmICsMLz77qlNtT3hy7f
	+bI25rnhfIzo4wc23GxFKtJgp+IrtbAACH9UFFCt69zi+oVXaHekMTjxEkClNa+JSd68/R7z8fa
	1a/np9aYMvt2N0rsTFKkB8QDk6kH0RNWuE4AA7w6DQh3dc2ynJAEHOevQn5WimIj6ReNxbbi5+B
	CxyHFsOp0pDPGwiHFNVzv5VVGaiIaO3KUJ1MpPF0a1K10a2Nex5BHslPSqWFIipISY9iYqBiuYi
	ZGs01ED3/cHdV1XIrLa2BvzYwRO1oAohXplI7odSCuTt3upGepHxVae4TUIr8t3QtglGV3JJxUN
	yz4Yjol8XrIS2XIN29Q4LVGwb/Wam5AWkNyv3XkZV6LiUBjQYqbhTe1ZUm3nKF4=
X-Received: by 2002:a05:600c:a596:b0:4b5:d95c:2380 with SMTP id 5b1f17b1804b1-4bb55a86fb2mr24790785e9.11.1794573508217;
        Fri, 13 Nov 2026 04:38:28 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb571cfa2esm48348475e9.2.2026.11.13.04.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 04:38:27 -0800 (PST)
Message-ID: <28a33fa649dcaae2eadcc934ec49fa591ec1c283.camel@amutable.com>
Subject: Re: [PATCH RFC 20/41] apparmor: use fc_init_pseudo() for apparmorfs
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
Date: Fri, 13 Nov 2026 13:38:25 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-20-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-20-4c998976c6c7@kernel.org>
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
> Initialize apparmorfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. apparmorfs never holds executables
> or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0security/apparmor/apparmorfs.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/security/apparmor/apparmorfs.c
> b/security/apparmor/apparmorfs.c
> index a99366467217..351ea3a7120e 100644
> --- a/security/apparmor/apparmorfs.c
> +++ b/security/apparmor/apparmorfs.c
> @@ -21,6 +21,7 @@
> =C2=A0#include <linux/rcupdate.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/poll.h>
> =C2=A0#include <linux/zstd.h>
> =C2=A0#include <linux/string.h>
> @@ -263,6 +264,7 @@ static const struct fs_context_operations
> apparmorfs_context_ops =3D {
> =C2=A0
> =C2=A0static int apparmorfs_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &apparmorfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
