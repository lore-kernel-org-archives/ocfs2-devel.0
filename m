From: Dave Chinner <david@fromorbit.com>
Date: Tue, 29 Jun 2010 12:44:06 +1000
Subject: [Ocfs2-devel] [PATCH] Revert "writeback: limit
 write_cache_pages integrity scanning to current EOF"
In-Reply-To: <AANLkTil5y7F9w-18mVi0G1S5pSv9MiKq6XL5MWAMFBQM@mail.gmail.com>
References: <20100628173529.GA10573@mail.oracle.com>
	<20100629002421.GY6590@dastard>
	<20100629005403.GC24343@mail.oracle.com>
	<AANLkTil1R9I94pVXLE50JAMPIwpiaZuroJAg4wcwyBUb@mail.gmail.com>
	<20100629015822.GD24343@mail.oracle.com>
	<AANLkTil5y7F9w-18mVi0G1S5pSv9MiKq6XL5MWAMFBQM@mail.gmail.com>
Message-ID: <20100629024406.GB6590@dastard>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Tao Ma <tao.ma@oracle.com>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>

On Mon, Jun 28, 2010 at 07:20:33PM -0700, Linus Torvalds wrote:
> On Mon, Jun 28, 2010 at 6:58 PM, Joel Becker <Joel.Becker@oracle.com> wrote:
> >
> > ? ? ? ?Well, shit. ?Something has changed in here, or we're really
> > really (un)lucky. ?We visited this code a year ago or so when we had
> > serious zeroing problems, and we tested the hell out of it. ?Now it is
> > broken again. ?And it sure looks like that block_write_full_page() check
> > has been there since before git.
> 
> Hmm. I'm actually starting to worry that we should do the revert after all.
> 
> Why? Locking. That page-writeback.c thing decides to limit the end to
> the inode size the same way that block_write_full_page() does, but
> block_write_full_page() holds the page lock, while page-writeback.c
> does not. Which means that as a race against somebody else doing a
> truncate(), the two things really are pretty different.
> 
> That said, write_cache_pages() obviously doesn't actually invalidate
> the page (the way block_write_full_page() does), so locking matters a
> whole lot less for it. If somebody is doing a concurrent truncate or a
> concurrent write, then for the data to really show up reliably on disk
> there would obviously have to be a separate sync operation involved,
> so even with the lack of any locking, it should be safe.

Yes, that is the premise on which the "stop @ EOF" code in
write_cache_pages() is based. It's simply a snapshot of the EOF when
the data integrity sync starts and as such any subsequent extensions
to it that happen after the sync started are not something we have
to worry about for this sync operation.

OTOH, if there is a concurrent truncation while the loop is
operating, then the existing checks for truncation after locking the
page _must_ be sufficent to avoid writeback of such truncated pages
otherwise truncate would already be broken.

> I dunno. Filesystem corruption makes me nervous.

You're not alone in that feeling. :/

FWIW, it's taken us quite a long while (years) to iron out all of
the known sync+crash bugs in XFS and as a result f the process we
have a fair number of regression tests that tell us quickly when
sync is has been broken. This test hasn't indicated any problems
with XFS, so I'm fairly confident the change is safe.

That said, ....

> So I'm certainly
> totally willing to do the revert if that makes ocfs2 work again. Even
> if "work again" happens to be partly by mistake, and for some reason
> that isn't obvious.
> 
> Your call, I guess.  If any ocfs2 fix looks scary, and you'd prefer to
> have an -rc4 (in a few days - not today) with just the revert, I'm ok
> with that. Even if it's only a "at least no worse than 2.6.34"
> situation rather than a real fix.

... I agree with this.

Cheers,

Dave.
-- 
Dave Chinner
david at fromorbit.com
