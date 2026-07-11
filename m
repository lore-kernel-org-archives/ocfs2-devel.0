Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3509373463;
	Sat, 11 Jul 2026 00:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783729591; cv=none; b=jneLU2KQj2N+HyFeFlUXN/9vOmiNh+yjBd8vkoN4AfHXELf7hjEa2ughF0YBVQ9d+XUQnOwoja4QcoGRYgRfZxGStUOd0SzrdqxJLzgkJZ2J8ggTMRd9UYOIbCpMTEMnM5bBJl5Ifat0c5/UZCOIc9QbkggOFbNsr2T1aiClYyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783729591; c=relaxed/simple;
	bh=ZK2nKAKrsvfe6Pr7JaqwswG03BH+PQKvUIk34Sf3ibs=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=pjaQqZEdd2mldmONordWusBxoWYtCx4Wh8nqIHsT/8weJ2TNFTFPy2Pw3mFKciGPYJb50TJjdlHE3uJ5i5ovOuUgsZCdzvAd4UXfUgNf8weR0Gmz8Kq0afdJqmoPK5SXgFnvqmcTm0BDgNTy4UREAtvEQhSzvMOHLWI6v+D/Z7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mtfwCGnk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mtfwCGnk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A081F000E9;
	Sat, 11 Jul 2026 00:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783729589;
	bh=banCqW2lPppu31e6axxVhHolJxz+6ZJTgW+V9fYIQQs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=mtfwCGnkmCz+YxjksZyDfYrXKZO5IObFx+LIwi9XZ0IGrJj7F1TTmJowoIZALn2Xy
	 bp2A6vTkJPdrBC/b+PY+qZH9oCEKc6TWD7ep0jUFAUqnikedXsD3rz4fz3WSkooI63
	 wP3DA+GkzDhCrqsfdcHYtfGJRksRQR73udnEV88s=
Date: Fri, 10 Jul 2026 17:26:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Heming Zhao <heming.zhao@suse.com>, Mark Fasheh <mark@fasheh.com>, Joel
 Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ocfs2: cluster: use GFP_NOFS for heartbeat bio
 allocation
Message-Id: <20260710172629.46dcd01fc4132e876b92d2f0@linux-foundation.org>
In-Reply-To: <20260710071756.3586797-1-joseph.qi@linux.alibaba.com>
References: <20260710071756.3586797-1-joseph.qi@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 10 Jul 2026 15:17:55 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:

> o2hb_setup_one_bio() allocates the heartbeat bio with GFP_ATOMIC. The
> disk heartbeat runs in the o2hb kernel thread (o2hb_do_disk_heartbeat),
> which is process context and can sleep, so there is no atomicity
> requirement here.
> 
> GFP_ATOMIC lacks __GFP_DIRECT_RECLAIM, so the allocation is not served
> from the fs_bio_set mempool reserve and can return NULL under memory
> pressure. A failed heartbeat allocation aborts the heartbeat and can
> lead to the local node being fenced, which is exactly what the old
> comment worried about.
> 
> Use GFP_NOFS instead. It keeps __GFP_DIRECT_RECLAIM so the allocation is
> backed by the fs_bio_set mempool and cannot fail, while avoiding
> recursion back into the filesystem during heartbeat I/O. As the
> allocation can no longer fail, drop the dead ERR_PTR(-ENOMEM) path in
> o2hb_setup_one_bio() and the now-redundant IS_ERR() handling in its
> callers.

fyi, AI review asked a thing:
	https://sashiko.dev/#/patchset/20260710071756.3586797-1-joseph.qi@linux.alibaba.com
