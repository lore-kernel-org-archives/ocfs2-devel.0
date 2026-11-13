Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794565724;
	b=HaLuXebQBsbkKtr62FSH/VNBa99Kan08SsJPLGH/xv8kUxm2zYCpMMGn6SITnFe1sndG
	 I8Rk8wKCAbxCylWgyYImPc6FXG1O3UNwfd2G75Pw1iDBy5PaykQWllAOC+MHpZd4AWSOb
	 vPTl+gyIZJ0Dd7vL3GXuB9jSfOEKWZREotZ0kdRuj/sBLDu8lCB2i+oTaLLqd6N4dhswk
	 iYAN5DzJzroQSrfDgtNE8bftM0E/nPgGClZYAMBlFCAcMivBTICOpmmtDa9Z9rX43mOgj
	 0Fk05egRY1u5QxCIY9TJSydf1FUDwZz3Dan5X4bGxOWwbj+4cWR595aKLuQUdCJLqhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794565724;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=HIAZ+a2RY8snYu8gjwIzGL7aFLB+UDjcbceUrGWDUl0=;
	b=XwNtIaQo8pVd6rqXzTt/Lpu2Ayep7d9q+TPgqXt2oI94TBcuPlDR32jMCduFHhGRRVlQ
	 DPZM9Ehg0N5qw5CfTv4d1Xzr0gRpUKDu5kFpg+qUIMLShWoUoE7SYELU/vn/YwDw3CaOf
	 wITsqVnElWrummxxzpeQGMUfzhQpGR8q7IqqUCyMvDF7gOZxzqNPjSUDZKMl2BTYO3SSw
	 F4hiMy9TpsBg/dzd3USe+kMBsrs3ZD1Vkexr0a81H39s8rdJYs0o6UAbUP1e39mZTm+2A
	 3qSN5daEo03A6rq2LXqH63FAA25sx4aBikt8/KjfRzJ0CTJbqnVPxPsz1z4lh/0pcuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=VlHoglXf;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F35606A339
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 10:28:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03F35606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=VlHoglXf
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a5177d78c7so11141975e9.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 02:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794565721; x=1795170521; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=HIAZ+a2RY8snYu8gjwIzGL7aFLB+UDjcbceUrGWDUl0=;
        b=VlHoglXfntK1uOOECu9u3O6EPXojoIKVOL2wPIM/Pq4SAt7H6z5KWRVu+rckK+EYOB
         7hOBh+DlVNP5eUpU/k/H7aQzb/Lvjau3E8XYvFK9zZiEnQbdm7HZK2PD1x6+hW+7tcV1
         vrVoAbJ5WWq3nKeapTnvHLILmyFy1t4Z7vJGUrB7iL44sK7SYnjsLJwEvK7K1DChSmAP
         h9oFajixVpvX4Hzp3xDowD9OLhDhXvnuxjvaHLbD1O1nTbig5dXFd5uTLjIJpV2pRfIl
         b7PI10DjbD12WHc6CnUOFjfvsJeFqL7SiHlfcXGbf1+rswAPCVatvCLEiKZlTXLvwvZK
         n2HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794565721; x=1795170521;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HIAZ+a2RY8snYu8gjwIzGL7aFLB+UDjcbceUrGWDUl0=;
        b=AXfpUDLTL9MXILZs5x4pmUAYbKhGkNe53rTP45NcI/UL5olewUnws07uEfL6Nj1A25
         DcrnPaDCLI29Am+JepVWuJ6Vc3aeLj1Ni776BQLXYSWyW6BVUyov4o+fGmKqHuYKJ7vK
         WxdP/uqZb5dmQfbxr/uG6M5qsC50owcHhVe4E+OUtqEOUxIzUOq+IgYJUfaQFUAwuZg6
         bv6F8p+tXmRk9XUkajt5bWfJmWsp6QRMoy3dD2O/VaNLbWl93DUzbvHcgecT45g9h7Rb
         a3FVUAYnfi1IARM4DbGVQyGpUiFHCi6GSjGVqyM5OjbV+JMVj+kWxSPLz/8GzDgRQDGe
         pESg==
X-Forwarded-Encrypted: i=1; AL+hErH+lejthOaCY1F++XVwqx32NaZx3D3jkMrdhL6glXetaW8Oz5kqHtVUyReX1YcSwWKXW+Xn5CZlM3yiTA==@lists.linux.dev
X-Gm-Message-State: APuU4Z/1wIfRX3gELLLhALB2XNu2IlS/jhfh1iHEu21kqUyC4TpAk1dy
	jAGqr9bE3W6mUmYLiVEJx1mjUFyYBX1TaJEvOorb/3cn5Mw5HsPprqJEFyvNNDVGiQkJ
