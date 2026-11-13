Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564337;
	b=pG0hKBLwyFbfsd26+dEib04MAM01y9eSCajNQdcgauVKjZvtzsdb8OSc3d4zFqNk1upo
	 fzYG0l1OArShftnW3urLTC0aRqhjhnolh9SaSB9OZbuyQnJoPGfhH4QJOeELCArEsqQoL
	 sTOCs5/17qc8L14jE+sAN4bnd/gFsUrqwvafF5Ib0h8s1YAEystM0z6nkJLbCL8UuJ/Aq
	 Y9Zz6w7S9oPPbX3sLtFn/yqqOUByOwsCi6XRF5bkmdepHgiscXTwzPI9xBEQUl3d8j1lh
	 hOVDSU4+oq/G/lnj6iPJ05vXORxe4jEPRQ9MHWu8TzHG6Xd2Nb24IGxpd+USrLqVHzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564337;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=fNM18G1T3F0ezY9f7dMoEwC6d3kOVWk14Z1vuqkOGWM=;
	b=2z59pnujGgirk5yLSzHjqfSi+38EgO+WSOYo2wKHslWAEArpKRlpF5GtYNZVjZS56NCy
	 FRXr8SW6gXnkBR514pOjOKyG4FMg2sEaHA8zj1Nv+Cz+oqJQ0+uBmRq9UzAY9AFUdHnkI
	 MQ7C5gilKrO0K2p7V7ZQYAEdl2nspQWmLEoEO5O+eMqr3k2idMz7e5nVLdwjk+WorHcDC
	 j9h/UInA3d58lRCG1OOxgqtu2Zx8duuTmR40tA7jVHCewyM0ROoqnkWNCHxBvXtZvz2p/
	 /8vSGuJWWIZU7/06FBFwFsQDjl+K2xURoHPkJdZoPbhd8boAFZTuE71zfhLYW+ZMFjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="Jn/dkLNl";
	arc=none smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7989606A8B3
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 10:05:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7989606A8B3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Jn/dkLNl
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6a642495d81so1310615a12.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 02:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564335; x=1795169135; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=fNM18G1T3F0ezY9f7dMoEwC6d3kOVWk14Z1vuqkOGWM=;
        b=Jn/dkLNl0ovyerSt4MCl59DKCIiOZG2u5ryQ7WeMIfqMh1uM9gm96UnKRB/88czBv6
         TbeCRSp2bJT5bCdy62R0ppvlrW5RVM2zA+RY68PTTrCdUO85tcEVk8BpaE35qNTTD7+H
         dzsKzFcaGqf17Tdljh2ByjACa/M62fPd2OWZCQ+P4XSUI1AH78MLGdmg+BSRUygRaojZ
         llWgqX1/ON+ZqaZSus2UwB6par6plJib4y+H5jfABsm6L/FuIghBXx5cxMUk8uJS6dyt
         iPxcIaQD8iLziRYGqd9VzzCVjociVN+VG4Zt6XP7UnNt/Xq+cpqZB71++3e6LLADqHr2
         iNkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564335; x=1795169135;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fNM18G1T3F0ezY9f7dMoEwC6d3kOVWk14Z1vuqkOGWM=;
        b=FSjWbqb3vqPlODCVVES5FFyI9EfKf/9w+LErl7Hwq9939QPTttIXHldZN2wT+QU2J8
         eDQZWFQVl15vCE2tQcYeJJtSzJdDAVVsa/vMSaxZlID0qtSHF0l/cIBhCDwQxtT7ktgm
         A9AQS2iq7Rm85ksScRCN9Yw4jcdni0c3zA4/OSJ2wxd8SY7mea2TMuYvVdj8p9bws486
         QsEveR/LbdFIIjbk8pBixICD8sSN2a4Z97JKTGCFiutqE84R1/B1++LzBvhQe34FlmVo
         C1/Z9dtUBEw4zTu4bcPCveMxjExH0V4c7RhItsH2qxAERvD/S/SRLVehFkoFNF75N9Sm
         IB3Q==
