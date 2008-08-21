From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 20 Aug 2008 17:57:37 -0700
Subject: [Ocfs2-devel] [PATCH 07/16] Add extent tree operation for	xattr
	value.
In-Reply-To: <1219052334-10415-7-git-send-email-tao.ma@oracle.com>
References: <48A929A4.90103@oracle.com>
	<1219052334-10415-7-git-send-email-tao.ma@oracle.com>
Message-ID: <20080821005737.GB28632@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Aug 18, 2008 at 05:38:48PM +0800, Tao Ma wrote:
> Add some thin wrappers around ocfs2_insert_extent.
> 3 functions ocfs2_inode_insert_extent, ocfs2_xattr_value_insert_extent and
> ocfs2_xattr_tree_insert_extent(for xattr index btree, and it will show up
> in the last patch). All the old callers in file.c etc will call
> ocfs2_dinode_insert_extent, while the other two handle the xattr issue.
> And the init of extent tree are handled by these functions.

<snip>

	I see in this patch that ocfs2_*_insert_extent() become wrappers
around the now-static ocfs2_insert_extent().  That makes me wonder the
following:

> +static int ocfs2_insert_extent(struct ocfs2_super *osb,
> +			       handle_t *handle,
> +			       struct inode *inode,
> +			       struct buffer_head *root_bh,
> +			       u32 cpos,
> +			       u64 start_blk,
> +			       u32 new_clusters,
> +			       u8 flags,
> +			       struct ocfs2_alloc_context *meta_ac,
> +			       struct ocfs2_extent_tree *et)
>  {
>  	int status;
>  	int uninitialized_var(free_records);
>  	struct buffer_head *last_eb_bh = NULL;
>  	struct ocfs2_insert_type insert = {0, };
>  	struct ocfs2_extent_rec rec;
> -	struct ocfs2_extent_tree *et = NULL;
>  
>  	BUG_ON(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL);

	Can't an inline data inode have non-inline xattrs?  Won't this
BUG when growing that xattr extent tree?
	Next, a few lines down:

        mlog_bug_on_msg(!ocfs2_sparse_alloc(osb) &&
                        (OCFS2_I(inode)->ip_clusters != cpos),
                        "Device %s, asking for sparse allocation: inode %llu, "
                        "cpos %u, clusters %u\n",
                        osb->dev_str,
                        (unsigned long long)OCFS2_I(inode)->ip_blkno, cpos,
                        OCFS2_I(inode)->ip_clusters);

Won't that BUG() when cpos of an xattr extent is not matching the
ip_clusters of the data?

Joel

-- 

"You look in her eyes, the music begins to play.
 Hopeless romantics, here we go again."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
