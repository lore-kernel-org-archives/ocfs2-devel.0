From: Jan Kara <jack@suse.cz>
Date: Tue, 21 Jul 2009 10:58:06 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2: flush dentry lock drop when
	sync	ocfs2 volume.
In-Reply-To: <20090720202524.GB7768@mail.oracle.com>
References: <1248080922-24908-1-git-send-email-tao.ma@oracle.com>
	<20090720123401.GA15341@duck.suse.cz>
	<20090720190846.GA7768@mail.oracle.com>
	<20090720202524.GB7768@mail.oracle.com>
Message-ID: <20090721085806.GA4775@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon 20-07-09 13:25:24, Joel Becker wrote:
> On Mon, Jul 20, 2009 at 12:08:46PM -0700, Joel Becker wrote:
> > On Mon, Jul 20, 2009 at 02:34:01PM +0200, Jan Kara wrote:
> > > +void ocfs2_drop_dl_inodes(struct work_struct *work)
> > > +{
> > > +	struct ocfs2_super *osb = container_of(work, struct ocfs2_super,
> > > +					       dentry_lock_work);
> > > +
> > > +	__ocfs2_drop_dl_inodes(osb, DL_INODE_DROP_COUNT);
> > > +	/*
> > > +	 * Don't queue dropping if umount is in progress. We flush the
> > > +	 * list in ocfs2_dismount_volume
> > > +	 */
> > > +	spin_lock(&dentry_list_lock);
> > > +	if (osb->dentry_lock_list &&
> > > +	    !ocfs2_test_osb_flag(osb, OCFS2_OSB_UMOUNT))
> > >  		queue_work(ocfs2_wq, &osb->dentry_lock_work);
> > >  	spin_unlock(&dentry_list_lock);
> > >  }
> > 
> > 	The approach is good, but boy, I wish we could use vol_state
> > instead of a flag.  We are now tracking the mount/umount state in how
> > many places?
> 
> 	A quick #ocfs2 discussion ensued.  Let's rename OCFS2_OSB_UMOUNT
> to OCFS2_OSB_DROP_DENTRY_LOCK_IMMED.  That flag doesn't mean anything
> other than the dentry lock behavior, so we'll name it specific to its
> purpose.
> 	I think the rest of the patch looked good, so please resend with
> the renamed flag and a clean patch header and I'll verify and apply.
  OK, attached is updated version of the patch.
BTW, Joel, did you have any chance of looking at the quota fixes I've sent
you last week?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
-------------- next part --------------
A non-text attachment was scrubbed...
Name: 0001-ocfs2-Fix-deadlock-on-umount.patch
Type: text/x-patch
Size: 6482 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20090721/5433e57b/attachment.bin 
