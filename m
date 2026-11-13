Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794565074;
	b=LfMt284SWTDVs543qJxT6cD3UAv7hdLqFUT9q2WvLA4cQkPK28v9gzJ/MXnUhMux8416
	 uOLxfxUq7PKLktyzWkstvIMB9OB9bF2CtnHLitDZOLIQDm7L8w8C0mxqJhcLOtqVHB4Js
	 /K1oH3qCUVz674WsUGd8sU8bTItQYiO6IdijJ9yZtQXNGqq3paqB90QW439EYL72JUBqX
	 w2PnhLv+Zt1fbj5PJKC9jRZQxXpBvtoTv5TGuxV2MrXSqohtWn0ywfbv3GNkhKKyesWqA
	 6+9LgUxcr0OaGzhkMGpl+S3RTXOqUhq8bvIQCoRT/8uD8E6vzLCfpLq7P5Qz0TgSo9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794565074;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=zqPqkCGOaO5RL/5NE1UeXRxAO7AqEHmUDDsiHSGxDsA=;
	b=hyP64LRKiHn1QgPRFQ/PuuR9Iea+itvj+aebuirs2eSuLEM3XOUkbs5OZXWOuDKFTsnW
	 nTWrh7qGZivCjh5US4w/vgLbMgEwx9NTIBD3M7Gjhyg9NOOG+jLc8o3rMDF/O6uNfMVY0
	 ue5945Qaod2r1wze/j4+v/arJ5usV5nWc8T5ndQH3mD39CNePCTx5uM0gwO+9NulTbZ3s
	 5Hc4iacVD6tNdaOLDscQs6OV/w7OtUmEEGo6vmiBP3yKxIY6YJnLLG8GWOP6bFu1BVP2U
	 tMtQ4wvyi9yi4c8JkOFwI7H1EFGWWWRhsLd0gRc4ODsAvdcO5L/zt8eO/hR7mOscUng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=qMxZ3N7T;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72534606A890
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 10:17:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72534606A890
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=qMxZ3N7T
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a35d5d4a20so13807575e9.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 02:17:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794565072; x=1795169872; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=zqPqkCGOaO5RL/5NE1UeXRxAO7AqEHmUDDsiHSGxDsA=;
        b=qMxZ3N7TISx7XpMNQRK1jnKLlhEpRTonGMRKIMPpHSGe/Juw2H3Cq4zhDtNAfATL4V
         w19mDU3JyzruRSwgm2fXw9kyP7148iS7PY1cAMcPpKKxK60KknSMnY3RDU5QNjIiiHpS
         S3mJb7gOnfWqCVox1oe+DUcxJ5kLan/9cKAH5aiNVFkZhLJCN6DpJ45uiXymbzqKGV02
         8NbXN3D+pizy9ARwTjDgH0I23olfUuG4UNSZghjRrsSECyHAnOzY1Frc50SMSUXy+7+A
         4qp3u38Ca9MfquRtxlFK6sunOEBbaq/EJAr4iLwy8WwOC2MbMrGIJ0WKrrIYWcY5JRxH
         PVKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794565072; x=1795169872;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zqPqkCGOaO5RL/5NE1UeXRxAO7AqEHmUDDsiHSGxDsA=;
        b=Ovmpo8JUb/0uTnxlQsu1E+IQ/wLGHaF2/ok9sNEasXy+WuEL+8cNSJ0ta9RKXSjuck
         qTnwktm+RPbGwC1tmNVT1gecFT1aen7jRFAhOmTtkotZ4GO7JBtESCND7uK58+z1i6gW
         etKXzWPfWOfwwDu4ZEAp42UcZRhv/1hiEzG+uyfhZRoKzX+7QHOlWt3M9yE2DgiT6SzQ
         jaeevtaEsVympiB1NL+wHtkQebylj/N6bc00S3209Mnm8kjQ0GXOPtE9znkBCjcFC8al
         3NMMe7B70YdVCoTi4N50hmpjTQ182E04fvdOE8x06jvbsIZmSpa8tAkm4kB8OrsHKXEW
         HdDQ==
