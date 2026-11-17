Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794903941;
	b=WhgdAbILB6UlfWhIytqO8VY6XFAHbVo4AlHWQ9vJrouHdO+TkUR6ebNsTiRcG4REb6sY
	 vQZbJjyS5JM46z5086EcOVT9iw3D4xbx6f7oNmoqr1CKoGzztkuV5vGiERMPgAX8SB0Ib
	 10D51NhJVHvTPxiucMcNCWYrjA3ZBZfkDfQl6DFDmdGxf3LVUhtTIy6dqGj2hp4T0l7mJ
	 C2xrilVWFkPW6rnDpIzvUfMw4L0/uZ/Hjq/5FtT0meQ03/ZyYWhKpmWNs7/mx8U8iqUCT
	 nDxNfP+/zd2KcWhgaRf9V+A6ZWA2xjuZFhJj/AyCOtkQGFwj0GbT90UsPds/GsmTFkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794903941;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=UGlayfD5Z/El6cdpm6ie0HDMH84kD107OWGXScU9uXE=;
	b=BOgA2ftWM0ZRpb0IUWrK6DsOVkoGofoCcTQ999zdoC4WR85JLZ5y9Sm15rc9AhQQmFy/
	 aGvkPE4lHUnO8dQnVJnW9eZTVXauYHRisppyRWt+bueIyAksdyMb+D8MnQh+LQXz4hEba
	 tjGXxrP9/+J7bGuk6bitkrhEDdjREg3TlJWA5TW2AxjCutEls+D7r/Rwt51TKTJ1qcJ2m
	 uqUm6otPi3AC8g4EEjwwVQ9+Tc94ZcSWDVYXTOoq4Tenp9rs7jZPlsyIbrwvpqOT1o8L1
	 1emryZ9tJcscdDVZYg0Z89SaMmQ6cuwOUEYOv9CCGbeB7RevEZK4PPNgzIBgu4k+zYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=piMT0ia1;
	arc=none smtp.remote-ip=209.85.221.54
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA93606A331
	for <ocfs2-devel@lists.linux.dev>; Tue, 17 Nov 2026 08:25:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BDA93606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=piMT0ia1
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-492690dd5daso4102906f8f.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 17 Nov 2026 00:25:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794903939; x=1795508739; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=UGlayfD5Z/El6cdpm6ie0HDMH84kD107OWGXScU9uXE=;
        b=piMT0ia1t/K9qziJsImmHuFr4wsV/+kcb12WYrQqsKxCZOLaEL/kjkrpWEmwvB4shT
         u3Ce+SndVhNQ9GdkrVeglRQTPrK3N9k1ZqjNqZRFOU3tJHe/s20ifCftUTcb20Ghzy7T
         r3wDa/wR/XQzUom7TlaHKashup/N87G4n0rrB00zZRUpIjjksT9kWRNx13h5TgJYH3DM
         vxSqISdFDTS3wsgq3r/Y49PdQjHKkTBT8/XzHzbkbb+nwhN97BfRpAnKLJfqD4UCz0rA
         vaudwb2beXfmA9Drc8hnIZ15ieFKTA3Q+ndphF0riwk/ey73PGIbg9RPQdCRnkFbH3g8
         5Tbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794903939; x=1795508739;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UGlayfD5Z/El6cdpm6ie0HDMH84kD107OWGXScU9uXE=;
        b=Jil0det+4rJZBD3iDrai+9a5sC6r1Dp+VfuxzGhj19d0jHabfSyKXkcy5u/uxpVUM5
         wJez/rIHpVG9apdW3kdfLS1PEvmNeJu/itHwKiFA9u9nXW1HEn9Y9/mwBdJQU8aimYGJ
         zMJ3QlpGiHZYEjzosGvYIol1wGkKr3njuMQrRWf0aGmKCGvuXzU/5uoOnzg933rbR74v
         IYYjBiKDY5N+0MjPDZ6mKEzDv9NnyTehCSh58t6O5iFEWDLoMPfHKDT1MearuGR/mCvY
         CXwwZk36uczFYoSqz6Ao7Izuve0g+A+QbUOKAwSA9oaPIeUbCkujMTF04EurqDJjaUcy
         NkAw==
X-Forwarded-Encrypted: i=1; AL+hErFXnTXcsBQqpxR0Q1gGt3ieB390jEYrlf15CNGPjUNLjUbPpmSui2X1VmZVtTZnENScJqARffuJ75hjtw==@lists.linux.dev
X-Gm-Message-State: APuU4Z/syFxmNQsEAdNEY5G2TKWbC6lzUYo44/LJnSrKBLemvmoXcLzI
	aqx+NJtcGgLDOu2I5BpSoJpw3Vfe4XBD8ewOAz1Wi0Vy4DJmdbZMYn1klW2CPa03QVpq
