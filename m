From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Mar  5 11:48:31 2004
Subject: [Ocfs2-devel] RFE: Change #include usage
In-Reply-To: <50D19C3AC815734C9E19FE4C4F6128A602A569B4@orsmsx403.jf.intel.com>
References: <50D19C3AC815734C9E19FE4C4F6128A602A569B4@orsmsx403.jf.intel.com>
Message-ID: <20040305174826.GA31692@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Well, I'm not averse to this change either, though I'd want it to be done
(if at all) when I'm all sync'd up with svn :)
	--Mark

On Fri, Mar 05, 2004 at 09:21:48AM -0800, Villalovos, John L wrote:
> > On Thu, Mar 04, 2004 at 04:38:29PM -0800, Villalovos, John L wrote:
> > > #include "inc/ocfs.h"
> > > 
> > > This should make for cleaner Makefiles that don't need to 
> > add a -I flag
> > > to add the inc/ directory.
> > > 
> > > Any comments on this?
> > 
> > 	Other way around, really.  All in-kernel filesystems with
> > headers have the headers in the flat directory.
> 
> I agree if you are saying that we should get rid of the "inc/" directory
> and move all the .h files into the src/ directory.
> 
> That would make it more palatable to future integration with the kernel.
> IMHO :)
> 
> John
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
