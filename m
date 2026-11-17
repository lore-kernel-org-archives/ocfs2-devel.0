Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794904595;
	b=tTfaUxFYp4JBWoXINSDoEeiVC6tWqT1n1McWh3BlRG0j/poe/7rXQNssRIc/aned4WdE
	 IHSFIKpk5SZZM2hhpdOSELz5bQSdr6HMpwLWygiZ5xkVMgfn21Pd6Yc7m+NI6Fjm0ZUX2
	 WJjv8giHdQXg2077/ugTbdu71mijIV8cqbbBPVlrHc/N8zK1Ov/oU5jKULt8hNBVbj73U
	 l/V/xsMkmCwWcqud5A9PiiHxl2x3yqJkdNGByRcbvgjg1VrOmUa89ygesxXouE/pf6znE
	 dkV+FM8Qr8GoN+4oRm6yMCx70XHAhcgbMBWAFik6iXok8FEyQmMY4LijiGSr8l5v11g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794904595;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=u/hxpfxH2Ygjpkkpn+gEQ4NFMpeA+YPAHTw9d0qdSc4=;
	b=Dc2x2CTKPH4imDPWr1G3ovMd5zj0xyq24OrmlAdP5Om52CnJBCbfK4qEEUMA3N20dOFU
	 mUcidqC0ro+57o21qC1szedh41LNfiFePAkyhaU0h83OcFxtgBtW2eBnvCI99iOSxfbDr
	 nphLFtzAyBpMXJ2i/AzoRVkibP85zJTAv64BhpC+wrqwR+ULDl2BnS4vq6Z3ygKU9lrxh
	 3ldxHFBmT8RjGKiuS5CVmHx2aSgiaIR05Qr5FFfnwmxNcYDgJgEqRLcVCGOwNQcNBZkqI
	 iD/G+jtB6xOFQXFTzyJCprYz7o3KMMMH40Y3X0OydrfpsnYu+7CVOaTxDrab01PyxGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="aYmM/GlQ";
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C51606A8A2
	for <ocfs2-devel@lists.linux.dev>; Tue, 17 Nov 2026 08:36:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2C51606A8A2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=aYmM/GlQ
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4b467581b98so39088865e9.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 17 Nov 2026 00:36:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904592; x=1795509392; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=u/hxpfxH2Ygjpkkpn+gEQ4NFMpeA+YPAHTw9d0qdSc4=;
        b=aYmM/GlQram29k41kbBU3ySezqx9KNWUNuYe3i1xKxJ0y1xgZQ+LJM/FIr9UDBi5wt
         EUIqGzXn8CbeolIR7DvOKSNeYuIBqIeeNK8F0MQKLJ7qwm11En3qO26JhPNvGk2paD69
         U7N7xncp/GRVRFDNcIuifTpVuVJNG8jU4Q3wXsQNed/0Tg0YFTxAIww71hMFw+5lkdi2
         GSwBoD8x4+l2SuhioCbR6ytEgNPnEziI9cNFaAKiGxS/sGp7TnJ3m82dxZoPJmTczkS5
         Bb33DDhE3GKslfQDvo7yH7Tf+R7T4kSPBZf67kZ/+WH9Lydj4/+1e7HD0vsiAQN2GjGO
         iL/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904592; x=1795509392;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u/hxpfxH2Ygjpkkpn+gEQ4NFMpeA+YPAHTw9d0qdSc4=;
        b=UfjYc+scz2bBnYIC7Z8PUPUYKMUbT1D+lm+EumuDyR6u0v1P3LVS4qGg597CyNNlIk
         eNGm8vayahy/S5wpN2RQEQkIkUgPci6nZ7/cuG5RHKc+NiPCwq6QMhOjqbSAJoeQ59or
         AuieRDxjvndhI8FaGVTko7USpu3KuX/vGyrvMgvd0kUZR9soNwuhi1jL7ZU9kJYgY7il
         GbNrXpm6+FIsSco5G9ojg1AacWO/GN0LT0skUNUwXxq4ZmF//CjRtebzNA+ijYbawQyo
         AbTvO6O3MotEb3EKSAxBjuBMa9IDslkgnemhNDw+5g+KJz5vGYB7nHTCLnIqg2K0PO5l
         /8cQ==
