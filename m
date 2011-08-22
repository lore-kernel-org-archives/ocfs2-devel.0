From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Mon, 22 Aug 2011 16:55:57 +0800
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2: limit the number of inodes in
 orphanscan
In-Reply-To: <20110822081940.GA25447@noexit.corp.google.com>
References: <201107291006.p6TA6aSZ010899@acsmt358.oracle.com>
	<20110822044722.GJ31134@noexit.corp.google.com>
	<20110822055100.GA13398@laptop.jp.oracle.com>
	<20110822081940.GA25447@noexit.corp.google.com>
Message-ID: <20110822085556.GA17681@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 11-08-22 01:19, Joel Becker wrote:
> On Mon, Aug 22, 2011 at 01:51:01PM +0800, Wengang Wang wrote:
> > Hi Joel,
> > 
> > On 11-08-21 21:47, Joel Becker wrote:
> > > On Fri, Jul 29, 2011 at 06:06:23PM +0800, Wengang Wang wrote:
> > > > During orphanscan, limit the scan number in a single loop to avoid OOM.
> > > 
> > > How does this OOM?  Please explain this in the patch and in the patch
> > > description.  Or, conversely, free the resources the orphan scan is done
> > > using.
> > 
> > Explaination why it OOM:
> > In current code, when recoverying orphan dirs, we are doing it like this:
> > 
> > lock orphandir
> > read out all the inodes under the orphandir to a list
> > unlock the orphandir
> > #above see ocfs2_queue_orphans()
> > and the iput all the inodes in the list to delete the on disk inode
> > #above see ocfs2_recover_orphans()
> > 
> > For normal case, there are no many files under orphandir, there is no problem.
> > But for an extreme case, there are a huge number of files under orphandir,
> > huge size of memory is needed to hold the inodes. It is possible to exhaust
> > memory, then OOM occurs.
> 
> 	This makes sense.  But you didn't describe this in the patch or
> the patch description ;-)

Yes :) Since the following, I didn't. And sure I will add them if the
patch will get committed.
> 
> > The fix in this patch depends on patch
> >   "ocfs2: ocfs2_dir_foreach returns the error turned by filldir"
> > Since NAK for that patch, please ignore this too.
> 
> 	Why is that required?
> 

ocfs2_dir_foreach deals with all direntries from begining to end if
nothing breaks it. filldir returning an error is a breaker.

For current code, though filldir returning error breaks the loop, it doesn't
tell why. The caller then doesn't know it's break or a finish thus no way
to decide next action should be "continue looping" or "returning to caller"

The code in this patch is not full fix for the problem, it depends on
also patch
	[PATCH 3/4] ocfs2: fix slow deleting
#this patch is [PATCH 4/4].

For the 4 patches 
	[PATCH 1/4] ocfs2: make direntry invalid when deleting it
	[PATCH 2/4] ocfs2: ocfs2_dir_foreach returns the error turned by filldir
	[PATCH 3/4] ocfs2: fix slow deleting
	[PATCH 4/4] ocfs2: limit the number of inodes in orphanscan
The later depends on the earlier.

Looking at all of them, you can know I am using the error code returned
by filldir, -EAGAIN, to indicate the break.

thanks,
wengang.
