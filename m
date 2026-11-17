Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794903967;
	b=QprpMbSNcK3Id0sYQVgu8x+UaXhO+VhEVoeyAQjEFfnqV7R9G7ijm1UYdWB75YB8X5wY
	 68pXzJXUnzwu4uVe6rJ+Iu58ZtSY34AMVZnjo6+VrrZq1xzIyXIMXRJxQNs/RxJ+dkHyv
	 hvVbeaRHOpza6Oqrjx/FdNxgksi8nM3HEh4nNqFQSNI+oF2YW/D3lnQhaK0cT+/9B3Nsr
	 QJJDZugcP91ncpJLmkUEQ66G8ke2cIkUIksED14Q1xUcDZHQ4F0yIugVCbgPuxcgizusw
	 euVAUfhHlmMB2Q86MXy77qpdufMx87iQKsGr+nzSZenU85h31z3ubh5RB4uW3E2Z1ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794903967;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=z/NZRmC5bENRF/WsK1hUt6gARTy1xozW3x04wBCWbAk=;
	b=Kop3MpQDOVyXYiozrzsO7lKSpRFnK2QWcRyNLR/ABMO5sZYI+dPLS2FU4sgECaYPRYJV
	 ye+QYWcJh1T5ytsVd5hvZIqp61Z2GGZE5HXs1/OTODM838W50brzMh/K3pVs9ExHDtLFE
	 oEnEGy5LhfYuzxapoinmL0/vd2aA05qCf/wRUq8mxtgOKYjsqN7Z9ONBdTIJ3YH6W9tGu
	 z/CTAOrchRwBBnpe4b1HGF3acz0R7eamn4UpgHGET9Qqoa1Z9lQs6XTiDMYrCOKMcrtKD
	 zEJ9eHdQf3sELsftFkUgzrFLQjlnwTuUg30NpLczFS+b2IfzKVi7XRbdFKFLaeIPCBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=UEAOLX7l;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1571E606A32C
	for <ocfs2-devel@lists.linux.dev>; Tue, 17 Nov 2026 08:26:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1571E606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=UEAOLX7l
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so7875505e9.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 17 Nov 2026 00:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794903965; x=1795508765; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=z/NZRmC5bENRF/WsK1hUt6gARTy1xozW3x04wBCWbAk=;
        b=UEAOLX7l7cnwnMylb65LK6lGxPXBNYSXhSi4g6VCjlx3u15dXuKJJ17At6S/HsGzXq
         ggqexs6vn/jsiAFSygZEpK/eXu24zeYNDhEt3eX+bIqdQOU7krrH2uAVW4/S6/t7I20m
         xvY6muKC3w7G9OX5wyTrLSj7WIOoFyO8SSNi4wORThA+GQ3ofkoQdeDoOiC93e9UPPMj
         fel92QVVW9w3x0dVC4d1EB3bSzt+Og1bIVxFNuUtg0G0ZUJe79TGR6f/N8bjCEDR2jLY
         BW+lkEDOBfsWAAPxjL3tQbgpzXJiSp1d6PQh3Fy3m5rUsE7Igyx4gJps6nl/+v7iwZHY
         Iq+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794903965; x=1795508765;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z/NZRmC5bENRF/WsK1hUt6gARTy1xozW3x04wBCWbAk=;
        b=U42YHDtEHaEtfYGjnmQqlDXOXJ+Flsq47FZLjw02abJsLOPhWo5kfLiD8vP0vxThhg
         l2o4KSW6JMFfKY8VT3+9auvbrC8AmblynMQBOfhIRworqEna1pIZrD42Qe++W/4oCqGV
         IC/quumt9H4AE1AqSSX81yf2IS8cbcU0vcZhz3NyHc0CUyR/a24EU9c0C3XB7hcA8RHR
         f2mOBqnPx3hm0XXo1ZW+9EPCp6bBdEThLrj+Xw4jRHEP1PwQIyuAoS/0kPf68hKe92jQ
         YlTzudHWxTY9zzoq/rk7XPKKnxfMEZDIDBTWP3m7Np7PhGzG9c/IgiWM83HjyYOkYDZ0
         8jqQ==
X-Forwarded-Encrypted: i=1; AL+hErG4BQwGYUqTQzLPjCHcd0PhxUlpXXa8IqPkPhXuYg99dtX8s1yQt1VwTC0c0xFpvnF6ox08ZxyUfJqrtw==@lists.linux.dev
X-Gm-Message-State: APuU4Z/DzFO+85dYKvvS0zrUtw62EHtI3wN3JhBbZmVxjcnN1TEUVgCS
	XDNurrVPBj+33wIyML+Bw+oukrl6simszThV5CBXvabVi3T9dkk0Gn7nTa2lwYyBla/K
