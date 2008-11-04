From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 3 Nov 2008 19:17:42 -0800
Subject: [Ocfs2-devel] [PATCH 03/15] ocfs2/xattr: Move clusters
	free	into dealloc.
In-Reply-To: <1225345335-11527-3-git-send-email-tao.ma@oracle.com>
References: <49099B13.9030802@oracle.com>
	<1225345335-11527-3-git-send-email-tao.ma@oracle.com>
Message-ID: <20081104031742.GD16483@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Oct 30, 2008 at 01:42:13PM +0800, Tao Ma wrote:
> Move clusters free process into dealloc context so that
> they can be freed after the transaction.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
>  fs/ocfs2/xattr.c |   14 +-------------
>  1 files changed, 1 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index dc90ffb..7605677 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -455,7 +455,6 @@ static int __ocfs2_remove_xattr_range(struct inode *inode,
>  	int ret;
>  	u64 phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, phys_cpos);
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> -	struct inode *tl_inode = osb->osb_tl_inode;
>  	handle_t *handle;
>  	struct ocfs2_alloc_context *meta_ac = NULL;
>  	struct ocfs2_extent_tree et;
> @@ -468,16 +467,6 @@ static int __ocfs2_remove_xattr_range(struct inode *inode,
>  		return ret;
>  	}
>  
> -	mutex_lock(&tl_inode->i_mutex);
> -
> -	if (ocfs2_truncate_log_needs_flush(osb)) {
> -		ret = __ocfs2_flush_truncate_log(osb);
> -		if (ret < 0) {
> -			mlog_errno(ret);
> -			goto out;
> -		}
> -	}
> -
>  	handle = ocfs2_start_trans(osb, OCFS2_REMOVE_EXTENT_CREDITS);
>  	if (IS_ERR(handle)) {
>  		ret = PTR_ERR(handle);
> @@ -507,14 +496,13 @@ static int __ocfs2_remove_xattr_range(struct inode *inode,
>  		goto out_commit;
>  	}
>  
> -	ret = ocfs2_truncate_log_append(osb, handle, phys_blkno, len);
> +	ret = ocfs2_cache_clusters_dealloc(dealloc, phys_blkno, len);

[Referring to the discussion of the previous patch]
	See, in the old code you called __ocfs2_remove_xattr_range()
once per extend, so the check for needs_flush() and the call to
log_append() were just like ocfs2_commit_truncate().  In the new code,
you move the handling into the dealloc context, but the actual mechanics
of deleting the clusters inside ocfs2_run_deallocs() need to be correct.
	This patch is fine, btw.

Joel

-- 

"All alone at the end of the evening
 When the bright lights have faded to blue.
 I was thinking about a woman who had loved me
 And I never knew"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
