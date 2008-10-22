From: Jan Kara <jack@suse.cz>
Date: Wed, 22 Oct 2008 15:57:43 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2: Enable quota accounting on mount,
	disable on umount
In-Reply-To: <20081021235155.GJ2871@mail.oracle.com>
References: <12245234432502-git-send-email-jack@suse.cz>
	<20081021235155.GJ2871@mail.oracle.com>
Message-ID: <20081022135743.GI13868@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue 21-10-08 16:51:55, Joel Becker wrote:
> On Mon, Oct 20, 2008 at 07:23:59PM +0200, Jan Kara wrote:
> > Enable quota usage tracking on mount and disable it on umount. Also
> > add support for quota on and quota off quotactls and usrquota and
> > grpquota mount options.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> 
> 	Looks good, with one small comment.
> 
> > @@ -660,6 +798,22 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
> >  	osb->preferred_slot = parsed_options.slot;
> >  	osb->osb_commit_interval = parsed_options.commit_interval;
> >  	osb->local_alloc_size = parsed_options.localalloc_opt;
> > +	if (osb->s_mount_opt & OCFS2_MOUNT_USRQUOTA &&
> > +	    !OCFS2_HAS_RO_COMPAT_FEATURE(sb,
> > +					 OCFS2_FEATURE_RO_COMPAT_USRQUOTA)) {
> > +		status = -EINVAL;
> > +		mlog(ML_ERROR, "User quota requested but filesystem feature "
> > +			       "is not set\n");
> 
> 	Can we say "User quotas were requested, but this filesystem does not
> have the feature enabled.\n"?  The same for group quotas.
  Of course. I always take a language advice from a native speaker ;).
Done.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
