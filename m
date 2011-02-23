From: Joel Becker <jlbec@evilplan.org>
Date: Wed, 23 Feb 2011 13:17:05 -0800
Subject: [Ocfs2-devel] [PATCH] Treat writes as new when holes span
 across page boundaries
In-Reply-To: <AANLkTimrFoVm11T=Hyq+Uf7wfX8n7zSZStNnAs4sPmvK@mail.gmail.com>
References: <AANLkTi=+vK_17n-ENMznWbYKBZcZ0v1U0ptgv8qThkUv@mail.gmail.com>
	<20110222213927.GA28774@noexit> <20110222215428.GB28774@noexit>
	<AANLkTikByGbpDyDmbM7kNV-ZAt1Ts5BzbM0Ospi=o8Ki@mail.gmail.com>
	<20110222233417.GC28774@noexit>
	<AANLkTik3387QOadM+-7FaXLT90ednn6+=oDfiyzjt=Tv@mail.gmail.com>
	<20110223093932.GA30720@noexit>
	<AANLkTikZHYK3_BTuS_eOApJnT866t4-HPbRc96jpiWYX@mail.gmail.com>
	<20110223191338.GA4020@noexit>
	<AANLkTimrFoVm11T=Hyq+Uf7wfX8n7zSZStNnAs4sPmvK@mail.gmail.com>
Message-ID: <20110223211704.GH4020@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Feb 23, 2011 at 02:54:19PM -0600, Goldwyn Rodrigues wrote:
> On Wed, Feb 23, 2011 at 1:13 PM, Joel Becker <jlbec@evilplan.org> wrote:
> > ? ? ? ?I was about to think we were done, but now I'm not so sure. ?I
> > have a question: with my change to ocfs2_should_read_block(), but
> > without your patch, what do you see for corruption? ?Your pattern
> > written in the first pass, or complete random garbage?
> 
> Joel, you are getting confused in the list of parameters to reproduce
> the bug. I have listed it in the past, but not in a single location so
> it is difficult to pick up the bits. I will put it together for you.

Goldwyn,
	I'm just not remembering off the top of my head, so I'm asking.
I'm actually describing the myriad cases we can encounter in this code,
because any change we make has to be safe for all possible cases.

> 1. blocksize < clustersize

	Ok.

> 2.  the previous write ended in a page boundary, but not a cluster
> boundary. eg, clustersize=16K but pos is at the page boundary = 4k

	Must it be a page boundary?  What about a block boundary? ;-)

> 3. you wrote something at the page boundary

	I think it's more block than page, really.  But that is the same
for 4K blocks and pages.

> 4. there is a hole created in the page from 4k-8k in *between* say 4128-4640

	There is no hole here.  We have allocation.  Even if the user
doesn't directly write to this location, it is not a hole, because we
have a cluster there.  You just mean that the user didn't write to this
location (sparse writing).  That's just a terminology thing, but it's
important for other folks understanding you.

> What I am seeing is pure junk(not 0xbaadfeed), and not what I had
> written earlier.

	Ok.  That's what I expected.  I wanted to clarify we were not
reading stale data, but were instead failing to zero memory.

> In retrospect, since we have covered the rest of the bases, we can set
> new on the condition:
> 
> i_size == page_offset == pos
> 
> I interpreted new as new page or new data vs new cluster, and perhaps
> that is the reason I placed the condition there.

	I don't like this.  We still haven't figured out where we're
failing.
	The core piece of this, why I'm going back and forth with you
discussing the issue, is that we never want to paper over a symptom.
Sure, we know that i_size==page_offset==pos triggers this, but is it the
only case?  If we figure out *why* we're here, when the code is supposed
to not have this problem, then we can be sure we've closed out all
exposure.
	To wit: If we really only have a problem when i_size is on a
page boundary, doesn't that sound like an off-by-one error?  We've had
those before.  I'm not sure that it is, but shouldn't we be sure about
it?

Joel

-- 

"But then she looks me in the eye
 And says, 'We're going to last forever,'
 And man you know I can't begin to doubt it.
 Cause it just feels so good and so free and so right,
 I know we ain't never going to change our minds about it, Hey!
 Here comes my girl."

			http://www.jlbec.org/
			jlbec at evilplan.org
