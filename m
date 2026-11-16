Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794830457;
	b=1loRoMHtO4/TBpQITK9wk3EZRw4MOZLrA7olgOKd4igCqrT5Ats8V1TDUQOBOWW7bJfE
	 rpgQGdvV68522x+fRmX1mymIAY1a2CNbolf3wpA/Rt4zI7SYTUiImOJa6t1v3hxPXdFEu
	 neyjUeg30LI1Xg/JD01nbv63XVyhPe1FqgvDFSpog698XZV3yRaBYtUlkvtwKrQZ9nwLm
	 yjjZi/LjS5X0MiarClrfJ44hwIxaz4gc689waBc2BgOBX4SF53gM+7DZS/T4hFosFF7hO
	 OFEmb34bWtv/VrBJJ4sijPIp7yWQuMNFDGBlYbfQLaz+33IHBvoa+pn2gzE0RrnopTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794830457;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=kLAz6sn1EqmF7aJ7KDEBtraVgj4ybxLcfJJY1MY6K34=;
	b=iT37E3xq+YH+GxKns42Y5rIM2a5D3+Sm0AcIVpNk6UwcOq/L+PAFEl2qaUpiFRxceqfX
	 K14ay1RWvcBsuBCv2coeLbqU/0dn/9XVS1yZ/SWt7mpWgAX+XUqT/1pYNmf+En4rccHcx
	 S4mzSyXCYH1bNeoagca3ZmIqBPIwR0MJKaU1fO6BNYj/M7fcLfb1MTGkEFiPLIne0tzFL
	 qULHYH5d/ALwSRWBGUGfX3jePFaFNkbzyK5/ngz/nRMgtEOh2tv3VBvu3+zkEzzcPlqku
	 iEay6I2d97FpQnVMv6DM9Wi+P+eow+RhGTf3+YsBQX9n6J0uYZ6h0hSpFyVnQ1rJNkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=CVWVNvSq;
	arc=none smtp.remote-ip=209.85.221.71
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2280E606A32C
	for <ocfs2-devel@lists.linux.dev>; Mon, 16 Nov 2026 12:00:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2280E606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=CVWVNvSq
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-48e0461e040so2973439f8f.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 16 Nov 2026 04:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794830455; x=1795435255; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kLAz6sn1EqmF7aJ7KDEBtraVgj4ybxLcfJJY1MY6K34=;
        b=CVWVNvSqZ4Kvef9qLV13IEC3wrRDMTDLd1UcYfVh3RelG4sKSQwdvnpgNda+b8r1CS
         eli/q4umBwmNIrBBRVOSKSN6xcvy4LUaUh2LOGQRiQ7hXSigawtn6iNVRbkygI3zV7Pv
         uTHA5OlJFK1RtoFT38tnvJ1gsUTqMy9BWqCDcZ9fxYE+WfSCGmwpZfpwnx/yMaEQvdU3
         VV2CJd+AJFB+qDkTKJIJpCE77NldlBXcjqe0PbecLfz/BOm3ZNYcchBSAs6OoGUXDJwB
         gNyEKrURC7L1yFfUoGyPkyybCL/CsRYBWTncrou+S+70FvW8ktjvogRu5VIIzmhynoEF
         EdRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794830455; x=1795435255;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kLAz6sn1EqmF7aJ7KDEBtraVgj4ybxLcfJJY1MY6K34=;
        b=SAFSHxw32m1mki/7ZHmWo4Pjp+/D0liotkXCJrUfZNx85JDfF1zy57cV0BdmI6BLHB
         fRH22YKYyvomDcwrxFCEilJNv9lUDcFRGooraQh+XG8Y4pVQoLh/UeUreuHRiEyAeOfv
         2vU/vP6oBAwu0AQ+UFQzQNlsJyZ8l/5otn4SrWxN/YNwEAQOTWMWNmJIthEAGBx0kmiy
         Xm5gdLnf8tTzAVxQ0KFpJVQiafKFuC/thJU4XrJPGXKJAhcfaaNFtTCndgd+FYgfy269
         hHATK477tFcLCgfiXP039HjU2RTK0fig2fxoORErHw7vomMLCOtLT/Pqbx8GFLdikmga
         TMFQ==
X-Forwarded-Encrypted: i=1; AL+hErHjuuhoKlmniOU8YM5W8ctzxIA9emRCx3Df2Hy/FLaoH5rInjTZhzMay8EZ8H62KmzHPOWI9nN9MP03yA==@lists.linux.dev
X-Gm-Message-State: APuU4Z9ahgbPKXnNhqyKnjkmyjhU8d5pP3tzzmAn9ZUJhK7mmY0ckQUG
	CTkrj+ijOjAsaDxyhxnriet+kn1T2ELScRxz2wCdPPwmb5CGo/zK67Pd0XqeagLqW87NA4JP8/D
	R4KFoSBxcddUymWhI4Q==
X-Received: from wrso13.prod.google.com ([2002:a5d:474d:0:b0:493:3d97:6e88])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:adf:e007:0:20b0:48e:3697:708d with SMTP id ffacd0b85a97d-49c70ed8e41mr16698595f8f.12.1794830455230;
 Mon, 16 Nov 2026 04:00:55 -0800 (PST)
Date: Mon, 16 Nov 2026 12:00:53 +0000
In-Reply-To: <20261116-work-loop-pseudo-v3-12-8cbbea1cf34f@kernel.org>
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org> <20261116-work-loop-pseudo-v3-12-8cbbea1cf34f@kernel.org>
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261116120053.371591-1-aliceryhl@google.com>
Subject: Re: [PATCH RFC v3 12/44] rust_binderfs: use fc_init_pseudo()
From: Alice Ryhl <aliceryhl@google.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, linux-fsdevel@vger.kernel.org, 
	Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org, 
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, 
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Nov 16, 2026 at 12:04:45PM +0100, Christian Brauner wrote:
> Initialize binderfs as a pseudo filesystem instead of raising SB_I_NOEXEC
> by hand. This adds SB_I_PSEUDO. binderfs_fill_super() keeps clearing
> SB_I_NODEV for the binder device nodes.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
