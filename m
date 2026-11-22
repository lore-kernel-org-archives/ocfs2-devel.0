Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795384942;
	b=pBEACgA36xFSDDxXG+1RQfD522q8s3R/vqcG1WpafCscgR4wsKojkM91+EearyjAlLpN
	 udKJMpbydgO+5NkAPmhk+pQEYepZvWd0NMdFuRBAdiHmttCwxYF1JO0NRNgQBng4BznUC
	 SO+oFFLm98opsX+QMraPG7YcuZOfK3Vle/+Pduacu1gzoSGz5hIp3h/vyPhyD3iGcGv3o
	 RbLOeAZinykQ+Dlf/BcHUICvuC52CXFlaOoO2xI6Ev3ElIaRmZ6waBGRnZM4SQGmHWHDe
	 DMOuO5kvASvd5ZHFy+Z1hpP34IJFyOD7xOfv/vP2gO4/syNVJdYwnVas5cXsRK78C0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795384942;
	h=Received:DKIM-Signature:Mime-Version:Content-Transfer-Encoding:
	 Content-Type:Date:Message-Id:Subject:Cc:To:From:References:
	 In-Reply-To;
	bh=sTtlSSaGTpDBtcMHiOircAIvmiTH+Ctop/XsFzGC1x4=;
	b=YrgCw7fc82efjOJR6aqKPcSwalSW3k8vQUHIYDJVI37d9CBiToehWm/1ktwwymQWL6Au
	 svoB7yp+0z1su71Hd0PFrG5Nz0ensrulMD/zKBsuvTb4eZkW4szYQKpqve8SdVqOhaNC9
	 rpXHgTRZ0G5Hg9lObkmlBU8Tx36zXCsAu90qa2oSdJ1RpKVfZn2VTpdKMJellxju98pBd
	 lQ7x4g3dBPSLJkeB4pX7VQTWEnhJIBU8fqJl3690tWQtBED2+6yS5r5cH/ivr2aZa7umF
	 oaG5QKUfA4/qFx5fhDpAyRJVmhYyRytxOTiVWaI8Cmn0IGGlcCD4X9b3p1tq8Kfh2TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k2Hc6xFR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C7D606A31A;
	Sun, 22 Nov 2026 22:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k2Hc6xFR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DB11F000C6;
	Sun, 22 Nov 2026 22:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795384942;
	bh=sTtlSSaGTpDBtcMHiOircAIvmiTH+Ctop/XsFzGC1x4=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To;
	b=k2Hc6xFRtkicPKFvuKT7zGdEMFSb//oYzAC6yGi4WET4vMctzGLV95ptNtrt42XPr
	 WQXnncoUOn8vCWB5V+5BOCSO1YRgvEGvWFlC6kSpFwx64JgBjdDeDjN8t0GAWjAHIl
	 OTUhOZXnH51x9+wu6dE5+5xRqac3uNPyE7pzVVKvZEWUvPhn37jeV+RfXXnvGy2n+o
	 5fpjybhz8GWsaKNEldr/b1vfp4LchA2oilYAZk48pyxh0hZg4h3t2J1QwAu6uVH9h7
	 a22sYJ2GBWGWAOsKWbURM4twq7Z2FvgS7RP2m5XNLf/srWoFugU+HT+1vi7WOYs8uY
	 PaUfPtPCWI/6w==
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 22 Nov 2026 23:02:06 +0100
Message-Id: <DN22U90WCTGB.1REAOP1PQUMIQ@kernel.org>
Subject: Re: [PATCH v4 0/9] Add __must_init and require explicit
 kobj_type::release
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Kees Cook"
 <kees@kernel.org>, "Miguel Ojeda" <ojeda@kernel.org>, "Rafael J . Wysocki"
 <rafael@kernel.org>, "Madhavan Srinivasan" <maddy@linux.ibm.com>, "Srish
 Srinivasan" <ssrish@linux.ibm.com>, "Michael Ellerman"
 <mpe@ellerman.id.au>, "Nicholas Piggin" <npiggin@gmail.com>, "Christophe
 Leroy" <chleroy@kernel.org>, "Nayna Jain" <nayna@linux.ibm.com>, "Mimi
 Zohar" <zohar@linux.ibm.com>, "Yoshinori Sato"
 <ysato@users.sourceforge.jp>, "Rich Felker" <dalias@libc.org>, "John Paul
 Adrian Glaubitz" <glaubitz@physik.fu-berlin.de>, "Juergen Gross"
 <jgross@suse.com>, "Stefano Stabellini" <sstabellini@kernel.org>,
 "Oleksandr Tyshchenko" <oleksandr_tyshchenko@epam.com>, "Nathan Chancellor"
 <nathan@kernel.org>, "Nick Desaulniers" <ndesaulniers@google.com>, "Viresh
 Kumar" <viresh.kumar@linaro.org>, "Zhongqiu Han"
 <zhongqiu.han@oss.qualcomm.com>, "Alexander Aring" <aahringo@redhat.com>,
 "Felix Kuehling" <felix.kuehling@amd.com>, =?utf-8?q?Christian_K=C3=B6nig?=
 <christian.koenig@amd.com>, "Zhihao Cheng" <chengzhihao1@huawei.com>,
 "Sumanth Korikkar" <sumanthk@linux.ibm.com>, "Bill Wendling"
 <morbo@google.com>, "Justin Stitt" <justinstitt@google.com>,
 <driver-core@lists.linux.dev>, <llvm@lists.linux.dev>,
 <linux-hardening@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-doc@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
 <linux-pm@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
 <linux-sh@vger.kernel.org>, <linux-s390@vger.kernel.org>,
 <gfs2@lists.linux.dev>, <xen-devel@lists.xenproject.org>,
 <linux-mtd@lists.infradead.org>, <amd-gfx@lists.freedesktop.org>,
 <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
 <agordeev@linux.ibm.com>, <airlied@gmail.com>, <alexander.deucher@amd.com>,
 <catalin.marinas@arm.com>, <chao@kernel.org>, <deller@gmx.de>,
 <dennis.dalessandro@cornelisnetworks.com>, <dmaengine@vger.kernel.org>,
 <gor@linux.ibm.com>, <hca@linux.ibm.com>, <jaegeuk@kernel.org>,
 <James.Bottomley@HansenPartnership.com>, <jgg@ziepe.ca>,
 <jlbec@evilplan.org>, <johan@kernel.org>, <joseph.qi@linux.alibaba.com>,
 <leon@kernel.org>, <lihuisong@huawei.com>, <linusw@kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <linux-erofs@lists.ozlabs.org>,
 <linux-f2fs-devel@lists.sourceforge.net>, <linux-fbdev@vger.kernel.org>,
 <linux-omap@vger.kernel.org>, <linux-parisc@vger.kernel.org>,
 <linux-rdma@vger.kernel.org>, <mark@fasheh.com>, <neescoba@cisco.com>,
 <ocfs2-devel@lists.linux.dev>, <satishkh@cisco.com>, <simona@ffwll.ch>,
 <sre@kernel.org>, <vkoul@kernel.org>, <will@kernel.org>, <xiang@kernel.org>
