From: Eric Biggers <ebiggers@kernel.org>
Date: Fri, 20 Mar 2020 09:58:28 -0700
Subject: [Ocfs2-devel] [PATCH v9 12/25] mm: Move end_index check out of
	readahead loop
In-Reply-To: <20200320142231.2402-13-willy@infradead.org>
References: <20200320142231.2402-1-willy@infradead.org>
	<20200320142231.2402-13-willy@infradead.org>
Message-ID: <20200320165828.GB851@sol.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 20, 2020 at 07:22:18AM -0700, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> By reducing nr_to_read, we can eliminate this check from inside the loop.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: John Hubbard <jhubbard@nvidia.com>
> Reviewed-by: William Kucharski <william.kucharski@oracle.com>
> ---
>  mm/readahead.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/readahead.c b/mm/readahead.c
> index d01531ef9f3c..a37b68f66233 100644
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -167,8 +167,6 @@ void __do_page_cache_readahead(struct address_space *mapping,
>  		unsigned long lookahead_size)
>  {
>  	struct inode *inode = mapping->host;
> -	struct page *page;
> -	unsigned long end_index;	/* The last page we want to read */
>  	LIST_HEAD(page_pool);
>  	loff_t isize = i_size_read(inode);
>  	gfp_t gfp_mask = readahead_gfp_mask(mapping);
> @@ -178,22 +176,29 @@ void __do_page_cache_readahead(struct address_space *mapping,
>  		._index = index,
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
> +	/* Avoid wrapping to the beginning of the file */
> +	if (index + nr_to_read < index)
> +		nr_to_read = ULONG_MAX - index + 1;
> +	/* Don't read past the page containing the last byte of the file */
> +	if (index + nr_to_read >= end_index)
> +		nr_to_read = end_index - index + 1;

There seem to be a couple off-by-one errors here.  Shouldn't it be:

	/* Avoid wrapping to the beginning of the file */
	if (index + nr_to_read < index)
		nr_to_read = ULONG_MAX - index;
	/* Don't read past the page containing the last byte of the file */
	if (index + nr_to_read > end_index)
		nr_to_read = end_index - index + 1;

I.e., 'ULONG_MAX - index' rather than 'ULONG_MAX - index + 1', so that
'index + nr_to_read' is then ULONG_MAX rather than overflowed to 0.

Then 'index + nr_to_read > end_index' rather 'index + nr_to_read >= end_index',
since otherwise nr_to_read can be increased by 1 rather than decreased or stay
the same as expected.

- Eric
