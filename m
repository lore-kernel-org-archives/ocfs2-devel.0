Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4563CD8D3
	for <ocfs2-devel@lists.linux.dev>; Tue, 26 May 2026 09:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779788156; cv=none; b=uFR1BFc2UGGTgBN2tDLbDKSO548JQUvaX8vPpuxYPtLqz0IdxDp9yO0OQZPO+bvEuos2WnzeJuHbP7lpuMUfHsmbxqA+BbB/kKYGnBzYVhtaK8ynSxBQsZfbRRl7LMaPd05P8g32qQGvMAIvAkrpuppX6A+jUoPwXWe3ZbBtIF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779788156; c=relaxed/simple;
	bh=sjU7RHyInlH9mxFug2LKz+GK48Ojh7vR1sjgQ2TiRGM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NtDAhr0et50KorfErspu91sdhMlhMo9R7jmjw0AzIGyNGVota2EtmDkfHZhaeB0l2rsanjdIyBMi9VpSXu0SJvHmA2nzq6QNJ1qxpuSDqrNAJ5SnCzrO/63WmTFHRKOXrRQKCUokbSGvw3YY7raLo/GByCvpVTH47GyxHtsv9G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WbgqCW7W; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WbgqCW7W"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-44b330c5cc6so7966625f8f.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 26 May 2026 02:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779788154; x=1780392954; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2bHfAVXmh3q3FWdhM0EExqsSxnDVRJkOcr0NBrLZ8n4=;
        b=WbgqCW7W0QOACg+VH8+skZCu7gIw+6bxxMHfNYACBgktBN6dI9oPELm0Jay8c6fVfq
         3q2xOb0tO1mUfbmkUaED4/vSAJaYmEgJ2NnJMfdFlDOy+wBlcmBaEXSQKnCuWtVC7tOO
         BvjpW1cyWFfZ2phOd0GT62s0AApZQ6KTwl+XDh3IQ79uENUNCakw3N1Eie0keKLGtM/1
         nMHANc109aeHtHfgKBKemX/514Z/zrvUXNilqmI/kJyFSToleUuJxyg1neuijChD0R2N
         XqYBCcqY8eJtQa237zLgLl1CEpheXBphigCSOc5HNdAtD1RLwPfWj+V4y4CodS/ccyun
         HAfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779788154; x=1780392954;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2bHfAVXmh3q3FWdhM0EExqsSxnDVRJkOcr0NBrLZ8n4=;
        b=KyR3lED81VjKdiBrweaQHBJ4SotN1rXlRrLii0thPzhVBtSRtmQi/47vU0OXeiB50D
         e+hwilZ7j2yrUoJauBGjp9uvIRfIpb8+nh1TbCaBMg5Zbm8PYmUiPqOOMqFi1zjP5adk
         Di3K9+siHpXgvlRVibqZ/IpQ+MoByRL0kwRYbaDBc+DyqInqh1LXCgsWuFpStF+IOceT
         /26iQPyIsVUn4kExHj2Y+i9TiLTU1Q6uqUOKfMTQlKgvBYH6oeq+G8oGEpdrDXHLZhL/
         nvjWOycVzVqGplDf600SlsSP3+SyLlZSl9P9AGZd+8IRv30fyL89XFK2JOvH6Tj4OjxZ
         vcfA==
X-Forwarded-Encrypted: i=1; AFNElJ+lq1CWxLvgpdeNqw+OBJc4AfSseYIoBTC7cGYgyVuIeni8RJuX9hHyOzggajyPidWfHuhxqDWQRqIxmw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzJ0BzIqP+nkvetKPKbRyiFkPudOLysYTzoi2srthqD/4LFUICj
	jCIGdBl0JNW6bo9sI3Ghj1Z+1WKroiM1Vgxwl+2PugW6gxQM6feFZXYX
X-Gm-Gg: Acq92OFX47iYnTMmcTlrhvlHehd3yXQcFYPfAsjZMwMq8ebjTl82R5CV/JFQGBNjUxt
	1IUF4n5Q7yF9Xh041VRydwowILc1PxgD9leKIYOg84i+xttFTwv06O0nR4+fZqvUyhe6CZcxV0G
	EL5xjKj98ShWE9PStQULhn45c5NHMBGtDD5CFijfo1OxGSOVPgUIGtNhbwxWAtiNsR0xCVq4k5N
	bPghIZx4BlXknVcGzbD/E9qAX9qhkSeY9BJ9kRJg8TvjmT9uUkDtYI+jLqhNCus9k37/dQaiwoy
	BI+5O5o60vGP2OAboHLKKSFFd5QVv2B6ui12ok8fYb7j32gob6Rk9hNPZgC/I6Z9ktTLed7VC03
	FbS9/H/vnd92Y1ONCWhXbZF5CaZlMyNr8Sm34J75L9U1qRkcvb6CldZXMzDDLihAdUaxAyCKB3m
	GjN3ZqXe7vFRns6ET8aw/5C09dHIO2k+rdl2oTLblxLjFlL74wlD4EEXxeODwSelxyPanq9+uFi
	4s=
X-Received: by 2002:a05:6000:4b07:b0:43c:cf25:f29a with SMTP id ffacd0b85a97d-45eb3689049mr28173297f8f.8.1779788153530;
        Tue, 26 May 2026 02:35:53 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d64eb1sm38023448f8f.32.2026.05.26.02.35.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 02:35:53 -0700 (PDT)
Date: Tue, 26 May 2026 10:35:51 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker
 <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, Ryusuke
 Konishi <konishi.ryusuke@gmail.com>, Viacheslav Dubeyko
 <slava@dubeyko.com>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker
 <anna@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, Jeff Layton
 <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Olga Kornievskaia
 <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey
 <tom@talpey.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, Theodore
 Ts'o <tytso@mit.edu>, Miklos Szeredi <miklos@szeredi.hu>, Andreas Hindborg
 <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, Kees Cook
 <kees@kernel.org>, "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org,
 linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 linux-ext4@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 10/17] jbd2: replace __get_free_pages() with kmalloc()
Message-ID: <20260526103551.0a05ec07@pumpkin>
In-Reply-To: <ahSNFmwAA17pMy6o@casper.infradead.org>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
	<20260523-b4-fs-v1-10-275e36a83f0e@kernel.org>
	<2omm5gmnv2khshoxkrag5rusd3qzrsqyjgsef2syxgryrtg6vq@ao7oabqwebgo>
	<20260525182134.04045610@pumpkin>
	<ahSNFmwAA17pMy6o@casper.infradead.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 25 May 2026 18:55:34 +0100
Matthew Wilcox <willy@infradead.org> wrote:

> On Mon, May 25, 2026 at 06:21:34PM +0100, David Laight wrote:
> > Would kvalloc() be more appropriate here?  
> 
> no
> 
> > Does __get_free_pages() return physically contiguous memory?  
> 
> yes
> 

Thankyou
