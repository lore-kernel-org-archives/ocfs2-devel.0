From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 09 Apr 2010 17:22:01 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2: Optimize punching-hole codes
 v5.
In-Reply-To: <1270802647-17191-2-git-send-email-tristan.ye@oracle.com>
References: <1270802647-17191-1-git-send-email-tristan.ye@oracle.com>
	<1270802647-17191-2-git-send-email-tristan.ye@oracle.com>
Message-ID: <4BBEF1B9.6090105@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Tristan,

Tristan Ye wrote:
> V5 patch simplifies the logic of handling existing holes and procedures
> for skipping extent blocks, and removed most of confusing comments.
> 
> V5 patch has survived with fill_verify_holes testcase in ocfs2-test,
> it also passed my manual sanity check and stress tests with enormous
> extent records.
> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
> ---
>  fs/ocfs2/file.c |  173 +++++++++++++++++++++++++++++++++++++++++++++++--------
>  1 files changed, 148 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index db2e0c9..907653e 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1423,18 +1423,97 @@ out:
>  	return ret;
>  }
>  
> +static int ocfs2_find_rec(struct ocfs2_extent_list *el,
> +			  u32 pos,
> +			  int include_pos)
Why you need this 'include_pos'? btw, there is only one caller with 
include_pos = 0, so why not remove it? ;)
> +{
> +	int i;
> +	struct ocfs2_extent_rec *rec = NULL;
> +
> +	for (i = le16_to_cpu(el->l_next_free_rec) - 1; i >= 0; i--) {
> +
> +		rec = &el->l_recs[i];
> +
> +		if (include_pos) {
> +			if (le32_to_cpu(rec->e_cpos) <= pos)
> +				break;
> +		} else {
> +			if (le32_to_cpu(rec->e_cpos) < pos)
> +				break;
> +		}
> +	}
> +
> +	return i;
> +}
> +
> +/*
> + * Helper to calculate the punching pos and length in one run, we handle the
> + * following three cases in order:
> + *
> + * - remove the entire record
> + * - remove a partial record
> + * - no record needs to be removed (hole-punching completed)
> +*/
> +static void ocfs2_calc_trunc_pos(struct inode *inode,
> +				 struct ocfs2_extent_list *el,
> +				 struct ocfs2_extent_rec *rec,
> +				 u32 trunc_start, u32 *trunc_cpos,
> +				 u32 *trunc_len, u32 *trunc_end,
> +				 u64 *blkno, int *done)
> +{
> +	int ret = 0;
> +	u32 coff, range;
> +
> +	range = le32_to_cpu(rec->e_cpos) + ocfs2_rec_clusters(el, rec);
> +
> +	if (le32_to_cpu(rec->e_cpos) >= trunc_start) {
> +		*trunc_cpos = le32_to_cpu(rec->e_cpos);
> +		/*
> +		 * Skip holes if any.
> +		 */
> +		if (range < *trunc_end)
> +			*trunc_end = range;
> +		*trunc_len = *trunc_end - le32_to_cpu(rec->e_cpos);
> +		*blkno = le64_to_cpu(rec->e_blkno);
> +		*trunc_end = le32_to_cpu(rec->e_cpos);
> +	} else if (range > trunc_start) {
> +		*trunc_cpos = trunc_start;
> +		*trunc_len = range - trunc_start;
I guess there should be a bug? what if the old trunc_end < range?
then *trunc_len should be min(range, *trunc_end) - trunc_start?
> +		coff = trunc_start - le32_to_cpu(rec->e_cpos);
> +		*blkno = le64_to_cpu(rec->e_blkno) +
> +				ocfs2_clusters_to_blocks(inode->i_sb, coff);
> +		*trunc_end = trunc_start;
> +	} else {
> +		/*
> +		 * It may have two following possibilities:
> +		 *
> +		 * - last record has been removed
> +		 * - trunc_start was within a hole
> +		 *
> +		 * both two cases mean the completion of hole punching.
> +		 */
> +		ret = 1;
> +	}
> +
> +	*done = ret;
> +}
> +
Regards,
Tao
