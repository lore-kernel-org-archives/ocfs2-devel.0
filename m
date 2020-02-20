From: Matthew Wilcox <willy@infradead.org>
Date: Thu, 20 Feb 2020 08:57:34 -0800
Subject: [Ocfs2-devel] [PATCH v7 22/24] iomap: Convert from readpages to
	readahead
In-Reply-To: <20200220154912.GC19577@infradead.org>
References: <20200219210103.32400-1-willy@infradead.org>
	<20200219210103.32400-23-willy@infradead.org>
	<20200220154912.GC19577@infradead.org>
Message-ID: <20200220165734.GZ24185@bombadil.infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On Thu, Feb 20, 2020 at 07:49:12AM -0800, Christoph Hellwig wrote:
> > +/**
> > + * iomap_readahead - Attempt to read pages from a file.
> > + * @rac: Describes the pages to be read.
> > + * @ops: The operations vector for the filesystem.
> > + *
> > + * This function is for filesystems to call to implement their readahead
> > + * address_space operation.
> > + *
> > + * Context: The file is pinned by the caller, and the pages to be read are
> > + * all locked and have an elevated refcount.  This function will unlock
> > + * the pages (once I/O has completed on them, or I/O has been determined to
> > + * not be necessary).  It will also decrease the refcount once the pages
> > + * have been submitted for I/O.  After this point, the page may be removed
> > + * from the page cache, and should not be referenced.
> > + */
> 
> Isn't the context documentation something that belongs into the aop
> documentation?  I've never really seen the value of duplicating this
> information in method instances, as it is just bound to be out of date
> rather sooner than later.

I'm in two minds about it as well.  There's definitely no value in
providing kernel-doc for implementations of a common interface ... so
rather than fixing the nilfs2 kernel-doc, I just deleted it.  But this
isn't just the implementation, like nilfs2_readahead() is, it's a library
function for filesystems to call, so it deserves documentation.  On the
other hand, there's no real thought to this on the part of the filesystem;
the implementation just calls this with the appropriate ops pointer.

Then again, I kind of feel like we need more documentation of iomap to
help filesystems convert to using it.  But maybe kernel-doc isn't the
mechanism to provide that.
