From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Sun, 11 Jun 2006 10:45:10 -0700
Subject: [Ocfs2-devel] ext2 attributes for OCFS2
In-Reply-To: <20060610123253.GA23924@MAIL.13thfloor.at>
References: <20060610123253.GA23924@MAIL.13thfloor.at>
Message-ID: <20060611174510.GW3082@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hey Herbert,

On Sat, Jun 10, 2006 at 02:32:53PM +0200, Herbert Poetzl wrote:
> did a first hack on adding the iattrs (ext2) to OCFS2. it is currently for
> Linux-VServer patched kernels and I need to clean it up a little more (and
> of course test it), but I thought I'd ask you folks what you think about
> the general idea and the implementation.
Well it definitely looks like things are going in a good direction :) How
many of these attributes were you planning to implement by the way? I'm
thinking we probably want to cover at least some of the basics
- immutable, appends... Maybe the vfs already handles those for us - I'll
have to read more code to figure that out. Patch comments below.

> here is a link to the patch, if there is some
> interest from your side, I'll prepare one for
> mainline ...
> 
> http://vserver.13thfloor.at/Experimental/delta-ocfs2-feat01.diff
You probably want to move the cluster lock in the OCFS2_IOC_SETFLAGS case up
a bit so that you can be sure your inode image is up to date within the
cluster. Similarly, you'll probably want to take a read-only meta data lock
in the OCFS2_IOC_GETFLAGS case.

OCFS2 makes use of a small area associated with locks (called a Lock Value
Block) to stuff commonly used inode information. This helps the file system
avoid a disk read when updating inode information due to a new lock acquiry
- ocfs2_meta_lock_update() is the function responsible for this. These new
attributes should be put in the lvb as we'll want to be able to test their
existence by checking the struct inode under cluster lock (as opposed to
having to read off disk and checking the disk inode flags). Luckily this is
pretty easy - you already handled the disk cases by updating
ocfs2_populate_inode() and ocfs2_refresh_inode(). The lvb is a similar
process. I'll outline the steps below.

At the top of dlmglue.h you'll see the ocfs2_meta_lvb structure definition.
Just go ahead and take some of the reserved fields for our purposes.
Be sure to bump the value of OCFS2_LVB_VERSION so that node which don't
understand the new field know just to ignore the lvb.

The next step is to update __ocfs2_stuff_meta_lvb() to understand how to
write the values into the lvb, and ocfs2_refresh_inode_from_lvb() to take
them from the lvb into the inode.

We only need to stuff these new flags into the lvb btw, so don't worry about
the other ocfs2_dinode->i_flags - they're not nearly as dynamic and aren't
really checked anywhere we won't already be using the disk.

I'm thinking about whether we want to mark the existence of this feature in
the superblock (probably as a compat flag). More on this later I suppose.

> note: some attributes (like the noatime) do not (yet) make sense for
> OCFS2, It's just a generic approach ...
Right. What's up with the OCFS2_BARRIER_FL and OCFS2_IUNLINK flags? Am
I correct when I don't notice those in ext3?

Thanks!
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh at oracle.com
