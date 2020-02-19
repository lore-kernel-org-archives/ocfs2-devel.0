From: Dave Chinner <david@fromorbit.com>
Date: Wed, 19 Feb 2020 12:04:31 +1100
Subject: [Ocfs2-devel] [PATCH v6 08/19] mm: Add readahead address space
	operation
In-Reply-To: <20200218161004.GR7778@bombadil.infradead.org>
References: <20200217184613.19668-1-willy@infradead.org>
	<20200217184613.19668-14-willy@infradead.org>
	<20200218062147.GN10776@dread.disaster.area>
	<20200218161004.GR7778@bombadil.infradead.org>
Message-ID: <20200219010431.GW10776@dread.disaster.area>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On Tue, Feb 18, 2020 at 08:10:04AM -0800, Matthew Wilcox wrote:
> On Tue, Feb 18, 2020 at 05:21:47PM +1100, Dave Chinner wrote:
> > On Mon, Feb 17, 2020 at 10:45:54AM -0800, Matthew Wilcox wrote:
> > > From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> > > 
> > > This replaces ->readpages with a saner interface:
> > >  - Return void instead of an ignored error code.
> > >  - Pages are already in the page cache when ->readahead is called.
> > 
> > Might read better as:
> > 
> >  - Page cache is already populates with locked pages when
> >    ->readahead is called.
> 
> Will do.
> 
> > >  - Implementation looks up the pages in the page cache instead of
> > >    having them passed in a linked list.
> > 
> > Add:
> > 
> >  - cleanup of unused readahead handled by ->readahead caller, not
> >    the method implementation.
> 
> The readpages caller does that cleanup too, so it's not an advantage
> to the readahead interface.

Right. I kinda of read the list as "the reasons the new API is sane"
not as "how readahead is different to readpages"....

> > >  ``readpages``
> > >  	called by the VM to read pages associated with the address_space
> > >  	object.  This is essentially just a vector version of readpage.
> > >  	Instead of just one page, several pages are requested.
> > >  	readpages is only used for read-ahead, so read errors are
> > >  	ignored.  If anything goes wrong, feel free to give up.
> > > +	This interface is deprecated; implement readahead instead.
> > 
> > What is the removal schedule for the deprecated interface? 
> 
> I mentioned that in the cover letter; once Dave Howells has the fscache
> branch merged, I'll do the remaining filesystems.  Should be within the
> next couple of merge windows.

Sure, but I like to see actual release tags with the deprecation
notice so that it's obvious to the reader as to whether this is
something new and/or when they can expect it to go away.

> > > +/* The byte offset into the file of this readahead block */
> > > +static inline loff_t readahead_offset(struct readahead_control *rac)
> > > +{
> > > +	return (loff_t)rac->_start * PAGE_SIZE;
> > > +}
> > 
> > Urk. Didn't an early page use "offset" for the page index? That
> > was was "mm: Remove 'page_offset' from readahead loop" did, right?
> > 
> > That's just going to cause confusion to have different units for
> > readahead "offsets"....
> 
> We are ... not consistent anywhere in the VM/VFS with our naming.
> Unfortunately.
> 
> $ grep -n offset mm/filemap.c 
> 391: * @start:	offset in bytes where the range starts
> ...
> 815:	pgoff_t offset = old->index;
> ...
> 2020:	unsigned long offset;      /* offset into pagecache page */
> ...
> 2257:	*ppos = ((loff_t)index << PAGE_SHIFT) + offset;
> 
> That last one's my favourite.  Not to mention the fine distinction you
> and I discussed recently between offset_in_page() and page_offset().
> 
> Best of all, even our types encode the ambiguity of an 'offset'.  We have
> pgoff_t and loff_t (replacing the earlier off_t).
> 
> So, new rule.  'pos' is the number of bytes into a file.  'index' is the
> number of PAGE_SIZE pages into a file.  We don't use the word 'offset'
> at all.  'length' as a byte count and 'count' as a page count seem like
> fine names to me.

That sounds very reasonable to me. Another patchset in the making? :)

Cheers,

Dave.
-- 
Dave Chinner
david at fromorbit.com
