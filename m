From: Matthew Wilcox <willy@infradead.org>
Date: Fri, 14 Feb 2020 17:15:05 -0800
Subject: [Ocfs2-devel] [PATCH v5 04/13] mm: Add readahead address space
	operation
In-Reply-To: <755399a8-8fdf-bfac-9f23-81579ff63ddf@nvidia.com>
References: <20200211010348.6872-1-willy@infradead.org>
	<20200211010348.6872-5-willy@infradead.org>
	<755399a8-8fdf-bfac-9f23-81579ff63ddf@nvidia.com>
Message-ID: <20200215011505.GD7778@bombadil.infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Feb 13, 2020 at 09:36:25PM -0800, John Hubbard wrote:
> > +static inline struct page *readahead_page(struct readahead_control *rac)
> > +{
> > +	struct page *page;
> > +
> > +	if (!rac->nr_pages)
> > +		return NULL;
> > +
> > +	page = xa_load(&rac->mapping->i_pages, rac->start);
> 
> 
> Is it worth asserting that the page was found:
> 
> 	VM_BUG_ON_PAGE(!page || xa_is_value(page), page);
> 
> ? Or is that overkill here?

It shouldn't be possible since they were just added in a locked state.
If it did happen, it'll be caught by the assert below -- dereferencing
a NULL pointer or a shadow entry is not going to go well.

> > +	VM_BUG_ON_PAGE(!PageLocked(page), page);
> > +	rac->batch_count = hpage_nr_pages(page);
> > +	rac->start += rac->batch_count;
> 
> The above was surprising, until I saw the other thread with Dave and you.
> I was reviewing this patchset in order to have a chance at understanding the 
> follow-on patchset ("Large pages in the page cache"), and it seems like that
> feature has a solid head start here. :)  

Right, I'll document that.
