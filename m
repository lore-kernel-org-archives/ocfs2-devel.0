From: sunnyZhang <sunny.s.zhang@oracle.com>
Date: Fri, 20 Sep 2019 10:07:43 +0800
Subject: [Ocfs2-devel] ocfs2: protect extent tree in the
	ocfs2_prepare_inode_for_write
In-Reply-To: <mailman.1.1568833204.19731.ocfs2-devel@oss.oracle.com>
References: <mailman.1.1568833204.19731.ocfs2-devel@oss.oracle.com>
Message-ID: <721400dc-5bf4-3cf1-0cbc-b23ab4bd0f12@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joseph,? Gang,

Can you help me to review these patchs?

Thanks


? 2019/9/19 ??3:00, ocfs2-devel-request at oss.oracle.com ??:
> Send Ocfs2-devel mailing list submissions to
> 	ocfs2-devel at oss.oracle.com
>
> To subscribe or unsubscribe via the World Wide Web, visit
> 	https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> or, via email, send a message with subject or body 'help' to
> 	ocfs2-devel-request at oss.oracle.com
>
> You can reach the person managing the list at
> 	ocfs2-devel-owner at oss.oracle.com
>
> When replying, please edit your Subject line so it is more specific
> than "Re: Contents of Ocfs2-devel digest..."
>
>
> Today's Topics:
>
>     1. [PATCH V2 2/2] ocfs2: remove unused function
>        ocfs2_prepare_inode_for_refcount (Shuning Zhang)
>     2. [PATCH V2 1/2] ocfs2: protect extent tree in the
>        ocfs2_prepare_inode_for_write (Shuning Zhang)
>     3. [PATCH V2 0/2] ocfs2: protect extent tree in the
>        ocfs2_prepare_inode_for_write (Shuning Zhang)
>
>
> ----------------------------------------------------------------------
>
> Message: 1
> Date: Wed, 18 Sep 2019 10:02:55 +0800
> From: Shuning Zhang <sunny.s.zhang@oracle.com>
> Subject: [Ocfs2-devel] [PATCH V2 2/2] ocfs2: remove unused function
> 	ocfs2_prepare_inode_for_refcount
> To: ocfs2-devel at oss.oracle.com
> Message-ID:
> 	<1568772175-2906-3-git-send-email-sunny.s.zhang@oracle.com>
>
> The function of ocfs2_prepare_inode_for_refcount is no longer
> being used. I remove this function.
>
> Signed-off-by: Shuning Zhang <sunny.s.zhang@oracle.com>
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
