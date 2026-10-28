Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793225386;
	b=y/f1/fUe8MSySGzw9xK9+J+omfpteEw1PDWcO1lSIzw+nRtnYkiBALoEROdH8d0AbsfF
	 mOrvLVmLs+TUuaQ1vo11C6cBwt8+5cq4fypthDccEe4x7zmSHROlEfSe+/J4ymFoBpq+T
	 pDYLffarzJdFz4oMcW56m3MbGi2EJ8McD2LCQBbP/03oOtlSM1Zjxuo1TiOEtTlUdGUog
	 OuxhJZqDh1Bn9phNTTjZc2Y+GLwA++uFFyUgzOyNysH7VKtzjt9NL9C2aoD58CQdU3AT+
	 pun2t4vqQq7XFIwea3P7TBekaRHGz+jLm7zU3Vwh41HBVW9T76mR+ti8URuMPU6rU+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793225386;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type:
	 Content-Transfer-Encoding;
	bh=j5xHrk121VJ6jsiOiBImMpaem11Ex15L22vqkzMRx+Y=;
	b=fIt5Z3RkLzLD7+cUcnyVL4Sk1jnMHgY6wCFdLlSli6ZlRYAQSeMv7S0iM2k2JliHTd07
	 ujHjVX75MHEJchfxq+g6mviSSoZFbcXB6PdCf9jyn1pM30nBYnAOqcMkhfBFXE5+8EOwQ
	 jxaePPHDOKEIypdpV+tXdjK6rlUk2oz571mfitMmZRwxyVRSBNqg5+Dyel1a8Tms22ULO
	 0P5HPQ7+pVkneUET+6prjax0WY07WuqJYJrfIgwPLpUUV2zICmA8WqJReA1/ISD/N5YM5
	 0Jep8fl7y2KWghNUMkXBvDefV85j+Cp9BbpkQP7Tdw8TgUrSzimZMjP0Ql4mM6z+xKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=PNja0RrK;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC067606A324
	for <ocfs2-devel@lists.linux.dev>; Wed, 28 Oct 2026 22:09:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC067606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=PNja0RrK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793225384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j5xHrk121VJ6jsiOiBImMpaem11Ex15L22vqkzMRx+Y=;
	b=PNja0RrK+GAXFseGHRAPgDcQljq0pWRU5IrNz2yhBUldeqB5xObADIbjyjHyNHrutF7Pt+
	rJoNk3kv9NPLEvl8XKZoimFvycT999RKjoXG01AAR++Ak8kkM30MDhOQrx+KtOHBWo5kfK
	yRocWGrPgLWx6N9WURbn5mAhp5Y0UlA=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-15-BliYkdmFNOaOtcDKETvQtw-1; Wed, 28 Oct 2026 18:09:43 -0400
X-MC-Unique: BliYkdmFNOaOtcDKETvQtw-1
X-Mimecast-MFC-AGG-ID: BliYkdmFNOaOtcDKETvQtw_1793225383
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-6768601940bso263054d50.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 28 Oct 2026 15:09:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793225383; x=1793830183;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j5xHrk121VJ6jsiOiBImMpaem11Ex15L22vqkzMRx+Y=;
        b=05jTFrXk4gdvZbcA5URUUwpVMKB4PyfduvjTFUzvNR4Q2H1nWlRtrU/aQ1627uFAjy
         8HE4Cfj+GHZ+34DFsCbX5MTiEiDLMLFtRoLgaw2bTlKVZC3J9M1VUPou6PmuQ59nmM9b
         RnwN1YoF2gjhuNmvsP6arGPkb8JWt4dWHwIKN6lnh2GzK0sRvflEZIGTb1cUInr/yM8T
         V0iLxmx8Hcte/4G0nZjMW/KB2hD9kCQC36sMySCBM7WUyQatZ35EHMfRb0Ue/I3atB/e
         BZ1V0Fyiv8onjuYcVUFNsb0UcZBpeC+VwNWMg8Yp80htx+mT9+KPV1SZwK0PEWWpQxLk
         1kcQ==
