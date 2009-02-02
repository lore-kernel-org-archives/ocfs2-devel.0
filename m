From: Jan Kara <jack@suse.cz>
Date: Mon, 2 Feb 2009 11:05:24 +0100
Subject: [Ocfs2-devel] [PATCH 7/7] ocfs2: add quota call to
	ocfs2_remove_btree_range()
In-Reply-To: <1233351753-14640-8-git-send-email-mfasheh@suse.com>
References: <1233351753-14640-1-git-send-email-mfasheh@suse.com>
	<1233351753-14640-8-git-send-email-mfasheh@suse.com>
Message-ID: <20090202100524.GA7145@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri 30-01-09 13:42:33, Mark Fasheh wrote:
> We weren't reclaiming the clusters which get free'd from this function,
> so any user punching holes in a file would still have those bytes accounted
> against him/her. Add the call to vfs_dq_free_space_nodirty() to fix this.
> Interestingly enough, the journal credits calculation already took this into
> account.
> 
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Mark Fasheh <mfasheh@suse.com>
  Looks fine. Thanks for finding this.
Acked-by: Jan Kara <jack@suse.cz>

									Honza

> ---
>  fs/ocfs2/alloc.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index cf96a05..b20af53 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -5447,6 +5447,9 @@ int ocfs2_remove_btree_range(struct inode *inode,
>  		goto out;
>  	}
>  
> +	vfs_dq_free_space_nodirty(inode,
> +				  ocfs2_clusters_to_bytes(inode->i_sb, len));
> +
>  	ret = ocfs2_remove_extent(inode, et, cpos, len, handle, meta_ac,
>  				  dealloc);
>  	if (ret) {
> -- 
> 1.5.6
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
