From: Manish Singh <manish.singh@oracle.com>
Date: Tue Feb 10 19:10:12 2004
Subject: [Ocfs2-devel] Revision 30 fails to insmod
In-Reply-To: <20040211002621.GA16362@penguin.co.intel.com>
References: <50D19C3AC815734C9E19FE4C4F6128A617802E@orsmsx403.jf.intel.com>
	<20040211002621.GA16362@penguin.co.intel.com>
Message-ID: <20040211011007.GA20569@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Feb 10, 2004 at 04:26:21PM -0800, Rusty Lynch wrote:
> On Tue, Feb 10, 2004 at 04:07:26PM -0800, Villalovos, John L wrote:
> > Just did a sync with revision 30 from the repository.
> > 
> > It fails to insmod.
> > 
> > /lib/modules/2.4.22-1.2149.nptl/unsupported/fs/ocfs2.o: unresolved
> > symbol OCFS_SB_GET_KDEV
> > 
> > It looks like the latest revision removed the definition of
> > OCFS_SB_GET_KDEV in src/inc/ocfs.h but is still using the macro :(
> 
> Here is a fix

Thanks, committed to the tree.

-Manish
