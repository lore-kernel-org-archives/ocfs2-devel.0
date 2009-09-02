From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 02 Sep 2009 10:58:03 +0800
Subject: [Ocfs2-devel] [PATCH 14/14] ocfs2: Set inline xattr entries
	with ocfs2_xa_set()
In-Reply-To: <1251448563-12508-15-git-send-email-joel.becker@oracle.com>
References: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
	<1251448563-12508-15-git-send-email-joel.becker@oracle.com>
Message-ID: <4A9DDF3B.4090906@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker wrote:
> ocfs2_xattr_ibody_set() is the only remaining user of
> ocfs2_xattr_set_entry().  ocfs2_xattr_set_entry() actually does two
> things: it calls ocfs2_xa_set(), and it initializes the inline xattrs.
> Initializing the inline space really belongs in its own call.
> 
> We lift the initialization to ocfs2_xattr_ibody_init(), called from
> ocfs2_xattr_ibody_set() only when necessary.  Now
> ocfs2_xattr_ibody_set() can call ocfs2_xa_set() directly.
> ocfs2_xattr_set_entry() goes away.
> 
> Another nice fact is that ocfs2_init_dinode_xa_loc() can trust
> i_xattr_inline_size.
> 
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> ---
>  fs/ocfs2/xattr.c |  156 +++++++++++++++++++++++++-----------------------------
>  1 files changed, 72 insertions(+), 84 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 862c56d..d485932 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -2088,17 +2088,13 @@ static void ocfs2_init_dinode_xa_loc(struct ocfs2_xa_loc *loc,
>  {
>  	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
> @@ -2615,9 +2586,10 @@ static int ocfs2_xattr_ibody_set(struct inode *inode,
>  				 struct ocfs2_xattr_search *xs,
>  				 struct ocfs2_xattr_set_ctxt *ctxt)
>  {
> +	int ret;
>  	struct ocfs2_inode_info *oi = OCFS2_I(inode);
>  	struct ocfs2_dinode *di = (struct ocfs2_dinode *)xs->inode_bh->b_data;
> -	int ret;
> +	struct ocfs2_xa_loc loc;
>  
>  	if (inode->i_sb->s_blocksize == OCFS2_MIN_BLOCKSIZE)
>  		return -ENOSPC;
> @@ -2630,8 +2602,24 @@ static int ocfs2_xattr_ibody_set(struct inode *inode,
>  		}
>  	}
>  
> -	ret = ocfs2_xattr_set_entry(inode, xi, xs, ctxt,
> -				(OCFS2_INLINE_XATTR_FL | OCFS2_HAS_XATTR_FL));
> +	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL)) {
> +		ret = ocfs2_xattr_ibody_init(inode, xs->inode_bh, ctxt);
> +		if (ret) {
> +			mlog_errno(ret);
if ret == -ENOSPC, we don't need to print error message.
> +			goto out;
> +		}
> +	}

Regards,
Tao
