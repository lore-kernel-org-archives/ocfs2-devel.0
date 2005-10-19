From: David Teigland <teigland@redhat.com>
Date: Wed Oct 19 17:42:09 2005
Subject: [Ocfs2-devel] [RFC] Integration with external clustering
In-Reply-To: <20051019195654.GQ24589@marowsky-bree.de>
References: <43556F8B.3060105@suse.com>
	<20051018221849.GN11488@ca-server1.us.oracle.com>
	<43558422.9040607@suse.com>
	<20051019195654.GQ24589@marowsky-bree.de>
Message-ID: <20051019224221.GB4305@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Oct 19, 2005 at 09:56:54PM +0200, Lars Marowsky-Bree wrote:
> On 2005-10-18T19:24:18, Jeff Mahoney <jeffm@suse.com> wrote:
> 
> > > 	Have you also considered what this will or won't do to possible
> > > interaction with the CMan stack?  We'd love OCFS2 to handle both stacks.
> > I'm not really familiar with the CMan stack, but I was hoping that the
> > configuration I described would be easy enough for any userspace cluster
> > manager to handle. Lars and Andrew Beekhof are working with me on the
> > cluster side of things, so they'd be more familiar with the details here.
> 
> David, what are your thoughts? ;-)

Just catching up on this after being away for a while.  Not only has cman
moved entirely to user space, but a large portion of gfs (everything
related to cman and clustering) has also moved to user space.  So, a user
space gfs daemon (call it gfs_clusterd) interacts with the other user
space clustering systems and drives the bits of gfs in the kernel. 

Here are the main "knobs" gfs_clusterd uses to control a specific fs:

/sys/fs/gfs2/<fs_name>/lock_module/
                                   block
                                   mounted
                                   jid
                                   recover

When a gfs fs is mounted on a node:

. the mount process enters gfs-kernel
. the mount process sends a simple uevent to gfs_clusterd
. the mount process waits for gfs_clusterd to write 1 to /sys/.../mounted

. gfs_clusterd gets the mount uevent from gfs-kernel
. gfs_clusterd joins the cluster-wide "group" that represents the
  specific fs being mounted [1]
. gfs_clusterd tells gfs-kernel which journal the local node will use by
  writing the journal id to /sys/.../jid
. gfs_clusterd tells the mount process it can continue by writing 1
  to /sys/.../mounted
. the local node now has the fs mounted

[1] As part of the node being added to the group, gfs_clusterd on the
nodes that already have the fs mounted is notified of the new mounter for
the fs.

When a node that has a gfs file system mounted fails:

. the cluster infrastructure notifies gfs_clusterd that a node failed
. gfs_clusterd writes 1 to /sys/../block to block new lock requests from gfs
. the infrastructure notifies gfs_clusterd that gfs_clusterd is "stopped"
  (and therefore blocked) on all mounters
. gfs_clusterd tells gfs-kernel to recover the journal of the failed
  node by writing the journal id of the failed node to /sys/.../recover
. when journal recovery is done, gfs-kernel sends a uevent to gfs_clusterd
. gfs_clusterd tells gfs-kernel to continue normal operation by
  writing 0 to /sys/.../block

That's a simplified example of how we control gfs from user space.  Our
dlm is controlled in a similar way by the dlm_controld daemon.  Think of
the user daemon (gfs_clusterd) and kernel module (gfs.ko) as two parts of
a single system and sysfs/configfs as more of an internal communication
path between the two parts, not so much an external API.

It's the interfaces the two user daemons have with the cluster
infrastructure (membership/group manager, crm, etc) that would need to be
studied to use gfs in other environments.  None of this is easy, but
there's far more flexibility working it out in user space than in the
kernel.  The same may be the case for ocfs.

Dave
