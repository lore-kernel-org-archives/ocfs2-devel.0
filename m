Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564960;
	b=d3qmN6vmElMMCg9bjt+rID1S3AB9so5ZgopMkdGUK69h5Aglqi/+X/Dv+p9eN5KFljAC
	 RJANR91tKXxsv26Yfa9ELPfZ32/pTCcuT6kl7xuzK6KbnbyTYdmEo9CfF3hU/vumns8Yf
	 iMa7WQ8DJqZXiNABi3vdY0qRSFbQfUKJqs97TCi41CwKxO/Cik6SPRhzDCBBYVp5bf01Z
	 XR0lbyIoxkVFnvArckLVIuv6QM4coDoK8+FwUr5aG72MoXC3UXA1eZK5QpvxfhVoIXsU0
	 3CoCyCU1a/1CM+zsEYb6UNVjos5KeIiqCrlj5AnPkXzKHvJwqsZdEqWGS5E1SNtHmbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564960;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=PfCz/38ILdxPmJBY1NDzDaIsiECcLTMyKpoKPJStEV0=;
	b=Ckmef5WMFSnM/LPys4c6DfgcCG1CM1CgcRp1UnEhSOmu5ul0OJ5kJOA0KI99Mw0dlrnY
	 XhtlXiOYSWNzYu2MAtmoTFsY17cUQq+iXc6Oy32G0JWp+ONC9F/oHTzgOfAt/CpXw3AHl
	 mmP2t1NcqxO/lfx1VNGy15Y8i/6oHey18y9XRa4utqLnfykPteRWFBDDEPOr2dYTP+8WZ
	 SHlsxyZMC9WQ4wkCv4SK2ed7Y12+OkrEDn7VC7TEgO0eTLQXVidcv17Z+6C7XXJZdZ8u1
	 okdFPJ2PawID6TUMGzjUSEawZvLpapmz9p2xz9brtIdYo0wvzuJo062kp3xlkucsLzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="lVl/VZr5";
	arc=none smtp.remote-ip=209.85.218.49
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62F2606A8BF
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 10:15:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B62F2606A8BF
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=lVl/VZr5
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c506094fd93so151135966b.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 02:15:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564958; x=1795169758; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=PfCz/38ILdxPmJBY1NDzDaIsiECcLTMyKpoKPJStEV0=;
        b=lVl/VZr5BEKWYu2dn0nBJM9BVsCcn1qVSaho3GfNRoL5CKw9b5y1pd30LtFxa5ri87
         BxGoNTFc1G7PzLtAUJjpX7/maTT0x9xULYuKIH6jhYNdAsQ5e735jwJ9vYdciRmeO3u+
         aZfXsiN6Tw8MYD78u7YorsDcyj1veF+ee2WNcb+ncYPkNhQ3pEyrm14UzjIuv8LVfsYV
         u2utRCV1ETIwz8JGAWIw0deTXq7E6kE83uizlO06QsX9XQfslW+SQ88x7qhJ37VSNs/P
         elUhGr3NkLO6absGYQXhhO6PHw8yGJkpPtEKw1TZLSrXolJLIn3Ob4jPs6h9XFXOMV6F
         qfrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564958; x=1795169758;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PfCz/38ILdxPmJBY1NDzDaIsiECcLTMyKpoKPJStEV0=;
        b=Q/a7xpX2TBp2Nx0am6yWivq/BO4UEAJxknmuViMjS6WRK6CDJ7NxQPSfPYygsroNBA
         0PIaVO42J7vXnpfOgSb+Q8z5A/hxQa0ztrBik27/bvol3MKrrnZXcPpdErBS7lBMu1wT
         unKUm+Bp/OTxDRWhHwuWzpjR7f2oy62mmliLzbSEdVYdTo72145XTpU1OlaagoGFUPFp
         cnV1vGRJzeguA9rczfc/Z+69yEZyG8YflzdJkSIC+c/3h4RYHedl0g45mVW7ZzLktB7g
         KFeegQrqRwYYB+mzn0donqyfKsl5EQ0TIyMiQCf4ZHp1sGE4/dnxvrWv6HML1DSCmnWn
         D1+w==
X-Forwarded-Encrypted: i=1; AL+hErEEwYzO8cSqxU1vM5HLEV5ImY9yGVYDRAjvyLEyRH1OdgF0OtqmXpJxWSwFEXIH6KwoAT++nIyWzEJeZQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z9t/j6mnMKhm4pajXXH4ydzncTuzAMwTno7iJJi1Ge91M0hjv/P
	VAGw4oI4ZXBDLShoJEc7nBL4CVp5c1V+MNxDsewpYwrmh8AzxJJyJ/nPDyx+J2IQlchP
