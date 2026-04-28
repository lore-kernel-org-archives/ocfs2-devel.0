Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6207D3F1664;
	Tue, 28 Apr 2026 11:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.228.1.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777375274; cv=none; b=buN/pxfa6TpAApzwyyMI4CmXrCHQKE1skHx4JTVZiIr2OSYAHvO9fddgGf6oNGCaGrc4tOpxvTQS0Y5ULqA6pVR1YVJ+HR+vnA3n0+0UA8zBvRedfQqOPmty3If4PWaoe498O5fprKw3cQJo+G2Oa/nW1xiw/ve1Nzx/mr6UJ0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777375274; c=relaxed/simple;
	bh=5DkX/L9B3d/cRrLHprvgAdk9AfWqqBG9xKTQLL8w4bk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EP878SKISU3z0FiMwJYKkgYssoEtEr0z5b+u3NE5sVJ0i3v58ACRLtGzMjRshNj2EBKy7cm6WGsgKjdqtjj1mveCYVu/n2OknoLvbblUHT/w4jnTeDKtrJ1ScCtDv39Tlbic/8kwRSmy1q0Bu3J8gZMJcILsU8b5Mk3j3jZFfyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org; spf=pass smtp.mailfrom=kernel.crashing.org; arc=none smtp.client-ip=63.228.1.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.crashing.org
Received: from gate.crashing.org (localhost [127.0.0.1])
	by gate.crashing.org (8.18.1/8.18.1/Debian-2) with ESMTP id 63SBKIxF1057213;
	Tue, 28 Apr 2026 06:20:18 -0500
Received: (from segher@localhost)
	by gate.crashing.org (8.18.1/8.18.1/Submit) id 63SBKHXo1057211;
	Tue, 28 Apr 2026 06:20:17 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date: Tue, 28 Apr 2026 06:20:17 -0500
From: Segher Boessenkool <segher@kernel.crashing.org>
To: Yury Norov <ynorov@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Laight <david.laight.linux@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-alpha@vger.kernel.org,
        Yury Norov <yury.norov@gmail.com>, linux-kernel@vger.kernel.org,
        linux-snps-arc@lists.infradead.org,
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
        ocfs2-devel@lists.linux.dev, bpf@vger.kernel.org,
        kasan-dev@googlegroups.com, linux-mm@kvack.org,
        linux-x25@vger.kernel.org, rust-for-linux@vger.kernel.org,
        linux-sound@vger.kernel.org, sound-open-firmware@alsa-project.org,
        linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org,
        loongarch@lists.linux.dev, linux-m68k@vger.kernel.org,
        linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [RFC PATCH v1 7/9] x86: Add unsafe_copy_from_user()
Message-ID: <afCX8WlnEFUei1y6@gate>
References: <cover.1777306795.git.chleroy@kernel.org>
 <0ee46bb228d97163fbdc14f2a7c52b93d8bc34ce.1777306795.git.chleroy@kernel.org>
 <ae-j2_QirCySZD02@yury>
 <63a4d0f6-0eb3-48cd-9f98-bf7b223b2606@kernel.org>
 <ae-2yLWSGnfeTvh1@yury>
 <CAHk-=wgPrLy0FR3sEWBYQuNAac1axDASYMnTuPuxEU0WytzL7w@mail.gmail.com>
 <ae_jeJLlVWjJ4sOY@yury>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae_jeJLlVWjJ4sOY@yury>

Hi!

On Mon, Apr 27, 2026 at 06:30:16PM -0400, Yury Norov wrote:
> On Mon, Apr 27, 2026 at 02:52:05PM -0700, Linus Torvalds wrote:
> > On Mon, 27 Apr 2026 at 12:19, Yury Norov <ynorov@nvidia.com> wrote:
> > >
> > > This is what Linus said when added x86 implementation for copy_from_user()
> > > in c512c69187197:
> > 
> > Note that some things have happily changed in the six+ years since...
> > 
> > >   That's partly because we have no current users of it, but also partly
> > >   because the copy_from_user() case is slightly different and cannot
> > >   efficiently be implemented in terms of a unsafe_get_user() loop (because
> > >   gcc can't do asm goto with outputs).
> > 
> > now everybody can do asm goto with outputs.
> > 
> > Yes, it's disabled on older versions, so it's not *always* available,
> > but all modern versions do it. And if you care about performance, you
> > won't be using an old compiler.
> 
> The minimal GCC version is 8.1, and asm goto with outputs is supported
> since GCC-11. That would brake the build, if we just switch to using it
> without "CC_IS_GCC && (GCC_VERSION >= 110100)" guard.
> 
> Is it worth to maintain 2 version of the function? I don't know...

GCC 11 was released five years and a day ago.  The last GCC 11 release
(that of 11.5) is not even two years ago though (but there will be no
more!)

So it would be not conservative at all to require GCC 11 as minimum now,
some people might even call it a bit aggressive.  But in a year (or
maybe two) the lay of the land will be rather different.


Segher
