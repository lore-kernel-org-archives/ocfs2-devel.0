From: Joel Becker <jlbec@evilplan.org>
Date: Mon, 22 Aug 2011 01:19:42 -0700
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2: limit the number of inodes in
 orphanscan
In-Reply-To: <20110822055100.GA13398@laptop.jp.oracle.com>
References: <201107291006.p6TA6aSZ010899@acsmt358.oracle.com>
	<20110822044722.GJ31134@noexit.corp.google.com>
	<20110822055100.GA13398@laptop.jp.oracle.com>
Message-ID: <20110822081940.GA25447@noexit.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Aug 22, 2011 at 01:51:01PM +0800, Wengang Wang wrote:
> Hi Joel,
> 
> On 11-08-21 21:47, Joel Becker wrote:
> > On Fri, Jul 29, 2011 at 06:06:23PM +0800, Wengang Wang wrote:
> > > During orphanscan, limit the scan number in a single loop to avoid OOM.
> > 
> > How does this OOM?  Please explain this in the patch and in the patch
> > description.  Or, conversely, free the resources the orphan scan is done
> > using.
> 
> Explaination why it OOM:
> In current code, when recoverying orphan dirs, we are doing it like this:
> 
> lock orphandir
> read out all the inodes under the orphandir to a list
> unlock the orphandir
> #above see ocfs2_queue_orphans()
> and the iput all the inodes in the list to delete the on disk inode
> #above see ocfs2_recover_orphans()
> 
> For normal case, there are no many files under orphandir, there is no problem.
> But for an extreme case, there are a huge number of files under orphandir,
> huge size of memory is needed to hold the inodes. It is possible to exhaust
> memory, then OOM occurs.

	This makes sense.  But you didn't describe this in the patch or
the patch description ;-)

> The fix in this patch depends on patch
>   "ocfs2: ocfs2_dir_foreach returns the error turned by filldir"
> Since NAK for that patch, please ignore this too.

	Why is that required?

Joel

-- 

"Practice random acts of kindness and senseless acts of beauty."

 Oh, and don't forget where your towel is.

			http://www.jlbec.org/
			jlbec at evilplan.org
