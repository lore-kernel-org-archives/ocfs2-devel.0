From: Dave Chinner <david@fromorbit.com>
Date: Tue, 11 Feb 2020 15:52:30 +1100
Subject: [Ocfs2-devel] [PATCH v5 04/13] mm: Add readahead address space
	operation
In-Reply-To: <20200211010348.6872-5-willy@infradead.org>
References: <20200211010348.6872-1-willy@infradead.org>
	<20200211010348.6872-5-willy@infradead.org>
Message-ID: <20200211045230.GD10776@dread.disaster.area>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 10, 2020 at 05:03:39PM -0800, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> This replaces ->readpages with a saner interface:
>  - Return void instead of an ignored error code.
>  - Pages are already in the page cache when ->readahead is called.
>  - Implementation looks up the pages in the page cache instead of
>    having them passed in a linked list.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

....

>  
> +/*
> + * Readahead is of a block of consecutive pages.
> + */
> +struct readahead_control {
> +	struct file *file;
> +	struct address_space *mapping;
> +/* private: use the readahead_* accessors instead */
> +	pgoff_t start;
> +	unsigned int nr_pages;
> +	unsigned int batch_count;
> +};
> +
> +static inline struct page *readahead_page(struct readahead_control *rac)
> +{
> +	struct page *page;
> +
> +	if (!rac->nr_pages)
> +		return NULL;
> +
> +	page = xa_load(&rac->mapping->i_pages, rac->start);
> +	VM_BUG_ON_PAGE(!PageLocked(page), page);
> +	rac->batch_count = hpage_nr_pages(page);
> +	rac->start += rac->batch_count;

There's no mention of large page support in the patch description
and I don't recall this sort of large page batching in previous
iterations.

This seems like new functionality to me, not directly related to
the initial ->readahead API change? What have I missed?

Cheers,

Dave.
-- 
Dave Chinner
david at fromorbit.com
