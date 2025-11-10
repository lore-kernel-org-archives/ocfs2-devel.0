Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237922773C1
	for <ocfs2-devel@lists.linux.dev>; Mon, 10 Nov 2025 15:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762789992; cv=none; b=FzllzdPy7LW6Otyvmb7yVq5Rj9yd9NoWffN6SNfwkCw9kijMVSsngqbwb9bNkFlMv6jJceXJdh87hrlX6o76//0dMLJwL/m5ognW/mSH+vYSt55oBGEZA6hfiR/1TxVIvWXtPQbZ7YH8wdjkEbxJsD6gzoN1B+gnzpVXC+BeJ6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762789992; c=relaxed/simple;
	bh=gWEKOlfjmTo2SkUq6o41QIsojdM2ynIfxpfkRHpWi0k=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=L6Okd41RX2vGSKhfwCui+wgBHehfC6AEyAC9v1AIUtKauD4VpoUwxRskuWY1RQuhc+OBYAh+5yZkyZ/DNmS+XqLN9uQ69sP1/Gm07QF5ZVcZNPlhbTgE8fygHMZTkq3dSMesGCCK9F70Gb6yW5cxp4lalIKFRYnkMDAuDjfSq5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ncd+VPFp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ncd+VPFp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AEB4C113D0;
	Mon, 10 Nov 2025 15:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762789991;
	bh=gWEKOlfjmTo2SkUq6o41QIsojdM2ynIfxpfkRHpWi0k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ncd+VPFp9/XAMWaZUzRdrEsk+wEgN27atzgosa7QixG5zy+xjmQARWSg5n5wflfcW
	 EGc8IOvxIUST0g460QY9F4K+r2nmFugXTwWfGKDwBUx9NNVivgKpEqXdW3XP2cTvPE
	 5WvS+wpo+rY5oBKk+zuymaHJ9VO1ynKgxITT9PE4=
Date: Mon, 10 Nov 2025 07:53:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev
Subject: Re: arm build error
Message-Id: <20251110075310.249336e414fe5f257e33383d@linux-foundation.org>
In-Reply-To: <1f24e061-b863-404f-8341-d9c2191c2604@linux.alibaba.com>
References: <20251108212340.4c815638a2c231ef45873446@linux-foundation.org>
	<4c791da9-3bea-4cab-a41b-a3e1919e8e1e@linux.alibaba.com>
	<20251109090522.79e51167f4e5eacd5b5e4a28@linux-foundation.org>
	<1f24e061-b863-404f-8341-d9c2191c2604@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 10 Nov 2025 14:20:47 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:

> 
> 
> On 2025/11/10 01:05, Andrew Morton wrote:
> > On Sun, 9 Nov 2025 16:38:10 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
> > 
> >> Hi,
> >>
> >> In which mm tree branch?
> > 
> > mm-nonmm-unstable, which is where I queue ocfs2 changes.
> > 
> > That gets fed into linux-next.
> > 
> 
> I can't directly clone mm.git so I've applied the queued ocfs2 patches
> upon master, and then make allmodconfig && make -j96 in ARM server, but
> don't see this build error.
> BTW, I build with gcc 12.3.

I'm using gcc-15.2.  I get my cross-compilers from
https://www.kernel.org/pub/tools/crosstool/ - they're super easy to
install and run.


> Joseph
> 
> >> On 2025/11/9 13:23, Andrew Morton wrote:
> >>>
> >>> Is anyone else seeing this?  Current mm.git, arm allmodconfig;
> >>>
> >>>
> >>> In file included from ./include/linux/string.h:382,
> >>>                  from ./include/linux/bitmap.h:13,
> >>>                  from ./include/linux/cpumask.h:12,
> >>>                  from ./include/linux/smp.h:13,
> >>>                  from ./include/linux/lockdep.h:14,
> >>>                  from ./include/linux/spinlock.h:63,
> >>>                  from ./include/linux/wait.h:9,
> >>>                  from ./include/linux/wait_bit.h:8,
> >>>                  from ./include/linux/fs.h:7,
> >>>                  from fs/ocfs2/xattr.c:13:
> >>> In function 'fortify_memset_chk',
> >>>     inlined from 'ocfs2_reflink_xattr_header' at fs/ocfs2/xattr.c:6365:5:
> >>> ./include/linux/fortify-string.h:480:25: error: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]

I poked around a bit with struct_group(), no success.  It isn't a thing
I'm familiar with and ocfs2_reflink_xattr_header() is very dense.

I'll take another look later.

> >>>   480 |                         __write_overflow_field(p_size_field, size);
> >>>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >>> cc1: all warnings being treated as errors
> >>>
> >>> Callsite is
> >>>
> >>> 				memset(last, 0,
> >>> 				       sizeof(struct ocfs2_xattr_entry));
> >>>
