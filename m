Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794904111;
	b=wVTNuCkdfoKnSO4MNvesa9Q6mzSVJT9edB7UDMxn+nkwyc+9P0Hk8U3fRRJUSrVGjm5K
	 yoPfNTf2yZ24x6wC4a3dJ0fshsI3m89HTRt3/vhZyAFoXpUhYXqkYF4DKw0xRLAT/8cmX
	 EWDXwkj7mHQPMSzWMTGKrBDmOoGtDh37Z2Ca3Va3cli19rgXco94ZiCh1stfyHF4NKXz8
	 I617XPKlmixg72ZYms9C3DJZeTpXkf7153XmAQkxPhozYJKgf7VMy0iMSIIBzH+Qfrhhj
	 ONpmqQDrKZAxu5/YXALADOQzR5XVNSaTr2zT+BlPO4P4F0w9Cok6zLn527eBy/mcd7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794904111;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=80nJ9mfJsz3UGKSZAnLQ0A7kD85nyx4H/r5vYSV/3QM=;
	b=vQiG0Cukf2SVfp3ixQ/s0Mjk0hHFWw6MbHxDo4qp3c3QKKKhi7JZ3hvkj0rmr9KUwmUK
	 9xY3SEKd9eYBC/Mmwq/KKXde3F0y+Vxz8fIwV2yn8DrpPAwJsTCVNZXY8cIXuws/uErmp
	 afHOSPFTLYMDwp+RvOyCe54UsQS6zNrrGjW0NvWdblFo1E+tE6gffwiMY2RzF3Pi9R29p
	 ldhvKWOHym0vA1ggb66ENEdOt0Fu7wrL2+VUvrp5llttjgSZJsWwqE/b8MPMaQHF5/TUv
	 IjnGGjJLHTAEUqWpXFCJV637io5zAHMmr6bzzxUF6IyL2+eJsjel5Blx3Au1xKucsVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=uXanWzS6;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F392960A2611
	for <ocfs2-devel@lists.linux.dev>; Tue, 17 Nov 2026 08:28:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F392960A2611
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=uXanWzS6
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a35ac4475dso28247935e9.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 17 Nov 2026 00:28:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904108; x=1795508908; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=80nJ9mfJsz3UGKSZAnLQ0A7kD85nyx4H/r5vYSV/3QM=;
        b=uXanWzS6KLBuYv3bFiuy7p2Z1+227mW1xrHWoFvaDbJ4eIR86cdI1UfJ1Vl6WUjJqL
         IJaho440FIf8b9IVU7Kam+OSXnIH1jz33WHTujYT1BQfo0B6SnXDwYqbWw0t0qlqzaok
         kNRlJO6ubpwmwkK9bKsbnA8CCcxZtujXfM4mSBx1ucI+Gj/wfMgQKSvTWN80MqHAe4Q4
         K0wutzKwO2Mf+59qNoIzXTOiwGbG/+A4azNJdDQMNWt+RQ7wzSKmF6jTS0qaKJWAuNDN
         YKdae80DaM2Rsb1thTTj773gVDHc6h/SXbfPEUrMNYox1t+BGiLn0VpO0U/ZIX8mo8As
         cNsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904108; x=1795508908;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=80nJ9mfJsz3UGKSZAnLQ0A7kD85nyx4H/r5vYSV/3QM=;
        b=NaUpTzRWDVaMXcnka8UdjluShN9QE8vEvOsMiv0tiwsbHX4Kodf1gKtRIYmTyvf8z+
         qE/QQY7ICZcGPdnpaOqL6yTG79lDO9VF3mYdmB+0H2bnZ1afjtdCjAQDHIpO+jEl53YV
         /OTzmr+46MYWsi2XiacAtsdc0TNzhi6h+DZcQ7X9oVN65MnJThPtICa+ammNb7vXGGlq
         C0zhEPl0SXkrE8fzKOHjdZNimn6Sex3m3bMLH9Bz5yKcTOyMOXFfdA7SIBV2Cm06I8Lu
         vJn/jj/2LnWYx1wpDGuHPplb08FQDYV8q/mKPfj5m/+ag999AlvA5+Lat7C5pUuMHPIe
         JIkw==
