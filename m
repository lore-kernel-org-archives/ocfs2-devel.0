Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564161;
	b=Y69rFsIix+irmUEjHt7rSS5SzDyZ3jSCd+6GZeRWgBV/K6Atbyi96gdz16GqC3FRY2dE
	 jTab/9FfPo/24Xg43+7rjtTa86AoJW94u/tpFatGEKrJWa511yngNfE971T2pSyqZ7h2a
	 DqSFSmxqFqCKHYXZ0EKA1JxXuKB7kTHqiAQ5znhq8e2xbCxz2UNpnMBFSnoMyVdprynZ/
	 6rkKI74qy3Lu5zQuod9CgHGc2V829Ygqi2ax+QnqDfquQWKUaTKkhjifNpSJfmQzoUZTN
	 060iTMRk/UizoRNXLKB85D9Bwx91aHnqR8bYb/XFVhQOUvzdI4dzEniobxBtsHB1j7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564161;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=8oHy35ptJ0fLQb2YrI1vdssfNtJpVRQvJ6BVJKFTHRg=;
	b=FjiOJLIvy/N3xo6vcJtwwTNPe7gMKrqexjDDxp7oJmohTS1KAbDM0Og0ehYmTrLRz53Q
	 84JJXL52KBLeYIQJkyQ1Gv91vWBdeeMidPxSNnExRH2iM1ARDHGQxvpc1/h+GLxj8a4fy
	 iV9oRMeYUxmZpBMcCoDFCPnd2L42U3QvWd6veTves78/IZvyD2nSaxPtHA2y9t9llBb55
	 RD36j0Hn6nfoM5ka+i3BU2dn8XPsSAh/WLW+mvmx2Lrz/FcAAGChnuap/wohANrSIt+ef
	 wxQP4+Q97i2ziNUSmBVJGkIBjY3DvfEabs05DwxmaUPi4Cqp5QQyWgnEdqIU5jD2Cyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=dnP9LmU5;
	arc=none smtp.remote-ip=209.85.218.54
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237E7606A894
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 10:02:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 237E7606A894
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=dnP9LmU5
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c5067a2411bso135634266b.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 02:02:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564159; x=1795168959; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=8oHy35ptJ0fLQb2YrI1vdssfNtJpVRQvJ6BVJKFTHRg=;
        b=dnP9LmU5Wj9xt+ah6YsFcBPYGlWSNkdMQEpybYA4L0H5NqZ+7e3mAv8GvVtSob3L2a
         rXYuzNfBPhc6AFsd1Rfilby3geH8+2VknzgmaIoGO/Kbl9jVuyjdK18ZztwJ7yr+6vjV
         Zso+KlVIbPH0POlyCpye58J2N8IIZWWD9MZoJnIHnuce/jeva+bobNn32bcLHyiroWtN
         Zq3taXXvyoJQgBlCMzBnFJJTo478QBQkKXaE9Fkj9XwsXpMq7vtAuSStYmTRfY+ivafS
         5K6jNgNWWWLxVqOemA28W+VssHJOp7zlm7cc4dMmG1v1nDyTJGJ2RBJfhHl//knwUX79
         zbjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564159; x=1795168959;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8oHy35ptJ0fLQb2YrI1vdssfNtJpVRQvJ6BVJKFTHRg=;
        b=NOvcPIOjG+PpfP8tDHkUzADhrwKDsqwLtgoaitauKa3QPxGGmc3kXSIZZj+Z8vmSGA
         207i2X84vk1+5v9Nq5XcqdfmfbKNjSTFd3qLFlotPIc1Ds43tMAdgYG+/XXl/Hiq8+H9
         7ktcfn3MjycpuwZ3WDLO6TNNHIDdb9sVOLsacSgawJnzHPTCr+p+wpaAD1kaw6XlUJ5u
         Hbc9gsTxgX+WAx8msL4Ic6w4B+WKeIgnjhYJ1Clw/IBTPj/LwWvjyQDefW4woxmopzyg
         MZGazLh8Dyx8N9oWL3QSCwxGbiegbN8myowgOV7OGZe/Vaw5t8yOGmAE8DM8utNmPJBm
         1peA==
