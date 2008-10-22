From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 22 Oct 2008 10:31:49 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Add quota calls for allocation	and
	freeing of inodes and space
In-Reply-To: <20081022144900.GK13868@duck.suse.cz>
References: <1224523443806-git-send-email-jack@suse.cz>
	<20081021233446.GI2871@mail.oracle.com>
	<20081022144900.GK13868@duck.suse.cz>
Message-ID: <20081022173149.GD27819@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Oct 22, 2008 at 04:49:00PM +0200, Jan Kara wrote:
> On Tue 21-10-08 16:34:46, Joel Becker wrote:
> > On Mon, Oct 20, 2008 at 07:23:58PM +0200, Jan Kara wrote:
> > > Add quota calls for allocation and freeing of inodes and space, also update
> > > estimates on number of needed credits for a transaction. Move out inode
> > > allocation from ocfs2_mknod_locked() because vfs_dq_init() must be called
> > > outside of a transaction.
> > > 
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> > > @@ -5954,6 +5955,8 @@ static int ocfs2_do_truncate(struct ocfs2_super *osb,
> > >  		goto bail;
> > >  	}
> > >  
> > > +	vfs_dq_free_space_nodirty(inode,
> > > +			ocfs2_clusters_to_bytes(osb->sb, clusters_to_del));
> > >  	spin_lock(&OCFS2_I(inode)->ip_lock);
> > >  	OCFS2_I(inode)->ip_clusters = le32_to_cpu(fe->i_clusters) -
> > >  				      clusters_to_del;
> > 
> > 	In this one instance, you don't clean up the quota change on
> > error, even though clusters_to_del might remain allocated.  How come?
>   Good point. Is there a way to find out how many clusters were actually
> truncated before we failed?

	Not quite sure, really.  And this brings up the second question.

> > 	On that note, I don't see us a) fixing the inode up on failure
> > or b) writing out the new values.  Now, I remember from the past that we
> > allow a smaller i_clusters than actually in the tree, because our alloc
> > code can handle that.  So I'm sure that the fallout from us not fixing
> > up i_clusters and/or writing it is safe.
> > 	But I wonder what the right behavior is with regards to quota.
>   Well, quota usage must be always in sync with i_clusters - or better
> i_blocks - because on chown or chgrp, that is what you're going to transfer
> from one user to another one.
>   As a side note, I've actually noticed a few paths (even for cases of
> ENOSPC) in OCFS2 where if we fail during allocation, we actually leave
> behind allocated blocks not attached anywhere (i.e., only fsck can reclaim
> them). I discussed it with Mark and it's not completely trivial to fix. So
> I've worked it around so that quota allocation is done before allocating
> any blocks and I also tried to take care that at least quota stays correct
> after a failure.

	Right, there are a couple places like this, and the second
question is what matters for quota - what is supposed to be allocated
(i_clusters) or what is really allocated (only different from i_clusters
in these corner cases).
	In that truncate case above, i_clusters on the ocfs2_dinode will
stay at the "supposed to be truncated" number, but journal_dirty() isn't
called.  If nothing else happens to that buffer, it won't be written.
However, if it is written out due to another operation, the smaller
i_clusters will appear on disk.  This is a safe behavior from the view
of the file (truncate happened or did not).  The fact that the
allocation remains in both cases is something we silently handle in the
allocation paths and clean up in fsck when we spot it.

Joel

-- 

Life's Little Instruction Book #267

	"Lie on your back and look at the stars."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