X-Forwarded-Encrypted: i=1; AL+hErGGLtavYY2o7Fcaahqfsoh7Iijse+PsKzfj9aGyUZBglGedu9N8vESU/iesmwo/a79cpbQyoibjQz6+Vw==@lists.linux.dev
X-Gm-Message-State: APuU4Z8cnr033mesZLQqD0evLuHCbzMqdOURlNRWRHzIjw3ZXOheWFYU
	M20lyLhlafZo+sg1ISxOKm+oasf28aLQcgO6xyy5RB/ZP8h2Y8Ajc8qdZf0tEqmq0MmC
X-Gm-Gg: AYBFou3z5bTiPL9zeVe1ZuYFo4C7x1G4UFnGWYL9Q+MeUGC1ickCBJzRrKSMYRJkahN
	FUc04un/uD3befGkPMIll8PdVajHuZYBjjM2++PPf2DkFNbPPrkKr1mMLzBUzi0EBVDWPndQ6Ng
	Nn2KZG6KZCRtCKS2PSSCLlsuBnxE8Pv6+5fXV+TmLu6UeFJxEqyUVNGbyEnHECGTgRLT8SkqMBF
	qex7+ufy1R2CgSXXysytFqV1CbQVLcDp13yFEGghTDg0yFjuFha7PAJPVLbgjwerkw4O46H37yM
	Th4cW4zhJHBIkb/AUvu/N9CtL6zcNKqFPoFHXG2XzveiS1RK7xcN8ICsOZzOAbSEzMXYnIS0y7U
	j3on26nBPDT7A0Gun6A3E2nnRJNEy5ayLSBDKMXprotEir2e9QNUjM5GJIfzMD5f78NMnSPQsa3
	eZFaa3lqnCU0JuSQjNw3Wn/+jFUFmT8mEnmm25eBbZhvd2KQSDwkpEyoSI8VS15Pq/iCHcahRre
	1rjRjEwYnIHoskaQSiEvEqsv9ldaOsoaaATKckeUlMaBTTLeuh5wmEN5Mc8clBlOwf5C3HY8rjM
	Fq+Y6Ge7mgeEZzEYbALaif4HbmnPV6/sXfP1FJQnb+2/+oo3tRMI3mLXpW9JvDNbRHzTbB6iHDc
	aQVUI8iOFKyGRYetBkeTO1elAvymtC3Nmyw+YJTyRXwLTe7mURvii7AtW
X-Received: by 2002:a05:600c:6286:b0:4a1:7e77:c382 with SMTP id 5b1f17b1804b1-4bb55a5d634mr255399085e9.5.1794904108278;
        Tue, 17 Nov 2026 00:28:28 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb78422d2dsm75197335e9.10.2026.11.17.00.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:28:27 -0800 (PST)
Message-ID: <afc070a816e3ae5eb3c9e2d62d4f25c59ee61df2.camel@amutable.com>
Subject: Re: [PATCH RFC v3 26/44] xenfs: use fc_init_pseudo()
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
Date: Tue, 17 Nov 2026 09:28:26 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-26-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-26-8cbbea1cf34f@kernel.org>
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
> Initialize xenfs as a pseudo filesystem. This raises SB_I_PSEUDO and
> also SB_I_NOEXEC and SB_I_NODEV. xenfs never holds executables or
> device nodes.
>=20
> SB_I_NOEXEC also refuses PROT_EXEC mappings. xenfs maps the xenstore
> page and guest memory through privcmd, both data.
>=20
> Reviewed-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0drivers/xen/xenfs/super.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/xen/xenfs/super.c b/drivers/xen/xenfs/super.c
> index 37ea7c5c03469..aba7d038ed735 100644
> --- a/drivers/xen/xenfs/super.c
> +++ b/drivers/xen/xenfs/super.c
> @@ -15,6 +15,7 @@
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/magic.h>
> =C2=A0
> =C2=A0#include <xen/xen.h>
> @@ -80,6 +81,7 @@ static const struct fs_context_operations
> xenfs_context_ops =3D {
> =C2=A0
> =C2=A0static int xenfs_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &xenfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
