Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564206;
	b=e7DFcLgQ88BDLpEwa8S7XhoL0o1HV4hkV5tXc/glvcuFToUda1ym24CXHjpQXhSW5I2u
	 reodAPCXbmTA2AAzeERcJbQUqSQDlR39fUqYAvmTcUCqD4eEs4+2eXvtlCGDkaJrBPYht
	 3hesmcNtWJws3bscoQjrhKT89TLxjszHYHjb2ONSUycmE1w0AH/LpxWPakFCi40t56xmo
	 xHnaxXy0BjUgcReDuvcCvXRwlyzrT44lGOk3FbNArcARV2Bg8In0ejNnC43qwD7gr5/gW
	 c4wqjyljMq6w5BVsNBWT+MaKKg5WAdvm7a1ryP3pdJBy6Oj3uk2XLnETpU57Mhgzs8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564206;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=yP9dZgkD4P/bNBFnmHOgKVBIpz9VJZUP73dl9853V04=;
	b=AVPO8gTikMrK2501PELUWx9bKI6gPP8mYbcawM+12nxjfWeBsh+6nE+193D8D+dskhpJ
	 LzVJSPRODamf6v9PXR2leBhvS2OHzV/v6sg+dA4J4x3b1rp47pgxRRzAvblIVg4ebrWAo
	 S5XeAcrkptDB3Y1sjydMN6vDyqxJQVNV5LfL1E0snfwAxUBbRXxCuJeEVKOuh7Go+RDlC
	 pXN/sIhB3+B+3RMeAbuWLVUUM/IOgBmMDbv2hWubGOwopvXzMy3v81Kdtq7nC6kYsmWCn
	 6cJwGGb50ExaZO1D1JCc7leHMkkkP10xr9MWlBPx+llyDBWLFfSsWkEss0XdKgtz4uQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=jxmjOD1a;
	arc=none smtp.remote-ip=209.85.208.49
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924F0606A334
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 10:03:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 924F0606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=jxmjOD1a
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6b75712fb57so1193799a12.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 02:03:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564204; x=1795169004; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=yP9dZgkD4P/bNBFnmHOgKVBIpz9VJZUP73dl9853V04=;
        b=jxmjOD1aHRA2R1Hi3ZWl3j0ZOodJPFK2qm9WAbCdp+JzmUT3mpZDWfxLLNYa4wWF37
         QpPbYxRrQ8E3XpPP9fn0qWFw/aER/GznbEaktvuMsdS+Mm+8yeaaXQHQ2EgSxBq2PrGr
         8Yaksqquc/U2YHZKyRnIlZ2k68SfzsGeWZXZzzCenlb5+nwamArR6ajrY1KAoS4FGRH8
         fJ2pADZxBllItxcAaQFN2ZB6i73jQHr9OcuqrB0pCowy3Ssf8EJw6wlrvgYO6dqyTBjF
         J2l8uwa5br7QPuZNTDnMB5LRlagizf5aj7GkdPUkSQMNrroKmr44ACmyxZtPNrGNFKTM
         qEOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564204; x=1795169004;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yP9dZgkD4P/bNBFnmHOgKVBIpz9VJZUP73dl9853V04=;
        b=FzXQX6d58PI86eJWLN0R8ISNWjjuO8mWsyQ91FhT4vs1rd0+A9pEsyE1pzlqFHMpI6
         MuqaS8HEGWWPxT0kLES72JZcoATEz0cuVhsgGahll8JV80m1tLhquClmaAiTXyo7s+NP
         SIa9pMFOfxo8YYpJtJ/VfwqSOhu6tXyiYlYGu1uBtC8K+XYdLyJse07lHb+Yg1tv84E0
         YfOESDRTT85f5diwvqA+CO1NGt9DaG25TWDzcudUT6JQzVblAwSGgc0uvNEQd1LwDR0Q
         pWdnxg5L2+Rq4A+v8gIFepBev2wbXOKn0thPogWlohOA5kvCulgoQ8ig4BuKw4jQre1g
         mT+w==
