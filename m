From: Jan Kara <jack@suse.cz>
Date: Wed, 22 Oct 2008 16:49:00 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2: Add quota calls for allocation	and
	freeing of inodes and space
In-Reply-To: <20081021233446.GI2871@mail.oracle.com>
References: <1224523443806-git-send-email-jack@suse.cz>
	<20081021233446.GI2871@mail.oracle.com>
Message-ID: <20081022144900.GK13868@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue 21-10-08 16:34:46, Joel Becker wrote:
> On Mon, Oct 20, 2008 at 07:23:58PM +0200, Jan Kara wrote:
> > Add quota calls for allocation and freeing of inodes and space, also update
> > estimates on number of needed credits for a transaction. Move out inode
> > allocation from ocfs2_mknod_locked() because vfs_dq_init() must be called
> > outside of a transaction.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > @@ -5954,6 +5955,8 @@ static int ocfs2_do_truncate(struct ocfs2_super *osb,
> >  		goto bail;
> >  	}
> >  
> > +	vfs_dq_free_space_nodirty(inode,
> > +			ocfs2_clusters_to_bytes(osb->sb, clusters_to_del));
> >  	spin_lock(&OCFS2_I(inode)->ip_lock);
> >  	OCFS2_I(inode)->ip_clusters = le32_to_cpu(fe->i_clusters) -
> >  				      clusters_to_del;
> 
> 	In this one instance, you don't clean up the quota change on
> error, even though clusters_to_del might remain allocated.  How come?
  Good point. Is there a way to find out how many clusters were actually
truncated before we failed?

> 	On that note, I don't see us a) fixing the inode up on failure
> or b) writing out the new values.  Now, I remember from the past that we
> allow a smaller i_clusters than actually in the tree, because our alloc
> code can handle that.  So I'm sure that the fallout from us not fixing
> up i_clusters and/or writing it is safe.
> 	But I wonder what the right behavior is with regards to quota.
  Well, quota usage must be always in sync with i_clusters - or better
i_blocks - because on chown or chgrp, that is what you're going to transfer
from one user to another one.
  As a side note, I've actually noticed a few paths (even for cases of
ENOSPC) in OCFS2 where if we fail during allocation, we actually leave
behind allocated blocks not attached anywhere (i.e., only fsck can reclaim
them). I discussed it with Mark and it's not completely trivial to fix. So
I've worked it around so that quota allocation is done before allocating
any blocks and I also tried to take care that at least quota stays correct
after a failure.

> > @@ -908,7 +911,8 @@ void ocfs2_delete_inode(struct inode *inode)
> >  
> >  	mlog_entry("(inode->i_ino = %lu)\n", inode->i_ino);
> >  
> > -	if (is_bad_inode(inode)) {
> > +	/* Inode left after unsuccessful inode allocation? */
> > +	if (is_bad_inode(inode) || !OCFS2_I(inode)->ip_blkno) {
> >  		mlog(0, "Skipping delete of bad inode\n");
> >  		goto bail;
> >  	}
> 
> 	!ip_blkno is your way of saying you called
> ocfs2_get_init_inode() but failed ocfs2_claim_new_inode() in
> ocfs2_mknod_locked(), right?
  Or user is over quota...

> Probably want to adjust your comment to
> point out that is_bad_inode() comes from read_inode(), !ip_blkno from
> mknod().
  Good point. Will do.

> 	I checked into just having your failed mknod() call
> make_bad_inode(), but it doesn't fit.  We don't even want to get there.
  Yes, I was also looking into it before introducing the test and for some
reason I didn't like it much.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
