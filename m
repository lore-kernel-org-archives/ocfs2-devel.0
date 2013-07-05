From: Jeff Liu <jeff.liu@oracle.com>
Date: Fri, 05 Jul 2013 19:46:39 +0800
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: lighten up allocate transaction
In-Reply-To: <51D6A5A0.1080300@huawei.com>
References: <51D6A5A0.1080300@huawei.com>
Message-ID: <51D6B21F.8050402@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 07/05/2013 06:53 PM, Younger Liu wrote:

> The issue scenario is as following:
> When fallocating a very large disk space for a small file,
> __ocfs2_extend_allocation attempts to get a very large transaction. 
> For some journal sizes, there may be not enough room for this 
> transaction, and the fallocate will fail.
> 
> The patch below extents & restarts the transaction as necessary while
> allocating space, and should work with even the smallest journal.
> This patch refers ext4 resize.
> 
> Test:
> # mkfs.ocfs2 -b 4K -C 32K -T datafiles /dev/sdc
> ...(jounral size is 32M)
> # mount.ocfs2 /dev/sdc /mnt/ocfs2/
> # touch /mnt/ocfs2/1.log
> # fallocate -o 0 -l 400G /mnt/ocfs2/1.log
> fallocate: /mnt/ocfs2/1.log: fallocate failed: Cannot allocate memory
> # tail -f /var/log/messages
> [ 7372.278591] JBD: fallocate wants too many credits (2051 > 2048)
> [ 7372.278597] (fallocate,6438,0):__ocfs2_extend_allocation:709 ERROR: status = -12
> [ 7372.278603] (fallocate,6438,0):ocfs2_allocate_unwritten_extents:1504 ERROR: status = -12
> [ 7372.278607] (fallocate,6438,0):__ocfs2_change_file_space:1955 ERROR: status = -12
> ^C
> 
> With this patch, the test works well.
> 
> Compared with V1, add trace point in ocfs2_allocate_extend_trans.
> 
> Signed-off-by: Younger Liu <younger.liu@huawei.com>
> Cc: Jie Liu <jeff.liu@oracle.com>
> ---
>  fs/ocfs2/file.c        |    6 +-----
>  fs/ocfs2/journal.c     |   36 ++++++++++++++++++++++++++++++++++++
>  fs/ocfs2/journal.h     |   11 +++++++++++
>  fs/ocfs2/ocfs2_trace.h |    2 ++
>  4 files changed, 50 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 05c0bb1..4943918 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -666,11 +666,7 @@ restarted_transaction:
>  		} else {
>  			BUG_ON(why != RESTART_TRANS);
>  
> -			/* TODO: This can be more intelligent. */
> -			credits = ocfs2_calc_extend_credits(osb->sb,
> -							    &fe->id2.i_list,
> -							    clusters_to_add);
> -			status = ocfs2_extend_trans(handle, credits);
> +			status = ocfs2_allocate_extend_trans(handle, 1);
>  			if (status < 0) {
>  				/* handle still has to be committed at
>  				 * this point. */
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 8eccfab..1d389fb 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -455,6 +455,42 @@ bail:
>  	return status;
>  }
>  
> +/*
> + * If we have fewer than thresh credits, extend by OCFS2_MAX_TRANS_DATA.
> + * If that fails, restart the transaction & regain write access for the
> + * buffer head which is used for metadata modifications.
> + * Taken from Ext4: extend_or_restart_transaction() 
> + */
> +int ocfs2_allocate_extend_trans(handle_t *handle, int thresh)
> +{
> +	int status, old_nblks;
> +
> +	BUG_ON(!handle);
> +	
> +	old_nblks = handle->h_buffer_credits;
> +	trace_ocfs2_allocate_extend_trans(old_nblks, thresh);
> +	
> +	if (old_nblks < thresh)
> +		return 0;
> +
> +	status = jbd2_journal_extend(handle, OCFS2_MAX_TRANS_DATA);
> +	if (status < 0) {
> +		mlog_errno(status);
> +		goto bail;
> +	}
> +
> +	if (status > 0) {
> +		status = jbd2_journal_restart(handle, OCFS2_MAX_TRANS_DATA);
> +		if (status < 0) {
> +			mlog_errno(status);
> +			goto bail;
> +		}

I guess you missed one comment in my previous review that is we can omit
the 'goto' statement as well as the curly braces around it.

BTW, I detected a number of trailing whitespace error when applying this
patch, please check it too.

That is all right, you don't need to post a revised version until get some
feedbacks from others.

Thanks,
-Jeff

> +	}
> +	
> +bail:
> +	return status;
> +}
> +
>  struct ocfs2_triggers {
>  	struct jbd2_buffer_trigger_type	ot_triggers;
>  	int				ot_offset;
> diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
> index a3385b6..62a26bd 100644
> --- a/fs/ocfs2/journal.h
> +++ b/fs/ocfs2/journal.h
> @@ -259,6 +259,17 @@ handle_t		    *ocfs2_start_trans(struct ocfs2_super *osb,
>  int			     ocfs2_commit_trans(struct ocfs2_super *osb,
>  						handle_t *handle);
>  int			     ocfs2_extend_trans(handle_t *handle, int nblocks);
> +int			     ocfs2_allocate_extend_trans(handle_t *handle,
> +						int thresh);
> +
> +/* 
> + * Define an arbitrary limit for the amount of data we will anticipate
> + * writing to any given transaction.  For unbounded transactions such as
> + * fallocate(2) we can write more than this, but we always
> + * start off at the maximum transaction size and grow the transaction
> + * optimistically as we go.
> + */
> +#define OCFS2_MAX_TRANS_DATA	64U
>  
>  /*
>   * Create access is for when we get a newly created buffer and we're
> diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
> index 3b481f4..1b60c62 100644
> --- a/fs/ocfs2/ocfs2_trace.h
> +++ b/fs/ocfs2/ocfs2_trace.h
> @@ -2579,6 +2579,8 @@ DEFINE_OCFS2_INT_INT_EVENT(ocfs2_extend_trans);
>  
>  DEFINE_OCFS2_INT_EVENT(ocfs2_extend_trans_restart);
>  
> +DEFINE_OCFS2_INT_INT_EVENT(ocfs2_allocate_extend_trans);
> +
>  DEFINE_OCFS2_ULL_ULL_UINT_UINT_EVENT(ocfs2_journal_access);
>  
>  DEFINE_OCFS2_ULL_EVENT(ocfs2_journal_dirty);
