From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Mon, 22 Aug 2016 11:59:12 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix start offset to
 ocfs2_zero_range_for_truncate()
In-Reply-To: <1470957147-14185-1-git-send-email-ashish.samant@oracle.com>
References: <1470957147-14185-1-git-send-email-ashish.samant@oracle.com>
Message-ID: <57BB4B80.3040901@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Good catch! Thank you for the fix

Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>

On 08/11/2016 04:12 PM, Ashish Samant wrote:
> If we do fallocate with punch hole option on a reflink, with start offset
> on a cluster boundary and end offset somewhere in another cluster, we
> dont COW the first cluster starting at the start offset. But in this
> case, we were wrongly passing this cluster to
> ocfs2_zero_range_for_truncate() to zero out.
>
> Fix this by skipping this cluster in such a scenario.
>
> Signed-off-by: Ashish Samant <ashish.samant@oracle.com>
> ---
>   fs/ocfs2/file.c | 34 ++++++++++++++++++++++++----------
>   1 file changed, 24 insertions(+), 10 deletions(-)
>
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 4a6e130..ab305aa 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1522,7 +1522,8 @@ static int ocfs2_zero_partial_clusters(struct inode *inode,
>   				       u64 start, u64 len)
>   {
>   	int ret = 0;
> -	u64 tmpend, end = start + len;
> +	u64 tmpend = 0;
> +	u64 end = start + len;
>   	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>   	unsigned int csize = osb->s_clustersize;
>   	handle_t *handle;
> @@ -1554,18 +1555,31 @@ static int ocfs2_zero_partial_clusters(struct inode *inode,
>   	}
>   
>   	/*
> -	 * We want to get the byte offset of the end of the 1st cluster.
> +	 * If start is on a cluster boundary and end is somewhere in another
> +	 * cluster, we have not COWed the cluster starting at start, unless
> +	 * end is also within the same cluster. So, in this case, we skip this
> +	 * first call to ocfs2_zero_range_for_truncate() truncate and move on
> +	 * to the next one.
>   	 */
> -	tmpend = (u64)osb->s_clustersize + (start & ~(osb->s_clustersize - 1));
> -	if (tmpend > end)
> -		tmpend = end;
> +	if ((start & (csize - 1)) != 0) {
> +		/*
> +		 * We want to get the byte offset of the end of the 1st
> +		 * cluster.
> +		 */
> +		tmpend = (u64)osb->s_clustersize +
> +			(start & ~(osb->s_clustersize - 1));
> +		if (tmpend > end)
> +			tmpend = end;
>   
> -	trace_ocfs2_zero_partial_clusters_range1((unsigned long long)start,
> -						 (unsigned long long)tmpend);
> +		trace_ocfs2_zero_partial_clusters_range1(
> +			(unsigned long long)start,
> +			(unsigned long long)tmpend);
>   
> -	ret = ocfs2_zero_range_for_truncate(inode, handle, start, tmpend);
> -	if (ret)
> -		mlog_errno(ret);
> +		ret = ocfs2_zero_range_for_truncate(inode, handle, start,
> +						    tmpend);
> +		if (ret)
> +			mlog_errno(ret);
> +	}
>   
>   	if (tmpend < end) {
>   		/*
