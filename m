Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.225.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794573426;
	b=kI80tdkgvexmK4f6EgSmup4wTHlXwdBGBRs5DIkd/tPM9MP4DQwHs+gMyqzrPx5/TW5F
	 G/NUHAIxZtgPB7s+NgI8maMTkLMYYfhs/PvlyaE76D8GMJAMWlYL8FNCC/p2NTJd4ZFUX
	 vNbJgxZuGF/sf+EkNmfD6FVrHqukprcU7DFXtp6W/Jws+BFDLlYxKwCa0OMlKnjPImoQR
	 NzI3W+Qpm6SlEjIBo27qqfP0NZG3zmhJW+T0i6OK9R9zCdB25fHGaiIKsW2ODJmvmF8rP
	 q0x/dpSTG97lJnvcX4cG7zvU8XWG+7gKUIJf22Gx11QPatapJLRQQuoO3EHtetQ56hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794573426;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=87/Ge5NhXdmtGpcXCLUvnqWpWEAxiW5M6eWOW+m4zUs=;
	b=EzySBf3KofYcqp0JvZLp78k7jlE9ECIfFkvSbpIli2GP1ucZR6jfol1hUUrMjZMO+Opk
	 9H1FRCq+IPa4An6A4qsUXzjE7JpAdHvAXGoPEiprJNz5bVJJy+NlUfcnDW10/O+EHhK7M
	 1FM9l7svIfBqu0sQ0ozJdHonBgGW/ihtV7Ei+HwerG5XIBYesOP7SEzQ5KsYLnTSK2R9x
	 wMuig/tqTZs6b3iVBzmFX4QONQwagmgTuECwIaXJMmmLX9ozo0scogFQU273PtG06KXvk
	 SfpviqQXzGa6zmzYNV6crJYdmF90RjS2l7YaOKTDcxVmIZzIcEw2orsjwCT0O4ZeYsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Tu9p6NGc;
	arc=none smtp.remote-ip=74.125.225.138
Received: from mail-wm2-f10.google.com (mail-wm2-f10.google.com [74.125.225.138])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04F4606A33A
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 12:37:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E04F4606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Tu9p6NGc
Received: by mail-wm2-f10.google.com with SMTP id 5b1f17b1804b1-4b886ebe069so3303835e9.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 04:37:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794573423; x=1795178223; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=87/Ge5NhXdmtGpcXCLUvnqWpWEAxiW5M6eWOW+m4zUs=;
        b=Tu9p6NGcOF4z0zLKEG8rFsAGxhnNNZ3YXRzgBjD+Zgvog4jzGewEr93mY+5QLqeJiY
         k/b4eA3nyJFT5mUkf19NIQbfgFGdNlwzoP+Gk8+ZauW72nC0Fe02lc/nAN0lHw+3/Zzb
         Q7cxGpm8N5h2I1opQc8PdtWBs8GH3ul5+o1cSuGLAsR9W7YSxaMm4TXumFn46mioHsGN
         wsmOFjqXVBlSo4Tx9r1r3V6DBkSTtq0HaddZAyi28yE2e5UZUa2jqd57XSlB5HF9QRFc
         DjugvFJHUM5nIyIm1TAdtnTGyuyV2W9USZt254Vrts4YGip+jRmUTEEn9h0DREuegwVs
         rUHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794573423; x=1795178223;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=87/Ge5NhXdmtGpcXCLUvnqWpWEAxiW5M6eWOW+m4zUs=;
        b=lZQZRxPhzhWIxl9BUQnzWQuhHDZvGSlEdlifre6l7jJsiNLv7UmlaqmbNHFM47f9kA
         wAknrKxXuIvsAP/pBaby8lOwcSKl8YTWgDOSG01UtaRtr7KXCIb3TT8OH6rUBiMl6KKT
         qumjZM9b8m2kLmkMInbNgXU6sEwqRoH7hsPoZD24S51u+cVRMMMbBB6T8aPi/uuGMoJQ
         KYmMeoRZ/J2JQmGQtXO/G1vGQi6PHfb6/jVhDTlt2t2epkNnoLUktiKtOtB9jNYnLpYf
         NTDoYVi5vJVxwgQeVbJleaV+dJmHzK8qjAHPrVNGjSovVTPdExXcAu55+CNPddLLXvZY
         NY9A==
