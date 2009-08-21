From: Jan Kara <jack@suse.cz>
Date: Fri, 21 Aug 2009 16:30:49 +0200
Subject: [Ocfs2-devel] [PATCH 13/17] ocfs2: Update syncing
	after	splicing to match generic version
In-Reply-To: <20090821013617.GI10558@mail.oracle.com>
References: <1250697884-22288-1-git-send-email-jack@suse.cz>
	<1250697884-22288-14-git-send-email-jack@suse.cz>
	<20090821013617.GI10558@mail.oracle.com>
Message-ID: <20090821143049.GC3007@duck.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, hch@infradead.org, ocfs2-devel@oss.oracle.com, mfasheh@suse.com

On Thu 20-08-09 18:36:17, Joel Becker wrote:
> On Wed, Aug 19, 2009 at 06:04:40PM +0200, Jan Kara wrote:
> > Update ocfs2 specific splicing code to use generic syncing helper.
> > 
> > CC: Joel Becker <Joel.Becker@oracle.com>
> > CC: ocfs2-devel at oss.oracle.com
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ocfs2/file.c |   27 ++++++---------------------
> >  1 files changed, 6 insertions(+), 21 deletions(-)
> > 
> > diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> > index 1c71f0a..bd7fdf8 100644
> > --- a/fs/ocfs2/file.c
> > +++ b/fs/ocfs2/file.c
> > @@ -1990,31 +1990,16 @@ static ssize_t ocfs2_file_splice_write(struct pipe_inode_info *pipe,
> >  
> >  	if (ret > 0) {
> >  		unsigned long nr_pages;
> > +		int err;
> >  
> > -		*ppos += ret;
> >  		nr_pages = (ret + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
> >  
> > -		/*
> > -		 * If file or inode is SYNC and we actually wrote some data,
> > -		 * sync it.
> > -		 */
> > -		if (unlikely((out->f_flags & O_SYNC) || IS_SYNC(inode))) {
> > -			int err;
> > -
> > -			mutex_lock(&inode->i_mutex);
> > -			err = ocfs2_rw_lock(inode, 1);
> > -			if (err < 0) {
> > -				mlog_errno(err);
> > -			} else {
> > -				err = generic_osync_inode(inode, mapping,
> > -						  OSYNC_METADATA|OSYNC_DATA);
> > -				ocfs2_rw_unlock(inode, 1);
> > -			}
> > -			mutex_unlock(&inode->i_mutex);
> > +		err = generic_write_sync(out, *ppos, ret);
> > +		if (err)
> > +			ret = err;
> > +		else
> > +			*ppos += ret;
> 
> 	You've removed the rw_lock around the sync.  Any reason why?
  Ah, I should have written in the changelog: generic_write_sync() will
acquire i_mutex so to preserve lock ordering (i_mutex -> rw_lock) we cannot
hold it while calling generic_write_sync(). Furthermore, I didn't see point
for holding it while calling generic_write_sync() since we don't hold it
in fsync() path either.
  I'll add something like this to the changelog.

									Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
