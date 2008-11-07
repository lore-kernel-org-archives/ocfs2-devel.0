From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 6 Nov 2008 17:02:02 -0800
Subject: [Ocfs2-devel] [PATCH 06/15] ocfs2: move new_inode out of the
	transaction
In-Reply-To: <1225366819-6286-1-git-send-email-tiger.yang@oracle.com>
References: <49099B13.9030802@oracle.com>
	<1225366819-6286-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <20081107010202.GF15154@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Oct 30, 2008 at 07:40:19PM +0800, Tiger Yang wrote:
> we need know the security xattr size before start transaction,
> so mov new_inode out of mknod_unlock and populate i_mode to
> get the exact security xattr size.
> 
> Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
> ---
>  fs/ocfs2/namei.c |   53 +++++++++++++++++++++++++++++++++--------------------
>  1 files changed, 33 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index f4967e6..dd4ee52 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -71,7 +71,7 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
>  			      struct buffer_head **new_fe_bh,
>  			      struct buffer_head *parent_fe_bh,
>  			      handle_t *handle,
> -			      struct inode **ret_inode,
> +			      struct inode *inode,
>  			      struct ocfs2_alloc_context *inode_ac);
>  
>  static int ocfs2_prepare_orphan_dir(struct ocfs2_super *osb,
> @@ -186,6 +186,21 @@ bail:
>  	return ret;
>  }
>  
> +static inline struct inode *ocfs2_make_init_inode(struct inode *dir, int mode)
> +{
> +	struct inode *inode;
> +
> +	/*
> +	 * move new_inode out of the transanction and populate i_mode
> +	 * to get exact security xattr size.
> +	 */
> +	inode = new_inode(dir->i_sb);
> +	if (!IS_ERR(inode))
> +		inode->i_mode = mode;
> +
> +	return inode;
> +}

Great, this is what I was hoping for. Check out this patch from Jan:

http://oss.oracle.com/pipermail/ocfs2-devel/2008-October/003266.html

(forward down to ocfs2_get_init_inode()).

Should we just copy that function in here and use that?


Btw, we probably want to do the minor changes to ocfs2_mknod_locked so that
it doesn't fill i_mode (and whatever fields) a second time.
	--Mark

--
Mark Fasheh
