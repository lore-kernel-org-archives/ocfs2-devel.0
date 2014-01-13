From: Joel Becker <jlbec@evilplan.org>
Date: Mon, 13 Jan 2014 07:42:01 -0800
Subject: [Ocfs2-devel] What's the need of OCFS2_INODE_MAYBE_ORPHANED?
In-Reply-To: <52CEDBF3.3010009@suse.de>
References: <CAJtY7HVQue79bLEUPXnN=fSbvcKS_mA8FUQbmaNE0dipSp1XoA@mail.gmail.com>
	<52CDFB7F.5010200@oracle.com> <52CE13AF.5080107@suse.de>
	<52CE3409.8080108@oracle.com> <52CEC3C4.20505@suse.de>
	<52CEC915.8040908@oracle.com> <52CECF96.4050900@suse.de>
	<52CED680.10501@oracle.com> <52CEDBF3.3010009@suse.de>
Message-ID: <20140113154201.GD18208@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 09, 2014 at 11:27:15AM -0600, Goldwyn Rodrigues wrote:
> >> Yes, I did not consider that.
> >> How about using open locks ro_holders count to identify this? That may
> >> just work. Thanks!
> > One problem I see in using open lock for this is it could be late.
> > Consider the scenario where node A removes the dentry and then the node
> > crashes before trying the try_open_lock. Node B does the file close
> > later but it doesn't know that the file was unlinked and doesn't do the
> > clean up.
> >
> > To me it appears OCFS2_INODE_MAYBE_ORPHANED is necessary. Any delay it
> > is causing must be addressed differently.
> 
> No, I don't mean to remove the OCFS2_INODE_MAYBE_ORPHANED flag, but set 
> it conditionally in ocfs2_dentry_convert_worker() based on the value of 
> the open locks held.

I'm confused by what you are attempting here.  We hold the dentry lock
until the final dpu() (see the comment in fs/ocfs2/dcache.c).  We should
never have ro_holders==0 unless we're flushing the entry from the
dcache.  Do you mean something else?

Joel

-- 

"Now Someone's on the telephone, desperate in his pain.
 Someone's on the bathroom floor doing her cocaine.
 Someone's got his finger on the button in some room.
 No one can convince me we aren't gluttons for our doom."

			http://www.jlbec.org/
			jlbec at evilplan.org
