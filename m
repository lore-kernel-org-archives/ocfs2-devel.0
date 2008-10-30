From: Jan Kara <jack@suse.cz>
Date: Thu, 30 Oct 2008 08:24:59 +0100
Subject: [Ocfs2-devel] [PATCH 10/29] quota:
	Introduce	DQUOT_QUOTA_SYS_FILE flag
In-Reply-To: <20081029230934.GI15154@wotan.suse.de>
References: <122488610212-git-send-email-jack@suse.cz>
	<12248861031533-git-send-email-jack@suse.cz>
	<20081029230934.GI15154@wotan.suse.de>
Message-ID: <20081030072458.GC14500@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed 29-10-08 16:09:34, Mark Fasheh wrote:
> On Sat, Oct 25, 2008 at 12:08:03AM +0200, Jan Kara wrote:
> > If filesystem can handle quota files as system files hidden from users, we can
> > skip a lot of cache invalidation, syncing, inode flags setting etc. when
> > turning quotas on, off and quota_sync. Allow filesystem to indicate that it is
> > hiding quota files from users by DQUOT_QUOTA_SYS_FILE flag.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/dquot.c            |   45 ++++++++++++++++++++++++++++++---------------
> >  fs/quota.c            |    3 +++
> >  include/linux/quota.h |    7 +++++++
> >  3 files changed, 40 insertions(+), 15 deletions(-)
> > 
> > diff --git a/fs/dquot.c b/fs/dquot.c
> > index 96ed45b..5b82722 100644
> > --- a/fs/dquot.c
> > +++ b/fs/dquot.c
> > @@ -1627,6 +1627,11 @@ int vfs_quota_disable(struct super_block *sb, int type, unsigned int flags)
> >  		dqopt->ops[cnt] = NULL;
> >  	}
> >  	mutex_unlock(&dqopt->dqonoff_mutex);
> > +
> > +	/* Skip syncing and setting flags if quota files are hidden */
> > +	if (dqopt->flags & DQUOT_QUOTA_SYS_FILE)
> > +		goto put_inodes;
> > +
> >  	/* Sync the superblock so that buffers with quota data are written to
> >  	 * disk (and so userspace sees correct data afterwards). */
> >  	if (sb->s_op->sync_fs)
> > @@ -1651,6 +1656,12 @@ int vfs_quota_disable(struct super_block *sb, int type, unsigned int flags)
> >  				mark_inode_dirty(toputinode[cnt]);
> >  			}
> >  			mutex_unlock(&dqopt->dqonoff_mutex);
> > +		}
> > +	if (sb->s_bdev)
> > +		invalidate_bdev(sb->s_bdev);
> 
> Is the indentation here weird, or am I just reading this wrong?
  It is:
	for (...)
		if (...) {
			...
		}

  Which looks strange in the patch but otherwise is fine.

> Otherwise btw, this patch is a fantastic idea. I hadn't thought of it
> before, but this should save Ocfs2 a good amount of pain.
  Thanks :).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
