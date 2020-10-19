From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Mon, 19 Oct 2020 15:46:08 +0800
Subject: [Ocfs2-devel] [patch -next] ocfs2: Add the
	trace_ocfs2_read_blocks_end
In-Reply-To: <20201016091157.29039-1-zhangqilong3@huawei.com>
References: <20201016091157.29039-1-zhangqilong3@huawei.com>
Message-ID: <6a644e29-a2a1-8f18-116f-a67c9a1c5653@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 2020/10/16 17:11, Zhang Qilong wrote:
> Missing the trace_ocfs2_read_blocks_end when reading blocks fails.>
Why do you need the trace in case error?
In general, it will log an error message if fail.

Thanks,
Joseph

> Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
> ---
>  fs/ocfs2/buffer_head_io.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
> index f0b104e483d8..0e6ee6e9b201 100644
> --- a/fs/ocfs2/buffer_head_io.c
> +++ b/fs/ocfs2/buffer_head_io.c
> @@ -395,11 +395,10 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
>  	}
>  	ocfs2_metadata_cache_io_unlock(ci);
>  
> +bail:
>  	trace_ocfs2_read_blocks_end((unsigned long long)block, nr,
>  				    flags, ignore_cache);
>  
> -bail:
> -
>  	return status;
>  }
>  
> 
