From: Dave Chinner <david@fromorbit.com>
Date: Mon, 8 Feb 2016 17:17:31 +1100
Subject: [Ocfs2-devel] [PATCH 2/3] xfs: don't use ioends for direct
	write completions
In-Reply-To: <20160208010026.GL31407@dastard>
References: <1454524816-11392-1-git-send-email-hch@lst.de>
	<1454524816-11392-3-git-send-email-hch@lst.de>
	<20160208010026.GL31407@dastard>
Message-ID: <20160208061731.GC27429@dastard>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Mon, Feb 08, 2016 at 12:00:26PM +1100, Dave Chinner wrote:
> On Wed, Feb 03, 2016 at 07:40:15PM +0100, Christoph Hellwig wrote:
> > We only need to communicate two bits of information to the direct I/O
> > completion handler:
> > 
> >  (1) do we need to convert any unwritten extents in the range
> >  (2) do we need to check if we need to update the inode size based
> >      on the range passed to the completion handler
> > 
> > We can use the private data passed to the get_block handler and the
> > completion handler as a simple bitmask to communicate this information
> > instead of the current complicated infrastructure reusing the ioends
> > from the buffer I/O path, and thus avoiding a memory allocation and
> > a context switch for any non-trivial direct write.  As a nice side
> > effect we also decouple the direct I/O path implementation from that
> > of the buffered I/O path.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> This change is now dependent on the preceeding direct IO API
> changes. Do I a) take the DIO API change through the XFS tree, or
> b) use the older version of the patch that didn't have this
> dependency and let somebody else deal with the API change and merge
> issues?
> 
> I'm happy to take the DIO API change through the XFS tree, if that's
> the fastest/easiest way to get the necessary DIO subsystem fixes
> into the mainline tree for XFS. As such, the for-next tree that I'm
> building right now will include the DIO API change patch....

Right now this series is in a stable branch in the XFS tree:

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git xfs-dio-fix-4.6

If you want to push it through some other tree, please let me know
when/where it is committed so I can rebuild the XFS for-next branch
appropriately from a stable commit/branch...

Cheers,

Dave.
-- 
Dave Chinner
david at fromorbit.com
