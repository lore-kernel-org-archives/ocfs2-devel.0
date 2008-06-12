From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 12 Jun 2008 16:44:12 -0700
Subject: [Ocfs2-devel] [PATCH 6/8] Add extent tree operation for xattr
	value.v1
In-Reply-To: <20080605073437.GA19797@tma-pc2.cn.oracle.com>
References: <484792D1.3080802@oracle.com>
	<20080605073437.GA19797@tma-pc2.cn.oracle.com>
Message-ID: <20080612234412.GR28100@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jun 05, 2008 at 03:34:37PM +0800, Tao Ma wrote:
> @@ -4199,7 +4246,8 @@ int ocfs2_insert_extent(struct ocfs2_super *osb,
>  			u32 new_clusters,
>  			u8 flags,
>  			struct ocfs2_alloc_context *meta_ac,
> -			enum ocfs2_extent_tree_type et_type)
> +			enum ocfs2_extent_tree_type et_type,
> +			void *private)

Hmm, at this point, wouldn't it make sense to have a couple high-level
"ocfs2_foo_insert_extent" functions whcih build up anm ocfs2_extent_tree and
then pass it down to the common ocfs2_insert_extent?


> +static int ocfs2_xattr_value_truncate(struct inode *inode,
> +				      struct buffer_head *root_bh,
> +				      struct ocfs2_xattr_value_root *xv,
> +				      int len)
> +{
> +	int ret;
> +	u32 new_clusters = ocfs2_clusters_for_bytes(inode->i_sb, len);
> +	u32 old_clusters = le32_to_cpu(xv->xr_clusters);
> +
> +	if (new_clusters == old_clusters)
> +		return 0;
> +
> +	if (new_clusters > old_clusters)
> +		ret = ocfs2_xattr_extend_allocation(inode,
> +						    new_clusters - old_clusters,
> +						    root_bh, xv);
> +	else
> +		ret = ocfs2_xattr_shrink_size(inode,
> +					      old_clusters, new_clusters,
> +					      root_bh, xv);

If we shrink the xattr value, do you need to zero the area between the new
size and the end of the last cluster? We do it for inodes because a later
extend might expose the data which was trucated. But I think EA's don't have
that equivalent operation?
	--Mark

--
Mark Fasheh
