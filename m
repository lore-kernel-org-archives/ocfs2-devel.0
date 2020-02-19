From: Dave Chinner <david@fromorbit.com>
Date: Wed, 19 Feb 2020 12:23:18 +1100
Subject: [Ocfs2-devel] [PATCH v6 11/19] btrfs: Convert from readpages to
	readahead
In-Reply-To: <20200218211228.GF24185@bombadil.infradead.org>
References: <20200217184613.19668-1-willy@infradead.org>
	<20200217184613.19668-19-willy@infradead.org>
	<20200218065758.GQ10776@dread.disaster.area>
	<20200218211228.GF24185@bombadil.infradead.org>
Message-ID: <20200219012318.GY10776@dread.disaster.area>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On Tue, Feb 18, 2020 at 01:12:28PM -0800, Matthew Wilcox wrote:
> On Tue, Feb 18, 2020 at 05:57:58PM +1100, Dave Chinner wrote:
> > On Mon, Feb 17, 2020 at 10:45:59AM -0800, Matthew Wilcox wrote:
> > > From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
....
> > >  
> > > -		if (nr) {
> > > -			u64 contig_start = page_offset(pagepool[0]);
> > > +		ASSERT(contig_start + nr * PAGE_SIZE - 1 == contig_end);
> > 
> > Ok, yes it does. :)
> > 
> > I don't see how readahead_for_each_batch() guarantees that, though.
> 
> I ... don't see how it doesn't?  We start at rac->_start and iterate
> through the consecutive pages in the page cache.  readahead_for_each_batch()
> does assume that __do_page_cache_readahead() has its current behaviour
> of putting the pages in the page cache in order, and kicks off a new
> call to ->readahead() every time it has to skip an index for whatever
> reason (eg page already in page cache).

And there is the comment I was looking for while reading
readahead_for_each_batch() :)

> 
> > > -	if (bio)
> > > -		return submit_one_bio(bio, 0, bio_flags);
> > > -	return 0;
> > > +	if (bio) {
> > > +		if (submit_one_bio(bio, 0, bio_flags))
> > > +			return;
> > > +	}
> > >  }
> > 
> > Shouldn't that just be
> > 
> > 	if (bio)
> > 		submit_one_bio(bio, 0, bio_flags);
> 
> It should, but some overzealous person decided to mark submit_one_bio()
> as __must_check, so I have to work around that.

/me looks at code

Ngggh.

I rather dislike functions that are named in a way that look like
they belong to core kernel APIs but in reality are local static
functions.

I'd ask for this to be fixed if it was generic code, but it's btrfs
specific code so they can deal with the ugliness of their own
creation. :/

> > Confusing when put alongside rac->_batch_count counting the number
> > of pages in the batch, and "batch" being the index into the page
> > array, and they aren't the same counts....
> 
> Yes.  Renamed to 'i'.
> 
> > > +	XA_STATE(xas, &rac->mapping->i_pages, rac->_start);
> > > +	struct page *page;
> > > +
> > > +	rac->_batch_count = 0;
> > > +	xas_for_each(&xas, page, rac->_start + rac->_nr_pages - 1) {
> > 
> > That just iterates pages in the start,end doesn't it? What
> > guarantees that this fills the array with a contiguous page range?
> 
> The behaviour of __do_page_cache_readahead().  Dave Howells also has a
> usecase for xas_for_each_contig(), so I'm going to add that soon.
> 
> > > +		VM_BUG_ON_PAGE(!PageLocked(page), page);
> > > +		VM_BUG_ON_PAGE(PageTail(page), page);
> > > +		array[batch++] = page;
> > > +		rac->_batch_count += hpage_nr_pages(page);
> > > +		if (PageHead(page))
> > > +			xas_set(&xas, rac->_start + rac->_batch_count);
> > 
> > What on earth does this do? Comments please!
> 
> 		/*
> 		 * The page cache isn't using multi-index entries yet,
> 		 * so xas_for_each() won't do the right thing for
> 		 * large pages.  This can be removed once the page cache
> 		 * is converted.
> 		 */

Oh, it's changing the internal xarray lookup cursor position to
point at the correct next page index? Perhaps it's better to say
that instead of "won't do the right thing"?

> > > +#define readahead_for_each_batch(rac, array, size, nr)			\
> > > +	for (; (nr = readahead_page_batch(rac, array, size));		\
> > > +			readahead_next(rac))
> > 
> > I had to go look at the caller to work out what "size" refered to
> > here.
> > 
> > This is complex enough that it needs proper API documentation.
> 
> How about just:
> 
> -#define readahead_for_each_batch(rac, array, size, nr)                 \
> -       for (; (nr = readahead_page_batch(rac, array, size));           \
> +#define readahead_for_each_batch(rac, array, array_sz, nr)             \
> +       for (; (nr = readahead_page_batch(rac, array, array_sz));       \

Yup, that's fine - now the macro documents itself.

Cheers,

Dave.
-- 
Dave Chinner
david at fromorbit.com
