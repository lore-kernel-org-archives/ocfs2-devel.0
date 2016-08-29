From: Eric Ren <zren@suse.com>
Date: Mon, 29 Aug 2016 13:39:18 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: Fix start offset to
 ocfs2_zero_range_for_truncate()
In-Reply-To: <1472252646-29618-1-git-send-email-ashish.samant@oracle.com>
References: <1472252646-29618-1-git-send-email-ashish.samant@oracle.com>
Message-ID: <bdd26542-cbe2-8879-6db0-fe576286b04d@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

Thanks for this fix. I'd like to reproduce this issue locally and test this patch,
could you elaborate the detailed steps of reproduction?

Thanks,
Eric

On 08/27/2016 07:04 AM, Ashish Samant wrote:
> If we punch a hole on a reflink such that following conditions are met:
>
> 1. start offset is on a cluster boundary
> 2. end offset is not on a cluster boundary
> 3. (end offset is somewhere in another extent) or
>     (hole range > MAX_CONTIG_BYTES(1MB)),
>
> we dont COW the first cluster starting at the start offset. But in this
> case, we were wrongly passing this cluster to
> ocfs2_zero_range_for_truncate() to zero out. This will modify the cluster
> in place and zero it in the source too.
>
> Fix this by skipping this cluster in such a scenario.
>
> Reported-by: Saar Maoz <saar.maoz@oracle.com>
> Signed-off-by: Ashish Samant <ashish.samant@oracle.com>
> Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
> ---
> v1->v2:
> -Changed the commit msg to include a better and generic description of
>   the problem, for all cluster sizes.
> -Added Reported-by and Reviewed-by tags.
>    
>   fs/ocfs2/file.c | 34 ++++++++++++++++++++++++----------
>   1 file changed, 24 insertions(+), 10 deletions(-)
>
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 4e7b0dc..0b055bf 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1506,7 +1506,8 @@ static int ocfs2_zero_partial_clusters(struct inode *inode,
>   				       u64 start, u64 len)
>   {
>   	int ret = 0;
> -	u64 tmpend, end = start + len;
> +	u64 tmpend = 0;
> +	u64 end = start + len;
>   	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>   	unsigned int csize = osb->s_clustersize;
>   	handle_t *handle;
> @@ -1538,18 +1539,31 @@ static int ocfs2_zero_partial_clusters(struct inode *inode,
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
