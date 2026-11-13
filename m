Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794563701;
	b=MUniN0GNki1K4ft9aDu9QTnI+eAUieodxe/vnhB3QspTErUsKnc8JsdGyF6EzqzVVHD0
	 oofo8tPE69qqG8pGxzgFM41GECEEdYzEzuqWLmO8ID1FS3CD5+17igxO3RoC+5Jc2QWHa
	 NsJ8v5qszHPy1KaIolN6cYLWyyacazS5XCEY2DU8JBhgJtZmonyoyxGiJVcIQ41Tf2HZA
	 Uq9m5Gj81GaGL/lbaS3QixUkif1fcSe/qLHb1WBTqHWZQTbLAKbPxzqEcTX46gJI3tWO3
	 wsc8yqbmsfyzM30ETz2y00NfWHq37NPvz9UXOA3nLkTGOoSrewouMsEv4G13qwqKI6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794563701;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=G8DmFU4pJwAPCJlqHBF8SKasEEThxtJNlC1sg/CSkLw=;
	b=v/b6UL44TDi9JDhiuOf9+fRwsw+KwqoIvuyjKPzha2WmhKdndVrnPykSnuMdkaYgxuos
	 tAGEbCUJ8tEMKA/wuGi8pTs9gddW2iNZpVyOTplWtw2F4MLod+Zh5LlZaCfTyOGRu6Ko1
	 ngayXpUxdjZzEU+Eeusxi0bjCrkUpGcCXTMf45Z4LsF7WN2d4Zu3DhYq1/C7b0EXdwaGA
	 pg+p3WFBFGkBjikM+j1PF/iGcknJVjCsUSbgtO1gkpGAQoJDL0KWh122Hh9fGE9pgXiZ8
	 /hhnK8CoLD5Bi4LvZ/9ADg0e8yml2Dji3ITTJx2be3pstJnh8KI9W818HPTukTiM+Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="Pp/iLDW+";
	arc=none smtp.remote-ip=209.85.208.46
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1E660A2610
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 09:55:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C1E660A2610
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Pp/iLDW+
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6b56bbf8330so1172445a12.3
        for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 01:55:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794563698; x=1795168498; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=G8DmFU4pJwAPCJlqHBF8SKasEEThxtJNlC1sg/CSkLw=;
        b=Pp/iLDW+KULLKBMDnLmVBWDK+QDaUtq+Niif6l1EqKwNsNYtPcwvnQTLzN0LEJUP6L
         PGJDotaWKmardus4LLZNBqKDLeC5C760DHoSHYCBjeu9GOQ9nu0DUeM1r3TgFlXbdPcy
         2b4QgvYrhndUcOdRAv48ft5UlYrCX20BkFPnU8mdn/J4gpAqRelBDEhKm+G47Wdc21Um
         dB60lx8fBejOlfSgstrd6pVmDWmsrtkJd4EP1M/XlEbkcm3/IPBAsBPnQ62VuwbnBfxQ
         oxHGU4ZPSKpSsjROdfa5xGV+prmKLZ0Q3cGRMHeCeMEfFndorbVIsFzp5VGEsLT7vky3
         ANiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794563698; x=1795168498;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G8DmFU4pJwAPCJlqHBF8SKasEEThxtJNlC1sg/CSkLw=;
        b=s0HjnRv3UdgEKnMdqCN7IYuEGo99pT/CDrjeyVt0bcY4GuiHrTcLzuON96UAZv9ynY
         I3dS0j6Njt6i8MyOLWKgUlpvP3YGwHn+eB10yAGdm9SHDSeaT41Vy61c+tZE9XALjWl8
         v4Yek7WruEZyrqXki7gkAuDZKbR/pjLEXE8SskbMKviTneVZ9V2gZnS4fTx//WPGVsVa
         dI4t89I0sICQ/1XNyZPlkLLr12eTAat/wd2EF7SBPJWxeg5uDBXJ8SYekL/L9y5IrKfB
         QFuy2FJkHPk9/eycNGp6Gi+Z0DULB+yaaC3yLbx1c+lBmZR6aMRz1tjFTQgLXK9AmSZ6
         WH+Q==
