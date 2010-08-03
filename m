From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Tue, 3 Aug 2010 09:13:18 +0800
Subject: [Ocfs2-devel] [PATCH 1/2 v2] ocfs2: Flush drive's caches on
 fdatasync
In-Reply-To: <20100802163842.GI3278@quack.suse.cz>
References: <1280754276-6741-1-git-send-email-jack@suse.cz>
	<20100802135539.GA2924@laptop.jp.oracle.com>
	<20100802163842.GI3278@quack.suse.cz>
Message-ID: <20100803011318.GA2370@laptop.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Appreciated!

thanks a lot.
wengang.
On 10-08-02 18:38, Jan Kara wrote:
>   Hi,
> 
> On Mon 02-08-10 21:55:39, Wengang Wang wrote:
> > I think it will be better if you mention the BARRIER mount option in the patch
> > description. That will accurately match your patch.
>   OK. So the description could be:
> When 'barrier' mount option is specified, we have to issue a cache flush
> during fdatasync. We have to do this even if inode doesn't have
> I_DIRTY_DATASYNC set because we still have to get written *data* to disk so
> that they are not lost in case of crash.
> 
>   Better?
> 
> 								Honza
> > On 10-08-02 15:04, Jan Kara wrote:
> > > We have to issue a cache flush during fdatasync even if inode doesn't have
> > > I_DIRTY_DATASYNC set because we still have to get written *data* to disk to
> > > observe fdatasync() guarantees.
> > > 
> > > Acked-by: Tao Ma <tao.ma@oracle.com>
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> > > ---
> > >  fs/ocfs2/file.c |   11 ++++++++++-
> > >  1 files changed, 10 insertions(+), 1 deletions(-)
> > > 
> > >   Joel, would you merge this and the following patch please? Thanks.
> > > 
> > > 								Honza
> > > 
> > > diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> > > index 2b10b36..3ed8efd 100644
> > > --- a/fs/ocfs2/file.c
> > > +++ b/fs/ocfs2/file.c
> > > @@ -36,6 +36,7 @@
> > >  #include <linux/writeback.h>
> > >  #include <linux/falloc.h>
> > >  #include <linux/quotaops.h>
> > > +#include <linux/blkdev.h>
> > >  
> > >  #define MLOG_MASK_PREFIX ML_INODE
> > >  #include <cluster/masklog.h>
> > > @@ -190,8 +191,16 @@ static int ocfs2_sync_file(struct file *file, int datasync)
> > >  	if (err)
> > >  		goto bail;
> > >  
> > > -	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
> > > +	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC)) {
> > > +		/*
> > > +		 * We still have to flush drive's caches to get data to the
> > > +		 * platter
> > > +		 */
> > > +		if (osb->s_mount_opt & OCFS2_MOUNT_BARRIER)
> > > +			blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL,
> > > +					   NULL, BLKDEV_IFL_WAIT);
> > >  		goto bail;
> > > +	}
> > >  
> > >  	journal = osb->journal->j_journal;
> > >  	err = jbd2_journal_force_commit(journal);
> > > -- 
> > > 1.6.4.2
> > > 
> > > 
> > > _______________________________________________
> > > Ocfs2-devel mailing list
> > > Ocfs2-devel at oss.oracle.com
> > > http://oss.oracle.com/mailman/listinfo/ocfs2-devel
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
