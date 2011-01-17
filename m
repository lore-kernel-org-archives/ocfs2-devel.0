From: Tao Ma <tm@tao.ma>
Date: Mon, 17 Jan 2011 15:41:21 +0800
Subject: [Ocfs2-devel] [PATCH 9/9] Ocfs2: Handle refcounted extents when
 doing moving/defraging.
In-Reply-To: <1295248137-24363-1-git-send-email-tristan.ye@oracle.com>
References: <1295248137-24363-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <4D33F2A1.3040900@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 01/17/2011 03:08 PM, Tristan Ye wrote:
> Tao, any thoughts?
ok, so in general it looks good. some comments are inlined.
>
> Signed-off-by: Tristan Ye<tristan.ye@oracle.com>
> ---
>   fs/ocfs2/move_extents.c |  112 +++++++++++++++++++++++++++++++++++++++++-----
>   1 files changed, 99 insertions(+), 13 deletions(-)
>
> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> index dd5b995..c0f0ae8 100644
> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -319,20 +338,48 @@ out:
>   static int ocfs2_defrag_extent(struct ocfs2_move_extents_context *context,
>   			       u32 cpos, u32 phys_cpos, u32 len, int ext_flags)
>   {
> -	int ret, credits = 0;
> +	int ret, credits = 0, extra_blocks = 0;
>   	handle_t *handle;
>   	struct inode *inode = context->inode;
>   	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>   	struct inode *tl_inode = osb->osb_tl_inode;
> +	struct ocfs2_refcount_tree *ref_tree = NULL;
>   	u32 new_phys_cpos, new_len;
> +	u64 phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, phys_cpos);
> +
> +	if ((ext_flags&  OCFS2_EXT_REFCOUNTED)&&  len) {
So you do the check of 'len' here and we do have a chance of 'len = 0'?
if yes, mayber just something like
	if (!len)
		return 0;
should be put at the begining of the function.
> +
> +		BUG_ON(!(OCFS2_I(inode)->ip_dyn_features&
> +			 OCFS2_HAS_REFCOUNT_FL));
> +
> +		BUG_ON(!context->refcount_loc);
> +
> +		ret = ocfs2_lock_refcount_tree(osb, context->refcount_loc, 1,
> +					&ref_tree, NULL);
> +		if (ret) {
> +			mlog_errno(ret);
> +			return ret;
> +		}
> +		
> +		ret = ocfs2_prepare_refcount_change_for_del(inode,
> +							context->refcount_loc,
> +							phys_blkno,
> +							len,
> +							&credits,
> +							&extra_blocks);
> +		if (ret) {
> +			mlog_errno(ret);
> +			goto out;
> +		}
> +	}
>
>   	ret = ocfs2_lock_allocators_move_extents(inode,&context->et, len, 1,
>   						&context->meta_ac,
>   						&context->data_ac,
> -						 0,&credits);
> +						 extra_blocks,&credits);
So your lock_allocators_move_extents can handle the case of changing 0 
-> extra_blocks and not *reset* credits, right?
>   	if (ret) {
>   		mlog_errno(ret);
> -		return ret;
> +		goto out;
>   	}
>
>   	/*

Regards,
Tao
