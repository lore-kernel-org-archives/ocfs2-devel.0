From: Matthew Wilcox <willy@infradead.org>
Date: Tue, 14 Apr 2020 19:18:08 -0700
Subject: [Ocfs2-devel] [PATCH v11 05/25] mm: Add new readahead_control
	API
In-Reply-To: <20200414181705.bfc4c0087092051a9475141e@linux-foundation.org>
References: <20200414150233.24495-1-willy@infradead.org>
	<20200414150233.24495-6-willy@infradead.org>
	<20200414181705.bfc4c0087092051a9475141e@linux-foundation.org>
Message-ID: <20200415021808.GA5820@bombadil.infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, William Kucharski <william.kucharski@oracle.com>

On Tue, Apr 14, 2020 at 06:17:05PM -0700, Andrew Morton wrote:
> On Tue, 14 Apr 2020 08:02:13 -0700 Matthew Wilcox <willy@infradead.org> wrote:
> > From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> > 
> > Filesystems which implement the upcoming ->readahead method will get
> > their pages by calling readahead_page() or readahead_page_batch().
> > These functions support large pages, even though none of the filesystems
> > to be converted do yet.
> > 
> > +static inline struct page *readahead_page(struct readahead_control *rac)
> > +static inline unsigned int __readahead_batch(struct readahead_control *rac,
> > +		struct page **array, unsigned int array_sz)
> 
> These are large functions.  Was it correct to inline them?

Hmm.  They don't seem that big to me.

readahead_page, stripped of its sanity checks:

+       rac->_nr_pages -= rac->_batch_count;
+       rac->_index += rac->_batch_count;
+       if (!rac->_nr_pages) {
+               rac->_batch_count = 0;
+               return NULL;
+       }
+       page = xa_load(&rac->mapping->i_pages, rac->_index);
+       rac->_batch_count = hpage_nr_pages(page);

__readahead_batch is much bigger, but it's only used by btrfs and fuse,
and it seemed unfair to make everybody pay the cost for a function only
used by two filesystems.

> The batching API only appears to be used by fuse?  If so, do we really
> need it?  Does it provide some functional need, or is it a performance
> thing?  If the latter, how significant is it?

I must confess to not knowing the performance impact.  If the code uses
xa_load() repeatedly, it costs O(log n) each time as we walk down the tree
(mitigated to a large extent by cache, of course).  Using xas_for_each()
keeps us at the bottom of the tree and each iteration is O(1).
I'm interested to see if filesystem maintainers start to use the batch
function or if they're happier sticking with the individual lookups.

The batch API was originally written for use with btrfs, but it was a
significant simplification to convert fuse to use it.

> The code adds quite a few (inlined!) VM_BUG_ONs.  Can we plan to remove
> them at some stage?  Such as, before Linus shouts at us :)

I'd be happy to remove them.  Various reviewers said things like "are you
sure this can't happen?"
