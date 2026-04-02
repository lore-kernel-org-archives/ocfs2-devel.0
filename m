Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3C81A6823;
	Thu,  2 Apr 2026 04:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775103422; cv=none; b=NG0lyS4J3mLQM5nTQEBjxtGUXkndAuaRnIttSEev/28xeim+MJz4aqkJzCSeuKkwLXeSgv2AoqwjnkbHi4SoNV8LRd2gMVYbhWSeZ/TT+vpyxDX7SNk0ysDHUO4dUq6FjbHrAP/mgO8cwq3XMzGe1wCBM7kOYIjIj1oPTbYFtgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775103422; c=relaxed/simple;
	bh=8HBCXdsAF42dQTv39Jzy5BfnDmivqMtwpj+JNGM3Etc=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Jm8qWg7KgyiS0yHzFPzRSQRqg/8rGeMVqRK8RzQlyGBE0JqTsfwkZKJNGJx7nIARhGRFOZNJxQSf/817g29M3a2iJuCfIdkU5wopkRirXpoKJHdvnuyEim6mLW7lE0unba1sefZ7W9EAbXpQFEmZN+evL/4LadSCyZJ5W8OXyvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FnUc5NJx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FnUc5NJx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60249C19423;
	Thu,  2 Apr 2026 04:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775103421;
	bh=8HBCXdsAF42dQTv39Jzy5BfnDmivqMtwpj+JNGM3Etc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FnUc5NJxa2RBOCSqB7aaTCcW5TwafgKOg7q+HEdWfNGOBHir3l4LcDYCDv9jzUDcE
	 gvQ5O2BWg08c+IMsuxrypuo/IgG+rpOdXeEk4WQo61d4zRyaoSMePA0k4ZrlKNvHHO
	 ZryNUqktXvOTYMGB1Y8LMexnOoGoaYaYORWfhkXs=
Date: Wed, 1 Apr 2026 21:17:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: tejas bharambe <tejas.bharambe@outlook.com>, "mark@fasheh.com"
 <mark@fasheh.com>, "jlbec@evilplan.org" <jlbec@evilplan.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com"
 <syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com>,
 "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>
Subject: Re: [PATCH v3] ocfs2: fix use-after-free in ocfs2_fault() when
 VM_FAULT_RETRY
Message-Id: <20260401211700.0749e640e5f7c67a062c2deb@linux-foundation.org>
In-Reply-To: <183fdc2a-b6f9-4ffb-8d12-a5ead1b0d207@linux.alibaba.com>
References: <JH0PR06MB6632E1E416539AAF508ECAB28951A@JH0PR06MB6632.apcprd06.prod.outlook.com>
	<183fdc2a-b6f9-4ffb-8d12-a5ead1b0d207@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 2 Apr 2026 11:47:12 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:

> 
> 
> On 4/2/26 11:08 AM, tejas bharambe wrote:
> > filemap_fault() may drop the mmap_lock before returning VM_FAULT_RETRY,
> > as documented in mm/filemap.c:
> > 
> >   "If our return value has VM_FAULT_RETRY set, it's because the mmap_lock
> >   may be dropped before doing I/O or by lock_folio_maybe_drop_mmap()."
> > 
> > When this happens, a concurrent munmap() can call remove_vma() and free
> > the vm_area_struct via RCU. The saved 'vma' pointer in ocfs2_fault() then
> > becomes a dangling pointer, and the subsequent trace_ocfs2_fault() call
> > dereferences it -- a use-after-free.
> > 
> > Fix this by saving the inode reference before calling filemap_fault(),
> > and removing vma from the trace event. The inode remains valid across
> > the lock drop since the file is still open, so the trace can fire in
> > all cases without dereferencing the potentially freed vma.
> > 
> > Reported-by: syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=a49010a0e8fcdeea075f
> > Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> > Signed-off-by: Tejas Bharambe <tejas.bharambe@outlook.com>
> 
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Cool.

I think a cc:stable is needed?

The code looks like it dates back to 2011, so Fixes: isn't needed.


A process thing: as far as I know, the -stable maintainers will
automatically gather any patch which has a Fixes:.  But they've been
asked not to do that for MM patches, so there's a risk they'll see an
ocfs2 patch is from my tree and not backport it.  I like to add
a cc:stable just to be sure.

Also, because this one doesn't have a Fixes: it might not be grabbed by
the -stable trees.  An explicit cc:stable again removes doubt.

But that's just my late night waffling which can be ignored.  For every
single patch I always consider cc:stable so other people don't have to ;)