X-Forwarded-Encrypted: i=1; AL+hErH1viorTChooE76nZlRXrGNJOtmZX068plmMrIzNvtlesjDKoY5tP9g8w+VxGm6aMkrmJADRsyE0uojew==@lists.linux.dev
X-Gm-Message-State: APuU4Z/r2/SoN0fmnBY0/VhN5qVknmJQgMfySUPmReDnxuvS+KiR9+/+
	1C9oZbQ99Mtciy1JlFDEGJc8Ceo/izw94fqDmcc3Djp761yxkvhkF5jFeKCpZsC11nJq
X-Gm-Gg: AYBFou0JHW5jEAHYwQjTU29JvdNvw4EIpTSZLvPDxLyihHwFsfxTHHMP1SmRsI+AoED
	EqZmsBU+PFLcnvEP4v+IOJveR0Y/LclTEgMZU2+pOetak0GaTwBKZpzEcxaSXfC6oIq3gfX+0oT
	yyWtmx2X6AMVc9PIpWL9+GsJNOpiusD0wNlCbSd9U12e6qx3ep4Ta1srp5GGE26Eolw6f5pe58a
	r+2uWWMHJo20V0HA86rimI2t/dmfWwAdEm9tXI53Fxn7eMs+I/KrmXoCgM8N0FeQaY3LA8u/Xmx
	3ZaYQk7drG7gQl43+KaS08aP6H7LLeqw6w6k8zK6aKt2ty+TfHyQC+KBiOxCpS1vo7Y6Fca1F9K
	4YzP9tZtjrSZrG89H1dODvnNzZTPH95YfoaIUD+BrCx7GuO/a74jEzBM+biE7qISEYbJNXF3u5L
	7JGs6rw3pD9h2G+2qpcKi2EFBS0VONwo2haXjdT6VpQ6w0acAx4eZ4R87lJB2p1SRYqlRJXCYbl
	dT41h0FPZPT82nWVpjsGKhc66hV9+VpYQpbCzuGgL+LQpz4YlXmzEZjC6xLY7+lQxxbrRid+eXE
	W7Bimbf+bWyJcRlggRHYi1kR4cQi2wWuDUOMnwLXTa+0cLnR9cqkWG23kpBJPLI=
X-Received: by 2002:a17:907:7b93:b0:c29:f5d5:5a9c with SMTP id a640c23a62f3a-c509654de57mr163595166b.38.1794564159104;
        Fri, 13 Nov 2026 02:02:39 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b23afdsm74417566b.13.2026.11.13.02.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:02:38 -0800 (PST)
Message-ID: <8c51aa1ad231dea30af06ecf761a971f5958d063.camel@amutable.com>
Subject: Re: [PATCH RFC 05/41] kernfs: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:02:36 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-5-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-5-4c998976c6c7@kernel.org>
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
> Initialize all kernfs based filesystems as pseudo filesystems in
> kernfs_get_tree() instead of raising SB_I_NOEXEC and SB_I_NODEV by
> hand
> in kernfs_fill_super(). This adds SB_I_PSEUDO for sysfs, cgroupfs and
> resctrl.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/kernfs/mount.c | 4 ++--
> =C2=A01 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
> index a0be784bfb06..6b60d212b003 100644
> --- a/fs/kernfs/mount.c
> +++ b/fs/kernfs/mount.c
> @@ -8,6 +8,7 @@
> =C2=A0 */
> =C2=A0
> =C2=A0#include <linux/fs.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/magic.h>
> @@ -298,8 +299,6 @@ static int kernfs_fill_super(struct super_block
> *sb, struct kernfs_fs_context *k
> =C2=A0	struct dentry *root;
> =C2=A0
> =C2=A0	info->sb =3D sb;
> -	/* Userspace would break if executables or devices appear on
> sysfs */
> -	sb->s_iflags |=3D SB_I_NOEXEC | SB_I_NODEV;
> =C2=A0	sb->s_blocksize =3D PAGE_SIZE;
> =C2=A0	sb->s_blocksize_bits =3D PAGE_SHIFT;
> =C2=A0	sb->s_magic =3D kfc->magic;
> @@ -388,6 +387,7 @@ int kernfs_get_tree(struct fs_context *fc)
> =C2=A0	info->ns =3D kfc->ns_tag;
> =C2=A0	INIT_LIST_HEAD(&info->node);
> =C2=A0
> +	fc_init_pseudo(fc);
> =C2=A0	fc->s_fs_info =3D info;
> =C2=A0	sb =3D sget_fc(fc, kernfs_test_super, kernfs_set_super);
> =C2=A0	if (IS_ERR(sb))
