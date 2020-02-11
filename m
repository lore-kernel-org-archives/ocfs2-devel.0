From: Dave Chinner <david@fromorbit.com>
Date: Wed, 12 Feb 2020 07:08:26 +1100
Subject: [Ocfs2-devel] [PATCH v5 04/13] mm: Add readahead address space
	operation
In-Reply-To: <20200211125413.GU8731@bombadil.infradead.org>
References: <20200211010348.6872-1-willy@infradead.org>
	<20200211010348.6872-5-willy@infradead.org>
	<20200211045230.GD10776@dread.disaster.area>
	<20200211125413.GU8731@bombadil.infradead.org>
Message-ID: <20200211200826.GK10776@dread.disaster.area>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Feb 11, 2020 at 04:54:13AM -0800, Matthew Wilcox wrote:
> On Tue, Feb 11, 2020 at 03:52:30PM +1100, Dave Chinner wrote:
> > > +struct readahead_control {
> > > +	struct file *file;
> > > +	struct address_space *mapping;
> > > +/* private: use the readahead_* accessors instead */
> > > +	pgoff_t start;
> > > +	unsigned int nr_pages;
> > > +	unsigned int batch_count;
> > > +};
> > > +
> > > +static inline struct page *readahead_page(struct readahead_control *rac)
> > > +{
> > > +	struct page *page;
> > > +
> > > +	if (!rac->nr_pages)
> > > +		return NULL;
> > > +
> > > +	page = xa_load(&rac->mapping->i_pages, rac->start);
> > > +	VM_BUG_ON_PAGE(!PageLocked(page), page);
> > > +	rac->batch_count = hpage_nr_pages(page);
> > > +	rac->start += rac->batch_count;
> > 
> > There's no mention of large page support in the patch description
> > and I don't recall this sort of large page batching in previous
> > iterations.
> > 
> > This seems like new functionality to me, not directly related to
> > the initial ->readahead API change? What have I missed?
> 
> I had a crisis of confidence when I was working on this -- the loop
> originally looked like this:
> 
> #define readahead_for_each(rac, page)                                   \
>         for (; (page = readahead_page(rac)); rac->nr_pages--)
> 
> and then I started thinking about what I'd need to do to support large
> pages, and that turned into
> 
> #define readahead_for_each(rac, page)                                   \
>         for (; (page = readahead_page(rac));				\
> 		rac->nr_pages -= hpage_nr_pages(page))
> 
> but I realised that was potentially a use-after-free because 'page' has
> certainly had put_page() called on it by then.  I had a brief period
> where I looked at moving put_page() away from being the filesystem's
> responsibility and into the iterator, but that would introduce more
> changes into the patchset, as well as causing problems for filesystems
> that want to break out of the loop.
> 
> By this point, I was also looking at the readahead_for_each_batch()
> iterator that btrfs uses, and so we have the batch count anyway, and we
> might as well use it to store the number of subpages of the large page.
> And so it became easier to just put the whole ball of wax into the initial
> patch set, rather than introduce the iterator now and then fix it up in
> the patch set that I'm basing on this.
> 
> So yes, there's a certain amount of excess functionality in this patch
> set ... I can remove it for the next release.

I'd say "Just document it" as that was the main reason I noticed it.
Or perhaps add the batching function as a stand-alone patch so it's
clear that the batch interface solves two problems at once - large
pages and the btrfs page batching implementation...

Cheers,

Dave.
-- 
Dave Chinner
david at fromorbit.com
