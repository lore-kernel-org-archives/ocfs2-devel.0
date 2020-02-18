From: Dave Chinner <david@fromorbit.com>
Date: Tue, 18 Feb 2020 17:31:10 +1100
Subject: [Ocfs2-devel] [PATCH v6 09/19] mm: Add
	page_cache_readahead_limit
In-Reply-To: <20200217184613.19668-16-willy@infradead.org>
References: <20200217184613.19668-1-willy@infradead.org>
	<20200217184613.19668-16-willy@infradead.org>
Message-ID: <20200218063110.GO10776@dread.disaster.area>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On Mon, Feb 17, 2020 at 10:45:56AM -0800, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> ext4 and f2fs have duplicated the guts of the readahead code so
> they can read past i_size.  Instead, separate out the guts of the
> readahead code so they can call it directly.

Gross and nasty (hosting non-stale data beyond EOF in the page
cache, that is).

Code is pretty simple, but...

>  }
>  
> -/*
> - * __do_page_cache_readahead() actually reads a chunk of disk.  It allocates
> - * the pages first, then submits them for I/O. This avoids the very bad
> - * behaviour which would occur if page allocations are causing VM writeback.
> - * We really don't want to intermingle reads and writes like that.
> +/**
> + * page_cache_readahead_limit - Start readahead beyond a file's i_size.
> + * @mapping: File address space.
> + * @file: This instance of the open file; used for authentication.
> + * @offset: First page index to read.
> + * @end_index: The maximum page index to read.
> + * @nr_to_read: The number of pages to read.
> + * @lookahead_size: Where to start the next readahead.
> + *
> + * This function is for filesystems to call when they want to start
> + * readahead potentially beyond a file's stated i_size.  If you want
> + * to start readahead on a normal file, you probably want to call
> + * page_cache_async_readahead() or page_cache_sync_readahead() instead.
> + *
> + * Context: File is referenced by caller.  Mutexes may be held by caller.
> + * May sleep, but will not reenter filesystem to reclaim memory.
>   */
> -void __do_page_cache_readahead(struct address_space *mapping,
> -		struct file *filp, pgoff_t offset, unsigned long nr_to_read,
> -		unsigned long lookahead_size)
> +void page_cache_readahead_limit(struct address_space *mapping,

... I don't think the function name conveys it's purpose. It's
really a ranged readahead that ignores where i_size lies. i.e

	page_cache_readahead_range(mapping, start, end, nr_to_read)

seems like a better API to me, and then you can drop the "start
readahead beyond i_size" comments and replace it with "Range is not
limited by the inode's i_size and hence can be used to read data
stored beyond EOF into the page cache."

Also: "This is almost certainly not the function you want to call.
Use page_cache_async_readahead or page_cache_sync_readahead()
instead."

Cheers,

Dave.
-- 
Dave Chinner
david at fromorbit.com
