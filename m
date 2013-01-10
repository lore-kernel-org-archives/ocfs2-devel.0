From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Thu, 10 Jan 2013 09:07:24 +0800
Subject: [Ocfs2-devel] [PATCH] Remove unecessary
	ocfs2_iocb_clear_sem_locked
In-Reply-To: <CAJtY7HXvfg44yD=U7-upbtsYEwMpkR0w9r=rC4HM5tcsuHS7hg@mail.gmail.com>
References: <CAJtY7HXvfg44yD=U7-upbtsYEwMpkR0w9r=rC4HM5tcsuHS7hg@mail.gmail.com>
Message-ID: <50EE144C.8080500@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 01/10/2013 01:01 AM, Goldwyn Rodrigues wrote:
> Since 2dfd06036ba7ae8e7be2daf5a2fff1dac42390bf, the private field of
> kiocb is initialized in init_sync_kiocb(). This obviates the need to
> clear the OCFS2_IOCB_SEM bits. This will save a few cycles/flushes.
>
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Fine to me.

Thanks,
Junxiao
>
> ---
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 37d313e..2946c3e 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2254,8 +2254,6 @@ static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
>
>  	mutex_lock(&inode->i_mutex);
>
> -	ocfs2_iocb_clear_sem_locked(iocb);
> -
>  relock:
>  	/* to match setattr's i_mutex -> rw_lock ordering */
>  	if (direct_io) {
> @@ -2560,8 +2558,6 @@ static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
>  		goto bail;
>  	}
>
> -	ocfs2_iocb_clear_sem_locked(iocb);
> -
>  	/*
>  	 * buffered reads protect themselves in ->readpage().  O_DIRECT reads
>  	 * need locks to protect pending reads from racing with truncate.
