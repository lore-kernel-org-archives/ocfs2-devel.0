From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Fri, 20 Sep 2019 09:57:43 -0700
Subject: [Ocfs2-devel] [PATCH V2 2/2] ocfs2: remove unused function
 ocfs2_prepare_inode_for_refcount
In-Reply-To: <1568772175-2906-3-git-send-email-sunny.s.zhang@oracle.com>
References: <1568772175-2906-1-git-send-email-sunny.s.zhang@oracle.com>
	<1568772175-2906-3-git-send-email-sunny.s.zhang@oracle.com>
Message-ID: <8382d7f4-4643-f244-dbac-f5f4265c909e@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 9/17/19 7:02 PM, Shuning Zhang wrote:

> The function of ocfs2_prepare_inode_for_refcount is no longer
> being used. I remove this function.
>
> Signed-off-by: Shuning Zhang <sunny.s.zhang@oracle.com>
Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
>   fs/ocfs2/file.c | 27 ---------------------------
>   1 file changed, 27 deletions(-)
>
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index dff4ab2..dadc35a 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2092,33 +2092,6 @@ static int ocfs2_is_io_unaligned(struct inode *inode, size_t count, loff_t pos)
>   	return 0;
>   }
>   
> -static int ocfs2_prepare_inode_for_refcount(struct inode *inode,
> -					    struct file *file,
> -					    loff_t pos, size_t count,
> -					    int *meta_level)
> -{
> -	int ret;
> -	struct buffer_head *di_bh = NULL;
> -	u32 cpos = pos >> OCFS2_SB(inode->i_sb)->s_clustersize_bits;
> -	u32 clusters =
> -		ocfs2_clusters_for_bytes(inode->i_sb, pos + count) - cpos;
> -
> -	ret = ocfs2_inode_lock(inode, &di_bh, 1);
> -	if (ret) {
> -		mlog_errno(ret);
> -		goto out;
> -	}
> -
> -	*meta_level = 1;
> -
> -	ret = ocfs2_refcount_cow(inode, di_bh, cpos, clusters, UINT_MAX);
> -	if (ret)
> -		mlog_errno(ret);
> -out:
> -	brelse(di_bh);
> -	return ret;
> -}
> -
>   static int ocfs2_inode_lock_for_extent_tree(struct inode *inode,
>   					    struct buffer_head **di_bh,
>   					    int meta_level,
