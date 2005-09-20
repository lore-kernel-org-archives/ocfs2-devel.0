From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Sep 20 15:24:34 2005
Subject: [Ocfs2-devel] [PATCH] remove ocfs2_write_blocks
In-Reply-To: <20050918103617.GA23648@lst.de>
References: <20050918103617.GA23648@lst.de>
Message-ID: <20050920202439.GE18764@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Thanks - committed.

I took some liberties with the patch:
- merged it with the newest version of buffer_head_io.c (it got some
  readonly goodness since your patch was created)
- added a couple minor cleanups of my own
- you forgot to update a comment, which I did
	 --Mark

On Sun, Sep 18, 2005 at 12:36:17PM +0200, Christoph Hellwig wrote:
> we only need ocfs2_write_block because there's never more than one
> buffer written.
> 
> Also remove lots of useless checks and replace the useful ones with
> BUG_ON.
> 
> While we're at it, can someone please audit the buffer_head end_io
> handlers in ocfs?  comparing them to the generic ones in fs/buffer.c
> the buffered I/O in ocfs seems to lack grabbing a reference for the
> duration of the I/O.  It might in fact be possible to just use the
> generic completetion handlers.
> 
> 
> Index: fs/ocfs2/buffer_head_io.c
> ===================================================================
> --- fs/ocfs2/buffer_head_io.c	(revision 2593)
> +++ fs/ocfs2/buffer_head_io.c	(working copy)
> @@ -52,21 +52,16 @@
>  	unlock_buffer(bh);
>  }
>  
> -int ocfs2_write_blocks(ocfs2_super *osb, struct buffer_head *bhs[],
> -		       int nr, struct inode *inode)
> +int ocfs2_write_block(ocfs2_super *osb, struct buffer_head *bh,
> +				    struct inode *inode)
>  {
>  	int status = 0;
> -	int i;
> -	struct buffer_head *bh;
>  
> -	mlog_entry("(bh[0]->b_blocknr = %llu, nr=%d, inode=%p)\n",
> -		   (unsigned long long)bhs[0]->b_blocknr, nr, inode);
> +	mlog_entry("(bh->b_blocknr = %llu, inode=%p)\n",
> +		   (unsigned long long)bh->b_blocknr, inode);
>  
> -	if (osb == NULL || osb->sb == NULL || bhs == NULL) {
> -		status = -EINVAL;
> -		mlog_errno(status);
> -		goto bail;
> -	}
> +	BUG_ON(bh->b_blocknr < OCFS2_SUPER_BLOCK_BLKNO);
> +	BUG_ON(buffer_jbd(bh));
>  
>  	/* No need to check for a soft readonly file system here. non
>  	 * journalled writes are only ever done on system files which
> @@ -76,70 +71,34 @@
>  		goto bail;
>  	}
>  
> -	if (inode)
> -		down(&OCFS2_I(inode)->ip_io_sem);
> -	for (i = 0 ; i < nr ; i++) {
> -		bh = bhs[i];
> -		if (bh == NULL) {
> -			if (inode)
> -				up(&OCFS2_I(inode)->ip_io_sem);
> -			status = -EIO;
> -			mlog_errno(status);
> -			goto bail;
> -		}
> +	down(&OCFS2_I(inode)->ip_io_sem);
>  
> -		if (unlikely(bh->b_blocknr < OCFS2_SUPER_BLOCK_BLKNO)) {
> -			BUG();
> -			status = -EIO;
> -			mlog_errno(status);
> -			goto bail;
> -		}
> +	lock_buffer(bh);
> +	set_buffer_uptodate(bh);
>  
> -		if (unlikely(buffer_jbd(bh))) {
> -			/* What are you thinking?! */
> -			mlog(ML_ERROR, "trying to write a jbd managed bh "
> -				       "(blocknr = %llu), nr=%d\n",
> -			     (unsigned long long)bh->b_blocknr, nr);
> -			BUG();
> -		}
> +	/* remove from dirty list before I/O. */
> +	clear_buffer_dirty(bh);
>  
> -		lock_buffer(bh);
> +	bh->b_end_io = ocfs2_end_buffer_io_sync;
> +	submit_bh(WRITE, bh);
>  
> -		set_buffer_uptodate(bh);
> +	wait_on_buffer(bh);
>  
> -		/* remove from dirty list before I/O. */
> -		clear_buffer_dirty(bh);
> -
> -		bh->b_end_io = ocfs2_end_buffer_io_sync;
> -		submit_bh(WRITE, bh);
> +	if (buffer_uptodate(bh))
> +		ocfs2_set_buffer_uptodate(inode, bh);
> +	else {
> +		/* Status won't be cleared from here on out,
> +		 * so we can safely record this and loop back
> +		 * to cleanup the other buffers. Don't need to
> +		 * remove the clustered uptodate information
> +		 * for this bh as it's not marked locally
> +		 * uptodate. */
> +		status = -EIO;
> +		brelse(bh);
>  	}
>  
> -	for (i = (nr - 1) ; i >= 0; i--) {
> -		bh = bhs[i];
> -
> -		wait_on_buffer(bh);
> -
> -		if (!buffer_uptodate(bh)) {
> -			/* Status won't be cleared from here on out,
> -			 * so we can safely record this and loop back
> -			 * to cleanup the other buffers. Don't need to
> -			 * remove the clustered uptodate information
> -			 * for this bh as it's not marked locally
> -			 * uptodate. */
> -			status = -EIO;
> -			brelse(bh);
> -			bhs[i] = NULL;
> -			continue;
> -		}
> -
> -		if (inode)
> -			ocfs2_set_buffer_uptodate(inode, bh);
> -	}
> -	if (inode)
> -		up(&OCFS2_I(inode)->ip_io_sem);
> -
> -bail:
> -
> +	up(&OCFS2_I(inode)->ip_io_sem);
> + bail:
>  	mlog_exit(status);
>  	return status;
>  }
> Index: fs/ocfs2/buffer_head_io.h
> ===================================================================
> --- fs/ocfs2/buffer_head_io.h	(revision 2593)
> +++ fs/ocfs2/buffer_head_io.h	(working copy)
> @@ -32,19 +32,13 @@
>  			     int uptodate);
>  
>  /* Yosh made me do it. */
> -static inline int ocfs2_write_block(ocfs2_super         *osb,
> -				    struct buffer_head  *bh,
> -				    struct inode        *inode);
>  static inline int ocfs2_read_block(ocfs2_super          *osb,
>  				   u64                  off,
>  				   struct buffer_head **bh,
>  				   int                  flags,
>  				   struct inode        *inode);
>  
> -int ocfs2_write_blocks(ocfs2_super          *osb,
> -		       struct buffer_head  *bh[],
> -		       int                  nr,
> -		       struct inode        *inode);
> +int ocfs2_write_block(ocfs2_super *, struct buffer_head *, struct inode *);
>  int ocfs2_read_blocks(ocfs2_super          *osb,
>  		      u64                  block,
>  		      int                  nr,
> @@ -56,16 +50,6 @@
>  #define OCFS2_BH_CACHED            1
>  #define OCFS2_BH_READAHEAD         8	/* use this to pass READA down to submit_bh */
>  
> -static inline int ocfs2_write_block(ocfs2_super * osb, struct buffer_head *bh,
> -				    struct inode *inode)
> -{
> -	int status;
> -
> -	status = ocfs2_write_blocks(osb, &bh, 1, inode);
> -
> -	return status;
> -}
> -
>  static inline int ocfs2_read_block(ocfs2_super * osb, u64 off,
>  				   struct buffer_head **bh, int flags,
>  				   struct inode *inode)
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
