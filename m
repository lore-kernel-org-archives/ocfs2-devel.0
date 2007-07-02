From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Jul  2 16:18:17 2007
Subject: [Ocfs2-devel] Re: [-mm PATCH] ocfs2: ->fallocate() support
In-Reply-To: <20070630093413.GE22354@infradead.org>
References: <20070621190143.GC17713@ca-server1.us.oracle.com>
	<20070630093413.GE22354@infradead.org>
Message-ID: <20070702231812.GA15463@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Amit Arora <aarora@in.ibm.com>, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

On Sat, Jun 30, 2007 at 10:34:13AM +0100, Christoph Hellwig wrote:
> Btw, it seems like ocfs implements the xfs preallocation ioctls.  What
> would people thing about moving those up to work over ->fallocate so they
> can be used on all filesystems that support preallocation?

That sounds like a good idea. We've already got a very good match on
RESVP/UNRESVP with the various ->fallocate flags.

I'm not sure whether we want to do this for ALLOCSP/FREESP - as far as I've
heard those are hardly used.


> While the ABI is quite ugly it has a huge userbase because it's the only
> existing preallocation mechanism on Linux.

Yeah, that was the primary reason I chose to implement the ioctl (along with
the ->fallocate patch)
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
