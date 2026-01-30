Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F70018A6D4;
	Fri, 30 Jan 2026 05:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769750887; cv=none; b=CLcIUEJt1vcJ2gdl7MMN0SkMj+GQH9iLdjYmbvgYoFgdZzmMAlIA/pF6YqTk+NnIw9+Kn0zMbkw3uPBJ1KM0xOQ850yvS8GUHcgVPmpW97lFoDBVw4VdL1Qp/hcM6CHa4tvcXtjQNShJEvsPH2iAWXE8d/Ruf8kH7spWy3S1pLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769750887; c=relaxed/simple;
	bh=UaeaH9whCXVsGM+hEeSu1CpmD+e4VhiT/MTCh3XtfYs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b6tInPMLa2qROr6DjjfHA0oYWTAP2Qk1nh5kXXSz0YPKr8W3rFwIzQAokrE39oHZvreb2o3InBcoGWBgJn+YJMTlt5GDzW+Cd6z0lOKQkOQNsjQfA1nIT0dc0LvTUzKHlKWeBKsXdBKpsUfJK3LWfx7w7IsKzQfCGrtwz/UnLuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rt9U4ltA; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rt9U4ltA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nDtdah5jNTlSI7AM+W+OOBROsO+EQ4xV0CJOOq4Nljc=; b=rt9U4ltAXMIdL+YvAFZ1BezN/D
	eGqwbsfuWHoUwQUlAJU8iXFNa9Dpg928Xa9a3WHfjtoVb9tvRE5YvfPMGvl1yHQAjisVZGJlATzQy
	3A07yPghRUcr29igiABl5Zwb+RVZaOoZpZpIIEGgLWdlsd/wNW/1yS+72fy8wwVh5pyvXtoXWp75q
	cqX1uQa74jNueAfi7ieFlFB5Tuqw8JdiQuvdPySwA9Zy7i80mlZZ+N/gQdcjVY7TNgK4lDYLgnxez
	VOaGyXjF+8097paopP4x6K5y+CYkEq8j3mqQNWuVo2iykrCvaFyTmqcOAAx2swFwOI/+NpbtdzsM8
	dyqzLSjw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vlh32-0000000BiN2-0oFV;
	Fri, 30 Jan 2026 05:28:00 +0000
Date: Fri, 30 Jan 2026 05:27:59 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Li Chen <me@linux.beauty>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
	Jan Kara <jack@suse.com>
Subject: Re: [PATCH 3/3] ocfs2: use READ_ONCE for lockless jinode reads
Message-ID: <aXxBX2Ul-S6nJzG5@casper.infradead.org>
References: <20260130031232.60780-1-me@linux.beauty>
 <20260130031232.60780-4-me@linux.beauty>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260130031232.60780-4-me@linux.beauty>

On Fri, Jan 30, 2026 at 11:12:32AM +0800, Li Chen wrote:
> ocfs2 journal commit callback reads jbd2_inode dirty range fields without
> holding journal->j_list_lock.
> 
> Use READ_ONCE() for these reads to correct the concurrency assumptions.

I don't think this is the right solution to the problem.  If it is,
there needs to be much better argumentation in the commit message.

As I understand it, jbd2_journal_file_inode() initialises jinode,
then adds it to the t_inode_list, then drops the j_list_lock.  So the
actual problem we need to address is that there's no memory barrier
between the store to i_dirty_start and the list_add().  Once that's
added, there's no need for a READ_ONCE here.

Or have I misunderstood the problem?

> Suggested-by: Jan Kara <jack@suse.com>
> Signed-off-by: Li Chen <me@linux.beauty>
> ---
>  fs/ocfs2/journal.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 85239807dec7..7032284cdbd6 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -902,8 +902,11 @@ int ocfs2_journal_alloc(struct ocfs2_super *osb)
>  
>  static int ocfs2_journal_submit_inode_data_buffers(struct jbd2_inode *jinode)
>  {
> -	return filemap_fdatawrite_range(jinode->i_vfs_inode->i_mapping,
> -			jinode->i_dirty_start, jinode->i_dirty_end);
> +	struct address_space *mapping = jinode->i_vfs_inode->i_mapping;
> +	loff_t dirty_start = READ_ONCE(jinode->i_dirty_start);
> +	loff_t dirty_end = READ_ONCE(jinode->i_dirty_end);
> +
> +	return filemap_fdatawrite_range(mapping, dirty_start, dirty_end);
>  }
>  
>  int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
> -- 
> 2.52.0
> 
