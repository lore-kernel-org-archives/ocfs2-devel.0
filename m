From: Matthew Wilcox <willy@infradead.org>
Date: Tue, 18 Feb 2020 05:56:18 -0800
Subject: [Ocfs2-devel] [PATCH v6 03/19] mm: Use readahead_control to
	pass arguments
In-Reply-To: <20200218050300.GI10776@dread.disaster.area>
References: <20200217184613.19668-1-willy@infradead.org>
	<20200217184613.19668-4-willy@infradead.org>
	<20200218050300.GI10776@dread.disaster.area>
Message-ID: <20200218135618.GO7778@bombadil.infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Tue, Feb 18, 2020 at 04:03:00PM +1100, Dave Chinner wrote:
> On Mon, Feb 17, 2020 at 10:45:44AM -0800, Matthew Wilcox wrote:
> > +static void read_pages(struct readahead_control *rac, struct list_head *pages,
> > +		gfp_t gfp)
> >  {
> > +	const struct address_space_operations *aops = rac->mapping->a_ops;
> >  	struct blk_plug plug;
> >  	unsigned page_idx;
> 
> Splitting out the aops rather than the mapping here just looks
> weird, especially as you need the mapping later in the function.
> Using aops doesn't even reduce the code side....

It does in subsequent patches ... I agree it looks a little weird here,
but I think in the final form, it makes sense:

static void read_pages(struct readahead_control *rac, struct list_head *pages)
{
        const struct address_space_operations *aops = rac->mapping->a_ops;
        struct page *page;
        struct blk_plug plug;

        blk_start_plug(&plug);

        if (aops->readahead) {
                aops->readahead(rac);
                readahead_for_each(rac, page) {
                        unlock_page(page);
                        put_page(page);
                }
        } else if (aops->readpages) {
                aops->readpages(rac->file, rac->mapping, pages,
                                readahead_count(rac));
                /* Clean up the remaining pages */
                put_pages_list(pages);
        } else {
                readahead_for_each(rac, page) {
                        aops->readpage(rac->file, page);
                        put_page(page);
                }
        }

        blk_finish_plug(&plug);
}

It'll look even better once ->readpages goes away.

> > @@ -155,9 +158,13 @@ void __do_page_cache_readahead(struct address_space *mapping,
> >  	unsigned long end_index;	/* The last page we want to read */
> >  	LIST_HEAD(page_pool);
> >  	int page_idx;
> > -	unsigned int nr_pages = 0;
> >  	loff_t isize = i_size_read(inode);
> >  	gfp_t gfp_mask = readahead_gfp_mask(mapping);
> > +	struct readahead_control rac = {
> > +		.mapping = mapping,
> > +		.file = filp,
> > +		._nr_pages = 0,
> > +	};
> 
> No need to initialise _nr_pages to zero, leaving it out will do the
> same thing.

Yes, it does, but I wanted to make it explicit here.

> > +			if (readahead_count(&rac))
> > +				read_pages(&rac, &page_pool, gfp_mask);
> > +			rac._nr_pages = 0;
> 
> Hmmm. Wondering ig it make sense to move the gfp_mask to the readahead
> control structure - if we have to pass the gfp_mask down all the
> way along side the rac, then I think it makes sense to do that...

So we end up removing it later on in this series, but I do wonder if
it would make sense anyway.  By the end of the series, we still have
this in iomap:

                if (ctx->rac) /* same as readahead_gfp_mask */
                        gfp |= __GFP_NORETRY | __GFP_NOWARN;

and we could get rid of that by passing gfp flags down in the rac.  On the
other hand, I don't know why it doesn't just use readahead_gfp_mask()
here anyway ... Christoph?
