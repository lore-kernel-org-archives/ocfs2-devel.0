Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564728;
	b=42vWIfFmAeHk52Cx3AHUkmburbn4X2WS2nFNIMlpuy1fyc2PBirLSOMPgqTTQUc6lzrz
	 H8Cnt23p0A6R1+84VrCqLDN+OgrgQemN7a148p15SwTgbBQnTnIUpvuqAyKQ1I7BVbGOu
	 f5Q78H+r4mLsxHNPMrYL0cclMVYZXdazVoXeyQYPBzBLXar8yNnXq+FUIigjLOcMcduNg
	 dKtMdzKasmfITmdO46kdye1t3+GAwj291tAL5kM+yF403BzCMj3KtoFIcS9SG0HZmRxI4
	 zQ4q1JRHVyDMjlu1io6ILeJTX/k3dZlAVbcuC2jPyySsEqJgbBDNwtB9wo5mkevq2kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564728;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=C9TZKYRayQVC7UyXoancZRI4bPIYIHY06/n7s/4tB9k=;
	b=y00CNtGEGJbumECu2FrZgJ/wKiFupIVCpPm5ToyQwVCqXPaFDUGsmnLtkIfT/N44hGfk
	 saVmosAm7/LbqqKjHI4JGwGhA7EVipAagytADQGUsqfg70pmLyMvANdLg8KoJEjDhYHaH
	 R550gKCNJy+GBksmZMhjOthwAbiI5Ehc33aWUTvJQj/r7nnM3mwiUY2D7FYlWw+IToYkc
	 yncTxBETJrmnIqtDqgsOCEZ+ryySSEv+QDMMl6kzv9TsrKwXHNgcWOafIybOTc7rs24B8
	 yezWi2n13wXmu4UXg99S0cchbsl50Ql6J3UV+qDWqdkR9dr24rOtVxVRHI7tI1BF37Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=GuHcZF3W;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB57606A33B
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 10:12:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BFB57606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=GuHcZF3W
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a20bdaf39cso13097865e9.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 02:12:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564726; x=1795169526; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=C9TZKYRayQVC7UyXoancZRI4bPIYIHY06/n7s/4tB9k=;
        b=GuHcZF3WORQRAgl1wCIyYPjHEqJzEGqhdMDJqRWcH729UKaWDHPpLvdqOoFkOCdSO+
         Lf6ZuxfCjMgvrTLtn8B37dazIcs7g/DZ935m8uj4NKqLuB8Lhl7kpxFr7lWMZ2qnWa+W
         gO6l1Y4DxQEe5pLUBrRUkzHcc/L4LYnEiSsC+wPSW1i3qMnSYRND5ELJSBT3716oE6yt
         aZQTbF550d7rR3ktdrXrHvBjVRLcFMqF83UrKK93kYG/kXhuOPk+F2RukH+AXiyPcPHz
         0vUSodZrzLEtelSLK/Cs+R20Ora+Oy+f0k1xQ18u97PKVmxgljaWz+GafSz/sbi83utd
         IGrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564726; x=1795169526;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C9TZKYRayQVC7UyXoancZRI4bPIYIHY06/n7s/4tB9k=;
        b=WOmKOpulWfzlG6lvmvs1C95hRnZmHkUHzTXYjdOX9JLLiZ+RhaHFkKQNRTOE2ZTzSi
         /FBcIoR30ecf+c9DKFpciwj5+dLBOS4OpiyvAQpapYvA6i+krKDFyPqi76waBq42yWI7
         0lpdXzL0hUnbRlem2HyhLQEJ9CWyqMyZSmegrpdzHdQll0KpQb90qh+6/cmuZxsnUQrN
         y7og0dhgPcuJkp46FuEno1EOM8gxERgrO5BH3PU1PSxZYf/uMyrms7MuQZ0E72WCzDs2
         xStGFcMmScMgBTHfjh+9FeU0IxN1n1vJpvMuC7O9s+vFB7TzaSaF/RH6ruYzofJ4w8/+
         WQbw==
X-Forwarded-Encrypted: i=1; AL+hErE0k9PY+W115MkMcXU4DJ+GHIJ2lJrMUDwPng0kss2vtBw3gqNYAVrJwg3lmlxz+U9SvlbKQgtOHWoClQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z/jmn/W+dgxruyaPxLvJ2G47/Pfh5hxUL5DHJkOCL1ijDmbonTt
	1eubFlhTH1rjgNNzXlj+u6eVZe36ZzV6SmDY/Ntqolw67PAG/ir59nUI3chXjW7DhfRJ
X-Gm-Gg: AYBFou1Lx1JtwwksBlXthvK/7Q67MmA04YAXHfXHL5bQ8uoZl7musN7I7qJXxCaE3gW
	JduYJnq0Bn8zIpR7AfATm+llszkdfkHz1R6cJ+/gbFP51nhZYxZsrTqLVh2K++6ybc0G7vbVlMd
	q4kFp67ur7Vc3arEm+mqJWHtA3z55nHTQi6szTcnFLOEGvmQewppDghIeM4juZiTMoqUXi33dA4
	ANTcogNEIu0PHW7FRagCMInoO86upi5XHetQChUECLCrpTv/gJx+a/iaquFB+fsbxXKNtXT6lTO
	2JyZVvxhenbrqD40M47+/66T3j4QcLsdf+x2+upyNU3mELNXgO5JASaSLEuNwUnzktowxzAEpkN
	yY3RfVD9Gl2chGJ6KoGjavLpQpa/KOXTu3T+NiLFhN0sLZ4x1IpiQv1MGVB+6KtsziSu2H4ixla
	AAZeNUIoTTjNuaPNvBZLRM0AMoHllgzuwNtc+SJGXbP1nHrJz9g/TdGsueNs+S/xk1ZgNsDrDE2
	TGJla7AtixXcyG0ncf6NGlio41YvnIvhw8NSw4cd5nREykHTpMZ1ejpVGnyz9HgcKIXgGbuMB4Q
	yJ6d8BN9MMH7PnYwNak72GU1Y0WasgVHTU6R4RVxDVo3YZd0PB9ct2kauecw5+7lDGEB0VG7yfZ
	bhNs5wtgY
X-Received: by 2002:a05:600c:c4a3:b0:4a1:6992:f861 with SMTP id 5b1f17b1804b1-4bb55a02932mr40317635e9.1.1794564726124;
        Fri, 13 Nov 2026 02:12:06 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e2842e6sm142085915e9.4.2026.11.13.02.12.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:12:05 -0800 (PST)
Message-ID: <82d691d2db7579d9630bf89f73132e36124bf74e.camel@amutable.com>
Subject: Re: [PATCH RFC 19/41] smack: use fc_init_pseudo() for smackfs
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
Date: Fri, 13 Nov 2026 11:12:03 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-19-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-19-4c998976c6c7@kernel.org>
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
> Initialize smackfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. smackfs never holds executables or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0security/smack/smackfs.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index a72bc7fabea9..4a56bbeaeca3 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -25,6 +25,7 @@
> =C2=A0#include <linux/magic.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include "smack.h"
> =C2=A0
> =C2=A0#define BEBITS	(sizeof(__be32) * 8)
> @@ -2880,6 +2881,7 @@ static const struct fs_context_operations
> smk_context_ops =3D {
> =C2=A0 */
> =C2=A0static int smk_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &smk_context_ops;
> =C2=A0	return 0;
> =C2=A0}
