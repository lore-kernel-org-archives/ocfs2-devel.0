Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368681EB3D;
	Wed, 20 Nov 2024 15:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732116180; cv=none; b=I6iyiqfkyFvHGA6d6A8IgY0mRuw1Due0yNKaWUNiAqlUNXHEmHLpzw/PVNqzAfbVmMMqRAk4/R6NWnWtk1l4yJbGCrmNYVThQ2lbQIpNXfshcStN+N57eMr6p7fhFWJz5xwYl6MUVm3v69mVIPxCevD+hMlzUruXa6cFjLnmgGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732116180; c=relaxed/simple;
	bh=7HSMTOSLIuP9rca81Zdn2qb0WbYseuUIWKIfSE9hWFY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=lWy124JiCXL+gDiWmXMjK2hNIzg9FqkFgDPGeQufV2LZQDZxJT0R4P6Axw3tqN7OqVsY90qZ4sUCXjIc1x/wQJZ3rhgrQUsf0kc0QTFQdSEio+co5F9u9fWiWPcwSqjF5Psn/kCyGwGN2j+XGF44QHcSPACkEh9a6uf6JWsAvE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=bukzJIPG; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="bukzJIPG"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 2653A403E5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1732116177; bh=F7TGxCuWmnHhM60mB3zccDkNdB0MqcFNwLzQHlKYkx4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=bukzJIPGKY14sI9P5nuItCcL1jwwnr4Ugrfz79nRbNqOGwE3eIiaYaeD3WembPh3L
	 01pynC+fxwfeBA1c0R03AAozh6DNOxvX7SBjE+neih0hplCmIZGKfoLuYFsHlmEbJq
	 gKws+n3ikuBvCHlGAu2rXvVJ971kWZIjLJ/gh08k8WGw1OHQ1Qx5shJY+LjdUOfIaD
	 Vu6+hkGX+VwKTxSrjIawWawFaNUOlclFJCqDRV9RGTFYRLn1dmMKSr/Ne8bigRuzK1
	 ZEXjF5YeiR8tUNmwDHsXoMiYytGf1BIGyn95jhV1vXAe8iKCstJmrwIrAY7wRqfeMN
	 Pcf3tWECV1KAg==
Received: from localhost (unknown [IPv6:2601:280:5e00:625::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 2653A403E5;
	Wed, 20 Nov 2024 15:22:57 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Christian Brauner <brauner@kernel.org>, Randy Dunlap
 <rdunlap@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, Ian Kent <raven@themaw.net>,
 autofs@vger.kernel.org, Alexander Aring <aahringo@redhat.com>, David
 Teigland <teigland@redhat.com>, gfs2@lists.linux.dev, Eric Biggers
 <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>,
 fsverity@lists.linux.dev, Mark Fasheh <mark@fasheh.com>, Joel Becker
 <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 ocfs2-devel@lists.linux.dev
Subject: Re: [PATCH] Documentation: filesystems: update filename extensions
In-Reply-To: <20241120-packen-popsong-7d5d34c0574c@brauner>
References: <20241120055246.158368-1-rdunlap@infradead.org>
 <20241120-packen-popsong-7d5d34c0574c@brauner>
Date: Wed, 20 Nov 2024 08:22:56 -0700
Message-ID: <87a5dudj5b.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Christian Brauner <brauner@kernel.org> writes:

>
> Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
>
> @Jon, should I take this through the vfs tree?

Up to you.  It looks like I'll definitely have another pull request
during this merge window, so I can get it Linusward too.  Just lemme
know what your preference is.

jon
