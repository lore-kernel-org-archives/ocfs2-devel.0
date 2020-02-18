From: John Hubbard <jhubbard@nvidia.com>
Date: Tue, 18 Feb 2020 14:33:19 -0800
Subject: [Ocfs2-devel] [PATCH v6 04/19] mm: Rearrange readahead loop
In-Reply-To: <20200217184613.19668-5-willy@infradead.org>
References: <20200217184613.19668-1-willy@infradead.org>
	<20200217184613.19668-5-willy@infradead.org>
Message-ID: <6ecedc28-a999-8673-e4b1-349b0c23fdfd@nvidia.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On 2/17/20 10:45 AM, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> Move the declaration of 'page' to inside the loop and move the 'kick
> off a fresh batch' code to the end of the function for easier use in
> subsequent patches.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  mm/readahead.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/readahead.c b/mm/readahead.c
> index 15329309231f..3eca59c43a45 100644
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -154,7 +154,6 @@ void __do_page_cache_readahead(struct address_space *mapping,
>  		unsigned long lookahead_size)
>  {
>  	struct inode *inode = mapping->host;
> -	struct page *page;
>  	unsigned long end_index;	/* The last page we want to read */
>  	LIST_HEAD(page_pool);
>  	int page_idx;
> @@ -175,6 +174,7 @@ void __do_page_cache_readahead(struct address_space *mapping,
>  	 * Preallocate as many pages as we will need.
>  	 */
>  	for (page_idx = 0; page_idx < nr_to_read; page_idx++) {
> +		struct page *page;
>  		pgoff_t page_offset = offset + page_idx;
>  
>  		if (page_offset > end_index)
> @@ -183,14 +183,14 @@ void __do_page_cache_readahead(struct address_space *mapping,
>  		page = xa_load(&mapping->i_pages, page_offset);
>  		if (page && !xa_is_value(page)) {
>  			/*
> -			 * Page already present?  Kick off the current batch of
> -			 * contiguous pages before continuing with the next
> -			 * batch.
> +			 * Page already present?  Kick off the current batch
> +			 * of contiguous pages before continuing with the
> +			 * next batch.  This page may be the one we would
> +			 * have intended to mark as Readahead, but we don't
> +			 * have a stable reference to this page, and it's
> +			 * not worth getting one just for that.
>  			 */
> -			if (readahead_count(&rac))
> -				read_pages(&rac, &page_pool, gfp_mask);
> -			rac._nr_pages = 0;
> -			continue;


A fine point:  you'll get better readability and a less complex function by
factoring that into a static subroutine, instead of jumping around with 
goto's. (This clearly wants to be a subroutine, and in fact you've effectively 
created one inside this function, at the "read:" label. Either way, though...


> +			goto read;
>  		}
>  
>  		page = __page_cache_alloc(gfp_mask);
> @@ -201,6 +201,11 @@ void __do_page_cache_readahead(struct address_space *mapping,
>  		if (page_idx == nr_to_read - lookahead_size)
>  			SetPageReadahead(page);
>  		rac._nr_pages++;
> +		continue;
> +read:
> +		if (readahead_count(&rac))
> +			read_pages(&rac, &page_pool, gfp_mask);
> +		rac._nr_pages = 0;
>  	}
>  
>  	/*
> 

...no errors spotted, I'm confident that this patch is correct,

    Reviewed-by: John Hubbard <jhubbard@nvidia.com>


thanks,
-- 
John Hubbard
NVIDIA
