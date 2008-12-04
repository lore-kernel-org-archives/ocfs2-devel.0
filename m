From: Tiger Yang <tiger.yang@oracle.com>
Date: Thu, 04 Dec 2008 13:31:45 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: recover transaction credits
 after extend it in xattr_set
In-Reply-To: <1227779987-14553-1-git-send-email-tiger.yang@oracle.com>
References: <1227779987-14553-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <49376B41.1010301@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark,
forget about this patch. Tao and I will find out an other solution to 
solve this problem.

thanks,
tiger

Tiger Yang wrote:
> ocfs2_extend_trans may commit old credits and start with new credits.
> In normal xattr set porcess, we don't worry about this, because we have
> already dirtied all the old journal before extend_trans.
> During mknod process, we may set two acl entries and one security entry
> in same transaction, then we may call journal_dirty many times.
> So the credits must be recoverd after extend_trans in that case.
> 
> Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
> ---
>  fs/ocfs2/xattr.c |   14 ++++++++++----
>  1 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 7e0d62a..5262dd5 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -1138,7 +1138,7 @@ static int __ocfs2_xattr_set_value_outside(struct inode *inode,
>  					   const void *value,
>  					   int value_len)
>  {
> -	int ret = 0, i, cp_len, credits;
> +	int ret = 0, i, cp_len, credits, old_credits;
>  	u16 blocksize = inode->i_sb->s_blocksize;
>  	u32 p_cluster, num_clusters;
>  	u32 cpos = 0, bpc = ocfs2_clusters_to_blocks(inode->i_sb, 1);
> @@ -1149,11 +1149,11 @@ static int __ocfs2_xattr_set_value_outside(struct inode *inode,
>  	BUG_ON(clusters > le32_to_cpu(xv->xr_clusters));
>  
>  	/*
> -	 * In __ocfs2_xattr_set_value_outside has already been dirtied,
> -	 * so we don't need to worry about whether ocfs2_extend_trans
> -	 * will create a new transactio for us or not.
> +	 * Because ocfs2_extend_trans may commit old credits and start with
> +	 * new credits, we need recover the old credits in that case.
>  	 */
>  	credits = clusters * bpc;
> +	old_credits = handle->h_buffer_credits;
>  	ret = ocfs2_extend_trans(handle, credits);
>  	if (ret) {
>  		mlog_errno(ret);
> @@ -1211,6 +1211,12 @@ static int __ocfs2_xattr_set_value_outside(struct inode *inode,
>  		}
>  		cpos += num_clusters;
>  	}
> +
> +	if (handle->h_buffer_credits < old_credits) {
> +		ret = ocfs2_extend_trans(handle, old_credits);
> +		if (ret)
> +			mlog_errno(ret);
> +	}
>  out:
>  	brelse(bh);
>  
