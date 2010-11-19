From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 19 Nov 2010 22:34:51 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Teach 'coherency=full'
 O_DIRECT writes to correctly up_read i_alloc_sem.
In-Reply-To: <1290155919-4280-1-git-send-email-tristan.ye@oracle.com>
References: <1290155919-4280-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <4CE68B0B.8010308@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Tristan,
	Just add joel to the cc in case he has a different option.

On 11/19/2010 04:38 PM, Tristan Ye wrote:
> Former logic of ocfs2_file_aio_write() was a bit stricky to unlock the rw_lock
> and i_alloc_sem, by using some private bits in struct 'iocb' to communite with
> ocfs2_dio_end_io(), it did work before we introduce the patch of supporting
> 'coherency=full,buffered' option, since rw_lock and i_alloc_sem were never
> acquired both at the same time, no mattar we doing buffered or direct IO or not.
These 2 locks can be acquired at the same time.
So if we go with direct_io, we do have i_alloc_sem and rw_lock locked 
simultaneously. why do you get this?

I have gone through your patch and the bug. It sees to me that the real 
cause for the bug is that you have EX rw_lock because of full_coherency 
while locking i_alloc_sem. So finally in ocfs2_dio_end_io, only rw_lock 
is freed and i_alloc_sem is left, right? If yes, please update the above 
commit log for it.

I don't like your solution either. full_coherency is only used in direct 
write and ocfs2_dio_end_io is used for both direct read/write. So why 
add the complexity of coherency to ocfs2_dio_end_io? Also you long 
comment in ocfs2_file_aio_write does indicate that it is really hard for 
the code reader to learn why we need to set this flag.

My suggestion is: why not use another flag to indicate the state of 
i_alloc_sem instead of full_coherency? So in place we down_read the 
i_alloc_sem, set the flag accordingly, and in ocfs2_dio_end_io, just 
check this flag instead of !rw_locked_level to up_read it. It should be 
more straightforward. Agree?

Joel, any comments?

Regards,
Tao


>
> This patch tries to teach ocfs2_dio_end_io fully understand the bahavior of
> all writes, including buffered/concurrency-allowed-odirect/none-concurrency-odirect
> writes, to have all lock/sem primitives getting correctly released.
>
> Signed-off-by: Tristan Ye<tristan.ye@oracle.com>
> ---
>   fs/ocfs2/aops.c |    9 +++++++--
>   fs/ocfs2/aops.h |    6 ++++++
>   fs/ocfs2/file.c |   16 ++++++++++++++++
>   3 files changed, 29 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index f1e962c..fd0713c 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -568,7 +568,7 @@ static void ocfs2_dio_end_io(struct kiocb *iocb,
>   			     bool is_async)
>   {
>   	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
> -	int level;
> +	int level, coherency;
>
>   	/* this io's submitter should not have unlocked this before we could */
>   	BUG_ON(!ocfs2_iocb_is_rw_locked(iocb));
> @@ -576,7 +576,12 @@ static void ocfs2_dio_end_io(struct kiocb *iocb,
>   	ocfs2_iocb_clear_rw_locked(iocb);
>
>   	level = ocfs2_iocb_rw_locked_level(iocb);
> -	if (!level)
> +	/*
> +	 * 'coherency=full' O_DIRECT writes needs this extra bit
> +	 * to correctly up_read the i_alloc_sem.
> +	 */
> +	coherency = ocfs2_iocb_coherency(iocb);
> +	if ((!level) || coherency)
>   		up_read(&inode->i_alloc_sem);
>   	ocfs2_rw_unlock(inode, level);
>
> diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
> index 76bfdfd..213cec6 100644
> --- a/fs/ocfs2/aops.h
> +++ b/fs/ocfs2/aops.h
> @@ -72,4 +72,10 @@ static inline void ocfs2_iocb_set_rw_locked(struct kiocb *iocb, int level)
>   	clear_bit(0, (unsigned long *)&iocb->private)
>   #define ocfs2_iocb_rw_locked_level(iocb) \
>   	test_bit(1, (unsigned long *)&iocb->private)
> +#define ocfs2_iocb_set_coherency(iocb) \
> +	set_bit(2, (unsigned long *)&iocb->private)
> +#define ocfs2_iocb_clear_coherency(iocb) \
> +	clear_bit(2, (unsigned long *)&iocb->private)
> +#define ocfs2_iocb_coherency(iocb) \
> +	test_bit(2, (unsigned long *)&iocb->private)
>   #endif /* OCFS2_FILE_H */
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 77b4c04..df070a3 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2277,8 +2277,24 @@ relock:
>   		}
>
>   		ocfs2_inode_unlock(inode, 1);
> +
> +		/*
> +		 * Due to the fault of 'full_coherency' O_DIRECT
> +		 * write needs to acqure both i_alloc_sem and rw_lock.
> +		 * We do another trick here to have coherency bit
> +		 * stored in iocb to communicate with ocfs2_dio_end_io
> +		 * for properly unlocking i_alloc_sem.
> +		 */
> +		ocfs2_iocb_set_coherency(iocb);
>   	}
>
> +	/*
> +	 * Concurrent-allowed odirect writes was able to up_read i_alloc_sem
> +	 * correctly, we therefore don't need this extra and tricky bit.
> +	 */
> +	if (direct_io&&  !full_coherency)
> +		ocfs2_iocb_clear_coherency(iocb);
> +
>   	can_do_direct = direct_io;
>   	ret = ocfs2_prepare_inode_for_write(file, ppos,
>   					    iocb->ki_left, appending,
