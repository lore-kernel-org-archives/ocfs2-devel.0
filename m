From: Joel Becker <jlbec@evilplan.org>
Date: Wed, 23 Feb 2011 11:28:27 -0800
Subject: [Ocfs2-devel] [PATCH] Treat writes as new when holes span
 across page boundaries
In-Reply-To: <20110223191338.GA4020@noexit>
References: <20110222083648.GC30966@noexit>
	<AANLkTi=+vK_17n-ENMznWbYKBZcZ0v1U0ptgv8qThkUv@mail.gmail.com>
	<20110222213927.GA28774@noexit> <20110222215428.GB28774@noexit>
	<AANLkTikByGbpDyDmbM7kNV-ZAt1Ts5BzbM0Ospi=o8Ki@mail.gmail.com>
	<20110222233417.GC28774@noexit>
	<AANLkTik3387QOadM+-7FaXLT90ednn6+=oDfiyzjt=Tv@mail.gmail.com>
	<20110223093932.GA30720@noexit>
	<AANLkTikZHYK3_BTuS_eOApJnT866t4-HPbRc96jpiWYX@mail.gmail.com>
	<20110223191338.GA4020@noexit>
Message-ID: <20110223192826.GB4020@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Feb 23, 2011 at 11:13:39AM -0800, Joel Becker wrote:
> The calling code should have made sure we are correctly passing
> should_zero to all non-target pages.  Having new overridden for them is
> wrong.  So maybe we move your check inside the target_page if.  It only
> really matters for the target page.

	Actually, I have a question: what is the clustersize of your
test?  Because if the filesystem is 4k/4k, the write at 4096 of 32 bytes
should allocate a new cluster.  'new' should already be set, and your
check irrelevant.

> 	But wait!  Check out block_write_full_page_endio() in
> fs/buffer.c!  Especially this part:
> 
> 	zero_user_segment(page, offset, PAGE_CACHE_SIZE);
> 
> It is zeroing the tail of a page when it straddles i_size to make sure
> it goes out correctly.  But, of course, blocks past i_size never go to
> disk.  And we don't care; readpage should handle them correctly, right?
> So if writepage is going to zero for us, and readpage is going to read
> correctly, how are you getting bad data?
> 	I was about to think we were done, but now I'm not so sure.  I
> have a question: with my change to ocfs2_should_read_block(), but
> without your patch, what do you see for corruption?  Your pattern
> written in the first pass, or complete random garbage?

	One thing I would like to see are the results with fsync()
between writeSparse() and checkSparselyWrittenFile().  Forcing the file
to disk before checking the values will tell us something.  This is with
my patch but without yours.
	Another good test would be to umount/mount between writeSparse()
and checkSparselyWrittenFile().  This tells us what actually hit disk.

Joel

-- 

"The question of whether computers can think is just like the question
 of whether submarines can swim."
	- Edsger W. Dijkstra

			http://www.jlbec.org/
			jlbec at evilplan.org
