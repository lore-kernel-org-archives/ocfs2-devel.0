Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794904006;
	b=a+VBdukgIG303FxixQKs6LDw9Y0JvOi5F4zk1CfDsP1DF7gvHd8n8zLvMdmzDBy8Q2zX
	 bNk2Nb/PZhEkuKwnAxxBRWt+VnqZx/0QwjkmKSo75bf9QWjl30W/cjOVZ2LbseiTyjjP0
	 +SjGKa0H7ur179O/JfEX5b9hCOkCiy0HzA0fCRkOPlCNRmifG169PcnS0w73B6dOmXkeg
	 68Vq6TUR7ubMHmQ2igmVik6QLJ4NwCbJO3XyLIKTTijqDCD1lmukfjC6INS8ytOFgw8gi
	 pr8di4wwF7YBiSYcYYGj6ueuPqYIVGsgseP9cwnCfuqp9DXkqTa/2A81Pg1MfPxp74Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794904006;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=zuUcsMvbqw5dxN0Fzu67367bPJAUtTqv88LLlRQCTVU=;
	b=2IJMcBBLi2dL04q+EoQp1eRejlKbylEoY0BIFvviBdm/fdGDoQIXBg2X2MeVjFTA3PzJ
	 e8pgjYtu0D09JrSeoOp76uFjm/yn4GtKF3y57/9wWwL3X+oXVeLK7jmmPZmCgptbAZNC0
	 IIZSXjtvF1Gy7Y365nOf2NiunA9LhLg5d4UOaCCFyNhEaTtVI6SCUHZLSe9z/nxjw3Iut
	 8E1qBxQejDToNXH6tQFoQNm89wiTlAaV1edbMPU2WiwgD4yp8C8Zm0zs0g+eyIfUpQi/y
	 RgZ1CPDpga54ykFU/SRhRvI/+l+T96lwNaFF878GN2BbJOI0SvuHJWeVTbMLB/Q4oCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="UKx/RrPm";
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0AC606A332
	for <ocfs2-devel@lists.linux.dev>; Tue, 17 Nov 2026 08:26:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C0AC606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=UKx/RrPm
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-4a3e706b5dfso174957f8f.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 17 Nov 2026 00:26:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904004; x=1795508804; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=zuUcsMvbqw5dxN0Fzu67367bPJAUtTqv88LLlRQCTVU=;
        b=UKx/RrPmhTGldtHcfNG1qU06hYbmnYn6ZCuGn4+mgezWIxVLxDzivpXn6Vdm8/jTeq
         rkLosPz8rrOmfca/qo6oc3FA6PSosLfoEh6amUpvZmrfz2vaxIR5gCAgV6vOXoxrdF6S
         ywgoLmnbiCyWISTpdApT1lx7El8xD2MZvlNS69BIkgbPo4T1pXiil/kIMSgFWS1eTDed
         jhQkUclN+rXRAOcCLj5SaNCl+w9clNstd6Ti45plGw4Shd7+4/vjtp3IgtVeyFsrSSzP
         XvLxVPUJG5W04x9O+YEr1sJtRRNtNb59KKdhN6pYjAoASAxuPjxC6jzgtPFHNxsSGppk
         jlLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904004; x=1795508804;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zuUcsMvbqw5dxN0Fzu67367bPJAUtTqv88LLlRQCTVU=;
        b=oZNfTeu1ytBGYIVWFCn8WCVMy43u+PlYjXDshhNcfWQ8ddnT4YTbRo+GI7+2mpeEF1
         cO9AJvbs42bTslE0OdxXzfIG7ZsJKBGi0k7IEEVKdfahmIOWE30CR1cpJyfTDKTLFnGR
         RcsXS0KfjPaxdJ8thtDO4lqcDdsxJRY9oJUZjw0FYcElcI27yZSGGQaUbUwlNNhrJ+6J
         lFDaKSZBbx0c20BhcVaCraZDCVxqtMl6jb7EXJlEg6jkihgbUGQ8R8MMVhIcx6cTlMlc
         8T8ivOgjJx0L1pShoR5Urg4Xw98EBg5M2zhLzuNK6MhCO1M8qB02Rlu0zxCNX0cjRHAE
         WEJQ==