X-Forwarded-Encrypted: i=1; AL+hErFlkkmyazQPqh6JYi4NbogULZ839Sj63KXJZR1eRzpyu58AdGPhlm4U0dYWqD215ytk4qahPeeuplbOMQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z9X0/oNbmb4iNTcdiHLJw3Stkn9CMBblQiKmaYWFeymkRKoQ6PH
	vYPirxgzmqyfiSv1TUI7WShXGa8UNsb1a7/rjjznrlaWUP45ZbKKdqPs5nBdc70n1dYH
X-Gm-Gg: AYBFou0qCMZKRIhv0+8LsFbrdEeTV9R/Q/38eBUncrrcrZXR1vRjqEGO1jSwDUv+qTl
	BIt3hURN5mVjxpcNTTn7HplHr2QdQw46KNCg56BnqEIH/u5XEJ5exvfpGsW+yQ7DVIGFVP02YsW
	WCqlFz1//Ywfv+tiObZ+SFrAh++4rD5sgPgHaIGtMg3tVEHNf2aZv6TQ2HjJyg+aKO3am4fbJ+c
	L4IPMoSbLYyTlRd7yjyraXNcZ6WTBGLIuER0TdaF3fzk5OxGXr5AKP7l+FEF44SxE52A1PpFetP
	CMzloRFL/OIPJv3xTBQYzaeR4L9AcaS+vV3XlUtzDyvley8tnmqxQh4+LERyJ7GIzUyiQBGo22B
	vMghoOkNxYPqJGl9foMMQEowGckfsBRtvApw97grN1+s5zo2iBMAoFckkIGrrTasdLos4powvdY
	bisQSahSjFMSV3yPlJGcNBKsdylDC13/UFDvOsQUvQR5Lpbi/nn9PXn4PFLaPb+FZAD9HUJ9eg5
	kCRLfDYHBytGp0DrgB7CupWbzuvxItrwpIlnAXnwAGXjvs91AvlmN7ZuEvJrNCTZYSoroxB2lnU
	qmTLo3z1z012TYFNYP9FNrjQDMjgwkb+BgOuihxozYIh0MxcfK6oW+1WS4poDpjOhAG3ne8Qwja
	VPDybigAz
X-Received: by 2002:a05:600c:b86:b0:4b5:d95c:2378 with SMTP id 5b1f17b1804b1-4bb55ac4030mr49782945e9.34.1794573423157;
        Fri, 13 Nov 2026 04:37:03 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb55af2901sm57437255e9.13.2026.11.13.04.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 04:37:02 -0800 (PST)
Message-ID: <f12140be54ffc4d1e8e4026f80c41c75cf5727e0.camel@amutable.com>
Subject: Re: [PATCH RFC 39/41] usb: gadget: f_mass_storage: refuse files on
 pseudo filesystems
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
Date: Fri, 13 Nov 2026 13:36:59 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-39-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-39-4c998976c6c7@kernel.org>
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
> fsg_lun_open() takes any regular file as the backing file of a LUN.
> The
> file-storage kthread then reads and writes it with kernel_read() and
> kernel_write() on behalf of the USB host. With a procfs or sysfs file
> behind a LUN the host gets to read and write kernel interfaces with
> kernel credentials. Refuse files on pseudo filesystems just like loop
> does.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0drivers/usb/gadget/function/storage_common.c | 5 +++++
> =C2=A01 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/usb/gadget/function/storage_common.c
> b/drivers/usb/gadget/function/storage_common.c
> index 75831f2c7abe..83683ade20c2 100644
> --- a/drivers/usb/gadget/function/storage_common.c
> +++ b/drivers/usb/gadget/function/storage_common.c
> @@ -211,6 +211,11 @@ int fsg_lun_open(struct fsg_lun *curlun, const
> char *filename)
> =C2=A0		goto out;
> =C2=A0	}
> =C2=A0
> +	if (file_is_pseudo(filp)) {
> +		LINFO(curlun, "file on a pseudo filesystem: %s\n",
> filename);
> +		goto out;
> +	}
> +
> =C2=A0	/*
> =C2=A0	 * If we can't read the file, it's no good.
> =C2=A0	 * If we can't write the file, use it read-only.
