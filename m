Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794686759;
	b=V8AReW28eGk5jmkav1ifw8G4OpS1dZUYG+KwGBOYxVJs9Wqc36LnA5Y0ppI+ErLhNlrj
	 bvfiQ/KzI3m8xoe8DdnJXBAiY1Y3ORoFSAcWa66ABqtsi1btZifqOS3f4wRIfbf4lbhBi
	 aq9znnLjsL22WEvT7K1ZhXGkDu+GTZzaELEo4C9WE+ek7vdht01dqlRkfiz1SIiu+Xx2M
	 3w2qTRGDSWOpG7/txCVshYy1lPLruXDKhtnMALyOcGoHDvrtuyqOZt5FqonlcclSstGA6
	 QRAnY1+aFDtzrsbOf0zuWNOe2/wdApv3CuzVB/AjVMgPUFOSw97Wgf/ehUet1sm2l7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794686759;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Message-ID:User-Agent;
	bh=cEK0v6G1yB2cz/8630PKsjvi8Z78P9QyctaIU0ylRW4=;
	b=wT5H29yQwVnZlhoX0RCWq3j+vHUbmcAcX1F19lw/rKJnQ71wmcNKNKcmc0LFOLUMb20q
	 hBZCzbGrrA9GXzBGYCdxsJnSU1rvMPPwzB7QzezriT6vR9yQf8YJ1cX3XM5ujvOCD0XJX
	 keaNL4CLNiKsO/ZEFz3bnZFy8hroAQx7Z909W4m/bqRURSFzgL8j12XQt8Xf4sO/qEBdk
	 nX/NB2MfVUsMEzV8qm7mERE3GrHg3hY5Jze1GPpzaJuh0Gf+7srsMP+KgsxJ1D6JCA9KQ
	 IuBqk8FTlLOJMAtZYUm20eKOsnTIxDEEKY04v3Y45aziqaw9VPSLLoXjiNOjoFhqFwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=ilNgJ3Sn;
	arc=none smtp.remote-ip=209.85.216.52
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C01460A2608
	for <ocfs2-devel@lists.linux.dev>; Sat, 14 Nov 2026 20:05:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C01460A2608
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=ilNgJ3Sn
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3adac5c10e3so1206758a91.0
        for <ocfs2-devel@lists.linux.dev>; Sat, 14 Nov 2026 12:05:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794686758; x=1795291558; darn=lists.linux.dev;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cEK0v6G1yB2cz/8630PKsjvi8Z78P9QyctaIU0ylRW4=;
        b=ilNgJ3Sntu0pY6pPhKI4uGJFNo+SlMecdZqgvb4KrTI7WLdZO971A0V9MrNandO28S
         3vq7hz/1ioS8xtDUN+qhNyWcbsmmyr7GBo6THELHDCEv1pF7e2vj/AFb7hRivjqepu/+
         KGD+4B6G07KrlhCpXD1iQRYOllpYE8oNrUeWQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686758; x=1795291558;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cEK0v6G1yB2cz/8630PKsjvi8Z78P9QyctaIU0ylRW4=;
        b=io8WCtRQ2U5MILGd5xuFYaMoG4LQWST1xZI6hCBxDac2PiWOIzmsynCUJ5ekHhuZeV
         7uP/2FAdf+UsaMzQ8wgfv6ytomOb+ejQug7p6pUJ+nY4+vfVgiyuFmEePqKbmbYG74jB
         lkhpgoEAphtbXShNKa0nN53qppmlgMAd4k0nWcaSeqcpCFg5lz2EULPQdWKfirHcp1p+
         uh6eXnDR6C/FDtFTEF2OwnmLfArAfD9htIkoPf5q2OsoIGlXtlQdq0Y3nPfG0b+aP0NQ
         tJFtWUynM+CnSUM4s3fV2wNbnL7O2w6QynFeKyEXz4k898UfFTIv+Di8skIo/XE8L55g
         tBQw==