To: "Ian Rogers" <irogers@google.com>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20261119192520.1983406-1-irogers@google.com>
 <20261122215639.1178566-1-dakr@kernel.org>
In-Reply-To: <20261122215639.1178566-1-dakr@kernel.org>

(Cc: more people previously Cc'd on v2)

On Sun Nov 22, 2026 at 10:56 PM CET, Danilo Krummrich wrote:
> On Thu, 19 Nov 2026 11:25:11 -0800, Ian Rogers wrote:
>> [PATCH v4 0/9] Add __must_init and require explicit kobj_type::release
>
> Applied, thanks!
>
>   Branch: driver-core-testing
>   Tree:   git://git.kernel.org/pub/scm/linux/kernel/git/driver-core/drive=
r-core.git
>
> [1/9] Compiler Attributes: Add __must_init macro
>       commit: b8a53320a885
> [2/9] powerpc/secvar: Add missing kobject release callback to secvar_ktyp=
e
>       commit: 4d5d4dd2a2e2
> [3/9] sh: sq: Add missing kobject release callback to ktype_percpu_entry
>       commit: d19384f2f3c7
> [4/9] cpufreq: governor: Initialize kobj_type release callback statically
>       commit: 009365942c15
> [5/9] dlm: Wait for kobject release before freeing dlm_ls
>       commit: 48ae948f4285
> [6/9] xen/sys-hypervisor: Add release callback to hyp_sysfs_kobj_type
>       commit: ecaf88d385c1
> [7/9] ubifs: sysfs: Use kset_create_and_add() for ubifs_kset
>       commit: 25d952902dee
> [8/9] drm/amdkfd: Free queue in procfs_queue_type kobject release callbac=
k
>       commit: 6d4ff4a020cf
> [9/9] kobject: Require explicit initialization of struct kobj_type::relea=
se
>       commit: 45eeed1f8094
>
> The patches will appear in the next linux-next integration (typically wit=
hin 24
> hours on weekdays).
>
> The patches are in the driver-core-testing branch and will be promoted to
> driver-core-next after validation.

I've now picked this up; I will keep this series in driver-core-testing for=
 a
few more days before moving it to driver-core-next. Please let me know if t=
here
are any concerns with the series, particularly the comments in patch 9.

Thanks,
Danilo
