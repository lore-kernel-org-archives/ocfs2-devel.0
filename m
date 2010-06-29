From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 28 Jun 2010 17:54:04 -0700
Subject: [Ocfs2-devel] [PATCH] Revert "writeback: limit
 write_cache_pages integrity scanning to current EOF"
In-Reply-To: <20100629002421.GY6590@dastard>
References: <20100628173529.GA10573@mail.oracle.com>
	<20100629002421.GY6590@dastard>
Message-ID: <20100629005403.GC24343@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Tao Ma <tao.ma@oracle.com>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>

On Tue, Jun 29, 2010 at 10:24:21AM +1000, Dave Chinner wrote:
> On Mon, Jun 28, 2010 at 10:35:29AM -0700, Joel Becker wrote:
> > This reverts commit d87815cb2090e07b0b0b2d73dc9740706e92c80c.
> 
> Hi Joel,
> 
> I have no problems with it being reverted - it's a really just a
> WAR for the simplest case of the sync hold holdoff.

	I have to insist that we revert it until we find a way to make
ocfs2 work.  The rest of the email will discuss the ocfs2 issues
therein.

> > This patch causes any filesystem with an allocation unit larger than the
> > filesystem blocksize will leak unzeroed data. During a file extend, the
> > entire allocation unit is zeroed.
> 
> XFS has this same underlying issue - it can have uninitialised,
> allocated blocks past EOF that have to be zeroed when extending the
> file.

	Does XFS do this in get_blocks()?  We deliberately do no
allocation in get_blocks(), which is where our need for up-front
allocation comes from.

> > However, this patch prevents the tail
> > blocks of the allocation unit from being written back to disk.  When the
> > file is next extended, i_size will now cover these unzeroed blocks,
> > leaking the old contents of the disk to userspace and creating a corrupt
> > file.
> 
> XFS doesn't zero blocks at allocation. Instead, XFS zeros the range
> between the old EOF and the new EOF on each extending write. Hence
> these pages get written because they fall inside the new i_size that
> is set during the write.  The i_size on disk doesn't get changed
> until after the data writes have completed, so even on a crash we
> don't expose uninitialised blocks.

	We do the same, but we zero the entire allocation.  This works
both when filling holes and when extending, though obviously the
extending is what we're worried about here.  We change i_size in
write_end, so our guarantee is the same as yours for the page containing
i_size.

> Looking at ocfs2_writepage(), it simply calls
> block_write_full_page(), which does:
> 
> 	/* Is the page fully outside i_size? (truncate in progress) */
> 	offset = i_size & (PAGE_CACHE_SIZE-1);
> 	if (page->index >= end_index+1 || !offset) {
> 		/*
> 		 * The page may have dirty, unmapped buffers.  For example,
> 		 * they may have been added in ext3_writepage().  Make them
> 		 * freeable here, so the page does not leak.
> 		 */
> 		do_invalidatepage(page, 0);
> 		unlock_page(page);
> 		return 0; /* don't care */
> 	}
> 
> i.e. pages beyond EOF get invalidated.  If it somehow gets through
> that check, __block_write_full_page() will avoid writing dirty
> bufferheads beyond EOF because the write is "racing with truncate".

	Your contention is that we've never gotten those tail blocks to
disk.  Instead, our code either handles the future extensions of i_size
or we've just gotten lucky with our testing.  Our current BUG trigger is
because we have a new check that catches this case.  Does that summarize
your position correctly?
	I'm not averse to having a zero-only-till-i_size policy, but I
know we've visited this problem before and got bit.  I have to go reload
that context.
	Regarding XFS, how do you handle catching the tail of an
allocation with an lseek(2)'d write?  That is, your current allocation
has a few blocks outside of i_size, then I lseek(2) a gigabyte past EOF
and write there.  The code has to recognize to zero around old_i_size
before moving out to new_i_size, right?  I think that's where our old
approaches had problems.

Joel

-- 

"The real reason GNU ls is 8-bit-clean is so that they can
 start using ISO-8859-1 option characters."
	- Christopher Davis (ckd at loiosh.kei.com)

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
