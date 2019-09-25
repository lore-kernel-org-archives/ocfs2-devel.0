From: Gang He <GHe@suse.com>
Date: Wed, 25 Sep 2019 10:34:01 +0000
Subject: [Ocfs2-devel] [PATCH V2 2/2] ocfs2: remove unused
	function	ocfs2_prepare_inode_for_refcount
In-Reply-To: <1568772175-2906-3-git-send-email-sunny.s.zhang@oracle.com>
References: <1568772175-2906-1-git-send-email-sunny.s.zhang@oracle.com>
	<1568772175-2906-3-git-send-email-sunny.s.zhang@oracle.com>
Message-ID: <CH2PR18MB320637FC2123733FB31F062CCF870@CH2PR18MB3206.namprd18.prod.outlook.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



> -----Original Message-----
> From: ocfs2-devel-bounces at oss.oracle.com
> [mailto:ocfs2-devel-bounces at oss.oracle.com] On Behalf Of Shuning Zhang
> Sent: 2019?9?18? 10:03
> To: ocfs2-devel at oss.oracle.com
> Subject: [Ocfs2-devel] [PATCH V2 2/2] ocfs2: remove unused function
> ocfs2_prepare_inode_for_refcount
> 
> The function of ocfs2_prepare_inode_for_refcount is no longer being used. I
> remove this function.
> 
> Signed-off-by: Shuning Zhang <sunny.s.zhang@oracle.com>

Reviewed-by: Gang He <ghe@suse.com>

> ---
>  fs/ocfs2/file.c | 27 ---------------------------
>  1 file changed, 27 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c index dff4ab2..dadc35a 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2092,33 +2092,6 @@ static int ocfs2_is_io_unaligned(struct inode
> *inode, size_t count, loff_t pos)
>  	return 0;
>  }
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
>  static int ocfs2_inode_lock_for_extent_tree(struct inode *inode,
>  					    struct buffer_head **di_bh,
>  					    int meta_level,
> --
> 2.7.4
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
