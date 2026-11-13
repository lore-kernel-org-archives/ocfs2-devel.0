Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.225.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794565562;
	b=wFSh05WfJCtCRY07uup060WMPeAaeEWgPIkYCW20/1mcJfXPgQVJWoIB0lqSNu1WfST1
	 zLejiaEaqojRGbzd+0Sdxw2G0EubNSCVgKt+p2cZ2N6B6Vy07N7fefcYBX6Eq6Qs8m2fw
	 DC5R8jttJz1Zptk67UJ/EzvCdozoI6EakTZU519G+nNzcm+OhS/jB7zM2Dw/eP11yrlfA
	 vdJbJQC99/ncEBFY1fxsKcPEIMwas2ACLfp3xUGEXW9FOoYbYZCg9sFBCY/gq15N7Spvp
	 DlxxsZmxFta2WDIKDKzz+4QOFhyrpb1pdjfj9OYXQJqyCtbriRXOxQoJEIyMBY04gsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794565562;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=5OyDtStyAeBedN7jaZpmypaL0n4+GQJgji3UYOQMX7Y=;
	b=0VmwEBDQ64FIQtDSPQsg6wwE9nYZmJmrvh46LS71Mcw/oBYTSVfFn40yUpHAUfnYTYUS
	 X7920jPCGuq1y9CRCSoMeJD81xSLG7S0Nxvji2SWf5U0DKZBSerxbmZLC7mt0WxembOyz
	 i2ozvQB3b5N0+qN3BFGAjQKezz/g6DsPjiy7/p4nCZmcxj46q/M+RHg6UfS50PQEYSNdg
	 LFOhIWLOgq5w6GrCgrBzGWSpLzD0+4PGXfkI5CqqY82QjEl16oi3J/wkFnQCtXInDuq/d
	 xP/xtEDKJCZv9Jzb7YP/sKrCbUiWLUZhBxD4odA6m/BTyAQ1j/3FEqOC5YWUgjUOEvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=NKq7lQZB;
	arc=none smtp.remote-ip=74.125.225.138
Received: from mail-wm2-f10.google.com (mail-wm2-f10.google.com [74.125.225.138])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC221606A88D
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 10:26:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC221606A88D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=NKq7lQZB
Received: by mail-wm2-f10.google.com with SMTP id 5b1f17b1804b1-4b80834ce1aso1170705e9.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 02:26:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794565560; x=1795170360; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=5OyDtStyAeBedN7jaZpmypaL0n4+GQJgji3UYOQMX7Y=;
        b=NKq7lQZB3gGM0sLLYfuaugZJma8go/eKSMPykgYyCjF01TolC7bOUFBph2QfysOfyL
         vp5NvROZpjYewkD09tEtztgs/Bv948KTGCgFAFE8W9m9Tgh1o6kqs3VlpiYgXnoZFa1E
         6dOKrEmaHZUiMtoZoELRCbkOsaA5u3w5DAe9hrgrfIytB4mkbb7vof/aPry42XRjS2Ge
         Mx+YEdY1+gC7h5G8rcsMvEpUrdF6p/l2J7IOEy17IDREEYE+uoM7ZRrVwsF0plr4N9dV
         9QQD2tyAyye/Q4u4AyHVswy28OrFuzWzjCWEh+r5REeK2kKNplPJ66d2gj/3wUst4EE9
         IlyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794565560; x=1795170360;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5OyDtStyAeBedN7jaZpmypaL0n4+GQJgji3UYOQMX7Y=;
        b=Vw8lmlV60dI8oLmQY1X0MdkNXXN8GUFUkaxVbsDgyNwT6QU7CtgFvHkBbiiw+n7iGg
         Cj4OxKnmIX4IFw7ejc9Qvyn28LidIWCD66Z0QVVznXcG7iEnV9qZlSszDuB+IXahPdII
         zoVNJ9ejtvUt4BE/EDM3rexAInD30wA51U8WaFYsLpUvjO0Oq6W5Pl4jPXJh3OAN1brd
         hKPXcARseEXlIJ7H23dIYMwAA0qYhqCQpZCeNiocmpqkJKnusWQCAcn+0BOd+iUdjd3M
         eN2pWWSxmIdTYUaqi30BAAwKQlvxCaBIXNmfeLWMRR6a32q9/Axp1rgXpAQUI2fE0x1e
         MRng==
