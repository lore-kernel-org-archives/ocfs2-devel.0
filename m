From: Jan Kara <jack@suse.cz>
Date: Wed, 3 Jun 2009 15:31:35 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix possible deadlock
	in	ocfs2_global_read_dquot()
In-Reply-To: <20090603001554.GD31976@mail.oracle.com>
References: <1243945445-25847-1-git-send-email-jack@suse.cz>
	<1243945445-25847-2-git-send-email-jack@suse.cz>
	<20090603001554.GD31976@mail.oracle.com>
Message-ID: <20090603133135.GA5650@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue 02-06-09 17:15:54, Joel Becker wrote:
> On Tue, Jun 02, 2009 at 02:23:59PM +0200, Jan Kara wrote:
> > It is not possible to get a read lock and then try to get the same write lock
> > in one thread as that can block on downconvert being requested by other node
> > leading to deadlock. So first drop the quota lock for reading and only after
> > that get it for writing.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ocfs2/quota_global.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
> > index 1ed0f7c..edfa60c 100644
> > --- a/fs/ocfs2/quota_global.c
> > +++ b/fs/ocfs2/quota_global.c
> > @@ -421,6 +421,7 @@ int ocfs2_global_read_dquot(struct dquot *dquot)
> >  	OCFS2_DQUOT(dquot)->dq_originodes = dquot->dq_dqb.dqb_curinodes;
> >  	if (!dquot->dq_off) {	/* No real quota entry? */
> >  		/* Upgrade to exclusive lock for allocation */
> > +		ocfs2_qinfo_unlock(info, 0);
> >  		err = ocfs2_qinfo_lock(info, 1);
> >  		if (err < 0)
> >  			goto out_qlock;
> 
> 	Can other nodes change the state of dq_off while you're
> getting the exclusive?  I'm wondering if you have to retry the
> qtree_read_dquot(), and I don't know enough about the code to say yes or
> no.
  Good question. No, we don't have to restart it since we also hold a
global quotafile lock which protects us from other nodes adding the quota
entry. There's a comment about it just above ocfs2_global_read_dquot()...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
