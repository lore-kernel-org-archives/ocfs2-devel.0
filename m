From: John Hubbard <jhubbard@nvidia.com>
Date: Tue, 18 Feb 2020 13:05:29 -0800
Subject: [Ocfs2-devel] [PATCH v6 01/19] mm: Return void from various
	readahead functions
In-Reply-To: <20200217184613.19668-2-willy@infradead.org>
References: <20200217184613.19668-1-willy@infradead.org>
	<20200217184613.19668-2-willy@infradead.org>
Message-ID: <29d2d7ca-7f2b-7eb4-78bc-f2af36c4c426@nvidia.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On 2/17/20 10:45 AM, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> ondemand_readahead has two callers, neither of which use the return value.
> That means that both ra_submit and __do_page_cache_readahead() can return
> void, and we don't need to worry that a present page in the readahead
> window causes us to return a smaller nr_pages than we ought to have.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  mm/internal.h  |  8 ++++----
>  mm/readahead.c | 24 ++++++++++--------------
>  2 files changed, 14 insertions(+), 18 deletions(-)


This is an easy review and obviously correct, so:

    Reviewed-by: John Hubbard <jhubbard@nvidia.com>


Thoughts for the future of the API:

I will add that I could envision another patchset that went in the
opposite direction, and attempted to preserve the information about
how many pages were successfully read ahead. And that would be nice
to have (at least IMHO), even all the way out to the syscall level,
especially for the readahead syscall.

Of course, vague opinions about how the API might be improved are less
pressing than cleaning up the code now--I'm just bringing this up because
I suspect some people will wonder, "wouldn't it be helpful if I the 
syscall would tell me what happened here? Success (returning 0) doesn't
necessarily mean any pages were even read ahead." It just seems worth 
mentioning.


thanks,
-- 
John Hubbard
NVIDIA

> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 3cf20ab3ca01..f779f058118b 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -49,18 +49,18 @@ void unmap_page_range(struct mmu_gather *tlb,
>  			     unsigned long addr, unsigned long end,
>  			     struct zap_details *details);
>  
> -extern unsigned int __do_page_cache_readahead(struct address_space *mapping,
> +extern void __do_page_cache_readahead(struct address_space *mapping,
>  		struct file *filp, pgoff_t offset, unsigned long nr_to_read,
>  		unsigned long lookahead_size);
>  
>  /*
>   * Submit IO for the read-ahead request in file_ra_state.
>   */
> -static inline unsigned long ra_submit(struct file_ra_state *ra,
> +static inline void ra_submit(struct file_ra_state *ra,
>  		struct address_space *mapping, struct file *filp)
>  {
> -	return __do_page_cache_readahead(mapping, filp,
> -					ra->start, ra->size, ra->async_size);
> +	__do_page_cache_readahead(mapping, filp,
> +			ra->start, ra->size, ra->async_size);
>  }
>  
>  /*
> diff --git a/mm/readahead.c b/mm/readahead.c
> index 2fe72cd29b47..8ce46d69e6ae 100644
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -149,10 +149,8 @@ static int read_pages(struct address_space *mapping, struct file *filp,
>   * the pages first, then submits them for I/O. This avoids the very bad
>   * behaviour which would occur if page allocations are causing VM writeback.
>   * We really don't want to intermingle reads and writes like that.
> - *
> - * Returns the number of pages requested, or the maximum amount of I/O allowed.
>   */
> -unsigned int __do_page_cache_readahead(struct address_space *mapping,
> +void __do_page_cache_readahead(struct address_space *mapping,
>  		struct file *filp, pgoff_t offset, unsigned long nr_to_read,
>  		unsigned long lookahead_size)
>  {
> @@ -166,7 +164,7 @@ unsigned int __do_page_cache_readahead(struct address_space *mapping,
>  	gfp_t gfp_mask = readahead_gfp_mask(mapping);
>  
>  	if (isize == 0)
> -		goto out;
> +		return;
>  
>  	end_index = ((isize - 1) >> PAGE_SHIFT);
>  
> @@ -211,8 +209,6 @@ unsigned int __do_page_cache_readahead(struct address_space *mapping,
>  	if (nr_pages)
>  		read_pages(mapping, filp, &page_pool, nr_pages, gfp_mask);
>  	BUG_ON(!list_empty(&page_pool));
> -out:
> -	return nr_pages;
>  }
>  
>  /*
> @@ -378,11 +374,10 @@ static int try_context_readahead(struct address_space *mapping,
>  /*
>   * A minimal readahead algorithm for trivial sequential/random reads.
>   */
> -static unsigned long
> -ondemand_readahead(struct address_space *mapping,
> -		   struct file_ra_state *ra, struct file *filp,
> -		   bool hit_readahead_marker, pgoff_t offset,
> -		   unsigned long req_size)
> +static void ondemand_readahead(struct address_space *mapping,
> +		struct file_ra_state *ra, struct file *filp,
> +		bool hit_readahead_marker, pgoff_t offset,
> +		unsigned long req_size)
>  {
>  	struct backing_dev_info *bdi = inode_to_bdi(mapping->host);
>  	unsigned long max_pages = ra->ra_pages;
> @@ -428,7 +423,7 @@ ondemand_readahead(struct address_space *mapping,
>  		rcu_read_unlock();
>  
>  		if (!start || start - offset > max_pages)
> -			return 0;
> +			return;
>  
>  		ra->start = start;
>  		ra->size = start - offset;	/* old async_size */
> @@ -464,7 +459,8 @@ ondemand_readahead(struct address_space *mapping,
>  	 * standalone, small random read
>  	 * Read as is, and do not pollute the readahead state.
>  	 */
> -	return __do_page_cache_readahead(mapping, filp, offset, req_size, 0);
> +	__do_page_cache_readahead(mapping, filp, offset, req_size, 0);
> +	return;
>  
>  initial_readahead:
>  	ra->start = offset;
> @@ -489,7 +485,7 @@ ondemand_readahead(struct address_space *mapping,
>  		}
>  	}
>  
> -	return ra_submit(ra, mapping, filp);
> +	ra_submit(ra, mapping, filp);
>  }
>  
>  /**
> 
