From: Jan Kara <jack@suse.cz>
Date: Wed, 29 Oct 2008 03:30:46 +0100
Subject: [Ocfs2-devel] [PATCH 29/29] ocfs2: Enable quota accounting
	on	mount, disable on umount
In-Reply-To: <20081028191103.GB28483@mail.oracle.com>
References: <122488610212-git-send-email-jack@suse.cz>
	<12248861051597-git-send-email-jack@suse.cz>
	<20081028191103.GB28483@mail.oracle.com>
Message-ID: <20081029023046.GF24732@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue 28-10-08 12:11:03, Joel Becker wrote:
> On Sat, Oct 25, 2008 at 12:08:22AM +0200, Jan Kara wrote:
> > Enable quota usage tracking on mount and disable it on umount. Also
> > add support for quota on and quota off quotactls and usrquota and
> > grpquota mount options.
> > 
> 
> <snip>
> 
> > diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> > index 92539fe..bddc210 100644
> > --- a/fs/ocfs2/super.c
> > +++ b/fs/ocfs2/super.c
> > @@ -780,6 +950,23 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
> >  	atomic_set(&osb->vol_state, VOLUME_MOUNTED);
> >  	wake_up(&osb->osb_mount_event);
> >  
> > +	/* Now we can initialize quotas because we can afford to wait
> > +	 * for cluster locks recovery now. That also means that truncation
> > +	 * log recovery can happen but that waits for proper quota setup */
> > +	if (!(sb->s_flags & MS_RDONLY)) {
> > +		status = ocfs2_enable_quotas(osb);
> > +		if (status < 0) {
> > +			mlog_errno(status);
> > +			goto read_super_error;
> > +		}
> > +	}
> > +
> > +	ocfs2_complete_quota_recovery(osb);
> > +
> > +	/* Now we wake up again for processes waiting for quotas */
> > +	atomic_set(&osb->vol_state, VOLUME_MOUNTED_QUOTAS);
> > +	wake_up(&osb->osb_mount_event);
> > +
> >  	mlog_exit(status);
> >  	return status;
> >  
> 
> 	This hunk still has the bug where you are jumping to
> read_super_error after setting sb->s_root.  I'm guessing you have that
> fixed on your machine?
  Not yet fixed but yeah, I have it on my todo list :). These patches went
out before you pointed out the bug to me. Thanks for the review.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