X-Gm-Gg: AYBFou3R2RHesRb13cAHqqnJl6RRJR4Ig4tWlEDLGFvxZjh+SpBWOHF5a5CxiGlNNv9
	wDyi8Yg+f4Rs4k/0J7oLUI0W/ullCCvzedR2oZQltb2q+BbIRSTBJPBj2O28QDOcZfTRaWR9iJa
	dkdBG0f2mdMMPvyrHlYhAM6yAMuxL4wU4vAk3+nHFzT4LjSQIikG6mSkUFT0b8ta3MxicT0maay
	1CeLMP9z4DEY5tecRa9S8LMit5vfwDGSQ3+XtxUYBwPsBTIq4T5PCEj5tEQggBd/UVyfZwHsxDK
	cshzF7isS7LyG4qzBSuQJaA0RuQPip24DfDxhGgtHsCLsRnRcaKFiqq0LsUlkPKN+EuoDUO/O2g
	KvizqEy1Ip+bJmeEF6C90xluqFpmUtExVCyj0U9pThdV6f/UD0mthZg4pK30bHsYbWefDMggWWE
	kAlrvTJal0sg3uclSQaRdCo5vOocSQkpHmJhml1JX6hZnZMIJfagurlZGHWTEU6uu34EMFKKsEF
	yYAUkaeNTdHoHiH6fmmBbArqZx4zIAEzBiRDtBktGFMDkuSJKPG+lp3d4bT86ANOmNawBWbrU8g
	DERlN9+9bhpbazdXYtkHn844BW4VrmUe4pGS94ox+MJ9QX2u4iZ8C13EekTMm7U=
X-Received: by 2002:a05:600c:428c:b0:4a1:9661:14b5 with SMTP id 5b1f17b1804b1-4bb55aabd53mr26666375e9.29.1794565721222;
        Fri, 13 Nov 2026 02:28:41 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e252f7fsm152260095e9.2.2026.11.13.02.28.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:28:40 -0800 (PST)
Message-ID: <ae5a09a7dc0ab5d01e78114c38e90b39af32362c.camel@amutable.com>
Subject: Re: [PATCH RFC 41/41] selftests/filesystems: add backing file tests
 for pseudo files
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
Date: Fri, 13 Nov 2026 11:28:38 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-41-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-41-4c998976c6c7@kernel.org>
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
> Add tests that files on pseudo filesystems can't be used as storage:
>=20
> - a procfs file attached read-only to a loop device
> - sysfs files attached read-only and read-write to a loop device
> - a sysfs file behind a lower-only overlayfs attached to a loop
> device
> - a sysfs file as the backing file of a usb mass storage gadget LUN
> - a sysfs file as the source of a file-backed erofs mount
>=20
> And make sure that a memfd and another loop device still work as loop
> backing files and that loop refuses a backing file that isn't open
> for
> reading.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0tools/testing/selftests/filesystems/.gitignore=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0=C2=A0 1 +
> =C2=A0tools/testing/selftests/filesystems/Makefile=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 2 +-
> =C2=A0tools/testing/selftests/filesystems/config=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 9 +
> =C2=A0.../selftests/filesystems/pseudo_backing_test.c=C2=A0=C2=A0=C2=A0 |=
 274
