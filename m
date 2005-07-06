From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Jul  6 13:57:56 2005
Subject: [Ocfs2-devel] 256 node limit
In-Reply-To: <20050706180418.GA21089@ca-server1.us.oracle.com>
References: <200507011649.j61GnMlY022352@oss.oracle.com>
	<20050701170449.GG26608@marowsky-bree.de>
	<42C5899E.2000209@oracle.com>
	<11fa5cce05070116517b7339b5@mail.gmail.com>
	<42CB1689.8040800@oracle.com>
	<11fa5cce050706103855a0470f@mail.gmail.com>
	<20050706180418.GA21089@ca-server1.us.oracle.com>
Message-ID: <20050706185801.GM8215@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jul 06, 2005 at 11:04:19AM -0700, Wim Coekaerts wrote:
> it would be entertaining to see how it even works... but uhm go ahead.
> would be a good test we sure don't have the hardware to do that
Well the first problem you're likely to hit is that nm, and the dlm
represent node number as a u8 (dlm more specifically in it's network
packets).

Heartbeat uses a u8 nodenum in it's heartbeat block, but has the next 3 u8's
reserved for when we move to a larger value for node_num so simply replacing
that whole bit with u32 at least wouldn't change the size of the structure.
The next smallest disk value would be the slot map items which are u16's
each, but I expect we'll have moved to an alternate method of picking a
nodes slot by the time that becomes an issue.

Anyway this is all off the top of my head. It'd be interesting to see what
you run into after having made the structure changes to support > 254 nodes.

Btw, I say > 254 because node number 255 is reserved for 'invalid node num'.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
