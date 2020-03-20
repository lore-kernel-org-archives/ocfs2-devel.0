From: Eric Biggers <ebiggers@kernel.org>
Date: Fri, 20 Mar 2020 11:40:41 -0700
Subject: [Ocfs2-devel] [PATCH v9 20/25] ext4: Convert from readpages to
	readahead
In-Reply-To: <20200320174848.GC4971@bombadil.infradead.org>
References: <20200320142231.2402-1-willy@infradead.org>
	<20200320142231.2402-21-willy@infradead.org>
	<20200320173734.GD851@sol.localdomain>
	<20200320174848.GC4971@bombadil.infradead.org>
Message-ID: <20200320184041.GG851@sol.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 20, 2020 at 10:48:48AM -0700, Matthew Wilcox wrote:
> On Fri, Mar 20, 2020 at 10:37:34AM -0700, Eric Biggers wrote:
> > On Fri, Mar 20, 2020 at 07:22:26AM -0700, Matthew Wilcox wrote:
> > > From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> > > 
> > > Use the new readahead operation in ext4
> > > 
> > > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > > Reviewed-by: William Kucharski <william.kucharski@oracle.com>
> > > ---
> > >  fs/ext4/ext4.h     |  3 +--
> > >  fs/ext4/inode.c    | 21 +++++++++------------
> > >  fs/ext4/readpage.c | 22 ++++++++--------------
> > >  3 files changed, 18 insertions(+), 28 deletions(-)
> > > 
> > 
> > Reviewed-by: Eric Biggers <ebiggers@google.com>
> > 
> > > +		if (rac) {
> > > +			page = readahead_page(rac);
> > >  			prefetchw(&page->flags);
> > > -			list_del(&page->lru);
> > > -			if (add_to_page_cache_lru(page, mapping, page->index,
> > > -				  readahead_gfp_mask(mapping)))
> > > -				goto next_page;
> > >  		}
> > 
> > Maybe the prefetchw(&page->flags) should be included in readahead_page()?
> > Most of the callers do it.
> 
> I did notice that a lot of callers do that.  I wonder whether it (still)
> helps or whether it's just cargo-cult programming.  It can't possibly
> have helped before because we did list_del(&page->lru) as the very next
> instruction after prefetchw(), and they're in the same cacheline.  It'd
> be interesting to take it out and see what happens to performance.

Yeah, it does look like the list_del() made the prefetchw() useless, so it
should just be removed.  The prefetchw() dates all the way back to
mpage_readpages() being added in 2002, but even then the list_del() was
immediately afterwards, and 'flags' and 'lru' were in the same cache line in
'struct page' even then (assuming at least a 32-byte cache line size), so...

- Eric