X-Forwarded-Encrypted: i=1; AL+hErF/VvKye6Kwrx5BNsBDVokMW0rno5FZIuje0ZIEyMzwLIDfTtiiVvqOYcmoC79wU28Da0u4tp4wOqbSvg==@lists.linux.dev
X-Gm-Message-State: APuU4Z+16TfTW4u1Xb5GcY4Di5fnHvW5hnyhIKMBhUNl9Q3Yp7BkH35z
	NCSO5+XeAr5zK8TDevcz2680Hr8d0Qn3DXGGLLgcxcAEdbPwvn5m4dot4OjvRlI1OG8=
X-Gm-Gg: AYBFou1gckrdMyje4D9PNA1CTypzk3TuE07X7TkklUzSjw5RlvoIXhhjIbpgJnOKGAS
	uIZu97FZmnIVTqGgsMlRXJzN8rwsdbE74rAFBv3gEzs1kBX6XKZp895KQUsozoGIS25Jp5tLqjF
	X72dAiOHCtCT6mgKuarwSN7/i26HT58WELuDYL+MijbBKwwKarxTNrJmjyG4ONIRR77yifymJ7J
	Rty0i9jpSVAeiFTO/vnUOjxCEx8r5NFp8RcX990amOcIIj+IvgltpnWYdrHiKlYJMxsUYVlqXmH
	UbYwrF62smt3tnSqtus7YpOKq2R/Kr03ZdQufd5EaREkNn9apy4uyIV4R5NaHeeqwhclXg5SqbR
	f1bwiMpuXesKCYYpXtr/NfhKcgNkXUhsfrA3a4xixK6tTyY5nbnMmEhiWXUjqiQXPoO6/zmkYUl
	LtXI71QQSxV+e+YCDpND0efqMteeV4TLXVCiMcRa5MKIEjaOu7kAp49y5g/NP1ipN3FCze6pqdi
	PVekY7aWCEGdcbystnXR8uhsTnD/xt2X86kPjZbKJRCJU6Otsl9H37Q7xQ/3DMx8srlKB+axxO1
	luJ2SEVp/k+gU+rvtGnF98Njr9y7p4+bMYtUQGb79IRvf1S5Fc4QNRln/Op79OrEHLqH099TR76
	D8QNg4ic8IAh5zAqo13m4TjmpPmlnSxMjHWYJiupzSKEz+aDXbwwG0fuSphv4cLaGqWw7kzCLSg
	GzrJvnNfZk4uu9UpQQDMOc6N6vuJFs3BdUhS2IM4SUuVOSlzjMo9nfcU07
X-Received: by 2002:a17:90b:3b8a:b0:3b0:9f53:e8a8 with SMTP id 98e67ed59e1d1-3b1b0b5f2c1mr6192503a91.52.1794686758572;
        Sat, 14 Nov 2026 12:05:58 -0800 (PST)
Received: from [172.22.0.2] ([64.16.22.130])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b266d873sm4654869a91.1.2026.11.14.12.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 12:05:57 -0800 (PST)
Date: Sat, 14 Nov 2026 12:05:55 -0800
From: Chris Down <chris@chrisdown.name>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org,
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>
Subject: Re: [PATCH RFC v2 17/42] securityfs: use fc_init_pseudo()
In-Reply-To: <20261114-work-loop-pseudo-v2-17-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
	<20261114-work-loop-pseudo-v2-17-98639a2286fb@kernel.org>
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261114120555.cbfaf8ab8a92fb25@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

Hi Christian,

Christian Brauner writes:
>AppArmor puts a .null device node into securityfs but only ever opens
>it via dentry_open() which doesn't care about SB_I_NODEV.

Not a big deal, but userspace can see that node too, as
/sys/kernel/security/apparmor/.null. Opening it by path works in current
kernels and fails with EACCES after this patch. Now, I don't know of
anything that does that, but selinuxfs gets SB_I_NODEV cleared again in
the next patch for the same kind of node, so I think we should do the
same thing here. If not, it would be good to have a line in the
changelog saying that opening it by path is meant to stop working.

Once that's fixed, please feel free to add:

Reviewed-by: Chris Down <chris@chrisdown.name>
