From: Kurt Hackel <Kurt.Hackel@oracle.com>
Date: Wed Apr 14 14:22:13 2004
Subject: [Ocfs2-devel] [BUG] can not chmod to 777
In-Reply-To: <407D8D22.6050802@oracle.com>
References: 
	<3ACA40606221794F80A5670F0AF15F843C28A5@PDSMSX403.ccr.corp.intel.com>
	<20040414022055.GB7611@ca2.us.oracle.com> <407D8D22.6050802@oracle.com>
Message-ID: <20040414192205.GC7611@ca2.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Definitely could be.  Dynamic resizing is not much harder than
dynamically changing the root inode, especially since you have the
advantage of locking out all allocs by taking the global bitmap lock.  
Using the same method, the release lock would be the signal for other
nodes to resize their in-memory bitmaps.  Wouldn't be too difficult.

-k

On Wed, Apr 14, 2004 at 12:12:34PM -0700, Sunil Mushran wrote:
> uhhh... I hope that this is NOT a precursor to dynamic resizing
> of the volume too. :-)
> 
> Kurt Hackel wrote:
> 
> >Hi Xiaofeng,
> >
> >Unfortunately this is the normal behavior of OCFS.  When the filesystem
> >was originally ported from Windows NT, there was no provision for root
> >directory permissions (or any other permissions for that matter).  The
> >only way to change the permissions on the root currently is to use the
> >tuneocfs tool to change the permissions, uid and/or gid.
> >
> >If anyone wants to fix this, they would have to make a lock structure
> >somewhere on the header of the disk (plenty of space there) and
> >permanently set the OIN_MAP part of the lock structure to all nodes.
> >Then you would have to handle the release part of that special lock to
> >understand how to update the root inode when another node changes the
> >permissions, etc.  Basically need to broadcast the change, and not
> >continue doing anything locally that depends on the change until you
> >have gotten a response from all live nodes.
> >
> >
> >Thanks!
> >-kurt
> >
> >
> >On Wed, Apr 14, 2004 at 09:46:30AM +0800, Ling, Xiaofeng wrote:
> > 
> >
> >>HI
> >>	I create a directory /ocfs, and take it the mount point of ocfs2
> >>filesystem, but I can not
> >>use "chmod 777" to change its permission, it always shows 755.
> >>Seems this breaks a lot LTP test cases.
> >>I report it as bug 56.
> >>_______________________________________________
> >>Ocfs2-devel mailing list
> >>Ocfs2-devel@oss.oracle.com
> >>http://oss.oracle.com/mailman/listinfo/ocfs2-devel
> >>   
> >>
> >_______________________________________________
> >Ocfs2-devel mailing list
> >Ocfs2-devel@oss.oracle.com
> >http://oss.oracle.com/mailman/listinfo/ocfs2-devel
> > 
> >
> 
> 
