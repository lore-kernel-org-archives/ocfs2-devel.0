Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564920;
	b=RdbblxBMNnhPRib0JGts6y82c8vf+1c+T43bAxZNcT1uEKxFik/fQ9KCmIWvJF19Qkqd
	 Myvu9SzJLwZ919ofQmQYMfhavXdXrpO8CAYl2MkffIjlankW1bz0rRnISNCvR3ciiokNC
	 se6TOX11KKix5yrXRcfGIig0KA1arBlDh/HEp9fCFoiVA1bc3aJtqMiHKgikyT0zktGjx
	 Efli1JhVz1kpShyNz46aNx0UDW6PI6c2IdNj4GMqUHiNwGkux7QqgN50B7DVYiuV7Eu/1
	 8we+mTanINtEYOCgolSieB6bkiEkvmb0WGIYUOBM637IiNYBRelTBHIk/Kri6MKWPiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564920;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=QtOsdPCKGJ1fBhMqXd/zLQfd50NEx4L7veNiE/G2OUE=;
	b=A5d2uYMnGTeUvs/1KeePl75mA7hmBrDgoMrI9KSF6Xw5gVvEvbqGN6Fx288oazRwO8yU
	 I0pfsqLwIID1e8DX7rRCv33uGsB/dhZEBkgC957/3npE1Q35blMBrHHVpxx1T+IPPruYA
	 ZgMHykrP+0S/nDNaariuzz86thFogz706OPuuouzwRmaer9S5K53jhXObNFkAKf826ckS
	 0aHmwNN7p9Yi6reEvkCWFYVDwZ1QChNZ4FCeUXLHOwONxLe/89q75kMQKPUibqjd1utDe
	 V81uQwXVIOZ87Mm2trbXo6IMNh2iYqzKVVZsLiDwznjz+RPSL5OIcHQdD8/3oAY7e+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=oUQDzZyz;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6BA606B13E
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 10:15:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE6BA606B13E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=oUQDzZyz
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a5b2be99a8so4413345e9.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 02:15:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564917; x=1795169717; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=QtOsdPCKGJ1fBhMqXd/zLQfd50NEx4L7veNiE/G2OUE=;
        b=oUQDzZyz2AVCafrrp6ylKsFDwkCE/KuxxcUjE+7jIzMtLoNeObK4QQ7mZfupNQbwOl
         +pyaTMHqi5/892TWRjZrSy+jYABF9LXTKjnnON+Qy3x++5f4lxppW6OaN68J2uiqMLu/
         aP8A+CeEPOmH23nQ0aSaiC0c6u1zqxsvTUEQap2O/LoC2jKbqTiBk2O40s2W/k/Hi8Qw
         AXn7wQXaZet5QDXDghdB7evsi7ngxju96Q9Mgx0pkEAnt02pGje74i0v+goEB//zCa5C
         rfFAdiqyBtsLZF/bUdzN188hJd9+elqSU6yWmw4lTKInByJEwfAvsvWzAmmHk8LIQ/kG
         8drg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564917; x=1795169717;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QtOsdPCKGJ1fBhMqXd/zLQfd50NEx4L7veNiE/G2OUE=;
        b=NObLgn0j8XzZi6OwJl/nxEvDkKKc/7xC8avoAOoAX7xzCn3vhyC9gDW87bQh2uxP8g
         aFMnnuAjMBW5e1QrTeRieuI5SPv1wT9nZpi+hWLO+bM0/VI/MEGSFDh78NVLV1iolLbC
         yGtQne+fbACvbBUOhT978I9JW98BElDaFAxVe3hbuv/lhQlOkqIm4NfpVQ6eIrr0GFIt
         aLl7sYHF9ou27fwErPIuSyDrq/K8L6PT6UyZrTDVVved/hcaZGFqBbB5DCC6S4jx7kdn
         9ROM1EIVYGLNVqq172qkwQPOZdi3r/WY8zoNgsTfUAN5XlWOfY0ALJe2RbkCucqIGAo7
         coaA==
