Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4060A2750ED
	for <ocfs2-devel@lists.linux.dev>; Mon, 27 Apr 2026 21:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777326745; cv=none; b=JMq0WYCSY3bQCihP05tV1/nyl5GGAZWD9tn7pGyoaCfi7t7zybKn4oVeRJX3wnIAPkXNs64K3XjZaa7CW/2oSpZvTh+k3+wiOMGQgMtGHtjLet1EWCzDh4iphUIo9qmo9KMfgs/0v6myWpDAzs3j1o6SGtRbUryWH+ZuyN1l6p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777326745; c=relaxed/simple;
	bh=7P7VU36hQu4iMsGekLZKiPL3rBFQOW0TOaXA+fXfycA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zv+3e5N7kHTOL1zbYdtK7LvVgM34iU6vNNOPphwlxXl1EUVNg5kpUtNhMOH2oCSu9TmAvHwNW/hzoZflfhMgRtGkjGdzyntyrurhv6dXgXFGWbtYL5OfxYfPi9l9MjaGIGJx0Q1Tc/5LXiSj8Ot72eR9mjy1vCT4xRFqBbDRSRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KIQrzOM6; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KIQrzOM6"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-677f7c29af6so9392481a12.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 27 Apr 2026 14:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1777326742; x=1777931542; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eodThUBj1SnOvacXe/3ftYxEWQMFbYqc4B0FCa9Alx4=;
        b=KIQrzOM6TPir2+/GQTN9iIYBpj6sIdR4GpmKZh8SUPJLXM/lAfvoOZsYJB0Lkmnas5
         cn59K1VU5mjaCKGk+DCwM+3NmVfyoESvrJzmXbajWSgXc4HB2I9lS/jd+ea/v30AEbn/
         mHlhTMX/hEIp1e9AKBfkVRrD1tOHehE8IrzVk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777326742; x=1777931542;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eodThUBj1SnOvacXe/3ftYxEWQMFbYqc4B0FCa9Alx4=;
        b=DDJE0UHjlb1tnNDZHJi1o40kJxbEKMP0yEdJ/KrdLQr8SqvbC/FNRMS2surqaV42b0
         P1Si3Rgf2oCrxcw6ExS39lKmLqpi0p+eFytEbG0Pon4Path1EF3Y2BsUbqql2jRPDxJh
         /4xpEAPbwzLjdZH+cJrTIZAlfxz+A8imj+mp9iC0peLTlXoJUyBhLkoZ+ueNjlXIit9k
         cocmwsil4l3DgH52ZZJgUlaJ4PfQODBxhbWHSuWh53GlmQ4EYQ0G/TseSn/vMblNWDK3
         KYSgvedub3O0+m/DG//FBHz8hLB0UbOdhM3tUv6++uJ+IDhid38FMJjBHeMJgio6xuiE
         ZsIA==
X-Forwarded-Encrypted: i=1; AFNElJ9ROUqTzxqKoKVLoVHZyJAotEfI7uBGFF6Jstpqg/GpodcOqMtgyVrL7TniW9M/Eem6EY9IGXiZyXxaMg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw6cQuTnwEyA3rtitTvbzhxYtdfzGiFSB5Ld8Lo4wbwyBecspkP
	ro8ZwwzFhAZ6ojEIlg84qJBsPD/WNHhjUlatGiRt50Z1W/om8o6hTrcJ6eEDpxlgUtGrr4lD2qf
	OAIJpgx2pMg==
X-Gm-Gg: AeBDievEZjUQExro40QhGtlJDwjdTpS9MLxGoaKpBibfz4+VQD3c6dk0ZWnSXqNwmMI
	wj5ieGbyKp/+fQypjEH1M2Deap2UDeuZ2WdRAltD9RviPWlt5ARqpSqeYN/llYFbWXEyv7nezyN
	3hRaTQD0fVOjr1X5HawyA+J800PLiPtUoSFWl80489IqR8X/UfHRNEgA9pxNoG7aOJfcvEUyksS
	cxADp4/guK5gRZrvZ5LxnhqMP/v5vmsNOKSakcJIuX5L22VqMQIs7rBm92j0taTdUlEElTVjZwh
	1s0QH9etlcbIxohFInxZ39THOdeHIyXjSjP+lbGHjXQYC7xp7LAf7BzFXXmSIe3xHcm+f0nVkN5
	pEKMW3PL6RfUZDnZmKJU8gTVxCN4MxjpCJOkZ2gWgzGvExL6N3dLqv3aG3l+Zi+yzMnNrrc2Wrc
	2nZFbjY75JBfRPJCJKWygb6cCIpyKEp1g4vCwHqEgsbL7g08poHKhs7REjbj0xLsrD6ggVPb8Uh
	aO6MnTRl9s=
