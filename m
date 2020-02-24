From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Mon, 24 Feb 2020 08:52:44 -0800
Subject: [Ocfs2-devel] [PATCH v7 22/24] iomap: Convert from readpages to
	readahead
In-Reply-To: <20200224043355.GL24185@bombadil.infradead.org>
References: <20200219210103.32400-1-willy@infradead.org>
	<20200219210103.32400-23-willy@infradead.org>
	<20200220154912.GC19577@infradead.org>
	<20200220165734.GZ24185@bombadil.infradead.org>
	<20200222010013.GH9506@magnolia>
	<20200224043355.GL24185@bombadil.infradead.org>
Message-ID: <20200224165244.GA6731@magnolia>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On Sun, Feb 23, 2020 at 08:33:55PM -0800, Matthew Wilcox wrote:
> On Fri, Feb 21, 2020 at 05:00:13PM -0800, Darrick J. Wong wrote:
> > On Thu, Feb 20, 2020 at 08:57:34AM -0800, Matthew Wilcox wrote:
> > > On Thu, Feb 20, 2020 at 07:49:12AM -0800, Christoph Hellwig wrote:
> > > +/**
> > > + * iomap_readahead - Attempt to read pages from a file.
> > > + * @rac: Describes the pages to be read.
> > > + * @ops: The operations vector for the filesystem.
> > > + *
> > > + * This function is for filesystems to call to implement their readahead
> > > + * address_space operation.
> > > + *
> > > + * Context: The file is pinned by the caller, and the pages to be read are
> > > + * all locked and have an elevated refcount.  This function will unlock
> > > + * the pages (once I/O has completed on them, or I/O has been determined to
> > > + * not be necessary).  It will also decrease the refcount once the pages
> > > + * have been submitted for I/O.  After this point, the page may be removed
> > > + * from the page cache, and should not be referenced.
> > > + */
> > > 
> > > > Isn't the context documentation something that belongs into the aop
> > > > documentation?  I've never really seen the value of duplicating this
> > > > information in method instances, as it is just bound to be out of date
> > > > rather sooner than later.
> > > 
> > > I'm in two minds about it as well.  There's definitely no value in
> > > providing kernel-doc for implementations of a common interface ... so
> > > rather than fixing the nilfs2 kernel-doc, I just deleted it.  But this
> > > isn't just the implementation, like nilfs2_readahead() is, it's a library
> > > function for filesystems to call, so it deserves documentation.  On the
> > > other hand, there's no real thought to this on the part of the filesystem;
> > > the implementation just calls this with the appropriate ops pointer.
> > > 
> > > Then again, I kind of feel like we need more documentation of iomap to
> > > help filesystems convert to using it.  But maybe kernel-doc isn't the
> > > mechanism to provide that.
> > 
> > I think we need more documentation of the parts of iomap where it can
> > call back into the filesystem (looking at you, iomap_dio_ops).
> > 
> > I'm not opposed to letting this comment stay, though I don't see it as
> > all that necessary since iomap_readahead implements a callout that's
> > documented in vfs.rst and is thus subject to all the constraints listed
> > in the (*readahead) documentation.
> 
> Right.  And that's not currently in kernel-doc format, but should be.
> Something for a different patchset, IMO.
> 
> What we need documenting _here_ is the conditions under which the
> iomap_ops are called so the filesystem author doesn't need to piece them
> together from three different places.  Here's what I currently have:
> 
>  * Context: The @ops callbacks may submit I/O (eg to read the addresses of
>  * blocks from disc), and may wait for it.  The caller may be trying to
>  * access a different page, and so sleeping excessively should be avoided.
>  * It may allocate memory, but should avoid large allocations.  This
>  * function is called with memalloc_nofs set, so allocations will not cause
>  * the filesystem to be reentered.

How large? :)

--D
