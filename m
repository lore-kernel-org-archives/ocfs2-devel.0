From: John Hubbard <jhubbard@nvidia.com>
Date: Thu, 20 Feb 2020 18:48:45 -0800
Subject: [Ocfs2-devel] [PATCH v7 08/24] mm: Remove 'page_offset' from
	readahead loop
In-Reply-To: <20200219210103.32400-9-willy@infradead.org>
References: <20200219210103.32400-1-willy@infradead.org>
	<20200219210103.32400-9-willy@infradead.org>
Message-ID: <f4b720f3-9084-e767-8983-2b6c3d1b9c5a@nvidia.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On 2/19/20 1:00 PM, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> Replace the page_offset variable with 'index + i'.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  mm/readahead.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/readahead.c b/mm/readahead.c
> index 8a25fc7e2bf2..83df5c061d33 100644
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -181,12 +181,10 @@ void __do_page_cache_readahead(struct address_space *mapping,
>  	 * Preallocate as many pages as we will need.
>  	 */
>  	for (i = 0; i < nr_to_read; i++) {
> -		pgoff_t page_offset = index + i;


ha, the naming mismatch I complained about in an earlier patch gets deleted
here, so we're good after all. :)

Looks good,

    Reviewed-by: John Hubbard <jhubbard@nvidia.com>


thanks,
-- 
John Hubbard
NVIDIA

> -
> -		if (page_offset > end_index)
> +		if (index + i > end_index)
>  			break;
>  
> -		page = xa_load(&mapping->i_pages, page_offset);
> +		page = xa_load(&mapping->i_pages, index + i);
>  		if (page && !xa_is_value(page)) {
>  			/*
>  			 * Page already present?  Kick off the current batch of
> @@ -200,7 +198,7 @@ void __do_page_cache_readahead(struct address_space *mapping,
>  		page = __page_cache_alloc(gfp_mask);
>  		if (!page)
>  			break;
> -		page->index = page_offset;
> +		page->index = index + i;
>  		list_add(&page->lru, &page_pool);
>  		if (i == nr_to_read - lookahead_size)
>  			SetPageReadahead(page);
> 
