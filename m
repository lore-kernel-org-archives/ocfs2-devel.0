From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Jun  8 17:52:51 2004
Subject: [Ocfs2-devel] ATTN: OCFS2 coders and testers
Message-ID: <20040608225247.GD4380@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Ok, as of SVN revision 1024 I've commited some changes which include a set
of BUG() assertions. If you hit a BUG() on an acquire_lockres, or any bh sem
hash related functions (get data, get data write, etc) please copy and send
the entire output to me and/or to the list (both is prolly good).

Since this stuff is going away soon, I didn't bother to put the assertions
in the replacement functions which are used when BH_SEM_DEBUG is defined.
Please don't build with that enabled in the Makefile (it is disabled by
default).

What we're trying to do here is use an alternative locking scheme for I/O
instead of the acquire_lockres and bh sem hash stuff. When we're comfortable
that the new scheme works, we'll be removing those two.

The hope is that by putting this out a bit early we can get any corner cases
we've missed.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
