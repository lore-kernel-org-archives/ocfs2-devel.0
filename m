From: Joel Becker <jlbec@evilplan.org>
Date: Tue, 22 Feb 2011 15:34:18 -0800
Subject: [Ocfs2-devel] [PATCH] Treat writes as new when holes span
 across page boundaries
In-Reply-To: <AANLkTikByGbpDyDmbM7kNV-ZAt1Ts5BzbM0Ospi=o8Ki@mail.gmail.com>
References: <AANLkTi=pEu5y4=kjG1YoLR+YCd7Ak21QaFQz=AR3dffX@mail.gmail.com>
	<20110220070953.GC17784@noexit>
	<AANLkTinuhh9nF=6NQbe81NbE0K95huVtdDdC9Gb2pU=5@mail.gmail.com>
	<20110221020856.GL17784@noexit>
	<AANLkTimXr0rA5FV_ep-y9uetUVcD3w+9MuTZeBnLXDvG@mail.gmail.com>
	<20110222083648.GC30966@noexit>
	<AANLkTi=+vK_17n-ENMznWbYKBZcZ0v1U0ptgv8qThkUv@mail.gmail.com>
	<20110222213927.GA28774@noexit> <20110222215428.GB28774@noexit>
	<AANLkTikByGbpDyDmbM7kNV-ZAt1Ts5BzbM0Ospi=o8Ki@mail.gmail.com>
Message-ID: <20110222233417.GC28774@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Feb 22, 2011 at 04:09:47PM -0600, Goldwyn Rodrigues wrote:
> On Tue, Feb 22, 2011 at 3:54 PM, Joel Becker <jlbec@evilplan.org> wrote:
> > On Tue, Feb 22, 2011 at 01:39:28PM -0800, Joel Becker wrote:
> > ? ? ? ?Looking some more. ?ocfs2_zero_tail() is supposed to handle
> > this, isn't it? ?ocfs2_write_begin_nolock() calls ocfs2_zero_tail(pos),
> > which calls ocfs2_zero_extend(pos), which works up to
> > ocfs2_clusters_for_bytes(pos). ?Doesn't this include your cluster?
> > Shouldn't the page already be loaded into the pagecache with zeros?
> >
> >
> 
> Din't you discard that idea in my previous attempt? ;)

	I might have ;-)  I'm reloading state here, so I might be coming
back to something you've already seen.  I'm trying to ask questions that
make both of us come to the same understanding.  So my apologies if I
didn't get what you were saying before.
	For example, I thought you were saying that a write from 0 to
1023 (new i_size of 1024), with a blocksize of 4K and a clustersize of
8K, should zero from 1024 to 8191.  That is, zeroing the entire cluster
at allocation time, even though the second block does not contain
i_size.  My contention is that 1024 to 4095 should be zeroed for this
write.  We would only zero the second block when the file is later
extended past 4096.
	I may have been confused because ocfs2_zero_extend() only used
to matter for nonsparse, where this behavior was different.  Which of
the above did you mean?

> On a serious note, no it doesn't because zero_start and zero_to_size
> are the same when pos is on a block boundary and hence the loop does
> not execute.

	If they are the same (i_size == pos), there is no hole.  I don't
see how there is a problem.

Joel

-- 

Life's Little Instruction Book #464

	"Don't miss the magic of the moment by focusing on what's
	 to come."

			http://www.jlbec.org/
			jlbec at evilplan.org