X-Forwarded-Encrypted: i=1; AL+hErFW8g5Kk3sZn0Y94UsQxe0c2w0sYnwKdmyAVMsYjpdWlvUITq7DdpBWEhW+3k75OspdBC2e2b48QkoYjg==@lists.linux.dev
X-Gm-Message-State: APuU4Z+btV43madULObbHQt1f/+Ygb/cKXGviycIHU5d4Elh/Qpr9zV9
	BR1awef1VS6+YkIJcQKFWWCZO2wBn8nwTE4BXLl9dQH7lVPLZW2X35IPynV4uqfSjhjq
X-Gm-Gg: AYBFou35bxDSsVCC71WPmdhIXN2iNGF29g57pvOsZcntpX2qWOpStYOpR53jJYHNX8e
	dwlZyjAw37ePBXlXRHcxow/I45g7p8RBzmAgcEMNi6LdbNjOcYusKEh0AYaXBJ5VF/Hnyzj+Mcj
	V8an1bvgDQWYL3lPPv8kFpvQ/Szh0ja73ckQ68rdWCXu0KaQIoL9qWoQLETEzJT+72wa28qe2LK
	mP3LAkMW2eQQXBx3C/dR0OJRWNO0bw2Lp/tGRRMAAXxEtIvO6OkAgFV0a31LCj4i/7dpFSNxsAF
	VDNaEFtYVhFhniMK5lCExIVGWG1OpGY5hBcC5ltf0UhYtxg/LC7ACFpL7xt3Zk0kRXDHQqDEQfI
	WzY3mSyugL8ADnAtdZ9JG2RRc7CWq5IdsVa6t5lcycnzbyx4zHtl+QGV9eJAu4CXJbhKznpAak0
	4jK9UxpHilvnEDTLhcJETjgGQx+bOSyB4dGbJBAL2k+sULCZ2WsStHkHuCHrzShTxhxT648PJmf
	Yf4ahuUsLUJIh3fqSyp00hu3EzVo6opIlziYB1JG3o3mRq3jalipYtehQdCGx4WAMpN2KlR2xDW
	MMOC/Dej6qSw2qzyPkdMLAKFN/1wZl5wvmZsvs4yXbrvy2f2jiMYh75I3m9FeOU=
X-Received: by 2002:a17:907:ea93:b0:c41:4c20:5a80 with SMTP id a640c23a62f3a-c50963bdb9bmr198299566b.44.1794563698514;
        Fri, 13 Nov 2026 01:54:58 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c50957c6c1fsm75151566b.0.2026.11.13.01.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 01:54:58 -0800 (PST)
Message-ID: <b42c9f4d29a9cbea66929c95cc8f736f12703c72.camel@amutable.com>
Subject: Re: [PATCH RFC 01/41] loop: refuse backing files that aren't open
 for reading
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
 linux-kselftest@vger.kernel.org, 	stable@vger.kernel.org
Date: Fri, 13 Nov 2026 10:54:56 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-1-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-1-4c998976c6c7@kernel.org>
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
> loop_configure() takes any file as long as it implements -
> >read_iter().
> Loop itself never checked whether the file was actually opened for
> reading. Buffered I/O went through vfs_iter_read() which refuses
> files
> without FMODE_READ. Direct I/O has called ->read_iter() of the
> backing
> file directly ever since loop grew support for it.
>=20
> Since commit f2fed441c69b ("loop: stop using vfs_iter_{read,write}
> for
> buffered I/O") buffered I/O calls ->read_iter() directly as well.
> That
> commit was about O_DIRECT handling and the FMODE_READ check went away
> as a side effect.
>=20
> So whoever can set up a loop device can read a file it was only
> allowed
> to open for writing. Open the file O_WRONLY, configure a loop device
> with it and read the contents through the loop device.
>=20
> Refuse backing files that aren't open for reading. Loop always reads
> from its backing file so a write-only backing file never made sense
> in
> the first place.
>=20
> Fixes: bc07c10a3603 ("block: loop: support DIO & AIO")
> Fixes: f2fed441c69b ("loop: stop using vfs_iter_{read,write} for
> buffered I/O")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0drivers/block/loop.c | 3 +++
> =C2=A01 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index a3325ceab484..c96e35c3ef42 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -528,6 +528,9 @@ static void loop_assign_backing_file(struct
> loop_device *lo, struct file *file)
> =C2=A0
> =C2=A0static int loop_check_backing_file(struct file *file)
> =C2=A0{
> +	if (!(file->f_mode & FMODE_READ))
> +		return -EBADF;
> +
> =C2=A0	if (!file->f_op->read_iter)
> =C2=A0		return -EINVAL;
> =C2=A0