X-Received: by 2002:a05:6402:5056:b0:672:2993:b038 with SMTP id 4fb4d7f45d1cf-679bb09a808mr109880a12.25.1777326742668;
        Mon, 27 Apr 2026 14:52:22 -0700 (PDT)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-679b68523f3sm133186a12.20.2026.04.27.14.52.22
        for <ocfs2-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 14:52:22 -0700 (PDT)
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-670ab084a39so16193142a12.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 27 Apr 2026 14:52:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/YDlnt6+5UbJIk2zUldUnpHAWUa4AIVDYKbTT8IPz0drJA65mTzrEVoA9EiFG1SadFT+WWK3st0zwljA==@lists.linux.dev
X-Received: by 2002:a05:6402:35c2:b0:677:270f:6f4b with SMTP id
 4fb4d7f45d1cf-679bb04a8a7mr185115a12.1.1777326742385; Mon, 27 Apr 2026
 14:52:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1777306795.git.chleroy@kernel.org> <0ee46bb228d97163fbdc14f2a7c52b93d8bc34ce.1777306795.git.chleroy@kernel.org>
 <ae-j2_QirCySZD02@yury> <63a4d0f6-0eb3-48cd-9f98-bf7b223b2606@kernel.org> <ae-2yLWSGnfeTvh1@yury>
In-Reply-To: <ae-2yLWSGnfeTvh1@yury>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 27 Apr 2026 14:52:05 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgPrLy0FR3sEWBYQuNAac1axDASYMnTuPuxEU0WytzL7w@mail.gmail.com>
X-Gm-Features: AVHnY4LQUFWo9ODz4M3q2vZC9Gn8nsdYr95Nd4ky5ERVHHxIyN_9ZXY5zjebfdc
Message-ID: <CAHk-=wgPrLy0FR3sEWBYQuNAac1axDASYMnTuPuxEU0WytzL7w@mail.gmail.com>
Subject: Re: [RFC PATCH v1 7/9] x86: Add unsafe_copy_from_user()
To: Yury Norov <ynorov@nvidia.com>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Laight <david.laight.linux@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, 
	linux-alpha@vger.kernel.org, Yury Norov <yury.norov@gmail.com>, 
	linux-kernel@vger.kernel.org, linux-snps-arc@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-um@lists.infradead.org, 
	dmaengine@vger.kernel.org, linux-efi@vger.kernel.org, 
	linux-fsi@lists.ozlabs.org, amd-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, 
	linux-wpan@vger.kernel.org, netdev@vger.kernel.org, 
	linux-wireless@vger.kernel.org, linux-spi@vger.kernel.org, 
	linux-media@vger.kernel.org, linux-staging@lists.linux.dev, 
	linux-serial@vger.kernel.org, linux-usb@vger.kernel.org, 
	xen-devel@lists.xenproject.org, linux-fsdevel@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, linux-x25@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-sound@vger.kernel.org, sound-open-firmware@alsa-project.org, 
	linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, 
	linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linux-sh@vger.kernel.org, linux-arch@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 27 Apr 2026 at 12:19, Yury Norov <ynorov@nvidia.com> wrote:
>
> This is what Linus said when added x86 implementation for copy_from_user()
> in c512c69187197:

Note that some things have happily changed in the six+ years since...

>   That's partly because we have no current users of it, but also partly
>   because the copy_from_user() case is slightly different and cannot
>   efficiently be implemented in terms of a unsafe_get_user() loop (because
>   gcc can't do asm goto with outputs).

now everybody can do asm goto with outputs.

Yes, it's disabled on older versions, so it's not *always* available,
but all modern versions do it. And if you care about performance, you
won't be using an old compiler.

             Linus
