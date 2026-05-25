Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4A13F58C1
	for <ocfs2-devel@lists.linux.dev>; Mon, 25 May 2026 17:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779728864; cv=none; b=Vn6PGFg5cuJB1QIDbWoc/gCx3LlpsaWq/y5Xo+/MoHthHYjCE0fAg7tI6s36iSOzXoxIH2XgqQCRvmuEiTbGGkIJrQeo7ZExzdejjmQTtwJ08aPqTdoWXcI069vEA6mw54B2zEpfzUtCTI5z7CD8IGcIQNZ8qf0QlIyx8Tn7s7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779728864; c=relaxed/simple;
	bh=OfA/02aK6QFazWGWMXUJDcZG1We+Vv4rT2cijFC/iAs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rhDt8AmU/18zh4nQfB/p2eo0lUIx+1p84eJKoLQ4SzUIwJBjeqZorBsjQwsYdx9mu9w7dJhHHXhhqxE2enP1CVrm+fx1jmuNIoRlzxN0kHGo4JJNLABjyHpxmuSp5ANCqcVDzpmfmHdeMFirU1JjtK3LJ0y34gO5RLppxajCsVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZU0dvcZS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZU0dvcZS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779728861;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bQpQr0JjL82H2nIQzETTKVEBOyaYAjIK/HdNyKEHU4Y=;
	b=ZU0dvcZSMDF8n+FaBHKHnfeR04HOCTyN3XZbRdVt94/sv7ieGBX7Q+MUPBtWAehFopw30w
	pGIkLSaiv5N58D1LlgZ9BahEX7WCSB0AWehI9pbqDdG9UXO2S6Q0CRDY4jYOJ+yLy9QZKt
	WOJV6IMNX/4oQMdd7fJRXJodJ0LFdEA=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-67-ojuUvx8NP5mW019UuDrWrg-1; Mon, 25 May 2026 13:07:40 -0400
X-MC-Unique: ojuUvx8NP5mW019UuDrWrg-1
X-Mimecast-MFC-AGG-ID: ojuUvx8NP5mW019UuDrWrg_1779728859
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-7bdd1ef8648so162385847b3.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 25 May 2026 10:07:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779728859; x=1780333659;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QQ8f0KL2cvJbeqS1wq3el83kZ9Z8vH79ZAL6r1+vgks=;
        b=HXDfju3oP5MfXaIYetg5frFQznhEexNnxk764w2+/AOByHVk4PcMqibErYIGyK35R6
         ei0Xfh84aZUBSDM3/+Ua0MKMSJwfKkkjg3/f79SbxzmA+QA83PLBPwT2mYbv1Jj9Ze7L
         GrduxxtO84ycvVDtd51Q80vQoiB/yDHwAODCWTIIPrLs+dQd0TUvph70lvWUHWkzVuda
         jGtuu50PbwX0GhNh6YC7NyxiqP1QcMAeGi5cOUWLQB55WBZAuPnCm4g1wt+Et9Qj9eS1
         biI1INDCeWlrfHmreXHxYG3KhX2LNx1RHMoIAUM0cH7zos5XcXC0LABFdgJ7Hco1hGUh
         mjcg==
X-Forwarded-Encrypted: i=1; AFNElJ/d4tgj2eLv74MCWuGsBOCcSOZHbSyX8uG2zQNiNdkddoQtWKHjfpjY1a+lcoZi0iP+D0SDFHnEhshj6w==@lists.linux.dev
X-Gm-Message-State: AOJu0YzFcKnN4oZYwujIW1aHSFAA1Y94rA7gb6SoGfmwmwqoEqZcgdUq
	mmKFa5AZcSnS+tEj1YKyWaRfWhs99jTfQFdHjklNgqIxGj6vGZLwD/O/dtZVcRdrJr/7fLH4hMs
	gWVflN7XDjoiA/TJrFizPcJTuj/g9LIwcmvhtl9Ey8PyfyLpA4oeUCU3fdHbIf8u1