X-Gm-Gg: AYBFou3OszeHcEsS2QjrfG+6MVo6ApTjnXpK3hBTOG/7pGJmMmQjFTEVoEW+sdtI7Ur
	8WIgs8IoQKyp98UO2FV10iWSdJ2AzzyVug9FUlqjQhjSF6CGl1W1iMXzVEjpRixTdAZpVpT7Xg4
	N/m+g0yfFVSIL3me3f6YJvrGTVCtAIGzfVFW7Cd1d9+P9HkRIU2D6i6/VPJ4NFxFWVG1ToXWAy1
	YVRjOZ9bRR0Owher1bepltp7P1ou+wtEvY8bIeq9Ehl7ponq/KW1yXV8kir8R5foGEEe4JmyJ35
	rMdIr7qSHcWm/TSO2AFs/RH0YL8ZXe6P02VDStHHDNV9U2h8djGwMycz1oVN+5QRcOxogHo13UC
	wMQdESUdXJzaKQ05nIU4hpWccF7wVo7+qjtwkB273HM8sgw+FYobZ5UajNXabR6YP9K8yIHzk9w
	wyNkzsPX5s+ZUtuBADOE+TdIcl3p/bJPFpmENhntMo0RSrQ8l3aZ8WIsKnyu/V/H7pKUBJ1bjdc
	HhEJDNTUbgoD3QSrKxh3IVDfLejWZTT65UiumZZsIIFQsG7mVxjKGchUfQxLzdkBOVMusprtiVh
	0taabejJNOQvXZVKWBz92W+5SZtUztfmr/pPPJeybrLMCkCS+KXxBlkfJ54qULE=
X-Received: by 2002:a17:906:f59c:b0:c42:102f:15f0 with SMTP id a640c23a62f3a-c509614d4c1mr171873666b.3.1794564958075;
        Fri, 13 Nov 2026 02:15:58 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b7d1b7sm75606066b.74.2026.11.13.02.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:15:57 -0800 (PST)
Message-ID: <c5a694991af7e9182fd475a20bf4cfd73a13e395.camel@amutable.com>
Subject: Re: [PATCH RFC 34/41] loop: refuse files on pseudo filesystems as
 backing files
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
Date: Fri, 13 Nov 2026 11:15:56 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-34-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-34-4c998976c6c7@kernel.org>
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
> Currently loop accepts any regular file that implements ->read_iter()
> as
> a backing file and any that also implements ->write_iter() as a
> writable
> one. That includes files on procfs, sysfs and other pseudo
> filesystems.
> For example, /proc/kcore attaches read-only as a loop device the size
> of
> the kernel's virtual address space, 64 PiB with 5-level paging. sysfs
> attributes attach read-write as 4096 byte loop devices. Writing a
> block
> to the loop device of /sys/kernel/mm/transparent_hugepage/enabled
> changes the THP setting.
>=20
> That's not just nonsensical, it can be abused. Loop calls -
> >read_iter()
> and ->write_iter() of the backing file directly from its worker which
> runs with kernel credentials. But pseudo files enforce part of their
> access rules at read and write time against current. Dozens of sysfs
> ->show() and ->store() methods call capable(). Behind a loop device
> all
> of these checks are done against the loop worker instead of the task
> that opened the file. And setting up a loop device requires no
> capabilities, only access to the device nodes. So on v7.4-rc1:
>=20
> - uid 0 without any capabilities can't write to
> /sys/kernel/reboot/mode
> =C2=A0 as mode_store() requires CAP_SYS_BOOT. Writing "warm" through a
> loop
> =C2=A0 device works.
>=20
> - uid 0 without any capabilities can't read the files in
> =C2=A0 /sys/firmware/dmi/entries/*/ as dmi_sysfs_attr_show() requires
> =C2=A0 CAP_SYS_ADMIN. Reading them through a loop device works.
>=20
> - An unprivileged container that was handed a loop device can't
> change
> =C2=A0 gro_flush_timeout of its own network devices as
> =C2=A0 gro_flush_timeout_store() requires CAP_NET_ADMIN in the initial
> user
> =C2=A0 namespace. Writing it through a loop device works.
>=20
> The same goes for hard_offline_page, the md and sd attributes, rfkill
> and others.
>=20
> Refuse files on pseudo filesystems as loop backing files. Note that
> file_is_pseudo() looks through overlayfs so stacking overlayfs on top
> of
> sysfs doesn't get around this.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0drivers/block/loop.c | 3 +++
> =C2=A01 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index c96e35c3ef42..1482580a1979 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -537,6 +537,9 @@ static int loop_check_backing_file(struct file
> *file)
> =C2=A0	if ((file->f_mode & FMODE_WRITE) && !file->f_op->write_iter)
> =C2=A0		return -EINVAL;
> =C2=A0
> +	if (file_is_pseudo(file))
> +		return -EINVAL;
> +
> =C2=A0	return 0;
> =C2=A0}
> =C2=A0
