From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 12 Jun 2008 19:39:27 -0700
Subject: [Ocfs2-devel] [PATCH 6/8] Add extent tree operation for xattr
	value.v1
In-Reply-To: <20080605073437.GA19797@tma-pc2.cn.oracle.com>
References: <484792D1.3080802@oracle.com>
	<20080605073437.GA19797@tma-pc2.cn.oracle.com>
Message-ID: <20080613023927.GU28100@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

> +static int ocfs2_xattr_shrink_size(struct inode *inode,
> +				   u32 old_clusters,
> +				   u32 new_clusters,
> +				   struct buffer_head *root_bh,
> +				   struct ocfs2_xattr_value_root *xv)
> +{
> +	int ret = 0;
> +	u32 trunc_len, cpos, phys_cpos, alloc_size;
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +	struct ocfs2_cached_dealloc_ctxt dealloc;
> +
> +	ocfs2_init_dealloc_ctxt(&dealloc);
> +
> +	if (old_clusters <= new_clusters)
> +		return 0;
> +
> +	cpos = new_clusters;
> +	trunc_len = old_clusters - new_clusters;
> +	while (trunc_len) {
> +		ret = ocfs2_xattr_get_clusters(inode, cpos, &phys_cpos,
> +					       &alloc_size, &xv->xr_list);
> +		if (ret) {
> +			mlog_errno(ret);
> +			goto out;
> +		}
> +
> +		if (alloc_size > trunc_len)
> +			alloc_size = trunc_len;
> +
> +		ret = __ocfs2_remove_xattr_range(inode, root_bh, xv, cpos,
> +						 phys_cpos, alloc_size,
> +						 &dealloc);
> +		if (ret) {
> +			mlog_errno(ret);
> +			goto out;
> +		}
> +
> +		cpos += alloc_size;
> +		trunc_len -= alloc_size;
> +	}
> +
> +out:
> +	ocfs2_schedule_truncate_log_flush(osb, 1);
> +	ocfs2_run_deallocs(osb, &dealloc);
> +
> +	return ret;
> +	return 0;
> +}

You have two 'return' statements here.
	--Mark

--
Mark Fasheh
