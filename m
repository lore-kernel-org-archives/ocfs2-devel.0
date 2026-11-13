Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564238;
	b=guKpAe0PeGviZm/Y9fd+0dgPDsiDpmsbzdRRHLNZZRfiXWBhNJ27pRYSZV0BZhmZlRI/
	 dhTKUyk+vz5BUE6t9ExU/0Fv33+ZwkYwWkAdOVwM0GTUUD8UzT0kXk7jHTN8+ulI98ZOv
	 2te14o8jQDTWUxSZi4viyYhZRr64tQrwm6Itd6fMrB7t+CznR/Z0skbHhvoedYS2rupzX
	 BEj03QSwDKrA+oQ/JCJEd1tWlZPGWoXgNNEtfxkozGqYHazUcRyAeI3fnwxDqGlYAtLnW
	 hbWC/jUdo5wDP+QeDRrvvGXkhNmjACnY7tRJ04Mbh+3ExKccLx+ZuQXGDiTzRbaVA4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564238;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=isfwHOSFEU1THdAtyjNR/BymwB+TGu4CpGjFt5oul8o=;
	b=EtBL60tX17ekwCXkolKC8rZSU46DAUF5aLQEe4QPRKU9FfBPGsBdeZv66pCudzkbrBoj
	 4+lVX8Kltpfe24RiJJ5P5WMd2bs/mevHtVGojvQ+5GKBrG/8vQFP8u0IUv+GdyxylUpuX
	 apC/TLSQry6YwszuU+aDZP2nSbLxapuA4BVAOKFKefnIC2lavyhA4bLnSYxvI9FialzVd
	 VjfNXmvS4/s8EhChrOkxq/P1D0t7zuu3h2SAmERJseJmbYpDgJ5TwHRHSq4T37k2DX0PY
	 sb/GurwkFr7lePyNdMhzV1yHotQpRB/Q1tDBbNXt6ntmBOY6AYH9JdHRsbQXxpimMSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=q+lMz2fH;
	arc=none smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DCF606A8A6
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 10:03:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C2DCF606A8A6
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=q+lMz2fH
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b704171bc9so1238361a12.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 02:03:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564235; x=1795169035; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=isfwHOSFEU1THdAtyjNR/BymwB+TGu4CpGjFt5oul8o=;
        b=q+lMz2fHJ9i3ZjybyY+NkVQU7sgwYRyTXlZ+WjMrlNv4qgDUeJ96f51YP5y4KWISsh
         INTW6Ddk59Cg6VNJ2rQRM+UJkEGZREJB1MfKeuCFhrhe5QemJ8KX9wYR9KTdHnxBZxcu
         5xRH0/pVkHe2NjnKa1l/PLhbaWmORZqnS6b4gf1sYNMhN9v0ZQHV+AZvO5/iI9qh74Ja
         x71nDvqD7/9wpgWbzemm94G38fMdL694mQq3QVtHsF5wiqE0FowPDdLLgfMUx63JpXXs
         3vHJZaXJatqwPAiTGDTWQohO2KfvIc8UHDBj8IA/aa+A/wb35COZDzmIU3FIjU4TVIE9
         iRBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564235; x=1795169035;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=isfwHOSFEU1THdAtyjNR/BymwB+TGu4CpGjFt5oul8o=;
        b=vWgYo0muz0HGQUWJxnqoyX4f0upnLTFM9euDKC8VS1ZAeR23TEUGLmVJwLNU64TAK7
         fUlrNs7h+vqT9m2bI5cwt2eEd3l0pwWG0eDziQDBSUoZE+hisUO9mwD2VM8cey0UYjYp
         MxW+ZilZshosAo6NeSpf9WJlIcn8Q0p1WhKtmjgTliO1J7dd6rX1C5BAqKdnMs0AsLy3
         uz86WG4hghnfmbsYgkHoDQs6qc9t0sFzgiz6zSAZyOc/odfEJ301KmoRUm3NIuyU48QA
         g9XhPtdfr2RQYL3v6kz9xyiK67dO5TPRHgq9UHUOw6m+G6+eJ1Xcm6voAm/MFQRl3/fC
         IEVQ==
