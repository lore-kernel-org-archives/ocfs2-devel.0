Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3534618787A;
	Thu,  9 Jan 2025 18:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736445964; cv=none; b=VvHEyCfUg876uGgrEmYxXy8UlEdiwWGoaWWMkr5oFovrJb2FwTebjDin5EpnoVGYN28ukq2myVh045svMJRL8JsE63HRfqjdXQUl0H7gIUF9MzCVFKBKpnJjQbHKPxKz4Cwf4idIawEkLnve+ppo6OhZbiIIU0jjqIZfLC+2X38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736445964; c=relaxed/simple;
	bh=rp9xKD+8m1msQ0xxbCs9oZzFyU1GURrqUZhq3NbpvyQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VZDfMAbOVoBTLRuPumm/61F/h2i1GJZRnbEgzMhnss0baXDo1f0XYOpYBi4tzja4LFrqQzafYP5JJv1S7AdbWgoNz5EGEy4gUerg2ncDitCupUAfGFl3lErZBMARDgI5diRRJnipAROC50bHeFT1zHg9fSZZr/jK+qNPqzMkH2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hXJVC9TE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hXJVC9TE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE1D0C4CEEA;
	Thu,  9 Jan 2025 18:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736445963;
	bh=rp9xKD+8m1msQ0xxbCs9oZzFyU1GURrqUZhq3NbpvyQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=hXJVC9TEna9TWYKbS9F02aIUvOHalq4E7m1+cvMk0ArDdbnyNkOQeESQ7Ur7QTEYq
	 oV3fJnNHiU6ugTU9/tuOjHdJ9qaR831jsML8BcJ2B2+uzRQfA4kpmr3AmZ+XqRvw70
	 BTN8HX8ggLtR2WOIhN2X2Ipa4OKa5qs1wwTNGfy1p+9su4jHqsiWIAwGFmgaxU7Nfw
	 H9Abn1fQ/2SPP2QU6lVw0EYHITfjtwSWp9wIQJbaVZRVNv4TDYE1jWwRNuescPEqI8
	 vYK392uOFALwuMqP1HoC1bERclFcBuYV7fmAeGJqkaXECHPwUoHQw9LVho0fFgK9tk
	 fJ+fXn+JQWXLQ==
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-844ee15d6f4so82757339f.1;
        Thu, 09 Jan 2025 10:06:03 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU4jXhaetBibZ/hmdchBYWvF2l1SAnV1LRUFykzaKl5iey/cFFUumucujHsEG6jQSN07cHC5mQn7A==@lists.linux.dev, AJvYcCWLbXXebfHxne5je/vqSdO8ujCRzwcwRMlOa9883s88i2g7iLPT4N/zHrWpIXourkxWoQh2ssl/jagRs6o=@lists.linux.dev, AJvYcCXxLwHs+/M4lD2wW+fTWsGtXtIxwe1D62OVmHxyjN1Hcjb5UEeAB0rOb589RW5CHUqCHIDnBo0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzAGAgfv9/vJh1XduMGXqU0KK5euQsNsYpmJ3OqMWK3oR2DWEVv
	fJlIdrw3rU8GvjZ8p0UQJjsyYGlnPUlllaiSRAoZRbLG5gdbGVbIEOQSlAoH6o9amVdn7iNSYdl
	QPv+LOTrzvNWjZ1P6L2uRjz++KhY=
X-Google-Smtp-Source: AGHT+IHw82IqZn0L3vIWI2GRAE2/Fu1vkOzFuTOkK3ccul7HxPp7E2ac95iMCNTUN8mztI4YyZ2Kf9FZUsicSlonzfg=
X-Received: by 2002:a05:6e02:3048:b0:3a7:6a98:3fdf with SMTP id
 e9e14a558f8ab-3ce3a9da817mr60484875ab.14.1736445963152; Thu, 09 Jan 2025
 10:06:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250109-jag-ctl_table_const-v1-1-622aea7230cf@kernel.org>
In-Reply-To: <20250109-jag-ctl_table_const-v1-1-622aea7230cf@kernel.org>
From: Song Liu <song@kernel.org>
Date: Thu, 9 Jan 2025 10:05:51 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5zpA28gkBQYMMuYCUbnDzdeq4pHsd0Mx=PBnDPiHKqHw@mail.gmail.com>
X-Gm-Features: AbW1kvZZD8oqcdTZ9DXv7tEUC7bpyqeBsuw6nnhXboAE2kNg_1eTiibnv93HXj8
Message-ID: <CAPhsuW5zpA28gkBQYMMuYCUbnDzdeq4pHsd0Mx=PBnDPiHKqHw@mail.gmail.com>
Subject: Re: [PATCH] treewide: const qualify ctl_tables where applicable
To: Joel Granados <joel.granados@kernel.org>
Cc: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>, 
	Kees Cook <kees@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org, 
	openipmi-developer@lists.sourceforge.net, intel-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, 
	linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org, 
	linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-serial@vger.kernel.org, xen-devel@lists.xenproject.org, 
	linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netfs@lists.linux.dev, 
	codalist@coda.cs.cmu.edu, linux-mm@kvack.org, linux-nfs@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, fsverity@lists.linux.dev, 
	linux-xfs@vger.kernel.org, io-uring@vger.kernel.org, bpf@vger.kernel.org, 
	kexec@lists.infradead.org, linux-trace-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, keyrings@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 9, 2025 at 5:16=E2=80=AFAM Joel Granados <joel.granados@kernel.=
org> wrote:
>
[...]
>  drivers/base/firmware_loader/fallback_table.c | 2 +-
>  drivers/cdrom/cdrom.c                         | 2 +-
>  drivers/char/hpet.c                           | 2 +-
>  drivers/char/ipmi/ipmi_poweroff.c             | 2 +-
>  drivers/char/random.c                         | 2 +-
>  drivers/gpu/drm/i915/i915_perf.c              | 2 +-
>  drivers/gpu/drm/xe/xe_observation.c           | 2 +-
>  drivers/hv/hv_common.c                        | 2 +-
>  drivers/infiniband/core/iwcm.c                | 2 +-
>  drivers/infiniband/core/ucma.c                | 2 +-
>  drivers/macintosh/mac_hid.c                   | 2 +-
>  drivers/md/md.c                               | 2 +-

For md bits:

Reviewed-by: Song Liu <song@kernel.org>

Thanks,
Song

[...]
