From: Brian Foster <bfoster@redhat.com>
Date: Wed, 3 Feb 2016 08:52:20 -0500
Subject: [Ocfs2-devel] [PATCH 3/3] xfs: fold xfs_vm_do_dio into
	xfs_vm_direct_IO
In-Reply-To: <1454444257-9086-4-git-send-email-hch@lst.de>
References: <1454444257-9086-1-git-send-email-hch@lst.de>
	<1454444257-9086-4-git-send-email-hch@lst.de>
Message-ID: <20160203135220.GD20211@bfoster.bfoster>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, darrick.wong@oracle.com

On Tue, Feb 02, 2016 at 09:17:37PM +0100, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_aops.c | 39 ++++++++++++++-------------------------
>  1 file changed, 14 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index f6b08ea..e3cb7f8 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -1599,41 +1599,30 @@ xfs_end_io_direct_write(
>  	}
>  }
>  
> -static inline ssize_t
> -xfs_vm_do_dio(
> -	struct inode		*inode,
> +STATIC ssize_t
> +xfs_vm_direct_IO(
>  	struct kiocb		*iocb,
>  	struct iov_iter		*iter,
> -	loff_t			offset,
> -	void			(*endio)(struct kiocb	*iocb,
> -					 loff_t		offset,
> -					 ssize_t	size,
> -					 void		*private),
> -	int			flags)
> +	loff_t			offset)
>  {
> +	struct inode		*inode = iocb->ki_filp->f_mapping->host;
> +	dio_iodone_t		*endio = NULL;
> +	int			flags = 0;
>  	struct block_device	*bdev;
>  
> -	if (IS_DAX(inode))
> +	if (iov_iter_rw(iter) == WRITE) {
> +		endio = xfs_end_io_direct_write;
> +		flags = DIO_ASYNC_EXTEND;
> +	}
> +
> +	if (IS_DAX(inode)) {
>  		return dax_do_io(iocb, inode, iter, offset,
>  				 xfs_get_blocks_direct, endio, 0);
> +	}
>  
>  	bdev = xfs_find_bdev_for_inode(inode);
>  	return  __blockdev_direct_IO(iocb, inode, bdev, iter, offset,
> -				     xfs_get_blocks_direct, endio, NULL, flags);
> -}
> -
> -STATIC ssize_t
> -xfs_vm_direct_IO(
> -	struct kiocb		*iocb,
> -	struct iov_iter		*iter,
> -	loff_t			offset)
> -{
> -	struct inode		*inode = iocb->ki_filp->f_mapping->host;
> -
> -	if (iov_iter_rw(iter) == WRITE)
> -		return xfs_vm_do_dio(inode, iocb, iter, offset,
> -				     xfs_end_io_direct_write, DIO_ASYNC_EXTEND);
> -	return xfs_vm_do_dio(inode, iocb, iter, offset, NULL, 0);
> +			xfs_get_blocks_direct, endio, NULL, flags);
>  }
>  
>  /*
> -- 
> 2.1.4
> 
> _______________________________________________
> xfs mailing list
> xfs at oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
