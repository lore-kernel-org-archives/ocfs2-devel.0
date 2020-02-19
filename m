From: Dave Chinner <david@fromorbit.com>
Date: Wed, 19 Feb 2020 12:08:40 +1100
Subject: [Ocfs2-devel] [PATCH v6 09/19] mm: Add
	page_cache_readahead_limit
In-Reply-To: <20200218195404.GD24185@bombadil.infradead.org>
References: <20200217184613.19668-1-willy@infradead.org>
	<20200217184613.19668-16-willy@infradead.org>
	<20200218063110.GO10776@dread.disaster.area>
	<20200218195404.GD24185@bombadil.infradead.org>
Message-ID: <20200219010840.GX10776@dread.disaster.area>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On Tue, Feb 18, 2020 at 11:54:04AM -0800, Matthew Wilcox wrote:
> On Tue, Feb 18, 2020 at 05:31:10PM +1100, Dave Chinner wrote:
> > On Mon, Feb 17, 2020 at 10:45:56AM -0800, Matthew Wilcox wrote:
> > > From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> > > 
> > > ext4 and f2fs have duplicated the guts of the readahead code so
> > > they can read past i_size.  Instead, separate out the guts of the
> > > readahead code so they can call it directly.
> > 
> > Gross and nasty (hosting non-stale data beyond EOF in the page
> > cache, that is).
> 
> I thought you meant sneaking changes into the VFS (that were rejected) by
> copying VFS code and modifying it ...

Well, now that you mention it... :P

> > > +/**
> > > + * page_cache_readahead_limit - Start readahead beyond a file's i_size.
> > > + * @mapping: File address space.
> > > + * @file: This instance of the open file; used for authentication.
> > > + * @offset: First page index to read.
> > > + * @end_index: The maximum page index to read.
> > > + * @nr_to_read: The number of pages to read.
> > > + * @lookahead_size: Where to start the next readahead.
> > > + *
> > > + * This function is for filesystems to call when they want to start
> > > + * readahead potentially beyond a file's stated i_size.  If you want
> > > + * to start readahead on a normal file, you probably want to call
> > > + * page_cache_async_readahead() or page_cache_sync_readahead() instead.
> > > + *
> > > + * Context: File is referenced by caller.  Mutexes may be held by caller.
> > > + * May sleep, but will not reenter filesystem to reclaim memory.
> > >   */
> > > -void __do_page_cache_readahead(struct address_space *mapping,
> > > -		struct file *filp, pgoff_t offset, unsigned long nr_to_read,
> > > -		unsigned long lookahead_size)
> > > +void page_cache_readahead_limit(struct address_space *mapping,
> > 
> > ... I don't think the function name conveys it's purpose. It's
> > really a ranged readahead that ignores where i_size lies. i.e
> > 
> > 	page_cache_readahead_range(mapping, start, end, nr_to_read)
> > 
> > seems like a better API to me, and then you can drop the "start
> > readahead beyond i_size" comments and replace it with "Range is not
> > limited by the inode's i_size and hence can be used to read data
> > stored beyond EOF into the page cache."
> 
> I'm concerned that calling it 'range' implies "I want to read between
> start and end" rather than "I want to read nr_to_read at start, oh but
> don't go past end".
> 
> Maybe the right way to do this is have the three callers cap nr_to_read.
> Well, the one caller ... after all, f2fs and ext4 have no desire to
> cap the length.  Then we can call it page_cache_readahead_exceed() or
> page_cache_readahead_dangerous() or something else like that to make it
> clear that you shouldn't be calling it.

Fair point.

And in reading this, it occurred to me that what we are enabling is
an "out of bounds" readahead function. so
page_cache_readahead_OOB() or *_unbounded() might be a better name....

>   * Like add_to_page_cache_locked, but used to add newly allocated pages:
> diff --git a/mm/readahead.c b/mm/readahead.c
> index 9dd431fa16c9..cad26287ad8b 100644
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -142,45 +142,43 @@ static void read_pages(struct readahead_control *rac, struct list_head *pages)
>  	blk_finish_plug(&plug);
>  }
>  
> -/*
> - * __do_page_cache_readahead() actually reads a chunk of disk.  It allocates
> - * the pages first, then submits them for I/O. This avoids the very bad
> - * behaviour which would occur if page allocations are causing VM writeback.
> - * We really don't want to intermingle reads and writes like that.
> +/**
> + * page_cache_readahead_exceed - Start unchecked readahead.
> + * @mapping: File address space.
> + * @file: This instance of the open file; used for authentication.
> + * @index: First page index to read.
> + * @nr_to_read: The number of pages to read.
> + * @lookahead_size: Where to start the next readahead.
> + *
> + * This function is for filesystems to call when they want to start
> + * readahead beyond a file's stated i_size.  This is almost certainly
> + * not the function you want to call.  Use page_cache_async_readahead()
> + * or page_cache_sync_readahead() instead.
> + *
> + * Context: File is referenced by caller.  Mutexes may be held by caller.
> + * May sleep, but will not reenter filesystem to reclaim memory.

Yup, looks much better.

Cheers,

Dave.
-- 
Dave Chinner
david at fromorbit.com
