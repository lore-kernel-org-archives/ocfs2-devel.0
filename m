From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 28 Jun 2010 19:20:33 -0700
Subject: [Ocfs2-devel] [PATCH] Revert "writeback: limit
	write_cache_pages integrity scanning to current EOF"
In-Reply-To: <20100629015822.GD24343@mail.oracle.com>
References: <20100628173529.GA10573@mail.oracle.com>
	<20100629002421.GY6590@dastard>
	<20100629005403.GC24343@mail.oracle.com>
	<AANLkTil1R9I94pVXLE50JAMPIwpiaZuroJAg4wcwyBUb@mail.gmail.com>
	<20100629015822.GD24343@mail.oracle.com>
Message-ID: <AANLkTil5y7F9w-18mVi0G1S5pSv9MiKq6XL5MWAMFBQM@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Tao Ma <tao.ma@oracle.com>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>

On Mon, Jun 28, 2010 at 6:58 PM, Joel Becker <Joel.Becker@oracle.com> wrote:
>
> ? ? ? ?Well, shit. ?Something has changed in here, or we're really
> really (un)lucky. ?We visited this code a year ago or so when we had
> serious zeroing problems, and we tested the hell out of it. ?Now it is
> broken again. ?And it sure looks like that block_write_full_page() check
> has been there since before git.

Hmm. I'm actually starting to worry that we should do the revert after all.

Why? Locking. That page-writeback.c thing decides to limit the end to
the inode size the same way that block_write_full_page() does, but
block_write_full_page() holds the page lock, while page-writeback.c
does not. Which means that as a race against somebody else doing a
truncate(), the two things really are pretty different.

That said, write_cache_pages() obviously doesn't actually invalidate
the page (the way block_write_full_page() does), so locking matters a
whole lot less for it. If somebody is doing a concurrent truncate or a
concurrent write, then for the data to really show up reliably on disk
there would obviously have to be a separate sync operation involved,
so even with the lack of any locking, it should be safe.

I dunno. Filesystem corruption makes me nervous. So I'm certainly
totally willing to do the revert if that makes ocfs2 work again. Even
if "work again" happens to be partly by mistake, and for some reason
that isn't obvious.

Your call, I guess.  If any ocfs2 fix looks scary, and you'd prefer to
have an -rc4 (in a few days - not today) with just the revert, I'm ok
with that. Even if it's only a "at least no worse than 2.6.34"
situation rather than a real fix.

                 Linus
