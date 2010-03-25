From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 26 Mar 2010 07:36:56 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: __ocfs2_find_path() needs to
 treat hole correctly.
In-Reply-To: <1269506159-30981-1-git-send-email-tristan.ye@oracle.com>
References: <1269506159-30981-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <4BABF398.4040706@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Tristan Ye wrote:
> Currently, __ocfs2_find_path() was lack of a mechanism to detect
> a hole between two extent blocks if the cpos we want to search is
> within the hole, as a result, the last rec will be returned incorrectly.
>   
Do you mean extent block or extent rec? The extent block are contiguous 
and there should be no hole.
oh, here. We should never meet with this. So Nack.

Regards,
Tao
>   
> This patch attempts to detect a hole, and return the rightmost
> extent block preceding the hole.
>
> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
> ---
>  fs/ocfs2/alloc.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 9f8bd91..2638a18 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -1841,6 +1841,17 @@ static int __ocfs2_find_path(struct ocfs2_caching_info *ci,
>  				ocfs2_rec_clusters(el, rec);
>  			if (cpos >= le32_to_cpu(rec->e_cpos) && cpos < range)
>  			    break;
> +
> +			/*
> +			 * Return the rightmost extent block leftly adjacent
> +			 * to a hole if there is any between two extent blocks.
> +			 *
> +			 * Otherwise, we get the last rec of this block unexpectly.
> +			 */
> +			if (cpos < le32_to_cpu(rec->e_cpos)) {
> +				i--;
> +				break;
> +			}
>  		}
>  
>  		blkno = le64_to_cpu(el->l_recs[i].e_blkno);
>   