X-Forwarded-Encrypted: i=1; AL+hErGQNY/KhefcvePYhPWKrKrQ5WQ9s55AeBhAxh/6Pnrew8pYJgEuw5W0sJe03+f3XOybyE9tMoZ1w5LGcg==@lists.linux.dev
X-Gm-Message-State: APuU4Z8oVi4JSJB7xw3As7uilYMzh2t81KTUALZV7MFElF5y5K2wbZvC
	l+SF3P4sKrE+CYA/wGpIX5Jxdn/9DgFrde/JDVNhtJqykA2FXUPeMgQ07dGBvx77GhLg
X-Gm-Gg: AYBFou3m7du1mbw1JYn30QVI8eRpjFQYrqPLCwjFS6FE+MRprpMmzZB2eH8xdsJzdPH
	g5P7E35vCnaTZRHAgS0Zl7MfKdxuS85zKNMz0pWmjwLl9ysJJEEMhQ91aJ1htOEYlLX0uB0f7Yp
	6fRMnZsmqRp0q+5s0/GHxh71zEX1VChmBeOTWqKm6YXXZ2xLSMdVHgOpPNzDeuwsk6ueZArAIGO
	y06c7hqQZQQcH9GCBhrcopqed4MXagedSY16h2BQy/W+D5pcTeE5Fy9lJoD8ng881IufFhmfnzw
	bBtVZ2yakGprWMXehJJI+FnGiwdRN6UxZdPqQCQ8kh8Cv3MhESU/EWwlF+oPJW00kKpCIfb3BLb
	S4mdzN7hNjXXdE25Ht4OIfFWNc95M0ye9f4+0e+PJ5uJShdqcrESTjF6Q74YprycySywvH9h3vp
	apYkcwSkWLQWXT2xGlnOovC/SfnttJX/ZosR6W2WMBjvJ7RpFACTaDfpsoGDiLvSGtVfd7BHmtg
	inrT6+eU14KWO5FwIUhHd7GzGBqlmNJNtHviSEdA68y1IKe4ycG/AFLVFAJk0NbyOCg340HY9K/
	yFlAiwvdchEU4bSZdVIZrpy4P0Wv2xV+hKCGdioyAgFHtirWiusfoyEpRGgaK6gXZLLjHSSi7qv
	gWIlYRX0G
X-Received: by 2002:a17:907:608f:b0:c43:eae5:ee80 with SMTP id a640c23a62f3a-c5096398b03mr148720566b.17.1794564321873;
        Fri, 13 Nov 2026 02:05:21 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b7b2c9sm75811766b.73.2026.11.13.02.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:05:21 -0800 (PST)
Message-ID: <08fa1be263cf4a3db6b3e5ec2847107fba7acfba.camel@amutable.com>
Subject: Re: [PATCH RFC 13/41] devpts: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:05:19 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-13-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-13-4c998976c6c7@kernel.org>
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
> Initialize devpts as a pseudo filesystem. This raises SB_I_PSEUDO and
> SB_I_NOEXEC. devpts never holds executables. devpts_fill_super()
> keeps
> clearing SB_I_NODEV for the pty device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/devpts/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
> index bd1e8eb26edb..47ef12241d92 100644
> --- a/fs/devpts/inode.c
> +++ b/fs/devpts/inode.c
> @@ -13,6 +13,7 @@
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/sched.h>
> =C2=A0#include <linux/namei.h>
> @@ -438,6 +439,7 @@ static int devpts_init_fs_context(struct
> fs_context *fc)
> =C2=A0		fsi->mount_opts.reserve =3D true;
> =C2=A0
> =C2=A0	fc->s_fs_info =3D fsi;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &devpts_context_ops;
> =C2=A0	return 0;
> =C2=A0}
