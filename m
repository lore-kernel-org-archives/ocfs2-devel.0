From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Wed, 9 Apr 2014 15:10:29 -0700
Subject: [Ocfs2-devel] [patch 4/8] ocfs2: call
 ocfs2_update_inode_fsync_trans when updating any inode
In-Reply-To: <20140331020546.GD4488@wotan.suse.de>
References: <20140319211002.D199A5A4217@corp2gmr1-2.hot.corp.google.com>
	<20140331020546.GD4488@wotan.suse.de>
Message-ID: <20140409221029.GB9177@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sun, Mar 30, 2014 at 07:05:46PM -0700, Mark Fasheh wrote:
> On Wed, Mar 19, 2014 at 02:10:02PM -0700, Andrew Morton wrote:
> > From: "Darrick J. Wong" <darrick.wong@oracle.com>
> > Subject: ocfs2: call ocfs2_update_inode_fsync_trans when updating any inode
> > 
> > Ensure that ocfs2_update_inode_fsync_trans() is called any time we touch
> > an inode in a given transaction.  This is a follow-on to the previous
> > patch to reduce lock contention and deadlocking during an fsync operation.
> 
> This looks fine but I have a question - what happens if a future patch adds
> some disk structure change but forgets to call
> ocfs2_update_inode_fsync_trans(). Could we wind up skipping some blocks to
> sync in that case?

Yes, you'd almost certainly miss some blocks if such a programming error were
introduced.  It was tempting to try to stuff the functionality into
ocfs2_journal_dirty() rather than requiring a separate call, but that's not
really suitable since not all dirty buffers are tied to inodes.  I think the
only thing we can really do to ensure at review time that anything calling
ocfs2_start_trans() also include a call to ocfs2_update_inode_fsync_trans()
somewhere.

--D
> 	--Mark
> 
> --
> Mark Fasheh
