From: Dave Chinner <david@fromorbit.com>
Date: Wed, 19 Feb 2020 08:26:52 +1100
Subject: [Ocfs2-devel] [PATCH v6 00/19] Change readahead API
In-Reply-To: <20200218134230.GN7778@bombadil.infradead.org>
References: <20200217184613.19668-1-willy@infradead.org>
	<20200218045633.GH10776@dread.disaster.area>
	<20200218134230.GN7778@bombadil.infradead.org>
Message-ID: <20200218212652.GR10776@dread.disaster.area>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On Tue, Feb 18, 2020 at 05:42:30AM -0800, Matthew Wilcox wrote:
> On Tue, Feb 18, 2020 at 03:56:33PM +1100, Dave Chinner wrote:
> > Latest version in your git tree:
> > 
> > $ ? glo -n 5 willy/readahead
> > 4be497096c04 mm: Use memalloc_nofs_save in readahead path
> > ff63497fcb98 iomap: Convert from readpages to readahead
> > 26aee60e89b5 iomap: Restructure iomap_readpages_actor
> > 8115bcca7312 fuse: Convert from readpages to readahead
> > 3db3d10d9ea1 f2fs: Convert from readpages to readahead
> > $
> > 
> > merged into a 5.6-rc2 tree fails at boot on my test vm:
> > 
> > [    2.423116] ------------[ cut here ]------------
> > [    2.424957] list_add double add: new=ffffea000efff4c8, prev=ffff8883bfffee60, next=ffffea000efff4c8.
> > [    2.428259] WARNING: CPU: 4 PID: 1 at lib/list_debug.c:29 __list_add_valid+0x67/0x70
> > [    2.457484] Call Trace:
> > [    2.458171]  __pagevec_lru_add_fn+0x15f/0x2c0
> > [    2.459376]  pagevec_lru_move_fn+0x87/0xd0
> > [    2.460500]  ? pagevec_move_tail_fn+0x2d0/0x2d0
> > [    2.461712]  lru_add_drain_cpu+0x8d/0x160
> > [    2.462787]  lru_add_drain+0x18/0x20
> 
> Are you sure that was 4be497096c04 ?  I ask because there was a

Yes, because it's the only version I've actually merged into my
working tree, compiled and tried to run. :P

> version pushed to that git tree that did contain a list double-add
> (due to a mismerge when shuffling patches).  I noticed it and fixed
> it, and 4be497096c04 doesn't have that problem.  I also test with
> CONFIG_DEBUG_LIST turned on, but this problem you hit is going to be
> probabilistic because it'll depend on the timing between whatever other
> list is being used and the page actually being added to the LRU.

I'll see if I can reproduce it.

Cheers,

Dave.
-- 
Dave Chinner
david at fromorbit.com
