From: Joseph Qi <jiangqi903@gmail.com>
Date: Thu, 14 Mar 2019 09:06:51 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix inode bh swapping mixup in
 ocfs2_reflink_inodes_lock
In-Reply-To: <20190312214910.GK20533@magnolia>
References: <20190312214910.GK20533@magnolia>
Message-ID: <8b40e9d3-bd05-5b54-4770-dcd46f669ff6@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Darrick J. Wong" <darrick.wong@oracle.com>, akpm@linux-foundation.org, ocfs2-devel@oss.oracle.com
Cc: linux-fsdevel@vger.kernel.org



On 19/3/13 05:49, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> ocfs2_reflink_inodes_lock can swap the inode1/inode2 variables so that
> we always grab cluster locks in order of increasing inode number.
> Unfortunately, we forget to swap the inode record buffer head pointers
> when we've done this, which leads to incorrect bookkeepping when we're
> trying to make the two inodes have the same refcount tree.
> 
> This has the effect of causing filesystem shutdowns if you're trying to
> reflink data from inode 100 into inode 97, where inode 100 already has a
> refcount tree attached and inode 97 doesn't.  The reflink code decides
> to copy the refcount tree pointer from 100 to 97, but uses inode 97's
> inode record to open the tree root (which it doesn't have) and blows up.
> This issue causes filesystem shutdowns and metadata corruption!
> 
> Fixes: 29ac8e856cb369 ("ocfs2: implement the VFS clone_range, copy_range, and dedupe_range features")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good to me.
Reviewed-by: Joseph Qi <jiangqi903@gmail.com>

> ---
>  fs/ocfs2/refcounttree.c |   42 ++++++++++++++++++++++++------------------
>  1 file changed, 24 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index a35259eebc56..1dc9a08e8bdc 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -4719,22 +4719,23 @@ loff_t ocfs2_reflink_remap_blocks(struct inode *s_inode,
>  
>  /* Lock an inode and grab a bh pointing to the inode. */
>  int ocfs2_reflink_inodes_lock(struct inode *s_inode,
> -			      struct buffer_head **bh1,
> +			      struct buffer_head **bh_s,
>  			      struct inode *t_inode,
> -			      struct buffer_head **bh2)
> +			      struct buffer_head **bh_t)
>  {
> -	struct inode *inode1;
> -	struct inode *inode2;
> +	struct inode *inode1 = s_inode;
> +	struct inode *inode2 = t_inode;
>  	struct ocfs2_inode_info *oi1;
>  	struct ocfs2_inode_info *oi2;
> +	struct buffer_head *bh1 = NULL;
> +	struct buffer_head *bh2 = NULL;
>  	bool same_inode = (s_inode == t_inode);
> +	bool need_swap = (inode1->i_ino > inode2->i_ino);
>  	int status;
>  
>  	/* First grab the VFS and rw locks. */
>  	lock_two_nondirectories(s_inode, t_inode);
> -	inode1 = s_inode;
> -	inode2 = t_inode;
> -	if (inode1->i_ino > inode2->i_ino)
> +	if (need_swap)
>  		swap(inode1, inode2);
>  
>  	status = ocfs2_rw_lock(inode1, 1);
> @@ -4757,17 +4758,13 @@ int ocfs2_reflink_inodes_lock(struct inode *s_inode,
>  	trace_ocfs2_double_lock((unsigned long long)oi1->ip_blkno,
>  				(unsigned long long)oi2->ip_blkno);
>  
> -	if (*bh1)
> -		*bh1 = NULL;
> -	if (*bh2)
> -		*bh2 = NULL;
> -
>  	/* We always want to lock the one with the lower lockid first. */
>  	if (oi1->ip_blkno > oi2->ip_blkno)
>  		mlog_errno(-ENOLCK);
>  
>  	/* lock id1 */
> -	status = ocfs2_inode_lock_nested(inode1, bh1, 1, OI_LS_REFLINK_TARGET);
> +	status = ocfs2_inode_lock_nested(inode1, &bh1, 1,
> +					 OI_LS_REFLINK_TARGET);
>  	if (status < 0) {
>  		if (status != -ENOENT)
>  			mlog_errno(status);
> @@ -4776,15 +4773,25 @@ int ocfs2_reflink_inodes_lock(struct inode *s_inode,
>  
>  	/* lock id2 */
>  	if (!same_inode) {
> -		status = ocfs2_inode_lock_nested(inode2, bh2, 1,
> +		status = ocfs2_inode_lock_nested(inode2, &bh2, 1,
>  						 OI_LS_REFLINK_TARGET);
>  		if (status < 0) {
>  			if (status != -ENOENT)
>  				mlog_errno(status);
>  			goto out_cl1;
>  		}
> -	} else
> -		*bh2 = *bh1;
> +	} else {
> +		bh2 = bh1;
> +	}
> +
> +	/*
> +	 * If we swapped inode order above, we have to swap the buffer heads
> +	 * before passing them back to the caller.
> +	 */
> +	if (need_swap)
> +		swap(bh1, bh2);
> +	*bh_s = bh1;
> +	*bh_t = bh2;
>  
>  	trace_ocfs2_double_lock_end(
>  			(unsigned long long)oi1->ip_blkno,
> @@ -4794,8 +4801,7 @@ int ocfs2_reflink_inodes_lock(struct inode *s_inode,
>  
>  out_cl1:
>  	ocfs2_inode_unlock(inode1, 1);
> -	brelse(*bh1);
> -	*bh1 = NULL;
> +	brelse(bh1);
>  out_rw2:
>  	ocfs2_rw_unlock(inode2, 1);
>  out_i2:
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
