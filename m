From: Matthew Wilcox <willy@infradead.org>
Date: Tue, 18 Feb 2020 14:52:35 -0800
Subject: [Ocfs2-devel] [PATCH v6 03/19] mm: Use readahead_control to
	pass arguments
In-Reply-To: <20200218224610.GT10776@dread.disaster.area>
References: <20200217184613.19668-1-willy@infradead.org>
	<20200217184613.19668-4-willy@infradead.org>
	<20200218050300.GI10776@dread.disaster.area>
	<20200218135618.GO7778@bombadil.infradead.org>
	<20200218224610.GT10776@dread.disaster.area>
Message-ID: <20200218225235.GH24185@bombadil.infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Wed, Feb 19, 2020 at 09:46:10AM +1100, Dave Chinner wrote:
> On Tue, Feb 18, 2020 at 05:56:18AM -0800, Matthew Wilcox wrote:
> > On Tue, Feb 18, 2020 at 04:03:00PM +1100, Dave Chinner wrote:
> > > On Mon, Feb 17, 2020 at 10:45:44AM -0800, Matthew Wilcox wrote:
> > > > +static void read_pages(struct readahead_control *rac, struct list_head *pages,
> > > > +		gfp_t gfp)
> > > >  {
> > > > +	const struct address_space_operations *aops = rac->mapping->a_ops;
> > > >  	struct blk_plug plug;
> > > >  	unsigned page_idx;
> > > 
> > > Splitting out the aops rather than the mapping here just looks
> > > weird, especially as you need the mapping later in the function.
> > > Using aops doesn't even reduce the code side....
> > 
> > It does in subsequent patches ... I agree it looks a little weird here,
> > but I think in the final form, it makes sense:
> 
> Ok. Perhaps just an additional commit comment to say "read_pages() is
> changed to be aops centric as @rac abstracts away all other
> implementation details by the end of the patchset."

ACK, will add.

> > > > +			if (readahead_count(&rac))
> > > > +				read_pages(&rac, &page_pool, gfp_mask);
> > > > +			rac._nr_pages = 0;
> > > 
> > > Hmmm. Wondering ig it make sense to move the gfp_mask to the readahead
> > > control structure - if we have to pass the gfp_mask down all the
> > > way along side the rac, then I think it makes sense to do that...
> > 
> > So we end up removing it later on in this series, but I do wonder if
> > it would make sense anyway.  By the end of the series, we still have
> > this in iomap:
> > 
> >                 if (ctx->rac) /* same as readahead_gfp_mask */
> >                         gfp |= __GFP_NORETRY | __GFP_NOWARN;
> > 
> > and we could get rid of that by passing gfp flags down in the rac.  On the
> > other hand, I don't know why it doesn't just use readahead_gfp_mask()
> > here anyway ... Christoph?
> 
> mapping->gfp_mask is awful. Is it a mask, or is it a valid set of
> allocation flags? Or both?  Some callers to mapping_gfp_constraint()
> uses it as a mask, some callers to mapping_gfp_constraint() use it
> as base flags that context specific flags get masked out of,
> readahead_gfp_mask() callers use it as the entire set of gfp flags
> for allocation.
> 
> That whole API sucks - undocumented as to what it's suposed to do
> and how it's supposed to be used. Hence it's difficult to use
> correctly or understand whether it's being used correctly. And
> reading callers only leads to more confusion and crazy code like in
> do_mpage_readpage() where readahead returns a mask that are used as
> base flags and normal reads return a masked set of base flags...
> 
> The iomap code is obviously correct when it comes to gfp flag
> manipulation. We start with GFP_KERNEL context, then constrain it
> via the mask held in mapping->gfp_mask, then if it's readahead we
> allow the allocation to silently fail.
> 
> Simple to read and understand code, versus having weird code that
> requires the reader to decipher an undocumented and inconsistent API
> to understand how the gfp flags have been calculated and are valid.

I think a lot of this is not so much a criticism of mapping->gfp_mask
as a criticism of the whole GFP flags concept.  Some of the flags make
allocations more likely to succeed, others make them more likely to
fail.  Some of them allow the allocator to do more things; some prevent
the allocator from doing things it would otherwise do.  Some of them
aren't flags at all.  Some of them are mutually incompatible (and will
be warned about if set in combination), some of them will silently win
over other flags.

I think they made a certain amount of clunky sense when they were added,
but they've grown to a point where they don't make sense any more and
partly that's because there's nobody standing over the allocator with
a flaming sword promising certain death to anyone who adds a new flag
without thoroughly documenting its interactions with every other flag.

I am no longer a fan of GFP flags ;-)