X-Forwarded-Encrypted: i=1; AKwUvBw6q/TJ/vYOLOkt8RMZ6iHdixcqqhMR4uXNq6JmGA5NkW+Kqu87SAAKGXypUO7VHuKMGkS1dkHvCxUx2Q==@lists.linux.dev
X-Gm-Message-State: AFq9FYLjjjdP0RFq1ewPb6T+45UaMuacLufQmAEuGhThO08mkUnRv4yK
	/kUHu1s+M86QCPe9BAF5Rf8wS7jZYdauiLmpnjGMT6z7Wl1iZXRRNOuTwer4d+KYtfKeZWuQeS9
	4+xtiqcMoBqXaP8N8luuRQq3QLjgEVIvfOG3tTB9yqKQU8LxiP13pr7YVI/RQ0O78kFj44iFZih
	GKjCf6WfR0rT+2Z+FpYWUJQPedpswQS8ALqNtFqY/u8gFlbpw=
X-Gm-Gg: AYBFou34Qf3g22PysZtbbqUZIsdbqiuei6dWzfmhqozo4A+Mi1LDyS5XpbJwvl81L+h
	O01ROk3aNuTOjQORaLbrTnq2UdoH0P4DHR658v0lJHTNkB3byAPc2oV8AqiNOOn906mp+jcjIeX
	mtARwMCdK6vZaoKnvs3/449hzr3vBETMLkscnF39p5dLtXaiwRvY/CTdiy1xZAKqq781JbKVw9C
	2PtWlnHpxihWLFeolosxfZx7BJHoWVwEE1UazP5BnVN7Q==
X-Received: by 2002:a05:690e:1918:b0:679:ad2f:3fbf with SMTP id 956f58d0204a3-67a8d0047a5mr704862d50.8.1793225382802;
        Wed, 28 Oct 2026 15:09:42 -0700 (PDT)
X-Received: by 2002:a05:690e:1918:b0:679:ad2f:3fbf with SMTP id
 956f58d0204a3-67a8d0047a5mr704846d50.8.1793225382297; Wed, 28 Oct 2026
 15:09:42 -0700 (PDT)
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-21-60743a3dc326@kernel.org>
 <CAHc6FU6z4kX5R3Og8m0dYOHsjFcw+4Btvfe87AGPxy_EWs0E7A@mail.gmail.com> <20261028-zurschaustellen-okkupieren-inkompatibel-d11525ce88b8@brauner>
In-Reply-To: <20261028-zurschaustellen-okkupieren-inkompatibel-d11525ce88b8@brauner>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Wed, 28 Oct 2026 23:09:31 +0100
X-Gm-Features: AclHuK9MzobLdiG2EG9M5KT_ibZzYxdrTghiXff6ZlesOE7YSK8Ag_RtXekxyZI
Message-ID: <CAHc6FU6VSAWQ4RJTO_eLnpqN5qvrShbJeT+ADwiA6ohpq8dO4Q@mail.gmail.com>
Subject: Re: [PATCH RFC 21/28] gfs2: don't set SB_RDONLY on withdraw
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, ntfs@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org, 
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
	stable@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7QT7ToTqp67K9emsiKmTVImWwBpiooMbgNmBl5-5PJ8_1793225383
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 28, 2026 at 5:02=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
> On Fri, Oct 16, 2026 at 02:01:00AM +0200, Andreas Gruenbacher wrote:
> > According to commit d564053f0746 ("GFS2: Clean up freeze code"), the
> > idea of the freeze sysfs file was to make it behave like the FIFREEZE
> > / FITHAW ioctls. This isn't what the code is doing at all.
>
> That's a pre-existing and separate from this series. freeze_store() calls
> freeze_super() and thaw_super() directly with FREEZE_HOLDER_USERSPACE and=
 never
> goes through gfs2_freeze_super() and gfs2_thaw_super(). So it never takes=
 the
> freeze glock. I don't think that's for this series to fix.

I mainly wanted to point out that this behavior isn't intentional.

Thanks,
Andreas

