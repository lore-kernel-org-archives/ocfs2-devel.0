Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564705;
	b=gzCmORB6k2wbsmqq+nLaxHjbrAlwL2VXyzjI/13xqhqr2pE641FT/Vkfp2ep7dSWav9g
	 YiGU0VS49yf1cHH6KgKYruS4n6tKGkogAvySATsjEBClaLJHGRKpgtJNxZiBSwFM/AjbC
	 cpb7xmF/NdnkY3OtBpXUqExrLVu1n0v2metU9TjqL74nMSgWff97Vtx1nSBJIMgMacgPx
	 P8fzYwGamPZfcatYhfqllWaYd6QgK22dJH+uF9sO5ONOwG2kn2B1ozljvVsY2aiR2Rh5k
	 wFMC4o1LISNLXpN+TtuhpUaAnRzRfhD+mWzGionPSRuk6ow69FZHJjKfDTMP3MpgyJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564705;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=gXMsjTg9KyNTuX1cuQ9yr2iJq2/VClhNCtHhh+FL0ZU=;
	b=yef86WZQR90GPxawipbGp6L8JVzujfOvxa+PejtS0MfLU41scLYgwJ9cSGS2aHGzOEhy
	 0R72jIe0/+Kfpbek7gSDYJR3CH1xdCC3PfzSy7jq9aePw1N3o7ucRMd87cmrA8W6wUxkg
	 yXzemWWcgoqAHWUapP6+V62jPWp/8zpB9qEEWEdR5NEegpHnqa4zccTCH9Xf6wMl6IHcK
	 HzI8y4srUwIrD1fbX2hMIeWMSqnJnbYj8yH/cb+XjhEkbL+Tm+0O17iocJZEGc5oZF/8f
	 R9uhYwKda4KgL79dKgtHSru8Sg8eEesw9hHUQCei4C9MVOdkalSB1igC4EoU4mSiT5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="j+p/KZ3w";
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9787E606A88F
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 10:11:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9787E606A88F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=j+p/KZ3w
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-492fcbfaa88so323600f8f.3
        for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 02:11:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564703; x=1795169503; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=gXMsjTg9KyNTuX1cuQ9yr2iJq2/VClhNCtHhh+FL0ZU=;
        b=j+p/KZ3wnPwEFYF7F8WvNMoh50Zte0ElviyUo8TGwc6C6lwi3UkoG3t4wDiSzNyX8h
         z27ekuYt+mUh3b4RDsAVd7R8UfZjBu9et6oDxa0Hk+9g6UEzsjKR3SCcR1lLNn2RKqz/
         mKBysjufBSNI4rMp25/G8cklC4oX8zwxCaXbZpIUuEPrvDU2KbULI/UcekyN7NSyNul7
         bzQL4NYVP0a9I3LXIMKCXexHeKjRgS6bF53RBQCLKifyU351o8xMfNMp6ZB8Tg0bjxvf
         K2c3ncZU39Ck0OlZu8ev4rOLPihGJc4ZyDSU5ryvBFGL+DePL3iAg5xr5/Np60YX/h7n
         S9Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564703; x=1795169503;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gXMsjTg9KyNTuX1cuQ9yr2iJq2/VClhNCtHhh+FL0ZU=;
        b=NHwUliDTwEdE8rvH3RcaAOk6fg8N4KvZWMnlFYxTiN5/6fBlCzzIvV/MfZfyLwqgNx
         J2F18pM5QdRqzly1ZkmyXxTlfhna4wNvaYqH6nfdbYxm5iFmrM+ZlMf9HYglUP71KbLe
         cC2LV6tFBniekzq8GORGwSoFSAVPNb7DCVM86kMDcO6cS4pew6DkmokZFRjWLGdY6DCP
         5XpEiImtfgr+MDaZRxm1qwBRtkEPQyMn2PxSFr2w19w40aeYTWE5GB3fuffjTV80orB9
         W0aQVOC2ea5WZoKlj5lW3lR39dG+D8eq8kR1j0tsBA3lsvbwLgakHQhkl+OaBIOUcSyn
         Tvaw==
X-Forwarded-Encrypted: i=1; AL+hErEzhpw2KQnKZNZbXwFMFllFEcTrONk9RYIJ9YyfjPlTxWKaCnRyACg/9xVeID7EafuaT3juJ4sNUrjhvw==@lists.linux.dev
X-Gm-Message-State: APuU4Z/MI1QtFEzMobt3a94YmoazhfrxL4KevIkEpp/n4gldcr3J3rYx
	SDaq90VPsHCwBKOLvI4LU3cxpxWGbNFHO5SntOL15LenAdvM5Oh0bC1x0H39xNYBS/rG
