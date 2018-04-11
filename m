From: piaojun <piaojun@huawei.com>
Date: Wed, 11 Apr 2018 08:51:51 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: don't use iocb when EIOCBQUEUED
 returns
In-Reply-To: <1523361653-14439-1-git-send-email-ge.changwei@h3c.com>
References: <1523361653-14439-1-git-send-email-ge.changwei@h3c.com>
Message-ID: <5ACD5C27.4080205@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Changwei,

It looks like a code bug, and 'iocb' should not be freed at this place.
Could this BUG reproduced easily?

thanks,
Jun

On 2018/4/10 20:00, Changwei Ge wrote:
> When -EIOCBQUEUED returns, it means that aio_complete() will be called
> from dio_complete(), which is an asynchronous progress against write_iter.
> Generally, IO is a very slow progress than executing instruction, but we
> still can't take the risk to access a freed iocb.
> 
> And we do face a BUG crash issue.
>>From crash tool, iocb is obviously freed already.
> crash> struct -x kiocb ffff881a350f5900
> struct kiocb {
>   ki_filp = 0xffff881a350f5a80,
>   ki_pos = 0x0,
>   ki_complete = 0x0,
>   private = 0x0,
>   ki_flags = 0x0
> }
> 
> And the backtrace shows:
> ocfs2_file_write_iter+0xcaa/0xd00 [ocfs2]
> ? ocfs2_check_range_for_refcount+0x150/0x150 [ocfs2]
> aio_run_iocb+0x229/0x2f0
> ? try_to_wake_up+0x380/0x380
> do_io_submit+0x291/0x540
> ? syscall_trace_leave+0xad/0x130
> SyS_io_submit+0x10/0x20
> system_call_fastpath+0x16/0x75
> 
> Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
> ---
>  fs/ocfs2/file.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 5d1784a..1393ff2 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2343,7 +2343,7 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
>  
>  	written = __generic_file_write_iter(iocb, from);
>  	/* buffered aio wouldn't have proper lock coverage today */
> -	BUG_ON(written == -EIOCBQUEUED && !(iocb->ki_flags & IOCB_DIRECT));
> +	BUG_ON(written == -EIOCBQUEUED && !direct_io);
>  
>  	/*
>  	 * deep in g_f_a_w_n()->ocfs2_direct_IO we pass in a ocfs2_dio_end_io
> @@ -2463,7 +2463,7 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
>  	trace_generic_file_aio_read_ret(ret);
>  
>  	/* buffered aio wouldn't have proper lock coverage today */
> -	BUG_ON(ret == -EIOCBQUEUED && !(iocb->ki_flags & IOCB_DIRECT));
> +	BUG_ON(ret == -EIOCBQUEUED && !direct_io);
>  
>  	/* see ocfs2_file_write_iter */
>  	if (ret == -EIOCBQUEUED || !ocfs2_iocb_is_rw_locked(iocb)) {
> 
