From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 30 Dec 2015 09:47:45 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Do not lock/unlock() inode DLM lock
In-Reply-To: <1451413209-26406-1-git-send-email-rgoldwyn@suse.de>
References: <1451413209-26406-1-git-send-email-rgoldwyn@suse.de>
Message-ID: <568337C1.2000209@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 12/30/2015 02:20 AM, rgoldwyn at suse.de wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> DLM does not cache locks. So, blocking lock and unlock
> will only make the performance worse where contention over
> the locks is high.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Looks good.

Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
>  fs/ocfs2/dlmglue.c | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 20276e3..f92612e 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -2432,12 +2432,6 @@ bail:
>   * done this we have to return AOP_TRUNCATED_PAGE so the aop method
>   * that called us can bubble that back up into the VFS who will then
>   * immediately retry the aop call.
> - *
> - * We do a blocking lock and immediate unlock before returning, though, so that
> - * the lock has a great chance of being cached on this node by the time the VFS
> - * calls back to retry the aop.    This has a potential to livelock as nodes
> - * ping locks back and forth, but that's a risk we're willing to take to avoid
> - * the lock inversion simply.
>   */
>  int ocfs2_inode_lock_with_page(struct inode *inode,
>  			      struct buffer_head **ret_bh,
> @@ -2449,8 +2443,6 @@ int ocfs2_inode_lock_with_page(struct inode *inode,
>  	ret = ocfs2_inode_lock_full(inode, ret_bh, ex, OCFS2_LOCK_NONBLOCK);
>  	if (ret == -EAGAIN) {
>  		unlock_page(page);
> -		if (ocfs2_inode_lock(inode, ret_bh, ex) == 0)
> -			ocfs2_inode_unlock(inode, ex);
>  		ret = AOP_TRUNCATED_PAGE;
>  	}
>  
> 
