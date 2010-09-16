From: Jan Kara <jack@suse.cz>
Date: Thu, 16 Sep 2010 11:55:53 +0200
Subject: [Ocfs2-devel] [PATCH] quota: Fix deadlock during path resolution
In-Reply-To: <20100915225208.GA1490@lst.de>
References: <1284586791-8245-1-git-send-email-jack@suse.cz>
	<20100915225208.GA1490@lst.de>
Message-ID: <20100916095553.GA3359@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, reiserfs-devel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Al Viro <viro@ZenIV.linux.org.uk>, Ted Ts'o <tytso@mit.edu>, Joel Becker <joel.becker@oracle.com>

On Thu 16-09-10 00:52:08, Christoph Hellwig wrote:
> On Wed, Sep 15, 2010 at 11:39:51PM +0200, Jan Kara wrote:
> > As Al Viro pointed out path resolution during Q_QUOTAON calls to quotactl
> > is prone to deadlocks. We hold s_umount semaphore for reading during the
> > path resolution and resolution itself may need to acquire the semaphore
> > for writing when e. g. autofs mountpoint is passed.
> > 
> > Solve the problem by performing the resolution before we get hold of the
> > superblock (and thus s_umount semaphore). The whole thing is complicated
> > by the fact that some filesystems (OCFS2) ignore the path argument. So to
> > distinguish between filesystem which want the path and which do not we
> > introduce new .quota_on_meta callback which does not get the path. OCFS2
> > then uses this callback instead of old .quota_on.
> 
> FYI I have a patch that switches ocfs to share the quota_on method with
> XFS which behaves the same, and consolidate the quota_off method for all
> filesystems.  I think that's better than adding yet another method.
> 
> I'll rebase it and send it out soon.
  Ok, that would be nice. I'll wait with my fix then.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
