Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657339;
	b=gmziy081eSXhTbVxnviYs/UEFfLXfsHffcvRz9iiyO9ZCKA8B4v3JfoSKBO0e7I2jwBN
	 R433proQl+Fg+DLYoePrIo7FdtdEp6oJfReXvlO9F1KoWAjOzxUHapqdQ/imyCZB2R7I5
	 znLWv1pXZG2O7IeR66ujIxLb17fboPqAAGPQVWh/NPN7OIgzpPDIq/Af4pXuJ1L0y9yOi
	 /OsNU7t08/iC6gr/1JMQpH/5IcGb3w8oGkO5oPejJHsVzWu6OtcZsRSDurZU26cozd9yL
	 q3d1olticpjJ6jeiT6RarqBW8rhLu/NRCUOkQ+oVzRbb3MBvLrLClDZRyMvcB68yp5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657339;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=nJvs09p7QWIuuw8YOzj5TR133+2IJ5+yRajckn/hsO0=;
	b=nAbftbImcJdVZFreEYLr8xaBugsRruFOBDSrhKzYBZEzcsl1HjKGc6oi5+m6ektXVOVT
	 mEaNyHcDcfncd43Od7jwx/4LL+FfHbPJAlPev06tJatkybOTr4U/+CiqLmrV8W63XQfUF
	 q9qoLz+LocqzdSZeDDiAyfF+AVeBQtgU4fUMtKTGSyYUrBH7BHP/VXXESUhzQGBYL2NO9
	 8Y2mQWo484OWlDv+/8SUYAojWJ9rrxy/AibAPOZPBrRAzupRZQkYH0A8SfnfEbmOPE5kl
	 Idjq0Bwko89232eSCGfd9/bcNJNh3WvATNIoBZaK5jkVBA8s7/b5NKO+f2P9NfZyQHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EzHg5wFX;
	arc=none smtp.remote-ip=209.85.218.49
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76729606A33A
	for <ocfs2-devel@lists.linux.dev>; Sat, 14 Nov 2026 11:55:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76729606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EzHg5wFX
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c4cdc606b47so373829466b.0
        for <ocfs2-devel@lists.linux.dev>; Sat, 14 Nov 2026 03:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794657337; x=1795262137; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nJvs09p7QWIuuw8YOzj5TR133+2IJ5+yRajckn/hsO0=;
        b=EzHg5wFXockY2Q2XbmZ0Rn0jHLk3CY0hLNC7OoS3RrleaUIl+J6GzGG7YZ4Icf05w5
         Axum0xWvjOs2h25bZpH5InnJW178gL+Av/YpTMptaGuviJDc18kLohTeepllKubM/g1s
         hIoB4iPE0dyT4S1xGaue+1k589ir2w8yCC/z4kMhzDm+IEk4CVlTGK+Lmmgwehsg1x5H
         urnxdrpRqz8y6cwBmGE3tIJKXXERFmoWvaFl1y+yBe0LIcvbb+7WaxvBVDlYbbAPum/J
         9CX9jRbt1BONCtPVPJYOtRpHrgmVf76t3E/KYoYLfkA4ED5xiSUspf2abgm6uyvLdCIe
         GBTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794657337; x=1795262137;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=nJvs09p7QWIuuw8YOzj5TR133+2IJ5+yRajckn/hsO0=;
        b=HIz5T4hhgkQj7WJDuQ2u2lESXVw1LGk5daMiZpemjNqNV37bMhF1BDQgfrwxrXUywm
         REn1zvJOpmm8BC7E3dYJh/p2bV7Y1Xn3mj+zzOnps4vSbHStWutTWYnNLU55Ko3QGgkC
         r25dC81dSAdZ8JCagw8gt1oEDNkOrQeYAVPCyIItqRMAIq6LHtsjFGVDsCj2Ynhy1Z+O
         bld7gyfOBwv8KUflH0+cc47zYPMED+dEZAeIXl3GUyna8MovR5VVzHJqTHvAvuf5yov+
         +Kn0lzvlFNtGbSS0dZoShA+OrfdfgegfN0nYnaPoEdA0ZU4Ihs/61FUeI+TWZDm3wzwH
         SMTA==
