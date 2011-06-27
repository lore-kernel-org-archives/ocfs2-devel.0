From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 27 Jun 2011 10:26:32 -0700
Subject: [Ocfs2-devel] ocfs2: serialize unaligned aio
In-Reply-To: <4E08B336.9040701@oracle.com>
References: <20110622212338.GA20816@wotan.suse.de>
	<20110626072247.GA15623@noexit.corp.google.com>
	<20110627162306.GB20816@wotan.suse.de>
	<4E08B336.9040701@oracle.com>
Message-ID: <20110627172632.GC20816@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jun 27, 2011 at 09:43:34AM -0700, Sunil Mushran wrote:
> On 06/27/2011 09:23 AM, Mark Fasheh wrote:
> >On Sun, Jun 26, 2011 at 12:22:48AM -0700, Joel Becker wrote:
> >>On Wed, Jun 22, 2011 at 02:23:38PM -0700, Mark Fasheh wrote:
> >>>Fix a corruption that can happen when we have (two or more) outstanding
> >>>aio's to an overlapping unaligned region.  Ext4
> >>>(e9e3bcecf44c04b9e6b505fd8e2eb9cea58fb94d) and xfs recently had to fix
> >>>similar issues.
> >>>
> >>>In our case what happens is that we can have an outstanding aio on a 
> >>>region
> >>>and if a write comes in with some bytes overlapping the original aio we 
> >>>may
> >>>decide to read that region into a page before continuing (typically 
> >>>because
> >>>of buffered-io fallback).  Since we have no ordering guarantees with the
> >>>aio, we can read stale or bad data into the page and then write it back 
> >>>out.
> >>>
> >>>If the i/o is page and block aligned, then we avoid this issue as there
> >>>won't be any need to read data from disk.
> >>>
> >>>I took the same approach as Eric in the ext4 patch and introduced some
> >>>serialization of unaligned async direct i/o.  I don't expect this to 
> >>>have an
> >>>effect on the most common cases of AIO.  Unaligned aio will be slower
> >>>though, but that's far more acceptable than data corruption.
> >>	The patch looks good, but I'm a little confused.  Why doesn't
> >>this matter for buffered I/O?  Just because that data is going through
> >>the pagecache?  For a second, I couldn't see how unaligned dio was
> >>possible, until I remembered this was block aligned, not sector aligned.
> >Buffered I/O is synchronous so we don't really have any situations in which
> >there can be two buffered I/O's at the same time.
> >
> >
> >>	Don't most of the major DIO users (read: databases) do
> >>sector-aligned I/O?  Won't this affect them?
> >In 2.6? Anyway, Sunil will have to answer that question... I would guess
> >though that since xfs and ext4 have the same patch and there don't seem to
> >be major reports from Oracle of DB performance tanking. That's hardly solid
> >evidence of course.
> 
> The Oracle db is not a concern as it fully allocates (and inits) the blocks.
> The exception is the RMAN backup that does extending (aio) direct writes.

In this case (RMAN) wouldn't we just be always falling back to buffered
anyway, since it's always extending?
	--Mark

--
Mark Fasheh
