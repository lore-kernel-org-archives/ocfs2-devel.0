From: Jan Kara <jack@suse.cz>
Date: Wed, 22 Oct 2008 13:47:05 +0200
Subject: [Ocfs2-devel] [PATCH] quota: Add helpers to allow
	ocfs2	specific quota initialization and freeing
In-Reply-To: <20081021202216.GB2871@mail.oracle.com>
References: <1224523442408-git-send-email-jack@suse.cz>
	<20081021202216.GB2871@mail.oracle.com>
Message-ID: <20081022114705.GE13868@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue 21-10-08 13:22:16, Joel Becker wrote:
> On Mon, Oct 20, 2008 at 07:23:49PM +0200, Jan Kara wrote:
> > OCFS2 needs to peek whether quota structure is already in memory so
> > that it can avoid expensive cluster locking in that case. Similarly
> > when freeing dquots, it checks whether it is the last quota structure
> > user or not.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/dquot.c               |   30 ++++++++++++++++++++++++++++--
> >  include/linux/quotaops.h |    2 ++
> >  2 files changed, 30 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/dquot.c b/fs/dquot.c
> > index 3fde18b..c5016a2 100644
> > --- a/fs/dquot.c
> > +++ b/fs/dquot.c
> > @@ -660,6 +660,24 @@ static struct dquot *get_empty_dquot(struct super_block *sb, int type)
> >  }
> >  
> >  /*
> > + * Check whether dquot is in memory.
> > + * MUST be called with either dqptr_sem or dqonoff_mutex held
> > + */
> > +int dquot_is_cached(struct super_block *sb, unsigned int id, int type)
> > +{
> > +	unsigned int hashent = hashfn(sb, id, type);
> > +	int ret = 0;
> > +
> > +        if (!sb_has_quota_active(sb, type))
> > +		return 0;
> > +	spin_lock(&dq_list_lock);
> > +	if (find_dquot(hashent, sb, id, type) == NODQUOT)
> > +		ret = 1;
> > +	spin_unlock(&dq_list_lock);
> > +	return ret;
> > +}
> 
> 	I may have this backwards, but should that be "!= NODQUOT"?  As
> far as I can tell, NODQUOT means "not found", and returning 1 means
> "found".
  Of course, you are right. Thanks for catching this. Fixed.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
