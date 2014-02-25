From: Jan Kara <jack@suse.cz>
Date: Tue, 25 Feb 2014 22:18:08 +0100
Subject: [Ocfs2-devel] [PATCH 6/6] ocfs2: Revert iput deferring code in
 ocfs2_drop_dentry_lock
In-Reply-To: <20140225200236.GK5716@wotan.suse.de>
References: <1392975904-16944-1-git-send-email-jack@suse.cz>
	<1392975904-16944-7-git-send-email-jack@suse.cz>
	<20140225200236.GK5716@wotan.suse.de>
Message-ID: <20140225211808.GB21329@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue 25-02-14 12:02:36, Mark Fasheh wrote:
> I think I would have preferred this be broken up to make review easier. That
> said, I didn't find anything wrong with the code changes (which took me
> longer to review, etc)
> 
> Reviewed-by: Mark Fasheh <mfasheh@suse.de>
  Thanks for review Mark!

								Honza

> On Fri, Feb 21, 2014 at 10:45:04AM +0100, Jan Kara wrote:
> > From: Goldwyn Rodrigues <rgoldwyn@suse.de>
> > 
> > The following patches are reverted in this patch because these
> > patches caused performance regression in the remote unlink() calls.
> > 
> > ea455f8ab68338ba69f5d3362b342c115bea8e13 - ocfs2: Push out dropping
> > of dentry lock to ocfs2_wq
> > f7b1aa69be138ad9d7d3f31fa56f4c9407f56b6a - ocfs2: Fix deadlock on umount
> > 5fd131893793567c361ae64cbeb28a2a753bbe35 - ocfs2: Don't oops in
> > ocfs2_kill_sb on a failed mount
> > 
> > Previous patches in this series removed the possible deadlocks from
> > downconvert thread so the above patches shouldn't be needed anymore.
> > 
> > The regression is caused because these patches delay the iput() in case
> > of dentry unlocks. This also delays the unlocking of the open lockres.
> > The open lockresource is required to test if the inode can be wiped from
> > disk or not. When the deleting node does not get the open lock, it marks
> > it as orphan (even though it is not in use by another node/process)
> > and causes a journal checkpoint. This delays operations following the
> > inode eviction. This also moves the inode to the orphaned inode
> > which further causes more I/O and a lot of unneccessary orphans.
> > 
> 
> --
> Mark Fasheh
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
