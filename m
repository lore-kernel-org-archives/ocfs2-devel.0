From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 28 Jun 2010 18:12:35 -0700
Subject: [Ocfs2-devel] [PATCH] Revert "writeback: limit
	write_cache_pages integrity scanning to current EOF"
In-Reply-To: <20100629005403.GC24343@mail.oracle.com>
References: <20100628173529.GA10573@mail.oracle.com>
	<20100629002421.GY6590@dastard>
	<20100629005403.GC24343@mail.oracle.com>
Message-ID: <AANLkTil1R9I94pVXLE50JAMPIwpiaZuroJAg4wcwyBUb@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Tao Ma <tao.ma@oracle.com>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>

On Mon, Jun 28, 2010 at 5:54 PM, Joel Becker <Joel.Becker@oracle.com> wrote:
> On Tue, Jun 29, 2010 at 10:24:21AM +1000, Dave Chinner wrote:
>>
>> Looking at ocfs2_writepage(), it simply calls
>> block_write_full_page(), which does:
>>
>> ? ? ? /* Is the page fully outside i_size? (truncate in progress) */
>> ? ? ? offset = i_size & (PAGE_CACHE_SIZE-1);
>> ? ? ? if (page->index >= end_index+1 || !offset) {
>> ? ? ? ? ? ? ? /*
>> ? ? ? ? ? ? ? ?* The page may have dirty, unmapped buffers. ?For example,
>> ? ? ? ? ? ? ? ?* they may have been added in ext3_writepage(). ?Make them
>> ? ? ? ? ? ? ? ?* freeable here, so the page does not leak.
>> ? ? ? ? ? ? ? ?*/
>> ? ? ? ? ? ? ? do_invalidatepage(page, 0);
>> ? ? ? ? ? ? ? unlock_page(page);
>> ? ? ? ? ? ? ? return 0; /* don't care */
>> ? ? ? }
>>
>> i.e. pages beyond EOF get invalidated. ?If it somehow gets through
>> that check, __block_write_full_page() will avoid writing dirty
>> bufferheads beyond EOF because the write is "racing with truncate".
>
> ? ? ? ?Your contention is that we've never gotten those tail blocks to
> disk. ?Instead, our code either handles the future extensions of i_size
> or we've just gotten lucky with our testing. ?Our current BUG trigger is
> because we have a new check that catches this case. ?Does that summarize
> your position correctly?

Maybe Dave has some more exhaustive answer, but his point that
block_write_full_page() already just drops the page does seem to be
very valid.  Which makes me suspect that it would be better to remove
the ocfs2 BUG_ON() as a stop-gap measure, rather than reverting the
commit. It seems to be true that the "don't bother flushing past EOF"
commit really just uncovered an older bug.

So maybe ocfs2 should just replace the bug-on with invalidating the
page (perhaps with a WARN_ONCE() to make sure the problem doesn't get
forgotten about?)

                 Linus
