Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3BA256C71
	for <ocfs2-devel@lists.linux.dev>; Sun, 31 Aug 2025 19:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756667700; cv=none; b=mHpqGS/mdyk4dLVJVCqxLXMR+D0vQh0Op/V94Q2qtLNzRGpHl3h/0Mi01rvDeFB/9Hdid+v0uW65SUN66P0Bc2mI3VG+og1PxBdUHM2pFro4U9FU5rbIsDYlS2lI+vaioO3piLx9ohgPhM3wypk7lzLlKPJoBxmwHoPuZuDVbto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756667700; c=relaxed/simple;
	bh=OXfb6J9qcJTezaN5JxIS9POkQjHS4bhfEaJYd9Kq1G0=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=OcBdW5oS/IrTxCEKAkYgBsIHCl7I8f3h5IZG68n4gZRIabw3eVV8L9N+DWhpOwwQabU6FPbhDHR/u0Du0vy+K4R3rHZod3O9tdFihbWAlTbrwxiUcupiyIVLgU4smK4Lw3W37aQu8YMTKebW8Xb72eSzgHAh+IZxiofq31NsD5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q9riPGfN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q9riPGfN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E6DC4CEED;
	Sun, 31 Aug 2025 19:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756667699;
	bh=OXfb6J9qcJTezaN5JxIS9POkQjHS4bhfEaJYd9Kq1G0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=q9riPGfNZz5KSkEgKFHfJhEpN/F0HxFiQrg7hG7kmu9/qAyiQ1nY2+iR6llZGD+vv
	 sIHCqFX8i6gnMzm+Z7ZXgDwytu2NTRfMUi5mxcuxce0ZHVI4+OPkdcbcwYGAGIk2nY
	 6G7WI7aQFjXpK+XYSEOKSD+HlgJlXmxBfZra79E0=
Date: Sun, 31 Aug 2025 12:14:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Tinguely <mark.tinguely@oracle.com>
Cc: "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>, Joseph Qi
 <joseph.qi@linux.alibaba.com>, Heming Zhao <heming.zhao@suse.com>,
 syzbot+541dcc6ee768f77103e7@syzkaller.appspotmail.com
Subject: Re: [v4 PATCH] ocfs2: fix recursive semaphore deadlock in fiemap
 call
Message-Id: <20250831121458.6f195657f94c35005b5bc38d@linux-foundation.org>
In-Reply-To: <61d1a62b-2631-4f12-81e2-cd689914360b@oracle.com>
References: <20250829150620.22710-1-mark.tinguely@oracle.com>
	<61d1a62b-2631-4f12-81e2-cd689914360b@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 29 Aug 2025 10:18:15 -0500 Mark Tinguely <mark.tinguely@oracle.com> wrote:

> syzbot detected a OCFS2 hang due to a recursive semaphore on a
> FS_IOC_FIEMAP of the extent list on a specially crafted mmap file.
> 
> context_switch kernel/sched/core.c:5357 [inline]
> 
> ...
>
> ocfs2_fiemap() takes a read lock of the ip_alloc_sem semaphore (since
> v2.6.22-527-g7307de80510a) and calls fiemap_fill_next_extent()
> to read the extent list of this running mmap executable.
> The user supplied buffer to hold the fiemap information page faults
> calling ocfs2_page_mkwrite() which will take a write lock (since
> v2.6.27-38-g00dc417fa3e7) of the same semaphore. This recursive
> semaphore will hold filesystem locks and causes a hang of the
> fileystem.
> 
> The ip_alloc_sem protects the inode extent list and size.
> Release the read semphore before calling fiemap_fill_next_extent()
> in ocfs2_fiemap() and ocfs2_fiemap_inline(). This does an
> unnecessary semaphore lock/unlock on the last extent but simplifies
> the error path.
> 
> Reported-by: syzbot+541dcc6ee768f77103e7@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=541dcc6ee768f77103e7

So I'm thinking

Fixes: 00dc417fa3e7 ("ocfs2: fiemap support")
cc:stable

yes?