X-Forwarded-Encrypted: i=1; AL+hErFJ3NPILiHJF6bhGaSqA7BvgBdiadPerZg5kuch+UlohgzmbaelUdFJG1NAn12lmtsTNcSNttwIRNRorA==@lists.linux.dev
X-Gm-Message-State: APuU4Z+wFvv5iOlr8Bb6Qc1CXJ76uTt5H6nLl/TINpvRwQlpJze1DOFv
	E1hlU6TnCmOTstvARks4vGdJTlGx72L5m9HEQvIbAAKbKCxH8NJ1A6LXh4Xgn+DTikFN
X-Gm-Gg: AZFdTZfbInAm7qNVYEWC8UvUIauzVJ3Z7sfRJyZWXYurzJGcMY4KReVs2cAz7NkFtzN
	VMCC9YGZFCzve86VRk1TLh430qMX+IgY0a3Mn66q1ZcNEHunl6Oojkuxl9HxxrspAY6EfYB5GUr
	AWDMoaLaw2mSvwbh41uurNGzOmOwPPwOgHPWRASD6TB/ICXqz5T3wlW/2Lh6jWV5TadFfVQFrx3
	R3zjpwJpMv9e3xsfGRpHfhzDxFhsNLamIuybnicdjgiqTwpGvIy5xr70LF7asuWYEw7hnXyts7D
	tLBQqhPib8LbsUNURohGWF1XDlY39Ic2EPZ9YTXjsRbvwGZHB9ZswUNLDHXsp44IFwVGi9IpA+u
	1rI28xvBDA4VnJY+CpQQHGRxlQSz/l9hMD/+B234DkhFbFSd38GBmw7UqcXkua+fmkIbAZBYzFM
	THXTnvqtWUMo2F/tELXq6gWI8UzE8JqsvmwNBLJFlx7DFG9IRA4for05Q8BwTseICCap4/l8Pgo
	RC75uFb6E9J22OimMtIdYPon2KTK+uvMI3AXi+pAxyiL3XJcUI5zHR5IvsGWS5SnedKuxTqjYE2
	yBEJqGH+p51nuaT3m8vcaKh7GHB3MBIWxAx2qIcQyVkHNOm8/Bg6fJ0SprdV4hLUMzFJaXEcPgK
	mq6VyooxQK2tFY6betYuvdND7eCss8t2ctNowbchzuApr4oWLzi1hLEHs
X-Received: by 2002:a05:6000:2009:b0:4a5:2e5b:51c2 with SMTP id ffacd0b85a97d-4a52e6a947bmr243585f8f.29.1794904004601;
        Tue, 17 Nov 2026 00:26:44 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a4de4cb1c3sm977858f8f.8.2026.11.17.00.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:26:44 -0800 (PST)
Message-ID: <c43d70badf41f62f8e149ac024bab3df979fa756.camel@amutable.com>
Subject: Re: [PATCH RFC v3 11/44] failfs: use fc_init_pseudo()
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
Date: Tue, 17 Nov 2026 09:26:42 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-11-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-11-8cbbea1cf34f@kernel.org>
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
> Initialize failfs as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>=20
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0fs/failfs.c | 3 ++-
> =C2=A01 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/failfs.c b/fs/failfs.c
> index 437cdc981c2de..f03334f361c0e 100644
> --- a/fs/failfs.c
> +++ b/fs/failfs.c
> @@ -3,6 +3,7 @@
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs/super_types.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_struct.h>
> =C2=A0#include <linux/magic.h>
> =C2=A0#include <linux/mount.h>
> @@ -132,7 +133,7 @@ static int failfs_init_fs_context(struct
> fs_context *fc)
> =C2=A0	fc->ops		=3D &failfs_context_ops;
> =C2=A0	fc->global	=3D true;
> =C2=A0	fc->sb_flags	|=3D SB_NOUSER;
> -	fc->s_iflags	|=3D SB_I_NOEXEC | SB_I_NODEV;
> +	fc_init_pseudo(fc);
> =C2=A0	return 0;
> =C2=A0}
> =C2=A0
