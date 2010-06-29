From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 28 Jun 2010 18:58:23 -0700
Subject: [Ocfs2-devel] [PATCH] Revert "writeback: limit
 write_cache_pages integrity scanning to current EOF"
In-Reply-To: <AANLkTil1R9I94pVXLE50JAMPIwpiaZuroJAg4wcwyBUb@mail.gmail.com>
References: <20100628173529.GA10573@mail.oracle.com>
	<20100629002421.GY6590@dastard>
	<20100629005403.GC24343@mail.oracle.com>
	<AANLkTil1R9I94pVXLE50JAMPIwpiaZuroJAg4wcwyBUb@mail.gmail.com>
Message-ID: <20100629015822.GD24343@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Tao Ma <tao.ma@oracle.com>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>

On Mon, Jun 28, 2010 at 06:12:35PM -0700, Linus Torvalds wrote:
> On Mon, Jun 28, 2010 at 5:54 PM, Joel Becker <Joel.Becker@oracle.com> wrote:
> > ? ? ? ?Your contention is that we've never gotten those tail blocks to
> > disk. ?Instead, our code either handles the future extensions of i_size
> > or we've just gotten lucky with our testing. ?Our current BUG trigger is
> > because we have a new check that catches this case. ?Does that summarize
> > your position correctly?
> 
> Maybe Dave has some more exhaustive answer, but his point that
> block_write_full_page() already just drops the page does seem to be
> very valid.  Which makes me suspect that it would be better to remove
> the ocfs2 BUG_ON() as a stop-gap measure, rather than reverting the
> commit. It seems to be true that the "don't bother flushing past EOF"
> commit really just uncovered an older bug.

	Well, shit.  Something has changed in here, or we're really
really (un)lucky.  We visited this code a year ago or so when we had
serious zeroing problems, and we tested the hell out of it.  Now it is
broken again.  And it sure looks like that block_write_full_page() check
has been there since before git.

> So maybe ocfs2 should just replace the bug-on with invalidating the
> page (perhaps with a WARN_ONCE() to make sure the problem doesn't get
> forgotten about?)

	Oh, no, that's not it at all.  This is a disaster.  I can't see
for the life of me why we haven't had 100,000 bug reports.  You're going
to have an ocfs2 patch by the end of the week.  It will be ugly, I'm
sure of it, but it has to be done.  For every extend, we're going to
have to zero and potentially CoW around old_i_size if the old allocation
isn't within the bounds of the current write.

Joel

-- 

"In a crisis, don't hide behind anything or anybody. They're going
 to find you anyway."
	- Paul "Bear" Bryant

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
