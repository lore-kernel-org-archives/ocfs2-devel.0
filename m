From: Christoph Hellwig <hch@lst.de>
Date: Tue Jun 22 06:51:55 2004
Subject: [Ocfs2-devel] [PATCH] fixup journal-related ifdef mess
In-Reply-To: <20040622004806.GF1771@ca-server1.us.oracle.com>
References: <20040620144000.GB16073@lst.de>
	<20040622004806.GF1771@ca-server1.us.oracle.com>
Message-ID: <20040622114842.GA14441@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jun 21, 2004 at 05:48:06PM -0700, Mark Fasheh wrote:
> Thanks for all the patches so far.
> 
> (This patch has been committed, but before I could take a look at it)
> 
> What's wrong with how this was done before?
> 
> I agree with the goal of reducing code clutter, and making it easier to be
> a  2.6 file system, so why can't we do ext3 style thin wrappers around those
> functions (look at ext3_jbd.h to see what I'm going for) instead of doing
> things like 
> 
> > +#define journal_start(journal, nblocks)      \
> > +     ocfs_journal_start(journal, nblocks)
> > +#define journal_stop(handle) \
> > +     ocfs_journal_stop(handle)
> 
> which winds up defining a macro with the same name as a function (blech! ;)
> 
> Of course, ext3 had some other reasons for doing it that way too, but it
> seemed to me to be a bit more obvious...

Just using the latest kernel release native function is the cleanest
approach imho, wrappers just obsfucate the code.  I don't think this is
documented anywhere.
