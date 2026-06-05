Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE633BF699
	for <ocfs2-devel@lists.linux.dev>; Fri,  5 Jun 2026 09:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780653061; cv=none; b=KouxS1OcPmvoe62EA3ZYvq40DRRr3PirVQ7O9VyyZp1yCkaAgcoEB7eN21HV7Rwgp98xvQ/AlYpKjKp5A6gr11SqVKozCqtIyUOBCgEttogvNspliIxME6zjxln0x7ye8LkBG2g4v5sKyhMu6BSlqq/BONZPd01dbG41ZXDKVB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780653061; c=relaxed/simple;
	bh=Eu3wfuEQrxBBkGKCkeAzZasx5ExuiXoVmmjPgYkiKnE=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RWiyOYCvomr2mUL24wL9BtWJW3WprZMMraLVKU0yOBBZE0HGVtbxf7Jlgi+LWyYocwxysvh5SUTUBC05EyqThEdOrW+lZgxNQvuCQI63Tv8hjFFLXGP9JC5Lg0iZjJofVkLjQE76ofOLkh5WF0Uf8MY12xlxgBfR1oZtUgVZtE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XTtWtRzK; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XTtWtRzK"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5aa5e9a64b4so1890753e87.3
        for <ocfs2-devel@lists.linux.dev>; Fri, 05 Jun 2026 02:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780653059; x=1781257859; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xjcf+ZeYGf95GdPFKMkbVvi+CX0UN2Mwhbe9F7S/JCk=;
        b=XTtWtRzK8mYGhZg41sVbp58maWE2NdxFkvEc/0dJ+z8V7s174039LHWNjWGSCEEWMI
         wIN0IGbXydlkGgQMd6QAgd1Bi8G6o8PkmyvXER7aiu2ZoKtTYDmuk9a9wr/NN/zGF15q
         rx4hTUgoeWAA2bRA0B+zrmhCVZoZzdCDMA5xlarR/iDgdTwhmT6HFEaNA4Pco6KiZJlZ
         K/Ip2Yh3QfZe3M4Hd+dEuVINCnYMF21iX1jCBYwjP7smYyW0vlrPOATAnHRz46dBOd+s
         QleQwAvP9P0ZJrXKMy4wV7/yUJpmtwfiqQgVzk82ODKfdBS23Gq5exSimpGQwHoOK9JK
         ciRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780653059; x=1781257859;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xjcf+ZeYGf95GdPFKMkbVvi+CX0UN2Mwhbe9F7S/JCk=;
        b=q/N+4y8AJgQQWdn/Z+Ci+1ww+uLtd+DU5A6duQ8ZEJYzCr8IyeNeBp52c/5J3rrCWk
         RcsMgSpTGTdXoMb3VO9OB+kzZu7HWjATV3fDFFF/5yRPxiX8+3r4u8SUNZTogem1uq9R
         VEJ6BH9TP7BbB3gUPXxDhJWfKYLGaQ17flJxQXvaS+BFLLSVFmWj6i5wcSpS38FQVo8N
         iU42FsYhJq24d12ZB8xAa0VbRYwSiAXGrEW66kPrtzJSeJlp1UISoaoKl/c0/jX8i3Ne
         DhYd9S5iTey2eV7pCilc/UMOqDeIXhOjC6rspcGt1IBJWJ5kPw8v1Tfkrpj5GXHLvFsh
         4A8g==
X-Forwarded-Encrypted: i=1; AFNElJ+0HXNcDB7FJpWXWCvYfKG+QR2TXKn/ck+6cEHwgG9QYRYsxC8gTJy0aUj72dGxzgh5syujOM8x+mudMw==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywgy9/bCsLcbiw6l158gGFQ3bzHTlTWcn+QDH8TiQndfwyxUgwy
	lmCKRjEB8hdx4tfVMMAVfAgSFey4ckIXHdBjV2nPKIMmIOrFC1rQN8eE
X-Gm-Gg: Acq92OG1wYm24CRE7hW7/hO8pEFSlZxgt16he+0vBdS/Lox7PVDG57rk36sVvgCCYeX
	R0uRnXpK3DQ8evayOqa+HJrolYM1gRDAWWl7Dk9YEX/kyWILTXB6FPwNifdaR4TZ8skC3DzlWTq
	3wSRkCSUEh3ElcUoGzd5r7R4lK4Cb161Pm38C2A/yOjrUWkndG9lf0wkVu/uFlMKvCIkWN/60PI
	613aDG5ymyWtgaEDBz8Ir/IXZq8c6OMai4gcDxzbp4ueo3SbqoFEKbPA7R2A5aFj/hQnNnYQ16Z
	h8F0mZ7r8ae4ftB6kPywY/OJWtBDcmDqTuGQj7VMMX2RtRHrzS7um//EVSfBn6GuE9eEfhH+5ry
	1PA+iwsTeQTwu+HjBIaKLNTsNVWRvl0Ln7V13wRyyfmZSc/azBZLDvcIkxsqLSLugRTmezy816T
	+9RVqtqRHl8ayjHdZvsFM=
X-Received: by 2002:ac2:4e0e:0:b0:5a8:6cbc:60f3 with SMTP id 2adb3069b0e04-5aa87c03398mr899588e87.34.1780653058812;
        Fri, 05 Jun 2026 02:50:58 -0700 (PDT)
Received: from pc636 ([2001:9b1:d5a0:a500:de96:9acf:5dca:ede4])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aa7b97a71fsm1761298e87.46.2026.06.05.02.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 02:50:58 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Fri, 5 Jun 2026 11:50:56 +0200
To: David Laight <david.laight.linux@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, Mike Rapoport <rppt@kernel.org>,
	Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Dave Kleikamp <shaggy@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Breno Leitao <leitao@debian.org>, Kees Cook <kees@kernel.org>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org,
	linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-ext4@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 10/17] jbd2: replace __get_free_pages() with kmalloc()
Message-ID: <aiKcAIbzz3z9vN9a@pc636>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
 <20260523-b4-fs-v1-10-275e36a83f0e@kernel.org>
 <yfzx3jgzwesernofl7mzixa2mhjfii5v3o7yapghtmozixrpfu@6bsh7iixyiov>
 <aiEX4UTxEnBTjVKo@kernel.org>
 <ximvn6jwgtam665a4droqkp73o55kwvd5uukyidwjesmysobth@oe7rigpsjfkz>
 <20260605093332.7b067876@pumpkin>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260605093332.7b067876@pumpkin>

On Fri, Jun 05, 2026 at 09:33:32AM +0100, David Laight wrote:
> On Thu, 4 Jun 2026 10:05:52 -0400
> "Theodore Tso" <tytso@mit.edu> wrote:
> 
> ...
> > I suppose we could do it with kmalloc() with some flags which to
> > prevent forced reclaim / compaction, and if that fails, then fall back
> > to vmalloc().  Is there a better way?
> 
> There is already kvalloc().
> I'm not sure how hard that tries to get kmalloc() to succeed.
> 
I assume you mean kvmalloc()? kvalloc() is something unknown to me.

--
Uladzislau Rezki