X-Forwarded-Encrypted: i=1; AL+hErGqkUWhxkGdmZxEKEYd0WOmzpCEwsWSJIjO1c0crvFNALiHr+F7CjQ8r9YevWCCoV4aLxa8+e8quNYEPQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z/M7SXn+DaCckdv/a/85zAOTfAHzEG5JD+U+iNRA5FpD+3+wJij
	Th/R9Y3JWEfxX+seSBhHqIEOkRlPYJLbbJonwMCc8oc1OzBZ3O0MBGSUzBgOj2a1AoLo
X-Gm-Gg: AYBFou0bDHiCBgJpsPJc5pv75YpPHKqqzCkWuV+JEAwqlgUTveI9RmcnstdZZkO9dyo
	c+szl19KNneAqjZfg9vO9uJNgjkOxn3BycXEISOMuSMevojtOF8dJYAZPu1VLd9lW5ULPyWjGCo
	neZ0tv2CoZjFpEg+wEg3Vnwy/pWnncfCBMTsOr2M/YwjomIQR6yMi5CEekhnOUXynLdu3LKT4lj
	oU4vm7cjXI1rwXemnT6iauDNdWdGTD/d1K9WkcI3eU9D68gKfnyhCexPpzWUIOOl8JPp9hWEJS4
	Vy0fEDwfMJmGM8NcsJFyBAdmG9NH/QOYONQrAl82ZZFR00KpDiRw2+rUJQ1ny463tsSX6wFO9ia
	BZ6cy0atJYxZ49N5iNyvkAtowKH15ERDBuGJoxEfDm90ulRJUcl/j9tYZ+pLS9olzWaEXLg3FPr
	a6QeZxSzt1UqH0coDklOtW8YlsntfCTLmv6pfefsFDOKylLZxbvKsVePJTJ/Jdvkh9YtxHKoWv9
	c4LOjl0rIio8DNFs88eVIO9KyYxLfiu/P1E3DC8kWVDi0C972k339fFLByDZYYnN5NmSS3kc676
	6cOZKCooGnpPBxtqdlfGsF7TPunCBAut9kEriv7qPF5fB10QeZYN3c0wRUNYCJw=
X-Received: by 2002:aa7:d556:0:b0:6b5:96e9:ae97 with SMTP id 4fb4d7f45d1cf-6b7c0ccaafdmr1234919a12.34.1794564235160;
        Fri, 13 Nov 2026 02:03:55 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7c23611casm766458a12.9.2026.11.13.02.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:03:54 -0800 (PST)
Message-ID: <16dbddeb5cbb9613dc806b43fc681eb26aa3b0dd.camel@amutable.com>
Subject: Re: [PATCH RFC 10/41] nullfs: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:03:52 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-10-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-10-4c998976c6c7@kernel.org>
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
> Initialize nullfs as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/nullfs.c | 3 ++-
> =C2=A01 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/nullfs.c b/fs/nullfs.c
> index 319c2f5c5a67..2fe24cb97160 100644
> --- a/fs/nullfs.c
> +++ b/fs/nullfs.c
> @@ -2,6 +2,7 @@
> =C2=A0/* Copyright (c) 2026 Christian Brauner <brauner@kernel.org> */
> =C2=A0#include <linux/fs/super_types.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/magic.h>
> =C2=A0#include <linux/splice.h>
> =C2=A0#include <linux/uio.h>
> @@ -174,7 +175,7 @@ static int nullfs_init_fs_context(struct
> fs_context *fc)
> =C2=A0{
> =C2=A0	fc->ops		=3D &nullfs_fs_context_ops;
> =C2=A0	fc->sb_flags	|=3D SB_NOUSER;
> -	fc->s_iflags	|=3D SB_I_NOEXEC | SB_I_NODEV;
> +	fc_init_pseudo(fc);
> =C2=A0	return 0;
> =C2=A0}
> =C2=A0