X-Forwarded-Encrypted: i=1; AL+hErGVANdPPrw3QuMbgW8rj/GBR+k8UgvcRYJu/6s/FSCtP3L7km/SGpku5//i4j3Ho6HBqOurZ0hKmpI7Gg==@lists.linux.dev
X-Gm-Message-State: APuU4Z+E2DuVg/tSFCH2f5i8IGjSP451V+t8AvsT/kYQG2x70grvZwp+
	L0WvpfZoTWtjLP2iaquH66VVPuH1D+3W3FC+pVt1zA1W42lpNZP+rxpH9ePrb/25Bmk2
X-Gm-Gg: AYBFou3g/n+w1doN2wVb7sI8crxay1cU/NUR4Tt7w+pi6R9UROC7MmNbep+KpTEF78V
	BNK+BWHHbSGklB6EJ3hOifb2GpffOuL/58V5HQ5U/rJeEDXatqaZGo9LP3rGa6GF8LjzCcScJRm
	uKDAI2U7rwdVO+OjeB5PqRsDZpDWvlWUGSFTgtozC4oOoDzAZTve78pVUfd8vVpb3XALIEoZ9iW
	T40J5h9EMK/q8wBOIZgW6xrCFfwMVXMAlchWBVCJi6rNqDBodsqdoxiMg66pq+Izs6yXeY4AUFf
	gYuK35EtCeOh5HvMbccnabXwMIyf5SKqfWFeJiESWnhzC2TjQUJAPEx0YPURXJHLJHLrqgXR33p
	IUrhuDZEciK0TITv12lB13HnXf+pE3y/PO1tEhtBK2c5LOwhaZccBTFvbEx2ZvdOAEkjc+eeE+s
	4ul6gLv22QDrQEEK4wi3Z+isMF0w8uKEomNUeGnV7OhQ/S22zaqx1MM9JtJcWvTDtegJm06FLSg
	SS89aAVbJcQKvW1PuTjRNLl602R9sGZmrLUCVEyvUXq/J9w2Ipyb6TefxutjZynFDlRkJY9b6A+
	fwphkJZe4Vw2dAdwUp2ovT1n72HpWg5qcoMuKbKxlMw2pfBv8xD8/rM4e8vdVfc=
X-Received: by 2002:a05:600c:4e49:b0:4a1:78c5:79f5 with SMTP id 5b1f17b1804b1-4bb55aa999dmr38995625e9.33.1794565560090;
        Fri, 13 Nov 2026 02:26:00 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e2538b9sm244439965e9.1.2026.11.13.02.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:25:59 -0800 (PST)
Message-ID: <fb1d72cf25d10a960da627f6d93a3e041820ed3a.camel@amutable.com>
Subject: Re: [PATCH RFC 38/41] fuse: refuse files on pseudo filesystems as
 passthrough backing files
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, Chris Mason
	 <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
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
Date: Fri, 13 Nov 2026 11:25:57 +0100
In-Reply-To: <20261111151202.GA11391@lst.de>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-38-4c998976c6c7@kernel.org>
	 <20261111151202.GA11391@lst.de>
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

Hi Christoph,

On Wed, 2026-11-11 at 16:12 +0100, Christoph Hellwig wrote:
> I've seen setups where people use fuse to mediate access to sysfs
> sysfs in odd ways.=C2=A0 No idea if that's still around, but if so, this
> patch will break it.


Oh, that's painful. Do they use backing files for that?
It's a relatively new feature in FUSE...

Kind regards,
Alex
