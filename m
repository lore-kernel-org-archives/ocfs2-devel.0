From: Dave Chinner <david@fromorbit.com>
Date: Tue, 29 Jun 2010 10:24:21 +1000
Subject: [Ocfs2-devel] [PATCH] Revert "writeback: limit
 write_cache_pages integrity scanning to current EOF"
In-Reply-To: <20100628173529.GA10573@mail.oracle.com>
References: <20100628173529.GA10573@mail.oracle.com>
Message-ID: <20100629002421.GY6590@dastard>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Tao Ma <tao.ma@oracle.com>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>

On Mon, Jun 28, 2010 at 10:35:29AM -0700, Joel Becker wrote:
> This reverts commit d87815cb2090e07b0b0b2d73dc9740706e92c80c.

Hi Joel,

I have no problems with it being reverted - it's a really just a
WAR for the simplest case of the sync hold holdoff.

However, I had no idea that any filesystem relied on being able to
write pages beyond EOF, and I'd like to understand the implications
of it on the higher level code and, more importantly, understand how
the writes are getting to disk through multiple layers of
page-beyond-i_size checks in the writeback code....

> This patch causes any filesystem with an allocation unit larger than the
> filesystem blocksize will leak unzeroed data. During a file extend, the
> entire allocation unit is zeroed.

XFS has this same underlying issue - it can have uninitialised,
allocated blocks past EOF that have to be zeroed when extending the
file.

> However, this patch prevents the tail
> blocks of the allocation unit from being written back to disk.  When the
> file is next extended, i_size will now cover these unzeroed blocks,
> leaking the old contents of the disk to userspace and creating a corrupt
> file.

XFS doesn't zero blocks at allocation. Instead, XFS zeros the range
between the old EOF and the new EOF on each extending write. Hence
these pages get written because they fall inside the new i_size that
is set during the write.  The i_size on disk doesn't get changed
until after the data writes have completed, so even on a crash we
don't expose uninitialised blocks.

> This affects ocfs2 directly.  As Tao Ma mentioned in his reporting
> email:
> 
> 1. all the place we use filemap_fdatawrite in ocfs2 doesn't flush pages
> after i_size now.
> 2. sync, fsync, fdatasync and umount don't flush pages after i_size(they
> are called from writeback_single_inode).

I'm not sure this was ever supposed to work - my understanding is
that we should never do anything with pages beyong i_size as pages
beyond EOF as being beyond i_size implies we are racing with a
truncate and the page is no longer valid. In that case, we should
definitely not write it back to disk.

Looking at ocfs2_writepage(), it simply calls
block_write_full_page(), which does:

	/* Is the page fully outside i_size? (truncate in progress) */
	offset = i_size & (PAGE_CACHE_SIZE-1);
	if (page->index >= end_index+1 || !offset) {
		/*
		 * The page may have dirty, unmapped buffers.  For example,
		 * they may have been added in ext3_writepage().  Make them
		 * freeable here, so the page does not leak.
		 */
		do_invalidatepage(page, 0);
		unlock_page(page);
		return 0; /* don't care */
	}

i.e. pages beyond EOF get invalidated.  If it somehow gets through
that check, __block_write_full_page() will avoid writing dirty
bufferheads beyond EOF because the write is "racing with truncate".

Hence there are multiple layers of protection against writing past
i_size, so I'm wondering how these pages are even getting to disk in
the first place....

> 3. reflink have a BUG_ON triggered because we have some dirty pages
> while during CoW. http://oss.oracle.com/bugzilla/show_bug.cgi?id=1265

I'd suggest that the reason you see the BUG_ON() with this patch is
that the pages beyond EOF are not being invalidated because they are
not being passed to ->writepage and hence are remaining dirty in the
cache.  IOWs, I suspect that this commit has uncovered a bug in
ocfs2, not that it has caused a regression.

Your thoughts, Joel?

Cheers,

Dave.
-- 
Dave Chinner
david at fromorbit.com
