From: Villalovos, John L <john.l.villalovos@intel.com>
Date: Fri Mar  5 11:21:59 2004
Subject: [Ocfs2-devel] RFE: Change #include usage
Message-ID: <50D19C3AC815734C9E19FE4C4F6128A602A569B4@orsmsx403.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

> On Thu, Mar 04, 2004 at 04:38:29PM -0800, Villalovos, John L wrote:
> > #include "inc/ocfs.h"
> > 
> > This should make for cleaner Makefiles that don't need to 
> add a -I flag
> > to add the inc/ directory.
> > 
> > Any comments on this?
> 
> 	Other way around, really.  All in-kernel filesystems with
> headers have the headers in the flat directory.

I agree if you are saying that we should get rid of the "inc/" directory
and move all the .h files into the src/ directory.

That would make it more palatable to future integration with the kernel.
IMHO :)

John
