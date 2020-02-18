From: John Hubbard <jhubbard@nvidia.com>
Date: Tue, 18 Feb 2020 15:11:38 -0800
Subject: [Ocfs2-devel] [PATCH v6 06/19] mm: rename readahead loop
	variable to 'i'
In-Reply-To: <20200217184613.19668-10-willy@infradead.org>
References: <20200217184613.19668-1-willy@infradead.org>
	<20200217184613.19668-10-willy@infradead.org>
Message-ID: <64b98d0d-d281-fe34-8dbb-a04ac719d74d@nvidia.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On 2/17/20 10:45 AM, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> Change the type of page_idx to unsigned long, and rename it -- it's
> just a loop counter, not a page index.
> 
> Suggested-by: John Hubbard <jhubbard@nvidia.com>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  mm/readahead.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 

Looks good,

    Reviewed-by: John Hubbard <jhubbard@nvidia.com>


thanks,
-- 
John Hubbard
NVIDIA

> diff --git a/mm/readahead.c b/mm/readahead.c
> index 74791b96013f..bdc5759000d3 100644
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -156,7 +156,7 @@ void __do_page_cache_readahead(struct address_space *mapping,
>  	struct inode *inode = mapping->host;
>  	unsigned long end_index;	/* The last page we want to read */
>  	LIST_HEAD(page_pool);
> -	int page_idx;
> +	unsigned long i;
>  	loff_t isize = i_size_read(inode);
>  	gfp_t gfp_mask = readahead_gfp_mask(mapping);
>  	struct readahead_control rac = {
> @@ -174,7 +174,7 @@ void __do_page_cache_readahead(struct address_space *mapping,
>  	/*
>  	 * Preallocate as many pages as we will need.
>  	 */
> -	for (page_idx = 0; page_idx < nr_to_read; page_idx++) {
> +	for (i = 0; i < nr_to_read; i++) {
>  		struct page *page;
>  
>  		if (offset > end_index)
> @@ -198,7 +198,7 @@ void __do_page_cache_readahead(struct address_space *mapping,
>  			break;
>  		page->index = offset;
>  		list_add(&page->lru, &page_pool);
> -		if (page_idx == nr_to_read - lookahead_size)
> +		if (i == nr_to_read - lookahead_size)
>  			SetPageReadahead(page);
>  		rac._nr_pages++;
>  		offset++;
> 
