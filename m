From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Mon Mar 15 16:40:31 2004
Subject: [Ocfs2-devel] [PATCH]2.6 mechanism for holding private inode data
In-Reply-To: <20040315221654.GD20057@ca-server1.us.oracle.com>
References: <200403110449.i2B4ncDw032388@penguin.co.intel.com>
	<20040311215300.GA7623@penguin.co.intel.com>
	<20040312204747.GA20057@ca-server1.us.oracle.com>
	<20040312210701.GA12754@penguin.co.intel.com>
	<20040313000913.GB20057@ca-server1.us.oracle.com>
	<20040314223440.GA1408@penguin.co.intel.com>
	<20040315221654.GD20057@ca-server1.us.oracle.com>
Message-ID: <20040315223612.GA8086@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Mar 15, 2004 at 02:16:54PM -0800, Mark Fasheh wrote:
> On Sun, Mar 14, 2004 at 02:34:40PM -0800, Rusty Lynch wrote:
> > Here is a patch that stores the inode private data as you talked about above.
> > There is a little more complexity because you have to handle the cases where:
> > * new inodes are created via ocfs_mknod and ocfs_symlink, and we need to
> >   start setting private data before ocfs_populate_inode
> > * reading the root inode in ocfs_read_inode2 (2.4 kernel) or
> >   ocfs_read_locked_inode (2.6 kernel) where we just directly populate the
> >   inode and do not call ocfs_populate_inode()
> this is good. I'm going to do some testing on this today, though it looks
> pretty sane.
> 
> > There is really no difference between a 2.4 and 2.6 build (other then where
> > to put the code for reading the root inode.)
> Yeah, and the code is so much cleaner now too :)
> Just to be sure, this covers all you need in 2.6 to get the inode stuff
> going too, correct? For 2.6, it looks like you're using the generic_ip
> route, which is fine if you feel that there aren't any major disadvantages
> (the only thing I can think of is memory allocation related).

yes, this is all the 2.6 port needs to get the private data for inodes correct.
We are basically utilizing the legacy path on 2.6.  The only real disadvantage
I see is just that the code is more complex (when you only take the 2.6 code
into consideration.)

With this patch (and also the patch I sent earlier to ocfs_unlink), the only 
major functionality holes in 2.6 are:
* when you attempt to umount the volume, ocfs_released_cached_oin() will
  stumble across a oin->lock_res that has already been free'ed, but not
  set to null (oops'ing when we try to dereference ->signature).
* Something is screwy when we try to write file data.  All the file meta
  data seems to be correct, and we properly allocate blocks on disk, but
  only random garbage makes it into the extents

Other then that I can move files, delete files, read files, make symbolic 
links, follow symbolic links, etc.

    --rusty
