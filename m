From: Matthew Wilcox <willy@infradead.org>
Date: Wed, 15 Apr 2020 04:22:16 -0700
Subject: [Ocfs2-devel] [PATCH v11 05/25] mm: Add new readahead_control
	API
In-Reply-To: <20200414215616.f665d12f8549f52606784d1e@linux-foundation.org>
References: <20200414150233.24495-1-willy@infradead.org>
	<20200414150233.24495-6-willy@infradead.org>
	<20200414181705.bfc4c0087092051a9475141e@linux-foundation.org>
	<20200415021808.GA5820@bombadil.infradead.org>
	<20200414215616.f665d12f8549f52606784d1e@linux-foundation.org>
Message-ID: <20200415112216.GC5820@bombadil.infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, William Kucharski <william.kucharski@oracle.com>

On Tue, Apr 14, 2020 at 09:56:16PM -0700, Andrew Morton wrote:
> On Tue, 14 Apr 2020 19:18:08 -0700 Matthew Wilcox <willy@infradead.org> wrote:
> > Hmm.  They don't seem that big to me.
> 
> They're really big!

v5.7-rc1:	11636	    636	    224	  12496	   30d0	fs/iomap/buffered-io.o
readahead_v11:	11528	    636	    224	  12388	   3064	fs/iomap/buffered-io.o

> > __readahead_batch is much bigger, but it's only used by btrfs and fuse,
> > and it seemed unfair to make everybody pay the cost for a function only
> > used by two filesystems.
> 
> Do we expect more filesystems to use these in the future?

I'm honestly not sure.  I think it'd be nice to be able to fill a bvec
from the page cache directly, but I haven't tried to write that function
yet.  If so, then it'd be appropriate to move that functionality into
the core.

> > > The code adds quite a few (inlined!) VM_BUG_ONs.  Can we plan to remove
> > > them at some stage?  Such as, before Linus shouts at us :)
> > 
> > I'd be happy to remove them.  Various reviewers said things like "are you
> > sure this can't happen?"
> 
> Yeah, these things tend to live for ever.  Please add a todo to remove
> them after the code has matured?

Sure!  I'm touching this code some more in the large pages patch set, so
I can get rid of it there.