X-Gm-Gg: AZFdTZdLavBWtP3M3lZeVDxa8oVqnX+pelMS8g5jLOAn/OOPzC6u+HXzuet0A9kCgy8
	lL0CqJm6/O0sIBgQBF5IChjfKPySCVfVA/SP2Kg1iPzwYQSh12l6c/OwwzbI/GTEkcPyAzkL5Th
	mYhUgZG4FoT0tUUCYVdQoWyvfbB4nQOFSK6OeRKJRabvhHekvRdyAZH+GgroitKUilGdVBlhAqh
	xQ6X8Hxz7bW1UT9OPan5PaHBb5OlUS8EwP3wKWLz3UWv53OEcPGpNQjoN5aLhXB6Cov8X40SO13
	SWny4n5L3GzlEDUEIPT7XKEn8N/QltbE9Zhv+RMU5tKgwUNSDOs4wgB+WYhtdydw/TyfAX0wCHr
	e3uAAkPUrUabGVF8lCTT+08b7I7lPyN5UmbNwNUaECVMNTi6NIsHcquXCcScyi+eHlfCq26Y6Ow
	vQbin4+smxm1Xr5xkQvPhvFUdqk1oaMLnUlbr6j8jgJ6OQVYTBCK89lvMhfTlQ6kZUCGWWfiZn8
	tLBjsxODIXkiGUyV3AsQ/kw+iJRUJTRjxCFqDA9UrTui8m+aeQ5YhjnWfCefVgf3SuYYhSyRz+n
	JQd/iXL9hveuPi01KX/eh4uP5vOPX8Zp22qHBATEfMMSw4fZsqGtBiBO2CTy+9fWuhzD29FAwbf
	E0cKBuupbpfXgbC7d7LBzNBHW+U+RAGl057fQhClIXn5GXmpzESM/Fdy38IgkTNfxCF+M/8TToh
	whBQ==
X-Received: by 2002:a05:6000:2084:b0:492:46e:d4ce with SMTP id ffacd0b85a97d-49c6fd932c8mr25238543f8f.13.1794903938925;
        Tue, 17 Nov 2026 00:25:38 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5ff2be55sm26907832f8f.28.2026.11.17.00.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:25:38 -0800 (PST)
Message-ID: <a9124bf1c858cef3e8ac06b1b2396dcb0e19e2a5.camel@amutable.com>
Subject: Re: [PATCH RFC v3 02/44] nvmet: check that the file backend
 supports ->{read,write}_iter
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
 linux-kselftest@vger.kernel.org, Chris Down	 <chris@chrisdown.name>
Date: Tue, 17 Nov 2026 09:25:36 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-2-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-2-8cbbea1cf34f@kernel.org>
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

On Mon, 2026-11-16 at 12:04 +0100, Christian Brauner wrote:
> The file backend calls ->read_iter() and ->write_iter() of the
> backing
> file directly but never checks that they exist. Everything that isn't
> a
> block device ends up in the file backend. So a namespace pointing to
> a
> file without them calls a NULL pointer on its first I/O. Only
> buffered_io=3D1 gets that far as the O_DIRECT open fails for such
> files.
>=20
> Refuse them when the namespace is enabled the same way zloop does
> since
> commit 0c10f8a1a7ae ("zloop: check that the zone backing file support
> ->{read,write}_iter").
>=20
> Fixes: d5eff33ee6f8 ("nvmet: add simple file backed ns support")
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0drivers/nvme/target/io-cmd-file.c | 5 +++++
> =C2=A01 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/nvme/target/io-cmd-file.c
> b/drivers/nvme/target/io-cmd-file.c
> index 695963dd932ee..dfa8aa46188c8 100644
> --- a/drivers/nvme/target/io-cmd-file.c
> +++ b/drivers/nvme/target/io-cmd-file.c
> @@ -47,6 +47,11 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
> =C2=A0		return ret;
> =C2=A0	}
> =C2=A0
> +	if (!ns->file->f_op->read_iter || !ns->file->f_op-
> >write_iter) {
> +		ret =3D -EINVAL;
> +		goto err;
> +	}
> +
> =C2=A0	nvmet_file_ns_revalidate(ns);
> =C2=A0
> =C2=A0	/*
