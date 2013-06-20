From: Younger Liu <younger.liu@huawei.com>
Date: Thu, 20 Jun 2013 13:13:32 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Rework transaction rollback in
	ocfs2_relink_block_group()
In-Reply-To: <51C1C7FB.6080805@oracle.com>
References: <51C1C7FB.6080805@oracle.com>
Message-ID: <51C28F7C.3030500@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jeff,
There may be a mistake in the patch. See my comments below.

On 2013/6/19 23:02, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> In ocfs2_relink_block_group(), we roll back all those changes if
> notify intent to modify buffers for metadata update failed even
> if the relevant buffer has not yet been modified/got dirty at that
> point, that are not quite right because of:
> 
> - None buffer has been modified/dirty if failed to call
>   ocfs2_journal_access_gd() against the previous block group buffer
> - Only the previous block group buffer has got dirty if failed to
>   call ocfs2_journal_access_gd() against the block group buffer
> - There is no need to roll back the change for file entry buffer at all
> 
> Those problems will not cause anything wrong but unnecessary.
> This patch fix them and kill the useless bg_ptr variable as well.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  fs/ocfs2/suballoc.c |   25 ++++++++++++-------------
>  1 file changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index b7e74b5..101d16d 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -1422,7 +1422,7 @@ static int ocfs2_relink_block_group(handle_t *handle,
>  	int status;
>  	/* there is a really tiny chance the journal calls could fail,
>  	 * but we wouldn't want inconsistent blocks in *any* case. */
> -	u64 fe_ptr, bg_ptr, prev_bg_ptr;

Why remove bg_ptr and prev_bg_ptr from the context?
bg_ptr and prev_bg_ptr are also usable.

>  	struct ocfs2_group_desc *prev_bg = (struct ocfs2_group_desc *) prev_bg_bh->b_data;
> @@ -1437,7 +1437,6 @@ static int ocfs2_relink_block_group(handle_t *handle,
>  		(unsigned long long)le64_to_cpu(bg->bg_blkno),
>  		(unsigned long long)le64_to_cpu(prev_bg->bg_blkno));
>  
> -	fe_ptr = le64_to_cpu(fe->id2.i_chain.cl_recs[chain].c_blkno);
>  	bg_ptr = le64_to_cpu(bg->bg_next_group);
>  	prev_bg_ptr = le64_to_cpu(prev_bg->bg_next_group);
>  
> @@ -1446,7 +1445,7 @@ static int ocfs2_relink_block_group(handle_t *handle,
>  					 OCFS2_JOURNAL_ACCESS_WRITE);
>  	if (status < 0) {
>  		mlog_errno(status);
> -		goto out_rollback;
> +		goto out;
>  	}
>  
>  	prev_bg->bg_next_group = bg->bg_next_group;
> @@ -1456,7 +1455,7 @@ static int ocfs2_relink_block_group(handle_t *handle,
>  					 bg_bh, OCFS2_JOURNAL_ACCESS_WRITE);
>  	if (status < 0) {
>  		mlog_errno(status);
> -		goto out_rollback;
> +		goto out_rollback_prev_bg;
>  	}
>  
>  	bg->bg_next_group = fe->id2.i_chain.cl_recs[chain].c_blkno;
> @@ -1466,21 +1465,21 @@ static int ocfs2_relink_block_group(handle_t *handle,
>  					 fe_bh, OCFS2_JOURNAL_ACCESS_WRITE);
>  	if (status < 0) {
>  		mlog_errno(status);
> -		goto out_rollback;
> +		goto out_rollback_bg;
>  	}
>  
>  	fe->id2.i_chain.cl_recs[chain].c_blkno = bg->bg_blkno;
>  	ocfs2_journal_dirty(handle, fe_bh);
>  
> -out_rollback:
> -	if (status < 0) {
> -		fe->id2.i_chain.cl_recs[chain].c_blkno = cpu_to_le64(fe_ptr);
> -		bg->bg_next_group = cpu_to_le64(bg_ptr);
> -		prev_bg->bg_next_group = cpu_to_le64(prev_bg_ptr);
> -	}
> +out:
> +	return status;
>  
> -	if (status)
> -		mlog_errno(status);
> +out_rollback_bg:
> +	bg->bg_next_group = cpu_to_le64(bg_ptr);
> +out_rollback_prev_bg:
> +	prev_bg->bg_next_group = cpu_to_le64(prev_bg_ptr);
> +
> +	mlog_errno(status);
>  	return status;
>  }
>  
> 
