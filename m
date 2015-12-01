From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Tue, 1 Dec 2015 12:42:54 +0800
Subject: [Ocfs2-devel] [PATCH 1/4] ocfs2: fix ip_unaligned_aio deadlock
 with dio work queue
In-Reply-To: <1448007799-10914-1-git-send-email-ryan.ding@oracle.com>
References: <1448007799-10914-1-git-send-email-ryan.ding@oracle.com>
Message-ID: <565D254E.70501@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Ryan,

On 11/20/2015 04:23 PM, Ryan Ding wrote:
> In the current implementation of unaligned aio+dio, lock order behave as follow:
> 
> in user process context:
>   -> call io_submit()
>     -> get i_mutex
> 		<== window1
>       -> get ip_unaligned_aio
>         -> submit direct io to block device
>     -> release i_mutex
>   -> io_submit() return
> 
> in dio work queue context(the work queue is created in __blockdev_direct_IO):
>   -> release ip_unaligned_aio
> 		<== window2
>     -> get i_mutex
>       -> clear unwritten flag & change i_size
>     -> release i_mutex
> 
> There is a limitation to the thread number of dio work queue. 256 at default.
> If all 256 thread are in the above 'window2' stage, and there is a user process
> in the 'window1' stage, the system will became deadlock. Since the user process
> hold i_mutex to wait ip_unaligned_aio lock, while there is a direct bio hold
> ip_unaligned_aio mutex who is waiting for a dio work queue thread to be
> schedule. But all the dio work queue thread is waiting for i_mutex lock in
> 'window2'.
> 
> This case only happened in a test which send a large number(more than 256) of
> aio at one io_submit() call.
> 
> My design is to remove ip_unaligned_aio lock. Change it to a sync io instead.
> Just like ip_unaligned_aio lock, serialize the unaligned aio dio.
> 
> Signed-off-by: Ryan Ding <ryan.ding@oracle.com>
> ---
>  fs/ocfs2/aops.c  |    6 ------
>  fs/ocfs2/aops.h  |    7 -------
>  fs/ocfs2/file.c  |   27 +++++++++------------------
>  fs/ocfs2/inode.h |    3 ---
>  fs/ocfs2/super.c |    1 -
>  5 files changed, 9 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 4bb9921..cc604a2 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -2388,12 +2388,6 @@ static void ocfs2_dio_end_io(struct kiocb *iocb,
>  	/* this io's submitter should not have unlocked this before we could */
>  	BUG_ON(!ocfs2_iocb_is_rw_locked(iocb));
>  
> -	if (ocfs2_iocb_is_unaligned_aio(iocb)) {
> -		ocfs2_iocb_clear_unaligned_aio(iocb);
> -
> -		mutex_unlock(&OCFS2_I(inode)->ip_unaligned_aio);
> -	}
> -
>  	if (private)
>  		ocfs2_dio_end_io_write(inode, private, offset, bytes);
>  
> diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
> index d06b80f..7fc1189 100644
> --- a/fs/ocfs2/aops.h
> +++ b/fs/ocfs2/aops.h
> @@ -93,11 +93,4 @@ enum ocfs2_iocb_lock_bits {
>  #define ocfs2_iocb_rw_locked_level(iocb) \
>  	test_bit(OCFS2_IOCB_RW_LOCK_LEVEL, (unsigned long *)&iocb->private)
>  
> -#define ocfs2_iocb_set_unaligned_aio(iocb) \
> -	set_bit(OCFS2_IOCB_UNALIGNED_IO, (unsigned long *)&iocb->private)
> -#define ocfs2_iocb_clear_unaligned_aio(iocb) \
> -	clear_bit(OCFS2_IOCB_UNALIGNED_IO, (unsigned long *)&iocb->private)
> -#define ocfs2_iocb_is_unaligned_aio(iocb) \
> -	test_bit(OCFS2_IOCB_UNALIGNED_IO, (unsigned long *)&iocb->private)
> -

OCFS2_IOCB_UNALIGNED_IO is useless now. Please remove its definition.

Other looks good.
Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>


>  #endif /* OCFS2_FILE_H */
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 05346fb..6ab91cd 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2170,7 +2170,7 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>  	int full_coherency = !(osb->s_mount_opt &
>  			       OCFS2_MOUNT_COHERENCY_BUFFERED);
> -	int unaligned_dio = 0;
> +	void *saved_ki_complete = NULL;
>  	int append_write = ((iocb->ki_pos + count) >=
>  			i_size_read(inode) ? 1 : 0);
>  
> @@ -2233,17 +2233,12 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
>  		goto out;
>  	}
>  
> -	if (direct_io && !is_sync_kiocb(iocb))
> -		unaligned_dio = ocfs2_is_io_unaligned(inode, count, iocb->ki_pos);
> -
> -	if (unaligned_dio) {
> +	if (direct_io && !is_sync_kiocb(iocb) &&
> +	    ocfs2_is_io_unaligned(inode, count, iocb->ki_pos)) {
>  		/*
> -		 * Wait on previous unaligned aio to complete before
> -		 * proceeding.
> +		 * Make it a sync io if it's an unaligned aio.
>  		 */
> -		mutex_lock(&OCFS2_I(inode)->ip_unaligned_aio);
> -		/* Mark the iocb as needing an unlock in ocfs2_dio_end_io */
> -		ocfs2_iocb_set_unaligned_aio(iocb);
> +		saved_ki_complete = xchg(&iocb->ki_complete, NULL);
>  	}
>  
>  	/* communicate with ocfs2_dio_end_io */
> @@ -2264,11 +2259,10 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
>  	 */
>  	if ((written == -EIOCBQUEUED) || (!ocfs2_iocb_is_rw_locked(iocb))) {
>  		rw_level = -1;
> -		unaligned_dio = 0;
>  	}
>  
>  	if (unlikely(written <= 0))
> -		goto no_sync;
> +		goto out;
>  
>  	if (((file->f_flags & O_DSYNC) && !direct_io) ||
>  	    IS_SYNC(inode)) {
> @@ -2290,13 +2284,10 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
>  						      iocb->ki_pos - 1);
>  	}
>  
> -no_sync:
> -	if (unaligned_dio && ocfs2_iocb_is_unaligned_aio(iocb)) {
> -		ocfs2_iocb_clear_unaligned_aio(iocb);
> -		mutex_unlock(&OCFS2_I(inode)->ip_unaligned_aio);
> -	}
> -
>  out:
> +	if (saved_ki_complete)
> +		xchg(&iocb->ki_complete, saved_ki_complete);
> +
>  	if (rw_level != -1)
>  		ocfs2_rw_unlock(inode, rw_level);
>  
> diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
> index 0c22ddd..6e0633e 100644
> --- a/fs/ocfs2/inode.h
> +++ b/fs/ocfs2/inode.h
> @@ -43,9 +43,6 @@ struct ocfs2_inode_info
>  	/* protects extended attribute changes on this inode */
>  	struct rw_semaphore		ip_xattr_sem;
>  
> -	/* Number of outstanding AIO's which are not page aligned */
> -	struct mutex			ip_unaligned_aio;
> -
>  	/* These fields are protected by ip_lock */
>  	spinlock_t			ip_lock;
>  	u32				ip_open_count;
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index c70a80b..3fd171f 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1723,7 +1723,6 @@ static void ocfs2_inode_init_once(void *data)
>  	INIT_LIST_HEAD(&oi->ip_io_markers);
>  	INIT_LIST_HEAD(&oi->ip_unwritten_list);
>  	oi->ip_dir_start_lookup = 0;
> -	mutex_init(&oi->ip_unaligned_aio);
>  	init_rwsem(&oi->ip_alloc_sem);
>  	init_rwsem(&oi->ip_xattr_sem);
>  	mutex_init(&oi->ip_io_mutex);
> 