X-Forwarded-Encrypted: i=1; AL+hErEngEg/4L5gX5Silzx1h2VNQ9q57ApvVVWA15lQik3+UCxnema/mZjKFZ59uV+DU8rMotede6StA2FXFQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z9ag1lPmZUnG4HmRtzO4C+/8St4c5M5eiv5n/e5LTrqv+St87/I
	Z3tw6FRbQrRpoSQ6SkYJs8VeCBrlKuItZOu8O6vFw0xWxVljhUa9OO7Ui8G2R9gwGUyp
X-Gm-Gg: AYBFou1Ltty9HY2KiuLfBJoeJqvZMgk0phUgWeJl5Pdc5Hr9bKhAk4JUpkw0vBi1hMu
	tbd0gMxIbQy8fQS2qgPkoLu2W3qreZGK1CjjB10qWMe0sBIm+IfOI5du+XV4LMD8Vj8bKzNgvZ5
	lm4c1zvmax9rlEY8ufCKLV1vsj4x+srygDV+vS+1epS7Ot8ccrjFDJHi/pfnAjtfUW6t1takQIm
	ppc8G662nOcMzFudN9QBT5DYAHjsZ/EqFiologUkFi4tEs2PNRujB8jMJFmSO4UZXRKia4bhfqV
	2TiNhnM/QAUVzcAt1HtJlZDjo9BwcVwJXUvK004n3Gh8b/ajsqxbpRh0dGueUc/1bLwxfV1mLUI
	MI/qbzFNavGmBTQRE0OSAjipGCdS9JzDXi9OLXfq8RcQwqt5d85TrTJ/y6rNberJZ96fX//VDgq
	BGYb0zVbC6kh7C3YKlSLpKSBP4oB/QAlG68iBolsf5oVjNvaa9IXWfeVLf2dAv2ZKRkmx3VWjbc
	RIp2OyTg5XzyFCkBFg3Dg4+htoMVjxSM++ZgvSDdSSVyeXQctOrslm6/Sx0NFb/t1g60F769M/y
	ul8DzaZxLTLvP5MGC7z04ai6TiSCljqdgZwoYe/HSLcFq5T4hktoISXMLjoX8qY=
X-Received: by 2002:a05:600c:4f84:b0:4a7:7f3f:6f8e with SMTP id 5b1f17b1804b1-4bb5599ade1mr43492835e9.0.1794564916955;
        Fri, 13 Nov 2026 02:15:16 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb56680ea9sm31982365e9.0.2026.11.13.02.15.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:15:16 -0800 (PST)
Message-ID: <e2edfa06d185acd86b46945622b6eb6dff97b307.camel@amutable.com>
Subject: Re: [PATCH RFC 33/41] fs: add file_is_pseudo()
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
Date: Fri, 13 Nov 2026 11:15:14 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-33-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-33-4c998976c6c7@kernel.org>
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
> Add a helper to check whether a file is a regular file on a pseudo
> filesystem. Only regular files count. Device nodes on pseudo
> filesystems
> such as devpts, binderfs or the block devices on bdevfs are what they
> are.
>=20
> Look at the inode that actually provides the data via d_real_inode().
> overlayfs accepts sysfs, cgroup2, debugfs, tracefs, configfs and
> securityfs as lower layers and reads of such an overlayfs file are
> served by the file on the pseudo filesystem. Checking the overlayfs
> inode would miss that.
>=20
> No functional changes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0include/linux/fs.h | 12 ++++++++++++
> =C2=A01 file changed, 12 insertions(+)
>=20
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 99caef43ff3c..407ffb6342ec 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2553,6 +2553,18 @@ static inline const struct inode
> *file_user_inode(const struct file *f)
> =C2=A0	return file_inode(f);
> =C2=A0}
> =C2=A0
> +/*
> + * Regular files on pseudo filesystems are kernel interfaces and
> must not be
> + * used as storage. Look through stacking filesystems at the inode
> that
> + * provides the data.
> + */
> +static inline bool file_is_pseudo(const struct file *file)
> +{
> +	const struct inode *inode =3D d_real_inode(file-
> >f_path.dentry);
> +
> +	return S_ISREG(inode->i_mode) && (inode->i_sb->s_iflags &
> SB_I_PSEUDO);
> +}
> +
> =C2=A0static inline struct file *file_clone_open(struct file *file)
> =C2=A0{
> =C2=A0	return dentry_open(&file->f_path, file->f_flags, file-
> >f_cred);
