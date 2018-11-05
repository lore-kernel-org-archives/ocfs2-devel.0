From: Changwei Ge <ge.changwei@h3c.com>
Date: Mon, 5 Nov 2018 01:59:08 +0000
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: free up write context when
 direct IO failed
References: <20181102170632.25921-1-wen.gang.wang@oracle.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E37301277DFAB2@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


This version also added a nice mlog infrastructure.

Looks good to me.

Thanks,
Changwei

On 2018/11/3 1:08, Wengang Wang wrote:
> The write context should also be freed even when direct IO failed.
> Otherwise a memory leak is introduced and entries remain in
> oi->ip_unwritten_list causing the following BUG later in unlink path:
> 
> ERROR: bug expression: !list_empty(&oi->ip_unwritten_list)
> ERROR: Clear inode of 215043, inode has unwritten extents
> ...
> Call Trace:
> ? __set_current_blocked+0x42/0x68
> ocfs2_evict_inode+0x91/0x6a0 [ocfs2]
> ? bit_waitqueue+0x40/0x33
> evict+0xdb/0x1af
> iput+0x1a2/0x1f7
> do_unlinkat+0x194/0x28f
> SyS_unlinkat+0x1b/0x2f
> do_syscall_64+0x79/0x1ae
> entry_SYSCALL_64_after_hwframe+0x151/0x0
> 
> This patch also logs, with frequency limit, direct IO failures.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>

Reviewed-by: Changwei Ge <ge.changwei@h3c.com>

> ---
> v1 -> v2: log direct IO failures
> ---
>   fs/ocfs2/aops.c            | 12 ++++++++++--
>   fs/ocfs2/cluster/masklog.h |  9 +++++++++
>   2 files changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 302cd7c..7578bd5 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -2412,8 +2412,16 @@ static int ocfs2_dio_end_io(struct kiocb *iocb,
>   	/* this io's submitter should not have unlocked this before we could */
>   	BUG_ON(!ocfs2_iocb_is_rw_locked(iocb));
>   
> -	if (bytes > 0 && private)
> -		ret = ocfs2_dio_end_io_write(inode, private, offset, bytes);
> +	if (bytes <= 0)
> +		mlog_ratelimited(ML_ERROR, "Direct IO failed, bytes = %lld",
> +				 (long long)bytes);
> +	if (private) {
> +		if (bytes > 0)
> +			ret = ocfs2_dio_end_io_write(inode, private, offset,
> +						     bytes);
> +		else
> +			ocfs2_dio_free_write_ctx(inode, private);
> +	}
>   
>   	ocfs2_iocb_clear_rw_locked(iocb);
>   
> diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
> index 308ea0e..a396096 100644
> --- a/fs/ocfs2/cluster/masklog.h
> +++ b/fs/ocfs2/cluster/masklog.h
> @@ -178,6 +178,15 @@ do {									\
>   			      ##__VA_ARGS__);				\
>   } while (0)
>   
> +#define mlog_ratelimited(mask, fmt, ...)				\
> +do {									\
> +	static DEFINE_RATELIMIT_STATE(_rs,				\
> +				      DEFAULT_RATELIMIT_INTERVAL,	\
> +				      DEFAULT_RATELIMIT_BURST);		\
> +	if (__ratelimit(&_rs))						\
> +		mlog(mask, fmt, ##__VA_ARGS__);				\
> +} while (0)
> +
>   #define mlog_errno(st) ({						\
>   	int _st = (st);							\
>   	if (_st != -ERESTARTSYS && _st != -EINTR &&			\
> 
