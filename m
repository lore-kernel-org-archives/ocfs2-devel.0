From: Joel Becker <jlbec@evilplan.org>
Date: Wed, 23 Feb 2011 11:13:39 -0800
Subject: [Ocfs2-devel] [PATCH] Treat writes as new when holes span
 across page boundaries
In-Reply-To: <AANLkTikZHYK3_BTuS_eOApJnT866t4-HPbRc96jpiWYX@mail.gmail.com>
References: <AANLkTimXr0rA5FV_ep-y9uetUVcD3w+9MuTZeBnLXDvG@mail.gmail.com>
	<20110222083648.GC30966@noexit>
	<AANLkTi=+vK_17n-ENMznWbYKBZcZ0v1U0ptgv8qThkUv@mail.gmail.com>
	<20110222213927.GA28774@noexit> <20110222215428.GB28774@noexit>
	<AANLkTikByGbpDyDmbM7kNV-ZAt1Ts5BzbM0Ospi=o8Ki@mail.gmail.com>
	<20110222233417.GC28774@noexit>
	<AANLkTik3387QOadM+-7FaXLT90ednn6+=oDfiyzjt=Tv@mail.gmail.com>
	<20110223093932.GA30720@noexit>
	<AANLkTikZHYK3_BTuS_eOApJnT866t4-HPbRc96jpiWYX@mail.gmail.com>
Message-ID: <20110223191338.GA4020@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Feb 23, 2011 at 08:43:44AM -0600, Goldwyn Rodrigues wrote:
> On Wed, Feb 23, 2011 at 3:39 AM, Joel Becker <jlbec@evilplan.org> wrote:
> >> After the write, i_size=4128.
> >
> > ? ? ? ?And the block is zeroed out to 8191 (or at least it should be)
> > by.
> >
> 
> by...?

	Haha, where'd the rest of that sentence go?  By the
page prepare code (prepare_write() in older linux, write_begin() in
newer linux).

> So, who should zero the page? I assume map_pages

	ocfs2_map_page_blocks() explicitly describes itself as not
handling the zeroing.  Let's trust that for now.

> > ? ? ? ?Think about your first patch. ?It zeros from i_size to pos. ?But
> 
> Actually, it zeroed from i_size to EOC. But again I think that might
> be incorrect because of the commits you mentioned.

	Sure.  But it shouldn't be necessary.

> > ? ? ? ?Your last patch, where you force 'new', isn't quite right. ?The
> > cluster boundaries passed to map_pages aren't right, and the later
> > zeroing could be wrong (zeroing earlier parts of the file that contained
> > data). ?At least, that's how I read it. ?But I think you're in the right
> > place to start.
> 
> I still don't understand why? I am not considering clusters at all.
> The flag is set to new if -
> i_size <= page_offset <= pos

	Thinking about it, I think you're right about this part of its
safety.  My big concern is that 'new' means "I have a whole empty
cluster" and that might not be true.
	It's starting to look like your code is even closer to correct,
but might not be located exactly where it needs to be.  Let's look at
what should_zero means.
	In ocfs2_write_cluster(), it means the calling functions have an
entire new or unwritten cluster.  That's why we take v_blkno as cpos
when should_zero is true.  We know that the caller has set us up with an
entire cluster and we have to zero the front or all of it.  That's great
when we call down to ocfs2_prepare_page_for_write(), as we are able to
trust we can zero anything we see with impunity.  That's why we zero
whole ranges (cluster_start..cluster_end).  Remember here that a write
context can have multiple pages (to cover the front of a large cluster
that's just been allocated) or multiple clusters per page (16K/64K page
size).  should_zero (from c_needs_zero) tells us that the entire cluster
we're looking at is newly active.
	Down in ocfs2_map_page_blocks(), we must not venture outside
from/to, as other code (not the write path) assumes it will not pull in
blocks that it doesn't need.  So that's not a place to change.
	What about the loop at the bottom of ocfs2_write_cluster()?  The
one that calls ocfs2_prepare_page_for_write()?  It can walk multiple
pages, some of which may be the front of a newly allocated cluster
(Imagine this write is allocating a 1MB cluster at the end of the file,
but pos is 512K inside the new cluster.  This code handles zeroing all
the pages between the start of the cluster and pos).  I suppose we could
check here, but ocfs2_prepare_page_for_write() has logic based on target
vs non-target page, and we don't want to override it.
	So we do want to make a change inside
ocfs2_prepare_page_for_write().  Let's look at your change.  You trigger
'new' even if we're not the target page.  This means the BUG_ON() in the
else{} can never fail for the extend I described in the last paragraph.
The calling code should have made sure we are correctly passing
should_zero to all non-target pages.  Having new overridden for them is
wrong.  So maybe we move your check inside the target_page if.  It only
really matters for the target page.
	But wait!  Check out block_write_full_page_endio() in
fs/buffer.c!  Especially this part:

	zero_user_segment(page, offset, PAGE_CACHE_SIZE);

It is zeroing the tail of a page when it straddles i_size to make sure
it goes out correctly.  But, of course, blocks past i_size never go to
disk.  And we don't care; readpage should handle them correctly, right?
So if writepage is going to zero for us, and readpage is going to read
correctly, how are you getting bad data?
	I was about to think we were done, but now I'm not so sure.  I
have a question: with my change to ocfs2_should_read_block(), but
without your patch, what do you see for corruption?  Your pattern
written in the first pass, or complete random garbage?

Joel

-- 

"The opposite of a correct statement is a false statement. The
 opposite of a profound truth may well be another profound truth."
         - Niels Bohr 

			http://www.jlbec.org/
			jlbec@evilplan.org