X-Gm-Gg: AYBFou0nJQMuFz+Esb9Lui3vCPa1acYDfBpYb5XL8kO6cEB/8qMcIcf/lkd/5ydckRf
	sUyLmq/+bDeLFGG3r5h2uQV/cgYNWV7twGfM7AUNyG/2rrxbTDdENWP42Km67x8AlX/oAiTnwl+
	zYk+aoPnDfLcToVptaEwwxzwE3524pZY6Bxtp7ngTA7imFLEwcCVMMRhrSVNakGq5E3sYQMjutQ
	pzw05xXddvm8eKpiMQDXsl3EBNJMax4UrBCJc+TLBqvhReoxmcD9ysUUu1lUCBfpmzZUHnfotmw
	tgvJFrYqZ5RoMsgMkA7co5ZAemhvCaJ5DJ7OCq2yIaCgXf6nvz1quLYNqqDWHfLdBqPiNVnQK7q
	3QwDLCl3/XW8Eyq6CBvVxvKZ/4MJb5l3S7e/vMc78iuQu1P+N/GtdP28KTaSIFVu29kj4y0UhVA
	83efc/iX4D41Dpd7eScTtBggM3myYOpD6iX1ZFvhW1n5BfAUBzvinMmVnWQyysyyK0t/0szPyRK
	q8Cd9ZJPTbmWXobjL8URYzsISBb8ND8XJIjHwqTObv6VOUVWJgQSYnbKaJ6oH3YJ4j/nmsNB2Bw
	ZogFcGBZqEkGqsKCYbv8bJq7WVyUecm/cpwbHWa7/ulJ4lINmnW4xMftWN67i7uI2aIKw2FX3/W
	QpzIsU1lz34EseAcl//xoBnOxzY04mSTk4K2AvlOxU5QpioHu5MafUl0O
X-Received: by 2002:a05:600c:5493:b0:4a1:c27d:e1a8 with SMTP id 5b1f17b1804b1-4bb783813a7mr42606245e9.10.1794903965400;
        Tue, 17 Nov 2026 00:26:05 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb7ad9430asm12629125e9.15.2026.11.17.00.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:26:05 -0800 (PST)
Message-ID: <88041240268f70b218de7dfd58c41977d03a60d3.camel@amutable.com>
Subject: Re: [PATCH RFC v3 03/44] target: fileio: check that the backing
 file supports ->{read,write}_iter
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
Date: Tue, 17 Nov 2026 09:26:03 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-3-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-3-8cbbea1cf34f@kernel.org>
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
> With fd_async_io=3D1 the fileio backend calls ->read_iter() and
> ->write_iter() of the backing file directly. The synchronous path
> goes
> through vfs_iter_read() and vfs_iter_write() which check for them but
> the aio path doesn't. So a backing file without them calls a NULL
> pointer on its first I/O.
>=20
> Refuse such files when configuring the device. On the synchronous
> path
> every read or write that needed the missing method failed with EINVAL
> anyway.
>=20
> Fixes: 769031c92c8b ("scsi: target: target/file: Add support of
> direct and async I/O")
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0drivers/target/target_core_file.c | 8 ++++++++
> =C2=A01 file changed, 8 insertions(+)
>=20
> diff --git a/drivers/target/target_core_file.c
> b/drivers/target/target_core_file.c
> index ab9824a4852f1..a5391e57e9aa5 100644
> --- a/drivers/target/target_core_file.c
> +++ b/drivers/target/target_core_file.c
> @@ -144,6 +144,14 @@ static int fd_configure_device(struct se_device
> *dev)
> =C2=A0		goto fail;
> =C2=A0	}
> =C2=A0	fd_dev->fd_file =3D file;
> +
> +	if (!file->f_op->read_iter || !file->f_op->write_iter) {
> +		pr_err("FILEIO: %s lacks ->read_iter or -
> >write_iter\n",
> +		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fd_dev->fd_dev_name);
> +		ret =3D -EINVAL;
> +		goto fail;
> +	}
> +
> =C2=A0	/*
> =C2=A0	 * If using a block backend with this struct file, we
> extract
> =C2=A0	 * fd_dev->fd_[block,dev]_size from struct block_device.
