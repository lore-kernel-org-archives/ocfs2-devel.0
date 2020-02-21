From: Matthew Wilcox <willy@infradead.org>
Date: Thu, 20 Feb 2020 19:43:04 -0800
Subject: [Ocfs2-devel] [PATCH v7 09/24] mm: Put readahead pages in cache
	earlier
In-Reply-To: <5691442b-56c7-7b0d-d91b-275be52abb42@nvidia.com>
References: <20200219210103.32400-1-willy@infradead.org>
	<20200219210103.32400-10-willy@infradead.org>
	<5691442b-56c7-7b0d-d91b-275be52abb42@nvidia.com>
Message-ID: <20200221034304.GC24185@bombadil.infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: John Hubbard <jhubbard@nvidia.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On Thu, Feb 20, 2020 at 07:19:58PM -0800, John Hubbard wrote:
> > +static inline struct page *readahead_page(struct readahead_control *rac)
> > +{
> > +	struct page *page;
> > +
> > +	BUG_ON(rac->_batch_count > rac->_nr_pages);
> > +	rac->_nr_pages -= rac->_batch_count;
> > +	rac->_index += rac->_batch_count;
> > +	rac->_batch_count = 0;
> 
> 
> Is it intentional, to set rac->_batch_count twice (here, and below)? The
> only reason I can see is if a caller needs to use ->_batch_count in the
> "return NULL" case, which doesn't seem to come up...

Ah, but it does.  Not in this patch, but the next one ...

+       if (aops->readahead) {
+               aops->readahead(rac);
+               /* Clean up the remaining pages */
+               while ((page = readahead_page(rac))) {
+                       unlock_page(page);
+                       put_page(page);
+               }

In the normal case, the ->readahead method will consume all the pages,
and we need readahead_page() to do nothing if it is called again.

> > +	if (!rac->_nr_pages)
> > +		return NULL;

... admittedly I could do:

	if (!rac->_nr_pages) {
		rac->_batch_count = 0;
		return NULL;
	}

which might be less confusing.

> > @@ -130,23 +129,23 @@ static void read_pages(struct readahead_control *rac, struct list_head *pages,
> >  				readahead_count(rac));
> >  		/* Clean up the remaining pages */
> >  		put_pages_list(pages);
> > -		goto out;
> > -	}
> > -
> > -	for (page_idx = 0; page_idx < readahead_count(rac); page_idx++) {
> > -		struct page *page = lru_to_page(pages);
> > -		list_del(&page->lru);
> > -		if (!add_to_page_cache_lru(page, rac->mapping, page->index,
> > -				gfp))
> > +		rac->_index += rac->_nr_pages;
> > +		rac->_nr_pages = 0;
> > +	} else {
> > +		while ((page = readahead_page(rac))) {
> >  			aops->readpage(rac->file, page);
> > -		put_page(page);
> > +			put_page(page);
> > +		}
> >  	}
> >  
> > -out:
> >  	blk_finish_plug(&plug);
> >  
> >  	BUG_ON(!list_empty(pages));
> > -	rac->_nr_pages = 0;
> > +	BUG_ON(readahead_count(rac));
> > +
> > +out:
> > +	/* If we were called due to a conflicting page, skip over it */
> 
> Tiny documentation nit: What if we were *not* called due to a conflicting page? 
> (And what is a "conflicting page", in this context, btw?) The next line unconditionally 
> moves the index ahead, so the "if" part of the comment really confuses me.

By the end of the series, read_pages() is called in three places:

1.              if (page && !xa_is_value(page)) {
                        read_pages(&rac, &page_pool);

2.              } else if (add_to_page_cache_lru(page, mapping, index + i,
                                        gfp_mask) < 0) {
                        put_page(page);
                        read_pages(&rac, &page_pool);

3.      read_pages(&rac, &page_pool);

In the first two cases, there's an existing page in the page cache
(which conflicts with this readahead operation), and so we need to
advance index.  In the third case, we're exiting the function, so it
does no harm to advance index one further.

> > +		} else if (add_to_page_cache_lru(page, mapping, index + i,
> > +					gfp_mask) < 0) {
> 
> I still think you'll want to compare against !=0, rather than < 0, here.

I tend to prefer < 0 when checking for an error value in case the function
decides to start using positive numbers to mean something.  I don't think
it's a particularly important preference though (after all, returning 1
might mean "failed, but for this weird reason rather than an errno").

> > +			put_page(page);
> > +			read_pages(&rac, &page_pool);
> 
> Doing a read_pages() in the error case is because...actually, I'm not sure yet.
> Why do we do this? Effectively it's a retry?

Same as the reason we call read_pages() if we found a page in the page
cache earlier -- we're sending down a set of pages which are consecutive
in the file's address space, and now we have to skip one.  At least one ;-)
