From: Christoph Hellwig <hch@infradead.org>
Date: Wed, 26 Feb 2020 09:07:28 -0800
Subject: [Ocfs2-devel] [PATCH v8 25/25] iomap: Convert from readpages to
	readahead
In-Reply-To: <20200226170425.GD8045@magnolia>
References: <20200225214838.30017-1-willy@infradead.org>
	<20200225214838.30017-26-willy@infradead.org>
	<20200226170425.GD8045@magnolia>
Message-ID: <20200226170728.GD22837@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On Wed, Feb 26, 2020 at 09:04:25AM -0800, Darrick J. Wong wrote:
> > @@ -456,15 +435,8 @@ iomap_readpages(struct address_space *mapping, struct list_head *pages,
> >  			unlock_page(ctx.cur_page);
> >  		put_page(ctx.cur_page);
> >  	}
> > -
> > -	/*
> > -	 * Check that we didn't lose a page due to the arcance calling
> > -	 * conventions..
> > -	 */
> > -	WARN_ON_ONCE(!ret && !list_empty(ctx.pages));
> > -	return ret;
> 
> After all the discussion about "if we still have ctx.cur_page we should
> just stop" in v7, I'm surprised that this patch now doesn't say much of
> anything, not even a WARN_ON()?

The code quoted above puts the cur_page reference.  By dropping the
odd refactoring patch there is no need to check for cur_page being
left as a special condition as that still is the normal loop exit
state and properly handled, just as in the original iomap code.