X-Forwarded-Encrypted: i=1; AL+hErGs6/Hyh8NCM7CP+/VQJn7q4R5+3AN5nGBfRDDZLp5xfYzX/C6MReXwJnPUxG7uzMjFNY/pQ/pk6drLKw==@lists.linux.dev
X-Gm-Message-State: APuU4Z+/JKvOhX7a2+ewA89/6avM3WmjDdERLp+Ne9Iqme5vJsc11rwt
	5g00IEJN3Q0iWbBSKhaG21dryyC54A3dD5IbyWIaAogIh/4FYqcyLrBBOst6YcIXuerj
X-Gm-Gg: AYBFou3yy541i5W0v/Cu6qQXzIAbkXiP6vQ0UZATcRMppy9mHsJAnR+D04sm8A07Bmt
	vrSqXHrz6rml0WqLEJk01HVPJVOan9fMG5/akHAJ+0BqXKL2BVJ5rusZiF7qzo7IkJx8f3I7GJN
	u1i73IchWIvzkjk2O7ry3+9IyBhDjwAbDp535t3Qws/c+doql8OYcibuRkP1vKRRh3wcRpOKry9
	xnD5DBc1N5RrjpzEy1dKXQ3r+hSPKVmWDjA3TWN8e8dD5JYRfFFvzuK7DcyckCt98EDuOBMT39b
	4Z6HkHZV87Irwx7ZjhYDfxP6hSwDJrC3XgoGLlr2NjWizRLNXfuSdxPK65pKepM0i/1PjvdKrmi
	zJ6i1/8kU+7hOmUHxWVzn6Fu2DIdl+fg1G2AuAnziqiah2GVDP5/DOz/vW0chZn2O++6N2USrXa
	FkGpR72EDPVSl+/Z0TEmoma2XHWi9ToFEW8wYjEsQxdwRID/XMfZw+KmqFnUCXt0lwCMm2XFQT/
	FtzWSbkUuUq7jOJbtVsK5zjSciLD3c8EZ7h2rw4P1sXrIF/OijU9HcBPRNeq7fmiR6xghsHLyT+
	HkxowVQdVNzJOWyLAhC66Fn9kg7BG4jhmuXlc8fxNmEUm7JJpGndYErZUqx5hbw=
X-Received: by 2002:a05:6402:270d:b0:6b7:d479:654a with SMTP id 4fb4d7f45d1cf-6b7d47965e6mr298323a12.36.1794564203570;
        Fri, 13 Nov 2026 02:03:23 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7c236124esm752333a12.6.2026.11.13.02.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:03:22 -0800 (PST)
Message-ID: <e5f36cc53b733383ac1d1f1e8c03f73091595edf.camel@amutable.com>
Subject: Re: [PATCH RFC 08/41] mqueue: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:03:20 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-8-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-8-4c998976c6c7@kernel.org>
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
> Initialize mqueue as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0ipc/mqueue.c | 3 ++-
> =C2=A01 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> index 322c3dd98c44..8bbe32d0881f 100644
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -18,6 +18,7 @@
> =C2=A0#include <linux/file.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/namei.h>
> =C2=A0#include <linux/sysctl.h>
> =C2=A0#include <linux/poll.h>
> @@ -405,7 +406,6 @@ static int mqueue_fill_super(struct super_block
> *sb, struct fs_context *fc)
> =C2=A0	struct inode *inode;
> =C2=A0	struct ipc_namespace *ns =3D sb->s_fs_info;
> =C2=A0
> -	sb->s_iflags |=3D SB_I_NOEXEC | SB_I_NODEV;
> =C2=A0	sb->s_blocksize =3D PAGE_SIZE;
> =C2=A0	sb->s_blocksize_bits =3D PAGE_SHIFT;
> =C2=A0	sb->s_magic =3D MQUEUE_MAGIC;
> @@ -457,6 +457,7 @@ static int mqueue_init_fs_context(struct
> fs_context *fc)
> =C2=A0	put_user_ns(fc->user_ns);
> =C2=A0	fc->user_ns =3D get_user_ns(ctx->ipc_ns->user_ns);
> =C2=A0	fc->fs_private =3D ctx;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &mqueue_fs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
