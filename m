Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13ED3883F
	for <ocfs2-devel@lists.linux.dev>; Sun,  9 Nov 2025 17:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762707924; cv=none; b=D2CBXCRqqrv+O6J2CDzeIJQsBTSupbBJVhwWjwDoMTD1pMMdjWLgk1XfNgrNedbAyTPwWCcpNw35C2hm3WqV/LJsbaoqY+qynRJcXpAqj54ChoUQEPtM2RO9F6Kaka3rPrkaLSTvsvWz3b4ceWUq1Dr6ssMNIFQn79zgCzge+b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762707924; c=relaxed/simple;
	bh=+axsRIbxy8UW/XMkMlABd+HsbzW6MNeAVM+UEShDouI=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=C3G06HY5wo1S6EyFSCzfHx1SOS7/ViECYMdD7S3lH8OMCUGkHcXWdw1kzYlJAJ0u3oZcj1ZOhgg5QgvPn3lgB+pKvBmM6ip0rH/m+CmQPJbebO/u67lpUrd1kE+gWQSJhMvY0wYF7Jr0H0p/NoDvAakyx7A6uUj1enaQMUCh+is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ebe0YEOk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ebe0YEOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E41C19421;
	Sun,  9 Nov 2025 17:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762707923;
	bh=+axsRIbxy8UW/XMkMlABd+HsbzW6MNeAVM+UEShDouI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Ebe0YEOks1D7LKgt6mDXSBAZSyiW3Gz9rpHXRoJBsUmJzzdxq1GKqhz00Lw7u/0Rl
	 v6VpMUFX1URJARVIW9qBUjSan6w1x4i4Zae0JcELQKQ+aoWpkTxZk/2bmyv6L2K1Lo
	 a8wQQ34Q3GJNxtw0nd/e96PE6R0yImXK6dunRJjE=
Date: Sun, 9 Nov 2025 09:05:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev
Subject: Re: arm build error
Message-Id: <20251109090522.79e51167f4e5eacd5b5e4a28@linux-foundation.org>
In-Reply-To: <4c791da9-3bea-4cab-a41b-a3e1919e8e1e@linux.alibaba.com>
References: <20251108212340.4c815638a2c231ef45873446@linux-foundation.org>
	<4c791da9-3bea-4cab-a41b-a3e1919e8e1e@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 9 Nov 2025 16:38:10 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:

> Hi,
> 
> In which mm tree branch?

mm-nonmm-unstable, which is where I queue ocfs2 changes.

That gets fed into linux-next.

> On 2025/11/9 13:23, Andrew Morton wrote:
> > 
> > Is anyone else seeing this?  Current mm.git, arm allmodconfig;
> > 
> > 
> > In file included from ./include/linux/string.h:382,
> >                  from ./include/linux/bitmap.h:13,
> >                  from ./include/linux/cpumask.h:12,
> >                  from ./include/linux/smp.h:13,
> >                  from ./include/linux/lockdep.h:14,
> >                  from ./include/linux/spinlock.h:63,
> >                  from ./include/linux/wait.h:9,
> >                  from ./include/linux/wait_bit.h:8,
> >                  from ./include/linux/fs.h:7,
> >                  from fs/ocfs2/xattr.c:13:
> > In function 'fortify_memset_chk',
> >     inlined from 'ocfs2_reflink_xattr_header' at fs/ocfs2/xattr.c:6365:5:
> > ./include/linux/fortify-string.h:480:25: error: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
> >   480 |                         __write_overflow_field(p_size_field, size);
> >       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > cc1: all warnings being treated as errors
> > 
> > Callsite is
> > 
> > 				memset(last, 0,
> > 				       sizeof(struct ocfs2_xattr_entry));
> > 