X-Forwarded-Encrypted: i=1; AL+hErGo9DbG4RRa3yGXmPjZLplTbXDH4SKAgZHFCjQycLQbEvBTiapldrJVtck3OMGerVYIIttq/JnLgLChsg==@lists.linux.dev
X-Gm-Message-State: APuU4Z/f8CNH89rrk/lYIxaIw5H1W0JkW/x+xDeVzKEG7/sPc0wrEWdA
	wdIi9NDXMckw47CvgZ9i9wtxiN2MRNp1YtJR1fkuQ+zvNxT67PbXM/pHABAZcmK11K5U
X-Gm-Gg: AYBFou2tUzvK7lJyc9Z1Sovm9YchZJihHBoJiQ9pI07lWYdOI9dO/gZkUKHkeDYjMMz
	3o7/nKwO0C0tVM4AzHe4c/2fOCDYwI1JalTpO91f4iJp4Wse6WX22tK9PXRuFyvfjspa5LHF6Ub
	qrSSwXJAGr+IMzmfxzfDV/URrs1HmWb2nHif5jaIZJD2edtmvYpHgxcMEQIeoOV95FI9GbMKChY
	H6FQ2QwEpvhH/OusMboCP5rs/nVe7CORCUvdnHne8cPMtDMN9jDILZeDdnkXcCL4MIplwS/lC1O
	BmcbtcJCgCGR4EVXfY+QsT4bqfRfWzU+7Mw7y6LPgSgr6xFXekFcI/3B16swnR1sgvO49ugUIy/
	sK015umlFtJr55gZm2fiMFSseAPOA81NhZ+letxNgJFbgBHoXsJemFfqOFK+XbnvC8xrilCPLbK
	mfeBz9XDAziG2Mu5m0bXCYM9aVrbBUVi5M9k2eAyL3WBJ7uGkCHyBq4p0cuCnLX3ISWx02++CT/
	G3U4W8jjOwmVjYA/9IdaQ8AdrxdOd9akNGJCnYo9PQtnXBzbhWGU8rVNEeFh+AtifIVE9yPrQ/R
	H0/BsXuCN5VxSqOG9v1KBDXsBoWkwyXx2P8wD+M+1Ndh60yslS9LvqBd1KYdLVCscycnPXHnRCN
	IA7wOdl1vJkNY1Na6xSP5oQV8I5GC7tXRWaCi3uad1SAweJSPYD+COAPN
X-Received: by 2002:a05:600c:1f90:b0:4a7:76fa:87e9 with SMTP id 5b1f17b1804b1-4bb55ab281bmr266345525e9.21.1794904592167;
        Tue, 17 Nov 2026 00:36:32 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb78430752sm52548565e9.12.2026.11.17.00.36.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:36:31 -0800 (PST)
Message-ID: <411502f9a4f940c223b2b88d7e19fafdce63172e.camel@amutable.com>
Subject: Re: [PATCH RFC v3 29/44] s390/hypfs: use fc_init_pseudo()
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
Date: Tue, 17 Nov 2026 09:36:30 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-29-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-29-8cbbea1cf34f@kernel.org>
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
> Initialize hypfs as a pseudo filesystem. This raises SB_I_PSEUDO and
> also SB_I_NOEXEC and SB_I_NODEV. hypfs never holds executables or
> device nodes.
>=20

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0arch/s390/hypfs/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
> index 559b011e68800..8662169de477a 100644
> --- a/arch/s390/hypfs/inode.c
> +++ b/arch/s390/hypfs/inode.c
> @@ -12,6 +12,7 @@
> =C2=A0#include <linux/errno.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/namei.h>
> =C2=A0#include <linux/vfs.h>
> @@ -301,6 +302,7 @@ static int hypfs_init_fs_context(struct
> fs_context *fc)
> =C2=A0	sbi->gid =3D current_gid();
> =C2=A0
> =C2=A0	fc->s_fs_info =3D sbi;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &hypfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
