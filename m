From: Jan Kara <jack@suse.cz>
Date: Tue, 20 Jan 2015 17:53:38 +0100
Subject: [Ocfs2-devel] [PATCH 07/17] quota: Switch ->get_dqblk() and
 ->set_dqblk() to use bytes as space units
In-Reply-To: <20150119090720.GG27474@infradead.org>
References: <1421412471-4747-1-git-send-email-jack@suse.cz>
	<1421412471-4747-8-git-send-email-jack@suse.cz>
	<20150119090720.GG27474@infradead.org>
Message-ID: <20150120165338.GC3648@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, dchinner@redhat.com

On Mon 19-01-15 01:07:20, Christoph Hellwig wrote:
> > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > index 18dc721ca19f..f718ba1f2ccb 100644
> > --- a/fs/xfs/libxfs/xfs_fs.h
> > +++ b/fs/xfs/libxfs/xfs_fs.h
> > @@ -559,18 +559,4 @@ typedef struct xfs_swapext
> >  /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
> >  
> >  
> > -#ifndef HAVE_BBMACROS
> > -/*
> > - * Block I/O parameterization.	A basic block (BB) is the lowest size of
> > - * filesystem allocation, and must equal 512.  Length units given to bio
> > - * routines are in BB's.
> > - */
> > -#define BBSHIFT		9
> > -#define BBSIZE		(1<<BBSHIFT)
> > -#define BBMASK		(BBSIZE-1)
> > -#define BTOBB(bytes)	(((__u64)(bytes) + BBSIZE - 1) >> BBSHIFT)
> > -#define BTOBBT(bytes)	((__u64)(bytes) >> BBSHIFT)
> > -#define BBTOB(bbs)	((bbs) << BBSHIFT)
> > -#endif
> 
> Please don't move these defintions around and just opencode them in
> the quota code.
  I have moved the definitions because Dave asked me to use them in the XFS
parts of quota code (maybe he didn't realize that to be able to use them I
have to move the definitions somewhere where quota code can include them).
Dave? I personally don't care which variant will get used...

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
  Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
