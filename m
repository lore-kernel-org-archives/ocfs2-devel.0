From: Dave Chinner <david@fromorbit.com>
Date: Tue, 18 Feb 2020 17:57:58 +1100
Subject: [Ocfs2-devel] [PATCH v6 11/19] btrfs: Convert from readpages to
	readahead
In-Reply-To: <20200217184613.19668-19-willy@infradead.org>
References: <20200217184613.19668-1-willy@infradead.org>
	<20200217184613.19668-19-willy@infradead.org>
Message-ID: <20200218065758.GQ10776@dread.disaster.area>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On Mon, Feb 17, 2020 at 10:45:59AM -0800, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> Use the new readahead operation in btrfs.  Add a
> readahead_for_each_batch() iterator to optimise the loop in the XArray.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/btrfs/extent_io.c    | 46 +++++++++++++----------------------------
>  fs/btrfs/extent_io.h    |  3 +--
>  fs/btrfs/inode.c        | 16 +++++++-------
>  include/linux/pagemap.h | 27 ++++++++++++++++++++++++
>  4 files changed, 49 insertions(+), 43 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index c0f202741e09..e97a6acd6f5d 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -4278,52 +4278,34 @@ int extent_writepages(struct address_space *mapping,
>  	return ret;
>  }
>  
> -int extent_readpages(struct address_space *mapping, struct list_head *pages,
> -		     unsigned nr_pages)
> +void extent_readahead(struct readahead_control *rac)
>  {
>  	struct bio *bio = NULL;
>  	unsigned long bio_flags = 0;
>  	struct page *pagepool[16];
>  	struct extent_map *em_cached = NULL;
> -	struct extent_io_tree *tree = &BTRFS_I(mapping->host)->io_tree;
> -	int nr = 0;
> +	struct extent_io_tree *tree = &BTRFS_I(rac->mapping->host)->io_tree;
>  	u64 prev_em_start = (u64)-1;
> +	int nr;
>  
> -	while (!list_empty(pages)) {
> -		u64 contig_end = 0;
> -
> -		for (nr = 0; nr < ARRAY_SIZE(pagepool) && !list_empty(pages);) {
> -			struct page *page = lru_to_page(pages);
> -
> -			prefetchw(&page->flags);
> -			list_del(&page->lru);
> -			if (add_to_page_cache_lru(page, mapping, page->index,
> -						readahead_gfp_mask(mapping))) {
> -				put_page(page);
> -				break;
> -			}
> -
> -			pagepool[nr++] = page;
> -			contig_end = page_offset(page) + PAGE_SIZE - 1;
> -		}
> +	readahead_for_each_batch(rac, pagepool, ARRAY_SIZE(pagepool), nr) {
> +		u64 contig_start = page_offset(pagepool[0]);
> +		u64 contig_end = page_offset(pagepool[nr - 1]) + PAGE_SIZE - 1;

So this assumes a contiguous page range is returned, right?

>  
> -		if (nr) {
> -			u64 contig_start = page_offset(pagepool[0]);
> +		ASSERT(contig_start + nr * PAGE_SIZE - 1 == contig_end);

Ok, yes it does. :)

I don't see how readahead_for_each_batch() guarantees that, though.

>  
> -			ASSERT(contig_start + nr * PAGE_SIZE - 1 == contig_end);
> -
> -			contiguous_readpages(tree, pagepool, nr, contig_start,
> -				     contig_end, &em_cached, &bio, &bio_flags,
> -				     &prev_em_start);
> -		}
> +		contiguous_readpages(tree, pagepool, nr, contig_start,
> +				contig_end, &em_cached, &bio, &bio_flags,
> +				&prev_em_start);
>  	}
>  
>  	if (em_cached)
>  		free_extent_map(em_cached);
>  
> -	if (bio)
> -		return submit_one_bio(bio, 0, bio_flags);
> -	return 0;
> +	if (bio) {
> +		if (submit_one_bio(bio, 0, bio_flags))
> +			return;
> +	}
>  }

Shouldn't that just be

	if (bio)
		submit_one_bio(bio, 0, bio_flags);

> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 4f36c06d064d..1bbb60a0bf16 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -669,6 +669,33 @@ static inline void readahead_next(struct readahead_control *rac)
>  #define readahead_for_each(rac, page)					\
>  	for (; (page = readahead_page(rac)); readahead_next(rac))
>  
> +static inline unsigned int readahead_page_batch(struct readahead_control *rac,
> +		struct page **array, unsigned int size)
> +{
> +	unsigned int batch = 0;

Confusing when put alongside rac->_batch_count counting the number
of pages in the batch, and "batch" being the index into the page
array, and they aren't the same counts....

> +	XA_STATE(xas, &rac->mapping->i_pages, rac->_start);
> +	struct page *page;
> +
> +	rac->_batch_count = 0;
> +	xas_for_each(&xas, page, rac->_start + rac->_nr_pages - 1) {

That just iterates pages in the start,end doesn't it? What
guarantees that this fills the array with a contiguous page range?

> +		VM_BUG_ON_PAGE(!PageLocked(page), page);
> +		VM_BUG_ON_PAGE(PageTail(page), page);
> +		array[batch++] = page;
> +		rac->_batch_count += hpage_nr_pages(page);
> +		if (PageHead(page))
> +			xas_set(&xas, rac->_start + rac->_batch_count);

What on earth does this do? Comments please!

> +
> +		if (batch == size)
> +			break;
> +	}
> +
> +	return batch;
> +}

Seems a bit big for an inline function.

> +
> +#define readahead_for_each_batch(rac, array, size, nr)			\
> +	for (; (nr = readahead_page_batch(rac, array, size));		\
> +			readahead_next(rac))

I had to go look at the caller to work out what "size" refered to
here.

This is complex enough that it needs proper API documentation.

Cheers,

Dave.

-- 
Dave Chinner
david at fromorbit.com
