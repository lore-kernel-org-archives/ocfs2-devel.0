Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF00B37F33A;
	Fri,  4 Sep 2026 04:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788496581; cv=none; b=jxVKaEua48C7f31F8q7xVAlA3wHTWV5Jxb8IxRI8wweKowGO2z7bKfxxcgQyCqNc8qro42v0g5ZdVifwqmm5gl90sMRipFhLTuqsow6V4V+mDZS9x3M9/+KE2UNv1srw30aqpckqyANGAxoFey/TIATxx+oOASeLiH13v2yy+ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788496581; c=relaxed/simple;
	bh=7u56Bs18xcz+tspxJRrtQbClywvfOjaWXNoQTlymS6A=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=n7JahVUpTH6T3MHH1J1cxesqMWz12bTRN6triNTTdK6FxqI8/uC4N42f/Q1oWUO7oR2ICCSE4H5fdnGbPEv8lg49edCVANfY5aVm/wRbq0OinL9GJFMJQso7dlkWgFvL2cZskXFLEGTqjGQoCwfFzW2/EB60jVQMeCOBmHRySvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hVI/y/7Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hVI/y/7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A68B1F00A3D;
	Fri,  4 Sep 2026 04:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788496579;
	bh=t8jL3Ea67wD72nWlPefWAHml8QZhm5cpjZCb1g2Qihc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=hVI/y/7QjezkHTuTtVPxoGBMlDqibdOXp4nKpGhukaU4T086fFcqYEZO6Y3pnvz9E
	 eiKULK8ny0SG5CS5Pu/4+WYPG3eV9EbO5On6bmIXIH11hcvq9rZNt3d8Qs/yJkjTWD
	 6Pzi6En7jGcW+nGjDQJOiKY3iNyUlF/g31jMbJx0=
Date: Thu, 3 Sep 2026 21:36:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Heming Zhao <heming.zhao@suse.com>, Mark Fasheh <mark@fasheh.com>, Joel
 Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ocfs2: make ocfs2_calc_xattr_init() return void
Message-Id: <20260903213618.04d90c1cf88323b0dae59008@linux-foundation.org>
In-Reply-To: <20260904023751.3703334-1-joseph.qi@linux.alibaba.com>
References: <20260904023751.3703334-1-joseph.qi@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  4 Sep 2026 10:37:51 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:

> ocfs2_calc_xattr_init() used to read the default ACL off the parent
> inode itself, so it could return an error from ocfs2_xattr_get_nolock().
> Commit bd7c05fb4a47 ("ocfs2: fix circular locking dependency in
> ocfs2_init_acl()") moved that lookup before the transaction starts and
> deleted the error path, but left the now vestigial 'int ret = 0'
> declaration and both 'return ret' statements behind, along with an
> unreachable error branch in ocfs2_mknod().
> 
> Drop the leftover variable and convert the return type to void, so the
> callee states that it always succeeds and the caller no longer carries
> a check that can never trigger.
> 
> No functional change.

Thanks.

> Fixes: bd7c05fb4a47 ("ocfs2: fix circular locking dependency in ocfs2_init_acl()")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202609040247.8B3lmoqX-lkp@intel.com/

Gee, that's a bit picky, isn't it?