X-Gm-Gg: AYBFou2GvVYOlvOMgXiQ8+4j0Mp3/flxxFev/x/EN/IPqsYH4w58I7pEZaf3LzI4rD3
	jMfyJ+6Z3q4ovKQkWMUE0QW8CekJPkNYVyO8L7yus1wi4iSGAV94neZBvLxVSqEnJptHhEtKq0J
	ysqnqCQmlLgKGbstLe/zeCZkyNOD8AYrCMTtsqeD9A9qFz++PZEnpSg88EzSUaPlG5OlDoKYc88
	NuF6dlNS0OA79yiDfeyI8/WcT6ed5mj0WSo9v1SlKGZ0kmyT0OXiz/L8BVN4GEOXGbTKLIQ0MWI
	65DjjG+vcym5MILO7G7Dyph4l0V/d9dXIXt4cAO35m9Fu5PWcCFosoenbnt2lFTU4gxFPYJCbkU
	e8M91d938zbzZz6XkMrAnDyDtRz8loYnjku4ouVIdWu+m97wj9c24FSuBax7k5n+FV1WqZWSieK
	UGwOnd2GBA8rVbv7uzMBaZ8F8X5+pXfX2xgGuB5VTX7DZ/UbKlpH0veWAHsDcrlUcQZwOjkfoMf
	elp7GZzO8VKvwGSn/gf1C2POjzpAZ1nQibgTWbuGtrbf0wGCPMEc7Af49/KrLutdflyMy6lGzNU
	z3OtCBAS3M4HOMcttzJRLXy3zTfkMJ5f3SHJdz2E9S6reRcEqwongGClpg0U380=
X-Received: by 2002:a05:6000:2501:b0:488:88ec:59c3 with SMTP id ffacd0b85a97d-49c73259cc3mr5012611f8f.14.1794564703010;
        Fri, 13 Nov 2026 02:11:43 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5f1c1797sm4931434f8f.11.2026.11.13.02.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:11:42 -0800 (PST)
Message-ID: <ff6d2a8c8623f5476d5c352dac1ad98ab3da303c.camel@amutable.com>
Subject: Re: [PATCH RFC 18/41] selinux: use fc_init_pseudo() for selinuxfs
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
Date: Fri, 13 Nov 2026 11:11:40 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-18-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-18-4c998976c6c7@kernel.org>
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
> Initialize selinuxfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> SB_I_NOEXEC. selinuxfs never holds executables. SB_I_NOEXEC also
> refuses PROT_EXEC mappings but the status and policy files are only
> ever mapped for reading.
>=20
> But selinuxfs needs device nodes. The kernel replaces file
> descriptors
> with /sys/fs/selinux/null on exec via dentry_open() which doesn't
> care
> about SB_I_NODEV. Android init however opens /sys/fs/selinux/null by
> path as /dev/null doesn't exist yet at that point. So clear
> SB_I_NODEV
> again in sel_fill_super().
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
   I.=20
> ---
> =C2=A0security/selinux/selinuxfs.c | 5 +++++
> =C2=A01 file changed, 5 insertions(+)
>=20
> diff --git a/security/selinux/selinuxfs.c
> b/security/selinux/selinuxfs.c
> index 310e19efff1d..d7ae853b6d68 100644
> --- a/security/selinux/selinuxfs.c
> +++ b/security/selinux/selinuxfs.c
> @@ -18,6 +18,7 @@
> =C2=A0#include <linux/vmalloc.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/hex.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/mutex.h>
> @@ -1852,6 +1853,9 @@ static int sel_fill_super(struct super_block
> *sb, struct fs_context *fc)
> =C2=A0 /* last one */ {"", NULL, 0}
> =C2=A0 };
> =C2=A0
> + /* Android init opens the null device below by path. */
> + sb->s_iflags &=3D ~SB_I_NODEV;
> +
> =C2=A0 ret =3D selinux_fs_info_create(sb);
> =C2=A0 if (ret)
> =C2=A0 goto err;
> @@ -1955,6 +1959,7 @@ static const struct fs_context_operations
> sel_context_ops =3D {
> =C2=A0
> =C2=A0static int sel_init_fs_context(struct fs_context *fc)
> =C2=A0{
> + fc_init_pseudo(fc);
> =C2=A0 fc->ops =3D &sel_context_ops;
> =C2=A0 return 0;
> =C2=A0}
