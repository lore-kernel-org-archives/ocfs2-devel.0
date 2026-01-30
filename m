Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CE534FF68;
	Fri, 30 Jan 2026 16:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769790999; cv=none; b=an2sCK7x+IFus7GfVuVAJywH4gI81HQaBHfbn8nT3lnCvwxEtEqupA7Gfv3XkK/9Djb0woJaaKrEe8DoOF4ee5+LPycZg6FSDsQYf6ib4X+2TrAZ2Kcd2PjIcHV1BJ7RKPzTd4AyUbJc0mRDPw3CvApZWjsa5q7KvkKD2B/Sl5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769790999; c=relaxed/simple;
	bh=i3uZFPslr0h4UT6uROKb0K8Y2YLd+1AHFWdlU5hbBEI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ufLNU/FoxReI5GPhWX1SkJxVCbLxULReopSlYmlY2s95yVwSdr5lgwW+PMKTGl0W+OHywjVqWdJEix6pQcw6lIlrLL/WAQjeNyUpyphtCyn2clCjrdlo4yVVQvwIZiYQldOX6Rt5VFTLY7qmsEIplU8WYHnjaflsoGZLB0owiqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qQC89bHj; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qQC89bHj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fuu9tvm+EnSe+SQjtKHZkoQpg0Rk0IYtAOxypVQ7pHs=; b=qQC89bHjRG2rRaQRhDfnOai4D5
	4Q3cvM3mFHCRwv3jo3sUQf1ISfjxzALuHDPHHog5ETnQH2aNYqk32gWkPs59tdr7NNADIKmNLwZwY
	AkHgAAkDX0uSWOH3GDKZMJVGMf+x2hoCW7ZxjMK0pmGAF2bd0R3UMT/xpx79+7YDwsbYLzHCSgn93
	C0toaNUaRDzLWe9S153vhlY3wwGKOHpn4iwZPjh90GTKDirTOwk/iuULpDx8uUGYX+cFg/wZhKchl
	izyQokJiFveGoOSFKpsW5xYr3wOOXyf64zAwAmvMAFOHy6l/mI638Ae97piSJthrkalmZAZphgKDM
	bCHA/PWA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vlrTw-0000000CSLF-3xAk;
	Fri, 30 Jan 2026 16:36:28 +0000
Date: Fri, 30 Jan 2026 16:36:28 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Li Chen <me@linux.beauty>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel <ocfs2-devel@lists.linux.dev>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Jan Kara <jack@suse.com>
Subject: Re: [PATCH 3/3] ocfs2: use READ_ONCE for lockless jinode reads
Message-ID: <aXzeDE5P_lxiXfPB@casper.infradead.org>
References: <20260130031232.60780-1-me@linux.beauty>
 <20260130031232.60780-4-me@linux.beauty>
 <aXxBX2Ul-S6nJzG5@casper.infradead.org>
 <19c0edeadad.6adfc20c802629.8728440093470268039@linux.beauty>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19c0edeadad.6adfc20c802629.8728440093470268039@linux.beauty>

On Fri, Jan 30, 2026 at 08:26:40PM +0800, Li Chen wrote:
> Hi Matthew,
> 
>  > On Fri, Jan 30, 2026 at 11:12:32AM +0800, Li Chen wrote:
>  > > ocfs2 journal commit callback reads jbd2_inode dirty range fields without
>  > > holding journal->j_list_lock.
>  > > 
>  > > Use READ_ONCE() for these reads to correct the concurrency assumptions.
>  > 
>  > I don't think this is the right solution to the problem.  If it is,
>  > there needs to be much better argumentation in the commit message.
>  > 
>  > As I understand it, jbd2_journal_file_inode() initialises jinode,
>  > then adds it to the t_inode_list, then drops the j_list_lock.  So the
>  > actual problem we need to address is that there's no memory barrier
>  > between the store to i_dirty_start and the list_add().  Once that's
>  > added, there's no need for a READ_ONCE here.
>  > 
>  > Or have I misunderstood the problem?
> 
> Thanks for the review.
> 
> My understanding of your point is that you're worried about a missing
> "publish" ordering in jbd2_journal_file_inode(): we store
> jinode->i_dirty_start/end and then list_add() the jinode to
> t_inode_list, and a core which observes the list entry might miss the prior
> i_dirty_* stores. Is that the issue you had in mind?

I think that's the only issue that exists ...

> If so, for the normal commit path where the list is walked under
> journal->j_list_lock (e.g. journal_submit_data_buffers() in
> fs/jbd2/commit.c), spin_lock()/spin_unlock() should already provide the
> necessary ordering, since both the i_dirty_* updates and the list_add()
> happen inside the same critical section.

I don't think that's true.  I think what you're asserting is that:

	int *pi;
	int **ppi;

	spin_lock(&lock);
	*pi = 1;
	*ppi = pi;
	spin_unlock(&lock);

that the store to *pi must be observed before the store to *ppi, and
that's not true for a reader which doesn't read the value of lock.
The store to *ppi needs a store barrier before it.

> The ocfs2 case I was aiming at is different: the filesystem callback is
> invoked after unlocking journal->j_list_lock and may sleep, so it can't hold
> j_list_lock but it still reads jinode->i_dirty_start/end while other
> threads update these fields under the lock. Adding a barrier between the
> stores and list_add() would not address that concurrent update window.

I don't think that race exists.  If it does exist, the READ_ONCE will
not help (on 32 bit platforms) because it's a 64-bit quantity and 32-bit
platforms do not, in general, have a way to do an atomic 64-bit load
(look at the implementation of i_size_read() for the gyrations we go
through to assure a non-torn read of that value).

> "ocfs2 reads jinode->i_dirty_start/end without journal->j_list_lock
> (callback may sleep); these fields are updated under j_list_lock in jbd2.
> Use READ_ONCE() so the callback takes a single snapshot via actual loads
> from the variable (i.e. don't let the compiler reuse a value kept in a register
> or fold multiple reads)."

I think the prevention of this race occurs at a higher level than
"it's updated under a lock".  That is, jbd2_journal_file_inode()
is never called for a jinode which is currently being operated on by
j_submit_inode_data_buffers().  Now, I'm not an expert on the jbd code,
so I may be wrong here.
