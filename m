From: John Hubbard <jhubbard@nvidia.com>
Date: Tue, 18 Feb 2020 16:01:43 -0800
Subject: [Ocfs2-devel] [PATCH v6 07/19] mm: Put readahead pages in cache
	earlier
In-Reply-To: <20200217184613.19668-12-willy@infradead.org>
References: <20200217184613.19668-1-willy@infradead.org>
	<20200217184613.19668-12-willy@infradead.org>
Message-ID: <e3671faa-dfb3-ceba-3120-a445b2982a95@nvidia.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On 2/17/20 10:45 AM, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> At allocation time, put the pages in the cache unless we're using
> ->readpages.  Add the readahead_for_each() iterator for the benefit of
> the ->readpage fallback.  This iterator supports huge pages, even though
> none of the filesystems to be converted do yet.
> 


"Also, remove the gfp argument from read_pages(), now that read_pages()
no longer does allocation."

Generally looks accurate, just a few notes below:


> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/linux/pagemap.h | 24 ++++++++++++++++++++++++
>  mm/readahead.c          | 34 +++++++++++++++++-----------------
>  2 files changed, 41 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 982ecda2d4a2..3613154e79e4 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -639,8 +639,32 @@ struct readahead_control {
>  /* private: use the readahead_* accessors instead */
>  	pgoff_t _start;
>  	unsigned int _nr_pages;
> +	unsigned int _batch_count;
>  };
>  
> +static inline struct page *readahead_page(struct readahead_control *rac)
> +{
> +	struct page *page;
> +
> +	if (!rac->_nr_pages)
> +		return NULL;
> +
> +	page = xa_load(&rac->mapping->i_pages, rac->_start);
> +	VM_BUG_ON_PAGE(!PageLocked(page), page);
> +	rac->_batch_count = hpage_nr_pages(page);
> +
> +	return page;
> +}
> +
> +static inline void readahead_next(struct readahead_control *rac)
> +{
> +	rac->_nr_pages -= rac->_batch_count;
> +	rac->_start += rac->_batch_count;
> +}
> +
> +#define readahead_for_each(rac, page)					\
> +	for (; (page = readahead_page(rac)); readahead_next(rac))
> +


How about this instead? It uses the "for" loop fully and more naturally,
and is easier to read. And it does the same thing:

static inline struct page *readahead_page(struct readahead_control *rac)
{
	struct page *page;

	if (!rac->_nr_pages)
		return NULL;

	page = xa_load(&rac->mapping->i_pages, rac->_start);
	VM_BUG_ON_PAGE(!PageLocked(page), page);
	rac->_batch_count = hpage_nr_pages(page);

	return page;
}

static inline struct page *readahead_next(struct readahead_control *rac)
{
	rac->_nr_pages -= rac->_batch_count;
	rac->_start += rac->_batch_count;

	return readahead_page(rac);
}

#define readahead_for_each(rac, page)			\
	for (page = readahead_page(rac); page != NULL;	\
	     page = readahead_page(rac))




>  /* The number of pages in this readahead block */
>  static inline unsigned int readahead_count(struct readahead_control *rac)
>  {
> diff --git a/mm/readahead.c b/mm/readahead.c
> index bdc5759000d3..9e430daae42f 100644
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -113,12 +113,11 @@ int read_cache_pages(struct address_space *mapping, struct list_head *pages,
>  
>  EXPORT_SYMBOL(read_cache_pages);
>  
> -static void read_pages(struct readahead_control *rac, struct list_head *pages,
> -		gfp_t gfp)
> +static void read_pages(struct readahead_control *rac, struct list_head *pages)
>  {
>  	const struct address_space_operations *aops = rac->mapping->a_ops;
> +	struct page *page;
>  	struct blk_plug plug;
> -	unsigned page_idx;
>  
>  	blk_start_plug(&plug);
>  
> @@ -127,19 +126,13 @@ static void read_pages(struct readahead_control *rac, struct list_head *pages,
>  				readahead_count(rac));
>  		/* Clean up the remaining pages */
>  		put_pages_list(pages);
> -		goto out;
> -	}
> -
> -	for (page_idx = 0; page_idx < readahead_count(rac); page_idx++) {
> -		struct page *page = lru_to_page(pages);
> -		list_del(&page->lru);
> -		if (!add_to_page_cache_lru(page, rac->mapping, page->index,
> -				gfp))
> +	} else {
> +		readahead_for_each(rac, page) {
>  			aops->readpage(rac->file, page);
> -		put_page(page);
> +			put_page(page);
> +		}
>  	}
>  
> -out:
>  	blk_finish_plug(&plug);
>  }
>  
> @@ -159,6 +152,7 @@ void __do_page_cache_readahead(struct address_space *mapping,
>  	unsigned long i;
>  	loff_t isize = i_size_read(inode);
>  	gfp_t gfp_mask = readahead_gfp_mask(mapping);
> +	bool use_list = mapping->a_ops->readpages;


fwiw, "bool have_readpages" seems like a better name (after all, that's how read_pages() 
effectively is written: "if you have .readpages, then..."), but I can see both sides 
of that bikeshed. :)


>  	struct readahead_control rac = {
>  		.mapping = mapping,
>  		.file = filp,
> @@ -196,8 +190,14 @@ void __do_page_cache_readahead(struct address_space *mapping,
>  		page = __page_cache_alloc(gfp_mask);
>  		if (!page)
>  			break;
> -		page->index = offset;
> -		list_add(&page->lru, &page_pool);
> +		if (use_list) {
> +			page->index = offset;
> +			list_add(&page->lru, &page_pool);
> +		} else if (add_to_page_cache_lru(page, mapping, offset,
> +					gfp_mask) < 0) {


It would be a little safer from a maintenance point of view, to check for !=0, rather
than checking for < 0.  Most (all?) existing callers check that way, and it's good
to stay with the pack there.


> +			put_page(page);
> +			goto read;
> +		}
>  		if (i == nr_to_read - lookahead_size)
>  			SetPageReadahead(page);
>  		rac._nr_pages++;
> @@ -205,7 +205,7 @@ void __do_page_cache_readahead(struct address_space *mapping,
>  		continue;
>  read:
>  		if (readahead_count(&rac))
> -			read_pages(&rac, &page_pool, gfp_mask);
> +			read_pages(&rac, &page_pool);
>  		rac._nr_pages = 0;
>  		rac._start = ++offset;
>  	}
> @@ -216,7 +216,7 @@ void __do_page_cache_readahead(struct address_space *mapping,
>  	 * will then handle the error.
>  	 */
>  	if (readahead_count(&rac))
> -		read_pages(&rac, &page_pool, gfp_mask);
> +		read_pages(&rac, &page_pool);
>  	BUG_ON(!list_empty(&page_pool));
>  }
>  
> 


thanks,
-- 
John Hubbard
NVIDIA
