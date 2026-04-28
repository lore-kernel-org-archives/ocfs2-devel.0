Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE9F3A6B7F
	for <ocfs2-devel@lists.linux.dev>; Tue, 28 Apr 2026 09:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777368814; cv=none; b=sXumy7h9i88xzoc43piEP3hVcTAqZ1o7dF5YDazrjQOtkxbGfs/Ii9I1aHQgLQ622dC8FQYGegaOqaKdDol48tSDc6yrsAMoYbFvH6qFMZNWyWglo7oLt+oxID2qcrIQkFgfkgKXL7pDVOuit60zmWYaRH7olXElxP/AGAQm3uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777368814; c=relaxed/simple;
	bh=WZ0dv++aH+AeLwkvbNXxLqu7wJ3mA6GpS63WG1N27Uc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hRRnTn95H1tKH8aYV9LDvir5h7zoi5tSzuRvgdTHZSzbUNcAJLvjsTr8BBfC+WYsITD6Jqhg2ZtJojG7SYdKJOqawukezSG9GvJYL9RREkM3MXGcvflz1UfcWLHitQt19L52lN5TcWI+mYDief9TGP8ZK/PeJHLXzD3muI2Donk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-67389cf78b0so19508951a12.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 28 Apr 2026 02:33:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777368811; x=1777973611;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Al22kA6RCf7FSEzj29cZLSkjdM9EgXxihmBX7/SeSVI=;
        b=cRNJ6y3erv3HURuZTXlba9vBakhYMPF9zYxuVGr5foHGVqFFIVt5vMylQDG01wysD9
         gGzha5uVFbwiKRQqkfGrgoqTjnXyoFA3v1pxv4++HDnlb5qdSF3mKYvTodP9yLDahOxi
         zdBv1a8SA8Y8FROw0sLRXDvPnJ7MV9jRBsny1/0Ty3ZwFW3XIe7bFhB0/r3/qq4AfQ2h
         YAlCvEt0fsE/CtD2r/LVbJT6HE9mjgiWm6AxdtKa73ZStB9mY2DdaIk4DNVOvdqh9BK7
         WBbvoE422H4ssFObq4JaDTzEfMeSAORUqXqSFwlU+uMySRq7YOI8C/Sk7EhGkNA/S8YW
         Vj5Q==
X-Forwarded-Encrypted: i=1; AFNElJ+n5y6SGut81d8SxmkxZQBfHMws3kgj/BaPRd6IHO0UAa0rgUwoI+OcIE4weeqnKCDZjUyUVh2ivGk1eQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw1sxb71FEtckhTnTeMexXBt2azklxZmhB6bEs33Ipi/erlnyTA
	sO6Bcxu27m3DMmCST7eO6p9kOHniurmFDn9hMIq46s3k3p3Y6dCA+IasTP1D6vgARcM=
X-Gm-Gg: AeBDievKbjqMnF2FDW0RH5LWgU6nzJ29/qKcM9Q8ojD6voxU7FJxCt7dwr2SVziNY+S
	YZ3fu6K5Ex8cyVL6svteqrNkgVYrjzE185v50ecW7tlRu+ucpd7J+BDVRpXt9xS303qo89jtP+w
	GCjrkJzPhlzqW0xoqe4/lBvCnI/iUL0CrJb/a3ug62oFJB3UGsZEER2BClJz8BR7sYNZ7nZSCZc
	Kp8AIRofrQgkPdW3dNndX6pNJjvWJvHo2Rcs0/ya5m4p8UxP4g1uV3S5+W0uv2FVVRVcgRA2NQ6
	AG70Ojre2sTSzrTbQdKGokQu6VZJ9rzpMcUgimdeVahC9FIf99FOyGerAAGxTvxHQ+FMGwqcktZ
	0kZ++tRR4AxpJvOKjpZwXnwj3S2VZrQDwFoP9UZGh35Lqqu/tyVHJYUYpOJClu3RlR+V4yvAcdk
	mdU2izN/Krg8sIIV+WWU0LKC7fzppHAKG5QEOKlfIGl0rPM9EMdK/GZr64+aEdFmiCGiBhTU0=
X-Received: by 2002:a17:907:6ea2:b0:bad:d530:dbf7 with SMTP id a640c23a62f3a-bb804727dfemr137994166b.32.1777368810927;
        Tue, 28 Apr 2026 02:33:30 -0700 (PDT)
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com. [209.85.208.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bb808a35e19sm76197466b.16.2026.04.28.02.33.30
        for <ocfs2-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2026 02:33:30 -0700 (PDT)
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-678adefbd26so6419607a12.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 28 Apr 2026 02:33:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8ZO9zD3xyAlDsE1UmJFVRNhaZvtZXY4lungw4tvgpT+L1zKB49YAOEW73XTZRGe+Tj76LPrxx+Z1dfTw==@lists.linux.dev
X-Received: by 2002:a05:6402:5056:b0:676:d8a1:7a04 with SMTP id
 4fb4d7f45d1cf-679bb09a4admr915149a12.23.1777368324094; Tue, 28 Apr 2026
 02:25:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1777306795.git.chleroy@kernel.org> <c73b90236f2810edd47c84edd2a8d8e8e0c816da.1777306795.git.chleroy@kernel.org>
In-Reply-To: <c73b90236f2810edd47c84edd2a8d8e8e0c816da.1777306795.git.chleroy@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 28 Apr 2026 11:25:11 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUvTBWoDN_wUo2n8-gkoheJ+-rbwew53OvoAwo8G5n1qg@mail.gmail.com>
X-Gm-Features: AVHnY4JEWBVPw4tSjHgbQTia8gZd2WGJ1sv6qLdKJbtvs4hms1blpvc35yb0VWw
Message-ID: <CAMuHMdUvTBWoDN_wUo2n8-gkoheJ+-rbwew53OvoAwo8G5n1qg@mail.gmail.com>
Subject: Re: [RFC PATCH v1 4/9] uaccess: Introduce copy_{to/from}_user_partial()
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Yury Norov <ynorov@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, David Laight <david.laight.linux@gmail.com>, 
	Thomas Gleixner <tglx@linutronix.de>, linux-alpha@vger.kernel.org, 
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

Hi Christophe,

Thanks for your patch!

On Mon, 27 Apr 2026 at 19:18, Christophe Leroy (CS GROUP)
<chleroy@kernel.org> wrote:
> Today there are approximately 3000 calls for copy_to_user() and
> 3000 calls to copy_from_user().
>
> The majority of callers of copy_{to/from}_user() don't care about the
> return value, they only check whether it is 0 or not, and when it is
> not 0 they handle it as a -EACCES.

I think the "a" can be dropped.

> In order to allow better optimisation of copy_{to/from}_user() when
> the size of the copy is known at build time, create new fonctions

functions

> named copy_{to/from}_user_partial() to be used by the few callers
> that are interested in partial copies and need to now how many

know

> bytes remain at the end of the copy.
>
> For the time being it is just the same as copy_{to/from}_user().
>
> Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
