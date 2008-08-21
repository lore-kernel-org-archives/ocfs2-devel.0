From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 21 Aug 2008 15:10:59 -0700
Subject: [Ocfs2-devel] [PATCH 03/10] ocfs2: Make ocfs2_extent_tree
	get/put instead of alloc.
In-Reply-To: <1219286905-28104-4-git-send-email-joel.becker@oracle.com>
References: <1219286905-28104-1-git-send-email-joel.becker@oracle.com>
	<1219286905-28104-4-git-send-email-joel.becker@oracle.com>
Message-ID: <20080821221059.GQ4563@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 20, 2008 at 07:48:18PM -0700, Joel Becker wrote:
> Rather than allocating a struct ocfs2_extent_tree, just put it on the
> stack.  Fill it with ocfs2_get_extent_tree() and drop it with
> ocfs2_put_extent_tree().  Now the callers don't have to ENOMEM, yet
> still safely ref the root_bh.
> 
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> ---
>  fs/ocfs2/alloc.c |  117 ++++++++++++++++-------------------------------------
>  1 files changed, 36 insertions(+), 81 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index ab16b89..0abf11e 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -223,22 +223,17 @@ static struct ocfs2_extent_tree_operations ocfs2_xattr_tree_et_ops = {
>  	.eo_sanity_check	= ocfs2_xattr_tree_sanity_check,
>  };
>  
> -static struct ocfs2_extent_tree*
> -	 ocfs2_new_extent_tree(struct inode *inode,
> -			       struct buffer_head *bh,
> -			       enum ocfs2_extent_tree_type et_type,
> -			       void *private)
> +static void ocfs2_get_extent_tree(struct ocfs2_extent_tree *et,
> +				  struct inode *inode,
> +				  struct buffer_head *bh,
> +				  enum ocfs2_extent_tree_type et_type,
> +				  void *private)

Actually, maybe "ocfs2_init_extent_tree()" would be more straightforward.
I'm fine with this too though.


>  {
> -	struct ocfs2_extent_tree *et;
> -
> -	et = kzalloc(sizeof(*et), GFP_NOFS);
> -	if (!et)
> -		return NULL;
> -

>  	et->et_type = et_type;
>  	get_bh(bh);
>  	et->et_root_bh = bh;
>  	et->et_private = private;
> +	et->et_max_leaf_clusters = 0;
>  
>  	if (et_type == OCFS2_DINODE_EXTENT) {
>  		et->et_root_el =
> @@ -257,16 +252,11 @@ static struct ocfs2_extent_tree*
>  		et->et_max_leaf_clusters = ocfs2_clusters_for_bytes(inode->i_sb,
>  						OCFS2_MAX_XATTR_TREE_LEAF_SIZE);
>  	}

Can you add a check, down here probably, that we got an 'et_type' value
passed in which is valid? If not, then we might continue with on-the-stack
versions of et_root_el, etc. This won't fail as nice as the kzalloc would
have before.

Btw, I'm going by the source I have in my tree, where there's no default
action other than allowing them to be null via kzalloc.
	--Mark

--
Mark Fasheh