> +++++++++++++++++++++
> =C2=A04 files changed, 285 insertions(+), 1 deletion(-)
>=20
> diff --git a/tools/testing/selftests/filesystems/.gitignore
> b/tools/testing/selftests/filesystems/.gitignore
> index cf79000e4092..8df38eabb125 100644
> --- a/tools/testing/selftests/filesystems/.gitignore
> +++ b/tools/testing/selftests/filesystems/.gitignore
> @@ -7,3 +7,4 @@ kernfs_test
> =C2=A0idmapped_tmpfile
> =C2=A0ustat_test
> =C2=A0rw_hint_test
> +pseudo_backing_test
> diff --git a/tools/testing/selftests/filesystems/Makefile
> b/tools/testing/selftests/filesystems/Makefile
> index fbd5c27505ef..0ebb9005bcd2 100644
> --- a/tools/testing/selftests/filesystems/Makefile
> +++ b/tools/testing/selftests/filesystems/Makefile
> @@ -2,7 +2,7 @@
> =C2=A0
> =C2=A0CFLAGS +=3D $(KHDR_INCLUDES)
> =C2=A0TEST_GEN_PROGS :=3D devpts_pts anon_inode_test kernfs_test fclog
> ustat_test rw_hint_test
> -TEST_GEN_PROGS +=3D idmapped_tmpfile
> +TEST_GEN_PROGS +=3D idmapped_tmpfile pseudo_backing_test
> =C2=A0TEST_GEN_PROGS_EXTENDED :=3D dnotify_test
> =C2=A0
> =C2=A0include ../lib.mk
> diff --git a/tools/testing/selftests/filesystems/config
> b/tools/testing/selftests/filesystems/config
> index 9f45bc493a30..228196160d29 100644
> --- a/tools/testing/selftests/filesystems/config
> +++ b/tools/testing/selftests/filesystems/config
> @@ -6,3 +6,12 @@ CONFIG_NET=3Dy
> =C2=A0CONFIG_NET_NS=3Dy
> =C2=A0CONFIG_INET=3Dy
> =C2=A0CONFIG_SYSFS=3Dy
> +CONFIG_BLK_DEV_LOOP=3Dy
> +CONFIG_OVERLAY_FS=3Dy
> +CONFIG_TMPFS=3Dy
> +CONFIG_CONFIGFS_FS=3Dy
> +CONFIG_USB_GADGET=3Dy
> +CONFIG_USB_CONFIGFS=3Dy
> +CONFIG_USB_CONFIGFS_MASS_STORAGE=3Dy
> +CONFIG_EROFS_FS=3Dy
> +CONFIG_EROFS_FS_BACKED_BY_FILE=3Dy
> diff --git
> a/tools/testing/selftests/filesystems/pseudo_backing_test.c
> b/tools/testing/selftests/filesystems/pseudo_backing_test.c
> new file mode 100644
> index 000000000000..bc8e17ab8e6e
> --- /dev/null
> +++ b/tools/testing/selftests/filesystems/pseudo_backing_test.c
> @@ -0,0 +1,274 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define _GNU_SOURCE
> +
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <limits.h>
> +#include <sched.h>
> +#include <stdbool.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <unistd.h>
> +#include <linux/loop.h>
> +#include <linux/magic.h>
> +#include <sys/ioctl.h>
> +#include <sys/mman.h>
> +#include <sys/mount.h>
> +#include <sys/stat.h>
> +#include <sys/vfs.h>
> +
> +#include "kselftest_harness.h"
> +#include "wrappers.h"
> +
> +/*
> + * Put @fd behind a free loop device. The device is set up with
> + * LO_FLAGS_AUTOCLEAR and goes away again when it is closed here.
> + */
> +static int loop_attach(int fd, bool rw, char *dev, size_t len)
> +{
> +	struct loop_config cfg =3D {};
> +	int ctl, nr, lfd, ret =3D 0;
> +
> +	ctl =3D open("/dev/loop-control", O_RDWR | O_CLOEXEC);
> +	if (ctl < 0)
> +		return -errno;
> +	nr =3D ioctl(ctl, LOOP_CTL_GET_FREE);
> +	if (nr < 0)
> +		ret =3D -errno;
> +	close(ctl);
> +	if (ret)
> +		return ret;
> +
> +	snprintf(dev, len, "/dev/loop%d", nr);
> +	lfd =3D open(dev, (rw ? O_RDWR : O_RDONLY) | O_CLOEXEC);
> +	if (lfd < 0)
> +		return -errno;
> +
> +	cfg.fd =3D fd;
> +	cfg.info.lo_flags =3D LO_FLAGS_AUTOCLEAR;
> +	if (!rw)
> +		cfg.info.lo_flags |=3D LO_FLAGS_READ_ONLY;
> +	if (ioctl(lfd, LOOP_CONFIGURE, &cfg)) {
> +		ret =3D -errno;
> +		close(lfd);
> +	} else {
> +		ret =3D lfd;
> +	}
> +	return ret;
> +}
> +
> +static int attach_path(const char *path, bool rw)
> +{
> +	char dev[PATH_MAX];
> +	int fd, ret;
> +
> +	fd =3D open(path, (rw ? O_RDWR : O_RDONLY) | O_CLOEXEC);
> +	if (fd < 0)
> +		return -errno;
> +	ret =3D loop_attach(fd, rw, dev, sizeof(dev));
> +	close(fd);
> +	if (ret >=3D 0) {
> +		close(ret);
> +		ret =3D 0;
> +	}
> +	return ret;
> +}
> +
> +static bool can_use_loop(void)
> +{
> +	return geteuid() =3D=3D 0 && access("/dev/loop-control", R_OK |
> W_OK) =3D=3D 0;
> +}
> +
> +TEST(memfd_backing_file)
> +{
> +	char dev[PATH_MAX];
> +	int fd, lfd;
> +
> +	if (!can_use_loop())
> +		SKIP(return, "loop devices unavailable");
> +
> +	fd =3D memfd_create("pseudo_backing_test", MFD_CLOEXEC);
> +	ASSERT_GE(fd, 0);
> +	ASSERT_EQ(ftruncate(fd, 1 << 20), 0);
> +
> +	lfd =3D loop_attach(fd, true, dev, sizeof(dev));
> +	ASSERT_GE(lfd, 0);
> +	EXPECT_EQ(close(lfd), 0);
> +	EXPECT_EQ(close(fd), 0);
> +}
> +
> +TEST(loop_device_backing_file)
> +{
> +	char dev[PATH_MAX], dev2[PATH_MAX];
> +	int fd, lfd, bfd, lfd2;
> +
> +	if (!can_use_loop())
> +		SKIP(return, "loop devices unavailable");
> +
> +	fd =3D memfd_create("pseudo_backing_test", MFD_CLOEXEC);
> +	ASSERT_GE(fd, 0);
> +	ASSERT_EQ(ftruncate(fd, 1 << 20), 0);
> +	lfd =3D loop_attach(fd, true, dev, sizeof(dev));
> +	ASSERT_GE(lfd, 0);
> +
> +	/* A block device stays fine as a backing file. */
> +	bfd =3D open(dev, O_RDWR | O_CLOEXEC);
> +	ASSERT_GE(bfd, 0);
> +	lfd2 =3D loop_attach(bfd, true, dev2, sizeof(dev2));
> +	ASSERT_GE(lfd2, 0);
> +
> +	EXPECT_EQ(close(lfd2), 0);
> +	EXPECT_EQ(close(bfd), 0);
> +	EXPECT_EQ(close(lfd), 0);
> +	EXPECT_EQ(close(fd), 0);
> +}
> +
> +TEST(write_only_backing_file)
> +{
> +	char dev[PATH_MAX], path[PATH_MAX];
> +	int fd, wfd, lfd;
> +
> +	if (!can_use_loop())
> +		SKIP(return, "loop devices unavailable");
> +
> +	fd =3D memfd_create("pseudo_backing_test", MFD_CLOEXEC);
> +	ASSERT_GE(fd, 0);
> +	ASSERT_EQ(ftruncate(fd, 1 << 20), 0);
> +
> +	/* Loop reads from its backing file so it must be open for
> reading. */
> +	snprintf(path, sizeof(path), "/proc/self/fd/%d", fd);
> +	wfd =3D open(path, O_WRONLY | O_CLOEXEC);
> +	ASSERT_GE(wfd, 0);
> +
> +	lfd =3D loop_attach(wfd, true, dev, sizeof(dev));
> +	if (lfd >=3D 0)
> +		close(lfd);
> +	EXPECT_EQ(lfd, -EBADF);
> +	EXPECT_EQ(close(wfd), 0);
> +	EXPECT_EQ(close(fd), 0);
> +}
> +
> +TEST(procfs_backing_file)
> +{
> +	if (!can_use_loop())
> +		SKIP(return, "loop devices unavailable");
> +
> +	ASSERT_EQ(attach_path("/proc/cpuinfo", false), -EINVAL);
> +}
> +
> +TEST(sysfs_backing_file)
> +{
> +	if (!can_use_loop())
> +		SKIP(return, "loop devices unavailable");
> +
> +	ASSERT_EQ(attach_path("/sys/kernel/warn_count", false), -
> EINVAL);
> +
> +	if (access("/sys/kernel/reboot/mode", F_OK))
> +		SKIP(return, "no /sys/kernel/reboot/mode");
> +	ASSERT_EQ(attach_path("/sys/kernel/reboot/mode", true), -
> EINVAL);
> +}
> +
> +TEST(overlayfs_on_sysfs_backing_file)
> +{
> +	if (!can_use_loop())
> +		SKIP(return, "loop devices unavailable");
> +
> +	ASSERT_EQ(unshare(CLONE_NEWNS), 0);
> +	ASSERT_EQ(mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL),
> 0);
> +	ASSERT_EQ(mount("tmpfs", "/tmp", "tmpfs", 0, NULL), 0);
> +	ASSERT_EQ(mkdir("/tmp/empty", 0755), 0);
> +	ASSERT_EQ(mkdir("/tmp/merged", 0755), 0);
> +
> +	/* A lower-only overlayfs serves reads from sysfs. */
> +	if (mount("overlay", "/tmp/merged", "overlay", MS_RDONLY,
> +		=C2=A0 "lowerdir=3D/sys/kernel:/tmp/empty"))
> +		SKIP(return, "no overlayfs on top of sysfs: %s",
> strerror(errno));
> +
> +	ASSERT_EQ(attach_path("/tmp/merged/warn_count", false), -
> EINVAL);
> +}
> +
> +#define CONFIGFS_DIR "/sys/kernel/config"
> +#define GADGET_DIR CONFIGFS_DIR "/usb_gadget/pseudo_backing_test"
> +#define MASS_STORAGE_DIR GADGET_DIR "/functions/mass_storage.0"
> +
> +TEST(usb_mass_storage_backing_file)
> +{
> +	const char *path =3D "/sys/kernel/warn_count";
> +	struct statfs sfs;
> +	ssize_t ret;
> +	int fd, err;
> +
> +	if (geteuid())
> +		SKIP(return, "needs root");
> +
> +	/* Mounting configfs on top of itself fails with EBUSY. */
> +	if (statfs(CONFIGFS_DIR, &sfs) || sfs.f_type !=3D
> CONFIGFS_MAGIC) {
> +		ASSERT_EQ(unshare(CLONE_NEWNS), 0);
> +		ASSERT_EQ(mount(NULL, "/", NULL, MS_REC |
> MS_PRIVATE, NULL), 0);
> +		if (mount("configfs", CONFIGFS_DIR, "configfs", 0,
> NULL))
> +			SKIP(return, "no configfs: %s",
> strerror(errno));
> +	}
> +
> +	if (mkdir(GADGET_DIR, 0755))
> +		SKIP(return, "no usb gadget configfs: %s",
> strerror(errno));
> +	if (mkdir(MASS_STORAGE_DIR, 0755)) {
> +		err =3D errno;
> +		rmdir(GADGET_DIR);
> +		SKIP(return, "no usb mass storage function: %s",
> strerror(err));
> +	}
> +
> +	/* Writing the path opens the LUN's backing file right away.
> */
> +	fd =3D open(MASS_STORAGE_DIR "/lun.0/file", O_WRONLY |
> O_CLOEXEC);
> +	EXPECT_GE(fd, 0);
> +	if (fd >=3D 0) {
> +		ret =3D write(fd, path, strlen(path));
> +		err =3D errno;
> +		EXPECT_EQ(ret, -1);
> +		EXPECT_EQ(err, EINVAL);
> +		EXPECT_EQ(close(fd), 0);
> +	}
> +
> +	EXPECT_EQ(rmdir(MASS_STORAGE_DIR), 0);
> +	EXPECT_EQ(rmdir(GADGET_DIR), 0);
> +}
> +
> +TEST(erofs_backing_file)
> +{
> +	bool refused =3D false;
> +	char buf[256];
> +	int fsfd, ret, err;
> +	ssize_t n;
> +
> +	if (geteuid())
> +		SKIP(return, "needs root");
> +
> +	fsfd =3D sys_fsopen("erofs", FSOPEN_CLOEXEC);
> +	if (fsfd < 0)
> +		SKIP(return, "no erofs: %s", strerror(errno));
> +
> +	ASSERT_EQ(sys_fsconfig(fsfd, FSCONFIG_SET_STRING, "source",
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "/sys/kernel/warn_count", 0), 0)=
;
> +	ret =3D sys_fsconfig(fsfd, FSCONFIG_CMD_CREATE, NULL, NULL,
> 0);
> +	err =3D errno;
> +	if (ret && err =3D=3D ENOTBLK) {
> +		close(fsfd);
> +		SKIP(return, "no file-backed erofs mounts");
> +	}
> +	ASSERT_EQ(ret, -1);
> +	ASSERT_EQ(err, EINVAL);
> +
> +	/*
> +	 * Something that isn't an erofs image fails with EINVAL as
> well so
> +	 * check that the source itself was refused.
> +	 */
> +	while ((n =3D read(fsfd, buf, sizeof(buf) - 1)) > 0) {
> +		buf[n] =3D '\0';
> +		if (strstr(buf, "pseudo filesystem"))
> +			refused =3D true;
> +	}
> +	EXPECT_TRUE(refused);
> +	EXPECT_EQ(close(fsfd), 0);
> +}
> +
> +TEST_HARNESS_MAIN
