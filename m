From: Joel Becker <jlbec@evilplan.org>
Date: Wed, 23 Feb 2011 01:39:34 -0800
Subject: [Ocfs2-devel] [PATCH] Treat writes as new when holes span
 across page boundaries
In-Reply-To: <AANLkTik3387QOadM+-7FaXLT90ednn6+=oDfiyzjt=Tv@mail.gmail.com>
References: <AANLkTinuhh9nF=6NQbe81NbE0K95huVtdDdC9Gb2pU=5@mail.gmail.com>
	<20110221020856.GL17784@noexit>
	<AANLkTimXr0rA5FV_ep-y9uetUVcD3w+9MuTZeBnLXDvG@mail.gmail.com>
	<20110222083648.GC30966@noexit>
	<AANLkTi=+vK_17n-ENMznWbYKBZcZ0v1U0ptgv8qThkUv@mail.gmail.com>
	<20110222213927.GA28774@noexit> <20110222215428.GB28774@noexit>
	<AANLkTikByGbpDyDmbM7kNV-ZAt1Ts5BzbM0Ospi=o8Ki@mail.gmail.com>
	<20110222233417.GC28774@noexit>
	<AANLkTik3387QOadM+-7FaXLT90ednn6+=oDfiyzjt=Tv@mail.gmail.com>
Message-ID: <20110223093932.GA30720@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Feb 22, 2011 at 06:05:20PM -0600, Goldwyn Rodrigues wrote:
> On Tue, Feb 22, 2011 at 5:34 PM, Joel Becker <jlbec@evilplan.org> wrote:
> > ? ? ? ?I may have been confused because ocfs2_zero_extend() only used
> > to matter for nonsparse, where this behavior was different. ?Which of
> > the above did you mean?
> >

Key:
 EOF -> End of File, or i_size.
 EOB -> End of Block, the end of the block containing i_size.  So if
        i_size is 8000 and blocksize is 4096, EOB is 8192.
 EOC -> End of Cluster, the end of the cluster containing i_size.  So if
        i_size is 8000, blocksize is 4096, and clustersize is 16K, EOC
        is 16384, two blocks past i_size.

Hey Goldwyn,
	I want to apologize for not quite getting the point of your
original patch.  The legacy ocfs2_zero_extend() name put me in the mind
of our old nonsparse allocation code, and I saw EOF->EOC and assumed it
was at allocation time, not i_size change time.  I knew I was still
reloading the state in my brain and could be missing something, but that
still must have been frustrating to you.

> Not now, but it may in the future and that is the problem.
> 
> So consider your case of usual parameters, but i_size=4096.
> Now you append 32 bytes of data to it, so pos = i_size = 4096
> and len=32
> write(fd, 32 bytes of data);
> 
> In this case, zero_start and zero_to_size in zero_extend_file are both
> 4096 and it will not zero this page in ocfs2_zero_extend.

	Correct.

> After the write, i_size=4128.

	And the block is zeroed out to 8191 (or at least it should be)
by.

> Now lseek 512 bytes -
> lseek(fd, 512, SEEKCUR);
> 
> 
> ..and write 4096 bytes again.
> write(fd, 4096bytes of data);
> 
> pos=4640 len=4096 bytes, and after the transaction i_size=8736.
> 
> i_size is beyond 8192 now
> 
> Hole between 4128-4640 was never zeroed and carries junk. Does that
> make sense or am I doing the math wrong here?

	That may be the problem, but that is not what should have
happened.  write_begin() should have zeroed 4128-8192 while processing
the 32-byte write.  Linux always assumes that you zero a block when you
bring it into service.  Now, this is not the responsibility of
ocfs2_zero_tail(), because i_size == pos.  ocfs2_zero_tail() is supposed
to work when i_size < pos.  It's when you prepare the pages that this
matters.
	Think about your first patch.  It zeros from i_size to pos.  But
we're supposed to be guaranteed that zeros exist from i_size to EOB.
Thus I read it as zeroing during allocation, not when i_size moves to
cover already allocated clusters.  The "correct" approach (as Linux sees
it) would zero from EOB to pos (or, actually, EOB to the start of the
block containing pos).  We're already supposed to be doing that; that's
part of what I recently fixed.  Later in in our discussion I thought you
might have found a bug in my fix.  That's why I looked at the
ocfs2_should_read_block() code.  Now I see that is not the case (though
my patch is probably correct for ocfs2_should_read_block(), it is
unrelated to the problem you are seeing).
	Given your example above, at write(fd, 32 bytes of data),
ocfs2_prepare_pages_for_write() should be zeroing 4128-8192 before the
write code is allowed to copy the 32 bytes into 4096-4128.  Everyone
expects it to work this way (xfs, extN, etc).  That's exactly what
write_begin() is for.  It gives back a page array where all the pages
are properly allocated and zeroed.  Ours is complex because we have to
handle cluster allocation, where clusters, blocks, and pages can be all
be various multiples of each other.
	Your last patch, where you force 'new', isn't quite right.  The
cluster boundaries passed to map_pages aren't right, and the later
zeroing could be wrong (zeroing earlier parts of the file that contained
data).  At least, that's how I read it.  But I think you're in the right
place to start.

Joel

-- 

Life's Little Instruction Book #198

	"Feed a stranger's expired parking meter."

			http://www.jlbec.org/
			jlbec@evilplan.org