X-Gm-Gg: Acq92OEfDlpTh/FAGBiXZA2ZaWRpIxtgh8fOtYIA9BW5zla6qpCffkQMhM5ku+xWBmN
	9tjzkKSSZwPSYkY8DqyuoxJ4CcslUj210F0VWyirr1JPURTegUt1ZgIER/+IVaWyl4mHsWAFxp/
	gldXNLDiH8Ibb3b+qiBnXrJvxtbBtSd9MgabqvPrioI5zTcsXXtSVZ9DHF3prmYPVws/z0hRK45
	jOvnkUH0pIdIh0mdWRpa+fNNjXsm7PcGfQIDUnreCLkCmCogn6afvxTPuH6Czm5YpoaVI53hMcN
	dMeJIRH2xNfqpZXKYpAt8mSll24RXzoGf4XMdUVTouVTUptQPwG5GWmWIJ+Dm7TZst+5QBL8GNl
	Z5zIpDve0sd/p1wzPeDc0Nt7Qe98hpiOQpiii3+D2F6UsiK1qFopH
X-Received: by 2002:a05:690c:3708:b0:7bf:9648:8c5c with SMTP id 00721157ae682-7d3345da2e5mr155237607b3.18.1779728859425;
        Mon, 25 May 2026 10:07:39 -0700 (PDT)
X-Received: by 2002:a05:690c:3708:b0:7bf:9648:8c5c with SMTP id 00721157ae682-7d3345da2e5mr155237227b3.18.1779728858828;
        Mon, 25 May 2026 10:07:38 -0700 (PDT)
Received: from li-4c4c4544-0032-4210-804c-c3c04f423534.ibm.com ([2600:1700:6476:1430::29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7d389813ea8sm48480087b3.4.2026.05.25.10.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 10:07:38 -0700 (PDT)
Message-ID: <1bb537f6dc36b00788b613fb8f71579478418457.camel@redhat.com>
Subject: Re: [PATCH 04/17] nilfs2: replace get_zeroed_page() with kzalloc()
From: Viacheslav Dubeyko <vdubeyko@redhat.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>, Jan Kara <jack@suse.com>,
  Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Joseph Qi
 <joseph.qi@linux.alibaba.com>,  Ryusuke Konishi
 <konishi.ryusuke@gmail.com>, Viacheslav Dubeyko <slava@dubeyko.com>, Trond
 Myklebust	 <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Chuck
 Lever	 <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>,
 NeilBrown	 <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, Dai
 Ngo	 <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, Alexander Viro	
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
	 <jack@suse.cz>, Dave Kleikamp <shaggy@kernel.org>, Theodore Ts'o
 <tytso@mit.edu>,  Miklos Szeredi <miklos@szeredi.hu>, Andreas Hindborg
 <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>,  Kees Cook
 <kees@kernel.org>, "Tigran A. Aivazian" <aivazian.tigran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org, 
	linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-ext4@vger.kernel.org, linux-mm@kvack.org
Date: Mon, 25 May 2026 10:07:34 -0700
In-Reply-To: <20260523-b4-fs-v1-4-275e36a83f0e@kernel.org>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
	 <20260523-b4-fs-v1-4-275e36a83f0e@kernel.org>
User-Agent: Evolution 3.60.0 (3.60.0-1.fc44app2)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vp2AB_rlPJCXOIwK6UgXRzUrJNKSwVanVC_WrBE_j0k_1779728859
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2026-05-23 at 20:54 +0300, Mike Rapoport (Microsoft) wrote:
> nilfs_ioctl_wrap_copy() allocates a temporary buffer with
> get_zeroed_page().
>=20
> kzalloc() is a better API for such use and it also provides better
> scalability and more debugging possibilities.
>=20
> Replace use of get_zeroed_page() with kzalloc().
>=20
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  fs/nilfs2/ioctl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index e0a606643e87..b73f2c5d10f0 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -69,7 +69,7 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilf=
s,
>  =09if (argv->v_index > ~(__u64)0 - argv->v_nmembs)
>  =09=09return -EINVAL;
> =20
> -=09buf =3D (void *)get_zeroed_page(GFP_NOFS);
> +=09buf =3D kzalloc(PAGE_SIZE, GFP_NOFS);
>  =09if (unlikely(!buf))
>  =09=09return -ENOMEM;
>  =09maxmembs =3D PAGE_SIZE / argv->v_size;
> @@ -107,7 +107,7 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *ni=
lfs,
>  =09}
>  =09argv->v_nmembs =3D total;
> =20
> -=09free_pages((unsigned long)buf, 0);
> +=09kfree(buf);
>  =09return ret;
>  }
> =20

Makes sense to me.

Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>

Thanks,
Slava.

