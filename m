From: Jan Kara <jack@suse.cz>
Date: Wed, 22 Oct 2008 13:44:39 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2: Support nested transactions
In-Reply-To: <20081021203210.GD2871@mail.oracle.com>
References: <12245234433804-git-send-email-jack@suse.cz>
	<20081021203210.GD2871@mail.oracle.com>
Message-ID: <20081022114439.GD13868@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue 21-10-08 13:32:10, Joel Becker wrote:
> On Mon, Oct 20, 2008 at 07:23:52PM +0200, Jan Kara wrote:
> > OCFS2 can easily support nested transactions. We just have to
> > take care and not spoil statistics acquire semaphore unnecessarily.
> 
> 	I'm guessing this is required for the quota code, because it
> wants to start its own transaction underneath the transaction ocfs2 is
> doing?  Is there a way to have ocfs2 just pass the handle to the quota
> op (I'm guessing not because it's in the VFS)?
  Exactly and moreover there are paths in VFS which can get to that place
without starting a transaction and other paths which get there with a
transaction started and it's easier to not have to care.

> 	This just scares me a little.
  Well, unless OCFS2 does with transactions something non-standard (which I
don't think so), it should not be a problem :) Quota on ext3/4 does exactly
the same thing.

> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ocfs2/journal.c |   14 +++++++-------
> >  1 files changed, 7 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> > index c47bc2a..b3e24f9 100644
> > --- a/fs/ocfs2/journal.c
> > +++ b/fs/ocfs2/journal.c
> > @@ -256,11 +256,9 @@ handle_t *ocfs2_start_trans(struct ocfs2_super *osb, int max_buffs)
> >  	BUG_ON(osb->journal->j_state == OCFS2_JOURNAL_FREE);
> >  	BUG_ON(max_buffs <= 0);
> >  
> > -	/* JBD might support this, but our journalling code doesn't yet. */
> > -	if (journal_current_handle()) {
> > -		mlog(ML_ERROR, "Recursive transaction attempted!\n");
> > -		BUG();
> > -	}
> > +	/* Nested transaction? Just return the handle... */
> > +	if (journal_current_handle())
> > +		return journal_start(journal, max_buffs);
> >  
> >  	down_read(&osb->journal->j_trans_barrier);
> >  
> > @@ -285,16 +283,18 @@ handle_t *ocfs2_start_trans(struct ocfs2_super *osb, int max_buffs)
> >  int ocfs2_commit_trans(struct ocfs2_super *osb,
> >  		       handle_t *handle)
> >  {
> > -	int ret;
> > +	int ret, nested;
> >  	struct ocfs2_journal *journal = osb->journal;
> >  
> >  	BUG_ON(!handle);
> >  
> > +	nested = handle->h_ref > 1;
> >  	ret = journal_stop(handle);
> >  	if (ret < 0)
> >  		mlog_errno(ret);
> >  
> > -	up_read(&journal->j_trans_barrier);
> > +	if (!nested)
> > +		up_read(&journal->j_trans_barrier);
> >  
> >  	return ret;
> >  }
> 
> 	If we're doing to do this, I'd like to see a check in
> ocfs2_commit_trans() to make sure we're running ABBA nested and not ABAB
> overlapping.  Perhaps a flag on osb->journal somehow?
  Hmm, how do you find out to which ocfs2_start_trans() does
ocfs2_commit_trans() belong? Note that for nested transaction, number of
credits requested is actually discarded so the only thing it really does is
just increase the reference count of the handle.
  As I'm looking into my changes, it could even be cleaned up a bit so that
j_trans_barrier is taken and dropped always and only increasing of
j_num_trans would be conditioned on reference being the last one... I can
do that if you like it more like that.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
