From: Joel Becker <jlbec@evilplan.org>
Date: Thu, 7 Nov 2013 03:11:53 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix possible double free in
 ocfs2_write_begin_nolock
In-Reply-To: <526B86E0.9080009@huawei.com>
References: <526B86E0.9080009@huawei.com>
Message-ID: <20131107111152.GF24799@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Oct 26, 2013 at 05:09:52PM +0800, Xue jiufei wrote:
> When ocfs2_write_cluster_by_desc() failed in ocfs2_write_begin_nolock()
> because of ENOSPC, it goes to out_quota, freeing data_ac(meta_ac). Then
> it calls ocfs2_try_to_free_truncate_log() to free space. If enough
> space freed, it will try to write again. Unfortunately, some error
> happenes before ocfs2_lock_allocators(), it goes to out and free 
> data_ac(meta_ac) again.
> 
> Signed-off-by: joyce <xuejiufei@huawei.com>

Good catch.  This function could use some refactoring for
understandability.

Acked-by: Joel Becker <jlbec@evilplan.org>

> ---
>  fs/ocfs2/aops.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index f37d3c0..8ad0a41 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -1897,10 +1897,14 @@ out_commit:
>  out:
>  	ocfs2_free_write_ctxt(wc);
>  
> -	if (data_ac)
> +	if (data_ac) {
>  		ocfs2_free_alloc_context(data_ac);
> -	if (meta_ac)
> +		data_ac = NULL;
> +	}
> +	if (meta_ac) {
>  		ocfs2_free_alloc_context(meta_ac);
> +		meta_ac = NULL;
> +	}
>  
>  	if (ret == -ENOSPC && try_free) {
>  		/*
> -- 
> 1.7.9.7
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

Life's Little Instruction Book #464

	"Don't miss the magic of the moment by focusing on what's
	 to come."

			http://www.jlbec.org/
			jlbec at evilplan.org
