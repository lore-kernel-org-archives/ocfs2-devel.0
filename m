From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 20 May 2015 12:04:14 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: remove OCFS2_IOCB_SEM lock type in
 direct io
In-Reply-To: <55556992.6040002@huawei.com>
References: <55556992.6040002@huawei.com>
Message-ID: <555C07BE.2040701@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 05/15/2015 11:35 AM, WeiWei Wang wrote:
> Hi all,
> 
> In ocfs2 direct read/write, OCFS2_IOCB_SEM lock type is used to protect
> inode->i_alloc_sem rw semaphore lock in the earlier kernel version.
> However, in the latest kernel, inode->i_alloc_sem rw semaphore lock
> is not used at all, so OCFS2_IOCB_SEM lock type needs to be removed.
> 
> Any comments are appreciated, thanks!
> 					-- Weiwei Wang
> 
> 
> Signed-off-by: Weiwei Wang <wangww631@huawei.com>
Looks fine.

Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>

Thanks,
Junxiao.
> ---
>  fs/ocfs2/aops.c |  3 ---
>  fs/ocfs2/aops.h |  7 -------
>  fs/ocfs2/file.c | 31 ++++---------------------------
>  3 files changed, 4 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index f906a25..d3eccc0 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -619,9 +619,6 @@ static void ocfs2_dio_end_io(struct kiocb *iocb,
>  	/* this io's submitter should not have unlocked this before we could */
>  	BUG_ON(!ocfs2_iocb_is_rw_locked(iocb));
> 
> -	if (ocfs2_iocb_is_sem_locked(iocb))
> -		ocfs2_iocb_clear_sem_locked(iocb);
> -
>  	if (ocfs2_iocb_is_unaligned_aio(iocb)) {
>  		ocfs2_iocb_clear_unaligned_aio(iocb);
> 
> diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
> index dd59599..24e496d 100644
> --- a/fs/ocfs2/aops.h
> +++ b/fs/ocfs2/aops.h
> @@ -79,7 +79,6 @@ static inline void ocfs2_iocb_set_rw_locked(struct kiocb *iocb, int level)
>  enum ocfs2_iocb_lock_bits {
>  	OCFS2_IOCB_RW_LOCK = 0,
>  	OCFS2_IOCB_RW_LOCK_LEVEL,
> -	OCFS2_IOCB_SEM,
>  	OCFS2_IOCB_UNALIGNED_IO,
>  	OCFS2_IOCB_NUM_LOCKS
>  };
> @@ -88,12 +87,6 @@ enum ocfs2_iocb_lock_bits {
>  	clear_bit(OCFS2_IOCB_RW_LOCK, (unsigned long *)&iocb->private)
>  #define ocfs2_iocb_rw_locked_level(iocb) \
>  	test_bit(OCFS2_IOCB_RW_LOCK_LEVEL, (unsigned long *)&iocb->private)
> -#define ocfs2_iocb_set_sem_locked(iocb) \
> -	set_bit(OCFS2_IOCB_SEM, (unsigned long *)&iocb->private)
> -#define ocfs2_iocb_clear_sem_locked(iocb) \
> -	clear_bit(OCFS2_IOCB_SEM, (unsigned long *)&iocb->private)
> -#define ocfs2_iocb_is_sem_locked(iocb) \
> -	test_bit(OCFS2_IOCB_SEM, (unsigned long *)&iocb->private)
> 
>  #define ocfs2_iocb_set_unaligned_aio(iocb) \
>  	set_bit(OCFS2_IOCB_UNALIGNED_IO, (unsigned long *)&iocb->private)
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index d8b670c..fbfadb2 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2250,7 +2250,7 @@ out:
>  static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
>  				    struct iov_iter *from)
>  {
> -	int direct_io, appending, rw_level, have_alloc_sem  = 0;
> +	int direct_io, appending, rw_level;
>  	int can_do_direct, has_refcount = 0;
>  	ssize_t written = 0;
>  	ssize_t ret;
> @@ -2279,16 +2279,7 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
> 
>  	mutex_lock(&inode->i_mutex);
> 
> -	ocfs2_iocb_clear_sem_locked(iocb);
> -
>  relock:
> -	/* to match setattr's i_mutex -> rw_lock ordering */
> -	if (direct_io) {
> -		have_alloc_sem = 1;
> -		/* communicate with ocfs2_dio_end_io */
> -		ocfs2_iocb_set_sem_locked(iocb);
> -	}
> -
>  	/*
>  	 * Concurrent O_DIRECT writes are allowed with
>  	 * mount_option "coherency=buffered".
> @@ -2298,7 +2289,7 @@ relock:
>  	ret = ocfs2_rw_lock(inode, rw_level);
>  	if (ret < 0) {
>  		mlog_errno(ret);
> -		goto out_sems;
> +		goto out_mutex;
>  	}
> 
>  	/*
> @@ -2347,7 +2338,6 @@ relock:
>  	if (direct_io && !can_do_direct) {
>  		ocfs2_rw_unlock(inode, rw_level);
> 
> -		have_alloc_sem = 0;
>  		rw_level = -1;
> 
>  		direct_io = 0;
> @@ -2416,7 +2406,6 @@ no_sync:
>  	 */
>  	if ((ret == -EIOCBQUEUED) || (!ocfs2_iocb_is_rw_locked(iocb))) {
>  		rw_level = -1;
> -		have_alloc_sem = 0;
>  		unaligned_dio = 0;
>  	}
> 
> @@ -2429,10 +2418,7 @@ out:
>  	if (rw_level != -1)
>  		ocfs2_rw_unlock(inode, rw_level);
> 
> -out_sems:
> -	if (have_alloc_sem)
> -		ocfs2_iocb_clear_sem_locked(iocb);
> -
> +out_mutex:
>  	mutex_unlock(&inode->i_mutex);
> 
>  	if (written)
> @@ -2473,7 +2459,7 @@ bail:
>  static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
>  				   struct iov_iter *to)
>  {
> -	int ret = 0, rw_level = -1, have_alloc_sem = 0, lock_level = 0;
> +	int ret = 0, rw_level = -1, lock_level = 0;
>  	struct file *filp = iocb->ki_filp;
>  	struct inode *inode = file_inode(filp);
> 
> @@ -2490,16 +2476,11 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
>  		goto bail;
>  	}
> 
> -	ocfs2_iocb_clear_sem_locked(iocb);
> -
>  	/*
>  	 * buffered reads protect themselves in ->readpage().  O_DIRECT reads
>  	 * need locks to protect pending reads from racing with truncate.
>  	 */
>  	if (iocb->ki_flags & IOCB_DIRECT) {
> -		have_alloc_sem = 1;
> -		ocfs2_iocb_set_sem_locked(iocb);
> -
>  		ret = ocfs2_rw_lock(inode, 0);
>  		if (ret < 0) {
>  			mlog_errno(ret);
> @@ -2535,13 +2516,9 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
>  	/* see ocfs2_file_write_iter */
>  	if (ret == -EIOCBQUEUED || !ocfs2_iocb_is_rw_locked(iocb)) {
>  		rw_level = -1;
> -		have_alloc_sem = 0;
>  	}
> 
>  bail:
> -	if (have_alloc_sem)
> -		ocfs2_iocb_clear_sem_locked(iocb);
> -
>  	if (rw_level != -1)
>  		ocfs2_rw_unlock(inode, rw_level);
> 
