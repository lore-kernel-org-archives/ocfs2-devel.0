From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Oct 14 01:12:45 2005
Subject: [Ocfs2-devel] ocfs2's bmap output
In-Reply-To: <1129268016.8092.28.camel@localhost.localdomain>
References: <1129268016.8092.28.camel@localhost.localdomain>
Message-ID: <20051014061251.GE9943@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

On Fri, Oct 14, 2005 at 01:33:35AM -0400, Shaya Potter wrote:
> I'm guessing this is because of its use of extents, and probably means
> I've screwed myself in trying to use bmap in this way.  Is that a
> correct assumption?  Is there any other interface into OCFS2 to tell if
> a block is a "blank" sparse area?
Unfortunately, no. Since OCFS2 doesn't currently support sparse files, the
"holes" created are actually allocated and filled with zeros. Once
allocated, they'll look no different from other file data.

I suppose you could read back those clusters in a file to see if they have
zero's, though that might not be particularly performant. Also, it would be
impossible to differentiate between a block that was zero'd as part of
a process file write versus a block which was zero'd as a hole.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
