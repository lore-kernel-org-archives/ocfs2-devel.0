From: Daniel Phillips <phillips@istop.com>
Date: Fri Aug  5 15:39:10 2005
Subject: [Ocfs2-devel] Adding Posix locking to OCFS2
Message-ID: <200508060639.18207.phillips@istop.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi guys,

I'm interested in helping pull on the oars to help get the rest of the way to 
Posix compliance.  On the "talk is cheap" principle, I'll start with some 
cheap talk.

First, you don't have to add range locks to your DLM just to handle Posix 
locks.  Posix locking can be handled by a completely independent and crude 
mechanism.  You can take your time merging this with your DLM, or switching 
to another DLM if that's what you really want to do.

In the long run, the DLM has to have range locking in order to implement 
efficient, sub-file granularity caching, but the VFS still needs work to 
support this properly anyway, so there is no immediate urgency.  And Posix 
locking is even less of a reason to panic.

Now some comments on how the hookable Posix locking VFS interface works.  
First off, it is not a thing of beauty.  The principle is simple.  By 
default, the VFS maintains a simple minded range lock accounting structure.  
It is just a linear list of range locks per inode.  When somebody wants a new 
lock, the VFS searches the whole list to find collisions.  If a lock needs to 
be split, merged or whatever, these are very basic list operations.  The code 
is short.  It is obviously prone to efficiency bugs, but I have not heard 
people complaining.

The hook works by simply short-circuiting into your filesystem just before the 
VFS touches any of its own lock accounting data.  Your filesystem gets the 
original ioctl arguments and you get to replicate a bunch of work that the 
VFS would have done, using its own data structure.  There are about 5 
shortcircuits like this.  See what I mean by not beautiful?  But it is fairly 
obvious how to use this interface.

On a cluster, every node needs to have the same view of Posix locks for inodes 
it is sharing.  The easiest way I know of to accomplish this is to have a 
Posix lock server in the cluster that keeps the same, bad old linear list of 
locks per Posix-locked inode, but exports operations on those locks over the 
network.  Not much challenge: a user space server and some tcp messaging.  
The server will count the nodes locking a given inode, and let the inode fall 
away when all are done.  I think inode deletion just works: the filesystem 
just has to wait for confirmation from the lock server that the Posix locks 
are dropped before it allows the normal delete path to continue.

Inodes that aren't shared don't require consulting the server, an easy 
optimization.

For failover, each node will keep its own list of Posix locks.  Exactly the 
same code the VFS already uses will do, just cut and paste it and insert the 
server messaging.  To fail over a lock server, the new server has to rollcall 
all cluster nodes to upload their Posix locks.

Now, obviously this locking should really be distributed, right?  Sure, but 
notice: the failover algorithm is the same regardless of single-server vs 
distributed; in the DLM case it just has to be executed on every node for the 
locks mastered on that node.  And oh, you have to deal with a new layer of 
bookkeeping to keep track of lock masters, and fail that over too.  And of 
course you want lock migration...

So my purpose today is to to introduce the VFS interface and to point out that 
this doesn't have to blow up into a gigantic project just to add correct 
Posix locking.

See here:

   http://lxr.linux.no/source/fs/locks.c#L1560
   if (filp->f_op && filp->f_op->lock) {

Regards,

Daniel
