From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Fri, 5 Jul 2019 09:14:39 +0800
Subject: [Ocfs2-devel] [PATCH v2 31/35] ocfs2: Use kmemdup rather than
 duplicating its implementation
In-Reply-To: <20190703163147.881-1-huangfq.daxian@gmail.com>
References: <20190703163147.881-1-huangfq.daxian@gmail.com>
Message-ID: <edc1407f-f45c-a6ce-e836-5e93947106bd@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Fuqian Huang <huangfq.daxian@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>



On 19/7/4 00:31, Fuqian Huang wrote:
> kmemdup is introduced to duplicate a region of memory in a neat way.
> Rather than kmalloc/kzalloc + memcpy, which the programmer needs to
> write the size twice (sometimes lead to mistakes), kmemdup improves
> readability, leads to smaller code and also reduce the chances of mistakes.
> Suggestion to use kmemdup rather than using kmalloc/kzalloc + memcpy.
> 
> Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> Changes in v2:
>   - Fix a typo in commit message (memset -> memcpy)
> 
>  fs/ocfs2/alloc.c      | 8 +++-----
>  fs/ocfs2/localalloc.c | 6 ++----
>  2 files changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index d1348fc4ca6d..d4911d70c326 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -6191,17 +6191,15 @@ int ocfs2_begin_truncate_log_recovery(struct ocfs2_super *osb,
>  	if (le16_to_cpu(tl->tl_used)) {
>  		trace_ocfs2_truncate_log_recovery_num(le16_to_cpu(tl->tl_used));
>  
> -		*tl_copy = kmalloc(tl_bh->b_size, GFP_KERNEL);
> +		/* Assuming the write-out below goes well, this copy
> +		 * will be passed back to recovery for processing. */
> +		*tl_copy = kmemdup(tl_bh->b_data, tl_bh->b_size, GFP_KERNEL);
>  		if (!(*tl_copy)) {
>  			status = -ENOMEM;
>  			mlog_errno(status);
>  			goto bail;
>  		}
>  
> -		/* Assuming the write-out below goes well, this copy
> -		 * will be passed back to recovery for processing. */
> -		memcpy(*tl_copy, tl_bh->b_data, tl_bh->b_size);
> -
>  		/* All we need to do to clear the truncate log is set
>  		 * tl_used. */
>  		tl->tl_used = 0;
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index f03674afbd30..158e5af767fd 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -424,12 +424,11 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb)
>  	bh = osb->local_alloc_bh;
>  	alloc = (struct ocfs2_dinode *) bh->b_data;
>  
> -	alloc_copy = kmalloc(bh->b_size, GFP_NOFS);
> +	alloc_copy = kmemdup(alloc, bh->b_size, GFP_NOFS);
>  	if (!alloc_copy) {
>  		status = -ENOMEM;
>  		goto out_commit;
>  	}
> -	memcpy(alloc_copy, alloc, bh->b_size);
>  
>  	status = ocfs2_journal_access_di(handle, INODE_CACHE(local_alloc_inode),
>  					 bh, OCFS2_JOURNAL_ACCESS_WRITE);
> @@ -1272,13 +1271,12 @@ static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb,
>  	 * local alloc shutdown won't try to double free main bitmap
>  	 * bits. Make a copy so the sync function knows which bits to
>  	 * free. */
> -	alloc_copy = kmalloc(osb->local_alloc_bh->b_size, GFP_NOFS);
> +	alloc_copy = kmemdup(alloc, osb->local_alloc_bh->b_size, GFP_NOFS);
>  	if (!alloc_copy) {
>  		status = -ENOMEM;
>  		mlog_errno(status);
>  		goto bail;
>  	}
> -	memcpy(alloc_copy, alloc, osb->local_alloc_bh->b_size);
>  
>  	status = ocfs2_journal_access_di(handle,
>  					 INODE_CACHE(local_alloc_inode),
> 
