From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 03 Apr 2009 19:16:04 -0000
Subject: [Ocfs2-devel] [git patches] Ocfs2 updates for 2.6.30
In-Reply-To: <20090403184605.GC14571@wotan.suse.de>
References: <20090403184605.GC14571@wotan.suse.de>
Message-ID: <alpine.LFD.2.00.0904031208490.4015@localhost.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Andrew Morton <akpm@linux-foundation.org>



On Fri, 3 Apr 2009, Mark Fasheh wrote:
> 
> 	Here is the Ocfs2 changes for this merge window. I sent all these
> patches out to the list a couple weeks ago. Original mail is attached.

Hmm. And I can _guarantee_ that none of these patches were actually tested 
as-is, because they were all rebased just minutes before the send.

 - top commit:

	Commit:     Mark Fasheh <mfasheh@suse.com>
	CommitDate: Fri Apr 3 11:39:26 2009 -0700

 - email:

	Date: Fri, 3 Apr 2009 11:46:05 -0700
	From: Mark Fasheh <mfasheh@suse.com>

So any possible subtle interactions with any other changes would never 
have been tested very much before the "please pull".

Are they likely? Probably not. But that's not the point. The point is that 
you barely had time to compile that thing, much less give it any testing.

The whole "it compiles, it's perfect, ship it" mentality is _strictly_ 
only for me.

Quod licet Jovi, non licet bovi.

		Linus
