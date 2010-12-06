From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 6 Dec 2010 15:24:13 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Teach 'coherency=full'
 O_DIRECT writes to correctly up_read i_alloc_sem.
In-Reply-To: <1291022506-14981-1-git-send-email-tristan.ye@oracle.com>
References: <1291022506-14981-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <20101206232413.GG16687@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Nov 29, 2010 at 05:21:46PM +0800, Tristan Ye wrote:
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index f1e962c..857e013 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -568,7 +568,7 @@ static void ocfs2_dio_end_io(struct kiocb *iocb,
>  			     bool is_async)
>  {
>  	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
> -	int level;
> +	int level, sem_locked;
>  
>  	/* this io's submitter should not have unlocked this before we could */
>  	BUG_ON(!ocfs2_iocb_is_rw_locked(iocb));
> @@ -576,7 +576,9 @@ static void ocfs2_dio_end_io(struct kiocb *iocb,
>  	ocfs2_iocb_clear_rw_locked(iocb);
>  
>  	level = ocfs2_iocb_rw_locked_level(iocb);
> -	if (!level)
> +	sem_locked = ocfs2_iocb_is_sem_locked(iocb);
> +	ocfs2_iocb_clear_sem_locked(iocb);
> +	if (sem_locked)
>  		up_read(&inode->i_alloc_sem);
>  	ocfs2_rw_unlock(inode, level);

	I agree with Tao, we don't need sem_locked.  Just do:

	if (ocfs2_iocb_is_sem_locked(iocb)) {
		up_read(&inode->i_alloc_sem);
		ocfs2_iocb_clear_sem_locked(iocb);
	}

I think it reads better.

> diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
> index 76bfdfd..c7a3e5f 100644
> --- a/fs/ocfs2/aops.h
> +++ b/fs/ocfs2/aops.h
> @@ -72,4 +72,10 @@ static inline void ocfs2_iocb_set_rw_locked(struct kiocb *iocb, int level)
>  	clear_bit(0, (unsigned long *)&iocb->private)
>  #define ocfs2_iocb_rw_locked_level(iocb) \
>  	test_bit(1, (unsigned long *)&iocb->private)
> +#define ocfs2_iocb_set_sem_locked(iocb) \
> +	set_bit(2, (unsigned long *)&iocb->private)
> +#define ocfs2_iocb_clear_sem_locked(iocb) \
> +	clear_bit(2, (unsigned long *)&iocb->private)
> +#define ocfs2_iocb_is_sem_locked(iocb) \
> +	test_bit(2, (unsigned long *)&iocb->private)

	Give these bits an enum.  Anonymous numbers aren't good.  And
make the comment better.

>  #endif /* OCFS2_FILE_H */
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 77b4c04..0e9d729 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2246,7 +2246,10 @@ relock:
>  	if (direct_io) {
>  		down_read(&inode->i_alloc_sem);
>  		have_alloc_sem = 1;
> -	}
> +		/* communicate with ocfs2_dio_end_io */
> +		ocfs2_iocb_set_sem_locked(iocb);
> +	} else
> +		ocfs2_iocb_clear_sem_locked(iocb);

	I understand you're trying to avoid bad bits here, but you
should explicitly clear it at the top of the function.  You know for a
fact that, at the top (right before relock:), there is no sem held.
Then set it as you do, and only re-clear it when you up_write().

Joel

-- 

"Drake!  We're LEAVING!"

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
