From: Matthew Wilcox <willy@infradead.org>
Date: Tue, 18 Feb 2020 21:22:30 -0800
Subject: [Ocfs2-devel] [PATCH v6 19/19] mm: Use memalloc_nofs_save in
	readahead path
In-Reply-To: <20200219034324.GG10776@dread.disaster.area>
References: <20200217184613.19668-1-willy@infradead.org>
	<20200217184613.19668-33-willy@infradead.org>
	<20200219034324.GG10776@dread.disaster.area>
Message-ID: <20200219052230.GM24185@bombadil.infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>, Michal Hocko <mhocko@suse.com>

On Wed, Feb 19, 2020 at 02:43:24PM +1100, Dave Chinner wrote:
> On Mon, Feb 17, 2020 at 10:46:13AM -0800, Matthew Wilcox wrote:
> > From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> > 
> > Ensure that memory allocations in the readahead path do not attempt to
> > reclaim file-backed pages, which could lead to a deadlock.  It is
> > possible, though unlikely this is the root cause of a problem observed
> > by Cong Wang.
> > 
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Reported-by: Cong Wang <xiyou.wangcong@gmail.com>
> > Suggested-by: Michal Hocko <mhocko@suse.com>
> > ---
> >  mm/readahead.c | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > diff --git a/mm/readahead.c b/mm/readahead.c
> > index 94d499cfb657..8f9c0dba24e7 100644
> > --- a/mm/readahead.c
> > +++ b/mm/readahead.c
> > @@ -22,6 +22,7 @@
> >  #include <linux/mm_inline.h>
> >  #include <linux/blk-cgroup.h>
> >  #include <linux/fadvise.h>
> > +#include <linux/sched/mm.h>
> >  
> >  #include "internal.h"
> >  
> > @@ -174,6 +175,18 @@ void page_cache_readahead_limit(struct address_space *mapping,
> >  		._nr_pages = 0,
> >  	};
> >  
> > +	/*
> > +	 * Partway through the readahead operation, we will have added
> > +	 * locked pages to the page cache, but will not yet have submitted
> > +	 * them for I/O.  Adding another page may need to allocate memory,
> > +	 * which can trigger memory reclaim.  Telling the VM we're in
> > +	 * the middle of a filesystem operation will cause it to not
> > +	 * touch file-backed pages, preventing a deadlock.  Most (all?)
> > +	 * filesystems already specify __GFP_NOFS in their mapping's
> > +	 * gfp_mask, but let's be explicit here.
> > +	 */
> > +	unsigned int nofs = memalloc_nofs_save();
> > +
> 
> So doesn't this largely remove the need for all the gfp flag futzing
> in the readahead path? i.e. almost all readahead allocations are now
> going to be GFP_NOFS | GFP_NORETRY | GFP_NOWARN ?

I don't think it ensures the GFP_NORETRY | GFP_NOWARN, just the GFP_NOFS
part.  IOW, we'll still need a readahead_gfp() macro at some point ... I
don't want to add that to this already large series though.

Michal also wants to kill mapping->gfp_mask, btw.