X-Forwarded-Encrypted: i=1; AL+hErHYFoOkv1pSGIQwdtmch/pIsCgODleZp3GoNtiZ0AYq/i2z3xAiHe8QFvlOHa/3m6+CUIvZcALMAVy+WQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z8WAgDqO1zLADKndmpYRRbqMHfKVJUF/zdxcd/yIkfkAzhnTAoE
	u3FuxG/a5R0OB/QwP8/fOEyUBa/3abM9WWF+7xn0HX/nVRkx8nBF6pni
X-Gm-Gg: AYBFou3oO7Fhh3UyMl4T5dL84stmuatG1KqGOWsHzk6nb8oAGF7esIVMuzRJtro0YWf
	UgPgWeOb5zQ+HBRA/o546yPIbAMW2RIRXjPPzb3WX5mDJUTY3395PjBb+voTem1YqgUxOj133uW
	kW6odyT2AOVJNPjvHtvvuji2VPZMPj+b9tUKNCUYegJfi9pPP1txdMPA1DosdEPN79VJNo7V1np
	ij2mj18pNZlODyrvp83+tOaVvC1KTvOqj3Npo+D34Na5Wzil3dwjoZP/DDjqctBCw8o5cgcM8HN
	JRV1UZc2sO9dLTQJ93lZoe8xvRCGguOEavydf+gWR4Qc4imk+1hCgbWhtdKVW8CX4Ts83Kzf20J
	LsgeOI0i4mrWNi64XH+el1boZM6tXIlHF0SHJ1YZhosfdhKmV/XK5bBXle0KCQoOmuHwSteUmDD
	XpPBvCI/i4Z0QK1IRxY0LeypGXS+VF7GSq8ZwJMVA2IWj+rOhTVB/pjtNZMPnrYnVsWELIMEw7V
	CAQV1ThufFetoOzoAEPmGPB03ceyxOeNsSQHJ+hl7hdMuMcSQXb6b2mJepu5wbhLrJhWXKNv3q1
	1FikTnhreXzDGU9p1NyXRRjMTw7lN2OdxjIm6Hl42SpiH0H55Aj1YU4hnR2N/CuXJICVBD0Z72B
	5koJOPxkw9Jg=
X-Received: by 2002:a17:907:3e10:b0:c40:231:6eab with SMTP id a640c23a62f3a-c5096370c31mr441592966b.16.1794657336589;
        Sat, 14 Nov 2026 03:55:36 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b41f44sm206223866b.31.2026.11.14.03.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 03:55:36 -0800 (PST)
Date: Sat, 14 Nov 2026 12:55:35 +0100
From: Amir Goldstein <amir73il@gmail.com>
To: Alexander Mikhalitsyn <alex@amutable.com>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org,
	bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org, apparmor@lists.ubuntu.com,
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 38/41] fuse: refuse files on pseudo filesystems as
 passthrough backing files
Message-ID: <avhMN39TECaur0sS@amir-ThinkPad-T480>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-38-4c998976c6c7@kernel.org>
 <20261111151202.GA11391@lst.de>
 <fb1d72cf25d10a960da627f6d93a3e041820ed3a.camel@amutable.com>
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fb1d72cf25d10a960da627f6d93a3e041820ed3a.camel@amutable.com>

On Fri, Nov 13, 2026 at 11:25:57AM +0100, Alexander Mikhalitsyn wrote:
> Hi Christoph,
> 
> On Wed, 2026-11-11 at 16:12 +0100, Christoph Hellwig wrote:
> > I've seen setups where people use fuse to mediate access to sysfs
> > sysfs in odd ways.  No idea if that's still around, but if so, this
> > patch will break it.
> 
> 
> Oh, that's painful. Do they use backing files for that?
> It's a relatively new feature in FUSE...
> 

Very unlikely that they use FUSE passthrough and if they did
very unlikely that it would break their filesystem.

The API for fuse passthrough is that the server requests to setup a
backing file before open via ioctl and if ioctl fails (as this patch
does) then server falls back to non-passthrough open.

The ioctl can already fail for many reasons such as MAX_STACK_DEPTH on
procfs as the commit message says, so server needs to cope with the
fall back.

Thanks,
Amir.
