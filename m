From: Cahill, Ben M <ben.m.cahill@intel.com>
Date: Tue Jun 22 16:25:54 2004
Subject: [Ocfs2-devel] The truncate_inode_page call ... g-lock
Message-ID: <0604335B7764D141945E20215310596002299E75@orsmsx404.amr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Well, another major feature of the g-lock layer is that it supports
plug-in inter-node lock management.  G-lock itself is not an inter-node
manager; it knows only about *this* node, and reaches out to an
inter-node lock manager when a lock is needed on this node.

OpenGFS' legacy "memexp" inter-node lock manager has been used by
OpenGFS for a few years.  We've been working recently to use OpenDLM as
the inter-node lock manager, mainly because memexp exhibits a single
point of failure in its lock storage server.  Other lock managers
(distributed or not, LAN based or not), such as yours, could be plugged
in as well, with a little bit of work to create a "lock module"
interface layer.  

So, it makes it easy to switch from one LM to another, depending upon
your needs.  There's even a "nolock" (fake inter-node lock manager)
module that plugs into g-lock if you're using just a single node.

-- Ben --

Opinions are mine, not Intel's

> -----Original Message-----
> From: wim.coekaerts@oracle.com [mailto:wim.coekaerts@oracle.com] 
> Sent: Tuesday, June 22, 2004 4:24 PM
> To: Cahill, Ben M
> Cc: Mark Fasheh; Zhang, Sonic; Ocfs2-Devel
> Subject: Re: [Ocfs2-devel] The truncate_inode_page call 
> inocfs_file_releasecaus es the severethroughput drop of file 
> reading in OCFS2.
> 
> yeah - unfortunately we don't have a real dlm :(
> 
> On Tue, Jun 22, 2004 at 12:55:10PM -0700, Cahill, Ben M wrote:
> > I don't know if it will be helpful, but I'll tell you a bit about
> > OpenGFS locking and flushing, etc.  You may have something like this
> > already, so I'll be brief:
> > 
> > OGFS uses the "g-lock" layer to coordinate inter-node and intra-node
> > (inter-process) locking.  It provides generic hooks to 
> invoke functions
> > when:
> > 
> > Acquiring a lock at inter-node level
> > Locking a lock at process level
> > Unlocking a lock at process level
> > Releasing a lock at inter-node level
> > 
> > The sets of functions are like other "ops" in Linux, a vector of
> > functions.  Each different type of lock (e.g. inode, 
> journal) has its
> > own set of functions (some sets are empty).  These 
> functions typically
> > flush to disk, read from disk, read or write lock value blocks, etc.
> > 
> > The g-lock layer caches an inter-node lock for 5 minutes 
> after its last
> > use within the node.  When requested by another node, it 
> will release a
> > cached lock immediately if it is not being used within the 
> node.  Since
> > a "glops" function is invoked when releasing the lock, this caching
> > mechanism provides some hysteresis for flushing, etc.
> > 
> > If you're interested in more info, see the rather lengthy 
> ogfs-locking
> > (a.k.a. "Locking") doc on opengfs.sourceforge.net/docs.php.
> > 
> > I did some work to extract the g-lock layer out of OGFS back in the
> > Fall.  You can find the "generic" code in OGFS CVS tree at:
> > 
> > opengfs/src/locking/glock
> > 
> > It's actually fairly compact for what it does.
> > 
> > -- Ben --
