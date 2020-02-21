From: John Hubbard <jhubbard@nvidia.com>
Date: Thu, 20 Feb 2020 19:50:39 -0800
Subject: [Ocfs2-devel] [PATCH v7 11/24] mm: Move end_index check out of
	readahead loop
In-Reply-To: <20200219210103.32400-12-willy@infradead.org>
References: <20200219210103.32400-1-willy@infradead.org>
	<20200219210103.32400-12-willy@infradead.org>
Message-ID: <e6ef2075-b849-299e-0f11-c6ee82b0a3c7@nvidia.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On 2/19/20 1:00 PM, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> By reducing nr_to_read, we can eliminate this check from inside the loop.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  mm/readahead.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/readahead.c b/mm/readahead.c
> index 07cdfbf00f4b..ace611f4bf05 100644
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -166,8 +166,6 @@ void __do_page_cache_readahead(struct address_space *mapping,
>  		unsigned long lookahead_size)
>  {
>  	struct inode *inode = mapping->host;
> -	struct page *page;
> -	unsigned long end_index;	/* The last page we want to read */
>  	LIST_HEAD(page_pool);
>  	loff_t isize = i_size_read(inode);
>  	gfp_t gfp_mask = readahead_gfp_mask(mapping);
> @@ -179,22 +177,27 @@ void __do_page_cache_readahead(struct address_space *mapping,
>  		._nr_pages = 0,
>  	};
>  	unsigned long i;
> +	pgoff_t end_index;	/* The last page we want to read */
>  
>  	if (isize == 0)
>  		return;
>  
> -	end_index = ((isize - 1) >> PAGE_SHIFT);
> +	end_index = (isize - 1) >> PAGE_SHIFT;
> +	if (index > end_index)
> +		return;
> +	if (index + nr_to_read < index)
> +		nr_to_read = ULONG_MAX - index + 1;
> +	if (index + nr_to_read >= end_index)
> +		nr_to_read = end_index - index + 1;


This tiny patch made me pause, because I wasn't sure at first of the exact
intent of the lines above. Once I worked it out, it seemed like it might
be helpful (or overkill??) to add a few hints for the reader, especially since
there are no hints in the function's (minimal) documentation header. What
do you think of this?

	/*
	 * If we can't read *any* pages without going past the inodes's isize
	 * limit, give up entirely:
	 */
	if (index > end_index)
		return;

	/* Cap nr_to_read, in order to avoid overflowing the ULONG type: */
	if (index + nr_to_read < index)
		nr_to_read = ULONG_MAX - index + 1;

	/* Cap nr_to_read, to avoid reading past the inode's isize limit: */
	if (index + nr_to_read >= end_index)
		nr_to_read = end_index - index + 1;


Either way, it looks corrected written to me, so:

    Reviewed-by: John Hubbard <jhubbard@nvidia.com>


thanks,
-- 
John Hubbard
NVIDIA

>  
>  	/*
>  	 * Preallocate as many pages as we will need.
>  	 */
>  	for (i = 0; i < nr_to_read; i++) {
> -		if (index + i > end_index)
> -			break;
> +		struct page *page = xa_load(&mapping->i_pages, index + i);
>  
>  		BUG_ON(index + i != rac._index + rac._nr_pages);
>  
> -		page = xa_load(&mapping->i_pages, index + i);
>  		if (page && !xa_is_value(page)) {
>  			/*
>  			 * Page already present?  Kick off the current batch of
> 