X-Forwarded-Encrypted: i=1; AL+hErG2nNWhpGxrvqIjuAxgiXO7M2lEqbSCJdc1yPA6WlsRW8g1G9GcQQFhQq86ZYF2tmhyt5Q4WAweSH08cg==@lists.linux.dev
X-Gm-Message-State: APuU4Z9jfAhyPxbh/a5F8ZUsKH7eLYiKH1/Egd+KFl4tv3H8xOqariW/
	R+R5FjfAIyxNaQL+PUlKdjYRzo85L9giIeDjnERdM50j14tzSWarwhCWUTrkctTITzoz
X-Gm-Gg: AYBFou13U/yYwvxVbT+0VNiFMjBXiceLPrYRBXg1+I0I4An4BvKIZpT7GU13bHRTex9
	I/8YTHhhTN+zOaJUzIjm28ZuvxV+QC9dnBu5NkD+4aY7NVhLUexmeJNbMXNLEHOAdDGfnIlfIiZ
	pwcTC1xyLCZjS7skgxzUQjxi3YtZhlJ1m3p8SNiWM4F4xrc0tWpNFknuGsp5PWQMB2ahlFYwVgM
	N5EiNVFNBKVC5K4PxycmsLHekkNWShAjmO0AmxbKYv+/4mYaLAe3njG4jjTBJacPeSmmn+Cef3O
	+xzDpQh7GXPhTGXNIkKw5GMBhM7LcWAEqWzkwrQPRhqgam5Q2y1D8eK7M5wOVfjcL3ceCwaMrOU
	d2+Fink+eChH0iayuzRRr5mN1pHzka/BtlxxMNSvFV2x5GRBo53AsDAWjQoE70/u3xbKP7nUrtK
	/R0s6+Uft/Shy0a7SOkXLmkZZVkQ0S8YpZvLRiQBqiF26Z6l9XlKHLI2vUQRHtcqdVqQq7kCgW4
	8g7SpSteU5v2TEno/JJZE3JQJIDBf/SvnnSXklb8xkRovwmm97EQtTCHZpv/EBEmWVHhAt9YRet
	JVTTRFEcOdhlCvLGnj7BcruMQKxXsrnGKc8ulcsM344bcL6DaQNtIhj/tibtYm0=
X-Received: by 2002:a05:600c:45d4:b0:4a0:23f:8b0d with SMTP id 5b1f17b1804b1-4bb559f6f31mr43851425e9.2.1794565071804;
        Fri, 13 Nov 2026 02:17:51 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c7da37b19sm3937770f8f.5.2026.11.13.02.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:17:51 -0800 (PST)
Message-ID: <7cde6f3091f9d90593e4a6441723b6b889cc4024.camel@amutable.com>
Subject: Re: [PATCH RFC 35/41] zloop: refuse zone files on pseudo filesystems
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
Date: Fri, 13 Nov 2026 11:17:48 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-35-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-35-4c998976c6c7@kernel.org>
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
> zloop opens its zone files by name below the base directory but a
> bind
> mount can put any file there, including a procfs or sysfs file.
> Refuse
> files on pseudo filesystems as zone files just like loop does.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0drivers/block/zloop.c | 5 +++++
> =C2=A01 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
> index 65634a39b0bf..dcc06dd47b04 100644
> --- a/drivers/block/zloop.c
> +++ b/drivers/block/zloop.c
> @@ -1137,6 +1137,11 @@ static int zloop_init_zone(struct zloop_device
> *zlo, struct zloop_options *opts,
> =C2=A0		goto out_fput;
> =C2=A0	}
> =C2=A0
> +	if (file_is_pseudo(zone->file)) {
> +		ret =3D -EINVAL;
> +		goto out_fput;
> +	}
> +
> =C2=A0	if (zlo->block_size) {
> =C2=A0		ret =3D zloop_get_block_size(zlo, zone);
> =C2=A0		if (ret)
